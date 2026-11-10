&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0302 2.00.00.013 } /*** "010013" 16/09/2024 11:31:24 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302 MAO}
&ENDIF


/********************************************************************************
** Copyright DATasUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATasUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AO0302
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              btImprimir btRedimensiona brDetalhe btModifica btCancela btLegenda  ~
                              btConfirma fiResultado-txt fiResultado-num fiResultado-dat cbResultado btExcel btTXT btGoto btCarga btAprova


/* Local Variable Definitions ---                                       */
define variable c-arquivo     as character                no-undo.
define variable rRowidBusca   as rowid                    no-undo.
/** Busca Valor **/
define variable rRowid        as rowid                    no-undo.
define variable cCodPai       as character format "x(20)" no-undo.
define variable vCodigo       as character format "x(20)" no-undo.
define variable vDescricao    as character format "x(32)" no-undo.
define variable iImage        as integer                  no-undo.
define variable cTag          as character                no-undo.
define variable cCCCodigo     as character                no-undo.
DEFINE VARIABLE cUnidNegoc    AS CHARACTER                NO-UNDO.
define variable iRowIni       as decimal                  no-undo.
define variable rRow          as rowid                    no-undo.
/** Controles **/
define variable l-expande     as logical init no          no-undo.
define variable l-ok          as logical                  no-undo.
define variable c-tag-tree    as character                no-undo.
define variable i-cont        as integer                  no-undo.
define variable iVisao        as integer                  no-undo.
define variable i-button-tree as integer   initial 1      no-undo.
define variable cCodArmaz     as character format "x(22)" no-undo.
define variable cCodPaiReg    as character format "x(22)" no-undo.
define variable rRowidPai     as rowid                    no-undo.
define variable cTexto        as character format "x(22)" no-undo.
define variable lLabel        as logical   initial no     no-undo.
define variable cDocto        as char                     no-undo.
define variable iAmostra      as int                      no-undo.
define variable cNunControl   like mao-amostra-oleo.cod-amostra-fisic no-undo.
define variable i-image        as integer                  no-undo.   
define variable iEstadoAmostra as integer                  no-undo.
define variable c-liter        as character format "X(25)" no-undo.
define variable d-data-ult-amostra    as date              no-undo.
define variable d-data-penult-amostra as date              no-undo.
def var num-ult-amostra-oleo    like mao-amostra-oleo.num-amostra-oleo no-undo.
def var num-penult-amostra-oleo like mao-amostra-oleo.num-amostra-oleo no-undo.

/** Pop-Menu **/
define variable pop-menu      as widget-handle            no-undo.
define variable exp-con       as widget-handle            no-undo.
define variable detalhe       as widget-handle            no-undo.
define variable regua         as widget-handle            no-undo.
/*** Window ***/
define variable dWinXC        as decimal                  no-undo.
define variable dWinYC        as decimal                  no-undo.
define variable drowbtDetalhe as decimal                  no-undo.
define variable drowbtCarga   as decimal                  no-undo.
define variable drowbtAprova  as decimal                  no-undo.

/*** Busca no V† Para ***/
define variable pNunAmostra    like mao-amostra-oleo.cod-amostra-fisic no-undo.
define variable rRowid3        as rowid                                no-undo.
/** Excel **/
define variable i-lin          as integer                  no-undo.
define variable i-lin2         as integer                  no-undo.
define variable i-col          as integer                  no-undo.
define variable i-impressao    as integer                  no-undo.
define variable hHandle        as handle                   no-undo.
define variable hHandle2       as handle                   no-undo.
define variable c-colunas      as character                no-undo.
/** TXT **/
define variable cCaminho       as character format "x(300)" no-undo. /*Indica o caminho */
define variable cDelimitador   as character format "x(01)"  no-undo. /*Indica o tipo de delimitador */
define variable lCabecalho     as logical   initial no      no-undo. /*Indica se gera cabeáalho */
define variable cTituloTxt     as character format "x(256)" no-undo.
define variable cDescPai       as character format "x(256)" no-undo.
/**** Descriá‰es ****/
DEFINE VARIABLE cDescStatus as character format "x(22)"     no-undo.
DEFINE VARIABLE cDescStatusAmostra as character format "x(22)" no-undo.
DEFINE VARIABLE cDescResult as character format "x(22)"     no-undo.
DEFINE VARIABLE cDescLog    as character format "x(5)"      no-undo.
DEFINE VARIABLE c-lista     as character format "x(100)"    no-undo.

/**** Variaveis para Exportaá∆o - ab0303.w ****/
DEFINE VARIABLE cValorParam   like mab-param.des-valor        no-undo.
DEFINE VARIABLE iEpCodigo     like mab-eqpto.ep-codigo        no-undo.
DEFINE VARIABLE cCodEqpto     like mab-eqpto.cod-eqpto        no-undo.
DEFINE VARIABLE cCodSubSist   like mab-sub-sist.cod-sub-sist  no-undo.
DEFINE VARIABLE cCodEvento    like mab-event.cod-evento       no-undo.
DEFINE VARIABLE cObs          like mao-ensaio-padr.dsl-obs-nao-troca no-undo.
DEFINE VARIABLE iNumEvent     like mao-amostra-oleo.num-docto-event  no-undo.
DEFINE VARIABLE cValorParam-2 as integer initial 0  no-undo.
/********* BOs*******************************/
DEFINE VARIABLE hDBOAmostra as HANDLE     no-undo.
DEFINE VARIABLE cReturnAux as character  no-undo.
DEFINE VARIABLE hDBOResult as HANDLE     no-undo.
/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.

def temp-table tt-Result no-undo like mao-restdo-ensaio
    field r-rowid as rowid.
{aop/ao0302.i3 ttDados} /** Definiá∆o da ttDados **/

define buffer bfttDados  for ttDados.
define buffer bfttDados2 for ttDados.  
define buffer bfttDados3 for ttDados.  
define buffer bfmao-amostra-oleo  for mao-amostra-oleo.
define buffer bfmao-restdo-ensaio for mao-restdo-ensaio.
def temp-table ttDadosAux   no-undo like ttDados.  
def temp-table ttAmostraAux no-undo like mao-amostra-oleo
    field r-rowid as rowid. 
{aop/ao0302.i}  /** Definiá∆o da temp-table de parÉmetros **/

DEF VAR i-num-amostra-oleo LIKE ttDados.num-amostra-oleo no-undo.

/**Temp-table para dados do Excell**/
define temp-table tt-dados-ex no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    field celula-coluna                 as integer format ">>>>9"
    field celula-linha                  as integer format ">>>>9"
    field celula-cor-interior           as integer format ">9"     initial 58 /* None */
    field celula-formato                as char    format "x(255)"
    field celula-formula                as char    format "x(255)"
    field celula-alinhamento-horizontal as integer format "9"      initial 4 /* Left */
    field celula-alinhamento-vertical   as integer format "9"      initial 1 /* Bottom */
    field celula-valor                  as char    format "x(255)"
    field celula-fonte-nome             as char    format "x(255)" initial "Times New Roman"
    field celula-fonte-tamanho          as integer format ">9"     initial 10
    field celula-fonte-negrito          as logical                 initial no
    field celula-fonte-italico          as logical                 initial no
    field celula-fonte-sublinhado       as integer format "9"      initial 3 /* None */
    field celula-fonte-cor              as integer format ">9"     initial 57 /* Automatic */
    field celula-tipo-borda-sup         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-inf         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-esq         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-dir         as integer format "9"      initial 7 /* None */
    index tt-dados-pri is unique primary
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha.

