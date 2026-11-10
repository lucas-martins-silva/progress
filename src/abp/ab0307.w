&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS wWindow 
USING com.totvs.framework.utp.treelist.*.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttApontAux NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i AB0307 2.00.00.019 } /*** "010019" 16/09/2024 11:31:23 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0307 MAB}
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
&GLOBAL-DEFINE Program        AB0307
&GLOBAL-DEFINE Version        2.00.00.019

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btAbrir btSalvar btAtualizar btFiltro btParam btVisao btExpande ~
                              btImprimir btRedimensiona brApont brItem btApontamento btMenu ~
                              btExcel btTxt btModifica btPadrao btUsuario btAtualizacao btHistorico ~
                              btEqpto btConsulta btParametros btVaPara fiAnterior EDITOR-1 fiHodEqpto ~
                              fiHodSecEqpto fiAbastec fiPercurso fiDocAnterior fiHodEqpto-2 fiHodSecEqpto-2

/* Local Temp Table Definitions ---                                       */
{abp/ab0307.i}  /* ttSelecao */
{abp/ab0307.i3} /* ttDados   */

/** Excell **/
define temp-table tt-dados-ex no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    field celula-coluna                 as integer format ">>>>9"
    field celula-linha                  as integer format ">>>>9"
    field celula-cor-interior           as integer format ">9"     initial 58 /* None   */
    field celula-formato                as char    format "x(255)"            
    field celula-formula                as char    format "x(255)"            
    field celula-alinhamento-horizontal as integer format "9"      initial 4  /* Left   */
    field celula-alinhamento-vertical   as integer format "9"      initial 1  /* Bottom */
    field celula-valor                  as char    format "x(255)"            
    field celula-fonte-nome             as char    format "x(255)" initial "Times New Roman"
    field celula-fonte-tamanho          as integer format ">9"     initial 10
    field celula-fonte-negrito          as logical                 initial no
    field celula-fonte-italico          as logical                 initial no
    field celula-fonte-sublinhado       as integer format "9"      initial 3  /* None      */
    field celula-fonte-cor              as integer format ">9"     initial 57 /* Automatic */
    field celula-tipo-borda-sup         as integer format "9"      initial 7  /* None      */
    field celula-tipo-borda-inf         as integer format "9"      initial 7  /* None      */
    field celula-tipo-borda-esq         as integer format "9"      initial 7  /* None      */
    field celula-tipo-borda-dir         as integer format "9"      initial 7  /* None      */
    index tt-dados-pri is unique primary
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha.

/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.
{abp/abapi001.i}

/*Temp table para atualizaá∆o de apontamento/durabilidade */
define temp-table tt-param-pnp NO-UNDO LIKE tt-param.

/** Busca Valor **/
define variable rRowid        as rowid                          no-undo.
define variable cCodPai       as character format "x(20)"       no-undo.
define variable vCodigo       as character format "x(20)"       no-undo.
define variable vDescricao    as character format "x(32)"       no-undo.
define variable iImage        as integer                        no-undo.
define variable cTag          as character                      no-undo.
define variable cCCCodigo     as character                      no-undo.
/** OCX **/
define variable chTimer       as com-handle                     no-undo.

/* Eventos treeview */
{utp/ut-4gltreeview.i}

DEFINE  VARIABLE    n-4gltreeview-row       AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-column    AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-height    AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    n-4gltreeview-width     AS  DECIMAL NO-UNDO.
DEFINE  VARIABLE    r-rowid                 AS ROWID    NO-UNDO.

/** Controles **/
define variable l-expande      as logical init no               no-undo.
define variable l-ok           as logical                       no-undo.
define variable c-tag-tree     as character                     no-undo.
define variable i-cont         as integer                       no-undo.
define variable iVisao         as integer                       no-undo.
define variable i-button-tree  as integer  initial 1            no-undo.
define variable cTexto         as character format "x(22)"      no-undo.                                     
/** Pop-Menu **/                                                
define variable pop-menu       as widget-handle                 no-undo.
define variable exp-con        as widget-handle                 no-undo.
define variable detalhe        as widget-handle                 no-undo.
define variable regua          as widget-handle                 no-undo.
/** Window **/                                                  
define variable dWinXC         as decimal                       no-undo.
define variable dWinYC         as decimal                       no-undo.                                           
/** Excel **/                                                   
define variable i-lin          as integer                       no-undo.
define variable i-lin2         as integer                       no-undo.
define variable i-col          as integer                       no-undo.
define variable i-impressao    as integer                       no-undo.
define variable hHandle        as handle                        no-undo.
define variable c-colunas      as character                     no-undo.
define variable rRowid3        as rowid                         no-undo.
/** TXT **/                                                    
define variable cCaminho       as character format "x(300)"     no-undo. /*Indica o caminho */
define variable cDelimitador   as character format "x(01)"      no-undo. /*Indica o tipo de delimitador */
define variable lCabecalho     as logical   initial no          no-undo. /*Indica se gera cabeáalho */
define variable cTituloTxt     as character format "x(256)"     no-undo.
define variable cDescPai       as character format "x(256)"     no-undo.

/********* BOs*******************************/

/** Local Variable Definitions --- **/
define variable cDescErro       as character format "x(50)"      no-undo.
define variable iRow            as integer                       no-undo.
define variable deParam14       as decimal                       no-undo.
define variable iTpConsumo      as integer                       no-undo.
define variable iTpConsumoSec   as integer                       no-undo.
define variable c-cod-livre-1   LIKE mab-model.cod-livre-1       no-undo.
define variable lUsaContadorSec LIKE mab-model.log-cont-sec      no-undo.
DEFINE VARIABLE iUsoReal        LIKE ttDocLib.uso-real           NO-UNDO.
DEFINE VARIABLE iUsoRealSec     LIKE ttDocLib.uso-real-sec       NO-UNDO.

/** Filtro **/
define variable dtDataIni       as   date                        no-undo.
define variable dtDataFim       as   date                        no-undo.
define variable iEmpIni         like mab-eqpto.ep-codigo         no-undo.
define variable iEmpFim         like mab-eqpto.ep-codigo         no-undo.
define variable cEqptoIni       like mab-eqpto.cod-eqpto         no-undo.
define variable cEqptoFim       like mab-eqpto.cod-eqpto         no-undo.
define variable cEstabIni       like mab-histor-ativid.cod-estab no-undo.
define variable cEstabFim       like mab-histor-ativid.cod-estab no-undo.
define variable cTagIni         like mab-histor-ativid.cd-tag    no-undo.
define variable cTagFim         like mab-histor-ativid.cd-tag    no-undo.
define variable cCCIni          like mab-histor-ativid.cc-codigo no-undo.
define variable cCCFim          like mab-histor-ativid.cc-codigo no-undo.
define variable lOK             as   logical                     no-undo.
/** Variable Handles Definitions --- **/
define variable hDBOApont       as handle                        no-undo.
define variable hDBOAbast       as handle                        no-undo.
define variable hDBOEqpto       as handle                        no-undo.
define variable hDBOModelo      as handle                        no-undo.
define variable hDBOAtiv        as handle                        no-undo.
define variable hAbapi002       as handle                        no-undo.
define variable c-arquivo       as character                     no-undo.
define variable cErro           as character format "x(60)"      no-undo.
/** Variable **/
define variable deHodometro    like mab-abastec-lubrific.val-hodom-horim     no-undo.
define variable deHodometroSec like mab-abastec-lubrific.val-hodom-horim-sec no-undo.
define variable dtMovimento    like mab-abastec-lubrific.dat-movto           no-undo.
define variable hrHorario      like mab-abastec-lubrific.hra-inicial         no-undo.
define variable tpAtividade    like mab-abastec-lubrific.cod-ativid          no-undo.
define variable hAcomp         as handle                                     no-undo.
define variable iImBrw         as integer                                    no-undo.
define variable cCodOficial    like ttDados.cod-oficial                      no-undo.
/*Variaveis para atualizaá∆o dos pneus*/
define variable cCodEqpto         like mab-abastec-lubrific.cod-eqpto             no-undo.
define variable cEmpCod           like mab-abastec-lubrific.ep-codigo             no-undo.
define variable DtDatMovto        like mab-abastec-lubrific.dat-movto             no-undo.
define variable c-valor-param53   like mab-param.des-valor                        no-undo.

/** Buffer **/
define buffer bfttDados  for ttDados.
define buffer bfttDados2 for ttDados.
define buffer bfApont    for mab-abastec-lubrific.
/** Full Screen **/
def var iStyle   as int init ? no-undo.
def var iOldMenu as int no-undo.
def var dWidth   as dec no-undo.
def var dHeight  as dec no-undo.
def var dCol     as dec no-undo.
def var dRow     as dec no-undo.

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

/*** Inicio Projeto 118 - Seguranáa por Estabelecimento ***/
{cdp/cd0031.i "MAB":U} /** Trigger on-fin da tabela estabelec **/
/*** Final Projeto 118 - Seguranáa por Estabelecimento ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brApont

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttDados ttQuantidades

/* Definitions for BROWSE brApont                                       */
&Scoped-define FIELDS-IN-QUERY-brApont ttDados.ep-codigo ttDados.cod-eqpto ttDados.dat-movto ttDados.hra-inicial ttDados.num-docto fnDescErro(ttDados.idi-consist) @ cErro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brApont   
&Scoped-define SELF-NAME brApont
&Scoped-define QUERY-STRING-brApont for each ttDados NO-LOCK
&Scoped-define OPEN-QUERY-brApont open query brApont for each ttDados NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brApont ttDados
&Scoped-define FIRST-TABLE-IN-QUERY-brApont ttDados


