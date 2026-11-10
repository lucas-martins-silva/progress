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

{include/i-prgvrs.i AB0608 2.00.00.030 } /*** "010030" 16/09/2024 11:31:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0608 MAB}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0608
&GLOBAL-DEFINE Version        2.00.00.030

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              btImprimir brDetalhe btRedimensiona btExcel btTxt btApont btEqpto btConsumo

{cdp/cdcfgmnt.i}

/* Local Variable Definitions ---                                       */
define variable c-arquivo     as character                no-undo.
define variable c-arquivo2    as character                no-undo.
define variable i-cont        as integer                  no-undo.
define variable i-cont2       as integer                  no-undo.
define variable iVisao        as integer                  no-undo.
define variable cSub          as character                no-undo.
define variable lReal         as logical                  no-undo.
/** TXT e EXCEL **/
define variable i-lin2        as integer initial 1         no-undo.
define variable i-lin         as integer initial 1         no-undo.
define variable i-col         as integer initial 1         no-undo.
define variable hHandle2      as handle                    no-undo.
define variable c-colunas     as character                 no-undo.
define variable hHandle       as handle                    no-undo.
define variable cDimensao     as character                 no-undo.
define variable cDimensaoPai  as character                 no-undo.
define variable i-col-aux     as integer                   no-undo.
define variable i-impressao   as integer                   no-undo.
DEFINE VARIABLE iVisao2       AS integer                   NO-UNDO.
DEFINE VARIABLE iControl      as integer initial 0         no-undo. /**Controle para formataá∆o da celula***/
define variable lCabecalho    as logical initial no        no-undo. /*Indica se gera cabeáalho */
DEFINE VARIABLE l-first       AS LOGICAL                   NO-UNDO.
define variable cDelimitador  as character format "x(01)"  no-undo. /*Indica o tipo de delimitador */
define variable cCaminho      as character format "x(300)" no-undo. /*Indica o caminho */
/** Busca Valor **/
define variable rRowid        as rowid                    no-undo.
define variable cCodPai       as character format "x(20)" no-undo.
define variable vCodigo       as character format "x(20)" no-undo.
define variable vDescricao    as character format "x(32)" no-undo.
define variable iImage        as integer                  no-undo.

DEFINE VARIABLE oTreeList   AS CLASS TotvsTreeList  NO-UNDO. //Visao

/** Controles **/
define variable l-expande     as log init no              no-undo.
define variable l-ok          as log                      no-undo.
define variable i-button-tree as int init 1               no-undo.
define variable i-result      as int                      no-undo.
/** Pop-Menu **/
define variable pop-menu      as widget-handle            no-undo.
define variable exp-con       as widget-handle            no-undo.
define variable detalhe       as widget-handle            no-undo.
define variable regua         as widget-handle            no-undo.
/*** Window ***/
define variable dWinXC        as decimal                  no-undo.
define variable dWinYC        as decimal                  no-undo.
/** C†lculo **/
define variable deQuantidade  AS decimal format  ">>>,>>>,>>9.99" no-undo.
define variable deValor       as decimal                       no-undo.
define variable deConsumo     as decimal                       no-undo.
define variable cun           as character                     no-undo.
define variable cTpMater      like mab-tip-mater.cod-tip-mater no-undo.
define variable cItem         as character                     no-undo.
define variable cCodBomba     as character                     no-undo.
define variable cCodPosto     as character                     no-undo.
define variable cEvento       as character                     no-undo.
DEFINE VARIABLE cComptmento   as character                     no-undo.
define variable cb-moeda      as character                     no-undo.
define variable cDescPai      as character format "x(400)"     no-undo.
define variable cTituloTxt    as character format "x(400)"     no-undo.
define variable cAtivid       as character                     no-undo.
define variable cTag          as character                     no-undo.
DEFINE VARIABLE cMotorista    AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE lIntEstoq     AS LOGICAL                       NO-UNDO.
define variable iNr-trans     like mab-item-abastec.nr-trans   no-undo.
define variable dt-Trans      like movto-estoq.dt-trans        no-undo.

def new global shared var gr-mab-eqpto            as rowid no-undo.
def new global shared var gr-mab-abastec-lubrific as rowid no-undo.
/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.

/** Dados **/
def temp-table ttDados no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field Codigo            as   character format "X(20)"
    field tpMater           as   character format "X(30)"
    field desc-dimensao     as   character format "x(32)"
    field Nivel             as   character format "x(40)"
    field cod-dimens-pai    as   character format "x(300)"
    field Quantidade        as   decimal format  ">>>,>>>,>>9.99"
    field Valor             as   decimal format  ">>>,>>>,>>>,>>9.99"
    field un                like mab-tip-mater.un
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    FIELD integracao        AS   CHAR FORMAT "x(15)"
    FIELD data              LIKE mab-abastec-lubrific.dat-movto
    FIELD hora              LIKE mab-abastec-lubrific.hra-inicial
    FIELD contador          LIKE mab-abastec-lubrific.val-hodom-horim
    FIELD nr-trans          LIKE mab-item-abastec.nr-trans
    FIELD dt-trans          LIKE movto-estoq.dt-trans
    index id is primary unique sequencia ascending
                               cod-dimensao ASCENDING
    index quantidade           quantidade descending
                               sequencia 
                               cod-dimensao 
    index Valor                Valor descending
                               sequencia 
                               cod-dimensao.

def temp-table ttUn no-undo
    field cor               as   integer
    field un                AS   CHAR
    field r-rowid           as   rowid
    index id is primary unique cor ascending
                               un ascending.

define buffer bfAbastec for mab-abastec-lubrific.
define buffer bfItemAbastec  for mab-item-abastec.
define buffer bfItemLubrific for mab-item-lubrific.
define buffer bfttDados for ttDados.
define buffer bfttDados2 for ttDados.
define buffer bfttVisao for ttVisao.

{cdp/cd9911.i}
{abp/ab0608.i}  /** Definiá∆o da temp-table de parÉmetros **/
{abp/ab9000.i}  /** Calculo para Data e Hora Invertida **/

/** Vari†veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}

DEF VAR qry3   AS HANDLE.
DEF VAR hTemp2 AS WIDGET-HANDLE NO-UNDO.
DEF VAR hTemp3 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE cEstab     LIKE mab-eqpto.cod-estabel          NO-UNDO.
DEFINE VARIABLE cGrpEqpto  LIKE mab-eqpto.cod-grp-eqpto        NO-UNDO.
DEFINE VARIABLE cCCCodigo  LIKE mab-abastec-lubrific.cc-codigo NO-UNDO.
DEFINE VARIABLE cEPCodigo  LIKE mab-abastec-lubrific.ep-codigo NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(03)"         NO-UNDO.
DEFINE VARIABLE v-param-55 AS LOGICAL INITIAL FALSE.

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
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttDados.Codigo ttDados.Nivel ttDados.Quantidade ttDados.Un ttDados.Valor ttDados.data ttDados.hora ttDados.contador ttDados.nr-trans ttDados.integracao ttDados.dt-trans   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalhe   
&Scoped-define SELF-NAME brDetalhe
&Scoped-define QUERY-STRING-brDetalhe FOR EACH ttDados no-lock
&Scoped-define OPEN-QUERY-brDetalhe OPEN QUERY {&SELF-NAME} FOR EACH ttDados no-lock.
&Scoped-define TABLES-IN-QUERY-brDetalhe ttDados
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalhe ttDados


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDetalhe}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btAbrir btSalvar btRefresh ~
btExpande btEqpto btNotaFiscal btApont btConsumo btParam btFiltro btVisao ~
btImprimir btExcel btTxt btQueryJoins btReportsJoins btExit btHelp ~
btRedimensiona brDetalhe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-coluna wWindow 
FUNCTION f-coluna RETURNS CHARACTER
  ( INPUT pHandle AS HANDLE,
    INPUT pCampo  AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBrowse wWindow 
FUNCTION fnBrowse RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer )  FORWARD.

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
       MENU-ITEM m_Consulta_Equipamento LABEL "&Consulta_Equipamento" ACCELERATOR "CTRL-X"
       MENU-ITEM m_Nota_Fiscal  LABEL "&Nota_Fiscal"   ACCELERATOR "CTRL-N"
       MENU-ITEM m_Apontamento  LABEL "&Apontamento"   ACCELERATOR "CTRL-Z"
       MENU-ITEM m_Consumo      LABEL "&Consumo"       ACCELERATOR "CTRL-D"
       MENU-ITEM miEvento       LABEL "E&ventos"       ACCELERATOR "CTRL-E"
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-J"
       MENU-ITEM m_Excel        LABEL "&Excel"         ACCELERATOR "CTRL-V"
       MENU-ITEM m_Exporta_TXT  LABEL "&Exporta TXT"   ACCELERATOR "CTRL-T"
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

DEFINE BUTTON btApont 
     IMAGE-UP FILE "image/im-apont.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.25 TOOLTIP "Apontamento".

DEFINE BUTTON btConsumo 
     IMAGE-UP FILE "image/mab-consumo.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.25 TOOLTIP "Consumo por Equipamento".

DEFINE BUTTON btEqpto 
     IMAGE-UP FILE "image/mab-eqpto.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Equipamento".

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
     IMAGE-INSENSITIVE FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btNotaFiscal 
     IMAGE-UP FILE "image/mab-nota.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Nota Fiscal".

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
  QUERY brDetalhe DISPLAY
      ttDados.Codigo      width 20
ttDados.Nivel       width 30
ttDados.Quantidade  width 16
ttDados.Un          width 03
ttDados.Valor       width 16
ttDados.data        WIDTH 11
ttDados.hora        WIDTH 09
ttDados.contador    WIDTH 10
ttDados.nr-trans    WIDTH 11
ttDados.integracao  WIDTH 16
ttDados.dt-trans    WIDTH 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 8.46
         FONT 1
         TITLE "" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btAbrir AT ROW 1.13 COL 2
     btSalvar AT ROW 1.13 COL 6
     btRefresh AT ROW 1.13 COL 10
     btExpande AT ROW 1.13 COL 13.86
     btEqpto AT ROW 1.13 COL 34.86
     btNotaFiscal AT ROW 1.13 COL 38.86
     btApont AT ROW 1.13 COL 42.86
     btConsumo AT ROW 1.13 COL 46.86
     btParam AT ROW 1.13 COL 50.86 HELP
          "ParÉmetros"
     btFiltro AT ROW 1.13 COL 54.86 HELP
          "Filtro"
     btVisao AT ROW 1.13 COL 58.86 HELP
          "Classifica"
     btImprimir AT ROW 1.13 COL 62.86 HELP
          "Impress∆o"
     btExcel AT ROW 1.13 COL 66.86
     btTxt AT ROW 1.13 COL 70.72
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btRedimensiona AT ROW 11 COL 1
     brDetalhe AT ROW 11.25 COL 1
     rtToolBar-2 AT ROW 1 COL 1
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
         TITLE              = "Sa°da de Combust°veis e Lubrificantes"
         HEIGHT             = 19.17
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

ASSIGN 
       btRedimensiona:MOVABLE IN FRAME fpage0          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDetalhe
/* Query rebuild information for BROWSE brDetalhe
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttDados no-lock
     _END_FREEFORM
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
ON END-ERROR OF wWindow /* Sa°da de Combust°veis e Lubrificantes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Sa°da de Combust°veis e Lubrificantes */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow /* Sa°da de Combust°veis e Lubrificantes */
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-unDO.


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
           btNotaFiscal:column in frame fPage0     = (btNotaFiscal:column in frame fPage0 + dXC)
           btApont:column in frame fPage0          = (btApont:column in frame fPage0 + dXC)
           btEqpto:column in frame fPage0          = (btEqpto:column in frame fPage0 + dXC)
           btConsumo:column in frame fPage0        = (btConsumo:column in frame fPage0 + dXC)
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
ON WINDOW-RESTORED OF wWindow /* Sa°da de Combust°veis e Lubrificantes */
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-unDO.


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
           btNotaFiscal:column in frame fPage0     = (btNotaFiscal:column in frame fPage0 - dXC)
           btApont:column in frame fPage0          = (btApont:column in frame fPage0 - dXC)
           btEqpto:column in frame fPage0          = (btEqpto:column in frame fPage0 - dXC)
           btConsumo:column in frame fPage0        = (btConsumo:column in frame fPage0 - dXC)
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


