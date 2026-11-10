&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ems2cad          PROGRESS
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
{include/i-prgvrs.i AB0508 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0508 MAB}
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
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AB0508
&GLOBAL-DEFINE Version        2.00.00.001
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
&GLOBAL-DEFINE page2Widgets   fi-num-viagem-ini fi-num-viagem-fim ~
                              fi-dat-saida-ini fi-dat-saida-fim ~
                              fi-hra-saida-ini fi-hra-saida-fim ~
                              fi-dat-ret-ini fi-dat-ret-fim ~
                              fi-hra-ret-ini fi-hra-ret-fim ~
                              fi-num-reserva-ini fi-num-reserva-fim ~
                              fi-cod-rota-ini fi-cod-rota-fim ~
                              fi-ep-codigo-ini fi-ep-codigo-fim ~
                              fi-cod-eqpto-ini fi-cod-eqpto-fim ~
                              fiEmpresaMatr-ini fiEmpresaMatr-fim ~
                              fiEstabelMatr-ini fiEstabelMatr-fim ~
                              fi-cod-matr-ini fi-cod-matr-fim ~
                              fi-cod-grp-eqpto-ini fi-cod-grp-eqpto-fim

&GLOBAL-DEFINE page3Widgets   rsClassif
&GLOBAL-DEFINE page4Widgets   tgViagemAnd ~
                              tgViagemConcl ~
                              tgViagemKmAc ~
                              tgObservacao ~
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
&GLOBAL-DEFINE page2Fields    fi-num-viagem-ini ~ fi-num-viagem-fim ~
                              fi-dat-saida-ini ~ fi-dat-saida-fim ~
                              fi-hra-saida-ini ~ fi-hra-saida-fim ~
                              fi-dat-ret-ini ~ fi-dat-ret-fim ~
                              fi-hra-ret-ini ~ fi-hra-ret-fim ~
                              fi-num-reserva-ini ~ fi-num-reserva-fim ~
                              fi-cod-rota-ini ~ fi-cod-rota-fim ~
                              fi-ep-codigo-ini ~ fi-ep-codigo-fim ~
                              fi-cod-eqpto-ini ~ fi-cod-eqpto-fim ~
                              fi-cod-matr-ini ~ fi-cod-matr-fim ~
                              fi-cod-grp-eqpto-ini ~ fi-cod-grp-eqpto-fim
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
        field i-ep-codigo          LIKE mab-viagem.ep-codigo
        field classifica           as integer
        field desc-classifica      as char format "x(40)"
        field rs-considera         as integer
        field desc-considera       as char format "x(40)"
        field l-ViagemAnd          as logical  
        field l-ViagemConcl        as logical
        field l-ViagemKmAc         as logical
        field l-Insere             as logical
        FIELD l-ImprimeObs         AS LOGICAL
        field i-viagem-ini         like mab-viagem.num-viagem
        field i-viagem-fim         like mab-viagem.num-viagem
        field d-dt-saida-ini       like mab-viagem.dat-saida
        field d-dt-saida-fim       like mab-viagem.dat-saida
        field c-hr-saida-ini       like mab-viagem.hra-saida
        field c-hr-saida-fim       like mab-viagem.hra-saida
        field d-dt-ret-ini         like mab-viagem.dat-ret
        field d-dt-ret-fim         like mab-viagem.dat-ret
        field c-hr-ret-ini         like mab-viagem.hra-ret
        field c-hr-ret-fim         like mab-viagem.hra-ret
        field i-reserva-ini        like mab-viagem.num-reserva
        field i-reserva-fim        like mab-viagem.num-reserva
        field c-rota-ini           like mab-viagem.cod-rota
        field c-rota-fim           like mab-viagem.cod-rota
        field i-cod-emp-ini        like mab-viagem.ep-codigo
        field i-cod-emp-fim        like mab-viagem.ep-codigo
        field c-cod-eqpto-ini      like mab-viagem.cod-eqpto
        field c-cod-eqpto-fim      like mab-viagem.cod-eqpto
        FIELD c-empresa-matr-ini   LIKE mab-viagem.ep-codigo-matr
        FIELD c-empresa-matr-fim   LIKE mab-viagem.ep-codigo-matr
        FIELD c-estabel-matr-ini   LIKE mab-viagem.cod-estabel-matr
        FIELD c-estabel-matr-fim   LIKE mab-viagem.cod-estabel-matr
        field c-cod-matr-ini       like mab-viagem.cod-matr
        field c-cod-matr-fim       like mab-viagem.cod-matr
        FIELD c-cod-grp-eqpto-ini  LIKE mab-eqpto.cod-grp-eqpto
        FIELD c-cod-grp-eqpto-fim  LIKE mab-eqpto.cod-grp-eqpto.
        

        

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