/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem ttQuantidades.it-codigo ttQuantidades.qtd ttQuantidades.estab-posto ttQuantidades.dep-posto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem   
&Scoped-define SELF-NAME brItem
&Scoped-define QUERY-STRING-brItem for each ttQuantidades no-lock
&Scoped-define OPEN-QUERY-brItem open query {&SELF-NAME} for each ttQuantidades no-lock.
&Scoped-define TABLES-IN-QUERY-brItem ttQuantidades
&Scoped-define FIRST-TABLE-IN-QUERY-brItem ttQuantidades


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brApont}~
    ~{&OPEN-QUERY-brItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 RECT-20 RECT-21 rtToolBar-2 ~
rtToolBar-4 btAbrir btSalvar btAtualizar btExpande btParam btFiltro btVisao ~
btExcel btTxt btImprimir btQueryJoins btReportsJoins btExit btHelp ~
rs-integr btApontamento btModifica btPadrao btUsuario btAtualizacao ~
btHistorico btEqpto btConsulta btParametros btVaPara EDITOR-1 brApont ~
brItem fiTexto-1 fiAtivid fiDescAtiv fiTexto-2 fiModelo fiDescModelo ~
fiTexto-17 fiTexto-16 fiTexto-3 fiReal fiTexto-8 fiHodEqpto fiUN1 fiTexto-4 ~
fiMaximo fiTexto-9 fiHodSecEqpto fiUNSec fiTexto-5 fiMinimo fiTexto-10 ~
fiAbastec fiTexto-6 fiPadEqpto fiTexto-11 fiPercurso fiUN2 fiTexto-7 ~
fiPadMod fiAnterior fiTexto-12 fiDocAnterior fiTexto-14 fiHodEqpto-2 fiUN-2 ~
fiDatDocAnt fiHodSecEqpto-2 fiUNSec-2 
&Scoped-Define DISPLAYED-OBJECTS rs-integr EDITOR-1 fiTexto-1 fiAtivid ~
fiDescAtiv fiTexto-2 fiModelo fiDescModelo fiTexto-17 fiTexto-16 fiTexto-3 ~
fiReal fiTexto-8 fiHodEqpto fiUN1 fiTexto-4 fiMaximo fiTexto-9 ~
fiHodSecEqpto fiUNSec fiTexto-5 fiMinimo fiTexto-10 fiAbastec fiTexto-6 ~
fiPadEqpto fiTexto-11 fiPercurso fiUN2 fiTexto-7 fiPadMod fiAnterior ~
fiTexto-12 fiDocAnterior fiTexto-14 fiHodEqpto-2 fiUN-2 fiTexto-13 ~
fiDatDocAnt fiTexto-15 fiHodSecEqpto-2 fiUNSec-2 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescErro wWindow 
FUNCTION fnDescErro RETURNS CHARACTER
  ( input iStatus as integer)  FORWARD.

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


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU miArquivo 
       MENU-ITEM miAbrir        LABEL "&Abrir"         ACCELERATOR "CTRL-A"
       MENU-ITEM miSalvar       LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       MENU-ITEM miAtualizar    LABEL "A&tualizar"     ACCELERATOR "CTRL-T"
       RULE
       MENU-ITEM miExpande      LABEL "&Expande"       ACCELERATOR "CTRL-E"
       MENU-ITEM miVaPara       LABEL "&Va Para"       ACCELERATOR "CTRL-V"
       RULE
       MENU-ITEM miParametro    LABEL "&Parametro"     ACCELERATOR "CTRL-P"
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM miClassifica   LABEL "&Classificaá∆o" ACCELERATOR "CTRL-C"
       MENU-ITEM miExcel        LABEL "Exce&l"         ACCELERATOR "CTRL-L"
       MENU-ITEM miTxt          LABEL "T&xt"           ACCELERATOR "CTRL-X"
       MENU-ITEM miImpressao    LABEL "&Impressao"     ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&QueryJoins"    ACCELERATOR "CTRL-Q"
       MENU-ITEM miReportsJoins LABEL "Reports&Joins"  ACCELERATOR "CTRL-J"
       MENU-ITEM miExit         LABEL "Ex&it"          ACCELERATOR "CTRL-R"
       MENU-ITEM miHelp         LABEL "&Help"         .

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  miArquivo      LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .

DEFINE MENU POPUP-MENU-btApontamento-2 
       MENU-ITEM m_Manuteno_Equipamento LABEL "Manutená∆o Equipamento"
       MENU-ITEM m_Manuteno_Modelo LABEL "Manutená∆o Modelo"
       RULE
       MENU-ITEM m_Tipo_de_Material LABEL "Tipo de Material"
       RULE
       MENU-ITEM m_Compartimento_leoFiltros LABEL "Compartimento ‡leo/Filtros"
       RULE
       MENU-ITEM m_Abastecimento LABEL "Abastecimento" 
       MENU-ITEM m_AbastecimentoLubrificao LABEL "Abastecimento/Lubrificaá∆o"
       MENU-ITEM m_Importao_AbastLubrif LABEL "Importaá∆o Abast./Lubrif."
       MENU-ITEM m_ConsisteAtualiza_Apontament LABEL "Consiste/Atualiza Apontamentos"
       MENU-ITEM m_%_Remonta_leo_Motor LABEL "% Remonta ‡leo Motor"
       RULE
       MENU-ITEM m_Integrao_Estoque LABEL "Integraá∆o Estoque".


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame-4 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame-4 AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt1 
     LABEL "" 
     SIZE 1 BY 8.

DEFINE BUTTON btAbrir 
     IMAGE-UP FILE "image/im-open":U
     IMAGE-INSENSITIVE FILE "image/ii-open":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Abrir"
     FONT 4.

DEFINE BUTTON btApontamento 
     IMAGE-UP FILE "image/im-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Apontamento".

DEFINE BUTTON btAtualizacao 
     IMAGE-UP FILE "image/im-autom.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-autom.bmp":U
     LABEL "Atualizaá∆o On-Line" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizaá∆o do Apontamento On-Line".

DEFINE BUTTON btAtualizar 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON btConsulta 
     IMAGE-UP FILE "image/mab-docto.bmp":U
     LABEL "&Consultar" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta da Apontamento".

DEFINE BUTTON btEqpto 
     IMAGE-UP FILE "image/mab-eqpto.bmp":U
     LABEL "E&quip." 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Equipamento".

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

DEFINE BUTTON btHistorico 
     IMAGE-UP FILE "image/im-hist.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-hist.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Hist¢rico Abastecimentos e Lubrificaá‰es".

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btMenu 
     IMAGE-UP FILE "image/im-det.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Apontamento".

DEFINE BUTTON btModifica 
     IMAGE-UP FILE "image/im-mod.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mod.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar".

DEFINE BUTTON btPadrao 
     IMAGE-UP FILE "image/im-tick.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-tick.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Liberar pelo Padr∆o".

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-param":U
     IMAGE-INSENSITIVE FILE "image/ii-param":U
     LABEL "ParÉmetros" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros"
     FONT 4.

DEFINE BUTTON btParametros 
     IMAGE-UP FILE "image/im-calen.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros de Abastecimentos".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRedimensiona 
     LABEL "" 
     SIZE 90 BY .29.

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

DEFINE BUTTON btUsuario 
     IMAGE-UP FILE "image/im-edl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-edl.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Liberar pelo Usu†rio".

DEFINE BUTTON btVaPara 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U NO-FOCUS
     LABEL "Go To" 
     SIZE 4 BY 1.25 TOOLTIP "V† Para".

DEFINE BUTTON btVisao 
     IMAGE-UP FILE "image/im-aloca":U
     IMAGE-INSENSITIVE FILE "image/im-aloci":U
     LABEL "Classificar" 
     SIZE 4 BY 1.25 TOOLTIP "Classifica"
     FONT 4.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 58.86 BY 2.38.

DEFINE VARIABLE fiAbastec AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiAnterior AS CHARACTER FORMAT "X(256)":U INITIAL "Anterior" 
      VIEW-AS TEXT 
     SIZE 5.29 BY .67 NO-UNDO.

DEFINE VARIABLE fiAtivid AS CHARACTER FORMAT "x(8)" 
      VIEW-AS TEXT 
     SIZE 8 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDatDocAnt AS DATE FORMAT "99/99/9999":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescAtiv AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDocAnterior AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiHodEqpto AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiHodEqpto-2 AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiHodSecEqpto AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiHodSecEqpto-2 AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiMaximo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiMinimo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiModelo AS CHARACTER FORMAT "X(50)" 
      VIEW-AS TEXT 
     SIZE 8 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPadEqpto AS DECIMAL FORMAT ">>>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPadMod AS DECIMAL FORMAT ">>>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPercurso AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiReal AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiTexto-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Atividade" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-10 AS CHARACTER FORMAT "X(256)":U INITIAL "Qtde Abastecida" 
      VIEW-AS TEXT 
     SIZE 11.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-11 AS CHARACTER FORMAT "X(256)":U INITIAL "Percurso" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-12 AS CHARACTER FORMAT "X(256)":U INITIAL "Documento" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-13 AS CHARACTER FORMAT "X(256)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 4.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-14 AS CHARACTER FORMAT "X(256)":U INITIAL "Contador" 
      VIEW-AS TEXT 
     SIZE 6.72 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-15 AS CHARACTER FORMAT "X(256)":U INITIAL "Contador Sec" 
      VIEW-AS TEXT 
     SIZE 10.43 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-16 AS CHARACTER FORMAT "X(256)":U INITIAL "Consumo" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-17 AS CHARACTER FORMAT "X(256)":U INITIAL "Valores" 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Real" 
      VIEW-AS TEXT 
     SIZE 3.72 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-4 AS CHARACTER FORMAT "X(256)":U INITIAL "M†ximo" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-5 AS CHARACTER FORMAT "X(256)":U INITIAL "M°nimo" 
      VIEW-AS TEXT 
     SIZE 5.43 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Padr∆o Equipamento" 
      VIEW-AS TEXT 
     SIZE 14.29 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-7 AS CHARACTER FORMAT "X(256)":U INITIAL "Padr∆o Modelo/Ativ" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Contador" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto-9 AS CHARACTER FORMAT "X(256)":U INITIAL "Contador Sec" 
      VIEW-AS TEXT 
     SIZE 10.57 BY .67 NO-UNDO.

DEFINE VARIABLE fiUN-2 AS CHARACTER FORMAT "xx":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiUN1 AS CHARACTER FORMAT "xx":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiUN2 AS CHARACTER FORMAT "xx":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiUNSec AS CHARACTER FORMAT "xx":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiUNSec-2 AS CHARACTER FORMAT "xx":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE rs-integr AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "N∆o Integrado", 1,
"Integrado", 2
     SIZE 41 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 4.25.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 4.25.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.92.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.96.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brApont FOR 
      ttDados SCROLLING.

DEFINE QUERY brItem FOR 
      ttQuantidades SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brApont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brApont wWindow _FREEFORM
  QUERY brApont NO-LOCK DISPLAY
      ttDados.ep-codigo      
ttDados.cod-eqpto
ttDados.dat-movto
ttDados.hra-inicial
ttDados.num-docto
fnDescErro(ttDados.idi-consist) @ cErro width 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 8
         FONT 1
         TITLE "Erros Apontamentos".

DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem wWindow _FREEFORM
  QUERY brItem NO-LOCK DISPLAY
      ttQuantidades.it-codigo
ttQuantidades.qtd 
ttQuantidades.estab-posto
ttQuantidades.dep-posto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 35 BY 8
         FONT 1
         TITLE "Quantidades".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btMenu AT ROW 12.21 COL 86.57 HELP
          "Consulta do Apontamento" NO-TAB-STOP 
     btAbrir AT ROW 1.13 COL 2
     btSalvar AT ROW 1.13 COL 6
     btAtualizar AT ROW 1.13 COL 10
     btExpande AT ROW 1.13 COL 16
     btParam AT ROW 1.13 COL 43 HELP
          "ParÉmetros"
     btFiltro AT ROW 1.13 COL 47 HELP
          "Filtro"
     btVisao AT ROW 1.13 COL 51 HELP
          "Classifica"
     btExcel AT ROW 1.13 COL 55
     btTxt AT ROW 1.13 COL 59
     btImprimir AT ROW 1.13 COL 63 HELP
          "Impress∆o"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rs-integr AT ROW 4.54 COL 41 NO-LABEL
     btApontamento AT ROW 10.5 COL 33.43 HELP
          "Consulta do Apontamento"
     btModifica AT ROW 12.21 COL 32.57 HELP
          "Modificar"
     btPadrao AT ROW 12.21 COL 36.43 HELP
          "Liberar pelo Padr∆o"
     btUsuario AT ROW 12.21 COL 40.43 HELP
          "Liberar pelo Usu†rio"
     btAtualizacao AT ROW 12.21 COL 44.43 HELP
          "Atualizaá∆o do Apontamento On-Line"
     btHistorico AT ROW 12.21 COL 49.86 HELP
          "Hist¢rico Abastecimentos e Lubrificaá‰es"
     btEqpto AT ROW 12.21 COL 53.72 HELP
          "Consulta Equipamento"
     btConsulta AT ROW 12.21 COL 57.72 HELP
          "Consulta da Ordem de Manutená∆o"
     btParametros AT ROW 12.21 COL 61.72 HELP
          "Reporte de Horas"
     btVaPara AT ROW 1.13 COL 20 HELP
          "V† Para"
     EDITOR-1 AT ROW 13.63 COL 32.14 NO-LABEL
     btRedimensiona AT ROW 15.88 COL 1
     brApont AT ROW 16.13 COL 1
     bt1 AT ROW 16.13 COL 55
     brItem AT ROW 16.13 COL 56
     fiTexto-1 AT ROW 2.75 COL 35.72 COLON-ALIGNED NO-LABEL
     fiAtivid AT ROW 2.79 COL 42.72 COLON-ALIGNED HELP
          "C¢digo da Atividade" NO-LABEL NO-TAB-STOP 
     fiDescAtiv AT ROW 2.79 COL 51 COLON-ALIGNED NO-LABEL
     fiTexto-2 AT ROW 3.5 COL 37 COLON-ALIGNED NO-LABEL
     fiModelo AT ROW 3.54 COL 42.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiDescModelo AT ROW 3.54 COL 51 COLON-ALIGNED NO-LABEL
     fiTexto-17 AT ROW 5.17 COL 58.29 COLON-ALIGNED NO-LABEL
     fiTexto-16 AT ROW 5.21 COL 31.29 COLON-ALIGNED NO-LABEL
     fiTexto-3 AT ROW 5.79 COL 41.43 COLON-ALIGNED NO-LABEL
     fiReal AT ROW 5.79 COL 45.29 COLON-ALIGNED HELP
          "Quantidade de Combust°vel" NO-LABEL NO-TAB-STOP 
     fiTexto-8 AT ROW 6.04 COL 64.72 COLON-ALIGNED NO-LABEL
     fiHodEqpto AT ROW 6.04 COL 71.43 COLON-ALIGNED HELP
          "Valor Hodìmetro/Hor°metro do Equipamento" NO-LABEL NO-TAB-STOP 
     fiUN1 AT ROW 6.04 COL 81.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-4 AT ROW 6.54 COL 39.57 COLON-ALIGNED NO-LABEL
     fiMaximo AT ROW 6.54 COL 45.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-9 AT ROW 6.79 COL 61.57 COLON-ALIGNED NO-LABEL
     fiHodSecEqpto AT ROW 6.79 COL 71.43 COLON-ALIGNED HELP
          "Valor Hodìmetro/Hor°metro do Equipamento" NO-LABEL NO-TAB-STOP 
     fiUNSec AT ROW 6.79 COL 81.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-5 AT ROW 7.29 COL 39.72 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     fiMinimo AT ROW 7.29 COL 45.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-10 AT ROW 7.54 COL 59.57 COLON-ALIGNED NO-LABEL
     fiAbastec AT ROW 7.54 COL 71.43 COLON-ALIGNED HELP
          "Quantidade de Combust°vel" NO-LABEL NO-TAB-STOP 
     fiTexto-6 AT ROW 8 COL 30.57 COLON-ALIGNED NO-LABEL
     fiPadEqpto AT ROW 8.04 COL 45.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-11 AT ROW 8.29 COL 64.86 COLON-ALIGNED NO-LABEL
     fiPercurso AT ROW 8.29 COL 71.43 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiUN2 AT ROW 8.29 COL 81.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-7 AT ROW 8.75 COL 31.14 COLON-ALIGNED NO-LABEL
     fiPadMod AT ROW 8.79 COL 45.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiAnterior AT ROW 9.75 COL 31.29 COLON-ALIGNED NO-LABEL
     fiTexto-12 AT ROW 10.33 COL 40.43 COLON-ALIGNED NO-LABEL
     fiDocAnterior AT ROW 10.33 COL 48.86 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-14 AT ROW 10.38 COL 66.86 COLON-ALIGNED NO-LABEL
     fiHodEqpto-2 AT ROW 10.38 COL 73.57 COLON-ALIGNED HELP
          "Valor Hodìmetro/Hor°metro do Equipamento" NO-LABEL NO-TAB-STOP 
     fiUN-2 AT ROW 10.38 COL 83.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-13 AT ROW 11.04 COL 45 COLON-ALIGNED NO-LABEL
     fiDatDocAnt AT ROW 11.04 COL 48.86 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTexto-15 AT ROW 11.13 COL 63.72 COLON-ALIGNED NO-LABEL
     fiHodSecEqpto-2 AT ROW 11.13 COL 73.57 COLON-ALIGNED HELP
          "Valor Hodìmetro/Hor°metro do Equipamento" NO-LABEL NO-TAB-STOP 
     fiUNSec-2 AT ROW 11.13 COL 83.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     RECT-16 AT ROW 5.5 COL 32
     RECT-17 AT ROW 5.5 COL 59
     RECT-20 AT ROW 2.58 COL 32
     RECT-21 AT ROW 10.04 COL 32
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar-4 AT ROW 12.04 COL 32
     SPACE(0.00) SKIP(0.63)
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
   Temp-Tables and Buffers:
      TABLE: ttApontAux T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Gerenciador de abastecimentos"
         HEIGHT             = 23.33
         WIDTH              = 90.43
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
/* BROWSE-TAB brApont btRedimensiona fpage0 */
/* BROWSE-TAB brItem bt1 fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

ASSIGN 
       brApont:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brApont:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       brItem:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brItem:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

/* SETTINGS FOR BUTTON bt1 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btMenu IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btMenu:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-btApontamento-2:HANDLE.

/* SETTINGS FOR BUTTON btRedimensiona IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTexto-13 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTexto-15 IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brApont
/* Query rebuild information for BROWSE brApont
     _START_FREEFORM
open query brApont for each ttDados NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttApont.ep-codigo|yes,Temp-Tables.ttApont.cod-eqpto|yes"
     _Query            is OPENED
*/  /* BROWSE brApont */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _START_FREEFORM
open query {&SELF-NAME} for each ttQuantidades no-lock.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttAbast.it-codigo|yes"
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame-4 ASSIGN
       FRAME           = FRAME fpage0:HANDLE
       ROW             = 13
       COLUMN          = 27
       HEIGHT          = 1.17
       WIDTH           = 4
       HIDDEN          = yes
       SENSITIVE       = yes.
/* CtrlFrame-4 OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame-4:MOVE-AFTER(btParametros:HANDLE IN FRAME fpage0).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Gerenciador de abastecimentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Gerenciador de abastecimentos */
DO:
  /** Atualizaá∆o da Remonta do Motor **/
  run piRemonta in this-procedure.

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow /* Gerenciador de abastecimentos */
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    def var hlabel as handle no-undo.
    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                     = wWindow:width-chars  - dWinXC
           dYC                                     = wWindow:height-chars - dWinYC
           dWinXC                                  = wWindow:width-chars
           dWinYC                                  = wWindow:height-chars
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars
           frame fPage0:height-chars               = wWindow:height-chars
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0    = (rtToolBar-2:width-chars in frame fPage0 + dXC)
           btHelp:column in frame fPage0              = (btHelp:column in frame fPage0 + dXC)
           btExit:column in frame fPage0              = (btExit:column in frame fPage0 + dXC)
           btReportsJoins:column in frame fPage0      = (btReportsJoins:column in frame fPage0 + dXC)
           btQueryJoins:column in frame fPage0        = (btQueryJoins:column in frame fPage0 + dXC)
           btParam:column in frame fPage0             = (btParam:column in frame fPage0 + dXC)
           btFiltro:column in frame fPage0            = (btFiltro:column in frame fPage0 + dXC)
           btVisao:column in frame fPage0             = (btVisao:column in frame fPage0 + dXC)
           btExcel:column in frame fPage0             = (btExcel:column in frame fPage0 + dXC)
           btTXT:column in frame fPage0               = (btTXT:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0          = (btImprimir:column in frame fPage0 + dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 + dXC)
           btRedimensiona:row in frame fPage0         = (n-4gltreeview-row + n-4gltreeview-height)                  /*(btRedimensiona:row in frame fPage0 + (dYC / 22))*/                                        
           brApont:width-chars in frame fPage0        = (brApont:width-chars in frame fPage0 + (dXC / 1.7))         /* (btRedimensiona:width - EDITOR-1:width)  */                                
           brApont:height-chars in frame fPage0       = (brApont:height-chars in frame fPage0 + (dYC / 1))          /* (frame fPage0:height - btRedimensiona:row) + (2 * btRedimensiona:height) */
           brApont:row in frame fPage0                =  btRedimensiona:row in frame fPage0 + btRedimensiona:height                                                                               
           brItem:width-chars in frame fPage0         = (brItem:width-chars in frame fPage0 + (dXC / 2.42))         /* EDITOR-1:width - bt1:width    */                                           
           brItem:column in frame fPage0              = (brApont:width + (2 * bt1:width))                           /*(brItem:column in frame fPage0 + dXC / 1.7)*/                                               
           brItem:row in frame fPage0                 =  btRedimensiona:row in frame fPage0 + btRedimensiona:height                                                                               
           brItem:height-chars in frame fPage0        = (brItem:height-chars in frame fPage0 + (dYC / 1))           /* (frame fPage0:height - btRedimensiona:row) + (2 * btRedimensiona:height) */
           n-4gltreeview-width                        = n-4gltreeview-width + dXC
           no-error.

    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.

    assign rtToolBar-4:width-chars in frame fPage0    = (rtToolBar-4:width-chars in frame fPage0 + dXC)
           RECT-20:column in frame fPage0             = (RECT-20:column in frame fPage0 + dXC)
           RECT-16:column in frame fPage0             = (RECT-16:column in frame fPage0 + dXC)
           RECT-17:column in frame fPage0             = (RECT-17:column in frame fPage0 + dXC)
           RECT-21:column in frame fPage0             = (RECT-21:column in frame fPage0 + dXC)
           fiAtivid:column in frame fPage0            = (fiAtivid:column in frame fPage0 + dXC)
           fiDescAtiv:column in frame fPage0          = (fiDescAtiv:column in frame fPage0 + dXC)
           fiModelo:column in frame fPage0            = (fiModelo:column in frame fPage0 + dXC)
           fiDescModelo:column in frame fPage0        = (fiDescModelo:column in frame fPage0 + dXC)
           fiReal:column in frame fPage0              = (fiReal:column in frame fPage0 + dXC)       
           fiMaximo:column in frame fPage0            = (fiMaximo:column in frame fPage0 + dXC)     
           fiMinimo:column in frame fPage0            = (fiMinimo:column in frame fPage0 + dXC)     
           fiPadEqpto:column in frame fPage0          = (fiPadEqpto:column in frame fPage0 + dXC)   
           fiPadMod:column in frame fPage0            = (fiPadMod:column in frame fPage0 + dXC)     
           fiHodEqpto:column in frame fPage0          = (fiHodEqpto:column in frame fPage0 + dXC)   
           fiUN1:column in frame fPage0               = (fiUN1:column in frame fPage0 + dXC)        
           fiHodSecEqpto:column in frame fPage0       = (fiHodSecEqpto:column in frame fPage0 + dXC)
           fiUNSec:column in frame fPage0             = (fiUNSec:column in frame fPage0 + dXC)      
           fiAbastec:column in frame fPage0           = (fiAbastec:column in frame fPage0 + dXC)    
           fiPercurso:column in frame fPage0          = (fiPercurso:column in frame fPage0 + dXC)   
           fiUN2:column in frame fPage0               = (fiUN2:column in frame fPage0 + dXC)        
           rs-integr:column in frame fPage0           = (rs-integr:column in frame fPage0 + dXC) /*(RECT-20:column in frame fPage0 + (dXC / 5.8))*/       
           fiDocAnterior:column in frame fPage0       = (fiDocAnterior:column in frame fPage0 + dXC)
           fiDatDocAnt:column in frame fPage0         = (fiDatDocAnt:column in frame fPage0 + dXC)
           fiHodEqpto-2:column in frame fPage0        = (fiHodEqpto-2:column in frame fPage0 + dXC)
           fiUN-2:column in frame fPage0              = (fiUN-2:column in frame fPage0 + dXC)
           fiHodSecEqpto-2:column in frame fPage0     = (fiHodSecEqpto-2:column in frame fPage0 + dXC)
           fiUNSec-2:column in frame fPage0           = (fiUNSec-2:column in frame fPage0 + dXC)
           btApontamento:column in frame fPage0       = (btApontamento:column in frame fPage0 + dXC)
           btModifica:column in frame fPage0          = (btModifica:column in frame fPage0 + dXC) 
           btPadrao:column in frame fPage0            = (btPadrao:column in frame fPage0 + dXC) 
           btUsuario:column in frame fPage0           = (btUsuario:column in frame fPage0 + dXC) 
           btAtualizacao:column in frame fPage0       = (btAtualizacao:column in frame fPage0 + dXC) 
           btHistorico:column in frame fPage0         = (btHistorico:column in frame fPage0 + dXC)
           btEqpto:column in frame fPage0             = (btEqpto:column in frame fPage0 + dXC) 
           btConsulta:column in frame fPage0          = (btConsulta:column in frame fPage0 + dXC) 
           btParametros:column in frame fPage0        = (btParametros:column in frame fPage0 + dXC)
           btMenu:column in frame fPage0              = (btMenu:column in frame fPage0 + dXC)
           EDITOR-1:column in frame fPage0            = (EDITOR-1:column in frame fPage0 + dXC)
           bt1:column in frame fPage0                 = (bt1:column in frame fPage0 + dXC / 1.7)                    /* EDITOR-1:column in frame fPage0   */     
           bt1:row in frame fPage0                    =  btRedimensiona:row in frame fPage0 + btRedimensiona:height /*(bt1:row in frame fPage0 + (dXC / 22))*/   
           bt1:height-chars in frame  fPage0          = (bt1:height-chars in frame  fPage0 + (dYC / 1))             /* brApont:height */                        
           fiAnterior:column in frame fPage0          = (fiAnterior:column in frame fPage0 + dXC)
           fiTexto-1:column in frame  fPage0          = (fiTexto-1:column in frame  fPage0 + dXC)
           fiTexto-2:column in frame  fPage0          = (fiTexto-2:column in frame  fPage0 + dXC)
           fiTexto-3:column in frame  fPage0          = (fiTexto-3:column in frame  fPage0 + dXC)
           fiTexto-4:column in frame  fPage0          = (fiTexto-4:column in frame  fPage0 + dXC)
           fiTexto-5:column in frame  fPage0          = (fiTexto-5:column in frame  fPage0 + dXC)
           fiTexto-6:column in frame  fPage0          = (fiTexto-6:column in frame  fPage0 + dXC)
           fiTexto-7:column in frame  fPage0          = (fiTexto-7:column in frame  fPage0 + dXC)
           fiTexto-8:column in frame  fPage0          = (fiTexto-8:column in frame  fPage0 + dXC)
           fiTexto-9:column in frame  fPage0          = (fiTexto-9:column in frame  fPage0 + dXC)
           fiTexto-10:column in frame fPage0          = (fiTexto-10:column in frame fPage0 + dXC) 
           fiTexto-11:column in frame fPage0          = (fiTexto-11:column in frame fPage0 + dXC)
           fiTexto-12:column in frame fPage0          = (fiTexto-12:column in frame fPage0 + dXC)
           fiTexto-13:column in frame fPage0          = (fiTexto-13:column in frame fPage0 + dXC)
           fiTexto-14:column in frame fPage0          = (fiTexto-14:column in frame fPage0 + dXC)
           fiTexto-15:column in frame fPage0          = (fiTexto-15:column in frame fPage0 + dXC)
           fiTexto-16:column in frame fPage0          = (fiTexto-16:column in frame fPage0 + dXC)
           fiTexto-17:column in frame fPage0          = (fiTexto-17:column in frame fPage0 + dXC) no-error.


/*     run piLabelCampos in this-procedure. */

/*     apply "END-MOVE":U to btRedimensiona in frame fPage0. */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESTORED OF wWindow /* Gerenciador de abastecimentos */
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    def var hlabel as handle no-undo.
    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                        = dWinXC - wWindow:width-chars
           dYC                                        = dWinYC - wWindow:height-chars
           dWinXC                                     = wWindow:width-chars
           dWinYC                                     = wWindow:height-chars
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0    = (rtToolBar-2:width-chars in frame fPage0 - dXC)
           btHelp:column in frame fPage0              = (btHelp:column in frame fPage0 - dXC)
           btExit:column in frame fPage0              = (btExit:column in frame fPage0 - dXC)
           btReportsJoins:column in frame fPage0      = (btReportsJoins:column in frame fPage0 - dXC)
           btQueryJoins:column in frame fPage0        = (btQueryJoins:column in frame fPage0 - dXC)
           btParam:column in frame fPage0             = (btParam:column in frame fPage0 - dXC)
           btFiltro:column in frame fPage0            = (btFiltro:column in frame fPage0 - dXC)
           btVisao:column in frame fPage0             = (btVisao:column in frame fPage0 - dXC)
           btExcel:column in frame fPage0             = (btExcel:column in frame fPage0 - dXC)
           btTXT:column in frame fPage0               = (btTXT:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0          = (btImprimir:column in frame fPage0 - dXC)
           btRedimensiona:width-chars in frame fPage0 = (btRedimensiona:width-chars in frame fPage0 - dXC)
           btRedimensiona:row in frame fPage0         = (n-4gltreeview-row + n-4gltreeview-height)                  /* 15.88  */                                                                    
           brApont:width-chars in frame fPage0        = (brApont:width-chars in frame fPage0 - (dXC / 1.7))         /* 54     */ 
           brApont:height-chars in frame fPage0       = (brApont:height-chars in frame fPage0 - (dYC / 1))          /* 8      */  
           brApont:row in frame fPage0                =  btRedimensiona:row in frame fPage0 + btRedimensiona:height /* 16.13  */  
           brItem:width-chars in frame fPage0         = (brItem:width-chars in frame fPage0 - (dXC / 2.42))         /* 35     */  
           brItem:column in frame fPage0              =  brApont:width + (2 * bt1:width)                            /* 56     */  
           brItem:row in frame fPage0                 =  btRedimensiona:row in frame fPage0 + btRedimensiona:height /* 16.13  */  
           brItem:height-chars in frame fPage0        = (brItem:height-chars in frame fPage0 - (dYC / 1))           /* 8      */  
           n-4gltreeview-width                        = n-4gltreeview-width - dXC
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                   = wWindow:width-chars
           frame fPage0:height-chars                  = wWindow:height-chars  no-error.

    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.

    assign rtToolBar-4:width-chars in frame fPage0    = (rtToolBar-4:width-chars in frame fPage0 - dXC)
           RECT-20:column in frame fPage0             = (RECT-20:column in frame fPage0 - dXC)
           RECT-16:column in frame fPage0             = (RECT-16:column in frame fPage0 - dXC)
           RECT-17:column in frame fPage0             = (RECT-17:column in frame fPage0 - dXC)
           RECT-21:column in frame fPage0             = (RECT-21:column in frame fPage0 - dXC)
           fiAtivid:column in frame fPage0            = (fiAtivid:column in frame fPage0 - dXC)
           fiDescAtiv:column in frame fPage0          = (fiDescAtiv:column in frame fPage0 - dXC)
           fiModelo:column in frame fPage0            = (fiModelo:column in frame fPage0 - dXC)
           fiDescModelo:column in frame fPage0        = (fiDescModelo:column in frame fPage0 - dXC)
           fiReal:column in frame fPage0              = (fiReal:column in frame fPage0 - dXC)       
           fiMaximo:column in frame fPage0            = (fiMaximo:column in frame fPage0 - dXC)     
           fiMinimo:column in frame fPage0            = (fiMinimo:column in frame fPage0 - dXC)     
           fiPadEqpto:column in frame fPage0          = (fiPadEqpto:column in frame fPage0 - dXC)   
           fiPadMod:column in frame fPage0            = (fiPadMod:column in frame fPage0 - dXC)     
           fiHodEqpto:column in frame fPage0          = (fiHodEqpto:column in frame fPage0 - dXC)   
           fiUN1:column in frame fPage0               = (fiUN1:column in frame fPage0 - dXC)        
           fiHodSecEqpto:column in frame fPage0       = (fiHodSecEqpto:column in frame fPage0 - dXC)
           fiUNSec:column in frame fPage0             = (fiUNSec:column in frame fPage0 - dXC)      
           fiAbastec:column in frame fPage0           = (fiAbastec:column in frame fPage0 - dXC)    
           fiPercurso:column in frame fPage0          = (fiPercurso:column in frame fPage0 - dXC)   
           fiUN2:column in frame fPage0               = (fiUN2:column in frame fPage0 - dXC)        
           rs-integr:column in frame fPage0           = (rs-integr:column in frame fPage0 - dXC) /*41.00*/
           fiDocAnterior:column in frame fPage0       = (fiDocAnterior:column in frame fPage0 - dXC)
           fiDatDocAnt:column in frame fPage0         = (fiDatDocAnt:column in frame fPage0 - dXC)
           fiHodEqpto-2:column in frame fPage0        = (fiHodEqpto-2:column in frame fPage0 - dXC)
           fiUN-2:column in frame fPage0              = (fiUN-2:column in frame fPage0 - dXC)
           fiHodSecEqpto-2:column in frame fPage0     = (fiHodSecEqpto-2:column in frame fPage0 - dXC)
           fiUNSec-2:column in frame fPage0           = (fiUNSec-2:column in frame fPage0 - dXC)
           btApontamento:column in frame fPage0       = (btApontamento:column in frame fPage0 - dXC)
           btModifica:column in frame fPage0          = (btModifica:column in frame fPage0 - dXC) 
           btPadrao:column in frame fPage0            = (btPadrao:column in frame fPage0 - dXC) 
           btUsuario:column in frame fPage0           = (btUsuario:column in frame fPage0 - dXC) 
           btAtualizacao:column in frame fPage0       = (btAtualizacao:column in frame fPage0 - dXC) 
           btHistorico:column in frame fPage0         = (btHistorico:column in frame fPage0 - dXC)
           btEqpto:column in frame fPage0             = (btEqpto:column in frame fPage0 - dXC) 
           btConsulta:column in frame fPage0          = (btConsulta:column in frame fPage0 - dXC) 
           btParametros:column in frame fPage0        = (btParametros:column in frame fPage0 - dXC)
           btMenu:column in frame fPage0              = (btMenu:column in frame fPage0 - dXC)
           EDITOR-1:column in frame fPage0            = (EDITOR-1:column in frame fPage0 - dXC)                 
           bt1:column in frame fPage0                 = (bt1:column in frame fPage0 - dXC / 1.7)                    /* 55    */
           bt1:row in frame fPage0                    =  btRedimensiona:row in frame fPage0 + btRedimensiona:height /* 16.13 */ 
           bt1:height-chars in frame fPage0           = (bt1:height-chars in frame fPage0 - (dYC / 1))              /* 8     */                                                                 
           fiAnterior:column in frame fPage0          = (fiAnterior:column in frame fPage0 - dXC)
           fiTexto-1:column in frame fPage0           = (fiTexto-1:column in frame  fPage0 - dXC)
           fiTexto-2:column in frame fPage0           = (fiTexto-2:column in frame  fPage0 - dXC)
           fiTexto-3:column in frame fPage0           = (fiTexto-3:column in frame  fPage0 - dXC)
           fiTexto-4:column in frame fPage0           = (fiTexto-4:column in frame  fPage0 - dXC)
           fiTexto-5:column in frame fPage0           = (fiTexto-5:column in frame  fPage0 - dXC)
           fiTexto-6:column in frame fPage0           = (fiTexto-6:column in frame  fPage0 - dXC)
           fiTexto-7:column in frame fPage0           = (fiTexto-7:column in frame  fPage0 - dXC)
           fiTexto-8:column in frame fPage0           = (fiTexto-8:column in frame  fPage0 - dXC)
           fiTexto-9:column in frame fPage0           = (fiTexto-9:column in frame  fPage0 - dXC)
           fiTexto-10:column in frame fPage0          = (fiTexto-10:column in frame fPage0 - dXC) 
           fiTexto-11:column in frame fPage0          = (fiTexto-11:column in frame fPage0 - dXC)
           fiTexto-12:column in frame fPage0          = (fiTexto-12:column in frame fPage0 - dXC)
           fiTexto-13:column in frame fPage0          = (fiTexto-13:column in frame fPage0 - dXC)
           fiTexto-14:column in frame fPage0          = (fiTexto-14:column in frame fPage0 - dXC)
           fiTexto-15:column in frame fPage0          = (fiTexto-15:column in frame fPage0 - dXC)
           fiTexto-16:column in frame fPage0          = (fiTexto-16:column in frame fPage0 - dXC)
           fiTexto-17:column in frame fPage0          = (fiTexto-17:column in frame fPage0 - dXC) no-error.


/*     run piLabelCampos in this-procedure. */

    apply "END-MOVE":U to btRedimensiona in frame fPage0.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brApont
&Scoped-define SELF-NAME brApont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brApont wWindow
ON VALUE-CHANGED OF brApont IN FRAME fpage0 /* Erros Apontamentos */
DO:
    /** Busca Registros para mostrar em tela **/
    RUN piApontamento IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItem
&Scoped-define SELF-NAME brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON VALUE-CHANGED OF brItem IN FRAME fpage0 /* Quantidades */
DO:
  /** Busca valores para campos em tela **/
  RUN piAbastecimento IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAbrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAbrir wWindow
ON CHOOSE OF btAbrir IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAbrir IN MENU mbMain DO:
   /** Troca as barras **/
   ASSIGN c-arquivo = REPLACE(c-arquivo, "/", "/").

   /** Abre caixa para abrir arquivo **/
   SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dat" "*.dat",
               "*.*" "*.*"
       ASK-OVERWRITE
       DEFAULT-EXTENSION "dat"
       INITIAL-DIR entry (1, PROPATH)
       USE-FILENAME
       UPDATE l-ok.

   /** Retorno de OK, abre o arquivo **/
   IF l-ok THEN DO:
      IF SEARCH (c-arquivo) <> ? THEN
         RUN carregaFiltro (INPUT c-arquivo).
   END.

   APPLY "ENTRY":U TO btAbrir IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btApontamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btApontamento wWindow
ON CHOOSE OF btApontamento IN FRAME fpage0
DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  RUN piConsultaApontamento IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.

  APPLY "ENTRY":U TO btApontamento IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizacao wWindow
ON CHOOSE OF btAtualizacao IN FRAME fpage0 /* Atualizaá∆o On-Line */
DO:
    if avail ttDados then do:
        get current brApont.
        run piParametroLiberacao in this-procedure.
        run abp/abapi001.p (input  table tt-param,
                            output table RowErrors,
                            output table ttDocLib).

        if can-find(first RowErrors) then do:
            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
            /** Limpa temp-tables de erros **/
            empty temp-table RowErrors.
        end.

        /** Busca os registros **/
        run piAtualizaVisao in this-procedure (input 2).

        APPLY "ENTRY":U TO brApont IN FRAME fPage0.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizar wWindow
ON CHOOSE OF btAtualizar IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miAtualizar IN MENU mbMain DO:
    /** Controla expans∆o **/
    IF l-expande THEN
        ASSIGN l-expande = NO.

    assign c-tag-tree = "".

    SESSION:SET-WAIT-STATE ("GENERAL").
    RUN piAtualizar IN THIS-PROCEDURE.
    SESSION:SET-WAIT-STATE ("").

    RUN applyEntry IN h-4gltreeview(INPUT "").
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConsulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsulta wWindow
ON CHOOSE OF btConsulta IN FRAME fpage0 /* Consultar */
DO:
  run chamaPrograma in this-procedure (input "abp/ab0611.w":U,
                                       input 16,
                                       input no).
  apply "ENTRY":U to btConsulta in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEqpto wWindow
ON CHOOSE OF btEqpto IN FRAME fpage0 /* Equip. */
DO:
  run piEquipamento in this-procedure (input "abp/ab0602.w").
  if return-value = "NOK":U then
      return NO-APPLY.

  apply "ENTRY":U to btEqpto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM miExcel IN MENU mbMain DO:
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
        RUN piExcel IN THIS-PROCEDURE.
    END.
    APPLY "ENTRY":U TO btExcel IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    /** Atualizaá∆o da Remonta do Motor **/
    run piRemonta in this-procedure.

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExpande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExpande wWindow
ON CHOOSE OF btExpande IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miExpande IN MENU mbMain DO:

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
OR CHOOSE OF MENU-ITEM miFiltro IN MENU mbMain DO:
    assign {&window-name}:sensitive = no.
    run abp/ab0307b.w (input-output table ttSelecao).
    assign {&window-name}:sensitive = yes.

    /* /** Busca os registros **/                   */
    /* if lOK then do:                              */
    /*    run buscaApontamentos in this-procedure.  */
    /* end.                                         */

/*     apply "ENTRY":U to btFiltro in frame fPage0. */
    apply "ENTRY":U to brApont in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miHelp IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistorico wWindow
ON CHOOSE OF btHistorico IN FRAME fpage0
DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  RUN piHistorico IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.

  APPLY "ENTRY":U TO btHistorico IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miImpressao IN MENU mbMain DO:
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN 
        RUN piImprimir IN THIS-PROCEDURE.
    APPLY "ENTRY":U TO btImprimir IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModifica wWindow
ON CHOOSE OF btModifica IN FRAME fpage0
DO:
    if avail ttDados then do:
        get current brApont.
        /** Atualiza Campos **/
        RUN piModifica IN THIS-PROCEDURE.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPadrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPadrao wWindow
ON CHOOSE OF btPadrao IN FRAME fpage0
DO:
    if avail ttDados then do:
        get current brApont.
        /** Libera Registro pelo Padr∆o **/
        DO TRANS:
            RUN piLibera IN THIS-PROCEDURE (INPUT 2).
            IF  RETURN-VALUE = "NOK":U THEN DO:
                UNDO, LEAVE.
            END.
            ELSE DO:
                /** Busca os registros **/
                RUN piAtualizaVisao IN THIS-PROCEDURE (INPUT 1).
            END.
        END.
        apply "VALUE-CHANGED":U  to brApont in frame fPage0.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM miParametro IN MENU mbMain DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN abp/ab0307a.w (INPUT-OUTPUT TABLE ttSelecao).
    for first ttSelecao no-lock:
        assign chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.
    end.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY "ENTRY":U TO btParam IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParametros wWindow
ON CHOOSE OF btParametros IN FRAME fpage0
DO:
    run abp/ab0101.w.
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
OR CHOOSE OF MENU-ITEM miSalvar IN MENU mbMain DO:
   /** Troca os tipos de barras **/ 
   ASSIGN c-arquivo = "AB0307.dat"
          c-arquivo = REPLACE(c-arquivo, "/", "/").

   /** Abre caixa de escolha de arquivos **/
   SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dat" "*.dat",
               "*.*" "*.*"
       ASK-OVERWRITE
       DEFAULT-EXTENSION "dat"
       INITIAL-DIR ENTRY (1, PROPATH)
       SAVE-AS     
       USE-FILENAME 
       UPDATE l-ok.

   /** Retorno de OK **/
   IF l-ok THEN DO:
      OUTPUT TO VALUE (c-arquivo).

      /** Salva Seleá∆o **/
      FOR EACH ttSelecao:
          IF l-usa-unid-negoc THEN DO:
              &IF DEFINED (bf_mnt_ems206b) &THEN
                  EXPORT DELIMITER ";"
                      ttSelecao.dat-ini
                      ttSelecao.dat-fim
                      ttSelecao.ep-codigo-ini
                      ttSelecao.ep-codigo-fim
                      ttSelecao.estab-eqpto-ini
                      ttSelecao.estab-eqpto-fim
                      ttSelecao.tag-ini
                      ttSelecao.tag-fim
                      ttSelecao.cc-codigo-ini
                      ttSelecao.cc-codigo-fim
                      ttSelecao.cod-eqpto-ini
                      ttSelecao.cod-eqpto-fim
                      ttSelecao.estab-posto-ini
                      ttSelecao.estab-posto-fim
                      ttSelecao.posto-ini
                      ttSelecao.posto-fim
                      ttSelecao.bomba-ini
                      ttSelecao.bomba-fim
                      ttSelecao.deposito-ini
                      ttSelecao.deposito-fim
                      ttSelecao.cod-model-ini
                      ttSelecao.cod-model-fim
                      ttSelecao.iVisualiza
                      ttSelecao.lAtivos
                      ttSelecao.lInativos
                      ttSelecao.lProprios
                      ttSelecao.lTerceiros
                      ttSelecao.lMotorizados
                      ttSelecao.lNMotorizados
                      ttSelecao.iAtualiza
                      ttSelecao.cod-unid-negoc-ini
                      ttSelecao.cod-unid-negoc-fim.

              &ENDIF
          END.
          ELSE DO:
              EXPORT DELIMITER ";"
                  ttSelecao.dat-ini
                  ttSelecao.dat-fim
                  ttSelecao.ep-codigo-ini
                  ttSelecao.ep-codigo-fim
                  ttSelecao.estab-eqpto-ini
                  ttSelecao.estab-eqpto-fim
                  ttSelecao.tag-ini
                  ttSelecao.tag-fim
                  ttSelecao.cc-codigo-ini
                  ttSelecao.cc-codigo-fim
                  ttSelecao.cod-eqpto-ini
                  ttSelecao.cod-eqpto-fim
                  ttSelecao.estab-posto-ini
                  ttSelecao.estab-posto-fim
                  ttSelecao.posto-ini
                  ttSelecao.posto-fim
                  ttSelecao.bomba-ini
                  ttSelecao.bomba-fim
                  ttSelecao.deposito-ini
                  ttSelecao.deposito-fim
                  ttSelecao.cod-model-ini
                  ttSelecao.cod-model-fim
                  ttSelecao.iVisualiza
                  ttSelecao.lAtivos
                  ttSelecao.lInativos
                  ttSelecao.lProprios
                  ttSelecao.lTerceiros
                  ttSelecao.lMotorizados
                  ttSelecao.lNMotorizados
                  ttSelecao.iAtualiza.
          END.
      END.
      /** Salva Vis‰es **/
      FOR EACH ttVisao:
          EXPORT DELIMITER ";"
                 ttVisao.dimensao
                 ttVisao.sequencia.
      END.
      OUTPUT CLOSE.
   END.

   APPLY "ENTRY":U TO btSalvar IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTxt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTxt wWindow
ON CHOOSE OF btTxt IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miTxt IN MENU mbMain DO:
    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
        RUN piTexto IN THIS-PROCEDURE.
    END.
    APPLY "ENTRY":U TO btTxt IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUsuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUsuario wWindow
ON CHOOSE OF btUsuario IN FRAME fpage0
DO:
    if avail ttDados then do:
        get current brApont.
        /** Libera registro pelo usu†rio **/
        DO TRANS:            
            RUN piLibera IN THIS-PROCEDURE (INPUT 3).
            IF  RETURN-VALUE = "NOK":U THEN DO:
                UNDO, LEAVE.
            END.
            ELSE DO:
                /** Busca os registros **/
                RUN piAtualizaVisao IN THIS-PROCEDURE (INPUT 1).
            END.
        END.

        APPLY "ENTRY":U TO brApont IN FRAME fPage0.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVaPara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVaPara wWindow
ON CHOOSE OF btVaPara IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miVaPara IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisao wWindow
ON CHOOSE OF btVisao IN FRAME fpage0 /* Classificar */
OR CHOOSE OF MENU-ITEM miClassifica IN MENU mbMain DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN abp/ab0307c.w (INPUT-OUTPUT TABLE ttVisao).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY "ENTRY":U TO btVisao IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame-4 wWindow OCX.Tick
PROCEDURE CtrlFrame-4.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
/** Atualiza dados **/
SESSION:SET-WAIT-STATE ("GENERAL":U).
RUN piAtualizar IN THIS-PROCEDURE.
SESSION:SET-WAIT-STATE ("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAtivid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAtivid wWindow
ON LEAVE OF fiAtivid IN FRAME fpage0
DO:
   if avail ttDados then do:
       get current brApont.
        assign fiAtivid:screen-value in frame fPage0 = ttDados.cod-ativid.
        {method\referenceFields.i
            &HandleDBOLeave="hDBOAtiv"
            &KeyValue1="fiAtivid:screen-value in frame fPage0"
            &FieldName1="des-ativid"
            &FieldScreen1="fiDescAtiv"
            &Frame1="fPage0"}
    end.
    else do:
        assign fiAtivid:screen-value in frame fPage0   = ""
               fiDescAtiv:screen-value in frame fPage0 = "".
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiModelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiModelo wWindow
ON LEAVE OF fiModelo IN FRAME fpage0
DO:
    if can-find(first ttDados) then do:
        run buscaModelo in this-procedure.
        {method\referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="fiModelo:screen-value in frame fPage0"
            &FieldName1="des-model"
            &FieldScreen1="fiDescModelo"
            &Frame1="fPage0"
            &FieldName2="un"
            &FieldScreen2="fiUN1"
            &Frame2="fPage0"
            &FieldName3="un"
            &FieldScreen3="fiUN2"
            &Frame3="fPage0"
            &FieldName4="cod-livre-1"
            &Variable1="c-cod-livre-1"}

            RUN goToKey      IN hDBOModelo (INPUT fiModelo:SCREEN-VALUE IN FRAME fPage0).
            RUN getCharField IN hDBOModelo (INPUT "cod-livre-1":U,
                                            OUTPUT c-cod-livre-1).
        ASSIGN fiUNSec:SCREEN-VALUE IN FRAME fPAge0   = SUBSTRING(c-cod-livre-1, 1, 2)
               fiUN-2:SCREEN-VALUE IN FRAME fPAge0    = fiUN1:SCREEN-VALUE IN FRAME fPAge0
               fiUNSec-2:SCREEN-VALUE IN FRAME fPAge0 = fiUNSec:SCREEN-VALUE IN FRAME fPAge0.
        /*ttApont.cod-eqpto*/
    end.
    else 
        assign fiModelo:screen-value in frame fPage0     = ""
               fiDescModelo:screen-value in frame fPage0 = ""
               fiUN1:screen-value in frame fPage0        = ""
               fiUN2:screen-value in frame fPage0        = ""
               fiUNSec:SCREEN-VALUE IN FRAME fPAge0      = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_%_Remonta_leo_Motor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_%_Remonta_leo_Motor wWindow
ON CHOOSE OF MENU-ITEM m_%_Remonta_leo_Motor /* % Remonta ‡leo Motor */
DO:
    run abp/ab0404.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Abastecimento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Abastecimento wWindow
ON CHOOSE OF MENU-ITEM m_Abastecimento /* Abastecimento */
DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  RUN piConsultaAbastecimento IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_AbastecimentoLubrificao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_AbastecimentoLubrificao wWindow
ON CHOOSE OF MENU-ITEM m_AbastecimentoLubrificao /* Abastecimento/Lubrificaá∆o */
DO:
    run chamaPrograma in this-procedure (input "abp/ab0302.w":U,
                                         input 00,
                                         input no).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Compartimento_leoFiltros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Compartimento_leoFiltros wWindow
ON CHOOSE OF MENU-ITEM m_Compartimento_leoFiltros /* Compartimento ‡leo/Filtros */
DO:
    run abp/ab0109.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ConsisteAtualiza_Apontament
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ConsisteAtualiza_Apontament wWindow
ON CHOOSE OF MENU-ITEM m_ConsisteAtualiza_Apontament /* Consiste/Atualiza Apontamentos */
DO:
    run abp/ab0401.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Importao_AbastLubrif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Importao_AbastLubrif wWindow
ON CHOOSE OF MENU-ITEM m_Importao_AbastLubrif /* Importaá∆o Abast./Lubrif. */
DO:
    run abp/ab0705.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Integrao_Estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Integrao_Estoque wWindow
ON CHOOSE OF MENU-ITEM m_Integrao_Estoque /* Integraá∆o Estoque */
DO:
    run abp/ab0410.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Manuteno_Equipamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Manuteno_Equipamento wWindow
ON CHOOSE OF MENU-ITEM m_Manuteno_Equipamento /* Manutená∆o Equipamento */
DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  run piEquipamento in this-procedure (input "abp/ab0138.w").
  if return-value = "NOK":U then
      return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Manuteno_Modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Manuteno_Modelo wWindow
ON CHOOSE OF MENU-ITEM m_Manuteno_Modelo /* Manutená∆o Modelo */
DO:
    run abp/ab0104.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tipo_de_Material
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tipo_de_Material wWindow
ON CHOOSE OF MENU-ITEM m_Tipo_de_Material /* Tipo de Material */
DO:
    run abp/ab0102.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brApont
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
define temp-table RowErrorsAux no-undo like RowErrors.

btMenu:load-mouse-pointer("image/rbm.cur":U) in frame fPage0.

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

ON 'ENTRY':U anywhere DO:
    for first ttSelecao no-lock:
        assign chTimer:Interval = ttSelecao.iAtualiza * 60 * 1000.
    end.
END.

{abp/ab9000.i}    /** Convers∆o de horas invertidas **/
{abp/ab9005.i}    /** Validaá∆o de ParÉmetros **/
{abp/abapi001.i2} /** Criaá∆o de Erros **/


RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccusto.
RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  "",                     /* EMPRESA EMS2 */
                                             INPUT  "",                     /* CODIGO DO PLANO CCUSTO */
                                             INPUT  "",                     /* UNIDADE DE NEGOCIO */
                                             INPUT  TODAY,                  /* DATA DE TRANSACAO */
                                             OUTPUT TABLE tt_ccusto_integr, /* CCUSTOS */
                                             OUTPUT TABLE tt_log_erro).     /* ERROS */

{cdp/cdunif001b.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: afterDestroyInterface
  Parameters:  <none>
  Notes: Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
IF VALID-HANDLE(hDBOEqpto) THEN
    RUN Destroy IN hDBOEqpto.
/** Modelo **/
IF VALID-HANDLE(hDBOModelo) THEN
    RUN Destroy IN hDBOModelo.
/** Atividade **/
IF VALID-HANDLE(hDBOAtiv) THEN
    RUN Destroy IN hDBOAtiv.
/** API **/
IF VALID-HANDLE(hAbapi002) THEN
    DELETE PROCEDURE hAbapi002.
/* APONTAMENTO */
IF VALID-HANDLE(hDBOApont) THEN
    RUN Destroy IN hDBOApont.
/* ABASTECIMENTO */
IF VALID-HANDLE(hDBOAbast) THEN  
    RUN Destroy IN hDBOAbast.  

IF VALID-HANDLE(h_api_ccusto) THEN  
    DELETE PROCEDURE h_api_ccusto.   





{method/showmessage.i3}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o de tela
------------------------------------------------------------------------------*/
/** Busca os registros com erros para serem listados **/
/*run buscaApontamentos in this-procedure.*/

/** Busca Valores de m†ximo e m°nimo de consumo **/
FOR EACH  mab-param FIELDS(des-valor)
    WHERE mab-param.cdn-param = 14 NO-LOCK:
    ASSIGN deParam14 = DEC(mab-param.des-valor).
END.

/** Labels do browse **/
assign ttDados.ep-codigo:label in browse brApont     = fnBrowse("ep-codigo":U,1)
       ttDados.cod-eqpto:label in browse brApont     = fnBrowse("cod-eqpto":U,1)
       ttDados.dat-movto:label in browse brApont     = fnBrowse("dat-movto":U,1)
       ttDados.hra-inicial:label in browse brApont   = fnBrowse("hra-inicial":U,1)
       ttDados.num-docto:label in browse brApont     = fnBrowse("num-docto":U,1).

{utp/ut-liter.i "Descriá∆o Erro"}
assign cErro:label in browse brApont = return-value.

assign EDITOR-1:sensitive in frame fPage0 = yes 
       EDITOR-1:read-only in frame fPage0 = yes. 

run piLabelCampos in this-procedure.

/** Busca os parametros cadastrados ao consumo **/
RUN piPadrao IN THIS-PROCEDURE.

RETURN "OK":U.
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
DEFINE VARIABLE cTexto LIKE ttDados.cod-oficial NO-UNDO.

/** Se tiver filhos, mostra no browse, os filhos **/
if avail ttDados then do:
    CASE iImBrw:
        /* Empresa */
        WHEN 1 THEN DO:
            ASSIGN cTexto = SUBSTRING(cCodOficial,1,3).
            open query brApont for each ttDados NO-LOCK
                             &IF "{&mguni_version}" >= "2.071" &THEN
                                  WHERE ttDados.ep-codigo = cTexto
                             &ELSE
                                  WHERE ttDados.ep-codigo = int(cTexto)
                             &ENDIF
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Estabelecimento Equipamento */
        WHEN 2 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-estabel-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* TAG */
        WHEN 3 THEN DO:
            ASSIGN cTexto = IF (cCodOficial = "_" OR cCodOficial = "__") THEN "" ELSE cCodOficial.
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cd-tag-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Centro Custo */
        WHEN 4 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cc-codigo-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Equipamento */
        WHEN 5 THEN DO:
            ASSIGN cTexto = SUBSTRING(cCodOficial,5,16).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-eqpto = trim(cTexto)
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Màs/Ano */
        WHEN 6 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.mes-ano = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Data */
        WHEN 7 THEN DO:
            ASSIGN cTexto = cCodOficial.
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.dat-movto = date(cTexto)
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Estabelecimento Posto */
        WHEN 8 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-estabel-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Posto */
        WHEN 9 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Dep¢sito */
        WHEN 10 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-depos-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Modelo */
        WHEN 11 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-model-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Bomba */
        WHEN 12 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-bomba = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        OTHERWISE DO:
            open query brApont for each ttDados NO-LOCK.
        END.
    END CASE.
end.
/** Sen∆o, mostra ele mesmo **/
else do:
    CASE iImBrw:
        /* Empresa */
        WHEN 1 THEN DO:
            ASSIGN cTexto = SUBSTRING(cCodOficial,1,3).
            open query brApont for each ttDados NO-LOCK
                             &IF "{&mguni_version}" >= "2.071" &THEN
                                  WHERE ttDados.ep-codigo = cTexto
                             &ELSE
                                  WHERE ttDados.ep-codigo = int(cTexto)
                             &ENDIF
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Estabelecimento Equipamento */
        WHEN 2 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-estabel-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* TAG */
        WHEN 3 THEN DO:
            ASSIGN cTexto = IF (cCodOficial = "_" OR cCodOficial = "__") THEN "" ELSE cCodOficial.
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cd-tag-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Centro Custo */
        WHEN 4 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cc-codigo-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Equipamento */
        WHEN 5 THEN DO:
            ASSIGN cTexto = SUBSTRING(cCodOficial,5,16).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-eqpto = trim(cTexto)
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Màs/Ano */
        WHEN 6 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.mes-ano = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Data */
        WHEN 7 THEN DO:
            ASSIGN cTexto = cCodOficial.
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.dat-movto = date(cTexto)
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial.
        END.
        /* Estabelecimento Posto */
        WHEN 8 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-estabel-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Posto */
        WHEN 9 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Dep¢sito */
        WHEN 10 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-depos-posto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Modelo */
        WHEN 11 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-model-eqpto = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        /* Bomba */
        WHEN 12 THEN DO:
            ASSIGN cTexto = trim(cCodOficial).
            open query brApont for each ttDados NO-LOCK
                                  WHERE ttDados.cod-bomba = cTexto
                                  AND   ttDados.i-filho   = 2
                BY ttDados.ep-codigo  
                BY ttDados.cod-eqpto  
                BY ttDados.dat-movto
                BY ttDados.hra-inicial. 
        END.
        OTHERWISE DO:
            open query brApont for each ttDados NO-LOCK.
        END.
    END CASE.
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
  Notes:       Override (antes) inicializaá∆o de tela
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-label AS CHARACTER NO-UNDO.

/* -------------------------- */
/* Monta o Browse do TreeView */
/* -------------------------- */

IF  NOT VALID-HANDLE(h-4gltreeview) THEN DO:
    RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.

    RUN setParentFrame  IN  h-4gltreeview   (INPUT  FRAME   fPage0:HANDLE).

    RUN initializeObject IN h-4gltreeview.

    SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

    ASSIGN  n-4gltreeview-row       =   2.60.
    ASSIGN  n-4gltreeview-column    =   1.05.
    ASSIGN  n-4gltreeview-height    =   13.3.
    ASSIGN  n-4gltreeview-width     =   31.0.

    RUN repositionObject IN h-4gltreeview ( n-4gltreeview-row , n-4gltreeview-column )   NO-ERROR.
    RUN resizeObject     IN h-4gltreeview ( n-4gltreeview-height , n-4gltreeview-width ) NO-ERROR.
END.

/** Valida se os par∆metros est∆o cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "14,19,20,21":U,
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
       chTimer                  = chCtrlFrame-4:PSTimer
       dWinYC                   = wWindow:height-chars.

RUN emptyTree   IN  h-4gltreeview.
ASSIGN  c-codigo-node   =   "".

run criattSelecao in this-procedure.

/** Inicializaá∆o das BOs **/
run initializeDBOs in this-procedure.

return "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wWindow 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/
if num-results("brApont":U) > 0 then
    get current brApont.

IF AVAIL ttDados THEN DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOEqpto"
        &KeyValue1="ttDados.ep-codigo"
        &KeyValue2="ttDados.cod-eqpto"
        &FieldName1="cod-model"
        &FieldScreen1="fiModelo"
        &Frame1="fPage0"}

    RUN goToKey IN hDBOEqpto (INPUT ttDados.ep-codigo,
                              INPUT ttDados.cod-eqpto).

    RUN getLogField IN hDBOEqpto (INPUT "log-cont-sec":U,
                                  OUTPUT lUsacontadorSec).
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
assign vCodigo    = ""
       vDescricao = ""
       iImage     = 0
       rRowid     = ?.

/** Verifica tipo de vis∆o (classificaá∆o) **/
case substring(trim(pValorDimensao),1,2):
    /** Empresa **/
    when "01":U then do:
        if not avail empresa or empresa.ep-codigo <> mab-abastec-lubrific.ep-codigo then do:
            for first empresa fields(nome ep-codigo)
                where empresa.ep-codigo = mab-abastec-lubrific.ep-codigo no-lock:
            end.
        end.
        if avail empresa then do:
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = string(empresa.ep-codigo,"x(03)")
        &ELSE
            assign vCodigo    = string(empresa.ep-codigo,"999")
        &ENDIF
                   vDescricao = empresa.nome
                   iImage     = 1
                   rRowid     = rowid(empresa).
        end.
        else do:
            {utp/ut-liter.i Empresa_N∆o_Encontrada}
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = string(mab-eqpto.ep-codigo,"x(03)")
        &ELSE
            assign vCodigo    = string(mab-eqpto.ep-codigo,"999")
        &ENDIF
                   vDescricao = return-value
                   iImage     = 1
                   rRowid     = rowid(mab-abastec-lubrific).
        end.
    end.
    /** Estabel Eqpto **/
    when "02":U then do:
         if not avail estabelec or estabelec.cod-estabel <> mab-eqpto.cod-estabel then do:
             for first estabelec fields(nome cod-estabel)  
                 where estabelec.cod-estabel = mab-eqpto.cod-estabel no-lock:
             end.
         end.
         if avail estabelec then do:
             assign vCodigo    = estabelec.cod-estabel
                    vDescricao = estabelec.nome
                    iImage     = 2
                    rRowid     = rowid(estabelec).
         end.
         else do:
            {utp/ut-liter.i Estabel_N∆o_Encontrada}
            assign vCodigo     = mab-eqpto.cod-estabel
                   vDescricao  = return-value
                   iImage      = 2
                   rRowid      = rowid(mab-abastec-lubrific).
         end.
    end.
    /** TAG **/
    when "03":U then do:
        if not avail tag or tag.cd-tag <> mab-eqpto.cd-tag then do:
            for first tag 
                where tag.cd-tag = mab-eqpto.cd-tag no-lock:
            end.
        end.
        if avail tag then do:
            assign vCodigo    = if mab-eqpto.cd-tag = "" then "_" else mab-eqpto.cd-tag
                   vDescricao = tag.descricao
                   iImage     = 3
                   rRowid     = rowid(tag).
        end.
        else do:
            {utp/ut-liter.i Tag_N∆o_Encontrado}
            assign vCodigo    = if mab-eqpto.cd-tag = "" then "__" else mab-eqpto.cd-tag
                   vDescricao = return-value    
                   iImage     = 3
                   rRowid     = rowid(mab-abastec-lubrific). 
        end.
    end.
    /** Centro de Custo **/
    when "04":U then do:
        if not avail tt_ccusto_integr or tt_ccusto_integr.ttv_cod_ccusto <> mab-eqpto.cc-codigo then do:
            for first tt_ccusto_integr
                where tt_ccusto_integr.ttv_cod_ccusto = mab-eqpto.cc-codigo no-lock:
            end.
        end.
        if avail tt_ccusto_integr then do:
            assign vCodigo      = mab-eqpto.cc-codigo
                   vDescricao   = tt_ccusto_integr.ttv_des_titulo
                   iImage       = 4
                   rRowid       = rowid(tt_ccusto_integr).
         end.
         else do:
             {utp/ut-liter.i Centro_Custo_N∆o_Encontrado}
             assign vCodigo     = mab-eqpto.cc-codigo
                    vDescricao  = return-value
                    iImage      = 4
                    rRowid      = rowid(mab-abastec-lubrific).
         end.
    end.
    /** Equipamento **/
    when "05":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model un)
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = string(mab-eqpto.ep-codigo,"x(03)") + "-" + mab-eqpto.cod-eqpto
        &ELSE
            assign vCodigo    = string(mab-eqpto.ep-codigo,"999") + "-" + mab-eqpto.cod-eqpto
        &ENDIF
                   vDescricao = mab-model.des-model
                   iImage     = 5
                   rRowid     = rowid(mab-abastec-lubrific).
        end.
        else do:
            {utp/ut-liter.i Equipamento_N∆o_Encontrado}
        &IF "{&mguni_version}" >= "2.071" &THEN
            assign vCodigo    = string(mab-eqpto.ep-codigo,"x(03)") + "-" + mab-eqpto.cod-eqpto
        &ELSE
            assign vCodigo    = string(mab-eqpto.ep-codigo,"999") + "-" + mab-eqpto.cod-eqpto
        &ENDIF
                   vDescricao = return-value
                   iImage     = 5
                   rRowid     = rowid(mab-abastec-lubrific).
         end.
    end.
    /* Màs/Ano */
    when "06":U then do:
        assign vCodigo    = string(string(month(mab-abastec-lubrific.dat-movto),"99") + "/" + string(year(mab-abastec-lubrific.dat-movto),"9999"))
               vDescricao = ""
               iImage     = 6
               rRowid     = rowid(mab-abastec-lubrific).
    end.
    /* Data */
    when "07":U then do:
        assign vCodigo    = string(mab-abastec-lubrific.dat-movto,"99/99/9999")
               vDescricao = ""
               iImage     = 7
               rRowid     = rowid(mab-abastec-lubrific).
    end.
    /** Estabel Posto **/
    when "08":U then do:
         if not avail estabelec or estabelec.cod-estabel <> mab-posto.cod-estabel then do:
             for first estabelec fields(nome cod-estabel)  
                 where estabelec.cod-estabel = mab-posto.cod-estabel no-lock:
             end.
         end.
         if avail estabelec then do:
             assign vCodigo    = mab-posto.cod-estabel
                    vDescricao = estabelec.nome
                    iImage     = 8 
                    rRowid     = rowid(estabelec).
         end.
         else do:
             {utp/ut-liter.i Estabel_N∆o_Encontrado}
             assign vCodigo     = mab-posto.cod-estabel
                    vDescricao  = return-value
                    iImage      = 8
                    rRowid      = rowid(mab-abastec-lubrific).
         end.
     end.
     /** Posto **/
     when "09":U then do:
         assign vCodigo    = mab-posto.cod-posto
                vDescricao = mab-posto.des-posto
                iImage     = 9
                rRowid     = rowid(mab-posto).
    end.
    /** Dep¢sito **/
    when "10":U then do:
        if not avail deposito or deposito.cod-depos <> mab-posto.cod-depos then do:
            for first deposito
                where deposito.cod-depos = mab-posto.cod-depos no-lock:
            end.
        end.
        if avail deposito then do:
            assign vCodigo    = mab-posto.cod-depos
                   vDescricao = deposito.nome
                   iImage     = 10
                   rRowid     = rowid(deposito).
        end.
        else do:
            {utp/ut-liter.i Dep¢sito_N∆o_Encontrado}
            assign vCodigo    = "_"
                   vDescricao = return-value    
                   iImage     = 10
                   rRowid     = rowid(mab-abastec-lubrific). 
        end.
    end.
    /** Modelo **/
    when "11":U then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then do:
            for first mab-model fields(des-model cod-model)  
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        end.
        if avail mab-model then do:         
            assign vCodigo    = mab-eqpto.cod-model
                   vDescricao = mab-model.des-model
                   iImage     = 11
                   rRowid     = rowid(mab-model).
        end.
        else do:
            {utp/ut-liter.i Modelo_N∆o_Encontrado}
            assign vCodigo    = mab-eqpto.cod-model
                   vDescricao = return-value    
                   iImage     = 11
                   rRowid     = rowid(mab-abastec-lubrific). 
        end.
    end.
    /** Bomba **/
    when "12":U then do:
        if not avail mab-bomba or mab-bomba.cod-posto <> mab-posto.cod-posto then do:
            for first mab-bomba
                where mab-bomba.cod-posto = mab-posto.cod-posto no-lock:
            end.
        end.
        if avail mab-bomba then do:
            assign vCodigo    = mab-bomba.cod-bomba 
                   iImage     = 12
                   rRowid     = rowid(mab-bomba).
        end.
        else do:
            assign vCodigo    = "0"
                   iImage     = 12
                   rRowid     = rowid(mab-abastec-lubrific).
        end.
    end.
    /** Unidade Negocio **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN "13" THEN DO:
            IF l-usa-unid-negoc THEN DO:
                IF NOT AVAIL unid-negoc OR mab-abastec-lubrific.cod-unid-negoc <> unid-negoc.cod-unid-negoc THEN DO:
                    FOR FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc NO-LOCK:
                    END.
                END.
                IF AVAIL unid-negoc THEN DO:
                    ASSIGN vCodigo    = STRING(unid-negoc.cod-unid-negoc)
                           vDescricao = STRING(unid-negoc.des-unid-negoc)
                           iImage     = 13
                           rRowid     = ROWID(unid-negoc).
                END.
                ELSE DO:
                    {utp/ut-liter.i "Unidade_Neg¢cio_n∆o_encontrada"}
                    ASSIGN vCodigo    = "_":U
                           vDescricao = RETURN-VALUE
                           iImage     = 13
                           rRowid     = ROWID(mab-abastec-lubrific).
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
define input parameter cNome as character no-undo.

define variable c-linha as char no-undo.

/** Limpa as vis‰es **/
empty temp-table ttVisao.

input from value (cNome).
/** Busca os parÉmetros e seleá‰es **/
for first ttSelecao exclusive-lock:
    import unformatted c-linha.
    assign c-linha                    = replace (c-linha, chr(34), "")
           ttSelecao.dat-ini          = date(entry(1,c-linha,";"))
           ttSelecao.dat-fim          = date(entry(2,c-linha,";"))
       &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.ep-codigo-ini    = entry(3,c-linha,";")
           ttSelecao.ep-codigo-fim    = entry(4,c-linha,";")
       &ELSE
           ttSelecao.ep-codigo-ini    = int(entry(3,c-linha,";")) 
           ttSelecao.ep-codigo-fim    = int(entry(4,c-linha,";")) 
       &ENDIF
           ttSelecao.estab-eqpto-ini  = entry(5,c-linha,";")      
           ttSelecao.estab-eqpto-fim  = entry(6,c-linha,";")      
           ttSelecao.tag-ini          = entry(7,c-linha,";")      
           ttSelecao.tag-fim          = entry(8,c-linha,";")      
           ttSelecao.cc-codigo-ini    = entry(9,c-linha,";")      
           ttSelecao.cc-codigo-fim    = entry(10,c-linha,";")     
           ttSelecao.cod-eqpto-ini    = entry(11,c-linha,";")     
           ttSelecao.cod-eqpto-fim    = entry(12,c-linha,";")     
           ttSelecao.estab-posto-ini  = entry(13,c-linha,";")     
           ttSelecao.estab-posto-fim  = entry(14,c-linha,";")     
           ttSelecao.posto-ini        = entry(15,c-linha,";")     
           ttSelecao.posto-fim        = entry(16,c-linha,";")  
           ttSelecao.bomba-ini        = entry(17,c-linha,";")     
           ttSelecao.bomba-fim        = entry(18,c-linha,";")  
           ttSelecao.deposito-ini     = entry(19,c-linha,";")     
           ttSelecao.deposito-fim     = entry(20,c-linha,";")     
           ttSelecao.cod-model-ini    = entry(21,c-linha,";")
           ttSelecao.cod-model-fim    = entry(22,c-linha,";")
           ttSelecao.iVisualiza       = int(entry(23,c-linha,";"))
           ttSelecao.lAtivos          = (entry(24,c-linha,";") = "yes")
           ttSelecao.lInativos        = (entry(25,c-linha,";") = "yes")     
           ttSelecao.lProprios        = (entry(26,c-linha,";") = "yes")     
           ttSelecao.lTerceiros       = (entry(27,c-linha,";") = "yes")     
           ttSelecao.lMotorizados     = (entry(28,c-linha,";") = "yes")
           ttSelecao.lNMotorizados    = (entry(29,c-linha,";") = "yes")
           ttSelecao.iAtualiza        = int(entry(30,c-linha,";")).
        IF l-usa-unid-negoc THEN DO:
            &IF DEFINED (bf_mnt_ems206b) &THEN
                ASSIGN ttSelecao.cod-unid-negoc-ini = entry(31,c-linha,";")
                       ttSelecao.cod-unid-negoc-fim = entry(32,c-linha,";").            
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chamaPrograma wWindow 
PROCEDURE chamaPrograma :
/*------------------------------------------------------------------------------
  Purpose:     chamaPrograma
  Parameters:  entrada pProgram = Caminho do programa (ex: "abp/ab0303.w")
               entrada pImagem  = Imagem da Vis∆o
               entrada pAtualiz = Atualiza browse
  Notes:       Chama programa de apontamentos de eventos passando o equipamento
               que se deseja incluir o evento.
------------------------------------------------------------------------------*/
define input parameter pProgram as character no-undo.
define input parameter pImagem  as integer   no-undo.
define input parameter pAtualiz as logical   no-undo.

DEFINE VARIABLE iDocto   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImagem  AS INTEGER    NO-UNDO.
DEFINE VARIABLE rProgram AS ROWID      NO-UNDO.
DEFINE VARIABLE hProgram AS HANDLE     NO-UNDO.

IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
    assign rRowid = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
    for first ttDados
        where rowid(ttDados) = rRowid no-lock:
        assign iDocto   = ttDados.num-docto
               rProgram = ttDados.r-rowid
               iImagem  = ttDados.p-image.
    end.
    if  iImagem = 11 then do:
        for first mab-eqpto
            where mab-eqpto.ep-codigo = ttDados.ep-codigo 
            and   mab-eqpto.cod-eqpto = ttDados.cod-eqpto no-lock:
            assign rProgram = rowid(mab-eqpto).
        end.            
    end.
end.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
RUN value(pProgram) PERSISTENT SET hProgram.

/* novo mÇtodo de teste do valid-handle */
IF VALID-HANDLE(hProgram) AND
   hProgram:Type = "PROCEDURE":U AND
   hProgram:FILE-NAME = pProgram THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
    RUN initializeInterface IN hProgram.

IF VALID-HANDLE(hProgram) THEN DO:
    /** Reposiciona programa no registro **/
    run repositionRecord in hProgram (input rProgram).
end.

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
wait-for "CLOSE":U of hProgram.

assign {&window-name}:sensitive = yes.

if valid-handle(hProgram) then
    delete procedure hProgram.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wWindow  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "ab0307.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame-4 = CtrlFrame-4:COM-HANDLE
    UIB_S = chCtrlFrame-4:LoadControls( OCXFile, "CtrlFrame-4":U)
    CtrlFrame-4:NAME = "CtrlFrame-4":U
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "ab0307.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
define variable i-img    as integer           no-undo.

define buffer bfttDados for ttDados.

/** Limpa o tree-view **/
RUN emptyTree   IN  h-4gltreeview.
ASSIGN  c-codigo-node   =   "".

assign i-cont = 0.
/** Verifica se existem vis‰es escolhidas **/
for last ttVisao fields(sequencia) no-lock:
    assign iQtSeq = ttVisao.sequencia.
end.

IF iQtSeq = 0 then return.

/** Busca os dados criados **/
for each ttDados
    where ttDados.sequencia <= iQtSeq no-lock use-index dime:

    /** Conta sequàncias de linhas **/ 
    assign i-cont           = i-cont + 1.
    assign ttDados.seq-tree = i-cont.
    assign i-img            = ttDados.p-image.

    /** Inclui primeira linha **/
    IF  ttDados.sequencia   =   1   THEN    DO:
        RUN pi-create-node  ("i" + STRING(i-cont), "" , STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao, fnImages(ttDados.p-image), "") .          

        DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + ",").
        IF  ttDados.r-rowid <>  ?   THEN
            DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + "," + STRING(ttDados.r-rowid)).
    END.
    ELSE    DO:
        /** Busca filhos da vis∆o escolhida **/
        FOR FIRST   bfttDados 
            WHERE   bfttDados.cod-dimensao  =   ttDados.cod-dimens-pai  NO-LOCK:
            
            /** Inclui linhas das vis‰es filhas **/
            RUN pi-create-node  ("i" + STRING(i-cont), "i" + STRING(bfttDados.seq-tree), STRING(ttDados.cod-oficial) + " - " + ttDados.desc-dimensao, fnImages(ttDados.p-image), "").

            /** Guarda chave (rowid) da temp-table no tree-view **/
            DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + ",").
            IF  ttDados.r-rowid <>  ?   THEN
                DYNAMIC-FUNCTION('setNodeTag' IN  h-4gltreeview, "i" + STRING(i-cont), STRING(ROWID(ttDados)) + "," + STRING(ttDados.p-image) + "," + STRING(ttDados.r-rowid)).
        END.
    END.
