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
{include/i-prgvrs.i AB0504 2.00.00.003} /*** "010003" 22/07/2024 08:07:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0504 MAB}
&ENDIF


/********************************************************************************
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
&GLOBAL-DEFINE Program       AB0504
&GLOBAL-DEFINE Version        2.00.00.003
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Classifica‡Æo,Parƒmetro,ImpressÆo

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
&GLOBAL-DEFINE page1Widgets                                 
&GLOBAL-DEFINE page2Widgets fi-estabelec-fim fi-estabelec-ini ~
                            fi-eqpto-fim fi-eqpto-ini ~
                            fi-grupo-fim fi-grupo-ini ~
                            fi-modelo-fim fi-modelo-ini ~
                            fi-tag-fim fi-tag-ini ~
                            fi-empresa-fim fi-empresa-ini ~
                            fi-estrut-mec-ini fi-estrut-mec-fim ~
                            fi-evento-ini fi-evento-fim ~
                            fi-sub-sist-ini fi-sub-sist-fim ~
                            fi-manut-ini fi-manut-fim ~
                            fi-dat-inicial-ini fi-dat-inicial-fim ~
                            fi-dat-final-ini fi-dat-final-fim ~
                            fi-cod-matr-ini fi-cod-matr-fim ~
                            fi-c-custo-ini fi-c-custo-fim
&GLOBAL-DEFINE page3Widgets   rsClassif
&GLOBAL-DEFINE page4Widgets   tgEqptosMot ~
                              tgEqptosNMot ~
                              tgEqptosAtivos ~
                              tgEqptosInativos ~
                              tgEqptosProp ~
                              tgEqptosTerc ~
                              tgEventNEn ~
                              tgEventEncerr ~
                              tgManutOleo ~
                              tgManutFiltros ~
                              tgManutMec ~
                              tgMotivoParada ~
                              tgCustos ~
                              tgOutros ~
                              tgInsere
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-param
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-modo-2 l-param
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fi-estabelec-fim ~ fi-estabelec-ini ~ fi-eqpto-ini ~ fi-eqpto-fim ~ fi-grupo-ini ~ fi-grupo-fim ~ fi-modelo-ini ~ fi-modelo-fim ~ fi-empresa-ini ~ fi-empresa-fim ~ fi-tag-ini ~ fi-tag-fim ~ fi-estrut-mec-ini ~ fi-estrut-mec-fim ~ fi-evento-ini ~ fi-evento-fim ~ fi-sub-sist-ini ~ fi-sub-sist-fim ~ fi-manut-ini ~ fi-manut-fim ~ fi-dat-inicial-ini ~ fi-dat-inicial-fim ~ fi-dat-final-ini ~ fi-dat-final-fim ~ fi-empresa-matr-ini ~ fi-empresa-matr-fim ~ fi-estabel-matr-ini ~ fi-estabel-matr-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
   DEF temp-table tt-param
        field destino              as integer
        field arquivo              as char
        field usuario              as char
        field data-exec            as date
        field hora-exec            as integer
        field parametro            as logical
        FIELD formato              as integer
        field v_num_tip_aces_usuar as integer
        field i-ep-codigo          LIKE mab-eqpto.ep-codigo
        field classifica           as integer
        field desc-classifica      as char format "x(40)"
        field rs-considera         as integer
        field desc-considera       as char format "x(40)"
        field  l-EqptosMot         as logical  
        field  l-EqptosNMot        as logical  
        field  l-EqptosAtivos      as logical  
        field  l-EqptosInativos    as logical  
        field  l-EqptosProp        as logical  
        field  l-EqptosTerc        as logical  
        field  l-EventNEnc         as logical  
        field  l-EventEncerr       as logical  
        field  l-ManutOleo         as logical  
        field  l-ManutFiltros      as logical  
        field  l-ManutMec          as logical  
        field  l-MotivoParada      as logical  
        field  l-Custos            as logical  
        field  l-Outros            as logical
        field  l-Insere            as logical
        field c-estabelec-ini      like mab-eqpto.cod-estabel
        field c-estabelec-fim      like mab-eqpto.cod-estabel
        field c-eqpto-ini          like mab-eqpto.cod-eqpto
        field c-eqpto-fim          like mab-eqpto.cod-eqpto
        field c-grupo-fim          like mab-eqpto.cod-grp-eqpto
        field c-grupo-ini          like mab-eqpto.cod-grp-eqpto
        field c-modelo-fim         like mab-eqpto.cod-model
        field c-modelo-ini         like mab-eqpto.cod-model
        field c-tag-fim            like mab-eqpto.cd-tag
        field c-tag-ini            like mab-eqpto.cd-tag
        field c-empresa-ini        like mab-eqpto.ep-codigo
        field c-empresa-fim        like mab-eqpto.ep-codigo
        field c-estrut-mec-ini     like mab-eqpto.cod-estrut-mec
        field c-estrut-mec-fim     like mab-eqpto.cod-estrut-mec
        field c-evento-ini         like mab-movto-event.cod-evento
        field c-evento-fim         like mab-movto-event.cod-evento
        field c-sub-sist-fim       like mab-movto-event.cod-sub-sist
        field c-sub-sist-ini       like mab-movto-event.cod-sub-sist
        field c-manut-ini          like mab-movto-event.cd-tipo
        field c-manut-fim          like mab-movto-event.cd-tipo
        field d-dat-inicial-ini    like mab-movto-event.dat-inicial
        field d-dat-inicial-fim    like mab-movto-event.dat-inicial 
        field d-dat-final-ini      like mab-movto-event.dat-final 
        field d-dat-final-fim      like mab-movto-event.dat-final
        FIELD c-empresa-matr-ini   LIKE mab-movto-event.ep-codigo-matr  
        FIELD c-empresa-matr-fim   LIKE mab-movto-event.ep-codigo-matr  
        FIELD c-estabel-matr-ini   LIKE mab-movto-event.cod-estabel-matr
        FIELD c-estabel-matr-fim   LIKE mab-movto-event.cod-estabel-matr
        field c-cod-matr-ini       like mab-movto-event.cod-matr
        field c-cod-matr-fim       like mab-movto-event.cod-matr
        FIELD c-custo-ini          LIKE mab-eqpto.cc-codigo
        FIELD c-custo-fim          LIKE mab-eqpto.cc-codigo
      &IF DEFINED(bf_mnt_ems206b) &THEN
        FIELD c-cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
        FIELD c-cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
      &ENDIF
        .

def temp-table tt-digita no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE VARIABLE c-cod-unid-negoc-ini AS CHARACTER INITIAL "":U    NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc-fim AS CHARACTER INITIAL "ZZZ":U NO-UNDO.

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

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-expan.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-expan.bmp":U
     LABEL "" 
     SIZE 10 BY 1 TOOLTIP "Mais Sele‡Æo".

DEFINE VARIABLE fi-c-custo-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-c-custo-ini AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R22 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cod-matr-fim AS CHARACTER FORMAT "X(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-matr-ini AS CHARACTER FORMAT "X(10)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-final-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-final-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Execu‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-inicial-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-inicial-ini AS DATE FORMAT "99/99/9999" INITIAL 07/18/03 
     LABEL "Abertura":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-empresa-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-matr-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-matr-ini LIKE empresa.ep-codigo
     LABEL "Motorista":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-eqpto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fi-eqpto-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fi-estabel-matr-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-matr-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabelec-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabelec-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estrut-mec-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-estrut-mec-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Estrutura Mecanica":R22 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-evento-fim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-evento-ini AS CHARACTER FORMAT "x(08)" 
     LABEL "Evento":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-grupo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-grupo-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Grupo":R21 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-manut-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-manut-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Tipo Manuten‡Æo":R18 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-modelo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-modelo-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo":R22 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-sub-sist-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-sub-sist-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Sub Sistema":R14 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-tag-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-tag-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Tag" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Equipamento", 1,
"Modelo", 2,
"Estabelecimento", 3,
"Evento", 4,
"Data", 5,
"SubSistema", 6,
"Unidade Neg¢cio", 7
     SIZE 27.86 BY 5.96
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 7.25.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 9.29.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 6.79.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 2.5.

DEFINE VARIABLE tgCustos AS LOGICAL INITIAL yes 
     LABEL "Custos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosAtivos AS LOGICAL INITIAL yes 
     LABEL "Equipamentos Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosInativos AS LOGICAL INITIAL no 
     LABEL "Equipamentos Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosMot AS LOGICAL INITIAL yes 
     LABEL "Equipamentos Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosNMot AS LOGICAL INITIAL yes 
     LABEL "Equipamentos nÆo Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosProp AS LOGICAL INITIAL yes 
     LABEL "Equipamentos Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgEqptosTerc AS LOGICAL INITIAL no 
     LABEL "Equipamentos Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgEventEncerr AS LOGICAL INITIAL no 
     LABEL "Eventos Encerrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgEventNEn AS LOGICAL INITIAL no 
     LABEL "Eventos NÆo Encerrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgInsere AS LOGICAL INITIAL no 
     LABEL "Inserir quebra de P gina" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tgManutFiltros AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tgManutMec AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo Mecƒnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgManutOleo AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo àleo" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgMotivoParada AS LOGICAL INITIAL no 
     LABEL "Motivos Parada" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgOutros AS LOGICAL INITIAL yes 
     LABEL "Outros" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY .83 NO-UNDO.

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

DEFINE VARIABLE text-modo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 18.14 BY .63
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
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-param AS LOGICAL INITIAL no 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.25 COL 2
     btCancel AT ROW 18.25 COL 13
     btHelp2 AT ROW 18.25 COL 80
     rtToolBar AT ROW 18.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 18.54
         FONT 1.
         
DEFINE FRAME fPage2
     fi-empresa-ini AT ROW 1.21 COL 14.72 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 1.21 COL 46.14 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-eqpto-ini AT ROW 2.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo do equipamento"
     fi-eqpto-fim AT ROW 2.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fi-grupo-ini AT ROW 3.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo Grupo Equipamento"
     fi-grupo-fim AT ROW 3.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo Grupo Equipamento" NO-LABEL
     fi-modelo-ini AT ROW 4.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo Modelo Equipamento"
     fi-modelo-fim AT ROW 4.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo Modelo Equipamento" NO-LABEL
     fi-estabelec-ini AT ROW 5.21 COL 4.72 HELP
          ""
          LABEL "Estabelecimento":R15
     fi-estabelec-fim AT ROW 5.21 COL 46.14 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-tag-ini AT ROW 6.21 COL 14.72 COLON-ALIGNED
     fi-tag-fim AT ROW 6.21 COL 46.14 COLON-ALIGNED HELP
          "Localiza‡Æo funcional (TAG)" NO-LABEL
     fi-c-custo-ini AT ROW 7.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo Centro de Custo"
     fi-c-custo-fim AT ROW 7.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo do SubSistema" NO-LABEL
     fi-estrut-mec-ini AT ROW 8.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo Estrutura Mecƒnica"
     fi-estrut-mec-fim AT ROW 8.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo Estrutura Mecƒnica" NO-LABEL
     fi-evento-ini AT ROW 9.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo do evento programado"
     fi-evento-fim AT ROW 9.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo do evento programado" NO-LABEL
     fi-sub-sist-ini AT ROW 10.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo do SubSistema"
     fi-sub-sist-fim AT ROW 10.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo do SubSistema" NO-LABEL
     fi-manut-ini AT ROW 11.21 COL 14.72 COLON-ALIGNED HELP
          "C¢digo do Tipo de Manuten‡Æo"
     fi-manut-fim AT ROW 11.21 COL 46.14 COLON-ALIGNED HELP
          "C¢digo do Tipo de Manuten‡Æo" NO-LABEL
     fi-dat-inicial-ini AT ROW 12.21 COL 14.72 COLON-ALIGNED HELP
          "Data de Abertura do apontamento do evento"
     fi-dat-inicial-fim AT ROW 12.21 COL 46.14 COLON-ALIGNED HELP
          "Data de Abertura do apontamento do evento" NO-LABEL
     fi-dat-final-ini AT ROW 13.21 COL 14.72 COLON-ALIGNED HELP
          "Data de encerramento do evento"
     fi-dat-final-fim AT ROW 13.21 COL 46.14 COLON-ALIGNED HELP
          "Data de encerramento do evento" NO-LABEL
     fi-empresa-matr-ini AT ROW 14.21 COL 14.72 COLON-ALIGNED HELP
          ""
          LABEL "Motorista":R9
     fi-estabel-matr-ini AT ROW 14.21 COL 20 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-cod-matr-ini AT ROW 14.21 COL 25.14 COLON-ALIGNED HELP
          "C¢digo Motorista" NO-LABEL
     fi-empresa-matr-fim AT ROW 14.21 COL 46.14 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-estabel-matr-fim AT ROW 14.21 COL 51.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-cod-matr-fim AT ROW 14.21 COL 57 COLON-ALIGNED HELP
          "C¢digo Motorista" NO-LABEL
     btSelecao AT ROW 14.21 COL 69.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 79 BY 14.46
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage2
     IMAGE-10 AT ROW 2.21 COL 42.86
     IMAGE-11 AT ROW 6.21 COL 38.43
     IMAGE-12 AT ROW 6.21 COL 42.86
     IMAGE-13 AT ROW 4.21 COL 38.43
     IMAGE-14 AT ROW 4.21 COL 42.86
     IMAGE-15 AT ROW 5.21 COL 38.43
     IMAGE-16 AT ROW 5.21 COL 42.86
     IMAGE-22 AT ROW 7.21 COL 38.43
     IMAGE-23 AT ROW 7.21 COL 43
     IMAGE-24 AT ROW 8.21 COL 38.43
     IMAGE-25 AT ROW 8.21 COL 43
     IMAGE-26 AT ROW 11.21 COL 38.43
     IMAGE-27 AT ROW 12.21 COL 38.43
     IMAGE-28 AT ROW 10.21 COL 38.43
     IMAGE-29 AT ROW 9.21 COL 38.43
     IMAGE-3 AT ROW 3.21 COL 38.43
     IMAGE-30 AT ROW 11.21 COL 43.43
     IMAGE-31 AT ROW 12.21 COL 43.43
     IMAGE-32 AT ROW 10.21 COL 43.29
     IMAGE-33 AT ROW 9.21 COL 43.29
     IMAGE-39 AT ROW 13.21 COL 38.43
     IMAGE-4 AT ROW 3.21 COL 42.86
     IMAGE-40 AT ROW 13.21 COL 43.43
     IMAGE-49 AT ROW 14.21 COL 38.43
     IMAGE-50 AT ROW 14.21 COL 43.29
     IMAGE-7 AT ROW 1.21 COL 38.43
     IMAGE-8 AT ROW 1.21 COL 42.86
     IMAGE-9 AT ROW 2.21 COL 38.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 79 BY 14.46
         FONT 1.
         
DEFINE FRAME fPage4
     tgEqptosMot AT ROW 2 COL 5
     tgEqptosNMot AT ROW 3 COL 5
     tgEqptosAtivos AT ROW 4 COL 5
     tgEqptosInativos AT ROW 5 COL 5
     tgEqptosProp AT ROW 6 COL 5
     tgEqptosTerc AT ROW 7 COL 5
     tgEventNEn AT ROW 8 COL 5
     tgEventEncerr AT ROW 9 COL 5
     tgManutOleo AT ROW 2.25 COL 45
     tgManutFiltros AT ROW 3.25 COL 45
     tgManutMec AT ROW 4.25 COL 45
     tgMotivoParada AT ROW 5.25 COL 45 WIDGET-ID 2
     tgCustos AT ROW 6.25 COL 45
     tgOutros AT ROW 7.25 COL 45
     tgInsere AT ROW 9.25 COL 46
     "Imprimir Grupo de Eventos" VIEW-AS TEXT
          SIZE 18.43 BY .54 AT ROW 1.46 COL 45.57
     RECT-24 AT ROW 1.71 COL 3
     RECT-25 AT ROW 1.71 COL 44
     RECT-26 AT ROW 8.5 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 13.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     l-param AT ROW 8.13 COL 4
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-modo-2 AT ROW 7.38 COL 1.86 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 5.29 COL 2.14
     RECT-11 AT ROW 7.58 COL 2.29
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 13.96
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 3.21 COL 4.86 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
     "Classificar por" VIEW-AS TEXT
          SIZE 11 BY .88 AT ROW 2 COL 4.57
     RECT-13 AT ROW 2.38 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 13.96
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
         TITLE              = "Apontamentos de Eventos"
         HEIGHT             = 18.54
         WIDTH              = 90.29
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-empresa-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-empresa-matr-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-matr-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                           */
/* SETTINGS FOR FILL-IN fi-estabel-matr-fim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estabel-matr-ini IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estabelec-fim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estabelec-ini IN FRAME fPage2
   ALIGN-L LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-modo-2:PRIVATE-DATA IN FRAME fPage6     = 
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
ON END-ERROR OF wReport /* Apontamentos de Eventos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Apontamentos de Eventos */
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wReport
ON CHOOSE OF btSelecao IN FRAME fPage2
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN abp/ab0504a.w (INPUT-OUTPUT c-cod-unid-negoc-ini, 
                       INPUT-OUTPUT c-cod-unid-negoc-fim).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    APPLY "ENTRY":U TO btSelecao IN FRAME fPage2.
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


