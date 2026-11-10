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

{include/i-prgvrs.i AB0604 2.00.00.021 } /*** "010021" 16/09/2024 11:31:23 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0604 MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{utp/ut-glob.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AB0604
&GLOBAL-DEFINE Version        2.00.00.021

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btRefresh btFiltro btParam btVisao btExpande ~
                              bt-Pneus bt-Comptes bt-equipto bt-relat-eqpto ~
                              bt-cons-comb bt-remonta bt-reservas bt-histo-vida bt-mov-abast ~
                              bt-mov-evento bt-mov-reserva bt-mov-viagem btImprimir btExcel btTxt ~
                              brDetalhe btRedimensiona fiText-1 fiText-2
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var h-cpapi013 as handle no-undo.
 /***Include de definiá∆o de Temp-Table e buffer***/
{abp/ab0604.i}

def new global shared var gr-mab-eqpto     as rowid no-undo.
def var l-ativos               as log initial yes no-undo.
def var l-motorizados          as log initial yes no-undo.
def var l-proprios             as log initial yes no-undo.
def var l-inativos             as log initial no no-undo.
def var l-n-motorizados        as log initial yes no-undo.
def var l-terceiros            as log initial no no-undo.
def var l-hodometro            as log initial no no-undo.
define variable iVisao         as integer                       no-undo.
define variable cSub           as character                     no-undo.
define variable cEvento        as character                     no-undo.
define variable iManut         as integer                       no-undo.
define variable lReal          as logical                       no-undo.
define variable hHandle        as handle                        no-undo.
DEFINE VARIABLE l-executa      AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE cRowid         as char no-undo.
DEFINE VARIABLE rROWID         AS ROWID      NO-UNDO.
define variable iVisao2        as integer                       no-undo.
DEFINE VARIABLE iVisao3        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iVisaoAux AS INTEGER    NO-UNDO.
/**Controle**/
define variable i      as integer no-undo.
define variable j      as integer no-undo.
define variable i-cont as integer no-undo.
DEF VAR l-tem-combustivel AS LOGICAL NO-UNDO.
DEF VAR c-tipo-mater AS CHAR NO-UNDO.

/** Busca Valor **/                                            
DEF VAR vCodigo AS CHAR FORMAT "x(20)".
DEF VAR vDescricao AS CHAR FORMAT "x(30)".
DEFINE VARIABLE iImage AS INTEGER    NO-UNDO.
DEF VAR cCodPai                AS CHAR FORMAT "X(300)".

/***Vari†veis dos ParÉmetros de seleá∆o e filtro**/
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-ini    LIKE empresa.ep-codigo  init 0                  no-undo.
&ELSE
def var i-empresa-ini    as int  init 0                  no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-fim    LIKE empresa.ep-codigo  init 999                no-undo.
&ELSE
def var i-empresa-fim    as int  init 999                no-undo.
&ENDIF
def var c-equipto-ini    as char init ""                 no-undo.
def var c-equipto-fim    as char init "ZZZZZZZZZZZZZZZZ" no-undo.
def var c-grupo-ini      as char init ""                 no-undo.
def var c-grupo-fim      as char init "ZZZZZZZZ"         no-undo.
def var c-modelo-ini     as char init ""                 no-undo.
def var c-modelo-fim     as char init "ZZZZZZZZ"         no-undo.
def var c-estab-ini      as char init ""                 no-undo.
def var c-estab-fim      as char init "ZZZZZZZZ"         no-undo.
def var c-tag-ini        as char init ""                 no-undo.
def var c-tag-fim        as char init "ZZZZZZZZZZZZZZZZ" no-undo.
def var c-estrut-ini     as char init ""                 no-undo.
def var c-estrut-fim     as char init "ZZZZZZZZ"         no-undo.
def var c-ccusto-ini     as char init ""                 no-undo.
def var c-ccusto-fim     as char init "ZZZZZZZZZZZZZZZZZZZZ" no-undo.
def var c-sit-ini        as char init ""                 no-undo.
def var c-sit-fim        as char init "ZZZZZZZZ"         no-undo.
def var i-ano-fabric-ini as int  init 0                  no-undo.
def var i-ano-fabric-fim as int  init 9999               no-undo.
def var d-periodo-ini    as date init "01/01/1900"       no-undo.
def var d-periodo-fim    as date init "12/31/9999"       no-undo.
def var i-emitente-ini   as int  init 0                  no-undo.
def var i-emitente-fim   as int  init 999999999          no-undo.
DEF VAR i-placa-ini      AS CHAR INIT ""                 NO-UNDO.
DEF VAR i-placa-fim      AS CHAR INIT "ZZZZZZZZZZZZ"     NO-UNDO.
def var d-dat-compra-ini as date init "01/01/1900"       no-undo.
def var d-dat-compra-fim as date init "12/31/9999"       no-undo.
def var d-val-compra-ini as dec  init 0                  no-undo.
def var d-val-compra-fim as dec  init 999999999.99       no-undo.
def var c-unid-negoc-ini as char init ""                 no-undo.
def var c-unid-negoc-fim as char init "ZZZ"              no-undo.
DEF VAR c-tipo-mater-ini AS CHAR INIT ""                 NO-UNDO.
DEF VAR c-tipo-mater-fim AS CHAR INIT "ZZZZZZZZ"         NO-UNDO.

/** TXT e Excel **/
define variable cTituloTxt     as character format "x(256)" no-undo.
define variable cDescPai       as character format "x(256)" no-undo.
define variable i-cont2        as integer                   no-undo.
define variable c-arquivo      as char init "AB0604.dat"    no-undo.
define variable cDelimitador   as character format "x(01)"  no-undo. /*Indica o tipo de delimitador */
define variable cCaminho       as character format "x(300)" no-undo. /*Indica o caminho */
define variable lCabecalho     as logical   initial no      no-undo. /*Indica se gera cabeáalho */
define variable i-impressao    as integer                   no-undo.
define variable i-lin          as integer                   no-undo.
define variable i-lin2         as integer                   no-undo.
define variable i-col          as integer                   no-undo.
define variable c-colunas      as character                 no-undo.
define variable i-tipo-exp     as character                 no-undo.
DEFINE VARIABLE i-col2         AS INTEGER                   NO-UNDO.           
DEFINE VARIABLE i-col-real     AS INTEGER                   NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE                    NO-UNDO.

DEFINE VARIABLE oTreeList      AS CLASS TotvsTreeList       NO-UNDO.

/***Expande /Contrai -  Pop-Menu  ***/
def var l-expande     as log init no no-undo.
def var i-seq         as int         no-undo.
def var l-ok          as log         no-undo.
def var i-button-tree as int init 1  no-undo.
def var i-result      as int         no-undo.
def var pop-menu    as widget-handle no-undo.
def var exp-con     as widget-handle no-undo.
def var detalhe     as widget-handle no-undo.
def var regua       as widget-handle no-undo.

/***Gr†fico***/
define variable i-tipo       as int no-undo.
define variable cTitGrafcio  as char FORMAT "x(250)" no-undo.
define variable c-eixo-x     as char no-undo.
define variable cLeft-Title1 as char no-undo.

/*** Window ***/
def var dWinXC as dec no-undo.
def var dWinYC as dec no-undo.

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

DEFINE BUFFER bf-mab-movto-km-eqpto FOR mab-movto-km-eqpto.

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
&Scoped-define INTERNAL-TABLES ttVisao1

/* Definitions for BROWSE brDetalhe                                     */
&Scoped-define FIELDS-IN-QUERY-brDetalhe ttVisao1.cod-oficial ttVisao1.desc-dimensao ttVisao1.quant-eqpto ttVisao1.km-rodado ttVisao1.un ttVisao1.km-sec ttVisao1.un-sec ttVisao1.iIdMedia ttVisao1.hodometro-pri ttVisao1.hodometro-sec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalhe   
&Scoped-define SELF-NAME brDetalhe
&Scoped-define QUERY-STRING-brDetalhe for each ttVisao1 no-lock
&Scoped-define OPEN-QUERY-brDetalhe open query {&SELF-NAME} for each ttVisao1 no-lock.
&Scoped-define TABLES-IN-QUERY-brDetalhe ttVisao1
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalhe ttVisao1


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDetalhe}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-21 RECT-22 rtToolBar-2 btAbrir ~
btSalvar btRefresh btExpande bt-Pneus bt-Comptes btParam btFiltro btVisao ~
btImprimir btExcel btTxt btQueryJoins btReportsJoins btExit btHelp ~
bt-equipto bt-relat-eqpto bt-cons-comb bt-remonta bt-reservas bt-histo-vida ~
btRedimensiona brDetalhe bt-mov-abast bt-mov-evento bt-mov-reserva ~
bt-mov-viagem fiText-1 fiText-2 
&Scoped-Define DISPLAYED-OBJECTS fiText-1 fiText-2 

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
DEFINE SUB-MENU m_Arquivo 
       MENU-ITEM m_Abrir        LABEL "&Abrir"         ACCELERATOR "CTRL-A"
       MENU-ITEM m_Salvar       LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       MENU-ITEM m_Atualizar    LABEL "&Atualizar"     ACCELERATOR "CTRL-R"
       MENU-ITEM m_Expande      LABEL "&Expande/Contrai" ACCELERATOR "CTRL-E"
       MENU-ITEM m_Consulta_Pneus LABEL "&Consulta Pneus" ACCELERATOR "CTRL-Z"
       MENU-ITEM m_Consulta_Componentes LABEL "&Consulta Componentes" ACCELERATOR "CTRL-D"
       MENU-ITEM m_Selecao      LABEL "&Seleá∆o"       ACCELERATOR "CTRL-P"
       MENU-ITEM m_Filtro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM m_Classifica   LABEL "&Classifica"    ACCELERATOR "CTRL-C"
       MENU-ITEM m_Imprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-T"
       MENU-ITEM m_Excel        LABEL "&Excel"         ACCELERATOR "CTRL-Q"
       MENU-ITEM m_Txt          LABEL "&TXT"           ACCELERATOR "CTRL-W"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  m_Arquivo      LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-Comptes 
     IMAGE-UP FILE "image/im-battery.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-battery.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Componentes".

DEFINE BUTTON bt-cons-comb 
     LABEL "Consumo Combust." 
     SIZE 15 BY .92.

DEFINE BUTTON bt-equipto 
     LABEL "Equipamento" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-histo-vida 
     LABEL "Hist¢rico Vidas" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-mov-abast 
     LABEL "Abast./Lubrif" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-mov-evento 
     LABEL "Evento" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-mov-reserva 
     LABEL "Reserva" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-mov-viagem 
     LABEL "Viagem" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-Pneus 
     IMAGE-UP FILE "image/im-pneu.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Pneus do Equipamento".

DEFINE BUTTON bt-relat-eqpto 
     LABEL "Relat¢rio Equip." 
     SIZE 15 BY .92.

DEFINE BUTTON bt-remonta 
     LABEL "% Remonta Motor" 
     SIZE 15 BY .92.

DEFINE BUTTON bt-reservas 
     LABEL "Reservas/Viagens" 
     SIZE 15 BY .92.

DEFINE BUTTON btAbrir 
     IMAGE-UP FILE "image/im-open":U
     IMAGE-INSENSITIVE FILE "image/ii-open":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Abrir"
     FONT 4.

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

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-param":U
     IMAGE-INSENSITIVE FILE "image/ii-param":U
     LABEL "Seleá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Seleá∆o"
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRedimensiona 
     LABEL "" 
     SIZE 74 BY .42.

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
     LABEL "Organizar" 
     SIZE 4 BY 1.25 TOOLTIP "Classifica"
     FONT 4.

DEFINE VARIABLE fiText-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE fiText-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 17.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 7.5.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 7.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDetalhe FOR 
      ttVisao1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDetalhe wWindow _FREEFORM
  QUERY brDetalhe NO-LOCK DISPLAY
      ttVisao1.cod-oficial     width 20