END.

RUN pi-atualizaTreeview.

RUN applyEntry  IN  h-4gltreeview   (INPUT  "").

/** Posiciona o Tree-View no £ltimo lido **/
IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN DO:
    DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, c-codigo-node).
END.

RETURN  "OK":U.
END PROCEDURE.

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
assign ttSelecao.dat-ini          = today - 30
       ttSelecao.dat-fim          = today
&IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.ep-codigo-ini    = ""
       ttSelecao.ep-codigo-fim    = "ZZZ"
&ELSE
       ttSelecao.ep-codigo-ini    = 0
       ttSelecao.ep-codigo-fim    = 999
&ENDIF
       ttSelecao.estab-eqpto-ini  = ""
&IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.estab-eqpto-fim  = "ZZZZZ"
&ELSE
       ttSelecao.estab-eqpto-fim  = "ZZZ"
&ENDIF
       ttSelecao.tag-ini          = ""
       ttSelecao.tag-fim          = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.cc-codigo-ini    = ""
       ttSelecao.cc-codigo-fim    = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.cod-eqpto-ini    = ""
       ttSelecao.cod-eqpto-fim    = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.estab-posto-ini  = ""
&IF "{&mguni_version}" >= "2.071" &THEN
       ttSelecao.estab-posto-fim  = "ZZZZZ"
