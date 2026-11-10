&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i AF0001 2.00.00.008 } /*** "010008" ***/
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0001
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo


&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES


&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   c-cod-estabel-ini c-cod-estabel-fim ~
                              i-cod-emitente-ini i-cod-emitente-fim ~
                              c-it-codigo-ini c-it-codigo-fim ~
                              i-cod-gr-forn-ini i-cod-gr-forn-fim ~
                              c-fm-codigo-ini c-fm-codigo-fim ~
                              i-ge-codigo-ini i-ge-codigo-fim ~
                              dt-implant-forn-ini dt-implant-forn-fim ~
                              dt-implant-item-ini dt-implant-item-fim

&GLOBAL-DEFINE page4Widgets   lQualidade ~
                              lQuantidade ~
                              lPreco ~
                              lDataEntrega ~
                              lFamilia ~
                              lItem ~
                              lItemEstab ~
                              log-considera-qtd-receb ~
                              log-considera-val-receb ~
                              pct-qtd-min ~
                              pct-qtd-max ~
                              pct-val-min ~
                              pct-val-max ~
                              lapenasItemFornec ~
                              lapenasordemcompra ~
                              da-oc-ini ~
                              da-oc-fin ~
                              c-cod-grp-aval ~
                              l-assume-grp-aval ~
                              nr-versao-grp-avaliacao ~
                              l-cria-versao ~
                              nr-versao ~
                              l-item-ativo ~
                              l-fornecedor-ativo

&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    dDemerito dVarMin dVarMax 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{afp/af0001.i1} /*  temp table */
{utp/ut-glob.i} 
define buffer b-tt-digita for tt-digita.

DEFINE variable dTotPerc    as decimal   no-undo.
DEFINE VARIABLE h-boaf017   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boaf022   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boaf023   AS HANDLE    NO-UNDO.

/* Transfer Definitions */

def var raw-param        as raw no-undo.



def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.nr-controle tt-digita.percentual tt-digita.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.nr-controle tt-digita.percentual   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

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
     SIZE 87 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-fm-codigo-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam¡lia":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88.

DEFINE VARIABLE dt-implant-forn-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-implant-forn-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF  
     LABEL "Data implanta‡Æo do fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-implant-item-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-implant-item-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data implanta‡Æo do item" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE i-cod-gr-forn-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-cod-gr-forn-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-ge-codigo-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-ge-codigo-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-65
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
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

DEFINE IMAGE IMAGE-89
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-90
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-91
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-92
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE c-cod-grp-aval AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Avalia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-oc-fin AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE da-oc-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDemerito AS DECIMAL FORMAT ">>>9.99":U INITIAL 0 
     LABEL "Dem‚rito" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE dVarMax AS DECIMAL FORMAT ">>>9":U INITIAL 0 
     LABEL "Varia‡Æo M x" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE dVarMin AS DECIMAL FORMAT ">>>9":U INITIAL 0 
     LABEL "Varia‡Æo M¡n" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE nr-versao LIKE af-grp-avaliacao.nr-versao
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE nr-versao-grp-avaliacao LIKE af-item-contr.nr-versao-grp-avaliacao
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE pct-qtd-max LIKE af-item-contr.pct-qtd-max
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE pct-qtd-min LIKE af-item-contr.pct-qtd-min
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE pct-val-max LIKE af-item-contr.pct-val-max
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE pct-val-min LIKE af-item-contr.pct-val-min
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.5.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.29.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 4.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 2.25.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 1.5.