DEFINE VARIABLE cHora       AS CHARACTER format "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora2      AS CHARACTER format "23:59:59" NO-UNDO.

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

DEFINE VARIABLE fi-cod-eqpto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-eqpto-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-grp-eqpto-fim AS CHARACTER FORMAT "x(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-grp-eqpto-ini AS CHARACTER FORMAT "x(10)" 
     LABEL "Grupo Eqpto":R11 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-matr-fim AS CHARACTER FORMAT "x(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-matr-ini AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-rota-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-rota-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Trajeto":R9 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-ret-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-ret-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Retorno":R9 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-saida-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-saida-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Sa¡da":R12 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-ep-codigo-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-ret-fim AS CHARACTER FORMAT "99:99:99" INITIAL "235959" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-hra-ret-ini AS CHARACTER FORMAT "99:99:99" INITIAL "000000" 
     LABEL "Hora":R5 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-hra-saida-fim AS CHARACTER FORMAT "99:99:99" INITIAL "235959" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-hra-saida-ini AS CHARACTER FORMAT "99:99:99" INITIAL "000000" 
     LABEL "Hora Sa¡da":R5 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-reserva-fim AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-reserva-ini AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 
     LABEL "Documento Reserva" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-viagem-fim AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-viagem-ini AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 
     LABEL "Documento Viagem" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fiEmpresaMatr-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpresaMatr-ini LIKE empresa.ep-codigo
     LABEL "Motorista":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabelMatr-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabelMatr-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
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

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento Viagem", 1,
"Data/Hora Sa¡da", 2,
"Data/Hora Retorno", 3,
"Empresa/Equipamento", 4,
"Grupo Equipamento", 5
     SIZE 27.86 BY 7.04
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31 BY 8.38.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 5.29.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51.14 BY 1.5.

DEFINE VARIABLE tgInsere AS LOGICAL INITIAL no 
     LABEL "Inserir Quebra de P gina de acordo com a classifica‡Æo escolhida" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .83 NO-UNDO.

