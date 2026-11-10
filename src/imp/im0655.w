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
{include/i-prgvrs.i IM0655 2.00.00.045 } /*** 010045 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0655 MIM}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/boerrtab.i}

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0655
&GLOBAL-DEFINE Version        2.00.00.044
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Sele‡Æo 2,Parƒmetro,Parƒmetro 2,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    ccod-estabel-ini ~
                              ccod-estabel-fim ~
                              cembarque-ini ~
                              cembarque-fim ~
                              cnr-proc-imp-ini ~
                              cnr-proc-imp-fim ~
                              ccod-fornec-ini ~
                              ccod-fornec-fim ~
                              ccod-itiner-ini ~
                              ccod-itiner-fim  ~
                              fiPtoSolicLiIni ~
                              fiPtoSolicLiFim ~
                              ccod-embarque-ini ~
                              ccod-embarque-fim ~
                              ccod-desemb-ini ~
                              ccod-desemb-fim ~
                              ccod-grupo-ini ~
                              ccod-grupo-fim

&GLOBAL-DEFINE page3Fields  ccod-familia-ini ~
                            ccod-familia-fim ~
                            cit-codigo-ini  ~
                            cit-codigo-fim  ~
                            cfatura-ini  ~
                            cfatura-fim  ~
                            c-nr-conhecto-master-ini ~
                            c-nr-conhecto-master-fim ~
                            c-nr-conhecto-house-ini ~
                            c-nr-conhecto-house-fim ~
                            c-declar-import-ini ~
                            c-declar-import-fim ~
                            c-veiculo-transp-ini ~
                            c-veiculo-transp-fim ~
                            fiLicencImportIni ~
                            fiLicencImportFim ~
                            cx-via-trans-ini ~
                            cx-via-trans-fim

&GLOBAL-DEFINE page4Fields  ilocaliza ~
                            iMoeda ~
                            desc-moeda ~
                            dtCotacao ~
                            da-data-ini ~
                            da-data-fim ~
                            rs-situacao ~
                            rs-processos ~
                            rs-situacao-embarque

&GLOBAL-DEFINE page5Fields  litiner ~
                            lpeso-cub ~
                            lordens ~
                            tgDetalhaLi ~
                            ldespesas ~
                            ladicembarq ~
                            l-antecipacao

&GLOBAL-DEFINE page6Fields  rsDestiny ~
                            cfile ~
                            btFile~
                            btConfigImpr ~
                            rsExecution ~
                            text-destino ~
                            text-modo

/* Parameters Definitions ---                                           */
{imp/im0655.i} /* tt-param */

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
DEF VAR l-fn-antecipacao   AS LOGICAL NO-UNDO.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR cx-via-aux         AS CHAR    NO-UNDO.
DEF VAR i-cont             AS INT     NO-UNDO.

def stream s-imp.

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN l-fn-antecipacao = CAN-FIND(FIRST funcao
                                   WHERE funcao.cd-funcao = "spp-ifric22":U
                                     AND funcao.ativo).

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

DEFINE VARIABLE ccod-desemb-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-desemb-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-embarque-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-embarque-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Embarque" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-fornec-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-fornec-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-grupo-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-grupo-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-itiner-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-itiner-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-proc-imp-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-proc-imp-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiIni AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Solicita LI" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-113
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-114
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE cx-via-trans-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cx-via-trans-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-declar-import-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-declar-import-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhecto-house-fim AS CHARACTER FORMAT "X(18)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhecto-house-ini AS CHARACTER FORMAT "X(18)":U 
     LABEL "Conhec House" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhecto-master-fim AS CHARACTER FORMAT "X(18)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhecto-master-ini AS CHARACTER FORMAT "X(18)":U 
     LABEL "Conhec Master" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-veiculo-transp-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-veiculo-transp-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Veiculo Transp" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-familia-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-familia-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cfatura-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE cfatura-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Faturas" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE cit-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE cit-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Licenciamento Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-105
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-106
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-107
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-108
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-109
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-110
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-111
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-112
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-115
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-116
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-121
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-122
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-48
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE da-data-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de chegada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE desc-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dtCotacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Cota‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE ilocaliza AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE iMoeda AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-opcao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Internos", 1,
"Fornecedor", 2
     SIZE 12 BY 1.88 NO-UNDO.