&Scoped-define SELF-NAME btAbrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAbrir wWindow
ON CHOOSE OF btAbrir IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAbrir  IN MENU mbMain DO:

   /** Troca as barras **/
   assign c-arquivo = replace(c-arquivo, "/", "~\").
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


&Scoped-define SELF-NAME btApont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btApont wWindow
ON CHOOSE OF btApont IN FRAME fpage0 /* Button 2 */
OR CHOOSE OF MENU-ITEM m_Apontamento  IN MENU mbMain 
DO:
  if oTreeList:hasNode() then do:
        run piApontamento in this-procedure.
    end.
    apply "ENTRY":U to btApont in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConsumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsumo wWindow
ON CHOOSE OF btConsumo IN FRAME fpage0 /* Button 3 */
OR CHOOSE OF MENU-ITEM m_Consumo  IN MENU mbMain 
DO:
    if oTreeList:hasNode() then do:
          case oTreeList:getDataInt(oTreeList:currentCode, "p-image"):                      
               when 5  then DO:                    
                  run piConsumo in this-procedure.
               end.
               otherwise     
                    RUN abp/ab0609.w.
          END CASE.

    END.
    apply "ENTRY":U to btEqpto in frame fPage0. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEqpto wWindow
ON CHOOSE OF btEqpto IN FRAME fpage0
OR CHOOSE OF MENU-ITEM m_Consulta_Equipamento  IN MENU mbMain 
DO:
     if oTreeList:hasNode() then do:
          case oTreeList:getDataInt(oTreeList:currentCode, "p-image"):                      
               when 5  then DO:                    
                  run piEqpto in this-procedure.
               end.
               otherwise     
                   RUN abp/ab0602.w.
          END CASE.

    END.
    apply "ENTRY":U to btEqpto in frame fPage0. 


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM m_Excel  IN MENU mbMain 
DO:
    if oTreeList:hasNode() then DO:
       run pi-exporta-excel in this-procedure.
    END.
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
    IF  oTreeList:hasNode() THEN DO:
        /** Controla expans∆o **/
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
  run abp/ab0608a.w (input-output  table ttselecao).
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
    if oTreeList:hasNode() then do:
        run piImprimir in this-procedure.
    end.
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNotaFiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNotaFiscal wWindow
ON CHOOSE OF btNotaFiscal IN FRAME fpage0
OR CHOOSE OF MENU-ITEM m_Nota_Fiscal IN MENU mbMain 
DO:
   if oTreeList:hasNode() then do:
        run piNotaFiscal in this-procedure.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miSelecao  IN MENU mbMain DO:
 assign {&window-name}:sensitive = no.
  run abp/ab0608c.w (input-output  table ttselecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btParam in frame fPage0.
  find first ttSelecao no-lock no-error.
     IF AVAIL ttSelecao THEN

      IF ttSelecao.lHabilita = YES 
         AND substring(ttSelecao.cb-moeda,1,1) = "0" THEN DO:
          ASSIGN btNotaFiscal:SENSITIVE IN FRAME fPage0 = YES. 
      END.
      ELSE DO:
         ASSIGN btNotaFiscal:SENSITIVE IN FRAME fPage0 = NO.
      END.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    Run showQueryJoins IN THIS-PROCEDURE.
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
    ASSIGN brDetalhe:title in frame fPage0 = "".

    FIND FIRST ttSelecao NO-LOCK NO-ERROR.
    FIND FIRST ttVisao NO-LOCK NO-ERROR.
    IF  AVAIL ttSelecao AND ttSelecao.lBuscaMovtoEstoque AND AVAIL ttVisao THEN DO:
        IF  NOT CAN-FIND(FIRST ttVisao
                         WHERE SUBSTRING(ttVisao.dimensao,1,2) = "23") THEN DO:
            {utp/ut-liter.i "Màs/Ano Integraá∆o, Documento"}
            RUN utp/ut-msgs.p (INPUT "Show":U,
                               INPUT 55735,
                               INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
    END.

    session:set-wait-state ("GENERAL").
    run piAtualizar in this-procedure.
    session:set-wait-state ("").

    APPLY "Entry":U TO btRefresh.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    Run showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSalvar  IN MENU mbMain DO:
   /** Troca os tipos de barras **/ 
   assign c-arquivo = replace(c-arquivo, "/", "~\")
          c-arquivo = "ab0608.dat":U.
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
                              ttSelecao.estabeqpto-ini
                              ttSelecao.estabeqpto-fim
                              ttSelecao.hora-ini         
                              ttSelecao.hora-fim         
                              ttSelecao.docto-ini        
                              ttSelecao.docto-fim        
                              ttSelecao.posto-ini        
                              ttSelecao.posto-fim        
                              ttSelecao.bomba-ini        
                              ttSelecao.bomba-fim        
                              ttSelecao.matrl-ini        
                              ttSelecao.matrl-fim        
                              ttSelecao.periodo-ini      
                              ttSelecao.periodo-fim      
                              ttSelecao.item-ini         
                              ttSelecao.item-fim         
                              ttSelecao.emitente-ini     
                              ttSelecao.emitente-fim     
                              ttSelecao.nota-ini         
                              ttSelecao.nota-fim         
                              ttSelecao.evento-ini       
                              ttSelecao.evento-fim       
                              ttSelecao.ccusto-ini-item       
                              ttSelecao.ccusto-fim-item
                              ttSelecao.comptmento-ini   
                              ttSelecao.comptmento-fim   
                              ttSelecao.cod-ativid-ini   
                              ttSelecao.cod-ativid-fim
                              ttSelecao.cod-tag-ini
                              ttSelecao.cod-tag-fim
                              ttSelecao.lCombutivel      
                              ttSelecao.lLubrific        
                              ttSelecao.lProprios      
                              ttSelecao.lTerceiros     
                              ttSelecao.lHabilita      
                              ttSelecao.lAtualiza      
                              ttSelecao.cb-moeda       
                              ttSelecao.classifica
                              ttSelecao.lAtivos
                              ttSelecao.lInativos
                              ttSelecao.lMotorizados
                              ttSelecao.lNmotorizados
                              ttSelecao.lTerc
                              ttSelecao.lProprio
                              ttSelecao.cod-motorista-ini  
                              ttSelecao.cod-motorista-fim
                              ttSelecao.cod-emitente-ini
                              ttSelecao.cod-emitente-fim
                              ttSelecao.trajeto-ini
                              ttSelecao.trajeto-fim
                              ttSelecao.cod-unid-negoc-eqpto-ini
                              ttSelecao.cod-unid-negoc-eqpto-fim
                              ttSelecao.cod-unid-negoc-ficha-ini
                              ttSelecao.cod-unid-negoc-ficha-fim
                              ttSelecao.lBuscaMovtoEstoque
                              .              
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
                          ttSelecao.estabeqpto-ini
                          ttSelecao.estabeqpto-fim
                          ttSelecao.hora-ini         
                          ttSelecao.hora-fim         
                          ttSelecao.docto-ini        
                          ttSelecao.docto-fim        
                          ttSelecao.posto-ini        
                          ttSelecao.posto-fim        
                          ttSelecao.bomba-ini        
                          ttSelecao.bomba-fim        
                          ttSelecao.matrl-ini        
                          ttSelecao.matrl-fim        
                          ttSelecao.periodo-ini      
                          ttSelecao.periodo-fim      
                          ttSelecao.item-ini         
                          ttSelecao.item-fim         
                          ttSelecao.emitente-ini     
                          ttSelecao.emitente-fim     
                          ttSelecao.nota-ini         
                          ttSelecao.nota-fim         
                          ttSelecao.evento-ini       
                          ttSelecao.evento-fim       
                          ttSelecao.ccusto-ini-item
                          ttSelecao.ccusto-fim-item
                          ttSelecao.comptmento-ini   
                          ttSelecao.comptmento-fim   
                          ttSelecao.cod-ativid-ini   
                          ttSelecao.cod-ativid-fim
                          ttSelecao.cod-tag-ini
                          ttSelecao.cod-tag-fim
                          ttSelecao.lCombutivel      
                          ttSelecao.lLubrific        
                          ttSelecao.lProprios      
                          ttSelecao.lTerceiros     
                          ttSelecao.lHabilita      
                          ttSelecao.lAtualiza      
                          ttSelecao.cb-moeda       
                          ttSelecao.classifica
                          ttSelecao.lAtivos
                          ttSelecao.lInativos
                          ttSelecao.lMotorizados
                          ttSelecao.lNmotorizados
                          ttSelecao.lTerc
                          ttSelecao.lProprio
                          ttSelecao.cod-motorista-ini  
                          ttSelecao.cod-motorista-fim
                          ttSelecao.cod-emitente-ini
                          ttSelecao.cod-emitente-fim
                          ttSelecao.trajeto-ini
                          ttSelecao.trajeto-fim
                          ttSelecao.lBuscaMovtoEstoque.
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
OR CHOOSE OF MENU-ITEM m_Exporta_TXT  IN MENU mbMain
DO:

  run pi-exporta-txt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisao wWindow
ON CHOOSE OF btVisao IN FRAME fpage0 /* Classificar */
OR CHOOSE OF MENU-ITEM miClassifica  IN MENU mbMain DO:

 assign {&window-name}:sensitive = no.
  run abp/ab0608b.w (input-output table ttvisao,
                     INPUT        TABLE ttSelecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btVisao in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDetalhe
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

RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccusto.
/* RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  "",                     /* EMPRESA EMS2 */           */
/*                                              INPUT  "",                     /* CODIGO DO PLANO CCUSTO */ */
/*                                              INPUT  "",                     /* UNIDADE DE NEGOCIO */     */
/*                                              INPUT  TODAY,                  /* DATA DE TRANSACAO */      */
/*                                              OUTPUT TABLE tt_ccusto_integr, /* CCUSTOS */                */
/*                                              OUTPUT TABLE tt_log_erro).     /* ERROS */                  */

{cdp/cdunif001b.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


IF VALID-HANDLE(h_api_ccusto) THEN
    DELETE PROCEDURE h_api_ccusto.

/** Caixa de mensagens **/
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
{utp/ut-liter.i "Codigo"}
assign ttDados.Codigo:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Descriá∆o"}
assign ttDados.Nivel:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Quantidade"}
assign ttDados.Quantidade:label in browse brDetalhe = return-value.
{utp/ut-liter.i "un"}
assign ttDados.Un:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Valor"}
assign ttDados.vAlor:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Integraá∆o"}
ASSIGN ttDados.integracao:LABEL IN BROWSE brDetalhe = RETURN-VALUE.
{utp/ut-liter.i "Data"}
ASSIGN ttDados.data:LABEL IN BROWSE brDetalhe = RETURN-VALUE.
{utp/ut-liter.i "Hora"}
ASSIGN ttDados.hora:LABEL IN BROWSE brDetalhe = RETURN-VALUE.
{utp/ut-liter.i "Contador"}
ASSIGN ttDados.contador:LABEL IN BROWSE brDetalhe = RETURN-VALUE.
{utp/ut-liter.i "Nr_Transaá∆o"}
ASSIGN ttDados.nr-trans:LABEL IN BROWSE brDetalhe = RETURN-VALUE.
{utp/ut-liter.i "Data_Integraá∆o"}
ASSIGN ttDados.dt-trans:LABEL IN BROWSE brDetalhe = RETURN-VALUE.

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
  Purpose:      
  Parameters:  <none>
  Notes:       Mostra registros no browse
------------------------------------------------------------------------------*/


    /** Se tiver filhos, mostra no browse, os filhos **/
    if avail ttDados then do:
        run tituloBrowse in this-procedure (ttDados.p-image).

        for first ttSelecao no-lock:
        end.

        if ttSelecao.classifica = 1 then do:
            open query brDetalhe for each  ttDados
                                     where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                                     by    ttDados.cod-dimensao.  
        end.
        else do:
            if ttSelecao.classifica = 2 then do:
                open query brDetalhe for each ttDados
                                     where    ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                                     by       ttDados.valor descending.
            end.
            else do:
                open query brDetalhe for each ttDados
                                     WHERE    ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                                     by       ttDados.quantidade descending.
            end.
        end.




    end.
    /** Sen∆o, mostra ele mesmo **/
    else do:
        run tituloBrowse in this-procedure (bfttDados.p-image).
        open query brDetalhe for each  ttDados
                                 where ttDados.cod-dimensao = bfttDados.cod-dimensao no-lock.

    end.


    if not(ttDados.Quantidade:visible in browse brDetalhe) then
        assign btImprimir:sensitive in frame fPage0 = no.
    else 
        assign btImprimir:sensitive in frame fPage0 = yes.

return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaNota wWindow 
PROCEDURE atualizaNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pNota  AS CHAR NO-UNDO.
define input parameter pSerie AS CHAR NO-UNDO.
define input parameter pValor AS DEC  NO-UNDO.
DEFINE VARIABLE Indicador1 AS DECIMAL  FORMAT "->>>,>>9.99999999"  NO-UNDO.
DEFINE VARIABLE Indicador2 AS DECIMAL  FORMAT "->>>,>>9.99999999"  NO-UNDO.
DEFINE VARIABLE AnoMes     AS CHARACTER FORMAT "9999/99" NO-UNDO.

for EACH  mab-abastec-lubrific
        where mab-abastec-lubrific.ep-codigo    >= ttSelecao.empresa-ini
        and   mab-abastec-lubrific.ep-codigo    <= ttSelecao.empresa-fim
        and   mab-abastec-lubrific.cod-eqpto    >= ttSelecao.equipto-ini
        and   mab-abastec-lubrific.cod-eqpto    <= ttSelecao.equipto-fim
        and   mab-abastec-lubrific.dat-movto    >= ttSelecao.periodo-ini
        and   mab-abastec-lubrific.dat-movto    <= ttSelecao.periodo-fim
        and   mab-abastec-lubrific.hra-inicial  >= ttSelecao.hora-ini
        and   mab-abastec-lubrific.hra-inicial  <= ttSelecao.hora-fim
        and   mab-abastec-lubrific.num-docto    >= ttSelecao.docto-ini
        and   mab-abastec-lubrific.num-docto    <= ttSelecao.docto-fim
        and   mab-abastec-lubrific.cod-posto    >= ttSelecao.posto-ini
        and   mab-abastec-lubrific.cod-posto    <= ttSelecao.posto-fim
        and   mab-abastec-lubrific.nr-nota-fis  >= ttSelecao.nota-ini 
        and   mab-abastec-lubrific.nr-nota-fis  <= ttSelecao.nota-fim
        AND   mab-abastec-lubrific.cod-rota     >= ttSelecao.trajeto-ini
        AND   mab-abastec-lubrific.cod-rota     <= ttSelecao.trajeto-fim NO-LOCK:

        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-abastec-lubrific.cod-unid-negoc >= ttSelecao.cod-unid-negoc-ficha-ini  AND 
                       mab-abastec-lubrific.cod-unid-negoc <= ttSelecao.cod-unid-negoc-ficha-fim) THEN NEXT.
            END.
        &ENDIF

        /** Seleciona os Postos **/
        if not avail mab-posto or mab-posto.cod-posto <> mab-abastec-lubrific.cod-posto then do:
            for first mab-posto fields(des-posto cod-posto cod-estabel cod-emitente )  
                where mab-posto.cod-posto        = mab-abastec-lubrific.cod-posto
                and   mab-posto.cod-estabel     >= ttSelecao.estab-ini
                and   mab-posto.cod-estabel     <= ttSelecao.estab-fim 
                and   ((mab-posto.idi-posto      = 1 and ttSelecao.lProprios)   /** Pr¢prios **/
                or    (mab-posto.idi-posto       = 2 and ttSelecao.lTerceiros))  /** Terceiros **/
                and   mab-posto.cod-emitente    >= ttSelecao.emitente-ini 
                and   mab-posto.cod-emitente    <= ttSelecao.emitente-fim  no-lock:
            end.
        end.

          /** Seleciona as Bombas **/
        if not avail mab-bomba or mab-bomba.cod-posto <> mab-abastec-lubrific.cod-posto then do:
           for first mab-bomba fields(cod-posto cod-bomba)  
               where mab-bomba.cod-posto     = mab-abastec-lubrific.cod-posto 
               and   mab-bomba.cod-bomba    >= ttSelecao.bomba-ini
               and   mab-bomba.cod-bomba    <= ttSelecao.bomba-fim no-lock:
           end.
       end.

         /** Seleciona os equipamento **/
        if not avail mab-eqpto or mab-eqpto.ep-codigo <> mab-abastec-lubrific.ep-codigo OR mab-eqpto.cod-eqpto <> mab-abastec-lubrific.cod-eqpto then do:
            for first mab-eqpto fields(cod-model cod-eqpto ep-codigo cod-grp-eqpto cod-estabel cod-emitente)  
                where mab-eqpto.ep-codigo          = mab-abastec-lubrific.ep-codigo
                and   mab-eqpto.cod-eqpto          = mab-abastec-lubrific.cod-eqpto 
                and   mab-eqpto.cod-model         >= ttSelecao.modelo-ini
                and   mab-eqpto.cod-model         <= ttSelecao.modelo-fim
                and   mab-eqpto.cod-grp-eqpto     >= ttSelecao.grupo-ini
                and   mab-eqpto.cod-grp-eqpto     <= ttSelecao.grupo-fim
                AND   mab-eqpto.cod-emitente      >= ttSelecao.emitente-ini
                AND   mab-eqpto.cod-emitente      <= ttSelecao.emitente-fim no-lock:
            end.
        end.

        ASSIGN AnoMes =   string(year(mab-abastec-lubrific.dat-movto),"9999") + string(month(mab-abastec-lubrific.dat-movto),"99").

          find first param-estoq NO-LOCK NO-ERROR.
             IF AVAIL param-estoq THEN
               if  param-estoq.tem-moeda1 then do:
                   find moeda where moeda.mo-codigo = param-estoq.moeda1 NO-LOCK NO-ERROR.
                              FIND cotacao WHERE cotacao.mo-codigo    = param-estoq.moeda1
                                           AND   cotacao.ano-periodo  = AnoMes  NO-LOCK NO-ERROR.
                                                 ASSIGN Indicador1 =  cotacao.cotacao[DAY(mab-abastec-lubrific.dat-movto)].
               END.
             if  param-estoq.tem-moeda2 then do:
                 find moeda where moeda.mo-codigo = param-estoq.moeda2 NO-LOCK NO-ERROR.
                            FIND cotacao WHERE cotacao.mo-codigo    = param-estoq.moeda2
                                         AND   cotacao.ano-periodo  = AnoMes  NO-LOCK NO-ERROR.
                                               ASSIGN Indicador2 =  cotacao.cotacao[DAY(mab-abastec-lubrific.dat-movto)].
               END.





          /** Busca fichas de Abastecimentos **/
        if ttSelecao.lCombutivel = YES then do:
            assign  deQuantidade   = 0
                    deValor        = 0
                    cTpMater       = ""
                    cItem          = ""
                    cCodBomba      = "".
            for each mab-item-abastec fields(num-docto cod-tip-mater it-codigo val-mater-1 val-mater-2 val-mater-3 val-quant cod-posto )  
               where mab-item-abastec.num-docto        = mab-abastec-lubrific.num-docto
               AND   mab-item-abastec.cod-tip-mater    >= ttSelecao.matrl-ini 
               AND   mab-item-abastec.cod-tip-mater    <= ttSelecao.matrl-fim 
               AND   mab-item-abastec.it-codigo        >= ttSelecao.item-ini
               AND   mab-item-abastec.it-codigo        <= ttSelecao.item-fim
               AND   mab-item-abastec.cod-posto        = mab-posto.cod-posto no-lock,
               FIRST mab-tip-mater FIELDS (cod-tip-mater un des-tip-mater)
                     WHERE mab-tip-mater.cod-tip-mater = mab-item-abastec.cod-tip-mater NO-LOCK:
              
                      IF NOT AVAIL  mab-item-abastec  THEN NEXT.
                      
                        /** Atualiza Nota, Serie e Valor **/
                    FOR EACH bfAbastec WHERE ROWID(bfAbastec) = ROWID(mab-abastec-lubrific) EXCLUSIVE-LOCK:

                                 ASSIGN bfAbastec.nr-nota-fis =  pNota 
                                        bfAbastec.serie       =  pSerie.
                                 FOR FIRST bfItemAbastec FIELDS (num-docto val-mater-1 val-mater-2 val-mater-3 val-quant  )
                                     WHERE bfItemAbastec.num-docto   = mab-abastec-lubrific.num-docto EXCLUSIVE-LOCK:
                                     IF  pValor = 0 THEN DO:
                                           ASSIGN bfItemAbastec.val-mater-1 = mab-item-abastec.val-mater-1.
                                        IF Indicador1 > 0 THEN
                                            ASSIGN bfItemAbastec.val-mater-2 = mab-item-abastec.val-mater-2.
                                        IF Indicador2 > 0 THEN
                                           ASSIGN bfItemAbastec.val-mater-3 = mab-item-abastec.val-mater-3.
                                     END.
                                     ELSE DO:
                                        ASSIGN bfItemAbastec.val-mater-1 = bfItemAbastec.val-quant * pValor.
                                        IF Indicador1 > 0 THEN
                                            ASSIGN bfItemAbastec.val-mater-2 = bfItemAbastec.val-mater-1 / Indicador1.
                                        IF Indicador2 > 0 THEN
                                           ASSIGN bfItemAbastec.val-mater-3 = bfItemAbastec.val-mater-1 / Indicador2.
                                     END.

                                 END.


                    END.
           end.
       end.




     /** Busca fichas de  lubrificaá∆o **/

       if ttSelecao.lLubrific  = YES then do:
            assign  deQuantidade = 0
                    deValor      = 0
                    cTpMater     = ""
                    cItem        = ""
                    cCodBomba    = "".
           for each  mab-item-lubrific fields(num-docto cod-tip-mater it-codigo val-mater-1 val-mater-2 val-mater-3 val-quant cod-evento cod-comptmento)  
               where mab-item-lubrific.num-docto         = mab-abastec-lubrific.num-docto 
               AND   mab-item-lubrific.cod-tip-mater    >= ttSelecao.matrl-ini 
               AND   mab-item-lubrific.cod-tip-mater    <= ttSelecao.matrl-fim 
               AND   mab-item-lubrific.it-codigo        >= ttSelecao.item-ini
               AND   mab-item-lubrific.it-codigo        <= ttSelecao.item-fim
               AND   mab-item-lubrific.cod-evento       >= ttSelecao.evento-ini 
               AND   mab-item-lubrific.cod-evento       <= ttSelecao.evento-fim
               AND   mab-abastec-lubrific.cod-posto      = mab-posto.cod-posto no-lock,
                FIRST mab-tip-mater FIELDS (cod-tip-mater un des-tip-mater)
                     WHERE mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater NO-LOCK:
                        IF NOT AVAIL   mab-item-lubrific  THEN NEXT.
                                 

                                    /** Atualiza Nota, Serie e Valor **/
                                FOR EACH bfAbastec WHERE ROWID(bfAbastec) = ROWID(mab-abastec-lubrific) EXCLUSIVE-LOCK:
                                             ASSIGN bfAbastec.nr-nota-fis =  pNota 
                                                    bfAbastec.serie       =  pSerie.
                                             FOR FIRST  bfItemLubrific FIELDS (num-docto val-mater-1 val-mater-2 val-mater-3 val-quant  )
                                                 WHERE  bfItemLubrific.num-docto   = mab-abastec-lubrific.num-docto EXCLUSIVE-LOCK:
                                                  IF pValor = 0 THEN DO: 
                                                       ASSIGN  bfItemLubrific.val-mater-1 =  mab-item-lubrific.val-mater-1.
                                                    IF Indicador1 > 0 THEN
                                                        ASSIGN  bfItemLubrific.val-mater-2 =  mab-item-lubrific.val-mater-2.
                                                    IF Indicador2 > 0 THEN
                                                       ASSIGN  bfItemLubrific.val-mater-3 =  mab-item-lubrific.val-mater-3.
                                                  END.
                                                  ELSE DO:
                                                       ASSIGN  bfItemLubrific.val-mater-1 =  bfItemLubrific.val-quant * pValor.
                                                    IF Indicador1 > 0 THEN
                                                        ASSIGN  bfItemLubrific.val-mater-2 =  bfItemLubrific.val-mater-1 / Indicador1.
                                                    IF Indicador2 > 0 THEN
                                                       ASSIGN  bfItemLubrific.val-mater-3 =  bfItemLubrific.val-mater-1 / Indicador2.
                                                  END.

                                             END.
                                                                  

                                END.





           end.
       end.


end. /** mab-abastec-lubrific **/
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
ASSIGN dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

run criattSelecao in this-procedure.

/** Verifica Integraá∆o Frotas x Estoque E M S **/
for first mab-param-integr fields(des-valor cdn-param)
    where mab-param-integr.cdn-param = 8 no-lock:
    if mab-param-integr.des-valor > "1" then
        assign lIntEstoq = yes.
    else
        assign lIntEstoq = no.
end.

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
     
    IF  (cEvent =   "selected"  OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:
        /* Guarda rowid do tree-view */
        ASSIGN rRowid   =   TO-ROWID(oTreeList:getDataChar(cNodeId, "r-rowid-visao")).

        /** Busca Registro com rowid **/
        FOR FIRST   bfttDados 
            WHERE   ROWID(bfttDados)    =   rRowid  NO-LOCK:
        end.

        /** Verifica se ele cont≤m filhos **/
        FOR FIRST   ttDados
            WHERE   ttDados.cod-dimens-pai  =   bfttDados.cod-dimensao NO-LOCK:
        END.

        IF  AVAIL   ttDados THEN    DO:
            /** Mostra registros no browse **/
            RUN atualizaBrowse  IN  THIS-PROCEDURE.
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
       vDescricao = ""
       iImage     = 0
       rRowid     = ?.
/** Verifica tipo de vis∆o (classificaá∆o) **/
case substring(trim(pValorDimensao),1,2):
     /** Estabelecimento **/
    when "01":U then do:
        if not avail estabelec or estabelec.cod-estabel <> cEstab then do:
            for first estabelec fields(nome cod-estabel)  
                where estabelec.cod-estabel = cEstab no-lock:
            end.
        end.
        if avail estabelec then do:
            assign vCodigo    = cEstab
                   vDescricao = estabelec.nome
                   iImage     = 1
                   rRowid     = rowid(estabelec).
        end.
        else do:
            {utp/ut-liter.i "Estabelecimento N∆o Dispon°vel"}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 1
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Empresa **/
    when "02":U then do:
        if not avail empresa or empresa.ep-codigo <> mab-eqpto.ep-codigo then do:
            for first empresa fields(nome ep-codigo)  
                where empresa.ep-codigo = mab-eqpto.ep-codigo no-lock:
            end.
        end.
        if avail empresa then do:
            assign vCodigo    = string(mab-eqpto.ep-codigo, "999")
                   vDescricao = empresa.nome
                   iImage     = 2
                   rRowid     = rowid(empresa).
        end.
        else do:
            {utp/ut-liter.i "Empresa N∆o Dispon°vel"}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 2
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Grupo Equipamento **/
    when "03":U then do:
        if not avail mab-grp-eqpto or mab-grp-eqpto.cod-grp-eqpto <> cGrpEqpto then do:
            for first mab-grp-eqpto fields(des-grp-eqpto cod-grp-eqpto)  
                where mab-grp-eqpto.cod-grp-eqpto = cGrpEqpto no-lock:
            end.
        end.
        if avail mab-grp-eqpto then do:
            assign vCodigo    = cGrpEqpto
                   vDescricao = mab-grp-eqpto.des-grp-eqpto
                   iImage     = 3
                   rRowid     = rowid(mab-grp-eqpto).
        end.
        ELSE DO:
            {utp/ut-liter.i "Grupo Equipamento Inexistente"}
            assign vCodigo    = "_":U
                   vDescricao = RETURN-VALUE
                   iImage     = 3
                   rRowid     = rowid(mab-eqpto).
        END.
    end.

     /** Modelo Equipamento **/
    when "04":U then do:
        if avail mab-model then do:
            assign vCodigo    = mab-eqpto.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 4
                   rRowid     = rowid(mab-model).
        end.
        else do:
            {utp/ut-liter.i Model_N∆o_Encontrado}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 4
                   rRowid     = rowid(empresa).
        end.
    end.
     /** Equipamento **/
    when "05":U then do:
        assign vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
               iImage     = 5
               rRowid     = rowid(mab-eqpto).
        if avail mab-model then do:
            assign vDescricao = mab-model.des-model.
        end.
        else do:
            assign vDescricao = "_".
        end.
    end.
   /** Data Movimento **/
    when "06":U then do:
        assign vCodigo    = SUBSTRING(STRING(mab-abastec-lubrific.val-dat-hora-invrtda), 1, 08)
               vDescricao = string(mab-abastec-lubrific.dat-movto,"99/99/9999")
               iImage     = 6
               rRowid     = rowid(mab-abastec-lubrific).
    end.
    /** Hora Movimento **/
    when "07":U then do:
        assign vCodigo    = SUBstring(STRING(mab-abastec-lubrific.val-dat-hora-invrtda), 9, 4)
               vDescricao = string(mab-abastec-lubrific.hra-inicial,"99:99:99")
               iImage     = 7
               rRowid     = rowid(mab-abastec-lubrific).        
    end.
     /** Posto **/
     when "08":U then do:
        if not avail mab-posto or mab-posto.cod-posto <> cCodPosto then do:
            for first mab-posto fields(des-posto cod-posto)  
                where mab-posto.cod-posto = cCodPosto no-lock:
            end.
        end.
        if avail mab-posto then do:
            assign vCodigo    = mab-posto.cod-posto
                   vDescricao = mab-posto.des-posto
                   iImage     = 8
                   rRowid     = rowid(mab-posto).
        end.
        else do:
            {utp/ut-liter.i Posto_N∆o_Encontrado}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 8
                   rRowid     = rowid(mab-eqpto).
        end.
    end.
    /** Bomba **/
    when "09":U then do:
        if not avail mab-bomba or mab-bomba.cod-bomba <> cCodBomba then do:
            for first mab-bomba fields(cod-bomba cod-posto)  
                where mab-bomba.cod-bomba = cCodBomba 
                  AND mab-bomba.cod-posto = cCodPosto no-lock:
            end.
        end.
        if avail mab-bomba then do:
            assign vCodigo    = cCodBomba 
                   iImage     = 9
                   rRowid     = rowid(mab-bomba).
        end.      
        ELSE DO:
             assign vCodigo   = "0"
                    iImage     = 9
                    rRowid     = rowid(mab-abastec-lubrific). 
        END.
    end.
    /** Tipo Material **/
    when "10":U then do:
        if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> cTpMater then do:
            for first mab-tip-mater fields(des-tip-mater cod-tip-mater)  
                where mab-tip-mater.cod-tip-mater = cTpMater no-lock:
            end.
        end.
        if avail mab-tip-mater then do:
            assign vCodigo    = cTpMater
                   vDescricao = mab-tip-mater.des-tip-mater
                   iImage     = 10
                   rRowid     = rowid(mab-tip-mater).
        end.        
    end.
    /** Item Estoque **/
    when "11":U then do:
        if not avail item or item.it-codigo <> cItem then do:
            for first item fields(desc-item it-codigo)  
                where item.it-codigo = cItem no-lock:
            end.
        end.
        if avail item then do:
            assign vCodigo    = if cItem = "" then "_" else cItem
                   vDescricao = item.desc-item
                   iImage     = 11
                   rRowid     = rowid(item).
        end.   
        else do:
            {utp/ut-liter.i Item_Estoque_N∆o_Encontrado}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 11
                   rRowid     = rowid(mab-abastec-lubrific).
        end.
    end.
    /** Emitente **/
    when "12":U then do:
          if not avail emitente or emitente.cod-emitente <> mab-posto.cod-emitente then do:
            for first emitente fields(nome-emit cod-emitente)  
                where emitente.cod-emitente = mab-posto.cod-emitente no-lock:
            end.
        end.
        if avail emitente then do:
            assign vCodigo    = string(emitente.cod-emitente, ">>>>>>>>9") 
                   vDescricao = emitente.nome-emit
                   iImage     = 12
                   rRowid     = rowid(emitente).
        end.    
        ELSE DO:
           ASSIGN  vCodigo    = string( mab-posto.cod-emitente) 
                   vDescricao = ""
                   iImage     = 12
                   rRowid     = rowid(mab-posto).
        END.
    end.
    /** Nota Fiscal **/
    when "13":U then do:
            assign vCodigo    = IF mab-abastec-lubrific.nr-nota-fis = "" THEN "0" ELSE mab-abastec-lubrific.nr-nota-fis
                   iImage     = 13
                   rRowid     = rowid(mab-abastec-lubrific).
            IF vCodigo = "" THEN ASSIGN vCodigo = "0".

    end.
     /** Màs / Ano **/
    when "14":U then do:
        assign vCodigo    = string(year(mab-abastec-lubrific.dat-movto),"9999") + string(month(mab-abastec-lubrific.dat-movto),"99") 
               vDescricao = fnMes(month(mab-abastec-lubrific.dat-movto)) + " " + string(year(mab-abastec-lubrific.dat-movto),"9999")
               iImage     = 14
               rRowid     = rowid(mab-abastec-lubrific).
    end.
     /**Evento **/
    when "15":U then do:
        if not avail mab-event or mab-event.cod-evento <> cEvento then do:
            for first mab-event fields(des-evento cod-evento)  
                where mab-event.cod-evento = cEvento no-lock:
            end.
        end.
        if avail mab-event then do:
            assign vCodigo    = if cEvento = "" then "_" else cEvento 
                   vDescricao = mab-event.des-evento
                   iImage     = 15
                   rRowid     = rowid(mab-event).
        end.
        ELSE DO:
            {utp/ut-liter.i Abastecimento}
            ASSIGN vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 15
                   rRowid     = ROWID(mab-item-abastec).
        END.
    end.
    /** Documento **/
    when "16":U then do:
      assign vCodigo    = string(mab-abastec-lubrific.num-docto, "999999999").
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
         run utp/ut-liter.p (input replace(trim(cauxtraducao001)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN vDescricao = RETURN-VALUE.
     &else
         ASSIGN vDescricao = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
     &endif

        ASSIGN iImage     = 16
               rRowid     = rowid(mab-abastec-lubrific). 
    END.
   /** Centro de Custo **/
    WHEN "17":U THEN DO:
        RUN posicionaTTCCustoIntegr IN THIS-PROCEDURE.
        IF AVAIL (tt_ccusto_integr) THEN DO:
            assign vCodigo    = cCCCodigo
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 17
                   rRowid     = rowid(tt_ccusto_integr).
        end.
        else do:
            {utp/ut-liter.i "Centro Custo_em_Branco"}
            assign vCodigo    = "_ "
                   vDescricao = RETURN-VALUE
                   iImage     = 17
                   rRowid     = rowid(mab-eqpto).
        END.
    END.
    /** Compartimento **/
    WHEN "18":U THEN DO:
        IF NOT AVAIL mab-comptmento OR mab-comptmento.cod-comptmento <> cComptmento THEN DO:
            FOR FIRST mab-comptmento WHERE
                  mab-comptmento.cod-comptmento = cComptmento NO-LOCK:
            END.
        END.
        IF AVAIL mab-comptmento THEN DO:
            ASSIGN vCodigo    = cComptmento
                   iImage     = 18
                   rRowid     = ROWID(mab-comptmento)
                   vDescricao = mab-comptmento.des-comptmento.
        END.
        ELSE DO:
            {utp/ut-liter.i Abastecimento}
            ASSIGN vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 18
                   rRowid     = ROWID(mab-item-abastec).
        END.
    END.
    /** Atividade **/
    WHEN "19":U THEN DO:
        IF NOT AVAIL mab-ativid OR mab-ativid.cod-ativid <> cAtivid THEN DO:
            FOR FIRST mab-ativid WHERE
                      mab-ativid.cod-ativid = cAtivid NO-LOCK:
            END.
        END.
        IF AVAIL mab-ativid THEN DO:
            ASSIGN vCodigo    = cAtivid
                   iImage     = 19
                   rRowid     = ROWID(mab-ativid)
                   vDescricao = mab-ativid.des-ativid.
        END.
        ELSE DO:
            {utp/ut-liter.i Atividade_N∆o_Encontrada}
            ASSIGN vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 19
                   rRowid     = ROWID(mab-abastec-lubrific).
        END.
    END.
    /** TAG **/
    WHEN "20":U THEN DO:
        IF NOT AVAIL tag OR tag.cd-tag <> cTag THEN DO:
            FOR FIRST tag WHERE
                      tag.cd-tag = cTag NO-LOCK:
            END.
        END.
        IF AVAIL tag THEN DO:
            ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                   iImage     = 20
                   rRowid     = ROWID(tag)
                   vDescricao = tag.descricao.
        END.
        ELSE DO:
            {utp/ut-liter.i TAG_N∆o_Encontrada}
            ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                   vDescricao = RETURN-VALUE
                   iImage     = 20
                   rRowid     = ROWID(mab-abastec-lubrific).
        END.
    END.
    /** Estabelecimento Posto **/
    when "21":U then do:
        if not avail estabelec or estabelec.cod-estabel <> mab-posto.cod-estabel then do:
            for first estabelec fields(nome cod-estabel)
                where estabelec.cod-estabel = mab-posto.cod-estabel no-lock:
            end.
        end.
        if avail estabelec then do:
            assign vCodigo    = mab-posto.cod-estabel
                   vDescricao = estabelec.nome
                   iImage     = 21
                   rRowid     = rowid(estabelec).
        end.
        else do:
            {utp/ut-liter.i "Estabelecimento_Posto_N∆o_Encontrado"}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 21
                   rRowid     = rowid(mab-posto).
        end.
    end.
    /** MOTORISTA **/
    WHEN "22":U THEN DO:
        IF NOT AVAIL mab-motoris OR mab-motoris.cod-matr <> cMotorista THEN DO:
            FOR FIRST mab-motoris WHERE
                      mab-motoris.cod-matr = cMotorista NO-LOCK:
            END.
        END.
        IF AVAIL mab-motoris THEN DO:
            ASSIGN vCodigo    = cMotorista
                   iImage     = 22
                   rRowid     = ROWID(mab-motoris)
                   vDescricao = mab-motoris.nom-motoris.
        END.
        ELSE DO:
            {utp/ut-liter.i Motorista_N∆o_Encontrada}
            ASSIGN vCodigo    = "_"
                   vDescricao = RETURN-VALUE
                   iImage     = 22
                   rRowid     = ROWID(mab-abastec-lubrific).
        END.
    END.
    /** Mes/Ano Integracao **/
    WHEN "23":U THEN DO:
        if avail movto-estoq then do:
            assign vCodigo    = string(month(movto-estoq.dt-trans),"99") + "/" + string(year(movto-estoq.dt-trans),"9999")
                   vDescricao = fnMes(month(movto-estoq.dt-trans)) + " " + string(year(movto-estoq.dt-trans),"9999")
                   iImage     = 23
                   rRowid     = rowid(movto-estoq).
        end.
        else do:
            {utp/ut-liter.i N∆o_Integrado}
            assign vCodigo    = "_"
                   vDescricao = return-value
                   iImage     = 23
                   rRowid     = rowid(mab-abastec-lubrific).
                   
        end.
    END.    
    when "24":U then do:
        if not avail emitente or emitente.cod-emitente <> mab-eqpto.cod-emitente then do:   
            for first emitente fields(cod-emitente nome-abrev)  
                where emitente.cod-emitente = mab-eqpto.cod-emitente no-lock:
            end.
        end.
        if avail emitente then do:
            assign vCodigo    = STRING(emitente.cod-emitente) 
                   vDescricao = nome-abrev
                   iImage     = 24
                   rRowid     = rowid(emitente).
        end.
        else do:
            {utp/ut-liter.i Propriet†rio_N∆o_Encontrado }
            assign vCodigo    = mab-eqpto.cod-estrut-mec 
                   vDescricao = RETURN-VALUE
                   iImage     = 24
                   rRowid     = rowid(mab-eqpto).
        end.
    end. 
/*     WHEN "25":U THEN DO:                                                                                 */
/*         IF mab-eqpto.idi-tip-propriet = 1 THEN {utp/ut-liter.i Pr¢prio } ELSE {utp/ut-liter.i Terceiro } */
/*         ASSIGN vCodigo    = STRING(mab-eqpto.idi-tip-propriet)                                           */
/*                vDescricao = RETURN-VALUE                                                                 */
/*                iImage     = 25                                                                           */
/*                rRowid     = ROWID(mab-eqpto).                                                            */
/*     END.                                                                                                 */
    WHEN "25":U THEN DO:
        ASSIGN vCodigo    = STRING(mab-eqpto.idi-tip-propriet) 
               vDescricao = {frinc/i01fr007.i 4 mab-eqpto.idi-tip-propriet }
               iImage     = 25
               rRowid     = ROWID(mab-eqpto).
    END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "26" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR cUnidNegoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = cUnidNegoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 26
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unid_Negoc_Eqpto_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 26
                           rRowid     = ROWID(mab-eqpto).
                END.
            END.
        END.
        WHEN "27" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-abastec-lubrific.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 27
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unid_Negoc_Ficha_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 27
                           rRowid     = ROWID(mab-abastec-lubrific).
                END.
            END.       
        END.

    &ENDIF
        WHEN "28" THEN DO:
        /* Faz a busca por informaá‰es de trajeto */
        IF  NOT AVAIL mab-trajeto OR mab-abastec-lubrific.cod-rota <> mab-trajeto.cod-rota THEN DO:
            FOR FIRST mab-trajeto FIELDS(cod-rota des-rota)
                WHERE mab-trajeto.cod-rota = mab-abastec-lubrific.cod-rota NO-LOCK:
            END.
        END.
        IF  AVAIL mab-trajeto THEN DO:
            ASSIGN vCodigo    = mab-abastec-lubrific.cod-rota
                   vDescricao = mab-trajeto.des-rota
                   iImage     = 28 /* Essa imagem deve estar cadastrada no ab0608.wrx */
                   rRowid     = ROWID(mab-trajeto).
        END.
        ELSE DO:
               IF trim(mab-abastec-lubrific.cod-rota) = "" OR mab-abastec-lubrific.cod-rota = ? THEN DO:
                    {utp/ut-liter.i "Trajeto_n∆o_Informado_no_Abastecimento"}
               END.
               ELSE DO:
                               {utp/ut-liter.i "Trajeto_n∆o_Encontrado"}
               END.
        ASSIGN vCodigo    = "_"
               vDescricao = RETURN-VALUE
               iImage     = 28 /* Essa imagem deve estar cadastrada no ab0608.wrx */
               rRowid     = ROWID(mab-abastec-lubrific).
        END.
    END.

end case.

RETURN "OK":U.
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
    assign c-linha                      = replace (c-linha, chr(34), "")
       &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.empresa-ini        = entry(1,c-linha,";")
           ttSelecao.empresa-fim        = entry(2,c-linha,";")
       &ELSE
           ttSelecao.empresa-ini        = int(entry(1,c-linha,";"))
           ttSelecao.empresa-fim        = int(entry(2,c-linha,";"))
       &ENDIF
           ttSelecao.equipto-ini        = entry(3,c-linha,";")
           ttSelecao.equipto-fim        = entry(4,c-linha,";")
           ttSelecao.grupo-ini          = entry(5,c-linha,";")
           ttSelecao.grupo-fim          = entry(6,c-linha,";")
           ttSelecao.modelo-ini         = entry(7,c-linha,";")
           ttSelecao.modelo-fim         = entry(8,c-linha,";")
           ttSelecao.estab-ini          = entry(9,c-linha,";")
           ttSelecao.estab-fim          = entry(10,c-linha,";")
           ttSelecao.estabeqpto-ini     = entry(11,c-linha,";")
           ttSelecao.estabeqpto-fim     = entry(12,c-linha,";")
           ttSelecao.hora-ini           = entry(13,c-linha,";")
           ttSelecao.hora-fim           = entry(14,c-linha,";")
           ttSelecao.docto-ini          = int(entry(15,c-linha,";"))
           ttSelecao.docto-fim          = int(entry(16,c-linha,";"))
           ttSelecao.posto-ini          = entry(17,c-linha,";")
           ttSelecao.posto-fim          = entry(18,c-linha,";")
           ttSelecao.bomba-ini          = entry(19,c-linha,";")
           ttSelecao.bomba-fim          = entry(20,c-linha,";")
           ttSelecao.matrl-ini          = entry(21,c-linha,";")
           ttSelecao.matrl-fim          = entry(22,c-linha,";")
           ttSelecao.periodo-ini        = date(entry(23,c-linha,";"))
           ttSelecao.periodo-fim        = date(entry(24,c-linha,";"))
           ttSelecao.item-ini           = entry(25,c-linha,";")
           ttSelecao.item-fim           =  entry(26,c-linha,";")
           ttSelecao.emitente-ini       = int(entry(27,c-linha,";"))
           ttSelecao.emitente-fim       = int(entry(28,c-linha,";"))
           ttSelecao.nota-ini           = entry(29,c-linha,";")
           ttSelecao.nota-fim           = entry(30,c-linha,";")
           ttSelecao.evento-ini         = entry(31,c-linha,";")
           ttSelecao.evento-fim         = entry(32,c-linha,";")
           ttSelecao.ccusto-ini-item    = entry(33,c-linha,";")
           ttSelecao.ccusto-fim-item    = entry(34,c-linha,";")
           ttSelecao.comptmento-ini     = entry(35,c-linha,";")
           ttSelecao.comptmento-fim     = entry(36,c-linha,";")
           ttSelecao.cod-ativid-ini     = entry(37,c-linha,";")
           ttSelecao.cod-ativid-fim     = entry(38,c-linha,";")
           ttSelecao.cod-tag-ini        = entry(39,c-linha,";")
           ttSelecao.cod-tag-fim        = entry(40,c-linha,";")
           ttSelecao.lCombutivel        = (entry(41,c-linha,";") = "yes")
           ttSelecao.lLubrific          = (entry(42,c-linha,";") = "yes")
           ttSelecao.lProprios          = (entry(43,c-linha,";") = "yes")
           ttSelecao.lTerceiros         = (entry(44,c-linha,";") = "yes")
           ttSelecao.lHabilita          = (entry(45,c-linha,";") = "yes")
           ttSelecao.lAtualiza          = (entry(46,c-linha,";") = "yes")
           ttSelecao.cb-moeda           = entry(47,c-linha,";")
           ttSelecao.classifica         = int(entry(48,c-linha,";"))
           ttSelecao.lAtivos            = (entry(49,c-linha,";") = "yes")
           ttSelecao.lInativos          = (entry(50,c-linha,";") = "yes")
           ttSelecao.lMotorizados       = (entry(51,c-linha,";") = "yes")
           ttSelecao.lNmotorizados      = (entry(52,c-linha,";") = "yes")
           ttSelecao.lTerc              = (entry(53,c-linha,";") = "yes")
           ttSelecao.lProprio           = (entry(54,c-linha,";") = "yes")
           ttSelecao.cod-Motorista-ini  = entry(55,c-linha,";")
           ttSelecao.cod-Motorista-fim  = entry(56,c-linha,";")
           ttSelecao.cod-emitente-ini   = int(entry(57,c-linha,";"))
           ttSelecao.cod-emitente-fim   = int(entry(58,c-linha,";"))
           ttSelecao.trajeto-ini        = (ENTRY(59,c-linha,";"))
           ttSelecao.trajeto-fim        = (ENTRY(60,c-linha,";")).
    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao.cod-unid-negoc-eqpto-ini = entry(61,c-linha,";")
                   ttSelecao.cod-unid-negoc-eqpto-fim = entry(62,c-linha,";")
                   ttSelecao.cod-unid-negoc-ficha-ini = entry(63,c-linha,";")
                   ttSelecao.cod-unid-negoc-ficha-fim = entry(64,c-linha,";")
                   ttSelecao.lBuscaMovtoEstoque = (entry(65,c-linha,";") = "yes").
        &ENDIF
    END.
    ELSE DO:
        ASSIGN ttSelecao.lBuscaMovtoEstoque = (entry(61,c-linha,";") = "yes").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTreeView wWindow 
PROCEDURE criaTreeView :
/*------------------------------------------------------------------------------
  Purpose:     criaTreeView
  Parameters:  <none>
  Notes:       Cria as linhas do tree-view
------------------------------------------------------------------------------*/
define variable iQtSeq   as integer initial 0 no-undo.
define variable cValor   as character         no-undo.
define variable cQtde    as character         no-undo.
define variable c-texto  as character         no-undo.

define buffer bfttDados for ttDados.

/** Limpa o tree-view **/
oTreeList:emptyTreeList().

assign i-cont = 0.
/** Verifica se existem vis‰es escolhidas **/
for last ttVisao no-lock:
    assign iQtSeq = ttVisao.sequencia.
end.
    if iQtSeq = 0 then return.
/** Label da Valor do Material **/
{utp/ut-liter.i "Valor"}
assign cValor = return-value.


{utp/ut-liter.i "Qtde"}
assign cQtde = return-value.

/** Busca os dados criados **/
for each  ttDados 
    where ttDados.sequencia < iQtSeq NO-LOCK
    by ttDados.cod-dimensao:

  /** Conta sequàncias de linhas **/ 
  assign i-cont = i-cont + 1.
  assign ttDados.seq-tree = i-cont.
  /** Inclui primeira linha **/
  if ttDados.sequencia = 1 then do:
        if ttDados.p-image = 10 then do:
            ASSIGN    c-texto =   STRING(ttDados.Codigo) + " - " + ttDados.Nivel  + " - " +  cQtde + " : " + STRING(ttDados.Quantidade,">>>,>>>,>>9.99") + STRING(ttDados.Un) + " - " +  cValor + " : " +  string(ttDados.Valor,">>>,>>>,>>>,>>9.99").
        END.
        ELSE DO:
            ASSIGN    c-texto =   STRING(ttDados.Codigo) + " - " + ttDados.Nivel.
        END.
        oTreeList:addNode(""                  , "i" + STRING(i-cont), c-texto).
        oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados.p-image).
        oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados))).

        IF  ttDados.r-rowid <>  ?   THEN
            oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados.r-rowid)).
  end.
  else do:
      /** Busca filhos da vis∆o escolhida **/
      find first bfttDados 
           where bfttDados.cod-dimensao = ttDados.cod-dimens-pai no-lock no-error.
      if avail bfttDados then do:
          /** Equipamento **/
          if ttDados.p-image = 5 then do:
              IF  ttSelecao.matrl-ini =  ttSelecao.matrl-fim THEN DO:
                  ASSIGN    c-texto =   STRING(ttDados.Codigo) + " - " +  cQtde + " : " + STRING(ttDados.Quantidade,">>>,>>>,>>9.99") + STRING(ttDados.Un) + " - " +  cValor + " : " +  STRING(ttDados.Valor,">>>,>>>,>>>,>>9.99").
              END. 
              ELSE DO:
                  if ttDados.sequencia >= iVisao  then do:
                    ASSIGN  c-texto =   STRING(ttDados.Codigo) + " - " +  cQtde + " : " + STRING(ttDados.Quantidade,">>>,>>>,>>9.99") + STRING(ttDados.Un) + " - " +  cValor + " : " +  STRING(ttDados.Valor,">>>,>>>,>>>,>>9.99").
                  END.
                  ELSE DO:
                    ASSIGN  c-texto =   STRING(ttDados.Codigo) + "  " + cValor + " : " +  STRING(ttDados.Valor,">>>,>>>,>>>,>>9.99").
                  END.
              END.
          end.
          /** Outros **/
          else do:
                if ttDados.sequencia >= iVisao  then do:
                    ASSIGN  c-texto =   STRING(ttDados.Codigo) + " - " + ttDados.Nivel + " - " + cQtde + " : " + STRING(ttDados.Quantidade,">>,>>>,>>9.99") + STRING(ttDados.Un) + " - " + cValor + " : " +  STRING(ttDados.Valor,">>>,>>>,>>>,>>9.99").
                end.
                else do:
                    ASSIGN  c-texto =   STRING(ttDados.Codigo) + " - " + ttDados.Nivel + "  " + cValor + " : " + STRING(ttDados.Valor,">>>,>>>,>>>,>>9.99").
                end.

          end.

          oTreeList:addNode("i" + string(bfttDados.seq-tree), "i" + STRING(i-cont), c-texto).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criattSelecao wWindow 
PROCEDURE criattSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


find moeda where
         moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
    assign cb-moeda  = '0 - ' + moeda.descricao.

create ttSelecao.
assign
   &IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.empresa-ini        = ""
       ttSelecao.empresa-fim        = "ZZZ"
   &ELSE
       ttSelecao.empresa-ini        = 0
       ttSelecao.empresa-fim        = 999
   &ENDIF
       ttSelecao.equipto-ini        = ""
       ttSelecao.equipto-fim        = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.grupo-ini          = ""
       ttSelecao.grupo-fim          = "ZZZZZZZZ"
       ttSelecao.modelo-ini         = ""
       ttSelecao.modelo-fim         = "ZZZZZZZZ"
    &IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.estab-ini          = ""
       ttSelecao.estab-fim          = "ZZZZZ"
       ttSelecao.estabeqpto-ini     = ""
       ttSelecao.estabeqpto-fim     = "ZZZZZ"
    &ELSE
       ttSelecao.estab-ini          = ""
       ttSelecao.estab-fim          = "ZZZ"
       ttSelecao.estabeqpto-ini     = ""
       ttSelecao.estabeqpto-fim     = "ZZZ"
    &ENDIF
       ttSelecao.hora-ini           = "00:00:000"
       ttSelecao.hora-fim           = "23:59:59"
       ttSelecao.docto-ini          = 0
       ttSelecao.docto-fim          = 999999999
       ttSelecao.posto-ini          = ""
       ttSelecao.posto-fim          = "ZZZZZZZZ"
       ttSelecao.bomba-ini          = ""
       ttSelecao.bomba-fim          = "ZZZZZZZZ"
       ttSelecao.matrl-ini          = ""        
       ttSelecao.matrl-fim          = "ZZZZZZZZ"
       ttSelecao.periodo-ini        = TODAY - 7
       ttSelecao.periodo-fim        = TODAY
       ttSelecao.item-ini           = ""        
       ttSelecao.item-fim           = "ZZZZZZZZ"
       ttSelecao.emitente-ini       = 0
       ttSelecao.emitente-fim       = 999999999
       ttSelecao.nota-ini           = ""
       ttSelecao.nota-fim           = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.evento-ini         = ""
       ttSelecao.evento-fim         = "ZZZZZZZZ"
       ttSelecao.ccusto-ini-item    = ""
       ttSelecao.ccusto-fim-item    = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.comptmento-ini     = ""
       ttSelecao.comptmento-fim     = "ZZZZZZZZ"
       ttSelecao.cod-ativid-ini     = ""
       ttSelecao.cod-ativid-fim     = "ZZZZZZZZ"
       ttSelecao.cod-tag-ini        = ""
       ttSelecao.cod-tag-fim        = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.lCombutivel        = yes
       ttSelecao.lLubrific          = yes
       ttSelecao.lProprios          = yes
       ttSelecao.lTerceiros         = yes
       ttSelecao.lHabilita          = no
       ttSelecao.lAtualiza          = no
       ttSelecao.cb-moeda           = cb-moeda
       ttSelecao.classifica         = 1
       ttSelecao.lAtivos            = yes
       ttSelecao.lInativos          = no
       ttSelecao.lMotorizados       = yes
       ttSelecao.lNmotorizados      = yes
       ttSelecao.lTerc              = yes
       ttSelecao.lProprio           = yes
       ttSelecao.lIntegrados        = yes
       ttSelecao.lNaoIntegrados     = yes
       ttSelecao.cod-motorista-ini  = ""
       ttSelecao.cod-Motorista-fim  = "ZZZZZZZZ"
       ttSelecao.cod-emitente-ini   = 0
       ttSelecao.cod-emitente-fim   = 999999999
       ttSelecao.trajeto-ini        = ""
       ttSelecao.trajeto-fim        = "ZZZZZZZZZZZZ"
    &IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.cod-unid-negoc-eqpto-ini = "":U
       ttSelecao.cod-unid-negoc-eqpto-fim = "ZZZ":U
       ttSelecao.cod-unid-negoc-ficha-ini = "":U
       ttSelecao.cod-unid-negoc-ficha-fim = "ZZZ":U
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-excel wWindow 
PROCEDURE pi-exporta-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Limpa temp-table Excel **/
EMPTY TEMP-TABLE tt-dados-ex.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN pnp/pn0609e.w (OUTPUT i-impressao,
                   OUTPUT l-ok).
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

/** A tela foi confirmada, ent∆o continua **/
IF l-ok THEN DO:
    ASSIGN i-col     = 1
           i-lin     = 1
           i-lin2    = 1
           c-colunas = "".

    /** Encontra n£mero total de colunas **/
    DO i-col = 1 TO brDetalhe:NUM-COLUMNS IN FRAME fPage0:
        ASSIGN hHandle = brDetalhe:GET-BROWSE-COLUMN(i-col).
        IF hHandle:VISIBLE THEN DO:
            ASSIGN c-colunas = c-colunas + hHandle:NAME.
            IF i-col <> brDetalhe:NUM-COLUMNS THEN
                ASSIGN c-colunas = c-colunas + ",".
        END.
        /** Guarda t°tulos das colunas **/
    END.

    FOR LAST ttVisao NO-LOCK:
        ASSIGN iVisao2 = ttVisao.sequencia - 1.
    END.

    /** Somente vis∆o selecionada **/
    IF i-impressao = 1 THEN DO:
        /** Guarda rowid do tree-view **/
        ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).

        /** Busca Registro **/
        CASE (ttSelecao.classifica):
            WHEN 1 THEN DO:
                FOR FIRST bfttDados
                    WHERE ROWID(bfttDados) = rRowid NO-LOCK:
                    RUN piExcelDados (INPUT bfttDados.cod-dimensao).
                END.
            END.
            WHEN 2 THEN DO:
                FOR FIRST bfttDados
                    WHERE ROWID(bfttDados) = rRowid NO-LOCK:
                    RUN piExcelDadosVal (INPUT bfttDados.cod-dimensao).
                END.
            END.
            WHEN 3 THEN DO:
                FOR FIRST bfttDados
                    WHERE ROWID(bfttDados) = rRowid NO-LOCK:
                    RUN piExcelDadosQtd (INPUT bfttDados.cod-dimensao).
                END.
            END.
        END CASE.
    END.
    /** Completo **/
    ELSE DO:
        CASE (ttSelecao.classifica):
            WHEN 1 THEN DO:
                FOR EACH  bfttDados
                    WHERE bfttDados.sequencia = 1 NO-LOCK:
                    RUN piExcelDados (INPUT bfttDados.cod-dimensao).
                END.
            END.
            WHEN 2 THEN DO:
                FOR EACH  bfttDados
                    WHERE bfttDados.sequencia = 1 NO-LOCK:
                    RUN piExcelDadosVal (INPUT bfttDados.cod-dimensao).
                END.
            END.
            WHEN 3 THEN DO:
                FOR EACH  bfttDados
                    WHERE bfttDados.sequencia = 1 NO-LOCK:
                    RUN piExcelDadosQtd (INPUT bfttDados.cod-dimensao).
                END.
            END.
        END CASE.
    END.

    /** Programa que gera o XLS **/
    RUN abp/ab9003.p(INPUT "ab0608":u,
                     INPUT TABLE tt-dados-ex).

    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    /** Posiciona o Tree-View no £ltimo lido **/
     if oTreeList:hasNode() then
        oTreeList:selectLine(oTreeList:currentCode) no-error.

END.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-txt wWindow 
PROCEDURE pi-exporta-txt :
/*------------------------------------------------------------------------------
  Purpose:     piTexto
  Parameters:  <none>
  Notes:       Exporta os dados da consulta para um arquivo texto
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

    /** Imprime Somente visao selecionada **/
    assign l-first = no.
    if i-impressao = 1 then do:
        /** Guarda rowid do tree-view **/
        ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        /** Busca Registro **/
        case (ttSelecao.classifica):
            when 1 then do:
                for first bfttDados
                    where rowid(bfttDados) = rRowid no-lock:
                    assign iVisao2 = bfttDados.sequencia.
                    run piTextoDados (input bfttDados.cod-dimensao).
                end.
            end.
            when 2 then do:
                for first bfttDados
                    where rowid(bfttDados) = rRowid no-lock:
                    assign iVisao2 = bfttDados.sequencia.
                    run piTextoDadosQtd (input bfttDados.cod-dimensao).
                end.
            end.
            when 3 then do:
                for first bfttDados
                    where rowid(bfttDados) = rRowid no-lock:
                    assign iVisao2 = bfttDados.sequencia.
                    run piTextoDadosVal(input bfttDados.cod-dimensao).
                end.
            end.
        end case.
    end.
    /** Imprime Todos **/
    else do:
        /** Guarda rowid do tree-view **/
        ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
        for last bfttDados
            where rowid(bfttDados) = rRowid no-lock:
            assign iVisao2 = bfttDados.sequencia.
        end.
        /** Busca Registro **/
        case (ttSelecao.classifica):
            when 1 then do:
                for each bfttDados
                    where bfttDados.sequencia = iVisao2 no-lock:
                    run piTextoDados (input bfttDados.cod-dimensao).
                end.
            end.
            when 2 then do:
                for each bfttDados
                    where bfttDados.sequencia = iVisao2 no-lock:
                    run piTextoDadosQtd (input bfttDados.cod-dimensao).
                end.
            end.   
            when 3 then do:
                for each bfttDados
                    where bfttDados.sequencia = iVisao2 no-lock:
                    run piTextoDadosVal (input bfttDados.cod-dimensao).
                end.
            end.
        end case.
    end.
    output close.

    /** Abertura do Arquivo **/
    RUN utp/ut-showreport.p (INPUT cCaminho).

    /** Posiciona o Tree-View no £ltimo lido **/
     if oTreeList:hasNode() then
        oTreeList:selectLine(oTreeList:currentCode) no-error.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piApontamento wWindow 
PROCEDURE piApontamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 if num-results("brDetalhe":U) > 0 then do:
         get current brDetalhe. 
         find mab-abastec-lubrific where mab-abastec-lubrific.num-docto = Int(ttdados.Codigo) NO-LOCK NO-ERROR.
         if  avail ttDados then do:
             ASSIGN gr-mab-abastec-lubrific = ttDados.r-rowid.
             {&window-name}:sensitive = no.
               run abp/ab0611.w.
             {&window-name}:sensitive = YES.



      end.  
 end. 
 ELSE DO:
      {&window-name}:sensitive = no.
       run abp/ab0611.w.
      {&window-name}:sensitive = YES.

 END.

RETURN "OK":U.

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
DEFINE VARIABLE hAcomp AS HANDLE NO-UNDO.

DEFINE VARIA d-data-ini-aux AS DATE NO-UNDO.

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run piCriaVisao in this-procedure.
end.

/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.

DEF VAR vDataHoraInvertidaIni AS DECIMAL FORMAT ">>>>>>>>>>>>" NO-UNDO.
DEF VAR vDataHoraInvertidafim AS DECIMAL FORMAT ">>>>>>>>>>>>" NO-UNDO.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}
assign iVisao = 0.
IF  ttSelecao.matrl-ini =  ttSelecao.matrl-fim THEN DO:
    ASSIGN lReal = YES.
