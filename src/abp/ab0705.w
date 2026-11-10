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
{include/i-prgvrs.i AB0705 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0705 MAB}
&ENDIF


/*****************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
****************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0705
&GLOBAL-DEFINE Version        2.00.00.005
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Layout,Seleá∆o,ParÉmetros,Log

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   brLayout ~
                              bt-verify ~
                              bt-rescue ~
                              bt-plus ~
                              bt-save ~
                              bt-layout ~
                              rsLayout ~
                              rsTipo ~
                              fiDelimitador

&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile ~
                              bt-edit ~
                              rsImport ~
                              fiAgrupa ~
                              tbValPadr ~
                              ep-prin

&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada fiTexto4
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-imprime text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    fiEmpFim fiEmpIni ~
                              fiEqptoFim fiEqptoIni ~
                              fiDataFim fiDataIni ~
                              fiPlacaFim fiPlacaIni
&GLOBAL-DEFINE page4Fields    cInputFile 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields 
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

{frbo/bofr089.i ttLayout} /* Temp-table mab-layout-import */
/*********************************************************************/
                                               /** Parameters Definitions **/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer

    field todos            as integer  /** 1 = Todos / 2 = Rejeitados **/
    field execucao         as integer
    field i-origem         as integer
    field arq-entrada      as char format "x(80)"
    field arq-destino      as char format "x(80)"
    field dtInicial        as date format "99/99/9999"
    field dtFinal          as date format "99/99/9999"
&IF "{&mguni_version}" >= "2.071" &THEN
    field empIni           LIKE empresa.ep-codigo format "x(03)"
    field empFim           LIKE empresa.ep-codigo format "x(03)"
&ELSE
    field empIni           as integer format ">>9"
    field empFim           as integer format ">>9"
&ENDIF
    field eqptoIni         as character format "x(16)"
    field eqptoFim         as character format "x(16)"
    field placaIni         as character format "x(8)"
    field placaFim         as character format "x(8)"
    field cDelimitador     as character format "x(1)"
    field iLayout          as integer
    field iImport          as integer
    field iClassif         as integer
    field iAgrupa          as integer
    field lValoresPadr     as logical
    field cLayout          as character
    field cImport          as character format "x(20)"
    field cClassif         as character
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-prin          LIKE empresa.ep-codigo format "x(03)"
&ELSE
    field ep-prin          as integer format ">>9"
&ENDIF
&IF DEFINED(bf_mnt_ems206b) &THEN
    FIELD unidNegocIni     AS CHARACTER FORMAT "x(03)"
    FIELD unidNegocFim     AS CHARACTER FORMAT "x(03)"
&ENDIF
    .

DEFINE TEMP-TABLE tt-digita no-undo like ttLayout.

define buffer b-tt-digita for tt-digita.

define temp-table ttLayoutAux no-undo like ttLayout.

/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
/*********************************************************************/
                                                  /** Definiá∆o vari†veis **/

DEFINE VARIABLE l-ok           as logical              no-undo.
DEFINE VARIABLE c-arq-digita   as char                 no-undo.
DEFINE VARIABLE c-terminal     as char                 no-undo.
DEFINE VARIABLE c-arq-layout   as char                 no-undo.      
DEFINE VARIABLE c-arq-temp     as char                 no-undo.
DEFINE VARIABLE hDBOLayout      as handle               no-undo.
DEFINE VARIABLE c-inicio       as char    format ">>9" no-undo.
DEFINE VARIABLE i-rows         as integer              no-undo.
DEFINE VARIABLE i-sequencia    AS INTEGER              NO-UNDO.
DEFINE VARIABLE mandatorio     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE posicaoInvalida AS LOGICAL             NO-UNDO.
def stream   s-imp.
define variable c-confirma as character no-undo.
/** Vari†veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}


/* Buffer ttLayout para verificar a integridade das posiá‰es iniciais */
DEFINE BUFFER bfttLayout4 FOR ttLayout.

define buffer bfttLayout  for ttLayout.
define buffer bfttLayout2 for ttLayout.
define buffer bfttLayout3 for ttLayout.
DEFINE VARIABLE i-posicao-ini AS INTEGER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brLayout

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttLayout

/* Definitions for BROWSE brLayout                                      */
&Scoped-define FIELDS-IN-QUERY-brLayout /** Mostra dados no browse **/ ttLayout.num-seq f-campo(ttLayout.nom-campo) @ ttLayout.nom-campo ttLayout.num-tam-campo ttLayout.num-pos-inicial ttLayout.num-pos-final ttLayout.cod-tip-dado ttLayout.qti-casas-dec mandatorio /*format "sim/n∆o"*/ /*********************************************************************/ /** Deixa campo habilitado no browse **/   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLayout ttLayout.num-tam-campo ttLayout.num-pos-inicial   
&Scoped-define ENABLED-TABLES-IN-QUERY-brLayout ttLayout
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brLayout ttLayout
&Scoped-define SELF-NAME brLayout
&Scoped-define QUERY-STRING-brLayout FOR EACH ttLayout by ttLayout.num-pos-inicial.  IF AVAIL ttLayout THEN /*********************************************************************/
&Scoped-define OPEN-QUERY-brLayout OPEN QUERY brLayout FOR EACH ttLayout by ttLayout.num-pos-inicial.  IF AVAIL ttLayout THEN /*********************************************************************/.
&Scoped-define TABLES-IN-QUERY-brLayout ttLayout
&Scoped-define FIRST-TABLE-IN-QUERY-brLayout ttLayout


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brLayout}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-campo wReport 
FUNCTION f-campo RETURNS CHARACTER
  (input p-campo as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-tamanho wReport 
FUNCTION f-tamanho RETURNS INTEGER
  (input p-inicio  as integer,
   input p-tamanho as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Fechar".

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1 TOOLTIP "Ajuda".

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1 TOOLTIP "Executar".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-layout 
     LABEL "Imprimir &Layout" 
     SIZE 15 BY 1 TOOLTIP "Imprimir Layout".

DEFINE BUTTON bt-Plus 
     LABEL "&Gerar Default" 
     SIZE 15 BY 1 TOOLTIP "Gerar Default".

DEFINE BUTTON bt-rescue 
     LABEL "&Recuperar" 
     SIZE 15 BY 1 TOOLTIP "Recuperar".

DEFINE BUTTON bt-save 
     LABEL "&Salvar" 
     SIZE 15 BY 1 TOOLTIP "Salvar".

DEFINE BUTTON bt-verify 
     LABEL "&Verificar" 
     SIZE 15 BY 1 TOOLTIP "Verificar".

DEFINE VARIABLE fiDelimitador AS CHARACTER FORMAT "X(08)":U INITIAL "~;" 
     LABEL "Delimitador" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(11)":U INITIAL "Tipo Layout" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Importaá∆o" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE rsLayout AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "GoodCard", 1,
"CTF", 2,
"Outros", 3,
"COPEC", 4
     SIZE 34 BY .75 NO-UNDO.

DEFINE VARIABLE rsTipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Padr∆o", 1,
"Delimitador", 2
     SIZE 20.57 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 1.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 1.75.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 1.75.

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEmpIni LIKE empresa.ep-codigo
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiPlacaFim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fiPlacaIni AS CHARACTER FORMAT "x(12)" 
     LABEL "Placa":R7 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fiUnidNegocFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
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

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-edit 
     LABEL "E&ditar Arquivo" 
     SIZE 12 BY 1 TOOLTIP "Editar Arquivo".

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolher o Arquivo a ser importado".

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE ep-prin AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Empresa Principal" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiAGrupa AS INTEGER FORMAT ">>>,>>9":U INITIAL 10 
     LABEL "Acumular fichas com diferenáa de tempo de" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiTexto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Importa Por" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto4 AS CHARACTER FORMAT "X(256)":U INITIAL "Minutos" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Entrada" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsImport AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Placa", 1,
"C¢digo Equipamento", 2
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.14 BY 2.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.14 BY 2.

DEFINE VARIABLE tbValPadr AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 78.43 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79
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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLayout FOR 
      ttLayout SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLayout wReport _FREEFORM
  QUERY brLayout DISPLAY
      /** Mostra dados no browse **/
ttLayout.num-seq            format "999"            width 3
f-campo(ttLayout.nom-campo) @ ttLayout.nom-campo    width 27  FORMAT 'x(32)'
ttLayout.num-tam-campo                              width 8
ttLayout.num-pos-inicial                            width 8
ttLayout.num-pos-final      format ">>>>9"          width 6
ttLayout.cod-tip-dado                               width 7
ttLayout.qti-casas-dec                              width 6
mandatorio                                          width 7




 /*format "sim/n∆o"*/


/*********************************************************************/
/** Deixa campo habilitado no browse **/
enable
ttLayout.num-tam-campo
ttLayout.num-pos-inicial
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 80 BY 6
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     brLayout AT ROW 3.92 COL 1
     fiTexto1 AT ROW 1.25 COL 4 COLON-ALIGNED NO-LABEL
     fiTexto2 AT ROW 1.25 COL 39 COLON-ALIGNED NO-LABEL
     rsLayout AT ROW 2.17 COL 5 NO-LABEL
     rsTipo AT ROW 2 COL 41.43 NO-LABEL
     bt-save AT ROW 10 COL 1
     bt-verify AT ROW 10 COL 16
     bt-rescue AT ROW 10 COL 31
     bt-Plus AT ROW 10 COL 46
     bt-layout AT ROW 10 COL 61
     fiDelimitador AT ROW 2 COL 70.86 COLON-ALIGNED
     RECT-13 AT ROW 1.5 COL 4
     RECT-14 AT ROW 1.5 COL 40
     RECT-27 AT ROW 1.5 COL 63
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage3
     fiDataIni AT ROW 1.5 COL 24 COLON-ALIGNED
     fiDataFim AT ROW 1.5 COL 52.86 COLON-ALIGNED NO-LABEL
     fiPlacaIni AT ROW 2.5 COL 21.86 COLON-ALIGNED HELP
          "Placa"
     fiPlacaFim AT ROW 2.5 COL 53 COLON-ALIGNED HELP
          "Placa" NO-LABEL
     fiEmpIni AT ROW 3.5 COL 23.29 HELP
          "C¢digo da empresa"
          LABEL "Empresa":R9
          FONT 1
     fiEmpFim AT ROW 3.5 COL 55 HELP
          "C¢digo da empresa" NO-LABEL
          FONT 1
     fiEqptoIni AT ROW 4.5 COL 10
     fiEqptoFim AT ROW 4.5 COL 55 NO-LABEL
     fiUnidNegocIni AT ROW 5.5 COL 28.72 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 5.5 COL 53 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 35.86
     IMAGE-2 AT ROW 1.5 COL 51.29
     IMAGE-3 AT ROW 2.5 COL 35.86
     IMAGE-4 AT ROW 2.5 COL 51.29
     IMAGE-5 AT ROW 3.5 COL 35.86
     IMAGE-6 AT ROW 3.5 COL 51.29
     IMAGE-7 AT ROW 4.5 COL 35.86
     IMAGE-8 AT ROW 4.5 COL 51.29
     IMAGE-9 AT ROW 5.5 COL 35.86
     IMAGE-10 AT ROW 5.5 COL 51.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.29 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 5.71 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btDestinyFile AT ROW 5.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 5.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.88 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-imprime AT ROW 1.46 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.75 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 7.13 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.42 COL 2
     RECT-11 AT ROW 1.75 COL 2
     RECT-8 AT ROW 4.04 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     ep-prin AT ROW 2.71 COL 51 COLON-ALIGNED HELP
          "C¢digo da empresa do equipamento"
     tbValPadr AT ROW 6.25 COL 2.57
     fiAGrupa AT ROW 4.54 COL 33 COLON-ALIGNED
     fiTexto4 AT ROW 4.67 COL 40 COLON-ALIGNED
     fiTexto3 AT ROW 1.75 COL 1 COLON-ALIGNED NO-LABEL
     rsImport AT ROW 2.75 COL 4 NO-LABEL
     cInputFile AT ROW 9.79 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 9.79 COL 43.14 HELP
          "Escolher o Arquivo a ser importado"
     bt-edit AT ROW 9.5 COL 50.72
     text-entrada AT ROW 8.75 COL 4.14 NO-LABEL
     RECT-12 AT ROW 9 COL 2
     RECT-28 AT ROW 2 COL 1.86
     RECT-29 AT ROW 4 COL 1.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
         TITLE              = "Importaá∆o de Abastecimentos"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB brLayout 1 fPage2 */
/* SETTINGS FOR BROWSE brLayout IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       brLayout:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brLayout:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEqptoFim IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEqptoIni IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Entrada".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLayout
/* Query rebuild information for BROWSE brLayout
     _START_FREEFORM
OPEN QUERY brLayout FOR EACH ttLayout by ttLayout.num-pos-inicial.

IF AVAIL ttLayout THEN
/*********************************************************************/
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brLayout */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Importaá∆o de Abastecimentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Importaá∆o de Abastecimentos */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brLayout
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON END-ERROR OF brLayout IN FRAME fPage2
/** Retorna dados ao original **/
anywhere
DO:
define variable i-posicao as integer no-undo.
define variable i-tamanho as integer no-undo.
    /** Posiciona no registro atual **/
    get current brLayout.                        
    /** Busca pelas posiá‰es e tamanhos da tabela **/
    run findPosicao in hDBOLayout (input  ttLayout.cod-prog-import,
                                   input  ttLayout.nom-bd,
                                   input  ttLayout.nom-tabela,
                                   input  ttLayout.num-seq,
                                   output i-posicao).
 case input frame fPage2 rsLayout:
           when 1 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705A":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                            /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705B":U,
                                                 INPUT  ttLayout.num-seq,
                                                 OUTPUT i-tamanho).
           end.

           when 2 then do:
             if input frame fPage2 rsTipo = 1 then
                 /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705C":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
               run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705D":U,
                                                INPUT  ttLayout.num-seq,
                                                OUTPUT i-tamanho).
           end.

           when 3 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705E":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                 /** Retorna tamanho m†ximo do campo **/
                  run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705F":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
           end.
       end case.    /** Mostra em tela os valores originais **/
    assign ttLayout.num-pos-inicial = i-posicao
           ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial)
           ttLayout.num-tam-campo  = i-tamanho
           ttLayout.num-tam-campo:screen-value in browse brLayout  = string(ttLayout.num-tam-campo).
    RUN pi-validate-browse IN THIS-PROCEDURE.

    apply "leave":U to browse brLayout.
    APPLY "entry":U TO bt-save IN FRAME fPage2.

    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ENTER OF brLayout IN FRAME fPage2
