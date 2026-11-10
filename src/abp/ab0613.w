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

{include/i-prgvrs.i AB0613 2.00.00.014 } /*** "010014" 16/05/2025 17:37:31 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0613 MAB}
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
&GLOBAL-DEFINE Program        AB0613
&GLOBAL-DEFINE Version        2.00.00.014

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              btImprimir btRedimensiona brDetalhe btResumo

/* Local Variable Definitions ---                                       */
define variable c-arquivo     as character                no-undo.
define variable i-cont        as integer                  no-undo.
define variable iVisao        as integer                  no-undo.
define variable iVisao2       as integer                  no-undo.
define variable cUN           as character                no-undo.
define variable cPrazo        as character                no-undo.
define variable lReal         as logical                  no-undo.
/** Busca Valor **/
define variable rRowid        as rowid                    no-undo.
define variable cCodPai       as character format "x(20)" no-undo.
define variable vCodigo       as character format "x(20)" no-undo.
define variable vCodigoOf     as character format "x(20)" no-undo.
define variable vDescricao    as character format "x(32)" no-undo.
define variable iImage        as integer                  no-undo.

DEFINE VARIABLE oTreeList     AS CLASS TotvsTreeList      NO-UNDO. // Visao

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
define variable deVida        as DECIMAL FORMAT "->>>,>>>,>>9.9" no-undo.
define variable dePadrao      as decimal FORMAT "->>>,>>>,>>9.9" no-undo.
define variable iPrazo        as integer                  no-undo.
define variable deQuantidade  as decimal                  no-undo.
define variable devalor       as decimal                  no-undo.

define variable cCompart      as character                no-undo.
define variable cTag          as character                no-undo.
define variable cCCCodigo     as CHARACTER                no-undo.
define variable cSubSist      as character                no-undo.
define variable dData         as date                     no-undo.
DEFINE VARIABLE cHoraIni      AS CHAR                     NO-UNDO.             
DEFINE VARIABLE cHoraFim      AS CHAR                     NO-UNDO.             
define variable dval-Dat-Hora-Invrtda as decimal          no-undo.
DEFINE VARIABLE cCod-oficial  AS CHARACTER                NO-UNDO. 
/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.

/** Dados **/
def temp-table ttDados no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(35)" 
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field uso-real          as   decimal FORMAT "->>>,>>>,>>9.9"
    field uso-padrao        as   decimal format "->>>,>>>,>>9.9"
    field diferenca         as   decimal format "->>>,>>>,>>9.9"
    field perc-desvio       as   decimal format "->>9.9"
    field un                as   character format "x(2)"
    field iPrazo            as   integer /** 1=Antes 2=Dentro 3=Ap¢s **/ 
    field iAntes            as   integer
    field iDentro           as   integer
    field iApos             as   integer
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    field quantidade        as   decimal format ">>>,>>9.99"
    field valor             as   decimal format ">>>,>>9.99"
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.

define buffer bfttDados  for ttDados.
define buffer bfLubrific for mab-item-lubrific.
define buffer bfKM       for mab-movto-km-eqpto.
{abp/ab0613.i}  /** Definiá∆o da temp-table de parÉmetros **/
{abp/ab9000.i}  /** Formataá∆o de Hora **/

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
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttDados.cod-oficial ttDados.desc-dimensao ttDados.quantidade ttDados.valor ttDados.uso-real ttDados.uso-padrao ttDados.diferenca ttDados.un ttDados.perc-desvio fnPrazo(ttDados.iPrazo) @ cPrazo   
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
btExpande btParam btFiltro btVisao btImprimir btResumo btQueryJoins ~
btReportsJoins btExit btHelp btRedimensiona brDetalhe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPrazo wWindow 
FUNCTION fnPrazo RETURNS CHARACTER
  ( iPrazo as int )  FORWARD.

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
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-J"
       MENU-ITEM miResumo       LABEL "Resumo"         ACCELERATOR "CTRL-O"
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
     IMAGE-UP FILE "image\im-open":U
     IMAGE-INSENSITIVE FILE "image\ii-open":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Abrir"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExpande 
     IMAGE-UP FILE "image\im-crit":U
     IMAGE-INSENSITIVE FILE "image\ii-crit":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Expande / Contrai"
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-fil":U
     IMAGE-INSENSITIVE FILE "image\ii-fil":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image\im-param":U
     IMAGE-INSENSITIVE FILE "image\ii-param":U
     LABEL "ParÉmetros" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros"
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRedimensiona 
     LABEL "" 
     SIZE 90 BY .29.

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btResumo 
     IMAGE-UP FILE "image/im-total.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-total.bmp":U
     LABEL "Resumo" 
     SIZE 4 BY 1.25 TOOLTIP "Resumo".

DEFINE BUTTON btSalvar 
     IMAGE-UP FILE "image\im-grava":U
     IMAGE-INSENSITIVE FILE "image\ii-grava":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar"
     FONT 4.

DEFINE BUTTON btVisao 
     IMAGE-UP FILE "image\im-aloca":U
     IMAGE-INSENSITIVE FILE "image\im-aloci":U
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
      ttDados.cod-oficial      width 14