END.
ELSE DO:
    for each ttVisao no-lock:
        if substring(ttVisao.dimensao,1,2)  = "10" OR
            substring(ttVisao.dimensao,1,2) = "11" then do:
           assign iVisao = ttVisao.sequencia.
           leave.
        end.
    end.
end.


IF  NOT ttSelecao.lBuscaMovtoEstoque THEN DO:
    run converteParaHoraInvertida (input string(ttselecao.periodo-ini,"99/99/9999"),
                                   input (SUBSTRING(ttselecao.hora-ini, 1,2) + 
                                          SUBSTRING(ttselecao.hora-ini, 4,2)),                               
                                   output vDataHoraInvertidaIni).
END.
ELSE DO:
    ASSIGN d-data-ini-aux = ttselecao.periodo-ini - 90.
    run converteParaHoraInvertida (input string(d-data-ini-aux,"99/99/9999"),
                                   input (SUBSTRING(ttselecao.hora-ini, 1,2) + 
                                          SUBSTRING(ttselecao.hora-ini, 4,2)),                               
                                   output vDataHoraInvertidaIni).
END.
run converteParaHoraInvertida (input string(ttselecao.periodo-fim,"99/99/9999"),
                               input (SUBSTRING(ttselecao.hora-FIM, 1,2) + 
                                      SUBSTRING(ttselecao.hora-FIM, 4,2)),                               
                               output vDataHoraInvertidafim).




/** Acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
{utp/ut-liter.i "Quantidade e Valor Combust/Lubr"}
RUN pi-inicializar IN hAcomp (trim(return-value)).

blk_ab0608:
DO on stop undo, return "NOK":U:
    for each mab-eqpto no-lock
        where mab-eqpto.ep-codigo     >= ttSelecao.empresa-ini
        and   mab-eqpto.ep-codigo     <= ttSelecao.empresa-fim
        and   mab-eqpto.cod-eqpto     >= ttSelecao.equipto-ini
        and   mab-eqpto.cod-eqpto     <= ttSelecao.equipto-fim
        and   mab-eqpto.cod-model     >= ttSelecao.modelo-ini
        and   mab-eqpto.cod-model     <= ttSelecao.modelo-fim
        and   mab-eqpto.cod-grp-eqpto >= ttSelecao.grupo-ini
        and   mab-eqpto.cod-grp-eqpto <= ttSelecao.grupo-fim
        and   mab-eqpto.cod-emitente  >= ttSelecao.cod-emitente-ini 
        and   mab-eqpto.cod-emitente  <= ttSelecao.cod-emitente-fim 
        and   ((mab-eqpto.idi-tip-propriet = 1 and ttSelecao.lProprio)        /** PrΩprios    **/
        or     (mab-eqpto.idi-tip-propriet = 2 and ttSelecao.lTerc))          /** Terceiros   **/
        and   ((mab-eqpto.dat-situacao     = ? and ttSelecao.lAtivos)         /** Ativos      **/
        or     (mab-eqpto.dat-situacao    <> ? and ttSelecao.lInativos))      /** Inativos    **/
        and   ((mab-eqpto.idi-tip-eqpto    = 1 and ttSelecao.lMotorizados)    /** Motorizados **/
        or     (mab-eqpto.idi-tip-eqpto    = 2 and ttSelecao.lNMotorizados)): /** Nío Motorizados **/

        /* ler somente equipamentos ativos no per°odo da seleá∆o */
        IF mab-eqpto.dat-situacao <> ? AND  mab-eqpto.dat-situacao < ttSelecao.periodo-ini THEN NEXT.

        /** Busca unidade do Modelo **/
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model un)
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.

        /** Acompanhamento **/
        {utp/ut-liter.i "Lendo Equipamento:"}
        RUN pi-Acompanhar IN hAcomp (RETURN-VALUE + " " + STRING(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto).

        /* IRM001380 - Contabilizaá∆o Item Abastecimento/Lubrificaá∆o */
        ASSIGN v-param-55 = FALSE.
        FOR FIRST mab-param
            WHERE mab-param.cdn-param = 55 AND mab-param.des-valor = "1":U NO-LOCK:
            ASSIGN v-param-55 = TRUE.
        END.

        for each  mab-abastec-lubrific
            where mab-abastec-lubrific.ep-codigo    = mab-eqpto.ep-codigo
            and   mab-abastec-lubrific.cod-eqpto    = mab-eqpto.cod-eqpto
            and   mab-abastec-lubrific.val-dat-hora-invrtda >= vDataHoraInvertidaini
            and   mab-abastec-lubrific.val-dat-hora-invrtda <= vDataHoraInvertidafim
            and   mab-abastec-lubrific.num-docto    >= ttSelecao.docto-ini
            and   mab-abastec-lubrific.num-docto    <= ttSelecao.docto-fim
            and   mab-abastec-lubrific.nr-nota-fis  >= ttSelecao.nota-ini 
            and   mab-abastec-lubrific.nr-nota-fis  <= ttSelecao.nota-fim 
            and   mab-abastec-lubrific.cod-ativid   >= ttSelecao.cod-ativid-ini
            and   mab-abastec-lubrific.cod-ativid   <= ttSelecao.cod-ativid-fim  
            AND   mab-abastec-lubrific.cod-matr     >= ttSelecao.cod-motorista-ini          
            AND   mab-abastec-lubrific.cod-matr     <= ttSelecao.cod-motorista-fim
            AND   mab-abastec-lubrific.cod-rota     >= ttSelecao.trajeto-ini
            AND   mab-abastec-lubrific.cod-rota     <= ttSelecao.trajeto-fim NO-LOCK:

            IF  NOT v-param-55 THEN
                IF mab-abastec-lubrific.cc-codigo < ttSelecao.ccusto-ini-item OR 
                   mab-abastec-lubrific.cc-codigo > ttSelecao.ccusto-fim-item THEN NEXT.
                   

            IF ttSelecao.lAtualiza = YES 
                     AND mab-abastec-lubrific.nr-nota-fis <> "" 
                     AND mab-abastec-lubrific.serie <> "" THEN NEXT.

            /** Valida Unidade de Negocio da ficha, caso impladada. **/
            &IF DEFINED(bf_mnt_ems206b) &THEN
                IF l-usa-unid-negoc THEN DO:
                    IF NOT(mab-abastec-lubrific.cod-unid-negoc >= ttSelecao.cod-unid-negoc-ficha-ini  AND 
                           mab-abastec-lubrific.cod-unid-negoc <= ttSelecao.cod-unid-negoc-ficha-fim) THEN NEXT.
                END.
            &ENDIF

            for last  mab-histor-ativid no-lock 
                where mab-histor-ativid.ep-codigo     = mab-abastec-lubrific.ep-codigo
                and   mab-histor-ativid.cod-eqpto     = mab-abastec-lubrific.cod-eqpto
                and   mab-histor-ativid.dat-cadastro <= mab-abastec-lubrific.dat-movto:
            end.
            if not avail mab-histor-ativid then do:
                for last  mab-histor-ativid no-lock 
                    where mab-histor-ativid.ep-codigo = mab-abastec-lubrific.ep-codigo
                    and   mab-histor-ativid.cod-eqpto = mab-abastec-lubrific.cod-eqpto.
                end.
                if not avail mab-histor-ativid then do:
                    assign cEstab    = mab-eqpto.cod-estabel
                           cGrpEqpto = mab-eqpto.cod-grp-eqpto
                           cTag      = mab-eqpto.cd-tag.

                    &IF DEFINED(bf_mnt_ems206b) &THEN
                        ASSIGN cUnidNegoc = mab-eqpto.cod-unid-negoc.
                    &ENDIF
                end.
                assign cEstab    = mab-histor-ativid.cod-estabel
                       cGrpEqpto = mab-histor-ativid.cod-grp-eqpto
                       cTag      = mab-histor-ativid.cd-tag.

                &IF DEFINED(bf_mnt_ems206b) &THEN
                    ASSIGN cUnidNegoc = mab-eqpto.cod-unid-negoc.
                &ENDIF
            end.
            else do:
                assign cEstab    = mab-histor-ativid.cod-estabel
                       cGrpEqpto = mab-histor-ativid.cod-grp-eqpto
                       cTag      = mab-histor-ativid.cd-tag.

                &IF DEFINED(bf_mnt_ems206b) &THEN
                    ASSIGN cUnidNegoc = mab-histor-ativid.cod-unid-negoc.
                &ENDIF
            end.
            if cTag      < ttSelecao.cod-tag-ini    or cTag      > ttSelecao.cod-tag-fim    then next.
            if cEstab    < ttSelecao.estabeqpto-ini or cEstab    > ttSelecao.estabeqpto-fim then next.
            if cGrpEqpto < ttSelecao.grupo-ini      or cGrpEqpto > ttSelecao.grupo-fim      then next.

            /** Valida Unidade de Negocio, caso impladada. **/
            &IF DEFINED(bf_mnt_ems206b) &THEN
                IF l-usa-unid-negoc THEN
                    IF cUnidNegoc < ttSelecao.cod-unid-negoc-eqpto-ini OR cUnidNegoc > ttSelecao.cod-unid-negoc-eqpto-fim THEN NEXT.
            &ENDIF

            ASSIGN cEPCodigo  = mab-abastec-lubrific.ep-codigo
                   cMotorista = mab-abastec-lubrific.cod-matr.

            IF NOT v-param-55 THEN
                ASSIGN cCCCodigo = mab-abastec-lubrific.cc-codigo.

            IF ttSelecao.lAtualiza = YES 
            AND mab-abastec-lubrific.nr-nota-fis <> "" 
            AND mab-abastec-lubrific.serie <> "" THEN NEXT.
            /** Ficha Integrada/N∆o Integrada **/
            if not(ttSelecao.lIntegrado)    and mab-abastec-lubrific.idi-integr = 2 then next.
            if not(ttSelecao.lNaoIntegrado) and mab-abastec-lubrific.idi-integr = 1 then next.

            /** Busca fichas de Abastecimentos **/
            if ttSelecao.lCombutivel = YES then do:
                assign deQuantidade   = 0
                       deValor        = 0
                       cTpMater       = ""
                       cItem          = ""
                       cCodBomba      = ""
                       cCodPosto      = ""
                       cEvento        = ""
                       cComptmento    = ""
                       cAtivid        = mab-abastec-lubrific.cod-ativid.

                for each mab-item-abastec fields(ep-codigo num-docto cod-posto cod-tip-mater it-codigo val-mater-1 val-mater-2 val-mater-3 val-quant cod-bomba nr-trans cod-ccusto)  
                    where mab-item-abastec.num-docto      = mab-abastec-lubrific.num-docto
                    and   mab-item-abastec.cod-tip-mater >= ttSelecao.matrl-ini 
                    and   mab-item-abastec.cod-tip-mater <= ttSelecao.matrl-fim 
                    and   mab-item-abastec.it-codigo     >= ttSelecao.item-ini
                    and   mab-item-abastec.it-codigo     <= ttSelecao.item-fim 
                    and   mab-item-abastec.cod-posto     >= ttSelecao.posto-ini
                    and   mab-item-abastec.cod-posto     <= ttSelecao.posto-fim no-lock,
                    FIRST mab-tip-mater FIELDS (cod-tip-mater un des-tip-mater)
                        WHERE mab-tip-mater.cod-tip-mater = mab-item-abastec.cod-tip-mater NO-LOCK:

                    IF  v-param-55 THEN
                        IF mab-item-abastec.cod-ccusto < ttSelecao.ccusto-ini-item OR
                           mab-item-abastec.cod-ccusto > ttSelecao.ccusto-fim-item THEN NEXT.

                    IF NOT AVAIL  mab-item-abastec  THEN NEXT.

                    ASSIGN cTpMater  = mab-tip-mater.cod-tip-mater
                           cItem     = mab-item-abastec.it-codigo
                           cCodBomba = mab-item-abastec.cod-bomba
                           cCodPosto = mab-item-abastec.cod-posto.
                    
                    IF v-param-55 THEN DO:
                        /*cCCCodigoItem*/
                        ASSIGN cCCCodigo  = mab-item-abastec.cod-ccusto.
                    END.
                      
                    /** Seleciona os Postos **/
                    if not avail mab-posto or mab-posto.cod-posto <> mab-item-abastec.cod-posto then do:
                        for first mab-posto fields(des-posto cod-posto cod-estabel cod-emitente idi-posto ep-codigo)  
                            where mab-posto.cod-posto = mab-item-abastec.cod-posto NO-LOCK:
                        END.
                    END.

                    IF NOT AVAIL mab-posto THEN NEXT.
                    

                    IF mab-posto.cod-estabel  < ttSelecao.estab-ini 
                    OR mab-posto.cod-estabel  > ttSelecao.estab-fim THEN NEXT.

                    IF mab-posto.idi-posto    = 1 and ttSelecao.lProprios  = FALSE THEN NEXT.  /** Posto Pr¢prios     **/
                    IF mab-posto.idi-posto    = 2 and ttSelecao.lTerceiros = FALSE THEN NEXT.  /** Posto de Terceiros **/

                    IF mab-posto.cod-emitente < ttSelecao.emitente-ini 
                    OR mab-posto.cod-emitente > ttSelecao.emitente-fim THEN NEXT.

                    IF mab-item-abastec.cod-bomba  < ttSelecao.bomba-ini 
                    OR mab-item-abastec.cod-bomba  > ttSelecao.bomba-fim THEN NEXT.

                    /** Guarda Quantidade e Valor **/
                    ASSIGN  deQuantidade = mab-item-abastec.val-quant
                            cEPCodigo    = mab-posto.ep-codigo.

                    IF substring(ttSelecao.cb-moeda,1,1) = "0":U THEN
                        assign deValor      = mab-item-abastec.val-mater-1.
                    IF substring(ttSelecao.cb-moeda,1,1) = "1":U THEN
                        assign deValor      = mab-item-abastec.val-mater-2.
                    IF substring(ttSelecao.cb-moeda,1,1) = "2":U THEN
                        assign deValor      = mab-item-abastec.val-mater-3.

                    /** Numero/Data Transaá∆o **/
                    assign iNr-trans = mab-item-abastec.nr-trans.
                    for first movto-estoq
                        where movto-estoq.nr-trans = iNr-trans no-lock:
                    end.
                    if avail movto-estoq then
                        IF  NOT ttSelecao.lBuscaMovtoEstoque THEN
                            assign dt-Trans = movto-estoq.dt-trans.
                        ELSE DO:
                            IF  movto-estoq.dt-trans >= ttSelecao.periodo-ini AND
                                movto-estoq.dt-trans <= ttSelecao.periodo-fim THEN
                                assign dt-Trans = movto-estoq.dt-trans.
                            ELSE NEXT.
                        END.
                    else 
                        assign dt-Trans = ?.



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
               end.
           end.

           /** Busca fichas de  lubrificaá∆o **/
           if ttSelecao.lLubrific  = YES then do:
               assign deQuantidade = 0
                      deValor      = 0
                      cTpMater     = ""
                      cItem        = ""
                      cCodBomba    = ""
                      cCodPosto    = ""
                      cEvento      = ""
                      cComptmento  = "".

               for each mab-item-lubrific fields(num-docto cod-tip-mater it-codigo val-mater-1 val-mater-2 val-mater-3 val-quant cod-evento cod-comptmento nr-trans cod-ccusto)  
                   where mab-item-lubrific.num-docto         = mab-abastec-lubrific.num-docto 
                   and   mab-item-lubrific.cod-tip-mater    >= ttSelecao.matrl-ini 
                   and   mab-item-lubrific.cod-tip-mater    <= ttSelecao.matrl-fim 
                   and   mab-item-lubrific.it-codigo        >= ttSelecao.item-ini
                   and   mab-item-lubrific.it-codigo        <= ttSelecao.item-fim 
                   and   mab-item-lubrific.cod-evento       >= ttSelecao.evento-ini 
                   and   mab-item-lubrific.cod-evento       <= ttSelecao.evento-fim 
                   AND   mab-item-lubrific.cod-comptmento   >= ttSelecao.comptmento-ini
                   AND   mab-item-lubrific.cod-comptmento   <= ttSelecao.comptmento-fim no-lock,

                   FIRST mab-tip-mater FIELDS (cod-tip-mater un des-tip-mater)
                       WHERE mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater NO-LOCK:

                   IF v-param-55 THEN
                      IF mab-item-lubrific.cod-ccusto < ttSelecao.ccusto-ini-item OR
                         mab-item-lubrific.cod-ccusto > ttSelecao.ccusto-fim-item THEN NEXT.

                   IF NOT AVAIL mab-item-lubrific  THEN NEXT.

                   ASSIGN cTpMater    = mab-tip-mater.cod-tip-mater
                          cItem       = mab-item-lubrific.it-codigo
                          cCodPosto   = mab-abastec-lubrific.cod-posto
                          cEvento     = mab-item-lubrific.cod-evento
                          cComptmento = mab-item-lubrific.cod-comptmento.

                    IF v-param-55 THEN
                        ASSIGN cCCCodigo  = mab-item-lubrific.cod-ccusto.

                   /** Seleciona os Postos **/
                   if not avail mab-posto or mab-posto.cod-posto <> mab-abastec-lubrific.cod-posto then do:
                       for first mab-posto fields(ep-codigo des-posto cod-posto cod-estabel cod-emitente idi-posto)  
                           where mab-posto.cod-posto = mab-abastec-lubrific.cod-posto NO-LOCK:
                       end.
                   end.

                   IF NOT AVAIL mab-posto THEN NEXT.

                   IF mab-posto.cod-posto    < ttSelecao.posto-ini 
                   OR mab-posto.cod-posto    > ttSelecao.posto-fim THEN NEXT.
                   IF mab-posto.cod-estabel  < ttSelecao.estab-ini 
                   OR mab-posto.cod-estabel  > ttSelecao.estab-fim THEN NEXT.
                   IF mab-posto.idi-posto    = 1 and ttSelecao.lProprios  = FALSE THEN NEXT.  /** Posto Pr¢prios     **/
                   IF mab-posto.idi-posto    = 2 and ttSelecao.lTerceiros = FALSE THEN NEXT.  /** Posto de Terceiros **/
                   IF mab-posto.cod-emitente < ttSelecao.emitente-ini 
                   OR mab-posto.cod-emitente > ttSelecao.emitente-fim THEN NEXT.

                   /** Guarda Quantidade e Valor **/
                   assign deQuantidade = mab-item-lubrific.val-quant
                          cEPCodigo    = mab-posto.ep-codigo.


                   IF substring(ttSelecao.cb-moeda,1,1) = "0":U THEN
                       assign deValor      = mab-item-lubrific.val-mater-1.

                   IF substring(ttSelecao.cb-moeda,1,1) = "1":U THEN
                       assign deValor      = mab-item-lubrific.val-mater-2.
                   IF substring(ttSelecao.cb-moeda,1,1) = "2":U THEN
                       assign deValor      = mab-item-lubrific.val-mater-3.

                   /** Numero/Data Transaá∆o **/
                   assign iNr-trans = mab-item-lubrific.nr-trans.
                   for first movto-estoq
                       where movto-estoq.nr-trans = iNr-trans no-lock:
                   end.
                   if avail movto-estoq then
                       IF  NOT ttSelecao.lBuscaMovtoEstoque THEN
                           assign dt-Trans = movto-estoq.dt-trans.
                       ELSE DO:
                           IF  movto-estoq.dt-trans >= ttSelecao.periodo-ini AND
                               movto-estoq.dt-trans <= ttSelecao.periodo-fim THEN
                               assign dt-Trans = movto-estoq.dt-trans.
                           ELSE NEXT.
                       END.
                   else 
                       assign dt-Trans = ?.

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
                   END.
               END.
           END.
        end. /** mab-abastec-lubrific **/
    END.
END.

/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

RUN pi-Finalizar IN hAcomp.

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
          ttDados.sequencia      = ttVisao.sequencia    /** Sequància dos dados **/
          ttDados.p-image        = iImage               /** N£mero da imagem do registro **/
          ttDados.r-rowid        = rRowid               /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai = cCodPai.             /** C¢digo do pai do registro **/

    /** C¢digo Original do registro **/
    if iImage = 6 OR iImage = 7 then 
        ASSIGN ttDados.Codigo = substring(vDescricao,1,16).
    ELSE DO:
        IF iImage = 14 THEN DO:
            ASSIGN ttDados.codigo = SUBSTRING(vCodigo,5,2) + "/" + SUBSTRING(vCodigo,1,4).
        END.
        ELSE
            ASSIGN ttDados.Codigo = vCodigo.
    END.

    /** Descriá∆o do c¢digo **/
    if iImage = 6 OR iImage = 7 OR iImage = 9 OR iImage = 15 then
        ASSIGN ttDados.Nivel = substring(vDescricao,1,16).
    else 
        ASSIGN ttDados.Nivel = vDescricao.

    ASSIGN ttDados.desc-dimensao  = ttDados.Nivel.

    IF AVAIL mab-abastec-lubrific AND iImage = 16 THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {frinc/i01fr055.i 04 mab-abastec-lubrific.idi-integr}.
            run utp/ut-liter.p (input replace(trim(cauxtraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  ttDados.integracao = RETURN-VALUE.
        &else
            ASSIGN ttDados.integracao = {frinc/i01fr055.i 04 mab-abastec-lubrific.idi-integr}.
        &endif
        ASSIGN ttdados.data     = mab-abastec-lubrific.dat-movto
               ttdados.hora     = mab-abastec-lubrific.hra-inicial
               ttdados.contador = mab-abastec-lubrific.val-hodom-horim
               ttdados.nr-trans = iNr-trans
               ttdados.dt-trans = dt-trans.
    END.                                              
end.

assign cCodPai = ttDados.cod-dimensao.
      ASSIGN  ttDados.Valor       = ttDados.Valor  + deValor.    /** Valor do Material **/


if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.



  /*IF  lReal THEN DO:                             /*Somente se material inicial e final forem iguais*/*/
         assign ttDados.Quantidade      = ttDados.Quantidade + deQuantidade.                         
  /*END.
  ELSE DO:

           assign ttDados.Quantidade    = ttDados.Quantidade.
  END.*/

    /** Busca unidade do Material **/
    if not avail mab-tip-mater or mab-tip-mater.cod-tip-mater <> cTpMater then do:
        for first mab-tip-mater fields(un cod-tip-mater des-tip-mater)
            where mab-tip-mater.cod-tip-mater = cTpMater no-lock:
        end.
    end.
      if avail mab-tip-mater then
        assign ttDados.Un = mab-tip-mater.un
               ttDados.tpMater = mab-tip-mater.des-tip-mater.

return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsumo wWindow 
PROCEDURE piConsumo :
/*------------------------------------------------------------------------------
  Purpose:     piEqpto
  Parameters:  <none>
  Notes:     
------------------------------------------------------------------------------*/
define variable hEqpto as handle    no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define variable iEmp    LIKE empresa.ep-codigo no-undo.
&ELSE
define variable iEmp    as integer   no-undo.
&ENDIF
define variable cEqpto  as character no-undo.

if INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")) = 5 then do:
    /** Guarda rowid do tree-view **/
    ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
    for first mab-eqpto
        where rowid(mab-eqpto) = rRowid no-lock:
        assign iEmp   = mab-eqpto.ep-codigo
               cEqpto = mab-eqpto.cod-eqpto.

        create ttSelecao2.                                       
        assign ttSelecao2.empresa-ini       =  mab-eqpto.ep-codigo
               ttSelecao2.empresa-fim       =  mab-eqpto.ep-codigo
               ttSelecao2.equipto-ini       =  mab-eqpto.cod-eqpto
               ttSelecao2.equipto-fim       =  mab-eqpto.cod-eqpto
               ttSelecao2.grupo-ini         =  ttSelecao.grupo-ini
               ttSelecao2.grupo-fim         =  ttSelecao.grupo-fim
               ttSelecao2.modelo-ini        =  ttSelecao.modelo-ini
               ttSelecao2.modelo-fim        =  ttSelecao.modelo-fim
               ttSelecao2.estab-ini         =  ttSelecao.estab-ini
               ttSelecao2.estab-fim         =  ttSelecao.estab-fim
               ttSelecao2.tag-ini           = ""
               ttSelecao2.tag-fim           = "ZZZZZZZZZZZZZZZZ"
               ttSelecao2.estrut-ini        = ""
               ttSelecao2.estrut-fim        = "ZZZZZZZZ"
               ttSelecao2.cc-cod-eqpto-ini  = ""
               ttSelecao2.cc-cod-eqpto-fim  = "ZZZZZZZZ"
               ttSelecao2.cc-cod-docto-ini  = ""
               ttSelecao2.cc-cod-docto-fim  = "ZZZZZZZZ"
               ttSelecao2.sit-ini           = ""
               ttSelecao2.sit-fim           = "ZZZZZZZZ"
               ttSelecao2.atividade-ini     = ""
               ttSelecao2.atividade-fim     = "ZZZZZZZZ"
               ttSelecao2.periodo-ini       =  ttSelecao.periodo-ini
               ttSelecao2.periodo-fim       =  ttSelecao.periodo-fim
               ttSelecao2.trajeto-ini       = ""
               ttSelecao2.trajeto-fim       = "ZZZZZZZZ"
               ttSelecao2.lAtivos           = ttSelecao.lAtivos
               ttSelecao2.lProprios         = ttSelecao.lProprios
               ttSelecao2.lInativos         = ttSelecao.lInativos
               ttSelecao2.lTerceiros        = ttSelecao.lTerceiros
               ttSelecao2.lOK               = yes
               ttSelecao2.lIrregular        = yes
               ttSelecao2.lDesperdicio      = no
               ttSelecao2.classificacao     = 1
               ttSelecao2.cod-emitente-ini  = 0
               ttSelecao2.cod-emitente-fim  = 999999999.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao2.cod-unid-negoc-ini = ttSelecao.cod-unid-negoc-eqpto-ini
                   ttSelecao2.cod-unid-negoc-fim = ttSelecao.cod-unid-negoc-eqpto-fim.
        &ENDIF
    end.
end.

else do:
    get current brDetalhe no-lock.
    for first mab-eqpto
        where rowid(mab-eqpto) = ttDados.r-rowid no-lock:
        assign iEmp   = mab-eqpto.ep-codigo
               cEqpto = mab-eqpto.cod-eqpto.

        create ttSelecao2.
        assign ttSelecao2.empresa-ini      =  mab-eqpto.ep-codigo
               ttSelecao2.empresa-fim      =  mab-eqpto.ep-codigo
               ttSelecao2.equipto-ini      =  mab-eqpto.cod-eqpto
               ttSelecao2.equipto-fim      =  mab-eqpto.cod-eqpto
               ttSelecao2.grupo-ini        =  ttSelecao.grupo-ini
               ttSelecao2.grupo-fim        =  ttSelecao.grupo-fim
               ttSelecao2.modelo-ini       =  ttSelecao.modelo-ini
               ttSelecao2.modelo-fim       =  ttSelecao.modelo-fim
               ttSelecao2.estab-ini        =  ttSelecao.estab-ini
               ttSelecao2.estab-fim        =  ttSelecao.estab-fim
               ttSelecao2.tag-ini          = ""
               ttSelecao2.tag-fim          = "ZZZZZZZZZZZZZZZZ"
               ttSelecao2.estrut-ini       = ""
               ttSelecao2.estrut-fim       = "ZZZZZZZZ"
               ttSelecao2.cc-cod-eqpto-ini = ""
               ttSelecao2.cc-cod-eqpto-fim = "ZZZZZZZZ"
               ttSelecao2.cc-cod-docto-ini = ""
               ttSelecao2.cc-cod-docto-fim = "ZZZZZZZZ"
               ttSelecao2.sit-ini          = ""
               ttSelecao2.sit-fim          = "ZZZZZZZZ"
               ttSelecao2.atividade-ini    = ""
               ttSelecao2.atividade-fim    = "ZZZZZZZZ"
               ttSelecao2.periodo-ini      =  ttSelecao.periodo-ini
               ttSelecao2.periodo-fim      =  ttSelecao.periodo-fim
               ttSelecao2.trajeto-ini      = ""
               ttSelecao2.trajeto-fim      = "ZZZZZZZZ"
               ttSelecao2.lAtivos          = ttSelecao.lAtivos   
               ttSelecao2.lProprios        = ttSelecao.lProprios 
               ttSelecao2.lInativos        = ttSelecao.lInativos 
               ttSelecao2.lTerceiros       = ttSelecao.lTerceiros
               ttSelecao2.lOK              = yes
               ttSelecao2.lIrregular       = yes
               ttSelecao2.lDesperdicio     = no
               ttSelecao2.classificacao    = 1
               ttSelecao2.tag-ini          = ""
               ttSelecao2.tag-fim          = "ZZZZZZZZ"
               ttSelecao2.cod-emitente-ini = 0
               ttSelecao2.cod-emitente-fim = 999999999.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao2.cod-unid-negoc-ini = ttSelecao.cod-unid-negoc-eqpto-ini
                   ttSelecao2.cod-unid-negoc-fim = ttSelecao.cod-unid-negoc-eqpto-fim.
        &ENDIF
    end.
end.
&IF "{&mguni_version}" >= "2.071" &THEN
if iEmp = "" or cEqpto = ""  then return "NOK":U.
&ELSE
if iEmp = 0 or cEqpto = ""  then return "NOK":U.
&ENDIF
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus o de filho ---*/
Run abp/ab0609.w persistent set heqpto.

/* alterado por Valdir (tech264) novo m˝todo de teste do valid-handle */
IF VALID-HANDLE(hEqpto) AND
   hEqpto:Type = "PROCEDURE":U AND
   hEqpto:FILE-NAME = "abp/ab0609.w":U THEN DO:
   /*--- Inicializa programa de inclus o de filho ---*/
   Run initializeInterface IN hEqpto.
   run setaEquipamento in hEqpto (input TABLE ttSelecao2).
END.

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
wait-for "CLOSE":U of hEqpto.
assign {&window-name}:sensitive = yes.

if valid-handle(hEqpto) then
    delete procedure hEqpto.

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
assign ttVisao.dimensao  = '02 ' + fnLabels(2)
       ttVisao.sequencia = 1.
create ttVisao.
assign ttVisao.dimensao  = '08 ' + fnLabels(8)
       ttVisao.sequencia = 2.
create ttVisao.
assign ttVisao.dimensao  = '10 ' + fnLabels(10)
       ttVisao.sequencia = 3.
create ttVisao.
assign ttVisao.dimensao  = '04 ' + fnLabels(4)
       ttVisao.sequencia = 4.
create ttVisao.
assign ttVisao.dimensao  = '05 ' + fnLabels(5)
       ttVisao.sequencia = 5.

IF  ttSelecao.lBuscaMovtoEstoque THEN DO:
    create ttVisao.
    assign ttVisao.dimensao  = '23 ' + fnLabels(23)
           ttVisao.sequencia = 6.

    create ttVisao.
    assign ttVisao.dimensao  = '16 ' + fnLabels(16)
           ttVisao.sequencia = 7.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEqpto wWindow 
PROCEDURE piEqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define variable rRowid     as rowid     no-undo.
  if INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")) = 5 then do:
      /** Guarda rowid do tree-view **/
      ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
      for first mab-eqpto
          where rowid(mab-eqpto) = rRowid no-lock:
          ASSIGN gr-mab-eqpto  = rRowid.
          {&window-name}:sensitive = no.
             run abp/ab0602.w.
          {&window-name}:sensitive = YES.
      end.
  end.
  else do:
      get current brDetalhe no-lock.
      for first mab-eqpto
          where rowid(mab-eqpto) = ttDados.r-rowid no-lock:
          ASSIGN gr-mab-eqpto  = ttDados.r-rowid.
          {&window-name}:sensitive = no.
             run abp/ab0602.w.
          {&window-name}:sensitive = YES.
      end.
  end.

RETURN "OK":U.            
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
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-col-aux AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPai      AS CHARACTER NO-UNDO.

ASSIGN cPai = "".

FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK:

    

    /** Verifica se existem n°veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piExcelDados (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            /** Imprime os cabeáalhos **/
            RUN piExcelVisao (INPUT ROWID(ttDados),
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai  = ttDados.cod-dimens-pai
                   i-lin = i-lin2.
        END.

        ASSIGN i-col-aux = 1.
        /** In°cio contador de colunas do Browse**/
        DO i-col = 1 TO brDetalhe:NUM-COLUMNS IN FRAME fPage0:
            hHandle2 = brDetalhe:GET-BROWSE-COLUMN(i-col).
            IF hHandle2:VISIBLE THEN DO:
                /** Contador para linhas **/
                IF i-lin = i-lin2 THEN DO:
                    CREATE tt-dados-ex.
                    ASSIGN tt-dados-ex.celula-coluna        = i-col-aux
                           tt-dados-ex.celula-linha         = i-lin
                           tt-dados-ex.celula-cor-interior  = 10
                           tt-dados-ex.celula-fonte-cor     = 19
                           tt-dados-ex.celula-fonte-negrito = YES.
                    ASSIGN tt-dados-ex.celula-valor         = IF i-col = 1
                                                            THEN fnLabels(ttDados.p-image)
                                                            ELSE fnBrowse(ENTRY(i-col,c-colunas),1).
                END.

                /** Impress∆o da primeira linha de dados **/
                CREATE tt-dados-ex.
                ASSIGN tt-dados-ex.celula-coluna = i-col-aux
                       tt-dados-ex.celula-linha  = i-lin + 1.
                ASSIGN tt-dados-ex.celula-valor  = fnBrowse(ENTRY(i-col,c-colunas),2).
                IF ENTRY(i-col,c-colunas) = "Codigo":U OR ENTRY(i-col,c-colunas) = "Hora":U THEN
                    assign tt-dados-ex.celula-formato = "@":U.
            END.
            ELSE DO:
                ASSIGN i-col-aux = i-col-aux - 1.
            END.
            ASSIGN i-col-aux = i-col-aux + 1.
        END. /** Colunas **/
        ASSIGN i-lin  = i-lin + 1
               i-lin2 = i-lin + 2.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelDadosQtd wWindow 
PROCEDURE piExcelDadosQtd :
/*------------------------------------------------------------------------------
  Purpose:     piExcelDadosQtd
  Parameters:  entrada pDimensao = Dimensao lida
  Notes:       Impress∆o dos dados em excel
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-col-aux AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPai      AS CHARACTER  NO-UNDO.

ASSIGN cPai = "".

FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK USE-INDEX quantidade:

    /** Verifica se existem n°veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piExcelDadosQtd (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            /** Imprime os cabeáalhos **/
            RUN piExcelVisao (INPUT ROWID(ttDados),
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai  = ttDados.cod-dimens-pai
                   i-lin = i-lin2.
        END.

        ASSIGN i-col-aux = 1.
        /** In°cio contador de colunas do Browse**/
        DO i-col = 1 TO brDetalhe:NUM-COLUMNS IN FRAME fPage0:
            hHandle2 = brDetalhe:GET-BROWSE-COLUMN(i-col).
            IF hHandle2:VISIBLE THEN DO:
                /** Contador para linhas **/
                IF i-lin = i-lin2 THEN DO:
                    CREATE tt-dados-ex.
                    ASSIGN tt-dados-ex.celula-coluna        = i-col-aux
                           tt-dados-ex.celula-linha         = i-lin
                           tt-dados-ex.celula-cor-interior  = 10
                           tt-dados-ex.celula-fonte-cor     = 19
                           tt-dados-ex.celula-fonte-negrito = YES.
                    ASSIGN tt-dados-ex.celula-valor         = IF i-col = 1
                                                            THEN fnLabels(ttDados.p-image)
                                                            ELSE fnBrowse(ENTRY(i-col,c-colunas),1).
                END.

                /** Impress∆o da primeira linha de dados **/
                CREATE tt-dados-ex.
                ASSIGN tt-dados-ex.celula-coluna = i-col-aux
                       tt-dados-ex.celula-linha  = i-lin + 1.
                ASSIGN tt-dados-ex.celula-valor  = fnBrowse(ENTRY(i-col,c-colunas),2).
                IF ENTRY(i-col,c-colunas) = "Codigo":U OR ENTRY(i-col,c-colunas) = "Hora":U THEN
                    assign tt-dados-ex.celula-formato = "@":U.
            END.
            ELSE DO:
                ASSIGN i-col-aux = i-col-aux - 1.
            END.
            ASSIGN i-col-aux = i-col-aux + 1.
        END. /** Colunas **/    
        ASSIGN i-lin  = i-lin + 1
               i-lin2 = i-lin + 2.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelDadosVal wWindow 
PROCEDURE piExcelDadosVal :
/*------------------------------------------------------------------------------
  Purpose:     piExcelDadosVal
  Parameters:  entrada pDimensao = Dimensao lida
  Notes:       Impress∆o dos dados em excel
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-col-aux AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPai      AS CHARACTER  NO-UNDO.

ASSIGN cPai = "".

FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK USE-INDEX valor:

    /** Verifica se existem n°veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piExcelDadosVal (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            /** Imprime os cabeáalhos **/
            RUN piExcelVisao (INPUT ROWID(ttDados),         
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai  = ttDados.cod-dimens-pai
                   i-lin = i-lin2.
        END.

        ASSIGN i-col-aux = 1.
        /** In°cio contador de colunas do Browse**/
        DO i-col = 1 TO brDetalhe:NUM-COLUMNS IN FRAME fPage0:
            hHandle2 = brDetalhe:GET-BROWSE-COLUMN(i-col).
            IF hHandle2:VISIBLE THEN DO:
                /** Contador para linhas **/
                IF i-lin = i-lin2 THEN DO:
                    CREATE tt-dados-ex.
                    ASSIGN tt-dados-ex.celula-coluna        = i-col-aux
                           tt-dados-ex.celula-linha         = i-lin
                           tt-dados-ex.celula-cor-interior  = 10
                           tt-dados-ex.celula-fonte-cor     = 19
                           tt-dados-ex.celula-fonte-negrito = YES.
                    ASSIGN tt-dados-ex.celula-valor         = IF i-col = 1
                                                            THEN fnLabels(ttDados.p-image)
                                                            ELSE fnBrowse(ENTRY(i-col,c-colunas),1).
                END.

                /** Impress∆o da primeira linha de dados **/
                CREATE tt-dados-ex.
                ASSIGN tt-dados-ex.celula-coluna = i-col-aux
                       tt-dados-ex.celula-linha  = i-lin + 1.
                ASSIGN tt-dados-ex.celula-valor  = fnBrowse(ENTRY(i-col,c-colunas),2).
                IF ENTRY(i-col,c-colunas) = "Codigo":U OR ENTRY(i-col,c-colunas) = "Hora":U THEN
                    assign tt-dados-ex.celula-formato = "@":U.
            END.
            ELSE DO:
                ASSIGN i-col-aux = i-col-aux - 1.
            END.
            ASSIGN i-col-aux = i-col-aux + 1.
        END. /** Colunas **/
        ASSIGN i-lin  = i-lin + 1
               i-lin2 = i-lin + 2.
    END.
END.

RETURN "OK":U.
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
DEFINE INPUT PARAMETER rRow    AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER cCodPai AS CHARACTER NO-UNDO.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
IF CAN-FIND(FIRST bfttDados2
            WHERE bfttDados2.cod-dimensao = cCodPai NO-LOCK) THEN DO:
    FOR EACH bfttDados2
        WHERE bfttDados2.cod-dimensao = cCodPai NO-LOCK:
        RUN piExcelVisao (INPUT ROWID(bfttDados2),
                          INPUT bfttDados2.cod-dimens-pai).
    END.
END.

FOR FIRST bfttDados2
    WHERE ROWID(bfttDados2) = rRow NO-LOCK:
END.
IF AVAIL bfttDados2 AND bfttDados2.sequencia <= iVisao2 THEN DO:
    {abp/ab0608.i2 bfttDados2.p-image}
    CREATE tt-dados-ex.
    ASSIGN tt-dados-ex.celula-coluna        = 1
           tt-dados-ex.celula-linha         = i-lin2
           tt-dados-ex.celula-cor-interior  = 27
           tt-dados-ex.celula-fonte-cor     = 1
           tt-dados-ex.celula-fonte-negrito = YES
           tt-dados-ex.celula-formato       = "@":U
           tt-dados-ex.celula-valor         = TRIM(RETURN-VALUE) + ":" +  bfttDados2.Codigo + "-" + bfttDados2.nivel
           i-lin2                           = i-lin2 + 1.
END.

RETURN "OK":U.
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

if oTreeList:hasNode() then do:
    /** Guarda rowid do tree-view **/
    ASSIGN  rRowid =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
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
        run abp/ab0608d.w (input table ttdados,
                           input iSequencia,
                           input cDimensao,
                           input ttSelecao.classifica).
        assign {&window-name}:sensitive = yes.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNotaFiscal wWindow 
PROCEDURE piNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lOK-1 AS LOGICAL  INITIAL NO  NO-unDO.
DEFINE VARIABLE lOK-2 AS LOGICAL  INITIAL NO  NO-unDO.

IF ttSelecao.lProprios        = NO
   AND ttSelecao.lTerceiros   = YES THEN DO:
     ASSIGN lOK-1 = YES.

    IF ttSelecao.emitente-ini = ttSelecao.emitente-fim 
       AND ttSelecao.emitente-ini <> 0 
       AND ttSelecao.emitente-fim <> 0   THEN DO:
       ASSIGN lOK-2 = YES.

       DEFINE VARIABLE cNota  LIKE  mab-abastec-lubrific.nr-nota-fis  NO-unDO.
       DEFINE VARIABLE cSerie LIKE  mab-abastec-lubrific.serie        NO-unDO.
       DEFINE VARIABLE dValor LIKE  mab-item-abastec.val-mater-1      NO-unDO.
         assign {&window-name}:sensitive = no.
             run abp/ab0608g.w (input-output cnota,
                                INPUT-OUTPUT cSerie,
                                INPUT-OUTPUT dValor,
                                OUTPUT l-ok).
         assign {&window-name}:sensitive = yes.
         IF l-ok  THEN DO:
             run atualizaNota in THIS-PROCEDURE (INPUT cNota,  
                                                 INPUT cSerie, 
                                                 INPUT dValor).

         END.
         ELSE 
             RETURN "NOK":U.





    END.
    if not(lOK-2) then do:
       run utp/ut-msgs.p (input "show":u,
                           input 28651,
                           input "").
        return no-apply.
    end.



END.
 if not(lOK-1) then do:
     run utp/ut-msgs.p (input "show":u,
                           input 28650,
                           input "").
        return no-apply.
   end.

RETURN "OK":U.
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
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE VARIABLE cPai     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTamCab  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTamReg  AS CHARACTER NO-UNDO.

ASSIGN cPai = "".


FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK:
    /** Verifica se existem n≠veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piTextoDados (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            ASSIGN cDescPai  = "".
            RUN piTextoVisao (INPUT ROWID(ttDados),
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai       = ttDados.cod-dimens-pai.

        END.

        /** Imprime cabeáalho se parametrizado **/
        IF lCabecalho AND l-first = NO THEN DO:
            IF ttDados.p-image = 16 THEN DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador + 
                       fnBrowse("Integraá∆o",1)           + cDelimitador +
                       fnBrowse("Data",1)                 + cDelimitador +
                       fnBrowse("Hora",1)                 + cDelimitador +
                       fnBrowse("Contador",1)             + cDelimitador +
                       fnBrowse("nr-trans",1)             + cDelimitador +
                       fnBrowse("dt-trans",1)))) + ")".
                
                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)                + cDelimitador + 
                          fnBrowse("Quantidade",1)           + cDelimitador + 
                          fnBrowse("Un",1)                   + cDelimitador + 
                          fnBrowse("Valor",1)                + cDelimitador +
                          SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador +
                          fnBrowse("Integraá∆o",1)           + cDelimitador +
                          fnBrowse("Data",1)                 + cDelimitador +
                          fnBrowse("Hora",1)                 + cDelimitador +
                          fnBrowse("Contador",1)             + cDelimitador +
                          fnBrowse("nr-trans",1)             + cDelimitador +
                          fnBrowse("dt-trans",1))) FORMAT cTamCab at 01.
            END.
            ELSE DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20)))) + ")".

                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)      + cDelimitador + 
                          fnBrowse("Quantidade",1) + cDelimitador + 
                          fnBrowse("Un",1)         + cDelimitador + 
                          fnBrowse("Valor",1)      + cDelimitador + 
                          SUBSTRING(ttSelecao.cb-moeda,4,20))) FORMAT cTamCab AT 01.
            END.
            ASSIGN l-first = YES.
        END.
    
        IF ttDados.p-image = 16 THEN DO:
            ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cDescPai)  +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                   ttDados.integracao                            + cDelimitador + 
                   STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                   STRING(ttDados.hora, "99:99:99")              + cDelimitador +
                   STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                   STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador +
                   IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U)) + ")". 
            
            PUT (TRIM(cDescPai)  +  
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                 ttDados.integracao                            + cDelimitador + 
                 STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                 STRING(ttDados.hora, "99:99:99")              + cDelimitador + 
                 STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                 STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador + 
                 IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U FORMAT cTamCab AT 01.
        END.
        ELSE DO:
            ASSIGN cTamReg = "x(" + STRING(LENGTH(TRIM(cDescPai) +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )))         + ")".

            PUT (TRIM(cDescPai) +
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )) FORMAT cTamReg AT 01.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoDadosQtd wWindow 
PROCEDURE piTextoDadosQtd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE variable cPai    AS CHARACTER NO-UNDO.
DEFINE variable cTamCab AS CHARACTER NO-UNDO.
DEFINE variable cTamReg AS CHARACTER NO-UNDO.

