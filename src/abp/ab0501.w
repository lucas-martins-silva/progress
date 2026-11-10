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
{include/i-prgvrs.i AB0501 2.00.00.006}  /*** 010006 ***/
{cdp/cdcfgmnt.i} /* Versäes EMS MNT */
{cdp/cd9911.i}  /* Varifica Unidade Neg¢cio */
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0501 MAB}
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
&GLOBAL-DEFINE Program       AB0501
&GLOBAL-DEFINE Version        2.00.00.006
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
&GLOBAL-DEFINE page2Widgets  fi-ep-codigo-ini ~ fi-ep-codigo-fim ~ fi-cod-eqpto-ini ~ fi-cod-eqpto-fim ~ fi-cod-grp-eqpto-ini ~ fi-cod-grp-eqpto-fim ~ fi-cod-model-ini ~ fi-cod-model-fim ~ fi-cod-estabel-ini ~ fi-cod-estabel-fim ~ fi-cd-tag-ini ~ fi-cd-tag-fim ~ fi-cod-prop-ini ~ fi-cod-prop-fim ~ fi-cod-estrut-mec-ini ~ fi-cod-estrut-mec-fim ~ fi-cc-codigo-ini ~ fi-cc-codigo-fim ~ fi-cod-sit-eqpto-ini ~ fi-cod-sit-eqpto-fim ~ fi-vli-ano-fabric-ini ~ fi-vli-ano-fabric-fim ~ fi-dat-cadastr-ini ~ fi-dat-cadastr-fim


&GLOBAL-DEFINE page3Widgets   rsClassif
&GLOBAL-DEFINE page4Widgets   rsDetalhe ~
                              tgMotorizados ~
                              tgNMotorizados ~
                              tgAtivos ~
                              tgInativos ~
                              tgProprios ~
                              tgTerceiros ~
                              tgCombust ~
                              tgCaract ~
                              tgComptes ~
                              tgHistor ~
                              tgEventos ~
                              tgPlanos ~
                              tgConfig ~
                              tgParam ~
                              tgInsere

                              
                              
                              
                              
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo  
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields  fi-ep-codigo-ini ~ fi-ep-codigo-fim ~ fi-cod-eqpto-ini ~ fi-cod-eqpto-fim ~ fi-cod-grp-eqpto-ini ~ fi-cod-grp-eqpto-fim ~ fi-cod-model-ini ~ fi-cod-model-fim ~ fi-cod-estabel-ini ~ fi-cod-estabel-fim ~ fi-cd-tag-ini ~ fi-cd-tag-fim ~ fi-cod-prop-ini ~ fi-cod-prop-fim ~ fi-cod-estrut-mec-ini ~ fi-cod-estrut-mec-fim ~ fi-cc-codigo-ini ~ fi-cc-codigo-fim ~ fi-cod-sit-eqpto-ini ~ fi-cod-sit-eqpto-fim ~ fi-vli-ano-fabric-ini ~ fi-vli-ano-fabric-fim ~ fi-dat-cadastr-ini ~ fi-dat-cadastr-fim

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
        field l-motorizados        as logical  
        field l-n-motorizados      as logical
        field l-ativos             as logical
        field l-Inativos           as logical 
        field l-proprios           as logical  
        field l-terceiros          as logical
        field l-combust            as logical
        field l-caract             as logical
        field l-comptes            as logical
        field l-hist               as logical  
        field l-eventos            as logical
        field l-planos             as logical
        field l-config             as logical 
        field l-param              as logical
        field l-Insere             as logical
        field i-cod-emp-ini        like mab-eqpto.ep-codigo
        field i-cod-emp-fim        like mab-eqpto.ep-codigo
        field c-cod-eqpto-ini      like mab-eqpto.cod-eqpto
        field c-cod-eqpto-fim      like mab-eqpto.cod-eqpto
        field c-grupo-ini          like mab-eqpto.cod-grp-eqpto
        field c-grupo-fim          like mab-eqpto.cod-grp-eqpto
        field c-modelo-ini         like mab-eqpto.cod-model
        field c-modelo-fim         like mab-eqpto.cod-model
        field c-estab-ini          like mab-eqpto.cod-estabel
        field c-estab-fim          like mab-eqpto.cod-estabel
        field c-tag-ini            like mab-eqpto.cd-tag
        field c-tag-fim            like mab-eqpto.cd-tag
        FIELD i-prop-ini           LIKE mab-eqpto.cod-emitente
        FIELD i-prop-fim           LIKE mab-eqpto.cod-emitente
        field c-estr-mec-ini       like mab-eqpto.cod-estrut-mec
        field c-estr-mec-fim       like mab-eqpto.cod-estrut-mec
        field c-ccusto-ini         like mab-eqpto.cc-codigo
        field c-ccusto-fim         like mab-eqpto.cc-codigo
        field c-sit-ini            like mab-eqpto.cod-sit-eqpto
        field c-sit-fim            like mab-eqpto.cod-sit-eqpto
        field i-ano-fab-ini        like mab-eqpto.vli-ano-fabric
        field i-ano-fab-fim        like mab-eqpto.vli-ano-fabric
        field dat-cadastr-ini      like mab-histor-ativid.dat-cadastro
        field dat-cadastr-fim      like mab-histor-ativid.dat-cadastro
      &IF DEFINED(bf_mnt_ems206b) &THEN
        FIELD c-cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
        FIELD c-cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
        FIELD l-matriz-un          AS LOGICAL
        FIELD l-detalha-un         AS LOGICAL
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

