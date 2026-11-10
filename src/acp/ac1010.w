&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
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
{include/i-prgvrs.i AC1010 2.00.00.026 } /*** 010026 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1010 MAC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field cod-estab-ini       like cotas.cod-estabel
    field cod-estab-fim       like cotas.cod-estabel
    field cod-canal-venda-ini like cotas.cod-canal-venda
    field cod-canal-venda-fim like cotas.cod-canal-venda
    field cod-gr-cli-ini      like cotas.cod-gr-cli
    field cod-gr-cli-fim      like cotas.cod-gr-cli
    field nome-abrev-ini      like emitente.nome-abrev
    field nome-abrev-fim      like emitente.nome-abrev
    field nome-ab-reg-ini     like cotas.nome-ab-reg
    field nome-ab-reg-fim     like cotas.nome-ab-reg
    field nome-mic-reg-ini    like cotas.nome-mic-reg
    field nome-mic-reg-fim    like cotas.nome-mic-reg
    field cod-rep-ini         like cotas.cod-rep
    field cod-rep-fim         like cotas.cod-rep
    field produto-ini         like cotas.cd-produto
    field produto-fim         like cotas.cd-produto
    field origem-dados        as integer
    field desc-orig-dados     as char format "x(40)"
    field cod-plano           as integer format ">>9" 
    field desc-plano          as char format "x(30)"
    field periodo-ini         as integer format ">>9"
    field periodo-fim         as integer format ">>9"
    field deleta              as logical
    field util-decimal        as logical
    field atualiza            as logical
    field soma-dif            as logical
    field dt-periodo          as date format "99/99/9999"
    field total-cota          as decimal format ">>>,>>>,>>9.99"
    field codigo              as integer format ">>9"
    field desc-tipo-baserat   as char format "x(30)"
    field dt-periodo-ini      as date format "99/99/9999"
    field dt-periodo-fim      as date format "99/99/9999" .

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.

/* Include pre-processador release 202 ou 203 */
{cdp/cdcfgdis.i}

/* Temporary Table Definitions ---                                      */

def temp-table tt-base-cota
   field cd-produto  like base-cota.cd-produto
   field qt-prevista like base-cota.qt-prevista
   INDEX i-cd-produto cd-produto DESCENDING.

/* Definiá∆o de variaveis utilizadas para armazenar literais */

def var c-label-1           as character format "x(35)" no-undo.
def var c-label-2           as character format "x(35)" no-undo.
def var c-label-3           as character format "x(35)" no-undo.
def var c-label-4           as character format "x(35)" no-undo.
def var c-label-5           as character format "x(35)" no-undo.
def var c-label-6           as character format "x(35)" no-undo.
def var c-label-7           as character format "x(35)" no-undo.
def var c-label-8           as character format "x(35)" no-undo.
def var c-label-9           as character format "x(35)" no-undo.
def var c-label-10          as character format "x(35)" no-undo.

def var i-selec-zoom        as integer init 1           no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

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

DEFINE VARIABLE c-desc-plano AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipo-baserat AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-periodo AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-dt-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Data Final" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-periodo-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE de-total-cota AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total Cota" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Previs∆o Vendas" 
      VIEW-AS TEXT 
     SIZE 20 BY .54 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Base Cotas" 
      VIEW-AS TEXT 
     SIZE 14 BY .54 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Informado" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE i-cod-plano AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Plano" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-codigo AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Tipo Base Rateio" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-periodo-fim AS INTEGER FORMAT ">>9":U INITIAL 365 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-periodo-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-origem-dados AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Previs∆o de Vendas", 1,
"Base de Cotas", 2,
"Informado", 3
     SIZE 65 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 2.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 3.75.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 1.75.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 1.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 3.75.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 3.75.

DEFINE VARIABLE l-util-decimal AS LOGICAL INITIAL yes 
     LABEL "Utiliza Decimais" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atualiza AS LOGICAL INITIAL yes 
     LABEL "Atualiza Cota Original" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 NO-UNDO.

DEFINE VARIABLE tg-deleta AS LOGICAL INITIAL no 
     LABEL "Elimina Posiá∆o Anterior" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-soma-dif AS LOGICAL INITIAL yes 
     LABEL "Soma Diferenáa na Maior Cota (Arredonda)" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.43 BY .83 NO-UNDO.

