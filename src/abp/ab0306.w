&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAbastec NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttFicha NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0306 2.00.00.048 } /*** "010048" 08/08/2025 11:24:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0306 MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0306
&GLOBAL-DEFINE Version        2.00.00.048

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttAbastec             
&GLOBAL-DEFINE hDBOTable      hDBOAbastec
&GLOBAL-DEFINE DBOTable       mab-item-abastec

&GLOBAL-DEFINE page0KeyFields {&ttTable}.cod-bomba {&ttTable}.cod-eqpto ~
                              {&ttTable}.cod-posto {&ttTable}.ep-codigo ~
                              {&tttable}.it-codigo {&ttTable}.num-docto
&GLOBAL-DEFINE page0Fields    {&ttTable}.cod-localiz {&ttTable}.cod-refer ~
                              {&ttTable}.lote {&ttTable}.val-mater-1 ~
                              {&ttTable}.val-quant fi-cc-codigo ~
                              ttFicha.cod-ativid ~
                              ttFicha.cod-matr ttFicha.cod-rota ~
                              ttFicha.cod-usuar fi-ct-codigo ~
                              ttFicha.dat-movto ttFicha.hra-final ~
                              ttFicha.hra-inicial ttFicha.nr-nota-fis ~
                              ttFicha.serie ttFicha.val-hodom-horim ~
                              ttFicha.ep-codigo-matr ttFicha.cod-estabel-matr ~
                              ttFicha.idi-integr ttFicha.val-hodom-horim-sec ~
                              ttFicha.dat-livre-1 ttFicha.dat-livre-2 ttFicha.cod-livre-1

&GLOBAL-DEFINE page0Widgets     btIntegraXML

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cFConta      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cFSub        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cHora        AS CHARACTER format "99:99:99" NO-UNDO.
DEFINE VARIABLE dtHoraIni    AS DATE format "99/99/9999"    NO-UNDO.
define variable dePrecoMater like {&ttTable}.val-mater-1    no-undo.
define variable iTpPosto     as integer                     no-undo.
define variable iTpValor     as integer                     no-undo.
define variable iEmpresaGlob LIKE mab-item-abastec.ep-codigo no-undo.
DEFINE VARIABLE lLogContSec  AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE cUnModelSec  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE dAuxiliar    AS DECIMAL                     NO-UNDO.
/*Parametros para atualizaá∆o durablidade/apontamento dos pneus*/
DEFINE VARIABLE param25      LIKE  mab-param.des-valor      NO-UNDO.
DEFINE VARIABLE param26      LIKE  mab-param.des-valor      NO-UNDO.
DEFINE VARIABLE param49      LIKE  mab-param.des-valor      NO-UNDO.

DEFINE VARIABLE iErro AS INTEGER NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE mab-histor-ativid.cod-estabel no-undo.
DEFINE VARIABLE cConta        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSub          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cContLub      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCCustoLub    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE cEstabelHist  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-ativid  LIKE mab-histor-ativid.cod-ativid NO-UNDO.
DEFINE VARIABLE c-msg-aux     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iKey          AS INTEGER   NO-UNDO.

{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE        NO-UNDO.
 
/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* Global Variables ---                                                 */
define new global shared variable c-it-codigo   like saldo-estoq.it-codigo            no-undo.
define new global shared variable c-estab       like saldo-estoq.cod-estabel          no-undo.
define new global shared variable cTipoMaterial like mab-tip-mater-item.cod-tip-mater no-undo.

/*variaveis globais para funcionamento da upc Colombo*/
DEF NEW GLOBAL SHARED VARIABLE i-glob-ep-codigo LIKE mab-item-abastec.ep-codigo NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-eqpto AS CHAR FORMAT "X(16)" NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-posto AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-conta-contabil AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-sub-conta AS CHAR NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOFicha    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtiv     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTraj     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOItem     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOApi003a  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor   AS HANDLE NO-UNDO.
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

{abp/abapi001.i}  /** Temp-Tables da API de Atualizaá∆o (ABAPI001) **/
{pnp/pnapi002.i tt-param-aux} /**Definiá∆o da Temp-Table tt-param-aux para integrar com a pnapi002**/
&IF DEFINED(bf_mnt_ems206b) &THEN
    {frbo/bofr133.i tt-unid-negoc-histor}
&ENDIF

{cdp/cd0031.i "MAB":U} /** Trigger on-fin da tabela estabelec **/
DEFINE BUFFER bfEquipto FOR mab-eqpto.
DEFINE BUFFER bfMabPosto FOR mab-posto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttFicha.dat-movto ttAbastec.num-docto ~
ttFicha.hra-inicial ttAbastec.ep-codigo ttAbastec.cod-eqpto ~
ttFicha.hra-final ttFicha.val-hodom-horim ttFicha.val-hodom-horim-sec ~
ttFicha.idi-integr ttAbastec.cod-posto ttAbastec.cod-bomba ~
ttFicha.ep-codigo-matr ttFicha.cod-estabel-matr ttFicha.cod-matr ~
ttFicha.cod-ativid ttFicha.cod-rota ttAbastec.it-codigo ttFicha.dat-livre-1 ~
ttAbastec.cod-refer ttAbastec.lote ttFicha.cod-usuar ttAbastec.cod-localiz ~
ttAbastec.val-quant ttFicha.nr-nota-fis ttFicha.serie ttAbastec.val-mater-1 ~
ttFicha.dat-livre-2 ttFicha.cod-livre-1 
&Scoped-define ENABLED-TABLES ttFicha ttAbastec
&Scoped-define FIRST-ENABLED-TABLE ttFicha
&Scoped-define SECOND-ENABLED-TABLE ttAbastec
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btIntegraXML ~
btQueryJoins btReportsJoins btExit btHelp tg-rastreamento fiDescEqpto fiUN ~
fiUnSec fi-cod-unid-negoc btMatriz fiStatus fiDescPosto fiDeposito ~
fiDescMoto fiDescAtiv fiDescTrajeto fiDescItem fiDescLocal fiUNItem ~
fi-ct-codigo fi-cc-codigo RECT-28 RECT-29 RECT-30 rtKeys rtKeys-2 rtKeys-3 ~
rtKeys-4 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttFicha.dat-movto ttAbastec.num-docto ~
ttFicha.hra-inicial ttAbastec.ep-codigo ttAbastec.cod-eqpto ~
ttFicha.hra-final ttFicha.val-hodom-horim ttFicha.val-hodom-horim-sec ~
ttFicha.idi-integr ttAbastec.cod-posto ttAbastec.cod-bomba ~
ttFicha.ep-codigo-matr ttFicha.cod-estabel-matr ttFicha.cod-matr ~
ttFicha.cod-ativid ttFicha.cod-rota ttAbastec.it-codigo ttFicha.dat-livre-1 ~
ttAbastec.cod-refer ttAbastec.lote ttFicha.cod-usuar ttAbastec.cod-localiz ~
ttAbastec.val-quant ttFicha.nr-nota-fis ttFicha.serie ttAbastec.val-mater-1 ~
ttFicha.dat-livre-2 ttFicha.cod-livre-1 
&Scoped-define DISPLAYED-TABLES ttFicha ttAbastec
&Scoped-define FIRST-DISPLAYED-TABLE ttFicha
&Scoped-define SECOND-DISPLAYED-TABLE ttAbastec
&Scoped-Define DISPLAYED-OBJECTS tg-rastreamento fiDescEqpto fiUN fiUnSec ~
fi-cod-unid-negoc fiStatus fiDescPosto fiDeposito fiDescMoto fiDescAtiv ~
fiDescTrajeto fiDescItem fiDescLocal fiUNItem fi-ct-codigo fi-cc-codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "Pr¢&ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "Ca&ncelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "Sai&r"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .

DEFINE MENU pop-item 
       MENU-ITEM miItem         LABEL "Pesquisa &Itens"
       RULE
       MENU-ITEM miMaterial     LABEL "Pesquisa Itens do &Tipo Material"
       RULE
       MENU-ITEM miSaldo        LABEL "Pesquisa &Saldo Estoque".


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
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

DEFINE BUTTON btIntegraXML 
     IMAGE-UP FILE "image/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-exp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exportaá∆o XML".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-cc-codigo AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unid. Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .88.

DEFINE VARIABLE fi-ct-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Cta Cont†bil" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiCodDeposLocaliz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deposito Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fiCodEstabelLocaliz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fiDeposito AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescAtiv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescLocal AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMoto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPosto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTrajeto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(256)":U 
     LABEL "Status" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUNItem AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnSec AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 1.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 3.25.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 2.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.33.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 3.25.

DEFINE RECTANGLE rtKeys-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-rastreamento AS LOGICAL INITIAL no 
     LABEL "Integra Rastreamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiCodDeposLocaliz AT ROW 9.25 COL 78.72 COLON-ALIGNED WIDGET-ID 2
     fiCodEstabelLocaliz AT ROW 10.25 COL 78.72 COLON-ALIGNED WIDGET-ID 4
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btIntegraXML AT ROW 1.13 COL 65.86
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttFicha.dat-movto AT ROW 2.79 COL 57.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
     ttAbastec.num-docto AT ROW 2.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tg-rastreamento AT ROW 2.83 COL 29.43
     ttFicha.hra-inicial AT ROW 2.83 COL 79.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttAbastec.ep-codigo AT ROW 3.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttAbastec.cod-eqpto AT ROW 3.83 COL 20.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescEqpto AT ROW 3.83 COL 37 COLON-ALIGNED NO-LABEL
     ttFicha.hra-final AT ROW 3.79 COL 79.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttFicha.val-hodom-horim AT ROW 4.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUN AT ROW 4.83 COL 27.57 COLON-ALIGNED NO-LABEL
     ttFicha.val-hodom-horim-sec AT ROW 4.83 COL 49.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUnSec AT ROW 4.83 COL 62 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 4.75 COL 79.72 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     btMatriz AT ROW 4.71 COL 86.14
     ttFicha.idi-integr AT ROW 5.79 COL 78.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o", 1,
"Sim", 2
          SIZE 11.57 BY .83
     fiStatus AT ROW 5.83 COL 15 COLON-ALIGNED
     ttAbastec.cod-posto AT ROW 7.38 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiDescPosto AT ROW 7.38 COL 27.57 COLON-ALIGNED NO-LABEL
     fiDeposito AT ROW 7.38 COL 59 COLON-ALIGNED NO-LABEL
     ttAbastec.cod-bomba AT ROW 7.38 COL 76 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.67
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     ttFicha.ep-codigo-matr AT ROW 8.38 COL 15 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttFicha.cod-estabel-matr AT ROW 8.38 COL 20.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttFicha.cod-matr AT ROW 8.38 COL 25.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiDescMoto AT ROW 8.38 COL 37.72 COLON-ALIGNED NO-LABEL
     ttFicha.cod-ativid AT ROW 9.38 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiDescAtiv AT ROW 9.38 COL 27.57 COLON-ALIGNED NO-LABEL
     ttFicha.cod-rota AT ROW 10.38 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiDescTrajeto AT ROW 10.38 COL 27.57 COLON-ALIGNED NO-LABEL
     ttAbastec.it-codigo AT ROW 11.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescItem AT ROW 11.83 COL 31.57 COLON-ALIGNED NO-LABEL
     ttFicha.dat-livre-1 AT ROW 12.46 COL 75.14 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttAbastec.cod-refer AT ROW 12.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttAbastec.lote AT ROW 12.83 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 33 BY .88
     ttFicha.cod-usuar AT ROW 13.46 COL 75.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttAbastec.cod-localiz AT ROW 13.83 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiDescLocal AT ROW 13.83 COL 36 COLON-ALIGNED NO-LABEL
     ttAbastec.val-quant AT ROW 15.5 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUNItem AT ROW 15.5 COL 27.57 COLON-ALIGNED NO-LABEL
     ttFicha.nr-nota-fis AT ROW 15.5 COL 44.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ttFicha.serie AT ROW 15.5 COL 61 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttAbastec.val-mater-1 AT ROW 16.5 COL 5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fi-ct-codigo AT ROW 16.5 COL 26.43 COLON-ALIGNED
     fi-cc-codigo AT ROW 16.5 COL 47 COLON-ALIGNED NO-LABEL
     ttFicha.dat-livre-2 AT ROW 15.58 COL 75.14 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttFicha.cod-livre-1 AT ROW 16.58 COL 75.14 COLON-ALIGNED
          LABEL "Usu†rio":R9
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     "Integrado" VIEW-AS TEXT
          SIZE 8.29 BY .54 AT ROW 5.88 COL 69.86
     "Criaá∆o" VIEW-AS TEXT
          SIZE 6.14 BY .54 AT ROW 11.5 COL 71.57
     "Alteraá∆o" VIEW-AS TEXT
          SIZE 7 BY .42 AT ROW 15 COL 71.57
     RECT-28 AT ROW 5.71 COL 69.14
     RECT-29 AT ROW 11.71 COL 70.43
     RECT-30 AT ROW 15.17 COL 70.43
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 7.21 COL 1
     rtKeys-3 AT ROW 11.71 COL 1
     rtKeys-4 AT ROW 15.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.67
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAbastec T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttFicha T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.92
         WIDTH              = 90
         MAX-HEIGHT         = 26.38
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.38
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN ttFicha.cod-livre-1 IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttFicha.dat-livre-1 IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttFicha.dat-livre-2 IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttFicha.ep-codigo-matr IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiCodDeposLocaliz IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodDeposLocaliz:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN fiCodEstabelLocaliz IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodEstabelLocaliz:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       ttAbastec.it-codigo:POPUP-MENU IN FRAME fpage0       = MENU pop-item:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
    /** Foco Inicial na Data **/
    apply "ENTRY":U to ttFicha.dat-movto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:

    RUN copyRecord IN THIS-PROCEDURE.
    /** Foco Inicial na Data **/
    apply "ENTRY":U to ttFicha.dat-movto in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    /** Gera os dados para a temp-table da API (abapi001) **/
    run piParametroAPI in this-procedure (input ttFicha.dat-movto,
                                          input ttFicha.ep-codigo,
                                          input ttFicha.cod-eqpto,
                                          input ttFicha.num-docto,
                                          input {&ttTable}.cod-posto).
    RUN deleteRecord IN THIS-PROCEDURE.
    if return-value = "OK":U then do:
        /** Mostra as Mensagens de Aviso da Eliminaá∆o **/
        if can-find(first RowErrors
                    where RowErrors.ErrorSubType <> "ERROR":U 
                    and   RowErrors.ErrorType    =  "EMS":U no-lock) then do:
            for each  RowErrors
                where RowErrors.ErrorType = "INTERNAL":U exclusive-lock:
                delete RowErrors.
            end.
            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
        end.
        /** Chama a API (abapi001), para consistir fichas **/
        run piAtualizacao in this-procedure (input 2).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIntegraXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegraXML wMaintenance
ON CHOOSE OF btIntegraXML IN FRAME fpage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).
    assign {&window-name}:sensitive = no.
    
    /*--- Executa programa de manutená∆o de filho ---*/
    run abp/ab0302d.w (input input frame fPage0 ttAbastec.num-docto).
      
    assign {&window-name}:sensitive = yes.
    /*--- Seta cursor do mouse para normal ---*/
    session:set-wait-state("":U).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMaintenance
ON CHOOSE OF btMatriz IN FRAME fpage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    /*--- Executa programa de manutená∆o de filho ---*/
    RUN abp/ab0302e.w (INPUT INPUT FRAME fPage0 ttAbastec.ep-codigo,
                       INPUT INPUT FRAME fPage0 ttAbastec.cod-eqpto,
                       INPUT INPUT FRAME fPage0 ttFicha.dat-movto).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    FOR FIRST mab-eqpto
         WHERE mab-eqpto.ep-codigo     =  &IF "{&mguni_version}" >= "2.071" &THEN ttAbastec.ep-codigo:SCREEN-VALUE IN FRAME fPage0 &ELSE INT(ttAbastec.ep-codigo:SCREEN-VALUE IN FRAME fPage0) &ENDIF 
         AND   mab-eqpto.cod-eqpto     =  ttAbastec.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
         AND   mab-eqpto.dat-situacao  >  date(ttficha.dat-movto:SCREEN-VALUE IN FRAME fPage0) NO-LOCK:
        IF CAN-FIND (FIRST mab-sit-eqpto
                     WHERE mab-sit-eqpto.cod-sit-eqpto = mab-eqpto.cod-sit-eqpto
                     AND   mab-sit-eqpto.idi-tip       = 2) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 26405,
                               INPUT "").
            RETURN "NOK":U.
        END.
    END.

    FIND FIRST mab-posto 
        WHERE mab-posto.cod-posto = input frame fPage0 {&ttTable}.cod-posto NO-LOCK NO-ERROR.

    IF iTpValor <> 1  THEN
    IF mab-posto.idi-posto = 1 THEN DO:
        if ttFicha.idi-integr = 1  then do:
           run piPrecoItem in this-procedure (input input frame fPage0 {&ttTable}.cod-posto).
           if return-value = "OK":U then do:
              assign {&ttTable}.val-mater-1 = input frame fPage0 {&ttTable}.val-quant * dePrecoMater.
              display {&ttTable}.val-mater-1 with frame fPage0.
           end.
        end. 
    END. 
  
    RUN abp/abapi003a.p PERSISTENT SET hDBOApi003a (INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT "",
                                                    INPUT ?,
                                                    INPUT "",
                                                    INPUT "",
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar).
    /** Transaá∆o de Inclus∆o dos Registros do Pai (mab-abastec-lubrific) 
        e do Filho (mab-item-abastec) **/
    Abastecimento:
    do transaction:
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE <> "OK":U then
            undo Abastecimento, leave Abastecimento.
    end.
    if return-value = "NOK":U then do:
        empty temp-table RowErrors.
        if cAction = "ADD":U or 
           cAction = "COPY":U then do:
            /** Busca a numeraá∆o do Apontamento, pois pode ter sido 
                inclu°do um outro registro durante este erro **/
            run buscaDocumento in hDBOFicha (output {&ttTable}.num-docto).
            /** Mostra documento em tela **/
            display {&ttTable}.num-docto
                with frame fPage0.
        end.
    end.
    else
        /** Chama API (abapi001), para consistància das fichas **/
        run piAtualizacao in this-procedure (input 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr057.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
    /** Foco Inicial na Data **/
    apply "ENTRY":U to ttFicha.dat-movto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-ativid wMaintenance
ON LEAVE OF ttFicha.cod-ativid IN FRAME fpage0 /* Atividade */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOAtiv"
        &KeyValue1="ttFicha.cod-ativid:screen-value in frame fPage0"
        &FieldName1="des-ativid"
        &FieldScreen1="fiDescAtiv"
        &Frame1="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-ativid wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttFicha.cod-ativid IN FRAME fpage0 /* Atividade */
OR "F5":U OF ttFicha.cod-ativid IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr001.w"
           &FieldZoom1="cod-ativid"
           &FieldScreen1="ttFicha.cod-ativid"
           &Frame1="fPage0"
           &FieldZoom2="des-ativid"
           &FieldScreen2="fiDescAtiv"
           &Frame2="fPage0"
           &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.cod-bomba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-bomba wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.cod-bomba IN FRAME fpage0 /* Bomba */
OR "F5":U OF {&ttTable}.cod-bomba IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr002.w"
           &FieldZoom1="cod-bomba"
           &FieldScreen1="{&ttTable}.cod-bomba"
           &Frame1="fPage0"
           &RunMethod="run setaPosto in hProgramZoom 
                       (input {&ttTable}.cod-posto:screen-value in frame fPage0)."}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-eqpto wMaintenance
ON LEAVE OF ttAbastec.cod-eqpto IN FRAME fpage0 /* cod-eqpto */
DO:

    /* Seguranáa estabelecimento */
    IF  l-seg-ativa-modulo THEN
        RUN ValidaSegurancaEstabelecimento (input input frame fPage0 ttAbastec.ep-codigo,
                                            input input frame fPage0 ttAbastec.cod-eqpto).
    
    /*
        Somente ir† executar a l¢gica abaixo nas seguintes condiá‰es:
        1 - Seguranáa por estabelecimento n∆o estiver habilitada
        2 - Se Seguranáa por estabelecimento estiver habilitada E o retorno da validaá∆o for "OK", ou seja, o usu†rio tem permiss∆o ao estabelecimento em quest∆o
    */
    IF  l-seg-ativa-modulo = NO OR (l-seg-ativa-modulo AND RETURN-VALUE = "OK":U) THEN DO:
        IF AVAIL ttAbastec THEN DO:
            FOR FIRST mab-eqpto
                WHERE mab-eqpto.cod-eqpto = ttAbastec.cod-eqpto 
                AND   mab-eqpto.ep-codigo = ttAbastec.ep-codigo NO-LOCK:
                ASSIGN tg-rastreamento:CHECKED IN FRAME fPage0 = mab-eqpto.log-livre-1.
            END.
        END.

        run buscaModelo in this-procedure.
        {method/referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="cCodModelo"
            &FieldName1="des-model"
            &FieldScreen1="fiDescEqpto"
            &Frame1="fPage0"
            &FieldName2="un"
            &FieldScreen2="fiUN"
            &Frame2="fPage0"}

        IF TRIM(cAction) <> "":U THEN DO:
            RUN piAtividade IN THIS-PROCEDURE.
            APPLY "leave":U TO ttAbastec.cod-posto IN FRAME fPage0.
            RUN piValidaContadorSec IN THIS-PROCEDURE.

            /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
            IF l-usa-unid-negoc THEN
                RUN piValidaMatriz IN THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-eqpto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.cod-eqpto IN FRAME fpage0 /* cod-eqpto */
OR "F5":U OF {&ttTable}.cod-eqpto IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="{&ttTable}.ep-codigo"
           &Frame1="fPage0"
           &FieldZoom2="cod-eqpto"
           &FieldScreen2="{&ttTable}.cod-eqpto"
           &Frame2="fPage0"
           &EnableImplant="YES"}
        apply "LEAVE":U to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.cod-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-estabel-matr wMaintenance
ON F5 OF ttFicha.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5" TO ttFicha.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-estabel-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttFicha.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5" TO ttFicha.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-localiz wMaintenance
ON LEAVE OF ttAbastec.cod-localiz IN FRAME fpage0 /* Localizaá∆o */
DO:
  /** Busca a descriá∆o da localizaá∆o **/
  assign fiDescLocal = "".

  FIND FIRST bfMabPosto
       WHERE bfMabPosto.cod-posto = {&ttTable}.cod-posto:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
  IF  AVAIL bfMabPosto THEN DO:
      IF  {&ttTable}.cod-localiz:SENSITIVE IN FRAME fPage0 = TRUE THEN DO:
          IF  fiCodEstabelLocaliz:SCREEN-VALUE IN FRAME fPage0 <> "" AND fiCodEstabelLocaliz:SCREEN-VALUE IN FRAME fPage0 <> bfMabPosto.cod-estabel THEN DO:
              {utp/ut-liter.i "Estabelecimento_da_Localizaá∆o"}
              ASSIGN c-msg-aux = RETURN-VALUE.
              {utp/ut-liter.i "Estabelecimento_do_Posto"}
              ASSIGN c-msg-aux = c-msg-aux + "~~" + RETURN-VALUE.
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 17399,
                                 INPUT c-msg-aux).
              RETURN NO-APPLY.
          END.
          IF  fiCodDeposLocaliz:SCREEN-VALUE IN FRAME fPage0 <> "" AND fiCodDeposLocaliz:SCREEN-VALUE IN FRAME fPage0 <> bfMabPosto.cod-depos THEN DO:
              {utp/ut-liter.i "Deposito_da_Localizaá∆o"}
              ASSIGN c-msg-aux = RETURN-VALUE.
              {utp/ut-liter.i "Deposito_do_Posto"}
              ASSIGN c-msg-aux = c-msg-aux + "~~" + RETURN-VALUE.
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 17399,
                                 INPUT c-msg-aux).
              RETURN NO-APPLY.
          END.
      END.
      FOR FIRST localizacao FIELDS(descricao)
          WHERE localizacao.cod-estabel = bfMabPosto.cod-estabel
          AND   localizacao.cod-depos   = bfMabPosto.cod-depos
          AND   localizacao.cod-localiz = {&ttTable}.cod-localiz:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
          ASSIGN fiDescLocal = localizacao.descricao.
      END.
  END.

  display fiDescLocal with frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-localiz wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.cod-localiz IN FRAME fpage0 /* Localizaá∆o */