/** Atualiza a posiá∆o final **/
ANYWHERE   
DO:    
    apply 'row-leave':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON OFF-END OF brLayout IN FRAME fPage2
/** Sai do browse ao final **/
DO:
  apply 'entry':U to bt-save in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON OFF-HOME OF brLayout IN FRAME fPage2
/** Sai do browse ao in°cio **/
DO:
  apply 'entry':U to bt-save in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ROW-ENTRY OF brLayout IN FRAME fPage2
DO:
  IF NOT CAN-FIND(FIRST ttLayout) THEN DO:
      APPLY 'entry':U TO bt-plus IN FRAME fPage2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ROW-LEAVE OF brLayout IN FRAME fPage2
/** Atualiza dados da linha ao sair **/
ANYWHERE
DO:
  RUN pi-validate-browse IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON TAB OF brLayout IN FRAME fPage2
ANYWHERE
DO:
  RUN pi-validate-browse IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-edit wReport
ON CHOOSE OF bt-edit IN FRAME fPage4 /* Editar Arquivo */
DO: /** Editar o arquivo selecionado **/
/*   OS-COMMAND SILENT "notepad.exe" VALUE(input frame fPage4 cInputFile). */
  {report/imtrm.i "input frame fPage4 cInputFile" 3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout wReport
ON CHOOSE OF bt-layout IN FRAME fPage2 /* Imprimir Layout */
DO: /** Editar/Imprimir layout  do browse **/
    IF CAN-FIND(FIRST ttLayout) THEN
        run pi-print-layout IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Plus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Plus wReport
ON CHOOSE OF bt-Plus IN FRAME fPage2 /* Gerar Default */
DO: /** Recupera o banco de dados original **/
    run utp/ut-msgs.p ("Show", 27252, "").
    assign c-confirma = return-value.
    if c-confirma = "yes":U then do:
        run createDefaultAB0705 in hDBOLayout (input frame fpage2 rsLayout,
                                               input frame fpage2 rsTipo).
        run pi-atualiza-browse in this-procedure (input yes).
    end.
    apply "display":U to browse brLayout.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rescue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rescue wReport
ON CHOOSE OF bt-rescue IN FRAME fPage2 /* Recuperar */
DO: /** Recupera a temp-table conforme BO **/
    IF CAN-FIND(FIRST ttLayout) THEN
        run pi-atualiza-browse in this-procedure (input YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-save wReport
ON CHOOSE OF bt-save IN FRAME fPage2 /* Salvar */
DO: 
    IF CAN-FIND(FIRST ttLayout) THEN DO:
        RUN pi-update-layout IN THIS-PROCEDURE.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-verify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-verify wReport
ON CHOOSE OF bt-verify IN FRAME fPage2 /* Verificar */
DO: /** Valida os campos do Browse **/
    IF CAN-FIND(FIRST ttLayout) THEN DO:
        run pi-validate-layout IN THIS-PROCEDURE (INPUT YES).
        {&Open-Query-{&Browse-Name}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CHOOSE":U TO bt-save IN FRAME fPage2.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
   {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
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
    {report/imarq.i cInputFile fPage4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do on error undo, return no-apply:
       run piExecute IN THIS-PROCEDURE.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fiAGrupa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAGrupa wReport
ON LEAVE OF fiAGrupa IN FRAME fPage4 /* Acumular fichas com diferenáa de tempo de */
DO:
  if input frame fPage4 fiAgrupa > 59 then do:
     {utp/ut-liter.i Valor_informado_esta_incorreto._Deve_ser_que_menor_ou_igual_a_59_minutos *  }
     RUN utp/ut-msgs.p (INPUT 'show':U,         
                        INPUT 17006,            
                        INPUT return-value).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2" then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rsImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsImport wReport
ON VALUE-CHANGED OF rsImport IN FRAME fPage4
DO:
    do with frame fPage4:
        case self:screen-value:
            when "1" then do:
                assign ep-prin:sensitive     = no
                       ep-prin:screen-value in frame fPage4 = "0".
            end.
            when "2" then do:
                assign ep-prin:sensitive     = yes.
                for first param-global no-lock:
                    assign ep-prin:screen-value in frame fPage4 = string(param-global.empresa-prin).
                end.
            end.
        end case.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME rsLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsLayout wReport
ON VALUE-CHANGED OF rsLayout IN FRAME fPage2
DO:

    IF rsLayout:SCREEN-VALUE IN FRAME fPage2 = "4" THEN DO:
       ASSIGN rsTipo:SCREEN-VALUE IN FRAME fPage2 = "2"
              rsTipo:SENSITIVE IN FRAME fPage2 = NO.


    END.
    ELSE
      ASSIGN rsTipo:SENSITIVE IN FRAME fPage2 = YES.

    case input frame fpage2 rsLayout:
        when 3 then do:
            assign rsImport:sensitive in frame fPage4 =  yes.
        end.
        otherwise do:
            assign rsImport:sensitive in frame fPage4 =  no
                   rsImport = 1.
            disp rsImport with frame fpage4.
        end.
    end case.
    apply "VALUE-CHANGED":U to rsTipo   in frame fPage2.
    apply "VALUE-CHANGED":U to rsImport in frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsTipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipo wReport
ON VALUE-CHANGED OF rsTipo IN FRAME fPage2
DO:

  DEFINE VARIABLE c-porgrama AS CHARACTER  NO-UNDO.
  ASSIGN rsTipo = INPUT FRAME fPage2 rstipo.
  case input frame fpage2 rsTipo:
      when 1 then do:
          assign ttLayout.num-pos-final:visible in browse brLayout = yes
                 ttLayout.num-tam-campo:visible in browse brLayout = yes
                 fiDelimitador:sensitive in frame fpage2           = no.
          {utp/ut-liter.i In°cio }
          assign ttLayout.num-pos-inicial:label in browse brLayout = trim(return-value).
          {utp/ut-liter.i Tamanho }                                
          assign ttLayout.num-tam-campo:label   in browse brLayout = trim(return-value).
      end.
      when 2 then do:
         assign ttLayout.num-pos-final:visible in browse brLayout  = no
                ttLayout.num-tam-campo:visible in browse brLayout  = yes
                fiDelimitador:sensitive in frame fpage2            = yes.
         {utp/ut-liter.i Posiá∆o }
         assign ttLayout.num-pos-inicial:label in browse brLayout  = trim(return-value).
         {utp/ut-liter.i Importar_? }
         assign ttLayout.num-tam-campo:label   in browse brLayout  = trim(return-value).
      end.
  end case.
  run pi-atualiza-browse in this-procedure (input yes).
  /** Abre a Query do Browse **/
  case input frame fpage2 rsLayout:
     when 1 THEN DO:
         IF rsTipo = 1 THEN
             assign c-programa = "AB0705-G":U. 
         ELSE
             assign c-programa = "AB0705G2":U.
     END.
     when 2 then
         IF rsTipo = 1 THEN
            assign c-programa = "AB0705-C":U. 
         ELSE
            assign c-programa = "AB0705C2":U. 
     when 3 then
         IF rsTipo = 1 THEN
            assign c-programa = "AB0705-O":U. 
         ELSE
            assign c-programa = "AB0705O2":U.
  end case.

   IF NOT CAN-FIND(FIRST ttLayout                                       
                   where ttLayout.cod-prog-import = c-programa ) then do:
       run createDefaultAB0705 in hDBOLayout (input frame fpage2 rsLayout, 
                                              input frame fpage2 rsTipo).  
   END.
   FIND FIRST ttLayout                                       
        WHERE ttLayout.cod-prog-import = c-programa NO-LOCK NO-ERROR.
   run pi-atualiza-browse in this-procedure (input yes).
   apply "display":U to browse brLayout.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/

ASSIGN fiEmpIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEmpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

{report/mainblock.i}

{abp/abapi001.i2} /** Criaá∆o de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Destroy as handles existentes na mem¢ria.
------------------------------------------------------------------------------*/
/** Layout Import **/
if valid-handle (hDBOLayout) then
    delete procedure hDBOLayout.
/** Caixa de Mensagens **/
{method/showmessage.i3}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s a inicializaá∆o da tela
------------------------------------------------------------------------------*/
/** Layout **/
{utp/ut-liter.i "Seq."}
assign ttLayout.num-seq:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "TÇrmino"}
assign ttLayout.num-pos-final:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Conte£do"}
assign ttLayout.cod-tip-dado:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Decimais"}
assign ttLayout.qti-casas-dec:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Obrigat¢rio"}
assign /*ttLayout.log-*/ mandatorio:label in browse brLayout = trim(return-value)
       c-arq-layout                                     = session:temp-directory + "layoutAB0705.tmp".

assign rsTipo = 2. /** Delimitador **/
{utp/ut-liter.i Posiá∆o }
assign ttLayout.num-pos-final:visible in browse brLayout  = no
       ttLayout.num-tam-campo:visible in browse brLayout  = yes
       fiDelimitador:sensitive in frame fpage2            = yes
       ttLayout.num-pos-inicial:label in browse brLayout  = trim(return-value).
{utp/ut-liter.i Importar_? }
assign ttLayout.num-tam-campo:label in browse brLayout    = trim(return-value).

disp rstipo with frame fPage2.
/** Seleá∆o **/
{utp/ut-liter.i "Empresa"}
assign fiEmpIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
assign fiEqptoIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Placa"}
assign fiPlacaIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Data"}
assign fiDataIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i Tipo_Layout }
assign fiTexto1 = trim(return-value).
{utp/ut-liter.i Tipo_Importaá∆o }
assign fiTexto2 = trim(return-value).
{utp/ut-liter.i Unidade_Neg¢cio }
assign fiUnidNegocIni:label in frame fPage3 = trim(return-value).

disp fiTexto1
     fiTexto2 with frame fPage2.

/** ParÉmetros **/
{utp/ut-liter.i "Editar Arquivo"}
assign bt-edit:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Arquivo Entrada"}
assign text-entrada = trim(return-value).
{utp/ut-liter.i Assume_valores_padr‰es_quando_informaá‰es_estiverem_incorretas * }
assign tbValPadr:label in frame fPage4 = trim(return-value).

{utp/ut-liter.i "Importa Por"}
assign fiTexto3 = trim(return-value).

display text-entrada  fiTexto3 with frame fPage4.
assign rsImport:sensitive in frame fPage4 =  no
       ep-prin:sensitive in frame fPage4  =  no.
/** LOG **/
assign rsAll = 2. /** Somente Rejeitados **/
display rsAll with frame fPage7.

/** Corrigi o campo Codigo Unidade Negocio. **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    RUN piAcertaNom-campo IN hDBOLayout.
&ENDIF

run pi-atualiza-browse in this-procedure (input yes).

/** Abre a Query do Browse **/
case input frame fpage2 rsLayout:
     WHEN 1 THEN DO:
         IF  rsTipo = 1 THEN
             ASSIGN c-programa = "AB0705-G":U.
         ELSE
             ASSIGN c-programa = "AB0705G2":U.
     END.
     WHEN 2 THEN DO:
         IF  rsTipo = 1 THEN
             ASSIGN c-programa = "AB0705-C":U.
         ELSE
             ASSIGN c-programa = "AB0705C2":U.
     END.
     WHEN 3 THEN DO:
         IF  rsTipo = 1 THEN
             ASSIGN c-programa = "AB0705-O":U.
         ELSE
             ASSIGN c-programa = "AB0705O2":U.
     END.
     WHEN 4 THEN DO:
         ASSIGN c-programa = "AB0705CO2":U.
     END.
 END CASE.

IF NOT CAN-FIND(FIRST ttLayout
                where ttLayout.cod-prog-import = c-programa ) then do:
    run createDefaultAB0705 in hDBOLayout (input frame fpage2 rsLayout,  
                                           input frame fpage2 rsTipo).   
    run pi-atualiza-browse in this-procedure (input yes).
END.

ASSIGN fiDataIni:SCREEN-VALUE IN FRAME fPage3 = STRING(TODAY - 7)
       fidatafim:SCREEN-VALUE IN FRAME fPage3 = STRING(TODAY).

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage3 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage3 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage3 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage3 = l-usa-unid-negoc
       IMAGE-9:VISIBLE          IN FRAME fPage3 = l-usa-unid-negoc
       IMAGE-10:VISIBLE         IN FRAME fPage3 = l-usa-unid-negoc.

IF l-usa-unid-negoc THEN DO:
    ASSIGN fiUnidNegocFim:SCREEN-VALUE IN FRAME fPage3 = fiUnidNegocFim.
END.

run setFolder in hFolder (input 3).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
/*:T--- Verifica se o DBO j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOLayout) OR
   hDBOLayout:TYPE <> "PROCEDURE":U OR
   hDBOLayout:FILE-NAME <> "frbo/bofr089.p":U THEN DO:
    run frbo/bofr089.p persistent set hDBOLayout.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse wReport 
PROCEDURE pi-atualiza-browse :
/*------------------------------------------------------------------------------
  Purpose:    pi-atualiza-browse
  Parameters: entrada pBrowse yes = Atualiza browse
                              no  = cria temp-table auxilia
  Notes:      Atualiza os dados da temp-table de layout para mostrar na tela  
------------------------------------------------------------------------------*/
define input parameter pBrowse as logical no-undo.
/** Roda as restriá‰es na BO **/
case input frame fPage2 rsLayout:
    when 1 then do:
            IF  rsTipo = 1 THEN
                run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                         input "mab-abastec-lubrific":U,
                                                         input "AB0705-G":U).
            ELSE
                run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                         input "mab-abastec-lubrific":U,
                                                         input "AB0705G2":U).
    end.
    when 2 then do:
        IF  rsTipo = 1 THEN
            run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                     input "mab-abastec-lubrific":U,
                                                     input "AB0705-C":U).
        ELSE
            run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                     input "mab-abastec-lubrific":U,
                                                     input "AB0705C2":U).
    end.
    when 3 then do:
        IF  rsTipo = 1 THEN
            run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                     input "mab-abastec-lubrific":U,
                                                     input "AB0705-O":U).
        ELSE
            run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                     input "mab-abastec-lubrific":U,
                                                     input "AB0705O2":U).
    end.
    when 4 then do:
        run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                                 input "mab-abastec-lubrific":U,
                                                 input "AB0705CO2":U).
    end.