DEFINE VARIABLE l-assume-grp-aval AS LOGICAL INITIAL no 
     LABEL "Assume Informa‡äes Grupo Avalia‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-cria-versao AS LOGICAL INITIAL no 
     LABEL "Criar nova versÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-fornecedor-ativo AS LOGICAL INITIAL no 
     LABEL "Fornecedor estiver ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE l-item-ativo AS LOGICAL INITIAL no 
     LABEL "Item estiver ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE lapenasitemfornec AS LOGICAL INITIAL yes 
     LABEL "Houver rela‡Æo Item X Fornecedor cadastrada" 
     VIEW-AS TOGGLE-BOX
     SIZE 77 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lapenasordemcompra AS LOGICAL INITIAL yes 
     LABEL "Existir ao menos uma cotacao para o item e fornecedor entre" 
     VIEW-AS TOGGLE-BOX
     SIZE 78 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDataEntrega AS LOGICAL INITIAL no 
     LABEL "Data Entrega" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lFamilia AS LOGICAL INITIAL no 
     LABEL "Gera relacionamento Fam¡lia X Ponto de Controle" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lItem AS LOGICAL INITIAL no 
     LABEL "Gera relacionamento Item X  Ponto de Controle" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lItemEstab AS LOGICAL INITIAL no 
     LABEL "Gera relac Item X  Ponto de Controle X Estabelec" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE log-considera-qtd-receb LIKE af-item-contr.log-considera-qtd-receb
     VIEW-AS TOGGLE-BOX
     SIZE 28.57 BY .71 NO-UNDO.

DEFINE VARIABLE log-considera-val-receb LIKE af-item-contr.log-considera-val-receb
     VIEW-AS TOGGLE-BOX
     SIZE 29.72 BY .71 NO-UNDO.

DEFINE VARIABLE lPreco AS LOGICAL INITIAL no 
     LABEL "Pre‡o" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lQualidade AS LOGICAL INITIAL no 
     LABEL "Qualidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE lQuantidade AS LOGICAL INITIAL no 
     LABEL "Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.nr-controle
tt-digita.percentual
tt-digita.descricao
ENABLE
tt-digita.nr-controle
tt-digita.percentual
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 10.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 76
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.57 BY 17
         FONT 1.