OR "F5":U OF {&ttTable}.cod-localiz IN FRAME fPage0 DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z01in189.w"
                      &campo={&ttTable}.cod-localiz
                      &campozoom=cod-localiz
                      &frame=fPage0
                      &campo2=fiDescLocal
                      &campozoom2=descricao
                      &frame2=fPage0
                      &campo3=fiCodEstabelLocaliz
                      &campozoom3=cod-estabel
                      &frame3=fPage0
                      &campo4=fiCodDeposLocaliz
                      &campozoom4=cod-depos
                      &frame4=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-matr wMaintenance
ON LEAVE OF ttFicha.cod-matr IN FRAME fpage0 /* cod-matr */
DO:

   FOR FIRST mab-param
       WHERE mab-param.cdn-param = 52 NO-LOCK:
         IF mab-param.des-valor = "1":U THEN do:
             for FIRST mab-motoris
                 where mab-motoris.cod-matr = ttFicha.cod-matr:screen-value in frame fPage0
                 AND   mab-motoris.ep-codigo = ttFicha.ep-codigo-matr:screen-value in frame fPage0 
                 AND   mab-motoris.cod-estabel = ttFicha.cod-estabel-matr:screen-value in frame fPage0 no-lock:

             END.

             if not avail mab-motoris then
                for FIRST mab-motoris
                    where mab-motoris.cod-matr = ttFicha.cod-matr:screen-value in frame fPage0 NO-LOCK:
                        assign ttFicha.ep-codigo-matr:screen-value in frame fPage0 = string(mab-motoris.ep-codigo)
                               ttFicha.cod-estabel-matr:screen-value in frame fPage0 = mab-motoris.cod-estabel.
                        
                END.
             
             if not avail mab-motoris then do:
                assign ttFicha.ep-codigo-matr:screen-value in frame fPage0 = "0"
                       ttFicha.cod-estabel-matr:screen-value in frame fPage0 = "".
             end.
         end.
   end.


  {method/ReferenceFields.i
      &HandleDBOLeave="hDBOMoto"
      &KeyValue1="input frame fPage0 ttFicha.ep-codigo-matr"
      &KeyValue2="input frame fPage0 ttFicha.cod-estabel-matr"
      &KeyValue3="input frame fPage0 ttFicha.cod-matr"
      &FieldName1="nom-motoris"
      &FieldScreen1="fiDescMoto"
      &Frame1="fPage0"}   
      
  IF cAction <> "" AND c-nom-prog-upc-mg97 <> "" THEN
      RUN VALUE(c-nom-prog-upc-mg97) (INPUT "leave-cod-matr",
                                      INPUT "",
                                      INPUT THIS-PROCEDURE,
                                      INPUT FRAME fpage0:HANDLE,
                                      INPUT "",
                                      INPUT ?).      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttFicha.cod-matr IN FRAME fpage0 /* cod-matr */
OR "F5":U OF ttFicha.cod-matr IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr017.w"
           &FieldZoom1="cod-matr"
           &FieldScreen1="ttFicha.cod-matr"
           &Frame1="fPage0"
           &FieldZoom2="nom-motoris"
           &FieldScreen2="fiDescMoto"
           &Frame2="fPage0"
           &FieldZoom3="ep-codigo"
           &FieldScreen3="ttFicha.ep-codigo-matr"
           &Frame3="fPage0"           
           &FieldZoom4="cod-estabel"
           &FieldScreen4="ttFicha.cod-estabel-matr"
           &Frame4="fPage0"
           &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-posto wMaintenance
ON LEAVE OF ttAbastec.cod-posto IN FRAME fpage0 /* Posto */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="{&ttTable}.cod-posto:screen-value in frame fPage0"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPosto"
        &Frame1="fPage0"
        &FieldName2="cod-depos"
        &FieldScreen2="fiDeposito"
        &Frame2="fPage0"}
        
    /** Verifica tipo de posto para habilitar em tela bomba **/
    run piBomba in this-procedure.  
    if  (c-nom-prog-upc-mg97 <> "":U) AND
        (trim(cAction) = "ADD":U or trim(cAction) = "COPY":U or trim(cAction) = "UPDATE":U) THEN do:

        /*chama upc da Colombo*/
        ASSIGN &IF "{&mguni_version}" >= "2.071" &THEN
                    i-glob-ep-codigo   = ttAbastec.ep-codigo:SCREEN-VALUE IN FRAME fPage0
               &ELSE
                    i-glob-ep-codigo   = INT(ttAbastec.ep-codigo:SCREEN-VALUE IN FRAME fPage0)
               &ENDIF
               c-glob-cod-eqpto   = ttAbastec.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
               c-glob-cod-posto   = ttAbastec.cod-posto:SCREEN-VALUE IN FRAME fPage0
               c-glob-conta-contabil = fi-ct-codigo:SCREEN-VALUE IN FRAME fPage0
               c-glob-sub-conta   = fi-cc-codigo:SCREEN-VALUE IN FRAME fPage0.

        run value(c-nom-prog-upc-mg97) (input "leave-posto", 
                                        input "",
                                        input THIS-PROCEDURE,
                                        input FRAME fPage0:HANDLE,
                                        input "",
                                        input ?).

        assign fi-ct-codigo:SCREEN-VALUE IN FRAME fPage0 = c-glob-conta-contabil
               fi-cc-codigo:SCREEN-VALUE IN FRAME fPage0 = c-glob-sub-conta.
    end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-posto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.cod-posto IN FRAME fpage0 /* Posto */
OR "F5":U OF {&ttTable}.cod-posto IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="{&ttTable}.cod-posto"
           &Frame1="fPage0"
           &FieldZoom2="des-posto"
           &FieldScreen2="fiDescPosto"
           &Frame2="fPage0"
           &FieldZoom3="cod-depos"
           &FieldScreen3="fiDeposito"
           &Frame3="fPage0"
           &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.cod-refer wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.cod-refer IN FRAME fpage0 /* Referància Item */
OR "F5":U OF {&ttTable}.cod-refer IN FRAME fPage0 DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo={&ttTable}.cod-refer
                    &campozoom=cod-refer
                    &parametros="run pi-seta-inicial in wh-pesquisa
                    ({&tttable}.it-codigo:screen-value in frame fPage0)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-rota wMaintenance
ON LEAVE OF ttFicha.cod-rota IN FRAME fpage0 /* Trajeto */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOTraj"
        &KeyValue1="ttFicha.cod-rota:screen-value in frame fPage0"
        &FieldName1="des-trajeto"
        &FieldScreen1="fiDescTrajeto"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.cod-rota wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttFicha.cod-rota IN FRAME fpage0 /* Trajeto */
OR "F5":U OF ttFicha.cod-rota IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="ttFicha.cod-rota"
           &Frame1="fPage0"
           &FieldZoom2="des-trajeto"
           &FieldScreen2="fiDescTrajeto"
           &Frame2="fPage0"
           &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.dat-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.dat-movto wMaintenance
ON LEAVE OF ttFicha.dat-movto IN FRAME fpage0 /* Data Movimento */
DO:
    IF TRIM(cAction) <> "":U THEN DO: 
        /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
        IF l-usa-unid-negoc THEN
            RUN piValidaMatriz IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.ep-codigo wMaintenance
ON LEAVE OF ttAbastec.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
    if trim(cAction) <> "":U THEN
        APPLY "leave":U TO ttAbastec.cod-posto IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.ep-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.ep-codigo IN FRAME fpage0 /* Empresa */
OR "F5":U OF {&ttTable}.ep-codigo IN FRAME fPage0 DO:
    apply "F5":U to {&ttTable}.cod-eqpto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.ep-codigo-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.ep-codigo-matr wMaintenance
ON F5 OF ttFicha.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5" TO ttFicha.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.ep-codigo-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttFicha.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5" TO ttFicha.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo wMaintenance
ON ENTRY OF fi-cc-codigo IN FRAME fpage0
DO:
  ASSIGN fi-cc-codigo:FORMAT IN FRAME fPage0 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo wMaintenance
ON LEAVE OF fi-cc-codigo IN FRAME fpage0
DO:
    IF fi-cc-codigo:SCREEN-VALUE <> "" THEN
        ASSIGN fi-cc-codigo:FORMAT IN FRAME fPage0 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cc-codigo IN FRAME fpage0
OR "F5":U OF fi-cc-codigo IN FRAME fPage0 DO:
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab  = INPUT FRAME fPage0 ttAbastec.ep-codigo
            dDtMovimento   = INPUT FRAME fPage0 ttFicha.dat-movto
            v_cod_cta_ctbl = INPUT FRAME fPage0 fi-ct-codigo.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN fi-cc-codigo:SCREEN-VALUE IN FRAME fPage0 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenance
ON F5 OF fi-cod-unid-negoc IN FRAME fpage0 /* Unid. Neg¢cio */
DO:
    IF l-usa-unid-negoc THEN     
        &IF DEFINED(bf_mnt_ems206b) &THEN
            {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                                 &FieldZoom1=cod-unid-negoc
                                 &FieldScreen1=fi-cod-unid-negoc
                                 &Frame1=fPage0}
        &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenance
ON LEAVE OF fi-cod-unid-negoc IN FRAME fpage0 /* Unid. Neg¢cio */
DO:
    /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
    IF l-usa-unid-negoc THEN
        RUN piValidaMatriz IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME fpage0 /* Unid. Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wMaintenance
ON ENTRY OF fi-ct-codigo IN FRAME fpage0 /* Cta Cont†bil */
DO:
    ASSIGN fi-ct-codigo:FORMAT IN FRAME fPage0 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wMaintenance
ON LEAVE OF fi-ct-codigo IN FRAME fpage0 /* Cta Cont†bil */
DO:
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 ttAbastec.ep-codigo
            dDtMovimento  = INPUT FRAME fPage0 ttFicha.dat-movto
            c-cod-estabel = "".
        
    FOR LAST mab-histor-ativid WHERE 
             mab-histor-ativid.ep-codigo     = INPUT FRAME fpage0 ttAbastec.ep-codigo AND
             mab-histor-ativid.cod-eqpto     = INPUT FRAME fpage0 ttAbastec.cod-eqpto AND
             mab-histor-ativid.dat-cadastro <= INPUT FRAME fPage0 ttFicha.dat-movto NO-LOCK: 
    END.

    IF  NOT AVAIL mab-histor-ativid THEN DO:
        FOR LAST mab-histor-ativid WHERE 
                 mab-histor-ativid.ep-codigo = INPUT FRAME fpage0 ttAbastec.ep-codigo AND
                 mab-histor-ativid.cod-eqpto = INPUT FRAME fpage0 ttAbastec.cod-eqpto NO-LOCK:
        END.
    END.
        
    IF AVAIL mab-histor-ativid THEN
        ASSIGN c-cod-estabel = mab-histor-ativid.cod-estabel.
                                                
    {cdp/cdunif001a.i fi-ct-codigo fi-cc-codigo fPage0 dDtMovimento cEmpresaEstab c-cod-estabel }
        
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-ct-codigo IN FRAME fpage0 /* Cta Cont†bil */
OR "F5":U OF fi-ct-codigo IN FRAME fPage0 DO:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 ttAbastec.ep-codigo
            dDtMovimento  = INPUT FRAME fPage0 ttFicha.dat-movto.

    assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo       */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem serviáo */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - M∆o-de-obra   */


    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fi-ct-codigo:SCREEN-VALUE IN FRAME fPage0 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.hra-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.hra-final wMaintenance
ON LEAVE OF ttFicha.hra-final IN FRAME fpage0 /* Hora Final */
DO:
    /** Consiste o hor†rio **/
    assign cHora = ttFicha.hra-final:screen-value in frame fPage0.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to ttFicha.hra-final in frame fPage0.
        return no-apply.
    end.
    assign ttFicha.hra-final:screen-value in frame fPage0 = cHora.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.hra-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.hra-inicial wMaintenance
