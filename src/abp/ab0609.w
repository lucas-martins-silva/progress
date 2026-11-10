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

USING com.totvs.framework.utp.treelist.*.

{include/i-prgvrs.i AB0609 2.00.00.027 } /*** "010027" 16/09/2024 11:31:24 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0609 MAB}
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
&GLOBAL-DEFINE Program        AB0609
&GLOBAL-DEFINE Version        2.00.00.027

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              btImprimir btRedimensiona brDetalhe ~
                              btExcel btTxt

/* Local Variable Definitions ---             */

define variable c-arquivo        as character                     no-undo.
define variable i-cont           as integer                       no-undo.
define variable iVisao           as integer                       no-undo.
define variable cSub             as character                     no-undo.
define variable cEvento          as character                     no-undo.
define variable iManut           as integer                       no-undo.
define variable lReal            as logical                       no-undo.
define variable hHandle          as handle                        no-undo.

/** Busca Valor **/                                            
define variable rRowid           as rowid                         no-undo.
define variable cCodPai          as character format "x(20)"      no-undo.
define variable vCodigo          as character format "x(20)"      no-undo.
define variable vCodigoOf        as character format "x(20)"      no-undo.
define variable vDescricao       as character format "x(32)"      no-undo.
define variable iImage           as integer                       no-undo.

DEFINE VARIABLE oTreeList   AS CLASS TotvsTreeList  NO-UNDO. //Visao

/** Controles **/                                              
define variable l-expande        as log init no                   no-undo.
define variable l-ok             as log                           no-undo.
define variable i-button-tree    as int init 1                    no-undo.
define variable i-result         as int                           no-undo.
/** Pop-Menu **/                                               
define variable pop-menu         as widget-handle                 no-undo.
define variable exp-con          as widget-handle                 no-undo.
define variable detalhe          as widget-handle                 no-undo.
define variable regua            as widget-handle                 no-undo.
/*** Window ***/                                               
define variable dWinXC           as decimal                       no-undo.
define variable dWinYC           as decimal                       no-undo.
/** C†lculo **/
define variable deQuantidade     as decimal                       no-undo.
define variable deConsumo        as decimal                       no-undo.
define variable deConsumoSec     as decimal                       no-undo.
define variable deConsumoPad     as decimal                       no-undo.
define variable deConsumoPadSec  as decimal                       no-undo.
define variable deConsumoReal    as decimal                       no-undo.
define variable deConsumoRealSec as decimal                       no-undo.
define variable deDesperdicio    as decimal                       no-undo.
define variable deDesperdicioSec as decimal                       no-undo.
define variable deGanho          as decimal                       no-undo.
define variable deGanhoSec       as decimal                       no-undo.
define variable iTipoConsumo     as integer                       no-undo.
define variable iTipoConsumoSec  as integer                       no-undo.
define variable lDesperdicio     as logical                       no-undo.
define variable lDesperdicioSec  as logical                       no-undo.
define variable lIrregular       as logical                       no-undo.
define variable lIrregularSec    as logical                       no-undo.
define variable deParam14        as decimal                       no-undo.
define variable deParam15        as decimal                       no-undo.
define variable deParam16        as decimal                       no-undo.
define variable cTpMater         like mab-tip-mater.cod-tip-mater no-undo.
define variable lVerificaHistorico AS LOGICAL                  no-undo.
/** TXT e Excel **/
define variable cTituloTxt    as character format "x(256)"  no-undo.
define variable cDescPai      as character format "x(256)"  no-undo.
define variable i-cont2       as integer                    no-undo.
DEFINE VARIABLE iVisaoAux3    AS INTEGER                    NO-UNDO.
DEFINE VARIABLE iVisaoAux     AS INTEGER                    NO-UNDO.
DEFINE VARIABLE l-first       AS LOGICAL                    NO-UNDO.
define variable i-lin         as integer initial 1          no-undo.
define variable i-lin2        as integer initial 1          no-undo.
define variable i-col         as integer initial 1          no-undo.
define variable c-colunas     as character                  no-undo.
define variable cDimensao     as character                  no-undo.
define variable cDimensaoPai  as character                  no-undo.
define variable cTexto        as character format "x(11)"   no-undo.
define variable hHandle2      as handle                     no-undo.
DEFINE VARIABLE iControl      as integer initial 0          no-undo. /**Controle para formataá∆o da celula***/
define variable i-impressao   as integer                    no-undo.
define variable cCaminho      as character format "x(300)"  no-undo. /*Indica o caminho */
define variable cDelimitador  as character format "x(01)"   no-undo. /*Indica o tipo de delimitador */
define variable lCabecalho    as logical   initial no       no-undo. /*Indica se gera cabeáalho */
DEFINE VARIABLE iVisao2       AS integer                    NO-UNDO.
DEFINE VARIABLE dt-ini-historico AS DATE                    NO-UNDO.
DEFINE VARIABLE dt-fim-historico AS DATE                    NO-UNDO.
DEFINE BUFFER b-mab-histor-ativ FOR mab-histor-ativ.


/* Inicio IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
DEFINE VARIABLE hHandleDetalhe AS HANDLE                    NO-UNDO.
DEFINE VARIABLE iContColDet    AS INTEGER                   NO-UNDO.
DEFINE VARIABLE lVisaoPorItem  AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE l-novo-docto   AS LOGICAL                   NO-UNDO.
/* Final IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */

{abp/ab0609.i}    /** Definiá∆o da temp-table de parÉmetros **/

/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    FIELD lConsumo AS LOGICAL /* Quando YES deve ser calculado o Percurso */
    index codigo is primary unique sequencia.

