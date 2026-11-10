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

{include/i-prgvrs.i AB0612 2.00.00.011 } /*** "010011" 13/06/2023 13:51:13  ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0612 MAB}
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
&GLOBAL-DEFINE Program        AB0612
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              btImprimir btRedimensiona brDetalhe

/* Local Variable Definitions ---                                       */
define variable c-arquivo     as character                no-undo.
define variable i-cont        as integer                  no-undo.
define variable iOrig         as integer                  no-undo.
define variable iVisao        as integer                  no-undo.
define variable cUN           as character                no-undo.
define variable cComp         as character                no-undo.
define variable cEvento       as character                no-undo.
define variable lReal         as logical                  no-undo.
/* Acompanhamento */
define variable hAcomp        as handle                   no-undo.
/** Busca Valor **/
define variable rRowid        as rowid                    no-undo.
define variable cCodPai       as character format "x(20)" no-undo.
define variable vCodigo       as character format "x(20)" no-undo.
define variable vDescricao    as character format "x(32)" no-undo.
define variable iImage        as integer                  no-undo.
DEFINE VARIABLE cTag          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cCCCodigo     AS CHARACTER                NO-UNDO.

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
define variable lVencer       as logical                  no-undo.
define variable lVencido      as logical                  no-undo.
define variable deReal        as decimal                  no-undo.
define variable dePadrao      as decimal                  no-undo.
define variable cCodPlano     as char                     no-undo.
define variable cDescPlano    as char                     no-undo.
DEFINE VARIABLE dVencimento   AS DATE FORMAT "99/99/9999" NO-UNDO.

define variable lListar as logical no-undo.
define buffer bfKM for mab-movto-km-eqpto.

/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.

/** Dados **/
def temp-table ttDados no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(20)"
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field num-docto         like mab-movto-km-eqpto.num-docto
    field uso-real          as   decimal format "->>,>>>,>>9.9"
    field uso-padrao        as   decimal format "->>>,>>>,>>9.9"
    field diferenca         as   decimal format "->>,>>>,>>9.9"
    field un                as   character format "x(3)"
    field lVencido          as   logical
    field lVencer           as   logical
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    FIELD dat-vencimento    AS   DATE FORMAT "99/99/9999"
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.

define buffer bfttDados for ttDados.
{abp/ab0612.i}  /** Definiá∆o da temp-table de parÉmetros **/

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
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttDados.cod-oficial ttDados.desc-dimensao ttDados.uso-real ttDados.uso-padrao ttDados.diferenca ttDados.un ttDados.num-docto ttDados.dat-vencimento   
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
btExpande btParam btFiltro btVisao btComp btImprimir btQueryJoins ~
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
       MENU-ITEM miEvento       LABEL "E&ventos"       ACCELERATOR "CTRL-N"
       MENU-ITEM miCompart      LABEL "Compar&timentos" ACCELERATOR "CTRL-T"
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
     IMAGE-UP FILE "image\im-open":U
     IMAGE-INSENSITIVE FILE "image\ii-open":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Abrir"
     FONT 4.

DEFINE BUTTON btComp 
     IMAGE-UP FILE "image/mab-eqpto.bmp":U
     LABEL "Equipamento" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Equipamento".

DEFINE BUTTON btEvento 
     IMAGE-UP FILE "image/im-mov.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mov.bmp":U
     LABEL "Eventos" 
     SIZE 4 BY 1.25 TOOLTIP "Eventos".

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
      ttDados.cod-oficial      width 20
ttDados.desc-dimensao    width 30
ttDados.uso-real         width 12
ttDados.uso-padrao       width 12
ttDados.diferenca        width 12
ttDados.un               width 03
ttDados.num-docto        width 15
ttDados.dat-vencimento   WIDTH 10
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
     btEvento AT ROW 1.13 COL 59 HELP
          "Eventos"
     btComp AT ROW 1.13 COL 63
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

/* SETTINGS FOR BUTTON btEvento IN FRAME fpage0
   NO-ENABLE                                                            */
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
           btEvento:column in frame fPage0         = (btEvento:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 + dXC)
           btComp:column in frame fPage0           = (btComp:column in frame fPage0 + dXC)
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
           btEvento:column in frame fPage0         = (btEvento:column in frame fPage0 - dXC)
           btComp:column in frame fPage0           = (btComp:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 - dXC)
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


&Scoped-define SELF-NAME btComp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btComp wWindow
ON CHOOSE OF btComp IN FRAME fpage0 /* Equipamento */
OR CHOOSE OF MENU-ITEM miCompart  IN MENU mbMain DO:
    
    if oTreeList:hasNode() then
        run piCompartimento in this-procedure.
    
    apply "ENTRY":U to btComp in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEvento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEvento wWindow
ON CHOOSE OF btEvento IN FRAME fpage0 /* Eventos */
OR CHOOSE OF MENU-ITEM miEvento  IN MENU mbMain DO:
    
    if oTreeList:hasNode() then do:
        run piEvento in this-procedure.
    end.
    
    apply "ENTRY":U to btEvento in frame fPage0.
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
        /** Controla expans o **/
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
  run abp/ab0612a.w (input-output  table ttSelecao).
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
    
    if oTreeList:hasNode() then
        run piImprimir in this-procedure.
    
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miSelecao  IN MENU mbMain DO:
    
  assign {&window-name}:sensitive = no.
  run abp/ab0612c.w (input-output  table ttSelecao).
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
                         ttSelecao.cc-ini
                         ttSelecao.cc-fim
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
                         ttSelecao.lVencido  
                         ttSelecao.lAVencer  
                         ttSelecao.lOutros
                         ttselecao.lServico
                         ttSelecao.iPlano
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
                     ttSelecao.grupo-ini    
                     ttSelecao.grupo-fim    
                     ttSelecao.modelo-ini   
                     ttSelecao.modelo-fim   
                     ttSelecao.estab-ini    
                     ttSelecao.estab-fim    
                     ttSelecao.tag-ini      
                     ttSelecao.tag-fim      
                     ttSelecao.cc-ini
                     ttSelecao.cc-fim
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
                     ttSelecao.lVencido  
                     ttSelecao.lAVencer  
                     ttSelecao.lOutros
                     ttselecao.lServico
                     ttSelecao.iPlano.
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
  run abp/ab0612b.w (input-output table ttVisao).
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
{abp/ab9000.i}    /** C†lculos de Tempo **/

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
{utp/ut-liter.i "Documento"}
assign ttDados.num-docto:label in browse brDetalhe = return-value.
{utp/ut-liter.i "Vencimento"}
assign ttDados.dat-vencimento:label in browse brDetalhe = return-value.

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