DEFINE FRAME fPage4
     lQualidade AT ROW 1.42 COL 3
     dDemerito AT ROW 1.42 COL 54 COLON-ALIGNED
     lQuantidade AT ROW 2.42 COL 3
     pct-qtd-min AT ROW 2.42 COL 54 COLON-ALIGNED HELP
          ""
     pct-qtd-max AT ROW 2.42 COL 73 COLON-ALIGNED HELP
          ""
     log-considera-qtd-receb AT ROW 2.67 COL 16 HELP
          ""
     lPreco AT ROW 3.42 COL 3
     pct-val-min AT ROW 3.42 COL 54 COLON-ALIGNED HELP
          ""
     pct-val-max AT ROW 3.42 COL 73 COLON-ALIGNED HELP
          ""
     log-considera-val-receb AT ROW 3.67 COL 16 HELP
          ""
     lDataEntrega AT ROW 4.42 COL 3
     dVarMin AT ROW 4.42 COL 54 COLON-ALIGNED
     dVarMax AT ROW 4.42 COL 73 COLON-ALIGNED
     c-cod-grp-aval AT ROW 6.04 COL 57.29 COLON-ALIGNED
     nr-versao-grp-avaliacao AT ROW 6.04 COL 71 COLON-ALIGNED HELP
          "N£mero da versÆo do grupo de avalia‡Æo" NO-LABEL
     lFamilia AT ROW 6.21 COL 3
     l-assume-grp-aval AT ROW 7.04 COL 80.01 RIGHT-ALIGNED
     lItem AT ROW 7.21 COL 3
     lItemEstab AT ROW 8.21 COL 3
     l-cria-versao AT ROW 8.71 COL 61.01 RIGHT-ALIGNED
     nr-versao AT ROW 8.71 COL 60.72 COLON-ALIGNED HELP
          "N£mero da versÆo" NO-LABEL
     lapenasitemfornec AT ROW 10.5 COL 3
     lapenasordemcompra AT ROW 11.42 COL 3
     da-oc-ini AT ROW 11.46 COL 46 COLON-ALIGNED NO-LABEL
     da-oc-fin AT ROW 11.46 COL 62 COLON-ALIGNED NO-LABEL
     l-item-ativo AT ROW 12.46 COL 3 
     l-fornecedor-ativo AT ROW 12.46 COL 47.43 
     "Gera relacionamento apenas quando" VIEW-AS TEXT
          SIZE 27 BY .54 AT ROW 9.92 COL 3
     "e" VIEW-AS TEXT
          SIZE 3 BY .54 AT ROW 11.88 COL 60.86
     RECT-21 AT ROW 1.17 COL 1
     RECT-24 AT ROW 10.21 COL 1
     RECT-26 AT ROW 5.88 COL 1
     RECT-28 AT ROW 5.88 COL 44
     RECT-48 AT ROW 8.38 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage2
     c-cod-estabel-ini AT ROW 3.5 COL 30 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 3.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     i-cod-emitente-ini AT ROW 4.5 COL 27 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     i-cod-emitente-fim AT ROW 4.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     dt-implant-forn-ini AT ROW 5.5 COL 27 COLON-ALIGNED 
     dt-implant-forn-fim AT ROW 5.5 COL 45 COLON-ALIGNED NO-LABEL 
     c-it-codigo-ini AT ROW 6.54 COL 19.29 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-codigo-fim AT ROW 6.54 COL 45 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     dt-implant-item-ini AT ROW 7.58 COL 27 COLON-ALIGNED 
     dt-implant-item-fim AT ROW 7.58 COL 45 COLON-ALIGNED NO-LABEL
     i-cod-gr-forn-ini AT ROW 8.63 COL 32 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores"
     i-cod-gr-forn-fim AT ROW 8.63 COL 45 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores" NO-LABEL
     c-fm-codigo-ini AT ROW 9.63 COL 26 COLON-ALIGNED HELP
          "Fam¡lia de material a que pertence o item"
     c-fm-codigo-fim AT ROW 9.63 COL 45 COLON-ALIGNED HELP
          "Fam¡lia de material a que pertence o item" NO-LABEL
     i-ge-codigo-ini AT ROW 10.63 COL 32 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item"
     i-ge-codigo-fim AT ROW 10.63 COL 45 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item" NO-LABEL
     IMAGE-65 AT ROW 3.5 COL 39
     IMAGE-67 AT ROW 6.54 COL 39
     IMAGE-69 AT ROW 3.5 COL 43
     IMAGE-72 AT ROW 4.5 COL 39
     IMAGE-74 AT ROW 4.5 COL 43
     IMAGE-79 AT ROW 6.54 COL 43
     IMAGE-83 AT ROW 8.63 COL 39
     IMAGE-84 AT ROW 8.63 COL 43
     IMAGE-85 AT ROW 9.63 COL 39
     IMAGE-86 AT ROW 9.63 COL 43
     IMAGE-87 AT ROW 10.63 COL 39
     IMAGE-88 AT ROW 10.63 COL 43
     IMAGE-89 AT ROW 5.5 COL 39 
     IMAGE-90 AT ROW 5.5 COL 43 
     IMAGE-91 AT ROW 7.58 COL 39 
     IMAGE-92 AT ROW 7.58 COL 43 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
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
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 12.25 COL 1
     btUpdate AT ROW 12.25 COL 16
     btDelete AT ROW 12.25 COL 31
     btSave AT ROW 12.25 COL 46
     btOpen AT ROW 12.25 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 87.57
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