DEFINE VARIABLE tgObservacao AS LOGICAL INITIAL no 
     LABEL "Imprime Observa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tgViagemAnd AS LOGICAL INITIAL yes 
     LABEL "Viagens em Andamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgViagemConcl AS LOGICAL INITIAL yes 
     LABEL "Viagens Conclu¡das" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgViagemKmAc AS LOGICAL INITIAL no 
     LABEL "Viagens com KM acima do estimado na Reserva" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .83 NO-UNDO.

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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage2
     fi-num-viagem-ini AT ROW 1.5 COL 18 COLON-ALIGNED HELP
          "N£mero Viagem"
     fi-num-viagem-fim AT ROW 1.5 COL 47 COLON-ALIGNED HELP
          "N£mero Viagem" NO-LABEL
     fi-dat-saida-ini AT ROW 2.5 COL 18 COLON-ALIGNED HELP
          "Data da Sa¡da do Equipamento"
     fi-dat-saida-fim AT ROW 2.5 COL 47 COLON-ALIGNED HELP
          "Data da Sa¡da do Equipamento" NO-LABEL
     fi-hra-saida-ini AT ROW 3.5 COL 18 COLON-ALIGNED HELP
          "Hora Sa¡da"
     fi-hra-saida-fim AT ROW 3.5 COL 47 COLON-ALIGNED HELP
          "Hora Sa¡da" NO-LABEL
     fi-dat-ret-ini AT ROW 4.5 COL 18 COLON-ALIGNED HELP
          "Data Retorno"
     fi-dat-ret-fim AT ROW 4.5 COL 47 COLON-ALIGNED HELP
          "Data Retorno" NO-LABEL
     fi-hra-ret-ini AT ROW 5.5 COL 18 COLON-ALIGNED HELP
          "Hora Retorno"
     fi-hra-ret-fim AT ROW 5.5 COL 47 COLON-ALIGNED HELP
          "Hora Retorno" NO-LABEL
     fi-num-reserva-ini AT ROW 6.5 COL 18 COLON-ALIGNED HELP
          "N£mero Reserva"
     fi-num-reserva-fim AT ROW 6.5 COL 47 COLON-ALIGNED HELP
          "N£mero Reserva" NO-LABEL
     fi-cod-rota-ini AT ROW 7.5 COL 18 COLON-ALIGNED HELP
          "C¢digo do trajeto"
     fi-cod-rota-fim AT ROW 7.5 COL 47 COLON-ALIGNED HELP
          "C¢digo do trajeto" NO-LABEL
     fi-ep-codigo-ini AT ROW 8.5 COL 18 COLON-ALIGNED
     fi-ep-codigo-fim AT ROW 8.5 COL 47 COLON-ALIGNED NO-LABEL
     fi-cod-eqpto-ini AT ROW 9.5 COL 18 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     fi-cod-eqpto-fim AT ROW 9.5 COL 47 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fiEmpresaMatr-ini AT ROW 10.5 COL 18 COLON-ALIGNED
          LABEL "Motorista":R9
     fiEstabelMatr-ini AT ROW 10.5 COL 23 COLON-ALIGNED NO-LABEL
     fi-cod-matr-ini AT ROW 10.5 COL 28 COLON-ALIGNED HELP
          "C¢digo Motorista" NO-LABEL
     fiEmpresaMatr-fim AT ROW 10.5 COL 47 COLON-ALIGNED NO-LABEL
     fiEstabelMatr-fim AT ROW 10.5 COL 52.14 COLON-ALIGNED NO-LABEL
     fi-cod-matr-fim AT ROW 10.5 COL 57.14 COLON-ALIGNED HELP
          "C¢digo Motorista" NO-LABEL
     fi-cod-grp-eqpto-ini AT ROW 11.5 COL 18 COLON-ALIGNED HELP
          "C¢digo do Motorista"
     fi-cod-grp-eqpto-fim AT ROW 11.5 COL 47 COLON-ALIGNED HELP
          "C¢digo do Motorista" NO-LABEL
     IMAGE-10 AT ROW 4.5 COL 45.14
     IMAGE-11 AT ROW 8.5 COL 40.72
     IMAGE-12 AT ROW 8.5 COL 45.14
     IMAGE-13 AT ROW 6.5 COL 40.72
     IMAGE-14 AT ROW 6.5 COL 45.14
     IMAGE-15 AT ROW 7.5 COL 40.72
     IMAGE-16 AT ROW 7.5 COL 45.14
     IMAGE-22 AT ROW 9.5 COL 40.72
     IMAGE-23 AT ROW 9.5 COL 45.29
     IMAGE-26 AT ROW 1.5 COL 40.72
     IMAGE-27 AT ROW 2.5 COL 40.72
     IMAGE-28 AT ROW 2.5 COL 45.14
     IMAGE-29 AT ROW 1.5 COL 45.14
     IMAGE-3 AT ROW 5.5 COL 40.72
     IMAGE-4 AT ROW 5.5 COL 45.14
     IMAGE-7 AT ROW 3.5 COL 40.72
     IMAGE-8 AT ROW 3.5 COL 45.14
     IMAGE-9 AT ROW 4.5 COL 40.72
     IMAGE-41 AT ROW 10.5 COL 40.72
     IMAGE-42 AT ROW 10.5 COL 45.29
     IMAGE-43 AT ROW 11.5 COL 40.72
     IMAGE-44 AT ROW 11.5 COL 45.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.75
         SIZE 76.86 BY 13
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
         SIZE 76.86 BY 13
         FONT 1.