oTreeList:browseTreeList:POPUP-MENU = pop-menu.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alterDestroyInterface wWindow 
PROCEDURE alterDestroyInterface :
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
    open query brDetalhe for each  ttDados
                             where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock
                             by    ttDados.cod-dimensao.
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
assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

create ttSelecao.
ASSIGN &IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.empresa-ini   = ""
       ttSelecao.empresa-fim   = "ZZZ":U
       &ELSE
       ttSelecao.empresa-ini   = 0
       ttSelecao.empresa-fim   = 999
       &ENDIF
       ttSelecao.equipto-ini   = ""
       ttSelecao.equipto-fim   = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.grupo-ini     = ""
       ttSelecao.grupo-fim     = "ZZZZZZZZ"
       ttSelecao.modelo-ini    = ""
       ttSelecao.modelo-fim    = "ZZZZZZZZ"
    &IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.estab-ini     = ""
       ttSelecao.estab-fim     = "ZZZZZ"
    &ELSE
       ttSelecao.estab-ini     = ""
       ttSelecao.estab-fim     = "ZZZ"
    &ENDIF
       ttSelecao.tag-ini       = ""
       ttSelecao.tag-fim       = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.cc-ini        = ""
       ttSelecao.cc-fim        = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.estrut-ini    = ""
       ttSelecao.estrut-fim    = "ZZZZZZZZ"
       ttSelecao.gr-ev-ini     = ""
       ttSelecao.gr-ev-fim     = "ZZZZZZZZ"
       ttSelecao.evento-ini    = ""
       ttSelecao.evento-fim    = "ZZZZZZZZ"
       ttSelecao.comp-ini      = ""        
       ttSelecao.comp-fim      = "ZZZZZZZZ"
       ttSelecao.lAtivos       = yes
       ttSelecao.lInativos     = no
       ttSelecao.lProprios     = yes
       ttSelecao.lTerceiros    = no
       ttSelecao.lMotor        = yes
       ttSelecao.lNMotor       = yes
       ttSelecao.lVencido      = yes
       ttSelecao.lAVencer      = yes
       ttSelecao.lOutros       = yes
       ttSelecao.lServico      = yes
       ttSelecao.iPlano        = 1
    &IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.unid-negoc-ini = "":U
       ttSelecao.unid-negoc-fim = "ZZZ":U
    &ENDIF
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

        /** Habilita Eventos se for Equipamento **/
        CASE    INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")):
            WHEN    2   THEN    ASSIGN  btComp:SENSITIVE    IN  FRAME   fPage0  =   YES
                                        btEvento:SENSITIVE  IN  FRAME   fPage0  =   NO.
            WHEN    5   THEN    ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   YES
                                        btComp:SENSITIVE    IN  FRAME   fPage0  =   NO.
            OTHERWISE
                ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   NO
                        btComp:SENSITIVE    IN  FRAME   fPage0  =   NO.
        END CASE.

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
            CASE    ttDados.p-image:
                WHEN    2   THEN    ASSIGN  btComp:SENSITIVE    IN  FRAME   fPage0  =   YES.
                WHEN    5   THEN    ASSIGN  btEvento:SENSITIVE  IN  FRAME   fPage0  =   YES.
            END CASE.
        END.
        IF  AVAIL   ttDados THEN    DO:
            /** Mostra registros no browse **/
            RUN atualizaBrowse      IN  THIS-PROCEDURE.
        END.

        ASSIGN  exp-con:LABEL   =   IF  oTreeList:getDataLog(oTreeList:currentCode,"lExpande")  THEN cContrai
                                                                                                ELSE cExpande.
    END.

    RETURN  "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaKm wWindow 
PROCEDURE BuscaKm :
/*------------------------------------------------------------------------------
  Purpose:     buscaKM
  Parameters:  entrada pEmp       = C¢digo da Empresa
               entrada pEqpto     = C¢digo do Equipamento
               entrada pInvertida = Data/Hora Invertida
               sa°da   pKM        = Valor da Quilometragem na data
  Notes:       Busca a quilometragem do equipamento em uma data
------------------------------------------------------------------------------*/
define input  parameter pEmp       LIKE mab-eqpto.ep-codigo no-undo.
define input  parameter pEqpto     LIKE mab-eqpto.cod-eqpto no-undo.
define input  parameter pInvertida LIKE mab-movto-km-eqpto.val-dat-hora-invrtda no-undo.
define output parameter pKM        as decimal   no-undo.

/** Busca Quilometragem do Hist¢rico **/
if can-find(first mab-movto-km-eqpto
            where mab-movto-km-eqpto.ep-codigo             = pEmp
            and   mab-movto-km-eqpto.cod-eqpto             = pEqpto
            and   mab-movto-km-eqpto.val-dat-hora-invrtda <= pInvertida no-lock) then do:
    for last  mab-movto-km-eqpto fields(val-km-real)
        where mab-movto-km-eqpto.ep-codigo             = pEmp
        and   mab-movto-km-eqpto.cod-eqpto             = pEqpto
        and   mab-movto-km-eqpto.val-dat-hora-invrtda <= pInvertida no-lock:
        assign pKM = mab-movto-km-eqpto.val-km-real.
    end.