{report~/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME Custom                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage4:MOVE-AFTER-TAB-ITEM (btHelp2:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR TOGGLE-BOX l-assume-grp-aval IN FRAME fPage4
   ALIGN-R                                                              */
/* SETTINGS FOR TOGGLE-BOX l-cria-versao IN FRAME fPage4
   ALIGN-R                                                              */
/* SETTINGS FOR TOGGLE-BOX log-considera-qtd-receb IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR TOGGLE-BOX log-considera-val-receb IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FILL-IN nr-versao IN FRAME fPage4
   NO-ENABLE LIKE = emsdca.af-grp-avaliacao.                            */
/* SETTINGS FOR FILL-IN nr-versao-grp-avaliacao IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FILL-IN pct-qtd-max IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FILL-IN pct-qtd-min IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FILL-IN pct-val-max IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FILL-IN pct-val-min IN FRAME fPage4
   LIKE = emsdca.af-item-contr. EXP-SIZE                                */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.nr-controle
                tt-digita.percentual with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   /*
   if  brDigita:new-row in frame fPage5 then do:
       assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).
   end.
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */

    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.nr-controle
               input browse brDigita tt-digita.percentual.
        FIND af-controle 
            WHERE af-controle.ep-codigo = i-ep-codigo-usuario
            AND   af-controle.nr-controle = input browse brDigita tt-digita.nr-controle
            NO-LOCK NO-ERROR.
        IF AVAIL af-controle THEN
            ASSIGN tt-digita.descricao = af-controle.descricao.

        DISP tt-digita.descricao WITH BROWSE {&browse-name}.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita THEN DO:
            assign input browse brDigita tt-digita.nr-controle
                   input browse brDigita tt-digita.percentual.
            FIND af-controle 
                 WHERE af-controle.ep-codigo = i-ep-codigo-usuario
                 AND   af-controle.nr-controle = input browse brDigita tt-digita.nr-controle
                 NO-LOCK NO-ERROR.
            IF AVAIL af-controle THEN
               ASSIGN tt-digita.descricao = af-controle.descricao.

             DISP tt-digita.descricao WITH BROWSE {&browse-name}.
        END.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.

    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.

        open query brDigita for each tt-digita.

        apply "entry":U to tt-digita.nr-controle in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.

    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
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
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.percentual in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-grp-aval
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-aval wReport
ON F5 OF c-cod-grp-aval IN FRAME fPage4 /* Grupo Avalia‡Æo */
DO:
    {method/zoomfields.i &ProgramZoom="afzoom/z01af017.w"
                         &FieldZoom1="cod-grp-avaliacao"
                         &FieldScreen1="c-cod-grp-aval"
                         &Frame1="fPage4"
                         &FieldZoom2="nr-versao"                         
                         &FieldScreen2="nr-versao-grp-avaliacao"                        
                         &Frame2="fPage4"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-aval wReport
ON LEAVE OF c-cod-grp-aval IN FRAME fPage4 /* Grupo Avalia‡Æo */
DO:
    IF INPUT FRAME {&FRAME-NAME} l-assume-grp-aval = YES THEN
        RUN pi-cria-tt-digita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-aval wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-grp-aval IN FRAME fPage4 /* Grupo Avalia‡Æo */
DO:
    apply "f5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-assume-grp-aval
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-assume-grp-aval wReport
ON VALUE-CHANGED OF l-assume-grp-aval IN FRAME fPage4 /* Assume Informa‡äes Grupo Avalia‡Æo */
DO:
    if input frame {&FRAME-NAME} l-assume-grp-aval = yes then
        run pi-cria-tt-digita.
    ELSE DO:
        empty temp-table tt-digita.
        {&OPEN-QUERY-brDigita}
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-cria-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-cria-versao wReport
ON VALUE-CHANGED OF l-cria-versao IN FRAME fPage4 /* Criar nova versÆo */
DO:
   IF INPUT FRAME {&FRAME-NAME} l-cria-versao:CHECKED THEN
       RUN piHabilitaVersao(INPUT TRUE).      
    ELSE
       RUN piHabilitaVersao(INPUT FALSE).           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lDataEntrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lDataEntrega wReport
ON VALUE-CHANGED OF lDataEntrega IN FRAME fPage4 /* Data Entrega */
DO:
    IF lDataEntrega:CHECKED THEN DO:
      FIND af-controle
           WHERE af-controle.ep-codigo   = i-ep-codigo-usuario
           AND   af-controle.nr-controle = 4
           NO-LOCK NO-ERROR.
      IF AVAIL af-controle THEN DO:
          CREATE tt-digita.
          ASSIGN tt-digita.nr-controle = 4
                 tt-digita.descricao   = af-controle.descricao.
      END.
  END.
  ELSE DO:
      FIND tt-digita
          WHERE tt-digita.nr-controle = 4 NO-ERROR.
      IF AVAIL tt-digita THEN DELETE tt-digita.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}  
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log-considera-qtd-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-considera-qtd-receb wReport
ON VALUE-CHANGED OF log-considera-qtd-receb IN FRAME fPage4 /* Considera varia‡äes qtd recebimento */
DO:
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log-considera-val-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-considera-val-receb wReport
ON VALUE-CHANGED OF log-considera-val-receb IN FRAME fPage4 /* Considera varia‡äes valor recebimento */
DO:
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lPreco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lPreco wReport
ON VALUE-CHANGED OF lPreco IN FRAME fPage4 /* Pre‡o */
DO:
  IF lPreco:CHECKED THEN DO:
      FIND af-controle
           WHERE af-controle.ep-codigo   = i-ep-codigo-usuario
           AND   af-controle.nr-controle = 3
           NO-LOCK NO-ERROR.
      IF AVAIL af-controle THEN DO:
          CREATE tt-digita.
          ASSIGN tt-digita.nr-controle = 3
                 tt-digita.descricao   = af-controle.descricao.
      END.
  END.
  ELSE DO:
      FIND tt-digita
          WHERE tt-digita.nr-controle = 3 NO-ERROR.
      IF AVAIL tt-digita THEN DELETE tt-digita.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}  
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lQualidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lQualidade wReport
ON VALUE-CHANGED OF lQualidade IN FRAME fPage4 /* Qualidade */
DO:
  IF lQualidade:CHECKED THEN DO:
      FIND af-controle
           WHERE af-controle.ep-codigo   = i-ep-codigo-usuario
           AND   af-controle.nr-controle = 1
           NO-LOCK NO-ERROR.
      IF AVAIL af-controle THEN DO:
          CREATE tt-digita.
          ASSIGN tt-digita.nr-controle = 1
                 tt-digita.descricao   = af-controle.descricao.
      END.
  END.
  ELSE DO:
      FIND tt-digita
          WHERE tt-digita.nr-controle = 1 NO-ERROR.
      IF AVAIL tt-digita THEN DELETE tt-digita.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}

  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lQuantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lQuantidade wReport