{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
DEF TEMP-TABLE tt_ccusto_integr NO-UNDO 
    FIELD ttv_cod_empresa      AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa"
    FIELD ttv_cod_plano_ccusto AS CHARACTER FORMAT "x(8)" LABEL "Plano CCusto" COLUMN-LABEL "Plano CCusto"
    FIELD ttv_cod_ccusto       AS CHARACTER FORMAT "x(20)" LABEL "Centro Custo" COLUMN-LABEL "Centro Custo"
    FIELD ttv_des_titulo       AS CHARACTER FORMAT "x(40)"
    INDEX tt_id                           
          ttv_cod_empresa                  ASCENDING 
          ttv_cod_plano_ccusto             ASCENDING
          ttv_cod_ccusto                   ASCENDING.

/* Eventos treeview */
{utp/ut-4gltreeview.i}

DEFINE  VARIABLE    n-4gltreeview-row       AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-column    AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-height    AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-width     AS  DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDetalhe

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttDados

/* Definitions for BROWSE brDetalhe                                     */
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttDados.cod-oficial ttDados.cod-ensaio ttDados.desc-dimensao fnStatus(ttDados.idi-estado-ensaio) @ cDescStatus fnStatusAmostra(ttDados.cod-oficial) @ cDescStatusAmostra fnLog(ttDados.log-padrao) @ cDescLog ttDados.des-val-restdo ttDados.des-val-min ttDados.des-val-max ttDados.num-tabela fnBrowse("dat-result":U,2) @ ttDados.dat-result fnBrowse("dat-result-ant":U,2) @ ttDados.dat-result-ant fnResultado(ttDados.idi-tip-restdo) @ cDescResult   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalhe   
&Scoped-define SELF-NAME brDetalhe
&Scoped-define QUERY-STRING-brDetalhe for each ttDados no-lock use-index docto
&Scoped-define OPEN-QUERY-brDetalhe open query {&SELF-NAME} for each ttDados no-lock use-index docto.
&Scoped-define TABLES-IN-QUERY-brDetalhe ttDados
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalhe ttDados


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDetalhe}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btDetalhe RECT-27 rtToolBar-2 rtToolBar-3 ~
rtToolBar-4 btAbrir btSalvar btRefresh btExpande btParam btFiltro btVisao ~
btExcel btTxt btImprimir btQueryJoins btReportsJoins btExit btHelp btAprova ~
btRedimensiona brDetalhe btLegenda btModifica btCancela btConfirma ~
fiResultado-dat fiResultado-num btCarga btGoTo fiResultado-txt cbResultado ~
fiTexto-2 fiTexto-1 fiTexto-3 fiTexto-4 fiTexto-5 fiTexto-6 fiTexto-8 ~
fiTexto-7 fiTexto-9 fiTexto10 
&Scoped-Define DISPLAYED-OBJECTS fiResultado-dat fiResultado-num ~
fiResultado-txt cbResultado fiTexto-2 fiTexto-1 fiData fiHora fiAmostra ~
fiTexto-3 fiEmpresa fiEquipamento fiDescEqpto fiTexto-4 fiCompto ~
fiDescCompto fiTexto-5 fiTpMater fiDescMatl fiTexto-6 fiData-2 fiTexto-8 ~
fiQtde fiTexto-7 fiLubrific fiDescLubrific fiTexto-9 fiStatus fiTexto10 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fiData fiHora fiAmostra fiEmpresa fiEquipamento ~
fiDescEqpto fiCompto fiDescCompto fiTpMater fiDescMatl fiData-2 fiQtde ~
fiLubrific fiDescLubrific fiStatus 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBrowse wWindow 
FUNCTION fnBrowse RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnImages wWindow 
FUNCTION fnImages RETURNS CHARACTER
  ( pImage AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLog wWindow 
FUNCTION fnLog RETURNS CHARACTER
  ( pLog as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnResultado wWindow 
FUNCTION fnResultado RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus wWindow 
FUNCTION fnStatus RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatusAmostra wWindow 
FUNCTION fnStatusAmostra RETURNS CHARACTER
  ( pCodOficial as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU miArquivo 
       MENU-ITEM miAbrir        LABEL "&Abrir"         ACCELERATOR "CTRL-A"
       MENU-ITEM miSalvar       LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       MENU-ITEM miAtualizar    LABEL "At&ualizar"     ACCELERATOR "CTRL-R"
       MENU-ITEM miExpande      LABEL "&Expande/Contrai" ACCELERATOR "CTRL-E"
       MENU-ITEM m_V_Para       LABEL "&V† Para"       ACCELERATOR "CTRL-G"
       RULE
       MENU-ITEM miSelecao      LABEL "Se&leá∆o"       ACCELERATOR "CTRL-P"
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM miClassifica   LABEL "&Classifica"    ACCELERATOR "CTRL-C"
       RULE
       MENU-ITEM miExcel        LABEL "E&xcel"         ACCELERATOR "CTRL-N"
       MENU-ITEM miTxt          LABEL "&Texto"         ACCELERATOR "CTRL-T"
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-J"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  miArquivo      LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAbrir 
     IMAGE-UP FILE "image/im-open":U
     IMAGE-INSENSITIVE FILE "image/ii-open":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Abrir"
     FONT 4.

DEFINE BUTTON btAprova 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Aprovaá∆o dos Ensaios"
     FONT 4.

DEFINE BUTTON btCancela 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "&Encerrar" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON btCarga 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizaá∆o dos Resultados".

DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirmar"
     FONT 4.

DEFINE BUTTON btDetalhe 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Amostra".

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel":U
     LABEL "Planilha" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar para Excel".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExpande 
     IMAGE-UP FILE "image/im-crit":U
     IMAGE-INSENSITIVE FILE "image/ii-crit":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Expande / Contrai"
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil":U
     IMAGE-INSENSITIVE FILE "image/ii-fil":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U NO-FOCUS
     LABEL "Go To" 
     SIZE 4 BY 1.25 TOOLTIP "V† Para".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btLegenda 
     IMAGE-UP FILE "image/im-abc.bmp":U
     LABEL "&Legenda" 
     SIZE 4 BY 1.25 TOOLTIP "Legenda dos Resultados".

DEFINE BUTTON btModifica 
     IMAGE-UP FILE "image/im-mod.bmp":U
     LABEL "A&lterar" 
     SIZE 4 BY 1.25 TOOLTIP "Alteraá∆o dos Resultados".

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-param":U
     IMAGE-INSENSITIVE FILE "image/ii-param":U
     LABEL "ParÉmetros" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros"
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRedimensiona 
     LABEL "" 
     SIZE 90 BY .29.

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSalvar 
     IMAGE-UP FILE "image/im-grava":U
     IMAGE-INSENSITIVE FILE "image/ii-grava":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar"
     FONT 4.

DEFINE BUTTON btTxt 
     IMAGE-UP FILE "image/mab-txt.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar para TXT".

DEFINE BUTTON btVisao 
     IMAGE-UP FILE "image/im-aloca":U
     IMAGE-INSENSITIVE FILE "image/im-aloci":U
     LABEL "Classificar" 
     SIZE 4 BY 1.25 TOOLTIP "Classifica"
     FONT 4.

DEFINE VARIABLE cbResultado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 33.14 BY 1 NO-UNDO.

DEFINE VARIABLE fiAmostra AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiCompto AS CHARACTER FORMAT "X(08)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiData AS DATE FORMAT "99/99/9999":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiData-2 AS DATE FORMAT "99/99/9999":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescCompto AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 38.72 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(40)":U 
      VIEW-AS TEXT 
     SIZE 25.43 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescLubrific AS CHARACTER FORMAT "X(40)":U 
      VIEW-AS TEXT 
     SIZE 36.57 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescMatl AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 38.72 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiEmpresa AS CHARACTER FORMAT "X(3)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiEquipamento AS CHARACTER FORMAT "X(16)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiHora AS CHARACTER FORMAT "99:99:99":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiLubrific AS CHARACTER FORMAT "X(11)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiQtde AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 13 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiResultado-dat AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiResultado-num AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiResultado-txt AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(22)":U 
      VIEW-AS TEXT 
     SIZE 27.86 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiTexto-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 3.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-2 AS CHARACTER FORMAT "X(256)":U INITIAL "N£mero Amostra" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Equipamento" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-4 AS CHARACTER FORMAT "X(256)":U INITIAL "Compartimento" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Material" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Èltima Troca" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-7 AS CHARACTER FORMAT "X(256)":U INITIAL "Lubrificaá∆o" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Quantidade" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-9 AS CHARACTER FORMAT "X(256)":U INITIAL "Status" 
      VIEW-AS TEXT 
     SIZE 4.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto10 AS CHARACTER FORMAT "X(256)":U INITIAL "Resultado" 
      VIEW-AS TEXT 
     SIZE 7.72 BY .67 NO-UNDO.

DEFINE VARIABLE fiTpMater AS CHARACTER FORMAT "X(08)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 5.42.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDetalhe FOR 
      ttDados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDetalhe wWindow _FREEFORM
  QUERY brDetalhe NO-LOCK DISPLAY
      ttDados.cod-oficial                       width 20
ttDados.cod-ensaio
ttDados.desc-dimensao                           width 30
fnStatus(ttDados.idi-estado-ensaio)  @  cDescStatus  
fnStatusAmostra(ttDados.cod-oficial) @  cDescStatusAmostra
fnLog(ttDados.log-padrao) @ cDescLog        
ttDados.des-val-restdo    
ttDados.des-val-min     
ttDados.des-val-max       
ttDados.num-tabela        width 06
fnBrowse("dat-result":U,2)           @  ttDados.dat-result        width 15
fnBrowse("dat-result-ant":U,2)       @  ttDados.dat-result-ant    width 15
fnResultado(ttDados.idi-tip-restdo)  @  cDescResult
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 6.29
         FONT 1
         TITLE "".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btDetalhe AT ROW 8.25 COL 32.72 HELP
          "V† Para"
     btAbrir AT ROW 1.13 COL 2
     btSalvar AT ROW 1.13 COL 6
     btRefresh AT ROW 1.13 COL 10
     btExpande AT ROW 1.13 COL 16
     btParam AT ROW 1.13 COL 47 HELP
          "ParÉmetros"
     btFiltro AT ROW 1.13 COL 51 HELP
          "Filtro"
     btVisao AT ROW 1.13 COL 55 HELP
          "Classifica"
     btExcel AT ROW 1.13 COL 59
     btTxt AT ROW 1.13 COL 63
     btImprimir AT ROW 1.13 COL 67 HELP
          "Impress∆o"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btAprova AT ROW 8.25 COL 86
     btRedimensiona AT ROW 9.63 COL 1
     brDetalhe AT ROW 10 COL 1
     btLegenda AT ROW 16.5 COL 2 HELP
          "Legenda das Tarefas"
     btModifica AT ROW 16.5 COL 78.86 HELP
          "Alteraá∆o da Ordem de Manutená∆o"
     btCancela AT ROW 16.5 COL 82.72 HELP
          "Encerramento da Ordem de Manutená∆o"
     btConfirma AT ROW 16.5 COL 86.57
     fiResultado-dat AT ROW 16.67 COL 41.72 COLON-ALIGNED NO-LABEL
     fiResultado-num AT ROW 16.67 COL 41.72 COLON-ALIGNED NO-LABEL
     btCarga AT ROW 8.25 COL 82 HELP
          "V† Para"
     btGoTo AT ROW 1.13 COL 20 HELP
          "V† Para"
     fiResultado-txt AT ROW 16.67 COL 41.72 COLON-ALIGNED NO-LABEL
     cbResultado AT ROW 16.71 COL 41.72 COLON-ALIGNED NO-LABEL
     fiTexto-2 AT ROW 2.71 COL 63.57 COLON-ALIGNED NO-LABEL
     fiTexto-1 AT ROW 2.75 COL 37 COLON-ALIGNED NO-LABEL
     fiData AT ROW 2.75 COL 43.43 NO-LABEL
     fiHora AT ROW 2.75 COL 53.57 NO-LABEL
     fiAmostra AT ROW 2.75 COL 77.29 NO-LABEL
     fiTexto-3 AT ROW 3.5 COL 32 COLON-ALIGNED NO-LABEL
     fiEmpresa AT ROW 3.5 COL 43.43 NO-LABEL
     fiEquipamento AT ROW 3.5 COL 48.72 NO-LABEL
     fiDescEqpto AT ROW 3.5 COL 64.86 NO-LABEL
     fiTexto-4 AT ROW 4.25 COL 31 COLON-ALIGNED NO-LABEL
     fiCompto AT ROW 4.25 COL 43.43 NO-LABEL
     fiDescCompto AT ROW 4.25 COL 51.57 NO-LABEL
     fiTexto-5 AT ROW 5 COL 32 COLON-ALIGNED NO-LABEL
     fiTpMater AT ROW 5 COL 43.43 NO-LABEL
     fiDescMatl AT ROW 5 COL 51.57 NO-LABEL
     fiTexto-6 AT ROW 5.75 COL 32 COLON-ALIGNED NO-LABEL
     fiData-2 AT ROW 5.75 COL 43.43 NO-LABEL
     fiTexto-8 AT ROW 5.75 COL 66.72 COLON-ALIGNED NO-LABEL
     fiQtde AT ROW 5.75 COL 77.29 NO-LABEL AUTO-RETURN 
     fiTexto-7 AT ROW 6.5 COL 32.57 COLON-ALIGNED NO-LABEL
     fiLubrific AT ROW 6.5 COL 43.43 NO-LABEL
     fiDescLubrific AT ROW 6.5 COL 53.72 NO-LABEL
     fiTexto-9 AT ROW 7.21 COL 36.72 COLON-ALIGNED NO-LABEL
     fiStatus AT ROW 7.25 COL 43.43 NO-LABEL
     fiTexto10 AT ROW 16.83 COL 33.72 COLON-ALIGNED NO-LABEL
     RECT-27 AT ROW 2.63 COL 32
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar-3 AT ROW 16.33 COL 1
     rtToolBar-4 AT ROW 8.08 COL 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.92
         WIDTH              = 90.29
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{btb/btb008za.i0}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB brDetalhe btRedimensiona fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

ASSIGN 
       brDetalhe:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brDetalhe:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       btRedimensiona:MOVABLE IN FRAME fpage0          = TRUE.

/* SETTINGS FOR FILL-IN fiAmostra IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiCompto IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiData IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiData-2 IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiDescCompto IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiDescEqpto IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiDescLubrific IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiDescMatl IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiEmpresa IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiEquipamento IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiHora IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiLubrific IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiQtde IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiStatus IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR FILL-IN fiTpMater IN FRAME fpage0
   NO-ENABLE ALIGN-L 1                                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDetalhe
/* Query rebuild information for BROWSE brDetalhe
     _START_FREEFORM
open query {&SELF-NAME} for each ttDados no-lock use-index docto.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDetalhe */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-UNDO.



    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                     = wWindow:width-chars  - dWinXC
           dYC                                     = wWindow:height-chars - dWinYC
           dWinXC                                  = wWindow:width-chars
           dWinYC                                  = wWindow:HEIGHT-CHARS
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars
           frame fPage0:height-chars               = wWindow:height-chars
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0 = (rtToolBar-2:width-chars in frame fPage0 + dXC)
           rtToolBar-3:width-chars in frame fPage0 = (rtToolBar-3:width-chars in frame fPage0 + dXC)
           rtToolBar-3:row in frame fPage0         = (rtToolBar-3:row in frame fPage0 + dYC)
           rtToolBar-4:row in frame fPage0         = (rtToolBar-4:row in frame fPage0 + (dYC / 450))
           rtToolBar-4:width-chars in frame fPage0 = (rtToolBar-4:width-chars in frame fPage0 + dXC)
           btModifica:row in frame fPage0          = (btModifica:row in frame fPage0 + dYC)
           btModifica:column in frame fPage0       = (btModifica:column in frame fPage0 + (dXC))
           btCancela:row in frame fPage0           = (btCancela:row in frame fPage0 + dYC)
           btCancela:column in frame fPage0        = (btCancela:column in frame fPage0 + (dXC))
           btConfirma:row in frame fPage0          = (btConfirma:row in frame fPage0 + dYC)
           btConfirma:column in frame fPage0       = (btConfirma:column in frame fPage0 + (dXC))
           btLegenda:row in frame fPage0           = (btLegenda:row in frame fPage0 + dYC)
           fiResultado-txt:column in frame fPage0  = (fiResultado-txt:column in frame fPage0 + (dXC))
           fiResultado-num:column in frame fPage0  = (fiResultado-num:column in frame fPage0 + (dXC))
           fiResultado-dat:column in frame fPage0  = (fiResultado-dat:column in frame fPage0 + (dXC))
           cbResultado:column in frame fPage0      = (cbResultado:column in frame fPage0 + (dXC))
           fiResultado-txt:row in frame fPage0     = (fiResultado-txt:row in frame fPage0 + dYC)
           fiResultado-num:row in frame fPage0     = (fiResultado-num:row in frame fPage0 + dYC)
           fiResultado-dat:row in frame fPage0     = (fiResultado-dat:row in frame fPage0 + dYC)
           cbResultado:row in frame fPage0         = (cbResultado:row in frame fPage0 + dYC)    
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 + dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 + dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 + dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 + dXC)
           btParam:column in frame fPage0          = (btParam:column in frame fPage0 + dXC)
           btFiltro:column in frame fPage0         = (btFiltro:column in frame fPage0 + dXC)
           btVisao:column in frame fPage0          = (btVisao:column in frame fPage0 + dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 + dXC)
           btTXT:column in frame fPage0            = (btTXT:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 + dXC)
           brDetalhe:width-chars in frame fPage0   = (brDetalhe:width-chars in frame fPage0 + dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 + dXC)
           btRedimensiona:row in frame fPage0          = (btRedimensiona:row in frame fPage0 + (dYC / 2))
           n-4gltreeview-width                     = n-4gltreeview-width  + dXC
           n-4gltreeview-height                    = n-4gltreeview-height + dYC
           NO-ERROR.


           /******************** Campos de tela o bot‰es *****************************************************/
           assign RECT-27:column in frame fPage0        = (RECT-27:column in frame fPage0 + dXC)
                  fiData:column in frame fPage0         = (fiData:column in frame fPage0 + dXC)        
                  fiData-2:column in frame fPage0       = (fiData-2:column in frame fPage0 + dXC)      
                  fiHora:column in frame fPage0         = (fiHora:column in frame fPage0 + dXC)        
                  fiAmostra:column in frame fPage0      = (fiAmostra:column in frame fPage0 + dXC)     
                  fiEmpresa:column in frame fPage0      = (fiEmpresa:column in frame fPage0 + dXC)     
                  fiEquipamento:column in frame fPage0  = (fiEquipamento:column in frame fPage0 + dXC) 
                  fiCompto:column in frame fPage0       = (fiCompto:column in frame fPage0 + dXC)      
                  fiTpMater:column in frame fPage0      = (fiTpMater:column in frame fPage0 + dXC)     
                  fiQtde:column in frame fPage0         = (fiQtde:column in frame fPage0 + dXC)        
                  fiLubrific:column in frame fPage0     = (fiLubrific:column in frame fPage0 + dXC)    
                  fiStatus:column in frame fPage0       = (fiStatus:column in frame fPage0 + dXC)      
                  fiDescMatl:column in frame fPage0     = (fiDescMatl:column in frame fPage0 + dXC)    
                  fiDescEqpto:column in frame fPage0    = (fiDescEqpto:column in frame fPage0 + dXC)   
                  fiDescCompto:column in frame fPage0   = (fiDescCompto:column in frame fPage0 + dXC)  
                  fiDescLubrific:column in frame fPage0 = (fiDescLubrific:column in frame fPage0 + dXC)
                  btDetalhe:column in frame fPage0      = (btDetalhe:column in frame fPage0 + dXC) 
                  btDetalhe:row in frame fPage0         = ((btDetalhe:row in frame fPage0 + (dYC / 450))  - 0.0077 )
                  btCarga:column in frame fPage0        = (btCarga:column in frame fPage0 + dXC) 
                  btCarga:row in frame fPage0           = ((btCarga:row in frame fPage0 + (dYC / 450))    - 0.0077 )
                  btAprova:column in frame fPage0       = (btAprova:column in frame fPage0 + dXC)
                  btAprova:row in frame fPage0          = ((btAprova:row in frame fPage0 + (dYC / 450))   - 0.0077 )
                  fiTexto-1:column in frame fPage0      = (fiTexto-1:column in frame fPage0 + dXC)
                  fiTexto-6:column in frame fPage0      = (fiTexto-6:column in frame fPage0 + dXC)
                  fiTexto-2:column in frame fPage0      = (fiTexto-2:column in frame fPage0 + dXC)
                  fiTexto-3:column in frame fPage0      = (fiTexto-3:column in frame fPage0 + dXC)
                  fiTexto-4:column in frame fPage0      = (fiTexto-4:column in frame fPage0 + dXC)
                  fiTexto-5:column in frame fPage0      = (fiTexto-5:column in frame fPage0 + dXC)
                  fiTexto-8:column in frame fPage0      = (fiTexto-8:column in frame fPage0 + dXC)
                  fiTexto-7:column in frame fPage0      = (fiTexto-7:column in frame fPage0 + dXC)
                  fiTexto-9:column in frame fPage0      = (fiTexto-9:column in frame fPage0 + dXC)
                  fiTexto10:column in frame fPage0      = (fiTexto10:column in frame fPage0 + dXC) 
                  fiTexto10:row in frame fPage0         = (fiTexto10:row in frame fPage0 + dYC) no-error.


        run piLabelCampos in this-procedure.

        IF btConfirma:SENSITIVE IN FRAME fPage0 = NO THEN
            ASSIGN fiTexto10:HIDDEN IN FRAME fPage0 = YES.

    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.

    apply "END-MOVE":U to btRedimensiona in frame fPage0.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESTORED OF wWindow
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-UNDO.


    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                     = dWinXC - wWindow:width-chars
           dYC                                     = dWinYC - wWindow:height-chars
           dWinXC                                  = wWindow:width-chars
           dWinYC                                  = wWindow:HEIGHT-CHARS
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0 = (rtToolBar-2:width-chars in frame fPage0 - dXC)
           rtToolBar-3:width-chars in frame fPage0 = (rtToolBar-3:width-chars in frame fPage0 - dXC)
           rtToolBar-3:row in frame fPage0         = (rtToolBar-3:row in frame fPage0 - dYC)
           rtToolBar-4:width-chars in frame fPage0 = (rtToolBar-4:width-chars in frame fPage0 - dXC)
           rtToolBar-4:row in frame fPage0         = /*iRowIni*/ (rtToolBar-4:row in frame fPage0 - (dYC / 450))
           btModifica:row in frame fPage0          = (btModifica:row in frame fPage0 - dYC)
           btModifica:column in frame fPage0       = (btModifica:column in frame fPage0 - (dXC))
           btCancela:row in frame fPage0           = (btCancela:row in frame fPage0 - dYC)
           btCancela:column in frame fPage0        = (btCancela:column in frame fPage0 - (dXC))
           btConfirma:row in frame fPage0          = (btConfirma:row in frame fPage0 - dYC)
           btConfirma:column in frame fPage0       = (btConfirma:column in frame fPage0 - (dXC))
           btLegenda:row in frame fPage0           = (btLegenda:row in frame fPage0 - dYC)
           btLegenda:column in frame fPage0        = (btLegenda:column in frame fPage0 - (dXC))
           fiResultado-txt:column in frame fPage0  = (fiResultado-txt:column in frame fPage0 - (dXC))
           fiResultado-num:column in frame fPage0  = (fiResultado-num:column in frame fPage0 - (dXC))
           fiResultado-dat:column in frame fPage0  = (fiResultado-dat:column in frame fPage0 - (dXC))
           cbResultado:column in frame fPage0      = (cbResultado:column in frame fPage0 - (dXC))
           fiResultado-txt:row in frame fPage0     = (fiResultado-txt:row in frame fPage0 - dYC)
           fiResultado-num:row in frame fPage0     = (fiResultado-num:row in frame fPage0 - dYC)
           fiResultado-dat:row in frame fPage0     = (fiResultado-dat:row in frame fPage0 - dYC)
           cbResultado:row in frame fPage0         = (cbResultado:row in frame fPage0 - dYC)    
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 - dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 - dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 - dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 - dXC)
           btParam:column in frame fPage0          = (btParam:column in frame fPage0 - dXC)
           btFiltro:column in frame fPage0         = (btFiltro:column in frame fPage0 - dXC)
           btVisao:column in frame fPage0          = (btVisao:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 - dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 - dXC)
           btTXT:column in frame fPage0            = (btTXT:column in frame fPage0 - dXC)
           brDetalhe:width-chars in frame fPage0   = (brDetalhe:width-chars in frame fPage0 - dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 - dXC)
           btRedimensiona:row in frame fPage0      = 9.62
           n-4gltreeview-width                     = n-4gltreeview-width - dXC
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars
           frame fPage0:height-chars               = wWindow:HEIGHT-CHARS  NO-ERROR.

           /******************** Campos de tela o bot‰es *****************************************************/
           assign RECT-27:column in frame fPage0        = (RECT-27:column in frame fPage0 - dXC)
                  fiData:column in frame fPage0         = (fiData:column in frame fPage0 - dXC)        
                  fiData-2:column in frame fPage0       = (fiData-2:column in frame fPage0 - dXC)      
                  fiHora:column in frame fPage0         = (fiHora:column in frame fPage0 - dXC)        
                  fiAmostra:column in frame fPage0      = (fiAmostra:column in frame fPage0 - dXC)     
                  fiEmpresa:column in frame fPage0      = (fiEmpresa:column in frame fPage0 - dXC)     
                  fiEquipamento:column in frame fPage0  = (fiEquipamento:column in frame fPage0 - dXC) 
                  fiCompto:column in frame fPage0       = (fiCompto:column in frame fPage0 - dXC)      
                  fiTpMater:column in frame fPage0      = (fiTpMater:column in frame fPage0 - dXC)     
                  fiQtde:column in frame fPage0         = (fiQtde:column in frame fPage0 - dXC)        
                  fiLubrific:column in frame fPage0     = (fiLubrific:column in frame fPage0 - dXC)    
                  fiStatus:column in frame fPage0       = (fiStatus:column in frame fPage0 - dXC)      
                  fiDescMatl:column in frame fPage0     = (fiDescMatl:column in frame fPage0 - dXC)    
                  fiDescEqpto:column in frame fPage0    = (fiDescEqpto:column in frame fPage0 - dXC)   
                  fiDescCompto:column in frame fPage0   = (fiDescCompto:column in frame fPage0 - dXC)  
                  fiDescLubrific:column in frame fPage0 = (fiDescLubrific:column in frame fPage0 - dXC)
                  btDetalhe:column in frame fPage0      = (btDetalhe:column in frame fPage0 - dXC)
                  btDetalhe:row in frame fPage0         = ((btDetalhe:row in frame fPage0 -  (dYC / 450)) -  0.0077 )
                  btCarga:column in frame fPage0        = (btCarga:column in frame fPage0 - dXC)
                  btCarga:row in frame fPage0           = ((btCarga:row in frame fPage0 -  (dYC / 450))   -  0.0077 )
                  btAprova:column in frame fPage0       = (btAprova:column in frame fPage0 - dXC)
                  btAprova:row in frame fPage0          = ((btAprova:row in frame fPage0 -  (dYC / 450))  -  0.0077 )
                  fiTexto-1:column in frame fPage0      = (fiTexto-1:column in frame fPage0 - dXC)
                  fiTexto-6:column in frame fPage0      = (fiTexto-6:column in frame fPage0 - dXC)
                  fiTexto-2:column in frame fPage0      = (fiTexto-2:column in frame fPage0 - dXC)
                  fiTexto-3:column in frame fPage0      = (fiTexto-3:column in frame fPage0 - dXC)
                  fiTexto-4:column in frame fPage0      = (fiTexto-4:column in frame fPage0 - dXC)
                  fiTexto-5:column in frame fPage0      = (fiTexto-5:column in frame fPage0 - dXC)
                  fiTexto-8:column in frame fPage0      = (fiTexto-8:column in frame fPage0 - dXC)
                  fiTexto-7:column in frame fPage0      = (fiTexto-7:column in frame fPage0 - dXC)
                  fiTexto-9:column in frame fPage0      = (fiTexto-9:column in frame fPage0 - dXC)
                  fiTexto10:column in frame fPage0      = (fiTexto10:column in frame fPage0 - dXC)
                  fiTexto10:row in frame fPage0         = (fiTexto10:row in frame fPage0 - dYC) no-error.


       run piLabelCampos in this-procedure.

        IF btConfirma:SENSITIVE IN FRAME fPage0 = NO THEN
            ASSIGN fiTexto10:HIDDEN IN FRAME fPage0 = YES.

    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.

    apply "END-MOVE":U to btRedimensiona in frame fPage0.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDetalhe
&Scoped-define SELF-NAME brDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDetalhe wWindow
ON ROW-DISPLAY OF brDetalhe IN FRAME fpage0
DO:
  if avail ttDados then do:
    case ttDados.idi-estado-ensaio:

          /** Pendente = Cinza **/
          when 1 then do:
              assign ttDados.cod-oficial:fgcolor in browse brDetalhe = 7
                     ttDados.cod-ensaio:fgcolor in browse brDetalhe = 7
                     ttDados.desc-dimensao:fgcolor in browse brDetalhe = 7                   
                     cDescStatus:fgcolor in browse brDetalhe = 7 
                     cDescStatusAmostra:fgcolor in browse brDetalhe = 7 
                     cDescLog:fgcolor in browse brDetalhe = 7        
                     ttDados.des-val-restdo:fgcolor in browse brDetalhe = 7    
                     ttDados.des-val-max:fgcolor in browse brDetalhe = 7       
                     ttDados.des-val-min:fgcolor in browse brDetalhe = 7       
                     ttDados.num-tabela:fgcolor in browse brDetalhe = 7        
                     ttDados.dat-result:fgcolor in browse brDetalhe = 7        
                     ttDados.dat-result-ant:fgcolor in browse brDetalhe = 7    
                     cDescResult:fgcolor in browse brDetalhe = 7.
          end. 
          /** Aprovado = Verde **/
          when 2 then do:
              assign ttDados.cod-oficial:fgcolor in browse brDetalhe = 3
                     ttDados.cod-ensaio:fgcolor in browse brDetalhe = 3
                     ttDados.desc-dimensao:fgcolor in browse brDetalhe = 3                   
                     cDescStatus:fgcolor in browse brDetalhe = 3  
                     cDescStatusAmostra:fgcolor in browse brDetalhe = 3 
                     cDescLog:fgcolor in browse brDetalhe = 3        
                     ttDados.des-val-restdo:fgcolor in browse brDetalhe = 3    
                     ttDados.des-val-max:fgcolor in browse brDetalhe = 3       
                     ttDados.des-val-min:fgcolor in browse brDetalhe = 3       
                     ttDados.num-tabela:fgcolor in browse brDetalhe = 3        
                     ttDados.dat-result:fgcolor in browse brDetalhe = 3        
                     ttDados.dat-result-ant:fgcolor in browse brDetalhe = 3    
                     cDescResult:fgcolor in browse brDetalhe = 3.
          end. 
          when 3 then do:
              /** Aprovado pelo usu†rio = Azul **/
              assign ttDados.cod-oficial:fgcolor in browse brDetalhe = 9 
                     ttDados.cod-ensaio:fgcolor in browse brDetalhe = 9
                     ttDados.desc-dimensao:fgcolor in browse brDetalhe = 9                   
                     cDescStatus:fgcolor in browse brDetalhe = 9  
                     cDescStatusAmostra:fgcolor in browse brDetalhe = 9 
                     cDescLog:fgcolor in browse brDetalhe = 9        
                     ttDados.des-val-restdo:fgcolor in browse brDetalhe = 9    
                     ttDados.des-val-max:fgcolor in browse brDetalhe = 9       
                     ttDados.des-val-min:fgcolor in browse brDetalhe = 9       
                     ttDados.num-tabela:fgcolor in browse brDetalhe = 9        
                     ttDados.dat-result:fgcolor in browse brDetalhe = 9        
                     ttDados.dat-result-ant:fgcolor in browse brDetalhe = 9    
                     cDescResult:fgcolor in browse brDetalhe = 9.
          end.   
          when 4 then do:
          /** Reprovado =  Vermelho **/
               assign ttDados.cod-oficial:fgcolor in browse brDetalhe = 12
                     ttDados.cod-ensaio:fgcolor in browse brDetalhe = 12
                     ttDados.desc-dimensao:fgcolor in browse brDetalhe = 12                   
                     cDescStatus:fgcolor in browse brDetalhe = 12  
                     cDescStatusAmostra:fgcolor in browse brDetalhe = 12
                     cDescLog:fgcolor in browse brDetalhe = 12        
                     ttDados.des-val-restdo:fgcolor in browse brDetalhe = 12    
                     ttDados.des-val-max:fgcolor in browse brDetalhe = 12       
                     ttDados.des-val-min:fgcolor in browse brDetalhe = 12       
                     ttDados.num-tabela:fgcolor in browse brDetalhe = 12        
                     ttDados.dat-result:fgcolor in browse brDetalhe = 12        
                     ttDados.dat-result-ant:fgcolor in browse brDetalhe = 12    
                     cDescResult:fgcolor in browse brDetalhe = 12.
          end.
        end case.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDetalhe wWindow
ON VALUE-CHANGED OF brDetalhe IN FRAME fpage0
DO:
         if num-entries("brDetalhe":u) > 0 then do:
            assign iAmostra = 0.
            if avail ttDados then do:
               get Current brDetalhe no-lock.
               if ttDados.p-image = 12 then do:
                   enable btModifica with frame fPage0.
                   ENABLE btCarga with frame fPage0.
                   ENABLE btAprova with frame fPage0.
                   enable btDetalhe with frame fPage0.
                   assign fiResultado-txt:hidden in frame fPage0       = yes
                          fiResultado-num:hidden in frame fPage0       = yes
                          fiResultado-dat:hidden in frame fPage0       = yes
                          cbResultado:hidden in frame fPage0           = yes
                          fitexto10:HIDDEN IN FRAME fPage0             = YES
                          btCancela:SENSITIVE IN FRAME fPage0          = NO
                          btConfirma:SENSITIVE IN FRAME fPage0         = NO
                          cDocto                                       = ttDados.cod-oficial:screen-value in browse brDetalhe.
                          iAmostra                                     = int(ttDados.cod-oficial:screen-value in browse brDetalhe).
                          /**** Mostra as informaá‰es da Amostra em Tela ***/
                        run piMostraCamposTela in this-procedure (input int(ttDados.cod-oficial:screen-value in browse brDetalhe)).
               end.
            end.
         end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAbrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAbrir wWindow
ON CHOOSE OF btAbrir IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAbrir  IN MENU mbMain DO:

   /** Troca as barras **/
   assign c-arquivo = replace(c-arquivo, "/", "/").
   /** Abre caixa para abrir arquivo **/
   SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dat" "*.dat",
               "*.*" "*.*"
       ASK-OVERWRITE
       DEFAULT-EXTENSION "dat"
       INITIAL-DIR entry (1, propath)
       USE-FILENAME
       UPDATE l-ok.
   /** Retorno de OK, abre o arquivo **/
   if l-ok then do:
      if search (c-arquivo) <> ? then
         run carregaFiltro (input c-arquivo).
   end.

   apply "ENTRY":U to btAbrir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprova wWindow
ON CHOOSE OF btAprova IN FRAME fpage0
DO:
  if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then do:
    if num-entries("brDetalhe":u) > 0 then do:
        assign {&window-name}:sensitive = no.
        get current brDetalhe no-lock.
        if avail ttDados then do:
           assign cDocto = ttDados.cod-oficial:screen-value in browse brDetalhe.
           run inicializaHandle in this-procedure.
           run buscaRegistros in this-procedure.
               if return-value = "OK":U then do:
                  run piAtualizar in this-procedure.
               end.
           run finalizaHandle in this-procedure.
        end. /*** if avail ttDados ***/
        assign {&window-name}:sensitive = yes.
    end.
  end. /*** DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) ***/
  
  apply "ENTRY":U to btAprova in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0 /* Encerrar */
DO:
       assign fiResultado-txt:hidden in frame fPage0       = yes
              fiResultado-num:hidden in frame fPage0       = yes
              fiResultado-dat:hidden in frame fPage0       = yes
              cbResultado:hidden in frame fPage0           = yes
              fiResultado-txt:screen-value in frame fPage0 = "":U 
              fiResultado-dat                              = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF  
              fiResultado-num                              = 0.00
              cbResultado:screen-value in frame fPage0     = "":U
              fiTexto10:hidden in frame fPage0             = yes
              lLabel                                       = no.
      /** Busca Registro com rowid **/
/*         for first bfttDados                                                */
/*             where rowid(bfttDados) = rRowidBusca no-lock:                  */
/*         end.                                                               */
/*         IF AVAIL bfttDados THEN                                            */
/*         /** Verifica se ele contÇm filhos **/                              */
/*         for first ttDados                                                  */
/*             where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock: */
/*         end.                                                               */
/*         /** Mostra registros no browse **/                                 */
/*         run piBrowseAtualiza in this-procedure.                            */
       disable btConfirma with frame fPage0.
       ENABLE  btModifica with frame fPage0.
       ENABLE  btCarga with frame fPage0.
       ENABLE  btAprova with frame fPage0.
       disable btCancela with frame fPage0.
       RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarga wWindow
ON CHOOSE OF btCarga IN FRAME fpage0
DO:
    EMPTY TEMP-TABLE ttDadosAux.
    
    if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then do:
        if num-entries("brDetalhe":u) > 0 then do:
            brDetalhe:SELECT-FOCUSED-ROW().
            get current brDetalhe no-lock.
            if avail ttDados then do:
                assign cDocto = ttDados.cod-oficial:screen-value in browse brDetalhe.
                assign {&window-name}:sensitive = no.
               /** Busca os filhos do Registro selecionado **/
                IF NOT AVAIL ttDadosAux THEN DO:
                  if cCodArmaz <> "":U /*and cCodPaiReg <> "":U*/ then do:
                    FIND FIRST bfttDados WHERE bfttDados.num-amostra-oleo <> 0 NO-LOCK NO-ERROR.
                    IF AVAIL bfttDados THEN
                        ASSIGN i-num-amostra-oleo = bfttDados.num-amostra-oleo.

                    for each bfttDados 
                        where bfttDados.p-image            = 12
                       /* and   bfttDados.cod-amostra-fisic  = cCodArmaz  */
                       /* and   bfttDados.cod-dimens-pai     = cCodPaiReg */
                        and   bfttDados.cod-oficial        = cDocto no-lock:
                        /*** Cria temp-table auxiliar ***/
                           CREATE ttDadosAux.
                           BUFFER-COPY bfttDados to ttDadosAux.
                           ASSIGN cNunControl = bfttDados.cod-amostra-fisic
                                  ttDadosAux.num-amostra-oleo = i-num-amostra-oleo.
                    END.
                  END.
                  run aop/ao0302g.w (input table  ttDadosAux).
                  assign {&window-name}:sensitive = yes.
    
                  if return-value = "OK":U then do:
    
                     IF NOT AVAIL bfttDados THEN
                         FIND FIRST bfttDados WHERE bfttDados.num-amostra-oleo <> 0 NO-LOCK NO-ERROR.
                     IF AVAIL bfttDados THEN
                         FIND FIRST mao-amostra-oleo WHERE mao-amostra-oleo.num-amostra-oleo   = bfttDados.num-amostra-oleo
                                                      AND (mao-amostra-oleo.idi-estado-amostra = 4 OR 
                                                           mao-amostra-oleo.idi-estado-amostra = 3) NO-LOCK NO-ERROR.
    
                         IF AVAIL mao-amostra-oleo  THEN DO:
                               IF mao-amostra-oleo.idi-estado-amostra = 3 THEN DO:
                                   {utp/ut-liter.i Aprovada_pelo_Usu†rio *}
                               END.
                               ELSE DO:
                                   {utp/ut-liter.i Reprovada *}
                               END.
                         
                               ASSIGN c-liter = RETURN-VALUE.
                               /*como amostra ficou reprovada(4) ou aprovada pelo usu†rio(3), pergunta ao usu†rio se quer criar Evento*/
                               run utp/ut-msgs.p (input "show":U,
                                                  input 30274,
                                                  input c-liter).
                               if return-value = "yes":U then do:
                                     run criaEvento in this-procedure.
                               END.
                         END.
                  END.
                  run piAtualizar in this-procedure.
                END.
            END.
            else do: 
                 for each bfttDados 
                     where bfttDados.p-image            = 12
                     and   bfttDados.cod-amostra-fisic  = pNunAmostra
                     and   bfttDados.cod-oficial        = cDocto  no-lock:
                     /*** Cria temp-table auxiliar ***/
                     create ttDadosAux.
                     buffer-copy bfttDados to ttDadosAux.
                     /**/
                     ASSIGN cNunControl = bfttDados.cod-amostra-fisic. 
                     /**/
                 end.
                 assign pNunAmostra = "":u.
                 run aop/ao0302g.w (input table  ttDadosAux).
                 assign {&window-name}:sensitive = yes.
    
                 if return-value = "OK":U then do:
    
                       IF NOT AVAIL bfttDados THEN
                         FIND FIRST bfttDados WHERE bfttDados.num-amostra-oleo <> 0 NO-LOCK NO-ERROR.
    
                       IF AVAIL bfttDados THEN
                       FIND FIRST mao-amostra-oleo 
                            WHERE mao-amostra-oleo.num-amostra-oleo   = bfttDados.num-amostra-oleo
                             AND (mao-amostra-oleo.idi-estado-amostra = 4 OR 
                                  mao-amostra-oleo.idi-estado-amostra = 3) NO-LOCK NO-ERROR.
    
                       IF AVAIL mao-amostra-oleo  THEN DO:
                                IF mao-amostra-oleo.idi-estado-amostra = 3 THEN DO:
                                    {utp/ut-liter.i Aprovada_pelo_Usu†rio *}
                                END.
                                ELSE DO:
                                    {utp/ut-liter.i Reprovada *}
                                END.
                                ASSIGN c-liter = RETURN-VALUE.
                           /*como amostra ficou reprovada(4) ou aprovada pelo usu†rio(3), pergunta ao usu†rio se quer criar Evento*/
                           RUN utp/ut-msgs.p (input "show":U,
                                              input 30274,
                                              input c-liter).
                           if return-value = "yes":U then do:
                                  run criaEvento in this-procedure.
                           END.
                       END.
                       run piAtualizar in this-procedure.
                 END.
            END.
        END.
        else do:
           {utp/ut-liter.i Deve_selecionar_pelo_um_registro_no_browse! * }
           assign cTexto = return-value +  tt-Result.cod-ensaio.
           run utp/ut-msgs.p (input "show":U,
                               input 17006,
                               input return-value ).
          return no-apply.
        END.
    END.
    
    APPLY "ENTRY":U to btCarga in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fpage0
DO:
       /**** Limpa a temp-table ***/
       empty temp-table tt-Result.
      if INPUT FRAME fPage0 brDetalhe:num-selected-rows > 0 then do:
          brDetalhe:SELECT-FOCUSED-ROW(). 
          disable btCancela  with frame fPage0.
          disable btModifica with frame fPage0.
          DISABLE btCarga with frame fPage0.
          DISABLE btAprova with frame fPage0.

         if  avail ttDados then do:
             run atualizaResultados in this-procedure.
            if return-value = "OK":U then do:
               OPEN QUERY brDetalhe FOR EACH ttDados WHERE ttDados.cod-ensaio        <> ?  AND 
                                                           ttDados.cod-ensaio        <> "" AND 
                                                           ttDados.cod-amostra-fisic = trim(fiAmostra:SCREEN-VALUE IN FRAME fPage0) NO-LOCK.
               assign fiResultado-txt:hidden in frame fPage0   = yes
                      fiResultado-num:hidden in frame fPage0   = yes
                      cbResultado:hidden in frame fPage0       = yes
                      fiResultado-dat:hidden in frame fPage0   = yes
                      fiTexto10:hidden in frame fpage0         = yes
                      fiResultado-txt                          = "":U
                      fiResultado-num                          = 0.0000
                      fiResultado-dat                          = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF .
               disable btCancela  with frame fPage0. 
               enable  btModifica with frame fPage0.
               ENABLE btCarga with frame fPage0.
               ENABLE btAprova with frame fPage0.
               disable btConfirma with frame fPage0. 
             end.
             else do:
               ENABLE btCancela  with frame fPage0. 
               DISABLE btModifica with frame fPage0.
               DISABLE btCarga with frame fPage0.
               DISABLE btAprova with frame fPage0.
               ENABLE btConfirma with frame fPage0. 
               assign fiTexto10:hidden in frame fpage0 = no.
            end.
          end. /*** if avail ttDados ***/

      end.
  apply "ENTRY":U to btConfirma in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wWindow
ON CHOOSE OF btDetalhe IN FRAME fpage0
DO:
    
  if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then do:
     assign {&window-name}:sensitive = no.
     if num-entries("brDetalhe":u) > 0 then do:
         get Current brDetalhe no-lock.
        if avail ttDados then do:
           run consultaAmostra in this-procedure.
        end.
     end.
     assign {&window-name}:sensitive = yes.
  end.
  
  apply "ENTRY":U to btDetalhe in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM miExcel  IN MENU mbMain DO:
    if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then do:
        run piExcel in this-procedure.
    end.
    
    apply "ENTRY":U to btExcel in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExpande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExpande wWindow
ON CHOOSE OF btExpande IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miExpande  IN MENU mbMain DO:
    /** Verifica se existem dados no tree-view **/
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN    DO:

        /** Posiciona no primeiro Node **/
        DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, 'i1').

        ASSIGN  l-expande   =   NOT l-expande.

        /** Expande os n°veis abaixo **/
        DO  i-cont = 1  TO  DYNAMIC-FUNCTION('getTreeCount' IN h-4gltreeview):
            IF  l-expande   THEN    DYNAMIC-FUNCTION('expandNode'   IN h-4gltreeview, 'i' + STRING(i-cont), "").
            ELSE                    DYNAMIC-FUNCTION('collapseNode' IN h-4gltreeview, 'i' + STRING(i-cont), "").
        END.
        RUN pi-atualizaTreeView.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM miFiltro  IN MENU mbMain DO:

  assign {&window-name}:sensitive = no.
  run aop/ao0302b.w (input-output  table ttSelecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btFiltro in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wWindow
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM m_V_Para  IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miImprimir  IN MENU mbMain DO:
    if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then
        run piImprimir in this-procedure.
        
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLegenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLegenda wWindow
ON CHOOSE OF btLegenda IN FRAME fpage0 /* Legenda */
DO: 
    assign {&window-name}:sensitive = no.
    run aop/ao0302h.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to btLegenda in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModifica wWindow
ON CHOOSE OF btModifica IN FRAME fpage0 /* Alterar */
DO:
      if INPUT FRAME fPage0 brDetalhe:num-selected-rows > 0 then do:
          brDetalhe:SELECT-FOCUSED-ROW(). 
         if  avail ttDados then do:
             assign lLabel = yes.
             {utp/ut-liter.i Resultado * }
             assign fiTexto10 = trim(return-value).
             disp fiTexto10 with frame fPage0.
             case ttDados.idi-tip-restdo:
                 when 1 then do:
                     assign  fiResultado-txt:hidden in frame fPage0       = YES
                             fiResultado-num:hidden in frame fPage0       = no
                             fiResultado-dat:hidden in frame fPage0       = YES
                             fiResultado-txt:sensitive in frame fPage0    = NO
                             fiResultado-num:sensitive in frame fPage0    = YES 
                             fiResultado-dat:sensitive in frame fPage0    = NO 
                             cbResultado:hidden in frame fPage0           = yes
                             fiResultado-num:format in frame fPage0       = ttDados.des-formato
                             fiResultado-num                              = 0.00
                             fiResultado-num:SCREEN-VALUE IN FRAME fPage0 = ttDados.des-val-restdo NO-ERROR.
                     apply "FOCUS":U to fiResultado-num in frame fPage0.
                 end.
                 when 2 then do:
                         assign  fiResultado-txt:hidden in frame fPage0       = YES
                                 fiResultado-num:hidden in frame fPage0       = YES
                                 fiResultado-dat:hidden in frame fPage0       = YES
                                 fiResultado-txt:sensitive in frame fPage0    = NO
                                 fiResultado-num:sensitive in frame fPage0    = NO 
                                 fiResultado-dat:sensitive in frame fPage0    = NO 
                                 cbResultado:hidden in frame fPage0           = no
                                 cbResultado:sensitive in frame fPage0        = yes.

                            run buscaResultados in this-procedure (input ttDados.num-tabela:screen-value in browse brDetalhe,
                                                                   output c-lista). 
                            assign cbResultado:LIST-ITEM-PAIRS in frame fPage0 = c-lista.
                            ASSIGN cbResultado:SCREEN-VALUE IN FRAME fPage0 = string(ttDados.des-val-restdo).

                     apply "FOCUS":U to cbResultado in frame fPage0.

                 end.
                 when 3 then do:
                     assign  fiResultado-txt:hidden in frame fPage0       = NO
                             fiResultado-num:hidden in frame fPage0       = YES
                             fiResultado-dat:hidden in frame fPage0       = YES
                             fiResultado-txt:sensitive in frame fPage0    = YES
                             fiResultado-num:sensitive in frame fPage0    = NO 
                             fiResultado-dat:sensitive in frame fPage0    = NO 
                             cbResultado:hidden in frame fPage0           = yes
                             fiResultado-txt:format in frame fPage0       = ttDados.des-formato
                             fiResultado-txt:SCREEN-VALUE IN FRAME fPage0 = "":U
                             fiResultado-txt:SCREEN-VALUE IN FRAME fPage0 = ttDados.des-val-restdo NO-ERROR.

                     apply "FOCUS":U to fiResultado-txt  in frame fPage0.
                 end.
                 when 4 then do:
                     {utp/ut-liter.i Resultado * }
                     assign  fiResultado-txt:hidden in frame fPage0       = YES
                             fiResultado-num:hidden in frame fPage0       = YES
                             fiResultado-dat:hidden in frame fPage0       = NO
                             fiResultado-txt:sensitive in frame fPage0    = NO
                             fiResultado-num:sensitive in frame fPage0    = NO 
                             fiResultado-dat:sensitive in frame fPage0    = YES 
                             cbResultado:hidden in frame fPage0           = yes
                             fiResultado-dat:format in frame fPage0       = "99/99/9999":U
                             fiResultado-dat:SCREEN-VALUE IN FRAME fPage0 = string(date(ttDados.des-val-restdo),"99/99/9999":U).

                     apply "FOCUS":U to fiResultado-dat  in frame fPage0.
                 end.
             end case.
            enable btConfirma with frame fPage0.
            enable btCancela with frame fPage0.
            DISABLE btModifica WITH FRAME fPage0.
            DISABLE btCarga with frame fPage0.
            DISABLE btAprova with frame fPage0.
         end.
      end.

  apply "ENTRY":U to btModifica in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miSelecao  IN MENU mbMain DO:

  assign {&window-name}:sensitive = no.
  run aop/ao0302a.w (input-output  table ttSelecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btParam in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRedimensiona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRedimensiona wWindow
ON END-MOVE OF btRedimensiona IN FRAME fpage0
DO:
    if btRedimensiona:row < 3.5 then
        assign btRedimensiona:row = 3.5.

    if btRedimensiona:row > (frame fPage0:height - 4) then
        assign btRedimensiona:row = (frame fPage0:height - 4).

    if btRedimensiona:row > frame fPage0:height then
       assign btRedimensiona:row = frame fPage0:height - 1.

 if btRedimensiona:row < (rtToolBar-4:row in frame fPage0 + rtToolBar-4:height) then
        assign btRedimensiona:row = (rtToolBar-4:row in frame fPage0 + rtToolBar-4:height) no-error.  


    assign brDetalhe:row     = btRedimensiona:row + btRedimensiona:height  no-error.
    assign brDetalhe:height  = (frame fPage0:height - 1.5) + 0.5 - (btRedimensiona:row) no-error.
    
    assign n-4gltreeview-height  = (frame fPage0:height) -  
                               (0.2 + brDetalhe:height + btRedimensiona:height + rtToolBar-4:height + rtToolBar-2:height) no-error.
    
 if btRedimensiona:row > (n-4gltreeview-row  + n-4gltreeview-height) then
    assign btRedimensiona:row = (n-4gltreeview-row  + n-4gltreeview-height) 
           brDetalhe:row in frame fPage0 =  btRedimensiona:row + 0.30 no-error.  
 

 if btRedimensiona:column in frame fPage0 > brDetalhe:column in frame fPage0  then do:
    assign btRedimensiona:column in frame fPage0 = brDetalhe:column in frame fPage0.
 end.

 RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wWindow
ON CHOOSE OF btRefresh IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAtualizar  IN MENU mbMain DO:

/** Controla expans∆o **/
if l-expande then 
    assign l-expande = no.

ASSIGN brDetalhe:title in frame fPage0       = ""
       c-tag-tree                            = "".
assign fiData:SCREEN-VALUE IN FRAME fPage0   = "":U
       fiData-2:SCREEN-VALUE IN FRAME fPage0 = "":U
       fiHora                                = "":U
       fiAmostra                             = "":U
       fiEmpresa                             = "":U
       fiEquipamento                         = "":U
       fiCompto                              = "":U
       fiTpMater                             = "":U
       fiQtde                                = 0.00
       fiLubrific                            = "":U
       fiStatus                              = "":U
       fiDescMatl                            = "":U
       fiDescEqpto                           = "":U
       fiDescCompto                          = "":U
       fiDescLubrific                        = "":U.

DISPLAY fiHora 
        fiAmostra        
        fiEmpresa        
        fiEquipamento    
        fiCompto         
        fiTpMater         
        fiQtde           
        fiLubrific       
        fiStatus         
        fiDescMatl       
        fiDescEqpto      
        fiDescCompto     
        fiDescLubrific with frame fPage0.

session:set-wait-state ("GENERAL").
run piAtualizar in this-procedure.
session:set-wait-state ("").

RUN applyEntry IN h-4gltreeview(INPUT "").

ASSIGN btModifica:SENSITIVE IN FRAME fPage0 = NO
       btDetalhe:SENSITIVE IN FRAME fPage0 = NO
       btCarga:SENSITIVE IN FRAME fPage0 = NO
       btAprova:SENSITIVE IN FRAME fPage0 = NO.

RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSalvar  IN MENU mbMain DO:

   /** Troca os tipos de barras **/ 
   assign c-arquivo = "ao0302.dat"
          c-arquivo = replace(c-arquivo, "/", "/").

   /** Abre caixa de escolha de arquivos **/
   SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dat" "*.dat",
               "*.*" "*.*"
       ASK-OVERWRITE
       DEFAULT-EXTENSION "dat"
       INITIAL-DIR entry (1, propath)
       SAVE-AS     
       USE-FILENAME 
       UPDATE l-ok.
   /** Retorno de OK **/
   if l-ok then do:
      output to value (c-arquivo).
      /** Salva Seleá∆o **/
      for each ttSelecao:
          IF l-usa-unid-negoc THEN DO:
              &IF DEFINED (bf_mnt_ems206b) &THEN
                  export delimiter ";"
                    ttSelecao.empresa-ini  
                    ttSelecao.empresa-fim  
                    ttSelecao.equipto-ini  
                    ttSelecao.equipto-fim  
                    ttSelecao.docto-ini    
                    ttSelecao.docto-fim    
                    ttSelecao.modelo-ini   
                    ttSelecao.modelo-fim   
                    ttSelecao.amostra-ini  
                    ttSelecao.amostra-fim  
                    ttSelecao.data-ini     
                    ttSelecao.data-fim     
                    ttSelecao.compto-ini   
                    ttSelecao.compto-fim   
                    ttSelecao.tp-mater-ini 
                    ttSelecao.tp-mater-fim
                    ttSelecao.lubrific-ini
                    ttSelecao.lubrific-fim
                    ttSelecao.tag-ini
                    ttSelecao.tag-fim
                    ttSelecao.cc-ini
                    ttSelecao.cc-fim
                    ttSelecao.lPadrao
                    ttSelecao.lNPadrao
                    ttSelecao.lData           
                    ttSelecao.lTexto
                    ttSelecao.lNumerico       
                    ttSelecao.lTabela         
                    ttSelecao.lAprovado       
                    ttSelecao.lReprovado      
                    ttSelecao.lPendente       
                    ttSelecao.lAprovUsuar     
                    ttSelecao.lAmostAprovado  
                    ttSelecao.lAmostReprovado 
                    ttSelecao.lAmostPendente  
                    ttSelecao.lAmostAprovUsuar
                    ttSelecao.unid-negoc-ini
                    ttSelecao.unid-negoc-fim.
              &ENDIF
          END.
          ELSE DO:
              export delimiter ";"
                ttSelecao.empresa-ini  
                ttSelecao.empresa-fim  
                ttSelecao.equipto-ini  
                ttSelecao.equipto-fim  
                ttSelecao.docto-ini    
                ttSelecao.docto-fim    
                ttSelecao.modelo-ini   
                ttSelecao.modelo-fim   
                ttSelecao.amostra-ini  
                ttSelecao.amostra-fim  
                ttSelecao.data-ini     
                ttSelecao.data-fim     
                ttSelecao.compto-ini   
                ttSelecao.compto-fim   
                ttSelecao.tp-mater-ini 
                ttSelecao.tp-mater-fim
                ttSelecao.lubrific-ini
                ttSelecao.lubrific-fim
                ttSelecao.tag-ini
                ttSelecao.tag-fim
                ttSelecao.cc-ini
                ttSelecao.cc-fim
                ttSelecao.lPadrao
                ttSelecao.lNPadrao
                ttSelecao.lData           
                ttSelecao.lTexto
                ttSelecao.lNumerico       
                ttSelecao.lTabela         
                ttSelecao.lAprovado       
                ttSelecao.lReprovado      
                ttSelecao.lPendente       
                ttSelecao.lAprovUsuar     
                ttSelecao.lAmostAprovado  
                ttSelecao.lAmostReprovado 
                ttSelecao.lAmostPendente  
                ttSelecao.lAmostAprovUsuar.
          END.          
      end.
      /** Salva Vis‰es **/
      for each ttVisao:
          export delimiter ";"
                 ttVisao.dimensao
                 ttVisao.sequencia.
      end.
      output close.
   end.

   apply "ENTRY":U to btSalvar in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTxt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTxt wWindow
ON CHOOSE OF btTxt IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miTxt IN MENU mbMain DO:
    if DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) then do:
        run piTexto in this-procedure.
    end.
    apply "ENTRY":U to btTxt in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisao wWindow
ON CHOOSE OF btVisao IN FRAME fpage0 /* Classificar */
OR CHOOSE OF MENU-ITEM miClassifica  IN MENU mbMain DO:

  assign {&window-name}:sensitive = no.
  run aop/ao0302c.w (input-output table ttVisao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btVisao in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
define temp-table RowErrorsAux no-undo like RowErrors.

/** Include padr∆o do template **/
{window/mainblock.i}

/** Procedure que manda mensagens para o sistema operacional **/
PROCEDURE SendMessageA EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER umsg   AS {&INT}.
    DEFINE INPUT PARAMETER wparam AS {&INT}.
    DEFINE INPUT PARAMETER lparam AS LONG. 
END.

/** define procedure externa para execucao do programa de visualizacao do txt **/
PROCEDURE WinExec EXTERNAL "kernel32.dll":
    DEF INPUT  PARAM prg_name                          AS CHARACTER.
    DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

btRedimensiona:load-mouse-pointer ("image/size2.cur") in frame fPage0.

{abp/ab9000.i}    /** Convers∆o de horas invertidas **/
{mvp/mv9000.i}    /** Convers∆o hora decimal
                      OBS: A procedure piCriaErro encontra-se definida dentro desta include  **/

RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccusto.
RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  "",                     /* EMPRESA EMS2 */
                                             INPUT  "",                     /* CODIGO DO PLANO CCUSTO */
                                             INPUT  "",                     /* UNIDADE DE NEGOCIO */
                                             INPUT  TODAY,                  /* DATA DE TRANSACAO */
                                             OUTPUT TABLE tt_ccusto_integr, /* CCUSTOS */
                                             OUTPUT TABLE tt_log_erro).     /* ERROS */

IF VALID-HANDLE(h_api_ccusto) THEN
    DELETE PROCEDURE h_api_ccusto.

{cdp/cdunif001b.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s terminar a tela
------------------------------------------------------------------------------*/
/** Caixa de mensagens **/
{method/showmessage.i3}

IF  VALID-HANDLE(h-4gltreeview) THEN    DO:
    RUN destroyObject   IN  h-4gltreeview.
    DELETE  PROCEDURE   h-4gltreeview.
END.
          
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializaá∆o da tela
------------------------------------------------------------------------------*/
/** Labels do browse **/
assign ttDados.cod-oficial:label in browse brDetalhe    = fnBrowse("cod-oficial":U,1) 
       ttDados.cod-ensaio:label in browse brDetalhe     = fnBrowse("cod-ensaio":U,1) 
       ttDados.desc-dimensao:label in browse brDetalhe  = fnBrowse("desc-dimensao":U,1)  
       cDescStatus:label in browse brDetalhe            = fnBrowse("idi-estado-ensaio":U,1)
       cDescLog:label in browse brDetalhe               = fnBrowse("log-padrao":U,1)
       ttDados.des-val-restdo:label in browse brDetalhe = fnBrowse("des-val-restdo":U,1)
       ttDados.des-val-max:label in browse brDetalhe    = fnBrowse("des-val-max":U,1)
       ttDados.des-val-min:label in browse brDetalhe    = fnBrowse("des-val-min":U,1)
       ttDados.num-tabela:label in browse brDetalhe     = fnBrowse("num-tabela":U,1)
       cDescResult:label in browse brDetalhe            = fnBrowse("idi-tip-restdo":U,1)
       ttDados.dat-result-ant:label in browse brDetalhe = fnBrowse("dat-result-ant":U,1)
       ttDados.dat-result:label in browse brDetalhe     = fnBrowse("dat-result":U,1)
       cDescStatusAmostra:visible in browse brDetalhe   = NO.

/** Desabilita bot‰es em tela na carga inicial do programa **/
assign btCarga:sensitive      in frame fPage0 = no
       btDetalhe:sensitive    in frame fPage0 = no
       btAprova:sensitive     in frame fPage0 = no
       btModifica:sensitive   in frame fPage0 = no
       btCancela:sensitive    in frame fPage0 = no
       btConfirma:sensitive   in frame fPage0 = no
       fiResultado-txt:hidden in frame fPage0 = yes
       fiResultado-dat:hidden in frame fPage0 = yes
       fiResultado-num:hidden in frame fPage0 = yes
       cbResultado:hidden     in frame fPage0 = yes
       fiTexto10:hidden       in frame fPage0 = yes.

assign iRowIni = rtToolBar-4:row in frame fPage0.

run piLabelCampos in this-procedure. 

/*limpando campos em tela*/
assign fiData:SCREEN-VALUE IN FRAME fPage0   = "":U
    fiData-2:SCREEN-VALUE IN FRAME fPage0 = "":U
    fiHora            =    "":U
    fiAmostra         =    "":U
    fiEmpresa         =    "":U
    fiEquipamento     =    "":U
    fiCompto          =    "":U
    fiTpMater         =    "":U
    fiQtde            =    0.00
    fiLubrific        =    "":U
    fiStatus          =    "":U
    fiDescMatl        =    "":U
    fiDescEqpto       =    "":U
    fiDescCompto      =    "":U
    fiDescLubrific    =    "":U.

disp fiHora 
 fiAmostra        
 fiEmpresa        
 fiEquipamento    
 fiCompto         
 fiTpMater         
 fiQtde           
 fiLubrific       
 fiStatus         
 fiDescMatl       
 fiDescEqpto      
 fiDescCompto     
 fiDescLubrific with frame fPage0.

ASSIGN drowbtAprova  = btAprova:ROW IN FRAME fPage0
   drowbtCarga   = btCarga:ROW IN FRAME fPage0
   drowbtDetalhe = btDetalhe:ROW IN FRAME fPage0.

/* -------------------------- */
/* Monta o Browse do TreeView */
/* -------------------------- */

IF  NOT VALID-HANDLE(h-4gltreeview) THEN DO:
    RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.

    RUN setParentFrame  IN  h-4gltreeview   (INPUT  FRAME   fPage0:HANDLE).

    RUN initializeObject IN h-4gltreeview.

    SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

    ASSIGN  n-4gltreeview-row       =   2.54.
    ASSIGN  n-4gltreeview-column    =   1.00.
    ASSIGN  n-4gltreeview-height    =   7.00.
    ASSIGN  n-4gltreeview-width     =   31.00.

    RUN repositionObject IN h-4gltreeview ( n-4gltreeview-row , n-4gltreeview-column )   NO-ERROR.
    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaResultados wWindow 
PROCEDURE atualizaResultados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
case ttDados.idi-tip-restdo:
       when 1 THEN DO:
             if input frame fPage0 fiResultado-num <> "":U then do:
                 assign ttDados.des-val-restdo =  input frame fPage0 fiResultado-num.
                 if INPUT FRAME fPage0 fiResultado-num   >= dec(ttDados.des-val-min)     
                    and INPUT FRAME fPage0 fiResultado-num  <= dec(ttDados.des-val-max) then do:
                    assign ttDados.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
                 end.
                 else do:
                     {utp/ut-liter.i Ensaio: * }
                     assign cTexto = return-value +  ttDados.cod-ensaio.
                     run utp/ut-msgs.p (input "show":U,
                                         input 30268,
                                         input ttDados.des-val-restdo + '~~~~' +
                                               cTexto).
                      IF return-value = "yes":U THEN DO:
                         assign ttDados.idi-estado-ensaio = 3. /*** Aprovado pelo Usu†rio ***/
                      end.
                      else do:
                          assign ttDados.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                      end.
                 end.
             end.
             else do:
                {utp/ut-liter.i Deve_ser_informado_um_valor_para_o_campo_Resultado! * }
                run utp/ut-msgs.p (input "show":U,
                                    input 17006,
                                    input return-value ).
                  assign fiTexto10:hidden in frame fpage0 = no.
                 return no-apply.

             end.
       end.
       when 2 then do:
          for first mab-restdo-tab
              where  mab-restdo-tab.num-tabela = int(ttDados.num-tabela) 
                and  mab-restdo-tab.des-restdo = cbResultado:screen-value in frame fPage0 no-lock:
              assign ttDados.des-val-restdo  = cbResultado:screen-value in frame fPage0.
          end.
          if avail mab-restdo-tab then do:
              if mab-restdo-tab.log-admit = true then do:
                assign ttDados.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
              end.
              else do:
                 {utp/ut-liter.i Ensaio: * }
                 assign cTexto = return-value +  ttDados.cod-ensaio.
                 run utp/ut-msgs.p (input "show":U,
                                     input 30268,
                                     input ttDados.des-val-restdo + '~~' +
                                           cTexto).
                  IF return-value = "yes":U THEN DO:
                     assign ttDados.idi-estado-ensaio = 3. /*** Aprovado pelo Usu†rio ***/
                  end.
                  else do:
                      assign ttDados.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                  end.
              end.
          end.
       end.  /*** if avail mab-restdo-tab ****/
      when 3 THEN DO:
          if input frame fPage0 fiResultado-txt <> "":U then do:
              assign ttDados.des-val-restdo =  input frame fPage0 fiResultado-txt.
              if INPUT FRAME fPage0 fiResultado-txt   >= STRING(ttDados.des-val-min)     
                 and INPUT FRAME fPage0 fiResultado-txt  <= STRING(ttDados.des-val-max) then do:
                 assign ttDados.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
              end.
              else do:
                  {utp/ut-liter.i Ensaio: * }
                  assign cTexto = return-value +  ttDados.cod-ensaio.
                  run utp/ut-msgs.p (input "show":U,
                                      input 30268,
                                      input ttDados.des-val-restdo + '~~~~' +
                                            cTexto).
                   IF return-value = "yes":U THEN DO:
                      assign ttDados.idi-estado-ensaio = 3. /*** Aprovado pelo Usu†rio ***/
                   end.
                   else do:
                       assign ttDados.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                   end.
              end.
             end.
             else do:
                {utp/ut-liter.i Deve_ser_informado_um_valor_para_o_campo_Resultado! * }
                run utp/ut-msgs.p (input "show":U,
                                    input 17006,
                                    input return-value ).
                 assign fiTexto10:hidden in frame fpage0 = no.
                 return no-apply.

             end.




    end.
    when 4 THEN DO:
         if input frame fPage0 fiResultado-dat <> ? then do:
            assign ttDados.des-val-restdo =  input frame fPage0 fiResultado-dat.
            if INPUT FRAME fPage0 fiResultado-dat   >= DATE(ttDados.des-val-min)     
               and INPUT FRAME fPage0 fiResultado-dat  <= DATE(ttDados.des-val-max) then do:
               assign ttDados.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
            end.
            else do:
                {utp/ut-liter.i Ensaio: * }
                assign cTexto = return-value +  ttDados.cod-ensaio.
                run utp/ut-msgs.p (input "show":U,
                                    input 30268,
                                    input ttDados.des-val-restdo + '~~~~' +
                                          cTexto).
                 IF return-value = "yes":U THEN DO:
                    assign ttDados.idi-estado-ensaio = 3. /*** Aprovado pelo Usu†rio ***/
                 end.
                 else do:
                     assign ttDados.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                 end.
            end.
         end.
        else do:
           {utp/ut-liter.i Deve_ser_informado_um_valor_para_o_campo_Resultado! * }
           run utp/ut-msgs.p (input "show":U,
                               input 17006,
                               input return-value ).
            assign fiTexto10:hidden in frame fpage0 = no.
            return no-apply.

        end.
  end.
 end case.  
 create  tt-Result.
 assign  tt-Result.num-amostra-oleo        = int(ttDados.cod-oficial:screen-value in browse brDetalhe) 
         tt-Result.cod-ensaio              = ttDados.cod-ensaio:screen-value in browse brDetalhe
         tt-Result.dat-restdo-ensaio       = ttDados.dat-restdo-ensaio
         tt-Result.hra-restdo-ensaio       = ttDados.hra-restdo-ensaio
         tt-Result.log-padrao              = ttDados.log-padrao 
         tt-Result.des-formato             = ttDados.des-formato
         tt-Result.des-val-max             = ttDados.des-val-max:screen-value in browse brDetalhe
         tt-Result.des-val-min             = ttDados.des-val-min:screen-value in browse brDetalhe 
         tt-Result.dsl-obs                 = ttDados.dsl-obs
         tt-Result.num-tabela              = int(ttDados.num-tabela:screen-value in browse brDetalhe)
         tt-Result.idi-estado-ensaio       = ttDados.idi-estado-ensaio
         tt-Result.des-val-restdo          = ttDados.des-val-restdo
         tt-Result.r-rowid                 = ttDados.r-rowid.

/*:T--- BO da tabela Resultado do Ensaio ---*/
IF NOT VALID-HANDLE(hDBOResult) OR
   hDBOResult:TYPE <> "PROCEDURE":U OR
   hDBOResult:FILE-NAME <> "frbo/bofr106.p":U THEN DO:
   run frbo/bofr106.p persistent set hDBOResult.
END.
RUN openQueryStatic IN hDBOResult (INPUT "Main":U) NO-ERROR.

/*seta o programa chamador para efeito de gravacao do cod-usuar-aprvdor*/
RUN setaPrograma IN hDBOResult (INPUT "ao0302.w":U).

SESSION:SET-WAIT-STATE("general":U).
 /*** Posiciona no Registro Lido ****/
 run repositionRecord in hDBOResult (input tt-Result.r-rowid).
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOResult.
/*--- Transfere temp-table tt-requisicao para o DBO ---*/
RUN setRecord IN hDBOResult (INPUT TABLE tt-Result).
/*--- Altera o registro corrente do DBO ---*/
RUN updateRecord IN hDBOResult.
/*--- Atualiza vari†vel cReturnAux com o conte£do do RETURN-VALUE ---*/
ASSIGN cReturnAux = RETURN-VALUE.
/*--- Verifica ocorrància de erros durante a gravaá∆o ---*/
IF cReturnAux = "NOK":U THEN DO:
    /*--- Retorna temp-table RowErrors do DBO ---*/
    RUN getRowErrors IN hDBOResult (OUTPUT TABLE RowErrors).
    /** Elimina todos os erros intrnos da BO (Navegaá∆o) **/
    for each  RowErrors
        where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
        delete RowErrors.
    end.
   IF CAN-FIND(FIRST RowErrors 
            WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
       /** Instancia aplicativo **/              
       {method/showmessage.i1}                   
       /** Mostra caixa com erros **/            
       {method/showmessage.i2 &Modal="YES"}      
       /** Limpa temp-tables de erros **/        
       empty temp-table RowErrors.               
       RETURN "NOK":U.
   end.
END.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).


 /** Resultados **/
if valid-handle(hDBOResult) THEN   
  run Destroy in hDBOResult.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de iniciar a tela
------------------------------------------------------------------------------*/
assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

create ttSelecao.
assign ttSelecao.empresa-ini      = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
       ttSelecao.empresa-fim      = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ" &else 999 &ENDIF
       ttSelecao.equipto-ini      = ""
       ttSelecao.equipto-fim      = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.docto-ini        = 0
       ttSelecao.docto-fim        = 999999999
       ttSelecao.modelo-ini       = ""
       ttSelecao.modelo-fim       = "ZZZZZZZZ"
       ttSelecao.amostra-ini      = ""
       ttSelecao.amostra-fim      = "ZZZZZZZZZZZ"
       ttSelecao.data-ini         = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
       ttSelecao.data-fim         = 12/31/9999
       ttSelecao.compto-ini       = ""
       ttSelecao.compto-fim       = "ZZZZZZZZ"
       ttSelecao.tp-mater-ini     = ""
       ttSelecao.tp-mater-fim     = "ZZZZZZZZ"
       ttSelecao.lubrific-ini     = 0
       ttSelecao.lubrific-fim     = 999999999
       ttSelecao.tag-ini          = ""
       ttSelecao.tag-fim          = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.cc-ini           = ""
       ttSelecao.cc-fim           = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.lPadrao          = yes
       ttSelecao.lNPadrao         = yes
       ttSelecao.lData            = yes
       ttSelecao.lTexto           = yes
       ttSelecao.lNumerico        = yes
       ttSelecao.lTabela          = yes
       ttSelecao.lAprovado        = no
       ttSelecao.lReprovado       = no
       ttSelecao.lPendente        = yes
       ttSelecao.lAprovUsuar      = no
       ttSelecao.lAmostAprovado   = no
       ttSelecao.lAmostReprovado  = no
       ttSelecao.lAmostPendente   = yes
       ttSelecao.lAmostAprovUsuar = NO
    &IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.unid-negoc-ini   = "":U
       ttSelecao.unid-negoc-fim   = "ZZZ":U
    &ENDIF
       . 

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRegistros wWindow 
PROCEDURE buscaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE rGoto            AS ROWID               NO-UNDO.
DEFINE VARIABLE iEstadoAmostra   AS INTEGER initial 0   NO-UNDO.
DEFINE VARIABLE iEstatoResultado AS INTEGER initial 0   NO-UNDO.

empty temp-table ttDadosAux.
empty temp-table tt-Result.

assign cNunControl = "":U.
/** Atualiza as variaveis ao clicar no tree-view **/
if cCodArmaz <> "":U and cCodPaiReg <> "":U then do:
    for each  ttDados
        where ttDados.p-image           = 12
        and   ttDados.cod-amostra-fisic = cCodArmaz
        and   ttDados.cod-dimens-pai    = cCodPaiReg
        and   ttDados.cod-oficial       = cDocto no-lock:
        create ttDadosAux.
        buffer-copy ttDados to ttDadosAux.
        assign cNunControl = ttDados.cod-amostra-fisic.
    END.
END.
else do: /** Busca pelo c¢digo digitado no v† para **/
    for each ttDados 
        where ttDados.p-image           = 12
        and   ttDados.cod-amostra-fisic = pNunAmostra
        and   ttDados.cod-oficial       = cDocto no-lock:
        create ttDadosAux.
        buffer-copy ttDados to ttDadosAux.
        assign cNunControl = ttDados.cod-amostra-fisic.
    END.
END.
/** Valida os resiultados - se existe algum padr∆o com o valor do rsultado em branco **/
run validaResultados in hDBOAmostra (input-output table ttDadosAux).

if return-value = "NOK":U then do:
    /*--- Retorna temp-table RowErrors do DBO ---*/
    RUN getRowErrors IN hDBOAmostra (OUTPUT TABLE RowErrors).
    /** Elimina todos os erros intrnos da BO (Navegaá∆o) **/
    for each  RowErrors
        where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
        delete RowErrors.
    END.
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U) then do:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="YES"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.
        RETURN "NOK":U.
    END.
END.
else do:
    assign iEstadoAmostra = 2.

    /** Valida o Status **/
    for each  ttDadosAux
        where ttDadosAux.idi-estado-ensaio = 4 exclusive-lock:
        {utp/ut-liter.i Ensaio: * }
        assign cTexto = return-value +  ttDadosAux.cod-ensaio.
        run utp/ut-msgs.p (input "show":U,
                           input 30268,
                           input ttDadosAux.des-val-restdo + '~~' +  cTexto).
        if return-value = "YES":U then do:
            assign ttDadosAux.idi-estado-ensaio = 3.
        END.
        ELSE DO:
            assign ttDadosAux.idi-estado-ensaio = 4.
        END.
        SESSION:SET-WAIT-STATE("GENERAL":U).
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN hDBOResult (INPUT Int(ttDadosAux.cod-oficial),
                                   input     ttDadosAux.cod-ensaio).
        run getRecord in hDBOResult (output table tt-Result).
        for first tt-Result exclusive-lock:
            assign tt-Result.idi-estado-ensaio = ttDadosAux.idi-estado-ensaio.
        END.
        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN hDBOResult.
        /*--- Transfere temp-table tt-requisicao para o DBO ---*/
        RUN setRecord IN hDBOResult (INPUT TABLE tt-Result).
        /*--- Altera o registro corrente do DBO ---*/
        RUN updateRecord IN hDBOResult.
        /*--- Atualiza vari†vel cReturnAux com o conte£do do RETURN-VALUE ---*/
        ASSIGN cReturnAux = RETURN-VALUE.
        /*--- Verifica ocorrància de erros durante a gravaá∆o ---*/
        IF cReturnAux = "NOK":U THEN DO:
            /*--- Retorna temp-table RowErrors do DBO ---*/
            RUN getRowErrors IN hDBOResult (OUTPUT TABLE RowErrors).
            /** Elimina todos os erros intrnos da BO (Navegaá∆o) **/
            for each  RowErrors
                where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
                delete RowErrors.
            END.
            IF CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
                /** Instancia aplicativo **/
                {method/showmessage.i1}
                /** Mostra caixa com erros **/
                {method/showmessage.i2 &Modal="YES"}
                /** Limpa temp-tables de erros **/
                empty temp-table RowErrors.
                RETURN "NOK":U.
            END.
        END.
        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).
    END. /** do for each ttDadosAux **/