end case.

/** Abre a query com as restriá‰es **/
run openQueryStatic in hDBOLayout (input "Programa":U).

if pBrowse then do:
    /** TempTable para o browse **/
    run getBatchRecords in hDBOLayout (input  ?,
                                       input  no,
                                       input  999,
                                       output i-rows,
                                       output table ttLayout).

    if can-find (first ttLayout) then do:
        {&OPEN-QUERY-{&BROWSE-NAME}}
    end.
end.
else
    /** TempTable para validaá‰es **/
    run getBatchRecords in hDBOLayout (input  ?,
                                       input  no,
                                       input  99,
                                       output i-rows,
                                       output table ttLayoutAux).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bkp wReport 
PROCEDURE pi-bkp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-log-mes AS LOGICAL NO-UNDO.

define buffer   b-ttLayout for ttLayout.
define variable i-posicao  as integer no-undo.
define variable i-tamanho  as integer no-undo.

/** Limpa a temp-table de erros **/
EMPTY TEMP-TABLE RowErrors.

ASSIGN i-sequencia = 0.

/** Verifica registros do layout **/
for each ttLayout no-lock break by ttLayout.num-pos-inicial :
    /** Procura pela posiá∆o no layout de importaá∆o **/ 
    run findPosicao in hDBOLayout (input  ttLayout.cod-prog-import,
                                   input  ttLayout.nom-bd,
                                   input  ttLayout.nom-tabela,
                                   input  ttLayout.num-seq,
                                   output i-posicao).
       case input frame fPage2 rsLayout:
           when 1 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705A":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                            /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705B":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
           end.

           when 2 then do:
             if input frame fPage2 rsTipo = 1 then
                 /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705C":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
               run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705D":U,
                                                INPUT  ttLayout.num-seq,
                                                OUTPUT i-tamanho).
           end.

           when 3 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705E":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
            else
                 /** Retorna tamanho m†ximo do campo **/
                  run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705F":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
           end.

           when 4 then do:
              /** Retorna tamanho m†ximo do campo **/
              run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705G":U,
                                                 INPUT  ttLayout.num-seq,
                                                 OUTPUT i-tamanho).
           end.
       end case.
    /** Verifica se posiá∆o inicial Ç menor que 0 para obrigat¢rios **/
    if  ttLayout.num-pos-inicial <= 0 AND ttLayout.log-mandatorio THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se posiá∆o inicial Ç menor que 0 para n∆o obrigat¢rios **/
    if  ttLayout.num-pos-inicial < 0 AND not(ttLayout.log-mandatorio) THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se Ç mandat¢rio **/
    IF ttLayout.log-mandatorio THEN DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo <= 0 OR 
           ttLayout.num-tam-campo > i-tamanho then do:
            RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
        /** Verifica se h† posiá‰es duplicadas **/
        if can-find(FIRST b-ttLayout where 
                          b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial and
                          b-ttLayout.num-pos-final  >= ttLayout.num-pos-inicial and 
                          rowid(b-ttLayout) <> rowid(ttLayout)) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        /** Verifica se h† posiá‰es duplicadas **/
        if can-find(FIRST b-ttLayout 
                          where b-ttLayout.num-pos-inicial = ttLayout.num-pos-inicial 
                          and rowid(b-ttLayout) <> rowid(ttLayout)) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        end.
        if input frame fpage2 rsTipo = 2 then do:
             for last bfttLayout
                 WHERE  bfttLayout.num-pos-final   <  ttLayout.num-pos-inicial
                 and    bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                 and    bfttLayout.nom-bd          = ttLayout.nom-bd 
                 and    bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                 and    bfttLayout.num-pos-inicial <> 0 no-lock:
             end.
             if avail bfttLayout  then do:
                    if bfttLayout.num-pos-inicial = 0 then do:
                       for last bfttLayout2
                            WHERE  bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial
                            and    bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                            and    bfttLayout2.nom-bd          = ttLayout.nom-bd 
                            and    bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                            and    bfttLayout2.num-pos-inicial <> 0 no-lock:
                        end.
                        if avail bfttLayout2 then do:
                             assign i-posicao-ini = bfttLayout2.num-tam-campo + bfttLayout2.num-pos-final.
                             assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                                    ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                        end.
                        else do:
                            assign i-posicao-ini                                            = bfttLayout.num-pos-inicial + ttLayout.num-tam-campo
                                   ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                                   ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                        end.
                    end.
                    else do:
                       assign  i-posicao-ini = bfttLayout.num-pos-final + 1.
                       for first bfttLayout2
                            where bfttLayout2.num-pos-inicial = i-posicao-ini
                            and   bfttLayout2.num-pos-inicial < ttLayout.num-pos-inicial no-lock:
                            assign i-posicao-ini = ttLayout.num-pos-inicial.
                       end.
                       assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                              ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                    end.
               end.
               else do:
                   /** Atualiza posiá∆o inicial **/
                    if ttLayout.num-pos-inicial > 1  then
                       assign i-posicao-ini = 1.
                    else
                      assign i-posicao-ini = ttLayout.num-pos-inicial.
                  assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                         ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
               end.
                 /** Atualiza posiá∆o final **/
                 assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial, ttLayout.num-tam-campo)
                        ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final). 
        end.
        else do:
           for last bfttLayout
                    WHERE  bfttLayout.num-seq           < ttLayout.num-seq
                    and    bfttLayout.cod-prog-import   = ttLayout.cod-prog-import 
                    and    bfttLayout.nom-bd            = ttLayout.nom-bd 
                    and    bfttLayout.nom-tabela        = ttLayout.nom-tabela no-lock:
           end.
           if avail bfttLayout  then do:
                if bfttLayout.num-pos-inicial = 0 then do:
                   for last bfttLayout2
                        WHERE  bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial 
                        and    bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                        and    bfttLayout2.nom-bd          = ttLayout.nom-bd 
                        and    bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                        and    bfttLayout2.num-tam-campo   <> 0 no-lock:
                    end.
                    if avail bfttLayout2 then do:
                        assign i-posicao-ini = bfttLayout2.num-pos-final + 1.
                    end.
                     else 
                        assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                end.
                else
                    assign i-posicao-ini            = (bfttLayout.num-pos-inicial  + bfttLayout.num-tam-campo).
           end.
           else do:
               assign i-posicao-ini = ttLayout.num-pos-inicial.
           end.
            /** Atualiza posiá∆o final **/
            assign ttLayout.num-pos-inicial                                 = i-posicao-ini 
                   ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial)
                   ttLayout.num-pos-final                                   = f-tamanho(i-posicao-ini,
                                                                                      ttLayout.num-tam-campo)
                   ttLayout.num-pos-final:screen-value in browse brLayout   = string(ttLayout.num-pos-final).
        end.
    END.
    ELSE DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo < 0 OR 
           ttLayout.num-tam-campo > i-tamanho then do:
           RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
        /** Verifica se h† posiá‰es duplicadas sem contar as com 0 **/
        if can-find(FIRST b-ttLayout where 
                          b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial and
                          b-ttLayout.num-pos-final  >= ttLayout.num-pos-inicial and 
                          rowid(b-ttLayout) <> rowid(ttLayout))    and
                          (ttLayout.num-tam-campo <> 0) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        /** Verifica se h† posiá‰es duplicadas **/
        if can-find(FIRST b-ttLayout
                          where b-ttLayout.num-pos-inicial = ttLayout.num-pos-inicial 
                          and rowid(b-ttLayout) <> rowid(ttLayout)) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        end.
         /** Verifica se tamanho Ç igual a zero **/
        IF ttLayout.num-tam-campo = 0 then do:
            /** Zera as posiá‰es **/
            ASSIGN ttLayout.num-pos-final                                   = 0
                   ttLayout.num-pos-inicial                                 = 0
                   ttLayout.num-pos-final:screen-value in browse brLayout   = string(0)
                   ttLayout.num-pos-inicial:screen-value in browse brLayout = string(0).

        end.
        else do:
            if input frame fpage2 rsTipo = 2 then do:
                 for last bfttLayout
                     WHERE  bfttLayout.num-pos-final   <  ttLayout.num-pos-inicial
                     and    bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                     and    bfttLayout.nom-bd          = ttLayout.nom-bd 
                     and    bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                     and    bfttLayout.num-pos-inicial <> 0 no-lock:
                 end.
                 if avail bfttLayout  then do:
                        if bfttLayout.num-pos-inicial = 0 then do:
                           for last bfttLayout2
                                WHERE  bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial
                                and    bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                                and    bfttLayout2.nom-bd          = ttLayout.nom-bd 
                                and    bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                                and    bfttLayout2.num-pos-inicial <> 0 no-lock:
                            end.
                            if avail bfttLayout2 then do:
                                 assign i-posicao-ini = bfttLayout2.num-tam-campo + bfttLayout2.num-pos-final.
                                 assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                                        ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                            end.
                            else do:
                                assign i-posicao-ini                                            = bfttLayout.num-pos-inicial + ttLayout.num-tam-campo
                                       ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                                       ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                            end.
                        end.
                        else do:
                           assign  i-posicao-ini = bfttLayout.num-pos-final + 1.
                           for first bfttLayout2
                                where bfttLayout2.num-pos-inicial = i-posicao-ini
                                and   bfttLayout2.num-pos-inicial < ttLayout.num-pos-inicial no-lock:
                                assign i-posicao-ini = ttLayout.num-pos-inicial.
                           end.
                           assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                                  ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                        end.
                   end.
                   else do:
                       /** Atualiza posiá∆o inicial **/
                        if ttLayout.num-pos-inicial > 1  then
                           assign i-posicao-ini = 1.
                        else
                          assign i-posicao-ini = ttLayout.num-pos-inicial.

                      assign ttLayout.num-pos-inicial                                 = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo)
                             ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial).
                   end.
                     /** Atualiza posiá∆o final **/

                     assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial, ttLayout.num-tam-campo)
                            ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final). 
            end.
            else do:
               for last bfttLayout
                        WHERE  bfttLayout.num-seq           < ttLayout.num-seq
                        and    bfttLayout.cod-prog-import   = ttLayout.cod-prog-import 
                        and    bfttLayout.nom-bd            = ttLayout.nom-bd 
                        and    bfttLayout.nom-tabela        = ttLayout.nom-tabela no-lock:
               end.
               if avail bfttLayout  then do:
                    if bfttLayout.num-pos-inicial = 0 then do:
                       for last bfttLayout2
                            WHERE  bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial 
                            and    bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                            and    bfttLayout2.nom-bd          = ttLayout.nom-bd 
                            and    bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                            and    bfttLayout2.num-tam-campo   <> 0 no-lock:
                        end.
                        if avail bfttLayout2 then do:
                            assign i-posicao-ini = bfttLayout2.num-pos-final + 1.
                        end.
                         else 
                            assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                    end.
                    else
                        assign i-posicao-ini            = (bfttLayout.num-pos-inicial  + bfttLayout.num-tam-campo).

               end.
               else do:
                   assign i-posicao-ini = ttLayout.num-pos-inicial.
               end.

                /** Atualiza posiá∆o final **/
                assign ttLayout.num-pos-inicial                                 = i-posicao-ini 
                       ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial)
                       ttLayout.num-pos-final                                   = f-tamanho(i-posicao-ini,
                                                                                          ttLayout.num-tam-campo)
                       ttLayout.num-pos-final:screen-value in browse brLayout   = string(ttLayout.num-pos-final).
            end.

        end. /** do else **/
    END.