ON VALUE-CHANGED OF lQuantidade IN FRAME fPage4 /* Quantidade */
DO:
    IF lQuantidade:CHECKED THEN DO:
      FIND af-controle
           WHERE af-controle.ep-codigo   = i-ep-codigo-usuario
           AND   af-controle.nr-controle = 2
           NO-LOCK NO-ERROR.
      IF AVAIL af-controle THEN DO:
          CREATE tt-digita.
          ASSIGN tt-digita.nr-controle = 2
                 tt-digita.descricao   = af-controle.descricao.
      END.
  END.
  ELSE DO:
      FIND tt-digita
          WHERE tt-digita.nr-controle = 2 NO-ERROR.
      IF AVAIL tt-digita THEN DELETE tt-digita.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nr-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr-versao wReport
ON F5 OF nr-versao IN FRAME fPage4
DO:
  {method/zoomfields.i &ProgramZoom="afzoom/z01af023.w"
                       &FieldZoom1="nr-versao"
                       &FieldScreen1="nr-versao"                      
                       &Frame1="fPage4"
                       &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr-versao wReport
ON MOUSE-SELECT-DBLCLICK OF nr-versao IN FRAME fPage4
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nr-versao-grp-avaliacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr-versao-grp-avaliacao wReport
ON F5 OF nr-versao-grp-avaliacao IN FRAME fPage4
DO:
    {method/zoomfields.i &ProgramZoom="afzoom/z01af017.w"
                         &FieldZoom1="nr-versao"
                         &FieldZoom2="cod-grp-avaliacao"
                         &FieldScreen1="nr-versao-grp-avaliacao"
                         &FieldScreen2="c-cod-grp-aval"
                         &Frame1="fPage4"
                         &Frame2="fPage4"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr-versao-grp-avaliacao wReport
ON LEAVE OF nr-versao-grp-avaliacao IN FRAME fPage4
DO:
  IF INPUT FRAME {&FRAME-NAME} l-assume-grp-aval = YES THEN
        RUN pi-cria-tt-digita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr-versao-grp-avaliacao wReport
ON MOUSE-SELECT-DBLCLICK OF nr-versao-grp-avaliacao IN FRAME fPage4
DO:
  APPLY "F5" TO SELF.
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
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

c-cod-grp-aval:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.
nr-versao-grp-avaliacao:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.
nr-versao:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE (h-boaf017) THEN DO:
        DELETE procedure h-boaf017.
        ASSIGN h-boaf017 = ?.
    END.

    IF  VALID-HANDLE (h-boaf022) THEN DO:
        DELETE procedure h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    IF  VALID-HANDLE (h-boaf023) THEN DO:
        DELETE procedure h-boaf023.
        ASSIGN h-boaf023 = ?.
    END.    

    RETURN "OK":U.
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
    IF  NOT VALID-HANDLE (h-boaf017) THEN 
        RUN afbo/boaf017.p PERSISTENT SET h-boaf017.

    RUN openQueryStatic IN h-boaf017 (INPUT "Main":U).

    IF  NOT VALID-HANDLE (h-boaf022) THEN 
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U).

    IF  NOT VALID-HANDLE (h-boaf023) THEN
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.

    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U).

    RUN piHabilitaCampos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-digita wReport 