END.
/** Busca por resultados aprovados pelo Usu†rio **/
run validaAmostra IN hDBOAmostra (input  TABLE ttDadosAux,
                                  output iEstadoAmostra).

/** Busca por resultados reprovados **/
if iEstadoAmostra  = 4 then do: /** Reprovado **/
    run utp/ut-msgs.p (input "show":U,
                       input 30272,
                       input cNunControl).
    if return-value = "yes":U THEN
        assign iEstadoAmostra = 3. /** Aprovado pelo Usu†rio **/
END.

IF iEstadoAmostra = 3 OR iEstadoAmostra = 4 THEN DO:
    IF iEstadoAmostra = 3 THEN DO:
        {utp/ut-liter.i Aprovada_pelo_Usu†rio *}
         
            
    END.
    ELSE DO:
        {utp/ut-liter.i Reprovada *}
    END.
    ASSIGN c-liter = RETURN-VALUE.
    /** Como amostra ficou Reprovada(4) ou Aprovada Pelo uUu†rio(3), pergunta ao usu†rio se quer criar Evento **/
    run utp/ut-msgs.p (input "show":U,
                       input 30274,
                       input c-liter).
    if return-value = "yes":U THEN
        run criaEvento in this-procedure.
END.

for first ttDadosAux
    where ttDadosAux.p-image     = 12
    and   ttDadosAux.cod-oficial = cDocto no-lock:
    empty temp-table ttAmostraAux.

    SESSION:SET-WAIT-STATE("GENERAL":U).
    /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
    RUN goToKey IN hDBOAmostra (INPUT Int(ttDadosAux.cod-oficial)).
    run getRecord in hDBOAmostra (output table ttAmostraAux).
    for first ttAmostraAux exclusive-lock:
        assign ttAmostraAux.idi-estado-amostra = iEstadoAmostra
               ttAmostraAux.num-docto-event    = iNumEvent.
    END.
    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN hDBOAmostra.
    /*--- Transfere temp-table tt-requisicao para o DBO ---*/
    RUN setRecord IN hDBOAmostra (INPUT TABLE ttAmostraAux).
    /*--- Altera o registro corrente do DBO ---*/
    RUN updateRecord IN hDBOAmostra.
    /*--- Atualiza vari†vel cReturnAux com o conte£do do RETURN-VALUE ---*/
    ASSIGN cReturnAux = RETURN-VALUE.
    /*--- Verifica ocorrància de erros durante a gravaá∆o ---*/
    IF cReturnAux = "NOK":U THEN DO:
        /*--- Retorna temp-table RowErrors do DBO ---*/
        RUN getRowErrors IN hDBOAmostra (OUTPUT TABLE RowErrors).
        /** Elimina todos os erros intrnos da BO (Navegaá∆o) **/
        for each  RowErrors
            where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
            delete RowErrors.
        END.
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
            /** Limpa temp-tables de erros **/
            empty temp-table RowErrors.
            RETURN "NOK":U.
        END.
    END.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaResultados wWindow 