ASSIGN cPai = "".

FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK USE-INDEX quantidade:

    /** Verifica se existem n≠veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piTextoDadosQtd (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            ASSIGN cDescPai  = "".
            RUN piTextoVisao (INPUT ROWID(ttDados),
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai       = ttDados.cod-dimens-pai.
        END.

        /** Imprime cabeáalho se parametrizado **/
        IF lCabecalho AND l-first = NO THEN DO:
            IF ttDados.p-image = 16 THEN DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador + 
                       fnBrowse("Integraá∆o",1)           + cDelimitador +
                       fnBrowse("Data",1)                 + cDelimitador +
                       fnBrowse("Hora",1)                 + cDelimitador +
                       fnBrowse("Contador",1)             + cDelimitador +
                       fnBrowse("nr-trans",1)             + cDelimitador +
                       fnBrowse("dt-trans",1)))) + ")".
                
                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)                + cDelimitador + 
                          fnBrowse("Quantidade",1)           + cDelimitador + 
                          fnBrowse("Un",1)                   + cDelimitador + 
                          fnBrowse("Valor",1)                + cDelimitador +
                          SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador +
                          fnBrowse("Integraá∆o",1)           + cDelimitador +
                          fnBrowse("Data",1)                 + cDelimitador +
                          fnBrowse("Hora",1)                 + cDelimitador +
                          fnBrowse("Contador",1)             + cDelimitador +
                          fnBrowse("nr-trans",1)             + cDelimitador +
                          fnBrowse("dt-trans",1))) FORMAT cTamCab at 01.
            END.
            ELSE DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20)))) + ")".

                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)      + cDelimitador + 
                          fnBrowse("Quantidade",1) + cDelimitador + 
                          fnBrowse("Un",1)         + cDelimitador + 
                          fnBrowse("Valor",1)      + cDelimitador + 
                          SUBSTRING(ttSelecao.cb-moeda,4,20))) FORMAT cTamCab AT 01.
            END.
            ASSIGN l-first = YES.
        END.
    
        IF ttDados.p-image = 16 THEN DO:
            ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cDescPai)  +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                   ttDados.integracao                            + cDelimitador + 
                   STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                   STRING(ttDados.hora, "99:99:99")              + cDelimitador +
                   STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                   STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador +
                   IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U)) + ")". 
            
            PUT (TRIM(cDescPai)  +  
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                 ttDados.integracao                            + cDelimitador + 
                 STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                 STRING(ttDados.hora, "99:99:99")              + cDelimitador + 
                 STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                 STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador + 
                 IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U FORMAT cTamCab AT 01.
        END.
        ELSE DO:
            ASSIGN cTamReg = "x(" + STRING(LENGTH(TRIM(cDescPai) +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )))         + ")".

            PUT (TRIM(cDescPai) +
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )) FORMAT cTamReg AT 01.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTextoDadosVal wWindow 
PROCEDURE piTextoDadosVal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pDimensao AS CHARACTER NO-UNDO.