ON LEAVE OF ttFicha.hra-inicial IN FRAME fpage0 /* Hora Inicial */
DO:
    /** Consiste o hor†rio **/
    assign cHora = ttFicha.hra-inicial:screen-value in frame fPage0.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to ttFicha.hra-inicial in frame fPage0.
        return no-apply.
    end.
    assign ttFicha.hra-inicial:screen-value in frame fPage0 = cHora
           ttFicha.hra-final:screen-value in frame fPage0   = cHora.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.it-codigo wMaintenance
ON LEAVE OF ttAbastec.it-codigo IN FRAME fpage0 /* Item */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOItem"
        &KeyValue1="{&tttable}.it-codigo:screen-value in frame fPage0"
        &FieldName1="desc-item"
        &FieldScreen1="fiDescItem"
        &Frame1="fPage0"
        &FieldName2="un"
        &FieldScreen2="fiUNItem"
        &Frame2="fPage0"}
        
        
    if (cAction = "ADD":U    or
        cAction = "UPDATE":U or 
        cAction = "COPY":U)  then do:
        /** Verifica se item est† associado a um tipo de material **/
        if input frame fPage0 {&tttable}.it-codigo <> "" then do:
                   run emptyRowErrors in {&hDBOTable}.
            run validaItem in {&hDBOTable} (input input frame fPage0 {&ttTable}.ep-codigo,
                                            input input frame fPage0 {&ttTable}.cod-eqpto,
                                            input input frame fPage0 {&ttTable}.cod-posto,
                                            input input frame fPage0 {&ttTable}.cod-bomba,
                                            input input frame fPage0 {&tttable}.it-codigo,
                                            input input frame fPage0 ttFicha.dat-movto).
            if return-value = "NOK":U then
                run piMostraErros in this-procedure (input 1).

        end.

            
        /** Procedure que verifica atributos do item **/
        if iTpPosto = 1 then
            run piItem in this-procedure (input input frame fPage0 {&ttTable}.cod-posto,
                                          input cAction).
            
        end.
        ELSE DO:
            FOR FIRST mab-histor-combust
                WHERE mab-histor-combust.ep-codigo = INPUT FRAME fpage0 {&ttTable}.ep-codigo
                  AND mab-histor-combust.cod-eqpto = INPUT FRAME fpage0 {&ttTable}.cod-eqpto
                  AND mab-histor-combust.dat-desativ <> ?
                  AND mab-histor-combust.idi-tip-consu > 1 NO-LOCK:
                ASSIGN cTipoMaterial = mab-histor-combust.cod-tip-mater.
            END.

        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.it-codigo IN FRAME fpage0 /* Item */
OR "F5":U OF {&tttable}.it-codigo IN FRAME fPage0 DO:
  if iTpPosto = 1 then do:
      apply "CHOOSE":U to menu-item miMaterial in menu pop-item.
  end.
  else do: 
      apply "CHOOSE":U to menu-item miItem in menu pop-item.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.lote wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAbastec.lote IN FRAME fpage0 /* Lote */
OR "F5":U OF {&ttTable}.lote IN FRAME fPage0 DO:
    if {&ttTable}.lote:read-only then
    return "OK".

  ASSIGN c-it-codigo = {&tttable}.it-codigo:screen-value IN FRAME fPage0
         c-estab     = "".

        {include/zoomvar.i
          &prog-zoom="inzoom/z02in403.w"
          &campo={&ttTable}.lote
          &campozoom=lote}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miItem wMaintenance