PROCEDURE buscaResultados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pNumTabela as INTEGER                  no-undo.
DEFINE OUTPUT PARAMETER pLista     as CHARACTER format "x(60)" no-undo.

if can-find (first mab-tab-restdo
             where mab-tab-restdo.num-tabela = pNumTabela no-lock) then do:
    for first mab-tab-restdo fields(num-tabela)
        where mab-tab-restdo.num-tabela = pNumTabela no-lock:
    END.
    if avail mab-tab-restdo then do:
        for each  mab-restdo-tab
            where mab-restdo-tab.num-tabela = mab-tab-restdo.num-tabela no-lock:
            IF pLista = "" then
                assign pLista = mab-restdo-tab.des-restdo + "," + mab-restdo-tab.des-restdo.
            else
                assign pLista = pLista + "," + mab-restdo-tab.des-restdo + "," + mab-restdo-tab.des-restdo.
        END.
    END.
    else do:
        assign pLista = "":U.
    END.
END.
else do:
    assign pLista = "":U.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaValor wWindow 
PROCEDURE buscaValor :
/*------------------------------------------------------------------------------
  Purpose:     buscaValor
  Parameters:  entrada pValorDimensao = N£mero da dimens∆o escolhida 
  Notes:       Busca os c¢digos e descriá∆o das vis‰es escolhidas
------------------------------------------------------------------------------*/
define input parameter pValorDimensao as character format "x(40)" no-undo.

/** Zera vari†veis no in°cio **/
assign vCodigo    = "":U
       vDescricao = "":U
       iImage     = 0
       rRowid     = ?.