DEFINE VARIABLE cPai    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTamCab AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTamReg AS CHARACTER NO-UNDO.

ASSIGN cPai = "".

FOR EACH ttDados
    WHERE ttDados.cod-dimens-pai = pDimensao NO-LOCK USE-INDEX valor:

    /** Verifica se existem n≠veis abaixo  **/
    IF ttDados.sequencia <= iVisao2 THEN DO:
        RUN piTextoDadosVal (INPUT ttDados.cod-dimensao).
    END.
    ELSE DO:
        IF cPai <> ttDados.cod-dimens-pai THEN DO:
            ASSIGN cDescPai  = "".
            RUN piTextoVisao (INPUT ROWID(ttDados),
                              INPUT ttDados.cod-dimens-pai).
            ASSIGN cPai       = ttDados.cod-dimens-pai.
        END.

        /** Imprime cabeáalho se parametrizado **/
        IF lCabecalho AND l-first = NO THEN DO:
            IF ttDados.p-image = 16 THEN DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador + 
                       fnBrowse("Integraá∆o",1)           + cDelimitador +
                       fnBrowse("Data",1)                 + cDelimitador +
                       fnBrowse("Hora",1)                 + cDelimitador +
                       fnBrowse("Contador",1)             + cDelimitador +
                       fnBrowse("nr-trans",1)             + cDelimitador +
                       fnBrowse("dt-trans",1)))) + ")".
                
                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)                + cDelimitador + 
                          fnBrowse("Quantidade",1)           + cDelimitador + 
                          fnBrowse("Un",1)                   + cDelimitador + 
                          fnBrowse("Valor",1)                + cDelimitador +
                          SUBSTRING(ttSelecao.cb-moeda,4,20) + cDelimitador +
                          fnBrowse("Integraá∆o",1)           + cDelimitador +
                          fnBrowse("Data",1)                 + cDelimitador +
                          fnBrowse("Hora",1)                 + cDelimitador +
                          fnBrowse("Contador",1)             + cDelimitador +
                          fnBrowse("nr-trans",1)             + cDelimitador +
                          fnBrowse("dt-trans",1))) FORMAT cTamCab at 01.
            END.
            ELSE DO:
                ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cTituloTxt) + 
                       brDetalhe:TITLE IN FRAME fPage0    + cDelimitador + 
                       fnBrowse("Nivel",1)                + cDelimitador + 
                       fnBrowse("Quantidade",1)           + cDelimitador + 
                       fnBrowse("Un",1)                   + cDelimitador + 
                       fnBrowse("Valor",1)                + cDelimitador + 
                       SUBSTRING(ttSelecao.cb-moeda,4,20)))) + ")".

                PUT TRIM((TRIM(cTituloTxt) + 
                          brDetalhe:TITLE IN FRAME fPage0 + cDelimitador + 
                          fnBrowse("Nivel",1)      + cDelimitador + 
                          fnBrowse("Quantidade",1) + cDelimitador + 
                          fnBrowse("Un",1)         + cDelimitador + 
                          fnBrowse("Valor",1)      + cDelimitador + 
                          SUBSTRING(ttSelecao.cb-moeda,4,20))) FORMAT cTamCab AT 01.
            END.
            ASSIGN l-first = YES.
        END.
    
        IF ttDados.p-image = 16 THEN DO:
            ASSIGN cTamCab = "x(" + STRING(LENGTH(TRIM(TRIM(cDescPai)  +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                   ttDados.integracao                            + cDelimitador + 
                   STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                   STRING(ttDados.hora, "99:99:99")              + cDelimitador +
                   STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                   STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador +
                   IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U)) + ")". 
            
            PUT (TRIM(cDescPai)  +  
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )           + cDelimitador + 
                 ttDados.integracao                            + cDelimitador + 
                 STRING(ttDados.data, "99/99/9999")            + cDelimitador + 
                 STRING(ttDados.hora, "99:99:99")              + cDelimitador + 
                 STRING(ttDados.contador, "999999999.9"))      + cDelimitador + 
                 STRING(ttDados.nr-trans,">>>,>>>,>>9")        + cDelimitador + 
                 IF ttDados.dt-trans <> ? THEN STRING(ttDados.dt-trans,"99/99/9999") ELSE "":U FORMAT cTamCab AT 01.
        END.
        ELSE DO:
            ASSIGN cTamReg = "x(" + STRING(LENGTH(TRIM(cDescPai) +  
                   TRIM(ttDados.codigo)                          + cDelimitador + 
                   TRIM(ttDados.Nivel)                           + cDelimitador + 
                   STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                   ttDados.un                                    + cDelimitador + 
                   STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                   SUBSTRING(ttSelecao.cb-moeda,4,20 )))         + ")".

            PUT (TRIM(cDescPai) +
                 TRIM(ttDados.codigo)                          + cDelimitador + 
                 TRIM(ttDados.Nivel)                           + cDelimitador + 
                 STRING(ttDados.Quantidade, "999999999999.99") + cDelimitador + 
                 ttDados.un                                    + cDelimitador + 
                 STRING(ttDados.Valor, "99999999999.99")       + cDelimitador + 
                 SUBSTRING(ttSelecao.cb-moeda,4,20 )) FORMAT cTamReg AT 01.
        END.
    END.
