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
{include/i-prgvrs.i AB0708 2.00.00.006 } /*** "010006" 16/05/2025 17:37:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708 MAB}
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
&GLOBAL-define Program        AB0708
&GLOBAL-define Version        2.00.00.001
&GLOBAL-define VersionLayout  001

&GLOBAL-define Folder         yes
&GLOBAL-define initialPage    6
&GLOBAL-define FolderLabels   Abast/Lubrif,Manut. Mec.,Pneus,Outros,Equipamento,Impress∆o

&GLOBAL-define PGLAY          yes  
&GLOBAL-define PGSEL          yes 
&GLOBAL-define PGCLA          yes 
&GLOBAL-define PGPAR          yes 
&GLOBAL-define PGDIG          yes 
&GLOBAL-define PGIMP          yes 
&GLOBAL-define PGLOG          no
 
&GLOBAL-define page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-define page1Widgets   tg-mab-marca tg-mab-model tg-mab-consu-model tg-mmv-tempo-padr tg-mab-ativid tg-mab-trajeto ~
                              tg-mab-caract tg-mab-comptmento tg-mab-estrut-mec tg-mab-sist tg-mab-sub-sist tg-mab-sit-eqpto ~
                              tg-mab-grp-eqpto tg-mab-posto tg-mab-bomba tg-mab-tip-mater tg-mab-tip-mater-item ~
                              tg-mab-grp-event tg-mab-event tg-mab-motoris tg-mab-motoris-model ~
                              tg-marca-todos tg-de-para cInputFileNOP btInputFileNOP bt-edit
&GLOBAL-define page2Widgets   tg-mmv-ofici tg-mmv-setor-ofici tg-mmv-func-ofici ~
                              tg-mmv-plano-prevent tg-mmv-tar-plano tg-mmv-tar-plano-item  ~
                              tg-marca-todos
&GLOBAL-define page3Widgets   tg-mpn-tip-borracha tg-mpn-medid tg-mpn-pos-pneu tg-mpn-layout tg-mpn-layout-eixo-pos ~
                              tg-mpn-ambien-trab tg-mpn-serv tg-mpn-desen tg-mpn-km-esperad tg-mpn-model ~
                              tg-mpn-pneu tg-mpn-histor-vida ~
                              tg-marca-todos
&GLOBAL-define page4Widgets   tg-mco-compon tg-mco-histor-vida~
                              tg-marca-todos
&GLOBAL-define page5Widgets   tg-mab-eqpto tg-mab-histor-ativid tg-mab-histor-combust  tg-mab-comptmento-eqpto tg-mab-period-manut tg-mab-configur-eixo ~
                              tg-mmv-eqpto-plano tg-mpn-histor-layout-eixo ~
                              tg-marca-todos tg-relac-eqpto-sub-sist tg-mab-eqpto-sub-sist
&GLOBAL-define page6Widgets   rsDestiny rsExecution btConfigImpr cFile ~
                              rs-exportar cInputDir tg-gerar-cabecalho btInputDir
&GLOBAL-define page7Widgets   
&GLOBAL-define page8Widgets   

&GLOBAL-define page0Text      
&GLOBAL-define page1Text      text-Modelo text-cadpg1 text-Evento text-Motorista
&GLOBAL-define page2Text      text-cadpg2
&GLOBAL-define page3Text      text-cadpg3 text-Pneu fi-km-vida-pneu
&GLOBAL-define page4Text      text-Componentes fi-km-vida-comp
&GLOBAL-define page5Text      text-cadastros fi-km-eqpto
&GLOBAL-define page6Text      text-destino text-modo text-entrada text-entrada-2
&GLOBAL-define page7Text      
&GLOBAL-define page8Text   

&GLOBAL-define page1Fields    
&GLOBAL-define page2Fields    
&GLOBAL-define page3Fields    
&GLOBAL-define page4Fields   
&GLOBAL-define page5Fields    
&GLOBAL-define page6Fields
&GLOBAL-define page7Fields
&GLOBAL-define page8Fields    

/***************************************************************************/

/** Parameters Definitions **/

/** Temp-Table de ParÉmetros **/
{abp/ab0708.i1}
    
DEFINE TEMP-TABLE tt-digita NO-UNDO 
    FIELD ordem            AS INTEGER    FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER  FORMAT "x(30)":U
    INDEX id ordem.

/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
/***************************************************************************/
                                                  /** Definiá∆o vari†veis **/

DEFINE VARIABLE l-habilit-componentes      AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-pneus            AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-manut-mec        AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-ok                       AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE p-destino                  LIKE arq-destino NO-UNDO.

define variable c-terminal AS character  no-undo.

/** Vari†veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}

/*zoom smart*/
/* define variable wh-pesquisa AS HANDLE no-undo.                      */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

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

DEFINE BUTTON bt-edit 
     LABEL "E&ditar Arquivo" 
     SIZE 12 BY 1 TOOLTIP "Editar Arquivo".

DEFINE BUTTON btInputFileNOP 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolher o Arquivo a ser importado".

DEFINE VARIABLE cInputFileNOP AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grp-event AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Evento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tip-mater AS CHARACTER FORMAT "X(8)":U 
     LABEL "Tipo Material" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-cadpg1 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-Evento AS CHARACTER FORMAT "X(256)":U INITIAL "Evento" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE text-Modelo AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE text-Motorista AS CHARACTER FORMAT "X(256)":U INITIAL "Motorista" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 3.46.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 5.75.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 2.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25.43 BY 2.5.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 1.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 5.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61 BY 1.83.

DEFINE VARIABLE tg-de-para AS LOGICAL INITIAL no 
     LABEL "Utiliza de-para NOP - Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-ativid AS LOGICAL INITIAL no 
     LABEL "Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-bomba AS LOGICAL INITIAL no 
     LABEL "Bomba" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-caract AS LOGICAL INITIAL no 
     LABEL "Caracter°sticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-comptmento AS LOGICAL INITIAL no 
     LABEL "Compartimentos ‡leo/Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-consu-model AS LOGICAL INITIAL no 
     LABEL "Consumo Padr∆o por Modelo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-estrut-mec AS LOGICAL INITIAL no 
     LABEL "Estrutura MecÉnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-event AS LOGICAL INITIAL no 
     LABEL "Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Grupo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-grp-event AS LOGICAL INITIAL no 
     LABEL "Grupo Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-marca AS LOGICAL INITIAL no 
     LABEL "Marcas" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-model AS LOGICAL INITIAL no 
     LABEL "Modelo - Equipamento/Compon." 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-motoris AS LOGICAL INITIAL no 
     LABEL "Motorista" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-motoris-model AS LOGICAL INITIAL no 
     LABEL "Motorista X Modelo Eqpto" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-posto AS LOGICAL INITIAL no 
     LABEL "Posto Abastecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-sist AS LOGICAL INITIAL no 
     LABEL "Sistema MecÉnico" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-sit-eqpto AS LOGICAL INITIAL no 
     LABEL "Situaá∆o Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-sub-sist AS LOGICAL INITIAL no 
     LABEL "Sub-Sistema" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-tip-mater AS LOGICAL INITIAL no 
     LABEL "Tipo Material" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-tip-mater-item AS LOGICAL INITIAL no 
     LABEL "Tipo Mat X Item Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-trajeto AS LOGICAL INITIAL no 
     LABEL "Trajeto" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-marca-todos AS LOGICAL INITIAL no 
     LABEL "Marcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-tempo-padr AS LOGICAL INITIAL no 
     LABEL "Tempo Padr∆o Execuá∆o Serviáos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .75 NO-UNDO.

DEFINE VARIABLE fi-cd-tipo AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Tipo Manutená∆o":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-calend AS CHARACTER FORMAT "x(9)" 
     LABEL "Calend†rio":R12 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-cc AS CHARACTER FORMAT "X(8)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-empr2 LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Empresa" NO-UNDO.

DEFINE VARIABLE fi-cod-event2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Evento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-ofic AS CHARACTER FORMAT "X(8)":U 
     LABEL "Oficina" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-posto AS CHARACTER FORMAT "X(8)":U 
     LABEL "Posto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sub-sist2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Sub-Sistema" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-cadpg2 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 1.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 7.5.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.14 BY 8.42.

DEFINE VARIABLE tg-mmv-func-ofici AS LOGICAL INITIAL no 
     LABEL "Funcion†rio Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-ofici AS LOGICAL INITIAL no 
     LABEL "Oficinas" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-plano-prevent AS LOGICAL INITIAL no 
     LABEL "Plano Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-setor-ofici AS LOGICAL INITIAL no 
     LABEL "Setor Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano AS LOGICAL INITIAL no 
     LABEL "Item Plano Preventiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-item AS LOGICAL INITIAL no 
     LABEL "Materias Necess†rios Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE fi-cod-causa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Causa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-event AS CHARACTER FORMAT "X(8)":U 
     LABEL "Evento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-it AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-medida2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Medida" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-seqpto AS CHARACTER FORMAT "X(8)":U 
     LABEL "Situaá∆o Serviáo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-km-vida-pneu AS CHARACTER FORMAT "X(256)":U INITIAL "Atualizaá∆o Quilometragem" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE fi-sub-sist3 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Sub-Sistema" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tip-serv AS CHARACTER FORMAT "X(8)":U 
     LABEL "Tipo Serviáo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-cadpg3 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-Pneu AS CHARACTER FORMAT "X(256)":U INITIAL "Pneu" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE rs-km-vida-pneu AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Processo Normal Atualizaá∆o", 1,
"Somente Quilometragem", 2
     SIZE 25.43 BY 1.25 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 1.17.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 8.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 2.5.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 4.88.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 1.92.

DEFINE VARIABLE tg-mpn-ambien-trab AS LOGICAL INITIAL no 
     LABEL "Ambiente Trabalho" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-desen AS LOGICAL INITIAL no 
     LABEL "Desenho" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-histor-vida AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Vida Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-km-esperad AS LOGICAL INITIAL no 
     LABEL "Durabilidade Esperada Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-layout AS LOGICAL INITIAL no 
     LABEL "Layout dos Eixos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-layout-eixo-pos AS LOGICAL INITIAL no 
     LABEL "Layout Eixo Posiá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-medid AS LOGICAL INITIAL no 
     LABEL "Medidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-model AS LOGICAL INITIAL no 
     LABEL "Modelo Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-pneu AS LOGICAL INITIAL no 
     LABEL "Cadastro Pneus" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-pos-pneu AS LOGICAL INITIAL no 
     LABEL "Posiá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-serv AS LOGICAL INITIAL no 
     LABEL "Serviáos" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-tip-borracha AS LOGICAL INITIAL no 
     LABEL "Tipo Borracha" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE fi-cc-codigo AS CHARACTER FORMAT "X(8)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-km-vida-comp AS CHARACTER FORMAT "X(256)":U INITIAL "Atualizaá∆o Quilometragem" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE text-Componentes AS CHARACTER FORMAT "X(256)":U INITIAL "Componentes" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE rs-km-vida-comp AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Processo Normal Atualizaá∆o", 1,