ttVisao1.desc-dimensao   width 30
ttVisao1.quant-eqpto     width 15
ttVisao1.km-rodado       width 13
ttVisao1.un              width 04
ttVisao1.km-sec          width 16
ttVisao1.un-sec          width 12
ttVisao1.iIdMedia        width 10
ttVisao1.hodometro-pri   width 15
ttVisao1.hodometro-sec   width 17
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 7.46
         FONT 1
         TITLE "" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btAbrir AT ROW 1.13 COL 2
     btSalvar AT ROW 1.13 COL 6
     btRefresh AT ROW 1.13 COL 10
     btExpande AT ROW 1.13 COL 13.86
     bt-Pneus AT ROW 1.13 COL 42.86
     bt-Comptes AT ROW 1.13 COL 46.86
     btParam AT ROW 1.13 COL 50.86
     btFiltro AT ROW 1.13 COL 54.86
     btVisao AT ROW 1.13 COL 58.86
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
     bt-equipto AT ROW 3.75 COL 75.43
     bt-relat-eqpto AT ROW 4.75 COL 75.43
     bt-cons-comb AT ROW 5.71 COL 75.43
     bt-remonta AT ROW 6.67 COL 75.43
     bt-reservas AT ROW 7.63 COL 75.43
     bt-histo-vida AT ROW 8.58 COL 75.43
     btRedimensiona AT ROW 11.83 COL 1
     brDetalhe AT ROW 12.42 COL 1
     bt-mov-abast AT ROW 13.42 COL 75.43
     bt-mov-evento AT ROW 14.33 COL 75.43
     bt-mov-reserva AT ROW 15.25 COL 75.43
     bt-mov-viagem AT ROW 16.17 COL 75.43
     fiText-1 AT ROW 3 COL 74 COLON-ALIGNED NO-LABEL
     fiText-2 AT ROW 12.58 COL 74 COLON-ALIGNED NO-LABEL
     RECT-20 AT ROW 2.5 COL 75
     RECT-21 AT ROW 3.25 COL 75
     RECT-22 AT ROW 13 COL 75
     rtToolBar-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(9.25)
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
         TITLE              = "Consulta Gerencial do Equipamento"
         HEIGHT             = 19.17
         WIDTH              = 90.14
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
open query {&SELF-NAME} for each ttVisao1 no-lock.
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
ON END-ERROR OF wWindow /* Consulta Gerencial do Equipamento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta Gerencial do Equipamento */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow /* Consulta Gerencial do Equipamento */
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
           rtToolBar-2:width-chars in frame fPage0      = (rtToolBar-2:width-chars in frame fPage0 + dXC)
           btHelp:column in frame fPage0                = (btHelp:column in frame fPage0 + dXC)
           btExit:column in frame fPage0                = (btExit:column in frame fPage0 + dXC)
           btReportsJoins:column in frame fPage0        = (btReportsJoins:column in frame fPage0 + dXC)
           btQueryJoins:column in frame fPage0          = (btQueryJoins:column in frame fPage0 + dXC)
           btParam:column in frame fPage0               = (btParam:column in frame fPage0 + dXC)
           btFiltro:column in frame fPage0              = (btFiltro:column in frame fPage0 + dXC)
           btVisao:column in frame fPage0               = (btVisao:column in frame fPage0 + dXC)
           bt-Pneus:column in frame fPage0              = (bt-Pneus:column in frame fPage0 + dXC)
           bt-Comptes:column in frame fPage0            = (bt-Comptes:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0            = (btImprimir:column in frame fPage0 + dXC)
           btExcel:column in frame fPage0               = (btExcel:column in frame fPage0 + dXC)
           btTxt:column in frame fPage0                 = (btTxt:column in frame fPage0 + dXC)
           brDetalhe:width-chars in frame fPage0        = (brDetalhe:width-chars in frame fPage0 + dXC)
           btRedimensiona:width-chars in frame fPage0   = (btRedimensiona:width-chars in frame fPage0 + dXC)
           btRedimensiona:row in frame fPage0           = (btRedimensiona:row in frame fPage0 + (dYC / 2))
           oTreeList:width                              = oTreeList:width   + dXC 
           oTreeList:HEIGHT                             = oTreeList:HEIGHT  + dYC
           RECT-20:column in frame fPage0               = (RECT-20:column in frame fPage0 + dXC)
           RECT-21:column in frame fPage0               = (RECT-21:column in frame fPage0 + dXC)
           RECT-22:column in frame fPage0               = (RECT-22:column in frame fPage0 + dXC)
           fiText-2:column in frame fPage0              = (fiText-2:column in frame fPage0 + dXC)
           fiText-1:column in frame fPage0              = (fiText-1:column in frame fPage0 + dXC)
           bt-equipto:column in frame fPage0            = (bt-equipto:column in frame fPage0 + dXC)
           bt-relat-eqpto:column in frame fPage0        = (bt-relat-eqpto:column in frame fPage0 + dXC)
           bt-cons-comb:column in frame fPage0          = (bt-cons-comb:column in frame fPage0 + dXC)
           bt-remonta:column in frame fPage0            = (bt-remonta:column in frame fPage0 + dXC)
           bt-reservas:column in frame fPage0           = (bt-reservas:column in frame fPage0 + dXC)
           bt-histo-vida:column in frame fPage0         = (bt-histo-vida:column in frame fPage0 + dXC)
           bt-mov-abast:column in frame fPage0          = (bt-mov-abast:column in frame fPage0 + dXC)
           bt-mov-evento:column in frame fPage0         = (bt-mov-evento:column in frame fPage0 + dXC)
           bt-mov-reserva:column in frame fPage0        = (bt-mov-reserva:column in frame fPage0 + dXC)
           bt-mov-viagem:column in frame fPage0         = (bt-mov-viagem:column in frame fPage0 + dXC) NO-ERROR.


         

    apply "END-MOVE":U to btRedimensiona in frame fPage0.
          
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESTORED OF wWindow /* Consulta Gerencial do Equipamento */
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
           rtToolBar-2:width-chars in frame fPage0      = (rtToolBar-2:width-chars in frame fPage0 - dXC)
           btHelp:column in frame fPage0                = (btHelp:column in frame fPage0 - dXC)
           btExit:column in frame fPage0                = (btExit:column in frame fPage0 - dXC)
           btReportsJoins:column in frame fPage0        = (btReportsJoins:column in frame fPage0 - dXC)
           btQueryJoins:column in frame fPage0          = (btQueryJoins:column in frame fPage0 - dXC)
           btParam:column in frame fPage0               = (btParam:column in frame fPage0 - dXC)
           btFiltro:column in frame fPage0              = (btFiltro:column in frame fPage0 - dXC)
           btVisao:column in frame fPage0               = (btVisao:column in frame fPage0 - dXC)
           bt-Pneus:column in frame fPage0              = (bt-Pneus:column in frame fPage0 - dXC)
           bt-Comptes:column in frame fPage0            = (bt-Comptes:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0            = (btImprimir:column in frame fPage0 - dXC)
           btExcel:column in frame fPage0               = (btExcel:column in frame fPage0 - dXC)
           btTxt:column in frame fPage0                 = (btTxt:column in frame fPage0 - dXC)
           brDetalhe:width-chars in frame fPage0        = (brDetalhe:width-chars in frame fPage0 - dXC)        
           btRedimensiona:width-chars in frame fPage0   = (btRedimensiona:width-chars in frame fPage0 - dXC)
           btRedimensiona:row in frame fPage0           = 11
           oTreeList:width                              = oTreeList:width  - dXC
           oTreeList:height                             = oTreeList:height - dYC
           RECT-20:column in frame fPage0               = (RECT-20:column in frame fPage0 - dXC)
           RECT-21:column in frame fPage0               = (RECT-21:column in frame fPage0 - dXC)
           RECT-22:column in frame fPage0               = (RECT-22:column in frame fPage0 - dXC)
           fiText-2:column in frame fPage0              = (fiText-2:column in frame fPage0 - dXC)
           fiText-1:column in frame fPage0              = (fiText-1:column in frame fPage0 - dXC)
           bt-equipto:column in frame fPage0            = (bt-equipto:column in frame fPage0 - dXC)
           bt-relat-eqpto:column in frame fPage0        = (bt-relat-eqpto:column in frame fPage0 - dXC)
           bt-cons-comb:column in frame fPage0          = (bt-cons-comb:column in frame fPage0 - dXC)
           bt-remonta:column in frame fPage0            = (bt-remonta:column in frame fPage0 - dXC)
           bt-reservas:column in frame fPage0           = (bt-reservas:column in frame fPage0 - dXC)
           bt-histo-vida:column in frame fPage0         = (bt-histo-vida:column in frame fPage0 - dXC)
           bt-mov-abast:column in frame fPage0          = (bt-mov-abast:column in frame fPage0 - dXC)
           bt-mov-evento:column in frame fPage0         = (bt-mov-evento:column in frame fPage0 - dXC)
           bt-mov-reserva:column in frame fPage0        = (bt-mov-reserva:column in frame fPage0 - dXC)
           bt-mov-viagem:column in frame fPage0         = (bt-mov-viagem:column in frame fPage0 - dXC) NO-ERROR.
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars.
           frame fPage0:height-chars               = wWindow:HEIGHT-CHARS   NO-ERROR.


           apply "END-MOVE":U to btRedimensiona in frame fPage0.


    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Comptes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Comptes wWindow
ON CHOOSE OF bt-Comptes IN FRAME fpage0 /* Button 2 */
DO:
    if oTreeList:hasNode() then do:
    run buscaRowidEquipto in this-procedure.
    assign {&window-name}:sensitive = no.
    run cop/co0604.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-Comptes in frame fPage0.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cons-comb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cons-comb wWindow
ON CHOOSE OF bt-cons-comb IN FRAME fpage0 /* Consumo Combust. */
DO:
    if oTreeList:hasNode() then do:
         run piConsumo in this-procedure.
         APPLY "Entry":U TO bt-cons-comb IN FRAME fPage0.   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-equipto wWindow
ON CHOOSE OF bt-equipto IN FRAME fpage0 /* Equipamento */
DO:
 if oTreeList:hasNode() then do:
    run buscaRowidEquipto in this-procedure.
    assign {&window-name}:sensitive = no.
    run abp/ab0602.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-equipto in frame fPage0.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-histo-vida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-histo-vida wWindow
ON CHOOSE OF bt-histo-vida IN FRAME fpage0 /* Hist¢rico Vidas */
DO:
  if oTreeList:hasNode() then do:
    run buscaRowidEquipto in this-procedure.
    assign {&window-name}:sensitive = no.
    run abp/ab0618.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-histo-vida in frame fPage0.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mov-abast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mov-abast wWindow
ON CHOOSE OF bt-mov-abast IN FRAME fpage0 /* Abast./Lubrif */
DO:

    assign {&window-name}:sensitive = no.
     RUN abp/ab0302.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-mov-abast in frame fPage0.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mov-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mov-evento wWindow
ON CHOOSE OF bt-mov-evento IN FRAME fpage0 /* Evento */
DO:

    assign {&window-name}:sensitive = no.
    RUN piEvento IN THIS-PROCEDURE.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-mov-evento in frame fPage0.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mov-reserva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mov-reserva wWindow
ON CHOOSE OF bt-mov-reserva IN FRAME fpage0 /* Reserva */
DO:
  
    assign {&window-name}:sensitive = no.
    RUN abp/ab0305.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-mov-reserva in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mov-viagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mov-viagem wWindow
ON CHOOSE OF bt-mov-viagem IN FRAME fpage0 /* Viagem */
DO:

    assign {&window-name}:sensitive = no.
    RUN abp/ab0304.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-mov-viagem in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Pneus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Pneus wWindow
ON CHOOSE OF bt-Pneus IN FRAME fpage0 /* Button 3 */
DO:
   if oTreeList:hasNode() then do:
    run buscaRowidEquipto in this-procedure.
    assign {&window-name}:sensitive = no.
    run pnp/pn0605.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-equipto in frame fPage0.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relat-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relat-eqpto wWindow
ON CHOOSE OF bt-relat-eqpto IN FRAME fpage0 /* Relat¢rio Equip. */
DO:
   assign {&window-name}:sensitive = no.
    RUN  abp/ab0501.w.
   assign {&window-name}:sensitive = yes.
   apply "ENTRY":U to bt-relat-eqpto in frame fPage0.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-remonta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-remonta wWindow
ON CHOOSE OF bt-remonta IN FRAME fpage0 /* % Remonta Motor */
DO:
   if oTreeList:hasNode() then do:
           run buscaRemontadEquipto in this-procedure.
          apply "ENTRY":U to bt-remonta in frame fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reservas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reservas wWindow
ON CHOOSE OF bt-reservas IN FRAME fpage0 /* Reservas/Viagens */
DO:
if oTreeList:hasNode() then do:
    run buscaRowidEquipto in this-procedure.
    assign {&window-name}:sensitive = no.
    run abp/ab0620.w.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to bt-reservas in frame fPage0.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAbrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAbrir wWindow
ON CHOOSE OF btAbrir IN FRAME fpage0
OR CHOOSE OF MENU-ITEM m_Abrir  IN MENU mbMain 
DO:

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


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM m_Excel  IN MENU mbMain 
DO:
    if oTreeList:hasNode() then DO:
       run piExcel.
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
OR CHOOSE OF MENU-ITEM m_Expande  IN MENU mbMain
DO:
    /** Verifica se existem dados no tree-view **/
    IF  oTreeList:hasNode() THEN DO:
        /** Controla expans∆o **/
        ASSIGN  l-expande   =   NOT l-expande.

        IF  l-expande   THEN    oTreeList:expandAll().
        ELSE                    oTreeList:collapseAll().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM m_Filtro  IN MENU mbMain
DO:


  assign {&window-name}:sensitive = no.
  run abp/ab0604a.w (input-output i-empresa-ini,   
                     input-output i-empresa-fim,   
                     input-output c-equipto-ini,   
                     input-output c-equipto-fim,   
                     input-output c-grupo-ini,     
                     input-output c-grupo-fim,     
                     input-output c-modelo-ini,    
                     input-output c-modelo-fim,    
                     input-output c-estab-ini,     
                     input-output c-estab-fim,     
                     input-output c-tag-ini,       
                     input-output c-tag-fim,       
                     input-output c-estrut-ini,    
                     input-output c-estrut-fim,    
                     input-output c-ccusto-ini,    
                     input-output c-ccusto-fim,    
                     input-output c-sit-ini,       
                     input-output c-sit-fim,       
                     input-output i-ano-fabric-ini,
                     input-output i-ano-fabric-fim,
                     input-output d-periodo-ini,   
                     input-output d-periodo-fim,
                     input-output i-emitente-ini,   
                     input-output i-emitente-fim,
                     INPUT-OUTPUT i-placa-ini,
                     INPUT-OUTPUT i-placa-fim,
                     input-output d-dat-compra-ini,
                     input-output d-dat-compra-fim,
                     input-output d-val-compra-ini,
                     input-output d-val-compra-fim,
                     INPUT-OUTPUT c-tipo-mater-ini,
                     INPUT-OUTPUT c-tipo-mater-fim
                    &IF DEFINED(bf_mnt_ems206b) &THEN                     
                     , INPUT-OUTPUT c-unid-negoc-ini,
                       INPUT-OUTPUT c-unid-negoc-fim
                    &ENDIF
                     ).
 
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
OR CHOOSE OF MENU-ITEM m_Imprimir  IN MENU mbMain DO:
    if oTreeList:hasNode() then do:
        run piImprimir in this-procedure.
    end.
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* Seleá∆o */
OR CHOOSE OF MENU-ITEM m_Selecao  IN MENU mbMain
DO:
    
  assign {&window-name}:sensitive = no.
   run abp/ab0604c.w (input-output l-ativos,       
                     input-output l-motorizados,  
                     input-output l-proprios,     
                     input-output l-inativos,     
                     input-output l-n-motorizados,
                     input-output l-terceiros,
                     input-output l-hodometro).
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
    /* A reduáao deve respeitar o limite m≠nimo de 5 do componente treelist, somando a linha do posicionamento do objeto */
    if btRedimensiona:row < 7.5 then
        assign btRedimensiona:row = 7.5.
  
    if btRedimensiona:row > (frame fPage0:height - 4) then
        assign btRedimensiona:row = (frame fPage0:height - 4).
     
    if btRedimensiona:row > frame fPage0:height then
       assign btRedimensiona:row = frame fPage0:height - 1.
    
   if btRedimensiona:column  > brDetalhe:column in frame fPage0 then
       assign btRedimensiona:column = brDetalhe:column in frame fPage0.

    assign oTreeList:height = btRedimensiona:row - 2.5 no-error.         
   
    assign brDetalhe:row = btRedimensiona:row + btRedimensiona:height no-error.
    assign brDetalhe:height  = (frame fPage0:height) + 0.5 - (btRedimensiona:row) no-error.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wWindow
ON CHOOSE OF btRefresh IN FRAME fpage0
OR CHOOSE OF MENU-ITEM m_Atualizar  IN MENU mbMain 
DO:

session:set-wait-state ("GENERAL").

FOR EACH  ttVisao WHERE substring(TRIM(ttVisao.dimensao),1,2) = "11"
    AND  l-terceiros = NO NO-LOCK:
        ASSIGN l-terceiros = YES.
END.

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao ) then do:
    run piCriaVisao in this-procedure.
end.
          run carregaTTEquipto (input i-empresa-ini,        
                                input i-empresa-fim,        
                                input c-equipto-ini,        
                                input c-equipto-fim,        
                                input c-grupo-ini,          
                                input c-grupo-fim,          
                                input c-modelo-ini,         
                                input c-modelo-fim,         
                                input c-estab-ini,          
                                input c-estab-fim,          
                                input c-tag-ini,            
                                input c-tag-fim,            
                                input c-estrut-ini,         
                                input c-estrut-fim,         
                                input c-ccusto-ini,         
                                input c-ccusto-fim,         
                                input c-sit-ini,            
                                input c-sit-fim,            
                                input i-ano-fabric-ini,     
                                input i-ano-fabric-fim,     
                                input d-periodo-ini,        
                                input d-periodo-fim, 
                                input i-emitente-ini,
                                input i-emitente-fim,
                                INPUT i-placa-ini,
                                INPUT i-placa-fim,
                                input l-ativos,             
                                input l-motorizados,        
                                input l-proprios,           
                                input l-inativos,           
                                input l-n-motorizados,      
                                input l-terceiros,
                                INPUT c-tipo-mater-ini,
                                INPUT c-tipo-mater-fim
                                &IF DEFINED(bf_mnt_ems206b) &THEN
                                , INPUT c-unid-negoc-ini,
                                  INPUT c-unid-negoc-fim
                                &ENDIF).

 run criaTreeList. 
                                                
/** Controla expans∆o **/

 if l-expande then assign l-expande = no.
 ASSIGN brDetalhe:title in frame fPage0    = "".

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
OR CHOOSE OF MENU-ITEM m_Salvar  IN MENU mbMain 
DO:

  /** Troca os tipos de barras **/ 
   assign c-arquivo = replace(c-arquivo, "/", "/").

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

      IF l-usa-unid-negoc THEN DO:
          export delimiter ";"
                 l-ativos l-motorizados l-proprios l-inativos l-n-motorizados l-terceiros
                 i-empresa-ini i-empresa-fim c-equipto-ini c-equipto-fim c-grupo-ini c-grupo-fim
                 c-modelo-ini  c-modelo-fim  c-estab-ini c-estab-fim c-tag-ini c-tag-fim c-estrut-ini
                 c-estrut-fim  c-ccusto-ini  c-ccusto-fim c-sit-ini  c-sit-fim i-ano-fabric-ini
                 i-ano-fabric-fim d-periodo-ini d-periodo-fim i-emitente-ini i-emitente-fim i-placa-ini
                 i-placa-fim d-dat-compra-ini d-dat-compra-fim d-val-compra-ini d-val-compra-fim c-tipo-mater-ini c-tipo-mater-fim c-unid-negoc-ini c-unid-negoc-fim l-hodometro.
      END.
      ELSE DO:
          export delimiter ";"
                 l-ativos l-motorizados l-proprios l-inativos l-n-motorizados l-terceiros
                 i-empresa-ini i-empresa-fim c-equipto-ini c-equipto-fim c-grupo-ini c-grupo-fim
                 c-modelo-ini  c-modelo-fim  c-estab-ini c-estab-fim c-tag-ini c-tag-fim c-estrut-ini
                 c-estrut-fim  c-ccusto-ini  c-ccusto-fim c-sit-ini  c-sit-fim i-ano-fabric-ini
                 i-ano-fabric-fim d-periodo-ini d-periodo-fim i-emitente-ini i-emitente-fim i-placa-ini
                 i-placa-fim d-dat-compra-ini d-dat-compra-fim d-val-compra-ini d-val-compra-fim c-tipo-mater-ini c-tipo-mater-fim l-hodometro.
      END.

      /** Salva Seleá∆o **/

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
OR CHOOSE OF MENU-ITEM m_Txt  IN MENU mbMain
DO:
   if oTreeList:hasNode() then do:
        run piTxt in this-procedure.
    end.
    apply "ENTRY":U to btTxt in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisao wWindow
ON CHOOSE OF btVisao IN FRAME fpage0 /* Organizar */
OR CHOOSE OF MENU-ITEM m_Classifica  IN MENU mbMain
DO:
 
  assign {&window-name}:sensitive = no.
    run abp/ab0604b.w (input-output table ttVisao).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btVisao in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDetalhe
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/

/** Criaá∆o do pop menu do tree-List **/
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

DELETE OBJECT oTreeList NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRemonta AS CHARACTER  NO-UNDO.

{utp/ut-liter.i "Remonta" MAB}
ASSIGN cRemonta = RETURN-VALUE.
{utp/ut-liter.i "Motor"}
ASSIGN bt-remonta:LABEL IN FRAME fPage0 = "% " + cRemonta + " " + RETURN-VALUE.

/** Labels do browse **/
assign ttVisao1.cod-oficial:label in browse brDetalhe   = fnBrowse("cod-oficial":U,1)  
       ttVisao1.desc-dimensao:label in browse brDetalhe = fnBrowse("desc-dimensao":U,1) 
       ttVisao1.quant-eqpto:label in browse brDetalhe   = fnBrowse("quant-eqpto":U,1)
       ttVisao1.km-rodado:label in browse brDetalhe     = fnBrowse("km-rodado":U,1)
       ttVisao1.un:label in browse brDetalhe            = fnBrowse("un":U,1)
       ttVisao1.un-sec:label in browse brDetalhe        = fnBrowse("un-sec":U,1)
       ttVisao1.km-sec:label in browse brDetalhe        = fnBrowse("km-sec":U,1)
       ttVisao1.iIdMedia:label in browse brDetalhe      = fnBrowse("iIdMedia":U,1)
       ttVisao1.hodometro-pri:label in browse brDetalhe = fnBrowse("hodometro-pri":U,1)
       ttVisao1.hodometro-sec:label in browse brDetalhe = fnBrowse("hodometro-sec":U,1).

/**Label do texto***/
{utp/ut-liter.i "Consultas"}
assign fiText-1 = return-value.
DISP fiText-1 WITH FRAME fPage0.

{utp/ut-liter.i "Tarefas"}
assign fiText-2 = return-value.
DISP fiText-2 WITH FRAME fPage0.

/*Pneus*/  
run cdp/cd9902.p (input 2).
if return-value = "NOK":U then
   assign bt-Pneus:sensitive in frame fPage0 = false
           MENU-ITEM m_Consulta_Pneus:SENSITIVE IN MENU mbMain    = FALSE.
else
   assign bt-Pneus:sensitive in frame fPage0 = true
           MENU-ITEM m_Consulta_Pneus:SENSITIVE IN MENU mbMain    = TRUE.

/*Componentes*/  
run cdp/cd9902.p (input 4).
if return-value = "NOK":U then
   assign bt-Comptes:sensitive in frame fPage0 = false
          MENU-ITEM m_Consulta_Componentes:SENSITIVE IN MENU mbMain    = FALSE.
else
   assign bt-Comptes:sensitive in frame fPage0 = true
          MENU-ITEM m_Consulta_Componentes:SENSITIVE IN MENU mbMain    = FALSE.
       
/* -------------------------- */
/* Monta o Browse do TreeList */
/* -------------------------- */

oTreeList             =   NEW TOTVSTreeList().
oTreeList:parentFrame =   FRAME   fpage0:HANDLE.
oTreeList:parentProg  =   THIS-PROCEDURE.
          
oTreeList:setSize(2.5, 1, 74, 9.25).

oTreeList:AddColumn("r-rowid"      , "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("r-rowid-visao", "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("p-image"      , "integer"  , 0, ">9"    , "", "", TRUE).

oTreeList:AddColumn("quant-eqpto" , "decimal"  , 0, ">>>,>>>,>>9"   , "", "", FALSE). 
oTreeList:AddColumn("km-rodado"   , "decimal"  , 0, ">>>,>>>,>>9.9" , "", "", FALSE). 
oTreeList:AddColumn("un"          , "character", 0, "X(003)"        , "", "", FALSE). 
oTreeList:AddColumn("km-sec"      , "decimal"  , 0, ">>>,>>>,>>9.9" , "", "", FALSE). 
oTreeList:AddColumn("un-sec"      , "character", 0, "X(003)"        , "", "", FALSE). 
oTreeList:AddColumn("iIdMedia"    , "decimal"  , 0, ">>>9.99"       , "", "", FALSE). 
oTreeList:AddColumn("vazia"       , "character", 0, "X(001)"        , "", "", FALSE). 

oTreeList:INITIALIZE().
oTreeList:emptyTreeList().

ASSIGN  oTreeList:browseTreeList:SEPARATORS         =   FALSE.
ASSIGN  oTreeList:browseTreeList:FIT-LAST-COLUMN    =   TRUE.    

oTreeList:setColumnLabel("cEstrutura", "").
oTreeList:setColumnSize("cEstrutura" , 32).
    
/* Ajuste no Label das colunas */
oTreeList:setColumnLabel("quant-eqpto"  , ttvisao1.quant-eqpto:LABEL    IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("km-rodado"    , ttvisao1.km-rodado:LABEL      IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("un"           , ttvisao1.un:LABEL             IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("km-sec"       , ttvisao1.km-sec:LABEL         IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("un-sec"       , ttvisao1.un-sec:LABEL         IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("iIdMedia"     , ttvisao1.iIdMedia:LABEL       IN  BROWSE  brDetalhe).
oTreeList:setColumnLabel("vazia"        , "").

/* Ajuste no Tamanho das colunas */
oTreeList:setColumnSize("quant-eqpto"   , 14).
oTreeList:setColumnSize("km-rodado"     , 13).
oTreeList:setColumnSize("un"            , 08).
oTreeList:setColumnSize("km-sec"        , 14).
oTreeList:setColumnSize("un-sec"        , 08).
oTreeList:setColumnSize("iIdMedia"      , 10).

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaBrowse wWindow 
PROCEDURE atualizaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Se tiver filhos, mostra no browse, os filhos **/
if avail ttVisao1 then do:
    run tituloBrowse in this-procedure (ttVisao1.p-image).
    open query brDetalhe for each  ttVisao1
                             where ttVisao1.cod-dimens-pai = bfttVisao1.cod-dimensao.
end.
/** Sen∆o, mostra ele mesmo **/
else do:
    run tituloBrowse in this-procedure (bfttVisao1.p-image).
    open query brDetalhe for each  ttVisao1
                             where ttVisao1.cod-dimensao = bfttVisao1.cod-dimensao.
end.

if not(ttVisao1.quant-eqpto:visible in browse brDetalhe) then
    assign btImprimir:sensitive in frame fPage0 = no
           btExcel:sensitive in frame fPage0    = no
           btTxt:sensitive in frame fPage0      = no.
else 
    assign btImprimir:sensitive in frame fPage0 = yes
           btExcel:sensitive in frame fPage0    = yes
           btTxt:sensitive in frame fPage0      = yes.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Override antes de iniciar a tela
------------------------------------------------------------------------------*/
assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

assign l-ativos               = yes
       l-motorizados          = yes
       l-proprios             = yes
       l-inativos             = no
       l-n-motorizados        = yes
       l-terceiros            = no
       l-hodometro            = NO.
              
RETURN "OK":U.
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

    IF  (cEvent =   "selected" OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:
        ASSIGN  rRow    =   TO-ROWID(oTreeList:getDataChar(cNodeId, "r-rowid-visao")).
            
        FOR FIRST   bfttVisao1 
            WHERE   ROWID(bfttVisao1)   =   rRow    NO-LOCK:
        END.

        /** Verifica se ele contem filhos **/
        FOR FIRST   ttVisao1
            WHERE   ttVisao1.cod-dimens-pai =   bfttVisao1.cod-dimensao NO-LOCK:
        END.
            
        IF  AVAIL   ttVisao1    THEN    RUN atualizaBrowse  IN  THIS-PROCEDURE.
    END.
    RETURN  "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRemontadEquipto wWindow 
PROCEDURE buscaRemontadEquipto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Executa o programa ab0601.w
------------------------------------------------------------------------------*/
define variable hEqpto  as handle    no-undo.
DEFINE VARIABLE rRowid AS ROWID      NO-UNDO.

if INTEGER(oTreeList:getDataChar(oTreeList:currentCode, "p-image")) = 6 then do:
    /** Guarda rowid do tree-view **/
    assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
    for first mab-eqpto
        where rowid(mab-eqpto) = rRowid no-lock:
        ASSIGN gr-mab-eqpto  = rRowid.
    END.
END.
else do:
    IF brDetalhe:NUM-SELECTED-ROWS  IN FRAME fpage0 > 0 THEN DO:
        get current brDetalhe NO-LOCK.
        IF AVAIL ttvisao1 THEN DO:
            for first mab-eqpto
                where rowid(mab-eqpto) = ttVisao1.r-rowid no-lock:
                ASSIGN gr-mab-eqpto  = ttVisao1.r-rowid.
            END.
        END.
    END.
END.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
Run abp/ab0601.w PERSISTENT SET hEqpto.

/* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
IF VALID-HANDLE(hEqpto) AND
   hEqpto:Type = "PROCEDURE":U AND
   hEqpto:FILE-NAME = "abp/ab0601.w":U THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
   Run initializeInterface IN hEqpto.
   run setaEquipamento in hEqpto (input  gr-mab-eqpto).

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
wait-for "CLOSE":U of hEqpto.
assign {&window-name}:sensitive = yes.

if valid-handle(hEqpto) then
    delete procedure hEqpto.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRowidEquipto wWindow 
PROCEDURE buscaRowidEquipto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Quando vis∆o selecionado no TreeList ou no Browser for equipamento guarda o rowid
------------------------------------------------------------------------------*/
def var r-Rowid as rowid no-undo.

if INTEGER(oTreeList:getDataChar(oTreeList:currentCode, "p-image")) = 6 then do:
    /** Guarda rowid do tree-view **/
    assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
    for first mab-eqpto
        where rowid(mab-eqpto) = rRowid no-lock:
        ASSIGN gr-mab-eqpto  = rRowid.
    end.
end.
else do:
    IF brDetalhe:NUM-SELECTED-ROWS  IN FRAME fpage0 > 0 THEN DO:
        get current brDetalhe NO-LOCK.
        IF AVAIL ttvisao1 THEN DO:
           for first mab-eqpto
              where rowid(mab-eqpto) = ttVisao1.r-rowid no-lock:
              ASSIGN gr-mab-eqpto  = ttVisao1.r-rowid.
           END.
        end.
    END.
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
DEF INPUT PARAM pValorDimensao AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cDescModel AS CHARACTER FORMAT "x(30)" NO-UNDO.
/***Zera vari†veis no inicio***/
ASSIGN vCodigo    = " "
       vDescricao = " "
       iImage = 0
       rRowid  = ?.

/** Verifica tipo de vis∆o (classificaá∆o) **/
CASE substring(TRIM(pValorDimensao),1,2):
    /**Empresa**/
    WHEN "01":U THEN DO:
        IF NOT AVAIL empresa OR empresa.ep-codigo <> mab-eqpto.ep-codigo THEN DO:
            for first empresa fields(ep-codigo nome) no-lock 
                WHERE empresa.ep-codigo = mab-eqpto.ep-codigo:
            END.
        END.
        IF AVAIL  empresa THEN DO:
            ASSIGN vCodigo    = STRING(mab-eqpto.ep-codigo, "999")
                   vDescricao = empresa.nome
                   iImage     = 1
                   rRowid     = ROWID(empresa).
        END.
        ELSE DO:
            ASSIGN vCodigo    = "_"
                   vDescricao = ""
                   iImage     = 1
                   rRowid     = ROWID(mab-eqpto).
        END.

    END.
    /**Tipo Equipamento **/
    WHEN "02":U THEN DO:
        ASSIGN vCodigo    = string(mab-eqpto.idi-tip-eqpto).
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {frinc/i00fr007.i 04 mab-eqpto.idi-tip-eqpto}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN vDescricao = RETURN-VALUE.
        &else
            ASSIGN vDescricao = {frinc/i00fr007.i 04 mab-eqpto.idi-tip-eqpto}.
        &endif
        ASSIGN iImage = 2
               rRowid = ROWID(mab-eqpto).
     END.
     /***Estrutura MecÉnica ****/
     WHEN "03":U THEN DO:
          IF NOT AVAIL mab-estrut-mec OR   mab-estrut-mec.cod-estrut-mec <> mab-eqpto.cod-estrut-mec THEN DO:
             for first mab-estrut-mec fields(cod-estrut-mec des-estrut-mec) no-lock where
                        mab-estrut-mec.cod-estrut-mec = mab-eqpto.cod-estrut-mec:
             end.
         END.
         IF AVAIL mab-estrut-mec THEN do:
            ASSIGN vCodigo    = mab-estrut-mec.cod-estrut-mec
                   vDescricao = mab-estrut-mec.des-estrut-mec
                   iImage     = 3
                   rRowid     = ROWID(mab-estrut-mec).
         END.
         ELSE DO:
             ASSIGN vCodigo    = mab-eqpto.cod-estrut-mec
                    vDescricao = ""
                    iImage     = 3
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Grupo****/
     WHEN "04":U THEN DO:
           IF NOT AVAIL mab-grp-eqpto OR    mab-grp-eqpto.cod-grp-eqpto <> mab-eqpto.cod-grp-eqpto THEN DO:
             for first mab-grp-eqpto fields(cod-grp-eqpto des-grp-eqpto) no-lock where
                       mab-grp-eqpto.cod-grp-eqpto = mab-eqpto.cod-grp-eqpto:
             end.
         END.
         
         IF AVAIL mab-grp-eqpto THEN do:
            ASSIGN vCodigo    = mab-grp-eqpto.cod-grp-eqpto
                   vDescricao = mab-grp-eqpto.des-grp-eqpto
                   iImage     = 4
                   rRowid     = ROWID(mab-grp-eqpto).
         END.
         ELSE DO:
             ASSIGN vCodigo    = mab-eqpto.cod-grp-eqpto
                    vDescricao = ""
                    iImage     = 4
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Modelo ***/
     WHEN "05":U THEN DO:
             IF NOT AVAIL mab-model OR    mab-model.cod-model <> mab-eqpto.cod-model THEN DO:
             for first mab-model fields(cod-model des-model cod-marca) no-lock where
                 mab-model.cod-model = mab-eqpto.cod-model:
             end.
         END.
         IF AVAIL mab-model THEN do:
            ASSIGN vCodigo    = mab-model.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 5
                   rRowid     = ROWID(mab-model).
                 
         END.
         ELSE DO:
             ASSIGN vCodigo    = mab-eqpto.cod-model
                    vDescricao = ""
                    iImage     = 5
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Equipamento ***/
     WHEN "06":U THEN DO:
         IF NOT AVAIL mab-model OR    mab-model.cod-model <> mab-eqpto.cod-model THEN DO:
             for first mab-model fields(cod-model des-model cod-marca) no-lock where
                 mab-model.cod-model = mab-eqpto.cod-model:
             END.
         END.
         IF AVAIL mab-model THEN do:
             ASSIGN cDescModel = mab-model.des-model
                    vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
                    vDescricao = cDescModel
                    iImage     = 6
                    rRowid     = rowid(mab-eqpto).
         END.
         ELSE DO:
             ASSIGN vCodigo    = string(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto
                    vDescricao = ""
                    iImage     = 6
                    rRowid     = rowid(mab-eqpto).
         END.
     END.
     /***Ano ***/
     WHEN "07":U THEN DO:
         ASSIGN vCodigo     = STRING( mab-eqpto.vli-ano-fabric,"9999")
                vDescricao = STRING( mab-eqpto.vli-ano-fabric,"9999")
                iImage     = 7.
     END.
     /***Estabelecimento ***/
     WHEN "08":U THEN DO:
          IF NOT AVAIL estabelec OR estabelec.cod-estabel <> mab-eqpto.cod-estabel THEN DO:
             for first estabelec fields(cod-estabel nome) no-lock where
                       estabelec.cod-estabel = mab-eqpto.cod-estabel:
             end.
         END.
         IF AVAIL estabelec THEN do:
            ASSIGN vCodigo    = mab-eqpto.cod-estabel
                   vDescricao = estabelec.nome
                   iImage     = 8
                   rRowid     = ROWID(estabelec).
         END.
         ELSE DO:
             ASSIGN vCodigo    = mab-eqpto.cod-estabel
                    vDescricao = ""
                    iImage     = 8
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /** Tag **/
     WHEN "09":U THEN DO:
          IF NOT AVAIL tag OR   tag.cd-tag <> mab-eqpto.cd-tag THEN DO:
               for first tag fields(cd-tag descricao) no-lock where
                   tag.cd-tag = mab-eqpto.cd-tag:
               end.
         END.
         IF AVAIL tag THEN do:
            ASSIGN vCodigo    = IF tag.cd-tag <> "" THEN tag.cd-tag ELSE "_":U
                   vDescricao = tag.descricao
                    iImage     = 9
                    rRowid     = ROWID(tag).
         END.
         ELSE DO:
             {utp/ut-liter.i "Tag_N∆o_Dispon°vel"}
             ASSIGN vCodigo    = "__":U
                    vDescricao = return-value
                    iImage     = 9
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Situaá∆o ****/
      WHEN "10":U THEN DO:
             ASSIGN vCodigo    = mab-sit-eqpto.cod-sit-eqpto
                   vDescricao = mab-sit-eqpto.des-sit-eqpto
                   iImage     = 10.
     END.
     /***Propriet†rio ***/
     WHEN "11":U THEN DO:
          IF NOT AVAIL emitente OR    emitente.cod-emitente <> mab-eqpto.cod-emitente THEN DO:
               for first emitente fields(cod-emitente nome-emit) no-lock where
                   emitente.cod-emitente = mab-eqpto.cod-emitente:
               END.
         END.
         IF AVAIL emitente THEN do:
            ASSIGN vCodigo    = trim(string(emitente.cod-emitente, ">>>>>>>>9"))
                   vDescricao = emitente.nome-emit
                   iImage     = 11.
         END.
         ELSE DO:
              ASSIGN vCodigo    = string(0)
                     vDescricao = ""
                     iImage     = 11.

         END.
     END.
     /***Marca***/
     WHEN "12":U THEN DO:
         IF NOT AVAIL mab-model OR    mab-model.cod-model <> mab-eqpto.cod-model THEN DO:
             for first mab-model fields(cod-model des-model cod-marca) no-lock where
                 mab-model.cod-model = mab-eqpto.cod-model:
             end.
         end.
         for first mab-marca fields (cod-marca nom-marca)
             where mab-marca.cod-marca = mab-model.cod-marca no-lock:   
         end.
         
         IF AVAIL mab-marca THEN do:
            ASSIGN vCodigo    = mab-marca.cod-marca
                   vDescricao = mab-marca.nom-marca
                   iImage     = 12
                   rRowid     = ROWID(mab-marca).
         END.
         ELSE DO:
             {utp/ut-liter.i "Modelo_N∆o_Dispon°vel"}
             ASSIGN vCodigo   = mab-eqpto.cod-model
                   vDescricao = return-value
                   iImage     = 12
                   rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Centro de Custo****/
     WHEN "13":U THEN DO:
       IF NOT AVAIL tt_ccusto_integr OR tt_ccusto_integr.ttv_cod_ccusto <> mab-eqpto.cc-codigo THEN DO:
            FOR FIRST tt_ccusto_integr
                WHERE tt_ccusto_integr.ttv_cod_ccusto = mab-eqpto.cc-codigo NO-LOCK:
            END.
        END.
        IF AVAIL (tt_ccusto_integr) THEN DO:
            ASSIGN vCodigo    = mab-eqpto.cc-codigo
                   vDescricao = tt_ccusto_integr.ttv_des_titulo
                   iImage     = 13
                   rRowid     = rowid(tt_ccusto_integr).
         END.
         ELSE DO:
             {utp/ut-liter.i "Centro_Custo_N∆o_Dispon°vel"}
             ASSIGN vCodigo   = mab-eqpto.cc-codigo
                   vDescricao = return-value
                   iImage     = 13
                   rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Data Compra****/
     WHEN "14":U THEN DO:    
         IF AVAIL mab-eqpto THEN do:
            {utp/ut-liter.i "Data_Compra"}
            ASSIGN vCodigo    = trim(string(mab-eqpto.dat-compra,"99/99/9999"))
                   vDescricao = return-value
                   iImage     = 14
                   rRowid     = rowid(mab-eqpto).
         END.
         ELSE DO:
             {utp/ut-liter.i "Data_Compra_N∆o_Dispon°vel"}
             ASSIGN vCodigo    = "_"
                    vDescricao = return-value
                    iImage     = 14
                    rRowid     = ROWID(mab-eqpto).
         END.
     END.
     /***Valor Compra****/
     WHEN "15":U THEN DO:
         IF AVAIL mab-eqpto THEN do:
            {utp/ut-liter.i "Valor_Compra"}
            ASSIGN vCodigo    = trim(string(mab-eqpto.val-compra,">>>,>>>,>>9.99"))
                   vDescricao = return-value
                   iImage     = 15
                   rRowid     = rowid(mab-eqpto).
         END.
         ELSE DO:
             {utp/ut-liter.i "Valor_Compra_N∆o_Dispon°vel"}
             ASSIGN vCodigo   = "_"
                   vDescricao = return-value
                   iImage     = 15
                   rRowid     = ROWID(mab-eqpto).
         END.
     END.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN        
        WHEN "16" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-eqpto.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-eqpto.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 16
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 16
                           rRowid     = ROWID(mab-eqpto).
                END.
            END.       
        END.
    &ENDIF
    /***Tipo Material***/
    WHEN "17":U THEN DO:
        IF  l-tem-combustivel THEN DO:
            FOR FIRST mab-tip-mater FIELDS(cod-tip-mater des-tip-mater) NO-LOCK WHERE
                mab-tip-mater.cod-tip-mater = c-tipo-mater:
            END.
            IF  AVAIL mab-tip-mater THEN DO:
                ASSIGN vCodigo      = STRING(mab-tip-mater.cod-tip-mater)
                       vDescricao   = STRING(mab-tip-mater.des-tip-mater)
                       iImage       = 17
                       rRowid       = ROWID(mab-tip-mater).
            END.
            ELSE DO:
                {utp/ut-liter.i "Tipo_Material_n∆o_informado"}
                 ASSIGN vCodigo      = "_":U
                        vDescricao   = RETURN-VALUE
                        iImage       = 17
                        rRowid       = ROWID(mab-eqpto).
            END.
        END.
        ELSE DO:
            {utp/ut-liter.i "Tipo_Material_n∆o_informado"}
             ASSIGN vCodigo      = "_":U
                    vDescricao   = RETURN-VALUE
                    iImage       = 17
                    rRowid       = ROWID(mab-eqpto).
        END.
    END.
END CASE.
     
RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaEquipto wWindow 
PROCEDURE carregaEquipto :
/*------------------------------------------------------------------------------
  Purpose:     carregaEquipto
  Parameters:  <none>
  Notes:       Busca os dados e atualiza o programa
------------------------------------------------------------------------------*/
def input param p-empresa-ini         LIKE empresa.ep-codigo  no-undo.
def input param p-empresa-fim         LIKE empresa.ep-codigo  no-undo.
def input param p-equipto-ini         as char no-undo.
def input param p-equipto-fim         as char no-undo.
def input param p-grupo-ini           as char no-undo.
def input param p-grupo-fim           as char no-undo.
def input param p-modelo-ini          as char no-undo.
def input param p-modelo-fim          as char no-undo.
def input param p-estab-ini           as char no-undo.
def input param p-estab-fim           as char no-undo.
def input param p-tag-ini             as char no-undo.
def input param p-tag-fim             as char no-undo.
def input param p-estrut-ini          as char no-undo. 
def input param p-estrut-fim          as char no-undo.
def input param p-ccusto-ini          as char no-undo. 
def input param p-ccusto-fim          as char no-undo.
def input param p-sit-ini             as char no-undo.
def input param p-sit-fim             as char no-undo.
def input param p-ano-fabric-ini      as int  no-undo.
def input param p-ano-fabric-fim      as int  no-undo.
def input param p-periodo-ini         as date no-undo.
def input param p-periodo-fim         as date no-undo.
def input param p-emitente-ini        as int  no-undo.
def input param p-emitente-fim        as int  no-undo.
DEF INPUT PARAM p-placa-ini           AS CHAR NO-UNDO.
DEF INPUT PARAM p-placa-fim           AS CHAR NO-UNDO.
def input param p-ativos              as log  no-undo.
def input param p-motorizados         as log  no-undo.
def input param p-proprios            as log  no-undo.
def input param p-inativos            as log  no-undo.
def input param p-n-motorizados       as log  no-undo.
def input param p-terceiros           as log  no-undo.
DEF INPUT PARAM p-tipo-mater-ini      AS CHAR NO-UNDO.
DEF INPUT PARAM p-tipo-mater-fim      AS CHAR NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN
def input param p-unid-negoc-ini      as char no-undo.
def input param p-unid-negoc-fim      as char no-undo.
&ENDIF

/** Busca ParÉmetros **/
find first ttVisao no-lock no-error.
   if not avail ttVisao then return "NOK":U.

empty temp-table ttVisao1.

{&OPEN-QUERY-brDetalhe}

oTreeList:emptyTreeList().

  /** Acompanhamento **/
    RUN utp/ut-acomp.p PERSISTENT SET hHandle.
    {utp/ut-liter.i Consulta_Equipamentos * }
    RUN pi-inicializar IN hHandle (trim(return-value)).
    
    blk1:
    do on stop undo, return "NOK":U:

        /* xavier */
        ASSIGN ivisao = 999.
        for each ttVisao fields(sequencia) no-lock:
            if substring(ttVisao.dimensao,1,2) = "04" or 
               substring(ttVisao.dimensao,1,2) = "05" or 
               substring(ttVisao.dimensao,1,2) = "06" then do:
               assign iVisao = ttVisao.sequencia.
               leave.
            end.
        end.
        assign iVisao2 = 0.
        for last ttVisao no-lock:
            assign iVisao2 = ttVisao.sequencia - 1
                   iVisao3 = ttVisao.sequencia.
        end.
        /* fim xavier */
    
        for each mab-eqpto fields(cc-codigo cd-tag cod-eqpto cod-estabel cod-estrut-mec
                                  cod-grp-eqpto cod-model cod-sit-eqpto dat-inicial ep-codigo 
                                  vli-ano-fabric dat-compra val-compra idi-tip-eqpto idi-tip-propriet 
                                  vli-ano-model cod-emitente cod-placa log-cont-sec val-km-sec &IF DEFINED(bf_mnt_ems206b) &THEN cod-unid-negoc &ENDIF) NO-LOCK
           where mab-eqpto.ep-codigo      >= p-empresa-ini    and
                 mab-eqpto.ep-codigo      <= p-empresa-fim    and
                 mab-eqpto.cod-eqpto      >= p-equipto-ini    AND
                 mab-eqpto.cod-eqpto      <= p-equipto-fim    AND
                 mab-eqpto.cod-grp-eqpto  >= p-grupo-ini      and
                 mab-eqpto.cod-grp-eqpto  <= p-grupo-fim      and
                 mab-eqpto.cod-model      >= p-modelo-ini     and  
                 mab-eqpto.cod-model      <= p-modelo-fim     and  
                 mab-eqpto.cod-estabel    >= p-estab-ini      and
                 mab-eqpto.cod-estabel    <= p-estab-fim      and
                 mab-eqpto.cd-tag         >= p-tag-ini        and
                 mab-eqpto.cd-tag         <= p-tag-fim        and
                 mab-eqpto.cod-estrut-mec >= p-estrut-ini     and
                 mab-eqpto.cod-estrut-mec <= p-estrut-fim     and
                 mab-eqpto.cc-codigo      >= p-ccusto-ini     and
                 mab-eqpto.cc-codigo      <= p-ccusto-fim     and
                 mab-eqpto.cod-sit-eqpto  >= p-sit-ini        and
                 mab-eqpto.cod-sit-eqpto  <= p-sit-fim        and
                 mab-eqpto.vli-ano-fabric >= p-ano-fabric-ini and
                 mab-eqpto.vli-ano-fabric <= p-ano-fabric-fim and 
                 mab-eqpto.dat-inicial    >= p-periodo-ini    and
                 mab-eqpto.dat-inicial    <= p-periodo-fim    and
                 mab-eqpto.cod-emitente   >= p-emitente-ini   and 
                 mab-eqpto.cod-emitente   <= p-emitente-fim   AND
                 mab-eqpto.cod-placa      >= p-placa-ini      AND
                 mab-eqpto.cod-placa      <= p-placa-fim      AND
                 mab-eqpto.dat-compra     >= d-dat-compra-ini and
                 mab-eqpto.dat-compra     <= d-dat-compra-fim and
                 mab-eqpto.val-compra     >= d-val-compra-ini and
                 mab-eqpto.val-compra     <= d-val-compra-fim and
                 ((mab-eqpto.idi-tip-eqpto =  1 and p-motorizados)   /**Equipamentos motorizados**/
                 or
                 (mab-eqpto.idi-tip-eqpto =  2 and p-n-motorizados)) /**Equipamentos n∆o motorizados**/
                 and
                 (( mab-eqpto.idi-tip-propriet = 1 and p-proprios) /**Equipamentos pr¢prios**/
                 OR
                 (mab-eqpto.idi-tip-propriet =  2 and p-terceiros)), /**Equipamentos de terceiros**/
                  FIRST mab-sit-eqpto fields(cod-sit-eqpto des-sit-eqpto) 
                      where mab-sit-eqpto.cod-sit-eqpto = mab-eqpto.cod-sit-eqpto 
                      and ((mab-sit-eqpto.idi-tip =  1 and p-ativos  )   /**Equipamentos Ativos **/
                          or
                          (mab-sit-eqpto.idi-tip =  2 and p-inativos )) NO-LOCK: /**Equipamentos Inativos**/

            IF l-usa-unid-negoc THEN DO:
                &IF DEFINED(bf_mnt_ems206b) &THEN
                    IF NOT(mab-eqpto.cod-unid-negoc >= p-unid-negoc-ini  AND
                           mab-eqpto.cod-unid-negoc <= p-unid-negoc-fim) THEN NEXT.
                &ENDIF
            END.

            for last  mab-movto-km-eqpto fields(val-km-real ep-codigo cod-eqpto val-livre-2) no-lock
                where mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
                AND   mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto:
            END.

            /* Inicializa a vari†vel "l-tem-combustivel" que Ç utilizado no procure "buscaValor" opá∆o 17.
               Somente dever† receber esse valor igual a "YES" quando o equipamento for Motorizado */.
            ASSIGN l-tem-combustivel = NO.
            /* Inicializa a vari†vel "c-tipo-mater" que Ç utilizado no procure "buscaValor" opá∆o 17 */.
            ASSIGN c-tipo-mater = "".
            /*  Se mab-eqpto.idi-tip-eqpto = 1 (Motorizado) ser† realizado o filtro do pelo tipo de Material */
            IF  mab-eqpto.idi-tip-eqpto = 1 THEN DO:
                /* Verifica se o Equipamento tem informaá‰es de Combustivel */
                IF  CAN-FIND (FIRST mab-histor-combust
                              WHERE mab-histor-combust.ep-codigo = mab-eqpto.ep-codigo
                              AND   mab-histor-combust.cod-eqpto = mab-eqpto.cod-eqpto  
                              AND   mab-histor-combust.idi-tip-consu <> 1 /*1-Sem consumo, 2-percurso/qtd, 3-qtd/percurso*/
                              NO-LOCK) THEN DO:

            /***************************************************************************************************************************************************
            Segue um exemplo grafico de um equipamento com tres combustiveis em seu hist¢rico (folder "combustivel" ab0138 )
            
            
            Exemplo quando o ultimo registro n∆o possuir data de Desativaá∆o.
                            ---------------------------------------------- Hit¢rico de Combustivel -------------------------------------------------------------
                            |Inicio                        Desativaá∆o|  |Inicio                        Desativaá∆o|  |Inicio                        Desativaá∆o|
                            |01/01/2014                     01/03/2014|  |01/03/2014                     01/06/2014|  |01/06/2014                     "Sem Data"|
                            |-----------------------------------------|  |-----------------------------------------|  |-----------------------------------------|
                            |     Tipo Material: 001 - Alcool         |  |     Tipo Material: 003 - Gasolina       |  |     Tipo Material: 004 - Flex           |
            
            Possiveis Per°odos Pesquisas:
            ND = Nenhum Combust°vel
            |Pesquisa: 1  ||Pesquisa: 2       |                |Pesquisa: 3       |    |Pesquisa: 4       |     |Pesquisa: 5       |                              |Pesquisa: 6       |  
            |Ini: 01/01/13||Ini: 01/01/14     |                |Ini: 15/02/14     |    |Ini: 01/04/14     |     |Ini: 15/05/14     |                              |Ini: 01/01/15     |  
            |Fim: 31/12/13||Fim: 30/01/14     |                |Fim: 31/03/14     |    |Fim: 30/04/14     |     |Fim: 30/06/14     |                              |Fim: 31/12/15     |  
            |Resultado:   ||Resultado:        |                |Resultado:        |    |Resultado:        |     |Resultado:        |                              |Resultado:        |  
            |ND           ||001 - Alcool      |                |003 - Gasolina    |    |003 - Gasolina    |     |004 - Flex        |                              |004 - Flex        |  
            
            
            
            Outro exemplo, agora quando o ultimo registro possuir data de Desativaá∆o.
            Somente ir† alterar o resultado da pesquisa 6, onde n∆o ir† trazer nenhum combustivel.
                            ---------------------------------------------- Hit¢rico de Combustivel -------------------------------------------------------------
                            |Inicio                        Desativaá∆o|  |Inicio                        Desativaá∆o|  |Inicio                        Desativaá∆o|
                            |01/01/2014                     01/03/2014|  |01/03/2014                     01/06/2014|  |01/06/2014                     31/12/2014|
                            |-----------------------------------------|  |-----------------------------------------|  |-----------------------------------------|
                            |     Tipo Material: 001 - Alcool         |  |     Tipo Material: 003 - Gasolina       |  |     Tipo Material: 004 - Flex           |
            
            Possiveis Per°odos Pesquisas:
            ND = Nenhum Combust°vel
            |Pesquisa: 1  ||Pesquisa: 2       |                |Pesquisa: 3       |    |Pesquisa: 4       |     |Pesquisa: 5       |                              |Pesquisa: 6       |  
            |Ini: 01/01/13||Ini: 01/01/14     |                |Ini: 15/02/14     |    |Ini: 01/04/14     |     |Ini: 15/05/14     |                              |Ini: 01/01/15     |  
            |Fim: 31/12/13||Fim: 30/01/14     |                |Fim: 31/03/14     |    |Fim: 30/04/14     |     |Fim: 30/06/14     |                              |Fim: 31/12/15     |  
            |Resultado:   ||Resultado:        |                |Resultado:        |    |Resultado:        |     |Resultado:        |                              |Resultado:        |  
            |ND           ||001 - Alcool      |                |003 - Gasolina    |    |003 - Gasolina    |     |004 - Flex        |                              |ND                |  

            
            ***************************************************************************************************************************************************/

                    /* Busca o ultimo tipo de material dentro do per°odo informado, VERIFICANDO A DATA DESATIVAÄ«O */
                    FOR LAST mab-histor-combust FIELDS(ep-codigo cod-eqpto dat-inicial cod-tip-mater dat-desativ idi-tip-consu)
                        WHERE mab-histor-combust.ep-codigo = mab-eqpto.ep-codigo
                        AND   mab-histor-combust.cod-eqpto = mab-eqpto.cod-eqpto
                        AND   mab-histor-combust.dat-inicial <= p-periodo-fim
                        AND   mab-histor-combust.idi-tip-consu <> 1
                        AND   ((mab-histor-combust.dat-desativ >= p-periodo-ini) OR (mab-histor-combust.dat-desativ = ?)) USE-INDEX mbhstrcm-id NO-LOCK:
                    END.

                    IF  AVAIL mab-histor-combust THEN DO:
                        /*  Verifica se o tipo de material esta dentro da faixa inicial e final informada */
                        IF  mab-histor-combust.cod-tip-mater >= p-tipo-mater-ini AND mab-histor-combust.cod-tip-mater <= p-tipo-mater-fim THEN DO:
                            /* Guarda valor do campo "mab-histor-combust.cod-tip-mater" para ser utilizado no procure "buscaValor" opá∆o 17 */.
                            ASSIGN c-tipo-mater = mab-histor-combust.cod-tip-mater.
                            ASSIGN l-tem-combustivel = YES.
                        END.
                        ELSE NEXT.
                    END.
                    ELSE
                        NEXT.
                END.
                ELSE DO:
                    /******************************************************************************************************************************
                     Indica que o Equipamento n∆o tem nenhuma informaá‰es de Combust°vel cadastrada.
                     Se o usu†rio escolher o "Tipo de Material" como Vis∆o, ser† exibido como descriá∆o "Equipamento sem Combust°vel Informado", e
                     listar† todos os equipamentos com essa situaá∆o.
                    ******************************************************************************************************************************/
                    ASSIGN l-tem-combustivel = NO.
                END.
            END.

            /** Acompanhamento **/
            RUN pi-Acompanhar IN hHandle (fnLabels(5) + ": " + STRING(mab-eqpto.ep-codigo) + "-" + mab-eqpto.cod-eqpto).
                 /** Primeiro da lista Ç o Pai, ent∆o n∆o contÇm pai **/
                assign cCodPai    = "".
                /** Busca vis‰es escolhidas **/
                for each ttVisao no-lock:
                    /** Busca c¢digo e descriá∆o dos registros da vis∆o **/
                    run buscaValor in this-procedure (input ttVisao.dimensao).
                    /** Verifica se encontrou c¢digo, sen∆o busca pr¢ximo **/
                    if vCodigo = "" then next.
                    /** Carrega os dados  **/
                    run pi-carrega-sequencias in this-procedure.
                END.
        END.
    end. 

IF VALID-HANDLE (hHandle) THEN
    DELETE PROCEDURE hHandle.

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
def input param c-nome  as char no-undo.
def var         c-linha as char no-undo.

/**Limpa as vis‰es**/
&IF integer(entry(1,proversion,".")) >= 9 &THEN
    EMPTY TEMP-TABLE ttVisao.
&ELSE
    for each ttVisao:
        delete ttVisao.
    end.
&ENDIF

input from value (c-nome).

/** Busca os parÉmetros e seleá‰es **/
import unformatted c-linha.
assign c-linha                = replace (c-linha, chr(34), "")
       l-ativos               = (entry(1,c-linha,";") = "yes")
       l-motorizados          = (entry(2,c-linha,";") = "yes")
       l-proprios             = (entry(3,c-linha,";") = "yes")
       l-inativos             = (entry(4,c-linha,";") = "yes")
       l-n-motorizados        = (entry(5,c-linha,";") = "yes")
       l-terceiros            = (entry(6,c-linha,";") = "yes")
       &IF "{&mguni_version}" >= "2.071" &THEN
       i-empresa-ini          = entry(7,c-linha,";")
       i-empresa-fim          = entry(8,c-linha,";")
       &ELSE
       i-empresa-ini          = int(entry(7,c-linha,";"))
       i-empresa-fim          = int(entry(8,c-linha,";"))
       &ENDIF
       c-equipto-ini          = entry(9,c-linha,";")
       c-equipto-fim          = entry(10,c-linha,";")
       c-grupo-ini            = entry(11,c-linha,";")
       c-grupo-fim            = entry(12,c-linha,";")
       c-modelo-ini           = entry(13,c-linha,";")
       c-modelo-fim           = entry(14,c-linha,";")
       c-estab-ini            = entry(15,c-linha,";")
       c-estab-fim            = entry(16,c-linha,";")
       c-tag-ini              = entry(17,c-linha,";")
       c-tag-fim              = entry(18,c-linha,";")
       c-estrut-ini           = entry(19,c-linha,";")
       c-estrut-fim           = entry(20,c-linha,";")
       c-ccusto-ini           = entry(21,c-linha,";")
       c-ccusto-fim           = entry(22,c-linha,";")
       c-sit-ini              = entry(23,c-linha,";")
       c-sit-fim              = entry(24,c-linha,";")
       i-ano-fabric-ini       = int(entry(25,c-linha,";"))
       i-ano-fabric-fim       = int(entry(26,c-linha,";"))
       d-periodo-ini          = date(entry(27,c-linha,";")) 
       d-periodo-fim          = date(entry(28,c-linha,";"))
       i-emitente-ini         = int(entry(29,c-linha,";"))
       i-emitente-fim         = int(entry(30,c-linha,";"))
       i-placa-ini            = ENTRY(31,c-linha,";")
       i-placa-fim            = ENTRY(32,c-linha,";")
       d-dat-compra-ini       = date(ENTRY(33,c-linha,";"))
       d-dat-compra-fim       = date(ENTRY(34,c-linha,";"))
       d-val-compra-ini       = dec(ENTRY(35,c-linha,";"))
       d-val-compra-fim       = dec(ENTRY(36,c-linha,";"))
       c-tipo-mater-ini       = ENTRY(37,c-linha,";")
       c-tipo-mater-fim       = ENTRY(38,c-linha,";").

    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN c-unid-negoc-ini = entry(39,c-linha,";")
                   c-unid-negoc-fim = entry(40,c-linha,";")
                   l-hodometro      = (entry(41,c-linha,";") = "yes").
        &ENDIF
    END.
    ELSE DO:
        ASSIGN l-hodometro      = (entry(39,c-linha,";") = "yes").
    END.


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

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTEquipto wWindow 
PROCEDURE carregaTTEquipto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/***ParÉmetros de seleá∆o e do filtro**/
&IF "{&mguni_version}" >= "2.071" &THEN
def input param p-empresa-ini         LIKE empresa.ep-codigo  no-undo.
&ELSE
def input param p-empresa-ini         as int  no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def input param p-empresa-fim         LIKE empresa.ep-codigo  no-undo.
&ELSE
def input param p-empresa-fim         as int  no-undo.
&ENDIF
def input param p-equipto-ini         as char no-undo.
def input param p-equipto-fim         as char no-undo.
def input param p-grupo-ini           as char no-undo.
def input param p-grupo-fim           as char no-undo.
def input param p-modelo-ini          as char no-undo.
def input param p-modelo-fim          as char no-undo.
def input param p-estab-ini           as char no-undo.
def input param p-estab-fim           as char no-undo.
def input param p-tag-ini             as char no-undo.
def input param p-tag-fim             as char no-undo.
def input param p-estrut-ini          as char no-undo. 
def input param p-estrut-fim          as char no-undo.
def input param p-ccusto-ini          as char no-undo. 
def input param p-ccusto-fim          as char no-undo.
def input param p-sit-ini             as char no-undo.
def input param p-sit-fim             as char no-undo.
def input param p-ano-fabric-ini      as int  no-undo.
def input param p-ano-fabric-fim      as int  no-undo.
def input param p-periodo-ini         as date no-undo.
def input param p-periodo-fim         as date no-undo.
def input param p-emitente-ini        as int  no-undo.
def input param p-emitente-fim        as int  no-undo.
DEF INPUT PARAM p-placa-ini           AS CHAR NO-UNDO.
DEF INPUT PARAM p-placa-fim           AS CHAR NO-UNDO.
def input param p-ativos              as log  no-undo.
def input param p-motorizados         as log  no-undo.
def input param p-proprios            as log  no-undo.
def input param p-inativos            as log  no-undo.
def input param p-n-motorizados       as log  no-undo.
def input param p-terceiros           as log  no-undo.
DEF INPUT PARAM p-tipo-mater-ini      AS CHAR NO-UNDO.
DEF INPUT PARAM p-tipo-mater-fim      AS CHAR NO-UNDO.
&IF DEFINED(bf_mnt_ems206b) &THEN
def input param p-unid-negoc-ini      as char no-undo.
def input param p-unid-negoc-fim      as char no-undo.
&ENDIF

/**Limpa as vis‰es**/
&IF integer(entry(1,proversion,".")) >= 9 &THEN
      EMPTY TEMP-TABLE ttVisao1.
&ELSE
      for each ttVisao:
        delete ttVisao1.
      end.
&ENDIF

    /**Executa a procedure carregaEquipto com base nos parÉmetros de seleá∆o e filtro definidos**/
       RUN carregaEquipto ( input  p-empresa-ini,     
                            input  p-empresa-fim,     
                            input  p-equipto-ini,     
                            input  p-equipto-fim,     
                            input  p-grupo-ini,       
                            input  p-grupo-fim,       
                            input  p-modelo-ini,      
                            input  p-modelo-fim,      
                            input  p-estab-ini,       
                            input  p-estab-fim,       
                            input  p-tag-ini,         
                            input  p-tag-fim,         
                            input  p-estrut-ini,      
                            input  p-estrut-fim,      
                            input  p-ccusto-ini,      
                            input  p-ccusto-fim,      
                            input  p-sit-ini,         
                            input  p-sit-fim,         
                            input  p-ano-fabric-ini, 
                            input  p-ano-fabric-fim, 
                            input  p-periodo-ini,    
                            input  p-periodo-fim,
                            input  p-emitente-ini,    
                            input  p-emitente-fim,
                            INPUT  p-placa-ini,
                            INPUT  p-placa-fim,
                            input  p-ativos,       
                            input  p-motorizados,  
                            input  p-proprios,     
                            input  p-inativos,     
                            input  p-n-motorizados,
                            input  p-terceiros,
                            INPUT  c-tipo-mater-ini,
                            INPUT  c-tipo-mater-fim
                            &IF DEFINED(bf_mnt_ems206b) &THEN
                            , INPUT p-unid-negoc-ini,
                              INPUT p-unid-negoc-fim
                            &ENDIF
                            ).

return "OK":U. 
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTreeList wWindow 
PROCEDURE criaTreeList :
/*------------------------------------------------------------------------------
  Purpose:      criaTreeList             
  Parameters:   <none>                   
  Notes:        Cria os n¢s do tree-list 
------------------------------------------------------------------------------*/
define variable iQtSeq  as integer initial 0 no-undo.
DEFINE VARIABLE i       AS INTEGER           NO-UNDO.
DEFINE VARIABLE c-texto AS CHARACTER         NO-UNDO.
define buffer bfttVisao1 for ttVisao1.
DEFINE VARIABLE cDimensao AS CHARACTER INITIAL "" NO-UNDO.
    assign i-cont = 0.
    /** Verifica se existem vis‰es escolhidas **/
    for last ttVisao fields(sequencia) no-lock:
        assign iQtSeq = ttVisao.sequencia.
    end.
        if iQtSeq = 0 then return.
    
    /** Busca os dados criados **/
    for each  ttVisao1 
        where ttVisao1.sequencia  < iQtSeq 
        BY ttVisao1.cod-dimens-pai:
       
        if ttVisao1.sequencia < iVisao then
            assign lReal = no. 
        else assign lReal = yes.      
        /** Conta sequàncias de linhas **/                                                     
        assign i-cont = i-cont + 1.                                   
        assign ttVisao1.seq-tree = i-cont.
        /** define texto do n¢ **/                                                        
                                                 
        ASSIGN c-texto = ttVisao1.cod-oficial + " - " + ttVisao1.desc-dimensao.
        /** Inclui primeira dimens∆o **/
        IF  ttVisao1.sequencia  =   1   THEN    DO:
            oTreeList:addNode("", "i" + STRING(i-cont), c-texto).

            oTreeList:setData(    "i" + STRING(i-cont), "quant-eqpto" , STRING(ttVisao1.quant-eqpto,">>>,>>>,>>9")).
            oTreeList:setData(    "i" + STRING(i-cont), "iIdMedia"    , STRING(ttVisao1.iIdMedia   ,">>>9.99")).
    
            IF  lreal   THEN    DO:
                oTreeList:setData(    "i" + STRING(i-cont), "km-rodado" , STRING(ttVisao1.km-rodado,">>>,>>>,>>9.9")).
                oTreeList:setData(    "i" + STRING(i-cont), "un"        , STRING(ttVisao1.un       ,"x(10)")).
                oTreeList:setData(    "i" + STRING(i-cont), "km-sec"    , STRING(ttVisao1.km-sec   ,">>>,>>>,>>9.9")).
                oTreeList:setData(    "i" + STRING(i-cont), "un-sec"    , STRING(ttVisao1.un-sec   ,"x(10)")).
            END.
            ELSE    DO:
                oTreeList:setData(    "i" + STRING(i-cont), "km-rodado" , " ").
                oTreeList:setData(    "i" + STRING(i-cont), "un"        , "").
                oTreeList:setData(    "i" + STRING(i-cont), "km-sec"    , " ").
                oTreeList:setData(    "i" + STRING(i-cont), "un-sec"    , "").
            END.

            IF  ttVisao1.quant-eqpto    =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "quant-eqpto" , "").
            IF  ttVisao1.iIdMedia       =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "iIdMedia"    , "").
            IF  ttVisao1.km-rodado      =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "km-rodado"   , "").
            IF  ttVisao1.un             =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "un"          , "").
            IF  ttVisao1.km-sec         =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "km-sec"      , "").
            IF  ttVisao1.un-sec         =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "un-sec"      , "").
    
            oTreeList:setData("i" + STRING(i-cont), "p-image"          , ttVisao1.p-image).
            oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"    , STRING(ROWID(ttVisao1))).
      
            IF  ttVisao1.r-rowid <>  ?   THEN
                oTreeList:setData("i" + STRING(i-cont), "r-rowid"      , STRING(ttVisao1.r-rowid)).
        END.
        ELSE    DO:
            /** Busca filhos da vis∆o escolhida **/
            FOR FIRST   bfttVisao1  FIELDS(seq-tree)
                WHERE   bfttVisao1.cod-dimensao =   ttVisao1.cod-dimens-pai NO-LOCK:

                oTreeList:addNode("i" + STRING(bfttVisao1.seq-tree), "i" + STRING(i-cont), c-texto).

                oTreeList:setData("i" + STRING(i-cont), "quant-eqpto" , STRING(ttVisao1.quant-eqpto,">>>,>>>,>>9")).
                oTreeList:setData("i" + STRING(i-cont), "iIdMedia"    , STRING(ttVisao1.iIdMedia   ,">>>9.99")).

                IF  lreal   THEN    DO:
                    oTreeList:setData(    "i" + STRING(i-cont), "km-rodado" , STRING(ttVisao1.km-rodado,">>>,>>>,>>9.9")).
                    oTreeList:setData(    "i" + STRING(i-cont), "un"        , STRING(ttVisao1.un       ,"x(10)")).
                    oTreeList:setData(    "i" + STRING(i-cont), "km-sec"    , STRING(ttVisao1.km-sec   ,">>>,>>>,>>9.9")).
                    oTreeList:setData(    "i" + STRING(i-cont), "un-sec"    , STRING(ttVisao1.un-sec   ,"x(10)")).
                END.
                ELSE    DO:
                    oTreeList:setData(    "i" + STRING(i-cont), "km-rodado" , " ").
                    oTreeList:setData(    "i" + STRING(i-cont), "un"        , "").
                    oTreeList:setData(    "i" + STRING(i-cont), "km-sec"    , " ").
                    oTreeList:setData(    "i" + STRING(i-cont), "un-sec"    , "").
                END.

                IF  ttVisao1.quant-eqpto    =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "quant-eqpto" , "").
                IF  ttVisao1.iIdMedia       =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "iIdMedia"    , "").
                IF  ttVisao1.km-rodado      =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "km-rodado"   , "").
                IF  ttVisao1.un             =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "un"          , "").
                IF  ttVisao1.km-sec         =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "km-sec"      , "").
                IF  ttVisao1.un-sec         =   ?   THEN    oTreeList:setData(    "i" + STRING(i-cont), "un-sec"      , "").

                oTreeList:setData("i" + STRING(i-cont), "p-image"          , ttVisao1.p-image).
                oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"    , STRING(ROWID(ttVisao1))).

                IF  ttVisao1.r-rowid <>  ?   THEN
                    oTreeList:setData("i" + STRING(i-cont), "r-rowid"      , STRING(ttVisao1.r-rowid)).        
            END.
        END.
    END.