/** Dados **/
def temp-table ttDados no-undo
    field sequencia           as   integer
    field cod-dimensao        as   character format "x(300)"
    field cod-oficial         as   character format "X(20)"
    field desc-dimensao       as   character format "x(32)"
    field cod-dimens-pai      as   character format "x(300)"
    field qtd-combustivel     as   decimal   format "->,>>>,>>9.9999"
    field val-percurso        as   decimal   format "->,>>>,>>9.99"
    field val-per-pad         as   decimal   format "->,>>>,>>9.99"
    field un                  like mab-model.un
    field relacao             as   character format "x(5)"
    field val-real            as   decimal   format "->,>>>,>>9.9999"
    field val-padrao          as   decimal   format "->,>>>,>>9.9999"
    field val-desperdicio     as   decimal   format "->,>>>,>>9.9999"
    field val-ganho           as   decimal   format "->,>>>,>>9.9999"
    field de-desvio           as   decimal   format "->,>>>,>>9.99"
    field l-desperdicio       as   logical
    field l-irregular         as   logical
    field r-rowid             as   rowid
    field p-image             as   integer
    field seq-tree            as   integer
    field val-percurso-sec    as   decimal   format "->,>>>,>>9.99"
    field val-per-pad-sec     as   decimal   format "->,>>>,>>9.99"
    field relacao-sec         as   character format "x(5)"
    field val-real-sec        as   decimal   format "->,>>>,>>9.9999"
    field val-padrao-sec      as   decimal   format "->,>>>,>>9.9999"
    field val-desperdicio-sec as   decimal   format "->,>>>,>>9.9999"
    field val-ganho-sec       as   decimal   format "->,>>>,>>9.9999"
    field de-desvio-sec       as   decimal   format "->,>>>,>>9.99"
    field l-desperdicio-sec   as   logical
    field l-irregular-sec     as   logical
    field l-LogContSec        as   logical
    FIELD l-VisaoPorItem      AS   LOGICAL /* Criado no IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
    index id is primary unique sequencia ascending
                               cod-dimensao ascending
    index qtd-combustivel      qtd-combustivel descending.

define buffer bfttDados  for ttDados.
define buffer bfttDados2 for ttDados.
define buffer bfttVisao  for ttVisao.

/** Definiá∆o da temp-table para integraá∆o com EMS 5 (Projeto 105 - Unificaá∆o de Conceito **/    
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
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttDados.cod-oficial ttDados.desc-dimensao ttDados.qtd-combustivel ttDados.un ttDados.val-per-pad ttDados.val-percurso ttDados.val-padrao ttDados.val-real ttDados.relacao ttDados.de-desvio ttDados.val-per-pad-sec ttDados.val-percurso-sec ttDados.val-padrao-sec ttDados.val-real-sec ttDados.relacao-sec ttDados.de-desvio-sec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalhe   
&Scoped-define SELF-NAME brDetalhe
&Scoped-define QUERY-STRING-brDetalhe for each ttDados no-lock
&Scoped-define OPEN-QUERY-brDetalhe open query {&SELF-NAME} for each ttDados no-lock.
&Scoped-define TABLES-IN-QUERY-brDetalhe ttDados
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalhe ttDados


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDetalhe}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btAbrir btSalvar btRefresh ~
btExpande btParam btFiltro btVisao btImprimir btExcel btTxt btQueryJoins ~
btReportsJoins btExit btHelp btRedimensiona brDetalhe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBrowse wWindow 
FUNCTION fnBrowse RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesvio wWindow 
FUNCTION fnDesvio RETURNS DECIMAL
  ( pPadrao as dec,
    pReal   as dec,
    iTipo   AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMes wWindow 
FUNCTION fnMes RETURNS CHARACTER
  ( iMes as int )  FORWARD.

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
       RULE
       MENU-ITEM miSelecao      LABEL "Se&leá∆o"       ACCELERATOR "CTRL-P"
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM miClassifica   LABEL "&Classifica"    ACCELERATOR "CTRL-C"
       RULE
       MENU-ITEM miEvento       LABEL "E&ventos"       ACCELERATOR "CTRL-E"
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-J"
       MENU-ITEM miExcel        LABEL "E&xcel"         ACCELERATOR "CTRL-L"
       MENU-ITEM miTxt          LABEL "&Texto"         ACCELERATOR "CTRL-T"
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

DEFINE BUTTON btEvento 
     IMAGE-UP FILE "image/im-mov.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mov.bmp":U
     LABEL "Eventos" 
     SIZE 4 BY 1.25 TOOLTIP "Eventos".

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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
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
      ttDados.cod-oficial      width 20
ttDados.desc-dimensao    width 30
ttDados.qtd-combustivel  width 10
ttDados.un               width 03
ttDados.val-per-pad      width 12
ttDados.val-percurso     width 12
ttDados.val-padrao       width 15
ttDados.val-real         width 15
ttDados.relacao          width 05
ttDados.de-desvio        width 10
ttDados.val-per-pad-sec  width 12
ttDados.val-percurso-sec width 12
ttDados.val-padrao-sec   width 15
ttDados.val-real-sec     width 15
ttDados.relacao-sec      width 05
ttDados.de-desvio-sec    width 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 8.5
         FONT 1
         TITLE "".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btAbrir AT ROW 1.13 COL 2
     btSalvar AT ROW 1.13 COL 6
     btRefresh AT ROW 1.13 COL 10
     btExpande AT ROW 1.13 COL 16
     btParam AT ROW 1.13 COL 43 HELP
          "ParÉmetros"
     btFiltro AT ROW 1.13 COL 47 HELP
          "Filtro"
     btVisao AT ROW 1.13 COL 51 HELP
          "Classifica"
     btEvento AT ROW 1.13 COL 55 HELP
          "Eventos"
     btImprimir AT ROW 1.13 COL 59 HELP
          "Impress∆o"
     btExcel AT ROW 1.13 COL 63
     btTxt AT ROW 1.13 COL 67
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btRedimensiona AT ROW 11 COL 1
     brDetalhe AT ROW 11.21 COL 1
     rtToolBar-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(8.50)
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
         HEIGHT             = 18.88
         WIDTH              = 90
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

/* SETTINGS FOR BUTTON btEvento IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDetalhe
/* Query rebuild information for BROWSE brDetalhe
     _START_FREEFORM
open query {&SELF-NAME} for each ttDados no-lock.
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
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 + dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 + dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 + dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 + dXC)
           btParam:column in frame fPage0          = (btParam:column in frame fPage0 + dXC)
           btFiltro:column in frame fPage0         = (btFiltro:column in frame fPage0 + dXC)
           btVisao:column in frame fPage0          = (btVisao:column in frame fPage0 + dXC)
           btEvento:column in frame fPage0         = (btEvento:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 + dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 + dXC)
           btTxt:column in frame fPage0            = (btTxt:column in frame fPage0 + dXC)
           brDetalhe:width-chars in frame fPage0   = (brDetalhe:width-chars in frame fPage0 + dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 + dXC)
           btRedimensiona:row in frame fPage0      = (btRedimensiona:row in frame fPage0 + (dYC / 2))
           oTreeList:width                         = oTreeList:width   + dXC 
           oTreeList:HEIGHT                        = oTreeList:HEIGHT  + dYC 
           NO-ERROR.

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
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 - dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 - dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 - dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 - dXC)
           btParam:column in frame fPage0          = (btParam:column in frame fPage0 - dXC)
           btFiltro:column in frame fPage0         = (btFiltro:column in frame fPage0 - dXC)
           btVisao:column in frame fPage0          = (btVisao:column in frame fPage0 - dXC)
           btEvento:column in frame fPage0         = (btEvento:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 - dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 - dXC)
           btTxt:column in frame fPage0            = (btTxt:column in frame fPage0 - dXC)
           brDetalhe:width-chars in frame fPage0   = (brDetalhe:width-chars in frame fPage0 - dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 - dXC)
           btRedimensiona:row in frame fPage0      = 11
           oTreeList:width                         = oTreeList:width  - dXC
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars.
           frame fPage0:height-chars               = wWindow:HEIGHT-CHARS   NO-ERROR.

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
        if ttDados.l-irregular OR ttDados.l-irregular-sec then do:
            assign ttDados.cod-oficial:fgcolor     in browse brDetalhe = 12
                   ttDados.desc-dimensao:fgcolor   in browse brDetalhe = 12
                   ttDados.qtd-combustivel:fgcolor in browse brDetalhe = 12
                   ttDados.un:fgcolor              in browse brDetalhe = 12
                   ttDados.val-per-pad:fgcolor     in browse brDetalhe = 12
                   ttDados.val-percurso:fgcolor    in browse brDetalhe = 12
                   ttDados.relacao:fgcolor         in browse brDetalhe = 12
                   ttDados.val-padrao:fgcolor      in browse brDetalhe = 12
                   ttDados.val-real:fgcolor        in browse brDetalhe = 12
                   ttDados.de-desvio:fgcolor       in browse brDetalhe = 12.
            IF  ttSelecao.lLogContSec THEN DO:
                ASSIGN ttDados.val-per-pad-sec:fgcolor  in browse brDetalhe = 12
                       ttDados.val-percurso-sec:fgcolor in browse brDetalhe = 12
                       ttDados.relacao-sec:fgcolor      in browse brDetalhe = 12
                       ttDados.val-padrao-sec:fgcolor   in browse brDetalhe = 12
                       ttDados.val-real-sec:fgcolor     in browse brDetalhe = 12
                       ttDados.de-desvio-sec:fgcolor    in browse brDetalhe = 12.
            END.
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


&Scoped-define SELF-NAME btEvento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEvento wWindow
ON CHOOSE OF btEvento IN FRAME fpage0 /* Eventos */
OR CHOOSE OF MENU-ITEM miEvento  IN MENU mbMain DO:
    if  oTreeList:hasNode() then do:
        run piEvento in this-procedure.
    end.
    apply "ENTRY":U to btEvento in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM miExcel  IN MENU mbMain DO:
    if  oTreeList:hasNode() then do:
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
    IF  oTreeList:hasNode() THEN DO:
        /** Controla expansío **/
        assign l-expande = not l-expande.

        IF  l-expande   THEN    oTreeList:expandAll().
        ELSE                    oTreeList:collapseAll().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM miFiltro  IN MENU mbMain DO:

  assign {&window-name}:sensitive = no.
  run abp/ab0609a.w (input-output  table ttSelecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btFiltro in frame fPage0.
  find first ttSelecao no-lock no-error.
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
    if  oTreeList:hasNode() then do:
        run piImprimir in this-procedure.
    end.
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miSelecao  IN MENU mbMain DO:

  assign {&window-name}:sensitive = no.
  run abp/ab0609c.w (input-output  table ttSelecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btParam in frame fPage0.
  find first ttSelecao no-lock no-error.
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

    if btRedimensiona:row < 7.5 then
     assign btRedimensiona:row = 7.5.

    if btRedimensiona:row > frame fPage0:height then
       assign btRedimensiona:row = frame fPage0:height - 1.
    
    assign oTreeList:height = btRedimensiona:row - 2.5 no-error.         
    
    assign brDetalhe:row = btRedimensiona:row + btRedimensiona:height no-error.
    assign brDetalhe:height  = frame fPage0:height + 0.5
                                 - (btRedimensiona:row) no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wWindow
ON CHOOSE OF btRefresh IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAtualizar  IN MENU mbMain DO:

/** Controla expans∆o **/
if l-expande then assign l-expande = no.
ASSIGN brDetalhe:title in frame fPage0    = ""
       btEvento:sensitive in frame fPage0 = no.

session:set-wait-state ("GENERAL").
run piAtualizar in this-procedure.
session:set-wait-state ("").

oTreeList:applyEntry().

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
   assign c-arquivo = replace(c-arquivo, "/", "/")                       
          c-arquivo = "ab0609.dat":U.
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
      for first ttSelecao:
           IF l-usa-unid-negoc THEN DO:
              &IF DEFINED (bf_mnt_ems206b) &THEN
                  export delimiter ";"
                           ttSelecao.empresa-ini   
                           ttSelecao.empresa-fim   
                           ttSelecao.equipto-ini   
                           ttSelecao.equipto-fim   
                           ttSelecao.grupo-ini     
                           ttSelecao.grupo-fim     
                           ttSelecao.modelo-ini    
                           ttSelecao.modelo-fim    
                           ttSelecao.estab-ini     
                           ttSelecao.estab-fim     
                           ttSelecao.tag-ini       
                           ttSelecao.tag-fim       
                           ttSelecao.estrut-ini    
                           ttSelecao.estrut-fim    
                           ttSelecao.cc-cod-eqpto-ini   
                           ttSelecao.cc-cod-eqpto-fim   
                           ttSelecao.sit-ini       
                           ttSelecao.sit-fim       
                           ttSelecao.atividade-ini 
                           ttSelecao.atividade-fim 
                           ttSelecao.periodo-ini   
                           ttSelecao.periodo-fim   
                           ttSelecao.trajeto-ini   
                           ttSelecao.trajeto-fim 
                           ttSelecao.cc-cod-docto-ini      
                           ttSelecao.cc-cod-docto-fim
                           ttSelecao.lAtivos       
                           ttSelecao.lProprios     
                           ttSelecao.lInativos     
                           ttSelecao.lTerceiros    
                           ttSelecao.lOK           
                           ttSelecao.lIrregular
                           ttSelecao.lLogContSec
                           ttSelecao.lDesperdicio  
                           ttSelecao.classificacao
                           ttSelecao.cod-emitente-ini 
                           ttSelecao.cod-emitente-fim
                           ttSelecao.cod-unid-negoc-ini
                           ttSelecao.cod-unid-negoc-fim.
              &ENDIF
           END.
           ELSE DO:               
              export delimiter ";"
                       ttSelecao.empresa-ini   
                       ttSelecao.empresa-fim   
                       ttSelecao.equipto-ini   
                       ttSelecao.equipto-fim   
                       ttSelecao.grupo-ini     
                       ttSelecao.grupo-fim     
                       ttSelecao.modelo-ini    
                       ttSelecao.modelo-fim    
                       ttSelecao.estab-ini     
                       ttSelecao.estab-fim     
                       ttSelecao.tag-ini       
                       ttSelecao.tag-fim       
                       ttSelecao.estrut-ini    
                       ttSelecao.estrut-fim    
                       ttSelecao.cc-cod-eqpto-ini   
                       ttSelecao.cc-cod-eqpto-fim   
                       ttSelecao.sit-ini       
                       ttSelecao.sit-fim       
                       ttSelecao.atividade-ini 
                       ttSelecao.atividade-fim 
                       ttSelecao.periodo-ini   
                       ttSelecao.periodo-fim   
                       ttSelecao.trajeto-ini   
                       ttSelecao.trajeto-fim 
                       ttSelecao.cc-cod-docto-ini      
                       ttSelecao.cc-cod-docto-fim
                       ttSelecao.lAtivos       
                       ttSelecao.lProprios     
                       ttSelecao.lInativos     
                       ttSelecao.lTerceiros    
                       ttSelecao.lOK           
                       ttSelecao.lIrregular
                       ttSelecao.lLogContSec
                       ttSelecao.lDesperdicio  
                       ttSelecao.classificacao
                       ttSelecao.cod-emitente-ini 
                       ttSelecao.cod-emitente-fim.
           END.
      END.
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
    if  oTreeList:hasNode() then do:
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
  run abp/ab0609b.w (input-output table ttVisao).
  assign {&window-name}:sensitive = yes.

  apply "ENTRY":U to btVisao in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
/** Criaá∆o do pop menu do tree-view **/
create menu pop-menu
    assign popup-only = true
           title = "POPUP":u.
create menu-item exp-con
    assign parent = pop-menu.
create menu-item regua
    assign parent  = pop-menu
           subtype = "RULE":u.

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

/** Trigger de choose do pop menu "Expande" **/
on choose of exp-con do:
end.

btRedimensiona:load-mouse-pointer ("image/size2.cur") in frame fPage0.

{abp/abapi001.i2} /** Criaá∆o de Erros **/
{abp/ab9005.i}    /** Validaá∆o de parÉmetros **/

/** Chama todas os centro custo do sistema **/
RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccusto.
/*carrega os dados */
RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  "",                         /* EMPRESA EMS2             */
                                             INPUT  "",                         /* CODIGO DO PLANO CCUSTO   */
                                             INPUT  "",                         /* UNIDADE DE NEGOCIO       */
                                             INPUT  TODAY,                      /* DATA DE TRANSACAO        */
                                             OUTPUT TABLE tt_ccusto_integr,     /* CCUSTOS                  */
                                             OUTPUT TABLE tt_log_erro).         /* ERROS                    */

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
  Notes:       Override ap¢s fechar a tela
------------------------------------------------------------------------------*/
/** Elimina handle do programa **/
/* IF VALID-HANDLE (hHandle) THEN */
/*     DELETE PROCEDURE hHandle.  */

/** Elimina aplicativo **/
{method/showmessage.i3}

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
assign ttDados.cod-oficial:label in browse brDetalhe     = fnBrowse("cod-oficial":U,1)
       ttDados.desc-dimensao:label in browse brDetalhe   = fnBrowse("desc-dimensao":U,1)
       ttDados.qtd-combustivel:label in browse brDetalhe = fnBrowse("qtd-combustivel":U,1)
       ttDados.un:label in browse brDetalhe              = fnBrowse("un":U,1)
       ttDados.val-per-pad:label in browse brDetalhe     = fnBrowse("val-per-pad":U,1)
       ttDados.val-percurso:label in browse brDetalhe    = fnBrowse("val-percurso":U,1)
       ttDados.relacao:label in browse brDetalhe         = "":U
       ttDados.val-padrao:label in browse brDetalhe      = fnBrowse("val-padrao":U,1)
       ttDados.val-real:label in browse brDetalhe        = fnBrowse("val-real":U,1)
       ttDados.de-desvio:label in browse brDetalhe       = fnBrowse("de-desvio":U,1)
       ttDados.val-per-pad-sec:label in browse brDetalhe  = fnBrowse("val-per-pad-sec":U,1)
       ttDados.val-percurso-sec:label in browse brDetalhe = fnBrowse("val-percurso-sec":U,1)
       ttDados.relacao-sec:label in browse brDetalhe      = "":U
       ttDados.val-padrao-sec:label in browse brDetalhe   = fnBrowse("val-padrao-sec":U,1)
       ttDados.val-real-sec:label in browse brDetalhe     = fnBrowse("val-real-sec":U,1)
       ttDados.de-desvio-sec:label in browse brDetalhe    = fnBrowse("de-desvio-sec":U,1).

/** C¢digo Sub Sistema **/
for each  mab-param fields(des-valor cdn-param)
    where mab-param.cdn-param = 19 
    or    mab-param.cdn-param = 21
    or    mab-param.cdn-param = 23 no-lock: 
    case mab-param.cdn-param:
        when 19 then assign cEvento = mab-param.des-valor.
        when 21 then assign iManut  = int(mab-param.des-valor).
        when 23 then assign cSub    = mab-param.des-valor.
    end case.
end.

/* -------------------------- */
/* Monta o Browse do TreeList */
/* -------------------------- */

oTreeList               =   NEW TOTVSTreeList().
oTreeList:parentFrame   =   FRAME   fpage0:HANDLE.
oTreeList:parentProg    =   THIS-PROCEDURE.

oTreeList:setSize(2.5, 1, 90, 8.5).

oTreeList:AddColumn("r-rowid"      , "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("r-rowid-visao", "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("p-image"      , "integer"  , 0, ">9"    , "", "", TRUE).

oTreeList:INITIALIZE().
oTreeList:emptyTreeList().

ASSIGN  oTreeList:browseTreeList:SEPARATORS         =   FALSE.
ASSIGN  oTreeList:browseTreeList:FIT-LAST-COLUMN    =   TRUE.

oTreeList:setColumnLabel("cEstrutura", "").

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaBrowse wWindow 
PROCEDURE atualizaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     atualizaBrowse
  Parameters:  <none>
  Notes:       Mostra registros no browse
------------------------------------------------------------------------------*/
/** Se tiver filhos, mostra no browse, os filhos **/
if avail ttDados then do:
    run tituloBrowse in this-procedure (ttDados.p-image).
    for first ttSelecao no-lock:
    end.

    if ttSelecao.classificacao = 1 then do:
        open query brDetalhe for each  ttDados
                             where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                             by    ttDados.cod-dimensao.
    end.
    else do:
        if ttSelecao.classifica = 2 then do:
            open query brDetalhe for each  ttDados
                                     where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                                     outer-join by ttDados.qtd-combustivel descending.
        end.
    end.
end.
/** Sen∆o, mostra ele mesmo **/
else do:
    run tituloBrowse in this-procedure (bfttDados.p-image).
    open query brDetalhe for each  ttDados
                             where ttDados.cod-dimensao = bfttDados.cod-dimensao no-lock.

end.

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
/** Valida se os par∆metros est∆o cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "14,15,16,19,21,23":U,
                                               input trim(return-value)).
if return-value = "NOK":U then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    empty temp-table RowErrors.
    /** Elimina aplicativo **/
    {method/showmessage.i3}
    return "NOK":U.
end.

assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

run criattSelecao in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEvent wWindow 
PROCEDURE browseEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT   PARAMETER   cEvent  AS  CHARACTER   NO-UNDO.
    DEFINE  INPUT   PARAMETER   cNodeId AS  CHARACTER   NO-UNDO.
     
    DEFINE  VARIABLE    rRow    AS  ROWID   NO-UNDO.

    IF  (cEvent =   "selected"  OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:
        /** Habilita Eventos se or Equipamento **/
        IF  INTEGER(oTreeList:getDataChar(cNodeId, "p-image"))  =   2   THEN
            ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   YES.
        ELSE 
            ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   NO.

        /** Guarda rowid do tree-view **/
        ASSIGN  rRow    =   TO-ROWID(oTreeList:getDataChar(cNodeId, "r-rowid-visao")).

        /** Busca Registro com rowid **/
        FOR FIRST   bfttDados 
            WHERE   ROWID(bfttDados)    =   rRow NO-LOCK:
        END.
        IF  NOT AVAIL   bfttdados   THEN    RETURN  NO-APPLY.

        /** Verifica se ele contem filhos **/
        FOR FIRST   ttDados
            WHERE   ttDados.cod-dimens-pai  =   bfttDados.cod-dimensao no-lock:
            IF  ttDados.p-image =   2   THEN    
                ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   YES.
        END.
        IF  AVAIL   ttDados THEN    DO:
            /** Mostra registros no browse **/
            RUN atualizaBrowse  IN  THIS-PROCEDURE.

            /* IRM001380-Contabilizacao Item Abastecimento / Lubrificacao */
            IF  ttDados.l-VisaoPorItem  THEN    DO:
                /*  Ocultar os campos abaixo quando o campo "ttDados.l-VisaoPorItem" tiver o valor "YES"
                    ou seja, n∆o exibir o campos abaixo quando for p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto), assim como todas as imagens 
                    que esteja em niveis abaixo de p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto) */
                /*  Segue o que representa cada coluna do browse
                    5 - ttDados.val-per-pad     
                    6 - ttDados.val-percurso    
                    7 - ttDados.val-padrao      
                    8 - ttDados.val-real        
                    9 - ttDados.relacao         
                    10 - ttDados.de-desvio       
                    11 - ttDados.val-per-pad-sec 
                    12 - ttDados.val-percurso-sec
                    13 - ttDados.val-padrao-sec  
                    14 - ttDados.val-real-sec    
                    15 - ttDados.relacao-sec     
                    16 - ttDados.de-desvio-sec    */          
                DO  iContColDet =   5   TO  16:
                    ASSIGN  hHandleDetalhe  =   brDetalhe:GET-BROWSE-COLUMN(iContColDet).
                            hHandleDetalhe:VISIBLE  =   FALSE.
                END.
            END.
        END.
    END.

    RETURN  "OK".
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
assign vCodigo    = ""
       vCodigoOf  = ""
       vDescricao = ""
       iImage     = 0
       rRowid     = ?.

/** Verifica tipo de vis∆o (classificaá∆o) **/
case substring(trim(pValorDimensao),1,2):
    /** Empresa **/
    when "01":U then do:
        if not avail empresa or empresa.ep-codigo <> mab-eqpto.ep-codigo then do:
            for first empresa fields(nome ep-codigo)  
                where empresa.ep-codigo = mab-eqpto.ep-codigo no-lock:
            end.
        end.
        if avail empresa then do:
            assign vCodigo    = string(mab-eqpto.ep-codigo, "999")
                   vDescricao = empresa.nome
                   iImage     = 1
                   rRowid     = rowid(empresa).
        end.
        ELSE DO:
            {utp/ut-liter.i "Empresa N∆o Encontrada" * }
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 1
                   rRowid     = rowid(mab-abastec-lubrific).
        END.
    end.
    /** Equipamento **/
    when "02":U then do:
        IF NOT AVAIL mab-eqpto THEN DO:
            FOR FIRST mab-eqpto WHERE
                      mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo AND
                      mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto NO-LOCK:
            END.
        END.
        IF AVAIL mab-eqpto THEN DO:
            IF NOT AVAIL mab-model OR mab-model.cod-model <> mab-eqpto.cod-model THEN DO:
                FOR FIRST mab-model fields(cod-marca des-model cod-model un cod-livre-1)
                    WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
                END.
                assign vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
                       vDescricao = mab-model.des-model
                       iImage     = 2
                       rRowid     = rowid(mab-eqpto).
            END.
            ELSE DO:
                assign vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
                       vDescricao = mab-model.des-model
                       iImage     = 2
                       rRowid     = rowid(mab-eqpto).
            END.
        END.
        ELSE DO:
            {utp/ut-liter.i "Equipamento N∆o Encontrado" }
            assign vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 2
                   rRowid     = rowid(mab-abastec-lubrific).
        END.
    end.
    /** Grupo Equipamento **/
    when "03":U then do:
        if not avail mab-grp-eqpto or mab-grp-eqpto.cod-grp-eqpto <> mab-eqpto.cod-grp-eqpto then do:
            for first mab-grp-eqpto fields(des-grp-eqpto cod-grp-eqpto)  
                where mab-grp-eqpto.cod-grp-eqpto = mab-eqpto.cod-grp-eqpto no-lock:
            end.
        end.
        if avail mab-grp-eqpto then do:
            assign vCodigo    = mab-eqpto.cod-grp-eqpto
                   vDescricao = mab-grp-eqpto.des-grp-eqpto
                   iImage     = 3
                   rRowid     = rowid(mab-grp-eqpto).
        end.
        else do:
            {utp/ut-liter.i Grupo_N∆o_Dispon°vel}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 3
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Modelo Equipamento **/
    when "04":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(cod-marca des-model cod-model un cod-livre-1)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
            assign vCodigo    = mab-eqpto.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 4
                   rRowid     = rowid(mab-model).
        end.
        else do:
            {utp/ut-liter.i Modelo_N∆o_Dispon°vel}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 4
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Estabelecimento **/
    when "05":U then do:
        if not avail estabelec or estabelec.cod-estabel <> mab-eqpto.cod-estabel then do:
            for first estabelec fields(nome cod-estabel)  
                where estabelec.cod-estabel = mab-eqpto.cod-estabel no-lock:
            end.
        end.
        if avail estabelec then do:
            assign vCodigo    = mab-eqpto.cod-estabel
                   vDescricao = estabelec.nome
                   iImage     = 5
                   rRowid     = rowid(estabelec).
        end.        
    end.
    /** TAG **/
    when "06":U then do:

          ASSIGN dt-ini-historico = 01/01/0001.

          REPEAT:

              FOR FIRST mab-histor-ativid FIELDS(cd-tag dat-cadastro)
                  WHERE mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto
                    AND mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo
                    AND mab-histor-ativid.dat-cadastro > dt-ini-historico NO-LOCK:
              END.
              
              IF NOT AVAIL mab-histor-ativid THEN LEAVE.
              
              ASSIGN dt-ini-historico = mab-histor-ativid.dat-cadastro.

              FOR FIRST b-mab-histor-ativ FIELDS(cd-tag dat-cadastro)
                  WHERE b-mab-histor-ativ.cod-eqpto = mab-eqpto.cod-eqpto
                    AND b-mab-histor-ativ.ep-codigo = mab-eqpto.ep-codigo
                    AND b-mab-histor-ativ.dat-cadastro > mab-histor-ativ.dat-cadastro NO-LOCK:

                    ASSIGN dt-fim-historico = b-mab-histor-ativ.dat-cadastro.
              END.
                
              IF mab-abastec-lubrific.dat-movto >= dt-ini-historico AND
                 mab-abastec-lubrific.dat-movto < dt-fim-historico  THEN 
                  LEAVE.
          END.

          IF NOT AVAIL mab-histor-ativid THEN
                FOR LAST mab-histor-ativ FIELDS(cd-tag)
                   WHERE mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto
                     AND mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo NO-LOCK:
                END.

        if not avail tag or tag.cd-tag <> mab-histor-ativid.cd-tag then do:
            for first tag fields(descricao cd-tag)  
                where tag.cd-tag = mab-histor-ativid.cd-tag no-lock:
            end.
        end.

        if avail tag then do:
            assign vCodigo    = if mab-histor-ativid.cd-tag = "" then "_" else mab-histor-ativid.cd-tag
                   vDescricao = tag.descricao
                   iImage     = 6
                   rRowid     = rowid(tag).
        end.

    end.
    /** Tipo Material **/
    when "07":U then do:
        if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> cTpMater then do:
            for first mab-tip-mater fields(des-tip-mater un cod-tip-mater)  
                where mab-tip-mater.cod-tip-mater = cTpMater no-lock:
            end.
        end.
        if avail mab-tip-mater then do:
            assign vCodigo    = cTpMater
                   vDescricao = mab-tip-mater.des-tip-mater
                   iImage     = 7
                   rRowid     = rowid(mab-tip-mater).
        end.
        else do:
            {utp/ut-liter.i Tipo_Material_N∆o_Dispon°vel}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 7
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Atividade **/
    when "08":U then do:
        if not avail mab-ativid or mab-ativid.cod-ativid <> mab-abastec-lubrific.cod-ativid then do:
            for first mab-ativid fields(des-ativid cod-ativid)  
                where mab-ativid.cod-ativid = mab-abastec-lubrific.cod-ativid no-lock:
            end.
        end.
        if avail mab-ativid then do:
            assign vCodigo    = mab-abastec-lubrific.cod-ativid
                   vDescricao = mab-ativid.des-ativid
                   iImage     = 8
                   rRowid     = rowid(mab-ativid).
        end.
        else do:
            {utp/ut-liter.i Atividade_N∆o_Dispon°vel}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 8
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Documento **/
    when "09":U then do:
        assign vCodigo    = string(mab-abastec-lubrific.num-docto, "999999999")
               iImage     = 9
               rRowid     = rowid(mab-abastec-lubrific). 
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN vDescricao = RETURN-VALUE.
        &else
            ASSIGN vDescricao = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN vDescricao = RETURN-VALUE.
        &else
            ASSIGN vDescricao = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
        &endif      
    end.
    /** Trajeto **/
    when "10":U then do:
        if not avail mab-trajeto or mab-trajeto.cod-rota <> mab-abastec-lubrific.cod-rota then do:
            for first mab-trajeto fields(des-rota cod-rota)  
                where mab-trajeto.cod-rota = mab-abastec-lubrific.cod-rota no-lock:
            end.
        end.
        if avail mab-trajeto then do:
            assign vCodigo    = mab-abastec-lubrific.cod-rota
                   vDescricao = mab-trajeto.des-rota
                   iImage     = 10
                   rRowid     = rowid(mab-trajeto).
        end.
        else do:
            {utp/ut-liter.i Trajeto_N∆o_Dipon°vel}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 10
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Data Movimento **/
    when "11":U then do:
        assign vCodigo    = substring(string(mab-abastec-lubrific.val-dat-hora-invrtda),1,8)
               vDescricao = string(mab-abastec-lubrific.dat-movto,"99/99/9999")
               iImage     = 11
               rRowid     = rowid(mab-abastec-lubrific).        
    end.
    /** Màs / Ano **/
    when "12":U then do:
        assign vCodigo    = string(year(mab-abastec-lubrific.dat-movto),"9999") + "/" + string(month(mab-abastec-lubrific.dat-movto),"99") 
               vCodigoOf  = string(month(mab-abastec-lubrific.dat-movto),"99") + "/" + string(year(mab-abastec-lubrific.dat-movto),"9999")
               vDescricao = fnMes(month(mab-abastec-lubrific.dat-movto)) + " " + string(year(mab-abastec-lubrific.dat-movto),"9999")
               iImage     = 12
               rRowid     = rowid(mab-abastec-lubrific). 
    end.
    /** Motorista **/
    when "13":U then do:
        if not avail mab-motoris or 
          (mab-motoris.ep-codigo   <> mab-abastec-lubrific.ep-codigo-matr  OR
           mab-motoris.cod-estabel <> mab-abastec-lubrific.cod-estabel-matr OR
           mab-motoris.cod-matr <> mab-abastec-lubrific.cod-matr) then do:
            for first mab-motoris fields(ep-codigo cod-estabel nom-motoris cod-matr)  
                WHERE mab-motoris.ep-codigo   = mab-abastec-lubrific.ep-codigo-matr  
                  AND mab-motoris.cod-estabel = mab-abastec-lubrific.cod-estabel-matr 
                  AND mab-motoris.cod-matr    = mab-abastec-lubrific.cod-matr no-lock:
            end.
        end.
        if avail mab-motoris then do:
            DEF VAR cEmp   AS CHAR NO-UNDO.
            DEF VAR cEstab AS CHAR NO-UNDO.
            DEF VAR cMatr  AS CHAR NO-UNDO.
            ASSIGN cEmp   = IF mab-abastec-lubrific.ep-codigo-matr = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF THEN "_"
                            ELSE string(mab-abastec-lubrific.ep-codigo-matr)
                   cEstab = IF mab-abastec-lubrific.cod-estabel-matr = "" THEN "_"
                            ELSE mab-abastec-lubrific.cod-estabel-matr
                   cMatr  = IF mab-abastec-lubrific.cod-matr = "" THEN "_"
                            ELSE mab-abastec-lubrific.cod-matr.

            assign vCodigo    = cEmp + "-" + cEstab + "-" + cMatr
                   vDescricao = mab-motoris.nom-motoris
                   iImage     = 13
                   rRowid     = rowid(mab-motoris).
        end. 
        ELSE DO:
            {utp/ut-liter.i Motorista_N∆o_Encontrado * }
            ASSIGN vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 13
                   rRowid     = rowid(mab-abastec-lubrific).
        END.
    end.
    /* centro de custo equipamento */
    when "14":U then do:
        if not avail tt_ccusto_integr or tt_ccusto_integr.ttv_cod_ccusto <> mab-eqpto.cc-codigo then do:
            for first tt_ccusto_integr fields(ttv_des_titulo ttv_cod_ccusto)  
                where tt_ccusto_integr.ttv_cod_ccusto = mab-eqpto.cc-codigo no-lock:
            end.
        end.
        if avail tt_ccusto_integr then do:
            assign vCodigo    = tt_ccusto_integr.ttv_cod_ccusto 
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 14
                   rRowid     = rowid(tt_ccusto_integr).
        end.
        else do:
            {utp/ut-liter.i Centro_Custo_Eqpto_N∆o_Encontrado }
            assign vCodigo    = mab-eqpto.cc-codigo 
                   vDescricao = RETURN-VALUE
                   iImage     = 14
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
   /** Marca **/
    when "15":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(cod-marca des-model cod-model un cod-marca cod-livre-1)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if not avail mab-marca or mab-marca.cod-marca <> mab-model.cod-marca then do:
            for first mab-marca fields(nom-marca cod-marca)  
                where mab-marca.cod-marca = mab-model.cod-marca no-lock:
            end.
        end.
        if avail mab-marca then do:
            assign vCodigo    = mab-marca.cod-marca
                   vDescricao = mab-marca.nom-marca
                   iImage     = 15
                   rRowid     = rowid(mab-marca).
        end.
        else do:
            {utp/ut-liter.i Marca_N∆o_Encontrada}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 15
                   rRowid     = rowid(mab-eqpto).
        end.
    end.

   /** Unidade Percurso - Ve°culo **/
    when "16":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(cod-marca des-model cod-model un cod-livre-1)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
           if not avail tab-unidade or tab-unidade.un <> mab-model.un then do:
                for first tab-unidade fields(descricao un)  
                    where tab-unidade.un = mab-model.un no-lock:
                end.
           END.
           IF AVAIL tab-unidade THEN DO:
               assign vCodigo    = mab-model.un
                      vDescricao = tab-unidade.descricao
                      iImage     = 16
                      rRowid     = rowid(mab-model).
           END.
        END.
    end.
    /* centro de custo docto */
    when "17":U then do:
        if not avail tt_ccusto_integr or tt_ccusto_integr.ttv_cod_ccusto <> mab-abastec-lubrific.cc-codigo then do:
            for first tt_ccusto_integr fields(ttv_des_titulo ttv_cod_ccusto)  
                where tt_ccusto_integr.ttv_cod_ccusto = mab-abastec-lubrific.cc-codigo no-lock:
            end.
        end.
        if avail tt_ccusto_integr then do:
            assign vCodigo    = tt_ccusto_integr.ttv_cod_ccusto 
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 17
                   rRowid     = rowid(tt_ccusto_integr).
        end.
        else do:
            {utp/ut-liter.i Centro_Custo_Docto_N∆o_Encontrado }
            assign vCodigo    = mab-abastec-lubrific.cc-codigo 
                   vDescricao = RETURN-VALUE
                   iImage     = 17
                   rRowid     = rowid(mab-abastec-lubrific).
        end.
    end.
    /* Estrutura Mecanica */
    when "18":U then do:
        if not avail mab-estrut-mec or mab-estrut-mec.cod-estrut-mec <> mab-eqpto.cod-estrut-mec then do:
            for first mab-estrut-mec fields(cod-estrut-mec des-estrut-mec)  
                where mab-estrut-mec.cod-estrut-mec = mab-eqpto.cod-estrut-mec no-lock:
            end.
        end.
        if avail mab-estrut-mec then do:
            assign vCodigo    = mab-estrut-mec.cod-estrut-mec 
                   vDescricao = mab-estrut-mec.des-estrut-mec
                   iImage     = 18
                   rRowid     = rowid(mab-estrut-mec).
        end.
        else do:
            {utp/ut-liter.i Estrutura_MecÉnica_N∆o_Encontrado }
            assign vCodigo    = mab-eqpto.cod-estrut-mec 
                   vDescricao = RETURN-VALUE
                   iImage     = 18
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /* propriet†rio */
    when "19":U then do:
        if not avail emitente or emitente.cod-emitente <> mab-eqpto.cod-emitente then do:   
            for first emitente fields(cod-emitente nome-abrev)  
                where emitente.cod-emitente = mab-eqpto.cod-emitente no-lock:
            end.
        end.
        if avail emitente then do:
            assign vCodigo    = STRING(emitente.cod-emitente) 
                   vDescricao = nome-abrev
                   iImage     = 19
                   rRowid     = rowid(emitente).
        end.
        else do:
            {utp/ut-liter.i Propriet†rio_N∆o_Encontrado }
            assign vCodigo    = mab-eqpto.cod-estrut-mec 
                   vDescricao = RETURN-VALUE
                   iImage     = 19
                   rRowid     = rowid(mab-eqpto).
        end.
    end. 
    WHEN "20":U THEN DO:
        ASSIGN vCodigo    = STRING(mab-eqpto.idi-tip-propriet) 
               vDescricao = {frinc/i01fr007.i 4 mab-eqpto.idi-tip-propriet }
               iImage     = 20
               rRowid     = ROWID(mab-eqpto).
    END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "21" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-eqpto.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-eqpto.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 21
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 21
                           rRowid     = ROWID(mab-eqpto).
                END.
            END.
        END.
    &ENDIF
    WHEN "22":U THEN DO:  /* Centro Custo Item */    /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
        if not avail tt_ccusto_integr or tt_ccusto_integr.ttv_cod_ccusto <> mab-item-abastec.cod-ccusto then do:
            for first tt_ccusto_integr fields(ttv_des_titulo ttv_cod_ccusto)  
                where tt_ccusto_integr.ttv_cod_ccusto = mab-item-abastec.cod-ccusto no-lock:
            end.
        end.
        if avail tt_ccusto_integr then do:
            assign vCodigo    = tt_ccusto_integr.ttv_cod_ccusto 
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 22
                   rRowid     = rowid(tt_ccusto_integr).
        end.
        else do:
            {utp/ut-liter.i Centro_Custo_em_Branco }
            assign vCodigo    = "_ "
                   vDescricao = RETURN-VALUE
                   iImage     = 22
                   rRowid     = rowid(mab-item-abastec).
        end.
    END.
    WHEN "23":U THEN DO:  /* Item abastecimento */ /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
        if not avail ITEM or ITEM.it-codigo <> mab-item-abastec.it-codigo then do:
            for first ITEM fields(it-codigo descricao-1)
                where ITEM.it-codigo = mab-item-abastec.it-codigo no-lock:
            end.
        end.
        if avail ITEM then do:
            assign vCodigo    = ITEM.it-codigo
                   vDescricao = ITEM.descricao-1
                   iImage     = 23
                   rRowid     = rowid(ITEM).
        end.
        else do:
            {utp/ut-liter.i ITEM_Abastecimento_N∆o_Encontrado }
            assign vCodigo    = mab-item-abastec.it-codigo
                   vDescricao = RETURN-VALUE
                   iImage     = 23
                   rRowid     = rowid(mab-item-abastec).
        end.
    END.
    WHEN "24":U THEN DO: /* Posto  */     /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
        if not avail mab-posto or mab-posto.cod-posto <> mab-item-abastec.cod-posto then do:
            for first mab-posto fields(cod-posto des-posto)
                where mab-posto.cod-posto = mab-item-abastec.cod-posto no-lock:
            end.
        end.
        if avail ITEM then do:
            assign vCodigo    = mab-posto.cod-posto
                   vDescricao = mab-posto.des-posto
                   iImage     = 24
                   rRowid     = rowid(ITEM).
        end.
        else do:
            {utp/ut-liter.i Posto_Abastecimento_N∆o_Encontrado }
            assign vCodigo    = mab-item-abastec.cod-pos
                   vDescricao = RETURN-VALUE
                   iImage     = 23
                   rRowid     = rowid(mab-item-abastec).
        end.
    END.
end case.

IF vCodigoOf = "" THEN ASSIGN vCodigoOf = vCodigo.
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
    assign c-linha                  = replace (c-linha, chr(34), "")        
           ttSelecao.empresa-ini    = &IF "{&mguni_version}" >= "2.071" &THEN entry(1,c-linha,";") &else int(entry(1,c-linha,";")) &ENDIF                   
           ttSelecao.empresa-fim    = &IF "{&mguni_version}" >= "2.071" &THEN entry(2,c-linha,";") &else int(entry(2,c-linha,";")) &ENDIF                   
           ttSelecao.equipto-ini    = entry(3,c-linha,";")                        
           ttSelecao.equipto-fim    = entry(4,c-linha,";")                        
           ttSelecao.grupo-ini      = entry(5,c-linha,";")                        
           ttSelecao.grupo-fim      = entry(6,c-linha,";")                        
           ttSelecao.modelo-ini     = entry(7,c-linha,";")                        
           ttSelecao.modelo-fim     = entry(8,c-linha,";")                        
           ttSelecao.estab-ini      = entry(9,c-linha,";")                        
           ttSelecao.estab-fim      = entry(10,c-linha,";")                       
           ttSelecao.tag-ini        = entry(11,c-linha,";")                       
           ttSelecao.tag-fim        = entry(12,c-linha,";")                       
           ttSelecao.estrut-ini     = entry(13,c-linha,";")                       
           ttSelecao.estrut-fim     = entry(14,c-linha,";")                       
           ttSelecao.cc-cod-eqpto-ini = entry(15,c-linha,";")                       
           ttSelecao.cc-cod-eqpto-fim = entry(16,c-linha,";")                       
           ttSelecao.sit-ini        = entry(17,c-linha,";")                       
           ttSelecao.sit-fim        = entry(18,c-linha,";")                       
           ttSelecao.atividade-ini  = entry(19,c-linha,";")                       
           ttSelecao.atividade-fim  = entry(20,c-linha,";")                       
           ttSelecao.periodo-ini    = date(entry(21,c-linha,";"))                 
           ttSelecao.periodo-fim    = date(entry(22,c-linha,";"))                 
           ttSelecao.trajeto-ini    = entry(23,c-linha,";")                       
           ttSelecao.trajeto-fim    = entry(24,c-linha,";")                       
           ttSelecao.cc-cod-docto-ini = entry(25,c-linha,";")
           ttSelecao.cc-cod-docto-fim = entry(26,c-linha,";")
           ttSelecao.lAtivos        = (entry(27,c-linha,";") = "yes")             
           ttSelecao.lProprios      = (entry(28,c-linha,";") = "yes")             
           ttSelecao.lInativos      = (entry(29,c-linha,";") = "yes")             
           ttSelecao.lTerceiros     = (entry(30,c-linha,";") = "yes")             
           ttSelecao.lOK            = (entry(31,c-linha,";") = "yes")             
           ttSelecao.lIrregular     = (entry(32,c-linha,";") = "yes")             
           ttSelecao.lLogContSec    = (entry(33,c-linha,";") = "yes")
           ttSelecao.lDesperdicio   = (entry(34,c-linha,";") = "yes")             
           ttSelecao.classificacao  = int(entry(35,c-linha,";"))
           ttSelecao.cod-emitente-ini = int(entry(36,c-linha,";"))  
           ttSelecao.cod-emitente-fim = int(entry(37,c-linha,";")).

    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao.cod-unid-negoc-ini = entry(38,c-linha,";")
                   ttSelecao.cod-unid-negoc-fim = entry(39,c-linha,";").
        &ENDIF
    END.
end.

ASSIGN lVisaoPorItem = NO.

repeat:
    /** Busca as vis‰es **/
    import unformatted c-linha.
    assign c-linha = replace (c-linha, chr(34), "").
    if num-entries (c-linha, ";") = 2 then do:
        create ttVisao.
        assign ttVisao.dimensao  = entry (1, c-linha, ";")
               ttVisao.sequencia = int (entry (2, c-linha, ";"))
                ttVisao.lConsumo = YES.
    
         IF  SUBSTRING(ttVisao.dimensao,1,2) = "22" OR SUBSTRING(ttVisao.dimensao,1,2) = "23" OR SUBSTRING(ttVisao.dimensao,1,2) = "24" THEN
             ASSIGN lVisaoPorItem = YES.
         /*  uma vez tendo a visao 22, 23 e 24 todos abaixo devera ter a variavel lConsumo = No, para nao calcular (exibir) Consumo. */
         IF  lVisaoPorItem THEN
             ASSIGN ttVisao.lConsumo = NO.
    end.
end.

input close.

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
define variable iQtSeq    as integer initial 0 no-undo.
define variable TotEqpto  as character         no-undo.
define variable c-texto   as character         no-undo.
define buffer   bfttDados for ttDados.

assign i-cont = 0.
/** Verifica se existem vis‰es escolhidas **/
for last ttVisao fields(sequencia) no-lock:
    assign iQtSeq = ttVisao.sequencia.
end.
    if iQtSeq = 0 then return.
/** Label da quantidade de equipamentos **/
{utp/ut-liter.i "Consumo Real"}
assign TotEqpto = return-value.

/** Busca os dados criados **/
for each  ttDados fields(cod-oficial desc-dimensao p-image 
                         val-real seq-tree cod-dimens-pai r-rowid)
    where ttDados.sequencia < iQtSeq no-lock 
    by ttDados.cod-dimensao:

  if ttDados.sequencia < iVisao then assign lReal = no.
                                else assign lReal = yes.

  /** Conta sequàncias de linhas **/ 
  assign i-cont = i-cont + 1.
  assign ttDados.seq-tree = i-cont.
  /** Inclui primeira linha **/
  if ttDados.sequencia = 1 then do:
     if lReal then do:
         /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o
            Somente deve exibir o valor da variavel "(ttDados.val-real", quando o campo "ttDados.l-VisaoPorItem" tiver o valor "NO"
            ou seja, n∆o exibir o consumo real quando for p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto), assim como todas as imagens 
            que esteja em niveis abaixo de p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto) */
         IF  NOT ttDados.l-VisaoPorItem THEN
             ASSIGN c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao + " - " + TotEqpto + " : " + string(ttDados.val-real,"->>>,>>>,>>9.99").
         ELSE 
             ASSIGN c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao.
     END.
     ELSE
         ASSIGN c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao.

     oTreeList:addNode(""                  , "i" + STRING(i-cont), c-texto).
     oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados.p-image).
     oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados))).

     IF  ttDados.r-rowid <>  ?   THEN
         oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados.r-rowid)).
  end.
  else do:
      /** Busca filhos da vis∆o escolhida **/
      for first bfttDados fields(seq-tree)
          where bfttDados.cod-dimensao = ttDados.cod-dimens-pai no-lock:
          /** Data **/
          if ttDados.p-image = 11 then do:
              /** Inclui linhas das vis‰es filhas **/
              if lReal then do:
                 /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o
                    Somente deve exibir o valor da variavel "(ttDados.val-real", quando o campo "ttDados.l-VisaoPorItem" tiver o valor "NO"
                    ou seja, n∆o exibir o consumo real quando for p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto), assim como todas as imagens 
                    que esteja em niveis abaixo de p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto) */
                  IF  NOT ttDados.l-VisaoPorItem THEN
                      ASSIGN    c-texto =   STRING(ttDados.cod-oficial) + " - " + TotEqpto + " : " + string(ttDados.val-real,"->>>,>>>,>>9.99").
                  ELSE 
                      ASSIGN    c-texto =   STRING(ttDados.cod-oficial).
              END.
              ELSE
                  ASSIGN    c-texto =   STRING(ttDados.cod-oficial).
          end.
          /** Outros **/
          else do:
              /** Inclui linhas das vis‰es filhas **/
              if lReal then do:
                 /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o
                    Somente deve exibir o valor da variavel "(ttDados.val-real", quando o campo "ttDados.l-VisaoPorItem" tiver o valor "NO"
                    ou seja, n∆o exibir o consumo real quando for p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto), assim como todas as imagens 
                    que esteja em niveis abaixo de p-image = 22 (CC ITEM), 23 (item) ou 24 (Posto) */
                  IF  NOT ttDados.l-VisaoPorItem THEN
                      ASSIGN    c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao + " - " + TotEqpto + " : " + string(ttDados.val-real,"->>>,>>>,>>9.99").
                  ELSE 
                      ASSIGN    c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao.
              END.
              ELSE
                  ASSIGN    c-texto =   STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao.
          end.

          oTreeList:addNode("i" + STRING(bfttDados.seq-tree), "i" + STRING(i-cont), c-texto).
          oTreeList:setData(                                  "i" + STRING(i-cont), "p-image", ttDados.p-image).
          oTreeList:setData(                                  "i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados))).

          IF  ttDados.r-rowid <>  ?   THEN
              oTreeList:setData("i" + STRING(i-cont), "r-rowid", STRING(ttDados.r-rowid)).
      end.
  end.
end.

oTreeList:REFRESH().

return "OK":U.

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSelecao wWindow 
PROCEDURE criaTTSelecao :
/*------------------------------------------------------------------------------
  Purpose:     criaTTSelecao
  Parameters:  <none>
  Notes:       Cria a temp-table de seleá∆o (parÉmetros) do programa
------------------------------------------------------------------------------*/
create ttSelecao.
assign ttSelecao.empresa-ini      = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
       ttSelecao.empresa-fim      = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ" &else 999 &ENDIF
       ttSelecao.equipto-ini      = ""
       ttSelecao.equipto-fim      = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.grupo-ini        = ""
       ttSelecao.grupo-fim        = "ZZZZZZZZ"
       ttSelecao.modelo-ini       = ""
       ttSelecao.modelo-fim       = "ZZZZZZZZ"
       ttSelecao.estab-ini        = ""
       ttSelecao.estab-fim        = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ" &else "ZZZ" &endif
       ttSelecao.tag-ini          = ""
       ttSelecao.tag-fim          = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.estrut-ini       = ""
       ttSelecao.estrut-fim       = "ZZZZZZZZ"
       ttSelecao.cc-cod-eqpto-ini = ""
       ttSelecao.cc-cod-eqpto-fim = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.sit-ini          = ""
       ttSelecao.sit-fim          = "ZZZZZZZZ"
       ttSelecao.atividade-ini    = ""        
       ttSelecao.atividade-fim    = "ZZZZZZZZ"
       ttSelecao.periodo-ini      = today - 7
       ttSelecao.periodo-fim      = today
       ttSelecao.trajeto-ini      = ""        
       ttSelecao.trajeto-fim      = "ZZZZZZZZ"
       ttSelecao.cc-cod-docto-ini = ""
       ttSelecao.cc-cod-docto-fim = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.lAtivos          = yes
       ttSelecao.lProprios        = yes
       ttSelecao.lInativos        = no
       ttSelecao.lTerceiros       = yes
       ttSelecao.lOK              = yes
       ttSelecao.lIrregular       = yes
       ttSelecao.lLogContSec      = NO
       ttSelecao.lDesperdicio     = no
       ttSelecao.classificacao    = 1
       ttSelecao.cod-emitente-ini = 0
       ttSelecao.cod-emitente-fim = 999999999
    &IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.cod-unid-negoc-ini = "":U
       ttSelecao.cod-unid-negoc-fim = "ZZZ":U
    &ENDIF
       .

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

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao wWindow 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados
            where bfttDados.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados
        where bfttDados.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfttDados),
                          input bfttDados.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttDados
    where rowid(bfttDados) = rRow no-lock:
end.
if avail bfttDados then do:
    /** Cria os dados na temp-table do excel **/
   {abp/ab0609.i2 bfttDados.p-image}
   create tt-dados-ex.
   assign tt-dados-ex.celula-coluna        = 1
          tt-dados-ex.celula-linha         = i-cont2
          tt-dados-ex.celula-cor-interior  = 27
          tt-dados-ex.celula-fonte-cor     = 1
          tt-dados-ex.celula-fonte-negrito = yes
          tt-dados-ex.celula-valor         = trim(return-value) + ":" +  bfttDados.cod-oficial + "-" + bfttDados.desc-dimensao
          i-cont2                          = i-cont2 + 1.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisaoTxt wWindow 
PROCEDURE imprimeVisaoTxt :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
               cDelim  = Delimitador
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow          as rowid     no-undo.
define input parameter cCodPai       as character no-undo.
define input parameter cDelim        as character no-undo. 

/** Zera vari†veis **/
assign cDescPai   = ""
       cTituloTxt = "".
/** Verifica se existem n°veis acima **/
if can-find(first bfttDados
            where bfttDados.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados
        where bfttDados.cod-dimensao = cCodPai no-lock:
        run imprimeVisaoTxt (input rowid(bfttDados),
                             input bfttDados.cod-dimens-pai,
                             input cDelim).
    end.
end.
/** Busca os dados **/
for first bfttDados
    where rowid(bfttDados) = rRow no-lock:
    {abp/ab0609.i2 bfttDados.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelim.
end.
if avail bfttDados then do:
    assign cDescPai  = trim(trim(cDescPai) + trim(bfttDados.cod-oficial) + "-" + TRIM(bfttDados.desc-dimensao) + cDelim).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizar wWindow 
PROCEDURE piAtualizar :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizar
  Parameters:  <none>
  Notes:       Busca os dados e atualiza o programa
------------------------------------------------------------------------------*/
/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run piCriaVisao in this-procedure.
end.

/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}
/** Limpa o tree-view **/
oTreeList:emptyTreeList().

blk1:
do on stop undo, return "NOK":U:
    /** Acompanhamento **/
    RUN utp/ut-acomp.p PERSISTENT SET hHandle.
    {utp/ut-liter.i "Consumo Combust°vel"}
    RUN pi-inicializar IN hHandle (trim(return-value)).

    /** Busca os parÉmetros **/
    for each  mab-param fields(des-valor cdn-param)
        where mab-param.cdn-param = 14
        or    mab-param.cdn-param = 15
        or    mab-param.cdn-param = 16 no-lock:
        if des-valor = "" then return "NOK":U.
        case mab-param.cdn-param:
            when 14 then assign deParam14 = dec(mab-param.des-valor).
            when 15 then assign deParam15 = dec(mab-param.des-valor).
            when 16 then assign deParam16 = dec(mab-param.des-valor).
        end case.
    end.
    assign iVisao = 0.
    for each ttVisao fields(sequencia) no-lock:
        if substring(ttVisao.dimensao,1,2) = "02" or 
           substring(ttVisao.dimensao,1,2) = "04" or 
           substring(ttVisao.dimensao,1,2) = "09" or 
           substring(ttVisao.dimensao,1,2) = "16" then do:  /* Unidade Percurso Equipamento */
           assign iVisao = ttVisao.sequencia.
           leave.
        end.
    end.

    /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
    ASSIGN lVisaoPorItem = NO.
    FOR EACH ttVisao NO-LOCK:
        IF  SUBSTRING(ttVisao.dimensao,1,2) = "22" /* CC Item */ OR
            SUBSTRING(ttVisao.dimensao,1,2) = "23" /* Item Abastecimento */ OR
            SUBSTRING(ttVisao.dimensao,1,2) = "24" /* Posto */ THEN DO:
            /* Estara fazendo uma leitura Item a item na tabela mab-item-abastec */
            ASSIGN lVisaoPorItem = YES.
        END.
    END.

    /** Seleciona os equipamento **/
    for each  mab-eqpto
        where mab-eqpto.ep-codigo         >= ttSelecao.empresa-ini
        and   mab-eqpto.ep-codigo         <= ttSelecao.empresa-fim
        and   mab-eqpto.cod-eqpto         >= ttSelecao.equipto-ini
        and   mab-eqpto.cod-eqpto         <= ttSelecao.equipto-fim
        and   mab-eqpto.cod-model         >= ttSelecao.modelo-ini
        and   mab-eqpto.cod-model         <= ttSelecao.modelo-fim
        and   mab-eqpto.cod-sit-eqpto     >= ttSelecao.sit-ini
        and   mab-eqpto.cod-sit-eqpto     <= ttSelecao.sit-fim
        and   mab-eqpto.cc-codigo         >= ttSelecao.cc-cod-eqpto-ini 
        and   mab-eqpto.cc-codigo         <= ttSelecao.cc-cod-eqpto-fim 
        and   mab-eqpto.cod-estabel       >= ttSelecao.estab-ini
        and   mab-eqpto.cod-estabel       <= ttSelecao.estab-fim
        and   mab-eqpto.cd-tag            >= ttSelecao.tag-ini
        and   mab-eqpto.cd-tag            <= ttSelecao.tag-fim
        and   mab-eqpto.cod-estrut-mec    >= ttSelecao.estrut-ini
        and   mab-eqpto.cod-estrut-mec    <= ttSelecao.estrut-fim
        and   mab-eqpto.cod-grp-eqpto     >= ttSelecao.grupo-ini
        and   mab-eqpto.cod-grp-eqpto     <= ttSelecao.grupo-fim 
        and   mab-eqpto.cod-emitente      >= ttSelecao.cod-emitente-ini 
        and   mab-eqpto.cod-emitente      <= ttSelecao.cod-emitente-fim 
        and   mab-eqpto.idi-tip-eqpto      = 1                            /** Motorizados **/
        and   ((mab-eqpto.idi-tip-propriet = 1 and ttSelecao.lProprios)   /** Pr¢prios **/
        or     (mab-eqpto.idi-tip-propriet = 2 and ttSelecao.lTerceiros)) /** Terceiros **/
        and   ((mab-eqpto.dat-situacao     = ? and ttSelecao.lAtivos)     /** Ativos **/
        or     (mab-eqpto.dat-situacao    <> ? and ttSelecao.lInativos))  /** Inativos **/
        no-lock:

        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-eqpto.cod-unid-negoc >= ttSelecao.cod-unid-negoc-ini  AND 
                       mab-eqpto.cod-unid-negoc <= ttSelecao.cod-unid-negoc-fim) THEN NEXT.
            END.
        &ENDIF

        /** Acompanhamento **/
        RUN pi-Acompanhar IN hHandle (fnLabels(2) + ": " + STRING(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto).

        ASSIGN lVerificaHistorico = FALSE.
        /** Verifica se existe hist¢rico de combust°vel no per°odo **/
        IF CAN-FIND ( FIRST mab-histor-combust 
                where mab-histor-combust.ep-codigo     = mab-eqpto.ep-codigo
                and   mab-histor-combust.cod-eqpto     = mab-eqpto.cod-eqpto
                and   mab-histor-combust.idi-tip-consu > 1
                and   mab-histor-combust.dat-inicial   > ttSelecao.periodo-ini) THEN DO:
            ASSIGN lVerificaHistorico = TRUE.
        END.
        /** Pega £ltimo hist¢rico de combust°vel cadastrado **/
        ELSE DO:
            FOR LAST mab-histor-combust 
                where mab-histor-combust.ep-codigo     = mab-eqpto.ep-codigo
                and   mab-histor-combust.cod-eqpto     = mab-eqpto.cod-eqpto
                and   mab-histor-combust.idi-tip-consu > 1
                and   mab-histor-combust.dat-inicial   <= ttSelecao.periodo-ini NO-LOCK:
            end.
        END.

        /** Busca fichas de abastecimento e lubrificaá∆o **/
        for each  mab-abastec-lubrific
            where mab-abastec-lubrific.ep-codigo   = mab-eqpto.ep-codigo
            and   mab-abastec-lubrific.cod-eqpto   = mab-eqpto.cod-eqpto
            and   mab-abastec-lubrific.cod-ativid >= ttSelecao.atividade-ini
            and   mab-abastec-lubrific.cod-ativid <= ttSelecao.atividade-fim
            and   mab-abastec-lubrific.cod-rota   >= ttSelecao.trajeto-ini
            and   mab-abastec-lubrific.cod-rota   <= ttSelecao.trajeto-fim
            and   mab-abastec-lubrific.dat-movto  >= ttSelecao.periodo-ini
            and   mab-abastec-lubrific.dat-movto  <= ttSelecao.periodo-fim
            and   mab-abastec-lubrific.cc-codigo  >= ttSelecao.cc-cod-docto-ini
            and   mab-abastec-lubrific.cc-codigo  <= ttSelecao.cc-cod-docto-fim
            and   mab-abastec-lubrific.log-consist  /** Abastecimento j† consistido **/ no-lock:

            /*  IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o
                lVisaoPorItem = NO, ocorre quando na ttVis∆o nao tem nenhuma dimensao por:
                "22" - CC Item
                "23" - Item Abastecimento
                "24" - Posto
            */
            IF  lVisaoPorItem = NO THEN DO:
                /** Calcula as fichas */
                run piCalculo in this-procedure.
                if return-value = "NOK":U then next.
                /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
                assign cCodPai = "".
                /** Busca vis‰es escolhidas **/
                for each ttVisao no-lock:
                    /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                    run buscaValor in this-procedure (input ttVisao.dimensao).
                    /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                    if vCodigo = "" then next.
                    /** Carrega os dados  **/
                    run piCarregaSequencias in this-procedure.
                end.
            END.
            ELSE DO:
                /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o  */
                /** Calcula as fichas */
                RUN piCalculo IN THIS-PROCEDURE.
                ASSIGN l-novo-docto = YES.

                FOR EACH mab-item-abastec
                    WHERE mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto NO-LOCK:

                    /* A sobreposiá∆o do campos abaixo Ç para gravar a quantidade de cada item da ficha de abastecimento*/
                    ASSIGN deQuantidade        = mab-item-abastec.val-quant
                           cTpMater            = mab-item-abastec.cod-tip-mater.

                    IF  RETURN-VALUE = "NOK":U THEN NEXT.
                    /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
                    ASSIGN cCodPai = "".
                    /** Busca vis‰es escolhidas **/
                    FOR EACH ttVisao NO-LOCK:
                        /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                        RUN buscaValor IN THIS-PROCEDURE (INPUT ttVisao.dimensao).
                        /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                        IF vCodigo = "" THEN NEXT.
                        /** Carrega os dados  **/
                        RUN piCarregaSequencias IN THIS-PROCEDURE.
                    END.
                    ASSIGN l-novo-docto = NO.
                END.
            END.
        end. /** mab-abastec-lubrific **/
    end. /** mab-eqpto **/
end.

IF VALID-HANDLE (hHandle) THEN
    DELETE PROCEDURE hHandle.
/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculo wWindow 
PROCEDURE piCalculo :
/*------------------------------------------------------------------------------
  Purpose:     piCalculo
  Parameters:  <none>
  Notes:       Calcula as vari†veis para os registros 
------------------------------------------------------------------------------*/
/** Zera vari†veis **/
assign deQuantidade     = 0
       deConsumo        = 0
       deConsumoSec     = 0
       deConsumoPad     = 0
       deConsumoPadSec  = 0
       deConsumoReal    = 0
       deConsumoRealSec = 0
       deDesperdicio    = 0
       deDesperdicioSec = 0
       deGanho          = 0
       deGanhoSec       = 0
       iTipoConsumo     = 0
       iTipoConsumoSec  = 0
       lDesperdicio     = no
       lIrregular       = no
       lIrregularSec    = no
       cTpMater         = "".
/** Busca registros de abastecimento para equipamento **/
for each  mab-item-abastec fields(val-quant cod-tip-mater)
    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
    and   mab-item-abastec.log-abastec-prim  /** Abastecimentos prim†rios **/
    no-lock:
    /** Guarda Quantidade e Tipo de Material **/
    assign deQuantidade = deQuantidade + mab-item-abastec.val-quant
           cTpMater     = mab-item-abastec.cod-tip-mater.
end.
/** Se n∆o encontrou quantidade, vai para pr¢xima ficha **/
if deQuantidade = 0 then return "NOK":U.
/** Busca Hist¢rico combust°vel **/

IF lVerificaHistorico THEN DO:
    for last  mab-histor-combust fields(val-consu-padr idi-tip-consu val-livre-1 num-livre-1)
        where mab-histor-combust.ep-codigo     = mab-eqpto.ep-codigo
        and   mab-histor-combust.cod-eqpto     = mab-eqpto.cod-eqpto
        and   mab-histor-combust.cod-tip-mater = cTpMater
        and   mab-histor-combust.idi-tip-consu > 1
        and   mab-histor-combust.dat-inicial  <= mab-abastec-lubrific.dat-movto no-lock:
        /** Guarda consumo padr∆o do hist¢rico **/
    end.
END.

/** Se n∆o existir hist¢rico de combust°vel, cadastro est† incorreto, vai para pr¢xima ficha **/
if not avail mab-histor-combust then return "NOK":U.

assign deConsumo       = mab-histor-combust.val-consu-padr
       deConsumoSec    = mab-histor-combust.val-livre-1 /* Referente ao campo val-consu-sec */
       iTipoConsumo    = mab-histor-combust.idi-tip-consu
       iTipoConsumoSec = mab-histor-combust.num-livre-1.  /** Tipo Consumo Secundario Percurso por Quantidade Ex: KM/L (quantos KM fiz com 1 litro) **/

/** Verifica se consumo padr∆o est† no modelo **/
IF NOT AVAIL mab-consu-model 
   OR (mab-consu-model.cod-model     <> mab-eqpto.cod-model
   OR  mab-consu-model.cod-ativid    <> mab-abastec-lubrific.cod-ativid
   OR  mab-consu-model.cod-tip-mater <> cTpMater) THEN DO:
    if can-find (first mab-consu-model
                 where mab-consu-model.cod-model     = mab-eqpto.cod-model
                 and   mab-consu-model.cod-ativid    = mab-abastec-lubrific.cod-ativid
                 and   mab-consu-model.cod-tip-mater = cTpMater  no-lock) then do:
        for first mab-consu-model fields(val-consu-padr cod-model cod-ativid cod-tip-mater val-consu-sec)
            where mab-consu-model.cod-model     = mab-eqpto.cod-model
            and   mab-consu-model.cod-ativid    = mab-abastec-lubrific.cod-ativid
            and   mab-consu-model.cod-tip-mater = cTpMater  no-lock:
            /** Padr∆o Modelo **/
            assign deConsumo    = mab-consu-model.val-consu-padr
                   deConsumoSec = mab-consu-model.val-consu-sec.
        end.            
    end.
end.
else 
    /** Consumo lido anteriormente **/
    if avail mab-consu-model then
        assign deConsumo    = mab-consu-model.val-consu-padr
               deConsumoSec = mab-consu-model.val-consu-sec.

/** Se consumo padr∆o for zerado, vai para pr¢xima ficha **/
if deConsumo = 0 then return "NOK":U.

case iTipoConsumo:
    /** Uso/Quantidade **/
    when 2 then do:
        assign deConsumoReal    = mab-abastec-lubrific.val-km-percur / deQuantidade
               deConsumoPad     = (deQuantidade * deConsumo)         / deQuantidade.
    end.
    /** Quantidade/Uso **/
    when 3 then do:
        assign deConsumoReal    = deQuantidade / mab-abastec-lubrific.val-km-percur 
               deConsumoPad     = deConsumo.
    end.
end case.
case iTipoConsumoSec:
    /** Uso/Quantidade **/
    when 2 then do:               
        assign deConsumoRealSec = mab-abastec-lubrific.val-livre-1 / deQuantidade 
               deConsumoPadSec  = (deQuantidade * deConsumoSec)      / deQuantidade.
    end.                          
    /** Quantidade/Uso **/
    when 3 then do:
        assign deConsumoRealSec = deQuantidade / mab-abastec-lubrific.val-livre-1 /* mab-abastec-lubrific.val-livre-1 Referente ao campo val-km-percurso-sec */
               deConsumoPadSec  = deQuantidade / (deQuantidade * deConsumoSec).
    end.
end case.

/** Consumo Desperd°cio e Ganho **/
/** Considera Desperd°cio **/
if ttSelecao.lDesperdicio then do:
    case iTipoConsumo:
        /** Uso/Quantidade **/
        when 2 then do:
            /** Desperd°cio **/
            if deConsumoReal < deConsumoPad then
                if (((deConsumoPad - deConsumoReal) / deConsumoPad * 100) > deParam15) then do:
                    assign lDesperdicio   = yes
                           lIrregular     = yes
                           deDesperdicio  = ((((deConsumoPad - deConsumoReal) / deConsumoPad) * 100) - deParam15) * (deQuantidade / 100).
                end.
            else
                /** Ganho **/
                if deConsumoReal > deConsumoPad then do:
                    if (((deConsumoReal - deConsumoPad) / deConsumoPad * 100) > deParam16) then do:
                        assign lDesperdicio = no
                               lIrregular   = yes
                               deGanho     = ((((deConsumoReal - deConsumoPad) / deConsumoPad) * 100) - deParam16) * (deQuantidade / 100).
                    end.
                end.
        end.
        /** Quantidade/Uso **/
        when 3 then do:
            /** Desperd°cio **/
            if deConsumoReal > deConsumoPad then
                if (((deConsumoReal - deConsumoPad) / deConsumoPad * 100) > deParam15) then do:
                    assign lDesperdicio   = yes
                           lIrregular     = yes
                           deDesperdicio  = ((((deConsumoReal - deConsumoPad) / deConsumoPad) * 100) - deParam15) * (deQuantidade / 100).
                end.
            else
                /** Ganho **/
                if deConsumoReal < deConsumoPad then do:
                    if (((deConsumoPad - deConsumoReal) / deConsumoPad * 100) > deParam16) then do:
                        assign lDesperdicio = no
                               lIrregular   = yes
                               deGanho     = ((((deConsumoPad - deConsumoReal) / deConsumoPad) * 100) - deParam16) * (deQuantidade / 100).
                    end.
                end.
        end.
    end case.
    /* Tipo de Consumo Secundario */
    case iTipoConsumoSec:
        /** Uso/Quantidade **/
        when 2 then do:
            /** Desperd°cio Secund†rio**/
            if deConsumoRealSec < deConsumoPadSec then
                if (((deConsumoPadSec - deConsumoRealSec) / deConsumoPadSec * 100) > deParam15) then do:
                    assign lDesperdicioSec  = yes
                           lIrregularSec    = yes
                           deDesperdicioSec = ((((deConsumoPadSec - deConsumoRealSec) / deConsumoPadSec) * 100) - deParam15) * (deQuantidade / 100).
                end.
            else
                /** Ganho **/
                if deConsumoRealSec > deConsumoPadSec then do:
                    if (((deConsumoRealSec - deConsumoPadSec) / deConsumoPadSec * 100) > deParam16) then do:
                        assign lDesperdicioSec = no
                               lIrregularSec   = yes
                               deGanhoSec      = ((((deConsumoRealSec - deConsumoPadSec) / deConsumoPadSec) * 100) - deParam16) * (deQuantidade / 100).
                    end.
                end.

        end.
        /** Quantidade/Uso **/
        when 3 then do:
            /** Desperd°cio Secund†rio**/
            if deConsumoRealSec > deConsumoPadSec then
                if (((deConsumoRealSec - deConsumoPadSec) / deConsumoPadSec * 100) > deParam15) then do:
                    assign lDesperdicioSec  = yes
                           lIrregularSec    = yes
                           deDesperdicioSec = ((((deConsumoRealSec - deConsumoPadSec) / deConsumoPadSec) * 100) - deParam15) * (deQuantidade / 100).
                end.
            else
                /** Ganho **/
                if deConsumoRealSec < deConsumoPadSec then do:
                    if (((deConsumoPadSec - deConsumoRealSec) / deConsumoPadSec * 100) > deParam16) then do:
                        assign lDesperdicioSec = no
                               lIrregularSec   = yes
                               deGanhoSec     = ((((deConsumoPadSec - deConsumoRealSec) / deConsumoPadSec) * 100) - deParam16) * (deQuantidade / 100).
                    end.
                end.
        end.
    end case.
end.
/** Verifica somente Irregular **/
ELSE DO:
    if (absolute(deConsumoReal - deConsumoPad) / deConsumoPad * 100) > deParam14 then
        assign lIrregular = yes.
    if (absolute(deConsumoRealSec - deConsumoPadSec) / deConsumoPadSec * 100) > deParam14 then
        assign lIrregularSec = yes.
END.

/** ParÉmetro para mostrar registros com consumo OK **/
if not(ttSelecao.lOK) and not(lIrregular) then return "NOK":U.
/** ParÉmetro para mostrar registros irregulares **/
if not(ttSelecao.lIrregular) and lIrregular then return "NOK":U.
IF  AVAIL mab-eqpto AND mab-eqpto.log-cont-sec THEN DO:
    /** ParÉmetro para mostrar registros com consumo OK **/
    if not(ttSelecao.lOK) and not(lIrregularSec) then return "NOK":U.
    /** ParÉmetro para mostrar registros irregulares **/
    if not(ttSelecao.lIrregular) and lIrregularSec then return "NOK":U.
END.

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
define variable deCons as decimal no-undo.

/** Busca registro **/
find first ttDados
     where ttDados.cod-dimensao  = (cCodPai + "#" + vCodigo)
     and   ttDados.sequencia     = ttVisao.sequencia exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttDados then do:
   create ttDados.
   assign ttDados.cod-dimensao   = (cCodPai + "#" + vCodigo)  /** C¢digo encadeado para tree-view **/
          ttDados.cod-oficial    = if iImage = 11 then substring(vDescricao,1,16) else
              IF iImage = 12 THEN vCodigoOf ELSE vCodigo /** C¢digo Original do registro **/
          ttDados.desc-dimensao  = if iImage = 11 then ""   else vDescricao                    /** Descriá∆o do c¢digo **/
          ttDados.sequencia      = ttVisao.sequencia    /** Sequància dos dados **/
          ttDados.p-image        = iImage               /** N£mero da imagem do registro **/
          ttDados.r-rowid        = rRowid               /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai = cCodPai.             /** C¢digo do pai do registro **/
end.

assign cCodPai = ttDados.cod-dimensao.

if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

/* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
IF  ttVisao.lConsumo = NO THEN DO:
    ASSIGN ttDados.l-VisaoPorItem = YES.
END.
          
/** Calcula apenas para registros **/
if lReal then do:
    assign ttDados.qtd-combustivel     = ttDados.qtd-combustivel + deQuantidade                                       /** Soma a quantidade de combust°vel **/
           ttDados.val-per-pad         = IF iTipoConsumo = 2 THEN ttDados.val-per-pad + (deQuantidade * deConsumoPad) 
                                         ELSE ttDados.val-per-pad + (deQuantidade / deConsumoPad)                     /** Soma dos KMs padr‰es **/
           ttDados.val-desperdicio     = deDesperdicio                                                                /** Consumo Desperd°cio **/
           ttDados.val-ganho           = deGanho                                                                      /** Consumo Ganho **/
           ttDados.l-Desperdicio       = no
           ttDados.l-Irregular         = no.

    /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
    /* Grava ttDados.val-percurso */
    IF  lVisaoPorItem THEN DO:
        IF l-novo-docto THEN
            ASSIGN ttDados.val-percurso = ttDados.val-percurso + mab-abastec-lubrific.val-km-percur.    /** Soma dos KMs percorridos **/
    END.
    ELSE ASSIGN ttDados.val-percurso = ttDados.val-percurso + mab-abastec-lubrific.val-km-percur.       /** Soma dos KMs percorridos **/

    IF  ttSelecao.lLogContSec THEN DO:
        ASSIGN ttDados.val-per-pad-sec     = ttDados.val-per-pad-sec + (deQuantidade * deConsumoPadSec)  /** Soma dos KMs padr‰es Secund†rios**/
               ttDados.val-desperdicio-sec = deDesperdicioSec                                            /** Consumo Desperd°cio Secund†rio **/
               ttDados.val-ganho-sec       = deGanhoSec                                                  /** Consumo Ganho Secund†rio**/
               ttDados.l-Desperdicio-sec   = no
               ttDados.l-Irregular         = no
               ttDados.l-LogContSec        = ttSelecao.lLogContSec.

        /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
        /* Grava ttDados.val-percurso */
        IF  lVisaoPorItem THEN DO:
            IF l-novo-docto THEN
                ASSIGN ttDados.val-percurso-sec = ttDados.val-percurso-sec + mab-abastec-lubrific.val-livre-1. /** Soma dos KMs Secund†rio percorridos **/
        END.
        ELSE ASSIGN ttDados.val-percurso-sec = ttDados.val-percurso-sec + mab-abastec-lubrific.val-livre-1.    /** Soma dos KMs Secund†rio percorridos **/
    END.
        

    /** Busca Unidade do Modelo **/
    if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
        for first mab-model fields(des-model cod-model un cod-marca cod-livre-1)
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
        end.
    end.
    /** Busca Unidade do Material **/
    if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> cTpMater then do:
        for first mab-tip-mater fields(un cod-tip-mater des-tip-mater)
            where mab-tip-mater.cod-tip-mater = cTpMater no-lock:
        end.
    end.
    case iTipoConsumo:
        /** Uso/Quantidade **/
        when 2 then do:
            /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
            IF  ttVisao.lConsumo THEN DO:
                assign ttDados.val-real   = if (ttDados.val-percurso / ttDados.qtd-combustivel = ?) 
                                            then 0
                                            else ttDados.val-percurso / ttDados.qtd-combustivel
                       ttDados.val-padrao = if (ttDados.val-per-pad  / ttDados.qtd-combustivel = ?)
                                            then 0
                                            else ttDados.val-per-pad  / ttDados.qtd-combustivel.
                IF  AVAIL mab-model AND AVAIL mab-tip-mater THEN DO:
                    ASSIGN ttDados.relacao     = mab-model.un + "/" + mab-tip-mater.un.
                END.
            END.
        end.
        /** Quantidade/Uso **/
        when 3 then do:
            /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
            IF  ttVisao.lConsumo THEN DO:
                assign ttDados.val-real   = if (ttDados.qtd-combustivel / ttDados.val-percurso = ?)
                                            then 0
                                            else ttDados.qtd-combustivel / ttDados.val-percurso
                       ttDados.val-padrao = if (ttDados.qtd-combustivel / ttDados.val-per-pad = ?)
                                            then 0
                                            else ttDados.qtd-combustivel / ttDados.val-per-pad.
    
                IF  AVAIL mab-model AND AVAIL mab-tip-mater THEN DO:
                    ASSIGN ttDados.relacao     = mab-tip-mater.un + "/" + mab-model.un.
                END.
            END.
        end.
    end case.

    case iTipoConsumoSec:
        /** Uso/Quantidade **/
        when 2 then do:
            /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
            IF  ttVisao.lConsumo THEN DO:
                IF  ttSelecao.lLogContSec THEN DO:
                    ASSIGN ttDados.val-real-sec   = IF (ttDados.val-percurso-sec / ttDados.qtd-combustivel = ?)
                                                    THEN 0
                                                    ELSE ttDados.val-percurso-sec / ttDados.qtd-combustivel
                           ttDados.val-padrao-sec = IF (ttDados.val-per-pad-sec / ttDados.qtd-combustivel = ?)
                                                    THEN 0
                                                    ELSE ttDados.val-per-pad-sec / ttDados.qtd-combustivel.
                    IF  AVAIL mab-model AND AVAIL mab-tip-mater THEN DO:
                        ASSIGN ttDados.relacao-sec = SUBSTRING(mab-model.cod-livre-1, 1, 2) + "/" + mab-tip-mater.un.
                    END.
                END.
            END.
        end.
        /** Quantidade/Uso **/
        when 3 then do:
            /* IRM001380-Contabilizaá∆o Item Abastecimento / Lubrificaá∆o */
            IF  ttVisao.lConsumo THEN DO:
                IF  ttSelecao.lLogContSec THEN DO:
                    ASSIGN ttDados.val-real-sec   = IF (ttDados.qtd-combustivel / ttDados.val-percurso-sec = ?)
                                                    THEN 0
                                                    ELSE ttDados.qtd-combustivel / ttDados.val-percurso-sec
                           ttDados.val-padrao-sec = IF (ttDados.qtd-combustivel / ttDados.val-per-pad-sec = ?)
                                                    THEN 0
                                                    ELSE ttDados.qtd-combustivel / ttDados.val-per-pad-sec.
    
                    IF  AVAIL mab-model AND AVAIL mab-tip-mater THEN DO:
                        ASSIGN ttDados.relacao-sec = mab-tip-mater.un + "/" + SUBSTRING(mab-model.cod-livre-1, 1, 2).
                    END.
                END.
            END.
        end.
    end case.
    ASSIGN ttDados.de-desvio     = fnDesvio(ttDados.val-padrao, ttDados.val-real, iTipoConsumo).
    IF  ttSelecao.lLogContSec THEN
        ASSIGN ttDados.de-desvio-sec = fnDesvio(ttDados.val-padrao-sec, ttDados.val-real-sec,iTipoConsumoSec).

    if avail mab-tip-mater then
        assign ttDados.un = mab-tip-mater.un.

    if ttSelecao.lDesperdicio then do:
        /** Desperd°cio **/
        if ttDados.val-real < ttDados.val-padrao then
            if (((ttDados.val-padrao - ttDados.val-real) / ttDados.val-padrao * 100) > deParam15) then do:
                assign ttDados.l-Desperdicio   = yes
                       ttDados.l-Irregular     = yes.
            end.
        else
            /** Ganho **/
            if ttDados.val-real > ttDados.val-padrao then do:
                if (((ttDados.val-real - ttDados.val-padrao) / ttDados.val-padrao * 100) > deParam16) then do:
                    assign ttDados.l-Desperdicio = no
                           ttDados.l-Irregular   = yes.
                end.
            end.

        IF  ttSelecao.lLogContSec THEN DO:
            /** Desperd°cio Secund†rio **/
            IF  ttDados.val-real-sec < ttDados.val-padrao-sec THEN
                IF  (((ttDados.val-padrao-sec - ttDados.val-real-sec) / ttDados.val-padrao-sec * 100) > deParam15) THEN DO:
                    ASSIGN ttDados.l-Desperdicio-sec = YES
                           ttDados.l-Irregular-sec   = YES.
                END.
            ELSE
                /** Ganho **/
                IF  ttDados.val-real-sec > ttDados.val-padrao-sec THEN DO:
                    IF  (((ttDados.val-real-sec - ttDados.val-padrao-sec) / ttDados.val-padrao-sec * 100) > deParam16) THEN DO:
                        ASSIGN ttDados.l-Desperdicio-sec = NO
                               ttDados.l-Irregular-sec   = YES.
                    END.
                END.
        END.
    end.
    /** Verifica somente Irregular **/
    ELSE DO:
        IF iTipoConsumo = 2 THEN DO: 

            if (absolute(ttDados.val-real - ttDados.val-padrao) / ttDados.val-padrao * 100) > deParam14 
                AND ttDados.de-desvio < 0 THEN

                  ASSIGN ttDados.l-Irregular = YES.
        END.

        ELSE IF itipoConsumo = 3 THEN DO:

            IF (absolute(ttDados.val-padrao - ttDados.val-real) / ttDados.val-padrao * 100) > deParam14 
                AND ttDados.de-desvio < 0 THEN

                  ASSIGN ttDados.l-Irregular = YES.
        END.

        IF ttSelecao.lLogContSec THEN DO:

            IF iTipoConsumoSec = 2 THEN DO:
              IF (ABSOLUTE(ttDados.val-real-sec - ttDados.val-padrao-sec) / ttDados.val-padrao-sec * 100) > deParam14 
                  AND ttDados.de-desvio < 0 THEN

                  ASSIGN ttDados.l-Irregular-sec = YES.
            END.

            ELSE IF iTipoConsumoSec = 3 THEN DO:
              IF (ABSOLUTE(ttDados.val-padrao-sec - ttDados.val-real-sec) / ttDados.val-padrao-sec * 100) > deParam14 
                  AND ttDados.de-desvio < 0 THEN

                  ASSIGN ttDados.l-Irregular-sec = YES.
            END.
        END.
    END.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaVisao wWindow 
PROCEDURE piCriaVisao :
/*------------------------------------------------------------------------------
  Purpose:     piCriaVisao
  Parameters:  <none>
  Notes:       Cria as vis‰es se n∆o foram selecionadas 
------------------------------------------------------------------------------*/
create ttVisao.
assign ttVisao.dimensao  = '01 ' + fnLabels(1)
       ttVisao.sequencia = 1
       ttVisao.lConsumo = YES.
create ttVisao.
assign ttVisao.dimensao  = '03 ' + fnLabels(3)
       ttVisao.sequencia = 2
       ttVisao.lConsumo = YES.
create ttVisao.
assign ttVisao.dimensao  = '04 ' + fnLabels(4)
       ttVisao.sequencia = 3
       ttVisao.lConsumo = YES.
create ttVisao.
assign ttVisao.dimensao  = '02 ' + fnLabels(2)
       ttVisao.sequencia = 4
       ttVisao.lConsumo = YES.
create ttVisao.
assign ttVisao.dimensao  = '08 ' + fnLabels(8)
       ttVisao.sequencia = 5
       ttVisao.lConsumo = YES.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEvento wWindow 
PROCEDURE piEvento :
/*------------------------------------------------------------------------------
  Purpose:     piEvento
  Parameters:  <none>
  Notes:       Chama programa de apontamentos de eventos passando o equipamento
               que se deseja incluir o evento.
------------------------------------------------------------------------------*/
define variable hEvento as handle    no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define variable iEmp    LIKE empresa.ep-codigo   no-undo.
&ELSE
define variable iEmp    as integer   no-undo.
&ENDIF
define variable cEqpto  as character no-undo.

IF  INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")) = 2 then do:
    /** Guarda rowid do tree-view **/
    assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
    for first mab-eqpto
        where rowid(mab-eqpto) = rRowid no-lock:
        assign iEmp   = mab-eqpto.ep-codigo
               cEqpto = mab-eqpto.cod-eqpto.
    end.
end.
else do:
    get current brDetalhe no-lock.
    for first mab-eqpto
        where rowid(mab-eqpto) = ttDados.r-rowid no-lock:
        assign iEmp   = mab-eqpto.ep-codigo
               cEqpto = mab-eqpto.cod-eqpto.
    end.
end.

if iEmp = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
or cEqpto = "" or cSub = "" then return "NOK":U.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
RUN abp/ab0303.w PERSISTENT SET hEvento.

/* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
IF VALID-HANDLE(hEvento) AND
   hEvento:Type = "PROCEDURE":U AND
   hEvento:FILE-NAME = "abp/ab0303.w":U THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
    RUN initializeInterface IN hEvento.

run inicializaInclusao in hEvento (input iEmp,
                                   input cEqpto,
                                   input cSub,
                                   input cEvento,
                                   input iManut).

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
run pnp/pn0609e.w (output i-impressao,
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
        assign rRowid    = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        if ttSelecao.classificacao = 2 then do:
            for first bfttDados
                where rowid(bfttDados) = rRowid no-lock use-index qtd-combustivel:
                assign iVisao2 = bfttDados.sequencia.
                run piExcelDadosQtde (input bfttDados.cod-dimensao).
            end.
        end.
        else do:
            for first bfttDados
                where rowid(bfttDados) = rRowid no-lock:
                assign iVisao2 = bfttDados.sequencia.
                run piExcelDados (input bfttDados.cod-dimensao).
            end.
        end.
    end.

    /** Completo **/
    else do:
       /** Guarda rowid do tree-view **/
        assign rRowid    = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        /** Busca Registro **/
        for first bfttDados
            where rowid(bfttDados) = rRowid no-lock:
            assign iVisao2 = bfttdados.sequencia.
        end.
        if ttSelecao.classificacao = 2 then do:
            for each bfttDados
                where bfttDados.sequencia = 1 no-lock use-index qtd-combustivel:
                run piExcelDadosQtde (input bfttDados.cod-dimensao).
            end.
        end.
        else do:
            for each bfttDados
                where bfttDados.sequencia = 1 no-lock:
                run piExcelDados (input bfttDados.cod-dimensao).
            end.
        end.
    end.

    /** Programa que gera o XLS **/
    run abp/ab9003.p(input "ab0609":U,
                     input table tt-dados-ex).
    if return-value = "NOK":U then .

    /** Posiciona o Tree-View no £ltimo lido **/
    if oTreeList:hasNode() then
       oTreeList:selectLine(oTreeList:currentCode) no-error.
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
define input param pDimensao as character no-undo.

DEFINE VARIABLE i-col-aux AS INTEGER    NO-UNDO.
define variable cPai as character no-undo.

assign cPai = "".

for each ttDados
    where ttDados.cod-dimens-pai = pDimensao no-lock:

    /** Verifica se existem n°veis abaixo  **/
    if ttDados.sequencia <= iVisao2 then do:
        run piExcelDados (input ttDados.cod-dimensao).
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
            hHandle2 = brDetalhe:get-browse-column(i-col).
            if hHandle2:VISIBLE then do:
                /** Contador para linhas **/
                if i-lin = i-lin2 then do:
                    create tt-dados-ex.
                    assign tt-dados-ex.celula-coluna        = i-col-aux
                           tt-dados-ex.celula-linha         = i-lin
                           tt-dados-ex.celula-cor-interior  = 10
                           tt-dados-ex.celula-fonte-cor     = 19
                           tt-dados-ex.celula-fonte-negrito = yes.
                    assign tt-dados-ex.celula-valor         = if i-col = 1
                                                            then fnLabels(ttDados.p-image)
                                                            else fnBrowse(entry(i-col,c-colunas),1).
                end.

                /** teste se  colunas Ç c¢digo ou descriá∆o **/
                IF hHandle2:NAME = "Eqpto":u THEN DO: /*** Verifica nome interno da coluna do browser n∆o
                                                           Ç necess†rio traduá∆o pois testa nome inteno da tabela ***/
                    ASSIGN iControl = 1.
                end.
                ELSE DO:
                    ASSIGN iControl = 2.
                end.

                create tt-dados-ex.
                assign tt-dados-ex.celula-coluna  = i-col-aux
                       tt-dados-ex.celula-linha   = i-lin + 1.
                assign tt-dados-ex.celula-formato = IF iControl = 1 THEN "@" ELSE "". /**Formata celula se 1 = texto , se 2 = geral**/
                assign tt-dados-ex.celula-valor   = string(fnBrowse(entry(i-col,c-colunas),2)).
            end.
            else do:
                assign i-col-aux = i-col-aux - 1.
            end.
            assign i-col-aux = i-col-aux + 1.
        end. /** Colunas **/    
        assign i-lin  = i-lin + 1
               i-lin2 = i-lin + 2.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelDadosQtde wWindow 
PROCEDURE piExcelDadosQtde :
/*------------------------------------------------------------------------------
  Purpose:     piExcelDados
  Parameters:  entrada pDimensao = Dimensao lida
  Notes:       Impress∆o dos dados em excel
------------------------------------------------------------------------------*/
define input param pDimensao as character no-undo.

DEFINE VARIABLE i-col-aux AS INTEGER    NO-UNDO.
define variable cPai as character no-undo.

assign cPai = "".

for each ttDados
    where ttDados.cod-dimens-pai = pDimensao no-lock use-index qtd-combustivel:

    /** Verifica se existem n°veis abaixo  **/
    if ttDados.sequencia <= iVisao2 then do:
        run piExcelDadosQtde (input ttDados.cod-dimensao).
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
            hHandle2 = brDetalhe:get-browse-column(i-col).
            if hHandle2:VISIBLE then do:
                /** Contador para linhas **/
                if i-lin = i-lin2 then do:
                    create tt-dados-ex.
                    assign tt-dados-ex.celula-coluna        = i-col-aux
                           tt-dados-ex.celula-linha         = i-lin
                           tt-dados-ex.celula-cor-interior  = 10
                           tt-dados-ex.celula-fonte-cor     = 19
                           tt-dados-ex.celula-fonte-negrito = yes.
                    assign tt-dados-ex.celula-valor         = if i-col = 1
                                                            then fnLabels(ttDados.p-image)
                                                            else fnBrowse(entry(i-col,c-colunas),1).
                end.

                /** teste se  colunas Ç c¢digo ou descriá∆o **/
                IF hHandle2:NAME = "Eqpto":u THEN DO: /*** Verifica nome interno da coluna do browser n∆o
                                                           Ç necess†rio traduá∆o pois testa nome inteno da tabela ***/
                    ASSIGN iControl = 1.
                end.
                ELSE DO:
                    ASSIGN iControl = 2.
                end.

                create tt-dados-ex.
                assign tt-dados-ex.celula-coluna  = i-col-aux
                       tt-dados-ex.celula-linha   = i-lin + 1.
                            assign tt-dados-ex.celula-formato = "@":U.
                assign tt-dados-ex.celula-valor   = string(fnBrowse(entry(i-col,c-colunas),2)).
            end.
            else do:
                assign i-col-aux = i-col-aux - 1.
            end.
            assign i-col-aux = i-col-aux + 1.
        end. /** Colunas **/    
        assign i-lin  = i-lin + 1
               i-lin2 = i-lin + 2.
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
               prRowid = item selecionado no treeview
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for EACH bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run piExcelVisao (input rowid(bfttDados2),
                          input bfttDados2.cod-dimens-pai).
    end.
end.

FOR FIRST bfttDados2
    WHERE ROWID(bfttDados2) = rRow no-lock:
END.

if avail bfttDados2 and bfttDados2.sequencia <= iVisao2 then do:
    {abp/ab0609.i2 bfttDados2.p-image}
    create tt-dados-ex.
    assign tt-dados-ex.celula-coluna        = 1
           tt-dados-ex.celula-linha         = i-lin2
           tt-dados-ex.celula-cor-interior  = 27
           tt-dados-ex.celula-fonte-cor     = 1
           tt-dados-ex.celula-fonte-negrito = yes
           tt-dados-ex.celula-formato       = "@":U
           tt-dados-ex.celula-valor         = trim(return-value) + ":" +  bfttDados2.cod-oficial + "-" + bfttDados2.desc-dimensao
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
define variable rRowid        as rowid     no-undo.
define variable iSequencia    as integer   no-undo.
define variable cDimensao     as character no-undo.
define variable i-tipo-browse as integer   no-undo.

/** Guarda rowid do tree-view **/

assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).

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

    if ttDados.qtd-combustivel:visible in browse brDetalhe then assign i-tipo-browse = 1.
    else assign i-tipo-browse = 2.

    assign {&window-name}:sensitive = no.
    run abp/ab0609d.w (input table ttDados,
                       input iSequencia,
                       input cDimensao,
                       input ttSelecao.periodo-ini,
                       input ttSelecao.periodo-fim,
                       input ttSelecao.classificacao,
                       input i-tipo-browse).
    assign {&window-name}:sensitive = yes.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTexto wWindow 