END.

RETURN "OK":U.
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
DEFINE INPUT PARAMETER rRow     AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER cCodPai  AS CHARACTER NO-UNDO.

ASSIGN cTituloTxt = ""
       cDescPai = "".

/** Verifica se existe n≠vel acima para chamar recursivamente a procedure **/
IF CAN-FIND(FIRST bfttDados2
            WHERE bfttDados2.cod-dimensao = cCodPai NO-LOCK) THEN DO:
    FOR EACH bfttDados2
        WHERE bfttDados2.cod-dimensao = cCodPai NO-LOCK:
        RUN piTextoVisao (INPUT ROWID(bfttDados2),
                          INPUT bfttDados2.cod-dimens-pai).
    END.
END.

IF i-impressao = 1 THEN DO:
    /** Busca os dados **/
    FOR FIRST bfttDados2
        WHERE ROWID(bfttDados2) = rRow NO-LOCK:
    END.
    IF AVAIL bfttDados2 AND bfttdados2.sequencia <= iVisao2 THEN DO:
        {abp/ab0608.i2 bfttDados2.p-image}
        ASSIGN cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador
               cDescPai   = TRIM(TRIM(cDescPai) + TRIM(bfttDados2.codigo) + "-" + TRIM(bfttDados2.nivel) + cDelimitador).
    END.
