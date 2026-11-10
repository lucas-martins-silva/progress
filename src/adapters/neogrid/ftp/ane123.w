&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANE123 2.00.02.009}  /*** 010209 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ane123 MAN}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ANE123
&GLOBAL-DEFINE Version        2.00.02.009
&GLOBAL-DEFINE VersionLayout  200000000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros,Sele‡Æo,Faixas,ImpressÆo

&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGIMP          YES


&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page3Widgets

&GLOBAL-DEFINE page4Widgets   

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text   
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    rs-gera-carga cb-itens-export

&GLOBAL-DEFINE page3Fields    l-motivo-cancel ~
			      l-empresa ~
                              l-estab ~
                              l-serie ~
                              l-natur-oper ~
                              l-cond-pagto ~
                              l-moeda ~
                              l-item ~
                              l-unid-med ~
                              l-item-fornec ~
                              l-grupo-cliente ~
                              l-cliente ~
                              l-fornecedor ~
                              l-transportador ~
                              l-via-transporte ~
                              l-repres ~
                              l-regiao ~
                              l-usuario ~
                              l-tab-preco ~
                              l-ped-venda ~
                              l-nota-fiscal ~
                              l-canal-venda ~
                              l-tp-rec-desp ~
                              l-info-cred ~
                              l-cotacoes-moedas ~
                              l-unid-feder ~
                              l-cidades-zfm ~
                              l-preco-padrao ~
                              l-estrut-comerc ~
                              l-item-estab ~
                              l-parametros ~
                              l-portador ~
                              l-item-cliente ~
                              l-un-neg ~
                              l-un-neg-fam ~
                              l-un-neg-item

&GLOBAL-DEFINE page4Fields    f-data-nf-ini ~
                              f-data-nf-fim ~
                              f-data-pedv-ini ~
                              f-data-pedv-fim ~
                              f-periodo-cotacao-ini ~
                              f-periodo-cotacao-fim ~
                              f-pais-ini ~
                              f-pais-fim ~
                              f-estado-ini ~
                              f-estado-fim

&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD l-preco-padrao    AS LOG
    FIELD l-estrut-comerc   AS LOG
    FIELD l-item-estab      AS LOG
    FIELD l-referencia      AS LOG
    FIELD l-item-refer      AS LOG
    FIELD l-portador        AS LOG
    FIELD l-item-cliente    AS LOG
    FIELD l-parametros      AS LOG
    FIELD l-un-neg          AS LOG
    FIELD l-un-neg-fam      AS LOG
    FIELD l-un-neg-item     AS LOG
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR    FORMAT "x(35)"
    FIELD usuario           AS CHAR    FORMAT "x(12)"
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD l-motivo-cancel   AS LOGICAL
    FIELD l-empresa         AS LOGICAL
    FIELD l-estab           AS LOGICAL
    FIELD l-serie           AS LOGICAL
    FIELD l-natur-oper      AS LOGICAL
    FIELD l-cond-pagto      AS LOGICAL
    FIELD l-moeda           AS LOGICAL
    FIELD l-item            AS LOGICAL
    FIELD l-unid-med        AS LOGICAL
    FIELD l-item-fornec     AS LOGICAL
    FIELD l-grupo-cliente   AS LOGICAL
    FIELD l-cliente         AS LOGICAL
    FIELD l-fornecedor      AS LOGICAL
    FIELD l-transportador   AS LOGICAL
    FIELD l-via-transporte  AS LOGICAL
    FIELD l-repres          AS LOGICAL
    FIELD l-regiao          AS LOGICAL
    FIELD l-usuario         AS LOGICAL
    FIELD l-tab-preco       AS LOGICAL
    FIELD l-ped-venda       AS LOGICAL
    FIELD l-info-cred       AS LOGICAL
    FIELD f-data-pedv-ini   AS DATE
    FIELD f-data-pedv-fim   AS DATE
    FIELD l-nota-fiscal     AS LOGICAL
    FIELD f-data-nf-ini     AS DATE
    FIELD f-data-nf-fim     AS DATE
    FIELD f-cod-emit-ini    AS INTEGER
    FIELD f-cod-emit-fim    AS INTEGER
    FIELD f-item-ini        AS CHAR
    FIELD f-item-fim        AS CHAR
    FIELD f-refer-ini        AS CHAR
    FIELD f-refer-fim        AS CHAR
    FIELD f-nome-abrev-ini  AS CHAR 
    FIELD f-nome-abrev-fim  AS CHAR 
    FIELD l-canal-venda     AS LOGICAL
    FIELD l-tp-rec-desp     AS LOGICAL
    FIELD i-selecao-cli     AS INTEGER
    FIELD l-cotacoes-moedas AS LOGICAL
    FIELD f-periodo-cotacao-ini AS CHAR
    FIELD f-periodo-cotacao-fim AS CHAR
    FIELD l-unid-feder      AS LOGICAL
    FIELD f-pais-ini        AS CHAR
    FIELD f-pais-fim        AS CHAR
    FIELD f-estado-ini      AS CHAR
    FIELD f-estado-fim      AS CHAR
    FIELD i-destino-dados   AS INTEGER FORMAT '9'
    FIELD c-itens-export    AS CHAR
    FIELD c-tab-pre-ini     AS CHAR
    FIELD c-tab-pre-fim     AS CHAR
    FIELD l-cidades-zfm     AS LOGICAL
    FIELD char-1            AS CHAR
    FIELD char-2            AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.


/* Variables Definitions ---                                          */
DEF VAR l-ok                AS LOGICAL NO-UNDO.
DEF VAR c-terminal          AS CHAR    NO-UNDO.
DEF VAR l-erro              AS LOG     NO-UNDO INITIAL 'NO'.

def stream s-imp.

FIND FIRST para-dis NO-LOCK NO-ERROR.