ttDados.desc-dimensao    width 30
ttDados.quantidade       width 10
ttDados.valor            width 10
ttDados.uso-real         width 12
ttDados.uso-padrao       width 12
ttDados.diferenca        width 12
ttDados.un               width 03
ttDados.perc-desvio           width 10
fnPrazo(ttDados.iPrazo) @ cPrazo width 10
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
     btParam AT ROW 1.13 COL 47 HELP
          "ParÉmetros"
     btFiltro AT ROW 1.13 COL 51 HELP
          "Filtro"
     btVisao AT ROW 1.13 COL 55 HELP
          "Classifica"
     btImprimir AT ROW 1.13 COL 59 HELP
          "Impress∆o"
     btResumo AT ROW 1.13 COL 65 HELP
          "Resumo"
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
         HEIGHT             = 19
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
       brDetalhe:NUM-LOCKED-COLUMNS IN FRAME fpage0     = 1
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
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 + dXC)
           btResumo:column in frame fPage0         = (btResumo:column in frame fPage0 + dXC)
           brDetalhe:width-chars in frame fPage0   = (brDetalhe:width-chars in frame fPage0 + dXC)
           oTreeList:width                         = oTreeList:width   + dXC 
           oTreeList:HEIGHT                        = oTreeList:HEIGHT  + dYC
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 + dXC)
           btRedimensiona:row in frame fPage0      = (btRedimensiona:row in frame fPage0 + (dYC / 2))
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
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 - dXC)
           btResumo:column in frame fPage0         = (btResumo:column in frame fPage0 - dXC)
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
        /** Controla expansao **/
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
  run abp/ab0613a.w (input-output  table ttselecao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btFiltro in frame fPage0.
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


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miSelecao  IN MENU mbMain DO:
    
  assign {&window-name}:sensitive = no.
  run abp/ab0613c.w (input-output  table ttselecao).
  assign {&window-name}:sensitive = yes.
  FIND FIRST ttSelecao NO-LOCK NO-ERROR.
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
ASSIGN brDetalhe:title in frame fPage0    = "".

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


&Scoped-define SELF-NAME btResumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btResumo wWindow
ON CHOOSE OF btResumo IN FRAME fpage0 /* Resumo */
OR CHOOSE OF MENU-ITEM miResumo IN MENU mbMain DO:
  assign {&window-name}:sensitive = no.

  run abp/ab0613e.w (input table ttvisao,
                     input table ttDados).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btResumo in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSalvar  IN MENU mbMain DO:
   /** Troca os tipos de barras **/ 
   assign c-arquivo = replace(c-arquivo, "/", "~\").

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
                         ttSelecao.periodo-ini
                         ttSelecao.periodo-fim
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
                         ttSelecao.gr-ev-ini 
                         ttSelecao.gr-ev-fim 
                         ttSelecao.evento-ini
                         ttSelecao.evento-fim
                         ttSelecao.comp-ini  
                         ttSelecao.comp-fim  
                         ttSelecao.lAtivos   
                         ttSelecao.lInativos 
                         ttSelecao.lProprios 
                         ttSelecao.lTerceiros
                         ttSelecao.lMotor    
                         ttSelecao.lNMotor   
                         ttSelecao.lAntes
                         ttSelecao.lDentro
                         ttSelecao.lApos
                         ttSelecao.lComp
                         ttSelecao.lFiltro
                         ttSelecao.lOutro
                         ttSelecao.ltipo
                         ttSelecao.unid-negoc-ini
                         ttSelecao.unid-negoc-fim
                         ttSelecao.causa-ini
                         ttSelecao.causa-fim.
              &ENDIF
          END.
          ELSE DO:
              export delimiter ";"
                     ttSelecao.periodo-ini
                     ttSelecao.periodo-fim
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
                     ttSelecao.gr-ev-ini 
                     ttSelecao.gr-ev-fim 
                     ttSelecao.evento-ini
                     ttSelecao.evento-fim
                     ttSelecao.comp-ini  
                     ttSelecao.comp-fim  
                     ttSelecao.lAtivos   
                     ttSelecao.lInativos 
                     ttSelecao.lProprios 
                     ttSelecao.lTerceiros
                     ttSelecao.lMotor    
                     ttSelecao.lNMotor   
                     ttSelecao.lAntes
                     ttSelecao.lDentro
                     ttSelecao.lApos
                     ttSelecao.lComp
                     ttSelecao.lFiltro
                     ttSelecao.lOutro
                     ttSelecao.ltipo
                     ttSelecao.causa-ini
                     ttSelecao.causa-fim.
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


&Scoped-define SELF-NAME btVisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisao wWindow
ON CHOOSE OF btVisao IN FRAME fpage0 /* Classificar */
OR CHOOSE OF MENU-ITEM miClassifica  IN MENU mbMain DO:
 
  assign {&window-name}:sensitive = no.
  run abp/ab0613b.w (input-output table ttvisao).
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
/** Trigger de choose do pop menu "Expande" **/
on choose of exp-con do:
    if  oTreeList:hasChildren(oTreeList:currentCode) then do:
        oTreeList:expandNode(oTreeList:currentCode, NOT oTreeList:getDataLog(oTreeList:currentCode,"lExpande")).
    end.
end.

btRedimensiona:load-mouse-pointer ("image~\size2.cur") in frame fPage0.

{abp/abapi001.i2} /** Criaá∆o de Erros **/

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
{utp/ut-liter.i "C¢digo"}
assign ttDados.cod-oficial:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Descriá∆o"}
assign ttDados.desc-dimensao:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Uso Real"}
assign ttDados.uso-real:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Uso Padr∆o"}
assign ttDados.uso-padrao:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Diferenáa"}
assign ttDados.diferenca:label in browse brDetalhe = return-value.
{utp/ut-liter.i "UN"}
assign ttDados.un:label in browse brDetalhe = return-value.
{utp/ut-liter.i "% Desvio"}
assign ttDados.perc-desvio:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Prazo"}
assign cPrazo:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Quantidade"}
assign ttDados.quantidade:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Valor"}
assign ttDados.valor:label in browse brDetalhe = return-value.

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

{utp/ut-liter.i Vis∆o *}
oTreeList:setColumnLabel("cEstrutura", RETURN-VALUE).

oTreeList:browseTreeList:POPUP-MENU = pop-menu.

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

    IF ttVisao.sequencia = iVisao THEN
        open query brDetalhe for each  ttDados
                                 where ttDados.cod-dimens-pai = bfttDados.cod-dimensao NO-LOCK
                                 BY    date(ttDados.cod-oficial).
    ELSE
        open query brDetalhe for each  ttDados
                                 where ttDados.cod-dimens-pai = bfttDados.cod-dimensao NO-LOCK
                                 BY    ttDados.cod-dimensao.
end.
/** Sen∆o, mostra ele mesmo **/
else do:
    run tituloBrowse in this-procedure (bfttDados.p-image).
    open query brDetalhe for each  ttDados
                             where ttDados.cod-dimensao = bfttDados.cod-dimensao NO-LOCK
                             BY    ttDados.cod-dimensao.
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
assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

create ttSelecao.
assign ttSelecao.periodo-ini   = today - 30
       ttSelecao.periodo-fim   = today
       ttSelecao.empresa-ini   = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
       ttSelecao.empresa-fim   = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ" &else 999 &ENDIF
       ttSelecao.equipto-ini   = ""
       ttSelecao.equipto-fim   = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.grupo-ini     = ""
       ttSelecao.grupo-fim     = "ZZZZZZZZ"
       ttSelecao.modelo-ini    = ""
       ttSelecao.modelo-fim    = "ZZZZZZZZ"
       ttSelecao.estab-ini     = ""
       ttSelecao.estab-fim     = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ" &else "ZZZ" &endif
       ttSelecao.tag-ini       = ""
       ttSelecao.tag-fim       = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.estrut-ini    = ""
       ttSelecao.estrut-fim    = "ZZZZZZZZ"
       ttSelecao.gr-ev-ini     = ""
       ttSelecao.gr-ev-fim     = "ZZZZZZZZ"
       ttSelecao.evento-ini    = ""
       ttSelecao.evento-fim    = "ZZZZZZZZ"
       ttSelecao.comp-ini      = ""        
       ttSelecao.comp-fim      = "ZZZZZZZZ"
       ttSelecao.c-custo-ini   = ""        
       ttSelecao.c-custo-fim   = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.lAtivos       = yes
       ttSelecao.lInativos     = no
       ttSelecao.lProprios     = yes
       ttSelecao.lTerceiros    = no
       ttSelecao.lMotor        = yes
       ttSelecao.lNMotor       = yes
       ttSelecao.lAntes        = yes
       ttSelecao.lDentro       = yes
       ttSelecao.lApos         = yes
       ttSelecao.lComp         = yes
       ttSelecao.lFiltro       = yes
       ttSelecao.lOutro        = NO
       ttSelecao.ltipo         = 1
    &IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.unid-negoc-ini = "":U
       ttSelecao.unid-negoc-fim = "ZZZ":U
    &ENDIF
       ttSelecao.causa-ini     = ""
       ttSelecao.causa-fim     = "ZZZZZZZZ"
       .


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

    DEFINE  VARIABLE    cExpande    AS  CHARACTER   NO-UNDO.
    DEFINE  VARIABLE    cContrai    AS  CHARACTER   NO-UNDO.
    DEFINE  VARIABLE    rRow        AS  ROWID       NO-UNDO.
    
    {utp/ut-liter.i "Expande"}
    ASSIGN  cExpande    =   RETURN-VALUE.
    {utp/ut-liter.i "Contrai"}
    ASSIGN  cContrai    =   RETURN-VALUE.

    IF  (cEvent =   "selected"  OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:

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
        END.
        IF  AVAIL   ttDados THEN    DO:
            FOR FIRST ttVisao
                WHERE ttVisao.sequencia = ttDados.sequencia NO-LOCK:
            END.
 
            /** Mostra registros no browse **/
            RUN atualizaBrowse  IN  THIS-PROCEDURE.
        END.

        ASSIGN  exp-con:LABEL   =   IF  oTreeList:getDataLog(oTreeList:currentCode,"lExpande")  THEN cContrai
                                                                                                ELSE cExpande.
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
assign cCod-Oficial = ""
       vCodigoOf    = ""
       vDescricao   = ""
       iImage       = 0
       rRowid       = ?.

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
            assign cCod-Oficial = string(mab-eqpto.ep-codigo, "999")
                   vDescricao = empresa.nome
                   iImage     = 1
                   rRowid     = rowid(empresa).
        end.      
    end.
    /** Equipamento **/
    WHEN "02":U THEN DO:
        ASSIGN cCod-Oficial = STRING (mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
               iImage     = 2
               rRowid     = ROWID(mab-eqpto).

        IF NOT AVAIL mab-model OR mab-model.cod-model <> mab-eqpto.cod-model THEN DO:
            FOR FIRST mab-model FIELDS(des-model cod-model un)  
                WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK: END.
        END.
        {utp/ut-liter.i "Modelo_n∆o_encontrado"}
        IF AVAIL mab-model THEN
            ASSIGN vDescricao = mab-model.des-model
                   cUN        = mab-model.un.
        ELSE
            ASSIGN vDescricao = RETURN-VAlUE
                   cUN        = "_".

    END.
    /** Compartimento / Filtro **/
    when "03":U then do:
        if cCompart <>  " " and 
           avail mab-comptmento then do:
            assign cCod-Oficial = mab-item-lubrific.cod-comptmento
                   vDescricao = mab-comptmento.des-comptmento
                   iImage     = 3
                   rRowid     = rowid(mab-comptmento).
        end.
        else do:
            for first mab-sub-sist where mab-sub-sist.cod-sub-sist = cSubSist no-lock:
            end.
            if avail mab-sub-sist then do:
                assign cCod-Oficial = "SS" + mab-sub-sist.cod-sub-sist
                       vDescricao = mab-sub-sist.des-sub-sist
                       iImage     = 3
                       rRowid     = rowid(mab-sub-sist).
            end.
            else do:
                {utp/ut-liter.i "Compartimento"}
                assign cCod-Oficial = "_"
                       vDescricao = return-value
                       iImage     = 3
                       rRowid     = rowid(mab-eqpto).
            end.
        end.
    end.
    /** Evento **/
    when "04":U then do:
        if avail mab-event then do:
            assign cCod-Oficial = mab-event.cod-evento
                   vDescricao = mab-event.des-evento
                   iImage     = 4
                   rRowid     = rowid(mab-event).
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
            assign cCod-Oficial = mab-eqpto.cod-estabel
                   vDescricao = estabelec.nome
                   iImage     = 5
                   rRowid     = rowid(estabelec).
        end.        
    end.
    /** Màs / Ano  **/
    when "06":U then do:
        assign cCod-Oficial = string(year(dData),"9999") + "/" + string(month(dData),"99")
               vCodigoOf    = string(MONTH(dData),"99") + "/" + string(YEAR(dData),"9999")
               vDescricao   = fnMes(month(dData)) + " " + string(year(dData),"9999")
               iImage       = 6
               rRowid       = rowid(mab-item-lubrific).
    end.
    /** Data **/
    when "07":U then do:      
        assign cCod-Oficial = substring(string(dval-dat-hora-invrtda),1,8) + " - " + STRING(cHoraIni) + " - " + STRING(cHoraFim)
               vDescricao = STRING(dData,"99/99/9999") + " - " + STRING(cHoraIni,"99:99:99")  + " - " + STRING(cHoraFim,"99:99:99")
               iImage     = 7                                                                                                
               rRowid     = rowid(mab-eqpto).                                                                                
    end.
    /** Grupo Equipamento **/
    when "08":U then do:
        if not avail mab-grp-eqpto or mab-grp-eqpto.cod-grp-eqpto <> mab-eqpto.cod-grp-eqpto then do:
            for first mab-grp-eqpto fields(des-grp-eqpto cod-grp-eqpto)  
                where mab-grp-eqpto.cod-grp-eqpto = mab-eqpto.cod-grp-eqpto no-lock:
            end.
        end.
        if avail mab-grp-eqpto then do:
            assign cCod-Oficial = mab-eqpto.cod-grp-eqpto
                   vDescricao = mab-grp-eqpto.des-grp-eqpto
                   iImage     = 8
                   rRowid     = rowid(mab-grp-eqpto).
        end.         
    end.
    /** Modelo Equipamento **/
    when "09":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model un)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
            assign cCod-Oficial = mab-eqpto.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 9
                   rRowid     = rowid(mab-model).
        end.         
    end.

    /** TAG **/
    WHEN "10":U THEN DO:
        IF NOT AVAIL tag OR tag.cd-tag <> cTag THEN DO:
            FOR FIRST tag WHERE
                      tag.cd-tag = cTag NO-LOCK:
            END.
        END.
        IF AVAIL tag THEN DO:
            ASSIGN cCod-Oficial = IF cTag = "" THEN "_" ELSE cTag
                   iImage       = 10
                   rRowid       = ROWID(tag)
                   vDescricao   = tag.descricao.
        END.
        ELSE DO:
            {utp/ut-liter.i Tag_N∆o_Dispon°vel}
            ASSIGN cCod-Oficial = IF cTag = "" THEN "_" ELSE cTag
                   vDescricao   = RETURN-VALUE
                   iImage       = 10
                   rRowid       = ROWID(mab-eqpto).
        END.
    END.
        
    /** Centro de Custo **/
    WHEN "11":U THEN DO:
        IF NOT AVAIL mab-histor-ativid THEN DO:
            FOR LAST mab-histor-ativid NO-LOCK
                WHERE mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo
                AND   mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto.
            END.
            IF NOT AVAIL mab-histor-ativid THEN 
                ASSIGN cCCCodigo = mab-eqpto.cc-codigo
                       cTag      = mab-eqpto.cd-tag.
            ELSE 
                ASSIGN cCCCodigo = mab-histor-ativid.cc-codigo
                       cTag      = mab-histor-ativid.cd-tag.
        END.
        IF NOT AVAIL tt_ccusto_integr OR tt_ccusto_integr.ttv_cod_ccusto <> cCCCodigo THEN DO:
            FOR FIRST tt_ccusto_integr
                WHERE tt_ccusto_integr.ttv_cod_ccusto = cCCCodigo NO-LOCK:
            END.
        END.
        IF AVAIL tt_ccusto_integr THEN DO:
            ASSIGN cCod-Oficial = if cCCCodigo = "" THEN "_" ELSE cCCCodigo
                   vDescricao   = tt_ccusto_integr.ttv_des_titulo
                   iImage       = 11
                   rRowid       = ROWID(tt_ccusto_integr).
        END.
        ELSE DO:
            {utp/ut-liter.i "Centro_Custo_N∆o_Dispon°vel"}
            ASSIGN cCod-Oficial = IF cCCCodigo = "" then "_" else cCCCodigo
                   vDescricao   = RETURN-VALUE 
                   iImage       = 11
                   rRowid       = ROWID(mab-eqpto).
        END.
    END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "12" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-eqpto.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-eqpto.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN cCod-Oficial = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao   = STRING(unid-negoc.des-unid-negoc)
                           iImage       = 12
                           rRowid       = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                    ASSIGN cCod-Oficial = "_":U
                           vDescricao   = RETURN-VALUE
                           iImage       = 12
                           rRowid       = ROWID(mab-eqpto).
                END.
            END.
        END.
    &ENDIF
end case.

IF vCodigoOf = "" THEN ASSIGN vCodigoOf = cCod-Oficial.
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
           ttSelecao.periodo-ini    = date(entry(1,c-linha,";"))            
           ttSelecao.periodo-fim    = date(entry(2,c-linha,";"))            
           ttSelecao.empresa-ini    = &IF "{&mguni_version}" >= "2.071" &THEN entry(3,c-linha,";") &else int(entry(3,c-linha,";")) &ENDIF
           ttSelecao.empresa-fim    = &IF "{&mguni_version}" >= "2.071" &THEN entry(4,c-linha,";") &else int(entry(4,c-linha,";")) &ENDIF
           ttSelecao.equipto-ini    = entry(5,c-linha,";")
           ttSelecao.equipto-fim    = entry(6,c-linha,";")   
           ttSelecao.grupo-ini      = entry(7,c-linha,";")    
           ttSelecao.grupo-fim      = entry(8,c-linha,";")    
           ttSelecao.modelo-ini     = entry(9,c-linha,";")    
           ttSelecao.modelo-fim     = entry(10,c-linha,";")    
           ttSelecao.estab-ini      = entry(11,c-linha,";")          
           ttSelecao.estab-fim      = entry(12,c-linha,";")          
           ttSelecao.tag-ini        = entry(13,c-linha,";")          
           ttSelecao.tag-fim        = entry(14,c-linha,";")          
           ttSelecao.estrut-ini     = entry(15,c-linha,";")          
           ttSelecao.estrut-fim     = entry(16,c-linha,";")          
           ttSelecao.gr-ev-ini      = entry(17,c-linha,";")          
           ttSelecao.gr-ev-fim      = entry(18,c-linha,";")          
           ttSelecao.evento-ini     = entry(19,c-linha,";")          
           ttSelecao.evento-fim     = entry(20,c-linha,";")          
           ttSelecao.comp-ini       = entry(21,c-linha,";")          
           ttSelecao.comp-fim       = entry(22,c-linha,";")          
           ttSelecao.lAtivos        = (entry(23,c-linha,";") = "yes")         
           ttSelecao.lInativos      = (entry(24,c-linha,";") = "yes")         
           ttSelecao.lProprios      = (entry(25,c-linha,";") = "yes")       
           ttSelecao.lTerceiros     = (entry(26,c-linha,";") = "yes")       
           ttSelecao.lMotor         = (entry(27,c-linha,";") = "yes")
           ttSelecao.lNMotor        = (entry(28,c-linha,";") = "yes")   
           ttSelecao.lAntes         = (entry(29,c-linha,";") = "yes")   
           ttSelecao.lDentro        = (entry(30,c-linha,";") = "yes")   
           ttSelecao.lApos          = (entry(31,c-linha,";") = "yes")
           ttSelecao.lComp          = (entry(32,c-linha,";") = "yes")
           ttSelecao.lFiltro        = (entry(33,c-linha,";") = "yes")
           ttSelecao.lOutro         = (entry(34,c-linha,";") = "yes")
           ttSelecao.ltipo          = int(entry(35,c-linha,";")).

        IF l-usa-unid-negoc THEN DO:
            &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao.unid-negoc-ini = entry(36,c-linha,";")
                   ttSelecao.unid-negoc-fim = entry(37,c-linha,";")
                   ttSelecao.causa-ini      = ENTRY(38,c-linha,";")
                   ttSelecao.causa-fim      = ENTRY(39,c-linha,";").
            &ENDIF
        END.
        ELSE DO:
            ASSIGN ttSelecao.causa-ini = ENTRY(36,c-linha,";")
                   ttSelecao.causa-fim = ENTRY(37,c-linha,";").
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
define variable TotEqpto as character         no-undo.
define buffer bfttDados for ttDados.

/** Limpa o tree-view **/
oTreeList:emptyTreeList().
    
assign i-cont = 0.
/** Verifica se existem vis‰es escolhidas **/
for last ttVisao no-lock:
    assign iQtSeq = ttVisao.sequencia.
end.
    if iQtSeq = 0 then return.
/** Label da quantidade de equipamentos **/
{utp/ut-liter.i "Consumo Real"}
assign TotEqpto = return-value.

/** Busca os dados criados **/
for each  ttDados 
    where ttDados.sequencia < iQtSeq exclusive-lock 
    by cod-dimensao:

  /** Conta sequàncias de linhas **/ 
  assign i-cont = i-cont + 1.
  assign ttDados.seq-tree = i-cont.
  /** Inclui primeira linha **/
  if ttDados.sequencia = 1 then do:
     oTreeList:addNode ("", "i" + string(i-cont), string(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao).
     /** Guarda chave (rowid) da temp-table no tree-view **/
     oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados.p-image).
     oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados))).

     IF  ttDados.r-rowid <>  ?   THEN
         oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados.r-rowid)).
  end.
  else do:
      /** Busca filhos da vis∆o escolhida **/
      for first bfttDados 
          where bfttDados.cod-dimensao = ttDados.cod-dimens-pai no-lock:
          /** Inclui linhas das vis‰es filhas **/
          oTreeList:addNode("i" + string(bfttDados.seq-tree), "i" + string(i-cont), string(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao).
          /** Guarda chave (rowid) da temp-table no tree-view **/
          oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados.p-image).
          oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados))).

          IF  ttDados.r-rowid <>  ?   THEN
              oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados.r-rowid)).
      end.
  end.