PROCEDURE piTexto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable c-key-value  as character no-undo.
define variable c-tam        as character no-undo.

/** Seta caminho e delimitador **/
assign cDelimitador = ";":U
       cCaminho     = session:temp-directory + c-programa-mg97 + ".txt":U.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.

/***Chamada do programa de par≥metros para geraªío do arquivo em formato TXT***/
run pnp/pn0602e.w (input-output cCaminho,
                   input-output lCabecalho,
                   input-output cDelimitador,
                   output       i-impressao,
                   output       l-ok).

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
assign {&window-name}:sensitive = yes.

/** Se confirmar **/
if l-ok then do:
    /** Troca barras contrarias pela correta **/
    assign cCaminho = replace(cCaminho, "/":U, "~\":U).
    /** Cria arquivo **/
    output to value(cCaminho) paged page-size 64 convert target "iso8859-1":U.

    for LAST ttVisao no-lock:
        assign iVisaoAux3 = ttVisao.sequencia.
    end.

    /** Imprime Somente visao selecionada **/
    assign l-first = no.
    if i-impressao = 1 then do:
        /** Guarda rowid do tree-view **/
        assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        if ttSelecao.classificacao = 2 then do:
            /** Busca Registro **/
                for first bfttDados
                        where rowid(bfttDados) = rRowid no-lock use-index qtd-combustivel:
                        assign iVisaoAux = bfttDados.sequencia.
                        run piTextoDadosQtde (input bfttDados.cod-dimensao).
                end.
        end.
        else do:
            /** Busca Registro **/
                for first bfttDados
                        where rowid(bfttDados) = rRowid no-lock:
                        assign iVisaoAux = bfttDados.sequencia.
                        run piTextoDados (input bfttDados.cod-dimensao).
                end.
        end.
    end.

    /** Imprime Todos **/
    else do:
        /** Guarda rowid do tree-view **/
        assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        for first bfttDados
            where rowid(bfttDados) = rRowid no-lock:
            assign iVisaoAux = bfttDados.sequencia.
        end.
        if ttSelecao.classificacao = 2 then do:
            /** Busca Registro **/
            for each bfttDados
                where bfttDados.sequencia = 1 no-lock use-index qtd-combustivel:
                run piTextoDadosQtde (input bfttDados.cod-dimensao).
            end.
        end.
        else do:
            /** Busca Registro **/
            for each bfttDados
                where bfttDados.sequencia = 1 no-lock:
                run piTextoDados (input bfttDados.cod-dimensao).
            end.
        end.
    end.
    output close.

    /** Abertura do Arquivo **/
    RUN utp/ut-showreport.p (INPUT cCaminho).

    /** Posiciona o Tree-View no £ltimo lido **/
    if oTreeList:hasNode() then
       oTreeList:selectLine(oTreeList:currentCode) no-error.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoDados wWindow 
PROCEDURE piTextoDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param pDimensao as character no-undo.

define variable cPai       as character  no-undo.
define variable cTamCab    as character  no-undo.
define variable cTamReg    as character  no-undo.

assign cPai = "".

for each ttDados
    where ttDados.cod-dimens-pai = pDimensao no-lock:

    /** Verifica se existem n≠veis abaixo  **/
    if ttDados.sequencia <= iVisaoAux then do:
        run piTextoDados (input ttDados.cod-dimensao).
    end.
    else do:
        if cPai <> ttDados.cod-dimens-pai then do:
            assign cDescPai  = "".
            run piTextoVisao (input rowid(ttDados),
                              input ttDados.cod-dimens-pai).
            assign cPai       = ttDados.cod-dimens-pai.

        end.

        /** Imprime cabeáalho se parametrizado **/
        if lCabecalho and not l-first then do:
            if ttDados.qtd-combustivel:visible in browse brDetalhe then do:
                IF  NOT ttSelecao.lLogContSec THEN DO:
                    IF ttDados.l-VisaoPorItem = NO THEN DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador + 
                                         fnBrowse("un":U,1) + cDelimitador + 
                                         fnBrowse("val-per-pad":U,1) + cDelimitador + 
                                         fnBrowse("val-percurso":U,1) + cDelimitador +
                                         fnBrowse("val-padrao":U,1) + cDelimitador +
                                         fnBrowse("val-real":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio":U,1)))) + ")".

                        put trim(trim(cTituloTxt)                               + 
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad":U,1) + cDelimitador +
                                 fnBrowse("val-percurso":U,1) + cDelimitador +
                                 fnBrowse("val-padrao":U,1) + cDelimitador +
                                 fnBrowse("val-real":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio":U,1)) FORMAT cTamCab AT 01.
                                 
                    END.
                    ELSE DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador + 
                                         fnBrowse("un":U,1)))) + ")".

                        put trim(trim(cTituloTxt)                               + 
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1)) FORMAT cTamCab AT 01.
                    END.
                END.
                ELSE DO:    
                    IF ttDados.l-VisaoPorItem = NO THEN DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                         fnBrowse("un":U,1) + cDelimitador +
                                         fnBrowse("val-per-pad":U,1) + cDelimitador +
                                         fnBrowse("val-percurso":U,1) + cDelimitador +
                                         fnBrowse("val-padrao":U,1) + cDelimitador +
                                         fnBrowse("val-real":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio":U,1) + cDelimitador +
                                         fnBrowse("val-per-pad-sec":U,1) + cDelimitador +
                                         fnBrowse("val-percurso-sec":U,1) + cDelimitador +
                                         fnBrowse("val-padrao-sec":U,1) + cDelimitador +
                                         fnBrowse("val-real-sec":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio-sec":U,1)))) + ")".

                        put trim(trim(cTituloTxt) +
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad":U,1) + cDelimitador +
                                 fnBrowse("val-percurso":U,1) + cDelimitador +
                                 fnBrowse("val-padrao":U,1) + cDelimitador +
                                 fnBrowse("val-real":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad-sec":U,1) + cDelimitador +
                                 fnBrowse("val-percurso-sec":U,1) + cDelimitador +
                                 fnBrowse("val-padrao-sec":U,1) + cDelimitador +
                                 fnBrowse("val-real-sec":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio-sec":U,1)) format cTamCab at 01.
                    END.
                    ELSE DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                         fnBrowse("un":U,1)))) + ")".

                        put trim(trim(cTituloTxt) +
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1)) FORMAT cTamCab AT 01.
                    END.

                END.
            end.
            else do:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                 brDetalhe:TITLE IN FRAME fPage0))) + ")".

                put trim(trim(cTituloTxt) +
                         brDetalhe:TITLE IN FRAME fPage0) format cTamCab at 01.
            end.
            assign l-first = yes.
        end.
        /** Imprime dados **/
        if ttDados.qtd-combustivel:visible in browse brDetalhe then do:
            IF  NOT ttSelecao.lLogContSec THEN DO:
                IF ttDados.l-VisaoPorItem = NO THEN DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un + cDelimitador +
                                     string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao + cDelimitador +
                                     string(ttDados.de-desvio,"->,>>>,>>9.99")))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un + cDelimitador +
                             string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao + cDelimitador +
                             string(ttDados.de-desvio,"->,>>>,>>9.99")) format cTamReg at 01.
                END.
                ELSE DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un) format cTamReg at 01.
                END.
            END.
            ELSE DO:
                IF ttDados.l-VisaoPorItem = NO THEN DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un + cDelimitador +
                                     string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao + cDelimitador +
                                     string(ttDados.de-desvio,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-per-pad-sec,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso-sec,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao-sec,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real-sec,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao-sec + cDelimitador +
                                     string(ttDados.de-desvio-sec,"->,>>>,>>9.99")))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un + cDelimitador +
                             string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao + cDelimitador +
                             string(ttDados.de-desvio,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-per-pad-sec,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso-sec,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao-sec,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real-sec,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao-sec + cDelimitador +
                             string(ttDados.de-desvio-sec,"->,>>>,>>9.99")) format cTamReg at 01.
                END.
                ELSE DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un ))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un) format cTamReg at 01.
                END.



            end.
        end.
        else do:
            ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao)))) + ")".

            put trim(trim(cDescPai) + 
                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao)) format cTamReg at 01.
        end.
    end.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoDadosQtde wWindow 