/** Verifica tipo de vis∆o (classificaá∆o) **/
case substring(trim(pValorDimensao),1,2):
    /** Tipo Material **/
    when "01":U then do:
        if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> mao-amostra-oleo.cod-tip-mater then do:
            for first mab-tip-mater fields(cod-tip-mater des-tip-mater)  
                where mab-tip-mater.cod-tip-mater = mao-amostra-oleo.cod-tip-mater no-lock:
            END.
        END.
        if avail mab-tip-mater then do:
            assign vCodigo    = mab-tip-mater.cod-tip-mater
                   vDescricao = mab-tip-mater.des-tip-mater
                   iImage     = 1
                   rRowid     = rowid(mab-tip-mater).
        end.
        ELSE DO:
            {utp/ut-liter.i "Tipo Material N∆o Encontrado"}
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 1
                   rRowid     = rowid(mao-ensaio).
        END.
    end.
    /** Empresa **/
    when "02":U then do:
        if not avail empresa or empresa.ep-codigo <> mao-amostra-oleo.ep-codigo then do:
            for first empresa fields(nome ep-codigo)  
                where empresa.ep-codigo = mao-amostra-oleo.ep-codigo no-lock:
            end.
        end.
        if avail empresa then do:
            assign vCodigo    = string(empresa.ep-codigo, "999")
                   vDescricao = empresa.nome
                   iImage     = 2
                   rRowid     = rowid(empresa).
        end.
        ELSE DO:
            {utp/ut-liter.i "Empresa N∆o Encontrada"}
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 2
                   rRowid     = rowid(mao-ensaio).
        END.
    end.
    /** Equipamento **/
    when "03":U then do:
        if not avail mab-eqpto or mab-eqpto.ep-codigo <> mao-amostra-oleo.ep-codigo
                               or mab-eqpto.cod-eqpto <> mao-amostra-oleo.cod-eqpto then do:
            for first mab-eqpto fields(cod-model ep-codigo cod-eqpto)  
                where mab-eqpto.ep-codigo = mao-amostra-oleo.ep-codigo
                AND   mab-eqpto.cod-eqpto = mao-amostra-oleo.cod-eqpto no-lock:
            END.
        END.
        if avail mab-eqpto then do:
            assign vCodigo    = string(mao-amostra-oleo.ep-codigo) + "-" + mao-amostra-oleo.cod-eqpto
                   iImage     = 3
                   rRowid     = rowid(mab-eqpto).
            if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
                for first mab-model fields(des-model cod-model un)  
                    where mab-model.cod-model = mab-eqpto.cod-model no-lock:
                end.
            end.
            if avail mab-model then do:
                assign vDescricao = mab-model.des-model.
            end.
        END.
        ELSE DO:
            {utp/ut-liter.i "Equipamento N∆o Encontrado"}
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 3
                   rRowid     = rowid(mao-ensaio).
        END.
    end.
    /** Modelo **/
    when "04":U then do:
        if not avail mab-eqpto or mab-eqpto.ep-codigo <> mao-amostra-oleo.ep-codigo
                               or mab-eqpto.cod-eqpto <> mao-amostra-oleo.cod-eqpto then do:
            for first mab-eqpto fields(cod-model ep-codigo cod-eqpto)
                where mab-eqpto.ep-codigo = mao-amostra-oleo.ep-codigo
                AND   mab-eqpto.cod-eqpto = mao-amostra-oleo.cod-eqpto no-lock:
            end.
        END.
        if avail mab-eqpto then do:
            if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
                for first mab-model fields(des-model cod-model un)  
                    where mab-model.cod-model = mab-eqpto.cod-model no-lock:
                end.
            end.
            if avail mab-model then do:
                assign vCodigo    = mab-model.cod-model
                       iImage     = 4
                       rRowid     = rowid(mab-model)
                       vDescricao = mab-model.des-model.
            end.
            ELSE DO:
                {utp/ut-liter.i "Modelo N∆o Encontrado"}
                assign vCodigo    = "_"
                       iImage     = 4
                       rRowid     = rowid(mao-ensaio)
                       vDescricao = RETURN-VALUE.
            END.
        END.
    end.
    /** Compartimento **/
    when "05":U then do:
        if not avail mab-comptmento or mab-comptmento.cod-comptmento <> mao-amostra-oleo.cod-comptmento then do:
            for first mab-comptmento fields(des-comptmento cod-comptmento)
                where mab-comptmento.cod-comptmento = mao-amostra-oleo.cod-comptmento no-lock:
            END.
        END.
        if avail mab-comptmento then do:
            assign vCodigo    = mao-amostra-oleo.cod-comptmento
                   vDescricao = mab-comptmento.des-comptmento
                   iImage     = 5
                   rRowid     = rowid(mab-comptmento).
        END.
        ELSE DO:
            {utp/ut-liter.i "Compartimento N∆o Encontrado"}
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 5
                   rRowid     = rowid(mao-ensaio).
        END.
    end.
    /** Data Amostra **/
    when "06":U then do:
        assign vCodigo    = substring(string(mao-amostra-oleo.val-dat-hora-invrtda),1,8)
               vDescricao = string(mao-amostra-oleo.dat-amostra,"99/99/9999")
               iImage     = 6
               rRowid     = rowid(mao-amostra-oleo).
    end.
    /** Lubrificaá∆o **/
    when "07":U then do:
            if not avail mab-item-lubrific  or mab-item-lubrific.cod-amostra-fisic <> mao-amostra-oleo.cod-amostra-fisic then do:
                for first mab-item-lubrific fields(num-docto ep-codigo cod-tip-mater cod-amostra-fisic cod-eqpto cod-comptmento )  
                    where mab-item-lubrific.num-docto      = mao-amostra-oleo.num-docto 
                    AND   mab-item-lubrific.cod-comptmento = mao-amostra-oleo.cod-comptmento no-lock:
                end. 
            end.
            if avail mab-item-lubrific then do:
               assign vCodigo    = string(mab-item-lubrific.num-docto)
                      iImage     = 7
                      rRowid     = rowid(mab-item-lubrific).
                for first mab-tip-mater fields(cod-tip-mater des-tip-mater)  
                    where mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater no-lock:
                end.
                if avail mab-tip-mater then do:
                    assign vDescricao = mab-tip-mater.des-tip-mater.
                end.      
            end.
            else do:
                {utp/ut-liter.i "N∆o_possui_Ficha_de_Lubrificaá∆o_associada"}
                assign vCodigo    = "_"
                       vDescricao = trim(return-value)
                       iImage     = 7
                       rRowid     = ?.
            end.
    end.
    /** N£mero da Amostra **/
    when "08":U then do:
            assign vCodigo    = mao-amostra-oleo.cod-amostra-fisic
                   vDescricao = "":U
                   iImage     = /*08*/ 8
                   rRowid     = rowid(mao-amostra-oleo).
    end.
    /** TAG **/
    WHEN "09":U THEN DO:
        IF NOT AVAIL tag OR tag.cd-tag <> cTag THEN DO:
            FOR FIRST tag WHERE
                tag.cd-tag = cTag NO-LOCK:
            END.
        END.
        IF AVAIL tag THEN DO:
            ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                   iImage     = 9
                   rRowid     = ROWID(tag)
                   vDescricao = tag.descricao.
        END.
        ELSE DO:
            {utp/ut-liter.i Tag_N∆o_Dispon°vel}
                ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                       vDescricao = RETURN-VALUE
                       iImage     = 9
                       rRowid     = ROWID(mab-abastec-lubrific).
        END.
    END.
    /** Centro de Custo **/
    WHEN "10":U THEN DO:              
        IF NOT AVAIL tt_ccusto_integr OR tt_ccusto_integr.ttv_cod_ccusto <> cCCCodigo THEN DO:
            FOR FIRST tt_ccusto_integr
                WHERE tt_ccusto_integr.ttv_cod_ccusto = cCCCodigo NO-LOCK:
            END.
        END.
        IF AVAIL tt_ccusto_integr THEN DO:
            ASSIGN vCodigo    = cCCCodigo
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 10
                   rRowid     = ROWID(tt_ccusto_integr).
        END.
        ELSE DO:
            {utp/ut-liter.i "Centro_Custo_N∆o_Dispon°vel"}
            ASSIGN vCodigo    = IF cCCCodigo = "" THEN "_" ELSE cCCCodigo
                   vDescricao = RETURN-VALUE 
                   iImage     = 10
                   rRowid     = ROWID(mab-eqpto).
        END.
    END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "11" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                if not avail mab-eqpto or mab-eqpto.ep-codigo <> mao-amostra-oleo.ep-codigo
                                       or mab-eqpto.cod-eqpto <> mao-amostra-oleo.cod-eqpto then do:
                    for first mab-eqpto fields(cod-model ep-codigo cod-eqpto)
                        where mab-eqpto.ep-codigo = mao-amostra-oleo.ep-codigo
                        AND   mab-eqpto.cod-eqpto = mao-amostra-oleo.cod-eqpto no-lock:
                    end.
                END.
                if avail mab-eqpto then do:                    
                    IF NOT AVAIL unid-negoc OR mab-eqpto.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                        FOR FIRST unid-negoc
                            WHERE unid-negoc.cod-unid-negoc = mab-eqpto.cod-unid-negoc NO-LOCK:
                        END.
                    END.
                    IF AVAIL unid-negoc THEN DO:
                        ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                               vDescricao = STRING(unid-negoc.des-unid-negoc)
                               iImage     = 11
                               rRowid     = ROWID(unid-negoc).
                    END.
                    ELSE DO:
                        {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                        ASSIGN vCodigo    = "_":U
                               vDescricao = RETURN-VALUE
                               iImage     = 11
                               rRowid     = ROWID(mab-eqpto).
                    END.
                END.
            END.
        END.
    &ENDIF
end case.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaFiltro wWindow 
PROCEDURE carregaFiltro :
/*------------------------------------------------------------------------------
  Purpose:     carregaFiltro
  Parameters:  entrada cNome = Nome do arquivo 
  Notes:       Importa arquivo de configuraá‰es da consulta 
------------------------------------------------------------------------------*/
define input parameter cNome  as character no-undo.

define variable c-linha as char no-undo.

/** Limpa as vis‰es **/
EMPTY TEMP-TABLE ttVisao.

input from value (cNome).
/** Busca os parÉmetros e seleá‰es **/
for first ttSelecao exclusive-lock:
    import unformatted c-linha.
    assign c-linha                     = replace (c-linha, chr(34), "")
           ttSelecao.empresa-ini       = &IF "{&mguni_version}" >= "2.071" &THEN entry(1,c-linha,";") &else int(entry(1,c-linha,";")) &ENDIF 
           ttSelecao.empresa-fim       = &IF "{&mguni_version}" >= "2.071" &THEN entry(2,c-linha,";") &else int(entry(2,c-linha,";")) &ENDIF 
           ttSelecao.equipto-ini       = entry(3,c-linha,";")
           ttSelecao.equipto-fim       = entry(4,c-linha,";")   
           ttSelecao.docto-ini         = int(entry(5,c-linha,";"))    
           ttSelecao.docto-fim         = int(entry(6,c-linha,";"))    
           ttSelecao.modelo-ini        = entry(7,c-linha,";")    
           ttSelecao.modelo-fim        = entry(8,c-linha,";")    
           ttSelecao.amostra-ini       = entry(9,c-linha,";")          
           ttSelecao.amostra-fim       = entry(10,c-linha,";")          
           ttSelecao.data-ini          = date(entry(11,c-linha,";"))          
           ttSelecao.data-fim          = date(entry(12,c-linha,";"))          
           ttSelecao.compto-ini        = entry(13,c-linha,";")          
           ttSelecao.compto-fim        = entry(14,c-linha,";")          
           ttSelecao.tp-mater-ini      = entry(15,c-linha,";")          
           ttSelecao.tp-mater-fim      = entry(16,c-linha,";")          
           ttSelecao.lubrific-ini      = INT(entry(17,c-linha,";"))          
           ttSelecao.lubrific-fim      = INT(entry(18,c-linha,";"))
           ttSelecao.tag-ini           = entry(19,c-linha,";") 
           ttSelecao.tag-fim           = entry(20,c-linha,";") 
           ttSelecao.cc-ini            = entry(21,c-linha,";") 
           ttSelecao.cc-fim            = entry(22,c-linha,";") 
           ttSelecao.lPadrao           = (entry(23,c-linha,";") = "yes")
           ttSelecao.lNPadrao          = (entry(24,c-linha,";") = "yes")
           ttSelecao.lData             = (entry(25,c-linha,";") = "yes")
           ttSelecao.lTexto            = (entry(26,c-linha,";") = "yes")
           ttSelecao.lNumerico         = (entry(27,c-linha,";") = "yes")
           ttSelecao.lTabela           = (entry(28,c-linha,";") = "yes")
           ttSelecao.lAprovado         = (entry(29,c-linha,";") = "yes")
           ttSelecao.lReprovado        = (entry(30,c-linha,";") = "yes")
           ttSelecao.lPendente         = (entry(31,c-linha,";") = "yes")
           ttSelecao.lAprovUsuar       = (entry(32,c-linha,";") = "yes")
           ttSelecao.lAmostAprovado    = (entry(33,c-linha,";") = "yes")
           ttSelecao.lAmostReprovado   = (entry(34,c-linha,";") = "yes")
           ttSelecao.lAmostPendente    = (entry(35,c-linha,";") = "yes")
           ttSelecao.lAmostAprovUsuar  = (entry(36,c-linha,";") = "yes").

    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao.unid-negoc-ini = entry(37,c-linha,";")
                   ttSelecao.unid-negoc-fim = entry(38,c-linha,";").
        &ENDIF
    END.
end.

repeat:
    /** Busca as vis‰es **/
    import unformatted c-linha.
    assign c-linha = replace (c-linha, chr(34), "").
    if num-entries (c-linha, ";") = 2 then do:
        create ttVisao.
        assign ttVisao.dimensao  = entry (1, c-linha, ";")
               ttVisao.sequencia = int (entry (2, c-linha, ";")).
    end.
end.

input close.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consultaAmostra wWindow 
PROCEDURE consultaAmostra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProgram AS HANDLE NO-UNDO.

  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /*--- Executa programa de inclus∆o de filho ---*/
  RUN aop/ao0601.w PERSISTENT SET hProgram.

  /** Validaá∆o do Handle **/
  IF VALID-HANDLE(hProgram) AND
     hProgram:Type = "PROCEDURE":U AND
     hProgram:FILE-NAME = "aop/ao0601.w":U THEN do:
      /*--- Inicializa programa de inclus∆o de filho ---*/
      RUN initializeInterface IN hProgram.
      /*:T Reposiciona registro com base em um rowid */
      RUN inicializaPrograma IN hProgram (INPUT int(ttDados.ep-codigo),
                                          input ttDados.cod-eqpto,
                                          input ttDados.cod-comptmento).
  end.
  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U).

  wait-for "CLOSE":U of hProgram.

  if valid-handle (hProgram) then
      delete procedure hProgram.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaEvento wWindow 
PROCEDURE criaEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hEvento      AS HANDLE     NO-UNDO.
/****Limpa as variaveis *************/
assign cValorParam   = "":U
       iEpCodigo     = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF 
       cCodEqpto     = "":U
       cCodSubSist   = "":U
       cCodEvento    = "":U
       cObs          = "":U
       iNumEvent     = 0 
       cValorParam-2 = 0.

/**** Busca parametro ********/
for first mab-param fields(des-valor)
    where mab-param.cdn-param = 17 no-lock: 
    assign cValorParam = mab-param.des-valor.
end.

for first mab-param fields(des-valor)
    where mab-param.cdn-param = 21 no-lock: 
    assign cValorParam-2 = int(mab-param.des-valor).
end.

/*Conforme conversado com Ademar, ser† posicionado no primeiro registro da ttDadosAux para buscar as informaá‰es utilizadas na logica abaixo.
TambÇm esta sendo alterado */
FOR FIRST ttDadosAux NO-LOCK
    WHERE ttDadosAux.p-image = 12.
END.
FOR FIRST ttDados NO-LOCK
    WHERE ttDados.p-image = 8.
    ASSIGN i-num-amostra-oleo = ttDados.num-amostra-oleo.
END.

/**** Busca por resultados repr2ovados ****/
FOR FIRST  mao-restdo-ensaio 
    WHERE mao-restdo-ensaio.num-amostra-oleo = i-num-amostra-oleo
    and  (mao-restdo-ensaio.idi-estado-ensaio = 3
    OR    mao-restdo-ensaio.idi-estado-ensaio = 4) NO-LOCK:

       if avail mao-restdo-ensaio then do:
          for first mab-eqpto fields (cod-model ep-codigo cod-eqpto)
              where mab-eqpto.ep-codigo = ttDadosAux.ep-codigo
              and   mab-eqpto.cod-eqpto = ttDadosAux.cod-eqpto no-lock:
          end.
             assign  iEpCodigo    = mab-eqpto.ep-codigo
                     cCodEqpto    = mab-eqpto.cod-eqpto.
             for first mab-comptmento-eqpto fields (cod-sub-sist cod-tip-mater)
                 where mab-comptmento-eqpto.ep-codigo      =  mab-eqpto.ep-codigo
                 and   mab-comptmento-eqpto.cod-eqpto      =  mab-eqpto.cod-eqpto
                 AND   mab-comptmento-eqpto.cod-comptmento =  ttDadosAux.cod-comptmento no-lock:
             end.
             if avail mab-comptmento-eqpto then do:
                assign cCodSubSist = mab-comptmento-eqpto.cod-sub-sist.
             end.
             for first mab-model fields(cod-model)  
                 where mab-model.cod-model = mab-eqpto.cod-model no-lock:
              end.
       
              if avail mab-model then do:
                 for first mao-ensaio-padr fields (cod-ensaio cod-model cod-event-troca dsl-obs-troca cod-event-nao-troca dsl-obs-nao-troca)
                     where mao-ensaio-padr.cod-ensaio = mao-restdo-ensaio.cod-ensaio 
                       AND mao-ensaio-padr.cod-tip-mater = mab-comptmento-eqpto.cod-tip-mater
                     and  (mao-ensaio-padr.cod-model  = mab-model.cod-model
                       OR  mao-ensaio-padr.cod-model  = "") no-lock:
                 end.
                 for first mab-period-manut fields (val-km-real val-km-padr val-km-estimad)
                     where mab-period-manut.ep-codigo    =  mab-eqpto.ep-codigo
                     and mab-period-manut.cod-eqpto      =  mab-eqpto.cod-eqpto
                     and mab-period-manut.cod-comptmento =  ttDadosAux.cod-comptmento 
                     and mab-period-manut.cod-evento     =  cValorParam  no-lock:
                     if mab-period-manut.val-km-real >= (mab-period-manut.val-km-padr - mab-period-manut.val-km-estimad) then do:
                        if avail mao-ensaio-padr then do:
                           assign cCodEvento =  mao-ensaio-padr.cod-event-nao-troca 
                                  cObs       =  mao-ensaio-padr.dsl-obs-nao-troca.
                        end.
                        else do:
                            {utp/ut-liter.i Realizar_troca_de_‡leo_do_compartimento * }
                            assign cCodEvento =  cValorParam
                                   cObs       = return-value + ": " + ttDadosAux.cod-comptmento.
                        end.
                     end.
                     else do:
                        if avail mao-ensaio-padr then do:
                            assign cCodEvento =  mao-ensaio-padr.cod-event-troca 
                                   cObs       =  mao-ensaio-padr.dsl-obs-troca.
                        end.
                        else do:
                            {utp/ut-liter.i Troca_de_OlÇo_j†_realizada_para_o_compartimento * }
                           /**** Busca parametro****/
                           for first mab-param fields(des-valor)
                               where mab-param.cdn-param = 19 no-lock: 
                               assign cValorParam = mab-param.des-valor.
                           END.
                            assign cCodEvento =  cValorParam
                                   cObs       = return-value + ": " + ttDadosAux.cod-comptmento.
                        END.
                     END.
                     END.
                 END.
                     IF NOT avail mab-period-manut then do:
                           assign cCodEvento =  cValorParam
                                  cObs       =  return-value + ": " + ttDadosAux.cod-comptmento.
                     end.
        
        
        
           END.
    END.

SESSION:SET-WAIT-STATE("GENERAL":U).
 assign {&window-name}:sensitive = no.
 /*--- Executa programa de inclusío de Eventos ---*/
 RUN abp/ab0303.w PERSISTENT SET hEvento.
 /* alterado por Valdir (tech264) novo m≤todo de teste do valid-handle */
 IF VALID-HANDLE(hEvento) AND
 hEvento:Type = "PROCEDURE":U AND
 hEvento:FILE-NAME = "abp/ab0303.w":U THEN
 /*--- Inicializa programa de Criaá∆o de Eventos ---*/
   RUN initializeInterface IN hEvento.
    /***Posiciona no registro selecionado pelo usu†rio****/
   run inicializaEventoAmostra in hEvento (input iEpCodigo,
                                           input cCodEqpto,
                                           input cCodSubSist,
                                           input cCodEvento,
                                           input cValorParam-2,
                                           input cObs,      
                                           OUTPUT iNumEvent).
  /*--- Seta cursor do mouse para normal ---*/
 SESSION:SET-WAIT-STATE("":U).
 wait-for "CLOSE":U of hEvento.
 assign {&window-name}:sensitive = yes.

 if valid-handle(hEvento) then
    delete procedure hEvento.

   
return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTreeView wWindow 
PROCEDURE criaTreeView :
/*------------------------------------------------------------------------------
  Purpose:     criaTreeView
  Parameters:  <none>
  Notes:       Cria as linhas do tree-view
------------------------------------------------------------------------------*/
 define variable iQtSeq   as integer initial 0 no-undo.
 define variable c-texto as character no-undo.
 
 /** Limpa o tree-view **/
 RUN emptyTree   IN  h-4gltreeview.
 ASSIGN  c-codigo-node   =   "". 
 
 assign i-cont   = 0.
 /** Verifica se existem vis‰es escolhidas **/
 for last ttVisao fields(sequencia) no-lock:
     assign iQtSeq = ttVisao.sequencia. 
 end.
 if iQtSeq = 0 then return.
 /** Busca os dados criados **/
 for each  ttDados fields(cod-oficial desc-dimensao p-image 
                          seq-tree cod-dimens-pai r-rowid)
     where ttDados.sequencia <= iQtSeq exclusive-lock:
         /** Conta sequàncias de linhas **/ 
         assign i-cont   = i-cont   + 1.
         assign ttDados.seq-tree = i-cont.
         /** define texto do n¢ **/
         if ttDados.p-image = 8 then do:   /** N£mero_da_Amostra    **/  
              {utp/ut-liter.i N£mero_Amostra * }
             ASSIGN c-texto = trim(return-value) + ' : ' +  string(ttDados.cod-oficial). /*** Atualiza somente com o c¢digo para mostrar no TreeView ***/
         end.
         else do:
            if ttDados.p-image = 6 then do: /**** Data ****/
               ASSIGN c-texto = ttDados.desc-dimensao. /***descriá∆o ****/
            end.
            else do:
               ASSIGN c-texto = string(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao. /*** Mostra c¢digo e descriá∆o ****/
            end.
         end.
         /** Inclui primeira linha **/
         if ttDados.sequencia = 1 then do:
            RUN pi-create-node  ("i" + STRING(i-cont), "" , c-texto, fnImages(ttDados.p-image), "") .          

            /** Guarda chave (rowid) da temp-table no tree-view **/
            DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + ",").
            IF  ttDados.r-rowid <>  ?   THEN    DO:
                DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + "," + STRING(ttDados.r-rowid)).
                ASSIGN  rRowid3         =   ROWID(ttDados)
                        ttDados.i-cont  =   i-cont.
            END.
         end.
         else do:
             /** Busca filhos da vis∆o escolhida **/
             for first bfttDados fields(seq-tree)
                 where bfttDados.cod-dimensao = ttDados.cod-dimens-pai exclusive-lock:
                 RUN pi-create-node  ("i" + STRING(i-cont), "i" + STRING(bfttDados.seq-tree), c-texto, fnImages(ttDados.p-image), "").

                 /** Guarda chave (rowid) da temp-table no tree-view **/
                 DYNAMIC-FUNCTION('setNodeTag'  IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + ",").
                 IF ttDados.r-rowid <>  ?   THEN    DO:
                    DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + "," + STRING(ttDados.r-rowid)).
                    ASSIGN  ttDados.i-cont  =   i-cont.
                 END.
             end.
         end. 
 end.

 RUN pi-atualizaTreeview.

 RUN applyEntry  IN  h-4gltreeview   (INPUT  "").

 /** Posiciona o Tree-View no ultimo lido **/
 IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
     DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, c-codigo-node).
 END.

 return "OK":U.


end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaVisoes wWindow 
PROCEDURE criaVisoes :
/*------------------------------------------------------------------------------
  Purpose:     criaVisoes
  Parameters:  <none>
  Notes:       Cria as vis‰es se n∆o foram selecionadas 
------------------------------------------------------------------------------*/
create ttVisao.
assign ttVisao.dimensao  = '08 ' + fnLabels(8)
       ttVisao.sequencia = 1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expandeItem wWindow 
PROCEDURE expandeItem :
/*------------------------------------------------------------------------------
  Purpose:     expandeItem
  Parameters:  <none>
  Notes:       Expande o tree-view
------------------------------------------------------------------------------*/
def input param p-node   as com-handle no-undo.
def input param p-expcon as log        no-undo.

def var h-child as com-handle no-undo.
def var i-aux   as int        no-undo.

assign p-node:Expanded = p-expcon
       h-child         = p-node:Child.

do i-aux = 1 to p-node:Children:
    assign h-child = h-child:next.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalizaHandle wWindow 
PROCEDURE finalizaHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Erros **/
{method/showmessage.i3}

/** Amostra **/
if valid-handle(hDBOAmostra) THEN   
    run Destroy in hDBOAmostra.


/**Resultados **/
if valid-handle(hDBOResult) THEN   
    run Destroy in hDBOResult.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wWindow 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bfttDados3 FOR ttDados.

       DEFINE BUTTON btGoToCancel AUTO-END-KEY 
            LABEL "&Cancelar":U 
            SIZE 10 BY 1
            BGCOLOR 8.

       DEFINE BUTTON btGoToOK AUTO-GO 
            LABEL "&OK":U 
            SIZE 10 BY 1
            BGCOLOR 8.

       DEFINE RECTANGLE rtGoToButton
            EDGE-PIXELS 2 GRAPHIC-EDGE  
            SIZE 58 BY 1.42
            BGCOLOR 7.

       DEFINE VARIABLE fiAmostra AS char VIEW-AS FILL-IN SIZE 12 BY .88 NO-UNDO.

       DEFINE FRAME fGoToRecord
           fiAmostra   AT ROW 1.21 COL 8.14 FORMAT "x(12)"  SKIP (0.3) 
           btGoToOK          AT ROW 2.63 COL 2.14
           btGoToCancel      AT ROW 2.63 COL 13
           rtGoToButton      AT ROW 2.38 COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                THREE-D SCROLLABLE FONT 1
                DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

        run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
        {utp/ut-liter.i V†_Para_Amostra *}
        assign frame fGoToRecord:title = return-value.

       {utp/ut-liter.i Numero_Amostra *}
       ASSIGN fiAmostra:LABEL IN FRAME fGoToRecord = RETURN-VALUE.

       ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
       ASSIGN fiAmostra .
       for first mao-amostra-oleo
           where mao-amostra-oleo.cod-amostra-fisic = input frame fGoToRecord fiAmostra no-lock:
       end.
       IF NOT AVAIL mao-amostra-oleo  THEN DO:
           {utp/ut-liter.i N£mero_Amostra * }
           RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
           RETURN NO-APPLY.
       END.
       ELSE DO:  /*encontrou amostra para o cod digitado, verificando se a mesma possui ensaios cadastrados*/
           IF NOT CAN-FIND(FIRST mao-restdo-ensaio 
                           WHERE mao-restdo-ensaio.num-amostra-oleo = mao-amostra-oleo.num-amostra-oleo NO-LOCK) THEN DO:
               {utp/ut-liter.i N∆o_h†_Ensaios_cadastrados_para_a_Amostra_Informada *}
               RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT RETURN-VALUE + "~~" + RETURN-VALUE ).
               RETURN NO-APPLY.
           END.
           ELSE DO:
              /*encontrou uma amostra com resultados cadastrados, entao gera informacoes na tela*/
              ASSIGN pNunAmostra = mao-amostra-oleo.cod-amostra-fisic.
              RUN gotoTreeView  (input pNunAmostra,
                                 input rowid(mao-amostra-oleo) ).
           END.

       END.


           APPLY "GO":U TO FRAME fGoToRecord.
       END.

       ENABLE fiAmostra  btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 
      WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gotoTreeView wWindow 
PROCEDURE gotoTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNunAmostra like  mao-amostra-oleo.cod-amostra-fisic no-undo.
def input param pRowid as rowid no-undo.
DEFINE VARIABLE c-chave AS CHARACTER  NO-UNDO.
for first ttDados exclusive-lock:
end.
if not avail ttDados then do:
   run piCriaRegistro  in this-procedure (pNunAmostra) .
    /** Busca Registro com rowid **/
    for first bfttDados 
        where rowid(bfttDados) = rRowid3 no-lock:
    end.
    /** Verifica se ele contÇm filhos **/
    for first ttDados
        where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
    end.
    /** Mostra registros no browse **/
    run piBrowseAtualiza in this-procedure.
    apply "focus":U to brDetalhe in frame fpage0.