assign  fi-dat-inicial-ini = TODAY - 30.
assign  fi-dat-final-ini = today.

ASSIGN fi-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-empresa-matr-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-empresa-matr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-estabelec-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF
       fi-estabel-matr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.
       

/*--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign fi-dat-inicial-ini = TODAY - 30.
ASSIGN fi-dat-final-ini   = TODAY.

ASSIGN btSelecao:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       btSelecao:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc.

IF NOT l-usa-unid-negoc THEN DO:
    rsClassif:DELETE("Unidade Neg¢cio") IN FRAME fPage3.
    ASSIGN btSelecao:TOOLTIP IN FRAME fPage2 = "":U.
END.

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

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
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
    assign tt-param.usuario              = c-seg-usuario
           tt-param.destino               = input frame fPage6 rsDestiny
           tt-param.data-exec             = today
           tt-param.hora-exec             = time
           tt-param.classifica            = input frame fPage3 rsClassif
           tt-param.desc-classifica       = entry((tt-param.classifica - 1) * 2 + 1,       
                                               rsClassif:radio-buttons in frame fPage3)
            tt-param.l-EqptosMot          = input frame fpage4 tgEqptosMot      
            tt-param.l-EqptosNMot         = input frame fpage4 tgEqptosNMot     
            tt-param.l-EqptosAtivos       = input frame fpage4 tgEqptosAtivos   
            tt-param.l-EqptosInativos     = input frame fpage4 tgEqptosInativos 
            tt-param.l-EqptosProp         = input frame fpage4 tgEqptosProp     
            tt-param.l-EqptosTerc         = input frame fpage4 tgEqptosTerc    
            tt-param.l-EventNEnc          = input frame fpage4 tgEventNEn       
            tt-param.l-EventEncerr        = input frame fpage4 tgEventEncerr    
            tt-param.l-ManutOleo          = input frame fpage4 tgManutOleo      
            tt-param.l-ManutFiltros       = input frame fpage4 tgManutFiltros   
            tt-param.l-ManutMec           = input frame fpage4 tgManutMec       
            tt-param.l-MotivoParada       = input frame fpage4 tgMotivoParada     
            tt-param.l-Custos             = input frame fpage4 tgCustos         
            tt-param.l-Outros             = input frame fpage4 tgOutros
            tt-param.l-Insere             = input frame fpage4 tgInsere          
            tt-param.c-estabelec-ini      = input frame fpage2 fi-estabelec-ini 
            tt-param.c-estabelec-fim      = input frame fpage2 fi-estabelec-fim      
            tt-param.c-eqpto-ini          = input frame fpage2 fi-eqpto-ini     
            tt-param.c-eqpto-fim          = input frame fpage2 fi-eqpto-fim      
            tt-param.c-grupo-fim          = input frame fpage2 fi-grupo-fim        
            tt-param.c-grupo-ini          = input frame fpage2 fi-grupo-ini        
            tt-param.c-modelo-fim         = input frame fpage2 fi-modelo-fim        
            tt-param.c-modelo-ini         = input frame fpage2 fi-modelo-ini        
            tt-param.c-tag-fim            = input frame fpage2 fi-tag-fim          
            tt-param.c-tag-ini            = input frame fpage2 fi-tag-ini          
            tt-param.c-empresa-ini        = input frame fpage2 fi-empresa-ini       
            tt-param.c-empresa-fim        = input frame fpage2 fi-empresa-fim    
            tt-param.c-estrut-mec-ini     = input frame fpage2 fi-estrut-mec-ini  
            tt-param.c-estrut-mec-fim     = input frame fpage2 fi-estrut-mec-fim  
            tt-param.c-evento-ini         = input frame fpage2 fi-evento-ini      
            tt-param.c-evento-fim         = input frame fpage2 fi-evento-fim      
            tt-param.c-sub-sist-fim       = input frame fpage2 fi-sub-sist-fim       
            tt-param.c-sub-sist-ini       = input frame fpage2 fi-sub-sist-ini      
            tt-param.c-manut-ini          = input frame fpage2 fi-manut-ini
            tt-param.c-manut-fim          = input frame fpage2 fi-manut-fim
            tt-param.d-dat-inicial-ini    = input frame fpage2 fi-dat-inicial-ini
            tt-param.d-dat-inicial-fim    = input frame fpage2 fi-dat-inicial-fim
            tt-param.d-dat-final-ini      = input frame fpage2 fi-dat-final-ini  
            tt-param.d-dat-final-fim      = input frame fpage2 fi-dat-final-fim
            tt-param.c-empresa-matr-ini   = INPUT FRAME fpage2 fi-empresa-matr-ini
            tt-param.c-empresa-matr-fim   = input frame fpage2 fi-empresa-matr-fim
            tt-param.c-estabel-matr-ini   = input frame fpage2 fi-estabel-matr-ini
            tt-param.c-estabel-matr-fim   = INPUT FRAME fpage2 fi-estabel-matr-fim
            tt-param.c-cod-matr-ini       = input frame fpage2 fi-cod-matr-ini
            tt-param.c-cod-matr-fim       = input frame fpage2 fi-cod-matr-fim
            tt-param.c-custo-ini          = input frame fpage2 fi-c-custo-ini
            tt-param.c-custo-fim          = input frame fpage2 fi-c-custo-fim
            tt-param.parametro            = input frame fpage6 l-param.

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    &IF DEFINED(bf_mnt_ems206b) &THEN
        ASSIGN tt-param.c-cod-unid-negoc-ini = c-cod-unid-negoc-ini
               tt-param.c-cod-unid-negoc-fim = c-cod-unid-negoc-fim.
    &ENDIF


    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    

    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0504rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