&ELSE
       ttSelecao.estab-posto-fim  = "ZZZ"
&ENDIF
       ttSelecao.posto-ini        = ""
       ttSelecao.posto-fim        = "ZZZZZZZZ"
       ttSelecao.bomba-ini        = ""
       ttSelecao.bomba-fim        = "ZZZZZZZZ"
       ttSelecao.deposito-ini     = ""
       ttSelecao.deposito-fim     = "ZZZ"
       ttSelecao.cod-model-ini    = ""
       ttSelecao.cod-model-fim    = "ZZZZZZZZ"
       ttSelecao.iVisualiza       = 1
       ttSelecao.lAtivos          = yes   
       ttSelecao.lInativos        = no
       ttSelecao.lProprios        = yes
       ttSelecao.lTerceiros       = yes
       ttSelecao.lMotorizados     = yes
       ttSelecao.lNMotorizados    = yes
       ttSelecao.iAtualiza        = 15
&IF DEFINED(bf_mnt_ems206b) &THEN
       ttSelecao.cod-unid-negoc-ini = "":U
       ttSelecao.cod-unid-negoc-fim = "ZZZ":U
&ENDIF
       .

return "OK":U.
END PROCEDURE.

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
assign ttVisao.dimensao  = '01 ' + fnLabels(1)
       ttVisao.sequencia = 1.