end.

oTreeList:REFRESH().

return "OK":U.

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizar wWindow 
PROCEDURE piAtualizar :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizar
  Parameters:  <none>
  Notes:       Busca os dados e atualiza o programa
------------------------------------------------------------------------------*/
DEFINE VARIABLE deInvIni AS DECIMAL FORMAT "999999999999" NO-UNDO.
DEFINE VARIABLE deInvFim AS DECIMAL FORMAT "999999999999" NO-UNDO.
DEFINE VARIABLE iUltimo  AS integer                       NO-UNDO.
DEFINE VARIABLE hAcomp   AS HANDLE                        NO-UNDO.

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run piCriaVisao in this-procedure.
end.

/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.

/* quando consulta custos e quantidades dos compartimentos, bot∆o RESUMO ser† desabilitado */
if ttSelecao.ltipo = 2 then 
    assign btResumo:sensitive in frame fPage0 = false.
else
    assign btResumo:sensitive in frame fPage0 = true.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}

for last ttVisao no-lock:
    assign iUltimo = ttVisao.sequencia.
end.

/** Verifica Èltimo o N°vel que Evetos est† **/
assign iVisao = 0.
for first ttVisao 
    where substring(ttVisao.dimensao,1,2) = "07":U no-lock:
    assign iVisao = ttVisao.sequencia.