ON CHOOSE OF MENU-ITEM miItem /* Pesquisa Itens */
DO:
        {method/zoomfields.i 
           &ProgramZoom="inzoom/z20in172.w"
           &FieldZoom1="it-codigo"
           &FieldScreen1="{&tttable}.it-codigo"
           &Frame1="fPage0"
           &FieldZoom2="desc-item"
           &FieldScreen2="fiDescItem"
           &Frame2="fPage0"
           &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMaterial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMaterial wMaintenance
ON CHOOSE OF MENU-ITEM miMaterial /* Pesquisa Itens do Tipo Material */
DO:
   assign cTipoMaterial = "".
    IF iTpPosto = 1 THEN DO:
        for first mab-bomba fields(cod-tip-mater)
            where mab-bomba.cod-posto = input frame fPage0 {&ttTable}.cod-posto
            and   mab-bomba.cod-bomba = input frame fPage0 {&ttTable}.cod-bomba no-lock:
            assign cTipoMaterial = mab-bomba.cod-tip-mater.
        end.
    END.
    ELSE DO:
        FOR FIRST mab-histor-combust
            WHERE mab-histor-combust.ep-codigo = INPUT FRAME fpage0 {&ttTable}.ep-codigo
              AND mab-histor-combust.cod-eqpto = INPUT FRAME fpage0 {&ttTable}.cod-eqpto
              AND mab-histor-combust.dat-desativ = ?
              AND mab-histor-combust.idi-tip-consu > 1 NO-LOCK:
            ASSIGN cTipoMaterial = mab-histor-combust.cod-tip-mater.
        END.
    END.
     {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr027.w"
           &FieldZoom1="it-codigo"
           &FieldScreen1="{&tttable}.it-codigo"
           &Frame1="fPage0"
           &FieldZoom2="desc-item"
           &FieldScreen2="fiDescItem"
           &Frame2="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miSaldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miSaldo wMaintenance
ON CHOOSE OF MENU-ITEM miSaldo /* Pesquisa Saldo Estoque */
DO:
  {include/zoomvar.i
    &prog-zoom="inzoom/z01in403.w"
    &campo={&tttable}.it-codigo
    &campozoom=it-codigo
    &frame=fPage0
    &campo2=fiDescItem
    &campozoom2=desc-item
    &frame2=fPage0}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttFicha.nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFicha.nr-nota-fis wMaintenance
ON ANY-KEY OF ttFicha.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
DO:
    iKey = LASTKEY.
    IF NOT ((iKey >= 48 AND iKey <= 57) OR iKey = 8 OR iKey = 9 OR iKey = 127) THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbastec.val-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbastec.val-quant wMaintenance
ON LEAVE OF ttAbastec.val-quant IN FRAME fpage0 /* Qtd Combust°vel */
DO:
    if ttFicha.idi-integr = 1  then do:
        run piPrecoItem in this-procedure (input input frame fPage0 {&ttTable}.cod-posto).
        if return-value = "OK":U then do:
            assign {&ttTable}.val-mater-1 = input frame fPage0 {&ttTable}.val-quant * dePrecoMater.
            display {&ttTable}.val-mater-1 with frame fPage0.
        end.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

{abp/ab9000.i}         /** Procedure buscaFormatoConta **/
{abp/ab9001.i}         /** piConverteMoeda  **/
{abp/ab0302.i fPage0}  /** Procedure piItem **/
/* {abp/ab0302.i2 fPage0}  /** Procedure piItemTermino **/  */
{abp/abapi001.i2}      /** Criaá∆o de Erros **/
{abp/ab9005.i}         /** Validaá∆o de ParÉmetros **/


&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN
        fi-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Ficha Apontamento **/
if valid-handle(hDBOFicha) then
    run Destroy in hDBOFicha.
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Atividade **/
if valid-handle(hDBOAtiv) then
    run Destroy in hDBOAtiv.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.
/** Trajeto **/
if valid-handle(hDBOTraj) then
    run Destroy in hDBOTraj.
/** Item **/
if valid-handle(hDBOItem) then
    run Destroy in hDBOItem.
IF  VALID-HANDLE(hDBOApi003a) THEN DO:
    DELETE PROCEDURE hDBOApi003a.
    ASSIGN hDBOApi003a = ?.
END.
/** Historico **/
IF VALID-HANDLE(hDBOHistor) THEN
    RUN Destroy IN hDBOHistor.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN
            ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage0 = NO. 
    &ELSE
        ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage0 = NO.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/

    /** Mostra Status da Ficha de Abastc/Lubrific **/
    RUN piStatus IN THIS-PROCEDURE.

        if not avail {&ttTable} then do:
                return "OK":U.
        end.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    ASSIGN  cEmpresaEstab = ttAbastec.ep-codigo:SCREEN-VALUE IN FRAME fPage0
            dDtMovimento  = IF ttFicha.dat-movto:SCREEN-VALUE IN FRAME  fPage0 <> "" THEN INPUT FRAME fPage0 ttFicha.dat-movto ELSE TODAY.
    
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,  /* EMPRESA EMS2 */
                                                   INPUT "",          /* PLANO CCUSTO */
                                                   INPUT dDtMovimento,               /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto,      /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    
    
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpresaEstab,
                                                       INPUT "",
                                                       INPUT dDtMovimento,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DELETE OBJECT h_api_cta_ctbl.

    {cdp/cdunif001b.i}
        

    /* Alimenta os campo de conta e centro de custo com base na ficha de abastecimento */
    ASSIGN fi-ct-codigo = ttFicha.ct-codigo
           fi-cc-codigo = ttFicha.cc-codigo.
    /* Quando paramentro 55 = sim Alimenta os campo de conta e centro de custo com base no item de abastecimento */
    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF  mab-param.des-valor = "1" THEN DO:
            /* Alimenta os campo de conta e centro de custo com base no item abastecimento */
            ASSIGN fi-ct-codigo = {&ttTable}.cod-cta-ctbl
                   fi-cc-codigo = {&ttTable}.cod-ccusto.
        END.
    END.

    /* atualiza SCREEN-VALUE */
   ASSIGN fi-ct-codigo:SCREEN-VALUE IN FRAME fPage0 = fi-ct-codigo
          fi-cc-codigo:SCREEN-VALUE IN FRAME fPage0 = fi-cc-codigo.

    ASSIGN fi-ct-codigo:FORMAT IN FRAME fPage0 = IF fi-ct-codigo:SCREEN-VALUE <> "" THEN p_cod_format_cta_ctbl  ELSE "x(20)"
           fi-cc-codigo:FORMAT IN FRAME fPage0 = IF fi-cc-codigo:SCREEN-VALUE <> "" THEN p_cod_format_ccusto    ELSE "x(20)".

    /** Descriá‰es dos campos **/
    APPLY "LEAVE":U TO {&ttTable}.cod-eqpto   IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.cod-posto   IN FRAME fPage0.
    APPLY "LEAVE":U TO ttFicha.cod-matr       IN FRAME fPage0.
    APPLY "LEAVE":U TO ttFicha.cod-ativid     IN FRAME fPage0.
    APPLY "LEAVE":U TO ttFicha.cod-rota       IN FRAME fPage0.
    APPLY "LEAVE":U TO {&tttable}.it-codigo   IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.cod-localiz IN FRAME fPage0.

    RUN piValidaContadorSec IN THIS-PROCEDURE.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = ttFicha.cod-unid-negoc.

            /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
            RUN piValidaMatriz IN THIS-PROCEDURE.
        END.
    &ELSE
        ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = ttFicha.cod_unid_negoc.
    &ENDIF

    ENABLE {&ttTable}.lote with frame fPage0.
    ASSIGN {&ttTable}.lote:READ-ONLY IN FRAME fPage0 = YES
           {&ttTable}.lote:BGCOLOR = 17.

           ttAbastec.lote:LOAD-MOUSE-POINTER("")        in frame fPage0.


        RETURN "OK":U. 
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     afterEnableFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/
if cAction = "COPY":U then
    assign {&ttTable}.r-rowid = ?.

if cAction = "ADD":U or
   cAction = "COPY":U then do:
    /** Busca a numeraá∆o do Apontamento **/
    run buscaDocumento in hDBOFicha (output {&ttTable}.num-docto).
    /** Data Atual **/
    assign ttFicha.cod-usuar    = c-seg-usuario
           ttFicha.idi-consist  = 1
           ttFicha.idi-integr   = 1
           {&ttTable}.nr-trans  = 0
           ttFicha.log-consist  = no
           ttFicha.dat-movto    = dtHoraIni
           {&ttTable}.ep-codigo = iEmpresaGlob
           ttFicha.dat-livre-1  = today
           ttFicha.dat-livre-2  = ?
           ttFicha.cod-livre-1  = "".

    display ttFicha.dat-movto
            ttFicha.cod-usuar
            {&ttTable}.ep-codigo
            ttFicha.idi-integr
            ttFicha.dat-livre-1
            ttFicha.dat-livre-2
            ttFicha.cod-livre-1
        with frame fPage0.
    /** Hora Atual **/
    run piMostraHorario in this-procedure.

    ASSIGN {&ttTable}.lote:READ-ONLY IN FRAME fPage0 = NO
           {&ttTable}.lote:BGCOLOR = ?.

           ttAbastec.lote:LOAD-MOUSE-POINTER("image/lupa.cur":U)        in frame fPage0.
END.

assign {&ttTable}.num-docto:sensitive in frame fPage0 = no
       ttFicha.cod-usuar:sensitive    in frame fPage0 = no
       ttFicha.dat-livre-1:sensitive  in frame fPage0 = no
       ttFicha.dat-livre-2:sensitive  in frame fPage0 = no
       ttFicha.cod-livre-1:sensitive  in frame fPage0 = no.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN
        ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage0 = YES.
&ELSE
    ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage0 = YES.
&ENDIF

/** Mostra Status da Ficha de Abastc/Lubrific **/
run piStatus in this-procedure.

/** Mostra documento em tela **/
display {&ttTable}.num-docto
    with frame fPage0.

apply "LEAVE":U to {&tttable}.it-codigo   in frame fPage0.

/** Mostra campos conforme parÉmetros do m¢dulo **/
run piParametros in this-procedure.
/** Verifica se ficha n∆o est† integrada com estoque **/
run piIntegracaoEMS in this-procedure.
/**Desabilita o campo de intagraá∆o durante a alteraá∆o**/
ASSIGN ttFicha.idi-integr:SENSITIVE IN FRAME fpage0 = NO.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o de tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Equipamento"}
assign {&ttTable}.ep-codigo:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Conta"}
assign fi-ct-codigo:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Status"}
assign fiStatus:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Data"}
assign ttFicha.dat-livre-1:label in frame fPage0 = trim(return-value).
assign ttFicha.dat-livre-2:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Usu†rio"}
assign ttFicha.cod-usuar:label in frame fPage0 = trim(return-value).
assign ttFicha.cod-livre-1:label in frame fPage0 = trim(return-value).

/** Busca os formatos da conta e sub-conta **/
EMPTY TEMP-TABLE tt_log_erro.

assign dtHoraIni                                = today.

IF AVAIL ttAbastec THEN DO:
    FOR FIRST mab-eqpto
        WHERE mab-eqpto.cod-eqpto = ttAbastec.cod-eqpto 
        AND   mab-eqpto.ep-codigo = ttAbastec.ep-codigo NO-LOCK:
        ASSIGN tg-rastreamento:CHECKED IN FRAME fPage0 = mab-eqpto.log-livre-1.
    END.
END.

/** Verifica integraá∆o com rastreamento **/
for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
    {utp/ut-liter.i Sim}
    if entry(4,mab-param-integr.des-valor) = return-value then do:
        assign btIntegraXML:visible in frame fPage0    = yes
               btIntegraXML:sensitive in frame fPage0  = YES
               tg-rastreamento:visible in frame fPage0 = YES.
    end.
    else do:
        assign btIntegraXML:visible in frame fPage0    = no
               btIntegraXML:sensitive in frame fPage0  = NO
               tg-rastreamento:visible in frame fPage0 = no.
    end.
end.

if not avail mab-param-integr then do:
    assign btIntegraXML:visible in frame fPage0    = no
           btIntegraXML:sensitive in frame fPage0  = no
           tg-rastreamento:visible in frame fPage0 = no.
end.

ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       btMatriz:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc.

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatriz:TOOLTIP IN FRAME fPage0 = "":U.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN fi-cod-unid-negoc:VISIBLE IN FRAME fPage0 = l-usa-unid-negoc.
&ENDIF

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenance 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeDisplayFields
  Parameters:  <none>
  Notes:       Override antes de mostrar os campos em tela
------------------------------------------------------------------------------*/
case cAction:
    /** Inclus∆o **/
    when "ADD":U then do:
        /** Deve-se abrir a query para reposicionamento **/
        run openQueryStatic in hDBOFicha (input "Main":U).
        /*--- Cria novo registro para temp-table ttFicha no DBO ---*/
        RUN newRecord IN hDBOFicha.
        /*--- Retorna registro da temp-table ttFicha do DBO ---*/
        RUN getRecord IN hDBOFicha (OUTPUT TABLE ttFicha).
    end.
    /** C¢pia **/
    when "COPY":U then do:
        /** Deve-se abrir a query para reposicionamento **/
        run openQueryStatic in hDBOFicha (input "Main":U).
        /** Posiciona o registro na BO **/
        run repositionRecord in hDBOFicha (input ttFicha.r-rowid).
    end.
    /** Alteraá∆o **/
    when "UPDATE":U then do:
        /** Utiliza o registro de tela **/
    end.
    /** Navegaá∆o **/
    otherwise do:
        if avail {&ttTable} then do:
            /** Limpa temp do programa **/
            empty temp-table ttFicha.
            /** Seta as restriá‰es pelo n£mero do documento da tabela filha **/
            run setConstraintDocumento in hDBOFicha (input {&ttTable}.num-docto,
                                                     input {&ttTable}.num-docto).
            /** Abre a query conforme o n£mero do documento do filho **/
            run openQueryStatic in hDBOFicha (input "Documento":U).
            /** Posiciona BO no registro **/
            run getFirst in hDBOFicha.
            /*--- Retorna registro da temp-table ttFicha do DBO ---*/
            RUN getRecord IN hDBOFicha (OUTPUT TABLE ttFicha).
        end.
        else do:
            empty temp-table ttFicha.
            /** N∆o h† registros para serem mostrados, ent∆o mostra registro em branco **/
            create ttFicha.
        end.
    end.
end case.
/** Deixa registro ativo **/
find first ttFicha no-lock no-error.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de iniciar o programa
------------------------------------------------------------------------------*/
/*Abastecimento*/
run cdp/cd9902.p (input 1).
if return-value = "NOK":U then do:
   {utp/ut-liter.i "Abastecimento" * r}
   run piCriaErro in this-procedure (input 2082, 
                                     input "EMS":U,
                                     input return-value).
   run piMostraErros (3).
   return "NOK":U.
end.


/** Valida se os par∆metros est∆o cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "7,8,9,10,11,30":U,
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
/** Busca a Empresa Principal dos ParÉmetros Globais **/
for first param-global fields(empresa-prin) no-lock:
    assign iEmpresaGlob = param-global.empresa-prin.
end.

ttAbastec.ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttAbastec.cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttAbastec.cod-posto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttFicha.ep-codigo-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttFicha.cod-estabel-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
ttFicha.cod-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage0.
ttFicha.cod-ativid:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage0.
ttFicha.cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage0.
fi-ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage0.
fi-cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage0.
ttAbastec.cod-bomba:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttAbastec.it-codigo:load-mouse-pointer("image/rbm.cur":u)    in frame fPage0.
ttAbastec.cod-refer:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
ttAbastec.cod-localiz:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
ttAbastec.lote:LOAD-MOUSE-POINTER("image/lupa.cur":U)        in frame fPage0.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override (antes) de salvar dados em tabela
------------------------------------------------------------------------------*/

/** Busca Valores para Moedas Alternativas **/
run piConverteMoeda in this-procedure (input  input frame fPage0 {&ttTable}.val-mater-1,
                                       output {&ttTable}.val-mater-2,
                                       output {&ttTable}.val-mater-3,
                                       input  input frame fPage0 ttFicha.dat-movto).


/* Grava Contas da ficha de abastecimento na conta informada em tela */
ASSIGN ttFicha.ct-codigo             = INPUT FRAME fPage0 fi-ct-codigo
       ttFicha.cc-codigo             = INPUT FRAME fPage0 fi-cc-codigo
       /* As variaveis abaixo est∆o alimentadas em branco como default no entando se o parametro 55 for verdadeiro as mesma iram receber o devido valor no bloco abaixo */
       ttFicha.cod-cta-ctbl-lubrific = ""
       ttFicha.cod-ccusto-lubrific   = ""
       {&ttTable}.cod-cta-ctbl       = ""
       {&ttTable}.cod-ccusto         = "".

/*  quando o parametro 55 estiver como sim, as informaá‰es de contas da ficha ser† igual a do historico de estabelecimento do equipamento.
    A conta de abastecimento informada em tela ser† gravada a nivel de item */
FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF  mab-param.des-valor = "1" THEN DO:
        IF  cContLub = "" THEN DO:
            /** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
            run buscaAtividade in hDBOFicha (input  input frame fPage0 {&ttTable}.ep-codigo,
                                             input  input frame fPage0 {&ttTable}.cod-eqpto,
                                             input  input frame fPage0 ttFicha.dat-movto,
                                             output c-cod-ativid,
                                             output cConta,
                                             output cSub,
                                             output cCodUnidNegoc,
                                             OUTPUT cContLub,
                                             OUTPUT cCCustoLub,
                                             OUTPUT cEstabelHist).
        END.

        /* Grava Contas da Ficha com base no Hist¢rico. */
        ASSIGN ttFicha.ct-codigo             = cConta
               ttFicha.cc-codigo             = cSub
               ttFicha.cod-cta-ctbl-lubrific = cContLub
               ttFicha.cod-ccusto-lubrific   = cCCustoLub.

        /* Grava Contas da mab-item-abastec com base na conta informada em tela */
        ASSIGN {&ttTable}.cod-cta-ctbl       = INPUT FRAME fPage0 fi-ct-codigo
               {&ttTable}.cod-ccusto         = INPUT FRAME fPage0 fi-cc-codigo.

    END.
END.

if cAction <> "UPDATE":U then
    assign dtHoraIni = input frame fPage0 ttFicha.dat-movto.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMaintenance 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method/referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttTable}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttTable}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consisteAbastecimento wMaintenance 
PROCEDURE consisteAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     consisteAbastecimento
  Parameters:  <none>
  Notes:       Validaá‰es / consistàncias no registro
------------------------------------------------------------------------------*/
define variable deTanque as decimal no-undo.
DEFINE VARIABLE cLocalXmlGerado AS CHARACTER FORMAT "x(200)" NO-UNDO.

/** Busca Tipo Material e Flag de Abastecimento Prim†rio **/
run buscaTipoMaterial in {&hDBOTable} (input  input frame fPage0 {&ttTable}.ep-codigo,
                                       input  input frame fPage0 {&ttTable}.cod-eqpto,
                                       input  input frame fPage0 {&tttable}.it-codigo,
                                       input  input frame fPage0 ttFicha.dat-movto,
                                       output {&ttTable}.cod-tip-mater,
                                       output {&ttTable}.log-abastec-prim,
                                       output deTanque).