PROCEDURE pi-cria-tt-digita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
empty temp-table tt-digita.

for each af-grp-avaliacao-form no-lock
    where af-grp-avaliacao-form.cod-grp-avaliacao = input frame fPage4 c-cod-grp-aval
    AND   af-grp-avaliacao-form.nr-versao = input frame fPage4 nr-versao-grp-avaliacao:
    create tt-digita.
    assign tt-digita.nr-controle         = af-grp-avaliacao-form.nr-controle
           tt-digita.percentual          = af-grp-avaliacao-form.percentual
           tt-digita.cod-grp-responsavel = af-grp-avaliacao-form.cod-grp-resp.

    find first af-controle no-lock
        where af-controle.ep-codigo   = i-ep-codigo-usuario
          and af-controle.nr-controle = af-grp-avaliacao-form.nr-controle no-error.
    if avail af-controle then
        assign tt-digita.descricao = af-controle.descricao.
end.

{&OPEN-QUERY-brDigita}

    RETURN "OK":U.

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

define var r-tt-digita as rowid no-undo.
DEFINE VARIABLE i-nr-versao LIKE  af-grp-avaliacao.nr-versao  NO-UNDO.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/

    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).

        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.nr-controle = tt-digita.nr-controle
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.nr-controle in browse brDigita.
            return error.
        end.

        /*:T As demais valida‡äes devem ser feitas aqui */
        FIND af-controle 
            WHERE af-controle.ep-codigo   = i-ep-codigo-usuario
            AND   af-controle.nr-controle = tt-digita.nr-controle
            NO-LOCK NO-ERROR.
        if  NOT AVAIL af-controle  then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.nr-controle:HANDLE in browse brDigita.
            reposition brDigita to rowid r-tt-digita.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ponto_de_controle" *}
            run utp/ut-msgs.p (input "SHOW":U, input 56, input RETURN-VALUE).
            apply "ENTRY":U to tt-digita.nr-controle in browse brDigita.
            return error.
        end.
    end.

    IF TRIM(INPUT FRAME fPage4 c-cod-grp-aval) > "" OR INPUT FRAME fPage4 nr-versao-grp-avaliacao > 0 OR l-assume-grp-aval:checked in frame fPage4 THEN DO:
        RUN goToKey IN h-boaf017 (INPUT i-ep-codigo-usuario, INPUT INPUT FRAME fPage4 c-cod-grp-aval, INPUT INPUT FRAME fPage4 nr-versao-grp-avaliacao).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Grupo_de_Avalia‡Æo" *}
            run utp/ut-msgs.p (input "SHOW":U, input 47, input RETURN-VALUE).
            apply "ENTRY":U to c-cod-grp-aval in frame fPage4.
            RETURN ERROR.
        END.
    END.    

    IF INPUT FRAME fPage4 l-cria-versao:CHECKED THEN DO:
        RUN goToKey IN h-boaf023 (INPUT INPUT FRAME fPage4 nr-versao, INPUT i-ep-codigo-usuario).
                
        IF RETURN-VALUE = "NOK":U THEN DO:        
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "VersÆo" *}
           RUN utp/ut-msgs.p (input "SHOW":U, input 47, input RETURN-VALUE).
           APPLY "ENTRY":U to nr-versao in frame fPage4.
           RETURN ERROR.
        END.
        ELSE
            ASSIGN i-nr-versao = INPUT FRAME fPage4 nr-versao.
    END.
    ELSE DO:

        RUN pi-retorna-menor-versao IN h-boaf023(OUTPUT i-nr-versao).
        
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Versäes" *}
            RUN utp/ut-msgs.p (input "SHOW":U, input 4610, input RETURN-VALUE).                
            RETURN ERROR.
        END.
    END.

    ASSIGN dTotPerc = 0.
    FOR EACH b-tt-digita:
        ASSIGN dTotPerc = dTotPerc + b-tt-digita.percentual.
    END.
    IF dTotPerc <> 100 THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Percentual_da_f¢rmula_dever _ser_100%" *}
       run utp/ut-msgs.p (input "SHOW":U, input 17567, input RETURN-VALUE).
       return error.
    END.    

    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
 
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.


    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

    ASSIGN tt-param.lFamilia                = INPUT FRAME fPage4 lFamilia
           tt-param.lItem                   = INPUT FRAME fPage4 lItem
           tt-param.lItemEstab              = INPUT FRAME fPage4 lItemEstab
           tt-param.dDemerito               = INPUT FRAME fPage4 dDemerito
           tt-param.dVarMin                 = INPUT FRAME fPage4 dVarMin
           tt-param.dVarMax                 = INPUT FRAME fPage4 dVarMax
           tt-param.cIniFamilia             = INPUT FRAME fPage2 c-fm-codigo-ini
           tt-param.cEndFamilia             = INPUT FRAME fPage2 c-fm-codigo-fim
           tt-param.cIniItem                = INPUT FRAME fPage2 c-it-codigo-ini
           tt-param.cEndItem                = INPUT FRAME fPage2 c-it-codigo-fim
           tt-param.dtIniImplantItem        = INPUT FRAME fPage2 dt-implant-item-ini
           tt-param.dtEndImplantItem        = INPUT FRAME fPage2 dt-implant-item-fim
           tt-param.cIniEstab               = INPUT FRAME fPage2 c-cod-estabel-ini
           tt-param.cEndEstab               = INPUT FRAME fPage2 c-cod-estabel-fim
           tt-param.cIniFornec              = INPUT FRAME fPage2 i-cod-emitente-ini
           tt-param.cEndFornec              = INPUT FRAME fPage2 i-cod-emitente-fim
           tt-param.dtIniImplantForn        = INPUT FRAME fPage2 dt-implant-forn-ini
           tt-param.dtEndImplantForn        = INPUT FRAME fPage2 dt-implant-forn-fim
           tt-param.i-cod-gr-forn-ini       = INPUT FRAME fPage2 i-cod-gr-forn-ini
           tt-param.i-cod-gr-forn-fim       = INPUT FRAME fPage2 i-cod-gr-forn-fim
           tt-param.i-ge-codigo-ini         = INPUT FRAME fPage2 i-ge-codigo-ini
           tt-param.i-ge-codigo-fim         = INPUT FRAME fPage2 i-ge-codigo-fim 
           tt-param.log-considera-qtd-receb = INPUT FRAME fPage4 log-considera-qtd-receb:checked
           tt-param.log-considera-val-receb = INPUT FRAME fPage4 log-considera-val-receb:checked
           tt-param.pct-qtd-min             = INPUT FRAME fPage4 pct-qtd-min
           tt-param.pct-qtd-max             = INPUT FRAME fPage4 pct-qtd-max
           tt-param.pct-val-min             = INPUT FRAME fPage4 pct-val-min
           tt-param.pct-val-max             = INPUT FRAME fPage4 pct-val-max
           tt-param.lapenasitemfornec       = input FRAME fpage4 lapenasitemfornec
           tt-param.lapenasordemcompra      = input FRAME fpage4 lapenasordemcompra
           tt-param.l-item-ativo            = input FRAME fpage4 l-item-ativo
           tt-param.l-fornecedor-ativo      = input FRAME fpage4 l-fornecedor-ativo
           tt-param.da-oc-ini               = input FRAME fpage4 da-oc-ini
           tt-param.da-oc-fin               = input FRAME fpage4 da-oc-fin
           tt-param.cod-grp-aval            = input FRAME fPage4 c-cod-grp-aval
           tt-param.assume-grp-aval         = l-assume-grp-aval:checked in frame fPage4
           tt-param.l-cria-versao           = INPUT FRAME fPage4 l-cria-versao:CHECKED
           tt-param.nr-versao-grp-avaliacao = INPUT FRAME fPage4 nr-versao-grp-avaliacao
           tt-param.nr-versao               = i-nr-versao.

    FIND tt-digita WHERE tt-digita.nr-controle = 1 NO-LOCK NO-ERROR.
    IF AVAIL tt-digita THEN ASSIGN tt-param.lQualidade = YES.
                       ELSE ASSIGN tt-param.lQualidade = NO.

    FIND tt-digita WHERE tt-digita.nr-controle = 2 NO-LOCK NO-ERROR.
    IF AVAIL tt-digita THEN ASSIGN tt-param.lQuantidade = YES.
                      ELSE ASSIGN tt-param.lQuantidade = NO.

    FIND tt-digita WHERE tt-digita.nr-controle = 3 NO-LOCK NO-ERROR.
    IF AVAIL tt-digita THEN ASSIGN tt-param.lPreco = YES.
                    ELSE ASSIGN tt-param.lPreco = NO.

    FIND tt-digita WHERE tt-digita.nr-controle = 4 NO-LOCK NO-ERROR.
    IF AVAIL tt-digita THEN ASSIGN tt-param.lDataEntrega = YES.
                      ELSE ASSIGN tt-param.lDataEntrega = NO.



    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i afp/af0001rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.

    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 

    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos wReport 
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-usa-log AS LOGICAL     NO-UNDO.
 