end.

/** Cria Hora Invertida Inicial e Final **/
run converteParaHoraInvertida (input  string(ttSelecao.periodo-ini,"99/99/9999"),
                               input  "000000",
                               output deInvIni).
run converteParaHoraInvertida (input  string(ttSelecao.periodo-fim,"99/99/9999"),
                               input  "235959",
                               output deInvFim).

blk1:
do on stop undo, return "NOK":U:

    /** Acompanhamento **/
    RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
    {utp/ut-liter.i "Eventos_Realizados_em_Equipamentos"}
    RUN pi-inicializar IN hAcomp (trim(return-value)).


    /** Seleciona os equipamento **/
    blk-mab-eqpto:
    for each  mab-eqpto
        where mab-eqpto.ep-codigo         >= ttSelecao.empresa-ini
        and   mab-eqpto.ep-codigo         <= ttSelecao.empresa-fim
        and   mab-eqpto.cod-eqpto         >= ttSelecao.equipto-ini
        and   mab-eqpto.cod-eqpto         <= ttSelecao.equipto-fim
        and   mab-eqpto.cod-model         >= ttSelecao.modelo-ini
        and   mab-eqpto.cod-model         <= ttSelecao.modelo-fim
        and   mab-eqpto.cod-estabel       >= ttSelecao.estab-ini
        and   mab-eqpto.cod-estabel       <= ttSelecao.estab-fim
        and   mab-eqpto.cod-estrut-mec    >= ttSelecao.estrut-ini
        and   mab-eqpto.cod-estrut-mec    <= ttSelecao.estrut-fim
        and   mab-eqpto.cod-grp-eqpto     >= ttSelecao.grupo-ini
        and   mab-eqpto.cod-grp-eqpto     <= ttSelecao.grupo-fim
        and   ((mab-eqpto.idi-tip-eqpto    = 1 and ttSelecao.lMotor)      /** Motorizados **/
        or     (mab-eqpto.idi-tip-eqpto    = 2 and ttSelecao.lNMotor))    /** N∆o Motorizados **/
        and   ((mab-eqpto.idi-tip-propriet = 1 and ttSelecao.lProprios)   /** Pr¢prios **/
        or     (mab-eqpto.idi-tip-propriet = 2 and ttSelecao.lTerceiros)) /** Terceiros **/
        and   ((mab-eqpto.dat-situacao     = ? and ttSelecao.lAtivos)     /** Ativos **/
        or     (mab-eqpto.dat-situacao    <> ? and ttSelecao.lInativos))  /** Inativos **/ no-lock:
    
        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-eqpto.cod-unid-negoc >= ttSelecao.unid-negoc-ini  AND 
                       mab-eqpto.cod-unid-negoc <= ttSelecao.unid-negoc-fim) THEN NEXT.
            END.
        &ENDIF
        
        /** Acompanhamento **/
        {utp/ut-liter.i "Lendo_Equipamento"}
        RUN pi-Acompanhar IN hAcomp (RETURN-VALUE + ": " + STRING(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto).
    
        /** Seleciona os apontamentos de lubrificaá∆o **/
        for each  mab-item-lubrific fields(cod-evento cod-comptmento val-dat-hora-invrtda val-quant val-mater-1 cod-eqpto ep-codigo num-docto)
            where mab-item-lubrific.ep-codigo             = mab-eqpto.ep-codigo
            and   mab-item-lubrific.cod-eqpto             = mab-eqpto.cod-eqpto
            and   mab-item-lubrific.val-dat-hora-invrtda >= deInvIni
            and   mab-item-lubrific.val-dat-hora-invrtda <= deInvFim
            and   mab-item-lubrific.cod-evento           >= ttSelecao.evento-ini
            and   mab-item-lubrific.cod-evento           <= ttSelecao.evento-fim
            and   mab-item-lubrific.cod-comptmento       >= ttSelecao.comp-ini
            and   mab-item-lubrific.cod-comptmento       <= ttSelecao.comp-fim
            AND   mab-item-lubrific.cod-causa            >= ttSelecao.causa-ini
            AND   mab-item-lubrific.cod-causa            <= ttSelecao.causa-fim NO-LOCK:
    
            find first mab-abastec-lubrific
                where mab-abastec-lubrific.num-docto = mab-item-lubrific.num-docto no-lock no-error.
    
            if avail mab-abastec-lubrific then do:
                for last mab-histor-ativid
                    where mab-histor-ativid.ep-codigo     = mab-eqpto.ep-codigo          
                    and   mab-histor-ativid.cod-eqpto     = mab-eqpto.cod-eqpto          
                    and   mab-histor-ativid.dat-cadastro <= mab-abastec-lubrific.dat-movto no-lock:
                end.
                if not avail mab-histor-ativid then do:
                    for last mab-histor-ativid no-lock
                        where mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo
                        and   mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto.
                    end.
                    if not avail mab-histor-ativid then do:
                        assign cCCCodigo = mab-eqpto.cc-codigo
                               cTag      = mab-eqpto.cd-tag.
                    end.
                    else do:
                        assign cCCCodigo = mab-histor-ativid.cc-codigo
                               cTag      = mab-histor-ativid.cd-tag.
                    end.
                end.
                else do:
                    assign cCCCodigo = mab-histor-ativid.cc-codigo
                           cTag      = mab-histor-ativid.cd-tag.
                end.
        
                if cTag < ttSelecao.tag-ini or cTag > ttSelecao.tag-fim THEN NEXT.
                if cCCCodigo < ttSelecao.c-custo-ini or cCCCodigo > ttSelecao.c-custo-fim THEN NEXT.
            end.
            
            assign dePadrao     = 0
                   deQuantidade = 0
                   deValor      = 0.
    
    
            if not avail mab-event or mab-event.cod-evento <> mab-item-lubrific.cod-evento then do:
                /** Busca os eventos (grupos de eventos) **/
                for first mab-event fields(cod-evento des-evento cod-grp-event)
                    where mab-event.cod-evento     = mab-item-lubrific.cod-evento 
                    and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini
                    and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
                end.
            end.
            if not avail mab-event then next.
    
            if not avail mab-comptmento or mab-comptmento.cod-comptmento <> mab-item-lubrific.cod-comptmento then do:
                /** Filtra os compartimentos de ¢leo e filtro **/
                for first mab-comptmento fields(cod-comptmento des-comptmento)
                    where mab-comptmento.cod-comptmento   = mab-item-lubrific.cod-comptmento 
                    and  ((mab-comptmento.idi-oleo-filtro = 1 and lComp)
                    or    (mab-comptmento.idi-oleo-filtro = 2 and lFiltro)) no-lock:
                end.
            end.
            if not avail mab-comptmento then next.
    
            assign cCompart = mab-comptmento.cod-comptmento
                   cSubSist = " "
                   dData    = date(int(substring(string(mab-item-lubrific.val-dat-hora-invrtda, "999999999999"), 5, 2)), 
                                   int(substring(string(mab-item-lubrific.val-dat-hora-invrtda, "999999999999"), 7, 2)), 
                                   int(substring(string(mab-item-lubrific.val-dat-hora-invrtda, "999999999999"), 1, 4)))
                   dval-Dat-Hora-Invrtda = mab-item-lubrific.val-dat-hora-invrtda.

            ASSIGN cHoraIni = mab-abastec-lubrific.hra-inicial
                   cHoraFim = mab-abastec-lubrific.hra-final.
                                                                                                                
            if not avail mab-period-manut or (mab-period-manut.ep-codigo      <> mab-eqpto.ep-codigo 
                                          or  mab-period-manut.cod-eqpto      <> mab-eqpto.cod-eqpto
                                          or  mab-period-manut.cod-comptmento <> mab-comptmento.cod-comptmento
                                          or  mab-period-manut.cod-evento     <> mab-event.cod-evento) then do:
                /** Busca o per°odo de manutená∆o dos compartimentos do equipamento **/
                for first mab-period-manut fields(val-km-estimad val-km-padr val-km-real cod-comptmento
                                                  ep-codigo cod-eqpto cod-evento)
                    where mab-period-manut.ep-codigo      = mab-eqpto.ep-codigo 
                    and   mab-period-manut.cod-eqpto      = mab-eqpto.cod-eqpto
                    and   mab-period-manut.cod-comptmento = mab-comptmento.cod-comptmento 
                    and   mab-period-manut.cod-evento     = mab-event.cod-evento no-lock:
                end.
            end.
    
            /** Zera vari†veis **/
            assign deVida = 0.
    
            if avail mab-period-manut then do:
                assign dePadrao = mab-period-manut.val-km-padr.
    
                /** Busca apontamento anterior do mesmo evento do compartimento do equipamento **/
                for last  bfLubrific fields(num-docto val-dat-hora-invrtda cod-eqpto ep-codigo)
                    where bfLubrific.ep-codigo            = mab-eqpto.ep-codigo
                    and   bfLubrific.cod-eqpto            = mab-eqpto.cod-eqpto
                    and   bfLubrific.cod-comptmento       = mab-comptmento.cod-comptmento
                    and   bfLubrific.cod-evento           = mab-event.cod-evento 
                    and   bfLubrific.val-dat-hora-invrtda < mab-item-lubrific.val-dat-hora-invrtda no-lock:
                end.
                /** Calcula a vida do equipamento neste per°odo **/
                for first mab-movto-km-eqpto fields(val-km-real num-docto idi-origem cod-eqpto)
                    where mab-movto-km-eqpto.num-docto  = mab-item-lubrific.num-docto
                    and   mab-movto-km-eqpto.idi-origem = 1 
                    AND   mab-movto-km-eqpto.ep-codigo  = mab-item-lubrific.ep-codigo      /* Colocado empresa e equipamento na chave pois documento pode ser para outro equipamento */
                    AND   mab-movto-km-eqpto.cod-eqpto  = mab-item-lubrific.cod-eqpto no-lock:
                    /** Verifica se existe manutená∆o anterior **/
                    if avail bfLubrific then do:
                        for first bfKM fields(val-km-real)
                            where bfKM.num-docto  = bfLubrific.num-docto
                            and   bfKM.idi-origem = 1 
                            AND   bfKM.ep-codigo  = bfLubrific.ep-codigo  
                            AND   bfKM.cod-eqpto  = bfLubrific.cod-eqpto no-lock:
                            assign deVida = mab-movto-km-eqpto.val-km-real - bfKM.val-km-real.
                        end.
                    end.
                    /** Busca do equipamento **/
                    else do:
                        for first mab-comptmento-eqpto fields(val-km-inicial)
                            where mab-comptmento-eqpto.ep-codigo      = mab-eqpto.ep-codigo
                            and   mab-comptmento-eqpto.cod-eqpto      = mab-eqpto.cod-eqpto
                            and   mab-comptmento-eqpto.cod-comptmento = mab-comptmento.cod-comptmento no-lock:
                            assign deVida = mab-movto-km-eqpto.val-km-real - mab-eqpto.val-km-inicial + mab-comptmento-eqpto.val-km-inicial.
                        end.
                    end.
                end. /** mab-movto-km-eqpto **/
                if not avail mab-movto-km-eqpto then next.
    
            end. /** avail mab-period-manut **/
    
            IF deVida < 0 THEN assign deVida = 0.
    
            if not avail mab-period-manut and 
               ttSelecao.ltipo = 1 then next.
    
            if ttSelecao.ltipo = 1 then do:
                /** Verifica os prazos das manutená‰es **/
                /** Antes do Prazo **/
                if (deVida + mab-period-manut.val-km-estimad) < mab-period-manut.val-km-padr then 
                    if ttSelecao.lAntes then assign iPrazo = 1.
                                        else next.
                /** Dentro do Prazo **/
                if ((deVida >= (mab-period-manut.val-km-padr - mab-period-manut.val-km-estimad)) and
                    (deVida <= (mab-period-manut.val-km-padr + mab-period-manut.val-km-estimad))) then 
                    if ttSelecao.lDentro then assign iPrazo = 2.
                                         else next.
                /** Ap¢s o prazo **/
                if (deVida > (mab-period-manut.val-km-padr + mab-period-manut.val-km-estimad)) then 
                    if ttSelecao.lApos then assign iPrazo = 3.
                                       else next.
            end.
    
            assign deQuantidade = mab-item-lubrific.val-quant
                   deValor      = mab-item-lubrific.val-mater-1.
    
            /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
            assign cCodPai  = "".
            /** Busca vis‰es escolhidas **/
            for each ttVisao no-lock:
                /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                run buscaValor in this-procedure (input ttVisao.dimensao).
    
                if ttVisao.sequencia <> iUltimo then do:
                   assign vCodigo = cCod-Oficial.
                end.
                else do:
                    assign vCodigo = trim(string(mab-item-lubrific.num-docto)) + cCod-Oficial.
                end.
                /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                if vCodigo = "" then next.
                /** Carrega os dados  **/
                run piCarregaSequencias in this-procedure.
            end.                        
        end. /** mab-item-lubrific **/
    
        if ttSelecao.ltipo = 2 then do:
            /** Seleciona os eventos ocorridos com o ve°culo  **/
            for each  mab-movto-event fields(cod-evento cod-sub-sist dat-final num-docto val-evento)
                where mab-movto-event.ep-codigo             = mab-eqpto.ep-codigo
                and   mab-movto-event.cod-eqpto             = mab-eqpto.cod-eqpto
                and   mab-movto-event.dat-final            >= ttSelecao.periodo-ini
                and   mab-movto-event.dat-final            <= ttSelecao.periodo-fim
                and   mab-movto-event.cod-evento           >= ttSelecao.evento-ini
                and   mab-movto-event.cod-evento           <= ttSelecao.evento-fim no-lock:
    
                assign dePadrao     = 0
                       deQuantidade = 0
                       deValor      = 0.
                
                if not avail mab-event or mab-event.cod-evento <> mab-movto-event.cod-evento then do:
                    /** Busca os eventos (grupos de eventos) **/
                    for first mab-event fields(cod-evento des-evento cod-grp-event)
                        where mab-event.cod-evento     = mab-movto-event.cod-evento 
                        and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini
                        and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
    
                    end.
                end.
                
                if not avail mab-event then next.
                            
                IF ttSelecao.lOutro = NO THEN DO:
                    FOR FIRST mab-grp-event WHERE mab-grp-event.cod-grp-event = mab-event.cod-grp-event NO-LOCK: 
                    END.
                    IF AVAIL(mab-grp-event) THEN DO:
                        IF mab-grp-event.idi-tip > 2 THEN NEXT.
                    END.
                END.
    
                assign cCompart              = " "
                       cSubSist              = mab-movto-event.cod-sub-sist
                       dData                 = mab-movto-event.dat-final
                       dval-Dat-Hora-Invrtda = (year(dData) * 100000000) + 
                                               (month(dData) * 1000000) + 
                                               (day(dData) * 10000).

                ASSIGN cHoraIni = mab-movto-event.hra-inicial
                       cHoraFim = mab-movto-event.hra-final.
                                                
                assign deQuantidade = 1
                       deValor      = mab-movto-event.val-evento.
    
                /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
                assign cCodPai  = "".
                /** Busca vis‰es escolhidas **/
                for each ttVisao no-lock:
                    /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                    run buscaValor in this-procedure (input ttVisao.dimensao).
    
                    if ttVisao.sequencia <> iUltimo then do:
                       assign vCodigo = cCod-Oficial.
                    end.
                    else do:
                        assign vCodigo = trim(string(mab-movto-event.num-docto)) + cCod-Oficial.
                    end.
    
                    /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                    if vCodigo = "" then next.
                    /** Carrega os dados  **/
                    run piCarregaSequencias in this-procedure.
                end.                        
            end. /** mab-item-lubrific **/
    
        end.
    end. /** mab-eqpto **/

    RUN pi-finalizar IN hAcomp.
end.


/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

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
/** Busca registro **/
find first ttDados 
     where ttDados.cod-dimensao  = (cCodPai + "#" + vCodigo)
     and   ttDados.sequencia     = ttVisao.sequencia exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttDados then do:
   create ttDados.
   assign ttDados.cod-dimensao   = (cCodPai + "#" + vCodigo)  /** C¢digo encadeado para tree-view **/
          ttDados.cod-oficial    = if iImage = 7 then substring(vDescricao,1,32) else
              IF iImage = 6 THEN vCodigoOf ELSE cCod-Oficial /** C¢digo Original do registro **/
          ttDados.desc-dimensao  = if iImage = 7 then ""   else vDescricao                    /** Descriá∆o do c¢digo **/
          ttDados.sequencia      = ttVisao.sequencia    /** Sequància dos dados **/
          ttDados.p-image        = iImage               /** N£mero da imagem do registro **/
          ttDados.r-rowid        = rRowid               /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai = cCodPai              /** C¢digo do pai do registro **/
          ttDados.un             = cUN.
end.

assign cCodPai = ttDados.cod-dimensao.

if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

if dePadrao > 0 then do:
    /** Calcula apenas para registros **/
    assign ttDados.uso-real    = ttDados.uso-real   + deVida
           ttDados.uso-padrao  = ttDados.uso-padrao + dePadrao
           ttDados.diferenca   = ttDados.uso-real   - ttDados.uso-padrao
           ttDados.iPrazo      = iPrazo
           ttDados.perc-desvio = (ttDados.diferenca / ttDados.uso-padrao) * 100.

  case iPrazo:
      when 1 then assign ttDados.iAntes  = ttDados.iAntes  + 1.
      when 2 then assign ttDados.iDentro = ttDados.iDentro + 1.
      when 3 then assign ttDados.iApos   = ttDados.iApos   + 1.
  end case.
end.

assign ttDados.quantidade  = ttDados.quantidade + deQuantidade
       ttDados.valor       = ttDados.valor      + deValor.
           
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
       ttVisao.sequencia = 1.
create ttVisao.
assign ttVisao.dimensao =  '02 ' + fnLabels(2)
       ttVisao.sequencia = 2.
create ttVisao.
assign ttVisao.dimensao =  '03 ' + fnLabels(3)
       ttVisao.sequencia = 3.
create ttVisao.
assign ttVisao.dimensao =  '04 ' + fnLabels(4)
       ttVisao.sequencia = 4.
create ttVisao.
assign ttVisao.dimensao =  '07 ' + fnLabels(7)
       ttVisao.sequencia = 5.

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
define variable iSeqOr     as integer   no-undo.
define variable cDimOr     as character no-undo.
define variable cPai       as character no-undo.
define variable iUltimo    as integer   no-undo.

for last ttVisao no-lock:
    assign iUltimo = ttVisao.sequencia.
end.
/** Guarda rowid do tree-view **/
assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
/** Busca Registro **/
for first ttDados
    where rowid(ttDados) = rRowid no-lock:
    assign iSequencia = ttDados.sequencia
           cDimensao  = ttDados.cod-dimensao
           iSeqOr     = ttDados.sequencia   
           cDimOr     = ttDados.cod-dimensao
           cPai       = ttDados.cod-dimens-pai.
end.
if iSequencia + 2 > iUltimo then do:
    for first ttDados
        where ttDados.cod-dimensao = cPai no-lock:
        assign iSequencia = ttDados.sequencia
               cDimensao  = ttDados.cod-dimensao.
    end.
end.
if avail ttDados then do:
    assign {&window-name}:sensitive = no.
    run abp/ab0613d.w (input table ttdados,
                       input iSequencia,
                       input cDimensao,
                       input iSeqOr,
                       input cDimOr,
                       input iUltimo,
                       ttSelecao.lTipo).
    assign {&window-name}:sensitive = yes.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tituloBrowse wWindow 
PROCEDURE tituloBrowse :
/*------------------------------------------------------------------------------
  Purpose:     labelBrowse
  Parameters:  entrada pImagem = N£mero da imagem da vis∆o
  Notes:       Coloca o label no browse conforme escolha
------------------------------------------------------------------------------*/
define input parameter pImagem as integer no-undo.

IF NOT AVAIL ttSelecao THEN
    FIND FIRST ttSelecao NO-LOCK NO-ERROR.

assign ttDados.desc-dimensao:visible in browse brDetalhe = yes
       ttDados.quantidade:visible in browse brDetalhe    = yes
       ttDados.valor:visible in browse brDetalhe         = yes
       ttDados.uso-real:visible in browse brDetalhe      = yes
       ttDados.uso-padrao:visible in browse brDetalhe    = yes
       ttDados.diferenca:visible in browse brDetalhe     = yes
       ttDados.un:visible in browse brDetalhe            = yes
       ttDados.perc-desvio:visible in browse brDetalhe   = yes
       cPrazo:visible in browse brDetalhe                = yes.

ASSIGN brDetalhe:title in frame fPage0 = fnLabels(pImagem).

if ttDados.sequencia < iVisao then assign lReal = NO.
                              else assign lReal = YES.

if pImagem = 7 then
    assign ttDados.desc-dimensao:visible in browse brDetalhe = no.

if not(lReal) THEN DO:
    assign ttDados.uso-real:visible in browse brDetalhe    = no
           ttDados.quantidade:visible in browse brDetalhe  = no
           ttDados.valor:visible in browse brDetalhe       = no
           ttDados.uso-padrao:visible in browse brDetalhe  = no
           ttDados.diferenca:visible in browse brDetalhe   = no
           ttDados.un:visible in browse brDetalhe          = no
           ttDados.perc-desvio:visible in browse brDetalhe = no
           cPrazo:visible in browse brDetalhe              = no.
END.
/* validaá∆o para nao n∆o mostrar colunas a mais caso usuario abrir a tela de filtro e cancelar a tela. **/
ELSE DO: 
    assign ttDados.quantidade:visible in browse brDetalhe  = no
           ttDados.valor:visible in browse brDetalhe       = no.
END.

/** if avail para nao dar erro caso usuario abrir a tela de filtro e cancelar a tela. **/
IF AVAIL ttSelecao THEN DO:
    if ttSelecao.ltipo = 2 THEN DO:
        assign ttDados.uso-real:visible in browse brDetalhe    = no
               ttDados.uso-padrao:visible in browse brDetalhe  = no
               ttDados.diferenca:visible in browse brDetalhe   = no
               ttDados.un:visible in browse brDetalhe          = no
               ttDados.perc-desvio:visible in browse brDetalhe = no
               cPrazo:visible in browse brDetalhe              = NO
               ttDados.quantidade:visible in browse brDetalhe  = YES
               ttDados.valor:visible in browse brDetalhe       = YES.
    END.
    ELSE DO:
        assign ttDados.quantidade:visible in browse brDetalhe  = no
               ttDados.valor:visible in browse brDetalhe       = no
               ttDados.uso-real:visible in browse brDetalhe    = YES
               ttDados.uso-padrao:visible in browse brDetalhe  = YES
               ttDados.diferenca:visible in browse brDetalhe   = YES
               ttDados.un:visible in browse brDetalhe          = YES
               ttDados.perc-desvio:visible in browse brDetalhe = YES
               cPrazo:visible in browse brDetalhe              = YES.
    END.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnLabels
    Notes:  Busca a label da imagem pasada
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

    /** T°tulo do browse **/
    {abp/ab0613.i2 pImage}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPrazo wWindow 
FUNCTION fnPrazo RETURNS CHARACTER
  ( iPrazo as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnPrazo
    Notes:  Busca descriá∆o do prazo
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

case iPrazo:
    when 0 then do:
        {utp/ut-liter.i " "}
    end.
    when 1 then do:
        {utp/ut-liter.i "Antes"}
    end.
    when 2 then do:
        {utp/ut-liter.i "Dentro"}
    end.
    when 3 then do:
        {utp/ut-liter.i "Ap¢s"}
    end.
end case.

assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