create ttVisao.
assign ttVisao.dimensao  = '05 ' + fnLabels(5)
       ttVisao.sequencia = 2.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wWindow 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER bfttDados3 FOR ttDados.
define variable pNumDocto like mab-abastec-lubrific.num-docto no-undo.

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

DEFINE VARIABLE fiApontamento AS integer VIEW-AS FILL-IN SIZE 12 BY .88 NO-UNDO.

DEFINE FRAME fGoToRecord
    fiApontamento   AT ROW 1.21 COL 8.14 format ">>>,>>>,>>9" SKIP (0.3) 
    btGoToOK          AT ROW 2.63 COL 2.14
    btGoToCancel      AT ROW 2.63 COL 13
    rtGoToButton      AT ROW 2.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
    THREE-D SCROLLABLE FONT 1
    DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
{utp/ut-liter.i V†_Para_Apontamento *}
assign frame fGoToRecord:title = return-value.

{utp/ut-liter.i C¢digo_Apontamento *}
ASSIGN fiApontamento:LABEL IN FRAME fGoToRecord = RETURN-VALUE.

ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
    ASSIGN fiApontamento .

    for first mab-abastec-lubrific
        where mab-abastec-lubrific.num-docto = input frame fGoToRecord fiApontamento no-lock:
    end.
    IF NOT AVAIL mab-abastec-lubrific THEN DO:
        {utp/ut-liter.i C¢digo_Apontamento * }
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
        RETURN NO-APPLY.
    end.
    ELSE DO:
        ASSIGN pNumDocto = mab-abastec-lubrific.num-docto.
        RUN gotoTreeView (input pNumDocto,
                          input rowid(mab-abastec-lubrific)).
    end.
end.

APPLY "GO":U TO FRAME fGoToRecord.

ENABLE fiApontamento  btGoToOK btGoToCancel WITH FRAME fGoToRecord.

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
def input param pNumDocto like  mab-abastec-lubrific.num-docto no-undo.
def input param pRowid    as rowid                             no-undo.

DEFINE VARIABLE c-chave AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTexto  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto1 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-cont-aux AS INTEGER NO-UNDO.

ASSIGN cTexto = "".

for first ttDados exclusive-lock:
end.
if not avail ttDados then do:
    run piCriaRegistro in this-procedure (pNumDocto).
    /** Busca Registro com rowid **/
    for first bfttDados 
        where rowid(bfttDados) = rRowid3 no-lock:
    end.
    /** Verifica se ele contÇm filhos **/
    for first ttDados
        where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
    end.
    /** Mostra registros no browse **/
    run atualizaBrowse in this-procedure.
            
    /** Seleciona item **/
    DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(ttDados.seq-tree)).
end.
else do:
    if not can-find (first bfttDados
                     where bfttDados.num-docto = pNumDocto no-lock) then do:
        {utp/ut-liter.i "O Apontamento"}
        ASSIGN cTexto = RETURN-VALUE + " " + string(pNumDocto).
        {utp/ut-liter.i "n∆o foi encontrado. Deseja recriar a consulta?"}
        ASSIGN cTexto = cTexto + " " + RETURN-VALUE.
        {utp/ut-liter.i "O Apontamento"}
        ASSIGN cTexto1 = RETURN-VALUE + " " + string(pNumDocto).
        {utp/ut-liter.i "n∆o foi localizado na consulta do TreeView deseja recriar a consulta?"}
        ASSIGN cTexto1 = cTexto1 + " " + RETURN-VALUE + CHR(10).
        {utp/ut-liter.i "Observaá∆o"}
        ASSIGN cTexto1 = cTexto1 + RETURN-VALUE + ":" + CHR(10).
        {utp/ut-liter.i "Sim = Recria a consulta com base no n£mero da amostra informada"}
        ASSIGN cTexto1 = cTexto1 + RETURN-VALUE + CHR(10).
        {utp/ut-liter.i "N∆o = A consulta n∆o Ç modificada"}
        ASSIGN cTexto1 = cTexto1 + RETURN-VALUE + CHR(10).
        run utp/ut-msgs.p (input "show":U,
                           input 32699,
                           input cTexto + "~~" + cTexto1).
        if return-value = "YES":U then do:
            run piCriaRegistro  in this-procedure (pNumDocto).
            /** Busca Registro com rowid **/
            for first bfttDados 
                where rowid(bfttDados) = rRowid3 no-lock:
            end.
            /** Verifica se ele contÇm filhos **/
            for first ttDados
                where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
            end.
            /** Mostra registros no browse **/
            run atualizaBrowse in this-procedure.
            
            /** Seleciona item **/            
            DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(ttDados.seq-tree)).
        end.
        else do:
            return "NOK":U.
        end.
    end.
    else do:
        /** Busca os dados criados **/
        for each  bfttDados
            where bfttDados.num-docto = pNumDocto no-lock:
            
            assign i-cont-aux           = i-cont-aux + 1.
            /** Verifica se ele contÇm filhos **/
            for first ttDados
                where ttDados.cod-dimens-pai = bfttDados.cod-dimensao no-lock:
            end.
            /** Mostra registros no browse **/
            run atualizaBrowse in this-procedure.

            /** Posiciona o Tree-View no £ltimo lido **/
            if bfttDados.sequencia = 1 then do:
                DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(i-cont-aux)).
                RUN applyEntry IN h-4gltreeview(INPUT "").
            end.
            else do:
                DYNAMIC-FUNCTION('selectNode':U IN h-4gltreeview, "i" + STRING(bfttDados.i-cont)).
                RUN applyEntry IN h-4gltreeview(INPUT "").
            end.
        end.
    end.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as DBOs necess†rias no programa
------------------------------------------------------------------------------*/

/*--- BO Apontamento ---*/
IF NOT VALID-HANDLE(hDBOApont) OR
   hDBOApont:TYPE <> "PROCEDURE":U OR
   hDBOApont:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
    RUN frbo/bofr055.p PERSISTENT SET hDBOApont.
END.

RUN openQueryStatic IN hDBOApont (INPUT "Main":U) NO-ERROR.

/*--- BO Abastecimento  ---*/
IF NOT VALID-HANDLE(hDBOAbast) OR 
   hDBOAbast:TYPE <> "PROCEDURE":U OR
   hDBOAbast:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
    RUN frbo/bofr057.p PERSISTENT SET hDBOAbast.
END.

/*--- DBO Equipamento ---*/
IF NOT VALID-HANDLE(hDBOEqpto) OR
   hDBOEqpto:TYPE <> "PROCEDURE":U OR
   hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
    RUN frbo/bofr007.p PERSISTENT SET  hDBOEqpto.
END.

RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

/*--- DBO Modelo ---*/
IF NOT VALID-HANDLE(hDBOModelo) OR
   hDBOModelo:TYPE <> "PROCEDURE":U OR
   hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
    RUN frbo/bofr016.p PERSISTENT SET  hDBOModelo.
END.

RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

/*--- DBO Atividade  ---*/
IF NOT VALID-HANDLE(hDBOAtiv) OR
   hDBOAtiv:TYPE <> "PROCEDURE":U OR
   hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
    RUN frbo/bofr001.p PERSISTENT SET  hDBOAtiv.
END.

RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

RETURN "OK":U.

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

    IF  DYNAMIC-FUNCTION('hasNodes':U IN h-4gltreeview) THEN    DO:

        /** Guarda rowid do tree-view **/
        ASSIGN  r-rowid = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
        /* Busca Registro com rowid */
        FOR FIRST   bfttDados 
            WHERE   ROWID(bfttDados)    =   r-rowid NO-LOCK:
            ASSIGN  iImBrw              =   bfttDados.p-image
                    cCodOficial         =   bfttDados.cod-oficial.
        END.
        
        /* Verifica se ele contem filhos */
        FOR FIRST   ttDados
            WHERE   ttDados.cod-dimens-pai  =   bfttDados.cod-dimensao  NO-LOCK:
        END.
        IF  AVAIL   ttDados THEN    DO:
            /* Mostra registros no browse */
            RUN atualizaBrowse  IN  THIS-PROCEDURE.
        END.
        GET CURRENT brApont.
        APPLY "VALUE-CHANGED":U TO brApont IN FRAME fPage0.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CtrlPopupTreeview wWindow 
PROCEDURE pi-CtrlPopupTreeview :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAbastecimento wWindow 
PROCEDURE piAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     piAbastecimento
  Parameters:  <none>
  Notes:       Busca campos para serem mostrados em tela de acordo com registros
               de apontamento de abastecimento.
------------------------------------------------------------------------------*/
define buffer bfQuantidades for ttQuantidades.

/** Campo Consumo Real **/
assign fiAbastec = 0.

for each  bfQuantidades
    where bfQuantidades.log-abastec-prim no-lock:
    assign fiAbastec = fiAbastec + bfQuantidades.qtd.
end.
display fiAbastec with frame fPage0.

/** Consumo Padr∆o Equipamento **/
run piPadrao in this-procedure.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAnterior wWindow 
PROCEDURE piAnterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-doc AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER d-val-horim LIKE mab-abastec-lubrific.val-hodom-horim NO-UNDO.

ASSIGN fiDocAnterior = 0
       fiHodEqpto-2  = 0
       fiDatDocAnt   = ?. 

IF p-doc <> ? THEN DO:
    FOR FIRST mab-abastec-lubrific WHERE mab-abastec-lubrific.num-docto = p-doc NO-LOCK:
        /** Verifica se existem apontamentos anteriores para equipamento por data **/
        IF CAN-FIND(LAST mab-item-abastec
                    WHERE mab-item-abastec.ep-codigo = mab-abastec-lubrific.ep-codigo           
                    AND   mab-item-abastec.cod-eqpto = mab-abastec-lubrific.cod-eqpto           
                    AND   mab-item-abastec.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda
                    AND   mab-item-abastec.log-abastec-prim = YES NO-LOCK) THEN DO:
            
            FOR LAST mab-item-abastec
                WHERE mab-item-abastec.ep-codigo = mab-abastec-lubrific.ep-codigo           
                AND   mab-item-abastec.cod-eqpto = mab-abastec-lubrific.cod-eqpto           
                AND   mab-item-abastec.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda
                AND   mab-item-abastec.log-abastec-prim = YES NO-LOCK:
            END.

            FIND FIRST bfApont 
                WHERE bfApont.num-docto = mab-item-abastec.num-docto NO-LOCK NO-ERROR.
            IF AVAIL bfApont THEN
                ASSIGN fiDocAnterior   = bfApont.num-docto
                       fiDatDocAnt     = bfApont.dat-movto
                       fiHodEqpto-2    = bfApont.val-hodom-horim
                       fiHodSecEqpto-2 = bfApont.val-hodom-horim-sec
                       fiPercurso      = d-val-horim - bfApont.val-hodom-horim.
        END.
        ELSE DO:

            /*Colocado a validaá∆o abaixo caso o hodìmetro inicial seja maior que zero*/
            IF AVAILABLE mab-eqpto AND mab-eqpto.val-hodom-horim-inicial > 0 THEN
                 ASSIGN fiPercurso = mab-abastec-lubrific.val-hodom-horim - mab-eqpto.val-hodom-horim-inicial.
            ELSE ASSIGN fiPercurso = mab-abastec-lubrific.val-hodom-horim.

        END.
            
    END.
END.

DISP fiDocAnterior fiDatDocAnt fiHodEqpto-2 fiHodSecEqpto-2 WITH FRAME fpage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piApontamento wWindow 
PROCEDURE piApontamento :
/*------------------------------------------------------------------------------
  Purpose:     piApontamento
  Parameters:  <none>
  Notes:       Busca valores para campos em tela conforme registros de
               apontamentos
------------------------------------------------------------------------------*/
define buffer bf-mab-posto for mab-posto.

empty temp-table ttQuantidades.

assign fiHodEqpto    = 0
       fiHodSecEqpto = 0.

if num-results("brApont":U) > 0 then
    get current brApont.

if avail ttDados then do:
    for each  mab-item-abastec
        where mab-item-abastec.num-docto = ttDados.num-docto no-lock:
        for first bf-mab-posto
            where bf-mab-posto.cod-posto = mab-item-abastec.cod-posto no-lock:
            create ttQuantidades.
            assign ttQuantidades.it-codigo        = mab-item-abastec.it-codigo
                   ttQuantidades.qtd              = mab-item-abastec.val-quant
                   ttQuantidades.estab-posto      = if avail bf-mab-posto then bf-mab-posto.cod-estabel else ""
                   ttQuantidades.dep-posto        = if avail bf-mab-posto then bf-mab-posto.cod-depos else ""
                   ttQuantidades.log-abastec-prim = mab-item-abastec.log-abastec-prim
                   ttQuantidades.r-rowid          = rowid(mab-item-abastec)
                   ttQuantidades.cod-tip-mater    = mab-item-abastec.cod-tip-mater.
        end.
    end.

    for each  mab-item-lubrific
        where mab-item-lubrific.num-docto = ttDados.num-docto no-lock:
        for first bf-mab-posto
            where bf-mab-posto.cod-posto = ttDados.cod-posto no-lock:
            create ttQuantidades.
            assign ttQuantidades.it-codigo        = mab-item-lubrific.it-codigo
                   ttQuantidades.qtd              = mab-item-lubrific.val-quant
                   ttQuantidades.estab-posto      = if avail bf-mab-posto then bf-mab-posto.cod-estabel else ""
                   ttQuantidades.dep-posto        = if avail bf-mab-posto then bf-mab-posto.cod-depos else ""
                   ttQuantidades.log-abastec-prim = no
                   ttQuantidades.r-rowid          = rowid(mab-item-lubrific)
                   ttQuantidades.cod-tip-mater    = mab-item-lubrific.cod-tip-mater.
        end.
    end.

    assign fiHodEqpto    = ttDados.val-hodom-horim
           fiHodSecEqpto = ttDados.val-hodom-horim-sec
           rs-integr     = ttDados.idi-integr.
    /** Busca o Apontamento anterior **/
    run piAnterior in this-procedure (input ttDados.num-docto, INPUT ttDados.val-hodom-horim).