PROCEDURE piTextoDadosQtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param pDimensao as character no-undo.

define variable cPai     as character  no-undo.
define variable cTamCab  as character  no-undo.
define variable cTamReg  as character  no-undo.

assign cPai = "".

for each ttDados
    where ttDados.cod-dimens-pai = pDimensao no-lock use-index qtd-combustivel:

    /** Verifica se existem n≠veis abaixo  **/
    if ttDados.sequencia <= iVisaoAux then do:
        run piTextoDadosQtde (input ttDados.cod-dimensao).
    end.

    else do:
        if cPai <> ttDados.cod-dimens-pai then do:
            assign cDescPai  = "".
            run piTextoVisao (input rowid(ttDados),
                              input ttDados.cod-dimens-pai).
            assign cPai       = ttDados.cod-dimens-pai.

        end.

        /** Imprime cabeáalho se parametrizado **/
        if lCabecalho and not l-first then do:
            if ttDados.qtd-combustivel:visible in browse brDetalhe then do:
                IF  NOT ttSelecao.lLogContSec THEN DO:
                    IF ttDados.l-VisaoPorItem = NO THEN DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador + 
                                         fnBrowse("un":U,1) + cDelimitador + 
                                         fnBrowse("val-per-pad":U,1) + cDelimitador + 
                                         fnBrowse("val-percurso":U,1) + cDelimitador +
                                         fnBrowse("val-padrao":U,1) + cDelimitador +
                                         fnBrowse("val-real":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio":U,1)))) + ")".

                        put trim(trim(cTituloTxt)                               + 
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad":U,1) + cDelimitador +
                                 fnBrowse("val-percurso":U,1) + cDelimitador +
                                 fnBrowse("val-padrao":U,1) + cDelimitador +
                                 fnBrowse("val-real":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio":U,1)) format cTamCab at 01.
                    END.
                    ELSE DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador + 
                                         fnBrowse("un":U,1)))) + ")".
      
                        put trim(trim(cTituloTxt)                               + 
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1)) FORMAT cTamCab AT 01.
                    END.
                END.
                ELSE DO:    
                    IF ttDados.l-VisaoPorItem = NO THEN DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                         fnBrowse("un":U,1) + cDelimitador +
                                         fnBrowse("val-per-pad":U,1) + cDelimitador +
                                         fnBrowse("val-percurso":U,1) + cDelimitador +
                                         fnBrowse("val-padrao":U,1) + cDelimitador +
                                         fnBrowse("val-real":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio":U,1) + cDelimitador +
                                         fnBrowse("val-per-pad-sec":U,1) + cDelimitador +
                                         fnBrowse("val-percurso-sec":U,1) + cDelimitador +
                                         fnBrowse("val-padrao-sec":U,1) + cDelimitador +
                                         fnBrowse("val-real-sec":U,1) + cDelimitador +
                                         "":U + cDelimitador +
                                         fnBrowse("de-desvio-sec":U,1)))) + ")".


                        put trim(trim(cTituloTxt) +
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad":U,1) + cDelimitador +
                                 fnBrowse("val-percurso":U,1) + cDelimitador +
                                 fnBrowse("val-padrao":U,1) + cDelimitador +
                                 fnBrowse("val-real":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio":U,1) + cDelimitador +
                                 fnBrowse("val-per-pad-sec":U,1) + cDelimitador +
                                 fnBrowse("val-percurso-sec":U,1) + cDelimitador +
                                 fnBrowse("val-padrao-sec":U,1) + cDelimitador +
                                 fnBrowse("val-real-sec":U,1) + cDelimitador +
                                 "":U + cDelimitador +
                                 fnBrowse("de-desvio-sec":U,1)) format cTamCab at 01.
                    END.
                    ELSE DO:
                        ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                         brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                         fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                         fnBrowse("un":U,1)))) + ")".
    
                        put trim(trim(cTituloTxt) +
                                 brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                                 fnBrowse("qtd-combustivel":U,1) + cDelimitador +
                                 fnBrowse("un":U,1)) FORMAT cTamCab AT 01.
                    END.
                END.
            end.
            else do:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(trim(trim(cTituloTxt) + 
                                 brDetalhe:TITLE IN FRAME fPage0))) + ")".

                put trim(trim(cTituloTxt) +
                         brDetalhe:TITLE IN FRAME fPage0) format cTamCab at 01.
            end.
            assign l-first = yes.
        end.
        /** Imprime dados **/
        if ttDados.qtd-combustivel:visible in browse brDetalhe then do:
            IF  NOT ttSelecao.lLogContSec THEN DO:
                IF ttDados.l-VisaoPorItem = NO THEN DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un + cDelimitador +
                                     string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao + cDelimitador +
                                     string(ttDados.de-desvio,"->,>>>,>>9.99")))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un + cDelimitador +
                             string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao + cDelimitador +
                             string(ttDados.de-desvio,"->,>>>,>>9.99")) format cTamReg at 01.
                END.
                ELSE DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un))) + ")".
    
                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un) format cTamReg at 01.
                END.

            END.
            ELSE DO:
                IF ttDados.l-VisaoPorItem = NO THEN DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un + cDelimitador +
                                     string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao + cDelimitador +
                                     string(ttDados.de-desvio,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-per-pad-sec,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-percurso-sec,"->,>>>,>>9.99") + cDelimitador +
                                     string(ttDados.val-padrao-sec,"->,>>>,>>9.9999") + cDelimitador +
                                     string(ttDados.val-real-sec,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.relacao-sec + cDelimitador +
                                     string(ttDados.de-desvio-sec,"->,>>>,>>9.99")))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un + cDelimitador +
                             string(ttDados.val-per-pad,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao + cDelimitador +
                             string(ttDados.de-desvio,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-per-pad-sec,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-percurso-sec,"->,>>>,>>9.99") + cDelimitador +
                             string(ttDados.val-padrao-sec,"->,>>>,>>9.9999") + cDelimitador +
                             string(ttDados.val-real-sec,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.relacao-sec + cDelimitador +
                             string(ttDados.de-desvio-sec,"->,>>>,>>9.99")) format cTamReg at 01.
                END.
                ELSE DO:
                    ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                                     string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                                     ttDados.un))) + ")".

                    put trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao) + cDelimitador + 
                             string(ttDados.qtd-combustivel,"->,>>>,>>9.9999") + cDelimitador +
                             ttDados.un) format cTamReg at 01.
                END.
            end.
        end.
        else do:
            ASSIGN cTamReg = "x(" + STRING(LENGTH(trim(trim(cDescPai) + 
                             trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao)))) + ")".

            put trim(trim(cDescPai) + 
                     trim(ttDados.cod-oficial) + "-" + trim(ttDados.desc-dimensao)) format cTamReg at 01.
        end.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoVisao wWindow 
