&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0730 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}":U >= "1.00":U &THEN
    {include/i-license-manager.i im0730 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0730
&GLOBAL-DEFINE Version        2.00.00.008
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo, Parƒmetro, ImpressÆo


&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGIMP          YES

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   rs-opcao

&GLOBAL-DEFINE page4Widgets   btInputFile btInputFile-2

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              rsDestinyExcel
                                           

&GLOBAL-DEFINE page0Text          
&GLOBAL-DEFINE page2Text      text-pedido-selecao text-embarque-selecao text-procexp-selecao text-informa
&GLOBAL-DEFINE page4Text      text-detalhar text-layout 
&GLOBAL-DEFINE page6Text      text-destino text-modo text-destino-excel
  
&GLOBAL-DEFINE page2Fields    cProcEstabIni cProcEstabFim cProcImpIni cProcImpFim ~
                              iEmitProcIni iEmitProcFim dDataEmisIni dDataEmisFim ~
                              cEmbEstabIni cEmbEstabFim cEmbarqueIni cEmbarqueFim ~
                              cDISiscomexIni cDISiscomexFim iDIEMSIni iDIEMSFim ~
                              dDataDIIni dDataDIFim cPedEstabIni cPedEstabFim ~
                              iPedidoIni iPedidoFim iOrdemCompraIni iOrdemCompraFim ~
                              iEmitPedIni iEmitPedFim dDataPedIni dDataPedFim

&GLOBAL-DEFINE page4Fields    lPedidoCompra lProcessoImp lFornecedor lOrdemCompra ~
                              lOrdemCompra lParcelas lItem lDeclaImport lAdicoesDI ~
                              lAcompDI lMaterialTransito lEmbarqueImp lAcompEmb lDocumentos ~
                              lItensDoc lMovtoEstoq lDuplicatas lDespImp ~
                              lDupDespesas lNFCompl lDespItemDoc ~
                              lEnviaDoct lLayoutUsuario lSobrepor lFornecedor ~
                              fi-destinatario fi-layout-padrao fi-destino-arq
&GLOBAL-DEFINE page6Fields    cFile 

 

/* Parameters Definitions ---                                           */
{imp/im0730.i} /* tt-param */
def var raw-param          as raw no-undo.
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR c-dir              AS CHAR    NO-UNDO.
DEF VAR c-lb-input-title   AS CHAR    NO-UNDO.
DEFINE VARIABLE l-cancelado AS LOGICAL     NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* Local Variables */
DEFINE VARIABLE h_ufn925 AS HANDLE NO-UNDO.
DEFINE VARIABLE i-empresa LIKE param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE v_log_integr_mec AS LOGICAL NO-UNDO.
DEFINE VARIABLE c_return AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cDISiscomexFim AS CHARACTER FORMAT "X(13)":U INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cDISiscomexIni AS CHARACTER FORMAT "X(13)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbarqueFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbarqueIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbEstabFim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbEstabIni AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cPedEstabFim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cPedEstabIni AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cProcEstabFim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cProcEstabIni AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cProcImpFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cProcImpIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dDataDIFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDataDIIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDataEmisFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDataEmisIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDataPedFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dDataPedIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iDIEMSFim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iDIEMSIni AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmitPedFim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmitPedIni AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmitProcFim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmitProcIni AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iOrdemCompraFim AS INTEGER FORMAT "zzzzz9,99":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iOrdemCompraIni AS INTEGER FORMAT "zzzzz9,99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iPedidoFim AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iPedidoIni AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-embarque-selecao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 34 BY .67 NO-UNDO.

DEFINE VARIABLE text-informa AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-pedido-selecao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 23.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-procexp-selecao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 24.14 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-opcao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Processo Importa‡Æo", 1,
"Embarque/Decl.Importa‡Æo", 2,
"Pedido/Ordem de Compra", 3
     SIZE 21.86 BY 3.13 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 5.25.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 4.25.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 5.25.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23.43 BY 3.63.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Selecione o Diret¢rio".

DEFINE BUTTON btInputFile-2 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Selecione o Diret¢rio.".

DEFINE VARIABLE fi-destinatario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Destinat rios" 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 TOOLTIP "Informe o endere‡o eletr“nico do(s) destinat rio(s)" NO-UNDO.

DEFINE VARIABLE fi-destino-arq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Destino" 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-layout-padrao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout PadrÆo" 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 NO-UNDO.

DEFINE VARIABLE text-detalhar AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-layout AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 2.17.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 7.71.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 2.13.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 2.17.

DEFINE VARIABLE lAcompDI AS LOGICAL INITIAL no 
     LABEL "Acompanhamento da DI" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lAcompEmb AS LOGICAL INITIAL no 
     LABEL "Acompanhamento Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lAdicoesDI AS LOGICAL INITIAL no 
     LABEL "Adi‡äes da DI" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDeclaImport AS LOGICAL INITIAL no 
     LABEL "Declara‡Æo de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDespImp AS LOGICAL INITIAL no 
     LABEL "Despesas do Documento" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDespItemDoc AS LOGICAL INITIAL no 
     LABEL "Despesas Item Documento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDocumentos AS LOGICAL INITIAL no 
     LABEL "Documentos de Entrada" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDupDespesas AS LOGICAL INITIAL no 
     LABEL "Duplicatas de Despesas" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lDuplicatas AS LOGICAL INITIAL no 
     LABEL "Duplicatas do Fornecedor da Mercadoria" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lEmbarqueImp AS LOGICAL INITIAL no 
     LABEL "Embarque de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lEnviaDoct AS LOGICAL INITIAL no 
     LABEL "Envia Docto via E-mail" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lFornecedor AS LOGICAL INITIAL no 
     LABEL "Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lItem AS LOGICAL INITIAL no 
     LABEL "Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lItensDoc AS LOGICAL INITIAL no 
     LABEL "Itens do Documento" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lLayoutUsuario AS LOGICAL INITIAL yes 
     LABEL "Utiliza Layout PadrÆo do Usu rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lMaterialTransito AS LOGICAL INITIAL no 
     LABEL "Material em Trƒnsito" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .71 NO-UNDO.

DEFINE VARIABLE lMovtoEstoq AS LOGICAL INITIAL no 
     LABEL "Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lNFCompl AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Complementar" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lOrdemCompra AS LOGICAL INITIAL no 
     LABEL "Ordem de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lParcelas AS LOGICAL INITIAL no 
     LABEL "Parcelas/Ordens do Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.14 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lPedidoCompra AS LOGICAL INITIAL no 
     LABEL "Pedido de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lProcessoImp AS LOGICAL INITIAL no 
     LABEL "Processo de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .71
     FONT 1 NO-UNDO.

DEFINE VARIABLE lSobrepor AS LOGICAL INITIAL yes 
     LABEL "Sobrepor arquivos j  existentes?" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .71
     FONT 1 NO-UNDO.

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

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL "Destino Relat¢rio Acompanhamento" 
      VIEW-AS TEXT 
     SIZE 25.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino-excel AS CHARACTER FORMAT "X(256)":U INITIAL "Destino Excel" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
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

DEFINE VARIABLE rsDestinyExcel AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Terminal", 1,
"Arquivo", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 20 COL 2
     btCancel AT ROW 20 COL 13
     btHelp2 AT ROW 20 COL 80
     rtToolBar AT ROW 19.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.38
         FONT 1.

DEFINE FRAME fPage2
     rs-opcao AT ROW 1.71 COL 2.14 NO-LABEL
     cProcEstabIni AT ROW 1.79 COL 47.28
     cProcEstabFim AT ROW 1.79 COL 66.29 NO-LABEL
     cProcImpIni AT ROW 2.71 COL 36.14
     cProcImpFim AT ROW 2.71 COL 66.29 NO-LABEL
     iEmitProcIni AT ROW 3.63 COL 44.28
     iEmitProcFim AT ROW 3.63 COL 66.29 NO-LABEL
     dDataEmisIni AT ROW 4.54 COL 43.14 COLON-ALIGNED
     dDataEmisFim AT ROW 4.54 COL 64.29 COLON-ALIGNED NO-LABEL
     cEmbEstabIni AT ROW 6.79 COL 47.43
     cEmbEstabFim AT ROW 6.79 COL 66.43 NO-LABEL
     cEmbarqueIni AT ROW 7.75 COL 38.43
     cEmbarqueFim AT ROW 7.71 COL 66.43 NO-LABEL
     cDISiscomexIni AT ROW 8.67 COL 38.43
     cDISiscomexFim AT ROW 8.63 COL 66.43 NO-LABEL
     iDIEMSIni AT ROW 9.58 COL 44.43
     iDIEMSFim AT ROW 9.54 COL 66.43 NO-LABEL
     dDataDIIni AT ROW 10.5 COL 43.29 COLON-ALIGNED
     dDataDIFim AT ROW 10.5 COL 64.43 COLON-ALIGNED NO-LABEL
     cPedEstabIni AT ROW 12.42 COL 47.43
     cPedEstabFim AT ROW 12.42 COL 66.43 NO-LABEL
     iPedidoIni AT ROW 13.33 COL 38.43
     iPedidoFim AT ROW 13.33 COL 66.43 NO-LABEL
     iOrdemCompraIni AT ROW 14.25 COL 38.43
     iOrdemCompraFim AT ROW 14.25 COL 66.43 NO-LABEL
     iEmitPedIni AT ROW 15.17 COL 44.43
     iEmitPedFim AT ROW 15.17 COL 66.43 NO-LABEL
     dDataPedIni AT ROW 16.13 COL 43.29 COLON-ALIGNED
     dDataPedFim AT ROW 16.13 COL 64.43 COLON-ALIGNED NO-LABEL
     text-procexp-selecao AT ROW 1.13 COL 25.86 COLON-ALIGNED NO-LABEL
     text-informa AT ROW 1.17 COL 2.72 NO-LABEL
     text-embarque-selecao AT ROW 6 COL 27 COLON-ALIGNED NO-LABEL
     text-pedido-selecao AT ROW 11.75 COL 26.43 COLON-ALIGNED NO-LABEL
     IMAGE-11 AT ROW 1.79 COL 56.14
     IMAGE-12 AT ROW 1.79 COL 63.29
     IMAGE-13 AT ROW 2.71 COL 56.14
     IMAGE-14 AT ROW 2.71 COL 63.29
     IMAGE-15 AT ROW 4.54 COL 56.14
     IMAGE-16 AT ROW 4.54 COL 63.29
     RECT-35 AT ROW 1.46 COL 1.57
     RECT-29 AT ROW 1.5 COL 26
     RECT-28 AT ROW 12.08 COL 26
     IMAGE-1 AT ROW 12.42 COL 56.29
     IMAGE-2 AT ROW 12.42 COL 63.43
     IMAGE-3 AT ROW 13.33 COL 56.29
     IMAGE-4 AT ROW 13.33 COL 63.43
     IMAGE-5 AT ROW 14.25 COL 56.29
     IMAGE-6 AT ROW 14.25 COL 63.43
     IMAGE-9 AT ROW 16.13 COL 56.29
     IMAGE-10 AT ROW 16.13 COL 63.43
     IMAGE-17 AT ROW 3.63 COL 56.14
     IMAGE-18 AT ROW 3.63 COL 63.29
     IMAGE-19 AT ROW 15.17 COL 56.29
     IMAGE-20 AT ROW 15.17 COL 63.43
     RECT-32 AT ROW 6.33 COL 26
     IMAGE-21 AT ROW 6.79 COL 56.29
     IMAGE-22 AT ROW 6.79 COL 63.43
     IMAGE-23 AT ROW 7.71 COL 56.29
     IMAGE-24 AT ROW 7.71 COL 63.43
     IMAGE-25 AT ROW 8.63 COL 56.29
     IMAGE-26 AT ROW 8.63 COL 63.43
     IMAGE-27 AT ROW 10.5 COL 56.29
     IMAGE-28 AT ROW 10.5 COL 63.43
     IMAGE-29 AT ROW 9.54 COL 56.29
     IMAGE-30 AT ROW 9.54 COL 63.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 16.46
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio de Acompanhamento" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.83 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.08 COL 1.14 COLON-ALIGNED NO-LABEL
     rsDestinyExcel AT ROW 8.08 COL 2.86 HELP
          "Destino Relat¢rio Excel" NO-LABEL
     text-destino-excel AT ROW 7.33 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.33 COL 2
     RECT-10 AT ROW 7.58 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 16.46
         FONT 1.

DEFINE FRAME fPage4
     lPedidoCompra AT ROW 1.67 COL 3
     lProcessoImp AT ROW 2.38 COL 3
     lFornecedor AT ROW 3.04 COL 3
     lOrdemCompra AT ROW 3.75 COL 3
     lParcelas AT ROW 4.46 COL 5.86
     lItem AT ROW 5.17 COL 5.86
     lDeclaImport AT ROW 5.88 COL 3
     lAdicoesDI AT ROW 6.54 COL 5.86
     lAcompDI AT ROW 7.25 COL 5.86
     lMaterialTransito AT ROW 7.92 COL 3
     lEmbarqueImp AT ROW 1.67 COL 46
     lAcompEmb AT ROW 2.38 COL 48.86
     lDocumentos AT ROW 3.04 COL 46
     lItensDoc AT ROW 3.75 COL 48.86
     lDespItemDoc AT ROW 4.46 COL 51.57
     lMovtoEstoq AT ROW 5.17 COL 51.57
     lDuplicatas AT ROW 5.88 COL 49
     lDespImp AT ROW 6.54 COL 49
     lDupDespesas AT ROW 7.25 COL 49
     lNFCompl AT ROW 7.96 COL 49
     lEnviaDoct AT ROW 9.46 COL 16.72
     fi-destinatario AT ROW 10.17 COL 14.72 COLON-ALIGNED HELP
          "Separe destinat rios por '~;'"
     lLayoutUsuario AT ROW 12.13 COL 16.72
     fi-layout-padrao AT ROW 12.83 COL 14.72 COLON-ALIGNED
     btInputFile AT ROW 12.79 COL 64.86 HELP
          "Escolha do nome do arquivo"
     lSobrepor AT ROW 14.25 COL 16.72
     fi-destino-arq AT ROW 14.92 COL 14.57 COLON-ALIGNED
     btInputFile-2 AT ROW 14.83 COL 64.72 HELP
          "Escolha do nome do arquivo"
     text-detalhar AT ROW 1 COL 4.43 NO-LABEL
     text-layout AT ROW 11.42 COL 6.43 NO-LABEL
     RECT-12 AT ROW 14 COL 2
     RECT-30 AT ROW 1.29 COL 2
     RECT-33 AT ROW 9.29 COL 2
     RECT-34 AT ROW 11.75 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 16.46
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
         HEIGHT             = 20.38
         WIDTH              = 90
         MAX-HEIGHT         = 39.04
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.04
         VIRTUAL-WIDTH      = 182.86
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN cDISiscomexFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cDISiscomexIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEmbarqueFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEmbarqueIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEmbEstabFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEmbEstabIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cPedEstabFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cPedEstabIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cProcEstabFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cProcEstabIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cProcImpFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cProcImpIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iDIEMSFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iDIEMSIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iEmitPedFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iEmitPedIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iEmitProcFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iEmitProcIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iOrdemCompraFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iOrdemCompraIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iPedidoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iPedidoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-informa IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR TOGGLE-BOX lAdicoesDI IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lParcelas IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-detalhar IN FRAME fPage4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-layout IN FRAME fPage4
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-destino-excel:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino Excel".

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
  run utp/ut-dir(input c-lb-input-title,
                  output c-dir,
                  output l-cancelado).
   if not l-cancelado then
       assign fi-layout-padrao:screen-value = /* campo de destino da tela */
            if length (c-dir) > 3 
            and substr(c-dir, length(c-dir), 1) <> "~\":U
            then (c-dir + "~\":U) 
            else c-dir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInputFile-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile-2 wReport
ON CHOOSE OF btInputFile-2 IN FRAME fPage4
DO:
  run utp/ut-dir(input c-lb-input-title,
                  output c-dir,
                  output l-cancelado).
   if not l-cancelado then
       assign fi-destino-arq:screen-value = /* campo de destino da tela */
            if length (c-dir) > 3 
            and substr(c-dir, length(c-dir), 1) <> "~\":U
            then (c-dir + "~\":U) 
            else c-dir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME lDeclaImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lDeclaImport wReport
ON VALUE-CHANGED OF lDeclaImport IN FRAME fPage4 /* Declara‡Æo de Importa‡Æo */
DO:
    IF INPUT FRAME fPage4 lDeclaImport THEN DO:
        ENABLE lAdicoesDI WITH FRAME fPage4.
        ENABLE lAcompDI WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE lAdicoesDI WITH FRAME fPage4.
        DISABLE lAcompDI   WITH FRAME fPage4.
        ASSIGN lAdicoesDI  = NO.
        ASSIGN lAcompDI    = NO.
        DISPLAY lAdicoesDI WITH FRAME fPage4.
        DISPLAY lAcompDI   WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lDocumentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lDocumentos wReport
ON VALUE-CHANGED OF lDocumentos IN FRAME fPage4 /* Documentos de Entrada */
DO:
    IF INPUT FRAME fPage4 lDocumentos THEN DO:
        ENABLE lItensDoc    WITH FRAME fPage4.
        ENABLE lDuplicatas  WITH FRAME fPage4.
        ENABLE lDespImp     WITH FRAME fPage4.
        ENABLE lDupDespesas WITH FRAME fPage4.
        ENABLE lNFCompl     WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE lItensDoc    WITH FRAME fPage4.
        DISABLE lDuplicatas  WITH FRAME fPage4.
        DISABLE lDespImp     WITH FRAME fPage4.
        DISABLE lDupDespesas WITH FRAME fPage4.
        DISABLE lNFCompl     WITH FRAME fPage4.
        ASSIGN lItensDoc     = NO.
        ASSIGN lDuplicatas   = NO.
        ASSIGN lDespImp      = NO.
        ASSIGN lDupDespesas  = NO.
        ASSIGN lNFCompl      = NO.
        DISPLAY lItensDoc    WITH FRAME fPage4.
        DISPLAY lDuplicatas  WITH FRAME fPage4.
        DISPLAY lDespImp     WITH FRAME fPage4.
        DISPLAY lDupDespesas WITH FRAME fPage4.
        DISPLAY lNFCompl     WITH FRAME fPage4.
    END.
    APPLY "VALUE-CHANGED":U TO lItensDoc IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lEmbarqueImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lEmbarqueImp wReport
ON VALUE-CHANGED OF lEmbarqueImp IN FRAME fPage4 /* Embarque de Importa‡Æo */
DO:
    IF INPUT FRAME fPage4 lEmbarqueImp THEN DO:
        ENABLE lAcompEmb WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE lAcompEmb WITH FRAME fPage4.
        ASSIGN lAcompEmb  = NO.
        DISPLAY lAcompEmb WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lEnviaDoct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lEnviaDoct wReport
ON VALUE-CHANGED OF lEnviaDoct IN FRAME fPage4 /* Envia Docto via E-mail */
DO:
    IF INPUT FRAME fPage4 lEnviaDoct THEN
        ENABLE fi-destinatario WITH FRAME fPage4.
    ELSE
        DISABLE fi-destinatario WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lItensDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lItensDoc wReport
ON VALUE-CHANGED OF lItensDoc IN FRAME fPage4 /* Itens do Documento */
DO:
    IF INPUT FRAME fPage4 lItensDoc THEN DO:
        ENABLE lMovtoEstoq WITH FRAME fPage4.
        ENABLE lDespItemDoc WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE lMovtoEstoq WITH FRAME fPage4.
        ASSIGN lMovtoEstoq  = NO.
        DISPLAY lMovtoEstoq WITH FRAME fPage4.
        DISABLE lDespItemDoc WITH FRAME fPage4.
        ASSIGN lDespItemDoc  = NO.
        DISPLAY lDespItemDoc WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lLayoutUsuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lLayoutUsuario wReport
ON VALUE-CHANGED OF lLayoutUsuario IN FRAME fPage4 /* Utiliza Layout PadrÆo do Usu rio */
DO:
    IF INPUT FRAME fPage4 lLayoutUsuario THEN DO:
        DISABLE fi-layout-padrao 
                btInputFile WITH FRAME fPage4.
        ASSIGN fi-layout-padrao:SCREEN-VALUE IN FRAME fPage4 = "":U.
    END.
    ELSE 
        ENABLE fi-layout-padrao 
               btInputFile WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOrdemCompra wReport
ON VALUE-CHANGED OF lOrdemCompra IN FRAME fPage4 /* Ordem de Compra */
DO:
    IF INPUT FRAME fPage4 lOrdemCompra THEN DO:
        ENABLE lParcelas WITH FRAME fPage4.
        ENABLE lItem WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE lParcelas WITH FRAME fPage4.
        ASSIGN lParcelas  = NO.
        DISPLAY lParcelas WITH FRAME fPage4.
        DISABLE lItem WITH FRAME fPage4.
        ASSIGN lItem  = NO.
        DISPLAY lItem WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao wReport
ON VALUE-CHANGED OF rs-opcao IN FRAME fPage2
DO:

    DISABLE cProcEstabIni cProcEstabFim cProcImpIni cProcImpFim
            iEmitProcIni iEmitProcFim dDataEmisIni dDataEmisFim
            cEmbEstabIni cEmbEstabFim cEmbarqueIni cEmbarqueFim
            cDISiscomexIni cDISiscomexFim iDIEMSIni iDIEMSFim
            dDataDIIni dDataDIFim cPedEstabIni cPedEstabFim
            iPedidoIni iPedidoFim iOrdemCompraIni iOrdemCompraFim
            iEmitPedIni iEmitPedFim dDataPedIni dDataPedFim
            WITH FRAME fPage2.

    /*Leitura por Processo Importa‡Æo*/
    IF INPUT FRAME fPage2 rs-opcao = "1":U THEN DO:
        ENABLE cProcEstabIni cProcEstabFim cProcImpIni cProcImpFim
               iEmitProcIni iEmitProcFim dDataEmisIni dDataEmisFim
               WITH FRAME fPage2.
    END.
    /*Leitura por Embarque*/
    IF INPUT FRAME fPage2 rs-opcao = "2":U THEN DO:
        ENABLE cEmbEstabIni cEmbEstabFim cEmbarqueIni cEmbarqueFim 
               cDISiscomexIni cDISiscomexFim iDIEMSIni iDIEMSFim
               dDataDIIni dDataDIFim
               WITH FRAME fPage2.
    END.
    /*Leitura por Pedido de Compra/Ordem de Compra*/
    IF INPUT FRAME fPage2 rs-opcao = "3":U THEN DO:
        ENABLE cPedEstabIni cPedEstabFim iPedidoIni iPedidoFim
               iOrdemCompraIni iOrdemCompraFim iEmitPedIni iEmitPedFim
               dDataPedIni dDataPedFim  
               WITH FRAME fPage2.
    END.
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
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestinyExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestinyExcel wReport
ON VALUE-CHANGED OF rsDestinyExcel IN FRAME fPage6
DO:
   /*{report/rprse.i}*/
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

{utp/ut-liter.i "Informar" *}
assign text-informa = trim(return-value).

/* Tradu‡Æo folder Sele‡Æo */
{utp/ut-liter.i "Dados_Processo_Importa‡Æo" *}
assign text-procexp-selecao = trim(return-value).
{utp/ut-liter.i "Estabel" *}
assign cProcEstabIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Processo_Imp" *}
assign cProcImpIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Data_EmissÆo" *}
assign dDataEmisIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Fornecedor" *}
assign iEmitProcIni:label in frame fPage2 = trim(return-value).

/* Tradu‡Æo folder Sele‡Æo */
{utp/ut-liter.i "Dados_Embarque/Declara‡Æo_de_Importa‡Æo" *}
assign text-embarque-selecao = trim(return-value).
{utp/ut-liter.i "Estabel" *}
assign cEmbEstabIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Embarque" *}
assign cEmbarqueIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "DI_Siscomex" *}
assign cDISiscomexIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "DI_EMS" *}
assign iDIEMSIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Data_da_DI" *}
assign dDataDIIni:label in frame fPage2 = trim(return-value).

/* Tradu‡Æo folder Sele‡Æo */
{utp/ut-liter.i "Dados_Pedido/Ordem_de_Compra" *}
assign text-pedido-selecao = trim(return-value).
{utp/ut-liter.i "Estabel" *}
assign cPedEstabIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Pedido" *}
assign iPedidoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Ordem_Compra" *}
assign iOrdemCompraIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Data_Pedido" *}
assign dDataPedIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Fornecedor" *}
assign iEmitPedIni:label in frame fPage2 = trim(return-value).

/* Tradu‡Æo folder Parƒmetro */
/* T¡tulos Retƒngulos */
{utp/ut-liter.i "Detalhar" *}
assign text-detalhar = trim(return-value).
{utp/ut-liter.i "Layout_Original" *}
assign text-layout = trim(return-value).
{report/mainblock.i}

/* Parƒmetros*/
{utp/ut-liter.i "Pedido_de_Compra" *}
assign lPedidoCompra:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Processo_de_Importa‡Æo" *}
assign lProcessoImp:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Fornecedor" *}
assign lFornecedor:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Ordem_de_Compra" *}
assign lOrdemCompra:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Parcelas/Ordens do Embarque" *}
assign lParcelas:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Item" *}
assign lItem:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Declara‡Æo_de_Importa‡Æo" *}
assign lDeclaImport:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Adi‡äes_da_DI" *}
assign lAdicoesDI:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Acompanhamento_da_DI" *}
assign lAcompDI:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Embarque_de_Importa‡Æo" *}
assign lEmbarqueImp:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Acompanhamento_Embarque" *}
assign lAcompEmb:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Documentos" *}
assign lDocumentos:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Itens_do_Documento" *}
assign lItensDoc:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Despesas_Item_Documento" *}
assign lDespItemDoc:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Estoque" *}
assign lMovtoEstoq:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Duplicatas_do_Fornecedor_da_Mercadoria" *}
assign lDuplicatas:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Despesas_de_Importa‡Æo" *}
assign lDespImp:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Duplicatas_de_Despesas" *}
assign lDupDespesas:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Nota_Fiscal_Complementar" *}
assign lNFCompl:label in frame fPage4 = trim(return-value).

{utp/ut-liter.i "Envia_Docto_via_E-mail" *}
assign lEnviaDoct:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Destinat rios" *}
assign fi-destinatario:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Utiliza_Layout_PadrÆo_do_Usu rio" *}
assign lLayoutUsuario:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Layout_PadrÆo" *}
assign fi-layout-padrao:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Sobrepor_arquivos_j _existentes?" *}
assign lSobrepor:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Destino" *}
assign fi-destino-arq:label in frame fPage4 = trim(return-value).

{utp/ut-liter.i "Selecione o diret¢rio." *}
ASSIGN c-lb-input-title = RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     M‚todo executado depois de iniciar a tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/




/* Disables necess rios e Eventos*/
APPLY "VALUE-CHANGED":U TO rs-opcao IN FRAME fPage2.


DISABLE lParcelas
        lItem
        lAdicoesDI
        lAcompDI
        lAcompEmb
        lItensDoc
        lMovtoEstoq
        lDespItemDoc
        lDuplicatas
        lDespImp
        lDupDespesas
        lNFCompl
        fi-destinatario 
        fi-layout-padrao
        btInputFile WITH FRAME fPage4.

FIND FIRST param-global NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     M‚todo respons vel por executar o relat¢rio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "":U AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

        do with frame fPage4:

           IF INPUT FRAME fPage4 lLayoutUsuario = NO THEN DO:
               assign file-info:file-name = input frame fpage4 fi-layout-padrao.
               if  file-info:pathname = ? 
               OR  SEARCH(input frame fpage4 fi-layout-padrao) <> ? then do:
                  
                   {utp/ut-liter.i "layout padrÆo"}
                   run utp/ut-msgs.p (input "show":U,
                                      input 4715,
                                      input TRIM(RETURN-VALUE)).                               
                   RUN setfolder IN hfolder (INPUT 2).

                   apply "ENTRY":U to fi-layout-padrao in frame fpage4.
                   return ERROR.
               end.  
           END.

           assign file-info:file-name = input frame fpage4 fi-destino-arq.
           if  file-info:pathname = ? 
           OR  SEARCH(input frame fpage4 fi-destino-arq) <> ? then do:

               {utp/ut-liter.i "destino"}
               run utp/ut-msgs.p (input "show":U,
                                  input 4715,
                                  input TRIM(RETURN-VALUE)).
               RUN setfolder IN hfolder (INPUT 2).
               apply "ENTRY":U to fi-destino-arq in frame fpage4.
               return ERROR.
           end.  

        end.
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
           tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
           &endif
           /* SELECAO */
           tt-param.iOpcao                   = INPUT FRAME fPage2 rs-opcao
           tt-param.cProcEstabIni            = INPUT FRAME fPage2 cProcEstabIni
           tt-param.cProcEstabFim            = INPUT FRAME fPage2 cProcEstabFim
           tt-param.cProcImpIni              = INPUT FRAME fPage2 cProcImpIni
           tt-param.cProcImpFim              = INPUT FRAME fPage2 cProcImpFim
           tt-param.iEmitProcIni             = INPUT FRAME fPage2 iEmitProcIni
           tt-param.iEmitProcFim             = INPUT FRAME fPage2 iEmitProcFim
           tt-param.dDataEmisIni             = INPUT FRAME fPage2 dDataEmisIni
           tt-param.dDataEmisFim             = INPUT FRAME fPage2 dDataEmisFim
           tt-param.cEmbEstabIni             = INPUT FRAME fPage2 cEmbEstabIni
           tt-param.cEmbEstabFim             = INPUT FRAME fPage2 cEmbEstabFim
           tt-param.cEmbarqueIni             = INPUT FRAME fPage2 cEmbarqueIni
           tt-param.cEmbarqueFim             = INPUT FRAME fPage2 cEmbarqueFim
           tt-param.cDISiscomexIni           = INPUT FRAME fPage2 cDISiscomexIni
           tt-param.cDISiscomexFim           = INPUT FRAME fPage2 cDISiscomexFim
           tt-param.iDIEMSIni                = INPUT FRAME fPage2 iDIEMSIni
           tt-param.iDIEMSFim                = INPUT FRAME fPage2 iDIEMSFim
           tt-param.dDataDIIni               = INPUT FRAME fPage2 dDataDIIni
           tt-param.dDataDIFim               = INPUT FRAME fPage2 dDataDIFim
           tt-param.cPedEstabIni             = INPUT FRAME fPage2 cPedEstabIni
           tt-param.cPedEstabFim             = INPUT FRAME fPage2 cPedEstabFim
           tt-param.iPedidoIni               = INPUT FRAME fPage2 iPedidoIni
           tt-param.iPedidoFim               = INPUT FRAME fPage2 iPedidoFim
           tt-param.iOrdemCompraIni          = INPUT FRAME fPage2 iOrdemCompraIni
           tt-param.iOrdemCompraFim          = INPUT FRAME fPage2 iOrdemCompraFim
           tt-param.iEmitPedIni              = INPUT FRAME fPage2 iEmitPedIni
           tt-param.iEmitPedFim              = INPUT FRAME fPage2 iEmitPedFim
           tt-param.dDataPedIni              = INPUT FRAME fPage2 dDataPedIni
           tt-param.dDataPedFim              = INPUT FRAME fPage2 dDataPedFim
           /* DETALHAR */
           tt-param.lPedidoCompra            = INPUT FRAME fPage4 lPedidoCompra
           tt-param.lProcessoImp             = INPUT FRAME fPage4 lProcessoImp
           tt-param.lFornecedor              = INPUT FRAME fPage4 lFornecedor
           tt-param.lOrdemCompra             = INPUT FRAME fPage4 lOrdemCompra
           tt-param.lParcelas                = INPUT FRAME fPage4 lParcelas
           tt-param.lItem                    = INPUT FRAME fPage4 lItem
           tt-param.lDeclaImport             = INPUT FRAME fPage4 lDeclaImport
           tt-param.lAdicoesDI               = INPUT FRAME fPage4 lAdicoesDI
           tt-param.lAcompDI                 = INPUT FRAME fPage4 lAcompDI
           tt-param.lMaterialTransito        = INPUT FRAME fPage4 lMaterialTransito
           tt-param.lEmbarqueImp             = INPUT FRAME fPage4 lEmbarqueImp
           tt-param.lAcompEmb                = INPUT FRAME fPage4 lAcompEmb
           tt-param.lDocumentos              = INPUT FRAME fPage4 lDocumentos
           tt-param.lItensDoc                = INPUT FRAME fPage4 lItensDoc
           tt-param.lDespItemDoc             = INPUT FRAME fPage4 lDespItemDoc
           tt-param.lMovtoEstoq              = INPUT FRAME fPage4 lMovtoEstoq
           tt-param.lDuplicatas              = INPUT FRAME fPage4 lDuplicatas
           tt-param.lDespImp                 = INPUT FRAME fPage4 lDespImp
           tt-param.lDupDespesas             = INPUT FRAME fPage4 lDupDespesas
           tt-param.lNFCompl                 = INPUT FRAME fPage4 lNFCompl
           /* PARAMETROS */
           tt-param.lEnviaDocto              = INPUT FRAME fPage4 lEnviaDoct
           tt-param.cDestinatario            = INPUT FRAME fPage4 fi-destinatario
           tt-param.lUtilizaLayout           = INPUT FRAME fPage4 lLayoutUsuario
           tt-param.cLayoutPadrao            = INPUT FRAME fPage4 fi-layout-padrao
           tt-param.lSobreporArq             = INPUT FRAME fPage4 lSobrepor
           tt-param.cDestinoArq              = INPUT FRAME fPage4 fi-destino-arq
           tt-param.iDestinoExcel            = INPUT FRAME fPage6 rsDestinyExcel.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i imp/im0730rp.p}
    
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
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i imp/im0730rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