oTreeList:REFRESH().

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expandeItem wWindow 
PROCEDURE expandeItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-node   as com-handle no-undo.
def input param p-expcon as log        no-undo.

def var h-child as com-handle no-undo.
def var i-aux   as int        no-undo.
assign p-node:Expanded = p-expcon
       h-child         = p-node:Children.
do i-aux = 1 to p-node:Children:
  /*  assign h-child = h-child:next.*/
end.

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
/*define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttVisao1
            where bfttVisao1.cod-dimensao = cCodPai no-lock) then do:
    for first bfttVisao1
        where bfttVisao1.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfttVisao1),
                          input bfttVisao1.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttVisao1
    where rowid(bfttVisao1) = rRow no-lock:
end.
if avail bfttVisao1 then do:
    /** Cria os dados na temp-table do excel **/
   {abp/ab0604.i2 bfttVisao1.p-image}
   create tt-dados-ex.
   assign tt-dados-ex.celula-coluna        = 1
          tt-dados-ex.celula-linha         = i-cont2
          tt-dados-ex.celula-cor-interior  = 27
          tt-dados-ex.celula-fonte-cor     = 1
          tt-dados-ex.celula-fonte-negrito = yes
          tt-dados-ex.celula-valor         = trim(return-value) + ":" +  bfttVisao1.cod-oficial + "-" + bfttVisao1.desc-dimensao
          i-cont2                          = i-cont2 + 1.
