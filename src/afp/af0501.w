&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0501 2.00.00.003 } /*** 010003 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

def var raw-param as raw no-undo.
def temp-table tt-raw-digita field raw-digita as RAW.

def var l-ok as logical no-undo.
def var c-arq-digita as char no-undo.
def var c-terminal as char no-undo.



/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL  f-pg-sel
&GLOBAL-DEFINE PGDIG  
&GLOBAL-DEFINE PGCLA  f-pg-cla
&GLOBAL-DEFINE PGPAR  f-pg-par
&GLOBAL-DEFINE PGIMP  f-pg-imp

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

{afp/af0501.i} /*Definiªío da tt-param*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.


def var h-boaf008 as handle no-undo.
def var c-dt-indice as char no-undo.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
/*DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.*/
/*-----------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-15 cb-classificacao1 cb-classificacao2 ~
cb-classificacao3 cb-classificacao4 cb-classificacao5 
&Scoped-Define DISPLAYED-OBJECTS cb-classificacao1 cb-classificacao2 ~
cb-classificacao3 cb-classificacao4 cb-classificacao5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-classificacao1 AS CHARACTER FORMAT "X(256)":U INITIAL "Estabelecimento" 
     LABEL "1a Classificacao" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Estabelecimento","Data ÷ndice","Fornecedor","Item","Ponto de Controle","---- Nenhuma ----" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classificacao2 AS CHARACTER FORMAT "X(256)":U INITIAL "Data ÷ndice" 
     LABEL "2a Classificacao" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Estabelecimento","Data ÷ndice","Fornecedor","Item","Ponto de Controle","---- Nenhuma ----" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classificacao3 AS CHARACTER FORMAT "X(256)":U INITIAL "Fornecedor" 
     LABEL "3a Classificacao" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Estabelecimento","Data ÷ndice","Fornecedor","Item","Ponto de Controle","---- Nenhuma ----" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classificacao4 AS CHARACTER FORMAT "X(256)":U INITIAL "Item" 
     LABEL "4a Classificacao" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Estabelecimento","Data ÷ndice","Fornecedor","Item","Ponto de Controle","---- Nenhuma ----" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classificacao5 AS CHARACTER FORMAT "X(256)":U INITIAL "Ponto de Controle" 
     LABEL "5a Classificacao" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Estabelecimento","Data ÷ndice","Fornecedor","Item","Ponto de Controle","---- Nenhuma ----" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 7.5.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.29 BY .75 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-1 AS CHARACTER FORMAT "X(20)":U INITIAL "Situaá∆o dos ÷ndices" 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-2 AS CHARACTER FORMAT "X(15)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE i-mensagem AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Mensagem Padr∆o" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-situacao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "N∆o Digitados", 1,
"Digitados / Calculados", 2
     SIZE 31 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 4.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.25.

DEFINE VARIABLE l-descricao-item AS LOGICAL INITIAL no 
     LABEL "Descriá∆o Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE l-detalha-itens AS LOGICAL INITIAL yes 
     LABEL "÷ndice detalhado por item" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE VARIABLE l-email AS LOGICAL INITIAL no 
     LABEL "Envia e-mail Grupo Responsavel" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.

DEFINE VARIABLE l-indice-zerado AS LOGICAL INITIAL no 
     LABEL "÷ndices digitados com valor zero" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .83 NO-UNDO.

DEFINE VARIABLE l-narrativa AS LOGICAL INITIAL no 
     LABEL "Narrativa ÷ndice" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE l-pula-linha AS LOGICAL INITIAL yes 
     LABEL "Linha em branco" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 NO-UNDO.

DEFINE VARIABLE cb-ano-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ano-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per°odo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-fim AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-ini AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-grp-aval-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-grp-aval-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Grupo Avaliaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-fim AS CHARACTER FORMAT "X(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-ini AS CHARACTER FORMAT "X(8)" 
     LABEL "Grupo Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88.

DEFINE VARIABLE c-fm-codigo-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam°lia":R9 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE i-cod-gr-forn-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE i-cod-gr-forn-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE i-ge-codigo-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE i-ge-codigo-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE i-nr-controle-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-nr-controle-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE IMAGE IMAGE-101
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-102
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-103
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-104
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-65
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-70
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-71
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-74
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-79
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-81
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-82
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-83
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-84
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-85
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-86
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-87
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-88
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 12
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.75 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.75 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.75 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.5 COL 2
     rt-folder AT ROW 2.5 COL 2
     RECT-6 AT ROW 14.25 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 3.13 COL 80.29
     rt-folder-left AT ROW 2.54 COL 2.14
     im-pg-cla AT ROW 1.5 COL 18
     im-pg-imp AT ROW 1.5 COL 50
     im-pg-par AT ROW 1.5 COL 34
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15.13
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-cla
     cb-classificacao1 AT ROW 3 COL 29 COLON-ALIGNED
     cb-classificacao2 AT ROW 4.25 COL 29 COLON-ALIGNED
     cb-classificacao3 AT ROW 5.5 COL 29 COLON-ALIGNED
     cb-classificacao4 AT ROW 6.75 COL 29 COLON-ALIGNED
     cb-classificacao5 AT ROW 8 COL 29 COLON-ALIGNED
     RECT-15 AT ROW 2.25 COL 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.31.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 3 COL 6.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 4.21 COL 46.14 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 4.25 COL 6.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     bt-arquivo AT ROW 4.25 COL 46 HELP
          "Escolha do nome do arquivo"
     rs-execucao AT ROW 6.38 COL 5.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 2.25 COL 6.72 NO-LABEL
     text-modo AT ROW 5.63 COL 4.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 2.54 COL 5
     RECT-9 AT ROW 5.92 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-par
     i-situacao AT ROW 2.25 COL 10 NO-LABEL
     l-email AT ROW 5 COL 10
     i-mensagem AT ROW 5.75 COL 22 COLON-ALIGNED
     c-descricao AT ROW 5.75 COL 31 COLON-ALIGNED NO-LABEL
     l-indice-zerado AT ROW 7.71 COL 10
     l-narrativa AT ROW 8.5 COL 10
     l-descricao-item AT ROW 9.29 COL 10
     l-detalha-itens AT ROW 10.08 COL 10
     l-pula-linha AT ROW 10.92 COL 10
     c-text-1 AT ROW 1.25 COL 9 NO-LABEL
     c-text-2 AT ROW 7 COL 9 NO-LABEL
     "E-mail" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 4.25 COL 10
     RECT-12 AT ROW 1.5 COL 6
     RECT-13 AT ROW 7.25 COL 6
     RECT-16 AT ROW 4.5 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.14 ROW 3
         SIZE 74.72 BY 11.04.

DEFINE FRAME f-pg-sel
     c-cod-estabel-ini AT ROW 1.5 COL 26 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 1.5 COL 42 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     cb-ano-ini AT ROW 2.5 COL 8 COLON-ALIGNED
     cb-periodo-ini AT ROW 2.5 COL 17 COLON-ALIGNED NO-LABEL
     cb-ano-fim AT ROW 2.5 COL 42 COLON-ALIGNED NO-LABEL
     cb-periodo-fim AT ROW 2.5 COL 51 COLON-ALIGNED NO-LABEL
     i-cod-emitente-ini AT ROW 3.75 COL 22 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     i-cod-emitente-fim AT ROW 3.75 COL 42 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     c-it-codigo-ini AT ROW 4.75 COL 16 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-codigo-fim AT ROW 4.75 COL 42 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     i-nr-controle-ini AT ROW 5.75 COL 23 COLON-ALIGNED HELP
          "N£mero do ponto de controle"
     i-nr-controle-fim AT ROW 5.75 COL 42 COLON-ALIGNED HELP
          "N£mero do ponto de controle" NO-LABEL
     i-cod-gr-forn-ini AT ROW 6.75 COL 28 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores"
     i-cod-gr-forn-fim AT ROW 6.75 COL 42 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores" NO-LABEL
     c-fm-codigo-ini AT ROW 7.75 COL 18 COLON-ALIGNED HELP
          "Fam°lia de material a que pertence o item"
     c-fm-codigo-fim AT ROW 7.75 COL 42 COLON-ALIGNED HELP
          "Fam°lia de material a que pertence o item" NO-LABEL
     i-ge-codigo-ini AT ROW 8.75 COL 28 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item"
     i-ge-codigo-fim AT ROW 8.75 COL 42 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item" NO-LABEL
     c-cod-grp-aval-ini AT ROW 9.75 COL 19 COLON-ALIGNED HELP
          "C¢digo do grupo de avaliaá∆o"
     c-cod-grp-aval-fim AT ROW 9.75 COL 42 COLON-ALIGNED HELP
          "C¢digo do grupo de avaliaá∆o" NO-LABEL
     c-cod-grp-resp-ini AT ROW 10.75 COL 19 COLON-ALIGNED
     c-cod-grp-resp-fim AT ROW 10.75 COL 42 COLON-ALIGNED NO-LABEL
     IMAGE-101 AT ROW 9.75 COL 36
     IMAGE-102 AT ROW 9.75 COL 40
     IMAGE-103 AT ROW 10.75 COL 36
     IMAGE-104 AT ROW 10.75 COL 40
     IMAGE-65 AT ROW 1.5 COL 36
     IMAGE-67 AT ROW 4.75 COL 36
     IMAGE-69 AT ROW 1.5 COL 40
     IMAGE-70 AT ROW 2.5 COL 36
     IMAGE-71 AT ROW 2.5 COL 40
     IMAGE-72 AT ROW 3.75 COL 36
     IMAGE-74 AT ROW 3.75 COL 40
     IMAGE-79 AT ROW 4.75 COL 40
     IMAGE-81 AT ROW 5.75 COL 36
     IMAGE-82 AT ROW 5.75 COL 40
     IMAGE-83 AT ROW 6.75 COL 36
     IMAGE-84 AT ROW 6.75 COL 40
     IMAGE-85 AT ROW 7.75 COL 36
     IMAGE-86 AT ROW 7.75 COL 40
     IMAGE-87 AT ROW 8.75 COL 36
     IMAGE-88 AT ROW 8.75 COL 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 3.25
         SIZE 75.57 BY 10.92.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Relat¢rio ÷ndices dos Pontos de Controle"
         HEIGHT             = 15.25
         WIDTH              = 81
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-1 IN FRAME f-pg-par
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-text-2 IN FRAME f-pg-par
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX l-indice-zerado IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-narrativa IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Relat¢rio ÷ndices dos Pontos de Controle */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Relat¢rio ÷ndices dos Pontos de Controle */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME cb-ano-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-fim w-relat
ON VALUE-CHANGED OF cb-ano-fim IN FRAME f-pg-sel
DO:
  RUN pi-preenche-periodo-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-ini w-relat