PROCEDURE piTextoVisao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter rRow     as rowid     no-undo.
define input parameter cCodPai  as character no-undo.

ASSIGN cTituloTxt = ""
       cDescPai = "".

/** Verifica se existe n≠vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for each bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run piTextoVisao (input rowid(bfttDados2),
                          input bfttDados2.cod-dimens-pai).
    end.
end.

if i-impressao = 1 then DO:
    /** Busca os dados **/
    for first bfttDados2
        where rowid(bfttDados2) = rRow no-lock:
    end.

    if avail bfttDados2 AND bfttdados2.sequencia <= iVisaoAux then do:
        {abp/ab0609.i2 bfttDados2.p-image}
        assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador
               cDescPai   = trim(trim(cDescPai) + trim(bfttDados2.cod-oficial) + "-" + TRIM(bfttDados2.desc-dimensao) + cDelimitador).
    end.
END.
ELSE DO:
    /** Busca os dados **/
    for first bfttDados2
        where rowid(bfttDados2) = rRow no-lock:
    end.

    if avail bfttDados2 AND bfttdados2.sequencia <= iVisaoAux then do:
        {abp/ab0609.i2 bfttDados2.p-image}
        assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador
               cDescPai   = trim(trim(cDescPai) + trim(bfttDados2.cod-oficial) + "-" + TRIM(bfttDados2.desc-dimensao) + cDelimitador).
    end.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaEquipamento wWindow 