DEFINE VARIABLE rs-processos AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Atrasados", 1,
"Adiantados", 2,
"Todos", 3
     SIZE 13 BY 3.42 NO-UNDO.

DEFINE VARIABLE rs-situacao AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Embarcado", 1,
"Embarcado Parcial", 2,
"Embarcado Total", 3,
"Encerrado", 4,
"Todos", 5
     SIZE 16.86 BY 4.17 NO-UNDO.

DEFINE VARIABLE rs-situacao-embarque AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Encerrado", 1,
"Encerrado", 2,
"Todos", 3
     SIZE 13 BY 3.42 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.14 BY 2.25.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.57 BY 3.83.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.29 BY 3.83.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 4.92.

DEFINE VARIABLE rs-detalhe-desp AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Despesas Pagas ao Fornecedor de Material", 1,
"Todas", 2
     SIZE 53 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 11.

DEFINE VARIABLE l-antecipacao AS LOGICAL INITIAL no 
     LABEL "Antecipa‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE ladicembarq AS LOGICAL INITIAL no 
     LABEL "Adi‡äes do Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE ldespesas AS LOGICAL INITIAL no 
     LABEL "Despesas Adicionais de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.29 BY .88 NO-UNDO.

DEFINE VARIABLE ldetalhadesp AS LOGICAL INITIAL no 
     LABEL "Detalha Dados das Despesas" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE litiner AS LOGICAL INITIAL no 
     LABEL "Detalhes do Itiner rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.72 BY .88 NO-UNDO.