"Somente Quilometragem", 2
     SIZE 27 BY 1.25 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 1.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 2.46.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 2.88.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.92.

DEFINE VARIABLE tg-mco-compon AS LOGICAL INITIAL no 
     LABEL "Cadastro Componentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mco-histor-vida AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Vida Componente" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .75 NO-UNDO.

DEFINE VARIABLE fi-cod-pais AS CHARACTER FORMAT "X(20)":U 
     LABEL "Pa°s" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-km-eqpto AS CHARACTER FORMAT "X(256)":U INITIAL "Atualizaá∆o Quilometragem" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE fi-sub-sist4 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Sub-Sistema ‡leo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sub-sist5 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Sub-Sistema Filtro" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE text-cadastros AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 8.29 BY .67 NO-UNDO.

DEFINE VARIABLE rs-km-eqpto AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Processo Normal Atualizaá∆o", 1,
"Somente Quilometragem", 2
     SIZE 27 BY 1.25 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 1.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 10.5.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.92.

DEFINE RECTANGLE rt1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 10.5.

DEFINE VARIABLE tg-mab-comptmento-eqpto AS LOGICAL INITIAL no 
     LABEL "Compartimento Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-configur-eixo AS LOGICAL INITIAL no 
     LABEL "Configuraá∆o Eixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto AS LOGICAL INITIAL no 
     LABEL "Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto-sub-sist AS LOGICAL INITIAL no 
     LABEL "Grupo Eqpto x Sub-Sistema" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-ativid AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Setor Grupo Atividade Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-combust AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Combust°vel Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mab-period-manut AS LOGICAL INITIAL no 
     LABEL "Per°odo Manutená∆o Compartimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mmv-eqpto-plano AS LOGICAL INITIAL no 
     LABEL "Equipamento Plano Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .75 NO-UNDO.

DEFINE VARIABLE tg-mpn-histor-layout-eixo AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Layout Eixo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .75 NO-UNDO.

DEFINE VARIABLE tg-relac-eqpto-sub-sist AS LOGICAL INITIAL no 
     LABEL "Equipamento x Sub-Sistema" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .75 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btInputDir 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cInputDir AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL "Destino" 
      VIEW-AS TEXT 
     SIZE 9.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Exportaá∆o" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Diret¢rio Exportaá∆o" 
      VIEW-AS TEXT 
     SIZE 14.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-exportar AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Arquivo Texto", 1,
"Base Dados", 2
     SIZE 42 BY .75 NO-UNDO.

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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 4.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 1.71.

DEFINE VARIABLE tg-gerar-cabecalho AS LOGICAL INITIAL yes 
     LABEL "Gerar cabeáalho" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17.08
         FONT 1.

DEFINE FRAME fPage2
     tg-mmv-ofici AT ROW 3.29 COL 9
     tg-mmv-setor-ofici AT ROW 4 COL 9
     tg-mmv-func-ofici AT ROW 4.71 COL 9
     tg-mmv-plano-prevent AT ROW 5.42 COL 9
     tg-mmv-tar-plano AT ROW 6.08 COL 9
     tg-mmv-tar-plano-item AT ROW 6.79 COL 9
     fi-cod-calend AT ROW 2.88 COL 56 COLON-ALIGNED HELP
          "Calend†rio genÇrico"
     fi-cod-posto AT ROW 3.83 COL 56 COLON-ALIGNED
     fi-cod-ofic AT ROW 4.83 COL 56 COLON-ALIGNED
     fi-cod-event2 AT ROW 5.83 COL 56 COLON-ALIGNED
     fi-sub-sist2 AT ROW 6.83 COL 56 COLON-ALIGNED
     fi-cod-cc AT ROW 7.79 COL 56 COLON-ALIGNED
     fi-cd-tipo AT ROW 8.75 COL 56 COLON-ALIGNED HELP
          "Tipo de Manutená∆o"
     fi-cod-empr2 AT ROW 9.75 COL 56 COLON-ALIGNED
     tg-marca-todos AT ROW 12.42 COL 69.43
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .75
     text-cadpg2 AT ROW 2.25 COL 7 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     "Informaá‰es Adicionais" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 2.29 COL 38.29
     RECT-23 AT ROW 12.33 COL 68
     RECT-27 AT ROW 2.58 COL 6
     RECT-40 AT ROW 2.58 COL 35.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage3
     tg-mpn-tip-borracha AT ROW 3 COL 9
     tg-mpn-medid AT ROW 3.71 COL 9
     tg-mpn-pos-pneu AT ROW 4.42 COL 9
     tg-mpn-layout AT ROW 5.08 COL 9
     tg-mpn-layout-eixo-pos AT ROW 5.79 COL 9
     tg-mpn-ambien-trab AT ROW 6.5 COL 9
     tg-mpn-serv AT ROW 7.21 COL 9
     tg-mpn-desen AT ROW 7.92 COL 9
     tg-mpn-km-esperad AT ROW 8.58 COL 9
     tg-mpn-model AT ROW 9.29 COL 9
     rs-km-vida-pneu AT ROW 11.08 COL 8.57 NO-LABEL
     tg-mpn-pneu AT ROW 2.71 COL 42.57
     tg-mpn-histor-vida AT ROW 3.58 COL 42.72
     fi-tip-serv AT ROW 5.96 COL 45 COLON-ALIGNED
     fi-sub-sist3 AT ROW 6.96 COL 45 COLON-ALIGNED
     fi-cod-medida2 AT ROW 7.96 COL 45 COLON-ALIGNED
     fi-cod-it AT ROW 8.96 COL 43.28
     tg-marca-todos AT ROW 12.63 COL 69.43
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .75
     fi-cod-causa AT ROW 5.71 COL 65.86
     fi-cod-event AT ROW 6.75 COL 65.28
     fi-cod-seqpto AT ROW 7.75 COL 58.57
     text-cadpg3 AT ROW 2 COL 7.29 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     fi-km-vida-pneu AT ROW 10.33 COL 5 COLON-ALIGNED NO-LABEL
     text-Pneu AT ROW 2 COL 37 COLON-ALIGNED HELP
          "Pneu" NO-LABEL
     "Informaá‰es Adicionais" VIEW-AS TEXT
          SIZE 16.86 BY .54 AT ROW 5 COL 37
     RECT-24 AT ROW 12.5 COL 68
     RECT-28 AT ROW 2.25 COL 6
     RECT-29 AT ROW 2.25 COL 36
     RECT-41 AT ROW 5.33 COL 36.14
     RECT-47 AT ROW 10.67 COL 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage4
     tg-mco-compon AT ROW 5.25 COL 18
     tg-mco-histor-vida AT ROW 5.25 COL 45
     fi-cod-emitente AT ROW 8.08 COL 32.72 COLON-ALIGNED
     fi-cc-codigo AT ROW 9.04 COL 32.72 COLON-ALIGNED
     rs-km-vida-comp AT ROW 11.08 COL 16.29 NO-LABEL
     tg-marca-todos AT ROW 12.42 COL 69.43
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     text-Componentes AT ROW 4.25 COL 14 COLON-ALIGNED HELP
          "Componentes" NO-LABEL
     fi-km-vida-comp AT ROW 10.33 COL 12.29 COLON-ALIGNED NO-LABEL
     "Informaá‰es Adicionais" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 7.08 COL 14
     RECT-25 AT ROW 12.33 COL 68
     RECT-30 AT ROW 4.5 COL 13
     RECT-43 AT ROW 7.38 COL 13
     RECT-46 AT ROW 10.67 COL 13.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage5
     tg-mab-eqpto AT ROW 2.79 COL 8.29
     tg-mab-histor-ativid AT ROW 3.5 COL 8.29
     tg-mab-histor-combust AT ROW 4.21 COL 8.29
     tg-mab-comptmento-eqpto AT ROW 4.88 COL 8.29
     tg-mab-period-manut AT ROW 5.58 COL 8.29
     tg-mab-configur-eixo AT ROW 6.29 COL 8.29
     tg-mmv-eqpto-plano AT ROW 7 COL 8.29
     tg-mpn-histor-layout-eixo AT ROW 7.71 COL 8.29
     tg-relac-eqpto-sub-sist AT ROW 8.5 COL 8.29
     tg-mab-eqpto-sub-sist AT ROW 9.25 COL 8.29
     rs-km-eqpto AT ROW 10.75 COL 11.57 NO-LABEL
     fi-cod-pais AT ROW 2.75 COL 63 COLON-ALIGNED
     fi-sub-sist4 AT ROW 3.75 COL 63 COLON-ALIGNED
     fi-sub-sist5 AT ROW 4.75 COL 63 COLON-ALIGNED
     tg-marca-todos AT ROW 12.58 COL 69.29
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .75
     fi-km-eqpto AT ROW 10 COL 7.57 COLON-ALIGNED NO-LABEL
     text-cadastros AT ROW 1.54 COL 9.14 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     "Informá‰es Adicionais" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.5 COL 50.86
     RECT-26 AT ROW 12.5 COL 68
     RECT-34 AT ROW 1.75 COL 4
     RECT-45 AT ROW 10.33 COL 8.57
     rt1 AT ROW 1.75 COL 45
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.96 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     rs-exportar AT ROW 8.33 COL 3 NO-LABEL
     btInputDir AT ROW 10 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cInputDir AT ROW 10.04 COL 3.29 HELP
          "Nome do Diret¢rio de Exportaá∆o" NO-LABEL
     tg-gerar-cabecalho AT ROW 11.29 COL 3.29
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.21 COL 1.14 COLON-ALIGNED NO-LABEL
     text-entrada AT ROW 7.54 COL 1.86 COLON-ALIGNED HELP
          "Exportaá∆o" NO-LABEL
     text-entrada-2 AT ROW 9.29 COL 1.86 COLON-ALIGNED HELP
          "Diret¢rio Exportaá∆o" NO-LABEL
     RECT-10 AT ROW 7.75 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.46 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage1
     tg-mab-marca AT ROW 1.92 COL 3.86
     tg-mab-model AT ROW 2.58 COL 3.86
     tg-mab-consu-model AT ROW 3.29 COL 3.86
     tg-mmv-tempo-padr AT ROW 4 COL 3.86
     tg-de-para AT ROW 11.17 COL 3
     cInputFileNOP AT ROW 12 COL 4.86 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     fi-cod-depos AT ROW 6.71 COL 15 COLON-ALIGNED
     fi-grp-event AT ROW 7.67 COL 15 COLON-ALIGNED
     fi-tip-mater AT ROW 8.63 COL 15 COLON-ALIGNED
     tg-mab-ativid AT ROW 1.92 COL 35
     tg-mab-trajeto AT ROW 2.58 COL 35
     tg-mab-caract AT ROW 3.29 COL 35
     tg-mab-comptmento AT ROW 4 COL 35
     tg-mab-estrut-mec AT ROW 4.71 COL 35
     tg-mab-sist AT ROW 5.42 COL 35
     tg-mab-sub-sist AT ROW 6.08 COL 35
     tg-mab-grp-event AT ROW 8.38 COL 35.57
     tg-mab-event AT ROW 9.08 COL 35.57
     btInputFileNOP AT ROW 12 COL 44.72 HELP
          "Escolher o Arquivo a ser importado"
     bt-edit AT ROW 12 COL 49.72
     tg-mab-sit-eqpto AT ROW 1.92 COL 60
     tg-mab-grp-eqpto AT ROW 2.58 COL 60
     tg-mab-posto AT ROW 3.33 COL 60
     tg-mab-bomba AT ROW 4.04 COL 60
     tg-mab-tip-mater AT ROW 4.75 COL 60
     tg-mab-tip-mater-item AT ROW 5.42 COL 60
     tg-mab-motoris AT ROW 8.38 COL 60.57
     tg-mab-motoris-model AT ROW 9.08 COL 60.57
     tg-marca-todos AT ROW 11.5 COL 69.29
     text-Modelo AT ROW 1.29 COL 2.43 COLON-ALIGNED HELP
          "Modelo" NO-LABEL
     text-cadpg1 AT ROW 1.25 COL 34.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     text-Evento AT ROW 7.42 COL 34 COLON-ALIGNED HELP
          "Evento" NO-LABEL
     text-Motorista AT ROW 7.42 COL 59.57 COLON-ALIGNED HELP
          "Motorista" NO-LABEL
     "Informaá‰es Adicionais" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 5.13 COL 3
     RECT-18 AT ROW 1.54 COL 2
     RECT-19 AT ROW 1.5 COL 33
     RECT-20 AT ROW 7.75 COL 33
     RECT-21 AT ROW 7.75 COL 58.57
     RECT-22 AT ROW 11.42 COL 68
     RECT-39 AT ROW 5.25 COL 2
     RECT-44 AT ROW 11.42 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: 
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.08
         WIDTH              = 90.14
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.96
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FRAME fPage2
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN fi-cd-tipo IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-cc IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-empr2 IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-cod-event2 IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-ofic IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-posto IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sub-sist2 IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage3
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN fi-cod-causa IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-event IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-it IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-seqpto IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
   L-To-R                                                               */