/** Verifica capacidade do tanque **/
if deTanque < input frame fPage0 {&ttTable}.val-quant then do:
    {utp/ut-liter.i "Tanque"}
    run utp/ut-msgs.p (input "SHOW":U,
                       input 28612,
                       input return-value + '~~' + string(deTanque)).
    /** Se usu†rio n∆o concordar com a quantidade, desfaz **/
    if return-value = "NO":U then do:
        apply "ENTRY":U to {&ttTable}.val-quant in frame fPage0.
        RUN getLocalXmlGerado IN hDBOFicha (OUTPUT cLocalXmlGerado).
        IF  SEARCH(cLocalXmlGerado) <> ? THEN
            OS-DELETE VALUE(cLocalXmlGerado). /*"C:~\bases~\EXP~\abastec20080219085544.xml".*/ 
        return "NOK":U.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE iDocumento LIKE {&ttTable}.num-docto NO-UNDO.
    DEFINE VARIABLE cPosto     LIKE {&ttTable}.cod-posto NO-UNDO.
    DEFINE VARIABLE cBomba     LIKE {&ttTable}.cod-bomba NO-UNDO.
    DEFINE VARIABLE cItem      LIKE {&tttable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        iDocumento        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cPosto            AT ROW 2.21 COL 17.72 COLON-ALIGNED
        cBomba            AT ROW 3.21 COL 17.72 COLON-ALIGNED
        cItem             AT ROW 4.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 5.63 COL 2.14
        btGoToCancel      AT ROW 5.63 COL 13
        rtGoToButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V†_Para_Abastecimento *}
    assign frame fGoToRecord:title = return-value.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iDocumento cPosto cBomba cItem.
        
        RUN goToKey IN {&hDBOTable} (INPUT iDocumento, 
                                     INPUT cPosto,
                                     INPUT cBomba,
                                     INPUT cItem).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Item Abastecimento"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT trim(return-value)).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iDocumento cPosto cBomba cItem btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose: Inicializa DBOs
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
        run frbo/bofr057.p persistent set {&hDBOTable}.
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    /** Seta o programa que chamou a BO, utilizado para eliminaá∆o do registro 
        da "mab-abastec-lubrific", ap¢s a eliminaá∆o do "mab-item-abastec" **/
    run setaPrograma in {&hDBOTable} (input "AB0306":U).

    /*:T--- BO de Ficha Abates/Lubrific ---*/
    IF NOT VALID-HANDLE(hDBOFicha) OR
       hDBOFicha:TYPE <> "PROCEDURE":U OR
       hDBOFicha:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOFicha.
    END.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.

    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.

    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.

    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
        run frbo/bofr001.p persistent set  hDBOAtiv.
    END.

    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMoto.
    END.

    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Trajeto  ---*/
    IF NOT VALID-HANDLE(hDBOTraj) OR
       hDBOTraj:TYPE <> "PROCEDURE":U OR
       hDBOTraj:FILE-NAME <> "frbo/bofr028.p":U THEN DO:
        run frbo/bofr028.p persistent set  hDBOTraj.
    END.

    RUN openQueryStatic IN hDBOTraj (INPUT "Main":U) NO-ERROR.

    /*--- DBO Item ---*/
    IF NOT VALID-HANDLE(hDBOItem) OR
       hDBOItem:TYPE <> "PROCEDURE":U OR
       hDBOItem:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        run inbo/boin172.p persistent set  hDBOItem.
    END.

    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.

    /*--- DBO Historico Atividade ---*/
    IF NOT VALID-HANDLE(hDBOHistor)      OR
        hDBOHistor:TYPE <> "PROCEDURE":U OR
        hDBOHistor:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        RUN frbo/bofr013.p PERSISTENT SET hDBOHistor.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtividade wMaintenance 
PROCEDURE piAtividade :
/*------------------------------------------------------------------------------
  Purpose:     piAtividade
  Parameters:  <none>
  Notes:       Busca Atividade e Conta Corrente do hist¢rico Atividade do Eqpto
------------------------------------------------------------------------------*/

/** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
run buscaAtividade in hDBOFicha (input  input frame fPage0 {&ttTable}.ep-codigo,
                                 input  input frame fPage0 {&ttTable}.cod-eqpto,
                                 input  input frame fPage0 ttFicha.dat-movto,
                                 output ttFicha.cod-ativid,
                                 output cConta,
                                 output cSub,
                                 output cCodUnidNegoc,
                                 OUTPUT cContLub,
                                 OUTPUT cCCustoLub,
                                 OUTPUT cEstabelHist).

ASSIGN fi-ct-codigo = cConta
       fi-cc-codigo = cSub.

/** Verifica se Atividade deve ser informada **/
if not(ttFicha.cod-ativid:sensitive in frame fPage0) then do:
    if return-value = "OK":U then do:
        /** Mostra Campo em tela **/
        display ttFicha.cod-ativid
            with frame fPage0.
        apply "LEAVE":U to ttFicha.cod-ativid in frame fPage0.
    end.
end.

/** Mostra Campos em tela **/
display fi-ct-codigo fi-cc-codigo
    with frame fPage0.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        ASSIGN fi-cod-unid-negoc = cCodUnidNegoc.

        DISPLAY fi-cod-unid-negoc
            WITH FRAME fPage0.
    END.
&ELSE
    ASSIGN fi-cod-unid-negoc = cCodUnidNegoc.

    DISPLAY fi-cod-unid-negoc
        WITH FRAME fPage0.
&ENDIF

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizacao wMaintenance 
PROCEDURE piAtualizacao :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizacao
  Parameters:  entrada pAcao = Aá∆o (1 = Inclu∆o/Alteraá∆o / 2 = Eliminaá∆o)
  Notes:       Chama a API de Atualizaá∆o das fichas de abastecimento/lubrificaá∆o
------------------------------------------------------------------------------*/
define input parameter pAcao as integer no-undo.

/*Quando exclu°da a ficha, prepara para a atualizaá∆o dos pneus*/
IF pAcao = 2 THEN DO:
    FOR EACH mab-param FIELDS (des-valor cdn-param)
       WHERE mab-param.cdn-param = 25 
          OR mab-param.cdn-param = 26  
          OR mab-param.cdn-param = 49  NO-LOCK:
        CASE mab-param.cdn-param:
            WHEN 25 THEN
                ASSIGN param25 = mab-param.des-valor. 
            WHEN 26 THEN
                ASSIGN param26 = mab-param.des-valor. 
            WHEN 49 THEN
                ASSIGN param49 = mab-param.des-valor. 
        END CASE.
    END.
         
    IF param25 = "1" AND param26 = "1" AND param49 = "1" THEN 
        RUN piAtualizaPneu IN THIS-PROCEDURE.
END.
    
if can-find(first mab-param /*ParÉmetro 11 - Consiste Ficha*/
            where mab-param.cdn-param = 11 no-lock) then do:
    for first mab-param fields(des-valor)
        where mab-param.cdn-param = 11 no-lock:
        if mab-param.des-valor = '1':U then do: /*1 - Online, 2 - Batch*/
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
            if pAcao = 1 then
                if trim(cAction) = "":U then
                    /* Reposiciona registro com base em um rowid */
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT {&ttTable}.r-rowid).
                else 
                    /** Foco Inicial na Data **/
                    apply "ENTRY":U to ttFicha.dat-movto in frame fPage0.
        end.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaPneu wMaintenance 
PROCEDURE piAtualizaPneu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Para exclus∆o n∆o Ç necess†rio validar se a ficha est† integrada ou n∆o*/
FIND FIRST tt-param NO-LOCK NO-ERROR.

/*Verifica os pneus no equipamento*/
FOR EACH mpn-pneu FIELDS(cod-eqpto-inicial cod-eqpto-atual ep-codigo-atual cod-pneu)
   WHERE mpn-pneu.ep-codigo-atual   >= tt-param.iEmpIni
     AND mpn-pneu.ep-codigo-atual   <= tt-param.iEmpFim
     AND mpn-pneu.cod-eqpto-atual   >= tt-param.cEqptoIni
     AND mpn-pneu.cod-eqpto-atual   <= tt-param.cEqptoFim
     AND mpn-pneu.cod-estabel-atual >= tt-param.cEstabIni
     AND mpn-pneu.cod-estabel-atual <= tt-param.cEstabFim NO-LOCK:

    EMPTY TEMP-TABLE tt-param-aux.
    /*Criaá∆o da tt-param que ser† enviada para a pnapi002. Esta temp-table ser† criada para cada */    
    /*pneu atual do equipamento                                                                   */
    CREATE tt-param-aux.
    ASSIGN tt-param-aux.destino   = tt-param.destino
           tt-param-aux.arquivo   = tt-param.arquivo 
           tt-param-aux.usuario   = tt-param.usuario    
           tt-param-aux.data-exec = tt-param.data-exec  
           tt-param-aux.hora-exec = tt-param.hora-exec  
           tt-param-aux.empIni    = tt-param.iEmpIni  
           tt-param-aux.empFim    = tt-param.iEmpFim  
           tt-param-aux.eqptoIni  = tt-param.cEqptoIni
           tt-param-aux.eqptoFim  = tt-param.cEqptoFim
           tt-param-aux.estabIni  = tt-param.cEstabIni
           tt-param-aux.estabFim  = tt-param.cEstabFim
           tt-param-aux.pneuIni   = mpn-pneu.cod-pneu 
           tt-param-aux.pneuFim   = mpn-pneu.cod-pneu 
           tt-param-aux.tag-ini   = tt-param.cTagIni 
           tt-param-aux.tag-fim   = tt-param.cTagFim 
           tt-param-aux.cc-ini    = tt-param.cCCini 
           tt-param-aux.cc-fim    = tt-param.cCCfim 
           tt-param-aux.dataIni   = (TODAY - 30)
           tt-param-aux.numDias   = 30 
           tt-param-aux.rRowid    = ?.
    /** Roda API geraá∆o KM **/
    RUN pnp/pnapi002.p (INPUT  TABLE tt-param-aux,
                        OUTPUT TABLE RowErrorsAux).

    /** Verifica se ocorreram erros **/
    IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
        FOR LAST RowErrors NO-LOCK:
            ASSIGN iErro = RowErrors.ErrorSequence.
        END.
    END.
    ELSE 
        ASSIGN iErro = 0.
    FOR EACH RowErrorsAux NO-LOCK:
        ASSIGN iErro = iErro + 1.
        CREATE RowErrors.
        BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
            ASSIGN RowErrors.ErrorSequence = iErro.
    END.
END.

RETURN "OK":U.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBomba wMaintenance 
PROCEDURE piBomba :
/*------------------------------------------------------------------------------
  Purpose:     piBomba
  Parameters:  <none>
  Notes:       Verifica tipo de posto para habilitar em tela bomba
               Obs: Se for de terceiro, deve-se gravar campo em branco,
                    Se for pr¢prio, deve-se deixar habilitado em tela para
                    o usu†rio informar.
------------------------------------------------------------------------------*/
/** Verifica se posto Ç pr¢prio ou de terceiro **/
run buscaTipoPosto in {&hDBOTable} (input  {&ttTable}.cod-posto:screen-value in frame fPage0,
                                    output iTpPosto).

if trim(cAction) <> "":U then do:
    case iTpPosto:
        /** Terceiro **/
        when 2 then do:
            assign {&ttTable}.cod-bomba = ""
                   {&ttTable}.cod-bomba:sensitive in frame fPage0   = no
                   {&ttTable}.cod-localiz = ""
                   {&ttTable}.cod-localiz:sensitive in frame fPage0 = no
                   {&ttTable}.cod-refer = ""
                   {&ttTable}.cod-refer:sensitive in frame fPage0   = no
                   {&ttTable}.lote = ""
                   {&ttTable}.lote:sensitive in frame fPage0        = no
                   {&ttTable}.val-mater-1:sensitive in frame fPage0 = yes
                   {&ttTable}.val-quant:sensitive in frame fPage0   = yes.
            if cAction = "ADD":U or
               cAction = "COPY":U then do:
                assign {&ttTable}.val-mater-1 = 0
                       {&ttTable}.val-quant = 0.
            end.
            apply "LEAVE":U to {&ttTable}.cod-bomba in frame fPage0.
            display {&ttTable}.cod-bomba
                    {&ttTable}.cod-localiz 
                    {&ttTable}.cod-refer 
                    {&ttTable}.lote 
                    {&ttTable}.val-mater-1 
                    {&ttTable}.val-quant
                with frame fPage0.
        end.
        /** Pr¢prio **/
        otherwise
            assign {&ttTable}.cod-bomba:sensitive in frame fPage0   = yes
                   {&ttTable}.cod-localiz:sensitive in frame fPage0 = yes
                   {&ttTable}.cod-refer:sensitive in frame fPage0   = yes
                   {&ttTable}.lote:sensitive in frame fPage0        = yes
                   {&ttTable}.val-mater-1:sensitive in frame fPage0 = yes
                   {&ttTable}.val-quant:sensitive in frame fPage0   = yes.
    end case.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHodometro wMaintenance 
PROCEDURE piHodometro :
/*------------------------------------------------------------------------------
  Purpose:     piHodometro
  Parameters:  <none>
  Notes:       Verifica se hodìmetro est† com valor correto
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-sec-aux AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-texto   AS CHARACTER  NO-UNDO.

/** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida in hDBOFicha (input  string(input frame fPage0 ttFicha.dat-movto,"99/99/9999"),
                                            input  input frame fPage0 ttFicha.hra-inicial,
                                            output ttFicha.val-dat-hora-invrtda).

/** Busca ultimo apontamento para verificar se hodìmetro est† menor **/
run buscaUltimoApontamento in hDBOFicha (input ttFicha.r-rowid,
                                         input ttFicha.val-dat-hora-invrtda,
                                         input input frame fPage0 {&ttTable}.ep-codigo,
                                         input input frame fPage0 {&ttTable}.cod-eqpto,
                                         input input frame fPage0 ttFicha.val-hodom-horim,
                                         input input frame fPage0 ttFicha.val-hodom-horim-sec,
                                         OUTPUT l-sec-aux).