DEFINE VARIABLE lobptocont AS LOGICAL INITIAL no 
     LABEL "Observa‡Æo Ponto Controle" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE lordens AS LOGICAL INITIAL no 
     LABEL "Ordens Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE lpeso-cub AS LOGICAL INITIAL no 
     LABEL "Pesos e Cubagens" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE tgDetalhaLi AS LOGICAL INITIAL no 
     LABEL "Detalha Licenciamentos de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
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
     SIZE 30.72 BY .92
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
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     ccod-estabel-ini AT ROW 1.75 COL 23 COLON-ALIGNED
     ccod-estabel-fim AT ROW 1.75 COL 50 COLON-ALIGNED NO-LABEL
     cembarque-ini AT ROW 2.75 COL 23 COLON-ALIGNED
     cembarque-fim AT ROW 2.75 COL 50 COLON-ALIGNED NO-LABEL
     cnr-proc-imp-ini AT ROW 3.75 COL 23 COLON-ALIGNED
     cnr-proc-imp-fim AT ROW 3.75 COL 50 COLON-ALIGNED NO-LABEL
     ccod-fornec-ini AT ROW 4.75 COL 23 COLON-ALIGNED
     ccod-fornec-fim AT ROW 4.75 COL 50 COLON-ALIGNED NO-LABEL
     ccod-itiner-ini AT ROW 5.75 COL 23 COLON-ALIGNED
     ccod-itiner-fim AT ROW 5.75 COL 50 COLON-ALIGNED NO-LABEL
     fiPtoSolicLiIni AT ROW 6.75 COL 23 COLON-ALIGNED
     fiPtoSolicLiFim AT ROW 6.75 COL 50 COLON-ALIGNED NO-LABEL
     ccod-embarque-ini AT ROW 7.75 COL 23 COLON-ALIGNED
     ccod-embarque-fim AT ROW 7.75 COL 50 COLON-ALIGNED NO-LABEL
     ccod-desemb-ini AT ROW 8.75 COL 23 COLON-ALIGNED
     ccod-desemb-fim AT ROW 8.75 COL 50 COLON-ALIGNED NO-LABEL
     ccod-grupo-ini AT ROW 9.75 COL 23 COLON-ALIGNED
     ccod-grupo-fim AT ROW 9.75 COL 50 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.75 COL 43
     IMAGE-113 AT ROW 9.75 COL 43
     IMAGE-114 AT ROW 9.75 COL 48
     IMAGE-2 AT ROW 1.75 COL 48
     IMAGE-31 AT ROW 2.75 COL 43
     IMAGE-32 AT ROW 2.75 COL 48
     IMAGE-33 AT ROW 3.75 COL 43
     IMAGE-34 AT ROW 3.75 COL 48
     IMAGE-35 AT ROW 4.75 COL 43
     IMAGE-36 AT ROW 4.75 COL 48
     IMAGE-37 AT ROW 5.75 COL 43
     IMAGE-38 AT ROW 5.75 COL 48
     IMAGE-39 AT ROW 6.75 COL 43
     IMAGE-40 AT ROW 6.75 COL 48
     IMAGE-43 AT ROW 8.75 COL 43
     IMAGE-44 AT ROW 8.75 COL 48
     IMAGE-49 AT ROW 7.75 COL 43
     IMAGE-50 AT ROW 7.75 COL 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage4
     ilocaliza AT ROW 1.38 COL 17.29 COLON-ALIGNED
     iMoeda AT ROW 2.38 COL 17.29 COLON-ALIGNED
     desc-moeda AT ROW 2.38 COL 21.72 COLON-ALIGNED NO-LABEL
     dtCotacao AT ROW 3.38 COL 17.29 COLON-ALIGNED
     da-data-ini AT ROW 4.38 COL 17.29 COLON-ALIGNED
     da-data-fim AT ROW 4.38 COL 35.43 COLON-ALIGNED NO-LABEL
     rs-situacao AT ROW 6.29 COL 42.57 NO-LABEL
     rs-processos AT ROW 6.71 COL 25.57 NO-LABEL
     rs-situacao-embarque AT ROW 6.75 COL 3.43 NO-LABEL
     rs-opcao AT ROW 11.25 COL 4 NO-LABEL
     "Situa‡Æo do Embarque:" VIEW-AS TEXT
          SIZE 16.14 BY .88 AT ROW 5.92 COL 3.14
     "Processos:" VIEW-AS TEXT
          SIZE 8 BY .88 AT ROW 6 COL 26
     " Imprime Unidade de Medida e Quantidade" VIEW-AS TEXT
          SIZE 30 BY .54 AT ROW 10.75 COL 4.43
     "Situa‡Æo do Processo:" VIEW-AS TEXT
          SIZE 15.86 BY .79 AT ROW 5.42 COL 43
     IMAGE-51 AT ROW 4.38 COL 30.43
     IMAGE-52 AT ROW 4.38 COL 33.86
     RECT-14 AT ROW 11 COL 2.86
     RECT-16 AT ROW 6.63 COL 2.72
     RECT-17 AT ROW 6.63 COL 24.72
     RECT-18 AT ROW 5.88 COL 42
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage3
     ccod-familia-ini AT ROW 1.75 COL 19 COLON-ALIGNED
     ccod-familia-fim AT ROW 1.75 COL 50 COLON-ALIGNED NO-LABEL
     cit-codigo-ini AT ROW 2.75 COL 19 COLON-ALIGNED
     cit-codigo-fim AT ROW 2.75 COL 50 COLON-ALIGNED NO-LABEL
     cfatura-ini AT ROW 3.75 COL 19 COLON-ALIGNED
     cfatura-fim AT ROW 3.75 COL 50 COLON-ALIGNED NO-LABEL
     c-nr-conhecto-master-ini AT ROW 4.75 COL 19 COLON-ALIGNED
     c-nr-conhecto-master-fim AT ROW 4.75 COL 50 COLON-ALIGNED NO-LABEL
     c-nr-conhecto-house-ini AT ROW 5.75 COL 19 COLON-ALIGNED
     c-nr-conhecto-house-fim AT ROW 5.75 COL 50 COLON-ALIGNED NO-LABEL
     c-veiculo-transp-ini AT ROW 6.75 COL 19 COLON-ALIGNED
     c-veiculo-transp-fim AT ROW 6.75 COL 50 COLON-ALIGNED NO-LABEL
     c-declar-import-ini AT ROW 7.75 COL 19 COLON-ALIGNED
     c-declar-import-fim AT ROW 7.75 COL 50 COLON-ALIGNED NO-LABEL
     fiLicencImportIni AT ROW 8.75 COL 19 COLON-ALIGNED
     fiLicencImportFim AT ROW 8.75 COL 50 COLON-ALIGNED NO-LABEL
     cx-via-trans-ini AT ROW 9.75 COL 19 COLON-ALIGNED WIDGET-ID 6
     cx-via-trans-fim AT ROW 9.75 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     IMAGE-105 AT ROW 4.75 COL 43
     IMAGE-106 AT ROW 4.75 COL 48
     IMAGE-107 AT ROW 7.75 COL 43
     IMAGE-108 AT ROW 7.75 COL 48
     IMAGE-109 AT ROW 6.75 COL 43
     IMAGE-110 AT ROW 6.75 COL 48
     IMAGE-111 AT ROW 5.75 COL 43
     IMAGE-112 AT ROW 5.75 COL 48
     IMAGE-115 AT ROW 8.75 COL 43
     IMAGE-116 AT ROW 8.75 COL 48
     IMAGE-45 AT ROW 1.75 COL 43
     IMAGE-46 AT ROW 1.75 COL 48
     IMAGE-47 AT ROW 2.75 COL 43
     IMAGE-48 AT ROW 2.75 COL 48
     IMAGE-53 AT ROW 3.75 COL 43
     IMAGE-54 AT ROW 3.75 COL 48
     IMAGE-121 AT ROW 9.75 COL 43 WIDGET-ID 8
     IMAGE-122 AT ROW 9.75 COL 48 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
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
     rsExecution AT ROW 5.75 COL 3.29 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.86 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage5
     litiner AT ROW 2.75 COL 6
     lobptocont AT ROW 3.75 COL 6
     lordens AT ROW 4.75 COL 6
     lpeso-cub AT ROW 5.75 COL 6
     tgDetalhaLi AT ROW 6.75 COL 6
     ldespesas AT ROW 7.75 COL 6
     rs-detalhe-desp AT ROW 8.75 COL 6 HELP
          "Modo de Execu‡Æo" NO-LABEL
     ldetalhadesp AT ROW 9.75 COL 6
     ladicembarq AT ROW 10.75 COL 6
     l-antecipacao AT ROW 11.75 COL 6 WIDGET-ID 2
     "Imprime:" VIEW-AS TEXT
          SIZE 6.29 BY .88 AT ROW 1.5 COL 6
     RECT-19 AT ROW 2 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
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
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN desc-moeda IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* SETTINGS FOR TOGGLE-BOX ldetalhadesp IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-detalhe-desp IN FRAME fPage5
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
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME dtCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dtCotacao wReport
ON LEAVE OF dtCotacao IN FRAME fPage4 /* Data Cota‡Æo */
DO:
  if input frame fPage4 dtcotacao = ? then
     assign dtcotacao:screen-value in frame fPage4 = string(today).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iMoeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iMoeda wReport