{abp/ab9000.i} /** Procedures de conversÆo de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

DEFINE VARIABLE cHora       AS CHARACTER FORMAT "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora2      AS CHARACTER FORMAT "23:59:59" NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc-ini AS CHARACTER INITIAL "":U    NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc-fim AS CHARACTER INITIAL "ZZZ":U NO-UNDO.
DEFINE VARIABLE l-considera-matriz   AS LOGICAL   INITIAL NO      NO-UNDO.
DEFINE VARIABLE l-detalha-unid-neg   AS LOGICAL   INITIAL NO      NO-UNDO.

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

DEFINE VARIABLE fi-cc-codigo-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cc-codigo-ini AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cd-tag-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cd-tag-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "TAG":R4 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-eqpto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-eqpto-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estrut-mec-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-estrut-mec-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Estrutura Mecƒnica":R22 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-grp-eqpto-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-grp-eqpto-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Grupo Equipamento":R21 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-model-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-model-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-prop-fim AS INTEGER FORMAT ">>>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE fi-cod-prop-ini AS INTEGER FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "Propriet rio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE fi-cod-sit-eqpto-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-sit-eqpto-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Situa‡Æo":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-cadastr-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-cadastr-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vli-ano-fabric-fim AS INTEGER FORMAT "9999" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-vli-ano-fabric-ini AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Ano Fabrica‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

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

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
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

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 1.42.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Equipamento", 1,
"Modelo", 2,
"Grupo", 3,
"Estrutura Mecƒnica", 4,
"Estabelecimento", 5,
"Tag", 6,
"Propriet rio", 7,
"Centro de Custo", 8,
"Unidade Neg¢cio", 9
     SIZE 27.86 BY 6.5
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 7.25.

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-expan.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-expan.bmp":U
     LABEL "" 
     SIZE 10 BY 1 TOOLTIP "Mais Parƒmetros".

DEFINE VARIABLE rsDetalhe AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Detalhado", 1,
"Resumido", 2
     SIZE 51 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 6.25.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 6.25.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.75.

DEFINE VARIABLE tgAtivos AS LOGICAL INITIAL yes 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgCaract AS LOGICAL INITIAL no 
     LABEL "Caracter¡stica" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tgCombust AS LOGICAL INITIAL no 
     LABEL "Combust¡vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgComptes AS LOGICAL INITIAL no 
     LABEL "Compartimentos/Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tgConfig AS LOGICAL INITIAL no 
     LABEL "Configura‡Æo dos Eixos" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tgEventos AS LOGICAL INITIAL no 
     LABEL "Eventos Programados" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tgHistor AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Transferˆncia Estab/Tags" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tgInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgInsere AS LOGICAL INITIAL no 
     LABEL "Inserir Quebra de P gina de acordo com a classifica‡Æo escolhida" 
     VIEW-AS TOGGLE-BOX
     SIZE 50.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgMotorizados AS LOGICAL INITIAL yes 
     LABEL "Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgNMotorizados AS LOGICAL INITIAL yes 
     LABEL "NÆo Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tgParam AS LOGICAL INITIAL yes 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgPlanos AS LOGICAL INITIAL no 
     LABEL "Planos de Manuten‡Æo Preventiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tgProprios AS LOGICAL INITIAL yes 
     LABEL "Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgTerceiros AS LOGICAL INITIAL no 
     LABEL "Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.14 BY .83 NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

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
         SIZE 90 BY 17.08
         FONT 1.

DEFINE FRAME fPage2
     fi-ep-codigo-ini AT ROW 1.04 COL 14.57 COLON-ALIGNED HELP
          ""
     fi-ep-codigo-fim AT ROW 1.04 COL 43 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-cod-eqpto-ini AT ROW 2.04 COL 14.57 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     fi-cod-eqpto-fim AT ROW 2.04 COL 43 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fi-cod-grp-eqpto-ini AT ROW 3.04 COL 15 COLON-ALIGNED HELP
          "C¢digo Grupo Equipamento"
     fi-cod-grp-eqpto-fim AT ROW 3.04 COL 43 COLON-ALIGNED HELP
          "C¢digo Grupo Equipamento" NO-LABEL
     fi-cod-model-ini AT ROW 4.04 COL 14.57 COLON-ALIGNED HELP
          "C¢digo do Modelo"
     fi-cod-model-fim AT ROW 4.04 COL 43 COLON-ALIGNED HELP
          "C¢digo do Modelo" NO-LABEL
     fi-cod-estabel-ini AT ROW 5.04 COL 14.57 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     fi-cod-estabel-fim AT ROW 5.04 COL 43 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-cd-tag-ini AT ROW 6.04 COL 14.57 COLON-ALIGNED HELP
          "Localiza‡Æo funcional (TAG)"
     fi-cd-tag-fim AT ROW 6.04 COL 43 COLON-ALIGNED HELP
          "Localiza‡Æo funcional (TAG)" NO-LABEL
     fi-cod-prop-ini AT ROW 7.04 COL 14.57 COLON-ALIGNED HELP
          "C¢digo do propriet rio do equipamento"
     fi-cod-prop-fim AT ROW 7.04 COL 43 COLON-ALIGNED HELP
          "C¢digo do propriet rio do equipamento" NO-LABEL
     fi-cod-estrut-mec-ini AT ROW 8.04 COL 14.72 COLON-ALIGNED HELP
          "C¢digo Estrutura Mecƒnica"
     fi-cod-estrut-mec-fim AT ROW 8.04 COL 43 COLON-ALIGNED HELP
          "C¢digo Estrutura Mecƒnica" NO-LABEL
     fi-cc-codigo-ini AT ROW 9.04 COL 14.57 COLON-ALIGNED HELP
          "C¢digo Centro Custo"
     fi-cc-codigo-fim AT ROW 9.04 COL 43 COLON-ALIGNED HELP
          "C¢digo Centro Custo" NO-LABEL
     fi-cod-sit-eqpto-ini AT ROW 10.04 COL 14.57 COLON-ALIGNED HELP
          "C¢digo da Situa‡Æo do Equipamento"
     fi-cod-sit-eqpto-fim AT ROW 10.04 COL 43 COLON-ALIGNED HELP
          "C¢digo da Situa‡Æo do Equipamento" NO-LABEL
     fi-vli-ano-fabric-ini AT ROW 11.04 COL 14.57 COLON-ALIGNED HELP
          "Ano Fabrica‡Æo"
     fi-vli-ano-fabric-fim AT ROW 11.04 COL 43 COLON-ALIGNED HELP
          "Ano Fabrica‡Æo" NO-LABEL
     btSelecao AT ROW 11.04 COL 60
     fi-dat-cadastr-ini AT ROW 12.79 COL 18.57 COLON-ALIGNED
     fi-dat-cadastr-fim AT ROW 12.79 COL 43 COLON-ALIGNED NO-LABEL
     "Hist¢rico Estabelecimento" VIEW-AS TEXT
          SIZE 18.72 BY .54 AT ROW 12.13 COL 11.29
     IMAGE-10 AT ROW 4.04 COL 41.14
     IMAGE-11 AT ROW 9.08 COL 36.72
     IMAGE-12 AT ROW 9.04 COL 41.14
     IMAGE-13 AT ROW 6.04 COL 36.72
     IMAGE-14 AT ROW 6.04 COL 41.14
     IMAGE-15 AT ROW 8.04 COL 36.72
     IMAGE-16 AT ROW 8.04 COL 41.14
     IMAGE-22 AT ROW 10.08 COL 36.72
     IMAGE-23 AT ROW 10.04 COL 41.14
     IMAGE-24 AT ROW 11.08 COL 36.72
     IMAGE-25 AT ROW 11.04 COL 41.14
     IMAGE-26 AT ROW 1.04 COL 36.72
     IMAGE-27 AT ROW 2.04 COL 36.72
     IMAGE-28 AT ROW 2.04 COL 41.14
     IMAGE-29 AT ROW 1.04 COL 41.14
     IMAGE-3 AT ROW 5.04 COL 36.72
     IMAGE-31 AT ROW 12.79 COL 37
     IMAGE-32 AT ROW 12.79 COL 41
     IMAGE-33 AT ROW 7.04 COL 36.72
     IMAGE-34 AT ROW 7.04 COL 41.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.96
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage2
     IMAGE-4 AT ROW 5.04 COL 41.14
     IMAGE-7 AT ROW 3.04 COL 36.72
     IMAGE-8 AT ROW 3.04 COL 41.14
     IMAGE-9 AT ROW 4.04 COL 36.72
     RECT-29 AT ROW 12.42 COL 9
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.96
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
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 5.29 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 2.96 COL 4.86 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
     "Classificar por" VIEW-AS TEXT
          SIZE 11 BY .88 AT ROW 2 COL 4.57
     RECT-13 AT ROW 2.38 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.71
         FONT 1.

DEFINE FRAME fPage4
     rsDetalhe AT ROW 2.5 COL 8 NO-LABEL
     tgMotorizados AT ROW 5.75 COL 8
     tgCombust AT ROW 5.75 COL 32
     tgNMotorizados AT ROW 6.5 COL 8
     tgCaract AT ROW 6.5 COL 32
     tgAtivos AT ROW 7.25 COL 8
     tgComptes AT ROW 7.25 COL 32
     tgInativos AT ROW 8 COL 8
     tgHistor AT ROW 8 COL 32
     tgProprios AT ROW 8.75 COL 8
     tgEventos AT ROW 8.75 COL 32
     tgTerceiros AT ROW 9.5 COL 8
     tgPlanos AT ROW 9.5 COL 32
     tgConfig AT ROW 10.25 COL 32
     tgParam AT ROW 11.92 COL 7.86
     btParam AT ROW 12.25 COL 62.57
     tgInsere AT ROW 12.67 COL 7.86
     "Relat¢rio" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.75 COL 6.57
     "Imprimir Equipamentos" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 4.92 COL 6
     "Dados do Equipamento" VIEW-AS TEXT
          SIZE 17.29 BY .54 AT ROW 4.92 COL 31.72
     RECT-24 AT ROW 5.25 COL 5
     RECT-26 AT ROW 11.75 COL 5
     RECT-27 AT ROW 5.25 COL 30
     RECT-28 AT ROW 2 COL 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.96
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
         TITLE              = "Listagem de Equipamentos"
         HEIGHT             = 17.08
         WIDTH              = 90
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
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN fi-cod-estabel-fim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-SIZE                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel-ini IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN fi-ep-codigo-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-ep-codigo-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
   L-To-R                                                               */
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
ON END-ERROR OF wReport /* Listagem de Equipamentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Listagem de Equipamentos */
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
&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wReport
ON CHOOSE OF btParam IN FRAME fPage4
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN abp/ab0501b.w(INPUT-OUTPUT l-considera-matriz,
                      INPUT-OUTPUT l-detalha-unid-neg).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    APPLY "ENTRY":U TO btParam IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wReport