PROCEDURE setaEquipamento :
/*------------------------------------------------------------------------------
  Purpose:     setaEquipamento
  Parameters:  entrada ttSelecao = TempTable de Seleá∆o
  Notes:       Seta os parÉmetros do programa
------------------------------------------------------------------------------*/
define input parameter table for ttSelecao.

/** Busca registro de seleá∆o **/
find first ttSelecao no-lock no-error.

/** Se n∆o encontrar, cria o default **/
if not avail ttSelecao then do:
    run crittSelecao in this-procedure.
end.

/** Aplica a seleá∆o para a conulta **/
apply "CHOOSE":U to btRefresh in frame fPage0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tituloBrowse wWindow 
PROCEDURE tituloBrowse :
/*------------------------------------------------------------------------------
  Purpose:     labelBrowse
  Parameters:  entrada pImagem = N£mero da imagem da vis∆o
  Notes:       Coloca o label no browse conforme escolha
------------------------------------------------------------------------------*/
define input parameter pImagem as integer no-undo.

assign ttDados.desc-dimensao:visible in browse brDetalhe   = yes
       ttDados.qtd-combustivel:visible in browse brDetalhe = yes
       ttDados.un:visible in browse brDetalhe              = yes
       ttDados.val-per-pad:visible in browse brDetalhe     = yes
       ttDados.val-percurso:visible in browse brDetalhe    = yes
       ttDados.relacao:visible in browse brDetalhe         = yes
       ttDados.val-padrao:visible in browse brDetalhe      = yes
       ttDados.val-real:visible in browse brDetalhe        = yes
       ttDados.de-desvio:visible in browse brDetalhe       = YES.