ON VALUE-CHANGED OF cb-ano-ini IN FRAME f-pg-sel /* Per°odo */
DO:
  RUN pi-preenche-periodo-ini.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME cb-classificacao1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-classificacao1 w-relat
ON VALUE-CHANGED OF cb-classificacao1 IN FRAME f-pg-cla /* 1a Classificacao */
DO:
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME i-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mensagem w-relat
ON F5 OF i-mensagem IN FRAME f-pg-par /* Mensagem Padr∆o */
DO:
  
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=i-mensagem
                       &campozoom=cod-mensagem
                       &frame=f-pg-par}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mensagem w-relat
ON LEAVE OF i-mensagem IN FRAME f-pg-par /* Mensagem Padr∆o */
DO:
  
    FIND FIRST mensagem WHERE 
        mensagem.cod-mensagem = INPUT FRAME f-pg-par i-mensagem NO-LOCK NO-ERROR.
    IF AVAIL mensagem THEN
        ASSIGN c-descricao:SCREEN-VALUE IN FRAME f-pg-par = mensagem.descricao.
    ELSE
        ASSIGN c-descricao:SCREEN-VALUE IN FRAME f-pg-par = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mensagem w-relat
ON MOUSE-SELECT-DBLCLICK OF i-mensagem IN FRAME f-pg-par /* Mensagem Padr∆o */
DO:
  
    APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-situacao w-relat