if return-value = "MENOR":U then do:
    ASSIGN c-texto = "".
    IF l-sec-aux THEN DO:
        {utp/ut-liter.i "Secund†rio"}
        ASSIGN c-texto = RETURN-VALUE.
    END.
    run utp/ut-msgs.p (input "SHOW":U,
                       input 28449,
                       input c-texto).
    if return-value = "NO" then
        return "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracaoEMS wMaintenance 
PROCEDURE piIntegracaoEMS :
/*------------------------------------------------------------------------------
  Purpose:     piIntegracaoEMS
  Parameters:  <none>
  Notes:       Verifica se o apontamento est† integrado com o almoxarifado.
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-altera AS LOGICAL    NO-UNDO.

if cAction = "UPDATE":U then do:
    /** Verifica integraá∆o com EMS **/
    run buscaIntegracao in hDBOFicha.
    if return-value = "NOK":U then do:
        ASSIGN l-altera = NO.
        FOR FIRST mab-param fields(des-valor cdn-param)
            where mab-param.cdn-param = 44 no-lock:
            ASSIGN l-altera = if mab-param.des-valor = "1" 
                              then yes
                              else no.
        END.
        disable {&page0Fields} with frame fPage0.
        assign ttFicha.hra-inicial:sensitive         in frame fPage0 = yes
               ttFicha.hra-final:sensitive           in frame fPage0 = yes
               ttFicha.val-hodom-horim:sensitive     in frame fPage0 = yes
               ttFicha.val-hodom-horim-sec:sensitive in frame fPage0 = yes
               ttFicha.cod-ativid:sensitive          in frame fPage0 = l-altera
               ttFicha.cod-rota:sensitive            in frame fPage0 = l-altera
               ttFicha.ep-codigo-matr:sensitive      in frame fPage0 = l-altera
               ttFicha.cod-estabel-matr:sensitive    in frame fPage0 = l-altera
               ttFicha.cod-matr:sensitive            in frame fPage0 = l-altera.

        IF l-usa-unid-negoc THEN
            ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage0 = NO.

        IF l-altera THEN DO:
            RUN piparametros IN THIS-PROCEDURE.
        END.
        /** Mostra erros em tela **/
        run piMostraErros in this-procedure (input 2).
        return "NOK":U.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenance 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  entrada pOrig = Origem dos erros (1 = Item Abast / 2 = Ficha)
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
define input parameter pOrig as integer no-undo.

if pOrig <> 3 then
   empty temp-table RowErrors.

/** Instancia aplicativo **/
{method/showmessage.i1}

if pOrig = 1 then do:
    /** Busca erros na BO **/
    run getRowErrors in {&hDBOTable} (output table RowErrors).
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in {&hDBOTable}.
end.
if pOrig = 2 then do:
    /** Busca erros na BO **/
    run getRowErrors in hDBOFicha (output table RowErrors).
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOFicha.
end.
if pOrig = 3 then do:
   /** Mostra caixa com erros **/
   {method/showmessage.i2 &Modal="YES"}
end.

empty temp-table RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraHorario wMaintenance 
PROCEDURE piMostraHorario :
/*------------------------------------------------------------------------------
  Purpose:     piMostraHorario
  Parameters:  <none>
  Notes:       Busca hora atual e mostra em tela
------------------------------------------------------------------------------*/

/** Busca a hora atual **/
run piFormataSegundoParaHora (input  time,
                              output ttFicha.hra-inicial).
run piFormataSegundoParaHora (input  time,
                              output ttFicha.hra-final).

disp ttFicha.hra-inicial
     ttFicha.hra-final
    with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametroAPI wMaintenance 
PROCEDURE piParametroAPI :
/*------------------------------------------------------------------------------
  Purpose:     piParametroAPI
  Parameters:  entrada pData    = Data do Movimento
               entrada pEmpresa = C¢digo da Empresa
               entrada pEqpto   = C¢digo do Equipamento
               entrada pDocto   = N£mero do Documento
  Notes:       Cria a temp-table de parÉmetros para a atualizaá∆o on-line
               (tt-param)
------------------------------------------------------------------------------*/
define input parameter pData    as date format "99/99/9999" no-undo.
define input parameter pEmpresa LIKE mab-item-abastec.ep-codigo no-undo.
define input parameter pEqpto   as character                no-undo.
define input parameter pDocto   as integer                  no-undo.
define input parameter pPosto   as character                no-undo.

DEFINE VARIABLE c-valor-param53 LIKE mab-param.des-valor NO-UNDO.
DEFINE VARIABLE deDataInvertida AS DECIMAL               NO-UNDO.

DEFINE BUFFER bf-mab-abastec-lubrific FOR mab-abastec-lubrific.

empty temp-table tt-param.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 1
       tt-param.arquivo         = ""
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.iConsiste       = 2 /** Todas as Fichas **/
       tt-param.descConsiste    = "Todos":U
       tt-param.iEmpIni         = pEmpresa
       tt-param.iEmpFim         = pEmpresa
       tt-param.cEqptoIni       = pEqpto
       tt-param.cEqptoFim       = pEqpto
       tt-param.num-docto       = pDocto
       tt-param.lFicha          = yes
       tt-param.tipo-liberacao  = 1 /** Normal **/
       tt-param.cCCini          = ""
       tt-param.cCCfim          = "ZZZZZZZZ"
       tt-param.cPostoIni       = pPosto
       tt-param.cPostoFim       = pPosto
       tt-param.cEstabIni       = ""
       tt-param.cEstabFim       = "ZZZZZ"
       tt-param.cTagIni         = ""
       tt-param.cTagFim         = "ZZZZZZZZZZZZZZZZ".

FOR FIRST bf-mab-abastec-lubrific
    WHERE bf-mab-abastec-lubrific.num-docto = pDocto NO-LOCK:
    ASSIGN deDataInvertida = bf-mab-abastec-lubrific.val-dat-hora-invrtda.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        ASSIGN tt-param.cUnidNegocIni = bf-mab-abastec-lubrific.cod-unid-negoc
               tt-param.cUnidNegocFim = bf-mab-abastec-lubrific.cod-unid-negoc.
    &ENDIF
END.

FOR FIRST mab-param
    WHERE mab-param.cdn-param = 53 NO-LOCK:
    ASSIGN c-valor-param53 = mab-param.des-valor.
END.

/** Se parametrizado para consistir todas as fichas posteriores a validada, 
    retira chamada somente para o documento e coloca data final como atual **/
IF c-valor-param53 = "1":U THEN DO:
    ASSIGN tt-param.dataIni   = pData
           tt-param.dataFim   = TODAY
           tt-param.num-docto = ?.
END.
ELSE DO:
    ASSIGN tt-param.dataIni   = pData
           tt-param.dataFim   = pData
           tt-param.num-docto = pDocto.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametros wMaintenance 
PROCEDURE piParametros :
/*------------------------------------------------------------------------------
  Purpose:     piParametros
  Parameters:  <none>
  Notes:       Busca ParÉmetros e habilita/desabilita campos em tela
------------------------------------------------------------------------------*/
assign ttFicha.cod-usuar:sensitive in frame fPage0 = no.

for each  mab-param fields(des-valor cdn-param)
    where (mab-param.cdn-param >= 7 
           and   mab-param.cdn-param <= 10)
    or     mab-param.cdn-param = 52 no-lock:
    case mab-param.cdn-param:
        /** Motorista **/
        when 7 THEN DO:
            assign ttFicha.ep-codigo-matr:sensitive in frame fPage0 = if mab-param.des-valor = "1" 
                                                                then yes
                                                                else no.
            assign ttFicha.cod-estabel-matr:sensitive in frame fPage0 = if mab-param.des-valor = "1" 
                                                                then yes
                                                                else no.
            assign ttFicha.cod-matr:sensitive in frame fPage0 = if mab-param.des-valor = "1" 
                                                                then yes
                                                                else no.
        END.

        /** Atividade **/
        when 8 then 
            assign ttFicha.cod-ativid:sensitive in frame fPage0 = if mab-param.des-valor = "1" 
                                                                  then no
                                                                  else yes.
        /** Trajeto **/
        when 9 then
            assign ttFicha.cod-rota:sensitive in frame fPage0 = if mab-param.des-valor = "1" 
                                                                then yes
                                                                else no.
        /** Busca o tipo de valor do material **/
        when 10 then
            assign iTpValor = int(mab-param.des-valor).
        when 52 then
            if mab-param.des-valor = "1":U then
                assign ttFicha.ep-codigo-matr:sensitive in frame fPage0 = no
                       ttFicha.cod-estabel-matr:sensitive in frame fPage0 = no.
    end case.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piStatus wMaintenance 
PROCEDURE piStatus :
/*------------------------------------------------------------------------------
  Purpose:     piStatus
  Parameters:  <none>
  Notes:       Mostra o Status da Ficha de Abastecimento
------------------------------------------------------------------------------*/
/** Mostra Status da Consistància do Documento em tela **/
if avail {&ttTable} THEN DO: 
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 ttFicha.idi-consist}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN fiStatus:screen-value in frame fPage0 = RETURN-VALUE.
    &else
        ASSIGN fiStatus:screen-value in frame fPage0 = {frinc/i00fr055.i 04 ttFicha.idi-consist}.
    &endif
END.
else 
    assign fiStatus:screen-value in frame fPage0 = "".

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaContadorSec wMaintenance 
PROCEDURE piValidaContadorSec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN lLogContSec = NO.
    IF  cCodModelo <> "" THEN DO:
        RUN gotokey IN hDBOEqpto (INPUT FRAME fPage0 ttAbastec.ep-codigo,
                                  INPUT FRAME fPage0 ttAbastec.cod-eqpto).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getLogField   IN hDBOEqpto (INPUT "log-cont-sec":U,
                                            OUTPUT lLogContSec).
        END.
        IF  lLogContSec THEN DO:
            RUN gotokey IN hDBOModelo (INPUT cCodModelo).
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField  IN hDBOModelo (INPUT "cod-livre-1":U,
                                                 OUTPUT cUnModelSec).
                ASSIGN cUnModelSec = SUBSTRING(cUnModelSec, 1, 2).
            END.
        END.
    END.
    
    IF  lLogContSec THEN
        ASSIGN ttFicha.val-hodom-horim-sec:SENSITIVE IN FRAME fPage0 = YES
               fiUnSec:SCREEN-VALUE                  IN FRAME fPage0 = cUnModelSec.
    ELSE
        ASSIGN ttFicha.val-hodom-horim-sec:SCREEN-VALUE IN FRAME fPage0 = "0,0"
               fiUnSec:SCREEN-VALUE                     IN FRAME fPage0 = ""
               ttFicha.val-hodom-horim-sec:SENSITIVE    IN FRAME fPage0 = NO.

    IF  cAction = "" THEN
        ASSIGN ttFicha.val-hodom-horim-sec:SENSITIVE IN FRAME fPage0 = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMaintenance 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemMatriz AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        RUN piRetornaUnidNegoc IN hDBOHistor (INPUT  INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                              INPUT  INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                              INPUT  INPUT FRAME fPage0 ttFicha.dat-movto,
                                              OUTPUT cUnidNegoc,
                                              OUTPUT lTemMatriz,
                                              OUTPUT TABLE tt-unid-negoc-histor).

        IF lTemMatriz AND cUnidNegoc = INPUT FRAME fPage0 fi-cod-unid-negoc THEN
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = NO.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveFieldsParent wMaintenance 
PROCEDURE saveFieldsParent :
/*------------------------------------------------------------------------------
  Purpose:     saveFieldsParent
  Parameters:  <none>
  Notes:       Salva os dados da temp-table ttFicha
------------------------------------------------------------------------------*/
/** O restante dos campos foram alterados em tela ou na AfterEnableFields **/
assign ttFicha.num-docto      = {&ttTable}.num-docto
       ttFicha.ep-codigo      = {&ttTable}.ep-codigo
       ttFicha.cod-eqpto      = {&ttTable}.cod-eqpto
       ttFicha.cod-posto      = {&ttTable}.cod-posto.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN ttFicha.cod-unid-negoc = input frame fPage0 fi-cod-unid-negoc.