{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-itens-export AS CHARACTER FORMAT "X(50)":U INITIAL "Fatur veis" 
     LABEL "Itens a Exportar" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Fatur veis","NÆo Fatur veis","Ambos" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE rs-gera-carga AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Neogrid", 1,
"CRM", 2
     SIZE 12 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 3.25.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.72 BY 12.

DEFINE VARIABLE l-canal-venda AS LOGICAL INITIAL no 
     LABEL "Canal Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE l-cidades-zfm AS LOGICAL INITIAL no 
     LABEL "Cidades Zona Franca" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-cliente AS LOGICAL INITIAL no 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE l-cond-pagto AS LOGICAL INITIAL no 
     LABEL "Condi‡Æo Pagamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE l-cotacoes-moedas AS LOGICAL INITIAL no 
     LABEL "Cota‡äes Moedas" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.
     
DEFINE VARIABLE l-motivo-cancel AS LOGICAL INITIAL no 
     LABEL "Motivos Canc/Rep Pedido" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.     

DEFINE VARIABLE l-empresa AS LOGICAL INITIAL no 
     LABEL "Empresa" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE l-estab AS LOGICAL INITIAL no 
     LABEL "Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE l-estrut-comerc AS LOGICAL INITIAL no 
     LABEL "Produto Comercial" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-fornecedor AS LOGICAL INITIAL no 
     LABEL "Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE l-grupo-cliente AS LOGICAL INITIAL no 
     LABEL "Grupo Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE l-info-cred AS LOGICAL INITIAL no 
     LABEL "Informa‡äes Cr‚dito" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE l-item AS LOGICAL INITIAL no 
     LABEL "Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 6 BY .83 NO-UNDO.

DEFINE VARIABLE l-item-cliente AS LOGICAL INITIAL no 
     LABEL "Item Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-item-estab AS LOGICAL INITIAL no 
     LABEL "Item Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-item-fornec AS LOGICAL INITIAL no 
     LABEL "Item x Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE l-item-refer AS LOGICAL INITIAL no 
     LABEL "Item x Referˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-moeda AS LOGICAL INITIAL no 
     LABEL "Moeda" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE l-natur-oper AS LOGICAL INITIAL no 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE l-nota-fiscal AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE l-parametros AS LOGICAL INITIAL no 
     LABEL "Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-ped-venda AS LOGICAL INITIAL no 
     LABEL "Pedido Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE l-portador AS LOGICAL INITIAL no 
     LABEL "Portador" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-preco-padrao AS LOGICAL INITIAL no 
     LABEL "Pre‡o PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-referencia AS LOGICAL INITIAL no 
     LABEL "Referˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-regiao AS LOGICAL INITIAL no 
     LABEL "RegiÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE l-repres AS LOGICAL INITIAL no 
     LABEL "Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE l-serie AS LOGICAL INITIAL no 
     LABEL "S‚rie Nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE l-tab-preco AS LOGICAL INITIAL no 
     LABEL "Tabela Pre‡o" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE l-todos AS LOGICAL INITIAL yes 
     LABEL "Selecionar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-tp-rec-desp AS LOGICAL INITIAL no 
     LABEL "Tipo Receita / Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE l-transportador AS LOGICAL INITIAL no 
     LABEL "Transportador" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE l-un-neg AS LOGICAL INITIAL no 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-un-neg-fam AS LOGICAL INITIAL no 
     LABEL "Un. Neg. x Fam. Com." 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE l-un-neg-item AS LOGICAL INITIAL no 
     LABEL "Un. Neg. x Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE l-unid-feder AS LOGICAL INITIAL no 
     LABEL "Unidade Federa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-unid-med AS LOGICAL INITIAL no 
     LABEL "Un Medida / Fator ConversÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE l-usuario AS LOGICAL INITIAL no 
     LABEL "Usu rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE l-via-transporte AS LOGICAL INITIAL no 
     LABEL "Via Transporte" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE c-nr-tab-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-tab-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Tabela Pre‡o" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE f-cod-emit-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE f-cod-emit-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE f-data-nf-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-data-nf-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data da Nota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-data-pedv-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-data-pedv-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data do Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-estado-fim AS CHARACTER FORMAT "x(4)":U INITIAL "ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE f-estado-ini AS CHARACTER FORMAT "x(4)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE f-item-fim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE f-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE f-nome-abrev-fim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE f-nome-abrev-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abreviado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE f-pais-fim AS CHARACTER FORMAT "x(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE f-pais-ini AS CHARACTER FORMAT "x(20)":U 
     LABEL "Pa¡s" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE f-periodo-cotacao-fim AS CHARACTER FORMAT "9999/99":U INITIAL "999912" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-periodo-cotacao-ini AS CHARACTER FORMAT "9999/99":U INITIAL "000101" 
     LABEL "Per¡odo Cota‡äes" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-refer-fim AS CHARACTER FORMAT "X(32)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE f-refer-ini AS CHARACTER FORMAT "X(32)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-66
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-68
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-70
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-71
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-73
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-76
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-77
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-78
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-79
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-80
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-81
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-82
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-83
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-84
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-85
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-86
     FILENAME "image/ii-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-87
     FILENAME "image/ii-las.bmp":U
     SIZE 3 BY .88.

DEFINE VARIABLE i-selecao-cli AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C¢digo", 1,
"Nome Abreviado", 2
     SIZE 18 BY 1.75 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage4
     f-data-nf-ini AT ROW 1.83 COL 18.72 COLON-ALIGNED
     f-data-nf-fim AT ROW 1.83 COL 36.14 COLON-ALIGNED NO-LABEL
     f-data-pedv-ini AT ROW 2.92 COL 18.86 COLON-ALIGNED
     f-data-pedv-fim AT ROW 2.92 COL 36.14 COLON-ALIGNED NO-LABEL
     f-cod-emit-ini AT ROW 4.04 COL 16.72 COLON-ALIGNED HELP
          "Faixa utilizada para clientes, fornecedores e inf. de cr‚dito"
     f-cod-emit-fim AT ROW 4.04 COL 36.14 COLON-ALIGNED HELP
          "Faixa utilizada para clientes, fornecedores e inf. de cr‚dito" NO-LABEL
     i-selecao-cli AT ROW 4.75 COL 64 HELP
          "Sele‡Æo utilizada para clientes, fornecedores e inf. de cr‚dito" NO-LABEL
     f-item-ini AT ROW 5.13 COL 11.72 COLON-ALIGNED
     f-item-fim AT ROW 5.13 COL 36.14 COLON-ALIGNED NO-LABEL
     f-refer-ini AT ROW 6.25 COL 7.72 COLON-ALIGNED
     f-refer-fim AT ROW 6.25 COL 36.14 COLON-ALIGNED NO-LABEL
     f-nome-abrev-ini AT ROW 7.33 COL 16.72 COLON-ALIGNED HELP
          "Faixa utilizada para clientes, fornecedores e inf. de cr‚dito"
     f-nome-abrev-fim AT ROW 7.33 COL 36.14 COLON-ALIGNED HELP
          "Faixa utilizada para clientes, fornecedores e inf. de cr‚dito" NO-LABEL
     c-nr-tab-ini AT ROW 8.42 COL 19.72 COLON-ALIGNED
     c-nr-tab-fim AT ROW 8.42 COL 36.14 COLON-ALIGNED NO-LABEL
     f-periodo-cotacao-ini AT ROW 9.54 COL 18.72 COLON-ALIGNED
     f-periodo-cotacao-fim AT ROW 9.54 COL 36.14 COLON-ALIGNED NO-LABEL
     f-pais-ini AT ROW 10.63 COL 8.72 COLON-ALIGNED
     f-pais-fim AT ROW 10.63 COL 36.14 COLON-ALIGNED NO-LABEL
     f-estado-ini AT ROW 11.75 COL 23.57 COLON-ALIGNED
     f-estado-fim AT ROW 11.75 COL 36.14 COLON-ALIGNED NO-LABEL
     IMAGE-66 AT ROW 1.83 COL 31
     IMAGE-67 AT ROW 1.83 COL 35
     IMAGE-68 AT ROW 2.92 COL 31
     IMAGE-69 AT ROW 2.92 COL 35
     IMAGE-70 AT ROW 4.04 COL 31
     IMAGE-71 AT ROW 4.04 COL 35
     IMAGE-72 AT ROW 7.33 COL 31
     IMAGE-73 AT ROW 7.33 COL 35
     IMAGE-76 AT ROW 9.54 COL 31
     IMAGE-77 AT ROW 9.54 COL 35
     IMAGE-78 AT ROW 10.63 COL 31
     IMAGE-79 AT ROW 10.63 COL 35
     IMAGE-80 AT ROW 11.75 COL 31
     IMAGE-81 AT ROW 11.75 COL 35
     IMAGE-82 AT ROW 5.13 COL 31
     IMAGE-83 AT ROW 5.13 COL 35
     IMAGE-84 AT ROW 8.42 COL 31
     IMAGE-85 AT ROW 8.42 COL 35
     IMAGE-86 AT ROW 6.25 COL 31
     IMAGE-87 AT ROW 6.25 COL 35
     "Sele‡Æo por" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 4.17 COL 64.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.79
         SIZE 86 BY 12.96
         FONT 1.

DEFINE FRAME fPage3
     l-un-neg AT ROW 2.25 COL 67
     l-un-neg-fam AT ROW 3.25 COL 67
     l-un-neg-item AT ROW 4.25 COL 67
     l-todos AT ROW 1.17 COL 36.57
     l-motivo-cancel AT ROW 6.25 COL 67
     l-empresa AT ROW 5.25 COL 67
     l-estab AT ROW 2.25 COL 3.43
     l-fornecedor AT ROW 2.25 COL 27.29
     l-cotacoes-moedas AT ROW 2.25 COL 47.29
     l-serie AT ROW 3.25 COL 3.43
     l-transportador AT ROW 3.25 COL 27.29
     l-unid-feder AT ROW 3.25 COL 47.29
     l-natur-oper AT ROW 4.25 COL 3.43
     l-via-transporte AT ROW 4.25 COL 27.29
     l-cidades-zfm AT ROW 4.25 COL 47.29
     l-cond-pagto AT ROW 5.25 COL 3.43
     l-repres AT ROW 5.25 COL 27.29
     l-referencia AT ROW 5.25 COL 47.29
     l-moeda AT ROW 6.25 COL 3.43
     l-regiao AT ROW 6.25 COL 27.29
     l-item-refer AT ROW 6.25 COL 47.29
     l-preco-padrao AT ROW 7.25 COL 47.29
     l-estrut-comerc AT ROW 8.25 COL 47.29
     l-item-estab AT ROW 9.25 COL 47.29
     l-item AT ROW 7.25 COL 3.43
     l-usuario AT ROW 7.25 COL 27.29
     l-unid-med AT ROW 8.25 COL 3.43
     l-nota-fiscal AT ROW 8.25 COL 27.29
     l-item-fornec AT ROW 9.25 COL 3.43
     l-ped-venda AT ROW 9.25 COL 27.29
     l-tab-preco AT ROW 10.25 COL 3.43
     l-canal-venda AT ROW 10.25 COL 27.29
     l-grupo-cliente AT ROW 11.25 COL 3.43
     l-tp-rec-desp AT ROW 11.25 COL 27.29
     l-cliente AT ROW 12.25 COL 3.43
     l-info-cred AT ROW 12.25 COL 27.29
     l-parametros AT ROW 10.25 COL 47.29
     l-portador AT ROW 11.25 COL 47.29
     l-item-cliente AT ROW 12.21 COL 47.29
     RECT-16 AT ROW 1.5 COL 2.29
     " Exporta‡Æo de Dados" VIEW-AS TEXT
          SIZE 18 BY .54 AT ROW 1.25 COL 11.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.79
         SIZE 86 BY 12.96
         FONT 1.

DEFINE FRAME fPage2
     cb-itens-export AT ROW 3.29 COL 49 COLON-ALIGNED
     rs-gera-carga AT ROW 4.21 COL 13.14 NO-LABEL
     RECT-14 AT ROW 3.58 COL 8
     " Gerar carga de dados para:" VIEW-AS TEXT
          SIZE 19.43 BY .75 AT ROW 3.25 COL 8.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.79
         SIZE 86 BY 12.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
   Custom                                                               */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR RADIO-SET i-selecao-cli IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   /*run verificaSelecao.
   if not l-erro then
       do  on error undo, return no-apply:*/
           run piExecute.
       /*end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME i-selecao-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-selecao-cli wReport
ON VALUE-CHANGED OF i-selecao-cli IN FRAME fPage4
DO:
    IF i-selecao-cli:SCREEN-VALUE IN FRAME fPage4 = "1" THEN DO:
        ENABLE  f-cod-emit-ini
                f-cod-emit-fim
                WITH FRAME fPage4.
        DISABLE f-nome-abrev-ini
                f-nome-abrev-fim
                WITH FRAME fPage4.
    END.
    ELSE DO:
       ENABLE  f-nome-abrev-ini
               f-nome-abrev-fim
               WITH FRAME fPage4.
       DISABLE f-cod-emit-ini
               f-cod-emit-fim
               WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME l-cidades-zfm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-cidades-zfm wReport
ON VALUE-CHANGED OF l-cidades-zfm IN FRAME fPage3 /* Cidades Zona Franca */
DO:
    assign frame fPage3 l-unid-feder.

    if  l-unid-feder then
        assign f-pais-ini:sensitive   in frame fPage4 = yes
               f-pais-fim:sensitive   in frame fPage4 = yes
               f-estado-ini:sensitive in frame fPage4 = yes
               f-estado-fim:sensitive in frame fPage4 = yes.
    else
        assign f-pais-ini:sensitive   in frame fPage4 = no
               f-pais-fim:sensitive   in frame fPage4 = no
               f-estado-ini:sensitive in frame fPage4 = no
               f-estado-fim:sensitive in frame fPage4 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-cliente wReport
ON VALUE-CHANGED OF l-cliente IN FRAME fPage3 /* Cliente */
DO:

/* A sele‡Æo por "C¢digo" e "Nome Abreviado" s¢ estar  habilitada 
   se as op‡äes "Cliente", "Fornecedor", "Item Cliente" ou "Informa‡äes de Cr‚dito" forem marcadas */
IF l-cliente:CHECKED    OR 
   l-fornecedor:CHECKED OR 
   l-info-cred:CHECKED    OR
   l-item-cliente:CHECKED THEN DO: 

  ENABLE i-selecao-cli WITH FRAME fPage4.
  APPLY "value-changed":U TO i-selecao-cli IN FRAME fPage4.

END.
ELSE DO:
    DISABLE f-nome-abrev-ini 
            f-nome-abrev-fim 
            f-cod-emit-ini   
            f-cod-emit-fim   
            i-selecao-cli WITH FRAME fPage4.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-cotacoes-moedas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-cotacoes-moedas wReport
ON VALUE-CHANGED OF l-cotacoes-moedas IN FRAME fPage3 /* Cota‡äes Moedas */
DO:
    assign frame fPage3 l-cotacoes-moedas.

    if  l-cotacoes-moedas then
        assign f-periodo-cotacao-ini:sensitive in frame fPage4 = yes
               f-periodo-cotacao-fim:sensitive in frame fPage4 = yes.
    else
        assign f-periodo-cotacao-ini:sensitive in frame fPage4 = no
               f-periodo-cotacao-fim:sensitive in frame fPage4 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-fornecedor wReport
ON VALUE-CHANGED OF l-fornecedor IN FRAME fPage3 /* Fornecedor */
DO:
    APPLY "value-changed":U TO l-cliente IN FRAME fPage3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-info-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-info-cred wReport
ON VALUE-CHANGED OF l-info-cred IN FRAME fPage3 /* Informa‡äes Cr‚dito */
DO:

 APPLY "value-changed":U TO l-cliente IN FRAME fPage3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-item wReport
ON VALUE-CHANGED OF l-item IN FRAME fPage3 /* Item */
DO:
/* A faixa de itens e o parƒmetro "Itens a Exportar" s¢ estarÆo habilitados
   se o check-box Item estiver marcado */
IF (l-item-refer:CHECKED = YES 
    OR l-item:CHECKED = YES 
    OR l-item-estab:CHECKED = YES
    OR l-un-neg-item:CHECKED = YES) 
    THEN DO:
ENABLE f-item-ini
       f-item-fim      WITH FRAME fPage4.
ENABLE cb-itens-export WITH FRAME fPage2.
END.
ELSE DO:
    DISABLE f-item-ini
            f-item-fim      WITH FRAME fPage4.
    DISABLE cb-itens-export WITH FRAME fPage2.
END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-item-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-item-cliente wReport
ON VALUE-CHANGED OF l-item-cliente IN FRAME fPage3 /* Item Cliente */
DO:
   APPLY "value-changed":U TO l-cliente IN FRAME fPage3.

   IF (l-item-refer:CHECKED = YES OR l-item:CHECKED = YES OR l-item-estab:CHECKED = YES OR l-item-cliente:CHECKED = YES) THEN
      ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = YES
             f-item-fim:SENSITIVE IN FRAME fpage4 = YES.
   ELSE
       ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = NO
              f-item-fim:SENSITIVE IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-item-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-item-estab wReport
ON VALUE-CHANGED OF l-item-estab IN FRAME fPage3 /* Item Estabelecimento */
DO:
   IF (l-item-refer:CHECKED = YES OR l-item:CHECKED = YES OR l-item-estab:CHECKED = YES) THEN
      ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = YES
             f-item-fim:SENSITIVE IN FRAME fpage4 = YES.
   ELSE
       ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = NO
              f-item-fim:SENSITIVE IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-item-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-item-refer wReport
ON VALUE-CHANGED OF l-item-refer IN FRAME fPage3 /* Item x Referˆncia */
DO:
   IF (l-item-refer:CHECKED = YES OR l-item:CHECKED = YES OR l-item-estab:CHECKED = YES) THEN
      ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = YES
             f-item-fim:SENSITIVE IN FRAME fpage4 = YES.
   ELSE
       ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = NO
              f-item-fim:SENSITIVE IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-nota-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-nota-fiscal wReport
ON VALUE-CHANGED OF l-nota-fiscal IN FRAME fPage3 /* Nota Fiscal */
DO:
    IF l-nota-fiscal:CHECKED IN FRAME fPage3 = YES THEN
       ENABLE  f-data-nf-ini
               f-data-nf-fim
               WITH FRAME fPage4.
    ELSE
       DISABLE f-data-nf-ini
               f-data-nf-fim
               WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ped-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ped-venda wReport
ON VALUE-CHANGED OF l-ped-venda IN FRAME fPage3 /* Pedido Venda */
DO:
  IF l-ped-venda:CHECKED IN FRAME fPage3 = YES THEN
     ENABLE  f-data-pedv-ini
             f-data-pedv-fim
             WITH FRAME fPage4.
  ELSE
     DISABLE f-data-pedv-ini
             f-data-pedv-fim
             WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-referencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-referencia wReport
ON VALUE-CHANGED OF l-referencia IN FRAME fPage3 /* Referˆncia */
DO:
   IF l-referencia:CHECKED = YES THEN
      ASSIGN f-refer-ini:SENSITIVE IN FRAME fpage4 = YES
             f-refer-fim:SENSITIVE IN FRAME fpage4 = YES.
   ELSE
      ASSIGN f-refer-ini:SENSITIVE IN FRAME fpage4 = NO
             f-refer-fim:SENSITIVE IN FRAME fpage4 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-tab-preco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-tab-preco wReport
ON VALUE-CHANGED OF l-tab-preco IN FRAME fPage3 /* Tabela Pre‡o */
DO:
    IF l-tab-preco:CHECKED IN FRAME fPage3 = YES THEN
        ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = YES
               c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = YES.
    ELSE
        ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
               c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-todos wReport
ON VALUE-CHANGED OF l-todos IN FRAME fPage3 /* Selecionar Todos */
DO:
     IF  l-todos:CHECKED = YES THEN DO:     
        IF l-motivo-cancel:SENSITIVE = YES THEN
           ASSIGN l-motivo-cancel:CHECKED = YES.
        ELSE
           ASSIGN l-motivo-cancel:CHECKED = NO.
	   
        IF l-empresa:SENSITIVE = YES THEN
           ASSIGN l-empresa:CHECKED = YES.
        ELSE
           ASSIGN l-empresa:CHECKED = NO.

        IF l-estab:SENSITIVE = YES THEN
           ASSIGN l-estab:CHECKED = YES.
        ELSE
           ASSIGN l-estab:CHECKED = NO.

        IF l-serie:SENSITIVE = YES THEN
           ASSIGN l-serie:CHECKED = YES.
        ELSE
            ASSIGN l-serie:CHECKED = NO.

        IF l-natur-oper:SENSITIVE = YES THEN
           ASSIGN l-natur-oper:CHECKED = YES.
        ELSE
            ASSIGN l-natur-oper:CHECKED = NO.

        IF l-cond-pagto:SENSITIVE = YES THEN
           ASSIGN l-cond-pagto:CHECKED = YES.
        ELSE
            ASSIGN l-cond-pagto:CHECKED = NO.

        IF l-moeda:SENSITIVE = YES THEN
           ASSIGN l-moeda:CHECKED = YES.
        ELSE
            ASSIGN l-moeda:CHECKED = NO.

        IF l-item:SENSITIVE = YES THEN DO:
           ASSIGN l-item:CHECKED = YES
                  f-item-ini:SENSITIVE IN FRAME fPage4 = YES
                  f-item-fim:SENSITIVE IN FRAME fPage4 = YES.
        END.
        ELSE
            ASSIGN l-item:CHECKED = NO
                   f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                   f-item-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-unid-med:SENSITIVE = YES THEN
           ASSIGN l-unid-med:CHECKED = YES.
        ELSE
            ASSIGN l-unid-med:CHECKED = NO.

        IF l-item-fornec:SENSITIVE = YES THEN
           ASSIGN l-item-fornec:CHECKED = YES.
        ELSE
            ASSIGN l-item-fornec:CHECKED = NO.

        IF l-grupo-cliente:SENSITIVE = YES THEN
           ASSIGN l-grupo-cliente:CHECKED = YES.
        ELSE
            ASSIGN l-grupo-cliente:CHECKED = NO.

        IF l-cliente:SENSITIVE = YES THEN
           ASSIGN l-cliente:CHECKED = YES
                  f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = YES
                  f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = YES.
        ELSE
            ASSIGN l-cliente:CHECKED = NO
                   f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = NO
                   f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-fornecedor:SENSITIVE = YES THEN
           ASSIGN l-fornecedor:CHECKED = YES.
        ELSE
            ASSIGN l-fornecedor:CHECKED = NO.

        IF l-transportador:SENSITIVE = YES THEN
           ASSIGN l-transportador:CHECKED = YES.
        ELSE
            ASSIGN l-transportador:CHECKED = NO.

        IF l-via-transporte:SENSITIVE = YES THEN
           ASSIGN l-via-transporte:CHECKED = YES.
        ELSE
            ASSIGN l-via-transporte:CHECKED = NO.

        IF l-repres:SENSITIVE = YES THEN
           ASSIGN l-repres:CHECKED = YES.
        ELSE
            ASSIGN l-repres:CHECKED = NO.

        IF l-regiao:SENSITIVE = YES THEN
           ASSIGN l-regiao:CHECKED = YES.
        ELSE
            ASSIGN l-regiao:CHECKED = NO.

         IF l-usuario:SENSITIVE = YES THEN
            ASSIGN l-usuario:CHECKED = YES.
         ELSE
             ASSIGN l-usuario:CHECKED = NO.
        
         IF l-tab-preco:SENSITIVE = YES THEN
            ASSIGN l-tab-preco:CHECKED = YES
                   c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = YES
                   c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = YES.
         ELSE
             ASSIGN l-tab-preco:CHECKED = NO
                    c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
                    c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-ped-venda:SENSITIVE = YES THEN
            ASSIGN l-ped-venda:CHECKED = YES
                   f-data-pedv-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-data-pedv-fim:SENSITIVE IN FRAME fPage4 = YES.

         ELSE 
             ASSIGN l-ped-venda:CHECKED = NO
                    f-data-pedv-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-data-pedv-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-nota-fiscal:SENSITIVE = YES THEN
            ASSIGN l-nota-fiscal:CHECKED = YES
                   f-data-nf-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-data-nf-fim:SENSITIVE IN FRAME fPage4 = YES.
         ELSE
            ASSIGN l-nota-fiscal:CHECKED = NO
                   f-data-nf-ini:SENSITIVE IN FRAME fPage4 = NO
                   f-data-nf-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-canal-venda:SENSITIVE = YES THEN
            ASSIGN l-canal-venda:CHECKED = YES.
         ELSE
             ASSIGN l-canal-venda:CHECKED = NO.

         IF l-tp-rec-desp:SENSITIVE = YES THEN
            ASSIGN l-tp-rec-desp:CHECKED = YES.
         ELSE
             ASSIGN l-tp-rec-desp:CHECKED = NO.

         IF l-info-cred:SENSITIVE = YES THEN
            ASSIGN l-info-cred:CHECKED = YES
                   f-cod-emit-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-cod-emit-fim:SENSITIVE IN FRAME fPage4 = YES.
         ELSE
             ASSIGN l-info-cred:CHECKED = NO
                    f-cod-emit-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-cod-emit-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-cotacoes-moedas:SENSITIVE = YES THEN
            ASSIGN l-cotacoes-moedas:CHECKED = YES
                   f-periodo-cotacao-ini:SENSITIVE = YES
                   f-periodo-cotacao-fim:SENSITIVE = YES.
         ELSE
              ASSIGN l-cotacoes-moedas:CHECKED = NO
                     f-periodo-cotacao-ini:SENSITIVE = NO
                     f-periodo-cotacao-fim:SENSITIVE = NO.

         IF l-unid-feder:SENSITIVE = YES THEN
            ASSIGN l-unid-feder:CHECKED = YES
                   f-pais-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-pais-fim:SENSITIVE IN FRAME fPage4 = YES
                   f-estado-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-estado-fim:SENSITIVE IN FRAME fPage4 = YES.

         ELSE
             ASSIGN l-unid-feder:CHECKED = NO
                    f-pais-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-pais-fim:SENSITIVE IN FRAME fPage4 = NO
                    f-estado-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-estado-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-cidades-zfm:SENSITIVE = YES THEN
            ASSIGN l-cidades-zfm:CHECKED = YES.
         ELSE
             ASSIGN l-cidades-zfm:CHECKED = NO.

         IF l-referencia:SENSITIVE = YES THEN
            ASSIGN l-referencia:CHECKED = YES
                   f-refer-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-refer-fim:SENSITIVE IN FRAME fPage4 = YES.
         ELSE
             ASSIGN l-referencia:CHECKED = NO
                    f-refer-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-refer-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-parametros:SENSITIVE = YES THEN
            ASSIGN l-parametros:CHECKED = YES.
         ELSE
            ASSIGN l-parametros:CHECKED = NO.

         /* FO 1703730 - Unidade de Neg¢cio */
         ASSIGN l-un-neg:CHECKED      = l-un-neg:SENSITIVE.
         ASSIGN l-un-neg-fam:CHECKED  = l-un-neg-fam:SENSITIVE.
         ASSIGN l-un-neg-item:CHECKED = l-un-neg-item:SENSITIVE.

        IF l-item-cliente:SENSITIVE = YES THEN
            ASSIGN l-item-cliente:CHECKED = YES
                   f-item-ini:SENSITIVE     IN FRAME fPage4 = YES
                   f-item-fim:SENSITIVE     IN FRAME fPage4 = YES.
        ELSE
            ASSIGN l-item-cliente:CHECKED = NO
                   f-item-ini:SENSITIVE     IN FRAME fPage4 = NO
                   f-item-fim:SENSITIVE     IN FRAME fPage4 = NO.
        IF l-portador:SENSITIVE = YES THEN
            ASSIGN l-portador:CHECKED = YES.
        ELSE
            ASSIGN l-portador:CHECKED = NO.
                   f-cod-emit-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-item-refer:SENSITIVE = YES THEN
            ASSIGN l-item-refer:CHECKED = YES
                   f-item-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-item-fim:SENSITIVE IN FRAME fPage4 = YES.

         ELSE 
             ASSIGN l-item-refer:CHECKED = NO
                    f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-item-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-preco-padrao:SENSITIVE = YES THEN
            ASSIGN l-preco-padrao:CHECKED = YES.
         ELSE
            ASSIGN l-preco-padrao:CHECKED = NO.

         IF l-estrut-comerc:SENSITIVE = YES THEN
            ASSIGN l-estrut-comerc:CHECKED = YES.
         ELSE
            ASSIGN l-estrut-comerc:CHECKED = NO.

         IF l-item-estab:SENSITIVE = YES THEN
            ASSIGN l-item-estab:CHECKED = YES
                   f-item-ini:SENSITIVE IN FRAME fPage4 = YES
                   f-item-fim:SENSITIVE IN FRAME fPage4 = YES.

         ELSE 
             ASSIGN l-item-estab:CHECKED = NO
                    f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                    f-item-fim:SENSITIVE IN FRAME fPage4 = NO.
    END.
    ELSE DO:
         IF l-motivo-cancel:SENSITIVE = YES THEN
            ASSIGN l-motivo-cancel:CHECKED = NO.
	    
         IF l-empresa:SENSITIVE = YES THEN
            ASSIGN l-empresa:CHECKED = NO.

         IF l-estab:SENSITIVE = YES THEN
            ASSIGN l-estab:CHECKED = NO.

         IF l-serie:SENSITIVE = YES THEN
            ASSIGN l-serie:CHECKED = NO.

         IF l-natur-oper:SENSITIVE = YES THEN
          ASSIGN l-natur-oper:CHECKED = NO.

         IF l-cond-pagto:SENSITIVE = YES THEN
          ASSIGN l-cond-pagto:CHECKED = NO.

         IF l-moeda:SENSITIVE = YES THEN
          ASSIGN l-moeda:CHECKED = NO.

         IF l-item:SENSITIVE = YES THEN
          ASSIGN l-item:CHECKED = NO
                 f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                 f-item-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-unid-med:SENSITIVE = YES THEN
          ASSIGN l-unid-med:CHECKED = NO.

         IF l-item-fornec:SENSITIVE = YES THEN
          ASSIGN l-item-fornec:CHECKED = NO.

         IF l-grupo-cliente:SENSITIVE = YES THEN
          ASSIGN l-grupo-cliente:CHECKED = NO.

         IF l-cliente:SENSITIVE = YES THEN
          ASSIGN l-cliente:CHECKED = NO
                 f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = NO
                 f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = NO.

         IF l-fornecedor:SENSITIVE = YES THEN
          ASSIGN l-fornecedor:CHECKED = NO.

         IF l-transportador:SENSITIVE = YES THEN
          ASSIGN l-transportador:CHECKED = NO.

        IF l-via-transporte:SENSITIVE = YES THEN
          ASSIGN l-via-transporte:CHECKED = NO.

        IF l-repres:SENSITIVE = YES THEN
          ASSIGN l-repres:CHECKED = NO.

        IF l-regiao:SENSITIVE = YES THEN
          ASSIGN l-regiao:CHECKED = NO.

        IF l-usuario:SENSITIVE = YES THEN
           ASSIGN l-usuario:CHECKED = NO.

        IF l-tab-preco:SENSITIVE = YES THEN
           ASSIGN l-tab-preco:CHECKED = NO
                  c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
                  c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-ped-venda:SENSITIVE = YES THEN
           ASSIGN l-ped-venda:CHECKED = NO
                  f-data-pedv-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-data-pedv-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-nota-fiscal:SENSITIVE = YES THEN
           ASSIGN l-nota-fiscal:CHECKED = NO
                  f-data-nf-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-data-nf-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-canal-venda:SENSITIVE = YES THEN
           ASSIGN l-canal-venda:CHECKED = NO.

        IF l-tp-rec-desp:SENSITIVE = YES THEN
           ASSIGN l-tp-rec-desp:CHECKED = NO.

        IF l-info-cred:SENSITIVE = YES THEN
           ASSIGN l-info-cred:CHECKED = NO
                  f-cod-emit-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-cod-emit-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-cotacoes-moedas:SENSITIVE = YES THEN
           ASSIGN l-cotacoes-moedas:CHECKED = NO
                  f-periodo-cotacao-ini:SENSITIVE = NO
                  f-periodo-cotacao-fim:SENSITIVE = NO.

        IF l-unid-feder:SENSITIVE = YES THEN
           ASSIGN l-unid-feder:CHECKED = NO
                  f-pais-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-pais-fim:SENSITIVE IN FRAME fPage4 = NO
                  f-estado-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-estado-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-cidades-zfm:SENSITIVE = YES THEN
           ASSIGN l-cidades-zfm:CHECKED = NO.

        IF l-referencia:SENSITIVE = YES THEN
           ASSIGN l-referencia:CHECKED = NO
                  f-refer-ini:SENSITIVE = NO
                  f-refer-fim:SENSITIVE = NO.

         IF l-parametros:SENSITIVE = YES THEN
            ASSIGN l-parametros:CHECKED = NO.

         /* FO 1703730 - Unidade de Neg¢cio */
         IF l-un-neg:SENSITIVE = YES THEN
            ASSIGN l-un-neg:CHECKED = NO.
         
         IF l-un-neg-fam:SENSITIVE = YES THEN
            ASSIGN l-un-neg-fam:CHECKED = NO.
         
         IF l-un-neg-item:SENSITIVE = YES THEN
            ASSIGN l-un-neg-item:CHECKED = NO.

        IF l-portador:SENSITIVE = YES THEN
            ASSIGN l-portador:CHECKED = NO.

        IF l-item-cliente:SENSITIVE = YES THEN
            ASSIGN l-item-cliente:CHECKED = NO
                   f-item-ini:SENSITIVE     IN FRAME fPage4 = NO
                   f-item-fim:SENSITIVE     IN FRAME fPage4 = NO.

        IF l-item-refer:SENSITIVE = YES THEN
           ASSIGN l-item-refer:CHECKED = NO
                  f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-item-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-item-estab:SENSITIVE = YES THEN
           ASSIGN l-item-estab:CHECKED = NO
                  f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                  f-item-fim:SENSITIVE IN FRAME fPage4 = NO.

        IF l-preco-padrao:SENSITIVE = YES THEN
           ASSIGN l-preco-padrao:CHECKED = NO.

        IF l-estrut-comerc:SENSITIVE = YES THEN
           ASSIGN l-estrut-comerc:CHECKED = NO.
   END.
    APPLY "value-changed":U TO l-cliente IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-un-neg-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-un-neg-item wReport
ON VALUE-CHANGED OF l-un-neg-item IN FRAME fPage3 /* Un. Neg. x Item */
DO:
   IF l-un-neg-item:CHECKED = YES THEN
      ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = YES
             f-item-fim:SENSITIVE IN FRAME fpage4 = YES.
   ELSE 
      IF (l-item-refer:CHECKED = NO AND l-item:CHECKED = NO AND l-item-estab:CHECKED = NO) THEN
          ASSIGN f-item-ini:SENSITIVE IN FRAME fpage4 = NO
                 f-item-fim:SENSITIVE IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-unid-feder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-unid-feder wReport
ON VALUE-CHANGED OF l-unid-feder IN FRAME fPage3 /* Unidade Federa‡Æo */
DO:
    assign frame fPage3 l-unid-feder.

    if  l-unid-feder then
        assign f-pais-ini:sensitive   in frame fPage4 = yes
               f-pais-fim:sensitive   in frame fPage4 = yes
               f-estado-ini:sensitive in frame fPage4 = yes
               f-estado-fim:sensitive in frame fPage4 = yes.
    else
        assign f-pais-ini:sensitive   in frame fPage4 = no
               f-pais-fim:sensitive   in frame fPage4 = no
               f-estado-ini:sensitive in frame fPage4 = no
               f-estado-fim:sensitive in frame fPage4 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME rs-gera-carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-gera-carga wReport
ON VALUE-CHANGED OF rs-gera-carga IN FRAME fPage2
DO:

   ASSIGN FRAME fPage3
        l-motivo-cancel
        l-empresa
        l-estab
        l-serie
        l-natur-oper
        l-cond-pagto
        l-moeda
        l-item
        l-unid-med
        l-item-fornec
        l-grupo-cliente
        l-cliente
        l-fornecedor
        l-transportador
        l-via-transporte
        l-repres
        l-regiao
        l-usuario
        l-tab-preco
        l-ped-venda
        l-nota-fiscal
        l-canal-venda
        l-tp-rec-desp
        l-info-cred
        l-cotacoes-moedas.

    IF INPUT FRAME fPage2 rs-gera-carga = 1 THEN DO: /*Neogrid*/
        DISABLE l-referencia
                l-item-refer
                l-parametros
                l-portador
                l-item-cliente
		l-motivo-cancel
                l-empresa
                l-estab
                l-grupo-cliente
                l-repres
                l-regiao
                l-usuario
                l-tab-preco
                l-ped-venda
                l-nota-fiscal
                l-canal-venda
                l-tp-rec-desp
                l-info-cred
                l-cotacoes-moedas
                l-unid-feder
               &if '{&BF_DIS_VERSAO_EMS}' >= '2.04':U &then
                l-cidades-zfm
                l-preco-padrao
                l-estrut-comerc
                l-item-estab
                /* FO 1703730 - Unidade de Neg¢cio */
                l-un-neg
                l-un-neg-fam
                l-un-neg-item
               &endif
                WITH FRAME fPage3.
        ENABLE  l-serie
                l-natur-oper
                l-cond-pagto
                l-moeda
                l-item
                l-unid-med
                l-item-fornec
                l-cliente
                l-fornecedor
                l-transportador
                l-via-transporte
                WITH FRAME fPage3.

        ENABLE f-cod-emit-ini   
               f-cod-emit-fim
               f-item-ini
               f-item-fim
               f-nome-abrev-ini 
               f-nome-abrev-fim 
               i-selecao-cli WITH FRAME fPage4.          

        DISABLE f-data-nf-ini
                f-data-nf-fim
                f-data-pedv-ini
                f-data-pedv-fim
                f-periodo-cotacao-ini
                f-periodo-cotacao-fim
                f-pais-ini
                f-pais-fim
                f-estado-ini
                f-estado-fim
                f-refer-ini
                f-refer-fim
                WITH FRAME fPage4.

        ASSIGN l-motivo-cancel:CHECKED   IN FRAME fPage3 = NO
	       l-empresa:CHECKED         IN FRAME fPage3 = NO
               l-estab:CHECKED           IN FRAME fPage3 = NO
               l-serie:CHECKED           IN FRAME fPage3 = YES
               l-natur-oper:CHECKED      IN FRAME fPage3 = YES
               l-cond-pagto:CHECKED      IN FRAME fPage3 = YES
               l-moeda:CHECKED           IN FRAME fPage3 = YES
               l-item:CHECKED            IN FRAME fPage3 = YES
               l-unid-med:CHECKED        IN FRAME fPage3 = YES
               l-item-fornec:CHECKED     IN FRAME fPage3 = YES
               l-grupo-cliente:CHECKED   IN FRAME fPage3 = NO
               l-cliente:CHECKED         IN FRAME fPage3 = YES
               l-fornecedor:CHECKED      IN FRAME fPage3 = YES
               l-transportador:CHECKED   IN FRAME fPage3 = YES
               l-via-transporte:CHECKED  IN FRAME fPage3 = YES
               l-repres:CHECKED          IN FRAME fPage3 = NO
               l-regiao:CHECKED          IN FRAME fPage3 = NO
               l-usuario:CHECKED         IN FRAME fPage3 = NO
               l-tab-preco:CHECKED       IN FRAME fPage3 = NO
               l-ped-venda:CHECKED       IN FRAME fPage3 = NO
               l-nota-fiscal:CHECKED     IN FRAME fPage3 = NO
               l-canal-venda:CHECKED     IN FRAME fPage3 = NO
               l-tp-rec-desp:CHECKED     IN FRAME fPage3 = NO
               l-info-cred:CHECKED       IN FRAME fPage3 = NO
               l-cotacoes-moedas:CHECKED IN FRAME fPage3 = NO
               l-unid-feder:CHECKED      IN FRAME fPage3 = NO
               l-referencia:CHECKED      IN FRAME fPage3 = NO
               l-item-refer:CHECKED      IN FRAME fPage3 = NO
               l-parametros:CHECKED      IN FRAME fPage3 = NO
               l-portador:CHECKED        IN FRAME fPage3 = NO
               l-item-cliente:CHECKED    IN FRAME fPage3 = NO
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
               l-cidades-zfm:CHECKED     IN FRAME fPage3 = NO
               l-preco-padrao:CHECKED    IN FRAME fPage3 = NO
               l-estrut-comerc:CHECKED   IN FRAME fPage3 = NO
               l-item-estab:CHECKED      IN FRAME fPage3 = NO
               /* FO 1703730 - Unidade de Neg¢cio */
               l-un-neg:CHECKED          IN FRAME fPage3 = NO
               l-un-neg-fam:CHECKED      IN FRAME fPage3 = NO
               l-un-neg-item:CHECKED     IN FRAME fPage3 = NO
            &endif
            .

        ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
               c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.

        APPLY "value-changed":U TO i-selecao-cli IN FRAME fPage4.
        APPLY "value-changed":U TO l-item IN FRAME fPage3.
    END.

    ELSE DO: /*CRM*/
        DISABLE l-item-fornec
                l-grupo-cliente
                l-via-transporte
                WITH FRAME fPage3.
        ENABLE  l-referencia 
                l-item-refer 
                l-parametros
                l-portador
                l-item-cliente
		l-motivo-cancel
                l-empresa
                l-estab
                l-serie
                l-natur-oper
                l-cond-pagto
                l-moeda
                l-item
                l-unid-med
                l-grupo-cliente
                l-cliente
                l-fornecedor
                l-transportador
                l-repres
                l-regiao
                l-usuario
                l-tab-preco
                l-ped-venda
                l-nota-fiscal
                l-canal-venda
                l-tp-rec-desp
                l-info-cred
               &if '{&BF_DIS_VERSAO_EMS}' >= '2.04':U &then
                l-cidades-zfm
                l-preco-padrao
                l-estrut-comerc
                l-item-estab
               &endif
                WITH FRAME fPage3.

        /* FO 1703730 - Unidade de Neg¢cio */
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04':U &then
        IF  AVAIL para-dis 
        AND para-dis.log-unid-neg = YES THEN DO:
            ENABLE l-un-neg
                   l-un-neg-fam
                   l-un-neg-item
                   WITH FRAME fPage3.
        END.
        &endif

        ENABLE  f-data-nf-ini
                f-data-nf-fim
                f-data-pedv-ini
                f-data-pedv-fim
                f-item-ini
                f-item-fim
                f-refer-ini
                f-refer-fim
                &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
                f-periodo-cotacao-ini
                f-periodo-cotacao-fim
                f-pais-ini
                f-pais-fim
                f-estado-ini
                f-estado-fim
                &else
                &endif
                i-selecao-cli
                WITH FRAME fPage4.

        ASSIGN l-motivo-cancel:CHECKED   IN FRAME fPage3 = YES
	       l-empresa:CHECKED         IN FRAME fPage3 = YES
               l-estab:CHECKED           IN FRAME fPage3 = YES
               l-serie:CHECKED           IN FRAME fPage3 = YES
               l-natur-oper:CHECKED      IN FRAME fPage3 = YES
               l-cond-pagto:CHECKED      IN FRAME fPage3 = YES
               l-moeda:CHECKED           IN FRAME fPage3 = YES
               l-item:CHECKED            IN FRAME fPage3 = YES
               l-unid-med:CHECKED        IN FRAME fPage3 = YES
               l-item-fornec:CHECKED     IN FRAME fPage3 = NO
               l-grupo-cliente:CHECKED   IN FRAME fPage3 = YES
               l-cliente:CHECKED         IN FRAME fPage3 = YES
               l-fornecedor:CHECKED      IN FRAME fPage3 = YES
               l-transportador:CHECKED   IN FRAME fPage3 = YES
               l-via-transporte:CHECKED  IN FRAME fPage3 = NO
               l-repres:CHECKED          IN FRAME fPage3 = YES
               l-regiao:CHECKED          IN FRAME fPage3 = YES
               l-usuario:CHECKED         IN FRAME fPage3 = YES
               l-tab-preco:CHECKED       IN FRAME fPage3 = YES
               l-ped-venda:CHECKED       IN FRAME fPage3 = YES
               l-nota-fiscal:CHECKED     IN FRAME fPage3 = YES
               l-canal-venda:CHECKED     IN FRAME fPage3 = YES
               l-tp-rec-desp:CHECKED     IN FRAME fPage3 = YES
               l-info-cred:CHECKED       IN FRAME fPage3 = YES
               l-parametros:CHECKED      IN FRAME fPage3 = NO
               l-portador:CHECKED        IN FRAME fPage3 = NO
               l-item-cliente:CHECKED    IN FRAME fPage3 = NO
               l-referencia:CHECKED      IN FRAME fPage3 = NO
               l-item-refer:CHECKED      IN FRAME fPage3 = NO
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
               l-cidades-zfm:CHECKED     IN FRAME fPage3 = YES
               l-preco-padrao:CHECKED    IN FRAME fPage3 = YES
               l-estrut-comerc:CHECKED   IN FRAME fPage3 = YES
               l-item-estab:CHECKED      IN FRAME fPage3 = YES
            &endif
            .

           /* FO 1703730 - Unidade de Neg¢cio */
           &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           IF  AVAIL para-dis 
           AND para-dis.log-unid-neg = YES THEN DO:
               ASSIGN l-un-neg:CHECKED      IN FRAME fPage3 = YES
                      l-un-neg-fam:CHECKED  IN FRAME fPage3 = YES
                      l-un-neg-item:CHECKED IN FRAME fPage3 = YES.
           END.
           &endif
        
        IF l-tab-preco:CHECKED IN FRAME fPage3 = YES THEN
            ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = YES
                   c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = YES.
        ELSE
            ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
                   c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.

        APPLY "value-changed":U TO i-selecao-cli IN FRAME fPage4.
        APPLY "value-changed":U TO l-item IN FRAME fPage3.

        /* XML Cota‡äes de Moedas - Somente dispon¡vel a partir da release 2.04 */
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
            ASSIGN l-cotacoes-moedas:HIDDEN IN FRAME fPage3 = NO.
            ENABLE l-cotacoes-moedas WITH FRAME fPage3.
            ASSIGN l-cotacoes-moedas:CHECKED IN FRAME fPage3 = YES.
            APPLY "value-changed":U TO l-cotacoes-moedas IN FRAME fPage3.
        &else
            ASSIGN l-cotacoes-moedas:HIDDEN IN FRAME fPage3 = YES.
            DISABLE l-cotacoes-moedas WITH FRAME fPage3.
            ASSIGN l-cotacoes-moedas:CHECKED IN FRAME fPage3 = NO.
            APPLY "value-changed":U TO l-cotacoes-moedas IN FRAME fPage3.
        &endif

        /* XML Unidades da Federa‡Æo - Somente dispon¡vel a partir da release 2.04 */
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
            ASSIGN l-unid-feder:HIDDEN IN FRAME fPage3 = NO.
            ENABLE l-unid-feder WITH FRAME fPage3.
            ASSIGN l-unid-feder:CHECKED IN FRAME fPage3 = YES.
            APPLY "value-changed":U TO l-unid-feder IN FRAME fPage3.
        &else
            ASSIGN l-unid-feder:HIDDEN IN FRAME fPage3 = YES.
            DISABLE l-unid-feder WITH FRAME fPage3.
            ASSIGN l-unid-feder:CHECKED IN FRAME fPage3 = NO.
            APPLY "value-changed":U TO l-unid-feder IN FRAME fPage3.
        &endif
        
        IF  l-todos:CHECKED = YES THEN DO:
	    IF l-motivo-cancel:SENSITIVE = YES THEN
               ASSIGN l-motivo-cancel:CHECKED = YES.
            ELSE
               ASSIGN l-motivo-cancel:CHECKED = NO.
	
            IF l-empresa:SENSITIVE = YES THEN
               ASSIGN l-empresa:CHECKED = YES.
            ELSE
                ASSIGN l-empresa:CHECKED = NO.
    
            IF l-estab:SENSITIVE = YES THEN
               ASSIGN l-estab:CHECKED = YES.
            ELSE
               ASSIGN l-estab:CHECKED = NO.

            IF l-serie:SENSITIVE = YES THEN
               ASSIGN l-serie:CHECKED = YES.
            ELSE
                ASSIGN l-serie:CHECKED = NO.
    
            IF l-natur-oper:SENSITIVE = YES THEN
               ASSIGN l-natur-oper:CHECKED = YES.
            ELSE
                ASSIGN l-natur-oper:CHECKED = NO.
    
            IF l-cond-pagto:SENSITIVE = YES THEN
               ASSIGN l-cond-pagto:CHECKED = YES.
            ELSE
                ASSIGN l-cond-pagto:CHECKED = NO.
    
            IF l-moeda:SENSITIVE = YES THEN
               ASSIGN l-moeda:CHECKED = YES.
            ELSE
                ASSIGN l-moeda:CHECKED = NO.
    
            IF l-item:SENSITIVE = YES THEN DO:
               ASSIGN l-item:CHECKED = YES
                      f-item-ini:SENSITIVE IN FRAME fPage4 = YES
                      f-item-fim:SENSITIVE IN FRAME fPage4 = YES.
            END.
            ELSE
                ASSIGN l-item:CHECKED = NO
                       f-item-ini:SENSITIVE = NO
                       f-item-fim:SENSITIVE = NO.
    
            IF l-unid-med:SENSITIVE = YES THEN
               ASSIGN l-unid-med:CHECKED = YES.
            ELSE
                ASSIGN l-unid-med:CHECKED = NO.
    
            IF l-item-fornec:SENSITIVE = YES THEN
               ASSIGN l-item-fornec:CHECKED = YES.
            ELSE
                ASSIGN l-item-fornec:CHECKED = NO.
    
            IF l-grupo-cliente:SENSITIVE = YES THEN
               ASSIGN l-grupo-cliente:CHECKED = YES.
            ELSE
                ASSIGN l-grupo-cliente:CHECKED = NO.
    
            IF l-cliente:SENSITIVE = YES THEN
               ASSIGN l-cliente:CHECKED = YES
                      f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = YES
                      f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = YES.
            ELSE
                ASSIGN l-cliente:CHECKED = NO
                       f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = NO
                       f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = NO.
    
            IF l-fornecedor:SENSITIVE = YES THEN
               ASSIGN l-fornecedor:CHECKED = YES.
            ELSE
                ASSIGN l-fornecedor:CHECKED = NO.
    
            IF l-transportador:SENSITIVE = YES THEN
               ASSIGN l-transportador:CHECKED = YES.
            ELSE
                ASSIGN l-transportador:CHECKED = NO.
    
            IF l-via-transporte:SENSITIVE = YES THEN
               ASSIGN l-via-transporte:CHECKED = YES.
            ELSE
                ASSIGN l-via-transporte:CHECKED = NO.
    
            IF l-repres:SENSITIVE = YES THEN
               ASSIGN l-repres:CHECKED = YES.
            ELSE
                ASSIGN l-repres:CHECKED = NO.
    
            IF l-regiao:SENSITIVE = YES THEN
               ASSIGN l-regiao:CHECKED = YES.
            ELSE
                ASSIGN l-regiao:CHECKED = NO.
    
             IF l-usuario:SENSITIVE = YES THEN
                ASSIGN l-usuario:CHECKED = YES.
             ELSE
                 ASSIGN l-usuario:CHECKED = NO.
            
             IF l-tab-preco:SENSITIVE = YES THEN
                ASSIGN l-tab-preco:CHECKED = YES
                       c-nr-tab-ini:SENSITIVE = YES
                       c-nr-tab-fim:SENSITIVE = YES.
             ELSE
                 ASSIGN l-tab-preco:CHECKED = NO
                        c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
                        c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.
    
             IF l-ped-venda:SENSITIVE = YES THEN
                ASSIGN l-ped-venda:CHECKED = YES.
             ELSE 
                 ASSIGN l-ped-venda:CHECKED = NO.
    
             IF l-nota-fiscal:SENSITIVE = YES THEN
                ASSIGN l-nota-fiscal:CHECKED = YES.
             ELSE
                ASSIGN l-nota-fiscal:CHECKED = NO.
    
             IF l-canal-venda:SENSITIVE = YES THEN
                ASSIGN l-canal-venda:CHECKED = YES.
             ELSE
                 ASSIGN l-canal-venda:CHECKED = NO.
    
             IF l-tp-rec-desp:SENSITIVE = YES THEN
                ASSIGN l-tp-rec-desp:CHECKED = YES.
             ELSE
                 ASSIGN l-tp-rec-desp:CHECKED = NO.
    
             IF l-info-cred:SENSITIVE = YES THEN
                ASSIGN l-info-cred:CHECKED = YES.
             ELSE
                 ASSIGN l-info-cred:CHECKED = NO.
    
             IF l-cotacoes-moedas:SENSITIVE = YES THEN
                ASSIGN l-cotacoes-moedas:CHECKED = YES.
             ELSE
                  ASSIGN l-cotacoes-moedas:CHECKED = NO.
    
             IF l-unid-feder:SENSITIVE = YES THEN
                ASSIGN l-unid-feder:CHECKED = YES.
             ELSE
                 ASSIGN l-unid-feder:CHECKED = NO.
    
             IF l-cidades-zfm:SENSITIVE = YES THEN
                ASSIGN l-cidades-zfm:CHECKED = YES.
             ELSE
                 ASSIGN l-cidades-zfm:CHECKED = NO.
    
             IF l-referencia:SENSITIVE = YES THEN
                ASSIGN l-referencia:CHECKED = YES
                       f-refer-ini:SENSITIVE = YES
                       f-refer-fim:SENSITIVE = YES.
             ELSE
                 ASSIGN l-referencia:CHECKED = NO
                        f-refer-ini:SENSITIVE = NO
                        f-refer-fim:SENSITIVE = NO.

            IF l-portador:SENSITIVE = YES THEN
                ASSIGN  l-portador:CHECKED = YES.
            ELSE
                ASSIGN l-portador:CHECKED = NO.

            IF l-item-cliente:SENSITIVE = YES THEN
                ASSIGN l-item-cliente:CHECKED = YES
                       f-item-ini:SENSITIVE     IN FRAME fPage4 = YES
                       f-item-fim:SENSITIVE     IN FRAME fPage4 = YES.
            ELSE
                ASSIGN l-item-cliente:CHECKED = NO
                       f-item-ini:SENSITIVE     IN FRAME fPage4 = NO
                       f-item-fim:SENSITIVE     IN FRAME fPage4 = NO.

             IF l-parametros:SENSITIVE = YES THEN
                ASSIGN  l-parametros:CHECKED = YES.
             ELSE
                ASSIGN  l-parametros:CHECKED = NO.

             /* FO 1703730 - Unidade de Neg¢cio */
             ASSIGN l-un-neg:CHECKED      = l-un-neg:SENSITIVE
                    l-un-neg-fam:CHECKED  = l-un-neg-fam:SENSITIVE
                    l-un-neg-item:CHECKED = l-un-neg-item:SENSITIVE.

             IF l-item-refer:SENSITIVE = YES THEN
                ASSIGN l-item-refer:CHECKED = YES
                       f-item-ini:SENSITIVE = YES
                       f-item-fim:SENSITIVE = YES.
    
            ELSE
                ASSIGN l-item-refer:CHECKED = NO
                       f-item-ini:SENSITIVE = NO
                       f-item-fim:SENSITIVE = NO.
    
             IF l-preco-padrao:SENSITIVE = YES THEN
                 ASSIGN l-preco-padrao = true
                        l-preco-padrao:CHECKED = YES.
              ELSE
                 ASSIGN l-preco-padrao:CHECKED = NO.
   
             IF l-estrut-comerc:SENSITIVE = YES THEN
                 ASSIGN l-estrut-comerc = TRUE 
                        l-estrut-comerc:CHECKED = YES.
             ELSE
                 ASSIGN l-estrut-comerc:CHECKED = NO.

             IF l-item-estab:SENSITIVE = YES THEN
                ASSIGN l-item-estab:CHECKED = YES
                       f-item-ini:SENSITIVE = YES
                       f-item-fim:SENSITIVE = YES.
    
            ELSE
                ASSIGN l-item-estab:CHECKED = NO
                       f-item-ini:SENSITIVE = NO
                       f-item-fim:SENSITIVE = NO.
    
        END.
        ELSE DO:
	     IF l-motivo-cancel:SENSITIVE = YES THEN
                ASSIGN l-motivo-cancel:CHECKED = NO.
		
             IF l-empresa:SENSITIVE = YES THEN
                ASSIGN l-empresa:CHECKED = NO.
    
             IF l-estab:SENSITIVE = YES THEN
                ASSIGN l-estab:CHECKED = NO.
    
             IF l-serie:SENSITIVE = YES THEN
                ASSIGN l-serie:CHECKED = NO.
    
             IF l-natur-oper:SENSITIVE = YES THEN
              ASSIGN l-natur-oper:CHECKED = NO.
    
             IF l-cond-pagto:SENSITIVE = YES THEN
              ASSIGN l-cond-pagto:CHECKED = NO.
    
             IF l-moeda:SENSITIVE = YES THEN
              ASSIGN l-moeda:CHECKED = NO.
    
             IF l-item:SENSITIVE = YES THEN
              ASSIGN l-item:CHECKED = NO
                     f-item-ini:SENSITIVE IN FRAME fPage4 = NO
                     f-item-fim:SENSITIVE IN FRAME fPage4 = NO.
    
             IF l-unid-med:SENSITIVE = YES THEN
              ASSIGN l-unid-med:CHECKED = NO.
    
             IF l-item-fornec:SENSITIVE = YES THEN
              ASSIGN l-item-fornec:CHECKED = NO.
    
             IF l-grupo-cliente:SENSITIVE = YES THEN
              ASSIGN l-grupo-cliente:CHECKED = NO.
    
             IF l-cliente:SENSITIVE = YES THEN
              ASSIGN l-cliente:CHECKED = NO
                     f-nome-abrev-ini:SENSITIVE IN FRAME fPage4 = NO
                     f-nome-abrev-fim:SENSITIVE IN FRAME fPage4 = NO.
    
             IF l-fornecedor:SENSITIVE = YES THEN
              ASSIGN l-fornecedor:CHECKED = NO.
    
             IF l-transportador:SENSITIVE = YES THEN
              ASSIGN l-transportador:CHECKED = NO.
    
            IF l-via-transporte:SENSITIVE = YES THEN
              ASSIGN l-via-transporte:CHECKED = NO.
    
            IF l-repres:SENSITIVE = YES THEN
              ASSIGN l-repres:CHECKED = NO.
    
            IF l-regiao:SENSITIVE = YES THEN
              ASSIGN l-regiao:CHECKED = NO.
    
            IF l-usuario:SENSITIVE = YES THEN
               ASSIGN l-usuario:CHECKED = NO.
    
            IF l-tab-preco:SENSITIVE = YES THEN
               ASSIGN l-tab-preco:CHECKED = NO
                      c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
                      c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.
    
            IF l-ped-venda:SENSITIVE = YES THEN
               ASSIGN l-ped-venda:CHECKED = NO.
    
            IF l-nota-fiscal:SENSITIVE = YES THEN
               ASSIGN l-nota-fiscal:CHECKED = NO.
    
            IF l-canal-venda:SENSITIVE = YES THEN
               ASSIGN l-canal-venda:CHECKED = NO.
    
            IF l-tp-rec-desp:SENSITIVE = YES THEN
               ASSIGN l-tp-rec-desp:CHECKED = NO.
    
            IF l-info-cred:SENSITIVE = YES THEN
               ASSIGN l-info-cred:CHECKED = NO.
    
            IF l-cotacoes-moedas:SENSITIVE = YES THEN
               ASSIGN l-cotacoes-moedas:CHECKED = NO.
    
            IF l-unid-feder:SENSITIVE = YES THEN
               ASSIGN l-unid-feder:CHECKED = NO.
    
            IF l-cidades-zfm:SENSITIVE = YES THEN
               ASSIGN l-cidades-zfm:CHECKED = NO.
    
            IF l-referencia:SENSITIVE = YES THEN
               ASSIGN l-referencia:CHECKED = NO
                      f-refer-ini:SENSITIVE = NO
                      f-refer-fim:SENSITIVE = NO.

            IF l-portador:SENSITIVE = YES THEN
                ASSIGN l-portador:CHECKED = NO.

            IF l-item-cliente:SENSITIVE = YES THEN
                ASSIGN l-item-cliente:CHECKED = NO
                       f-item-ini:SENSITIVE     IN FRAME fPage4 = NO
                       f-item-fim:SENSITIVE     IN FRAME fPage4 = NO.

            IF l-parametros:SENSITIVE = YES THEN
                ASSIGN l-parametros:CHECKED = NO.

            /* FO 1703730 - Unidade de Neg¢cio */
            IF l-un-neg:SENSITIVE = YES THEN
                ASSIGN l-un-neg:CHECKED = NO.
            
            IF l-un-neg-fam:SENSITIVE = YES THEN
                ASSIGN l-un-neg-fam:CHECKED = NO.
            
            IF l-un-neg-item:SENSITIVE = YES THEN
                ASSIGN l-un-neg-item:CHECKED = NO.
                                    
            IF l-item-refer:SENSITIVE = YES THEN
               ASSIGN l-item-refer:CHECKED = NO
                      f-item-ini:SENSITIVE = NO
                      f-item-fim:SENSITIVE = NO.
       
            IF l-preco-padrao:SENSITIVE = YES THEN
               ASSIGN l-preco-padrao:CHECKED = NO.

            IF l-estrut-comerc:SENSITIVE = YES THEN
               ASSIGN l-estrut-comerc:CHECKED = NO.
    
            IF l-item-estab:SENSITIVE = YES THEN
               ASSIGN l-item-estab:CHECKED = NO
                      f-item-ini:SENSITIVE = NO
                      f-item-fim:SENSITIVE = NO.
        END.          

    END.
    APPLY "value-changed":U TO l-todos IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializa‡Æo do programa ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wReport 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'VALUE-CHANGED':U TO rs-gera-carga IN FRAME fPage2.

/*APPLY 'VALUE-CHANGED':U TO l-nota-fiscal IN FRAME fPage3.
APPLY 'VALUE-CHANGED':U TO l-ped-venda   IN FRAME fPage3.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY 'VALUE-CHANGED':U TO rs-gera-carga IN FRAME fPage2.

/*APPLY 'VALUE-CHANGED':U TO l-nota-fiscal IN FRAME fPage3.
APPLY 'VALUE-CHANGED':U TO l-ped-venda   IN FRAME fPage3.*/

ASSIGN l-todos:SENSITIVE IN FRAME fpage3 = YES.
ASSIGN l-todos:CHECKED IN FRAME fpage3 = YES.
APPLY "value-changed":U TO l-todos IN FRAME fPage3.

 ASSIGN f-data-pedv-ini:SCREEN-VALUE      IN FRAME fPage4 = string(TODAY,'99/99/9999')
       f-data-pedv-fim:SCREEN-VALUE      IN FRAME fPage4 = string(TODAY,'99/99/9999')
       f-data-nf-ini:SCREEN-VALUE        IN FRAME fPage4 = string(TODAY,'99/99/9999')
       f-data-nf-fim:SCREEN-VALUE        IN FRAME fPage4 = string(TODAY,'99/99/9999')
       f-cod-emit-ini:SCREEN-VALUE       IN FRAME fPage4 = "0"
       f-cod-emit-fim:SCREEN-VALUE       IN FRAME fPage4 = "999999999"
       f-nome-abrev-ini:SCREEN-VALUE     IN FRAME fPage4 = ""
       f-nome-abrev-fim:SCREEN-VALUE     IN FRAME fPage4 = "ZZZZZZZZZZZZ"
       f-item-ini:SCREEN-VALUE           IN FRAME fPage4 = ""
       f-item-fim:SCREEN-VALUE           IN FRAME fPage4 = "ZZZZZZZZZZZZZZZZ"
       c-nr-tab-ini:SCREEN-VALUE         IN FRAME fPage4 = ""
       f-refer-ini:SCREEN-VALUE          IN FRAME fPage4 = ""
       f-refer-fim:SCREEN-VALUE          IN FRAME fPage4 = "ZZZZZZZZZZZZZZZZ"
       c-nr-tab-fim:SCREEN-VALUE         IN FRAME fPage4 = "ZZZZZZZZ".


/* XML Cota‡äes de Moedas - Somente dispon¡vel a partir da release 2.04 */
&if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    assign l-cotacoes-moedas:hidden     in frame fPage3 = no
           f-periodo-cotacao-ini:hidden in frame fPage4 = no
           f-periodo-cotacao-fim:hidden in frame fPage4 = no
           image-76:hidden              in frame fPage4 = no
           image-77:hidden              in frame fPage4 = no.
&else
    assign l-cotacoes-moedas:hidden     in frame fPage3 = yes
           f-periodo-cotacao-ini:hidden in frame fPage4 = yes
           f-periodo-cotacao-fim:hidden in frame fPage4 = yes
           image-76:hidden              in frame fPage4 = yes
           image-77:hidden              in frame fPage4 = yes.
&endif

/* XML Unidades Federa‡Æo - Somente dispon¡vel a partir da release 2.04 */
&if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    assign l-unid-feder:hidden in frame fPage3 = no
           l-cidades-zfm:hidden in frame fPage3 = no
           f-pais-ini:hidden   in frame fPage4 = no
           f-pais-fim:hidden   in frame fPage4 = no
           f-estado-ini:hidden in frame fPage4 = no
           f-estado-fim:hidden in frame fPage4 = no
           image-78:hidden     in frame fPage4 = no
           image-79:hidden     in frame fPage4 = no
           image-80:hidden     in frame fPage4 = no
           image-81:hidden     in frame fPage4 = no.
&else
    assign l-unid-feder:hidden in frame fPage3 = yes
           l-cidades-zfm:hidden in frame fPage3 = yes
           f-pais-ini:hidden   in frame fPage4 = yes
           f-pais-fim:hidden   in frame fPage4 = yes
           f-estado-ini:hidden in frame fPage4 = yes
           f-estado-fim:hidden in frame fPage4 = yes
           image-78:hidden     in frame fPage4 = yes
           image-79:hidden     in frame fPage4 = yes
           image-80:hidden     in frame fPage4 = yes
           image-81:hidden     in frame fPage4 = yes.
&endif

/* FO 1703730 - Unidade de Neg¢cio */
/* XML Unidades Negocio - Somente dispon¡vel a partir da release 2.04 */
&if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    ASSIGN l-un-neg:HIDDEN      IN FRAME fPage3 = NO
           l-un-neg-fam:HIDDEN  IN FRAME fPage3 = NO
           l-un-neg-item:HIDDEN IN FRAME fPage3 = NO.
&else
    ASSIGN l-un-neg:HIDDEN      IN FRAME fPage3 = YES
           l-un-neg-fam:HIDDEN  IN FRAME fPage3 = YES
           l-un-neg-item:HIDDEN IN FRAME fPage3 = YES.
&endif

IF l-tab-preco:CHECKED IN FRAME fPage3 = YES THEN
    ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = YES
           c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = YES.
ELSE
    ASSIGN c-nr-tab-ini:SENSITIVE IN FRAME fPage4 = NO
           c-nr-tab-fim:SENSITIVE IN FRAME fPage4 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

    /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.l-referencia      = INPUT FRAME fPage3 l-referencia          
           tt-param.l-item-refer      = INPUT FRAME fPage3 l-item-refer
           tt-param.l-portador        = INPUT FRAME fPage3 l-portador
           tt-param.l-item-cliente    = INPUT FRAME fPage3 l-item-cliente
           tt-param.l-parametros      = INPUT FRAME fPage3 l-parametros
           tt-param.usuario           = c-seg-usuario
           tt-param.destino           = input frame fPage6 rsDestiny
           tt-param.data-exec         = today
           tt-param.hora-exec         = time
	   tt-param.l-motivo-cancel   = INPUT FRAME fPage3 l-motivo-cancel
           tt-param.l-empresa         = INPUT FRAME fPage3 l-empresa          
           tt-param.l-estab           = INPUT FRAME fPage3 l-estab          
           tt-param.l-serie           = INPUT FRAME fPage3 l-serie          
           tt-param.l-natur-oper      = INPUT FRAME fPage3 l-natur-oper     
           tt-param.l-cond-pagto      = INPUT FRAME fPage3 l-cond-pagto     
           tt-param.l-moeda           = INPUT FRAME fPage3 l-moeda          
           tt-param.l-item            = INPUT FRAME fPage3 l-item           
           tt-param.l-unid-med        = INPUT FRAME fPage3 l-unid-med       
           tt-param.l-item-fornec     = INPUT FRAME fPage3 l-item-fornec    
           tt-param.l-grupo-cliente   = INPUT FRAME fPage3 l-grupo-cliente  
           tt-param.l-cliente         = INPUT FRAME fPage3 l-cliente        
           tt-param.l-fornecedor      = INPUT FRAME fPage3 l-fornecedor     
           tt-param.l-transportador   = INPUT FRAME fPage3 l-transportador  
           tt-param.l-via-transporte  = INPUT FRAME fPage3 l-via-transporte 
           tt-param.l-repres          = INPUT FRAME fPage3 l-repres         
           tt-param.l-regiao          = INPUT FRAME fPage3 l-regiao         
           tt-param.l-usuario         = INPUT FRAME fPage3 l-usuario
           tt-param.l-tab-preco       = INPUT FRAME fPage3 l-tab-preco
           tt-param.l-ped-venda       = INPUT FRAME fPage3 l-ped-venda
           tt-param.f-data-pedv-ini   = INPUT FRAME fPage4 f-data-pedv-ini
           tt-param.f-data-pedv-fim   = INPUT FRAME fPage4 f-data-pedv-fim
           tt-param.l-nota-fiscal     = INPUT FRAME fPage3 l-nota-fiscal
           tt-param.f-data-nf-ini     = INPUT FRAME fPage4 f-data-nf-ini
           tt-param.f-data-nf-fim     = INPUT FRAME fPage4 f-data-nf-fim
           tt-param.l-canal-venda     = INPUT FRAME fPage3 l-canal-venda
           tt-param.l-tp-rec-desp     = INPUT FRAME fPage3 l-tp-rec-desp
           tt-param.f-cod-emit-ini    = INPUT FRAME fPage4 f-cod-emit-ini
           tt-param.f-cod-emit-fim    = INPUT FRAME fPage4 f-cod-emit-fim
           tt-param.f-item-ini        = INPUT FRAME fPage4 f-item-ini
           tt-param.f-item-fim        = INPUT FRAME fPage4 f-item-fim
           tt-param.f-refer-ini       = INPUT FRAME fPage4 f-refer-ini
           tt-param.f-refer-fim       = INPUT FRAME fPage4 f-refer-fim

           tt-param.f-nome-abrev-ini  = INPUT FRAME fPage4 f-nome-abrev-ini
           tt-param.f-nome-abrev-fim  = INPUT FRAME fPage4 f-nome-abrev-fim
           tt-param.l-info-cred       = INPUT FRAME fPage3 l-info-cred
           tt-param.i-selecao-cli     = INPUT FRAME fPage4 i-selecao-cli
           tt-param.l-cotacoes-moedas     = INPUT FRAME fPage3 l-cotacoes-moedas
           tt-param.f-periodo-cotacao-ini = INPUT FRAME fPage4 f-periodo-cotacao-ini
           tt-param.f-periodo-cotacao-fim = INPUT FRAME fPage4 f-periodo-cotacao-fim
           tt-param.l-unid-feder      = INPUT FRAME fPage3 l-unid-feder
           tt-param.f-pais-ini        = INPUT FRAME fPage4 f-pais-ini
           tt-param.f-pais-fim        = INPUT FRAME fPage4 f-pais-fim
           tt-param.f-estado-ini      = INPUT FRAME fPage4 f-estado-ini
           tt-param.f-estado-fim      = INPUT FRAME fPage4 f-estado-fim
           tt-param.i-destino-dados   = INPUT FRAME fPage2 rs-gera-carga    /* 1 = Neogrid | 2 = CRM */
           tt-param.c-itens-export    = INPUT FRAME fPage2 cb-itens-export /* 1 = Fatur veis | 2 = NÆo Fatur veis | 3 = Ambos */
           tt-param.c-tab-pre-ini     = INPUT FRAME fPage4 c-nr-tab-ini
           tt-param.c-tab-pre-fim     = INPUT FRAME fPage4 c-nr-tab-fim
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           tt-param.l-cidades-zfm      = INPUT FRAME fPage3 l-cidades-zfm
           tt-param.l-preco-padrao    = INPUT FRAME fPage3 l-preco-padrao          
           tt-param.l-estrut-comerc   = INPUT FRAME fPage3 l-estrut-comerc          
           tt-param.l-item-estab      = INPUT FRAME fPage3 l-item-estab

           /* FO 1703730 - Unidade de Neg¢cio */
           tt-param.l-un-neg          = INPUT FRAME fPage3 l-un-neg
           tt-param.l-un-neg-fam      = INPUT FRAME fPage3 l-un-neg-fam
           tt-param.l-un-neg-item     = INPUT FRAME fPage3 l-un-neg-item

        &endif
        .

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

    IF  c-nom-prog-upc-mg97 <> ""
    AND c-nom-prog-upc-mg97 <> ? THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-RUN-RP", 
                                        INPUT "tt-param",
                                        INPUT TEMP-TABLE tt-param:HANDLE,
                                        INPUT THIS-PROCEDURE,
                                        INPUT ?,
                                        INPUT ?).
    END.



    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    /*--- CHAMADA AO RP ---*/
    {report/rprun.i adapters\neogrid\ftp\ane123rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaSelecao wReport 
PROCEDURE VerificaSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-erro = NO.

    ASSIGN FRAME fPage3
        l-motivo-cancel
        l-empresa
        l-estab
        l-serie
        l-natur-oper
        l-cond-pagto
        l-moeda
        l-item
        l-unid-med
        l-item-fornec
        l-grupo-cliente
        l-cliente
        l-fornecedor
        l-transportador
        l-via-transporte
        l-repres
        l-regiao
        l-usuario
        l-tab-preco
        l-ped-venda
        l-nota-fiscal
        l-canal-venda
        l-tp-rec-desp
        l-info-cred.

    IF  NOT l-motivo-cancel   AND
        NOT l-empresa         AND
        NOT l-estab           AND
        NOT l-serie           AND
        NOT l-natur-oper      AND
        NOT l-cond-pagto      AND
        NOT l-moeda           AND
        NOT l-item            AND
        NOT l-unid-med        AND
        NOT l-item-fornec     AND
        NOT l-grupo-cliente   AND
        NOT l-cliente         AND
        NOT l-fornecedor      AND
        NOT l-transportador   AND
        NOT l-via-transporte  AND
        NOT l-repres          AND
        NOT l-regiao          AND
        NOT l-usuario         AND
        NOT l-tab-preco       AND 
        NOT l-ped-venda       AND 
        NOT l-nota-fiscal     AND
        NOT l-canal-venda     AND
        NOT l-tp-rec-desp     AND 
        NOT l-info-cred       THEN DO:

        ASSIGN l-erro = YES.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 15825,
                           INPUT "Favor selecionar um arquivo a ser gerado!").
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