ON VALUE-CHANGED OF i-situacao IN FRAME f-pg-par
DO:
  if self:screen-value = "1" then do:
     disable l-indice-zerado
             l-narrativa with frame f-pg-par.
     assign l-narrativa:checked in frame f-pg-par = no.
     enable l-detalha-itens with frame f-pg-par.
  end.
  else do:
     enable l-indice-zerado
            l-narrativa with frame f-pg-par.
     disable l-detalha-itens with frame f-pg-par.
     assign l-detalha-itens:checked in frame f-pg-par = yes
            l-pula-linha:checked in frame f-pg-par = yes.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "AF0501" "2.00.00.002"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i im-pg-sel}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    {utp/ut-liter.i Seleá∆o-2 * R}
     RUN enable_UI.

    {include/i-rpmbl.i}

    RUN pi-preenche-periodo.
    
    apply 'mouse-select-click' to im-pg-sel in frame f-relat.
    apply 'entry' to frame f-pg-sel.
    apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

i-mensagem:load-mouse-pointer("image/lupa.cur":U)  in frame f-pg-par.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-cla im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY cb-classificacao1 cb-classificacao2 cb-classificacao3 
          cb-classificacao4 cb-classificacao5 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE RECT-15 cb-classificacao1 cb-classificacao2 cb-classificacao3 
         cb-classificacao4 cb-classificacao5 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr c-arquivo bt-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY i-situacao l-email i-mensagem c-descricao l-indice-zerado l-narrativa 
          l-descricao-item l-detalha-itens l-pula-linha c-text-1 c-text-2 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-12 RECT-13 RECT-16 i-situacao l-email i-mensagem l-descricao-item 
         l-detalha-itens l-pula-linha 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim cb-ano-ini cb-periodo-ini 
          cb-ano-fim cb-periodo-fim i-cod-emitente-ini i-cod-emitente-fim 
          c-it-codigo-ini c-it-codigo-fim i-nr-controle-ini i-nr-controle-fim 
          i-cod-gr-forn-ini i-cod-gr-forn-fim c-fm-codigo-ini c-fm-codigo-fim 
          i-ge-codigo-ini i-ge-codigo-fim c-cod-grp-aval-ini c-cod-grp-aval-fim 
          c-cod-grp-resp-ini c-cod-grp-resp-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-101 IMAGE-102 IMAGE-103 IMAGE-104 IMAGE-65 IMAGE-67 IMAGE-69 
         IMAGE-70 IMAGE-71 IMAGE-72 IMAGE-74 IMAGE-79 IMAGE-81 IMAGE-82 
         IMAGE-83 IMAGE-84 IMAGE-85 IMAGE-86 IMAGE-87 IMAGE-88 
         c-cod-estabel-ini c-cod-estabel-fim cb-ano-ini cb-periodo-ini 
         cb-ano-fim cb-periodo-fim i-cod-emitente-ini i-cod-emitente-fim 
         c-it-codigo-ini c-it-codigo-fim i-nr-controle-ini i-nr-controle-fim 
         i-cod-gr-forn-ini i-cod-gr-forn-fim c-fm-codigo-ini c-fm-codigo-fim 
         i-ge-codigo-ini i-ge-codigo-fim c-cod-grp-aval-ini c-cod-grp-aval-fim 
         c-cod-grp-resp-ini c-cod-grp-resp-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-relat 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

/* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}

    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").

            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    create tt-param.
    assign tt-param.usuario            = c-seg-usuario
           tt-param.destino            = input frame f-pg-imp rs-destino
           tt-param.c-destino          = entry((tt-param.destino - 1) * 2 + 1,
                                         rs-destino:radio-buttons in frame f-pg-imp)
           tt-param.data-exec          = today
           tt-param.hora-exec          = time
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               tt-param.classifica[1]  = LOOKUP(input frame f-pg-cla cb-classificacao1,cb-classificacao1:LIST-ITEM-PAIRS,",")
               tt-param.classifica[2]  = LOOKUP(input frame f-pg-cla cb-classificacao2,cb-classificacao2:LIST-ITEM-PAIRS,",")
               tt-param.classifica[3]  = LOOKUP(input frame f-pg-cla cb-classificacao3,cb-classificacao3:LIST-ITEM-PAIRS,",")
               tt-param.classifica[4]  = LOOKUP(input frame f-pg-cla cb-classificacao4,cb-classificacao4:LIST-ITEM-PAIRS,",")
               tt-param.classifica[5]  = LOOKUP(input frame f-pg-cla cb-classificacao5,cb-classificacao5:LIST-ITEM-PAIRS,",")
           &else
               tt-param.classifica[1]  = LOOKUP(input frame f-pg-cla cb-classificacao1,cb-classificacao1:LIST-ITEMS) 
               tt-param.classifica[2]  = LOOKUP(input frame f-pg-cla cb-classificacao2,cb-classificacao2:LIST-ITEMS) 
               tt-param.classifica[3]  = LOOKUP(input frame f-pg-cla cb-classificacao3,cb-classificacao3:LIST-ITEMS) 
               tt-param.classifica[4]  = LOOKUP(input frame f-pg-cla cb-classificacao4,cb-classificacao4:LIST-ITEMS) 
               tt-param.classifica[5]  = LOOKUP(input frame f-pg-cla cb-classificacao5,cb-classificacao5:LIST-ITEMS)
           &endif
           tt-param.desc-classifica[1] = input frame f-pg-cla cb-classificacao1                                     
           tt-param.desc-classifica[2] = input frame f-pg-cla cb-classificacao2
           tt-param.desc-classifica[3] = input frame f-pg-cla cb-classificacao3                                     
           tt-param.desc-classifica[4] = input frame f-pg-cla cb-classificacao4                                    
           tt-param.desc-classifica[5] = input frame f-pg-cla cb-classificacao5
           tt-param.c-est-ini          = input frame f-pg-sel c-cod-estabel-ini 
           tt-param.c-est-fim          = input frame f-pg-sel c-cod-estabel-fim
           tt-param.i-emi-ini          = input frame f-pg-sel i-cod-emitente-ini
           tt-param.i-emi-fim          = input frame f-pg-sel i-cod-emitente-fim 
           tt-param.c-it-ini           = INPUT FRAME f-pg-sel c-it-codigo-ini
           tt-param.c-it-fim           = INPUT FRAME f-pg-sel c-it-codigo-fim
           tt-param.i-nr-ini           = INPUT FRAME f-pg-sel i-nr-controle-ini
           tt-param.i-nr-fim           = INPUT FRAME f-pg-sel i-nr-controle-fim
           tt-param.c-cod-grp-aval-ini = INPUT FRAME f-pg-sel c-cod-grp-aval-ini
           tt-param.c-cod-grp-aval-fim = INPUT FRAME f-pg-sel c-cod-grp-aval-fim
           tt-param.c-cod-grp-resp-ini = INPUT FRAME f-pg-sel c-cod-grp-resp-ini
           tt-param.c-cod-grp-resp-fim = INPUT FRAME f-pg-sel c-cod-grp-resp-fim
           tt-param.i-ano-ini          = int(INPUT FRAME f-pg-sel cb-ano-ini)
           tt-param.c-des-per-ini      = INPUT FRAME f-pg-sel cb-periodo-ini
           tt-param.i-ano-fim          = int(INPUT FRAME f-pg-sel cb-ano-fim)
           tt-param.c-des-per-fim      = INPUT FRAME f-pg-sel cb-periodo-fim
           tt-param.i-ge-codigo-ini    = input frame f-pg-sel i-ge-codigo-ini
           tt-param.i-ge-codigo-fim    = input frame f-pg-sel i-ge-codigo-fim
           tt-param.i-cod-gr-forn-ini  = input frame f-pg-sel i-cod-gr-forn-ini 
           tt-param.i-cod-gr-forn-fim  = input frame f-pg-sel i-cod-gr-forn-fim 
           tt-param.c-fm-codigo-ini    = input frame f-pg-sel c-fm-codigo-ini
           tt-param.c-fm-codigo-fim    = input frame f-pg-sel c-fm-codigo-fim 
           tt-param.i-situacao         = input frame f-pg-par i-situacao
           tt-param.c-situacao         = entry((tt-param.i-situacao - 1) * 2 + 1, 
                                         i-situacao:radio-buttons in frame f-pg-par)
                                         
           tt-param.l-narrativa        = input frame f-pg-par l-narrativa
           tt-param.l-indice-zerado    = input frame f-pg-par l-indice-zerado
           tt-param.l-detalha-itens    = input frame f-pg-par l-detalha-itens
           tt-param.l-descricao-item   = input frame f-pg-par l-descricao-item
           tt-param.l-pula-linha       = input frame f-pg-par l-pula-linha
           tt-param.l-email            = input frame f-pg-par l-email
           tt-param.i-mensagem         = INPUT FRAME f-pg-par i-mensagem.

    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    {include/i-rpexb.i}
    SESSION:SET-WAIT-STATE("general":U).
    {include/i-rprun.i afp/af0501rp.p}
    {include/i-rpexc.i}
    SESSION:SET-WAIT-STATE("":U).
    {include/i-rptrm.i}
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo w-relat 
PROCEDURE pi-preenche-periodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Preenche os combo-box com os anos */
   {afbo/boaf016.i2 "cb-ano-ini" "cb-ano-fim" "f-pg-sel"}

   RUN pi-preenche-periodo-ini.
   RUN pi-preenche-periodo-fim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-fim w-relat 
PROCEDURE pi-preenche-periodo-fim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Preenche os combo-box com os per°odos do ano final */
  {afbo/boaf016.i3 "INPUT FRAME f-pg-sel cb-ano-fim:SCREEN-VALUE" cb-periodo-fim f-pg-sel}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-ini w-relat 
PROCEDURE pi-preenche-periodo-ini :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /* Preenche os combo-box com os per°odos do ano inicial */
   {afbo/boaf016.i3 "INPUT FRAME f-pg-sel cb-ano-ini:SCREEN-VALUE" "cb-periodo-ini" "f-pg-sel"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