DEFINE FRAME fPage4
     tgObservacao AT ROW 5.5 COL 7.72
     tgInsere AT ROW 7.42 COL 7.72
     tgViagemKmAc AT ROW 4.5 COL 7.72
     tgViagemAnd AT ROW 2.5 COL 7.72
     tgViagemConcl AT ROW 3.5 COL 7.72
     RECT-24 AT ROW 1.71 COL 4.86
     RECT-26 AT ROW 7.08 COL 4.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 13
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
         SIZE 76.86 BY 11.71
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
         TITLE              = "Relat¢rio de Apontamentos de Controle de Viagens"
         HEIGHT             = 16.96
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
/* SETTINGS FOR FILL-IN fi-ep-codigo-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-ep-codigo-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiEmpresaMatr-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fiEmpresaMatr-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                           */
/* SETTINGS FOR FILL-IN fiEstabelMatr-fim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fiEstabelMatr-ini IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
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
ON END-ERROR OF wReport /* Relat¢rio de Apontamentos de Controle de Viagens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Relat¢rio de Apontamentos de Controle de Viagens */
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


/*--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN fi-ep-codigo-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       fi-ep-codigo-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fiEmpresaMatr-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       fiEmpresaMatr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.
       
ASSIGN fiEstabelMatr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.
       

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
    assign tt-param.usuario               = c-seg-usuario
           tt-param.destino               = input frame fPage6 rsDestiny
           tt-param.data-exec             = today
           tt-param.hora-exec             = time
           tt-param.classifica            = input frame fPage3 rsClassif
           tt-param.desc-classifica       = entry((tt-param.classifica - 1) * 2 + 1,       
                                               rsClassif:radio-buttons in frame fPage3)
            tt-param.l-ViagemAnd         = input frame fpage4  tgViagemAnd    
            tt-param.l-ViagemConcl       = input frame fpage4  tgViagemConcl  
            tt-param.l-ViagemKmAc        = input frame fpage4  tgViagemKmAc   
            tt-param.l-Insere            = input frame fpage4  tgInsere 
            tt-param.l-ImprimeObs        = input frame fpage4  tgObservacao 
            tt-param.i-viagem-ini        = input frame fpage2  fi-num-viagem-ini 
            tt-param.i-viagem-fim        = input frame fpage2  fi-num-viagem-fim 
            tt-param.d-dt-saida-ini      = input frame fpage2  fi-dat-saida-ini  
            tt-param.d-dt-saida-fim      = input frame fpage2  fi-dat-saida-fim  
            tt-param.c-hr-saida-ini      = input frame fpage2  fi-hra-saida-ini  
            tt-param.c-hr-saida-fim      = input frame fpage2  fi-hra-saida-fim  
            tt-param.d-dt-ret-ini        = input frame fpage2  fi-dat-ret-ini    
            tt-param.d-dt-ret-fim        = input frame fpage2  fi-dat-ret-fim    
            tt-param.c-hr-ret-ini        = input frame fpage2  fi-hra-ret-ini   
            tt-param.c-hr-ret-fim        = input frame fpage2  fi-hra-ret-fim    
            tt-param.i-reserva-ini       = input frame fpage2  fi-num-reserva-ini 
            tt-param.i-reserva-fim       = input frame fpage2  fi-num-reserva-fim 
            tt-param.c-rota-ini          = input frame fpage2  fi-cod-rota-ini   
            tt-param.c-rota-fim          = input frame fpage2  fi-cod-rota-fim   
            tt-param.i-cod-emp-ini       = input frame fpage2  fi-ep-codigo-ini  
            tt-param.i-cod-emp-fim       = input frame fpage2  fi-ep-codigo-fim  
            tt-param.c-cod-eqpto-ini     = input frame fpage2  fi-cod-eqpto-ini  
            tt-param.c-cod-eqpto-fim     = input frame fpage2  fi-cod-eqpto-fim  
            tt-param.c-empresa-matr-ini  = input frame fpage2  fiEmpresaMatr-ini
            tt-param.c-empresa-matr-fim  = input frame fpage2  fiEmpresaMatr-fim
            tt-param.c-estabel-matr-ini  = input frame fpage2  fiEstabelMatr-ini
            tt-param.c-estabel-matr-fim  = input frame fpage2  fiEstabelMatr-fim
            tt-param.c-cod-matr-ini      = input frame fpage2  fi-cod-matr-ini   
            tt-param.c-cod-matr-fim      = input frame fpage2  fi-cod-matr-fim    
            tt-param.c-cod-grp-eqpto-ini = input frame fpage2  fi-cod-grp-eqpto-ini   
            tt-param.c-cod-grp-eqpto-fim = input frame fpage2  fi-cod-grp-eqpto-fim    

            tt-param.parametro           = input frame fpage6 l-param.

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    

    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0508rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