end.
else do:
      if not can-find (first bfttDados
                       where bfttDados.p-image   = 8
                       and bfttDados.cod-oficial = pNunAmostra no-lock)  then do:
                        run utp/ut-msgs.p (input "show":U,
                                         input 30326,
                                         input pNunAmostra).
                    if return-value = "YES":U then do:
                         run piCriaRegistro  in this-procedure (pNunAmostra) .
                        /** Busca Registro com rowid **/
                        for first bfttDados 
                            where rowid(bfttDados) = rRowid3 no-lock:
                        end.
                        /** Verifica se ele contÇm filhos **/
                        for first ttDados
                            where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
                        end.
                        /** Mostra registros no browse **/
                        run piBrowseAtualiza in this-procedure.
                        apply "focus":U to brDetalhe in frame fpage0.
                    end.
                    else do:
                       return "NOK":U.
                    end.
      end.
      else do:
         /** Busca os dados criados **/
         for each bfttDados
             where bfttDados.p-image     = 8 
             and   bfttDados.cod-oficial = pNunAmostra no-lock:
             /** Verifica se ele contÇm filhos **/
                for first ttDados
                    where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
                end.
                /** Mostra registros no browse **/
                run piBrowseAtualiza in this-procedure.
               /** Posiciona o Tree-View no £ltimo lido **/
                if bfttDados.sequencia = 1 then do:
                    IF  DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, "i" + STRING(bfttDados.i-cont)) THEN    DO:
                        /** Seleciona item **/
                        DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(bfttDados.i-cont)).

                        /** Atualiza Browse **/
                        RUN pi-ClickTreeView.
                    END.
               end.
               else do:
                   /** Seleciona item **/
                   DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(bfttDados.i-cont)).

                   /** Atualiza Browse **/
                   RUN pi-ClickTreeView.
               end.
         end.
     end.
end.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaHandle wWindow 
PROCEDURE inicializaHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


 /*:T--- BO da tabela mao-amostra-oleo ---*/
 IF NOT VALID-HANDLE(hDBOAmostra) OR
    hDBOAmostra:TYPE <> "PROCEDURE":U OR
    hDBOAmostra:FILE-NAME <> "frbo/bofr105.p":U THEN DO:
    run frbo/bofr105.p persistent set hDBOAmostra.
 END.
 RUN openQueryStatic IN hDBOAmostra (INPUT "Main":U) NO-ERROR.

/*:T--- BO da tabela mao-amostra-oleo ---*/
 IF NOT VALID-HANDLE(hDBOResult) OR
    hDBOResult:TYPE <> "PROCEDURE":U OR
    hDBOResult:FILE-NAME <> "frbo/bofr106.p":U THEN DO:
    run frbo/bofr106.p persistent set hDBOResult.
 END.
 RUN openQueryStatic IN hDBOResult (INPUT "Main":U) NO-ERROR.


/*setando na bo o programa chamador, para que possa fazer a gravaá∆o do cod-usuar-aprvdor*/
RUN setaPrograma IN hDBOAmostra (INPUT "ao0302.w":U).
RUN setaPrograma IN hDBOResult (INPUT "ao0302.w":U).


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraErros wWindow 
PROCEDURE mostraErros :
/*------------------------------------------------------------------------------
  Purpose:     mostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
/** Instancia aplicativo **/
{method/showmessage.i1}
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
empty temp-table RowErrors.

apply "ENTRY":U to {&window-name}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ClickTreeView wWindow 
PROCEDURE pi-ClickTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE rRow     AS ROWID      NO-UNDO.
    
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN    DO:

        /** Guarda rowid do tree-view **/
        ASSIGN  rRow        =   TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
    
        /** Busca Registro com rowid **/
        FOR FIRST   bfttDados 
            WHERE   ROWID(bfttDados)    =   rRow NO-LOCK:
            ASSIGN  cCodArmaz               =   bfttDados.cod-oficial
                    cCodPaiReg              =   bfttDados.cod-dimensao
                    i-image                 =   bfttDados.p-image
                    num-ult-amostra-oleo    =   bfttDados.num-amostra-oleo.
        END.

        /*Desabilta os botoes de modificacao*/
        APPLY   "choose":U  TO  btCancela   IN  FRAME   fPage0.
        ASSIGN  btModifica:SENSITIVE        IN  FRAME   fPage0  =   NO
                btDetalhe:SENSITIVE         IN  FRAME   fPage0  =   NO
                btCarga:SENSITIVE           IN  FRAME   fPage0  =   NO
                btAprova:SENSITIVE          IN  FRAME   fPage0  =   NO.

        /** Verifica se ele cont≤m filhos **/
        FOR FIRST   ttDados
            WHERE   ttDados.cod-dimens-pai  =   bfttDados.cod-dimensao NO-LOCK:
        END.
    
        /** Mostra registros no browse **/
        RUN piBrowseAtualiza    IN  THIS-PROCEDURE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CtrlPopupTreeView wWindow 
PROCEDURE pi-CtrlPopupTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT   PARAMETER   pcAction    AS  CHARACTER   NO-UNDO.
    DEFINE  INPUT   PARAMETER   pcEvent     AS  CHARACTER   NO-UNDO.
    DEFINE  INPUT   PARAMETER   pcNodeKey   AS  CHARACTER   NO-UNDO.

    DEFINE  VARIABLE    cListPopup  AS  CHARACTER   NO-UNDO.
    DEFINE  VARIABLE    cExpande    AS  CHARACTER   NO-UNDO.
    DEFINE  VARIABLE    cContrai    AS  CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Expande"}
    ASSIGN  cExpande    =   RETURN-VALUE.
    {utp/ut-liter.i "Contrai"}
    ASSIGN  cContrai    =   RETURN-VALUE.

    IF  pcAction = "build" THEN DO:
        IF  DYNAMIC-FUNCTION('isNodeExpanded' IN h-4gltreeview, pcNodeKey) THEN
            ASSIGN cListPopup = cContrai + CHR(1) + "menuContrair".
        ELSE
            ASSIGN cListPopup = cExpande + CHR(1) + "menuExpandir".

        RETURN  cListPopup.
    END.

    IF  pcAction    =   "choose" THEN DO:
        CASE    pcEvent:
            WHEN    "menuContrair"  THEN    DYNAMIC-FUNCTION('collapseNode' IN h-4gltreeview, pcNodeKey, "refresh").
            WHEN    "menuExpandir"  THEN    DYNAMIC-FUNCTION('expandNode'   IN h-4gltreeview, pcNodeKey, "refresh").
        END CASE.

        RETURN.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizar wWindow 
PROCEDURE piAtualizar :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizar
  Parameters:  
  Notes:       Busca os dados e atualiza o programa
------------------------------------------------------------------------------*/
DEFINE VARIABLE rRow   AS ROWID  NO-UNDO.
DEFINE VARIABLE hAcomp AS HANDLE NO-UNDO.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}

/*Limpa os campos em tela*/
assign fiData:SCREEN-VALUE IN FRAME fPage0   = "":U
       fiData-2:SCREEN-VALUE IN FRAME fPage0 = "":U
       fiHora            =    "":U
       fiAmostra         =    "":U
       fiEmpresa         =    "":U
       fiEquipamento     =    "":U
       fiCompto          =    "":U
       fiTpMater         =    "":U
       fiQtde            =    0.00
       fiLubrific        =    "":U
       fiStatus          =    "":U
       fiDescMatl        =    "":U
       fiDescEqpto       =    "":U
       fiDescCompto      =    "":U
       fiDescLubrific    =    "":U.

disp fiHora 
     fiAmostra        
     fiEmpresa        
     fiEquipamento    
     fiCompto         
     fiTpMater         
     fiQtde           
     fiLubrific       
     fiStatus         
     fiDescMatl       
     fiDescEqpto      
     fiDescCompto     
     fiDescLubrific with frame fPage0.

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run criaVisoes in this-procedure.
end.
/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.
/** Guarda a £ltima vis∆o **/
assign iVisao = 0.
for last ttVisao no-lock:
    assign iVisao = ttVisao.sequencia.
end.

/** Acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
{utp/ut-liter.i "Resultado dos Ensaios"}
RUN pi-inicializar IN hAcomp (trim(return-value)).

blk_ensaios:
DO on stop undo, return "NOK":U:
    /** Busca as informaá‰es conforme parametrizaá∆o **/
    for each  mao-amostra-oleo
        where mao-amostra-oleo.num-amostra-oleo    >= ttSelecao.docto-ini 
        and   mao-amostra-oleo.num-amostra-oleo    <= ttSelecao.docto-fim 
        and   mao-amostra-oleo.ep-codigo           >= ttSelecao.empresa-ini 
        and   mao-amostra-oleo.ep-codigo           <= ttSelecao.empresa-fim 
        and   mao-amostra-oleo.cod-eqpto           >= ttSelecao.equipto-ini 
        and   mao-amostra-oleo.cod-eqpto           <= ttSelecao.equipto-fim 
        and   mao-amostra-oleo.cod-comptmento      >= ttSelecao.compto-ini   
        and   mao-amostra-oleo.cod-comptmento      <= ttSelecao.compto-fim   
        and   mao-amostra-oleo.cod-tip-mater       >= ttSelecao.tp-mater-ini 
        and   mao-amostra-oleo.cod-tip-mater       <= ttSelecao.tp-mater-fim 
        and   mao-amostra-oleo.cod-amostra-fisic   >= ttSelecao.amostra-ini 
        and   mao-amostra-oleo.cod-amostra-fisic   <= ttSelecao.amostra-fim 
        and   mao-amostra-oleo.dat-amostra         >= ttSelecao.data-ini 
        and   mao-amostra-oleo.dat-amostra         <= ttSelecao.data-fim 
        and   mao-amostra-oleo.num-docto           >= ttSelecao.lubrific-ini
        and   mao-amostra-oleo.num-docto           <= ttSelecao.lubrific-fim
        and ((mao-amostra-oleo.idi-estado-amostra   = 1 and ttSelecao.lAmostPendente )  /** Pendente **/
        or   (mao-amostra-oleo.idi-estado-amostra   = 2 and ttSelecao.lAmostAprovado )  /** Aprovado**/
        or   (mao-amostra-oleo.idi-estado-amostra   = 3 and ttSelecao.lAmostAprovUsuar) /** Aprovado pelo Usu†rio **/
        or   (mao-amostra-oleo.idi-estado-amostra   = 4 and ttSelecao.lAmostReprovado)) /** Reprovado **/
        no-lock:

        find first mab-eqpto
            where mab-eqpto.cod-eqpto = mao-amostra-oleo.cod-eqpto
            and   mab-eqpto.ep-codigo = mao-amostra-oleo.ep-codigo no-lock no-error.

        if avail mab-eqpto then do:
            for last mab-histor-ativid
                where mab-histor-ativid.cod-eqpto     = mab-eqpto.cod-eqpto
                and   mab-histor-ativid.ep-codigo     = mab-eqpto.ep-codigo
                and   mab-histor-ativid.dat-cadastro <= mao-amostra-oleo.dat-amostra no-lock.
            end.

            if avail mab-histor-ativid then do:
                assign cTag      = mab-histor-ativid.cd-tag
                       cCCCodigo = mab-histor-ativid.cc-codigo.

                &IF DEFINED(bf_mnt_ems206b) &THEN
                    ASSIGN cUnidNegoc = mab-histor-ativid.cod-unid-negoc.
                &ENDIF
            end.

            else do:
                for last mab-histor-ativid
                    where mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto 
                    and   mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo no-lock:
                end.
                if avail mab-histor-ativid then do:
                    assign cTag      = mab-histor-ativid.cd-tag
                           cCCCodigo = mab-histor-ativid.cc-codigo.

                    &IF DEFINED(bf_mnt_ems206b) &THEN
                        ASSIGN cUnidNegoc = mab-histor-ativid.cod-unid-negoc.
                    &ENDIF
                end.
                else do:
                    assign cTag      = mab-eqpto.cd-tag
                           cCCCodigo = mab-eqpto.cc-codigo.

                    &IF DEFINED(bf_mnt_ems206b) &THEN
                        ASSIGN cUnidNegoc = mab-eqpto.cod-unid-negoc.
                    &ENDIF
                end.
            end.

            if cTag      < ttSelecao.tag-ini or cTag      > ttSelecao.tag-fim then next.
            if cCCCodigo < ttSelecao.cc-ini  or cCCCodigo > ttSelecao.cc-fim  then next.

            IF l-usa-unid-negoc THEN DO:
                &IF DEFINED(bf_mnt_ems206b) &THEN
                    if cUnidNegoc < ttSelecao.unid-negoc-ini  or cUnidNegoc > ttSelecao.unid-negoc-fim then next.
                &ENDIF
            END.
        end.

       /**********************************************************************************************
       ********* Busca os Resultados dos ensaios para a amostrade ‡leo *******************************
       **********************************************************************************************/
        blk-Resultado:
        for each mao-restdo-ensaio
            where mao-restdo-ensaio.num-amostra-oleo    = mao-amostra-oleo.num-amostra-oleo
            and ((mao-restdo-ensaio.idi-estado-ensaio   = 1 and ttSelecao.lPendente )    /** Pendente **/
            or   (mao-restdo-ensaio.idi-estado-ensaio   = 2 and ttSelecao.lAprovado )    /** Aprovado**/
            or   (mao-restdo-ensaio.idi-estado-ensaio   = 3 and ttSelecao.lAprovUsuar)   /** Aprovado pelo Usu†rio **/
            or   (mao-restdo-ensaio.idi-estado-ensaio   = 4 and ttSelecao.lReprovado))   /** Reprovado **/
            and ((mao-restdo-ensaio.log-padrao          = true and ttSelecao.lPadrao)    /** Ativos **/
            or   (mao-restdo-ensaio.log-padrao          = false and ttSelecao.lNPadrao)) /** Inativos **/ no-lock:

            /** Acompanhamento **/
            {utp/ut-liter.i "Lendo Amostra"}
            RUN pi-Acompanhar IN hAcomp (RETURN-VALUE + ": " + string(mao-amostra-oleo.num-amostra-oleo)).

            /**** Busca os Ensaios para verificar o tipo de Resultado *****/
             for first mao-ensaio fields (des-ensaio cod-ensaio   idi-tip-restdo ) 
                  where mao-ensaio.cod-ensaio       = mao-restdo-ensaio.cod-ensaio 
                  and ((mao-ensaio.idi-tip-restdo   = 1 and ttSelecao.lNumerico) /** Numerico **/
                  or   (mao-ensaio.idi-tip-restdo   = 2 and ttSelecao.lTabela)   /** Tabela**/
                  or   (mao-ensaio.idi-tip-restdo   = 3 and ttSelecao.lTexto)    /** Texto **/
                  or   (mao-ensaio.idi-tip-restdo   = 4 and ttSelecao.lData ))   /** Data **/
                  no-lock:
             end.
             if not avail  mao-ensaio then next blk-Resultado.
            /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
            assign cCodPai    = "".
            /** Busca vis‰es escolhidas **/
            for each ttVisao no-lock:
                /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                run buscaValor in this-procedure (input ttVisao.dimensao).
                /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                if vCodigo = "" then next.
                /** Carrega os dados  **/
                run piCarregaSequencias in this-procedure.
            end.
        end. /**** mao-restdo-ensaio *****/
    end. /** mao-amostra-oleo **/
END.

IF VALID-HANDLE(hAcomp) THEN
    RUN pi-finalizar IN hAcomp.

/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBrowseAtualiza wWindow 
PROCEDURE piBrowseAtualiza :
/*------------------------------------------------------------------------------
  Purpose:     piBrowseAtualiza
  Parameters:  <none>
  Notes:       Mostra registros no browse
------------------------------------------------------------------------------*/
DEFINE BUFFER bfmao-amostra-oleo2 FOR mao-amostra-oleo.
DEFINE BUFFER bfmao-amostra-oleo3 FOR mao-amostra-oleo.

/** Busca o £ltimo ensaio **/
FOR FIRST bfmao-amostra-oleo
    WHERE bfmao-amostra-oleo.num-amostra-oleo = num-ult-amostra-oleo NO-LOCK:
END.
IF AVAIL bfmao-amostra-oleo THEN DO:
    IF CAN-FIND(FIRST  bfmao-amostra-oleo2
                WHERE bfmao-amostra-oleo2.ep-codigo            = bfmao-amostra-oleo.ep-codigo
                AND   bfmao-amostra-oleo2.cod-eqpto            = bfmao-amostra-oleo.cod-eqpto
                AND   bfmao-amostra-oleo2.cod-comptmento       = bfmao-amostra-oleo.cod-comptmento
                AND   bfmao-amostra-oleo2.cod-tip-mater        = bfmao-amostra-oleo.cod-tip-mater
                AND   bfmao-amostra-oleo2.val-dat-hora-invrtda < bfmao-amostra-oleo.val-dat-hora-invrtda) THEN DO:
        FOR LAST  bfmao-amostra-oleo2 
            WHERE bfmao-amostra-oleo2.ep-codigo             = bfmao-amostra-oleo.ep-codigo
            AND   bfmao-amostra-oleo2.cod-eqpto             = bfmao-amostra-oleo.cod-eqpto
            AND   bfmao-amostra-oleo2.cod-comptmento        = bfmao-amostra-oleo.cod-comptmento
            AND   bfmao-amostra-oleo2.cod-tip-mater         = bfmao-amostra-oleo.cod-tip-mater
            AND   bfmao-amostra-oleo2.val-dat-hora-invrtda <= bfmao-amostra-oleo.val-dat-hora-invrtda 
            AND   rowid(bfmao-amostra-oleo2)               <> ROWID(bfmao-amostra-oleo) NO-LOCK
            BREAK BY    bfmao-amostra-oleo2.val-dat-hora-invrtda:
            ASSIGN d-data-ult-amostra   = bfmao-amostra-oleo2.dat-amostra
                   num-ult-amostra-oleo = bfmao-amostra-oleo2.num-amostra-oleo.
            IF CAN-FIND(FIRST bfmao-amostra-oleo3
                        WHERE bfmao-amostra-oleo3.ep-codigo            = bfmao-amostra-oleo.ep-codigo           
                        AND   bfmao-amostra-oleo3.cod-eqpto            = bfmao-amostra-oleo.cod-eqpto           
                        AND   bfmao-amostra-oleo3.cod-comptmento       = bfmao-amostra-oleo.cod-comptmento      
                        AND   bfmao-amostra-oleo3.cod-tip-mater        = bfmao-amostra-oleo.cod-tip-mater
                        AND   bfmao-amostra-oleo3.val-dat-hora-invrtda < bfmao-amostra-oleo2.val-dat-hora-invrtda) THEN DO:
                FOR LAST  bfmao-amostra-oleo3 USE-INDEX mmstrl-03
                    WHERE bfmao-amostra-oleo3.ep-codigo             = bfmao-amostra-oleo.ep-codigo           
                    AND   bfmao-amostra-oleo3.cod-eqpto             = bfmao-amostra-oleo.cod-eqpto           
                    AND   bfmao-amostra-oleo3.cod-comptmento        = bfmao-amostra-oleo.cod-comptmento      
                    AND   bfmao-amostra-oleo3.cod-tip-mater         = bfmao-amostra-oleo.cod-tip-mater
                    AND   bfmao-amostra-oleo3.val-dat-hora-invrtda <= bfmao-amostra-oleo2.val-dat-hora-invrtda 
                    AND   rowid(bfmao-amostra-oleo3)               <> ROWID(bfmao-amostra-oleo2) NO-LOCK
                    BREAK BY    bfmao-amostra-oleo3.val-dat-hora-invrtda:
                    ASSIGN d-data-penult-amostra   = bfmao-amostra-oleo3.dat-amostra
                           num-penult-amostra-oleo = bfmao-amostra-oleo3.num-amostra-oleo.
                END.
            END.
            ELSE DO: /** caso o pen£ltimo ensaio n∆o seja encontrado **/
                ASSIGN d-data-penult-amostra   = ?
                       num-penult-amostra-oleo = 0.
            END.
        END.
    END.
    ELSE DO: /** caso o £ltimo ensaio n∆o seja encontrado **/
        ASSIGN d-data-ult-amostra      = ?
               num-ult-amostra-oleo    = 0
               d-data-penult-amostra   = ?  
               num-penult-amostra-oleo = 0.
    END.
END.
/** Se tiver filhos, mostra no browse, os filhos **/
if avail ttDados then do:
    run piBrowseTitulo in this-procedure (ttDados.p-image).
    /** Retira marcaá∆o da geraá∆o de tarefas **/
    for each  ttDados use-index docto
        where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
    end.
    open query brDetalhe for each  ttDados use-index docto
                             where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock.
end.
/** Sen∆o, mostra ele mesmo **/
else do:
    run piBrowseTitulo in this-procedure (bfttDados.p-image).
    open query brDetalhe for each  ttDados use-index docto
                             where ttDados.cod-dimensao = bfttDados.cod-dimensao no-lock.
end.

apply "value-changed":U to brDetalhe in frame fpage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBrowseTitulo wWindow 
PROCEDURE piBrowseTitulo :
/*------------------------------------------------------------------------------
  Purpose:     labelBrowse
  Parameters:  entrada pImagem = N£mero da imagem da vis∆o
  Notes:       Coloca o label no browse conforme escolha
------------------------------------------------------------------------------*/

define input parameter pImagem as integer no-undo.

if pImagem = 12 then do:
assign  ttDados.cod-oficial:visible    in browse brDetalhe = yes
        ttDados.desc-dimensao:visible  in browse brDetalhe = yes
        cDescStatus:visible            in browse brDetalhe = yes
        cDescStatusAmostra:visible     in browse brDetalhe = NO
        cDescLog:visible               in browse brDetalhe = yes
        ttDados.des-val-restdo:visible in browse brDetalhe = yes
        ttDados.des-val-max:visible    in browse brDetalhe = yes
        ttDados.des-val-min:visible    in browse brDetalhe = yes
        ttDados.num-tabela:visible     in browse brDetalhe = yes
        cDescResult:visible            in browse brDetalhe = yes
        ttDados.dat-result-ant:visible in browse brDetalhe = yes
        ttDados.dat-result:visible     in browse brDetalhe = yes.
 /** Labels do browse **/
    assign ttDados.cod-oficial:label in browse brDetalhe    = fnBrowse("cod-oficial":U,1)
           ttDados.cod-ensaio:label in browse brDetalhe     = fnBrowse("cod-ensaio":U,1)
           ttDados.desc-dimensao:label in browse brDetalhe  = fnBrowse("desc-dimensao":U,1)
           cDescStatus:label in browse brDetalhe            = fnBrowse("idi-estado-ensaio":U,1)
           cDescLog:label in browse brDetalhe               = fnBrowse("log-padrao":U,1)
           ttDados.des-val-restdo:label in browse brDetalhe = fnBrowse("des-val-restdo":U,1)
           ttDados.des-val-max:label in browse brDetalhe    = fnBrowse("des-val-max":U,1)
           ttDados.des-val-min:label in browse brDetalhe    = fnBrowse("des-val-min":U,1)
           ttDados.num-tabela:label in browse brDetalhe     = fnBrowse("num-tabela":U,1)
           cDescResult:label in browse brDetalhe            = fnBrowse("idi-tip-restdo":U,1)
           ttDados.dat-result-ant:label in browse brDetalhe = fnBrowse("dat-result-ant":U,1)
           ttDados.dat-result:label in browse brDetalhe     = fnBrowse("dat-result":U,1).

        {utp/ut-liter.i  Resultados * }
        ASSIGN brDetalhe:title in frame fPage0 = trim(return-value).
        {utp/ut-liter.i  Documento * }
        assign ttDados.cod-oficial:label in browse brDetalhe = trim(return-value).