ON CHOOSE OF btSelecao IN FRAME fPage2
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN abp/ab0501a.w(INPUT-OUTPUT c-cod-unid-negoc-ini,
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rsDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDetalhe wReport
ON VALUE-CHANGED OF rsDetalhe IN FRAME fPage4
DO:
   
  IF INPUT FRAME fPage4 rsDetalhe = 2 then do:
      
/*        assign rsClassif:sensitive in frame fPage3 = no  */
/*               rsClassif = 1.                            */
/*        disp rsClassif with frame fPage3.                */
/*                                                         */
       assign  tgCombust:sensitive in frame fPage4 = NO
               tgCaract:sensitive in frame fPage4 = NO
               tgComptes:sensitive in frame fPage4 = NO
               tgHistor:sensitive in frame fPage4 = NO
               tgEventos:sensitive in frame fPage4 = NO
               tgPlanos:sensitive in frame fPage4 = NO
               tgConfig:sensitive in frame fPage4 = NO
               tgCombust:checked in frame fPage4 = NO
               tgCaract:checked in frame fPage4 = NO
               tgComptes:checked in frame fPage4 = NO
               tgHistor:checked in frame fPage4 = NO
               tgEventos:checked in frame fPage4 = NO
               tgPlanos:checked in frame fPage4 = NO
               tgConfig:checked in frame fPage4 = NO.

              
     
  END.
  ELSE DO:

/*       assign rsClassif:sensitive in frame fPage3 = yes. */

       assign  tgCombust:sensitive in frame fPage4 = yes
               tgCaract:sensitive in frame fPage4 = yes
               tgComptes:sensitive in frame fPage4 = yes
               tgHistor:sensitive in frame fPage4 = yes
               tgEventos:sensitive in frame fPage4 = yes 
               tgPlanos:sensitive in frame fPage4 = yes 
               tgConfig:sensitive in frame fPage4 = yes.
               
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
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


/*--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN fi-ep-codigo-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-ep-codigo-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-cod-estabel-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

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

    ASSIGN btSelecao:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
           btSelecao:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
           btParam:VISIBLE     IN FRAME fPage4 = l-usa-unid-negoc
           btParam:SENSITIVE   IN FRAME fPage4 = l-usa-unid-negoc.

    IF NOT l-usa-unid-negoc THEN DO:
        rsClassif:DELETE("Unidade Neg¢cio") IN FRAME fPage3.
        ASSIGN btSelecao:TOOLTIP IN FRAME fPage2 = "":U
               btParam:TOOLTIP   IN FRAME fPage4 = "":U.
    END.        

    RUN setFolder IN hFolder (1).

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
    assign tt-param.usuario            = c-seg-usuario
           tt-param.destino            = input frame fPage6 rsDestiny
           tt-param.data-exec          = today
           tt-param.hora-exec          = time
           tt-param.classifica         = input frame fPage3 rsClassif
           tt-param.desc-classifica    = entry((tt-param.classifica - 1) * 2 + 1,       
                                             rsClassif:radio-buttons in frame fPage3)
           tt-param.rs-considera       = input frame fPage4 rsDetalhe
           tt-param.desc-considera     = entry((tt-param.rs-considera - 1) * 2 + 1,       
                                             rsDetalhe:radio-buttons in frame fPage4)
           tt-param.l-motorizados      = input frame fpage4  tgMotorizados  
           tt-param.l-n-motorizados    = input frame fpage4  tgNMotorizados  
           tt-param.l-ativos           = input frame fpage4  tgAtivos     
           tt-param.l-Inativos         = input frame fpage4  tgInativos  
           tt-param.l-proprios         = input frame fpage4  tgProprios  
           tt-param.l-terceiros        = input frame fpage4  tgTerceiros 
           tt-param.l-combust          = input frame fpage4  tgCombust             
           tt-param.l-caract           = input frame fpage4  tgCaract
           tt-param.l-comptes          = input frame fpage4  tgComptes   
           tt-param.l-hist             = input frame fpage4  tgHistor      
           tt-param.l-eventos          = input frame fpage4  tgEventos   
           tt-param.l-planos           = input frame fpage4  tgPlanos    
           tt-param.l-config           = input frame fpage4  tgConfig   
           tt-param.l-param            = input frame fpage4  tgParam  
           tt-param.l-Insere           = input frame fpage4  tgInsere     
           tt-param.i-cod-emp-ini      = input frame fpage2  fi-ep-codigo-ini       
           tt-param.i-cod-emp-fim      = input frame fpage2  fi-ep-codigo-fim       
           tt-param.c-cod-eqpto-ini    = input frame fpage2  fi-cod-eqpto-ini       
           tt-param.c-cod-eqpto-fim    = input frame fpage2  fi-cod-eqpto-fim       
           tt-param.c-grupo-ini        = input frame fpage2  fi-cod-grp-eqpto-ini   
           tt-param.c-grupo-fim        = input frame fpage2  fi-cod-grp-eqpto-fim   
           tt-param.c-modelo-ini       = input frame fpage2  fi-cod-model-ini       
           tt-param.c-modelo-fim       = input frame fpage2  fi-cod-model-fim       
           tt-param.c-estab-ini        = input frame fpage2  fi-cod-estabel-ini     
           tt-param.c-estab-fim        = input frame fpage2  fi-cod-estabel-fim     
           tt-param.c-tag-ini          = input frame fpage2  fi-cd-tag-ini           
           tt-param.c-tag-fim          = input frame fpage2  fi-cd-tag-fim 
           tt-param.i-prop-ini         = INPUT FRAME fpage2  fi-cod-prop-ini
           tt-param.i-prop-fim         = INPUT FRAME fpage2  fi-cod-prop-fim
           tt-param.c-estr-mec-ini     = input frame fpage2  fi-cod-estrut-mec-ini  
           tt-param.c-estr-mec-fim     = input frame fpage2  fi-cod-estrut-mec-fim  
           tt-param.c-ccusto-ini       = input frame fpage2  fi-cc-codigo-ini       
           tt-param.c-ccusto-fim       = input frame fpage2  fi-cc-codigo-fim       
           tt-param.c-sit-ini          = input frame fpage2  fi-cod-sit-eqpto-ini   
           tt-param.c-sit-fim          = input frame fpage2  fi-cod-sit-eqpto-fim   
           tt-param.i-ano-fab-ini      = input frame fpage2  fi-vli-ano-fabric-ini  
           tt-param.i-ano-fab-fim      = input frame fpage2  fi-vli-ano-fabric-fim    
           tt-param.dat-cadastr-ini    = input frame fpage2  fi-dat-cadastr-ini  
           tt-param.dat-cadastr-fim    = input frame fpage2  fi-dat-cadastr-fim.  

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
               tt-param.c-cod-unid-negoc-fim = c-cod-unid-negoc-fim
               tt-param.l-matriz-un          = l-considera-matriz
               tt-param.l-detalha-un         = l-detalha-unid-neg.
    &ENDIF

    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i abp/ab0501rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.
&ELSE
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