IF  NOT ttSelecao.lLogContSec THEN DO:
    ASSIGN ttDados.val-per-pad-sec:visible in browse brDetalhe  = NO
           ttDados.val-percurso-sec:visible in browse brDetalhe = NO
           ttDados.relacao-sec:visible in browse brDetalhe      = NO
           ttDados.val-padrao-sec:visible in browse brDetalhe   = NO
           ttDados.val-real-sec:visible in browse brDetalhe     = NO
           ttDados.de-desvio-sec:visible in browse brDetalhe    = NO.
END.
ELSE DO:
    ASSIGN ttDados.val-per-pad-sec:visible in browse brDetalhe  = yes
           ttDados.val-percurso-sec:visible in browse brDetalhe = yes
           ttDados.relacao-sec:visible in browse brDetalhe      = yes
           ttDados.val-padrao-sec:visible in browse brDetalhe   = yes
           ttDados.val-real-sec:visible in browse brDetalhe     = yes
           ttDados.de-desvio-sec:visible in browse brDetalhe    = yes.
END.

if pImagem = 11 then
    assign ttDados.desc-dimensao:visible in browse brDetalhe = no.

ASSIGN brDetalhe:title in frame fPage0 = fnLabels(pImagem).

if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

if not(lReal) then
    assign ttDados.qtd-combustivel:visible in browse brDetalhe = no
           ttDados.un:visible in browse brDetalhe              = no
           ttDados.val-per-pad:visible in browse brDetalhe     = no
           ttDados.val-percurso:visible in browse brDetalhe    = no
           ttDados.relacao:visible in browse brDetalhe         = no
           ttDados.val-padrao:visible in browse brDetalhe      = no
           ttDados.val-real:visible in browse brDetalhe        = no
           ttDados.de-desvio:visible in browse brDetalhe       = NO
           ttDados.val-per-pad-sec:visible in browse brDetalhe  = no
           ttDados.val-percurso-sec:visible in browse brDetalhe = no
           ttDados.relacao-sec:visible in browse brDetalhe      = no
           ttDados.val-padrao-sec:visible in browse brDetalhe   = no
           ttDados.val-real-sec:visible in browse brDetalhe     = no
           ttDados.de-desvio-sec:visible in browse brDetalhe    = no.

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
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

if iTipo = 1 then do:
    case pCampo:
        when "cod-oficial":U then do:
            {utp/ut-liter.i "C¢digo"}
        end.
        when "desc-dimensao":U then do:
            {utp/ut-liter.i "Descriá∆o"}
        end.
        when "qtd-combustivel":U then do:
            {utp/ut-liter.i "Abastecido"}
        end.
        when "un":U then do:
            {utp/ut-liter.i "UN"}
        end.
        when "val-per-pad":U then do:
            {utp/ut-liter.i "Percurso Padr∆o"}
        end.
        when "val-percurso":U then do:
            {utp/ut-liter.i "Percurso Real"}
        end.
        when "val-padrao":U then do:
            {utp/ut-liter.i "Consumo Padr∆o"}
        end.
        when "val-real":U then do:
            {utp/ut-liter.i "Consumo Real"}
        end.
        when "de-desvio":U then do:
            {utp/ut-liter.i "% Desvio"}
        end.
        when "relacao":U then do:
            {utp/ut-liter.i "_"}
        end.
        when "val-per-pad-sec":U then do:
            {utp/ut-liter.i "Percurso Padr∆o Sec"}
        end.
        when "val-percurso-sec":U then do:
            {utp/ut-liter.i "Percurso Real Sec"}
        end.
        when "val-padrao-sec":U then do:
            {utp/ut-liter.i "Consumo Padr∆o Sec"}
        end.
        when "val-real-sec":U then do:
            {utp/ut-liter.i "Consumo Real Sec"}
        end.
        when "de-desvio-sec":U then do:
            {utp/ut-liter.i "% Desvio Sec"}
        end.
        when "relacao-sec":U then do:
            {utp/ut-liter.i "_"}
        end.
    end case.
    assign cRetorno = trim(return-value).
end.
else do:
    case pCampo:
        when "cod-oficial":U then do:
            assign cRetorno = ttDados.cod-oficial.
        end.
        when "desc-dimensao":U then do:
            assign cRetorno = ttDados.desc-dimensao.
        end.
        when "qtd-combustivel":U then do:
            assign cRetorno = string(ttDados.qtd-combustivel,"->,>>>,>>9.9999").
        end.
        when "un":U then do:
            assign cRetorno = ttDados.un.
        end.
        when "val-per-pad":U then do:
            assign cRetorno = string(ttDados.val-per-pad,"->,>>>,>>9.99").
        end.
        when "val-percurso":U then do:
            assign cRetorno = string(ttDados.val-percurso,"->,>>>,>>9.99").
        end.
        when "val-padrao":U then do:
            assign cRetorno = string(ttDados.val-padrao,"->,>>>,>>9.9999").
        end.
        when "val-real":U then do:
            assign cRetorno = string(ttDados.val-real,"->,>>>,>>9.9999").
        end.
        when "de-desvio":U then do:
            assign cRetorno = string(ttDados.de-desvio,"->,>>>,>>9.99").
        end.
        when "relacao":U then do:
            assign cRetorno = ttDados.relacao.
        end.
        when "val-per-pad-sec":U then do:
            assign cRetorno = string(ttDados.val-per-pad-sec,"->,>>>,>>9.99").
        end.
        when "val-percurso-sec":U then do:
            assign cRetorno = string(ttDados.val-percurso-sec,"->,>>>,>>9.99").
        end.
        when "val-padrao-sec":U then do:
            assign cRetorno = string(ttDados.val-padrao-sec,"->,>>>,>>9.9999").
        end.
        when "val-real-sec":U then do:
            assign cRetorno = string(ttDados.val-real-sec,"->,>>>,>>9.9999").
        end.
        when "de-desvio-sec":U then do:
            assign cRetorno = string(ttDados.de-desvio-sec,"->,>>>,>>9.99").
        end.
        when "relacao-sec":U then do:
            assign cRetorno = ttDados.relacao-sec.
        end.
    end case.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesvio wWindow 
FUNCTION fnDesvio RETURNS DECIMAL
  ( pPadrao as dec,
    pReal   as dec,
    iTipo   AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  fnDesvio
    Notes:  Calcula a porcentagem de desvio de consumo
------------------------------------------------------------------------------*/

  DEFINE VARIABLE deDesvio AS DECIMAL    NO-UNDO.

  CASE iTipo:

      WHEN 2 THEN
         ASSIGN deDesvio = IF (((pReal / pPadrao) * 100) = ?)
                           THEN 0
                           ELSE ((pReal / pPadrao) * 100) - 100.
      WHEN 3 THEN
         ASSIGN deDesvio = IF (((pPadrao / pReal ) * 100) = ?)
                           THEN 0
                           ELSE ((pPadrao / pReal) * 100) - 100.   
  END CASE.

  RETURN deDesvio.   /* Function return value. */

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
    {abp/ab0609.i2 pImage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMes wWindow 
FUNCTION fnMes RETURNS CHARACTER
  ( iMes as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnMes
    Notes:  Busca o Màs
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

case iMes:
    when 1 then do:
        {utp/ut-liter.i Janeiro}
    end.
    when 2 then do:
        {utp/ut-liter.i Fevereiro}
    end.
    when 3 then do:
        {utp/ut-liter.i Maráo}
    end.
    when 4 then do:
        {utp/ut-liter.i Abril}
    end.
    when 5 then do:
        {utp/ut-liter.i Maio}
    end.
    when 6 then do:
        {utp/ut-liter.i Junho}
    end.
    when 7 then do:
        {utp/ut-liter.i Julho}
    end.
    when 8 then do:
        {utp/ut-liter.i Agosto}
    end.
    when 9 then do:
        {utp/ut-liter.i Setembro}
    end.
    when 10 then do:
        {utp/ut-liter.i Outubro}
    end.
    when 11 then do:
        {utp/ut-liter.i Novembro}
    end.
    when 12 then do:
        {utp/ut-liter.i Dezembro}
    end.
end case.

assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