END.
ELSE DO:
    /** Busca os dados **/
    FOR FIRST bfttDados2
        WHERE ROWID(bfttDados2) = rRow NO-LOCK:
    END.
    IF AVAIL bfttDados2 AND bfttdados2.sequencia <= iVisao2 THEN DO:
        {abp/ab0608.i2 bfttDados2.p-image}
        ASSIGN cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador
               cDescPai   = TRIM(TRIM(cDescPai) + TRIM(bfttDados2.codigo) + "-" + TRIM(bfttDados2.nivel) + cDelimitador).
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE posicionaTTCCustoIntegr wWindow 
PROCEDURE posicionaTTCCustoIntegr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h_api_ccusto) THEN
    RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  cEPCodigo,              /* EMPRESA EMS2 */
                                                 INPUT  "",                     /* CODIGO DO PLANO CCUSTO */
                                                 INPUT  "",                     /* UNIDADE DE NEGOCIO */
                                                 INPUT  TODAY,                  /* DATA DE TRANSACAO */
                                                 OUTPUT TABLE tt_ccusto_integr, /* CCUSTOS */
                                                 OUTPUT TABLE tt_log_erro).     /* ERROS */

    FOR FIRST tt_ccusto_integr
        WHERE tt_ccusto_integr.ttv_cod_ccusto  = cCCCodigo NO-LOCK:
    END.

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
    run criattSelecao in this-procedure.
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

assign ttDados.Nivel:visible in browse brDetalhe      = YES
       ttDados.Quantidade:visible in browse brDetalhe = yes
       ttDados.un:visible in browse brDetalhe         = yes
       ttDados.Valor:visible in browse brDetalhe      = yes
       ttDados.Codigo:visible in browse brDetalhe     = yes.

IF pImagem = 16 THEN 
    ASSIGN ttDados.integracao:VISIBLE IN BROWSE brDetalhe = YES
           ttDados.data:VISIBLE IN BROWSE brDetalhe       = YES
           ttDados.hora:VISIBLE IN BROWSE brDetalhe       = YES
           ttDados.contador:VISIBLE IN BROWSE brDetalhe   = YES
           ttDados.nr-trans:VISIBLE IN BROWSE brDetalhe   = if lIntEstoq then yes else no
           ttDados.dt-trans:VISIBLE IN BROWSE brDetalhe   = if lIntEstoq then yes else no.
ELSE
    ASSIGN ttDados.integracao:VISIBLE IN BROWSE brDetalhe = NO
           ttDados.data:VISIBLE IN BROWSE brDetalhe       = NO
           ttDados.hora:VISIBLE IN BROWSE brDetalhe       = NO
           ttDados.contador:VISIBLE IN BROWSE brDetalhe   = no
           ttDados.nr-trans:VISIBLE IN BROWSE brDetalhe   = NO
           ttDados.dt-trans:VISIBLE IN BROWSE brDetalhe   = NO.

ASSIGN brDetalhe:title in frame fPage0 = fnLabels(pImagem).


return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-coluna wWindow 
FUNCTION f-coluna RETURNS CHARACTER
  ( INPUT pHandle AS HANDLE,
    INPUT pCampo  AS CHAR  ) :

    DEF VAR hCampo AS HANDLE NO-unDO.

    ASSIGN hCampo = pHandle:BUFFER-FIELD(pCampo).

  RETURN hCampo:STRING-VALUE.

END FunCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
        when "Codigo":U then do:
            {utp/ut-liter.i "C¢digo"}
        end.
        when "Nivel":U then do:
            {utp/ut-liter.i "Descriá∆o"}
        end.
        when "Quantidade":U then do:
            {utp/ut-liter.i "Quantidade"}
        end.
        when "un":U then do:
            {utp/ut-liter.i "UN"}
        end.
        when "valor":U then do:
            {utp/ut-liter.i "Valor"}
        end.
        when "integracao":U then do:
            {utp/ut-liter.i "Integraá∆o"}
        end.
        when "data":U then do:
            {utp/ut-liter.i "Data"}
        end.
        when "hora":U then do:
            {utp/ut-liter.i "Hora"}
        end.
        when "contador":U then do:
            {utp/ut-liter.i "Contador"}
        end.
        when "nr-trans":U then do:
            {utp/ut-liter.i "Nr_Transaá∆o"}
        end.
        when "dt-trans":U then do:
            {utp/ut-liter.i "Data_Transaá∆o"}
        end.
    end case.
    assign cRetorno = trim(return-value).
end.
else do:
    case pCampo:
        when "Codigo":U then do:
            assign cRetorno = ttDados.Codigo.
        end.
        when "Nivel":U then do:
            assign cRetorno = ttDados.Nivel.
        end.
        when "Quantidade":U then do:
            assign cRetorno = string(ttDados.Quantidade,">>>,>>>,>>9.99").
        end.
        when "un":U then do:
            assign cRetorno = ttDados.un.
        end.
        when "Valor":U then do:
            assign cRetorno = string(ttDados.Valor,">>>,>>>,>>>,>>9.99").
        end.
        when "integracao":U then do:
            assign cRetorno = ttDados.integracao.
        end.
        when "data":U then do:
            assign cRetorno = STRING(ttDados.data, "99/99/9999").
        end.
        when "hora":U then do:
            assign cRetorno = string(ttDados.hora, "99:99:99").
        end.
        when "contador":U then do:
            assign cRetorno = string(ttDados.contador).
        end.
        when "nr-trans":U then do:
            assign cRetorno = string(ttDados.nr-trans,">>>,>>>,>>9").
        end.
        when "dt-trans":U then do:
            assign cRetorno = STRING(ttDados.dt-trans,"99/99/9999").
        end.       
    end case.
end.

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

DEFINE VARIABLE cRetorno AS CHARACTER  NO-unDO.

    /** T°tulo do browse **/
    {abp/ab0608.i2 pimage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FunCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMes wWindow 
FUNCTION fnMes RETURNS CHARACTER
  ( iMes as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnMes
    Notes:  Busca o Màs
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-unDO.

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

END FunCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