RUN getLogField IN h-boaf022 ("log-usa-versao", OUTPUT l-usa-log).

IF NOT l-usa-log THEN DO:
    DISABLE l-cria-versao
            nr-versao-grp-avaliacao WITH FRAME fPage4.
    ASSIGN  l-cria-versao:SCREEN-VALUE IN FRAME fPage4 = "NO"            
            nr-versao-grp-avaliacao:SCREEN-VALUE IN FRAME fPage4 = "0".
END.

IF input frame fpage4 lqualidade:CHECKED THEN 
   ENABLE ddemerito WITH FRAME fPage4.
ELSE 
   DISABLE ddemerito WITH FRAME fPage4.

IF input frame fpage4 ldataentrega:CHECKED THEN 
  ENABLE dvarmin
         dvarmax
         WITH FRAME fpage4.
ELSE 
  DISABLE dvarmin
          dvarmax
          WITH FRAME fpage4.

IF input frame fpage4 lquantidade:CHECKED THEN DO:
  ENABLE log-considera-qtd-receb
         WITH FRAME fpage4.
  IF input frame fpage4 log-considera-qtd-receb:CHECKED then
       DISABLE pct-qtd-min
               pct-qtd-max
               with frame fpage4.
  else
       ENABLE pct-qtd-min
              pct-qtd-max
              with frame fpage4.