end.

display fiHodEqpto fiPercurso
        fiHodSecEqpto fiPercurso rs-integr with frame fPage0.

/** Campos em Tela **/
apply "LEAVE":U to fiAtivid in frame fPage0.
apply "LEAVE":U to fiModelo in frame fPage0.

/*--- Abre a query associada ao browse ---*/
{&OPEN-QUERY-brItem}
apply "VALUE-CHANGED":U to browse brItem.

/* Habilita / Desabilita Bot‰es em tela */
if avail ttSelecao then do:
    if ttSelecao.iVisualiza = 1 then do:
        assign btModifica:sensitive    in frame fPage0 = yes
               btPadrao:sensitive      in frame fPage0 = yes
               btUsuario:sensitive     in frame fPage0 = yes
               btAtualizacao:sensitive in frame fPage0 = no.
    end.
    else do:
        assign btModifica:sensitive    in frame fPage0 = no
               btPadrao:sensitive      in frame fPage0 = no
               btUsuario:sensitive     in frame fPage0 = no
               btAtualizacao:sensitive in frame fPage0 = yes.
    end.
end.

run piAbastecimento in this-procedure.

run piDicas in this-procedure.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaFichas wWindow 
PROCEDURE piAtualizaFichas :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaFichas
  Parameters:  <none>
  Notes:       Atualiza as fichas posteriores a ficha alterada
------------------------------------------------------------------------------*/
/** Cria Faixa de parÉmetros **/
RUN piParametro IN THIS-PROCEDURE (INPUT 1,
                                   INPUT ?).
/** Atualiza fichas **/
RUN abp/abapi001.p (INPUT  TABLE tt-param,
                    OUTPUT TABLE RowErrors,
                    OUTPUT TABLE ttDocLib).

/** Verifica erros **/
IF CAN-FIND(FIRST RowErrors) THEN DO:
    RUN piMostraErros IN THIS-PROCEDURE (2).
END.

/** Limpa temp-table **/
EMPTY TEMP-TABLE tt-param.

RETURN "OK":U.
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
DEFINE VARIABLE rRow AS ROWID  NO-UNDO.

empty temp-table ttDados.
{&OPEN-QUERY-brApont}

empty temp-table ttQuantidades.
{&OPEN-QUERY-brItem}

/** N∆o foram selecionadas as vis‰es **/
if not can-find(first ttVisao) then do:
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

/* Timer */
assign chTimer:enabled  = true
       chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.

/** Acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
{utp/ut-liter.i "Buscando Abastecimentos"}
RUN pi-inicializar IN hAcomp (trim(return-value)).

blk_principal:
DO ON STOP UNDO, RETURN "NOK":U:
    FOR EACH  mab-abastec-lubrific
        WHERE mab-abastec-lubrific.dat-movto >= ttSelecao.dat-ini
        AND   mab-abastec-lubrific.dat-movto <= ttSelecao.dat-fim
        AND   mab-abastec-lubrific.ep-codigo >= ttSelecao.ep-codigo-ini
        AND   mab-abastec-lubrific.ep-codigo <= ttSelecao.ep-codigo-fim
        AND   mab-abastec-lubrific.cod-eqpto >= ttSelecao.cod-eqpto-ini
        AND   mab-abastec-lubrific.cod-eqpto <= ttSelecao.cod-eqpto-fim
        AND   mab-abastec-lubrific.cod-posto >= ttSelecao.posto-ini
        AND   mab-abastec-lubrific.cod-posto <= ttSelecao.posto-fim no-lock by mab-abastec-lubrific.num-docto:

        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-abastec-lubrific.cod-unid-negoc >= ttSelecao.cod-unid-negoc-ini  AND 
                       mab-abastec-lubrific.cod-unid-negoc <= ttSelecao.cod-unid-negoc-fim) THEN NEXT.
            END.
        &ENDIF

        /** Validaá∆o de Ficha para visualizaá∆o
            ttSelecao.iVisualiza: Pode receber -> 1 - Problemas de Consistància
                                                  2 - Problemas de Integraá∆o **/
        /* Consistància */
        IF ttSelecao.iVisualiza = 1 THEN DO:
            IF mab-abastec-lubrific.idi-consist > 20 THEN NEXT.
        END.
        /* Integraá∆o */
        ELSE DO:
            IF mab-abastec-lubrific.idi-integr = 2 OR mab-abastec-lubrific.idi-consist < 20 THEN NEXT.
        END.

        /** Busca Equipamento **/
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.ep-codigo    = mab-abastec-lubrific.ep-codigo
            AND   mab-eqpto.cod-eqpto    = mab-abastec-lubrific.cod-eqpto
            AND   mab-eqpto.cod-estabel >= ttSelecao.estab-eqpto-ini
            AND   mab-eqpto.cod-estabel <= ttSelecao.estab-eqpto-fim
            AND   mab-eqpto.cd-tag      >= ttSelecao.tag-ini
            AND   mab-eqpto.cd-tag      <= ttSelecao.tag-fim
            AND   mab-eqpto.cc-codigo   >= ttSelecao.cc-codigo-ini
            AND   mab-eqpto.cc-codigo   <= ttSelecao.cc-codigo-fim
            AND   mab-eqpto.cod-model   >= ttSelecao.cod-model-ini
            AND   mab-eqpto.cod-model   <= ttSelecao.cod-model-fim NO-LOCK:
        END.

        IF NOT AVAIL mab-eqpto THEN NEXT.

        /** Validaá∆o de Tipo de Equipamento **/
        IF mab-eqpto.idi-tip-eqpto = 1 and NOT(ttSelecao.lMotorizados)  THEN NEXT. /** Equipamento Motorizado **/
        IF mab-eqpto.idi-tip-eqpto = 2 and NOT(ttSelecao.lNMotorizados) THEN NEXT. /** Equipamento N∆o Motorizado **/
        /** Validaá∆o Propriet†rio **/
        IF mab-eqpto.idi-tip-propriet = 1 and not(ttSelecao.lProprios)  THEN NEXT. /** Equipamento Pr¢prio **/
        IF mab-eqpto.idi-tip-propriet = 2 and not(ttSelecao.lTerceiros) THEN NEXT. /** Equipamento de Terceiro**/
        /** Validaá∆o Estado Equipamento **/
        IF mab-eqpto.dat-situacao <> ? AND NOT(ttSelecao.lInativos) THEN NEXT.
        IF mab-eqpto.dat-situacao =  ? AND NOT(ttSelecao.lAtivos)   THEN NEXT.

        /** Busca Posto **/
        FOR FIRST mab-posto
            WHERE mab-posto.cod-posto      = mab-abastec-lubrific.cod-posto
            AND   mab-posto.cod-estabel   >= ttSelecao.estab-posto-ini
            AND   mab-posto.cod-estabel   <= ttSelecao.estab-posto-fim
            AND   mab-posto.cod-depos     >= ttSelecao.deposito-ini
            AND   mab-posto.cod-depos     <= ttSelecao.deposito-fim NO-LOCK:
            FOR FIRST mab-bomba           
                WHERE mab-bomba.cod-posto  = mab-posto.cod-posto
                AND   mab-bomba.cod-bomba >= ttSelecao.bomba-ini
                AND   mab-bomba.cod-bomba <= ttSelecao.bomba-fim NO-LOCK:
            END.
        END.

        /* N∆o encontrou o posto */
        IF NOT AVAIL mab-posto THEN NEXT.

        /*** Inicio Projeto 118 - Seguranáa por Estabelecimento ***/
        IF  l-seg-ativa-modulo THEN DO:
            IF  NOT CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = mab-eqpto.cod-estabel) THEN
                NEXT.
        END.
        /*** Final Projeto 118 - Seguranáa por Estabelecimento ***/


        {utp/ut-liter.i "Documento"}
        run pi-acompanhar in hAcomp (input return-value + ": " + string(mab-abastec-lubrific.num-docto)).

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
        END.
    END.
END.

IF VALID-HANDLE(hAcomp) THEN
    RUN pi-finalizar IN hAcomp.

/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaVisao wWindow 
PROCEDURE piAtualizaVisao :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaVisao
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
define input parameter pConsist as integer no-undo.

define buffer bf-mab-abastec-lubrific for mab-abastec-lubrific.
define buffer bf-ttDados for ttDados.
&IF "{&mguni_version}" >= "2.071" &THEN
define variable i-emp      LIKE empresa.ep-codigo no-undo.
&ELSE
define variable i-emp      as int  no-undo.
&ENDIF
define variable c-eqpto    as char no-undo.
define variable c-dimensao as char no-undo.

for each  bf-ttDados
    where bf-ttDados.ep-codigo = ttDados.ep-codigo
    and   bf-ttDados.cod-eqpto = ttDados.cod-eqpto 
    and   bf-ttDados.i-filho   = 2 exclusive-lock:
    assign i-emp               = ttDados.ep-codigo 
           c-eqpto             = ttDados.cod-eqpto
           c-dimensao          = ttDados.cod-dimens-pai.
    for first bf-mab-abastec-lubrific
        where bf-mab-abastec-lubrific.num-docto = bf-ttDados.num-docto no-lock:
        assign bf-ttDados.idi-consist           = bf-mab-abastec-lubrific.idi-consist
               bf-ttDados.idi-integr            = bf-mab-abastec-lubrific.idi-integr.
    end.
end.

/** pConsist =                                                  **
 ** 1 - Libera Padrao / Usuario (Fichas N∆o Consistidas)        **
 ** 2 - Atualizaá∆o Online      (Fichas c/ Problema em Estoque) **/

if pConsist = 1 then do:
    for each  bf-ttDados
        where bf-ttDados.ep-codigo   = ttDados.ep-codigo
        and   bf-ttDados.cod-eqpto   = ttDados.cod-eqpto 
        and   bf-ttDados.i-filho     = 2
        and   bf-ttDados.idi-consist > 20 no-lock:
        delete bf-ttDados.
    end.
    /** Se n∆o existir mais registros, Elimina registro Pai **/
    if not can-find(first bf-ttDados
                    where bf-ttDados.ep-codigo   = i-emp
                    and   bf-ttDados.cod-eqpto   = c-eqpto
                    and   bf-ttDados.i-filho     = 2
                    and   bf-ttDados.idi-consist < 20 no-lock) then do:
        run piEliminaPai in this-procedure (input c-dimensao).
    end.
end.
else do:
    for each  bf-ttDados
        where bf-ttDados.ep-codigo   = ttDados.ep-codigo
        and   bf-ttDados.cod-eqpto   = ttDados.cod-eqpto 
        and   bf-ttDados.i-filho     = 2
        and   bf-ttDados.idi-consist < 20 no-lock:
        delete bf-ttDados.
    end.
    if not can-find(first bf-ttDados
                    where bf-ttDados.ep-codigo   = i-emp
                    and   bf-ttDados.cod-eqpto   = c-eqpto
                    and   bf-ttDados.i-filho     = 2
                    and   bf-ttDados.idi-consist > 20 no-lock) then do:
        run piEliminaPai in this-procedure (input c-dimensao).
    end.
end.

run criaTreeView   in this-procedure.
run atualizaBrowse in this-procedure.

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
     where ttDados.cod-dimensao = (cCodPai + "#" + vCodigo)
     and   ttDados.sequencia    = ttVisao.sequencia exclusive-lock no-error.
if not avail ttDados then do:
    /** Se n∆o estiver criado, cria registro **/
    create ttDados.
    assign ttDados.cod-dimensao         = (cCodPai + "#" + vCodigo)       /** C¢digo encadeado para tree-view **/
           ttDados.cod-oficial          = vCodigo                         /** C¢digo Original do registro **/
           ttDados.desc-dimensao        = vDescricao                      /** Descriá∆o do c¢digo **/
           ttDados.sequencia            = ttVisao.sequencia               /** Sequància dos dados **/
           ttDados.p-image              = iImage                          /** N£mero da imagem do registro **/
           ttDados.r-rowid              = rowid(mab-abastec-lubrific)     /** Rowid do registro para consultas futuras **/
           ttDados.cod-dimens-pai       = cCodPai                         /** C¢digo do pai do registro **/
           ttDados.ep-codigo            = mab-abastec-lubrific.ep-codigo
           ttDados.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
           ttDados.dat-movto            = mab-abastec-lubrific.dat-movto
           ttDados.hra-inicial          = mab-abastec-lubrific.hra-inicial
           ttDados.num-docto            = mab-abastec-lubrific.num-docto
           ttDados.idi-consist          = mab-abastec-lubrific.idi-consist
           ttDados.cod-ativid           = mab-abastec-lubrific.cod-ativid
           ttDados.val-hodom-horim      = mab-abastec-lubrific.val-hodom-horim
           ttDados.val-hodom-horim-sec  = mab-abastec-lubrific.val-hodom-horim-sec
           ttDados.val-km-percur        = mab-abastec-lubrific.val-km-percur
           ttDados.idi-integr           = mab-abastec-lubrific.idi-integr
           ttDados.cod-estabel-eqpto    = mab-eqpto.cod-estabel
           ttDados.cd-tag-eqpto         = mab-eqpto.cd-tag
           ttDados.cc-codigo-eqpto      = mab-eqpto.cc-codigo
           ttDados.mes-ano              = string(string(month(mab-abastec-lubrific.dat-movto),"99") + "/" + string(year(mab-abastec-lubrific.dat-movto),"9999"))
           ttDados.cod-estabel-posto    = mab-posto.cod-estabel
           ttDados.cod-depos-posto      = mab-posto.cod-pos
           ttDados.cod-posto            = mab-posto.cod-posto
           ttDados.cod-bomba            = if avail mab-bomba then mab-bomba.cod-bomba else "0"
           ttDados.cod-model-eqpto      = mab-eqpto.cod-model
           ttDados.i-filho              = 1
    &IF DEFINED(bf_mnt_ems206b) &THEN
           ttDados.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc
    &ENDIF
           .
end.

assign cCodPai = ttDados.cod-dimensao.

/* Cria um nivel a mais quando for a £ltima dimens∆o */
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
/** Busca registro **/
find first ttDados 
     where ttDados.cod-dimensao  = trim(cCodPai + "#" + string(mab-abastec-lubrific.num-docto) + vCodigo)
     and   ttDados.sequencia     = iVisao + 1 exclusive-lock no-error.
/** Se n∆o estiver criado, cria registro **/
if not avail ttDados then do:
   create ttDados.
   buffer-copy mab-abastec-lubrific to ttDados
   assign ttDados.cod-dimensao         = trim(cCodPai + "#" + string(mab-abastec-lubrific.num-docto) + vCodigo) /** C¢digo encadeado para tree-view **/
          ttDados.sequencia            = iVisao + 1                     /** Sequància dos dados **/
          ttDados.cod-oficial          = ""                             /** C¢digo Original do registro **/
          ttDados.desc-dimensao        = vDescricao                     /** Descriá∆o do c¢digo **/
          ttDados.p-image              = iImage                         /** N£mero da imagem do registro **/
          ttDados.r-rowid              = rowid(mab-abastec-lubrific)    /** Rowid do registro para consultas futuras **/
          ttDados.cod-dimens-pai       = cCodPai                        /** C¢digo do pai do registro **/
          ttDados.ep-codigo            = mab-abastec-lubrific.ep-codigo
          ttDados.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
          ttDados.dat-movto            = mab-abastec-lubrific.dat-movto
          ttDados.hra-inicial          = mab-abastec-lubrific.hra-inicial
          ttDados.num-docto            = mab-abastec-lubrific.num-docto
          ttDados.idi-consist          = mab-abastec-lubrific.idi-consist
          ttDados.cod-ativid           = mab-abastec-lubrific.cod-ativid
          ttDados.val-hodom-horim      = mab-abastec-lubrific.val-hodom-horim
          ttDados.val-hodom-horim-sec  = mab-abastec-lubrific.val-hodom-horim-sec
          ttDados.val-km-percur        = mab-abastec-lubrific.val-km-percur
          ttDados.idi-integr           = mab-abastec-lubrific.idi-integr
          ttDados.cod-estabel-eqpto    = mab-eqpto.cod-estabel
          ttDados.cd-tag-eqpto         = mab-eqpto.cd-tag
          ttDados.cc-codigo-eqpto      = mab-eqpto.cc-codigo
          ttDados.mes-ano              = string(string(month(mab-abastec-lubrific.dat-movto),"99") + "/" + string(year(mab-abastec-lubrific.dat-movto),"9999"))
          ttDados.cod-estabel-posto    = mab-posto.cod-estabel
          ttDados.cod-depos-posto      = mab-posto.cod-depos
          ttDados.cod-posto            = mab-posto.cod-posto
          ttDados.cod-bomba            = if avail mab-bomba then mab-bomba.cod-bomba else "0"
          ttDados.cod-model-eqpto      = mab-eqpto.cod-model
          ttDados.i-filho              = 2
    &IF DEFINED(bf_mnt_ems206b) &THEN
          ttDados.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc
    &ENDIF
          .
end.

assign cCodPai = ttDados.cod-dimensao.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsultaAbastecimento wWindow 
PROCEDURE piConsultaAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     piConsultaAbastecimento
  Parameters:  <none>
  Notes:       Consulta o Abastecimento selecionado no browse.
------------------------------------------------------------------------------*/
define variable h-program as handle no-undo.

assign {&window-name}:sensitive = no.

if avail ttDados then do:
    get current brApont.
    for first mab-item-abastec 
        where mab-item-abastec.num-docto = ttDados.num-docto 
        and   mab-item-abastec.cod-eqpto = ttDados.cod-eqpto
        and   mab-item-abastec.ep-codigo = ttDados.ep-codigo no-lock:
        run abp/ab0306.w persistent set h-program.
        /** Validaá∆o do Handle **/
        run initializeInterface in h-program.
        if return-value = "OK":U then
            /*:T Reposiciona registro com base em um rowid */
            run repositionRecord in h-program (input rowid(mab-item-abastec)).
        wait-for "close":U of h-Program.
    end.
    if not avail mab-item-abastec then do:
        run abp/ab0306.w.
    end.
end.

assign {&window-name}:sensitive = yes.

for first ttSelecao no-lock:
    assign chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.
end.

if valid-handle (h-program) then
    delete procedure h-program.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsultaApontamento wWindow 
PROCEDURE piConsultaApontamento :
/*------------------------------------------------------------------------------
  Purpose:     piConsultaApontamento
  Parameters:  <none>
  Notes:       Consulta o Apontamento anterior ao selecionado no browse.
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-program AS HANDLE NO-UNDO.

ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

FOR FIRST mab-abastec-lubrific 
    WHERE mab-abastec-lubrific.num-docto = INPUT FRAME fpage0 fiDocAnterior NO-LOCK:
      RUN abp/ab0611.w PERSISTENT SET h-program.
      /** Validaá∆o do Handle **/
      RUN initializeInterface IN h-program.
      IF RETURN-VALUE = "OK":U THEN
       /*:T Reposiciona registro com base em um rowid */
          RUN repositionRecord IN h-program (INPUT ROWID(mab-abastec-lubrific)).
      WAIT-FOR "close":U OF h-Program.
END.

IF NOT AVAIL mab-abastec-lubrific THEN DO:
    RUN abp/ab0611.w PERSISTENT SET h-program.
    /** Validaá∆o do Handle **/
    RUN initializeInterface IN h-program.
    WAIT-FOR "close":U OF h-Program.
END.

ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

IF VALID-handle (h-program) THEN
    DELETE PROCEDURE h-program.

RETURN "OK":U.
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
def input param pNumDocto like  mab-abastec-lubrific.num-docto no-undo.
define variable rRow      as rowid                             no-undo.

empty temp-table ttDados.
{&OPEN-QUERY-brApont}

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

assign chTimer:enabled  = true
       chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.

/** Acompanhamento **/
run utp/ut-acomp.p persistent set hAcomp.
{utp/ut-liter.i "Buscando Abastecimentos"}
run pi-inicializar in hAcomp (trim(return-value)).

/** Busca as informaá‰es conforme parametrizaá∆o **/
blk_principal:
do on stop undo, return "NOK":U:
    blk_abastec:
    for each  mab-abastec-lubrific
        where mab-abastec-lubrific.num-docto = pNumDocto no-lock:

        {utp/ut-liter.i "Documento"}
        run pi-acompanhar in hAcomp (input return-value + ": " + string(mab-abastec-lubrific.num-docto)).

        /** Busca Equipamento **/
        for first mab-eqpto
            where mab-eqpto.ep-codigo    = mab-abastec-lubrific.ep-codigo
            and   mab-eqpto.cod-eqpto    = mab-abastec-lubrific.cod-eqpto no-lock:
        end.
        if not avail mab-eqpto then next.

        /** Busca Posto **/
        for first mab-posto
            where mab-posto.cod-posto    = mab-abastec-lubrific.cod-posto no-lock:
        end.
        /* N∆o encontrou o posto */
        if not avail mab-posto then next.

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
    end.
end.

if valid-handle(hAcomp) then
    run pi-finalizar in hAcomp.