end.
else do:
    if pImagem = 6 then  do:
    assign  ttDados.cod-oficial:visible    in browse brDetalhe = no 
            ttDados.cod-ensaio:visible     in browse brDetalhe = no                  
            ttDados.desc-dimensao:visible  in browse brDetalhe = yes                  
            cDescStatus:visible            in browse brDetalhe = NO 
            cDescStatusAmostra:visible     in browse brDetalhe = NO
            cDescLog:visible               in browse brDetalhe = NO                
            ttDados.des-val-restdo:visible in browse brDetalhe = NO                              
            ttDados.des-val-max:visible    in browse brDetalhe = NO                                 
            ttDados.des-val-min:visible    in browse brDetalhe = NO                                 
            ttDados.num-tabela:visible     in browse brDetalhe = NO                                  
            cDescResult:visible            in browse brDetalhe = NO
            ttDados.dat-result-ant:visible in browse brDetalhe = NO
            ttDados.dat-result:visible     in browse brDetalhe = NO.
     /** Labels do browse **/
        assign ttDados.desc-dimensao:label in browse brDetalhe  = fnBrowse("desc-dimensao":U,1).  
        {aop/ao0302.i2 pImagem }
        ASSIGN brDetalhe:title in frame fPage0 = trim(return-value).

    END. /* pImagem = 6*/
    ELSE DO:
        IF pImagem = 8 THEN DO:
            assign  ttDados.cod-oficial:visible    in browse brDetalhe = yes                    
                    ttDados.desc-dimensao:visible  in browse brDetalhe = NO
                    ttDados.cod-ensaio:visible     in browse brDetalhe = no                  
                    cDescStatus:visible            in browse brDetalhe = NO
                    cDescStatusAmostra:visible     in browse brDetalhe = YES
                    cDescLog:visible               in browse brDetalhe = NO                
                    ttDados.des-val-restdo:visible in browse brDetalhe = NO                              
                    ttDados.des-val-max:visible    in browse brDetalhe = NO                                 
                    ttDados.des-val-min:visible    in browse brDetalhe = NO                                 
                    ttDados.num-tabela:visible     in browse brDetalhe = NO                                  
                    cDescResult:visible            in browse brDetalhe = NO
                    ttDados.dat-result-ant:visible in browse brDetalhe = NO
                    ttDados.dat-result:visible     in browse brDetalhe = NO.
             /** Labels do browse **/
                assign ttDados.cod-oficial:label in browse brDetalhe   = fnBrowse("cod-oficial":U,1)
                       cDescStatusAmostra:label  in browse brDetalhe   = fnBrowse("idi-estado-ensaio":U,1).

            {aop/ao0302.i2 pImagem}

            ASSIGN brDetalhe:title in frame fPage0 = trim(return-value).

        END.
        else do:
            assign  ttDados.cod-oficial:visible    in browse brDetalhe = yes                    
                    ttDados.desc-dimensao:visible  in browse brDetalhe = yes
                    ttDados.cod-ensaio:visible     in browse brDetalhe = no                  
                    cDescStatus:visible            in browse brDetalhe = NO
                    cDescStatusAmostra:visible     in browse brDetalhe = NO
                    cDescLog:visible               in browse brDetalhe = NO                
                    ttDados.des-val-restdo:visible in browse brDetalhe = NO                              
                    ttDados.des-val-max:visible    in browse brDetalhe = NO                                 
                    ttDados.des-val-min:visible    in browse brDetalhe = NO                                 
                    ttDados.num-tabela:visible     in browse brDetalhe = NO                                  
                    cDescResult:visible            in browse brDetalhe = NO
                    ttDados.dat-result-ant:visible in browse brDetalhe = NO
                    ttDados.dat-result:visible     in browse brDetalhe = NO.
             /** Labels do browse **/
            assign ttDados.cod-oficial:label in browse brDetalhe   = fnBrowse("cod-oficial":U,1)
                   ttDados.desc-dimensao:label in browse brDetalhe = fnBrowse("desc-dimensao":U,1).

            {aop/ao0302.i2 pImagem}

            ASSIGN brDetalhe:title in frame fPage0 = trim(return-value).
        end.
    END.
end.




return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaSequencias wWindow 
PROCEDURE piCarregaSequencias :
/*------------------------------------------------------------------------------
  Purpose:     piCarregaSequencias
  Parameters:  <none>
  notes:       Carrega a temp-table que ser† mostrada no tree-view e no browse
------------------------------------------------------------------------------*/
DEFINE BUFFER bfmao-amostra-oleo2 FOR mao-amostra-oleo.
DEFINE BUFFER bfmao-amostra-oleo3 FOR mao-amostra-oleo.

/** Busca registro **/
find first ttDados 
     where ttDados.cod-dimensao  = (cCodPai + "#" + vCodigo)
     and   ttDados.sequencia     = ttVisao.sequencia exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttDados then do:
   create ttDados.
   assign ttDados.cod-dimensao         = (cCodPai + "#" + vCodigo)   /** C¢digo encadeado para tree-view **/
          ttDados.cod-oficial          = vCodigo                /** C¢digo Original do registro **/
          ttDados.desc-dimensao        = vDescricao             /** Descriá∆o do c¢digo **/
          ttDados.sequencia            = ttVisao.sequencia      /** Sequància dos dados **/
          ttDados.p-image              = iImage                 /** N£mero da imagem do registro **/
          ttDados.r-rowid              = rRowid                 /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai       = cCodPai               /** C¢digo do pai do registro **/
          ttDados.num-amostra-oleo     = mao-amostra-oleo.num-amostra-oleo.
end.

assign cCodPai = ttDados.cod-dimensao.

/** Busca o £ltimo ensaio **/
FOR FIRST bfmao-amostra-oleo
    WHERE bfmao-amostra-oleo.num-amostra-oleo = ttDados.num-amostra-oleo NO-LOCK:
END.
IF AVAIL bfmao-amostra-oleo THEN DO:
    IF CAN-FIND(FIRST  bfmao-amostra-oleo2
                WHERE bfmao-amostra-oleo2.ep-codigo            = bfmao-amostra-oleo.ep-codigo
                AND   bfmao-amostra-oleo2.cod-eqpto            = bfmao-amostra-oleo.cod-eqpto
                AND   bfmao-amostra-oleo2.cod-comptmento       = bfmao-amostra-oleo.cod-comptmento
                AND   bfmao-amostra-oleo2.cod-tip-mater        = bfmao-amostra-oleo.cod-tip-mater
                AND   bfmao-amostra-oleo2.val-dat-hora-invrtda < bfmao-amostra-oleo.val-dat-hora-invrtda) THEN DO:
        FOR LAST  bfmao-amostra-oleo2 
            WHERE bfmao-amostra-oleo2.ep-codigo                = bfmao-amostra-oleo.ep-codigo
            AND   bfmao-amostra-oleo2.cod-eqpto                = bfmao-amostra-oleo.cod-eqpto
            AND   bfmao-amostra-oleo2.cod-comptmento           = bfmao-amostra-oleo.cod-comptmento
            AND   bfmao-amostra-oleo2.cod-tip-mater            = bfmao-amostra-oleo.cod-tip-mater
            AND   bfmao-amostra-oleo2.val-dat-hora-invrtda    <= bfmao-amostra-oleo.val-dat-hora-invrtda 
            AND   rowid(bfmao-amostra-oleo2)                  <> ROWID(bfmao-amostra-oleo) NO-LOCK
            BREAK BY    bfmao-amostra-oleo2.val-dat-hora-invrtda:
            ASSIGN d-data-ult-amostra   = bfmao-amostra-oleo2.dat-amostra
                   num-ult-amostra-oleo = bfmao-amostra-oleo2.num-amostra-oleo.
            IF CAN-FIND(FIRST bfmao-amostra-oleo3
                        WHERE bfmao-amostra-oleo3.ep-codigo            = bfmao-amostra-oleo.ep-codigo           
                        AND   bfmao-amostra-oleo3.cod-eqpto            = bfmao-amostra-oleo.cod-eqpto           
                        AND   bfmao-amostra-oleo3.cod-comptmento       = bfmao-amostra-oleo.cod-comptmento      
                        AND   bfmao-amostra-oleo3.cod-tip-mater        = bfmao-amostra-oleo.cod-tip-mater
                        AND   bfmao-amostra-oleo3.val-dat-hora-invrtda < bfmao-amostra-oleo2.val-dat-hora-invrtda) THEN DO:
                FOR LAST  bfmao-amostra-oleo3 USE-INDEX mmstrl-03
                    WHERE bfmao-amostra-oleo3.ep-codigo                = bfmao-amostra-oleo.ep-codigo           
                    AND   bfmao-amostra-oleo3.cod-eqpto                = bfmao-amostra-oleo.cod-eqpto           
                    AND   bfmao-amostra-oleo3.cod-comptmento           = bfmao-amostra-oleo.cod-comptmento      
                    AND   bfmao-amostra-oleo3.cod-tip-mater            = bfmao-amostra-oleo.cod-tip-mater
                    AND   bfmao-amostra-oleo3.val-dat-hora-invrtda    <= bfmao-amostra-oleo2.val-dat-hora-invrtda 
                    AND   rowid(bfmao-amostra-oleo3)                  <> ROWID(bfmao-amostra-oleo2) NO-LOCK
                    BREAK BY    bfmao-amostra-oleo3.val-dat-hora-invrtda:
                    ASSIGN d-data-penult-amostra   = bfmao-amostra-oleo3.dat-amostra             
                           num-penult-amostra-oleo = bfmao-amostra-oleo3.num-amostra-oleo.       
                END.                                                                             
            END.                                                                                 
            ELSE DO: /** caso o pen£ltimo ensaio n∆o seja encontrado **/
                ASSIGN d-data-penult-amostra   = ?
                       num-penult-amostra-oleo = 0.
            END.
        END.
    END.
    ELSE DO: /** caso o £ltimo ensaio n∆o seja encontrado **/
        ASSIGN d-data-ult-amostra      = ?
               num-ult-amostra-oleo    = 0
               d-data-penult-amostra   = ?  
               num-penult-amostra-oleo = 0.
    END.
END.

/* Cria um nivel a mais quando for a £ltima dimens∆o  */
if ttDados.sequencia = iVisao then do:
    run piCarregaVisao in this-procedure.
end.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaVisao wWindow 
PROCEDURE piCarregaVisao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign vCodigo    = string(mao-restdo-ensaio.num-amostra-oleo)
       vDescricao = if avail mao-ensaio then mao-ensaio.des-ensaio  else "":U
       iImage     = 12
       rRowid     = rowid(mao-restdo-ensaio).

/** Busca registro **/
find first ttDados 
     where ttDados.cod-dimensao         = trim(cCodPai + "#" + vCodigo)
     and   ttDados.sequencia            = iVisao + 1 
     and   ttDados.cod-ensaio           = mao-restdo-ensaio.cod-ensaio 
     and   ttDados.cod-amostra-fisic    = mao-amostra-oleo.cod-amostra-fisic exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttDados then do:
   create ttDados.
   assign ttDados.cod-dimensao            = (cCodPai  + "#" +  vCodigo)    /** C¢digo encadeado para tree-view **/
          ttDados.sequencia               = iVisao + 1                     /** Sequància dos dados **/
          ttDados.cod-oficial             = vCodigo                        /** C¢digo Original do registro **/
          ttDados.desc-dimensao           = vDescricao                     /** Descriá∆o do c¢digo **/
          ttDados.p-image                 = iImage                         /** N£mero da imagem do registro **/
          ttDados.r-rowid                 = rRowid                         /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai          = cCodPai                        /** C¢digo do pai do registro **/
          ttDados.data                    = mao-amostra-oleo.dat-amostra   
          ttDados.cod-amostra-fisic       = mao-amostra-oleo.cod-amostra-fisic    
          ttDados.val-quant               = mao-amostra-oleo.val-quant                                      
          ttDados.idi-estado-amostra      = mao-amostra-oleo.idi-estado-amostra
          ttDados.num-docto               = mao-amostra-oleo.num-docto
          ttDados.ep-codigo               = mao-amostra-oleo.ep-codigo        
          ttDados.cod-eqpto               = mao-amostra-oleo.cod-eqpto        
          ttDados.hora                    = mao-amostra-oleo.hra-amostra
          ttDados.cod-comptmento          = mao-amostra-oleo.cod-comptmento
          ttDados.cod-tip-mater           = mao-amostra-oleo.cod-tip-mater
          ttDados.val-quant               = mao-amostra-oleo.val-quant
          ttDados.idi-estado-amostra      = mao-amostra-oleo.idi-estado-amostra
          ttDados.cod-ensaio              = mao-restdo-ensaio.cod-ensaio                                
          ttDados.idi-estado-ensaio       = mao-restdo-ensaio.idi-estado-ensaio
          ttDados.log-padrao              = mao-restdo-ensaio.log-padrao  
          ttDados.des-val-restdo          = mao-restdo-ensaio.des-val-restdo   
          ttDados.des-val-max             = mao-restdo-ensaio.des-val-max     
          ttDados.des-val-min             = mao-restdo-ensaio.des-val-min     
          ttDados.num-tabela              = mao-restdo-ensaio.num-tabela
          ttDados.dat-restdo-ensaio       = mao-restdo-ensaio.dat-restdo-ensaio   
          ttDados.hra-restdo-ensaio       = mao-restdo-ensaio.hra-restdo-ensaio   
          ttDados.idi-tip-restdo          = if avail mao-ensaio then  mao-ensaio.idi-tip-restdo  else 1
          ttDados.dsl-obs                 = mao-restdo-ensaio.dsl-obs
          ttDados.des-formato             = mao-restdo-ensaio.des-formato
          ttDados.d-data-ult-amostra      = d-data-ult-amostra
          ttDados.num-ult-amostra-oleo    = num-ult-amostra-oleo
          ttDados.d-data-penult-amostra   = d-data-penult-amostra
          ttDados.num-penult-amostra-oleo = num-penult-amostra-oleo.

end. /*if not avail ttDados then do:*/

assign cCodPai = ttDados.cod-dimensao.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRegistro wWindow 
PROCEDURE piCriaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNunAmostra like  mao-amostra-oleo.cod-amostra-fisic no-undo.
define variable rRow        as rowid     no-undo.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run criaVisoes in this-procedure.
end.
/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.
/** Guarda a £ltima vis∆o **/
assign iVisao = 0.
for last ttVisao no-lock:
    assign iVisao = ttVisao.sequencia.
end.

/** Busca as informaá‰es conforme parametrizaá∆o **/
for each  mao-amostra-oleo
    where mao-amostra-oleo.cod-amostra-fisic    = pNunAmostra 
    no-lock:
   /**********************************************************************************************
   ********* Busca os Resultados dos ensaios para a amostrade ‡leo *******************************
   **********************************************************************************************/
    for each mao-restdo-ensaio
        where mao-restdo-ensaio.num-amostra-oleo = mao-amostra-oleo.num-amostra-oleo no-lock,
        first mao-ensaio where mao-ensaio.cod-ensaio = mao-restdo-ensaio.cod-ensaio no-lock:

        /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
        assign cCodPai    = "".
        /** Busca vis‰es escolhidas **/
        for each ttVisao no-lock:
            /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
            run buscaValor in this-procedure (input ttVisao.dimensao).
            /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
            if vCodigo = "" then next.
            /** Carrega os dados  **/
            run piCarregaSequencias in this-procedure.
        end.
    end. /**** mao-restdo-ensaio *****/
end. /** mao-amostra-oleo **/

/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcel wWindow 
PROCEDURE piExcel :
/*------------------------------------------------------------------------------
  Purpose:     piExcel
  Parameters:  <none>
  Notes:       Exporta os dados do programa para o Excel
------------------------------------------------------------------------------*/
/** Limpa temp-table Excel **/
empty temp-table tt-dados-ex.

/************************************************************
** Chama tela para escolha da impress∆o
** 1 = Somente Dimens∆o Selecionada
** 2 = Total
************************************************************/
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
run aop/ao0302f.w (output i-impressao,
                   output l-ok).
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
assign {&window-name}:sensitive = yes.

/** A tela foi confirmada, ent∆o continua **/
if l-ok then do:
    assign i-col     = 1
           i-lin     = 1
           i-lin2    = 1
           c-colunas = "".

    /** Encontra n£mero total de colunas **/
    do i-col = 1 TO brDetalhe:num-columns in frame fPage0:
        hHandle = brDetalhe:get-browse-column(i-col).
        /** Guarda t°tulos das colunas **/
        assign c-colunas = c-colunas + hHandle:name.
        if i-col <> brDetalhe:num-columns  then
            assign c-colunas = c-colunas + ",".
    end.

    /** Somente vis∆o selecionada **/
    if i-impressao = 1 then do:
        /** Guarda rowid do tree-view **/
        assign rRowid    = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).

        /** Busca Registro **/
        for first bfttDados
            where rowid(bfttDados) = rRowid no-lock:
            run piExcelDados (input bfttDados.cod-dimensao).
        end.
    end.
    /** Completo **/
    else do:
        for each  bfttDados
            where bfttDados.sequencia = 1 no-lock:
              run piExcelDados (input bfttDados.cod-dimensao).
        end.
    end.

    /** Programa que gera o XLS **/
    run abp/ab9003.p(input "ao0302":U,
                     input table tt-dados-ex).
    if return-value = "NOK":U then.

    /** Posiciona o Tree-View no £ltimo lido **/
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
        DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, c-codigo-node).
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelDados wWindow 
PROCEDURE piExcelDados :
/*------------------------------------------------------------------------------
  Purpose:     piExcelDados
  Parameters:  entrada pDimensao = Dimensao lida
  Notes:       Impress∆o dos dados em excel
------------------------------------------------------------------------------*/
define input parameter pDimensao as character no-undo.

define variable cPai      as character no-undo.
define variable i-col-aux as integer   no-undo.
define variable iControl  as integer   no-undo.
assign cPai = "".

for each  ttDados
    where ttDados.cod-dimens-pai = pDimensao no-lock:
    /** Verifica se existem n°veis abaixo  **/
    if ttDados.sequencia <= iVisao then do:
        run piExcelDados (ttDados.cod-dimensao).
    end.
    else do:
        if cPai <> ttDados.cod-dimens-pai then do:
            /** Imprime os cabeáalhos **/
            run piExcelVisao (input rowid(ttDados),         
                              input ttDados.cod-dimens-pai).
            assign cPai  = ttDados.cod-dimens-pai
                   i-lin = i-lin2.
        end.
        assign i-col-aux = 1.
        /** In°cio contador de colunas do Browse**/
        do i-col = 1 to brDetalhe:num-columns in frame fPage0: 
            hHandle = brDetalhe:get-browse-column(i-col).
            if hHandle:visible then do:
                if ttDados.p-image = 12 then do:
                    {utp/ut-liter.i Documento * }
                        /** Contador para linhas **/
                        if i-lin = i-lin2 then do:
                            create tt-dados-ex.
                            assign tt-dados-ex.celula-coluna     = i-col-aux 
                                tt-dados-ex.celula-linha         = i-lin
                                tt-dados-ex.celula-cor-interior  = 10
                                tt-dados-ex.celula-fonte-cor     = 19
                                tt-dados-ex.celula-fonte-negrito = yes.
                            assign tt-dados-ex.celula-valor      = if i-col = 1 
                                then return-value
                                else fnBrowse(entry(i-col,c-colunas),1).
                        end.
                end.
                else do:
                /** Contador para linhas **/
                    if i-lin = i-lin2 then do:
                        create tt-dados-ex.
                        assign tt-dados-ex.celula-coluna     = i-col-aux 
                            tt-dados-ex.celula-linha         = i-lin
                            tt-dados-ex.celula-cor-interior  = 10
                            tt-dados-ex.celula-fonte-cor     = 19
                            tt-dados-ex.celula-fonte-negrito = yes.
                        assign tt-dados-ex.celula-valor      = if i-col = 1 
                            then fnLabels(ttDados.p-image)
                            else fnBrowse(entry(i-col,c-colunas),1).
                    end.
                end.

                hHandle2 = brDetalhe:get-browse-column(i-col).
                if hHandle2:name = "codigo":u or hHandle:name  = "nivel":U then do: /*** Verifica nome interno da coluna do browser n∆o Ç necess†rio traduá∆o pois testa nome inteno da tabela***/
                    assign iControl = 1.
                end.
                else do:
                    assign iControl = 2.
                end.

                /** Impress∆o da primeira linha de dados **/
                create tt-dados-ex.
                assign tt-dados-ex.celula-coluna = i-col-aux
                    tt-dados-ex.celula-linha     = i-lin + 1
                    tt-dados-ex.celula-formato   = if iControl = 1 then "@" else "".
                assign tt-dados-ex.celula-valor  = fnBrowse(entry(i-col,c-colunas),2).
                case idi-estado-ensaio:
                    when 1 then
                        assign tt-dados-ex.celula-fonte-cor = 17. /** Pendente = Cinza **/
                    when 2 then
                        assign tt-dados-ex.celula-fonte-cor = 10. /** Aprovado = Verde **/
                    when 3 then
                        assign tt-dados-ex.celula-fonte-cor = 5.  /** Aprovado pelo usu†rio = Azul **/  
                    when 4 then
                        assign tt-dados-ex.celula-fonte-cor = 3.  /** Reprovado = Vermelho **/
                end case.
/*             /** Para c¢digo, coloca formato TEXTO **/            */
/*             if entry(i-col,c-colunas) = "cod-oficial":U then do: */
/*                 assign tt-dados-ex.celula-formato = "@":U.       */
/*             end.                                                 */
            end.
            else do:
                 assign i-col-aux = i-col-aux - 1.
            end.
            assign i-col-aux = i-col-aux + 1.
        end. /** Colunas **/
        if ttDados.p-image = 12 then
            assign i-lin  = i-lin + 1
                   i-lin2 = i-lin + 1.
    end.
end.

 return "OK":U.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelVisao wWindow 
PROCEDURE piExcelVisao :
/*------------------------------------------------------------------------------
  Purpose:     piExcelVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.
def var c-celula-valor         as char      no-undo.


/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run piExcelVisao (input rowid(bfttDados2),
                          input bfttDados2.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttDados2
    where rowid(bfttDados2) = rRow no-lock:
end.
if avail bfttDados2 and bfttDados2.p-image <> 12 then do:
    /** Cria os dados na temp-table do excel **/
   {aop/ao0302.i2 bfttDados2.p-image}
   if bfttDados2.p-image      = 8 then
       assign c-celula-valor  = trim(return-value) + ": " + bfttDados2.cod-oficial.
   else if bfttDados2.p-image = 6 then
       assign c-celula-valor  = trim(return-value) + ": " + bfttDados2.desc-dimensao.
   else
       assign c-celula-valor  = trim(return-value) + ": " + bfttDados2.cod-oficial + "-" + bfttDados2.desc-dimensao.
   create tt-dados-ex.
   assign tt-dados-ex.celula-coluna        = 1
          tt-dados-ex.celula-linha         = i-lin2
          tt-dados-ex.celula-cor-interior  = 27
          tt-dados-ex.celula-fonte-cor     = 1
          tt-dados-ex.celula-fonte-negrito = yes
          tt-dados-ex.celula-formato       = "@":U
          tt-dados-ex.celula-valor         = c-celula-valor
          i-lin2                           = i-lin2 + 1.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wWindow 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     piImprimir
  Parameters:  <none>
  Notes:       Chama tela de impress∆o passando vis∆o a ser impressa
------------------------------------------------------------------------------*/
define variable rRowid     as rowid     no-undo.
define variable iSequencia as integer   no-undo.
define variable cDimensao  as character no-undo.

/** Guarda rowid do tree-view **/
assign rRowid = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).

/** Busca Registro **/
for first ttDados
    where rowid(ttDados) = rRowid no-lock:
    assign iSequencia = ttDados.sequencia
           cDimensao  = ttDados.cod-dimensao.
end.
if avail ttDados then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttDados
                    where bfttDados.cod-dimens-pai = ttDados.cod-dimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttDados
            where bfttDados.cod-dimensao = ttDados.cod-dimens-pai no-lock:
            assign iSequencia = bfttDados.sequencia
                   cDimensao  = bfttDados.cod-dimensao.
        end.
    end.

    assign {&window-name}:sensitive = no.
    run aop/ao0302d.w (input table /*ttDados*/ bfttDados,
                       input iSequencia,
                       input cDimensao,
                       input iVisao).
    assign {&window-name}:sensitive = yes.

    /** Posiciona o Tree-View no £ltimo lido **/
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
        DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, c-codigo-node).
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLabelCampos wWindow 
PROCEDURE piLabelCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i Data * }
assign fiTexto-1 =    trim(return-value).
{utp/ut-liter.i Èltima_Troca}
assign fiTexto-6 =    trim(return-value).
{utp/ut-liter.i N£mero_Amostra * }
assign fiTexto-2 =    trim(return-value).
{utp/ut-liter.i Equipamento * }
assign fiTexto-3 =    trim(return-value).
{utp/ut-liter.i Compartimento * }
assign fiTexto-4 =    trim(return-value).
{utp/ut-liter.i Tipo_Material * }
assign fiTexto-5 =    trim(return-value).
{utp/ut-liter.i Quantidade * }
assign  fiTexto-8 =    trim(return-value).
{utp/ut-liter.i Lubrificaá∆o * }
assign fiTexto-7 =    trim(return-value).
{utp/ut-liter.i "Status"  * }
assign fiTexto-9 =    trim(return-value).
{utp/ut-liter.i "Resultado"  * }
assign fiTexto10=    trim(return-value).
disp fiTexto-1 
     fiTexto-6 
     fiTexto-2 
     fiTexto-3 
     fiTexto-4 
     fiTexto-5 
     fiTexto-8 
     fiTexto-7 
     fiTexto-9  
      with frame fpage0.