end.

return "OK":U.*/
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
  Notes:       Cria os dados no arquivo txt para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow          as rowid     no-undo.
define input parameter cCodPai       as character no-undo.
define input parameter cDelim        as character no-undo. 
  
/** Zera vari†veis **/
assign cDescPai   = ""
       cTituloTxt = "".
/** Verifica se existem n°veis acima **/
if can-find(first bfttVisao1
            where bfttVisao1.cod-dimensao = cCodPai no-lock) then do:
    for first bfttVisao1
        where bfttVisao1.cod-dimensao = cCodPai no-lock:
        run imprimeVisaoTxt (input rowid(bfttVisao1),
                             input bfttVisao1.cod-dimens-pai,
                             input cDelim).
    end.
end.
/** Busca os dados **/
for first bfttVisao1
    where rowid(bfttVisao1) = rRow no-lock:
    {abp/ab0604.i2 bfttVisao1.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelim.
end.
if avail bfttVisao1 then do:
    assign cDescPai  = trim(trim(cDescPai) + trim(bfttVisao1.cod-oficial) + "-" + TRIM(bfttVisao1.desc-dimensao) + cDelim).
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-sequencias wWindow 
PROCEDURE pi-carrega-sequencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Busca registro **/
find first ttVisao1
     where ttVisao1.cod-dimensao  = (cCodPai + "#" + vCodigo)
     and   ttVisao1.sequencia     = ttVisao.sequencia exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttVisao1 then do:
   create ttVisao1.
   assign ttVisao1.cod-dimensao    = (cCodPai + "#" +  vCodigo)  /** C¢digo encadeado para tree-view **/
          ttVisao1.cod-oficial     = vCodigo              /** C¢digo Original do registro **/
          ttVisao1.desc-dimensao   = vDescricao           /** Descriá∆o do c¢digo **/
          ttVisao1.sequencia       = ttVisao.sequencia    /** Sequància dos dados **/
          ttVisao1.p-image         = iImage               /** N£mero da imagem do registro **/
          ttVisao1.r-rowid         = rRowid               /** Rowid do registro para consultas futuras **/
          ttVisao1.cod-dimens-pai  = cCodPai.             /** C¢digo do pai do registro **/
end.

assign cCodPai = ttVisao1.cod-dimensao.

if ttVisao1.sequencia < iVisao then assign lReal = no.
                              else assign lReal = yes.

/** Calcula apenas para registros **/ 

/* herc°lio  - alteraá∆o */
ASSIGN ttVisao1.quant-eqpto = ttVisao1.quant-eqpto + 1.

IF YEAR(mab-eqpto.dat-compra) = mab-eqpto.vli-ano-model  THEN DO:
    ASSIGN ttVisao1.ano-vida = ttVisao1.ano-vida + (TODAY - mab-eqpto.dat-compra) / 365.
END.
ELSE DO:
    IF YEAR(mab-eqpto.dat-compra) = mab-eqpto.vli-ano-fabric  THEN DO:
        ASSIGN ttVisao1.ano-vida = ttVisao1.ano-vida + (TODAY - mab-eqpto.dat-compra) / 365.
    END.
    ELSE DO:
        ASSIGN ttVisao1.ano-vida = ttVisao1.ano-vida + (TODAY - DATE(01,01,mab-eqpto.vli-ano-fabric)) / 365.
    END.
END.

/* Para setar UN */
FOR FIRST mab-model
    WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
END.

ASSIGN cCodPai = ttVisao1.cod-dimensao.


/* Posiciona no historico mais recente, ou seja, o ultimo */
FIND LAST bf-mab-movto-km-eqpto
     WHERE bf-mab-movto-km-eqpto.ep-codigo   = mab-movto-km-eqpto.ep-codigo
     AND   bf-mab-movto-km-eqpto.cod-eqpto = mab-movto-km-eqpto.cod-eqpto NO-LOCK NO-ERROR.

if lReal then do:
    IF AVAIL mab-movto-km-eqpto THEN DO:
        ASSIGN ttVisao1.km-rodado = ttVisao1.km-rodado + mab-movto-km-eqpto.val-km-real 
               ttVisao1.un = mab-model.un.
    END.
    /*Se Contador segund†rio estiver selecionado*/
    IF mab-eqpto.log-cont-sec THEN DO:
        ASSIGN ttVisao1.km-sec = IF AVAIL mab-movto-km-eqpto THEN ttVisao1.km-sec + mab-movto-km-eqpto.val-livre-2 ELSE ttVisao1.km-sec + 0
               ttVisao1.un-sec = SUBSTRING(mab-model.cod-livre-1,1,2).
    END.


    /* Atualiza as variaveis responsaveis por exibir o hodometro/horimetro atual do equipamento */
    IF AVAIL bf-mab-movto-km-eqpto THEN DO:
        ASSIGN ttVisao1.hodometro-pri = bf-mab-movto-km-eqpto.val-hodom-horim.
        /*Se Contador segund†rio estiver selecionado*/
        IF mab-eqpto.log-cont-sec THEN DO:
            ASSIGN ttVisao1.hodometro-sec = IF AVAIL bf-mab-movto-km-eqpto THEN bf-mab-movto-km-eqpto.val-livre-1 ELSE 0.
        END.
    END.
end.
/* fim alteraá∆o xavier  */

/***Calcula para todas as dimens‰es a idade mÇdia do veiculo***/
ASSIGN ttVisao1.iIdMedia  = ttVisao1.ano-vida / ttVisao1.quant-eqpto.

RETURN "OK":U.

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
/*define variable i-lin        as integer initial 1 no-undo.
define variable i-col        as integer initial 1 no-undo.
define variable rRowid       as rowid             no-undo.
define variable hHandle      as handle            no-undo.
define variable hHandle2     as handle            no-undo.
define variable c-colunas    as character         no-undo.
define variable cDimensao    as character         no-undo.
define variable cDimensaoPai as character         no-undo.
DEFINE VARIABLE iControl     as integer initial 0 no-undo. /**Controle para formataá∆o da celula***/
/** Limpa temp-table Excel **/
empty temp-table tt-dados-ex.
/** Guarda rowid do tree-view **/
assign rRowid    = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao"))
       cDimensao = ""
       i-col     = 1
       i-lin     = 0 
       c-colunas = "".
/** Busca Registro **/
for first ttVisao1
    where rowid(ttVisao1) = rRowid no-lock:
    assign cDimensao     = ttVisao1.cod-dimensao
           cDimensaoPai  = ttVisao1.cod-dimens-pai.
end.
if avail ttVisao1 then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttVisao1
                    where bfttVisao1.cod-dimens-pai = ttVisao1.cod-dimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttVisao1
            where bfttVisao1.cod-dimensao = ttVisao1.cod-dimens-pai no-lock:
            assign cDimensao             = ttVisao1.cod-dimensao
                   cDimensaoPai          = bfttVisao1.cod-dimens-pai.
        end.
    end.
end.

/** Encontra n£mero total de colunas **/
do i-col = 1 TO brDetalhe:num-columns in frame fPage0:
    hHandle = brDetalhe:get-browse-column(i-col).
    /** Guarda t°tulos das colunas **/
    assign c-colunas = c-colunas + hHandle:name.
    if i-col <> brDetalhe:num-columns  then
        assign c-colunas = c-colunas + ",".
end.
/** Verifica se existem linhas no browse **/
if num-results("brDetalhe":U) > 0 then do:
    assign i-cont2 = 1.
    /** Cria os c¢digos dos pais **/
    run imprimeVisao (input rRowid,
                      input cDimensaoPai).
    assign i-lin = i-cont2.
    /** Percorre registros para criar dados no gr†fico **/
    for each  ttVisao1
        where ttVisao1.cod-dimens-pai = cDimensao no-lock:
       /** In°cio contador de colunas do Browse**/
       do i-col = 1 to brDetalhe:num-columns in frame fPage0 :

           /** Contador para linhas **/
           if i-lin = i-cont2 then do:
               create tt-dados-ex.
               assign tt-dados-ex.celula-coluna        = i-col
                      tt-dados-ex.celula-linha         = i-lin
                      tt-dados-ex.celula-cor-interior  = 10
                      tt-dados-ex.celula-fonte-cor     = 19
                      tt-dados-ex.celula-fonte-negrito = yes.
               assign tt-dados-ex.celula-valor         = if i-col = 1 
                                                         then string(fnLabels(ttVisao1.p-image))
                                                         else string(fnBrowse(entry(i-col,c-colunas),1)).
           end.
           /** Impress∆o da primeira linha de dados **/
            hHandle2 = brDetalhe:get-browse-column(i-col).
            /** teste se  colunas Ç c¢digo ou descriá∆o **/
            IF hHandle2:NAME = "cod-oficial":u OR hHandle:NAME  = "desc-dimensao":U THEN DO: /*** Verifica nome interno da coluna do browser n∆o
                                                                                                  Ç necess†rio traduá∆o pois testa nome inteno da tabela***/
               ASSIGN iControl = 1.
            END.
            ELSE DO:
                ASSIGN iControl = 2.
            END.
           create tt-dados-ex.
           assign tt-dados-ex.celula-coluna  = i-col
                  tt-dados-ex.celula-linha   = i-lin + 1.
                  tt-dados-ex.celula-formato = IF iControl = 1 THEN "@" ELSE "". /**Formata celula se 1 = texto , se 2 = geral**/
           assign tt-dados-ex.celula-valor  = string(fnBrowse(entry(i-col,c-colunas),2)).
       end. /** Colunas **/
       assign i-lin = i-lin + 1.
    end.
end.
     
/** Programa que gera o XLS **/
run abp/ab9003.p(input "ab0604":U,
                 input table tt-dados-ex).
if return-value = "NOK":U then .
   
return "OK":U.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-erro-nivel wWindow 
PROCEDURE pi-retorna-erro-nivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Pr¢ximo_N°vel" *}
run utp/ut-msgs.p (input "show":U,
                   input 5573,
                   input RETURN-VALUE).
RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsumo wWindow 
PROCEDURE piConsumo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable hEqpto as handle    no-undo.
define variable iEmp   LIKE mab-eqpto.ep-codigo  no-undo.
define variable cEqpto  as character no-undo.
        if INTEGER(oTreeList:getDataChar(oTreeList:currentCode, "p-image")) = 6 then do:
            /** Guarda rowid do tree-view **/
            assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).
            for first mab-eqpto
                where rowid(mab-eqpto) = rRowid no-lock:
                assign iEmp   = mab-eqpto.ep-codigo
                       cEqpto = mab-eqpto.cod-eqpto.
        
                create ttSelecao2.                                       
                assign ttSelecao2.empresa-ini      = mab-eqpto.ep-codigo                       
                       ttSelecao2.empresa-fim      = mab-eqpto.ep-codigo                           
                       ttSelecao2.equipto-ini      = mab-eqpto.cod-eqpto                           
                       ttSelecao2.equipto-fim      = mab-eqpto.cod-eqpto                           
                       ttSelecao2.grupo-ini        = mab-eqpto.cod-grp-eqpto                       
                       ttSelecao2.grupo-fim        = mab-eqpto.cod-grp-eqpto                       
                       ttSelecao2.modelo-ini       = mab-eqpto.cod-model                           
                       ttSelecao2.modelo-fim       = mab-eqpto.cod-model                           
                       ttSelecao2.estab-ini        = mab-eqpto.cod-estabel                         
                       ttSelecao2.estab-fim        = mab-eqpto.cod-estabel                         
                       ttSelecao2.tag-ini          = mab-eqpto.cd-tag                              
                       ttSelecao2.tag-fim          = mab-eqpto.cd-tag                              
                       ttSelecao2.estrut-ini       = mab-eqpto.cod-estrut-mec                      
                       ttSelecao2.estrut-fim       = mab-eqpto.cod-estrut-mec                      
                       ttSelecao2.cc-cod-eqpto-ini = mab-eqpto.cc-codigo                           
                       ttSelecao2.cc-cod-eqpto-fim = mab-eqpto.cc-codigo                           
                       ttSelecao2.sit-ini          = mab-eqpto.cod-sit-eqpto                
                       ttSelecao2.sit-fim          = mab-eqpto.cod-sit-eqpto                
                       ttSelecao2.atividade-ini    = ""                                         
                       ttSelecao2.atividade-fim    = "ZZZZZZZZ"                             
                       ttSelecao2.periodo-ini      = TODAY - 7                     
                       ttSelecao2.periodo-fim      = TODAY                      
                       ttSelecao2.trajeto-ini      = ""                                     
                       ttSelecao2.trajeto-fim      = "ZZZZZZZZZZZZ"
                       ttSelecao2.cc-cod-docto-ini = ""
                       ttSelecao2.cc-cod-docto-fim = "ZZZZZZZZZZZZZZZZZZZZ"
                       ttSelecao2.lAtivos          = yes                                    
                       ttSelecao2.lProprios        = yes                                 
                       ttSelecao2.lInativos        = no                                  
                       ttSelecao2.lTerceiros       = no
                       ttSelecao2.lOK              = yes
                       ttSelecao2.lIrregular       = yes
                       ttSelecao2.lLogContSec      = mab-eqpto.log-cont-sec
                       ttSelecao2.lDesperdicio     = no
                       ttSelecao2.classificacao    = 1
                       ttSelecao2.cod-emitente-ini = 0
                       ttSelecao2.cod-emitente-fim = 999999999
                    &IF DEFINED(bf_mnt_ems206b) &THEN
                       ttSelecao2.cod-unid-negoc-ini = mab-eqpto.cod-unid-negoc
                       ttSelecao2.cod-unid-negoc-fim = mab-eqpto.cod-unid-negoc
                    &ENDIF
                        .
            end.
        end.
          else do:
            get current brDetalhe no-lock.
            for first mab-eqpto
                where rowid(mab-eqpto) = ttVisao1.r-rowid no-lock:
                assign iEmp   = mab-eqpto.ep-codigo
                       cEqpto = mab-eqpto.cod-eqpto.
        
                create ttSelecao2.                                       
                assign ttSelecao2.empresa-ini      = mab-eqpto.ep-codigo                       
                       ttSelecao2.empresa-fim      = mab-eqpto.ep-codigo                           
                       ttSelecao2.equipto-ini      = mab-eqpto.cod-eqpto                           
                       ttSelecao2.equipto-fim      = mab-eqpto.cod-eqpto                           
                       ttSelecao2.grupo-ini        = mab-eqpto.cod-grp-eqpto                       
                       ttSelecao2.grupo-fim        = mab-eqpto.cod-grp-eqpto                       
                       ttSelecao2.modelo-ini       = mab-eqpto.cod-model                           
                       ttSelecao2.modelo-fim       = mab-eqpto.cod-model                           
                       ttSelecao2.estab-ini        = mab-eqpto.cod-estabel                         
                       ttSelecao2.estab-fim        = mab-eqpto.cod-estabel                         
                       ttSelecao2.tag-ini          = mab-eqpto.cd-tag                              
                       ttSelecao2.tag-fim          = mab-eqpto.cd-tag                              
                       ttSelecao2.estrut-ini       = mab-eqpto.cod-estrut-mec                      
                       ttSelecao2.estrut-fim       = mab-eqpto.cod-estrut-mec                      
                       ttSelecao2.cc-cod-eqpto-ini = mab-eqpto.cc-codigo                           
                       ttSelecao2.cc-cod-eqpto-fim = mab-eqpto.cc-codigo                           
                       ttSelecao2.sit-ini          = mab-eqpto.cod-sit-eqpto                
                       ttSelecao2.sit-fim          = mab-eqpto.cod-sit-eqpto                
                       ttSelecao2.atividade-ini    = ""                                         
                       ttSelecao2.atividade-fim    = "ZZZZZZZZ"                             
                       ttSelecao2.periodo-ini      = TODAY - 7                     
                       ttSelecao2.periodo-fim      = TODAY                      
                       ttSelecao2.trajeto-ini      = ""                                     
                       ttSelecao2.trajeto-fim      = "ZZZZZZZZ"                             
                       ttSelecao2.cc-cod-docto-ini = ""
                       ttSelecao2.cc-cod-docto-fim = "ZZZZZZZZZZZZZZZZZZZZ"
                       ttSelecao2.lAtivos          = yes                                    
                       ttSelecao2.lProprios        = yes                                 
                       ttSelecao2.lInativos        = no                                  
                       ttSelecao2.lTerceiros       = no
                       ttSelecao2.lOK              = yes
                       ttSelecao2.lIrregular       = yes
                       ttSelecao2.lLogContSec      = mab-eqpto.log-cont-sec
                       ttSelecao2.lDesperdicio     = no
                       ttSelecao2.classificacao    = 1
                       ttSelecao2.cod-emitente-ini = 0
                       ttSelecao2.cod-emitente-fim = 999999999
                    &IF DEFINED(bf_mnt_ems206b) &THEN
                       ttSelecao2.cod-unid-negoc-ini = mab-eqpto.cod-unid-negoc
                       ttSelecao2.cod-unid-negoc-fim = mab-eqpto.cod-unid-negoc
                    &ENDIF
                        .
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
            /*--- Executa programa de inclus∆o de filho ---*/
            Run abp/ab0609.w PERSISTENT SET hEqpto.
            
            /* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
            IF VALID-HANDLE(hEqpto) AND
               hEqpto:Type = "PROCEDURE":U AND
               hEqpto:FILE-NAME = "abp/ab0609.w":U THEN
                /*--- Inicializa programa de inclus∆o de filho ---*/
               Run initializeInterface IN hEqpto.
               run setaEquipamento in hEqpto (input TABLE ttSelecao2).
            
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
  Purpose:      piCriaVisao                               
  Parameters:   <none>                                    
  Notes:        Cria as vis‰es se n∆o foram selecionadas  