ON F5 OF iMoeda IN FRAME fPage4 /* Moeda */
DO:
      {method/zoomfields.i 
     &ProgramZoom="unzoom/z10un005.w"
     &FieldZoom1="mo-codigo"
     &FieldScreen1="imoeda"
     &Frame1="fPage4"
     &FieldZoom2="descricao"
     &FieldScreen2="desc-moeda"
     &Frame2="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iMoeda wReport
ON LEAVE OF iMoeda IN FRAME fPage4 /* Moeda */
DO:
    def var i-seq-erro as integer no-undo.
    for each tt-bo-erro no-lock:
        delete tt-bo-erro.
    end.   
    find moeda where moeda.mo-codigo = integer(imoeda:screen-value in frame fPage4) no-lock no-error.
    if not avail moeda then do:
/*        /* NAO ALTERAR - Distribuicao Magnus nao reconhece pre-processador em chamada de includes */
        {utp/ut-table.i mguni moeda 1}*/
        /****************************************************************************/    
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.    
    else 
        assign desc-moeda:screen-value in frame fPage4 = moeda.descricao.

    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.        

        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).        

        assign desc-moeda:screen-value in frame fPage4 = "".

        LEAVE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iMoeda wReport
ON MOUSE-SELECT-DBLCLICK OF iMoeda IN FRAME fPage4 /* Moeda */
DO:
  apply 'F5' to self in frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME ldespesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ldespesas wReport