end.

/** Mostra tabela de erros **/
IF CAN-FIND(FIRST RowErrors) THEN DO:
    {method/showmessage.i1}
    {method/showmessage.i2 &Modal="YES"}
    EMPTY TEMP-TABLE RowErrors.
    RETURN "NOK":U.
END.
ELSE
    /** Mostra mensagem sem erros **/
    IF p-log-mes THEN
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 27516,
                           INPUT '').

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print-layout wReport 
PROCEDURE pi-print-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-print-layout
  Parameters:  <none>
  Notes:       Editar/Imprimir o arquivo do layout (dados do browse).
------------------------------------------------------------------------------*/
                                                        /** Forms and Frames **/
define variable c-campo as character                 no-undo.

define variable iSeq    as integer format ">999":U     no-undo.
define variable iTamanh as integer format ">>>>999":U  no-undo.
define variable iInicio as integer format ">>>>>999":U no-undo.
define variable iTermin as integer format ">>>>999":U  no-undo.
define variable cDad    as character format "x(10)":U  no-undo.
define variable deCampo as integer format ">>>>>>9":U  no-undo.
define variable lMand   like ttLayout.log-mandatorio   no-undo.

assign c-arq-layout = session:temp-directory + "layoutAB0705.tmp"
       c-programa   = "AB/0705"
       c-versao     = "2.00"
       c-revisao    = ".00.000".    

for first param-global fields(grupo) no-lock:
    assign c-empresa = param-global.grupo.
end.
{utp/ut-liter.i "Abastecimento"}    
assign c-sistema = trim(return-value).
{utp/ut-liter.i "Layout Importaá∆o Abastecimentos" * R}
assign c-titulo-relat = trim(return-value).
if input frame fPage2 rsTipo = 1 then do:
    form "|" ttLayout.num-seq     format ">999":U      "|"
         c-campo                  format "x(60)":U     "|"
         ttLayout.num-tam-campo   format ">>>>999":U   "|"
         ttLayout.num-pos-inicial format ">>>>>999":U  "|"
         ttLayout.num-pos-final   format ">>>>999":U   "|"
         ttLayout.cod-tip-dado    format "x(10)":U     "|"
         ttLayout.qti-casas-dec   format ">>>>>>9":U   "|"
         ttLayout.log-mandatorio                      " |"
         SKIP
         "|----------------------------------------------------------------------------------------------------------------------------------|"
        with width 132 no-attr-space no-box no-label down frame f-layout stream-io.

    form "|" iSeq                  "|"
         c-campo  format "x(60)":U "|"
         iTamanh                   "|"  
         iInicio                   "|"
         iTermin                   "|"  
         cDad                      "|"
         deCampo                   "|"
         lMand                     "|"
         "|----------------------------------------------------------------------------------------------------------------------------------|"
        with width 132 no-attr-space no-box down frame f-main stream-io.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-main:HANDLE).
    

    /*----------------------------------------------------------------------------*/
                                                                      /** Labels **/
    {utp/ut-liter.i "Sim/N∆o"}
    assign lMand:format in frame f-main = trim(return-value).
    {utp/ut-liter.i "Seq."}
    assign iSeq:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "Descriá∆o"}
    assign c-campo:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "TÇrmino"}
    assign iTermin:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "Tipo"}
    assign cDad:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "Obr."}
    assign lMand:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "Decimal"}
    assign deCampo:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "Tamanho"}
    assign iTamanh:label in frame f-main = trim(return-value).
    {utp/ut-liter.i "In°cio"}
    assign iInicio:label in frame f-main = trim(return-value).