/** Mostra o tree-view em tela **/
run criaTreeView in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTT-param-pnp wWindow 
PROCEDURE piCriaTT-param-pnp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF CAN-FIND (FIRST ttDocLib) THEN DO:

    FIND FIRST mab-abastec-lubrific
         WHERE mab-abastec-lubrific.num-docto = ttDocLib.num-docto NO-LOCK.
    IF AVAIL mab-abastec-lubrific THEN DO:
        ASSIGN cEmpCod    = mab-abastec-lubrific.ep-codigo
               cCodEqpto  = mab-abastec-lubrific.cod-eqpto
               dtDatMovto = mab-abastec-lubrific.dat-movto.
        
        CREATE tt-param-pnp.
        ASSIGN tt-param-pnp.usuario         = c-seg-usuario        
               tt-param-pnp.destino         = 1                    
               tt-param-pnp.arquivo         = ""                   
               tt-param-pnp.data-exec       = today                
               tt-param-pnp.hora-exec       = time                 
               tt-param-pnp.iConsiste       = 2                    
               tt-param-pnp.descConsiste    = "Todos":U            
               tt-param-pnp.iEmpIni         = cEmpCod
               tt-param-pnp.iEmpFim         = cEmpCod
               tt-param-pnp.cEqptoIni       = cCodEqpto
               tt-param-pnp.cEqptoFim       = cCodEqpto
               tt-param-pnp.num-docto       = ttDocLib.num-docto
               tt-param-pnp.lFicha          = yes                  
               tt-param-pnp.tipo-liberacao  = 1 /** Normal **/     
               tt-param-pnp.cCCini          = ""                   
               tt-param-pnp.cCCfim          = "ZZZZZZZZZZZZZZZZZZZZ"           
               tt-param-pnp.cPostoIni       = ""                   
               tt-param-pnp.cPostoFim       = "ZZZZZZZZ".


        for FIRST mab-param
            where mab-param.cdn-param = 53 no-lock:
            ASSIGN c-valor-param53 = mab-param.des-valor.
        END.
            
        for last  mab-histor-ativid fields(cod-estab cd-tag)
            where mab-histor-ativid.ep-codigo     = cEmpCod
            and   mab-histor-ativid.cod-eqpto     = cCodEqpto
            and   mab-histor-ativid.dat-cadastro <= dtDatMovto  no-lock:
            assign tt-param-pnp.cEstabIni       = mab-histor-ativid.cod-estab
                   tt-param-pnp.cEstabFim       = mab-histor-ativid.cod-estab
                   tt-param-pnp.cTagIni         = mab-histor-ativid.cd-tag
                   tt-param-pnp.cTagFim         = mab-histor-ativid.cd-tag.
        end.
        IF NOT AVAIL mab-histor-ativid OR c-valor-param53 = "1":U THEN DO:
            FOR LAST   mab-histor-ativid
                WHERE  mab-histor-ativid.ep-codigo = cEmpCod
                AND    mab-histor-ativid.cod-eqpto = cCodEqpto NO-LOCK:
                assign tt-param-pnp.cEstabIni       = mab-histor-ativid.cod-estab
                       tt-param-pnp.cEstabFim       = mab-histor-ativid.cod-estab
                       tt-param-pnp.cTagIni         = mab-histor-ativid.cd-tag
                       tt-param-pnp.cTagFim         = mab-histor-ativid.cd-tag.
            END.
        END.
    END.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDicas wWindow 
PROCEDURE piDicas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable cDica as character no-undo.
assign cDica = "".

if num-results("brApont":U) > 0 then
    get current brApont.