ON VALUE-CHANGED OF ldespesas IN FRAME fPage5 /* Despesas Adicionais de Importa‡Æo */
DO:
    ASSIGN FRAME fPage5 ldespesas.
    IF  ldespesas THEN
        ENABLE rs-detalhe-desp 
               ldetalhadesp WITH FRAME fPage5.
    ELSE DO:
        DISABLE rs-detalhe-desp 
                ldetalhadesp WITH FRAME fPage5.
        ASSIGN ldetalhadesp:CHECKED IN FRAME fPage5 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME litiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL litiner wReport
ON VALUE-CHANGED OF litiner IN FRAME fPage5 /* Detalhes do Itiner rio */
DO:
    CASE SELF:SCREEN-VALUE:
        WHEN "Yes" THEN DO:
            ASSIGN lobptocont:SENSITIVE = YES.
        END.
        WHEN "No" THEN DO:
            ASSIGN lobptocont:SENSITIVE = NO.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-detalhe-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-detalhe-desp wReport
ON VALUE-CHANGED OF rs-detalhe-desp IN FRAME fPage5
DO:
    {report/rprse.i}
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

    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
    ON SHIFT-CTRL-TAB ANYWHERE
        RUN prevFolder IN hFolder.

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
    IF VALID-HANDLE(hFolder) THEN DO:
        DELETE PROCEDURE hFolder.
        ASSIGN hFolder = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterenablefields wReport 