/* SETTINGS FOR FRAME fPage5
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage6     = 
                "Exportaá∆o".

ASSIGN 
       text-entrada-2:PRIVATE-DATA IN FRAME fPage6     = 
                "Diret¢rio Exportaá∆o".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-edit wReport
ON CHOOSE OF bt-edit IN FRAME fPage1 /* Editar Arquivo */
DO: /** Editar o arquivo selecionado **/
/*   OS-COMMAND SILENT "notepad.exe" VALUE(input frame fPage4 cInputFile). */
  {report/imtrm.i "input frame fPage1 cInputFileNOP" 3}
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btInputDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputDir wReport
ON CHOOSE OF btInputDir IN FRAME fPage6
DO:
    DEFINE VARIABLE l-cancelado AS LOGICAL    NO-UNDO.
    {utp/ut-liter.i Diret¢rio_de_Exportaá∆o *}
    run utp/ut-dir.p (input RETURN-VALUE,
                              output cInputDir,
                              output l-cancelado).

    IF l-cancelado = NO THEN
        DISP cInputDir WITH FRAME fPage6.

    APPLY "leave":U TO cInputDir IN FRAME fPage6.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btInputFileNOP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFileNOP wReport
ON CHOOSE OF btInputFileNOP IN FRAME fPage1
DO:

    def var cConvFile  as char no-undo.

    assign cConvFile = replace(input frame fPage1 cInputFileNOP, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
       FILTERS "*.txt":U "*.txt":U,
               "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       &IF 'cInputFileNOP' <> 'cInputFileNOP' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "txt":U
       INITIAL-DIR "spool":U 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign cInputFileNOP = replace(cConvFile, "~\":U, "/":U).
        display cInputFileNOP with frame fPage1.
    end.

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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME cFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cFile wReport
ON LEAVE OF cFile IN FRAME fPage6
DO:
    IF cFile:SCREEN-VALUE IN FRAME fPage6 <> "":U THEN DO:
        ASSIGN cFile = replace(cFile:SCREEN-VALUE IN FRAME fPage6, "~\":U, "/":U).
    end.
    display cFile with frame fPage6.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cInputDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cInputDir wReport
ON LEAVE OF cInputDir IN FRAME fPage6
DO:
    IF cInputDir:SCREEN-VALUE IN FRAME fPage6 <> "":U THEN DO:
        ASSIGN cInputDir = replace(cInputDir:SCREEN-VALUE IN FRAME fPage6, "~\":U, "/":U).
        IF SUBSTRING(cInputDir,LENGTH(cInputDir),1) <> "/":U THEN
            ASSIGN cInputDir = cInputDir + "/":U.
    END.
    display cInputDir with frame fPage6.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cc-codigo IN FRAME fPage4 /* Centro Custo */
or F5 OF fi-cc-codigo IN FRAME fPage4 DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in042.w
        &campo=fi-cc-codigo
        &campozoom=cc-codigo
        &frame=fPage4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tipo wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cd-tipo IN FRAME fPage2 /* Tipo Manutená∆o */
or F5 OF fi-cd-tipo IN FRAME fPage2 DO:
    {method/ZoomFields.i
        &ProgramZoom="mnzoom/z01mn158.w"
        &FieldZoom1="cd-tipo"
        &FieldScreen1="fi-cd-tipo"
        &Frame1="fPage2"
        &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-calend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-calend wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-calend IN FRAME fPage2 /* Calend†rio */
or F5 OF fi-cod-calend IN FRAME fPage2 DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in026.w
        &campo=fi-cod-calend
        &campozoom=cd-calen
        &frame=fPage2} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-causa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-causa wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-causa IN FRAME fPage3 /* Causa */
or F5 OF fi-cod-causa IN FRAME fPage3 DO:
    {method/ZoomFields.i
        &ProgramZoom="mnzoom/z01mn082.w"
        &FieldZoom1="cd-causa-padr"
        &FieldScreen1="fi-cod-causa"
        &Frame1="fPage3"
        &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cc wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-cc IN FRAME fPage2 /* Centro Custo */
or F5 OF fi-cod-cc IN FRAME fPage2 DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in042.w
        &campo=fi-cod-cc
        &campozoom=cc-codigo
        &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
or F5 OF fi-cod-depos IN FRAME fPage1 DO:
    {include/zoomvar.i &prog-zoom   = "inzoom/z01in084.w"
        &campo = fi-cod-depos
        &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage4 /* Emitente */
or F5 OF fi-cod-emitente IN FRAME fPage4 DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
        &campo=fi-cod-emitente
        &campozoom=cod-emitente
        &frame=fPage4}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-event wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-event IN FRAME fPage3 /* Evento */
or F5 OF fi-cod-event IN FRAME fPage3 DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr010.w"
        &FieldZoom1="cod-evento"
        &FieldScreen1="fi-cod-event"
        &Frame1="fPage3"
        &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-event2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-event2 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-event2 IN FRAME fPage2 /* Evento */
or F5 OF fi-cod-event2 IN FRAME fPage2 DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr010.w"
        &FieldZoom1="cod-evento"
        &FieldScreen1="fi-cod-event2"
        &Frame1="fPage2"
        &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-it wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-it IN FRAME fPage3 /* Item */
or F5 OF fi-cod-it IN FRAME fPage3 DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
        &campo=fi-cod-it
        &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-medida2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-medida2 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-medida2 IN FRAME fPage3 /* Medida */
or F5 OF fi-cod-medida2 IN FRAME fPage3 DO:
    {method/ZoomFields.i
        &ProgramZoom="frzoom/z01fr049.w"
        &FieldZoom1="cod-medid"
        &FieldScreen1="fi-cod-medida2"
        &Frame1="fPage3"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-ofic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-ofic wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-ofic IN FRAME fPage2 /* Oficina */
or F5 OF fi-cod-ofic IN FRAME fPage2 DO:
    {method/ZoomFields.i
        &ProgramZoom="frzoom/z01fr033.w"
        &FieldZoom1="cod-ofici"
        &FieldScreen1="fi-cod-ofic"
        &Frame1="fPage2"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME fi-cod-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-pais wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-pais IN FRAME fPage5 /* Pa°s */
or F5 OF fi-cod-pais IN FRAME fPage5 DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
        &campo=fi-cod-pais
        &campozoom=nome-pais}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-posto wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-posto IN FRAME fPage2 /* Posto */
or F5 OF fi-cod-posto IN FRAME fPage2 DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr021.w"
        &FieldZoom1="cod-posto"
        &FieldScreen1="fi-cod-posto"
        &Frame1="fPage2"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-seqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-seqpto wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-seqpto IN FRAME fPage3 /* Situaá∆o Serviáo */
or F5 OF fi-cod-seqpto IN FRAME fPage3 DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr024.w"
        &FieldZoom1="cod-sit-eqpto"
        &FieldScreen1="fi-cod-seqpto"
        &Frame1="fPage3"
        &EnableImplant="YES"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-grp-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grp-event wReport
ON MOUSE-SELECT-DBLCLICK OF fi-grp-event IN FRAME fPage1 /* Grupo Evento */
or F5 OF fi-grp-event IN FRAME fPage1 DO:
    {method/ZoomFields.i
        &ProgramZoom="frzoom/z01fr012.w"
        &FieldZoom1="cod-grp-event"
        &FieldScreen1="fi-grp-event"
        &Frame1="fPage1"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-sub-sist2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sub-sist2 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-sub-sist2 IN FRAME fPage2 /* Sub-Sistema */
or F5 OF fi-sub-sist2 IN FRAME fPage2 DO:
    {method/zoomfields.i
        &ProgramZoom="frzoom/z01fr025.w"
        &FieldZoom1="cod-sub-sist"
        &FieldScreen1="fi-sub-sist2"
        &Frame1="fPage2"
        &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-sub-sist3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sub-sist3 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-sub-sist3 IN FRAME fPage3 /* Sub-Sistema */
or F5 OF fi-sub-sist3 IN FRAME fPage3 DO:
    {method/zoomfields.i
        &ProgramZoom="frzoom/z01fr025.w"
        &FieldZoom1="cod-sub-sist"
        &FieldScreen1="fi-sub-sist3"
        &Frame1="fPage3"
        &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME fi-sub-sist4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sub-sist4 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-sub-sist4 IN FRAME fPage5 /* Sub-Sistema ‡leo */
or F5 OF fi-sub-sist4 IN FRAME fPage5 DO:
    {method/zoomfields.i
        &ProgramZoom="frzoom/z01fr025.w"
        &FieldZoom1="cod-sub-sist"
        &FieldScreen1="fi-sub-sist4"
        &Frame1="fPage5"
        &EnableImplant="YES"}  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-sub-sist5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sub-sist5 wReport
ON MOUSE-SELECT-DBLCLICK OF fi-sub-sist5 IN FRAME fPage5 /* Sub-Sistema Filtro */
or F5 OF fi-sub-sist5 IN FRAME fPage5 DO:
    {method/zoomfields.i
        &ProgramZoom="frzoom/z01fr025.w"
        &FieldZoom1="cod-sub-sist"
        &FieldScreen1="fi-sub-sist5"
        &Frame1="fPage5"
        &EnableImplant="YES"}  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tip-mater wReport
ON MOUSE-SELECT-DBLCLICK OF fi-tip-mater IN FRAME fPage1 /* Tipo Material */
or F5 OF fi-tip-mater IN FRAME fPage1 DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr026.w"
        &FieldZoom1="cod-tip-mater"
        &FieldScreen1="fi-tip-mater"
       &Frame1="fPage1"
       &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-tip-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tip-serv wReport
ON MOUSE-SELECT-DBLCLICK OF fi-tip-serv IN FRAME fPage3 /* Tipo Serviáo */
or F5 OF fi-tip-serv IN FRAME fPage3 DO:
    {method/ZoomFields.i
        &ProgramZoom="frzoom/z01fr124.w"
        &FieldZoom1="cod-tip-serv"
        &FieldScreen1="fi-tip-serv"
        &Frame1="fPage3"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rs-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-exportar wReport
ON VALUE-CHANGED OF rs-exportar IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cInputDir:sensitive          = yes
                   btInputDir:sensitive         = yes
                   tg-gerar-cabecalho:sensitive = yes.
        end.
        when "2":U then do:
            assign cInputDir:sensitive          = no
                   btInputDir:sensitive         = no
                   tg-gerar-cabecalho:sensitive = no.
        end.
    end case.
end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                   btFile:sensitive      = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-de-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-de-para wReport
ON VALUE-CHANGED OF tg-de-para IN FRAME fPage1 /* Utiliza de-para NOP - Estabelecimento */
DO:

do  with frame fPage1:
    IF self:CHECKED THEN DO:
        assign cInputFileNOP:sensitive  = yes
               btInputFileNOP:sensitive = yes
               bt-edit:sensitive        = yes.
    END.
    ELSE DO:
        assign cInputFileNOP:sensitive  = no
               btInputFileNOP:sensitive = no
               bt-edit:sensitive        = no.
    END.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-mab-comptmento-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-comptmento-eqpto wReport
ON VALUE-CHANGED OF tg-mab-comptmento-eqpto IN FRAME fPage5 /* Compartimento Equipamento */
DO:
  IF tg-mab-comptmento-eqpto:CHECKED IN FRAME fPage5 THEN
           ASSIGN fi-sub-sist4:SENSITIVE IN FRAME fPage5 = YES
                  fi-sub-sist5:SENSITIVE IN FRAME fPage5 = YES.
  ELSE 
           ASSIGN fi-sub-sist4:SENSITIVE IN FRAME fPage5 = NO
                  fi-sub-sist4:SCREEN-VALUE IN FRAME fPage5 = "":U
                  fi-sub-sist5:SENSITIVE IN FRAME fPage5 = NO
                  fi-sub-sist5:SCREEN-VALUE IN FRAME fPage5 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-mab-consu-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-consu-model wReport
ON VALUE-CHANGED OF tg-mab-consu-model IN FRAME fPage1 /* Consumo Padr∆o por Modelo */
DO:
    IF tg-mab-consu-model:CHECKED IN FRAME fPage1 THEN
        ASSIGN fi-tip-mater:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN fi-tip-mater:SENSITIVE IN FRAME fPage1    = no
               fi-tip-mater:SCREEN-VALUE IN FRAME fPage1 = "":U.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-mab-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-eqpto wReport
ON VALUE-CHANGED OF tg-mab-eqpto IN FRAME fPage5 /* Equipamentos */
DO:
    ASSIGN rs-km-eqpto:SCREEN-VALUE IN FRAME fPage5 = "1":U.
    IF tg-mab-eqpto:CHECKED IN FRAME fPage5 THEN
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = YES.
    ELSE 
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-mab-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-event wReport
ON VALUE-CHANGED OF tg-mab-event IN FRAME fPage1 /* Evento */
DO:
    IF tg-mab-event:CHECKED IN FRAME fPage1 then do:
        ASSIGN fi-grp-event:SENSITIVE IN FRAME fPage1 = YES.
    end.
    else do:
        ASSIGN fi-grp-event:SENSITIVE IN FRAME fPage1    = no
               fi-grp-event:SCREEN-VALUE IN FRAME fPage1 = "":U.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-mab-histor-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-histor-ativid wReport
ON VALUE-CHANGED OF tg-mab-histor-ativid IN FRAME fPage5 /* Hist¢rico Setor Grupo Atividade Equipamento */
DO:
  IF tg-mab-histor-ativid:CHECKED IN FRAME fPage5 THEN
           ASSIGN fi-cod-pais:SENSITIVE IN FRAME fPage5 = YES.
  ELSE 
           ASSIGN fi-cod-pais:SENSITIVE IN FRAME fPage5 = NO
                  fi-cod-pais:SCREEN-VALUE IN FRAME fPage5 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mab-period-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-period-manut wReport
ON VALUE-CHANGED OF tg-mab-period-manut IN FRAME fPage5 /* Per°odo Manutená∆o Compartimento */
DO:
    ASSIGN rs-km-eqpto:SCREEN-VALUE IN FRAME fPage5 = "1":U.
    IF tg-mab-period-manut:CHECKED IN FRAME fPage5 THEN
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = YES.
    ELSE 
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = NO.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-mab-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mab-posto wReport
ON VALUE-CHANGED OF tg-mab-posto IN FRAME fPage1 /* Posto Abastecimento */
DO:
    IF tg-mab-posto:CHECKED IN FRAME fPage1 then do:
        ASSIGN fi-cod-depos:SENSITIVE IN FRAME fPage1   = YES.
    end.
    else do:
        ASSIGN fi-cod-depos:SENSITIVE IN FRAME fPage1      = NO   
               fi-cod-depos:SCREEN-VALUE IN FRAME fPage1   = "":U.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage3 /* Marcar Todos */
DO:
    DO WITH FRAME fPage3:
        IF tg-marca-todos:CHECKED then do:
            ASSIGN tg-mpn-tip-borracha:CHECKED    = yes
                   tg-mpn-medid:CHECKED           = yes
                   tg-mpn-pos-pneu:CHECKED        = yes
                   tg-mpn-layout:CHECKED          = yes
                   tg-mpn-layout-eixo-pos:CHECKED = yes
                   tg-mpn-ambien-trab:CHECKED     = yes
                   tg-mpn-serv:CHECKED            = yes
                   tg-mpn-desen:CHECKED           = yes
                   tg-mpn-km-esperad:CHECKED      = yes
                   tg-mpn-model:CHECKED           = yes
                   tg-mpn-pneu:CHECKED            = yes
                   tg-mpn-histor-vida:CHECKED     = yes.
        end.
        else do:
            ASSIGN tg-mpn-tip-borracha:CHECKED    = no
                   tg-mpn-medid:CHECKED           = no
                   tg-mpn-pos-pneu:CHECKED        = no
                   tg-mpn-layout:CHECKED          = no
                   tg-mpn-layout-eixo-pos:CHECKED = no
                   tg-mpn-ambien-trab:CHECKED     = no
                   tg-mpn-serv:CHECKED            = no
                   tg-mpn-desen:CHECKED           = no
                   tg-mpn-km-esperad:CHECKED      = no
                   tg-mpn-model:CHECKED           = no
                   tg-mpn-pneu:CHECKED            = no
                   tg-mpn-histor-vida:CHECKED     = no.
        end.
        APPLY "VALUE-CHANGED":U TO tg-mpn-histor-vida.
        APPLY "VALUE-CHANGED":U TO tg-mpn-pos-pneu.
        APPLY "VALUE-CHANGED":U TO tg-mpn-serv.
        APPLY "VALUE-CHANGED":U TO tg-mpn-km-esperad.
        APPLY "VALUE-CHANGED":U TO tg-mpn-pneu.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage4 /* Marcar Todos */
DO:
    DO WITH FRAME fPage4:
        IF tg-marca-todos:CHECKED THEN do:
            IF l-habilit-componentes then do:
                ASSIGN tg-mco-compon:CHECKED      = YES
                       tg-mco-histor-vida:CHECKED = YES.
            end.
        end.
        else do:
            ASSIGN tg-mco-compon:CHECKED      = NO
                   tg-mco-histor-vida:CHECKED = NO.
        end.
        APPLY "VALUE-CHANGED":U TO tg-mco-histor-vida.
        apply "VALUE-CHANGED":U to tg-mco-compon.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage5 /* Marcar Todos */
DO:
    DO WITH FRAME fPage5:
        IF tg-marca-todos:CHECKED THEN DO:
            IF l-habilit-manut-mec THEN
                ASSIGN tg-mmv-eqpto-plano:CHECKED = YES.
            IF l-habilit-pneus THEN
                ASSIGN tg-mab-configur-eixo:CHECKED = YES
                       tg-mpn-histor-layout-eixo:CHECKED = YES.
            ASSIGN tg-mab-eqpto:CHECKED            = YES
                   tg-mab-histor-ativid:CHECKED    = YES 
                   tg-mab-histor-combust:CHECKED   = YES 
                   tg-mab-comptmento-eqpto:CHECKED = YES 
                   tg-mab-period-manut:CHECKED     = YES
                   tg-relac-eqpto-sub-sist:checked = yes
                   tg-mab-eqpto-sub-sist:checked   = yes.
        end.
        ELSE
            ASSIGN  tg-mab-eqpto:CHECKED              = NO
                    tg-mab-histor-ativid:CHECKED      = NO 
                    tg-mab-histor-combust:CHECKED     = NO 
                    tg-mab-comptmento-eqpto:CHECKED   = NO 
                    tg-mab-period-manut:CHECKED       = NO
                    tg-mab-configur-eixo:CHECKED      = NO      
                    tg-mpn-histor-layout-eixo:CHECKED = NO 
                    tg-mmv-eqpto-plano:CHECKED        = NO
                    tg-relac-eqpto-sub-sist:checked   = no
                    tg-mab-eqpto-sub-sist:checked     = no.
    end.
    APPLY "VALUE-CHANGED":U TO tg-mab-eqpto.
    APPLY "VALUE-CHANGED":U TO tg-mab-histor-ativid.
    APPLY "VALUE-CHANGED":U TO tg-mab-comptmento-eqpto.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage1 /* Marcar Todos */
DO:
    DO WITH FRAME fPage1:
        IF tg-marca-todos:CHECKED then do:
            ASSIGN tg-mab-marca:CHECKED         = YES
                   tg-mab-model:checked         = yes
                   tg-mab-consu-model:checked   = yes
                   tg-mmv-tempo-padr:checked    = yes
                   tg-mab-ativid:checked        = yes
                   tg-mab-trajeto:checked       = yes
                   tg-mab-caract:checked        = yes
                   tg-mab-comptmento:checked    = yes
                   tg-mab-estrut-mec:checked    = yes
                   tg-mab-sist:checked          = yes
                   tg-mab-sub-sist:checked      = yes
                   tg-mab-sit-eqpto:checked     = yes
                   tg-mab-grp-eqpto:checked     = yes
                   tg-mab-posto:checked         = yes
                   tg-mab-bomba:checked         = yes
                   tg-mab-tip-mater:checked     = yes
                   tg-mab-tip-mater-item:checked= yes
                   tg-mab-grp-event:checked     = yes
                   tg-mab-event:checked         = yes
                   tg-mab-motoris:checked       = yes
                   tg-mab-motoris-model:checked = yes.
        end.
        else do:
            ASSIGN tg-mab-marca:CHECKED         = no
                   tg-mab-model:checked         = no
                   tg-mab-consu-model:checked   = no
                   tg-mmv-tempo-padr:checked    = no
                   tg-mab-ativid:checked        = no
                   tg-mab-trajeto:checked       = no
                   tg-mab-caract:checked        = no
                   tg-mab-comptmento:checked    = no
                   tg-mab-estrut-mec:checked    = no
                   tg-mab-sist:checked          = no
                   tg-mab-sub-sist:checked      = no
                   tg-mab-sit-eqpto:checked     = no
                   tg-mab-grp-eqpto:checked     = no
                   tg-mab-posto:checked         = no
                   tg-mab-bomba:checked         = no
                   tg-mab-tip-mater:checked     = no
                   tg-mab-tip-mater-item:checked= no
                   tg-mab-grp-event:checked     = no
                   tg-mab-event:checked         = no
                   tg-mab-motoris:checked       = no
                   tg-mab-motoris-model:checked = no.
        end.
        APPLY "value-changed":U TO tg-mab-consu-model.
        APPLY "value-changed":U TO tg-mmv-tempo-padr.
        APPLY "value-changed":U TO tg-mab-caract.
        APPLY "value-changed":U TO tg-mab-event.
        APPLY "value-changed":U TO tg-mab-motoris.
        APPLY "value-changed":U TO tg-mab-posto.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage2 /* Marcar Todos */
DO:
    DO WITH FRAME fPage2:
        IF tg-marca-todos:CHECKED then do:
            assign tg-mmv-ofici:checked          = yes
                   tg-mmv-setor-ofici:checked    = yes
                   tg-mmv-func-ofici:checked     = yes
                   tg-mmv-plano-prevent:checked  = yes
                   tg-mmv-tar-plano:checked      = yes
                   tg-mmv-tar-plano-item:checked = yes.
        end.
        else do:
            assign tg-mmv-ofici:checked          = no
                   tg-mmv-setor-ofici:checked    = no
                   tg-mmv-func-ofici:checked     = no
                   tg-mmv-plano-prevent:checked  = no
                   tg-mmv-tar-plano:checked      = no
                   tg-mmv-tar-plano-item:checked = no.
        end.
        APPLY "value-changed":U TO tg-mmv-ofici.
        APPLY "value-changed":U TO tg-mmv-setor-ofici.
        APPLY "value-changed":U TO tg-mmv-func-ofici.
        APPLY "value-changed":U TO tg-mmv-plano-prevent.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-mco-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mco-compon wReport
ON VALUE-CHANGED OF tg-mco-compon IN FRAME fPage4 /* Cadastro Componentes */
DO:
  IF tg-mco-compon:CHECKED IN FRAME fPage4 THEN
           ASSIGN fi-cc-codigo:SENSITIVE IN FRAME fPage4 = YES.
    ELSE 
           ASSIGN fi-cc-codigo:SENSITIVE IN FRAME fPage4 = NO
                  fi-cc-codigo:SCREEN-VALUE IN FRAME fPage4 = "":U.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mco-histor-vida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mco-histor-vida wReport
ON VALUE-CHANGED OF tg-mco-histor-vida IN FRAME fPage4 /* Hist¢rico Vida Componente */
DO:
    ASSIGN rs-km-vida-comp:SCREEN-VALUE IN FRAME fPage4 = "1":U.
    IF tg-mco-histor-vida:CHECKED IN FRAME fPage4 THEN
        ASSIGN fi-cod-emitente:SENSITIVE IN FRAME fPage4 = YES
               rs-km-vida-comp:SENSITIVE IN FRAME fPage4 = YES.
    ELSE 
        ASSIGN fi-cod-emitente:SENSITIVE IN FRAME fPage4    = NO
               rs-km-vida-comp:SENSITIVE IN FRAME fPage4    = NO
               fi-cod-emitente:SCREEN-VALUE IN FRAME fPage4 = "0":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-mmv-eqpto-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mmv-eqpto-plano wReport
ON VALUE-CHANGED OF tg-mmv-eqpto-plano IN FRAME fPage5 /* Equipamento Plano Manutená∆o */
DO:
    ASSIGN rs-km-eqpto:SCREEN-VALUE IN FRAME fPage5 = "1":U.
    IF tg-mmv-eqpto-plano:CHECKED IN FRAME fPage5 THEN
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = YES.
    ELSE 
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = NO.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-mmv-func-ofici
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mmv-func-ofici wReport
ON VALUE-CHANGED OF tg-mmv-func-ofici IN FRAME fPage2 /* Funcion†rio Oficina */
DO:
  IF tg-mmv-func-ofici:CHECKED IN FRAME fPage2 THEN
        ASSIGN fi-cod-cc:SENSITIVE IN FRAME fPage2 = YES
               fi-cod-empr2:sensitive in frame fPage2 = yes.
  ELSE 
        ASSIGN fi-cod-cc:SENSITIVE IN FRAME fPage2 = NO
               fi-cod-cc:SCREEN-VALUE IN FRAME fPage2 = "":U
               fi-cod-empr2:sensitive in frame fPage2 = no.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mmv-ofici
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mmv-ofici wReport
ON VALUE-CHANGED OF tg-mmv-ofici IN FRAME fPage2 /* Oficinas */
DO:
    IF tg-mmv-ofici:CHECKED IN FRAME fPage2 THEN
           ASSIGN fi-cod-posto:SENSITIVE IN FRAME fPage2 = YES
                  fi-cod-calend:SENSITIVE IN FRAME fPage2 = YES.
    ELSE 
           ASSIGN fi-cod-posto:SENSITIVE IN FRAME fPage2 = NO
                  fi-cod-posto:SCREEN-VALUE IN FRAME fPage2 = "":U
                  fi-cod-calend:SENSITIVE IN FRAME fPage2 = NO
                  fi-cod-calend:SCREEN-VALUE IN FRAME fPage2 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mmv-plano-prevent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mmv-plano-prevent wReport
ON VALUE-CHANGED OF tg-mmv-plano-prevent IN FRAME fPage2 /* Plano Manutená∆o */
DO:
  IF tg-mmv-plano-prevent:CHECKED IN FRAME fPage2 then DO:
      ASSIGN fi-cod-event2:SENSITIVE IN FRAME fPage2 = YES
             fi-sub-sist2:SENSITIVE IN FRAME fPage2  = YES
             fi-cod-calend:SENSITIVE IN FRAME fPage2 = YES
             fi-cd-tipo:SENSITIVE IN FRAME fPage2    = YES.
  end.
  else DO:
      ASSIGN fi-cod-event2:SENSITIVE IN FRAME fPage2    = NO   
             fi-cod-event2:SCREEN-VALUE IN FRAME fPage2 = "":U
             fi-sub-sist2:SENSITIVE IN FRAME fPage2     = NO
             fi-sub-sist2:SCREEN-VALUE IN FRAME fPage2  = "":U
             fi-cod-calend:SENSITIVE IN FRAME fPage2    = NO
             fi-cod-calend:SCREEN-VALUE IN FRAME fPage2 = "":U
             fi-cd-tipo:SENSITIVE IN FRAME fPage2       = NO
             fi-cd-tipo:SCREEN-VALUE IN FRAME fPage2    = "":U.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mmv-setor-ofici
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mmv-setor-ofici wReport
ON VALUE-CHANGED OF tg-mmv-setor-ofici IN FRAME fPage2 /* Setor Oficina */
DO:
  IF tg-mmv-setor-ofici:CHECKED IN FRAME fPage2 THEN
        ASSIGN fi-cod-ofic:SENSITIVE IN FRAME fPage2 = YES
               fi-cod-cc:SENSITIVE IN FRAME fPage2 = YES.
  ELSE
        ASSIGN fi-cod-ofic:SENSITIVE IN FRAME fPage2 = NO   
               fi-cod-ofic:SCREEN-VALUE IN FRAME fPage2 = "":U
               fi-cod-cc:SENSITIVE IN FRAME fPage2 = NO
               fi-cod-cc:SCREEN-VALUE IN FRAME fPage2 = "":U .    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tg-mpn-histor-vida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mpn-histor-vida wReport
ON VALUE-CHANGED OF tg-mpn-histor-vida IN FRAME fPage3 /* Hist¢rico Vida Pneu */
DO:
    ASSIGN rs-km-vida-pneu:SCREEN-VALUE IN FRAME fPage3 = "1":U.
    IF tg-mpn-histor-vida:CHECKED IN FRAME fPage3 THEN
        ASSIGN rs-km-vida-pneu:SENSITIVE IN FRAME fPage3 = YES.
    ELSE 
        ASSIGN rs-km-vida-pneu:SENSITIVE IN FRAME fPage3 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mpn-km-esperad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mpn-km-esperad wReport
ON VALUE-CHANGED OF tg-mpn-km-esperad IN FRAME fPage3 /* Durabilidade Esperada Pneu */
DO:
   IF tg-mpn-km-esperad:CHECKED IN FRAME fPage3 THEN
         ASSIGN fi-cod-it:SENSITIVE IN FRAME fPage3 = YES
                fi-cod-medida2:SENSITIVE IN FRAME fPage3 = YES.
                 
  ELSE
        
          ASSIGN fi-cod-it:SENSITIVE IN FRAME fPage3 = NO   
                 fi-cod-it:SCREEN-VALUE IN FRAME fPage3 = "":U
                 fi-cod-medida2:SENSITIVE IN FRAME fPage3 = NO   
                 fi-cod-medida2:SCREEN-VALUE IN FRAME fPage3 = "":U.

        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mpn-pneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mpn-pneu wReport
ON VALUE-CHANGED OF tg-mpn-pneu IN FRAME fPage3 /* Cadastro Pneus */
DO:
  IF tg-mpn-pneu:CHECKED IN FRAME fPage3 THEN
      ASSIGN fi-tip-serv:SENSITIVE IN FRAME fPage3  = YES
             fi-cod-causa:SENSITIVE IN FRAME fPage3 = YES.
  ELSE
      ASSIGN fi-tip-serv:SENSITIVE IN FRAME fPage3     = NO   
             fi-tip-serv:SCREEN-VALUE IN FRAME fPage3  = "":U
             fi-cod-causa:SENSITIVE IN FRAME fPage3    = NO   
             fi-cod-causa:SCREEN-VALUE IN FRAME fPage3 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mpn-pos-pneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mpn-pos-pneu wReport
ON VALUE-CHANGED OF tg-mpn-pos-pneu IN FRAME fPage3 /* Posiá‰es */
DO:
  IF tg-mpn-pos-pneu:CHECKED IN FRAME fPage3 THEN
         ASSIGN fi-sub-sist3:SENSITIVE IN FRAME fPage3 = YES.
                                 
  ELSE
        
          ASSIGN fi-sub-sist3:SENSITIVE IN FRAME fPage3 = NO   
                 fi-sub-sist3:SCREEN-VALUE IN FRAME fPage3 = "":U.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-mpn-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-mpn-serv wReport
ON VALUE-CHANGED OF tg-mpn-serv IN FRAME fPage3 /* Serviáos */
DO:
   IF tg-mpn-serv:CHECKED IN FRAME fPage3 THEN
         ASSIGN fi-cod-causa:SENSITIVE IN FRAME fPage3 = YES
                fi-cod-event:SENSITIVE IN FRAME fPage3 = YES
                fi-cod-seqpto:SENSITIVE IN FRAME fPage3 = YES.

                 
  ELSE
        
          ASSIGN fi-cod-causa:SENSITIVE IN FRAME fPage3 = NO   
                 fi-cod-causa:SCREEN-VALUE IN FRAME fPage3 = "":U
                 fi-cod-event:SENSITIVE IN FRAME fPage3 = NO   
                 fi-cod-event:SCREEN-VALUE IN FRAME fPage3 = "":U
                 fi-cod-seqpto:SENSITIVE IN FRAME fPage3 = NO   
                 fi-cod-seqpto:SCREEN-VALUE IN FRAME fPage3 = "":U.
          
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME tg-relac-eqpto-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-relac-eqpto-sub-sist wReport
ON VALUE-CHANGED OF tg-relac-eqpto-sub-sist IN FRAME fPage5 /* Equipamento x Sub-Sistema */
DO:
    ASSIGN rs-km-eqpto:SCREEN-VALUE IN FRAME fPage5 = "1":U.
    IF tg-relac-eqpto-sub-sist:CHECKED IN FRAME fPage5 THEN
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = YES.
    ELSE 
        ASSIGN rs-km-eqpto:SENSITIVE IN FRAME fPage5 = NO.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/
/*{report/mainblock.i}*/


/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padr∆o para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de RETURN padr∆o para FRAME fPage0 ---*/
ON RETURN OF FRAME fPage0 ANYWHERE
    RUN applyReturn IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padr∆o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padr∆o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON SHIFT-CTRL-TAB ANYWHERE
        RUN prevFolder IN hFolder.
&ENDIF

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- Padr∆o para janelas GUI ---*/
PAUSE 0 BEFORE-HIDE.

&IF "{&UIB_is_Running}":U <> "":U &THEN
    /*--- Inicializa programa ---*/
    RUN initializeInterface IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
&ELSE
    IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
        /*--- Inicializa programa ---*/
        RUN initializeInterface IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
&ENDIF

&IF defined(PGLOG) <> 0 &THEN
    &IF  "{&PGLOG}":U = "YES":U &THEN
        {report/imini.i}
    &ENDIF
&ENDIF

&IF defined(PGLOG) <> 0 &THEN
    &IF  "{&PGLOG}":U = "YES":U &THEN
        {report/imlbl.i}
    &ENDIF
&ENDIF

/*--- Block principal do programa ---*/
DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
    
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    
    
   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


/* define procedure externa para execucao do programa de visualizacao do relatorio */

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

fi-cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fi-grp-event:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fi-tip-mater:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fi-cod-posto:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-cod-ofic:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-cod-event2:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-sub-sist2:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-cod-cc:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-cod-calend:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fi-cod-it:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-cod-causa:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-cod-event:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-cod-medida2:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-sub-sist3:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-tip-serv:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-cod-seqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage3.
fi-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage4.
fi-cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage4.
fi-cod-pais:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage5.
fi-sub-sist4:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage5.
fi-sub-sist5:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s a inicializaá∆o da tela
------------------------------------------------------------------------------*/
/** Verifica se a base est† conectada.
    Se a mesma n∆o estiver mostra mensagem ao usu†rio e fecha o programa. **/
if not connected("mb":U) then do:
    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                       INPUT 31656, 
                       INPUT "":U).
    return "NOK":U.
end.
else do:
    run piValida in this-procedure.
    if return-value = "NOK":U then
        return "NOK":U.
end.

/*** Verifica se o m¢dulo est† implantado e desabilita os campos caso n∆o esteja ***/

/** Componentes **/
RUN cdp/cd9902.p (INPUT 4).
IF RETURN-VALUE = "NOK":U THEN DO:
    ASSIGN l-habilit-componentes = NO.
    DO WITH FRAME fPage4:
        ASSIGN tg-mco-compon:SENSITIVE       = NO
               tg-mco-histor-vida:SENSITIVE  = NO.
    end.
end.

/** Manutená∆o MecÉnica **/
RUN cdp/cd9902.p (INPUT 3).
IF RETURN-VALUE = "NOK":U THEN DO:
    RUN setEnabled in hFolder (input 2, input false).
    ASSIGN l-habilit-manut-mec                          = NO
           tg-mmv-eqpto-plano:SENSITIVE IN FRAME fPage5 = NO.
end.

/** Pneus **/
RUN cdp/cd9902.p (INPUT 2).
IF RETURN-VALUE = "NOK":U THEN DO:
    RUN setEnabled IN hFolder (INPUT 3, INPUT FALSE).
    ASSIGN l-habilit-pneus                                     = NO
           tg-mab-configur-eixo:SENSITIVE IN FRAME fPage5      = NO
           tg-mpn-histor-layout-eixo:SENSITIVE IN FRAME fPage5 = NO.
end.

APPLY "VALUE-CHANGED":U TO rs-exportar IN FRAME fPage6.
APPLY "VALUE-CHANGED":U TO tg-de-para  IN FRAME fPage1.
APPLY "VALUE-CHANGED":U TO tg-mpn-histor-vida IN FRAME fPage3.
APPLY "VALUE-CHANGED":U TO tg-mco-histor-vida IN FRAME fPage4.
APPLY "VALUE-CHANGED":U TO tg-mab-eqpto       IN FRAME fPage5.

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

DO ON ERROR UNDO, RETURN error
   ON STOP  UNDO, RETURN ERROR:

    {report/rpexa.i}

    CREATE tt-param.
    ASSIGN tt-param.usuario                  = c-seg-usuario
           tt-param.data-exec                = TODAY 
           tt-param.hora-exec                = TIME 
           tt-param.destino                  = INPUT FRAME fPage6 rsDestiny
           tt-param.execucao                 = INPUT FRAME fPage6 rsExecution
           tt-param.arquivo                  = INPUT FRAME fPage6 cFile
           tt-param.arq-destino              = INPUT FRAME fPage6 cFile
           /** Exportaá∆o **/
           tt-param.dest-exportacao          = INPUT FRAME fPage6 rs-exportar
           tt-param.dir-entrada              = INPUT FRAME fPage6 cInputDir
           tt-param.gera-cabecalho           = tg-gerar-cabecalho:CHECKED IN FRAME fPage6
           /** NOP x Estabelecimento **/
           tt-param.l-de-para                = tg-de-para:CHECKED IN FRAME fPage1
           tt-param.arq-estabel              = INPUT FRAME fPage1 cInputFileNOP
           /*FRAME 1*/                         
           tt-param.l-mab-marca              = tg-mab-marca:CHECKED IN FRAME fPage1           
           tt-param.l-mab-model              = tg-mab-model:CHECKED IN FRAME fPage1           
           tt-param.l-mab-consu-model        = tg-mab-consu-model:CHECKED IN FRAME fPage1     
           tt-param.l-mmv-tempo-padr         = tg-mmv-tempo-padr:CHECKED IN FRAME fPage1      
           tt-param.l-mab-ativid             = tg-mab-ativid:CHECKED IN FRAME fPage1          
           tt-param.l-mab-trajeto            = tg-mab-trajeto:CHECKED IN FRAME fPage1         
           tt-param.l-mab-caract             = tg-mab-caract:CHECKED IN FRAME fPage1          
           tt-param.l-mab-comptmento         = tg-mab-comptmento:CHECKED IN FRAME fPage1      
           tt-param.l-mab-estrut-mec         = tg-mab-estrut-mec:CHECKED IN FRAME fPage1      
           tt-param.l-mab-sist               = tg-mab-sist:CHECKED IN FRAME fPage1            
           tt-param.l-mab-sub-sist           = tg-mab-sub-sist:CHECKED IN FRAME fPage1        
           tt-param.l-mab-sit-eqpto          = tg-mab-sit-eqpto:CHECKED IN FRAME fPage1       
           tt-param.l-mab-grp-eqpto          = tg-mab-grp-eqpto:CHECKED IN FRAME fPage1       
           tt-param.l-mab-eqpto-sub-sist     = tg-relac-eqpto-sub-sist:CHECKED IN FRAME fPage5
           tt-param.l-mab-grp-eqpto-sub-sist = tg-mab-eqpto-sub-sist:checked in frame fPage5
           tt-param.l-mab-posto              = tg-mab-posto:CHECKED IN FRAME fPage1           
           tt-param.l-mab-bomba              = tg-mab-bomba:CHECKED IN FRAME fPage1           
           tt-param.l-mab-tip-mater          = tg-mab-tip-mater:CHECKED IN FRAME fPage1       
           tt-param.l-mab-tip-mater-item     = tg-mab-tip-mater-item:CHECKED IN FRAME fPage1  
           tt-param.l-mab-grp-event          = tg-mab-grp-event:CHECKED IN FRAME fPage1       
           tt-param.l-mab-event              = tg-mab-event:CHECKED IN FRAME fPage1        
           tt-param.l-mab-motoris            = tg-mab-motoris:CHECKED IN FRAME fPage1   
           tt-param.l-mab-motoris-model      = tg-mab-motoris-model:CHECKED IN FRAME fPage1
           tt-param.c-depos                  = INPUT FRAME fPage1 fi-cod-depos
           tt-param.c-grp-event              = INPUT FRAME fPage1 fi-grp-event
           tt-param.c-tip-mater              = INPUT FRAME fPage1 fi-tip-mater
           /*FRAME 2*/                         
           tt-param.l-mmv-ofici              = tg-mmv-ofici:CHECKED IN FRAME fPage2           
           tt-param.l-mmv-setor-ofici        = tg-mmv-setor-ofici:CHECKED IN FRAME fPage2     
           tt-param.l-mmv-func-ofici         = tg-mmv-func-ofici:CHECKED IN FRAME fPage2      
           tt-param.l-mmv-plano-prevent      = tg-mmv-plano-prevent:CHECKED IN FRAME fPage2   
           tt-param.l-mmv-tar-plano          = tg-mmv-tar-plano:CHECKED IN FRAME fPage2       
           tt-param.l-mmv-tar-plano-item     = tg-mmv-tar-plano-item:CHECKED IN FRAME fPage2  
           tt-param.c-cod-ofic               = INPUT FRAME fPage2 fi-cod-ofic
           tt-param.c-cod-cc                 = INPUT FRAME fPage2 fi-cod-cc
           tt-param.c-cod-event              = INPUT FRAME fPage2 fi-cod-event2
           tt-param.c-sub-sist2              = INPUT FRAME fPage2 fi-sub-sist2
           tt-param.c-cod-posto              = INPUT FRAME fPage2 fi-cod-posto
           tt-param.c-cod-calend             = INPUT FRAME fPage2 fi-cod-calend
           tt-param.i-cd-tipo                = INPUT FRAME fPage2 fi-cd-tipo
           tt-param.c-cod-empr2              = input frame fPage2 fi-cod-empr2
           /*FRAME 3*/                         
           tt-param.l-mpn-tip-borracha       = tg-mpn-tip-borracha:CHECKED IN FRAME fPage3   
           tt-param.l-mpn-medid              = tg-mpn-medid:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-pos-pneu           = tg-mpn-pos-pneu:CHECKED IN FRAME fPage3       
           tt-param.l-mpn-layout             = tg-mpn-layout:CHECKED IN FRAME fPage3         
           tt-param.l-mpn-layout-eixo-pos    = tg-mpn-layout-eixo-pos:CHECKED IN FRAME fPage3
           tt-param.l-mpn-ambien-trab        = tg-mpn-ambien-trab:CHECKED IN FRAME fPage3    
           tt-param.l-mpn-serv               = tg-mpn-serv:CHECKED IN FRAME fPage3           
           tt-param.l-mpn-desen              = tg-mpn-desen:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-km-esperad         = tg-mpn-km-esperad:CHECKED IN FRAME fPage3     
           tt-param.l-mpn-model              = tg-mpn-model:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-pneu               = tg-mpn-pneu:CHECKED IN FRAME fPage3           
           tt-param.l-mpn-histor-vida        = tg-mpn-histor-vida:CHECKED IN FRAME fPage3
           tt-param.c-evento                 = INPUT FRAME fPage3 fi-cod-event
           tt-param.c-sit-eqpto              = INPUT FRAME fPage3 fi-cod-seqpto
           tt-param.c-causa                  = INPUT FRAME fPage3 fi-cod-causa
           tt-param.c-it-codigo              = INPUT FRAME fPage3 fi-cod-it
           tt-param.c-sub-sist3              = INPUT FRAME fPage3 fi-sub-sist3
           tt-param.c-cod-serv               = INPUT FRAME fPage3 fi-tip-serv
           tt-param.c-cod-medida2            = INPUT FRAME fPage3 fi-cod-medida2
           tt-param.i-km-vida-pneu           = INPUT FRAME fPage3 rs-km-vida-pneu
           /*FRAME 4*/                         
           tt-param.l-mco-compon             = tg-mco-compon:CHECKED IN FRAME fPage4             
           tt-param.l-mco-histor-vida        = tg-mco-histor-vida:CHECKED IN FRAME fPage4   
           tt-param.c-cod-emitente           = INPUT FRAME fPage4 fi-cod-emitente
           tt-param.c-cc-codigo-compon       = INPUT FRAME fPage4 fi-cc-codigo
           tt-param.i-km-vida-comp           = INPUT FRAME fPage4 rs-km-vida-comp
           /*FRAME 5*/                         
           tt-param.l-mab-eqpto              = tg-mab-eqpto:CHECKED IN FRAME fPage5             
           tt-param.l-mab-histor-ativid      = tg-mab-histor-ativid:CHECKED IN FRAME fPage5      
           tt-param.l-mab-histor-combust     = tg-mab-histor-combust:CHECKED IN FRAME fPage5     
           tt-param.l-mab-comptmento-eqpto   = tg-mab-comptmento-eqpto:CHECKED IN FRAME fPage5   
           tt-param.l-mab-period-manut       = tg-mab-period-manut:CHECKED IN FRAME fPage5       
           tt-param.l-mab-configur-eixo      = tg-mab-configur-eixo:CHECKED IN FRAME fPage5      
           tt-param.l-mmv-eqpto-plano        = tg-mmv-eqpto-plano:CHECKED IN FRAME fPage5        
           tt-param.l-mpn-histor-layout-eixo = tg-mpn-histor-layout-eixo:CHECKED IN FRAME fPage5 
           tt-param.c-sub-sist-oleo          = INPUT FRAME fPage5 fi-sub-sist4
           tt-param.c-sub-sist-filtro        = INPUT FRAME fPage5 fi-sub-sist5
           tt-param.c-cod-pais               = INPUT FRAME fPage5 fi-cod-pais
           tt-param.i-km-eqpto               = INPUT FRAME fPage5 rs-km-eqpto.

    /*******************************************************/

    IF INPUT FRAME fPage1 tg-marca-todos THEN
        ASSIGN  tt-param.todos = 1. 
    ELSE                         
        ASSIGN  tt-param.todos = 2. 

    IF INPUT FRAME fPage2 tg-marca-todos THEN
        ASSIGN  tt-param.todos = 1.
    ELSE                         
        ASSIGN  tt-param.todos = 2.

    IF INPUT FRAME fPage3 tg-marca-todos THEN
        ASSIGN  tt-param.todos = 1.
    ELSE                         
        ASSIGN  tt-param.todos = 2.

    IF INPUT FRAME fPage4 tg-marca-todos THEN
        ASSIGN  tt-param.todos = 1. 
    ELSE                         
        ASSIGN  tt-param.todos = 2. 

    IF INPUT FRAME fPage5 tg-marca-todos THEN
        ASSIGN  tt-param.todos = 1. 
    ELSE                         
        ASSIGN  tt-param.todos = 2. 

    /* executa validaá‰es no campos das informaá‰es adicionais dos folders*/
    RUN piValidacoes IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaPosto IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaEvento IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaConsu IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaFuncionario IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaManutencaoMecanica IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        return "NOK":U.

    RUN piValidaPlanoPrevent IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaSetOfic IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaSetor IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN piValidaEmitente IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*executa as validacoes dos dados da tela, e verifica a existencia dos arquivos de importaá∆o.*/

    if tt-param.destino = 1 then 
        assign tt-param.arquivo = "":U.
    else 
        if  tt-param.destino = 2 then 
            assign tt-param.arquivo = input frame fPage6 cFile.
        else 
            assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i abp/ab0708rp.p}
    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValida wReport 
PROCEDURE piValida :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-verifica AS HANDLE     NO-UNDO.
define VARIABLE l-erro-empresa      as logical no-undo.
define VARIABLE l-erro-impressora   as logical no-undo.
define VARIABLE l-erro-procedimento as logical no-undo.
define VARIABLE l-erro-funcao       as logical no-undo.
DEFINE VARIABLE c-error1 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-dsl AS CHARACTER format "x(100)" NO-UNDO.
DEFINE VARIABLE c-dsl1 AS CHARACTER format "x(100)" NO-UNDO.

IF NOT VALID-HANDLE(h-verifica) then
    RUN abp/api-ab0708g.i PERSISTENT SET h-verifica.

if valid-handle(h-verifica) then do:
    run piValidaBase in h-verifica (output l-erro-empresa,
                                    output l-erro-impressora,
                                    output l-erro-procedimento,
                                    output l-erro-funcao).
    delete procedure h-verifica.
end.

if l-erro-empresa then do:
    if c-error1 = "" then do:
        assign c-error1 = "empresa":U.
    end.
    else do:
        assign c-error1 = c-error1 + "; " + "empresa":U.
    end.
end.

if l-erro-impressora then do:
    if c-error1 = "" then do:
        assign c-error1 = "impressora":U.
    end.
    else do:
        assign c-error1 = c-error1 + "; " + "impressora":U.
    end.
end.

if l-erro-procedimento then do:
    if c-error1 = "" then do:
        assign c-error1 = "procedimento":U.
    end.
    else do:
        assign c-error1 = c-error1 + "; " + "procedimento":U.
    end.
end.

if l-erro-funcao then do:
    if c-error1 = "" then do:
        assign c-error1 = "funcao":U.
    end.
    else do:
        assign c-error1 = c-error1 + "; " + "funcao":U.
    end.
end.

if l-erro-empresa or l-erro-impressora or l-erro-procedimento or l-erro-funcao then do:
    {utp/ut-liter.i "Foi verificado que existem algumas tabelas na base MB que n∆o s∆o suportadas pelo fato das mesmas existirem tambÇm no EMS. Favor alterar o nome das seguintes tabelas"}
    assign c-dsl = return-value.
    {utp/ut-liter.i "Para que poss°veis erros n∆o ocorram, o programa ser† encerrado, favor alterar o nome das tabelas para que esse erro n∆o volte a aparecer}
    assign c-dsl1 = return-value.
    {utp/ut-liter.i "Tabelas Inv†lidas"}
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT return-value + '~~' + c-dsl + ":" + chr(10) + c-error1 + chr(10) + c-dsl1).
    return "NOK":U.
end.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidacoes wReport 
PROCEDURE piValidacoes :
/*------------------------------------------------------------------------------
  Purpose:    Validacoes da Importaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.dest-exportacao = 1 AND tt-param.dir-entrada = "":U THEN DO:
    /*Diretorio de Exportaá∆o em Branco*/
    {utp/ut-liter.i Diret¢rio_de_Exportaá∆o *}
     RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 3145,
                        INPUT RETURN-VALUE).
    RUN setFolder IN hFolder (INPUT 6).
    apply "ENTRY":U to cInputDir in frame fPage6.
    RETURN "NOK":U.
END.

IF tt-param.l-de-para AND tt-param.arq-estabel = "":U THEN DO:
    /*Arquivo NOP x Estabel */
    {utp/ut-liter.i Arquivo_NOP_x_Estabelecimento *}
     RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 3145,
                        INPUT RETURN-VALUE).
    RUN setFolder IN hFolder (INPUT 1).
    apply "ENTRY":U to cInputFileNOP in frame fPage1.
    RETURN "NOK":U.
END.


IF tt-param.l-mab-marca              = NO AND 
   tt-param.l-mab-model              = NO AND 
   tt-param.l-mab-consu-model        = NO AND 
   tt-param.l-mmv-tempo-padr         = NO AND 
   tt-param.l-mab-ativid             = NO AND 
   tt-param.l-mab-trajeto            = NO AND 
   tt-param.l-mab-caract             = NO AND 
   tt-param.l-mab-comptmento         = NO AND 
   tt-param.l-mab-estrut-mec         = NO AND 
   tt-param.l-mab-sist               = NO AND 
   tt-param.l-mab-sub-sist           = NO AND 
   tt-param.l-mab-sit-eqpto          = NO AND 
   tt-param.l-mab-grp-eqpto          = NO AND 
   tt-param.l-mab-eqpto-sub-sist     = NO AND 
   tt-param.l-mab-posto              = NO AND 
   tt-param.l-mab-bomba              = NO AND 
   tt-param.l-mab-tip-mater          = NO AND 
   tt-param.l-mab-tip-mater-item     = NO AND 
   tt-param.l-mab-grp-event          = NO AND 
   tt-param.l-mab-event              = NO AND
   tt-param.l-mab-integr-cargo       = NO AND
   tt-param.l-mab-motoris            = NO AND
   tt-param.l-mab-motoris-model      = NO AND
   /* 2 */                              
   tt-param.l-mmv-ofici              = NO AND 
   tt-param.l-mmv-setor-ofici        = NO AND 
   tt-param.l-mmv-func-ofici         = NO AND 
   tt-param.l-mmv-plano-prevent      = NO AND 
   tt-param.l-mmv-tar-plano          = NO AND 
   tt-param.l-mmv-tar-plano-item     = NO AND 
   /* 3 */                              
   tt-param.l-mpn-param              = NO AND 
   tt-param.l-mpn-tip-borracha       = NO AND 
   tt-param.l-mpn-medid              = NO AND 
   tt-param.l-mpn-pos-pneu           = NO AND 
   tt-param.l-mpn-layout             = NO AND 
   tt-param.l-mpn-layout-eixo-pos    = NO AND 
   tt-param.l-mpn-ambien-trab        = NO AND 
   tt-param.l-mpn-serv               = NO AND 
   tt-param.l-mpn-tip-serv           = NO AND 
   tt-param.l-mpn-desen              = NO AND 
   tt-param.l-mpn-km-esperad         = NO AND 
   tt-param.l-mpn-model              = NO AND 
   tt-param.l-mpn-pneu               = NO AND 
   tt-param.l-mpn-histor-vida        = NO AND 
   /* 4 */                              
   tt-param.l-mco-compon             = NO AND 
   tt-param.l-mco-histor-vida        = NO AND 
   /* 5 */                            
   tt-param.l-mab-eqpto              = NO AND 
   tt-param.l-mab-histor-ativid      = NO AND 
   tt-param.l-mab-histor-combust     = NO AND 
   tt-param.l-mab-comptmento-eqpto   = NO AND 
   tt-param.l-mab-period-manut       = NO AND 
   tt-param.l-mab-configur-eixo      = NO AND 
   tt-param.l-mmv-eqpto-plano        = NO AND 
   tt-param.l-mpn-histor-layout-eixo = no and
   tt-param.l-mab-grp-eqpto-sub-sist = no THEN DO:

    /*Pelo menos um cadastro deve ser selecionado para Importaá∆o*/
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 30660,
                       INPUT "":U).
    RETURN "NOK":U.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaConsu wReport 
PROCEDURE piValidaConsu :
/*------------------------------------------------------------------------------
  Purpose:     Valida campos relacionados ao Consumo Padr∆o
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
IF tt-param.l-mab-consu-model = YES AND tt-param.c-tip-mater = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Tipo_Material" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEmitente wReport 
PROCEDURE piValidaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mco-histor-vida = YES  AND tt-param.c-cod-emitente = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Emitente" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.

IF tt-param.l-mco-compon = YES  AND tt-param.c-cc-codigo-compon = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Centro_Custo" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
    

RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEvento wReport 
PROCEDURE piValidaEvento :
/*------------------------------------------------------------------------------
  Purpose: Valida campos relacionados ao evento
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mab-event = YES AND tt-param.c-grp-event = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Grupo_Evento" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaFuncionario wReport 
PROCEDURE piValidaFuncionario :
/*------------------------------------------------------------------------------
  Purpose:Valida campos referente ao funcion†rio     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mmv-func-ofici = YES  AND tt-param.c-cod-cc = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Centro_de_Custo" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaManutencaoMecanica wReport 
PROCEDURE piValidaManutencaoMecanica :
/*------------------------------------------------------------------------------
  Purpose: Valida campos relacionados a oficina    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mmv-ofici = YES  then do:
    if tt-param.c-cod-posto = "" then DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_do_Posto" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 3145,
                           INPUT RETURN-VALUE).
        RETURN "NOK":U.
    end.
end.
IF tt-param.l-mmv-ofici = YES or tt-param.l-mmv-plano-prevent then do:
    if tt-param.c-cod-calend = "" then DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_do_Calend†rio" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 3145,
                           INPUT RETURN-VALUE).
        RETURN "NOK":U.
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaPlanoPrevent wReport 
PROCEDURE piValidaPlanoPrevent :
/*------------------------------------------------------------------------------
  Purpose: Valida Campos referentes ao plano preventivo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mmv-plano-prevent = YES  AND tt-param.c-cod-event = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Evento" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
IF tt-param.l-mmv-plano-prevent = YES  AND tt-param.c-sub-sist2 = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Sub-Sistema" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
IF tt-param.l-mmv-plano-prevent = YES  AND tt-param.i-cd-tipo = 0 then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Tipo_Manutená∆o" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.

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
IF tt-param.l-mpn-pos-pneu = YES  AND tt-param.c-sub-sist3 = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Sub-Sistema" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaPosto wReport 
PROCEDURE piValidaPosto :
/*------------------------------------------------------------------------------
  Purpose: Valida Campos relacionado ao posto    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mab-posto = YES  AND tt-param.c-depos = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Dep¢sito" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSetOfic wReport 
PROCEDURE piValidaSetOfic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mmv-setor-ofici = YES  AND tt-param.c-cod-ofic = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Oficina" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.

IF tt-param.l-mmv-setor-ofici = YES  AND tt-param.c-cod-cc = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_do_Centro_de_Custo" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSetor wReport 
PROCEDURE piValidaSetor :
/*------------------------------------------------------------------------------
  Purpose: Valida campos relacionados ao setor.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mmv-setor-ofici = YES  AND tt-param.c-cod-ofic = "" then DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Oficina" *}
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 3145,
                       INPUT RETURN-VALUE).
    RETURN "NOK":U.
end.
ELSE 
    IF tt-param.l-mmv-setor-ofici = YES  AND tt-param.c-cod-cc = "" then DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_Centro_de_Custo" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 3145,
                           INPUT RETURN-VALUE).
        RETURN "NOK":U.
    end.
    ELSE 
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