if avail ttDados then do:
    case ttDados.idi-consist:
        when 1 then do:
            {utp/ut-liter.i "- Verificar o parÉmetro 11 do programa AB0101 se este est† marcado para consistància online;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Esta ficha pode ter sido criada pelo AB0302 e n∆o ter sido selecionado o bot∆o de consistància online."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 2 then do:
            {utp/ut-liter.i "- O equipamento percorreu menos com muito combust°vel;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Validar se os consumos padr‰es por atividade (AB0104) ou do equipamento AB0138 (p†gina 1) est∆o corretos;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Validar se o parÉmetro de aceitaá∆o 14 do AB0101, est† com percentual correto;"}
            assign cDica = cDica + chr(10) + return-value.     
            {utp/ut-liter.i "- Verificar se a quantidade abastecida na ficha foi digitada corretamente;"}
            assign cDica = cDica + chr(10) + return-value.  
            {utp/ut-liter.i "- Verificar se o contador informado no apontamento est† correto;"}
            assign cDica = cDica + chr(10) + return-value.  
            {utp/ut-liter.i "- Pode-se utilizar a liberaá∆o pelo usu†rio (recomendada) ou a liberaá∆o pelo padr∆o. Lembrando que, quando for realizada a liberaá∆o pelo padr∆o est† sendo informado que para esta ficha o equipamento percorreu somente o percurso padr∆o poss°vel para este e quando for utilizada a liberaá∆o pelo usu†rio est† aceitando-se valor informado na ficha."}
            assign cDica = cDica + chr(10) + return-value.  
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 3 then do:
            {utp/ut-liter.i "- O equipamento percorreu mais com pouco combust°vel;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Validar se os consumos padr‰es por atividade (AB0104) ou do equipamento AB0138 (p†gina 1) est∆o corretos;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Validar se o parÉmetro de aceitaá∆o 14 do AB0101, est† com percentual correto;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Verificar se a quantidade abastecida na ficha foi digitada corretamente;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Verificar se o contador informado no apontamento est† correto."}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Pode-se utilizar a liberaá∆o pelo usu†rio (recomendada) ou a liberaá∆o pelo padr∆o. Lembrando que, quando for realizada a liberaá∆o pelo padr∆o est† sendo informado que para esta ficha o equipamento percorreu somente o percurso padr∆o poss°vel para este e quando for utilizada a liberaá∆o pelo usu†rio est† aceitando-se o valor informado na ficha;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Verificar a poss°vel falta de uma ficha anterior;"}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.              
        end.
        when 4 then do:
            {utp/ut-liter.i "- Em relaá∆o a £ltima ficha o contador da ficha atual est† com o mesmo valor. Pode indicar erro na digitaá∆o ou realmente indicar uma poss°vel quebra no contador;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Alterar a ficha (AB0302) caso seja digitaá∆o incorreta;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Utilizar a liberaá∆o por usu†rio para informar o percurso desta ficha manualmente caso seja uma quebra do contador;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Caso n∆o se saiba o percurso, liberar pelo padr∆o para colocar o padr∆o poss°vel a percorrer com a quantidade abastecida, conforme o consumo."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 5 then do:
            {utp/ut-liter.i "- Indica que o contador da ficha atual est† menor que o contador da ultima ficha deste equipamento;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Alterar a ficha (AB0302) caso seja digitaá∆o incorreta;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Utilizar a liberaá∆o por usu†rio para informar o percurso desta ficha manualmente caso seja uma quebra do contador;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Caso n∆o se saiba o percurso, liberar pelo padr∆o para colocar o padr∆o poss°vel a percorrer com a quantidade abastecida, conforme o consumo."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 7 then do:
            {utp/ut-liter.i "- Em relaá∆o a £ltima ficha o contador da ficha atual est† com o mesmo valor. Pode indicar erro na digitaá∆o ou realmente indicar uma poss°vel quebra no contador;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Alterar a ficha (AB0302) caso seja digitaá∆o incorreta;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Utilizar a liberaá∆o por usu†rio para informar o percurso desta ficha manualmente caso seja uma quebra do contador;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Caso n∆o se saiba o percurso, liberar pelo padr∆o para colocar o padr∆o poss°vel a percorrer com a quantidade abastecida, conforme o consumo."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 8 then do:
            {utp/ut-liter.i "- Indica que o contador da ficha atual est† menor que o contador da ultima ficha deste equipamento;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Alterar a ficha (AB0302) caso seja digitaá∆o incorreta;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Utilizar a liberaá∆o por usu†rio para informar o percurso desta ficha manualmente caso seja uma quebra do contador;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Caso n∆o se saiba o percurso, liberar pelo padr∆o para colocar o padr∆o poss°vel a percorrer com a quantidade abastecida, conforme o consumo."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        when 9 then do:
            {utp/ut-liter.i "- Verificar por data e hora a existància de ficha anterior com erro para este equipamento;"}
            assign cDica = return-value.
            {utp/ut-liter.i "- Utilizar o bot∆o detalhe (AB0611) para verificar o apontamento anterior incorreto;"}
            assign cDica = cDica + chr(10) + return-value.
            {utp/ut-liter.i "- Caso o apontamento anterior n∆o apareáa na consulta, verificar os parÉmetros de seleá∆o da consulta."}
            assign cDica = cDica + chr(10) + return-value.
            assign EDITOR-1:screen-value in frame fPage0 = cDica.
        end.
        otherwise do:
            assign EDITOR-1:screen-value in frame fPage0 = "".
        end.
    end case.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaPai wWindow 
PROCEDURE piEliminaPai :
/*------------------------------------------------------------------------------
  Purpose:     piEliminaPai
  Parameters:  <none>
  Notes:       Busca dimens‰es Pai que n∆o contem filhos e elimina-as.
------------------------------------------------------------------------------*/
    define input param pDimensao as char no-undo.
    define variable c-dimensao   as char no-undo.

    for first ttDados
        where ttDados.cod-dimensao = pDimensao no-lock:
        assign c-dimensao = ttDados.cod-dimens-pai.
        delete ttDados.
    end.
    if c-dimensao <> "":U and not can-find(first ttDados
                                           where ttDados.cod-dimens-pai = c-dimensao no-lock) then do:
        run piEliminaPai in this-procedure (input c-dimensao).
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEquipamento wWindow 
PROCEDURE piEquipamento :
/*------------------------------------------------------------------------------
  Purpose:     piEquipamento
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param pProgram    as character no-undo.
define variable    r-mab-eqpto as rowid     no-undo.
define variable    hProgram    as handle    no-undo.

assign r-mab-eqpto = ?.
if avail ttDados then do:
    get current brApont no-lock.
    for first mab-eqpto 
        where mab-eqpto.ep-codigo = ttDados.ep-codigo
        and mab-eqpto.cod-eqpto = ttDados.cod-eqpto no-lock:
        assign r-mab-eqpto =  rowid(mab-eqpto).
    end.
end.
assign {&window-name}:sensitive = no.

/** Chama programa de hist¢rico da remonta **/
    /* abp/ab0138.w abp/ab0602.w */
run value(pProgram) persistent set hProgram.

/** Validaá∆o do Handle **/
if valid-handle(hProgram) and
    hProgram:type = "PROCEDURE":U and
    hProgram:file-name = pProgram then do:
    /*--- Inicializa programa de consulta ---*/
    run initializeInterface IN hProgram.
    /*:T Reposiciona registro com base em um rowid */
    if r-mab-eqpto <> ? then
        run repositionRecord in hProgram (input r-mab-eqpto).
    wait-for "close":U of hProgram.
end.

for first ttSelecao no-lock:
    assign chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.
end.

assign {&window-name}:sensitive = yes.
if valid-handle(hprogram) then
    delete procedure hprogram.

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
run abp/ab0307f.w (output i-impressao,
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
    do i-col = 1 TO brApont:num-columns in frame fPage0:
        hHandle = brApont:get-browse-column(i-col).
        /** Guarda t°tulos das colunas **/
        assign c-colunas = c-colunas + hHandle:name.
        if i-col <> brApont:num-columns  then
            assign c-colunas = c-colunas + ",".
    end.

    /** Somente vis∆o selecionada **/
    if i-impressao = 1 then do:
        /** Guarda rowid do tree-view **/
        ASSIGN  r-Rowid =   TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
        /** Busca Registro **/
        for first bfttDados
            where rowid(bfttDados) = r-rowid no-lock:
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
    run abp/ab9003.p(input "ab0307":U,
                     input table tt-dados-ex).
    if return-value = "NOK":U then .

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

define variable cPai as character no-undo.

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

       /** In°cio contador de colunas do Browse**/
       do i-col = 2 to brApont:num-columns in frame fPage0:
           /** Contador para linhas **/
           if i-lin = i-lin2 then do:
               create tt-dados-ex.
               assign tt-dados-ex.celula-coluna        = i-col - 1
                      tt-dados-ex.celula-linha         = i-lin
                      tt-dados-ex.celula-cor-interior  = 10
                      tt-dados-ex.celula-fonte-cor     = 19
                      tt-dados-ex.celula-fonte-negrito = yes.
               assign tt-dados-ex.celula-valor         = if i-col = 1 
                                                         then fnLabels(ttDados.p-image)
                                                         else fnBrowse(entry(i-col,c-colunas),1).
           end.
           /** Impress∆o da primeira linha de dados **/
           create tt-dados-ex.
           assign tt-dados-ex.celula-coluna = i-col - 1
                  tt-dados-ex.celula-linha  = i-lin + 1.
           assign tt-dados-ex.celula-valor  = fnBrowse(entry(i-col,c-colunas),2).
           /** Para c¢digo, coloca formato TEXTO **/
           if entry(i-col,c-colunas) = "cod-oficial":U then do:
               assign tt-dados-ex.celula-formato = "@":U.
           end.
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
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

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
if avail bfttDados2 and bfttDados2.sequencia <= iVisao then do:
    /** Cria os dados na temp-table do excel **/
   {abp/ab0307.i2 bfttDados2.p-image}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHistorico wWindow 
PROCEDURE piHistorico :
/*------------------------------------------------------------------------------
  Purpose:     piHistorico
  Parameters:  <none>
  Notes:       Mostra Hist¢rico do consumo do equipamento
------------------------------------------------------------------------------*/
DEFINE VARIABLE r-mab-eqpto AS ROWID   NO-UNDO.
DEFINE VARIABLE hProgram    AS HANDLE  NO-UNDO.
ASSIGN r-mab-eqpto = ?.
IF AVAIL ttDados THEN DO:
    GET CURRENT brApont NO-LOCK.
    FOR first mab-eqpto 
        where mab-eqpto.ep-codigo = ttDados.ep-codigo
        AND mab-eqpto.cod-eqpto = ttDados.cod-eqpto NO-LOCK:
        ASSIGN r-mab-eqpto =  rowid(mab-eqpto).
    END.
END.
assign {&WINDOW-NAME}:sensitive = no.

/** Chama programa de hist¢rico da remonta **/
RUN abp/ab0618.w PERSISTENT SET hProgram.

/** Validaá∆o do Handle **/
IF VALID-HANDLE(hProgram) AND
    hProgram:Type = "PROCEDURE":U AND
    hProgram:FILE-NAME = "abp/ab0618.w":U THEN do:
    /*--- Inicializa programa de consulta ---*/
    RUN initializeInterface IN hProgram.
    /*:T Reposiciona registro com base em um rowid */
    IF r-mab-eqpto <> ? THEN
        RUN repositionRecord IN hProgram (INPUT r-mab-eqpto).
    WAIT-FOR "close":U oF hProgram.
end.

for first ttSelecao no-lock:
    assign chTimer:Interval = (ttSelecao.iAtualiza * 60) * 1000.
end.

assign {&WINDOW-NAME}:sensitive = yes.
IF valid-handle(hprogram) THEN
    DELETE PROCEDURE hprogram.

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
ASSIGN  rRowid =   TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
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
    run abp/ab0307d.w (input table bfttDados, /*ttDados*/
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
{utp/ut-liter.i "Atividade" * }
assign fiTexto-1 = trim(return-value).
{utp/ut-liter.i "Modelo"}
assign fiTexto-2 = trim(return-value).
{utp/ut-liter.i "Real" * }
assign fiTexto-3 = trim(return-value).
{utp/ut-liter.i "M†ximo" * }
assign fiTexto-4 = trim(return-value).
{utp/ut-liter.i "M°nimo" * }
assign fiTexto-5 = trim(return-value).
{utp/ut-liter.i "Padr∆o Equipamento" * }
assign fiTexto-6 = trim(return-value).
{utp/ut-liter.i "Padr∆o Modelo/Ativ" * }
assign fiTexto-7 = trim(return-value).
{utp/ut-liter.i "Contador" * }
assign fiTexto-8 = trim(return-value).
{utp/ut-liter.i "Contador Sec"  * }
assign fiTexto-9 = trim(return-value).
{utp/ut-liter.i "Qtde Abastecida"  * }
assign fiTexto-10 = trim(return-value).
{utp/ut-liter.i "Percurso"  * }
assign fiTexto-11 = trim(return-value).
{utp/ut-liter.i "Documento"  * }
assign fiTexto-12 = trim(return-value).
{utp/ut-liter.i "Data"  * }
assign fiTexto-13 = trim(return-value).
{utp/ut-liter.i "Contador"  * }
assign fiTexto-14 = trim(return-value).
{utp/ut-liter.i "Contador Sec"  * }
assign fiTexto-15 = trim(return-value).
{utp/ut-liter.i "Consumo"  * }
assign fiTexto-16 = trim(return-value).
{utp/ut-liter.i "Valores"  * }
assign fiTexto-17 = trim(return-value).
disp fiTexto-1 
     fiTexto-2 
     fiTexto-3 
     fiTexto-4 
     fiTexto-5 
     fiTexto-6 
     fiTexto-7 
     fiTexto-8 
     fiTexto-9  
     fiTexto-10
     fiTexto-11   
     fiTexto-12   
     fiTexto-13   
     fiTexto-14   
     fiTexto-15  
     fiTexto-16
     fiTexto-17
    with frame fpage0.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibera wWindow 
PROCEDURE piLibera :
/*------------------------------------------------------------------------------
  Purpose:     piLibera
  Parameters:  pLibera = Tipo Liberaá∆o  
                         -> 2 = Padr∆o
                         -> 3 = Usu†rio 
  Notes:       Libera o apontamento
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pLibera AS INTEGER   NO-UNDO.
DEFINE VARIABLE        cEvento AS CHARACTER NO-UNDO.
DEFINE VARIABLE        iDoc    AS INTEGER   NO-UNDO.
DEFINE variable        lOk     AS LOGICAL    NO-UNDO.

/**---------------------------------- C†lculo -------------------------------------**/
RUN piParametro IN THIS-PROCEDURE (INPUT pLibera,
                                   INPUT ttDados.num-docto).
/** Calcula Temp-Table de Documentos a serem liberados **/
RUN abp/abapi001.p (INPUT  TABLE tt-param,
                    OUTPUT TABLE RowErrors,
                    OUTPUT TABLE ttDocLib).

/** Erros da API de c†lculo **/
IF CAN-FIND(FIRST RowErrors) THEN DO:
    RUN piMostraErros IN THIS-PROCEDURE (2).
    RETURN "NOK":U.
END.

/**--------------------------------- Liberaá∆o ------------------------------------**/
/** Roda API liberaá∆o persistente **/
RUN abp/abapi002.p PERSISTENT SET hAbapi002.
/** Inicializaá∆o de BOs **/
RUN initializeHandle IN hAbapi002.

FOR FIRST ttDocLib
    WHERE ttDocLib.num-docto = ttDados.num-docto NO-LOCK:
    IF pLibera = 2 THEN DO:
        /** Verifica Quantidade Abastecida **/
        RUN piQuantidade IN hAbapi002 (INPUT ttDados.num-docto,
                                       INPUT ttDocLib.tp-consumo,
                                       INPUT INPUT FRAME fPage0 fiAbastec,
                                       INPUT ttDocLib.consumo-padrao).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN piMostraErros IN THIS-PROCEDURE (3).
            RUN finalizaHandle IN hAbapi002.
            IF VALID-HANDLE(hAbapi002) THEN 
                DELETE PROCEDURE hAbapi002.
            RETURN "NOK":U.
        END.

        /** Pergunta para liberar pelo padr∆o **/
        {utp/ut-liter.i "pelo consumo padr∆o"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 28489,
                           INPUT STRING(ttDados.num-docto) + '~~' +
                                 fiAbastec:SCREEN-VALUE IN FRAME fPage0 + '~~' +
                                 RETURN-VALUE).
        IF RETURN-VALUE = "NO":U THEN DO:
            RUN finalizaHandle IN hAbapi002.
            IF VALID-HANDLE(hAbapi002) THEN 
                DELETE PROCEDURE hAbapi002.
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        /** Programa Atualizaá∆o **/
        RUN abp/ab0307h.w (input  ttDados.r-rowid,
                           input  ttDocLib.consumo-padrao,
                           input  ttDocLib.consumo-padrao-sec,
                           input  ttDocLib.qtd-abast,
                           input  input frame fPage0 fiUN1,
                           input  input frame fPage0 fiUNSec,
                           input  iTpConsumo,
                           input  iTpConsumoSec,
                           output iUsoReal,
                           output iUsoRealSec,
                           output lOK).

        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        IF NOT(lOK) THEN DO:
            RUN finalizaHandle IN hAbapi002.
            IF VALID-HANDLE(hAbapi002) THEN 
                DELETE PROCEDURE hAbapi002.
            RETURN "NOK":U.
        END.
    END. /** else **/
END. /** for **/

/** Guarda tt na API **/
RUN piRecebeTT IN hAbapi002 (INPUT TABLE ttDocLib).
/** Guarda tt para pneus na API **/
RUN piCriaTT-param-pnp IN THIS-PROCEDURE.
/**tt de parametros para pneus**/
RUN piRecebeTTParam IN hAbapi002 (INPUT TABLE tt-param-pnp).
IF RETURN-VALUE = "NOK":U THEN DO:
    RUN piMostraErros IN THIS-PROCEDURE (3).
    RUN finalizaHandle IN hAbapi002.                           
    IF VALID-HANDLE(hAbapi002) THEN 
        DELETE PROCEDURE hAbapi002.
    RETURN "NOK":U.
END.

/** Liberaá∆o **/
RUN piLiberacao IN hAbapi002 (INPUT pLibera,
                              INPUT iUsoReal, 
                              INPUT iUsoRealSec ).

IF RETURN-VALUE = "WARNING":U THEN DO:
    RUN piMostraErros IN THIS-PROCEDURE (3).
    IF VALID-HANDLE(hAbapi002) THEN DO:
        RUN finalizaHandle IN hAbapi002.                           
        DELETE PROCEDURE hAbapi002.
    END.
    RETURN "NOK":U.
END.
/**---------------------------------- Evento -------------------------------------**/
/** Criaá∆o de Eventos para Manutená∆o **/
FOR FIRST ttDocLib:
    /** Contador parado ou Contador Secundario parado **/
    IF ttDocLib.idi-consist = 4 OR ttDocLib.idi-consist = 7 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 28491,
                           INPUT ttDados.cod-eqpto).
        IF RETURN-VALUE = "YES":U THEN DO:
            /** Validaá‰es ParÉmetros **/
            RUN piValida IN hAbapi002.
            IF RETURN-VALUE <> "NOK":U THEN DO:
                /** Cria ttEvento **/
                RUN piEvento IN hAbapi002 (INPUT  c-seg-usuario,
                                           OUTPUT iDoc).
                IF RETURN-VALUE = "DOC":U THEN DO:
                    /** Pergunta para criar evento duplicado **/
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 28493,
                                       INPUT ttDados.cod-eqpto + '~~' + STRING(iDoc)).

                    IF RETURN-VALUE = "NO":U THEN DO:
                        IF VALID-HANDLE(hAbapi002) THEN DO:
                            RUN finalizaHandle IN hAbapi002.
                            DELETE PROCEDURE hAbapi002.
                        END.
                    END.
                    ELSE DO:
                        /** Cria Evento **/
                        RUN piCriaEvento IN hAbapi002.
                        IF RETURN-VALUE = "NOK":U THEN
                            RUN piMostraErros IN THIS-PROCEDURE (3).
                    END.
                END.
                ELSE DO:
                    /** Cria Evento **/
                    RUN piCriaEvento IN hAbapi002.
                    IF RETURN-VALUE = "NOK":U THEN
                        RUN piMostraErros IN THIS-PROCEDURE (3).
                END.
            END.
            /** Erro na validaá∆o inicial **/
            ELSE
                RUN piMostraErros IN THIS-PROCEDURE (3).
        END.
    END.
END.

IF VALID-HANDLE(hAbapi002) THEN DO:
    RUN finalizaHandle IN hAbapi002.
    DELETE PROCEDURE hAbapi002.
END.
EMPTY TEMP-TABLE ttDocLib.
EMPTY TEMP-TABLE tt-param.

/** Atualiza as outras fichas **/
RUN piAtualizaFichas IN THIS-PROCEDURE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piModifica wWindow 
PROCEDURE piModifica :
/*------------------------------------------------------------------------------
  Purpose:     piModifica
  Parameters:  <none>
  Notes:       Modifica campos (Hodìmetro, Data e Hora)
------------------------------------------------------------------------------*/
define variable rReposition as rowid no-undo.
define variable rGoTo       as rowid no-undo.
define buffer   bf-mab-abastec-lubrific for mab-abastec-lubrific.

assign {&window-name}:sensitive = no.
/** Programa Atualizaá∆o **/
run abp/ab0307g.w (input  ttDados.r-rowid,
                   input  input frame fPage0 fiUN1,
                   input  input frame fPage0 fiUNSec,
                   input  lUsaContadorSec,
                   output deHodometro,
                   output deHodometroSec,
                   output dtMovimento,
                   output hrHorario,
                   OUTPUT tpAtividade,
                   output lOK).

assign {&window-name}:sensitive = yes.

/** Atualiza Apontamento **/
if lOK then do:
    create ttApontAux.
    buffer-copy ttDados to ttApontAux
    assign ttApontAux.val-hodom-horim     = deHodometro
           ttApontAux.val-hodom-horim-sec = deHodometroSec
           ttApontAux.dat-movto           = dtMovimento
           ttApontAux.hra-inicial         = hrHorario
           ttApontAux.hra-final           = hrHorario
           ttApontAux.cod-ativid          = tpAtividade
           rReposition                    = ttDados.r-rowid.

    /*:T Reposiciona registro com base em um rowid */
    run repositionRecord in hDBOApont (input ttApontAux.r-rowid).
    /*--- Transfere temp-table ttApontAux para o DBO ---*/
    run setRecord in hDBOApont (input table ttApontAux).
    empty temp-table ttApontAux.
    empty temp-table RowErrors.
    /** Salva Registro Alterado Validando dados **/
    run updateRecord in hDBOApont.
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure (1).
        return "NOK":U.
    end.
    /** Atualiza as datas das tabelas filhas **/
    run atualizaDatas in hDBOApont (input rReposition).
    /** Atualizaá∆o API001 **/
    run piParametro in this-procedure (input 1,
                                       input ttDados.num-docto).
    run abp/abapi001.p (input  table tt-param,
                        output table RowErrors,
                        output table ttDocLib).
    if can-find(first RowErrors) then do:
        run piMostraErros in this-procedure (2).
    end.
    empty temp-table tt-param.
    /** Atualiza as outras fichas **/
    run piAtualizaFichas in this-procedure.
    /** Busca os registros com erros para serem listados **/
    run piAtualizar in this-procedure.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wWindow 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  pLocal = Local de onde pegar os erros
                        1 = BO
                        2 = Local
                        3 = API002
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pLocal AS INTEGER NO-UNDO.

/** Instancia aplicativo **/
{method/showmessage.i1}
CASE pLocal:
    WHEN 1 then do:
        /** Busca erros na BO **/
        RUN getRowErrors IN hDBOApont (OUTPUT TABLE RowErrors).
    end.
    WHEN 3 THEN do:
        /** Busca erros na API **/
        RUN getErros IN hAbapi002 (OUTPUT TABLE RowErrors).
    end.
END CASE.

/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
CASE pLocal:
    WHEN 1 then do:
        /** Limpa temp-tables de erros **/
        RUN emptyRowErrors IN hDBOApont.
    end.
    WHEN 3 then do:
        /** Limpa temp-tables de erros **/
        RUN emptyErros IN hAbapi002.  
    end.
END CASE.

EMPTY TEMP-TABLE RowErrors.
EMPTY TEMP-TABLE ttDocLib.
EMPTY TEMP-TABLE tt-param.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPadrao wWindow 
PROCEDURE piPadrao :
/*------------------------------------------------------------------------------
  Purpose:     piPadrao
  Parameters:  <none>
  Notes:       Busca Consumo Padr∆o do Equipamento e do Modelo
------------------------------------------------------------------------------*/
ASSIGN fiPadMod   = 0
       fiPadEqpto = 0
       fiReal     = 0
       fiMaximo   = 0
       fiMinimo   = 0.

IF AVAIL(ttQuantidades) THEN DO:
    /** Busca Hist¢rico de Combust°vel para apontamento **/
    FOR LAST  mab-histor-combust /* FIELDS(idi-tip-consu val-consu-padr num-livre-1) */
        WHERE mab-histor-combust.ep-codigo      = ttDados.ep-codigo
        AND   mab-histor-combust.cod-eqpto      = ttDados.cod-eqpto
        AND   mab-histor-combust.cod-tip-mater  = ttQuantidades.cod-tip-mater
        AND   mab-histor-combust.dat-inicial   <= ttDados.dat-movto NO-LOCK:
        ASSIGN iTpConsumo = mab-histor-combust.idi-tip-consu
               iTpConsumoSec = mab-histor-combust.num-livre-1.
        /** Guarda tipo de consumo do equipamento
            (1 - Sem Consumo
             2 - Km-Hora/Qtd
             3 - Qtd/Km-Hora) **/
        IF iTpConsumo > 1 THEN DO:
            /**Padr∆o Equipamento **/
            ASSIGN fiPadEqpto = mab-histor-combust.val-consu-padr.
            /** 2 - Km-Hora/Qtd **/
            IF mab-histor-combust.idi-tip-consu = 2 THEN
                ASSIGN fiReal = ttDados.val-km-percur / fiAbastec.
            /** 3 - Qtd/Km-Hora **/
            ELSE
                ASSIGN fiReal = fiAbastec / ttDados.val-km-percur.
        END.
        /** Verifica se consumo padr∆o est† no modelo **/
        FOR FIRST mab-consu-model FIELDS(val-consu-padr)
            WHERE mab-consu-model.cod-model     = fiModelo:SCREEN-VALUE IN FRAME fPage0
            AND   mab-consu-model.cod-ativid    = ttDados.cod-ativid
            AND   mab-consu-model.cod-tip-mater = ttQuantidades.cod-tip-mater NO-LOCK:
            /** Padr∆o Modelo **/
            ASSIGN fiPadMod = mab-consu-model.val-consu-padr.
        END.
    END.
END.

/** Verifica M†ximo e m°nimo **/
IF fiPadMod > 0 THEN
    ASSIGN fiMaximo = fiPadMod + (fiPadMod * deParam14 / 100)
           fiMinimo = fiPadMod - (fiPadMod * deParam14 / 100).
ELSE
    ASSIGN fiMaximo = fiPadEqpto + (fiPadEqpto * deParam14 / 100)
           fiMinimo = fiPadEqpto - (fiPadEqpto * deParam14 / 100).

IF fiReal = ? THEN
    ASSIGN fiReal = 0.

DISPLAY fiPadMod fiPadEqpto fiReal fiMaximo fiMinimo WITH FRAME fPage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametro wWindow 
PROCEDURE piParametro :
/*------------------------------------------------------------------------------
  Purpose:     piParametro
  Parameters:  pLibera = Tipo de Liberaá∆o
  Notes:       Cria a temp-table de parÉmetros para a atualizaá∆o on-line
               (tt-param)
------------------------------------------------------------------------------*/
define input parameter pLibera as integer no-undo.
define input parameter pDoc    as integer no-undo.

empty temp-table tt-param.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 1
       tt-param.arquivo         = ""
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.iConsiste       = 1
       tt-param.descConsiste    = "Somente com Problemas"
       tt-param.dataIni         = if ttDados.dat-movto > dtMovimento 
                                  then ttDados.dat-movto
                                  else dtMovimento
       tt-param.dataFim         = today
       tt-param.iEmpIni         = ttDados.ep-codigo
       tt-param.iEmpFim         = ttDados.ep-codigo
       tt-param.cEqptoIni       = ttDados.cod-eqpto
       tt-param.cEqptoFim       = ttDados.cod-eqpto
       tt-param.num-docto       = pDoc
       tt-param.lFicha          = yes
       tt-param.tipo-liberacao  = pLibera
       tt-param.cEstabIni       = ""
&IF "{&mguni_version}" >= "2.071" &THEN
       tt-param.cEstabFim       = "ZZZZZ"
&ELSE
       tt-param.cEstabFim       = "ZZZ"
&ENDIF
       tt-param.cTagIni         = ""
       tt-param.cTagFim         = "ZZZZZZZZZZZZZZZZ"
       tt-param.cCCIni          = ""
       tt-param.cCCFim          = "ZZZZZZZZZZZZZZZZZZZZ"
       tt-param.cPostoIni       = ""
       tt-param.cPostoFim       = "ZZZZZZZZ"
&IF DEFINED(bf_mnt_ems206b) &THEN
       tt-param.cUnidNegocIni   = ttDados.cod-unid-negoc
       tt-param.cUnidNegocFim   = ttDados.cod-unid-negoc.
&ENDIF
       .

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametroLiberacao wWindow 
PROCEDURE piParametroLiberacao :
/*------------------------------------------------------------------------------
  Purpose:     piParametro
  Parameters:  <none>
  Notes:       Cria a temp-table de parÉmetros para a atualizaá∆o on-line
               (tt-param)
------------------------------------------------------------------------------*/
empty temp-table tt-param.

get current brApont.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 1
       tt-param.arquivo         = ""
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.iConsiste       = 2
       tt-param.descConsiste    = "Todos":U
       tt-param.dataIni         = ttDados.dat-movto
       tt-param.dataFim         = ttDados.dat-movto
       tt-param.iEmpIni         = ttDados.ep-codigo
       tt-param.iEmpFim         = ttDados.ep-codigo
       tt-param.cEqptoIni       = ttDados.cod-eqpto
       tt-param.cEqptoFim       = ttDados.cod-eqpto
       tt-param.num-docto       = ttDados.num-docto
       tt-param.lFicha          = yes
       tt-param.tipo-liberacao  = 1 /** Normal **/
       tt-param.cCCini          = ""
       tt-param.cCCfim          = "ZZZZZZZZZZZZZZZZZZZZ"
       tt-param.cPostoIni       = ""
       tt-param.cPostoFim       = "ZZZZZZZZ"
&IF DEFINED(bf_mnt_ems206b) &THEN
       tt-param.cUnidNegocIni   = ttDados.cod-unid-negoc
       tt-param.cUnidNegocFim   = ttDados.cod-unid-negoc.
&ENDIF
       .

for last  mab-histor-ativid fields(cod-estab cd-tag)
    where mab-histor-ativid.ep-codigo     = ttDados.ep-codigo
    and   mab-histor-ativid.cod-eqpto     = ttDados.cod-eqpto
    and   mab-histor-ativid.dat-cadastro <= ttDados.dat-movto no-lock:
    assign tt-param.cEstabIni       = mab-histor-ativid.cod-estab
           tt-param.cEstabFim       = mab-histor-ativid.cod-estab
           tt-param.cTagIni         = mab-histor-ativid.cd-tag
           tt-param.cTagFim         = mab-histor-ativid.cd-tag.
end.
if not avail mab-histor-ativid then do:
    for last   mab-histor-ativid
        where  mab-histor-ativid.ep-codigo = ttDados.ep-codigo
        and    mab-histor-ativid.cod-eqpto = ttDados.cod-eqpto no-lock:
        assign tt-param.cEstabIni       = mab-histor-ativid.cod-estab
               tt-param.cEstabFim       = mab-histor-ativid.cod-estab
               tt-param.cTagIni         = mab-histor-ativid.cd-tag
               tt-param.cTagFim         = mab-histor-ativid.cd-tag.
    end.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRemonta wWindow 
PROCEDURE piRemonta :
/*------------------------------------------------------------------------------
  Purpose:     piRemonta
  Parameters:  <none>
  Notes:       Chama programa de atualizaá∆o da remonta do motor 
------------------------------------------------------------------------------*/
/** Pergunta ao usu†rio se deseja atualizar remonta **/
RUN utp/ut-msgs.p (INPUT "show":U,
                   INPUT 28545,
                   INPUT "").

IF RETURN-VALUE = "yes":U THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN abp/ab0404.w.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

RETURN "OK":U.
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
run abp/ab0307e.w (input-output cCaminho,
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
    assign cCaminho = replace(cCaminho, "/":U, "~\":U).
    /** Cria arquivo **/
    output to value(cCaminho) paged page-size 64 convert target "iso8859-1":U.
        /******************************************************************
        ** Inicia impress∆o do TXT
        ******************************************************************/
        /** Somente vis∆o selecionada **/
        if i-impressao = 1 then do:
            /** Guarda rowid do tree-view **/
            ASSIGN  r-rowid =   TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node),",")).
            /** Busca Registro **/
            for first bfttDados
                where rowid(bfttDados) = r-rowid no-lock:
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
    where ttDados.cod-dimens-pai = pDimensao no-lock use-index data:
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

        assign c-tam = "x(" + string(length(trim(cDescPai) + cDelimitador                +  
                                                 string(ttDados.ep-codigo,">>9")         + cDelimitador +          
                                                 string(ttDados.cod-eqpto)               + cDelimitador +          
                                                 string(ttDados.dat-movto,"99/99/9999")  + cDelimitador +          
                                                 string(ttDados.hra-inicial,"99:99:99")  + cDelimitador +          
                                                 string(ttDados.num-docto,">>>,>>>,>>9") + cDelimitador +          
                                                 fnDescErro(ttDados.idi-consist))) + ")".                           

        /** Exporta dados para TXT **/                                                                              
        put trim(trim(cDescPai)                      +                                                                                        
             string(ttDados.ep-codigo,">>9")         + cDelimitador +                                             
             string(ttDados.cod-eqpto)               + cDelimitador +                                             
             string(ttDados.dat-movto,"99/99/9999")  + cDelimitador +                                             
             string(ttDados.hra-inicial,"99:99:99")  + cDelimitador +                                             
             string(ttDados.num-docto,">>>,>>>,>>9") + cDelimitador +                                             
             fnDescErro(ttDados.idi-consist)) format c-tam at 01.
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
define variable c-tam           as character no-undo.

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
    {abp/ab0307.i2 bfttDados2.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelimitador.
end.
if avail bfttDados2 and bfttDados2.sequencia <= iVisao then do:

    assign cDescPai  = trim(trim(cDescPai) + trim(bfttDados2.cod-oficial) + "-" + TRIM(bfttDados2.desc-dimensao) + cDelimitador).
    /** Se for o pen£ltimo n°vel, imprime cabeáalho se parametrizado **/
    if bfttDados2.sequencia = iVisao and lCabecalho then do:
        ASSIGN lCabecalho = NO.

        assign c-tam = "x(" + string(length(trim(trim(cTituloTxt)   +  
                                     fnBrowse("ep-codigo":U,1)      + cDelimitador +            
                                     fnBrowse("cod-eqpto":U,1)      + cDelimitador +         
                                     fnBrowse("dat-movto":U,1)      + cDelimitador +               
                                     fnBrowse("hra-inicial":U,1)    + cDelimitador +          
                                     fnBrowse("num-docto":U,1)      + cDelimitador +            
                                     fnBrowse("cErro":U,1)))) + ")".          
        put trim(trim(cTituloTxt)              +                              
                 fnBrowse("ep-codigo":U,1)     + cDelimitador +                              
                 fnBrowse("cod-eqpto":U,1)     + cDelimitador +                              
                 fnBrowse("dat-movto":U,1)     + cDelimitador +                              
                 fnBrowse("hra-inicial":U,1)   + cDelimitador +                              
                 fnBrowse("num-docto":U,1)     + cDelimitador +                              
                 fnBrowse("cErro":U,1)) format c-tam at 01.
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
apply "CHOOSE":U to btAtualizar in frame fPage0.

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
        when "ep-codigo":U then do:
            {utp/ut-liter.i "Empresa"}
        end.
        when "cod-eqpto":U then do:
            {utp/ut-liter.i "Equipamento"}
        end.
        when "dat-movto":U then do:
            {utp/ut-liter.i "Data"}
        end.
        when "hra-inicial":U then do:
            {utp/ut-liter.i "Hora"}
        end.
        when "num-docto":U then do:
            {utp/ut-liter.i "Documento"}
        end.
        when "cErro":U then do:
            {utp/ut-liter.i "Descriá∆o Erro"}
        end.
    end case.
    assign cRetorno = trim(return-value).
end.
else do:
    case pCampo:
        when "ep-codigo":U then do:
            assign cRetorno = string(ttDados.ep-codigo,">>9").
        end.
        when "cod-eqpto":U then do:
            assign cRetorno = string(ttDados.cod-eqpto,"x(16)").
        end.
        when "dat-movto":U then do:
            assign cRetorno = string(ttDados.dat-movto,"99/99/9999").
        end.
        when "hra-inicial":U then do:
            assign cRetorno = string(ttDados.hra-inicial,"99:99:99").
        end.
        when "num-docto":U then do:
            assign cRetorno = string(ttDados.num-docto,">>>,>>>,>>9").
        end.
        when "cErro":U then do:
            assign cRetorno = string(fnDescErro(ttDados.idi-consist),"x(60)").
        end.
    end case.
end.

RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescErro wWindow 
FUNCTION fnDescErro RETURNS CHARACTER
  ( input iStatus as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
define variable cStatus as character format 'x(40)' no-undo.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 iStatus}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  cStatus = RETURN-VALUE.
&else
    ASSIGN cStatus = {frinc/i00fr055.i 04 iStatus}.
&endif
  RETURN cStatus.   /* Function return value. */

END FUNCTION.

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
        WHEN    1   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-emp.bmp".
        WHEN    2   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-estab.bmp".
        WHEN    3   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-tag.bmp".
        WHEN    4   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-fin.bmp".
        WHEN    5   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-emsdis.bmp".
        WHEN    6   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mes.bmp".
        WHEN    7   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-calendario.bmp".
        WHEN    8   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-estab.bmp".
        WHEN    9   THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-posto.bmp".
        WHEN    10  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mpn-lixo3.bmp".
        WHEN    11  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-mod-eqpto.bmp".
        WHEN    12  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-mab-bomba1.bmp".
        WHEN    13  THEN    ASSIGN  cRetorno    =   "image/treeview/tvpics/tv-negoc.bmp".
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
    {abp/ab0307.i2 pImage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