end.
else do:
    form "|" ttLayout.num-seq     format ">999":U      "|"
         c-campo                  format "x(60)":U     "|"
         ttLayout.num-tam-campo   format ">>>>999":U   "|"
         ttLayout.num-pos-inicial format ">>>>>999":U  "|"
         ttLayout.cod-tip-dado    format "x(10)":U     "|"
         ttLayout.qti-casas-dec   format ">>>>>>9":U   "|"
         ttLayout.log-mandatorio                      " |"
         SKIP
         "|------------------------------------------------------------------------------------------------------------------------|"
        with width 132 no-attr-space no-box no-label down frame f-layout-2 stream-io.

    form "|" iSeq                  "|"
         c-campo  format "x(60)":U "|"
         iTamanh                   "|"  
         iInicio                   "|"
         cDad                      "|"
         deCampo                   "|"
         lMand                     "|"
         "|------------------------------------------------------------------------------------------------------------------------|"
        with width 132 no-attr-space no-box down frame f-main-2 stream-io.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-main-2:HANDLE).
    

    /*----------------------------------------------------------------------------*/
                                                                      /** Labels **/
    {utp/ut-liter.i "Sim/N∆o"}
    assign lMand:format in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Seq."}
    assign iSeq:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Descriá∆o"}
    assign c-campo:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Tipo"}
    assign cDad:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Obr."}
    assign lMand:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Decimal"}
    assign deCampo:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Importar_?"}
    assign iTamanh:label in frame f-main-2 = trim(return-value).
    {utp/ut-liter.i "Posiá∆o"}
    assign iInicio:label in frame f-main-2 = trim(return-value).

end.

/*----------------------------------------------------------------------------*/
                                                          /** Output Display **/
output to value(c-arq-layout) paged page-size 64 convert target "iso8859-1":U.

view frame f-cabec.
if input frame fPage2 rsTipo = 1 then do:
    for each ttLayout
        break by ttLayout.num-pos-inicial:
        assign c-campo = f-campo(ttLayout.nom-campo) + "  (" + ttLayout.nom-campo + ")".
       if ttLayout.num-pos-inicial = 0 then do:
           display ttLayout.num-seq         @ iSeq
                  c-campo
                  ttLayout.num-tam-campo   @ iTamanh  
                  ttLayout.num-pos-inicial @ iInicio  
                  ttLayout.num-pos-final   @ iTermin  
                  ttLayout.cod-tip-dado    @ cDad  
                  ttLayout.qti-casas-dec   @ deCampo
                  ttLayout.log-mandatorio  @ lMand 
                with frame f-main.
           down with frame f-main.
         end.
         else do:
          if ttLayout.num-seq = 1 then do:
                        display ttLayout.num-seq         @ iSeq
                                c-campo
                                ttLayout.num-tam-campo   @ iTamanh  
                                ttLayout.num-pos-inicial @ iInicio  
                                ttLayout.num-pos-final   @ iTermin  
                                ttLayout.cod-tip-dado    @ cDad  
                                ttLayout.qti-casas-dec   @ deCampo
                                ttLayout.log-mandatorio  @ lMand 
                              with frame f-main.
                        down with frame f-main.
                    end.
                    else do:
                        display ttLayout.num-seq     
                                c-campo
                                ttLayout.num-tam-campo
                                ttLayout.num-pos-inicial
                                ttLayout.num-pos-final
                                ttLayout.cod-tip-dado
                                ttLayout.qti-casas-dec
                                ttLayout.log-mandatorio
                              with frame f-layout.
                        down with frame f-layout.
                    end.
                  end.
         end.
end.
else do:
    for each ttLayout
        break by ttLayout.num-pos-inicial:
        assign c-campo = f-campo(ttLayout.nom-campo) + "  (" + ttLayout.nom-campo + ")".
       if ttLayout.num-pos-inicial = 0 then do:
           display ttLayout.num-seq         @ iSeq
                  c-campo
                  ttLayout.num-tam-campo   @ iTamanh  
                  ttLayout.num-pos-inicial @ iInicio  
                  ttLayout.cod-tip-dado    @ cDad  
                  ttLayout.qti-casas-dec   @ deCampo
                  ttLayout.log-mandatorio  @ lMand 
                with frame f-main-2.
           down with frame f-main-2.
         end.
         else do:
          if ttLayout.num-seq = 1 then do:
                        display ttLayout.num-seq         @ iSeq
                                c-campo
                                ttLayout.num-tam-campo   @ iTamanh  
                                ttLayout.num-pos-inicial @ iInicio  
                                ttLayout.cod-tip-dado    @ cDad  
                                ttLayout.qti-casas-dec   @ deCampo
                                ttLayout.log-mandatorio  @ lMand 
                              with frame f-main-2.
                        down with frame f-main-2.
                    end.
                    else do:
                        display ttLayout.num-seq     
                                c-campo
                                ttLayout.num-tam-campo
                                ttLayout.num-pos-inicial
                                ttLayout.cod-tip-dado
                                ttLayout.qti-casas-dec
                                ttLayout.log-mandatorio
                              with frame f-layout-2.
                        down with frame f-layout-2.
                    end.
                  end.
         end.
end.
view frame f-rodape.
output close.

/*----------------------------------------------------------------------------*/
                                                        /** Visualizar Dados **/
{report/imtrm.i c-arq-layout 3}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-layout wReport 
PROCEDURE pi-update-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-update-layout
  Parameters:  <none>
  Notes:       Verifica se h† alteraá‰es na ttLayout e atualiza a base
------------------------------------------------------------------------------*/
define variable c-atualiza as character no-undo.
define variable l-atualiza as logical   no-undo.


/* Gera buffer da layout-import */
run pi-atualiza-browse in this-procedure (input no).

bloco_a:
/** Verifica se a Tabela Original foi modificada **/
for each ttLayout no-lock:
    IF CAN-FIND(first  ttLayoutAux
                where (ttLayoutAux.cod-prog-import  = ttLayout.cod-prog-import 
                and    ttLayoutAux.nom-bd           = ttLayout.nom-bd          
                and    ttLayoutAux.nom-tabela       = ttLayout.nom-tabela         
                and    ttLayoutAux.num-seq          = ttLayout.num-seq)     
                and   (ttLayoutAux.num-pos-inicial <> ttLayout.num-pos-inicial       
                or     ttLayoutAux.num-tam-campo   <> ttLayout.num-tam-campo) no-lock) THEN DO:
        assign l-atualiza = yes.
        LEAVE bloco_a.
    END.
END.
/** Se foi modificada pergunta se deseja modifica-la **/
if l-atualiza then do:
    run utp/ut-msgs.p (input "SHOW":U,
                       input 27248,
                       input "":U).
    assign c-atualiza = return-value.
    /** Atualiza os dados de tela em tabela **/
    if c-atualiza = "YES":U then do:
        case input frame fPage2 rsLayout:
            /* GoodCard */
            when 1 then do:
                /* Padr∆o */
                IF INPUT FRAME fPage2 rsTipo = 1 THEN DO:
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705-G":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
                END.
                /* Delimitador */
                ELSE DO:
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705G2":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
                END.
            END.
            /* CTF */
            when 2 then do:
                /* Padr∆o */
                IF INPUT FRAME fPage2 rsTipo = 1 THEN DO:
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705-C":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
                END.
                /* Delimitador */
                ELSE DO:
                    RUN piValidaPosicao IN THIS-PROCEDURE.

                    IF posicaoInvalida = NO THEN
                        run createLayout in hDBOLayout (input table ttLayout,
                                                        input "AB0705C2":U,
                                                        input "movfro":U,
                                                        input "mab-abastec-lubrific":U).
                END.
            END.
            /* Outros */
            when 3 then do:
                /* Padr∆o */
                IF INPUT FRAME fPage2 rsTipo = 1 THEN DO:
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705-O":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
                END.
                /* Delimitador */
                ELSE DO:
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705O2":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
                END.
            END.
            /* Copec */
            when 4 then do:
                /* Delimitador */
                    run createLayout in hDBOLayout (input table ttLayout,
                                                    input "AB0705CO2":U,
                                                    input "movfro":U,
                                                    input "mab-abastec-lubrific":U).
            END.
        end case.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-browse wReport 
PROCEDURE pi-validate-browse :
/*------------------------------------------------------------------------------
  Purpose:     pi-validate-browse
  Parameters:  <none>
  Notes:       Valida se os dados n∆o est∆o sobrepostos 
------------------------------------------------------------------------------*/
define variable i-tamanho as integer no-undo.
define variable i-posicao as integer no-undo.

/** Cria tabela tempor†ria auxiliar para comparaá∆o **/
RUN pi-atualiza-browse IN THIS-PROCEDURE (INPUT NO).

FIND CURRENT ttLayout no-lock NO-ERROR.

ASSIGN ttLayout.num-tam-campo   = integer(ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout)
       ttLayout.num-pos-inicial = integer(ttLayout.num-pos-inicial:SCREEN-VALUE IN BROWSE brLayout)
       ttLayout.num-pos-final   = integer(ttLayout.num-pos-final:SCREEN-VALUE  IN BROWSE brLayout).