DEFINE VARIABLE c-cd-produto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-produto-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ab-reg-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ab-reg-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-nome-mic-reg-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-mic-reg-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE i-cod-canal-venda-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-cod-gr-cli-fim AS INTEGER FORMAT ">>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE i-cod-gr-cli-ini AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-las":U
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

DEFINE BUTTON bt-importa 
     LABEL "Importar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
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
     SIZE 79 BY 11.38
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

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-par
     rs-origem-dados AT ROW 2.04 COL 7 HELP
          "Situaá∆o" NO-LABEL
     i-cod-plano AT ROW 4.5 COL 8 COLON-ALIGNED HELP
          "C¢digo do Plano"
     c-desc-plano AT ROW 4.5 COL 13 COLON-ALIGNED NO-LABEL
     i-periodo-ini AT ROW 5.5 COL 8 COLON-ALIGNED HELP
          "Per°odo Inicial"
     i-periodo-fim AT ROW 5.5 COL 20 COLON-ALIGNED HELP
          "Per°odo Final" NO-LABEL
     i-codigo AT ROW 8.25 COL 18 COLON-ALIGNED HELP
          "Tipo da Base de Rateio"
     c-desc-tipo-baserat AT ROW 8.25 COL 22 COLON-ALIGNED NO-LABEL
     da-dt-periodo-ini AT ROW 9.25 COL 18 COLON-ALIGNED HELP
          "Data inicial do Per°odo das cotas"
     da-dt-periodo-fim AT ROW 10.25 COL 18 COLON-ALIGNED HELP
          "Data final do Per°odo das cotas"
     da-dt-periodo AT ROW 4.25 COL 55 COLON-ALIGNED HELP
          "Data inicial do Per°odo das cotas"
     de-total-cota AT ROW 6.25 COL 55 COLON-ALIGNED HELP
          "Total Cota"
     tg-deleta AT ROW 8.13 COL 42.72
     l-util-decimal AT ROW 8.88 COL 42.72
     tg-atualiza AT ROW 9.63 COL 42.72
     tg-soma-dif AT ROW 10.38 COL 42.72
     FILL-IN-1 AT ROW 3.5 COL 4 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 3.5 COL 42 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 5.5 COL 42 COLON-ALIGNED NO-LABEL
     "Origem dos Dados" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 1.25 COL 6
     RECT-11 AT ROW 1.5 COL 2
     RECT-26 AT ROW 3.75 COL 2
     RECT-27 AT ROW 7.75 COL 2
     IMAGE-18 AT ROW 5.5 COL 15
     IMAGE-19 AT ROW 5.5 COL 19
     RECT-24 AT ROW 3.75 COL 41
     RECT-25 AT ROW 5.75 COL 41
     RECT-21 AT ROW 7.75 COL 41
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.75
         SIZE 77.29 BY 10.79.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-importa AT ROW 14.54 COL 14
     bt-cancelar AT ROW 14.54 COL 25 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 2.25 COL 22 COLON-ALIGNED
     c-cod-estab-fim AT ROW 2.33 COL 50.86 COLON-ALIGNED NO-LABEL
     i-cod-canal-venda-ini AT ROW 3.25 COL 22 COLON-ALIGNED HELP
          "Codigo do Canal de Venda"
     i-cod-canal-venda-fim AT ROW 3.25 COL 50.86 COLON-ALIGNED HELP
          "C¢digo do Canal de Venda" NO-LABEL
     i-cod-gr-cli-ini AT ROW 4.25 COL 22 COLON-ALIGNED HELP
          "C¢digo do Grupo de Clientes"
     i-cod-gr-cli-fim AT ROW 4.25 COL 50.86 COLON-ALIGNED HELP
          "C¢digo do Grupo de Clientes" NO-LABEL
     c-nome-abrev-ini AT ROW 5.25 COL 22 COLON-ALIGNED HELP
          "Nome do Cliente Inicial"
     c-nome-abrev-fim AT ROW 5.25 COL 50.86 COLON-ALIGNED HELP
          "Nome do Cliente Final" NO-LABEL
     c-nome-ab-reg-ini AT ROW 6.25 COL 22 COLON-ALIGNED HELP
          "Nome da regi∆o"
     c-nome-ab-reg-fim AT ROW 6.25 COL 50.86 COLON-ALIGNED HELP
          "Nome da Regi∆o" NO-LABEL
     c-nome-mic-reg-ini AT ROW 7.25 COL 22 COLON-ALIGNED HELP
          "Nome da Microrregi∆o"
     c-nome-mic-reg-fim AT ROW 7.25 COL 50.86 COLON-ALIGNED HELP
          "Nome da Microrregi∆o" NO-LABEL
     i-cod-rep-ini AT ROW 8.25 COL 22 COLON-ALIGNED HELP
          "C¢digo do Representante"
     i-cod-rep-fim AT ROW 8.25 COL 50.86 COLON-ALIGNED HELP
          "C¢digo do Representante" NO-LABEL
     c-cd-produto-ini AT ROW 9.25 COL 22 COLON-ALIGNED HELP
          "C¢digo do Produto/Item"
     c-cd-produto-fim AT ROW 9.25 COL 50.86 COLON-ALIGNED HELP
          "C¢digo do Produto/Item" NO-LABEL
     IMAGE-15 AT ROW 2.25 COL 41.57
     IMAGE-16 AT ROW 2.25 COL 49.29
     IMAGE-1 AT ROW 3.25 COL 41.57
     IMAGE-2 AT ROW 3.25 COL 49.29
     IMAGE-13 AT ROW 4.25 COL 41.57
     IMAGE-14 AT ROW 4.25 COL 49.29
     IMAGE-20 AT ROW 5.25 COL 41.57
     IMAGE-21 AT ROW 5.25 COL 49.29
     IMAGE-7 AT ROW 6.25 COL 41.57
     IMAGE-12 AT ROW 6.25 COL 49.29
     IMAGE-6 AT ROW 7.25 COL 41.57
     IMAGE-11 AT ROW 7.25 COL 49.29
     IMAGE-4 AT ROW 8.25 COL 41.57
     IMAGE-9 AT ROW 8.25 COL 49.29
     IMAGE-5 AT ROW 9.25 COL 41.57
     IMAGE-10 AT ROW 9.25 COL 49.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Distribuiá∆o de Cotas"
         HEIGHT             = 15.08
         WIDTH              = 81.14
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
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-desc-plano IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tipo-baserat IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-periodo IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-cota IN FRAME f-pg-par
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-1:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Previs∆o Vendas".