------------------------------------------------------------------------------*/    
     CREATE ttVisao.
     {utp/ut-liter.i Empresa}
     ASSIGN ttVisao.dimensao  = '01 ' +  trim(RETURN-VALUE)
            ttVisao.sequencia = 1.
     CREATE ttVisao.
     {utp/ut-liter.i Tipo_Equipamento}
     ASSIGN ttVisao.dimensao  =  '02 ' +  trim(RETURN-VALUE)
            ttVisao.sequencia = 2.
     CREATE ttVisao.
     {utp/ut-liter.i Grupo}
     ASSIGN ttVisao.dimensao =  '04 ' +  trim(RETURN-VALUE)
            ttVisao.sequencia = 3.
     CREATE ttVisao.
     {utp/ut-liter.i Modelo}
     ASSIGN ttVisao.dimensao =  '05 ' +  trim(RETURN-VALUE)
            ttVisao.sequencia = 4.
     CREATE ttVisao.
     {utp/ut-liter.i Equipamento}
     ASSIGN ttVisao.dimensao =  '06 ' + trim(RETURN-VALUE)
            ttVisao.sequencia = 5.
   
return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEvento wWindow 
PROCEDURE piEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hEvento AS HANDLE     NO-UNDO.

    /*--- Seta cursor do mouse para espera ---*/
            SESSION:SET-WAIT-STATE("GENERAL":U).
            assign {&window-name}:sensitive = no.
            /*--- Executa programa de inclus∆o de filho ---*/
            Run abp/ab0303.w PERSISTENT SET hEvento.
            
            /* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
            IF VALID-HANDLE(hEvento) AND
               hEvento:Type = "PROCEDURE":U AND
               hEvento:FILE-NAME = "abp/ab0303.w":U THEN
                /*--- Inicializa programa de inclus∆o de filho ---*/
               Run initializeInterface IN hEvento.
               run setaEvento in hEvento.
            
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
  Purpose:     
  Parameters:  <none>
  Notes:       
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
run abp/ab0604f.w (output i-impressao,
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

    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i "Exportaá∆o Excel" *}                          
    run pi-inicializar in h-acomp(input RETURN-VALUE).
    
    blk2:
    do on stop undo, return "NOK":U:
        /** Somente vis∆o selecionada **/
        if i-impressao = 1 then do:
            /** Guarda rowid do tree-view **/
            assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
            /** Busca Registro **/
            for first bfttVisao1
                where rowid(bfttVisao1) = rRowid no-lock:
                assign iVisaoAux = bfttVisao1.sequencia.
                run piExcelDados (input bfttVisao1.cod-dimensao).
            end.
        end.
        /** Completo **/
        else do:
            /** Guarda rowid do tree-view **/
            assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
            for first bfttVisao1
                where rowid(bfttVisao1) = rRowid NO-LOCK:
                assign iVisaoAux = bfttVisao1.sequencia.
            end.

            for each  bfttVisao1
                where bfttVisao1.sequencia = iVisaoAux no-lock:
                  run piExcelDados (input bfttVisao1.cod-dimensao).
            end.
        end.
        run pi-finalizar in h-acomp. 
    
        /** Programa que gera o XLS **/
        validate tt-dados-ex.
        run abp/ab9003.p(input "ab0604":U,
                         input table tt-dados-ex).
        if return-value = "NOK":U then .
    
        /** Posiciona o Tree-View no £ltimo lido **/
        IF  oTreeList:hasNode() THEN
            oTreeList:selectLine(oTreeList:currentCode) NO-ERROR.
    end.