FOR FIRST ttLayoutAux FIELDS(tamanho) 
    WHERE ttLayoutAux.num-seq         = ttLayout.num-seq 
    and   ttLayoutAux.cod-prog-import = ttLayout.cod-prog-import 
    and   ttLayoutAux.nom-bd          = ttLayout.nom-bd 
    and   ttLayoutAux.nom-tabela      = ttLayout.nom-tabela no-lock:

    case input frame fPage2 rsLayout:
           when 1 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705A":U,
                                                    INPUT  ttLayout.num-seq,
                                                    OUTPUT i-tamanho).
            else
                            /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705B":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
           end.

           when 2 then do:
             if input frame fPage2 rsTipo = 1 then
                 /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705C":U,
                                                    INPUT  ttLayout.num-seq,
                                                    OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
               run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705D":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
           end.

           when 3 then do:
             if input frame fPage2 rsTipo = 1 then
                  /** Retorna tamanho m†ximo do campo **/
                 run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705E":U,
                                                    INPUT  ttLayout.num-seq,
                                                    OUTPUT i-tamanho).
            else
                 /** Retorna tamanho m†ximo do campo **/
                  run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705F":U,
                                                     INPUT  ttLayout.num-seq,
                                                     OUTPUT i-tamanho).
           end.
           when 4 then do:
               /** Retorna tamanho m†ximo do campo **/
               run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705G":U,
                                                  INPUT  ttLayout.num-seq,
                                                  OUTPUT i-tamanho).
           end.


       end case.
    /** Verifica se campo Ç mandat¢rio **/
   /** Verifica se campo Ç mandat¢rio **/
    IF ttLayout.log-mandatorio THEN DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo <= 0 OR ttLayout.num-tam-campo > i-tamanho THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 27515,
                               INPUT i-tamanho).
            ASSIGN ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout = STRING(i-tamanho).
            APPLY 'entry':U TO ttLayout.num-tam-campo IN BROWSE brLayout.
            RETURN "NOK":U.
        END.
        ELSE
            /** Atualiza campo de posiá∆o final **/
            assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial, 
                                                                                      ttLayout.num-tam-campo)
                   ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final).
    END.
    ELSE
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo < 0 OR ttLayout.num-tam-campo > i-tamanho THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 27515,
                               INPUT i-tamanho).
            ASSIGN ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout = STRING(i-tamanho).
            APPLY 'entry':U TO ttLayout.num-tam-campo IN BROWSE brLayout.
            RETURN "NOK":U.
        END.
        ELSE DO:
            /** Verifica se tamanho Ç igual a zero **/
            IF ttLayout.num-tam-campo = 0 THEN
                /** Zera as posiá‰es **/
                ASSIGN ttLayout.num-pos-final                                   = 0
                       ttLayout.num-pos-inicial                                 = 0
                       ttLayout.num-pos-final:screen-value in browse brLayout   = string(0)
                       ttLayout.num-pos-inicial:screen-value in browse brLayout = string(0).
            ELSE
                /** Atualiza posiá∆o final **/
                assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial,
                                                                                          ttLayout.num-tam-campo)
                       ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final).
        END.


END.



RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-layout wReport 
PROCEDURE pi-validate-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-validate-layout
  Parameters:  <none>
  Notes:       Valida a temp-table ttLayout
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-log-mes AS LOGICAL NO-UNDO.

define buffer   b-ttLayout   for ttLayout.
define variable i-posicao    as integer no-undo.
define variable i-tamanho    as integer no-undo.
define variable i-pos-atual  as integer no-undo.

/** Limpa a temp-table de erros **/
EMPTY TEMP-TABLE RowErrors.

ASSIGN i-sequencia = 0.

/** Verifica registros do layout **/
for each ttLayout EXCLUSIVE-LOCK
    break by ttLayout.num-pos-inicial:

    /** Procura pela posiá∆o no layout de importaá∆o **/ 
    run findPosicao in hDBOLayout (input  ttLayout.cod-prog-import,
                                   input  ttLayout.nom-bd,
                                   input  ttLayout.nom-tabela,
                                   input  ttLayout.num-seq,
                                   output i-posicao).

    case input frame fPage2 rsLayout:
        when 1 then do:
            if input frame fPage2 rsTipo = 1 then
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705A":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705B":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
        END.
        when 2 then do:
            if input frame fPage2 rsTipo = 1 then
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705C":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705D":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
        END.
        when 3 then do:
            if input frame fPage2 rsTipo = 1 then
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705E":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
            else
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705F":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
        END.
        when 4 then do:
                /** Retorna tamanho m†ximo do campo **/
                run ValidaTamanho-2 in hDBOLayout (INPUT  "AB0705G":U,
                                                   INPUT  ttLayout.num-seq,
                                                   OUTPUT i-tamanho).
        END.
    end case.

    /** Verifica se posiá∆o inicial Ç menor que 0 para obrigat¢rios **/
    if ttLayout.num-pos-inicial <= 0 AND ttLayout.log-mandatorio THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se posiá∆o inicial Ç menor que 0 para n∆o obrigat¢rios **/
    if ttLayout.num-pos-inicial < 0 AND not(ttLayout.log-mandatorio) THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se Ç mandat¢rio **/
    IF ttLayout.log-mandatorio THEN DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo <= 0 OR 
           ttLayout.num-tam-campo > i-tamanho then do:
            RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
            /** Verifica se h† posiá‰es duplicadas **/
            if can-find(FIRST b-ttLayout
                        where b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial
                        AND   b-ttLayout.num-pos-final   >= ttLayout.num-pos-inicial
                        and   rowid(b-ttLayout)          <> rowid(ttLayout)) THEN
                run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
            /** Verifica se h† posiá‰es duplicadas **/
            if can-find(FIRST b-ttLayout 
                        where b-ttLayout.num-pos-inicial = ttLayout.num-pos-inicial 
                        and rowid(b-ttLayout) <> rowid(ttLayout)) THEN
                run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        END.
        if input frame fpage2 rsTipo = 2 then do:
            for last  bfttLayout
                WHERE bfttLayout.num-pos-final   < ttLayout.num-pos-inicial
                and   bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                and   bfttLayout.nom-bd          = ttLayout.nom-bd 
                and   bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                and   bfttLayout.num-pos-inicial <> 0 no-lock:
            END.
            if avail bfttLayout then do:
                if bfttLayout.num-pos-inicial = 0 then do:
                    for last  bfttLayout2
                        WHERE bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial
                        and   bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                        and   bfttLayout2.nom-bd          = ttLayout.nom-bd 
                        and   bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                        and   bfttLayout2.num-pos-inicial <> 0 no-lock:
                    END.
                    if avail bfttLayout2 then do:
                        assign i-posicao-ini            = bfttLayout2.num-tam-campo + bfttLayout2.num-pos-final.
                        assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                    END.
                    else do:
                        assign i-posicao-ini            = bfttLayout.num-pos-inicial + ttLayout.num-tam-campo
                               ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                    END.
                END.
                else do:
                    assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                    for first bfttLayout2
                        where bfttLayout2.num-pos-inicial = i-posicao-ini
                        and   bfttLayout2.num-pos-inicial < ttLayout.num-pos-inicial no-lock:
                        assign i-posicao-ini = ttLayout.num-pos-inicial.
                    END.
                    IF INPUT FRAME fPage2 rsLayout <> 3 AND INPUT FRAME fPage2 rsTipo <> 2 THEN DO:
                        assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                    END.
                END.
            END.
            else do:
                /** Atualiza posiá∆o inicial **/
                if ttLayout.num-pos-inicial > 1 then
                    assign i-posicao-ini = 1.
                else
                    assign i-posicao-ini = ttLayout.num-pos-inicial.
                IF INPUT FRAME fPage2 rsLayout <> 3 AND INPUT FRAME fPage2 rsTipo <> 2 THEN DO:
                    assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                END.
            END.
            /** Atualiza posiá∆o final **/
            assign ttLayout.num-pos-final = f-tamanho(ttLayout.num-pos-inicial, ttLayout.num-tam-campo).
        END.
        else do:
            for last  bfttLayout
                WHERE bfttLayout.num-pos-final   < ttLayout.num-pos-inicial
                and   bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                and   bfttLayout.nom-bd          = ttLayout.nom-bd 
                and   bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                and   bfttLayout.num-pos-inicial <> 0 no-lock:
            END.
            if avail bfttLayout  then do:
                if bfttLayout.num-pos-inicial = 0 then do:
                    for last  bfttLayout2
                        WHERE bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial 
                        and   bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                        and   bfttLayout2.nom-bd          = ttLayout.nom-bd 
                        and   bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                        and   bfttLayout2.num-tam-campo   <> 0 no-lock:
                    END.
                    if avail bfttLayout2 then do:
                        assign i-posicao-ini = bfttLayout2.num-pos-final + 1.
                    END.
                    else 
                        assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                END.
                else
                    assign i-posicao-ini = (bfttLayout.num-pos-inicial  + bfttLayout.num-tam-campo).
            END.
            else do:
                assign i-posicao-ini = ttLayout.num-pos-inicial.
            END.
            /* COMENTADO POR KSM35590 PARA CORRIGIR QUANDO O LAYOUT FOR POR PADR«O, SEM DELIMITADOR
            /** Atualiza posiá∆o final **/
            assign ttLayout.num-pos-inicial = i-posicao-ini
                   ttLayout.num-pos-final   = f-tamanho(i-posicao-ini,ttLayout.num-tam-campo).*/
        END.
    END.
    ELSE DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo < 0 OR 
           ttLayout.num-tam-campo > i-tamanho then do:
            RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
            /** Verifica se h† posiá‰es duplicadas sem contar as com 0 **/
            if can-find(FIRST b-ttLayout
                        WHERE b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial
                        AND   b-ttLayout.num-pos-final  >= ttLayout.num-pos-inicial
                        and   rowid(b-ttLayout) <> rowid(ttLayout))
                        AND   (ttLayout.num-tam-campo <> 0) THEN
                run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
            /** Verifica se h† posiá‰es duplicadas **/
            if can-find(FIRST b-ttLayout
                        where b-ttLayout.num-pos-inicial = ttLayout.num-pos-inicial 
                        and   rowid(b-ttLayout) <> rowid(ttLayout)) THEN
                run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
        END.
        /** Verifica se tamanho Ç igual a zero **/
        IF ttLayout.num-tam-campo = 0 then do:
            /** Zera as posiá‰es **/
            ASSIGN ttLayout.num-pos-final                                   = 0
                   ttLayout.num-pos-inicial                                 = 0
                   ttLayout.num-pos-final:screen-value in browse brLayout   = string(0)
                   ttLayout.num-pos-inicial:screen-value in browse brLayout = string(0).
        END.
        else do:
            if input frame fpage2 rsTipo = 2 then do:
                for last  bfttLayout
                    WHERE bfttLayout.num-pos-final   <  ttLayout.num-pos-inicial
                    and   bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                    and   bfttLayout.nom-bd          = ttLayout.nom-bd 
                    and   bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                    and   bfttLayout.num-pos-inicial <> 0 no-lock:
                END.
                if avail bfttLayout then do:
                    if bfttLayout.num-pos-inicial = 0 then do:
                        for last  bfttLayout2
                            WHERE bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial
                            and   bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                            and   bfttLayout2.nom-bd          = ttLayout.nom-bd 
                            and   bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                            and   bfttLayout2.num-pos-inicial <> 0 no-lock:
                        END.
                        if avail bfttLayout2 then do:
                            assign i-posicao-ini            = bfttLayout2.num-tam-campo + bfttLayout2.num-pos-final.
                            assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                        END.
                        else do:
                            assign i-posicao-ini            = bfttLayout.num-pos-inicial + ttLayout.num-tam-campo
                                   ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                        END.
                    END.
                    ELSE do:
                        assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                        for first bfttLayout2
                            where bfttLayout2.num-pos-inicial = i-posicao-ini
                            and   bfttLayout2.num-pos-inicial < ttLayout.num-pos-inicial no-lock:
                            assign i-posicao-ini = ttLayout.num-pos-inicial.
                        END.
                        IF INPUT FRAME fPage2 rsLayout <> 3 AND INPUT FRAME fPage2 rsTipo <> 2 THEN DO:
                            assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                        END.
                    END.
                END.
                else do:
                    /** Atualiza posiá∆o inicial **/
                    if ttLayout.num-pos-inicial > 1  then
                        assign i-posicao-ini = 1.
                    else
                        assign i-posicao-ini = ttLayout.num-pos-inicial.
                    assign ttLayout.num-pos-inicial = f-tamanho(i-posicao-ini, ttLayout.num-tam-campo).
                END.
                /** Atualiza posiá∆o final **/
                assign ttLayout.num-pos-final = f-tamanho(ttLayout.num-pos-inicial, ttLayout.num-tam-campo).
            END.
            else do:
                for last  bfttLayout
                    WHERE bfttLayout.num-pos-final   <  ttLayout.num-pos-inicial
                    and   bfttLayout.cod-prog-import = ttLayout.cod-prog-import 
                    and   bfttLayout.nom-bd          = ttLayout.nom-bd 
                    and   bfttLayout.nom-tabela      = ttLayout.nom-tabela 
                    and   bfttLayout.num-pos-inicial <> 0 NO-LOCK:
                END.
                if avail bfttLayout then do:
                    if bfttLayout.num-pos-inicial = 0 then do:
                        for last  bfttLayout2
                            WHERE bfttLayout2.num-pos-final   < bfttLayout.num-pos-inicial 
                            and   bfttLayout2.cod-prog-import = ttLayout.cod-prog-import 
                            and   bfttLayout2.nom-bd          = ttLayout.nom-bd 
                            and   bfttLayout2.nom-tabela      = ttLayout.nom-tabela 
                            and   bfttLayout2.num-tam-campo   <> 0 no-lock:
                        END.
                        if avail bfttLayout2 then do:
                            assign i-posicao-ini = bfttLayout2.num-pos-final + 1.
                        END.
                        else 
                            assign i-posicao-ini = bfttLayout.num-pos-final + 1.
                    END.
                    else
                        assign i-posicao-ini = (bfttLayout.num-pos-inicial + bfttLayout.num-tam-campo).
                END.
                else do:
                    assign i-posicao-ini = ttLayout.num-pos-inicial.
                END.
                /* Comentado por Herc°lio - KSM35590 - Para corrigir quando o layout for por padr∆o, sem utlizar delimitador
                /** Atualiza posiá∆o final **/
                assign ttLayout.num-pos-inicial = i-posicao-ini
                       ttLayout.num-pos-final   = f-tamanho(i-posicao-ini,ttLayout.num-tam-campo).*/
            END.
        END. /** do else **/
    END.