end.
else do:
    /** Utiliza Quilometragem Inicial **/
    assign pKM = mab-eqpto.val-km-inicial.
end.

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
    /** Empresa **/
    when "01":U then do:
        if not avail empresa or empresa.ep-codigo <> mab-eqpto.ep-codigo then do:
            for first empresa fields(nome ep-codigo)  
                where empresa.ep-codigo = mab-eqpto.ep-codigo no-lock:
            end.
        end.
        if AVAIL empresa then do:
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = mab-eqpto.ep-codigo
        &else
            assign vCodigo    = string(mab-eqpto.ep-codigo, "999")
        &endif
           vDescricao = empresa.nome
           iImage     = 1
           rRowid     = rowid(empresa).
        end.
        ELSE DO:
            {utp/ut-liter.i "Empresa n∆o encontrada"}
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = mab-eqpto.ep-codigo
        &ELSE
            assign vCodigo    = string(mab-eqpto.ep-codigo, "999")
        &ENDIF
                   vDescricao = RETURN-VALUE
                   iImage     = 1
                   rRowid     = rowid(mab-eqpto).
        END.
    end.
    /** Equipamento **/
    when "02":U then do:
        assign vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
               iImage     = 2
               rRowid     = rowid(mab-eqpto).
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model un)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
            {utp/ut-liter.i "Dia"}
            assign vDescricao = mab-model.des-model
                   cUN        = if iOrig = 3 then return-value else mab-model.un.
        end.
    end.
    /** Modelo Equipamento **/
    when "03":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model un)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
            assign vCodigo    = mab-eqpto.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 3
                   rRowid     = rowid(mab-model).
        end.         
    end.
    /** Compartimento / Filtro / SubSistema **/
    when "04":U then do:
        /** Eventos Vencidos Normais **/
        if iOrig = 1 then do:
            if not avail mab-comptmento or mab-comptmento.cod-comptmento <> cComp then do:
                for first mab-comptmento fields(des-comptmento cod-comptmento)  
                    where mab-comptmento.cod-comptmento = cComp no-lock:
                end.
            end.
            if avail mab-comptmento then do:
                assign vCodigo    = cComp
                       vDescricao = mab-comptmento.des-comptmento
                       iImage     = 4
                       rRowid     = rowid(mab-comptmento).
            end.
        end.
        /** Outros Eventos **/
        else do:
            if not avail mab-sub-sist or mab-sub-sist.cod-sub-sist <> cComp then do:
                for first mab-sub-sist fields(des-sub-sist cod-sub-sist)  
                    where mab-sub-sist.cod-sub-sist = cComp no-lock:
                end.
            end.
            if avail mab-sub-sist then do:
                assign vCodigo    = cComp
                       vDescricao = mab-sub-sist.des-sub-sist
                       iImage     = 4
                       rRowid     = rowid(mab-sub-sist).
            end.
            /** Se n∆o estiver associado a um Sub-Sistema, inclui n°vel somente como evento **/
            else do:
                if not avail mab-event or mab-event.cod-evento <> cEvento then
                    for first mab-event fields(des-evento cod-evento cod-grp-event)  
                        where mab-event.cod-evento = cEvento no-lock:
                    end.
                if avail mab-event then do:
                    if not avail mab-grp-event or mab-grp-event.cod-grp-event <> mab-event.cod-grp-event then
                        for first mab-grp-event fields(cod-grp-event des-grp-event) 
                            of    mab-event no-lock:
                        end.
                    if avail mab-grp-event then
                        assign vCodigo    = "_":U + mab-grp-event.cod-grp-event
                               vDescricao = mab-grp-event.des-grp-event
                               iImage     = 4
                               rRowid     = rowid(mab-grp-event).
                end.
            end.
        end.

        /* Quando evento estiver relacionado a um plano de manutená∆o, a descriá∆o do sub-sistema ser† a descriá∆o do Plano */
        if cCodPlano <> " " then assign vCodigo    = cCodPlano
                                        vDescricao = cDescPlano.

    end.
    /** Evento **/
    when "05":U then do:
        if not avail mab-event or mab-event.cod-evento <> cEvento then do:
            for first mab-event fields(des-evento cod-evento cod-grp-event)
                where mab-event.cod-evento = cEvento no-lock:
            end.
        end.
        if avail mab-event then do:
            assign vCodigo    = cEvento
                   vDescricao = mab-event.des-evento
                   iImage     = 5
                   rRowid     = rowid(mab-event).
            
            IF AVAIL mab-movto-event THEN ASSIGN vCodigo = cEvento + "-" + STRING(mab-movto-event.num-docto).
        end.        

    end.
    /** Estabelecimento **/
    when "06":U then do:
        if not avail estabelec or estabelec.cod-estabel <> mab-eqpto.cod-estabel then do:
            for first estabelec fields(nome cod-estabel)  
                where estabelec.cod-estabel = mab-eqpto.cod-estabel no-lock:
            end.
        end.
        if avail estabelec then do:
            assign vCodigo    = mab-eqpto.cod-estabel
                   vDescricao = estabelec.nome
                   iImage     = 6
                   rRowid     = rowid(estabelec).
        end.
        ELSE DO:
            {utp/ut-liter.i "Estabelecimento n∆o encontrado"}
            assign vCodigo    = mab-eqpto.cod-estabel
                   vDescricao = RETURN-VALUE
                   iImage     = 6
                   rRowid     = rowid(mab-eqpto).
        END.
    end.

    /** Grupo Evento **/
    when "07":U then do:
        if not avail mab-event or mab-event.cod-evento <> cEvento then do:
            for first mab-event fields(des-evento cod-evento cod-grp-event)
                where mab-event.cod-evento = cEvento no-lock:
            end.
        end.
        if not avail mab-grp-event or mab-grp-event.cod-grp-event <> mab-event.cod-grp-event then do:
            for first mab-grp-event fields(des-grp-event cod-grp-event)
                where mab-grp-event.cod-grp-event = mab-event.cod-grp-event no-lock:
            end.
        end.
        if avail mab-grp-event then do:
            assign vCodigo    = mab-grp-event.cod-grp-event
                   vDescricao = mab-grp-event.des-grp-event
                   iImage     = 7
                   rRowid     = rowid(mab-grp-event).
        end.        
    end.
    /** TAG **/
    WHEN "08":U THEN DO:
        IF NOT AVAIL tag OR tag.cd-tag <> cTag THEN DO:
            FOR FIRST tag WHERE
                tag.cd-tag = cTag NO-LOCK:
            END.
        END.
        IF AVAIL tag THEN DO:
            ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                   iImage     = 8
                   rRowid     = ROWID(tag)
                   vDescricao = tag.descricao.
        END.
        ELSE DO:
            {utp/ut-liter.i Tag_N∆o_Dispon°vel}
                ASSIGN vCodigo    = IF cTag = "" THEN "_" ELSE cTag
                       vDescricao = RETURN-VALUE
                       iImage     = 8
                       rRowid     = ROWID(mab-eqpto).
        END.
    END.
    /** Centro Custo **/
    WHEN "09":U THEN DO:
        IF NOT AVAIL tt_ccusto_integr OR tt_ccusto_integr.ttv_cod_ccusto <> cCCCodigo THEN DO:
            FOR FIRST tt_ccusto_integr
                WHERE tt_ccusto_integr.ttv_cod_ccusto = cCCCodigo NO-LOCK:
            END.
        END.
        IF AVAIL (tt_ccusto_integr) THEN DO:
            ASSIGN vCodigo = cCCCodigo
                   vDescricao   = tt_ccusto_integr.ttv_des_titulo
                   iImage       = 9
                   rRowid       = ROWID(tt_ccusto_integr).
        END.
        ELSE DO:
            {utp/ut-liter.i "Centro_Custo_N∆o_Dispon°vel"}
            ASSIGN vCodigo      = IF cCCCodigo = "" THEN "_" ELSE cCCCodigo
                   vDescricao   = RETURN-VALUE
                   iImage       = 9
                   rRowid       = ROWID(mab-eqpto).
        END.
    END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "10" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-eqpto.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-eqpto.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 10
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 10
                           rRowid     = ROWID(mab-eqpto).
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
    assign c-linha                  = replace (c-linha, chr(34), "")
      &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.empresa-ini    = entry(1,c-linha,";")
           ttSelecao.empresa-fim    = entry(2,c-linha,";")
      &ELSE
           ttSelecao.empresa-ini    = int(entry(1,c-linha,";"))
           ttSelecao.empresa-fim    = int(entry(2,c-linha,";"))
      &ENDIF
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
           ttSelecao.cc-ini         = entry(13,c-linha,";")          
           ttSelecao.cc-fim         = entry(14,c-linha,";")          
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
           ttSelecao.lVencido       = (entry(29,c-linha,";") = "yes")   
           ttSelecao.lAVencer       = (entry(30,c-linha,";") = "yes")   
           ttSelecao.lOutros        = (entry(31,c-linha,";") = "yes")
           ttSelecao.lServico       = (entry(32,c-linha,";") = "yes")
           ttSelecao.iPlano         = int(entry(33,c-linha,";")).

    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN ttSelecao.unid-negoc-ini = entry(34,c-linha,";")
                   ttSelecao.unid-negoc-fim = entry(35,c-linha,";").
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
     oTreeList:addNode("", "i" + string(i-cont), string(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao).
     /** Guarda chave (rowid) da temp-table no tree-view **/
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
          /** Inclui linhas das vis‰es filhas **/
          oTreeList:addNode ("i" + string(bfttDados.seq-tree), "i" + string(i-cont), string(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao).
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
DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run piCriaVisao in this-procedure.
end.

/** Busca ParÉmetros **/
find first ttSelecao no-lock no-error.
if not avail ttSelecao then return "NOK":U.

empty temp-table ttDados.
{&OPEN-QUERY-brDetalhe}

assign iVisao = 0.
for first ttVisao 
    where substring(ttVisao.dimensao,1,2) = "05":U no-lock:
    assign iVisao = ttVisao.sequencia.
end.

/** Acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
{utp/ut-liter.i "Vencidos_e_A_Vencer"}
RUN pi-inicializar IN hAcomp (trim(return-value)).
blk_ab0612:
DO on stop undo, return "NOK":U:
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
        and   mab-eqpto.cd-tag            >= ttSelecao.tag-ini
        and   mab-eqpto.cd-tag            <= ttSelecao.tag-fim
        and   mab-eqpto.cc-codigo         >= ttSelecao.cc-ini
        and   mab-eqpto.cc-codigo         <= ttSelecao.cc-fim
        and   mab-eqpto.cod-estrut-mec    >= ttSelecao.estrut-ini
        and   mab-eqpto.cod-estrut-mec    <= ttSelecao.estrut-fim
        and   mab-eqpto.cod-grp-eqpto     >= ttSelecao.grupo-ini
        and   mab-eqpto.cod-grp-eqpto     <= ttSelecao.grupo-fim
        and  ((mab-eqpto.idi-tip-eqpto    = 1 and ttSelecao.lMotor)      /** Motorizados **/
        or    (mab-eqpto.idi-tip-eqpto    = 2 and ttSelecao.lNMotor))    /** N∆o Motorizados **/
        and  ((mab-eqpto.idi-tip-propriet = 1 and ttSelecao.lProprios)   /** Pr¢prios **/
        or    (mab-eqpto.idi-tip-propriet = 2 and ttSelecao.lTerceiros)) /** Terceiros **/
        and  ((mab-eqpto.dat-situacao     = ? and ttSelecao.lAtivos)     /** Ativos **/
        or    (mab-eqpto.dat-situacao    <> ? and ttSelecao.lInativos))  /** Inativos **/
        no-lock:

        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-eqpto.cod-unid-negoc >= ttSelecao.unid-negoc-ini  AND 
                       mab-eqpto.cod-unid-negoc <= ttSelecao.unid-negoc-fim) THEN NEXT.
            END.
        &ENDIF

       assign cTag      = mab-eqpto.cd-tag
              cCCCodigo = mab-eqpto.cc-codigo.
    
        if cTag      < ttSelecao.tag-ini or cTag      > ttSelecao.tag-fim then next.
        if cCCCodigo < ttSelecao.cc-ini  or cCCCodigo > ttSelecao.cc-fim  then next.
    
        /** Acompanhamento **/
        {utp/ut-liter.i "Lendo Equipamento"}
        RUN pi-Acompanhar IN hAcomp (RETURN-VALUE + ": " + STRING(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto).
    
        assign cCodPlano   = " "
               cDescPlano  = " "
               dVencimento = DATE(" ").
    
        if ttSelecao.lVencido or ttSelecao.lAVencer then do:
            /** Busca fichas de abastecimento e lubrificaá∆o **/
            RUN piFichaAbastecimento IN THIS-PROCEDURE.
        end.
        
        ASSIGN dVencimento = DATE(" ").
        /** Verifica se imprime outros eventos **/
        if ttSelecao.lOutros then do:
            RUN piOutrosEventos IN THIS-PROCEDURE.
        end.
    
        ASSIGN dVencimento = DATE(" ").
        /* Verifica se h† planos de Manutená∆o Preventiva Vencidos, ignorando calend†rio da manutená∆o */
        if ttSelecao.iPlano = 1 then do:
            RUN piManutencaoPreventiva IN THIS-PROCEDURE.
        end.
    
        ASSIGN dVencimento = DATE(" ").
        /* Verifica se h† calend†rio da manutená∆o , ignorando o per°odo de vencimento dos planos de manutená∆o */
        /* Busca apenas equipamentos vencidos para o dia atual (today) n∆o verificando equipamentos planejados  */
        /* para dia anterior e n∆o realizados.                                                                  */
        if ttSelecao.iPlano = 2 then do:
            RUN piCalendarioManutencao IN THIS-PROCEDURE.
        end.
        
        ASSIGN dVencimento = DATE(" ").
        /* Verifica se h† planos de Manutená∆o Preventiva Vencidos, ignorando calend†rio da manutená∆o */
        if ttSelecao.lservico = TRUE then do:
            RUN piServico IN THIS-PROCEDURE.
        end.
    
    end. /** mab-eqpto **/
    
    RUN pi-Finalizar IN hAcomp.
end.


/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalendarioManutencao wWindow 
PROCEDURE piCalendarioManutencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /** Busca fichas de abastecimento e lubrificaá∆o **/
        for each  mmv-eqpto-calend-plano
            where mmv-eqpto-calend-plano.ep-codigo       = mab-eqpto.ep-codigo
            and   mmv-eqpto-calend-plano.cod-eqpto       = mab-eqpto.cod-eqpto
            and   mmv-eqpto-calend-plano.dat-movto       = today no-lock:

            if not avail mmv-plano-prevent or 
               mmv-plano-prevent.cod-model <> mab-eqpto.cod-model or 
               mmv-plano-prevent.cod-plano <> mmv-eqpto-calend-plano.cod-plano then do:
               for first mmv-plano-prevent fields(cod-model cod-plano des-plano cod-evento cod-sub-sist val-km-padr val-km-aviso vli-dia vli-dia-aviso)
                    where mmv-plano-prevent.cod-model  = mab-eqpto.cod-model
                      and mmv-plano-prevent.cod-plano  = mmv-eqpto-calend-plano.cod-plano     
                      and mmv-plano-prevent.cod-event >= ttSelecao.evento-ini 
                      and mmv-plano-prevent.cod-event <= ttSelecao.evento-fim no-lock:
               end.
            end.
            if not avail mmv-plano-prevent then next.
            
            assign cCodPlano = "MV ":U + mmv-plano-prevent.cod-plano  
                   cDescPlano = mmv-plano-prevent.des-plano.


            if not avail mab-event or mab-event.cod-evento <> mmv-plano-prevent.cod-evento then do:
                for first mab-event fields(des-evento cod-evento cod-grp-event)
                    where mab-event.cod-evento     = mmv-plano-prevent.cod-evento 
                    and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini 
                    and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
                end.
            end.

            /** Verifica se evento foi encontrado **/
            if not avail mab-event then next.

            assign lVencido = yes
                   deReal   = 0
                   dePadrao = 0
                   iOrig    = 3
                   dVencimento = TODAY.
            

            /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
            assign cCodPai  = ""
                   cComp    = mmv-plano-prevent.cod-sub-sist  /* Sub-Sistema do Plano trabalha como Compartimento */
                   cEvento  = mmv-plano-prevent.cod-evento.
                   
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
          ttDados.cod-oficial    = vCodigo              /** C¢digo Original do registro **/
          ttDados.desc-dimensao  = vDescricao           /** Descriá∆o do c¢digo **/
          ttDados.sequencia      = ttVisao.sequencia    /** Sequància dos dados **/
          ttDados.p-image        = iImage               /** N£mero da imagem do registro **/
          ttDados.r-rowid        = rRowid               /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai = cCodPai              /** C¢digo do pai do registro **/
          ttDados.lVencido       = lVencido
          ttDados.lVencer        = lVencer
          ttDados.un             = cUN
          ttDados.dat-vencimento = dVencimento.
end.

assign cCodPai = ttDados.cod-dimensao.

if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

/** Calcula apenas para registros da vis∆o evento para baixo **/
if lReal then do:
    assign ttDados.uso-real   = ttDados.uso-real   + deReal
           ttDados.uso-padrao = ttDados.uso-padrao + dePadrao
           ttDados.diferenca  = ttDados.uso-real   - ttDados.uso-padrao
           ttDados.num-docto  = if avail mab-movto-event 
                                then mab-movto-event.num-docto 
                                else 0. 
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCompartimento wWindow 
PROCEDURE piCompartimento :
/*------------------------------------------------------------------------------
  Purpose:     piCompartimento
  Parameters:  <none>
  Notes:       Chama consulta de compartimentos do equipamento.
------------------------------------------------------------------------------*/
/** Verifica se n°vel selecionado Ç Equipamento **/
if INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")) = 2 then do:
    /** Guarda rowid do tree-view **/
    assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
    for first ttDados
        where rowid(ttDados) = rRowid no-lock:
        assign rRowid = ttDados.r-rowid.
    end.
end.
else do:
    get current brDetalhe no-lock.
    if ttDados.p-image = 2 then
        assign rRowid = ttDados.r-rowid.
end.


/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.

/*--- Executa programa de inclus∆o de filho ---*/
RUN abp/ab0602c.w (input ?,
                   input rRowid,
                   input this-procedure).

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
assign {&window-name}:sensitive = yes.

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
assign ttVisao.dimensao =  '04 ' + fnLabels(4)
       ttVisao.sequencia = 3.
create ttVisao.
assign ttVisao.dimensao =  '05 ' + fnLabels(5)
       ttVisao.sequencia = 4.


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
DEFINE VARIABLE iDoc    AS INTEGER    NO-UNDO.
DEFINE VARIABLE hEvento AS HANDLE     NO-UNDO.

if INTEGER(oTreeList:getDataInt(oTreeList:currentCode, "p-image")) = 5 then do: 
/** Guarda rowid do tree-view **/
assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")). 
    for first ttDados
        where rowid(ttDados) = rRowid no-lock:
        assign iDoc = ttDados.num-docto.

    end.
end.
else do:
  get current brDetalhe no-lock.
 if ttDados.p-image = 5 then 
  assign iDoc = ttDados.num-docto.
end.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
RUN abp/ab0303.w PERSISTENT SET hEvento.

/* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
/*IF VALID-HANDLE(hEvento) AND
   hEvento:Type = "PROCEDURE":U AND
   hEvento:FILE-NAME = "abp~\ab0303.w":U THEN */

/*--- Inicializa programa de inclus∆o de filho ---*/
IF VALID-HANDLE(hEvento) THEN 
    RUN initializeInterface IN hEvento.


RUN piReposiciona in hEvento (input iDoc).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFichaAbastecimento wWindow 
PROCEDURE piFichaAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each  mab-period-manut
    where mab-period-manut.ep-codigo       = mab-eqpto.ep-codigo
    and   mab-period-manut.cod-eqpto       = mab-eqpto.cod-eqpto
    and   mab-period-manut.cod-comptmento >= ttSelecao.comp-ini
    and   mab-period-manut.cod-comptmento <= ttSelecao.comp-fim
    and   mab-period-manut.cod-evento     >= ttSelecao.evento-ini
    and   mab-period-manut.cod-evento     <= ttSelecao.evento-fim no-lock:

    if not avail mab-event or mab-event.cod-evento <> mab-period-manut.cod-evento then do:
        for first mab-event fields(des-evento cod-evento cod-grp-event)
            where mab-event.cod-evento     = mab-period-manut.cod-evento 
            and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini 
            and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
        end.
    end.

    /** Verifica se evento foi encontrado **/
    if not avail mab-event then next.

    /** Evento n∆o est† vencido e nem est† a vencer **/
    if (mab-period-manut.val-km-real + mab-period-manut.val-km-estimad) < mab-period-manut.val-km-padr then next.

    assign lVencido = no
           lVencer  = no.
    /** Verifica se registro est† vencido **/
    if (mab-period-manut.val-km-real >= mab-period-manut.val-km-padr) then do:
        if not(ttSelecao.lVencido) then next.
        else assign lVencido = yes.
    end.
    
    /** Verifica se registro est† a vencer **/
    if not(lVencido) then
        if (mab-period-manut.val-km-real < mab-period-manut.val-km-padr) 
        and ((mab-period-manut.val-km-real + mab-period-manut.val-km-estimad) >= mab-period-manut.val-km-padr) then do:
            if not(ttSelecao.lAVencer) then next.
            else assign lVencer = yes.
        end.

        /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
        assign cCodPai  = ""
               cComp    = mab-period-manut.cod-comptmento
               cEvento  = mab-period-manut.cod-evento
               deReal   = mab-period-manut.val-km-real
               dePadrao = mab-period-manut.val-km-padr
               iOrig    = 1.

        IF lVencido THEN
            dVencimento = TODAY.

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
           cDimensao  = ttDados.cod-dimensao.
end.
if avail ttDados then do:
    assign {&window-name}:sensitive = no.
    run abp/ab0612d.w (input table ttDados,
                       input iSequencia,
                       input cDimensao,
                       input iUltimo).
    assign {&window-name}:sensitive = yes.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piManutencaoPreventiva wWindow 
PROCEDURE piManutencaoPreventiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /** Busca fichas de abastecimento e lubrificaá∆o **/
        for each  mmv-eqpto-plano
            where mmv-eqpto-plano.ep-codigo       = mab-eqpto.ep-codigo
            and   mmv-eqpto-plano.cod-eqpto       = mab-eqpto.cod-eqpto 
            AND   mmv-eqpto-plano.dat-final       > TODAY no-lock:

            if not avail mmv-plano-prevent or 
               mmv-plano-prevent.cod-model <> mab-eqpto.cod-model or 
               mmv-plano-prevent.cod-plano <> mmv-eqpto-plano.cod-plano then do:
               for first mmv-plano-prevent fields(cod-model cod-plano des-plano cod-evento cod-sub-sist val-km-padr val-km-aviso vli-dia vli-dia-aviso)
                    where mmv-plano-prevent.cod-model  = mab-eqpto.cod-model
                      and mmv-plano-prevent.cod-plano  = mmv-eqpto-plano.cod-plano     
                      and mmv-plano-prevent.cod-event >= ttSelecao.evento-ini 
                      and mmv-plano-prevent.cod-event <= ttSelecao.evento-fim no-lock:
               end.
            end.
            if not avail mmv-plano-prevent then next.

            assign cCodPlano  = "MV ":U + mmv-plano-prevent.cod-plano
                   cDescPlano = mmv-plano-prevent.des-plano.

            if not avail mab-event or mab-event.cod-evento <> mmv-plano-prevent.cod-evento then do:
                for first mab-event fields(des-evento cod-evento cod-grp-event)
                    where mab-event.cod-evento     = mmv-plano-prevent.cod-evento 
                    and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini 
                    and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
                end.
            end.

            /** Verifica se evento foi encontrado **/
            if not avail mab-event then next.

            assign lVencido = no
                   lVencer  = no.
            /** Verifica se registro est† vencido **/
            if mmv-plano-prevent.val-km-padr > 0 then do:
                if (mmv-eqpto-plano.val-km-real >= mmv-plano-prevent.val-km-padr) then do:
                    if not(ttSelecao.lVencido) then next.
                    ASSIGN lVencido = yes.
                end.
                /** Verifica se registro est† a vencer **/
                if not(lVencido) then do:
                    if (mmv-eqpto-plano.val-km-real < mmv-plano-prevent.val-km-padr) and
                           ((mmv-eqpto-plano.val-km-real + mmv-plano-prevent.val-km-aviso) >= mmv-plano-prevent.val-km-padr) then do:
                        if not(ttSelecao.lAVencer) then next.
                        assign lVencer = yes.
                    end.
                end.
                assign deReal   = mmv-eqpto-plano.val-km-real
                       dePadrao = mmv-plano-prevent.val-km-padr
                       iOrig    = 2.
            end.
            if mmv-plano-prevent.vli-dia > 0 AND lVencido = NO then do:
                if (today - mmv-eqpto-plano.dat-atualiz >= mmv-plano-prevent.vli-dia) then do:
                    if not(ttSelecao.lVencido) then next.
                    ASSIGN lVencido = yes.
                end.
                /** Verifica se registro est† a vencer **/
                if not(lVencido) AND lVencer = NO then do:
                    if (today - mmv-eqpto-plano.dat-atualiz  < mmv-plano-prevent.vli-dia) and
                           ((today - mmv-eqpto-plano.dat-atualiz + mmv-plano-prevent.vli-dia-aviso) >= mmv-plano-prevent.vli-dia) then do:
                        if not(ttSelecao.lAVencer) then next.
                        assign lVencer = YES
                               deReal   = today - mmv-eqpto-plano.dat-atualiz 
                               dePadrao = mmv-plano-prevent.vli-dia
                               iOrig    = 3.
                    end.
                end.
                IF lVencido THEN
                    assign deReal   = today - mmv-eqpto-plano.dat-atualiz 
                           dePadrao = mmv-plano-prevent.vli-dia
                           iOrig    = 3.
            end.

            /* Quando n∆o encontra Planos Preventiva Vencidos, volta para pr¢ximo registro */
            if not(lVencer) and not(lVencido) then next.


            /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
            assign cCodPai  = ""
                   cComp    = mmv-plano-prevent.cod-sub-sist  /* Sub-Sistema do Plano trabalha como Compartimento */
                   cEvento  = mmv-plano-prevent.cod-evento
                   dVencimento = TODAY.
                   
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOutrosEventos wWindow 
PROCEDURE piOutrosEventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-km-atual         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-km-anterior      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-invrtda-atual    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-invrtda-anterior AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-hora              AS CHARACTER  NO-UNDO.

for each  mab-movto-event
    where mab-movto-event.ep-codigo   = mab-eqpto.ep-codigo
    and   mab-movto-event.cod-eqpto   = mab-eqpto.cod-eqpto
    and   mab-movto-event.cod-evento >= ttSelecao.evento-ini
    and   mab-movto-event.cod-evento <= ttSelecao.evento-fim
    and   mab-movto-event.dat-final   = ? no-lock:
    /** Filtrar o Grupo de Evento **/
    if not avail mab-event or mab-event.cod-evento <> mab-movto-event.cod-evento then do:
        for first mab-event fields(des-evento cod-evento cod-grp-event)
            where mab-event.cod-evento     = mab-movto-event.cod-evento 
            and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini 
            and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
        end.
    end.
    /** Verifica se evento foi encontrado **/
    if not avail mab-event then next.

   assign lListar     = no
          lVencido    = NO
          lVencer     = NO
          dVencimento = mab-movto-event.dat-aviso.
    /** Verifica a data de aviso **/
    if mab-movto-event.dat-aviso <= today then do:
        assign lListar  = yes
               deReal   = today - mab-movto-event.dat-inicial
               dePadrao = mab-movto-event.dat-aviso - mab-movto-event.dat-inicial
               iOrig    = 3
               lVencido = YES.
    end.
   
    /** Busca H-KM **/
    ELSE DO:
        /** Busca a Data/hora Invertida Atual para o C†lculo **/
        run piFormataSegundoParaHora (input  time,
                                      output c-hora).
        run converteParaHoraInvertida (input  string(today,'99/99/9999'),
                                       input  replace(c-hora,":",""),
                                       output de-invrtda-atual).
        /** Busca as Quilometragens do equipamento nas datas do percurso **/
        RUN BuscaKm IN THIS-PROCEDURE (INPUT  mab-eqpto.ep-codigo,
                                       INPUT  mab-eqpto.cod-eqpto,
                                       INPUT  de-invrtda-atual,
                                       OUTPUT de-km-atual).
        /** Calcula data anterior (movimento do evento) **/
        run converteParaHoraInvertida (input  string(mab-movto-event.dat-inicial,'99/99/9999'),
                                       input  replace(mab-movto-event.hra-inicial,":",""),
                                       output de-invrtda-anterior).
        /** Busca as Quilometragens do equipamento nas datas do percurso **/
        RUN BuscaKm IN THIS-PROCEDURE (INPUT  mab-eqpto.ep-codigo,
                                       INPUT  mab-eqpto.cod-eqpto,
                                       INPUT  de-invrtda-anterior,
                                       OUTPUT de-km-anterior).
        if (de-km-atual - de-km-anterior) >= mab-movto-event.val-km-aviso then DO:
            assign lListar  = yes
                   deReal   = de-km-atual - de-km-anterior
                   dePadrao = mab-movto-event.val-km-aviso
                   iOrig    = 2
                   lVencido = YES.
        END.
        ELSE DO:
             IF mab-movto-event.val-km-aviso = 999999 THEN DO:
                ASSIGN lListar = YES
                       deReal   = today - mab-movto-event.dat-inicial
                       dePadrao = mab-movto-event.dat-aviso - mab-movto-event.dat-aviso
                       iOrig    = 3
                       lVencer  = YES.
             END.
             ELSE DO: 
                ASSIGN lListar = YES
                       deReal  = de-km-atual - de-km-anterior
                      dePadrao = mab-movto-event.val-km-aviso
                         iOrig = 2
                       lVencer = YES.
            END.
        END.
    END.  
    if lListar then do: 
        /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
        assign cCodPai  = ""
               cComp    = mab-movto-event.cod-sub-sist
               cEvento  = mab-movto-event.cod-evento.
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

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piServico wWindow 
PROCEDURE piServico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /** Busca fichas de abastecimento e lubrificaá∆o **/
        for each  mpn-eqpto-serv
            where mpn-eqpto-serv.ep-codigo       = mab-eqpto.ep-codigo
            and   mpn-eqpto-serv.cod-eqpto       = mab-eqpto.cod-eqpto 
            and   mpn-eqpto-serv.dat-final      >= today no-lock:
            

            IF NOT AVAIL mpn-serv OR  mpn-serv.cod-servico <> mpn-eqpto-serv.cod-servico THEN DO:
                FOR FIRST mpn-serv FIELDS (cod-servico des-servico cod-evento) 
                    WHERE mpn-serv.cod-servico = mpn-eqpto-serv.cod-servico NO-LOCK:
                END.
            END.
            IF NOT AVAIL mpn-serv THEN NEXT.

            if not avail mab-event or mab-event.cod-evento <> mpn-serv.cod-evento then do:
                for first mab-event fields(des-evento cod-evento cod-grp-event)
                    where mab-event.cod-evento     = mpn-serv.cod-evento
                    and   mab-event.cod-grp-event >= ttSelecao.gr-ev-ini 
                    and   mab-event.cod-grp-event <= ttSelecao.gr-ev-fim no-lock:
                end.
            end.

            /** Verifica se evento foi encontrado **/
            if not avail mab-event then next.

            assign lVencido = no
                   lVencer  = no.
            /** Verifica se registro est† vencido **/
            if mpn-eqpto-serv.num-dias > 0 then do:
                if (today - mpn-eqpto-serv.dat-trans  >= mpn-eqpto-serv.num-dias) then do:
                    lVencido = yes.
                end.
                assign deReal   = today - mpn-eqpto-serv.dat-trans 
                       dePadrao = mpn-eqpto-serv.num-dias
                       iOrig    = 3.
            end.

            /* Quando n∆o encontra Planos Preventiva Vencidos, volta para pr¢ximo registro */
            if not(lVencer) and not(lVencido) then next.

            assign cCodPlano = "PN ":U + mpn-eqpto-serv.cod-serv
                   cDescPlano = mpn-serv.des-servico.

            /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
            assign cCodPai  = ""
                   cComp    = " "
                   cEvento  = mpn-serv.cod-evento
                   dVencimento = (mpn-eqpto-serv.dat-trans + mpn-eqpto-serv.num-dias).
                   
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

assign ttDados.uso-real:visible in browse brDetalhe   = yes
       ttDados.uso-padrao:visible in browse brDetalhe = yes
       ttDados.diferenca:visible in browse brDetalhe  = yes
       ttDados.un:visible in browse brDetalhe         = yes
       ttDados.num-docto:visible in browse brDetalhe  = yes
       ttDados.dat-vencimento:VISIBLE IN BROWSE brDetalhe = YES.

ASSIGN brDetalhe:title in frame fPage0 = fnLabels(pImagem).

if ttDados.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

if not(lReal) then
    assign ttDados.uso-real:visible in browse brDetalhe   = no
           ttDados.uso-padrao:visible in browse brDetalhe = no
           ttDados.diferenca:visible in browse brDetalhe  = no
           ttDados.un:visible in browse brDetalhe         = no
           ttDados.num-docto:visible in browse brDetalhe  = no
           ttDados.dat-vencimento:VISIBLE IN BROWSE brDetalhe = NO.

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
    {abp/ab0612.i2 pImage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