end.
   
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcelDados wWindow 
PROCEDURE piExcelDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE c-cod-dimens-pai AS CHARACTER  NO-UNDO.
define input parameter pDimensao as character  no-undo.
define variable cPai             as character  no-undo.
DEFINE VARIABLE i-col-aux        AS INTEGER    NO-UNDO.

assign cPai = "".

for each  ttVisao1 
    where ttVisao1.cod-dimens-pai = pDimensao no-lock:
    
    assign c-cod-dimens-pai = replace(ttVisao1.cod-dimens-pai,"#","-").
   
    RUN pi-acompanhar IN h-acomp (INPUT substring(c-cod-dimens-pai,2,100)).
    /** Verifica se existem n°veis abaixo  **/
    if ttVisao1.sequencia <= iVisaoAux then do:
        run piExcelDados (ttVisao1.cod-dimensao).
    end.
    
    else do:
        if cPai <> ttVisao1.cod-dimens-pai then do:
            /** Imprime os cabeáalhos **/
            run piExcelVisao (input rowid(ttVisao1),         
                              input ttVisao1.cod-dimens-pai).
            assign cPai  = ttVisao1.cod-dimens-pai
                   i-lin = i-lin2.
        end.

       assign i-col-aux = 1.
       /** In°cio contador de colunas do Browse**/
       do i-col = 1 to brDetalhe:num-columns in frame fPage0:

           hHandle = brDetalhe:get-browse-column(i-col).

           if hHandle:VISIBLE then do:              
               /** Contador para linhas **/
               if i-lin = i-lin2 then do:
                   create tt-dados-ex.
                   assign tt-dados-ex.celula-coluna        = i-col-aux
                          tt-dados-ex.celula-linha         = i-lin
                          tt-dados-ex.celula-cor-interior  = 10
                          tt-dados-ex.celula-fonte-cor     = 19
                          tt-dados-ex.celula-fonte-negrito = yes.
                   assign tt-dados-ex.celula-valor         = if i-col = 1 
                                                             then fnLabels(ttVisao1.p-image)
                                                             else fnBrowse(entry(i-col,c-colunas),1).
                end.         
    
               /** Impress∆o da primeira linha de dados **/
               create tt-dados-ex.
               assign tt-dados-ex.celula-coluna = i-col-aux
                      tt-dados-ex.celula-linha  = i-lin + 1.
               assign tt-dados-ex.celula-valor  = fnBrowse(entry(i-col,c-colunas),2).
               
               /** Para c¢digo, coloca formato TEXTO **/
               if entry(i-col,c-colunas) = "cod-oficial":U  then do:
                   assign tt-dados-ex.celula-formato = "@":U.
               end.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttVisao2
            where bfttVisao2.cod-dimensao = cCodPai no-lock) then do:
    for first bfttVisao2
        where bfttVisao2.cod-dimensao = cCodPai no-lock:
        run piExcelVisao (input rowid(bfttVisao2),
                          input bfttVisao2.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttVisao2
    where rowid(bfttVisao2) = rRow no-lock:
end.
if avail bfttVisao2 and bfttVisao2.sequencia <= iVisaoAux /*and bfttVisao2.p-image <> 9*/  then do:
    /** Cria os dados na temp-table do excel **/
   {abp/ab0604.i2 bfttVisao2.p-image}
   create tt-dados-ex.
   assign tt-dados-ex.celula-coluna        = 1
          tt-dados-ex.celula-linha         = i-lin2
          tt-dados-ex.celula-cor-interior  = 27
          tt-dados-ex.celula-fonte-cor     = 1
          tt-dados-ex.celula-fonte-negrito = yes
          tt-dados-ex.celula-formato       = "@":U
          tt-dados-ex.celula-valor         = trim(return-value) + ":" + bfttVisao2.cod-oficial + 
                                             "-" + bfttVisao2.desc-dimensao
          i-lin2                           = i-lin2 + 1.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wWindow 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable rRowid     as rowid     no-undo.
define variable iSequencia as integer   no-undo.
define variable cDimensao  as character no-undo.

/** Guarda rowid do tree-view **/
assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
/** Busca Registro **/
for first ttVisao1
    where rowid(ttVisao1) = rRowid no-lock:
    assign iSequencia = ttVisao1.sequencia
           cDimensao  = ttVisao1.cod-dimensao
           iVisao2 = ttVisao1.sequencia.
end.
if avail ttVisao1 then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttVisao1
                    where bfttVisao1.cod-dimens-pai = ttVisao1.cod-dimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttVisao1
            where bfttVisao1.cod-dimensao = ttVisao1.cod-dimens-pai no-lock:
            assign iSequencia = bfttVisao1.sequencia
                   cDimensao  = bfttVisao1.cod-dimensao
                   iVisao2 = bfttVisao1.sequencia.
        end.
    end.
    assign {&window-name}:sensitive = no.

    run abp/ab0604e.w (input table ttVisao1,
                       input iSequencia,
                       input cDimensao,
                       input iVisao2).
                       
    assign {&window-name}:sensitive = yes.
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

DEFINE VARIABLE c-cod-dimens-pai AS CHARACTER  NO-UNDO.
define variable cPai  as character no-undo.
define variable c-tam as character no-undo.

assign cPai = "".

for each ttVisao1
    where ttVisao1.cod-dimens-pai = pDimensao no-lock:

    assign c-cod-dimens-pai = replace(ttVisao1.cod-dimens-pai,"#","-").

    RUN pi-acompanhar IN h-acomp (INPUT substring(c-cod-dimens-pai,2,100)).
    /** Verifica se existem n°veis abaixo  **/
    if ttVisao1.sequencia < iVisaoAux then do:
        run piTextoDados (ttVisao1.cod-dimensao).
    end.
    else do:
        if cPai <> ttVisao1.cod-dimens-pai then do:
            assign cDescPai = "":U.
            /** Imprime os cabeáalhos **/
            run piTextoVisao (input rowid(ttVisao1),
                              input ttVisao1.cod-dimens-pai).
            assign cPai       = ttVisao1.cod-dimens-pai
                   cTituloTxt = "":U.
        end.


        IF  l-hodometro THEN DO:
            assign c-tam = "x(" + string(length(trim(trim(cDescPai) +
                                                     trim(ttVisao1.cod-oficial) + "-" + trim(ttVisao1.desc-dimensao) + cDelimitador +
                                                     string(ttVisao1.quant-eqpto,">>>9")                             + cDelimitador + 
                                                     string(ttVisao1.km-rodado,">>>,>>>,>>9.9")                      + cDelimitador +
                                                     string(ttVisao1.un,"x(03)")                                     + cDelimitador +
                                                     string(ttVisao1.km-sec,">>>,>>>,>>9.9")                         + cDelimitador +
                                                     string(ttVisao1.un-sec,"x(03)")                                 + cDelimitador +
                                                     string(ttVisao1.iIdMedia,">>>9.99")                             + cDelimitador +
                                                     string(ttVisao1.hodometro-pri,">>>,>>>,>>9.9")                  + cDelimitador +
                                                     string(ttVisao1.hodometro-sec,">>>,>>>,>>9.9")))) + ")".
        END.
        ELSE DO:
            assign c-tam = "x(" + string(length(trim(trim(cDescPai) +
                                                     trim(ttVisao1.cod-oficial) + "-" + trim(ttVisao1.desc-dimensao) + cDelimitador +
                                                     string(ttVisao1.quant-eqpto,">>>9")                             + cDelimitador + 
                                                     string(ttVisao1.km-rodado,">>>,>>>,>>9.9")                      + cDelimitador +
                                                     string(ttVisao1.un,"x(03)")                                     + cDelimitador +
                                                     string(ttVisao1.km-sec,">>>,>>>,>>9.9")                         + cDelimitador +
                                                     string(ttVisao1.un-sec,"x(03)")                                 + cDelimitador +
                                                     string(ttVisao1.iIdMedia,">>>9.99")))) + ")".
        END.

        IF  l-hodometro THEN DO:
            /** Exporta dados para TXT **/
            put trim(trim(cDescPai) + 
                     trim(ttVisao1.cod-oficial) + "-" + trim(ttVisao1.desc-dimensao) + cDelimitador +
                     string(ttVisao1.quant-eqpto,">>>9")                             + cDelimitador + 
                     string(ttVisao1.km-rodado,">>>,>>>,>>9.9")                      + cDelimitador +
                     string(ttVisao1.un,"x(03)")                                     + cDelimitador +
                     string(ttVisao1.km-sec,">>>,>>>,>>9.9")                         + cDelimitador +
                     string(ttVisao1.un-sec,"x(03)")                                 + cDelimitador +
                     string(ttVisao1.iIdMedia,">>>9.99")                             + cDelimitador +
                     string(ttVisao1.hodometro-pri,">>>,>>>,>>9.9")                  + cDelimitador +
                     string(ttVisao1.hodometro-sec,">>>,>>>,>>9.9"))                 format c-tam at 01.
        END.
        ELSE DO:
            /** Exporta dados para TXT **/
            put trim(trim(cDescPai) + 
                     trim(ttVisao1.cod-oficial) + "-" + trim(ttVisao1.desc-dimensao) + cDelimitador +
                     string(ttVisao1.quant-eqpto,">>>9")                             + cDelimitador + 
                     string(ttVisao1.km-rodado,">>>,>>>,>>9.9")                      + cDelimitador +
                     string(ttVisao1.un,"x(03)")                                     + cDelimitador +
                     string(ttVisao1.km-sec,">>>,>>>,>>9.9")                         + cDelimitador +
                     string(ttVisao1.un-sec,"x(03)")                                 + cDelimitador +
                     string(ttVisao1.iIdMedia,">>>9.99"))                            format c-tam at 01.
        END.


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

define variable c-tam  as character no-undo.
DEFINE VARIABLE iQtSeq AS INTEGER    NO-UNDO.

/** Verifica se existem vis‰es escolhidas **/
for last ttVisao fields(sequencia) no-lock:
    assign iQtSeq = ttVisao.sequencia.
end.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttVisao2
            where bfttVisao2.cod-dimensao = cCodPai and
                  bfttVisao2.sequencia    <= iVisaoAux no-lock) then do:
    for first bfttVisao2
        where bfttVisao2.cod-dimensao = cCodPai and
              bfttVisao2.sequencia    <= iVisaoAux no-lock:
        run piTextoVisao (input rowid(bfttVisao2),
                          input bfttVisao2.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttVisao2
    where rowid(bfttVisao2)    = rRow and
          bfttVisao2.sequencia <= iVisaoAux no-lock:
    {abp/ab0604.i2 bfttVisao2.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador.
end.
if avail bfttVisao2 then do:
    assign cDescPai  = trim(trim(cDescPai) + trim(bfttVisao2.cod-oficial) + 
                            "-" + trim(bfttVisao2.desc-dimensao) + cDelimitador).
    /** Se for o pen£ltimo n°vel, imprime cabeáalho se parametrizado **/
    if bfttVisao2.sequencia = iVisaoAux and lCabecalho then do:
        ASSIGN lCabecalho = NO.
        assign c-tam = "x(" + STRING(length(trim(trim(cTituloTxt)                    +
                                     brDetalhe:TITLE IN FRAME fPage0  + cDelimitador +
                                     fnBrowse("quant-eqpto":U,1)      + cDelimitador +
                                     fnBrowse("Km-rodado":U,1)        + cDelimitador +
                                     fnBrowse("un":U,1)               + cDelimitador +
                                     fnBrowse("km-sec":U,1)           + cDelimitador +
                                     fnBrowse("un-sec":U,1)           + cDelimitador +                                     
                                     fnBrowse("iIdMedia":U,1)         + cDelimitador +
                                     fnBrowse("Hodometro-Pri":U,1)    + cDelimitador +                                     
                                     fnBrowse("Hodometro-Seg":U,1)))) + ")".
                                     
        put trim(trim(cTituloTxt)                                + 
                 brDetalhe:TITLE IN FRAME fPage0  + cDelimitador +
                 fnBrowse("quant-eqpto":U,1)      + cDelimitador +          
                 fnBrowse("Km-rodado":U,1)        + cDelimitador +   
                 fnBrowse("un":U,1)               + cDelimitador +
                 fnBrowse("km-sec":U,1)           + cDelimitador +
                 fnBrowse("un-sec":U,1)           + cDelimitador +
                 fnBrowse("iIdMedia":U,1)         + cDelimitador +
                 fnBrowse("Hodometro-Pri":U,1)    + cDelimitador +
                 fnBrowse("Hodometro-Seg":U,1))   format c-tam at 01.
    END.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTxt wWindow 
PROCEDURE piTxt :
/*------------------------------------------------------------------------------
  Purpose:     piTxt
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
run mvp/mv0613g.w (input-output cCaminho,
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
    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i "Exportaá∆o Txt" *}                          
    run pi-inicializar in h-acomp(input RETURN-VALUE).
    
    blk2:
    do on stop undo, return "NOK":U:
            /** Somente vis∆o selecionada **/
            if i-impressao = 1 then do:
                /** Guarda rowid do tree-view **/
                assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
                /** Busca Registro **/
                for first bfttVisao1
                    where rowid(bfttVisao1) = rRowid no-lock:
                    assign iVisaoAux = bfttVisao1.sequencia.
                    run piTextoDados (input bfttVisao1.cod-dimensao).
                end.
            end.
            /** Completo **/
            else do:
                /** Guarda rowid do tree-view **/
                assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).
                for first bfttVisao1
                    where rowid(bfttVisao1) = rRowid NO-LOCK:
                    assign iVisaoAux = bfttVisao1.sequencia.
                end.

                for each  bfttVisao1
                    where bfttVisao1.sequencia = iVisaoAux no-lock:
                      run piTextoDados (input bfttVisao1.cod-dimensao).
                end.
            end.
        run pi-finalizar in h-acomp. 
            /******************************************************************
            ** Finaliza impress∆o do TXT
            ******************************************************************/
        output close.
        /** Abertura do Arquivo **/
        RUN utp/ut-showreport.p (INPUT cCaminho).
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tituloBrowse wWindow 
PROCEDURE tituloBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pImagem as integer no-undo.

{utp/ut-liter.i C¢digo}
assign ttVisao1.desc-dimensao:visible in browse brDetalhe = yes
       ttVisao1.quant-eqpto:visible in browse brDetalhe   = yes
       ttVisao1.km-rodado:visible in browse brDetalhe     = yes
       ttVisao1.iIdMedia:visible in browse brDetalhe      = YES
       ttVisao1.un:visible in browse brDetalhe            = YES
       ttVisao1.un-sec:visible in browse brDetalhe        = YES
       ttVisao1.km-sec:visible in browse brDetalhe        = yes
       ttVisao1.cod-oficial:label in browse brDetalhe     = RETURN-VALUE
       ttVisao1.hodometro-pri:visible in browse brDetalhe = NO
       ttVisao1.hodometro-sec:visible in browse brDetalhe = NO.

ASSIGN brDetalhe:title in frame fPage0 = fnLabels(pImagem).

if ttVisao1.sequencia < iVisao then 
    assign lReal = no.
else assign lReal = yes.

if not(lReal) then do:     
    assign ttVisao1.km-rodado:visible in browse brDetalhe = NO
           ttVisao1.un:visible in browse brDetalhe        = NO
           ttVisao1.km-sec:visible in browse brDetalhe    = NO
           ttVisao1.un-sec:visible in browse brDetalhe    = no
           ttVisao1.hodometro-pri:visible in browse brDetalhe = NO
           ttVisao1.hodometro-sec:visible in browse brDetalhe = NO.
end.

IF  pImagem = 6 AND l-hodometro THEN
    assign ttVisao1.hodometro-pri:visible in browse brDetalhe = YES
           ttVisao1.hodometro-sec:visible in browse brDetalhe = YES.

{utp/ut-liter.i Data_Compra}
if brDetalhe:title in frame fPage0 = return-value then do:
    assign ttVisao1.cod-oficial:label in browse brDetalhe     = return-value.
end.

{utp/ut-liter.i Valor_Compra}
if brDetalhe:title in frame fPage0 = return-value then do:
    assign ttVisao1.cod-oficial:label in browse brDetalhe     = return-value.
end.

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
        when "quant-eqpto":U then do:                       
            {utp/ut-liter.i "Qtde_Equipamentos"}                    
        end.                                                   
        when "km-rodado":U then do:
            {utp/ut-liter.i "Percurso Rodado" MAB}
        end.
        when "iIdMedia":U then do:
            {utp/ut-liter.i "Idade_MÇdia"}
        end.
        when "un":U then do:
            {utp/ut-liter.i "UN"}
        end.
        when "un-sec":U then do:
            {utp/ut-liter.i "UN_Secund†ria"}
        end.
        when "km-sec":U then do:
            {utp/ut-liter.i "Percurso Secund†rio" MAB}
        end.
        when "Hodometro-Pri":U then do:
            {utp/ut-liter.i "Hodìmetro Prim†rio" MAB}
        end.
        when "Hodometro-Sec":U then do:
            {utp/ut-liter.i "Hodìmetro Secund†rio" MAB}
        end.
    end case.
    assign cRetorno = trim(return-value).
end.
else do:
    case pCampo:
        when "cod-oficial":U then do:
            assign cRetorno = ttVisao1.cod-oficial.
        end.
        when "desc-dimensao":U then do:
            assign cRetorno = ttVisao1.desc-dimensao.
        end.
        when "quant-eqpto":U then do:
            assign cRetorno = string(ttVisao1.quant-eqpto,">,>>>,>>9").
        end.
        when "km-rodado":U then do:
            assign cRetorno = string(ttVisao1.km-rodado,">>>,>>>,>>9.9").
        end.
        when "iIdMedia":U then do:
            assign cRetorno = string(ttVisao1.iIdMedia,">>>9.99").
        end.
        when "un":U then do:
            assign cRetorno = string(ttVisao1.un,"x(03)").
        end.
        when "un-sec":U then do:
            assign cRetorno = string(ttVisao1.un-sec,"x(03)").
        end.
        when "hodometro-pri":U then do:
            assign cRetorno = string(ttVisao1.hodometro-pri,">>,>>>,>>9.9").
        end.
        when "hodometro-sec":U then do:
            assign cRetorno = string(ttVisao1.hodometro-sec,">>>,>>>,>>9.9").
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

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

    /** T°tulo do browse **/
    {abp/ab0604.i2 pImage}

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
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