END.

/** Mostra tabela de erros **/
IF CAN-FIND(FIRST RowErrors) THEN DO:
    {method/showmessage.i1}
    {method/showmessage.i2 &Modal="YES"}
    EMPTY TEMP-TABLE RowErrors.
    RETURN "NOK":U.
END.
ELSE
    /** Mostra mensagem sem erros **/
    IF p-log-mes THEN
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 27516,
                           INPUT '').

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     Executa as validaá‰es padr‰es e chama o RP de importaá∆o.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/***************************************************************************/
/** Relat¢rio **/
&ELSE
/***************************************************************************/
/** Importaá∆o/Exportaá∆o **/
do on error undo, return ERROR 
   on stop  undo, return error:

    {report/rpexa.i}
    /** Validaá∆o arquivo destino **/
    if input frame fPage7 rsDestiny   = 2 and
       input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "").
            RUN setFolder IN hFolder (INPUT 3).
            apply "ENTRY":U to cDestinyFile in frame fPage7.
            return error.
        END.
    END.
    /** Validaá∆o do arquivo importaá∆o **/
    assign file-info:file-name = input frame fPage4 cInputFile.
    if file-info:pathname             = ? and
       input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).
        RUN setFolder IN hFolder (INPUT 2).
        apply "ENTRY":U to cInputFile in frame fPage4.
        return error.
    END.
    /** Validaá∆o da existància de layout **/
    IF NOT CAN-FIND(FIRST ttLayout) THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "CHOOSE":U TO bt-plus IN FRAME fPage2.
        RETURN ERROR.
    END.

    create tt-param.
    assign tt-param.usuario      = c-seg-usuario
           tt-param.destino      = input frame fPage7 rsDestiny
           tt-param.todos        = input frame fPage7 rsAll
           tt-param.execucao     = input frame fPage7 rsExecution
           tt-param.arq-entrada  = input frame fPage4 cInputFile
           tt-param.data-exec    = today
           tt-param.hora-exec    = time
           tt-param.i-origem     = 1 /** Importaá∆o **/
           tt-param.dtInicial    = input frame fPage3 fiDataIni
           tt-param.dtFinal      = input frame fPage3 fiDataFim
           tt-param.empIni       = input frame fPage3 fiEmpIni
           tt-param.empFim       = input frame fPage3 fiEmpFim
           tt-param.eqptoIni     = input frame fPage3 fiEqptoIni
           tt-param.eqptoFim     = input frame fPage3 fiEqptoFim
           tt-param.placaIni     = input frame fPage3 fiplacaIni
           tt-param.placaFim     = input frame fPage3 fiplacaFim
           tt-param.cDelimitador = input frame fPage2 fiDelimitador
           tt-param.iLayout      = input frame fPage2 rsLayout
           tt-param.cLayout      = entry((tt-param.iLayout - 1) * 2 + 1, rsLayout:radio-buttons in frame fPage2)
           tt-param.iImport      = input frame fPage2 rsTipo
           tt-param.cImport      = entry((tt-param.iImport - 1) * 2 + 1, rsTipo:radio-buttons in frame fPage2)
           tt-param.iClassif     = input frame fPage4 rsImport
           tt-param.cClassif     = entry((tt-param.iClassif - 1) * 2 + 1, rsImport:radio-buttons in frame fPage4)
           tt-param.iAgrupa      = input frame fPage4 fiAGrupa
           tt-param.lValoresPadr = input frame fPage4 tbValPadr
           tt-param.ep-prin      = input frame fPage4 ep-prin.

    if tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
        if tt-param.destino = 2 THEN
            assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
        else
            assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN tt-param.unidNegocIni = input frame fPage3 fiUnidNegocIni
                   tt-param.unidNegocFim = input frame fPage3 fiUnidNegocFim.
        END.
    &ENDIF

    /** Validaá∆o dos dados do Browse **/
    run pi-validate-layout IN THIS-PROCEDURE (INPUT NO).
    IF RETURN-VALUE = 'NOK':U THEN RETURN ERROR.

    /** Gravaá∆o da tt-digita **/
    EMPTY TEMP-TABLE tt-digita.
    for each ttLayout:
        create tt-digita.
        buffer-copy ttLayout to tt-digita.
    END.
    
    for each tt-raw-digita:
       delete tt-raw-digita.
    end.

    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end. 

    {report/imexb.i}
    if session:set-wait-state("GENERAL":U) then.

    {report/imrun.i abp/ab0705rp.p}

    {report/imexc.i}

    if session:set-wait-state("") then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}
END.
&endif

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaPosicao wReport 
PROCEDURE piValidaPosicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ultimaPosicao   AS INTEGER INIT 0  NO-UNDO.
    DEFINE VARIABLE logControle     AS LOGICAL INIT NO NO-UNDO.

    ASSIGN posicaoInvalida = NO.

    FOR EACH bfttLayout4 NO-LOCK BY bfttLayout4.num-pos-inicial:
        IF logControle = NO THEN DO:
            ASSIGN logControle = YES.
            ASSIGN ultimaPosicao = bfttLayout4.num-pos-inicial.
        END.
        ELSE DO:
            IF bfttLayout4.num-pos-inicial <= ultimaPosicao AND bfttLayout4.num-pos-inicial <> ? AND bfttLayout4.num-pos-inicial <> 0 THEN DO:
                ASSIGN posicaoInvalida = YES.
                RUN utp/ut-msgs.p(INPUT "show":U,
                                  INPUT 55266,
                                  INPUT "").
                LEAVE.
            END.
        END.

        ASSIGN ultimaPosicao = bfttLayout4.num-pos-inicial.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-campo wReport 
FUNCTION f-campo RETURNS CHARACTER
  (input p-campo as character):
/*------------------------------------------------------------------------------
  Purpose:  f-campo
    Notes:  Retorna um Label para o browse.
------------------------------------------------------------------------------*/
define variable c-campo as character format "x(40)" no-undo.