&ELSE
    ASSIGN ttFicha.cod_unid_negoc = input frame fPage0 fi-cod-unid-negoc.
&ENDIF

/** Busca Novamente a numeraá∆o, para n∆o ocorrer chave duplicada **/
if cAction = "ADD":U or
   cAction = "COPY":U then do:
    run buscaDocumento in hDBOFicha (output {&ttTable}.num-docto).
/*     assign ttFicha.num-docto   = {&ttTable}.num-docto */
/*            ttFicha.idi-consist = 1                    */
/*            ttFicha.idi-integr  = 1                    */
/*            ttFicha.log-consist = no.                  */
end.

/** Atualiza o campo hora invertida **/
assign {&ttTable}.val-dat-hora-invrtda = ttFicha.val-dat-hora-invrtda.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordParent wMaintenance 
PROCEDURE saveRecordParent :
/*------------------------------------------------------------------------------
  Purpose:     saveRecordParent
  Parameters:  <none>
  Notes:       Salva modificaá‰es efetuadas no registro da ttFicha
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButtonsStateAux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cReturnAux       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rCurrentAux      AS ROWID     NO-UNDO.

    &IF "{&ems_dbtype}":U = "MSS":U &THEN
        {utp/ut-verdatamss.i}
    &ENDIF

    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    /*--- Executa programas de customizaá∆o (before/after) ---*/
    {method/custom.i &Event="BEFORE-ASSIGN-ABASTEC"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="hDBOFicha"
                     &RowidTable="rCurrentAux"}

    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN hDBOFicha.

    /*--- Salva os campos da temp-table ttFicha ---*/
    RUN saveFieldsParent IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
       RETURN "NOK":U.

    /*--- Transfere temp-table ttFicha para o DBO ---*/
    RUN setRecord IN hDBOFicha (INPUT TABLE ttFicha).

    CASE cAction:
        /*--- Verifica se est† sendo feita uma inclus∆o/c¢pia ---*/
        WHEN "ADD":U OR WHEN "COPY":U THEN
            /*--- Cria um novo registro ---*/
            RUN createRecord IN hDBOFicha.
        /*--- Verifica se est† sendo feita uma alteraá∆o ---*/
        WHEN "UPDATE":U THEN
            /*--- Altera o registro corrente do DBO ---*/
            RUN updateRecord IN hDBOFicha.
    END CASE.

    /*--- Atualiza vari†vel cReturnAux com o conte£do do RETURN-VALUE ---*/
    ASSIGN cReturnAux = RETURN-VALUE.

    /*--- Verifica ocorrància de erros durante a gravaá∆o ---*/
    IF cReturnAux = "NOK":U THEN DO:
        /*--- Retorna temp-table RowErrors do DBO ---*/
        RUN getRowErrors IN hDBOFicha (OUTPUT TABLE RowErrors).

        /*--- Inicializa tela de mensagens de erros ---*/
        {method/showmessage.i1}

        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).

        /*Quando houver erro 3 ou 34 n∆o se mostrar nenhum outro erro de validaá∆o dos boÔs*/
        IF CAN-FIND(RowErrors WHERE RowErrors.ErrorNumber = 3 AND
                                     RowErrors.Errortype = "INTERNAL":U AND
                                     RowErrors.ErrorSubType = "ERROR":U) OR
            CAN-FIND(RowErrors WHERE RowErrors.ErrorNumber = 34 AND
                                     RowErrors.Errortype = "INTERNAL":U AND
                                     RowErrors.ErrorSubType = "ERROR":U) THEN DO:

            FOR EACH RowErrors WHERE RowErrors.ErrorNumber <> 3 AND 
                                     RowErrors.ErrorNumber <> 34 NO-LOCK:
                DELETE rowErrors.                                
            END.
        END.
        
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}

        WAIT-FOR CLOSE OF hShowMsg.
    END.
    ELSE do:
        /*--- Destr¢i tela de mensagens de erros ---*/
        {method/showmessage.i3}
    end.

    IF cReturnAux = "OK":U THEN DO:

        /*--- Retorna rowid do registro corrente do DBO ---*/
        RUN getRowid IN hDBOFicha (OUTPUT rCurrentAux).

        /*--- Atualiza campo ttFicha.r-Rowid e vari†vel com o valor do rowid do registro recÇm criado ---*/
        ASSIGN ttFicha.r-Rowid = rCurrentAux.

        /*--- Executa programas de customizaá∆o (before/after) ---*/
        {method/custom.i &Event="AFTER-ASSIGN-ABASTEC"
                         &Object="CONTAINER"
                         &ObjectHandle="THIS-PROCEDURE:HANDLE"
                         &FrameHandle="FRAME fPage0:HANDLE"
                         &Table="hDBOFicha"
                         &RowidTable="rCurrentAux"}
    END.

    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U 
                OR RowErrors.ErrorSubType = "":U) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaSegurancaEstabelecimento wMaintenance 
PROCEDURE ValidaSegurancaEstabelecimento :
/*------------------------------------------------------------------------------
  Purpose: ValidaSegurancaEstabelecimento
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pep-codigo LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcod-eqpto LIKE mab-eqpto.cod-eqpto NO-UNDO.

    FOR FIRST bfEquipto FIELDS (ep-codigo cod-eqpto cod-estabel)
        WHERE bfEquipto.ep-codigo = pep-codigo
        AND   bfEquipto.cod-eqpto = pcod-eqpto NO-LOCK:
        /* Se o estabelecimento atual do equipamento n∆o se encontra na tt_estab_ems2, o usu†rio n∆o tem permiss∆o para o mesmo,
           sendo assim deve informar que o equipamento n∆o esta cadastrada */
        IF  NOT CAN-FIND(FIRST tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = bfEquipto.cod-estabel NO-LOCK) THEN DO:
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wMaintenance 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     validateRecord
  Parameters:  <none>
  Notes:       Validaá‰es e criaá∆o do registro pai
------------------------------------------------------------------------------*/
    DEFINE VARIABLE deValContAnt   AS DEC        NO-UNDO.
    DEFINE VARIABLE dePerRod       AS DEC        NO-UNDO.
    DEFINE VARIABLE deMaxPer       AS DEC        NO-UNDO.
    DEFINE VARIABLE lUsaContSec    AS LOG        NO-UNDO.
    DEFINE VARIABLE lTemModelxAtiv AS LOG        NO-UNDO.
    DEFINE VARIABLE cMsg1          AS CHAR       NO-UNDO.
    DEFINE VARIABLE cMsg2          AS CHAR       NO-UNDO.
    DEFINE VARIABLE lRetorno       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cRetorno       AS CHARACTER  NO-UNDO.


    {utp/ut-liter.i "Atividade"}
    if ttFicha.cod-ativid:screen-value in frame fPage0 = "" then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 3145,
                           INPUT return-value).
        RETURN "NOK":U.
    END.
    else do:
        /** Atividade deve estar cadastrada **/
        if not can-find(first mab-ativid
                        where mab-ativid.cod-ativid = ttFicha.cod-ativid:screen-value in frame fPage0 no-lock) then do:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56,
                               INPUT return-value).
            RETURN "NOK":U.
        END.
    END.

    IF ttFicha.cod-rota:sensitive in frame fPage0 = YES THEN DO:
        IF NOT CAN-FIND(FIRST mab-trajeto
                        WHERE mab-trajeto.cod-rota = ttFicha.cod-rota:SCREEN-VALUE IN FRAME fPage0 NO-LOCK)  THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Trajeto_informado_inv†lido" *}
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT RETURN-VALUE + ".").
            RETURN "NOK":U.
        END.
    END.
    RUN validaAtividade IN hDBOApi003a (INPUT INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                        INPUT INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                        INPUT INPUT FRAME fPage0 ttFicha.cod-ativid,
                                        OUTPUT cRetorno, /* Retorna o modelo*/
                                        OUTPUT lRetorno).
    IF  lRetorno = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 32480,
                            INPUT STRING(cRetorno) + '~~' + STRING(INPUT FRAME fPage0 ttFicha.cod-ativid)).
        IF  RETURN-VALUE = "NO":U THEN DO:
            RETURN "NOK":U.
        END.
    END.

    /*Chama a Api de c†lculo do km informado > que o permitido*/
    RUN validaQuilometragem IN hDBOApi003a (INPUT 1,
                                            INPUT INPUT FRAME fPage0 ttFicha.val-hodom-horim,
                                            INPUT INPUT FRAME fPage0 ttFicha.val-hodom-horim-sec,
                                            INPUT INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                            INPUT INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                            INPUT INPUT FRAME fPage0 ttFicha.dat-movto,
                                            INPUT INPUT FRAME fPage0 ttFicha.hra-inicial,
                                            INPUT INPUT FRAME fPage0 ttFicha.cod-ativid,
                                            OUTPUT deValContAnt,
                                            OUTPUT dePerRod,
                                            OUTPUT deMaxPer).
    /*Mensagem com os dados informados x os dados gravados*/  
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN retornaLogical IN hDBOApi003a (OUTPUT lUsaContSec,
                                           OUTPUT lTemModelxAtiv).

        IF  lTemModelxAtiv THEN DO:
            {utp/ut-liter.i Validaá∆o_Contra_o_Consumo_Padr∆o_do_Modelo_de_Equipamento_x_Atividade_(AB0104) * }
            ASSIGN cMsg2 = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            {utp/ut-liter.i Validaá∆o_Contra_o_Consumo_do_Hist¢rico_de_Combust°vel_do_Equipamento * }
            ASSIGN cMsg2 = TRIM(RETURN-VALUE).
        END.

        IF  NOT lUsaContSec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 30381,
                               INPUT STRING({&ttTable}.ep-codigo,"999") + '~~' + {&ttTable}.cod-eqpto + '~~' + "" + '~~' + 
                                     STRING(ttFicha.val-hodom-horim,">>,>>>,>>9.99") + '~~' + STRING(deValContAnt,">>,>>>,>>9.99") + '~~' +
                                     STRING(dePerRod,">>,>>>,>>9.99") + '~~' + STRING(deMaxPer,">>,>>>,>>9.99") + '~~' + cMsg2 ).
        END.
        ELSE DO:
            {utp/ut-liter.i Secund†rio * }
            ASSIGN cMsg1 = " " + TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 30381,
                               INPUT STRING({&ttTable}.ep-codigo,"999") + '~~' + {&ttTable}.cod-eqpto + '~~' + cMsg1 + "~~" +
                                     STRING(ttFicha.val-hodom-horim-sec,">>,>>>,>>9.99") + '~~' + STRING(deValContAnt,">>,>>>,>>9.99") + '~~' +
                                     STRING(dePerRod,">>,>>>,>>9.99") + '~~' + STRING(deMaxPer,">>,>>>,>>9.99") + '~~' + cMsg2 ).
        END.
        IF RETURN-VALUE = "NO":U THEN
         RETURN "NOK":U.
    END.

    /** Verifica valores de hodìmetro/hor°metro **/
    run piHodometro in this-procedure.
    if return-value = "NOK":U then
        return "NOK":U.

    if cAction = "COPY":U then do:
        /** Deve-se abrir a query para reposicionamento **/
        run openQueryStatic in hDBOFicha (input "Main":U).
        /** Posiciona o registro na BO **/
        run repositionRecord in hDBOFicha (input ttFicha.r-rowid).
    end.

    /** Salva o Registro Pai **/
    run saveRecordParent in this-procedure.
    if return-value = "NOK":U then
        return "NOK":U.
    /** Gera os dados para a temp-table da API (abapi001) **/
    run piParametroAPI in this-procedure (input ttFicha.dat-movto,
                                          input ttFicha.ep-codigo,
                                          input ttFicha.cod-eqpto,
                                          input ttFicha.num-docto,
                                          input {&ttTable}.cod-posto).

    /** Consitància do Abastecimento **/
    run consisteAbastecimento in this-procedure.
    if return-value = "NOK":U then
        return "NOK":U.


    /*--- Executa programas de customizaá∆o ---*/
    {method/custom.i &Event="VALIDATE-RECORD"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="mab-item-abastec"
                     &RowidTable="?"}
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
      
    

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