if lLabel then do:
  disp fiTexto10 with frame fPage0.

end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraCamposTela wWindow 
PROCEDURE piMostraCamposTela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNumAmostra like mao-amostra-oleo.num-amostra-oleo no-undo.

if ttDados.p-image = 12 then do:
/*** Habilita bot‰es em tela para atualizaá∆o ***/
   assign btDetalhe:sensitive in frame fPage0  = yes
          btCarga:sensitive in frame fPage0  = yes
          btAprova:sensitive in frame fPage0 = yes.
   for first mao-amostra-oleo fields (cod-amostra-fisic cod-comptmento cod-eqpto cod-tip-mater 
                                      dat-amostra ep-codigo hra-amostra idi-estado-amostra num-amostra-oleo num-docto val-quant) 
       where mao-amostra-oleo.num-amostra-oleo = pNumAmostra no-lock:
   end.
   if avail mao-amostra-oleo then do:


      assign fiData            =   mao-amostra-oleo.dat-amostra
             fiHora            =   mao-amostra-oleo.hra-amostra
             fiAmostra         =   mao-amostra-oleo.cod-amostra-fisic
             fiEmpresa         =   STRING(mao-amostra-oleo.ep-codigo)
             fiEquipamento     =   mao-amostra-oleo.cod-eqpto
             fiCompto          =   mao-amostra-oleo.cod-comptmento
             fiTpMater         =   mao-amostra-oleo.cod-tip-mater
             fiQtde            =   dec(mao-amostra-oleo.val-quant)
             fiLubrific        =   STRING(mao-amostra-oleo.num-docto,">>>,>>>,>>9")
             fiStatus          =   fnStatus(mao-amostra-oleo.idi-estado-amostra).
     /***** Busca descriá‰es dos campos ***/
          /**** Material ***/
         if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> mao-amostra-oleo.cod-tip-mater then do:
               for first mab-tip-mater fields(cod-tip-mater des-tip-mater)  
                   where mab-tip-mater.cod-tip-mater = mao-amostra-oleo.cod-tip-mater no-lock:
               end.
               if avail mab-tip-mater then do:
                   assign fiDescMatl = mab-tip-mater.des-tip-mater.
               end.              
         end.
         else do:
             assign fiDescMatl = mab-tip-mater.des-tip-mater.
         end.
          /*** Equipamento ****/
           for first mab-eqpto fields(cod-model ep-codigo cod-eqpto)  
               where mab-eqpto.ep-codigo = mao-amostra-oleo.ep-codigo
               AND   mab-eqpto.cod-eqpto = mao-amostra-oleo.cod-eqpto no-lock:
           end.
         if avail mab-eqpto then do:
               if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
                   for first mab-model fields(des-model cod-model un)  
                       where mab-model.cod-model = mab-eqpto.cod-model no-lock:
                   end.
               end.
               if avail mab-model then do:
                   assign fiDescEqpto = mab-model.des-model.
               end.
          END.
          /**** compartimento ****/
         if not avail mab-comptmento or mab-comptmento.cod-comptmento <> mao-amostra-oleo.cod-comptmento then do:
            for first mab-comptmento fields(des-comptmento cod-comptmento)  
                where mab-comptmento.cod-comptmento = mao-amostra-oleo.cod-comptmento no-lock:
            end.
         end.
         if avail mab-comptmento then do:
            assign fiDescCompto = mab-comptmento.des-comptmento.
         end.
         /****** Lubrificaá∆o *****/
         if not avail mab-item-lubrific  or mab-item-lubrific.num-docto <> mao-amostra-oleo.num-docto then do:
             for first mab-item-lubrific fields( num-docto cod-tip-mater ep-codigo cod-amostra-fisic cod-eqpto cod-comptmento )  
                 where mab-item-lubrific.num-docto           = mao-amostra-oleo.num-docto
                 and   mab-item-lubrific.ep-codigo           = mao-amostra-oleo.ep-codigo     
                 and   mab-item-lubrific.cod-eqpto           = mao-amostra-oleo.cod-eqpto     
                 and   mab-item-lubrific.cod-comptmento      = mao-amostra-oleo.cod-comptmento
                 and   mab-item-lubrific.cod-tip-mater       = mao-amostra-oleo.cod-tip-mater    no-lock:
             end.
         end.
         if avail mab-item-lubrific then do:
             for last mab-abastec-lubrific fields ( num-docto ep-codigo cod-eqpto dat-movto idi-consist )
                 where  mab-abastec-lubrific.num-docto = mab-item-lubrific.num-docto
                 and    mab-abastec-lubrific.ep-codigo = mab-item-lubrific.ep-codigo
                 and    mab-abastec-lubrific.cod-eqpto = mab-item-lubrific.cod-eqpto no-lock:
             end.
             if avail mab-abastec-lubrific then do:
                 assign /*fiData-2       = string(mab-abastec-lubrific.dat-movto)*/
                        fiData-2:SCREEN-VALUE IN FRAME fPage0 = string(mab-abastec-lubrific.dat-movto,"99/99/9999":U)
                 .
                 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                     DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                     ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
                     run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                         INPUT "",
                                         INPUT "").
                     ASSIGN fiDescLubrific = RETURN-VALUE.
                 &else
                     ASSIGN fiDescLubrific = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
                 &endif
             end.
             else do:
                 assign fiData-2:SCREEN-VALUE IN FRAME fPage0 = "":U
                        fiDescLubrific                        = "":U.
             end.
         end.
         else do:
             {utp/ut-liter.i "N∆o_possui_Ficha_de_Lubrificaá∆o"}
             assign fiDescLubrific = trim(return-value).
         end.
   end.
end.

 disp fiData           
      fiHora 
      /*fiData-2          */
      fiAmostra        
      fiEmpresa        
      fiEquipamento    
      fiCompto         
      fiTpMater         
      fiQtde           
      fiLubrific       
      fiStatus         
      fiDescMatl       
      fiDescEqpto      
      fiDescCompto     
      fiDescLubrific with frame fPage0.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTexto wWindow 
PROCEDURE piTexto :
/*------------------------------------------------------------------------------
  Purpose:     piTexto
  Parameters:  <none>
  Notes:       Exporta os dados da consulta para um arquivo texto
------------------------------------------------------------------------------*/
define variable c-key-value  as character no-undo.

/** Seta caminho e delimitador **/
ASSIGN cDelimitador = ";":U
       cCaminho     = session:temp-directory + c-programa-mg97 + ".txt":U.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/***Chamada do programa de parÉmetros para geraá∆o do arquivo em formato TXT***/
run aop/ao0302e.w (input-output cCaminho,
                   input-output lCabecalho,
                   input-output cDelimitador,
                   output       i-impressao,
                   output       l-ok).
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
assign {&window-name}:sensitive = yes.

/** Se confirmar **/
if l-ok then do:
    /** Troca barras contr†rias pela correta **/
    assign cCaminho = replace(cCaminho, "/":U, "/":U).
    /** Cria arquivo **/
    output to value(cCaminho) paged page-size 64 convert target "iso8859-1":U.
        /******************************************************************
        ** Inicia impress∆o do TXT
        ******************************************************************/
        /** Somente vis∆o selecionada **/
        if i-impressao = 1 then do:
            /** Guarda rowid do tree-view **/
            assign rRowid = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
            
            /** Busca Registro **/
            for first bfttDados
                where rowid(bfttDados) = rRowid no-lock:
                run piTextoDados (input bfttDados.cod-dimensao).
            end.
        end.
        /** Completo **/
        else do:
            for each  bfttDados
                where bfttDados.sequencia = 1 no-lock:
                  run piTextoDados (input bfttDados.cod-dimensao).
            end.
        end.
        /******************************************************************
        ** Finaliza impress∆o do TXT
        ******************************************************************/
    output close.
    /** Abertura do Arquivo **/
    RUN utp/ut-showreport.p (INPUT cCaminho).


    /** Posiciona o Tree-View no £ltimo lido **/
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
        DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, c-codigo-node).
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoDados wWindow 
PROCEDURE piTextoDados :
/*------------------------------------------------------------------------------
  Purpose:     piTextoDados
  Parameters:  entrada pDimensao = Dimensao lida
  Notes:       Impress∆o dos dados em Texto
------------------------------------------------------------------------------*/
define input parameter pDimensao as character no-undo.

define variable cPai             as character                no-undo.
define variable c-dat-result     as character format "x(10)" no-undo.
define variable c-dat-result-ant as character format "x(10)" no-undo.
define variable c-tam            as character                no-undo.

assign cPai = "".

for each  ttDados 
    where ttDados.cod-dimens-pai = pDimensao no-lock:
    /** Verifica se existem n°veis abaixo  **/
    if ttDados.sequencia <= iVisao then do:
        run piTextoDados (ttDados.cod-dimensao).
    end.
    else do:
        if cPai <> ttDados.cod-dimens-pai then do:
            assign cDescPai = "":U.
            /** Imprime os cabeáalhos **/
            run piTextoVisao (input rowid(ttDados),         
                              input ttDados.cod-dimens-pai).
            assign cPai       = ttDados.cod-dimens-pai
                   cTituloTxt = "":U.
        end.

/*         assign c-dat-result     = if ttDados.dat-result     = ?  then "":U else string(ttDados.dat-result,"99/99/9999")      */
/*                c-dat-result-ant = if ttDados.dat-result-ant = ?  then "":U else string(ttDados.dat-result-ant,"99/99/9999"). */

        assign c-dat-result     = fnBrowse("dat-result":U,2)
               c-dat-result-ant = fnBrowse("dat-result-ant":U,2).  

        assign c-tam = "x(" + string(length(trim(trim(cDescPai) +
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador +
                                     fnStatus(ttDados.idi-estado-ensaio)                           + cDelimitador +
                                     fnLog(ttDados.log-padrao)                                     + cDelimitador +
                                     ttDados.des-val-restdo                                        + cDelimitador +
                                     ttDados.des-val-max                                           + cDelimitador +
                                     ttDados.des-val-min                                           + cDelimitador +
                                     string(ttDados.num-tabela,">>>>9")                            + cDelimitador +
                                     c-dat-result                                                  + cDelimitador + 
                                     c-dat-result-ant                                              + cDelimitador + 
                                     fnResultado(ttDados.idi-tip-restdo) ))) + ")".

        /** Exporta dados para TXT **/
        put trim(trim(cDescPai) +
             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador +
             fnStatus(ttDados.idi-estado-ensaio)                           + cDelimitador +
             fnLog(ttDados.log-padrao)                                     + cDelimitador +
             ttDados.des-val-restdo                                        + cDelimitador +
             ttDados.des-val-max                                           + cDelimitador +
             ttDados.des-val-min                                           + cDelimitador +
             string(ttDados.num-tabela,">>>>9")                            + cDelimitador +
             c-dat-result                                                  + cDelimitador + 
             c-dat-result-ant                                              + cDelimitador + 
             fnResultado(ttDados.idi-tip-restdo)) format c-tam at 01.


    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoVisao wWindow 
PROCEDURE piTextoVisao :
/*------------------------------------------------------------------------------
  Purpose:     piTextoVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow     as rowid     no-undo.
define input parameter cCodPai  as character no-undo.
define variable c-tam as character no-undo.
DEFINE VARIABLE teste AS CHARACTER  NO-UNDO.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run piTextoVisao (input rowid(bfttDados2),
                          input bfttDados2.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttDados2
    where rowid(bfttDados2) = rRow no-lock:
    {aop/ao0302.i2 bfttDados2.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador.
end.
if avail bfttDados2 and bfttDados2.p-image <> 12 then do:

   if bfttDados2.p-image = 6 then
       assign cDescPai  = trim(trim(cDescPai) + TRIM(bfttDados2.desc-dimensao) + cDelimitador).
   else 
       assign cDescPai  = trim(trim(cDescPai) + trim(bfttDados2.cod-oficial) + "-" + TRIM(bfttDados2.desc-dimensao) + cDelimitador).
    /** Se for o pen£ltimo n°vel, imprime cabeáalho se parametrizado **/
    if bfttDados2.sequencia = iVisao and lCabecalho then do:
        assign c-tam = "x(" + string(length(trim(trim(cTituloTxt)                        +
                                     brDetalhe:TITLE IN FRAME fPage0      + cDelimitador +
                                     fnBrowse("cDescStatus":U,1)          + cDelimitador +
                                     fnBrowse("cDescLog":U,1)             + cDelimitador +
                                     fnBrowse("des-val-restdo":U,1)       + cDelimitador +
                                     fnBrowse("des-val-max":U,1)          + cDelimitador +
                                     fnBrowse("des-val-min":U,1)          + cDelimitador +
                                     fnBrowse("num-tabela":U,1)           + cDelimitador +
                                     fnBrowse("dat-result-ant":U,1)       + cDelimitador +
                                     fnBrowse("dat-result":U,1)           + cDelimitador +                 
                                     fnBrowse("cDescResult":U,1)                ))) + ")".
        put trim(trim(cTituloTxt)                                    +
                 brDetalhe:TITLE IN FRAME fPage0      + cDelimitador +
                 fnBrowse("cDescStatus":U,1)          + cDelimitador +
                 fnBrowse("cDescLog":U,1)             + cDelimitador +
                 fnBrowse("des-val-restdo":U,1)       + cDelimitador +
                 fnBrowse("des-val-max":U,1)          + cDelimitador +
                 fnBrowse("des-val-min":U,1)          + cDelimitador +
                 fnBrowse("num-tabela":U,1)           + cDelimitador +
                 fnBrowse("dat-result-ant":U,1)       + cDelimitador +  
                 fnBrowse("dat-result":U,1)           + cDelimitador +                  
                 fnBrowse("cDescResult":U,1)      ) format c-tam at 01.


    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaRegistros wWindow 
PROCEDURE setaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     setaRegistros
  Parameters:  entrada ttSelecao = TempTable de Seleá∆o e ttVisao = TempTable de Vis‰es
  Notes:       Seta os parÉmetros do programa
------------------------------------------------------------------------------*/

define input parameter table for ttSelecao.
define input parameter table for ttVisao.

/** Busca registro de seleá∆o **/
find first ttSelecao no-lock no-error.

/** Se n∆o encontrar, cria o default **/
if not avail ttSelecao then do:
    run crittSelecao in this-procedure.
end.


/** Busca registro de vis‰es **/
find first ttVisao no-lock no-error.

/** Se n∆o encontrar, cria o default **/
if not avail ttVisao then do:
    run piCriaVisao in this-procedure.
end.

/** Aplica a seleá∆o para a conulta **/
apply "CHOOSE":U to btRefresh in frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBrowse wWindow 
FUNCTION fnBrowse RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  fnBrowse
    Notes:  Busca os t°tulos dos campos do browse
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  no-undo.

if iTipo = 1 then do:
    case pCampo:
        when "cod-oficial":U then do:
            {utp/ut-liter.i "C¢digo"}
            assign cRetorno = trim(return-value).
        END.
        when "cod-ensaio":U then do:
            {utp/ut-liter.i "Ensaio"}
            assign cRetorno = trim(return-value).
        END.
        when "desc-dimensao":U then do:
            {utp/ut-liter.i "Descriá∆o"}
            assign cRetorno = trim(return-value).
        END.
        when "idi-estado-ensaio":U then do:
            {utp/ut-liter.i "Estado"}
            assign cRetorno = trim(return-value).
        END.
        when "log-padrao":U then do:
            {utp/ut-liter.i "Padr∆o"}
            assign cRetorno = trim(return-value).
        END.
        when "des-val-restdo":U then do:
            {utp/ut-liter.i "Resultado"}
            assign cRetorno = trim(return-value).
        END.
        when "des-val-max":U then do:
            {utp/ut-liter.i "M†ximo"}
            assign cRetorno = trim(return-value).
        END.
        when "des-val-min":U then do:
            {utp/ut-liter.i "M°nimo"}
            assign cRetorno = trim(return-value).
        END.
        when "num-tabela":U then do:
            {utp/ut-liter.i "Tabela"}
            assign cRetorno = trim(return-value).
        END.
        when "idi-tip-restdo":U then do:
            {utp/ut-liter.i "Tipo_Resultado"}
            assign cRetorno = trim(return-value).
        END.
        when "dat-result":U then do:
            if avail ttDados then do:
                if ttDados.d-data-ult-amostra <> ? then do:
                    assign cRetorno = string (ttDados.d-data-ult-amostra,"99/99/9999":U).
                end.
                else do:
                    {utp/ut-liter.i Èltimo_Resultado * }
                        assign cRetorno = trim(return-value).
                end.
            end.
            else do:
                {utp/ut-liter.i Èltimo_Resultado * }
                    assign cRetorno = trim(return-value).
            end.
        end.
        when "dat-result-ant":U then do:
            if avail ttDados then do:
                if ttDados.d-data-penult-amostra <> ? then do:
                    assign cRetorno = string(ttDados.d-data-penult-amostra,"99/99/9999":U).
                end.
                else do:
                    {utp/ut-liter.i Pen£ltimo_Resultado * }
                        assign cRetorno = trim(return-value).
                end.
            end.
            else do:
                {utp/ut-liter.i Pen£ltimo_Resultado * }
                    assign cRetorno = trim(return-value).
            end.
        end.
        when "cDescStatus":U then do:
            {utp/ut-liter.i "Estado"}
            assign cRetorno = trim(return-value).
        END.
        when "cDescResult":U then do:
            {utp/ut-liter.i "Tipo_Resultado"}
            assign cRetorno = trim(return-value).
        END.
        when "cDescLog":U then do:
            {utp/ut-liter.i "Padr∆o"}
            assign cRetorno = trim(return-value).
        END.
    end case.
END.
else do:
    case pCampo:
        when "cod-oficial":U then do:
            assign cRetorno = ttDados.cod-oficial.
        END.
        when "cod-ensaio":U then do:
            assign cRetorno = ttDados.cod-ensaio.
        END.
        when "desc-dimensao":U then do:
            assign cRetorno = ttDados.desc-dimensao.
        END.
        when "idi-estado-ensaio":U then do:
            assign cRetorno = string(ttDados.idi-estado-ensaio,"9").
        END.
        when "log-padrao":U then do:
            assign cRetorno = string(ttDados.log-padrao).
        END.
        when "des-val-restdo":U then do:
            assign cRetorno = ttDados.des-val-restdo.
        END.
        when "des-val-max":U then do:
            assign cRetorno = ttDados.des-val-max.
        END.
        when "des-val-min":U then do:
            assign cRetorno = ttDados.des-val-min.
        END.
        when "num-tabela":U then do:
            assign cRetorno = string(ttDados.num-tabela,">>>>9").
        END.
        when "idi-tip-restdo":U then do:
            assign cRetorno = string(ttDados.idi-tip-restdo,"9").
        END.
        when "dat-result":U then do:
            /** Busca o £ltimo resultado **/
            if avail ttDados then do:
                if ttDados.num-ult-amostra-oleo <> 0 then do:
                    for first mao-restdo-ensaio
                        where mao-restdo-ensaio.num-amostra-oleo = ttDados.num-ult-amostra-oleo
                        and   mao-restdo-ensaio.cod-ensaio       = ttDados.cod-ensaio no-lock:
                        assign cRetorno = string(mao-restdo-ensaio.des-val-restdo /*,ttDados.des-formato*/ ).
                    end.
                    if not avail mao-restdo-ensaio or ttDados.num-ult-amostra-oleo = 0 then
                        assign cRetorno = "".
                end.
            end.
            else assign cRetorno = "".
        end.
        when "dat-result-ant":U then do:
            /** Busca o pen£ltimo resultado **/
            if avail ttDados then do:
                if ttDados.num-penult-amostra-oleo <> 0 then do:
                    for first mao-restdo-ensaio
                        where mao-restdo-ensaio.num-amostra-oleo = ttDados.num-penult-amostra-oleo
                        and   mao-restdo-ensaio.cod-ensaio       = ttDados.cod-ensaio no-lock:
                        assign cRetorno = string(mao-restdo-ensaio.des-val-restdo /*,ttDados.des-formato*/ ).
                    end.
                    if not avail mao-restdo-ensaio or ttDados.num-penult-amostra-oleo = 0 then
                        assign cRetorno = "".
                end.
            end.
            else assign cRetorno = "".
        end.
        when "cDescStatus":U then do:
            assign cRetorno = fnStatus(ttDados.idi-estado-ensaio).
        END.
        when "cDescResult":U then do:
            assign  cRetorno =  fnResultado(ttDados.idi-tip-restdo).
        END.
        when "cDescLog":U then do:
            assign cRetorno = fnLog(ttDados.log-padrao).
        END.
    end case.
END.

RETURN cRetorno. /* Retorno da Funá∆o */

END function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnImages wWindow 
FUNCTION fnImages RETURNS CHARACTER
  ( pImage AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  fnImages
    Notes:  Busca o caminho da imagem passada
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

    CASE    pImage:
        WHEN    1   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-mater.bmp".
        WHEN    2   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-emp.bmp".
        WHEN    3   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-emsdis.bmp".
        WHEN    4   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-mod-eqpto.bmp".
        WHEN    5   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-comp.bmp".
        WHEN    6   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-calendario.bmp".
        WHEN    7   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-cop3.bmp".
        WHEN    8   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-ampr3.bmp".
        WHEN    9   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-tag.bmp".
        WHEN    10  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-fin.bmp".
        WHEN    11  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-negoc.bmp".
        OTHERWISE           ASSIGN  cRetorno    =   "image/treeview/tvpics/field.bmp".
    END.

    RETURN cRetorno.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnLabels
    Notes:  Busca a label da imagem pasada
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

    /** T°tulo do browse **/
    {aop/ao0302.i2 pImage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLog wWindow 
FUNCTION fnLog RETURNS CHARACTER
  ( pLog as logical ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(5)" NO-UNDO.
if pLog  then do:
 {utp/ut-liter.i Sim * }
  assign cDesc =  return-value.   
end.
else do:
 {utp/ut-liter.i N∆o * }
  assign cDesc =  return-value.   
end.
RETURN cDesc.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnResultado wWindow 
FUNCTION fnResultado RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.
if pEstado <> 0  then DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {frinc/i00fr103.i 04 pEstado }.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  cDesc = RETURN-VALUE.
    &else
        ASSIGN cDesc = {frinc/i00fr103.i 04 pEstado }.
    &endif
END.
else
  assign cDesc  = "":u.


  RETURN cDesc.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus wWindow 
FUNCTION fnStatus RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.
if pEstado <> 0 then DO:
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao003 = {frinc/i00fr105.i 04 pEstado }.
       run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                           INPUT "",
                           INPUT "").
       ASSIGN  cDesc = RETURN-VALUE.
   &else
       ASSIGN cDesc = {frinc/i00fr105.i 04 pEstado }.
   &endif
END.
else 
   assign cDesc = "":u.


  RETURN cDesc.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatusAmostra wWindow 
FUNCTION fnStatusAmostra RETURNS CHARACTER
  ( pCodOficial as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(22)" NO-UNDO.

for first mao-amostra-oleo fields (idi-estado-amostra)
   where mao-amostra-oleo.cod-amostra-fisic = pCodOficial no-lock:
end.
IF AVAIL mao-amostra-oleo AND mao-amostra-oleo.idi-estado-amostra <> 0 THEN DO:
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao004 = {frinc/i00fr105.i 04 mao-amostra-oleo.idi-estado-amostra }.
       run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                           INPUT "",
                           INPUT "").
       ASSIGN  cDesc = RETURN-VALUE.
   &else
       ASSIGN cDesc = {frinc/i00fr105.i 04 mao-amostra-oleo.idi-estado-amostra }.
   &endif
END.
ELSE
    assign cDesc = "":U.

  RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