PROCEDURE afterenablefields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE cFile WITH FRAME fPage6.   
    /*btFile btConfigImpr*/

    DISABLE desc-moeda   WITH FRAME fPage4.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wReport 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN dtCotacao:SCREEN-VALUE IN FRAME fPage4 = STRING(TODAY) 
           rs-opcao:SENSITIVE     IN FRAME fPage4 = TRUE.

    ASSIGN rs-detalhe-desp:SCREEN-VALUE in frame fPage5 = "2".

    ASSIGN c-nr-conhecto-master-ini:FORMAT       IN FRAME fPage3 = "x(18)"
           c-nr-conhecto-master-fim:FORMAT       IN FRAME fPage3 = "x(18)" 
           c-nr-conhecto-master-fim:SCREEN-VALUE IN FRAME fPage3 = "ZZZZZZZZZZZZZZZZZZ"
           c-nr-conhecto-house-ini:FORMAT        IN FRAME fPage3 = "x(18)"
           c-nr-conhecto-house-fim:FORMAT        IN FRAME fPage3 = "x(18)" 
           c-nr-conhecto-house-fim:SCREEN-VALUE  IN FRAME fPage3 = "ZZZZZZZZZZZZZZZZZZ".

    ASSIGN cx-via-trans-ini:SCREEN-VALUE IN FRAME fPage3 = ENTRY(1, cx-via-aux, ",")
           cx-via-trans-fim:SCREEN-VALUE IN FRAME fPage3 = ENTRY(num-entries(cx-via-aux), cx-via-aux, ",").

    ASSIGN l-antecipacao:HIDDEN IN FRAME fPage5 = NOT l-fn-antecipacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR cx-via-desc AS CHAR NO-UNDO.
    DEF VAR cx-via-cod  AS CHAR NO-UNDO.

    RUN utp/thinfolder.w PERSISTENT SET hFolder.

    RUN setOCX IN hFolder (INPUT THIS-PROCEDURE:GET-SIGNATURE("control_load":U) <> "":U) NO-ERROR.

    RUN initializeFolders IN hFolder (INPUT FRAME fPage0:HANDLE,
                                      INPUT STRING(FRAME fPage2:HANDLE) + ",":U +
                                            STRING(FRAME fPage3:HANDLE) + ",":U +
                                            STRING(FRAME fPage4:HANDLE) + ",":U +
                                            STRING(FRAME fPage5:HANDLE) + ",":U +
                                            STRING(FRAME fPage6:HANDLE),
                                      INPUT "{&FolderLabels}":U,
                                      INPUT NUM-ENTRIES("{&FolderLabels}":U),
                                      INPUT ?,
                                      INPUT ?,
                                      INPUT ?,
                                      INPUT FRAME fPage0:HEIGHT - FRAME fPage2:ROW - 0.75 ).
    RUN setFolder IN hFolder (INPUT {&InitialPage}).

    DO  i-cont = 1 TO NUM-ENTRIES({adinc/i01ad268.i 07}) BY 2:    

        ASSIGN cx-via-desc = ENTRY(i-cont, {adinc/i01ad268.i 07})
               cx-via-cod  = ENTRY(i-cont + 1, {adinc/i01ad268.i 07}).

        ASSIGN cx-via-aux = cx-via-aux + trim(cx-via-cod) + "-" + cx-via-desc.
        IF i-cont + 1 = NUM-ENTRIES({adinc/i01ad268.i 07}) THEN .
        ELSE ASSIGN cx-via-aux = cx-via-aux + ",".

    END.

    ASSIGN cx-via-trans-ini:LIST-ITEMS IN FRAME fPage3 = cx-via-aux
           cx-via-trans-fim:LIST-ITEMS IN FRAME fPage3 = cx-via-aux.

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

    DEFINE VARIABLE r-tt-digita AS ROWID NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF  INPUT FRAME fPage6 rsDestiny = 2 
        AND INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 73, 
                                   INPUT "":U).
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.

        ASSIGN FRAME fPage2            
                ccod-estabel-ini ccod-estabel-fim
                cembarque-ini cembarque-fim
                cnr-proc-imp-ini cnr-proc-imp-fim
                ccod-fornec-ini ccod-fornec-fim
                fiPtoSolicLiIni fiPtoSolicLiFim
                ccod-itiner-ini ccod-itiner-fim
                ccod-embarque-ini ccod-embarque-fim
                ccod-desemb-ini ccod-desemb-fim
                ccod-grupo-ini ccod-grupo-fim.

        ASSIGN FRAME fPage3
                ccod-familia-ini ccod-familia-fim
                cit-codigo-ini cit-codigo-fim
                cfatura-ini cfatura-fim
                c-nr-conhecto-master-ini
                c-nr-conhecto-master-fim
                c-nr-conhecto-house-ini
                c-nr-conhecto-house-fim
                c-declar-import-ini
                c-declar-import-fim
                c-veiculo-transp-ini
                c-veiculo-transp-fim
                fiLicencImportIni
                fiLicencImportfim
                cx-via-trans-ini
                cx-via-trans-fim.

        ASSIGN FRAME fPage4
                ilocaliza
                iMoeda
                dtCotacao
                da-data-ini da-data-fim    
                rs-processos rs-situacao-embarque
                rs-situacao.

        ASSIGN FRAME fPage5
                litiner 
                lobptocont 
                lordens     
                lpeso-cub
                tgDetalhaLi
                ldespesas 
                rs-detalhe-desp
                ldetalhadesp
                ladicembarq
                l-antecipacao.

        IF  fiPtoSolicLiIni > fiPtoSolicLiFim THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-solicita-li-inicial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Solicita_LI_Inicial" *}
            ASSIGN c-lbl-liter-ponto-solicita-li-inicial = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ponto-solicita-li-final AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Solicita_LI_Final" *}
            ASSIGN c-lbl-liter-ponto-solicita-li-final = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 5820,
                               INPUT c-lbl-liter-ponto-solicita-li-inicial + "~~" + c-lbl-liter-ponto-solicita-li-final).
            RUN setFolder IN hFolder (INPUT 1).
            APPLY "ENTRY":U TO fiPtoSolicLiIni IN FRAME fPage2.
            RETURN ERROR.
        END.    

        IF  fiLicencImportIni > fiLicencImportFim THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-licenciamento-importacao-inici AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Licenciamento_Importa‡Æo_Inicial" *}
            ASSIGN c-lbl-liter-licenciamento-importacao-inici = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-licenciamento-importacao-final AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Licenciamento_Importa‡Æo_Final" *}
            ASSIGN c-lbl-liter-licenciamento-importacao-final = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 5820,
                               INPUT c-lbl-liter-licenciamento-importacao-inici + "~~" + c-lbl-liter-licenciamento-importacao-final).
            RUN setFolder IN hFolder (INPUT 2).
            APPLY "ENTRY":U TO fiLicencImportIni IN FRAME fPage3.
            RETURN ERROR.
        END.    

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = input frame fPage6 rsDestiny
               tt-param.data-exec       = today
               tt-param.hora-exec       = time.

        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE 
            IF tt-param.destino = 2 THEN 
                ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
            ELSE 
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.

        ASSIGN  tt-param.ep-codigo           = i-ep-codigo-usuario
                tt-param.l-tipo              = litiner
                tt-param.l-observacao        = lobptocont
                tt-param.l-ordens            = lordens
                tt-param.l-adic-embarq       = ladicembarq
                tt-param.i-atraso            = rs-processos
                tt-param.i-situacao          = rs-situacao
                tt-param.i-sit-emb           = rs-situacao-embarque
                tt-param.dt-cotacao          = dtCotacao
                tt-param.da-data-ini         = da-data-ini
                tt-param.da-data-fim         = da-data-fim
                tt-param.c-est-ini           = ccod-estabel-ini
                tt-param.c-est-fim           = ccod-estabel-fim
                tt-param.c-proc-ini          = cnr-proc-imp-ini
                tt-param.c-proc-fim          = cnr-proc-imp-fim
                tt-param.i-exp-ini           = ccod-fornec-ini
                tt-param.i-exp-fim           = ccod-fornec-fim
                tt-param.i-itiner-ini        = ccod-itiner-ini
                tt-param.i-itiner-fim        = ccod-itiner-fim
                tt-param.i-pto-emb-ini       = ccod-embarque-ini
                tt-param.i-pto-emb-fim       = ccod-embarque-fim
                tt-param.i-pto-des-ini       = ccod-desemb-ini
                tt-param.i-pto-des-fim       = ccod-desemb-fim
                tt-param.i-local             = ilocaliza
                tt-param.moeda               = iMoeda
                tt-param.i-grupo-ini         = ccod-grupo-ini
                tt-param.i-grupo-fim         = ccod-grupo-fim
                tt-param.c-fam-ini           = ccod-familia-ini
                tt-param.c-fam-fim           = ccod-familia-fim
                tt-param.c-item-ini          = cit-codigo-ini
                tt-param.c-item-fim          = cit-codigo-fim
                tt-param.c-embarque-ini      = cembarque-ini
                tt-param.c-embarque-fim      = cembarque-fim
                tt-param.c-fatura-ini        = cfatura-ini
                tt-param.c-fatura-fim        = cfatura-fim
                tt-param.l-desp              = ldespesas
                tt-param.declar-import-ini   = c-declar-import-ini
                tt-param.declar-import-fim   = c-declar-import-fim
                tt-param.veiculo-transp-ini  = c-veiculo-transp-ini
                tt-param.veiculo-transp-fim  = c-veiculo-transp-fim
                tt-param.i-opcao             = input frame fPage4 rs-opcao.

        IF  ldespesas THEN
            ASSIGN tt-param.detalhe-desp      = rs-detalhe-desp
                   tt-param.l-detalha-despesa = ldetalhadesp.    

        ASSIGN tt-param.l-peso-cub             = lpeso-cub
               tt-param.nr-conhecto-master-ini = c-nr-conhecto-master-ini
               tt-param.nr-conhecto-master-fim = c-nr-conhecto-master-fim
               tt-param.nr-conhecto-house-ini  = c-nr-conhecto-house-ini
               tt-param.nr-conhecto-house-fim  = c-nr-conhecto-house-fim.

        ASSIGN tt-param.iPtoSolicLiIni   = fiPtoSolicLiIni
               tt-param.iPtoSolicLiFim   = fiPtoSolicLiFim 
               tt-param.cLicencImportIni = fiLicencImportIni
               tt-param.cLicencImportFim = fiLicencImportFim
               tt-param.lDetalhaLi       = tgDetalhaLi.

        IF l-fn-antecipacao THEN
           ASSIGN tt-param.lantecipacao     = l-antecipacao.

        DO  i-cont = 1 TO NUM-ENTRIES(cx-via-aux):
            IF  ENTRY(i-cont,cx-via-aux) = cx-via-trans-ini THEN
                ASSIGN tt-param.via-transp-ini = i-cont.
            
            IF  ENTRY(i-cont,cx-via-aux) = cx-via-trans-fim THEN
                ASSIGN tt-param.via-transp-fim = i-cont.
        END.

        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i imp/im0655rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