ASSIGN 
       FILL-IN-2:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Base Cotas".

ASSIGN 
       FILL-IN-3:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Informado".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR BUTTON bt-importa IN FRAME f-relat
   NO-ENABLE                                                            */
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
ON END-ERROR OF w-relat /* Distribuiá∆o de Cotas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Distribuiá∆o de Cotas */
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


&Scoped-define SELF-NAME bt-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importa w-relat
ON CHOOSE OF bt-importa IN FRAME f-relat /* Importar */
DO:
  if SEARCH("acp~\ac1008.w") <> ? or
     SEARCH("acp~\ac1008.r") <> ? then do:
     run acp/ac1008.w.
  end.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-cd-produto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini w-relat
ON F5 OF c-cd-produto-ini IN FRAME f-pg-sel
DO:
    run cdp/cd9019.w (input-output i-selec-zoom).

    if  i-selec-zoom = 1  then do:
        {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                           &campo=c-cd-produto-ini
                           &campozoom=it-codigo
                           &frame={&FRAME-NAME}}
    end.
    else do:
        /*****  Uso de pre-processador ******/
        &if defined (bf_dis_adm_cotas) &then
            {include/zoomvar.i &prog-zoom=dizoom/z01di292.w
                               &campo=c-cd-produto-ini
                               &campozoom=cod-produto-coml
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &else
            {include/zoomvar.i &prog-zoom=inzoom/z01in360.w
                               &campo=c-cd-produto-ini
                               &campozoom=cd-produto
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &endif
    end.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cd-produto-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini w-relat
ON F5 OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
        {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=c-cod-estab-ini
                     &campozoom=cod-estabel
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-ab-reg-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg-ini w-relat
ON F5 OF c-nome-ab-reg-ini IN FRAME f-pg-sel
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad218.w
                     &campo=c-nome-ab-reg-ini
                     &campozoom=nome-ab-reg
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF c-nome-ab-reg-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-abrev-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev-ini w-relat
ON F5 OF c-nome-abrev-ini IN FRAME f-pg-sel /* Cliente */
DO:
              {include/zoomvar.i &prog-zoom=adzoom/z02ad098.w
                     &campo=c-nome-abrev-ini
                     &campozoom=nome-abrev
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF c-nome-abrev-ini IN FRAME f-pg-sel /* Cliente */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-mic-reg-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg-ini w-relat
ON F5 OF c-nome-mic-reg-ini IN FRAME f-pg-sel
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di107.w
                     &campo=c-nome-mic-reg-ini
                     &campozoom=nome-mic-reg
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF c-nome-mic-reg-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-canal-venda-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini w-relat
ON F5 OF i-cod-canal-venda-ini IN FRAME f-pg-sel
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                     &campo=i-cod-canal-venda-ini
                     &campozoom=cod-canal-venda
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF i-cod-canal-venda-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-gr-cli-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli-ini w-relat
ON F5 OF i-cod-gr-cli-ini IN FRAME f-pg-sel
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad129.w
                     &campo=i-cod-gr-cli-ini
                     &campozoom=cod-gr-cli
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF i-cod-gr-cli-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME i-cod-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-plano w-relat
ON F5 OF i-cod-plano IN FRAME f-pg-par /* Plano */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=inzoom/Z01IN313.w
                      &campo=i-cod-plano
                      &campozoom=cd-plano
                      &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-plano w-relat
ON LEAVE OF i-cod-plano IN FRAME f-pg-par /* Plano */
DO:
   {include/leave.i &tabela=pl-mest 
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-plano   
                    &where="pl-mest.cd-plano = input frame {&FRAME-NAME} i-cod-plano"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-plano w-relat
ON MOUSE-SELECT-DBLCLICK OF i-cod-plano IN FRAME f-pg-par /* Plano */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME i-cod-rep-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-rep-ini w-relat
ON F5 OF i-cod-rep-ini IN FRAME f-pg-sel
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad229.w
                     &campo=i-cod-rep-ini
                     &campozoom=cod-rep
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-rep-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF i-cod-rep-ini IN FRAME f-pg-sel
DO:
  apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME i-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo w-relat
ON F5 OF i-codigo IN FRAME f-pg-par /* Tipo Base Rateio */
DO:
    assign l-implanta= yes.
    {include/zoomvar.i &prog-zoom=dizoom/z01di266.w
                     &campo=i-codigo
                     &campozoom=codigo
                     &frame={&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo w-relat
ON LEAVE OF i-codigo IN FRAME f-pg-par /* Tipo Base Rateio */
DO:
   {include/leave.i &tabela=tipo-baserat
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tipo-baserat
                   &where="tipo-baserat.codigo = input frame {&FRAME-NAME} i-codigo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo w-relat
ON MOUSE-SELECT-DBLCLICK OF i-codigo IN FRAME f-pg-par /* Tipo Base Rateio */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
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


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME rs-origem-dados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-origem-dados w-relat
ON VALUE-CHANGED OF rs-origem-dados IN FRAME f-pg-par
DO:
    {utp/ut-liter.i Produto/Item * R}
    assign c-cd-produto-ini:label in frame f-pg-sel = trim(return-value).

    case self:screen-value:
        when "1" then do:
            {utp/ut-liter.i Item * R}
            assign c-cd-produto-ini:label in frame f-pg-sel = trim(return-value).
           enable i-periodo-ini i-periodo-fim i-cod-plano with frame f-pg-par.
           disable da-dt-periodo de-total-cota with frame f-pg-par.
           disable bt-importa with frame f-relat.
           assign da-dt-periodo:screen-value in frame f-pg-par = ""
                  de-total-cota:screen-value in frame f-pg-par = "". 
        end.
        when "2" then do:
           enable da-dt-periodo with frame f-pg-par.
           enable bt-importa with frame f-relat.
           disable i-periodo-ini i-periodo-fim i-cod-plano de-total-cota with frame f-pg-par.
           assign i-periodo-ini:screen-value in frame f-pg-par = ""
                  i-periodo-fim:screen-value in frame f-pg-par = ""
                  i-cod-plano:screen-value   in frame f-pg-par = ""
                  c-desc-plano:screen-value  in frame f-pg-par = "" 
                  de-total-cota:screen-value in frame f-pg-par = "".
        end.
        when "3" then do:
           enable  de-total-cota with frame f-pg-par.
           disable i-periodo-ini i-periodo-fim i-cod-plano da-dt-periodo with frame f-pg-par.
           disable bt-importa with frame f-relat.
           assign i-periodo-ini:screen-value in frame f-pg-par = ""
                  i-periodo-fim:screen-value in frame f-pg-par = ""
                  i-cod-plano:screen-value   in frame f-pg-par = ""
                  c-desc-plano:screen-value  in frame f-pg-par = "" 
                  da-dt-periodo:screen-value in frame f-pg-par = "".
        end.
    end case.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "AC1010" "2.00.00.024"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
    if c-cod-estab-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-canal-venda-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-gr-cli-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if c-nome-abrev-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if c-nome-ab-reg-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if c-nome-mic-reg-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-rep-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if c-cd-produto-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-plano:load-mouse-pointer ("image/lupa.cur") in frame f-pg-par then.    
    if i-codigo:load-mouse-pointer ("image/lupa.cur") in frame f-pg-par then.    


    {utp/ut-field.i mgdis cotas cod-estabel 1}
    assign c-cod-estab-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas cod-canal-venda 1}
    assign i-cod-canal-venda-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas cod-gr-cli 1}
    assign i-cod-gr-cli-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas nome-ab-reg 1}
    assign c-nome-ab-reg-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas nome-mic-reg 1}
    assign c-nome-mic-reg-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas cod-rep 1}
    assign i-cod-rep-ini:label in frame f-pg-sel = trim(return-value).


    {utp/ut-liter.i Produto/Item * R}
    assign c-cd-produto-ini:label in frame f-pg-sel = trim(return-value).

    {include/i-rpmbl.i}

    {acp/ac9900.i}      /* Verifica se o m¢dulo est† implantado */
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&IF "{&mguni_version}" >= "2.071" &THEN
ASSIGN c-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
ASSIGN c-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
&ENDIF

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
  ENABLE im-pg-sel im-pg-par im-pg-imp bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-origem-dados i-cod-plano c-desc-plano i-periodo-ini i-periodo-fim 
          i-codigo c-desc-tipo-baserat da-dt-periodo-ini da-dt-periodo-fim 
          da-dt-periodo de-total-cota tg-deleta l-util-decimal tg-atualiza 
          tg-soma-dif FILL-IN-1 FILL-IN-2 FILL-IN-3 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE rs-origem-dados i-cod-plano i-periodo-ini i-periodo-fim i-codigo 
         da-dt-periodo-ini da-dt-periodo-fim tg-deleta l-util-decimal 
         tg-atualiza tg-soma-dif FILL-IN-1 FILL-IN-2 FILL-IN-3 RECT-11 RECT-26 
         RECT-27 IMAGE-18 IMAGE-19 RECT-24 RECT-25 RECT-21 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
          i-cod-canal-venda-fim i-cod-gr-cli-ini i-cod-gr-cli-fim 
          c-nome-abrev-ini c-nome-abrev-fim c-nome-ab-reg-ini c-nome-ab-reg-fim 
          c-nome-mic-reg-ini c-nome-mic-reg-fim i-cod-rep-ini i-cod-rep-fim 
          c-cd-produto-ini c-cd-produto-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-15 IMAGE-16 IMAGE-1 IMAGE-2 IMAGE-13 IMAGE-14 IMAGE-20 IMAGE-21 
         IMAGE-7 IMAGE-12 IMAGE-6 IMAGE-11 IMAGE-4 IMAGE-9 IMAGE-5 IMAGE-10 
         c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
         i-cod-canal-venda-fim i-cod-gr-cli-ini i-cod-gr-cli-fim 
         c-nome-abrev-ini c-nome-abrev-fim c-nome-ab-reg-ini c-nome-ab-reg-fim 
         c-nome-mic-reg-ini c-nome-mic-reg-fim i-cod-rep-ini i-cod-rep-fim 
         c-cd-produto-ini c-cd-produto-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    run pi-validate.    

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.origem-dados    = input frame f-pg-par rs-origem-dados
           tt-param.desc-orig-dados = entry((tt-param.origem-dados - 1) * 2 + 1, 
                                            rs-origem-dados:radio-buttons in frame f-pg-par).


    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    assign tt-param.cod-estab-ini       = input frame f-pg-sel c-cod-estab-ini           
           tt-param.cod-estab-fim       = input frame f-pg-sel c-cod-estab-fim      
           tt-param.cod-canal-venda-ini = input frame f-pg-sel i-cod-canal-venda-ini
           tt-param.cod-canal-venda-fim = input frame f-pg-sel i-cod-canal-venda-fim
           tt-param.cod-gr-cli-ini      = input frame f-pg-sel i-cod-gr-cli-ini
           tt-param.cod-gr-cli-fim      = input frame f-pg-sel i-cod-gr-cli-fim
           tt-param.nome-abrev-ini      = input frame f-pg-sel c-nome-abrev-ini
           tt-param.nome-abrev-fim      = input frame f-pg-sel c-nome-abrev-fim
           tt-param.nome-ab-reg-ini     = input frame f-pg-sel c-nome-ab-reg-ini
           tt-param.nome-ab-reg-fim     = input frame f-pg-sel c-nome-ab-reg-fim
           tt-param.nome-mic-reg-ini    = input frame f-pg-sel c-nome-mic-reg-ini
           tt-param.nome-mic-reg-fim    = input frame f-pg-sel c-nome-mic-reg-fim
           tt-param.cod-rep-ini         = input frame f-pg-sel i-cod-rep-ini
           tt-param.cod-rep-fim         = input frame f-pg-sel i-cod-rep-fim
           tt-param.produto-ini         = input frame f-pg-sel c-cd-produto-ini
           tt-param.produto-fim         = input frame f-pg-sel c-cd-produto-fim
           tt-param.cod-plano           = input frame f-pg-par i-cod-plano 
           tt-param.desc-plano          = input frame f-pg-par c-desc-plano           
           tt-param.periodo-ini         = input frame f-pg-par i-periodo-ini
           tt-param.periodo-fim         = input frame f-pg-par i-periodo-fim
           tt-param.deleta              = input frame f-pg-par tg-deleta
           tt-param.util-decimal        = input frame f-pg-par l-util-decimal
           tt-param.atualiza            = input frame f-pg-par tg-atualiza
           tt-param.soma-dif            = input frame f-pg-par tg-soma-dif
           tt-param.dt-periodo          = input frame f-pg-par da-dt-periodo
           tt-param.total-cota          = input frame f-pg-par de-total-cota
           tt-param.codigo              = input frame f-pg-par i-codigo
           tt-param.desc-tipo-baserat   = input frame f-pg-par c-desc-tipo-baserat
           tt-param.dt-periodo-ini      = input frame f-pg-par da-dt-periodo-ini
           tt-param.dt-periodo-fim      = input frame f-pg-par da-dt-periodo-fim .

    {include/i-rpexb.i}

    SESSION:SET-WAIT-STATE("general":U).

    {include/i-rprun.i acp/ac1010rp.p}

    {include/i-rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {include/i-rptrm.i}
end.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate w-relat 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  if input frame f-pg-sel c-cod-estab-fim < input frame f-pg-sel c-cod-estab-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-estabel 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-cod-estab-ini in frame f-pg-sel.
     return error.  
  end. 
  if input frame f-pg-sel i-cod-canal-venda-fim < input frame f-pg-sel i-cod-canal-venda-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-canal-venda 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-canal-venda-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-sel i-cod-gr-cli-fim < input frame f-pg-sel i-cod-gr-cli-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-gr-cli 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-gr-cli-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-sel c-nome-abrev-fim < input frame f-pg-sel c-nome-abrev-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-abrev 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-abrev-ini in frame f-pg-sel.
     return error.
  end.
  if input frame f-pg-sel c-nome-ab-reg-fim < input frame f-pg-sel c-nome-ab-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-ab-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-ab-reg-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-sel c-nome-mic-reg-fim < input frame f-pg-sel c-nome-mic-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-mic-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-mic-reg-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-sel i-cod-rep-fim < input frame f-pg-sel i-cod-rep-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-rep 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-rep-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-sel c-cd-produto-fim < input frame f-pg-sel c-cd-produto-ini 
  then do:
     {utp/ut-field.i mgdis cotas cd-produto 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-cd-produto-ini in frame f-pg-sel.
     return error.
  end. 
  if input frame f-pg-par rs-origem-dados = 1 then do:
     find first param-global no-lock no-error.
     if avail param-global then do:
        if not param-global.modulo-pv then do:
           {utp/ut-table.i mgind pl-prod 3}
           run utp/ut-msgs.p (input "show",
                              input 2082,
                              input return-value).
           apply 'mouse-select-click' to im-pg-par in frame f-relat.
           apply 'entry' to i-cod-plano in frame f-pg-par.
        end.
     end.
     find first pr-venda no-lock
          where pr-venda.cd-plano = input frame f-pg-par i-cod-plano no-error.
     if not avail pr-venda then do:
        {utp/ut-liter.i Plano_Venda * R}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply 'mouse-select-click' to im-pg-par in frame f-relat.
        apply 'entry' to i-cod-plano in frame f-pg-par.
        return error.
     end.
     if input frame f-pg-par i-periodo-fim < input frame f-pg-par i-periodo-ini 
     then do:
        {utp/ut-liter.i Periodo_Final * L}
        assign c-label-9 = return-value.
        {utp/ut-liter.i Periodo_Inicial * L}
        assign c-label-10 = return-value.
        run utp/ut-msgs.p (input "show",input 209,input c-label-9 + "~~" + c-label-10).
        apply 'mouse-select-click' to im-pg-par in frame f-relat.
        apply 'entry' to i-periodo-fim in frame f-pg-par.
        return error.
     end. 

     if  input frame f-pg-sel c-cd-produto-fim <> c-cd-produto-fim
     OR  input frame f-pg-sel c-cd-produto-ini <> c-cd-produto-ini THEN DO:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-verifique-se-nao-foram-informa AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Verifique_se_n∆o_foram_informados_Produtos_Comerciais_na_faixa_de_seleá∆o_do_campo_Item" *}
         ASSIGN c-lbl-liter-verifique-se-nao-foram-informa = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-na-opcao-de-origem-previsao-de AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Na_opá∆o_de_origem_Previs∆o_de_Vendas_somente_poder∆o_ser_informados_Itens._Produtos_Comerciais_n∆o_ser∆o_considerados_para_geraá∆o_das_Cotas._Deseja_Continuar_?" *}
         ASSIGN c-lbl-liter-na-opcao-de-origem-previsao-de = TRIM(RETURN-VALUE).
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 27100,
                            INPUT c-lbl-liter-verifique-se-nao-foram-informa + "." + "~~" + 
                            c-lbl-liter-na-opcao-de-origem-previsao-de).
         IF  RETURN-VALUE = "NO" THEN
             return error.
     END.                                                                    

  end.   
  if input frame f-pg-par rs-origem-dados = 2 then do:
     find first base-cota no-lock 
          where base-cota.dt-inicial = input frame f-pg-par da-dt-periodo no-error.
     if not avail base-cota then do:
        {utp/ut-liter.i Per°odo * R}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply 'mouse-select-click' to im-pg-par in frame f-relat.
        apply 'entry' to da-dt-periodo in frame f-pg-par.
        return error.
     end.
  end.
  find tipo-baserat no-lock 
       where tipo-baserat.codigo = input frame f-pg-par i-codigo no-error.
  if not avail tipo-baserat then do:
     {utp/ut-liter.i Tipo_Base_Rateio * R}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     apply 'mouse-select-click' to im-pg-par in frame f-relat.
     apply 'entry' to i-codigo in frame f-pg-par.
     return error.
  end.

  /* n∆o permite excluir a base de rateio anterior, caso o periodo for 
     igual data inicial da nova cota */
  if input frame f-pg-par rs-origem-dados = 2                                      and
     input frame f-pg-par da-dt-periodo   = input frame f-pg-par da-dt-periodo-ini and
     tg-deleta:checked in frame f-pg-par  = yes                                    then do:
        {utp/ut-liter.i Posiá∆o_Anterior_com_Per°odo_igual_a_Data_Inicial * R}
        run utp/ut-msgs.p (input "show",
                           input 16668,
                           input trim(return-value)).
        apply 'mouse-select-click' to im-pg-par in frame f-relat.
        apply 'value-changed' to tg-deleta in frame f-pg-par.
        return error.
  end.

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
     Tables specified for this Window, and there are no
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