case p-campo:
    when "ep-codigo":U then do:
        {utp/ut-liter.i "Empresa"}
        assign c-campo = trim(return-value).
    end. 
    when "nome":U then do:
        {utp/ut-liter.i Descriá∆o_Empresa }
        assign c-campo = trim(return-value).
    end. 
    when "cod-ativid":U then do:
        {utp/ut-liter.i "Atividade"}
        assign c-campo = trim(return-value).
    end. 
    when "cod-eqpto":U then do:
        {utp/ut-liter.i "Equipamento"}
        assign c-campo = trim(return-value).
    end.
    when "num-docto":U then do:
        {utp/ut-liter.i "Documento"}
        assign c-campo = trim(return-value) + " - (999999999)":U.
    end.
    when "cod-rota":U then do:
        {utp/ut-liter.i "Trajeto"}
        assign c-campo = trim(return-value) .
    end.
    when "cod-placa":U then do:
        {utp/ut-liter.i "Placa"}
        assign c-campo = trim(return-value).
    end.
    when "cod-posto":U then do:
        {utp/ut-liter.i "Posto"}
        assign c-campo = trim(return-value).
    end.
    when "cod-bomba":U then do:
        {utp/ut-liter.i "Bomba"}
        assign c-campo = trim(return-value).
    end.
    when "cod-tip-mater":U then do:
        {utp/ut-liter.i "Tipo Material"}
        assign c-campo = trim(return-value).
    end.
    when "ep-codigo-matr":U then do:
        {utp/ut-liter.i "Empresa Motorista"}
        assign c-campo = trim(return-value).
    end.
    when "cod-estabel-matr":U then do:
        {utp/ut-liter.i "Estab Motorista"}
        assign c-campo = trim(return-value).
    end.
    when "cod-matr":U then do:
        {utp/ut-liter.i "Matr°cula Motorista"}
        assign c-campo = trim(return-value).
    end.
    when "val-hodom-horim":U then do:
        {utp/ut-liter.i "Contador"}
        assign c-campo = trim(return-value) + " - ( 9999999,9)":U.       .
    end.
    when "val-quant":U then do:
        {utp/ut-liter.i "Qtd Combust°vel"}
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.    
    end.
    when "val-mater-1":U then do:
        {utp/ut-liter.i "Valor"}
        assign c-campo = trim(return-value) + " - (999999999,9999)":U.     
    end.
    when "val-mater-2":U then do:
        {utp/ut-liter.i "Valor 1"}
        assign c-campo = trim(return-value) + " - (999999999,9999)":U.     
    end.
    when "val-mater-3":U then do:
        {utp/ut-liter.i "Valor 2"}
        assign c-campo = trim(return-value) + " - (999999999,9999)":U.     
    end.

    when "val-dat-hora-invrt":U then do:
        {utp/ut-liter.i "Data/Hora"}
        assign c-campo = trim(return-value) + " - (99999999999999)":U.     
    end.
    when "cgc":U then do: 
        {utp/ut-liter.i "CNPJ/CPF"}
        assign c-campo = trim(return-value).     
    end.
    when "cc-codigo":U then do: 
        {utp/ut-liter.i "Centro Custo"}
        assign c-campo = trim(return-value).     
    end.
    when "dat-movto":U then do: 
        {utp/ut-liter.i "Data Movimento"}
        assign c-campo = trim(return-value) + " - (dd/mm/yyyy)":U.     
    end.
    when "hra-inicial":U then do: 
        {utp/ut-liter.i "Hora Inicial"}
        assign c-campo = trim(return-value) + " - (HH:MM:SS)":U.     
    end.
    when "nr-nota-fis":U then do: 
        {utp/ut-liter.i "Nota Fiscal"}
        assign c-campo = trim(return-value).     
    end.
    when "des-posto":U then do: 
        {utp/ut-liter.i "Descriá∆o Posto"}
        assign c-campo = trim(return-value).     
    end.
    when "cod-comptmento":U then do: 
        {utp/ut-liter.i "Compartimento"}
        assign c-campo = trim(return-value).     
    end.
    when "cod-evento":U then do: 
        {utp/ut-liter.i "Evento"}
        assign c-campo = trim(return-value).     
    end.
    when "des-model":U then do: 
        {utp/ut-liter.i "Descriá∆o"}
        assign c-campo = trim(return-value).     
    end.
    when "nom-motoris":U then do: 
        {utp/ut-liter.i "Nome Motorista" }
        assign c-campo = trim(return-value).   
    end.
    when "Tipo":U then do: 
        {utp/ut-liter.i Tipo_Serviáo * }
        assign c-campo = trim(return-value).     
    end. 
    when "cod-emitente":U then do: 
        {utp/ut-liter.i "Emitente"}
        assign c-campo = trim(return-value).     
    end. 
&IF DEFINED(bf_mnt_ems206b) &THEN
    when "cod-unid-negoc":U then do: 
&ELSE
    when "cod_unid_negoc":U then do: 
&ENDIF
        {utp/ut-liter.i "Unidade Neg¢cio"}
        assign c-campo = trim(return-value).     
    end.
    when "serie":U then do:
        {utp/ut-liter.i "SÇrie"}
        assign c-campo = trim(return-value).     
    end. 
    when "cod-refer":U then do: 
        {utp/ut-liter.i "Referància"}
        assign c-campo = trim(return-value).     
    end. 
    when "cod-localiz":U then do:
        {utp/ut-liter.i "Localizaá∆o"}
        assign c-campo = trim(return-value).     
    end. 
    when "it-codigo":U then do:
        {utp/ut-liter.i "Item"}
        assign c-campo = trim(return-value).     
    end. 
    when "lote":U then do: 
        {utp/ut-liter.i "Lote"}
        assign c-campo = trim(return-value).     
    end. 
    when "tip-troca":U then do: 
        {utp/ut-liter.i "Tipo Troca"}
        assign c-campo = trim(return-value).     
    end. 
    when "cd-tipo":U then do: 
        {utp/ut-liter.i "Tipo Manutená∆o"}
        assign c-campo = trim(return-value).     
    end. 
    when "cod-usuar":U then do: 
        {utp/ut-liter.i "Usu†rio"}
        assign c-campo = trim(return-value).     
    end. 
    when "ct-codigo":U then do: 
        {utp/ut-liter.i "Conta"}
        assign c-campo = trim(return-value).     
    end. 
    when "apontador":U then do: 
        {utp/ut-liter.i "Apontador"}
        assign c-campo = trim(return-value).     
    end. 
    when "num-abastec":U then do: 
        {utp/ut-liter.i "N£mero Abastecimento"}
        assign c-campo = trim(return-value).     
    end. 
    when "tp-regist":U then do: 
        {utp/ut-liter.i "Tipo de Registro"}
        assign c-campo = trim(return-value).     
    end.
    when "icod-veiculo":U then do: 
        {utp/ut-liter.i "C¢digo do Ve°culo"}
        assign c-campo = trim(return-value).     
    end.
    when "icod-bomba":U then do: 
        {utp/ut-liter.i "N£mero da Bomba"}
        assign c-campo = trim(return-value).     
    end. 
    when "icod-rede":U then do: 
        {utp/ut-liter.i "C¢digo da Rede"}
        assign c-campo = trim(return-value).     
    end. 
    when "icod-posto":U then do: 
        {utp/ut-liter.i "C¢digo do Posto"}
        assign c-campo = trim(return-value).     
    end. 
    when "icod-frota":U then do: 
        {utp/ut-liter.i "C¢digo da Frota"}
        assign c-campo = trim(return-value).     
    end. 
    when "cTpCombust":U then do: 
        {utp/ut-liter.i "Tipo de Combust°vel"}
        assign c-campo = trim(return-value).     
    end. 
   when "uve":U then do: 
        {utp/ut-liter.i "N£mero da UVE"}
        assign c-campo = trim(return-value).     
    end. 
    when "val-descont":U then do: 
        {utp/ut-liter.i "Preáo do Desconto"}
        assign c-campo = trim(return-value).     
    end. 
    when "val-tot":U then do: 
        {utp/ut-liter.i "Preáo Total"}
        assign c-campo = trim(return-value).     
    end. 
    when "dat-credit":U then do: 
        {utp/ut-liter.i "Data do CrÇdito"}
        assign c-campo = trim(return-value) + " - (dd/mm/yyyy)":U.     
    end. 
    when "cNomeArq":U then do: 
        {utp/ut-liter.i "Nome do Arquivo"}
        assign c-campo = trim(return-value).     
    end. 
    when "deDistPerc":U then do: 
        {utp/ut-liter.i "Somat¢ria entre abastecimentos"}
        assign c-campo = trim(return-value).     
    end. 
    when "val-qtde-tot":U then do: 
        {utp/ut-liter.i "Somat¢ria de quantidade"}
        assign c-campo = trim(return-value).     
    end. 
    when "cStatus":U then do: 
        {utp/ut-liter.i "Status"}
        assign c-campo = trim(return-value).     
    end. 
    when "val-abastec-ant":U then do: 
        {utp/ut-liter.i "Abastecimento Anterior"}
        assign c-campo = trim(return-value).     
    end. 
    when "cCidPosto":U then do: 
        {utp/ut-liter.i "Cidade do Posto"} 
        assign c-campo = trim(return-value).     
    end. 
    when "des-tip-mater":U then do: 
        {utp/ut-liter.i "Tipo Serviáo" } 
        assign c-campo = trim(return-value).     
    end. 
    when "val-hodom-horim-sec":U then do: 
        {utp/ut-liter.i "Contador Secund†rio" } 
        assign c-campo = trim(return-value).     
    end. 
     when "nombre":U then do: 
        {utp/ut-liter.i "Nombre" } 
        assign c-campo = trim(return-value).     
    end.
     when "patente":U then do: 
        {utp/ut-liter.i "Patente/Conductor" } 
        assign c-campo = trim(return-value).     
    end.
     when "vehiculo":U then do: 
        {utp/ut-liter.i "Vehiculo/Conductor" } 
        assign c-campo = trim(return-value).     
    end.
     when "tarjeta":U then do: 
        {utp/ut-liter.i "Tarjeta" } 
        assign c-campo = trim(return-value).     
    end. 
     when "fecha":U then do: 
        {utp/ut-liter.i "Fecha" } 
        assign c-campo = trim(return-value) + " - (dd/mm/yyyy)":U.      
    end. 
     when "hora":U then do: 
        {utp/ut-liter.i "Hora" } 
        assign c-campo = trim(return-value) + " - (HH:MM:SS)":U.   
    end. 
     when "estacion-de-servicio":U then do: 
        {utp/ut-liter.i "Estaci¢n de Servicio" } 
        assign c-campo = trim(return-value).     
    end. 
     when "guia-despacho":U then do: 
        {utp/ut-liter.i "Gu°a Despacho" } 
        assign c-campo = trim(return-value).     
    end. 
     when "p-unitario":U then do: 
        {utp/ut-liter.i "P.Unitario" } 
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.     
    end. 
     when "volumen":U then do: 
        {utp/ut-liter.i "Volumen" } 
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.     
    end. 
     when "monto":U then do: 
        {utp/ut-liter.i "Monto" } 
        assign c-campo = trim(return-value) + " - ( 999999,999)":U.     
    end. 
     when "odometro":U then do: 
        {utp/ut-liter.i "Od¢metro" } 
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.     
    end. 
     when "Km-Lt":U then do: 
        {utp/ut-liter.i "Km/Lt" } 
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.     
    end. 
    when "Km":U then do: 
        {utp/ut-liter.i "Km" } 
        assign c-campo = trim(return-value) + " - ( 999999,99)":U.     
    end. 

end case.
  IF ttLayout.log-mandatorio = YES THEN DO:
      {utp/ut-liter.i "Sim" } 
      ASSIGN mandatorio = RETURN-VALUE.
  END.
  ELSE DO:
      {utp/ut-liter.i "N∆o" } 
      ASSIGN mandatorio = RETURN-VALUE.
  END.
  RETURN (c-campo).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-tamanho wReport 
FUNCTION f-tamanho RETURNS INTEGER
  (input p-inicio  as integer,
   input p-tamanho as integer) :
/*------------------------------------------------------------------------------
  Purpose:  f-tamanho
    Notes:  Atualiza o campo posiá∆o final no browse.
------------------------------------------------------------------------------*/
define variable i-termino as integer no-undo.

assign i-termino = (p-inicio + p-tamanho) - 1.

  RETURN i-termino.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