end.
ELSE 
  DISABLE log-considera-qtd-receb
          pct-qtd-min
          pct-qtd-max
          WITH FRAME fpage4.

IF input frame fpage4 lpreco:CHECKED THEN DO:
  ENABLE log-considera-val-receb
         WITH FRAME fpage4.
  IF input frame fpage4 log-considera-val-receb:CHECKED then
       DISABLE pct-val-min
               pct-val-max
               with frame fpage4.
  else
       ENABLE pct-val-min
              pct-val-max
              with frame fpage4.
end.
ELSE 
  DISABLE log-considera-val-receb
          pct-val-min
          pct-val-max
          WITH FRAME fpage4.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaVersao wReport 
PROCEDURE piHabilitaVersao :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para habilitar/Desabilitar o campo de versÆo.
               Quando desabilitado tamb‚m seta Zero para o campo.
  Parameters:  pl-habilita-versao = Parƒmetro que deve vir True ou False
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pl-habilita-versao AS LOGICAL NO-UNDO.

IF pl-habilita-versao THEN
    ENABLE nr-versao WITH FRAME fpage4.
ELSE DO:
   DISABLE nr-versao WITH FRAME fpage4.
   ASSIGN nr-versao:SCREEN-VALUE IN FRAME fpage4 = "0".
END.    

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

