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
{include/i-prgvrs.i AB0706 2.00.00.001}  /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706 MAB}
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
&GLOBAL-DEFINE Program        AB0706
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    6
&GLOBAL-DEFINE FolderLabels   Abast/Lubrif,Manut. Mec.,Pneus,Outros,Equipamento,Log

&GLOBAL-DEFINE PGLAY          YES  
&GLOBAL-DEFINE PGSEL          YES 
&GLOBAL-DEFINE PGCLA          YES 
&GLOBAL-DEFINE PGPAR          YES 
&GLOBAL-DEFINE PGDIG          YES 
&GLOBAL-DEFINE PGIMP          NO 
&GLOBAL-DEFINE PGLOG          YES 

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   tg-val-param tg-tab-unidade tg-tag ~
                              tg-mab-marca tg-mab-model tg-mab-consu-model tg-mmv-tempo-padr ~
                              tg-mab-ativid tg-mab-trajeto tg-mab-caract tg-mab-comptmento tg-mab-estrut-mec tg-mab-sist tg-mab-sub-sist tg-mab-sit-eqpto ~
                              tg-mab-grp-eqpto tg-mab-eqpto-sub-sist tg-mab-posto tg-mab-bomba tg-mab-tip-mater tg-mab-tip-mater-item ~
                              tg-mab-grp-event tg-mab-event ~
                              tg-mab-motoris tg-mab-motoris-model tg-integr-cargo ~
                              tg-marca-todos
&GLOBAL-DEFINE page2Widgets   tg-mmv-param tg-mmv-ofici tg-mmv-setor-ofici tg-mmv-func-ofici tg-mmv-plandor ~
                              tg-mmv-plano-prevent tg-mmv-tar-plano tg-mmv-tar-plano-item tg-mmv-tar-plano-epi tg-mmv-tar-plano-ferram tg-mmv-tar-plano-ficha ~
                              tg-mmv-tar-plano-esp tg-mmv-tar-plano-esp-curso tg-mi-espec tg-mi-curso-trein tg-mi-turno tg-mi-turno-ciclo tg-mmv-func-turno ~
                              tg-mmv-func-curso-trein tg-mmv-func-especialid tg-marca-todos
&GLOBAL-DEFINE page3Widgets   tg-mpn-param tg-mpn-tip-borracha tg-mpn-medid tg-mpn-pos-pneu tg-mpn-layout tg-mpn-layout-eixo-pos ~
                              tg-mpn-ambien-trab tg-mpn-serv tg-mpn-tip-serv tg-mpn-desen tg-mpn-km-esperad tg-mpn-model ~
                              tg-mpn-pneu tg-mpn-histor-vida ~
                              tg-marca-todos
&GLOBAL-DEFINE page4Widgets   tg-mco-compon tg-mco-histor-vida tg-mco-plano-compon ~
                              tg-mab-tab-restdo tg-mab-restdo-tab tg-mao-ensaio tg-mao-ensaio-padr ~
                              tg-mab-usuar-frota tg-mab-usuar-estab tg-mnd-proces-administ ~
                              tg-mgf-param tg-mgf-event-param tg-mgf-event-grp-eqpto tg-mgf-grp-estoq ~
                              tg-marca-todos
&GLOBAL-DEFINE page5Widgets   tg-mab-eqpto tg-mab-histor-ativid tg-mab-histor-combust tg-mab-eqpto-caract tg-mab-comptmento-eqpto tg-mab-period-manut tg-mab-configur-eixo ~
                              tg-mab-programac-event tg-mmv-eqpto-plano tg-mgf-eqpto-implto tg-mpn-histor-layout-eixo tg-mpn-eqpto-serv tg-mpn-hora-estimad ~
                              tg-mmv-grp-eqpto tg-mmv-eqpto-grp-eqpto tg-relac-eqpto-sub-sist ~
                              tg-marca-todos
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution ~
                              btInputDir ~
                              tg-atualiza
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      text-EMS text-Modelo text-cadpg1 text-Evento text-Motorista
&GLOBAL-DEFINE page2Text      text-cadpg2
&GLOBAL-DEFINE page3Text      text-cadpg3 text-Pneu
&GLOBAL-DEFINE page4Text      text-Componentes text-AnaliseOl text-ManutDoctos text-Gerencial
&GLOBAL-DEFINE page5Text      text-cadastros text-grpeqptomanut
&GLOBAL-DEFINE page6Text
&GLOBAL-DEFINE page7Text      text-imprime text-destino text-entrada text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields   
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields
&GLOBAL-DEFINE page7Fields    cDestinyFile cInputDir
&GLOBAL-DEFINE page8Fields    

/***************************************************************************/
                                               /** Parameters Definitions **/

{abp/ab0706.i4} /* Temp-table tt-param */

/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
/***************************************************************************/
                                                  /** Defini‡Æo vari veis **/

DEFINE VARIABLE l-habilit-componentes AS LOGICAL      INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-gerencial-frotas AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-manut-doctos AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-analise-oleos AS LOGICAL    INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-pneus        AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-manut-mec    AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-ok                      as logical  INITIAL YES no-undo.

DEFINE VARIABLE c-terminal AS CHARACTER  NO-UNDO.

/** Vari veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}



/*zoom smart*/
/* DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.                      */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

{cdp/cdunif001.i} /*vari veis unifica‡Æo de conceito*/
DEF TEMP-TABLE tt_ccusto_integr NO-UNDO 
    FIELD ttv_cod_empresa      AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa"
    FIELD ttv_cod_plano_ccusto AS CHARACTER FORMAT "x(8)" LABEL "Plano CCusto" COLUMN-LABEL "Plano CCusto"
    FIELD ttv_cod_ccusto       AS CHARACTER FORMAT "x(20)" LABEL "Centro Custo" COLUMN-LABEL "Centro Custo"
    FIELD ttv_des_titulo       AS CHARACTER FORMAT "x(40)"
    INDEX tt_id                           
          ttv_cod_empresa                  ASCENDING 
          ttv_cod_plano_ccusto             ASCENDING
          ttv_cod_ccusto                   ASCENDING.

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

DEFINE VARIABLE fi-cc-tag AS CHARACTER FORMAT "X(20)":U 
     LABEL "C Custo TAG" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-tag LIKE estabelec.cod-estabel
     LABEL "Estabelecimento TAG":R7 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE text-cadpg1 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-EMS AS CHARACTER FORMAT "X(256)":U INITIAL "EMS" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE text-Evento AS CHARACTER FORMAT "X(256)":U INITIAL "Evento" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE text-Modelo AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE text-Motorista AS CHARACTER FORMAT "X(256)":U INITIAL "Motorista" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 5.75.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 4.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 7.75.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.25.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.25.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE VARIABLE tg-integr-cargo AS LOGICAL INITIAL no 
     LABEL "Integr. Cargos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-ativid AS LOGICAL INITIAL no 
     LABEL "Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-bomba AS LOGICAL INITIAL no 
     LABEL "Bomba" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-caract AS LOGICAL INITIAL no 
     LABEL "Caracter¡sticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-comptmento AS LOGICAL INITIAL no 
     LABEL "Compartimentos àleo/Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-consu-model AS LOGICAL INITIAL no 
     LABEL "Consumo PadrÆo por Modelo" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto-sub-sist AS LOGICAL INITIAL no 
     LABEL "Relac Grp Eqpto X Sub-Sist" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-estrut-mec AS LOGICAL INITIAL no 
     LABEL "Estrutura Mecƒnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-event AS LOGICAL INITIAL no 
     LABEL "Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Grupo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-grp-event AS LOGICAL INITIAL no 
     LABEL "Grupo Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-marca AS LOGICAL INITIAL no 
     LABEL "Marcas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-model AS LOGICAL INITIAL no 
     LABEL "Modelo - Equipamento/Compon." 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-motoris AS LOGICAL INITIAL no 
     LABEL "Motorista" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-motoris-model AS LOGICAL INITIAL no 
     LABEL "Motorista X Model Eqpto" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-posto AS LOGICAL INITIAL no 
     LABEL "Posto Abastecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-sist AS LOGICAL INITIAL no 
     LABEL "Sistema Mecƒnico" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-sit-eqpto AS LOGICAL INITIAL no 
     LABEL "Situa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-sub-sist AS LOGICAL INITIAL no 
     LABEL "Sub-Sistema" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-tip-mater AS LOGICAL INITIAL no 
     LABEL "Tipo Material" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-tip-mater-item AS LOGICAL INITIAL no 
     LABEL "Tipo Mat. X Item Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-trajeto AS LOGICAL INITIAL no 
     LABEL "Trajeto" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-marca-todos AS LOGICAL INITIAL no 
     LABEL "Marcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tempo-padr AS LOGICAL INITIAL no 
     LABEL "Tempo PadrÆo Execu‡Æo Servi‡os" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tab-unidade AS LOGICAL INITIAL no 
     LABEL "Cria Unidades de Medida PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tag AS LOGICAL INITIAL no 
     LABEL "Cria TAG PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-val-param AS LOGICAL INITIAL yes 
     LABEL "Valida Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE text-cadpg2 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 11.

DEFINE VARIABLE tg-mi-curso-trein AS LOGICAL INITIAL no 
     LABEL "Treinamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mi-espec AS LOGICAL INITIAL no 
     LABEL "Especialidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mi-turno AS LOGICAL INITIAL no 
     LABEL "Turnos" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mi-turno-ciclo AS LOGICAL INITIAL no 
     LABEL "Horas Turno" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-curso-trein AS LOGICAL INITIAL no 
     LABEL "Treinamentos Funcion rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-especialid AS LOGICAL INITIAL no 
     LABEL "Especialidade Funcion rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-ofici AS LOGICAL INITIAL no 
     LABEL "Funcion rio Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-turno AS LOGICAL INITIAL no 
     LABEL "Turnos Funcion rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-ofici AS LOGICAL INITIAL no 
     LABEL "Oficinas" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-param AS LOGICAL INITIAL no 
     LABEL "Parƒmetros Manuten‡Æo Mecƒnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-plandor AS LOGICAL INITIAL no 
     LABEL "Planejador das Ordens de Manuten‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-plano-prevent AS LOGICAL INITIAL no 
     LABEL "Plano Manuten‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-setor-ofici AS LOGICAL INITIAL no 
     LABEL "Setor Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano AS LOGICAL INITIAL no 
     LABEL "Item Plano Preventiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-epi AS LOGICAL INITIAL no 
     LABEL "Equipamentos Prote‡Æo Necess rios" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-esp AS LOGICAL INITIAL no 
     LABEL "Especialidade Associada Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-esp-curso AS LOGICAL INITIAL no 
     LABEL "Treinamentos da Especialidade da Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-ferram AS LOGICAL INITIAL no 
     LABEL "Ferramentas Necess rias" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-ficha AS LOGICAL INITIAL no 
     LABEL "Ficha M‚todo Associada Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-item AS LOGICAL INITIAL no 
     LABEL "Materias Necess rios Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE text-cadpg3 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-Pneu AS CHARACTER FORMAT "X(256)":U INITIAL "Pneu" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 7.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 7.

DEFINE VARIABLE tg-mpn-ambien-trab AS LOGICAL INITIAL no 
     LABEL "Ambiente Trabalho" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-desen AS LOGICAL INITIAL no 
     LABEL "Desenho" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-histor-vida AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Vida Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-km-esperad AS LOGICAL INITIAL no 
     LABEL "Durabilidade Esperada Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-layout AS LOGICAL INITIAL no 
     LABEL "Layout dos Eixos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-layout-eixo-pos AS LOGICAL INITIAL no 
     LABEL "Layout Eixo Posi‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-medid AS LOGICAL INITIAL no 
     LABEL "Medidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-model AS LOGICAL INITIAL no 
     LABEL "Modelo Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-param AS LOGICAL INITIAL no 
     LABEL "Parƒmetros Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-pneu AS LOGICAL INITIAL no 
     LABEL "Cadastro Pneus" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-pos-pneu AS LOGICAL INITIAL no 
     LABEL "Posi‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-serv AS LOGICAL INITIAL no 
     LABEL "Servi‡os" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-tip-borracha AS LOGICAL INITIAL no 
     LABEL "Tipo Borracha" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-tip-serv AS LOGICAL INITIAL no 
     LABEL "Tipo Servi‡o" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 2 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-AnaliseOl AS CHARACTER FORMAT "X(256)":U INITIAL "An lise de àleos" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE text-Componentes AS CHARACTER FORMAT "X(256)":U INITIAL "Componentes" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE text-Gerencial AS CHARACTER FORMAT "X(256)":U INITIAL "Gerencial Frotas" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE text-ManutDoctos AS CHARACTER FORMAT "X(256)":U INITIAL "Manuten‡Æo de Documentos" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.42.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 4.58.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.42.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 4.58.

DEFINE VARIABLE tg-mab-restdo-tab AS LOGICAL INITIAL no 
     LABEL "Resultados da Tabela" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-tab-restdo AS LOGICAL INITIAL no 
     LABEL "Tabela Resultados" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-usuar-estab AS LOGICAL INITIAL no 
     LABEL "Usu rio X Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-usuar-frota AS LOGICAL INITIAL no 
     LABEL "Usu rio Frotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mao-ensaio AS LOGICAL INITIAL no 
     LABEL "Ensaios" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mao-ensaio-padr AS LOGICAL INITIAL no 
     LABEL "Padräes de Ensaio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mco-compon AS LOGICAL INITIAL no 
     LABEL "Cadastro Componentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mco-histor-vida AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Vida Componente" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mco-plano-compon AS LOGICAL INITIAL no 
     LABEL "Plano X Componente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-event-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Evento X Grupo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-event-param AS LOGICAL INITIAL no 
     LABEL "Parametriza‡Æo Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-grp-estoq AS LOGICAL INITIAL no 
     LABEL "Grupo Estoque - Pneus" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-param AS LOGICAL INITIAL no 
     LABEL "Parƒmetro Gerencial Frotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mnd-proces-administ AS LOGICAL INITIAL no 
     LABEL "Processo Administrativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE text-cadastros AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 8.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-grpeqptomanut AS CHARACTER FORMAT "X(256)":U INITIAL "Grupo Equipamento Manuten‡Æo" 
      VIEW-AS TEXT 
     SIZE 24 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 7.38.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 2.29.

DEFINE VARIABLE tg-mab-comptmento-eqpto AS LOGICAL INITIAL no 
     LABEL "Compartimento Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-configur-eixo AS LOGICAL INITIAL no 
     LABEL "Configura‡Æo Eixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto AS LOGICAL INITIAL no 
     LABEL "Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto-caract AS LOGICAL INITIAL no 
     LABEL "Caracter¡sticas Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-ativid AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Setor Grupo Atividade Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-combust AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Combust¡vel Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-period-manut AS LOGICAL INITIAL no 
     LABEL "Per¡odo Manuten‡Æo Compartimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-programac-event AS LOGICAL INITIAL no 
     LABEL "Programa‡Æo de Eventos" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-eqpto-implto AS LOGICAL INITIAL no 
     LABEL "Equipamentos X Implementos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-eqpto-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Equipamento X Grupo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-eqpto-plano AS LOGICAL INITIAL no 
     LABEL "Equipamento Plano Manuten‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Grupo Equipamento Manuten‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-eqpto-serv AS LOGICAL INITIAL no 
     LABEL "Servi‡o de Pneus em Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-histor-layout-eixo AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Layout Eixo Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-hora-estimad AS LOGICAL INITIAL no 
     LABEL "Percurso Estimado Mensal" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-relac-eqpto-sub-sist AS LOGICAL INITIAL no 
     LABEL "Relac. Eqpto X Sub-Sist" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btInputDir 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE cInputDir AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Diret¢rio de Importa‡Æo" 
      VIEW-AS TEXT 
     SIZE 17.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 3.21.

DEFINE VARIABLE tg-atualiza AS LOGICAL INITIAL no 
     LABEL "Atualizar Cadastros J  Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.


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
     tg-mmv-param AT ROW 2.25 COL 14
     tg-mmv-ofici AT ROW 3.25 COL 14
     tg-mmv-setor-ofici AT ROW 4.25 COL 14
     tg-mmv-func-ofici AT ROW 5.25 COL 14
     tg-mmv-plandor AT ROW 6.25 COL 14
     tg-mi-turno AT ROW 7.25 COL 14 WIDGET-ID 12
     tg-mi-turno-ciclo AT ROW 8.25 COL 14 WIDGET-ID 14
     tg-mi-curso-trein AT ROW 9.25 COL 14 WIDGET-ID 10
     tg-mi-espec AT ROW 10.25 COL 14 WIDGET-ID 8
     tg-mmv-plano-prevent AT ROW 11.25 COL 14
     tg-mmv-tar-plano AT ROW 2.25 COL 46.14
     tg-mmv-tar-plano-item AT ROW 3.25 COL 46.14
     tg-mmv-tar-plano-epi AT ROW 4.25 COL 46.14
     tg-mmv-tar-plano-ferram AT ROW 5.25 COL 46.14
     tg-mmv-tar-plano-ficha AT ROW 6.25 COL 46.14
     tg-mmv-tar-plano-esp AT ROW 7.25 COL 46.14 WIDGET-ID 26
     tg-mmv-tar-plano-esp-curso AT ROW 8.25 COL 46.14 WIDGET-ID 28
     tg-mmv-func-turno AT ROW 9.25 COL 46.14 WIDGET-ID 30
     tg-mmv-func-curso-trein AT ROW 10.25 COL 46.14 WIDGET-ID 18
     tg-mmv-func-especialid AT ROW 11.25 COL 46.14 WIDGET-ID 20
     tg-marca-todos AT ROW 12.58 COL 61.14
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     text-cadpg2 AT ROW 1.25 COL 10.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     RECT-23 AT ROW 12.5 COL 59.14
     RECT-27 AT ROW 1.33 COL 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage1
     tg-val-param AT ROW 2.04 COL 4
     tg-tab-unidade AT ROW 3 COL 4
     tg-tag AT ROW 4 COL 4
     fi-estabel-tag AT ROW 4.96 COL 10 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento TAG":R7
     fi-cc-tag AT ROW 6 COL 10 COLON-ALIGNED
     tg-mab-marca AT ROW 8.29 COL 4
     tg-mab-model AT ROW 9.21 COL 4
     tg-mab-consu-model AT ROW 10.17 COL 4
     tg-mmv-tempo-padr AT ROW 11.08 COL 4
     tg-mab-ativid AT ROW 1.92 COL 35
     tg-mab-trajeto AT ROW 2.83 COL 35
     tg-mab-caract AT ROW 3.79 COL 35
     tg-mab-comptmento AT ROW 4.71 COL 35
     tg-mab-estrut-mec AT ROW 5.67 COL 35
     tg-mab-sist AT ROW 6.58 COL 35
     tg-mab-sub-sist AT ROW 7.38 COL 35
     tg-mab-sit-eqpto AT ROW 1.92 COL 60
     tg-mab-grp-eqpto AT ROW 2.83 COL 60
     tg-mab-eqpto-sub-sist AT ROW 3.79 COL 60
     tg-mab-posto AT ROW 4.71 COL 60
     tg-mab-bomba AT ROW 5.67 COL 60
     tg-mab-tip-mater AT ROW 6.58 COL 60
     tg-mab-tip-mater-item AT ROW 7.54 COL 60
     tg-mab-grp-event AT ROW 10 COL 35
     tg-mab-event AT ROW 10.96 COL 35
     tg-mab-motoris AT ROW 10 COL 60
     tg-mab-motoris-model AT ROW 10.96 COL 60
     tg-marca-todos AT ROW 12.17 COL 60
     text-EMS AT ROW 1.29 COL 3 COLON-ALIGNED HELP
          "EMS" NO-LABEL
     text-Modelo AT ROW 7.42 COL 3 COLON-ALIGNED HELP
          "Modelo" NO-LABEL
     text-cadpg1 AT ROW 1.25 COL 34.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     text-Evento AT ROW 9.38 COL 34 COLON-ALIGNED HELP
          "Evento" NO-LABEL
     text-Motorista AT ROW 9.33 COL 59 COLON-ALIGNED HELP
          "Motorista" NO-LABEL
     tg-integr-cargo AT ROW 8.25 COL 35
     RECT-17 AT ROW 1.5 COL 2
     RECT-18 AT ROW 7.63 COL 2
     RECT-19 AT ROW 1.5 COL 33
     RECT-20 AT ROW 9.63 COL 33
     RECT-21 AT ROW 9.63 COL 58
     RECT-22 AT ROW 12.08 COL 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage3
     tg-mpn-param AT ROW 3.5 COL 11
     tg-mpn-tip-borracha AT ROW 4.42 COL 11
     tg-mpn-medid AT ROW 5.38 COL 11
     tg-mpn-pos-pneu AT ROW 6.29 COL 11
     tg-mpn-layout AT ROW 7.25 COL 11
     tg-mpn-layout-eixo-pos AT ROW 8.17 COL 11
     tg-mpn-ambien-trab AT ROW 3.5 COL 34
     tg-mpn-serv AT ROW 4.42 COL 34
     tg-mpn-tip-serv AT ROW 5.38 COL 34
     tg-mpn-desen AT ROW 6.29 COL 34
     tg-mpn-km-esperad AT ROW 7.25 COL 34
     tg-mpn-model AT ROW 8.17 COL 34
     tg-mpn-pneu AT ROW 3.5 COL 61
     tg-mpn-histor-vida AT ROW 4.42 COL 61
     tg-marca-todos AT ROW 12.17 COL 60
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     text-cadpg3 AT ROW 2.54 COL 7.29 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     text-Pneu AT ROW 2.5 COL 60 COLON-ALIGNED HELP
          "Pneu" NO-LABEL
     RECT-24 AT ROW 12.08 COL 58
     RECT-28 AT ROW 2.75 COL 6
     RECT-29 AT ROW 2.75 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage7
     rsAll AT ROW 2.08 COL 3.29 NO-LABEL
     rsDestiny AT ROW 4.21 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 5.46 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btDestinyFile AT ROW 5.42 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 5.46 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.58 COL 3.14 HELP
          "Modo de Execu‡Æo" NO-LABEL
     cInputDir AT ROW 10.04 COL 3.29 HELP
          "Nome do Diret¢rio de Importa‡Æo" NO-LABEL
     btInputDir AT ROW 10 COL 43.29 HELP
          "Escolha do nome do arquivo"
     tg-atualiza AT ROW 11.42 COL 3.43
     text-imprime AT ROW 1.29 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.46 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 6.83 COL 1.14 COLON-ALIGNED NO-LABEL
     text-entrada AT ROW 9.08 COL 1.86 COLON-ALIGNED HELP
          "Diret¢rio de Importa‡Æo" NO-LABEL
     RECT-10 AT ROW 7.13 COL 2
     RECT-11 AT ROW 1.58 COL 2
     RECT-8 AT ROW 3.75 COL 2
     RECT-9 AT ROW 9.29 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage5
     tg-mab-eqpto AT ROW 2.33 COL 11
     tg-mab-histor-ativid AT ROW 3.25 COL 11
     tg-mab-histor-combust AT ROW 4.21 COL 11
     tg-mab-eqpto-caract AT ROW 5.13 COL 11
     tg-mab-comptmento-eqpto AT ROW 6.08 COL 11
     tg-mab-period-manut AT ROW 7.08 COL 11
     tg-mab-configur-eixo AT ROW 8.04 COL 11
     tg-mab-programac-event AT ROW 2.33 COL 49.43
     tg-mmv-eqpto-plano AT ROW 3.25 COL 49.43
     tg-mgf-eqpto-implto AT ROW 4.21 COL 49.43
     tg-mpn-histor-layout-eixo AT ROW 5.13 COL 49.43
     tg-mpn-eqpto-serv AT ROW 6.08 COL 49.43
     tg-mpn-hora-estimad AT ROW 7 COL 49.43
     tg-mmv-grp-eqpto AT ROW 9.83 COL 11
     tg-mmv-eqpto-grp-eqpto AT ROW 10.79 COL 11
     tg-marca-todos AT ROW 12.17 COL 60
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     text-cadastros AT ROW 1.54 COL 10.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     text-grpeqptomanut AT ROW 9.21 COL 10 COLON-ALIGNED HELP
          "Grupo Equipamento Manuten‡Æo" NO-LABEL
     tg-relac-eqpto-sub-sist AT ROW 7.92 COL 49.43
     RECT-26 AT ROW 12.08 COL 58
     RECT-34 AT ROW 1.75 COL 6
     RECT-35 AT ROW 9.46 COL 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage4
     tg-mco-compon AT ROW 2.63 COL 12.29
     tg-mco-histor-vida AT ROW 3.54 COL 12.29
     tg-mco-plano-compon AT ROW 4.5 COL 12.29
     tg-mab-tab-restdo AT ROW 6.67 COL 12
     tg-mab-restdo-tab AT ROW 7.58 COL 12
     tg-mao-ensaio AT ROW 8.54 COL 12
     tg-mao-ensaio-padr AT ROW 9.46 COL 12
     tg-mab-usuar-frota AT ROW 2.5 COL 47
     tg-mab-usuar-estab AT ROW 3.42 COL 47
     tg-mnd-proces-administ AT ROW 4.38 COL 47
     tg-mgf-param AT ROW 6.75 COL 47
     tg-mgf-event-param AT ROW 7.67 COL 47
     tg-mgf-event-grp-eqpto AT ROW 8.63 COL 47
     tg-mgf-grp-estoq AT ROW 9.54 COL 47
     tg-marca-todos AT ROW 12.17 COL 60
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     cInputFile AT ROW 12 COL 82 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     text-Componentes AT ROW 1.79 COL 9 COLON-ALIGNED HELP
          "Componentes" NO-LABEL
     text-AnaliseOl AT ROW 5.75 COL 9 COLON-ALIGNED HELP
          "An lise de àleos" NO-LABEL
     text-ManutDoctos AT ROW 1.75 COL 44 COLON-ALIGNED HELP
          "Manuten‡Æo de Documentos" NO-LABEL
     text-Gerencial AT ROW 5.75 COL 44.57 COLON-ALIGNED HELP
          "Gerencial Frotas" NO-LABEL
     RECT-25 AT ROW 12.08 COL 58
     RECT-30 AT ROW 2.08 COL 8
     RECT-31 AT ROW 6 COL 8
     RECT-32 AT ROW 2.08 COL 44
     RECT-33 AT ROW 6 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
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
         HEIGHT             = 17.08
         WIDTH              = 90
         MAX-HEIGHT         = 27.04
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.04
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

{report~/report.i}

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
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-estabel-tag IN FRAME fPage1
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
ASSIGN 
       text-cadpg1:PRIVATE-DATA IN FRAME fPage1     = 
                "Cadastros".

ASSIGN 
       text-EMS:PRIVATE-DATA IN FRAME fPage1     = 
                "EMS".

ASSIGN 
       text-Evento:PRIVATE-DATA IN FRAME fPage1     = 
                "Evento".

ASSIGN 
       text-Modelo:PRIVATE-DATA IN FRAME fPage1     = 
                "Modelo".

ASSIGN 
       text-Motorista:PRIVATE-DATA IN FRAME fPage1     = 
                "Motorista".

/* SETTINGS FOR FRAME fPage2
   L-To-R,COLUMNS                                                       */
ASSIGN 
       text-cadpg2:PRIVATE-DATA IN FRAME fPage2     = 
                "Cadastros".

/* SETTINGS FOR FRAME fPage3
   Custom                                                               */
ASSIGN 
       text-cadpg3:PRIVATE-DATA IN FRAME fPage3     = 
                "Cadastros".

ASSIGN 
       text-Pneu:PRIVATE-DATA IN FRAME fPage3     = 
                "Pneu".

/* SETTINGS FOR FRAME fPage4
   L-To-R,COLUMNS                                                       */
ASSIGN 
       text-AnaliseOl:PRIVATE-DATA IN FRAME fPage4     = 
                "An lise de àleos".

ASSIGN 
       text-Componentes:PRIVATE-DATA IN FRAME fPage4     = 
                "Componentes".

ASSIGN 
       text-Gerencial:PRIVATE-DATA IN FRAME fPage4     = 
                "Gerencial Frotas".

ASSIGN 
       text-ManutDoctos:PRIVATE-DATA IN FRAME fPage4     = 
                "Manuten‡Æo de Documentos".

/* SETTINGS FOR FRAME fPage5
   Custom                                                               */
ASSIGN 
       text-cadastros:PRIVATE-DATA IN FRAME fPage5     = 
                "Cadastros".

ASSIGN 
       text-grpeqptomanut:PRIVATE-DATA IN FRAME fPage5     = 
                "Grupo Equipamento Manuten‡Æo".

/* SETTINGS FOR FRAME fPage7
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage7     = 
                "Diret¢rio de Importa‡Æo".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btInputDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputDir wReport
ON CHOOSE OF btInputDir IN FRAME fPage7
DO:
    DEFINE VARIABLE l-cancelado AS LOGICAL    NO-UNDO.
    {utp/ut-liter.i Diret¢rio_de_Importa‡Æo *}
    run utp/ut-dir.p (input RETURN-VALUE,
                              output cInputDir,
                              output l-cancelado).

    IF l-cancelado = NO THEN
        DISP cInputDir WITH FRAME fPage7.

    APPLY "leave":U TO cInputDir IN FRAME fPage7.

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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME cInputDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cInputDir wReport
ON LEAVE OF cInputDir IN FRAME fPage7
DO:
    IF cInputDir:SCREEN-VALUE IN FRAME fPage7 <> "":U THEN DO:
        ASSIGN cInputDir = replace(cInputDir:SCREEN-VALUE IN FRAME fPage7, "~\":U, "/":U).
        IF SUBSTRING(cInputDir,LENGTH(cInputDir),1) <> "/":U THEN
            ASSIGN cInputDir = cInputDir + "/":U.
    END.
    display cInputDir with frame fPage7.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cc-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-tag wReport
ON F5 OF fi-cc-tag IN FRAME fPage1 /* C Custo TAG */
DO:

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_zoom_ccusto IN h_api_ccusto (INPUT "",                  /* EMPRESA EMS2 */
                                        INPUT "",                  /* CODIGO DO PLANO CCUSTO */
                                        INPUT "",                  /* UNIDADE DE NEGOCIO */
                                        INPUT TODAY,               /* DATA DE TRANSACAO */
                                        OUTPUT v_cod_ccusto,       /* CODIGO CCUSTO */
                                        OUTPUT v_des_ccusto,       /* DESCRICAO CCUSTO */
                                        OUTPUT TABLE tt_log_erro). /* ERROS */


    ASSIGN fi-cc-tag:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-tag wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cc-tag IN FRAME fPage1 /* C Custo TAG */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estabel-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estabel-tag wReport
ON F5 OF fi-estabel-tag IN FRAME fPage1 /* Estabelecimento TAG */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-estabel-tag
                     &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estabel-tag wReport
ON MOUSE-SELECT-DBLCLICK OF fi-estabel-tag IN FRAME fPage1 /* Estabelecimento TAG */
DO:
  APPLY "f5":U TO SELF.
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage2 /* Marcar Todos */
DO:
      DO WITH FRAME fPage2:
          IF tg-marca-todos:CHECKED THEN
              ASSIGN    tg-mmv-param:CHECKED = YES
                        tg-mmv-ofici:CHECKED = YES 
                        tg-mmv-setor-ofici:CHECKED = YES 
                        tg-mmv-func-ofici:CHECKED = YES 
                        tg-mmv-plandor:CHECKED = YES
                                                      
                        tg-mmv-plano-prevent:CHECKED = YES 
                        tg-mmv-tar-plano:CHECKED = YES 
                        tg-mmv-tar-plano-item:CHECKED = YES 
                        tg-mmv-tar-plano-epi:CHECKED = YES 
                        tg-mmv-tar-plano-ferram:CHECKED = YES 
                        tg-mmv-tar-plano-ficha:CHECKED = YES
                        tg-mmv-tar-plano-esp:CHECKED = YES 
                        tg-mmv-tar-plano-esp-curso:CHECKED = YES

                        tg-mi-espec:CHECKED = YES            
                        tg-mi-curso-trein:CHECKED = YES      
                        tg-mi-turno:CHECKED = YES            
                        tg-mi-turno-ciclo:CHECKED = YES      
                        tg-mmv-func-turno:CHECKED = YES      
                        tg-mmv-func-curso-trein:CHECKED = YES
                        tg-mmv-func-especialid:CHECKED = YES.

          ELSE               
              ASSIGN    tg-mmv-param:CHECKED = NO
                        tg-mmv-ofici:CHECKED = NO 
                        tg-mmv-setor-ofici:CHECKED = NO 
                        tg-mmv-func-ofici:CHECKED = NO 
                        tg-mmv-plandor:CHECKED = NO
                                                      
                        tg-mmv-plano-prevent:CHECKED = NO 
                        tg-mmv-tar-plano:CHECKED = NO 
                        tg-mmv-tar-plano-item:CHECKED = NO 
                        tg-mmv-tar-plano-epi:CHECKED = NO 
                        tg-mmv-tar-plano-ferram:CHECKED = NO 
                        tg-mmv-tar-plano-ficha:CHECKED = NO
                        tg-mmv-tar-plano-esp:CHECKED = NO 
                        tg-mmv-tar-plano-esp-curso:CHECKED = NO

                        tg-mi-espec:CHECKED = NO              
                        tg-mi-curso-trein:CHECKED = NO        
                        tg-mi-turno:CHECKED = NO              
                        tg-mi-turno-ciclo:CHECKED = NO        
                        tg-mmv-func-turno:CHECKED = NO        
                        tg-mmv-func-curso-trein:CHECKED = NO  
                        tg-mmv-func-especialid:CHECKED = NO.  
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage4 /* Marcar Todos */
DO:

    DO WITH FRAME fPage4:

        IF tg-marca-todos:CHECKED THEN DO:

            IF l-habilit-componentes THEN
                ASSIGN tg-mco-compon:CHECKED =  YES
                       tg-mco-histor-vida:checked =  YES
                       tg-mco-plano-compon:checked =  YES.

            IF l-habilit-analise-oleos THEN
                ASSIGN tg-mab-tab-restdo:checked =  YES
                       tg-mab-restdo-tab:checked =  YES
                       tg-mao-ensaio:checked =  YES
                       tg-mao-ensaio-padr:checked =  YES.

            IF l-habilit-manut-doctos THEN
                ASSIGN tg-mab-usuar-frota:checked =  YES
                       tg-mab-usuar-estab:checked =  YES
                       tg-mnd-proces-administ:checked =  YES.

            IF l-habilit-gerencial-frotas THEN
                ASSIGN tg-mgf-param:checked =  YES
                       tg-mgf-event-param:checked =  YES
                       tg-mgf-event-grp-eqpto:checked =  YES
                       tg-mgf-grp-estoq:checked =  YES.
        END.
        ELSE
            ASSIGN     tg-mco-compon:CHECKED =  NO
                       tg-mco-histor-vida:checked =  NO
                       tg-mco-plano-compon:checked =  NO
                       tg-mab-tab-restdo:checked =  NO
                       tg-mab-restdo-tab:checked =  NO
                       tg-mao-ensaio:checked =  NO
                       tg-mao-ensaio-padr:checked =  NO
                       tg-mab-usuar-frota:checked =  NO
                       tg-mab-usuar-estab:checked =  NO
                       tg-mnd-proces-administ:checked =  NO
                       tg-mgf-param:checked =  NO
                       tg-mgf-event-param:checked =  NO
                       tg-mgf-event-grp-eqpto:checked =  NO
                       tg-mgf-grp-estoq:checked =  NO.
    END.

END.

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
                ASSIGN tg-mmv-eqpto-plano:CHECKED  = YES
                       tg-mmv-grp-eqpto:CHECKED  = YES
                       tg-mmv-eqpto-grp-eqpto:CHECKED  = YES.
            IF l-habilit-pneus THEN
                ASSIGN tg-mab-configur-eixo:CHECKED = YES
                       tg-mpn-histor-layout-eixo:CHECKED = YES
                       tg-mpn-eqpto-serv:CHECKED = YES
                       tg-mpn-hora-estimad:CHECKED = YES.
    
            ASSIGN  tg-mab-eqpto:CHECKED  = YES
                    tg-mab-histor-ativid:CHECKED  = YES 
                    tg-mab-histor-combust:CHECKED  = YES 
                    tg-mab-eqpto-caract:CHECKED  = YES 
                    tg-mab-comptmento-eqpto:CHECKED  = YES 
                    tg-mab-period-manut:CHECKED  = YES
                    tg-mab-programac-event:CHECKED  = YES 
                    tg-mgf-eqpto-implto:CHECKED  = YES
                    tg-relac-eqpto-sub-sist:CHECKED = YES.
        END.
        ELSE
            ASSIGN  tg-mab-eqpto:CHECKED  = NO
                    tg-mab-histor-ativid:CHECKED  = NO 
                    tg-mab-histor-combust:CHECKED  = NO 
                    tg-mab-eqpto-caract:CHECKED  = NO 
                    tg-mab-comptmento-eqpto:CHECKED  = NO 
                    tg-mab-period-manut:CHECKED  = NO
                    tg-mab-programac-event:CHECKED  = NO 
                    tg-mgf-eqpto-implto:CHECKED  = NO
                    tg-mab-configur-eixo:CHECKED = NO      
                    tg-mpn-histor-layout-eixo:CHECKED = NO 
                    tg-mpn-eqpto-serv:CHECKED = NO         
                    tg-mpn-hora-estimad:CHECKED = NO
                    tg-mmv-eqpto-plano:CHECKED  = NO     
                    tg-mmv-grp-eqpto:CHECKED  = NO       
                    tg-mmv-eqpto-grp-eqpto:CHECKED  = NO
                    tg-relac-eqpto-sub-sist:CHECKED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage3 /* Marcar Todos */
DO:
    DO WITH FRAME fPage3:
          IF tg-marca-todos:CHECKED THEN
              ASSIGN    tg-mpn-param:CHECKED = YES
                        tg-mpn-tip-borracha:CHECKED = YES
                        tg-mpn-medid:CHECKED = YES 
                        tg-mpn-pos-pneu:CHECKED = YES 
                        tg-mpn-layout:CHECKED = YES 
                        tg-mpn-layout-eixo-pos:CHECKED = YES 
                        
                        tg-mpn-ambien-trab:CHECKED = YES 
                        tg-mpn-serv:CHECKED = YES 
                        tg-mpn-tip-serv:CHECKED = YES 
                        tg-mpn-desen:CHECKED = YES 
                        tg-mpn-km-esperad:CHECKED = YES 
                        tg-mpn-model:CHECKED = YES 
                                                      
                        tg-mpn-pneu:CHECKED = YES 
                        tg-mpn-histor-vida:CHECKED = YES.

              ELSE
                  ASSIGN    tg-mpn-param:CHECKED = NO
                            tg-mpn-tip-borracha:CHECKED = NO
                            tg-mpn-medid:CHECKED = NO 
                            tg-mpn-pos-pneu:CHECKED = NO 
                            tg-mpn-layout:CHECKED = NO 
                            tg-mpn-layout-eixo-pos:CHECKED = NO 
                            
                            tg-mpn-ambien-trab:CHECKED = NO 
                            tg-mpn-serv:CHECKED = NO 
                            tg-mpn-tip-serv:CHECKED = NO 
                            tg-mpn-desen:CHECKED = NO 
                            tg-mpn-km-esperad:CHECKED = NO 
                            tg-mpn-model:CHECKED = NO 
                                                          
                            tg-mpn-pneu:CHECKED = NO 
                            tg-mpn-histor-vida:CHECKED = NO.    

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage1 /* Marcar Todos */
DO:
    DO WITH FRAME fPage1:
          IF tg-marca-todos:CHECKED THEN
              ASSIGN    tg-val-param:checked = yes
                        tg-tab-unidade:CHECKED = YES
                        tg-tag:CHECKED = YES
                        tg-mab-marca:CHECKED = YES
                        tg-mab-model:CHECKED = YES 
                        tg-mab-consu-model:CHECKED = YES 
                        tg-mmv-tempo-padr:CHECKED = YES
                        tg-mab-ativid:CHECKED = YES 
                        tg-mab-trajeto:CHECKED = YES 
                        tg-mab-caract:CHECKED = YES 
                        tg-mab-comptmento:CHECKED = YES 
                        tg-mab-estrut-mec:CHECKED = YES 
                        tg-mab-sist:CHECKED = YES 
                        tg-mab-sub-sist:CHECKED = YES 
                        tg-mab-sit-eqpto:CHECKED = YES
                        tg-mab-grp-eqpto:CHECKED = YES 
                        tg-mab-eqpto-sub-sist:CHECKED = YES 
                        tg-mab-posto:CHECKED = YES 
                        tg-mab-bomba:CHECKED = YES 
                        tg-mab-tip-mater:CHECKED = YES 
                        tg-mab-tip-mater-item:CHECKED = YES
                        tg-mab-grp-event:CHECKED = YES
                        tg-mab-event:CHECKED = YES 
                        tg-mab-motoris:CHECKED = YES 
                        tg-mab-motoris-model:CHECKED = YES
                        tg-integr-cargo:CHECKED = YES.

          ELSE               
              assign    tg-val-param:checked = no
                        tg-tab-unidade:CHECKED = NO
                        tg-tag:CHECKED = NO
                        tg-mab-marca:CHECKED = NO
                        tg-mab-model:CHECKED = NO 
                        tg-mab-consu-model:CHECKED = NO 
                        tg-mmv-tempo-padr:CHECKED = NO
                        tg-mab-ativid:CHECKED = NO 
                        tg-mab-trajeto:CHECKED = NO 
                        tg-mab-caract:CHECKED = NO 
                        tg-mab-comptmento:CHECKED = NO 
                        tg-mab-estrut-mec:CHECKED = NO 
                        tg-mab-sist:CHECKED = NO 
                        tg-mab-sub-sist:CHECKED = NO 
                        tg-mab-sit-eqpto:CHECKED = NO
                        tg-mab-grp-eqpto:CHECKED = NO 
                        tg-mab-eqpto-sub-sist:CHECKED = NO 
                        tg-mab-posto:CHECKED = NO 
                        tg-mab-bomba:CHECKED = NO 
                        tg-mab-tip-mater:CHECKED = NO 
                        tg-mab-tip-mater-item:CHECKED = NO
                        tg-mab-grp-event:CHECKED = NO
                        tg-mab-event:CHECKED = NO 
                        tg-mab-motoris:CHECKED = NO 
                        tg-mab-motoris-model:CHECKED = NO
                        tg-integr-cargo:CHECKED = NO.
    END.
    APPLY "value-changed":U TO tg-tag.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-tag wReport
ON VALUE-CHANGED OF tg-tag IN FRAME fPage1 /* Cria TAG PadrÆo */
DO:
  IF tg-tag:CHECKED IN FRAME fPage1 THEN
      ASSIGN fi-estabel-tag:SENSITIVE IN FRAME fPage1 = YES
             fi-cc-tag:SENSITIVE IN FRAME fPage1 = YES.
  ELSE
      ASSIGN fi-estabel-tag:SENSITIVE IN FRAME fPage1 = NO   
             fi-cc-tag:SENSITIVE IN FRAME fPage1 = NO
             fi-estabel-tag:SCREEN-VALUE IN FRAME fPage1 = "":U 
             fi-cc-tag:SCREEN-VALUE IN FRAME fPage1 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializa‡Æo do programam ---*/
/* {report/mainblock.i} */

fi-estabel-tag:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
fi-cc-tag:load-mouse-pointer      ("image/lupa.cur") in frame fPage1.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padrÆo para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de RETURN padrÆo para FRAME fPage0 ---*/
ON RETURN OF FRAME fPage0 ANYWHERE
    RUN applyReturn IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padrÆo para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padrÆo para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON SHIFT-CTRL-TAB ANYWHERE
        RUN prevFolder IN hFolder.
&ENDIF

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- PadrÆo para janelas GUI ---*/
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

/* &IF defined(PGIMP) <> 0 &THEN         */
/*     &IF  "{&PGIMP}":U = "YES":U &THEN */
/*         {report/rpini.i}              */
/*     &ENDIF                            */
/* &ENDIF                                */
&IF defined(PGLOG) <> 0 &THEN
    &IF  "{&PGLOG}":U = "YES":U &THEN
        {report/imini.i}
    &ENDIF
&ENDIF

/* &IF defined(PGIMP) <> 0 &THEN         */
/*     &IF  "{&PGIMP}":U = "YES":U &THEN */
/*         {report/rplbl.i}              */
/*     &ENDIF                            */
/* &ENDIF                                */
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
    
/*  &IF defined(PGLAY) <> 0 &THEN      */
/*   &IF  "{&PGLAY}":U = "YES":U &THEN */
/*     {report/imvrf.i}                */
/*   &ENDIF                            */
/*  &ENDIF                             */
    
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* define procedure externa para execucao do programa de visualizacao do relatorio */

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccusto.
RUN pi_busca_ccustos_integr IN h_api_ccusto (INPUT  "",                     /* EMPRESA EMS2 */
                                             INPUT  "",                     /* CODIGO DO PLANO CCUSTO */
                                             INPUT  "",                     /* UNIDADE DE NEGOCIO */
                                             INPUT  TODAY,                  /* DATA DE TRANSACAO */
                                             OUTPUT TABLE tt_ccusto_integr, /* CCUSTOS */
                                             OUTPUT TABLE tt_log_erro).     /* ERROS */

{cdp/cdunif001b.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s a inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Valida Parƒmetros"}
assign tg-val-param:label in frame fPage1 = return-value.

ASSIGN cInputFile:SENSITIVE IN FRAME fPage4 = NO
       cInputFile:HIDDEN IN FRAME fPage4    = YES.


/*VERIFICA SE MODULO ESTµ IMPLANTADO E DESABILITA CAMPOS 
        CORRESPONDENTES CASO NAO ESTEJA*/
/*Componentes*/
RUN cdp/cd9902.p (INPUT 4).
IF RETURN-VALUE = "NOK":U THEN DO:
    ASSIGN l-habilit-componentes = NO.
    DO WITH FRAME fPage4:
        ASSIGN tg-mco-compon:SENSITIVE = NO
               tg-mco-histor-vida:SENSITIVE = NO
               tg-mco-plano-compon:SENSITIVE = NO.
    END.
END.
/*Analise de Oleo*/
RUN cdp/cd9902.p (INPUT 6).
IF RETURN-VALUE = "NOK":U THEN DO:
    ASSIGN l-habilit-analise-oleos = NO.
    DO WITH FRAME fPage4:
        ASSIGN tg-mab-tab-restdo:SENSITIVE = NO
               tg-mab-restdo-tab:SENSITIVE = NO
               tg-mao-ensaio:SENSITIVE = NO
               tg-mao-ensaio-padr:SENSITIVE = NO.
    END.
END.
/*Manut Doctos*/
RUN cdp/cd9902.p (INPUT 7).
IF RETURN-VALUE = "NOK":U THEN DO:
    ASSIGN l-habilit-manut-doctos = NO.
    DO WITH FRAME fPage4:
        ASSIGN tg-mab-usuar-frota:SENSITIVE = NO
               tg-mab-usuar-estab:SENSITIVE = NO
               tg-mnd-proces-administ:SENSITIVE = NO.
    END.
END.
/*Gerencial Frotas*/
RUN cdp/cd9902.p (INPUT 5).
IF RETURN-VALUE = "NOK":U THEN DO:
    ASSIGN l-habilit-gerencial-frotas = NO.
    DO WITH FRAME fPage4:
        ASSIGN tg-mgf-param:SENSITIVE = NO
               tg-mgf-event-param:SENSITIVE = NO
               tg-mgf-event-grp-eqpto:SENSITIVE = NO
               tg-mgf-grp-estoq:SENSITIVE = NO.
    END.
END.

IF l-habilit-componentes      = NO AND
   l-habilit-analise-oleos    = NO AND
   l-habilit-manut-doctos     = NO AND
   l-habilit-gerencial-frotas = NO THEN
    run setEnabled in hFolder (input 4, input false).

/*Manutencao Mecanica - pag 2*/
RUN cdp/cd9902.p (INPUT 3).
IF RETURN-VALUE = "NOK":U THEN DO:
    run setEnabled in hFolder (input 2, input false).
    ASSIGN l-habilit-manut-mec = NO
           tg-mmv-eqpto-plano:SENSITIVE IN FRAME fPage5 = NO
           tg-mmv-grp-eqpto:SENSITIVE IN FRAME fPage5 = NO
           tg-mmv-eqpto-grp-eqpto:SENSITIVE IN FRAME fPage5 = NO.
END.

/*Pneus - pag 3*/
RUN cdp/cd9902.p (INPUT 2).
IF RETURN-VALUE = "NOK":U THEN DO:
    run setEnabled in hFolder (input 3, input false).
    ASSIGN l-habilit-pneus = NO
           tg-mab-configur-eixo:SENSITIVE IN FRAME fPage5 = NO
           tg-mpn-histor-layout-eixo:SENSITIVE IN FRAME fPage5 = NO
           tg-mpn-eqpto-serv:SENSITIVE IN FRAME fPage5 = NO
           tg-mpn-hora-estimad:SENSITIVE IN FRAME fPage5 = NO.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     Executa as valida‡äes padräes e chama o RP de importa‡Æo.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

/* &IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN                      */
/* /***************************************************************************/ */
/*                                                           /*** Relat¢rio ***/ */
/* &ELSE                                                                         */
/***************************************************************************/
                                              /*** Importa‡Æo/Exporta‡Æo ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}
    /** Valida‡Æo arquivo destino **/
    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "").
            RUN setFolder IN hFolder (INPUT 6).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.execucao        = input frame fPage7 rsExecution
           tt-param.dir-entrada     = input frame fPage7 cInputDir
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.i-origem        = 1 /** Importa‡Æo **/    
           tt-param.l-atualiza      = tg-atualiza:CHECKED IN FRAME fPage7
                    /* 1*/                      
           tt-param.l-tab-unidade             =     tg-tab-unidade:CHECKED IN FRAME fPage1     
           tt-param.l-tag                     =     tg-tag:CHECKED IN FRAME fPage1                 
           tt-param.c-estab-tag               =     fi-estabel-tag:SCREEN-VALUE IN FRAME fPage1
           tt-param.c-cc-tag                  =     fi-cc-tag:SCREEN-VALUE IN FRAME fPage1            
           tt-param.l-mab-marca               =     tg-mab-marca:CHECKED IN FRAME fPage1           
           tt-param.l-mab-model               =     tg-mab-model:CHECKED IN FRAME fPage1           
           tt-param.l-mab-consu-model         =     tg-mab-consu-model:CHECKED IN FRAME fPage1     
           tt-param.l-mmv-tempo-padr          =     tg-mmv-tempo-padr:CHECKED IN FRAME fPage1      
           tt-param.l-mab-ativid              =     tg-mab-ativid:CHECKED IN FRAME fPage1          
           tt-param.l-mab-trajeto             =     tg-mab-trajeto:CHECKED IN FRAME fPage1         
           tt-param.l-mab-caract              =     tg-mab-caract:CHECKED IN FRAME fPage1          
           tt-param.l-mab-comptmento          =     tg-mab-comptmento:CHECKED IN FRAME fPage1      
           tt-param.l-mab-estrut-mec          =     tg-mab-estrut-mec:CHECKED IN FRAME fPage1      
           tt-param.l-mab-sist                =     tg-mab-sist:CHECKED IN FRAME fPage1            
           tt-param.l-mab-sub-sist            =     tg-mab-sub-sist:CHECKED IN FRAME fPage1        
           tt-param.l-mab-sit-eqpto           =     tg-mab-sit-eqpto:CHECKED IN FRAME fPage1       
           tt-param.l-mab-grp-eqpto           =     tg-mab-grp-eqpto:CHECKED IN FRAME fPage1       
           tt-param.l-mab-eqpto-sub-sist      =     tg-mab-eqpto-sub-sist:CHECKED IN FRAME fPage1  
           tt-param.l-mab-posto               =     tg-mab-posto:CHECKED IN FRAME fPage1           
           tt-param.l-mab-bomba               =     tg-mab-bomba:CHECKED IN FRAME fPage1           
           tt-param.l-mab-tip-mater           =     tg-mab-tip-mater:CHECKED IN FRAME fPage1       
           tt-param.l-mab-tip-mater-item      =     tg-mab-tip-mater-item:CHECKED IN FRAME fPage1  
           tt-param.l-mab-grp-event           =     tg-mab-grp-event:CHECKED IN FRAME fPage1       
           tt-param.l-mab-event               =     tg-mab-event:CHECKED IN FRAME fPage1        
           tt-param.l-mab-motoris             =     tg-mab-motoris:CHECKED IN FRAME fPage1   
           tt-param.l-mab-motoris-model       =     tg-mab-motoris-model:CHECKED IN FRAME fPage1
           tt-param.l-mab-integr-cargo        =     tg-integr-cargo:CHECKED IN FRAME fPage1
           tt-param.l-val-param               =     tg-val-param:checked in frame fPage1
                    /* 2*/                    
           tt-param.l-mmv-param               =     tg-mmv-param:CHECKED IN FRAME fPage2
           tt-param.l-mmv-ofici               =     tg-mmv-ofici:CHECKED IN FRAME fPage2           
           tt-param.l-mmv-setor-ofici         =     tg-mmv-setor-ofici:CHECKED IN FRAME fPage2     
           tt-param.l-mmv-func-ofici          =     tg-mmv-func-ofici:CHECKED IN FRAME fPage2      
           tt-param.l-mmv-plandor             =     tg-mmv-plandor:CHECKED IN FRAME fPage2         
           tt-param.l-mmv-plano-prevent       =     tg-mmv-plano-prevent:CHECKED IN FRAME fPage2   
           tt-param.l-mmv-tar-plano           =     tg-mmv-tar-plano:CHECKED IN FRAME fPage2       
           tt-param.l-mmv-tar-plano-item      =     tg-mmv-tar-plano-item:CHECKED IN FRAME fPage2  
           tt-param.l-mmv-tar-plano-epi       =     tg-mmv-tar-plano-epi:CHECKED IN FRAME fPage2   
           tt-param.l-mmv-tar-plano-ferram    =     tg-mmv-tar-plano-ferram:CHECKED IN FRAME fPage2
           tt-param.l-mmv-tar-plano-ficha     =     tg-mmv-tar-plano-ficha:CHECKED IN FRAME fPage2 
           tt-param.l-mmv-tar-plano-esp       =     tg-mmv-tar-plano-esp:CHECKED IN FRAME fPage2
           tt-param.l-mmv-tar-plano-esp-curso =     tg-mmv-tar-plano-esp-curso:CHECKED IN FRAME fPage2
           tt-param.l-mi-espec                =     tg-mi-espec:CHECKED IN FRAME fPage2            
           tt-param.l-mi-curso-trein          =     tg-mi-curso-trein:CHECKED IN FRAME fPage2      
           tt-param.l-mi-turno                =     tg-mi-turno:CHECKED IN FRAME fPage2            
           tt-param.l-mi-turno-ciclo          =     tg-mi-turno-ciclo:CHECKED IN FRAME fPage2      
           tt-param.l-mmv-func-turno          =     tg-mmv-func-turno:CHECKED IN FRAME fPage2      
           tt-param.l-mmv-func-curso-trein    =     tg-mmv-func-curso-trein:CHECKED IN FRAME fPage2
           tt-param.l-mmv-func-especialid     =     tg-mmv-func-especialid:CHECKED IN FRAME fPage2 
                    /* 3*/                         
           tt-param.l-mpn-param               =     tg-mpn-param:CHECKED IN FRAME fPage3
           tt-param.l-mpn-tip-borracha        =     tg-mpn-tip-borracha:CHECKED IN FRAME fPage3   
           tt-param.l-mpn-medid               =     tg-mpn-medid:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-pos-pneu            =     tg-mpn-pos-pneu:CHECKED IN FRAME fPage3       
           tt-param.l-mpn-layout              =     tg-mpn-layout:CHECKED IN FRAME fPage3         
           tt-param.l-mpn-layout-eixo-pos     =     tg-mpn-layout-eixo-pos:CHECKED IN FRAME fPage3
           tt-param.l-mpn-ambien-trab         =     tg-mpn-ambien-trab:CHECKED IN FRAME fPage3    
           tt-param.l-mpn-serv                =     tg-mpn-serv:CHECKED IN FRAME fPage3           
           tt-param.l-mpn-tip-serv            =     tg-mpn-tip-serv:CHECKED IN FRAME fPage3       
           tt-param.l-mpn-desen               =     tg-mpn-desen:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-km-esperad          =     tg-mpn-km-esperad:CHECKED IN FRAME fPage3     
           tt-param.l-mpn-model               =     tg-mpn-model:CHECKED IN FRAME fPage3          
           tt-param.l-mpn-pneu                =     tg-mpn-pneu:CHECKED IN FRAME fPage3           
           tt-param.l-mpn-histor-vida         =     tg-mpn-histor-vida:CHECKED IN FRAME fPage3    
                    /* 4*/                    
           tt-param.l-mco-compon              =     tg-mco-compon:CHECKED IN FRAME fPage4             
           tt-param.l-mco-histor-vida         =     tg-mco-histor-vida:CHECKED IN FRAME fPage4     
           tt-param.l-mco-plano-compon        =     tg-mco-plano-compon:CHECKED IN FRAME fPage4    
           tt-param.l-mab-tab-restdo          =     tg-mab-tab-restdo:CHECKED IN FRAME fPage4      
           tt-param.l-mab-restdo-tab          =     tg-mab-restdo-tab:CHECKED IN FRAME fPage4      
           tt-param.l-mao-ensaio              =     tg-mao-ensaio:CHECKED IN FRAME fPage4          
           tt-param.l-mao-ensaio-padr         =     tg-mao-ensaio-padr:CHECKED IN FRAME fPage4     
           tt-param.l-mab-usuar-frota         =     tg-mab-usuar-frota:CHECKED IN FRAME fPage4     
           tt-param.l-mab-usuar-estab         =     tg-mab-usuar-estab:CHECKED IN FRAME fPage4     
           tt-param.l-mnd-proces-administ     =     tg-mnd-proces-administ:CHECKED IN FRAME fPage4 
           tt-param.l-mgf-param               =     tg-mgf-param:CHECKED IN FRAME fPage4           
           tt-param.l-mgf-event-param         =     tg-mgf-event-param:CHECKED IN FRAME fPage4     
           tt-param.l-mgf-event-grp-eqpto     =     tg-mgf-event-grp-eqpto:CHECKED IN FRAME fPage4 
           tt-param.l-mgf-grp-estoq           =     tg-mgf-grp-estoq:CHECKED IN FRAME fPage4       
                    /* 5*/                      
           tt-param.l-mab-eqpto                =     tg-mab-eqpto:CHECKED IN FRAME fPage5             
           tt-param.l-mab-histor-ativid        =     tg-mab-histor-ativid:CHECKED IN FRAME fPage5      
           tt-param.l-mab-histor-combust       =     tg-mab-histor-combust:CHECKED IN FRAME fPage5     
           tt-param.l-mab-eqpto-caract         =     tg-mab-eqpto-caract:CHECKED IN FRAME fPage5       
           tt-param.l-mab-comptmento-eqpto     =     tg-mab-comptmento-eqpto:CHECKED IN FRAME fPage5   
           tt-param.l-mab-period-manut         =     tg-mab-period-manut:CHECKED IN FRAME fPage5       
           tt-param.l-mab-configur-eixo        =     tg-mab-configur-eixo:CHECKED IN FRAME fPage5      
           tt-param.l-mab-programac-event      =     tg-mab-programac-event:CHECKED IN FRAME fPage5    
           tt-param.l-mmv-eqpto-plano          =     tg-mmv-eqpto-plano:CHECKED IN FRAME fPage5        
           tt-param.l-mgf-eqpto-implto         =     tg-mgf-eqpto-implto:CHECKED IN FRAME fPage5       
           tt-param.l-mpn-histor-layout-eixo   =     tg-mpn-histor-layout-eixo:CHECKED IN FRAME fPage5 
           tt-param.l-mpn-eqpto-serv           =     tg-mpn-eqpto-serv:CHECKED IN FRAME fPage5         
           tt-param.l-mpn-hora-estimad         =     tg-mpn-hora-estimad:CHECKED IN FRAME fPage5       
           tt-param.l-mmv-grp-eqpto            =     tg-mmv-grp-eqpto:CHECKED IN FRAME fPage5          
           tt-param.l-mmv-eqpto-grp-eqpto      =     tg-mmv-eqpto-grp-eqpto:CHECKED IN FRAME fPage5
           tt-param.l-mab-relac-eqpto-sub-sist =     tg-relac-eqpto-sub-sist:CHECKED IN FRAME fPage5.

    /*executa as validacoes dos dados da tela, e verifica a existencia dos arquivos de importa‡Æo.*/
    RUN piValidacoes IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.


    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.


    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i abp/ab0706rp.p}

    {report/imexc.i}

    if  session:set-wait-state("") then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.
/* &ENDIF */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidacoes wReport 
PROCEDURE piValidacoes :
/*------------------------------------------------------------------------------
  Purpose:    Validacoes da Importa‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.l-mab-marca               =  NO AND 
   tt-param.l-mab-model               =  NO AND 
   tt-param.l-mab-consu-model         =  NO AND 
   tt-param.l-mmv-tempo-padr          =  NO AND 
   tt-param.l-mab-ativid              =  NO AND 
   tt-param.l-mab-trajeto             =  NO AND 
   tt-param.l-mab-caract              =  NO AND 
   tt-param.l-mab-comptmento          =  NO AND 
   tt-param.l-mab-estrut-mec          =  NO AND 
   tt-param.l-mab-sist                =  NO AND 
   tt-param.l-mab-sub-sist            =  NO AND 
   tt-param.l-mab-sit-eqpto           =  NO AND 
   tt-param.l-mab-grp-eqpto           =  NO AND 
   tt-param.l-mab-eqpto-sub-sist      =  NO AND 
   tt-param.l-mab-posto               =  NO AND 
   tt-param.l-mab-bomba               =  NO AND 
   tt-param.l-mab-tip-mater           =  NO AND 
   tt-param.l-mab-tip-mater-item      =  NO AND 
   tt-param.l-mab-grp-event           =  NO AND 
   tt-param.l-mab-event               =  NO AND
   tt-param.l-mab-integr-cargo        =  NO AND
   tt-param.l-mab-motoris             =  NO AND
   tt-param.l-mab-motoris-model       =  NO AND
            /* 2*/                       
   tt-param.l-mmv-param               =  NO AND 
   tt-param.l-mmv-ofici               =  NO AND 
   tt-param.l-mmv-setor-ofici         =  NO AND 
   tt-param.l-mmv-func-ofici          =  NO AND 
   tt-param.l-mmv-plandor             =  NO AND 
   tt-param.l-mmv-plano-prevent       =  NO AND 
   tt-param.l-mmv-tar-plano           =  NO AND 
   tt-param.l-mmv-tar-plano-item      =  NO AND 
   tt-param.l-mmv-tar-plano-epi       =  NO AND 
   tt-param.l-mmv-tar-plano-ferram    =  NO AND 
   tt-param.l-mmv-tar-plano-ficha     =  NO AND 
   tt-param.l-mmv-tar-plano-esp       =  NO AND 
   tt-param.l-mmv-tar-plano-esp-curso =  NO AND 
   tt-param.l-mi-espec                =  NO AND 
   tt-param.l-mi-curso-trein          =  NO AND 
   tt-param.l-mi-turno                =  NO AND 
   tt-param.l-mi-turno-ciclo          =  NO AND 
   tt-param.l-mmv-func-turno          =  NO AND 
   tt-param.l-mmv-func-curso-trein    =  NO AND 
   tt-param.l-mmv-func-especialid     =  NO AND 
            /* 3*/                       
   tt-param.l-mpn-param               =  NO AND 
   tt-param.l-mpn-tip-borracha        =  NO AND 
   tt-param.l-mpn-medid               =  NO AND 
   tt-param.l-mpn-pos-pneu            =  NO AND 
   tt-param.l-mpn-layout              =  NO AND 
   tt-param.l-mpn-layout-eixo-pos     =  NO AND 
   tt-param.l-mpn-ambien-trab         =  NO AND 
   tt-param.l-mpn-serv                =  NO AND 
   tt-param.l-mpn-tip-serv            =  NO AND 
   tt-param.l-mpn-desen               =  NO AND 
   tt-param.l-mpn-km-esperad          =  NO AND 
   tt-param.l-mpn-model               =  NO AND 
   tt-param.l-mpn-pneu                =  NO AND 
   tt-param.l-mpn-histor-vida         =  NO AND 
            /* 4*/                      
   tt-param.l-mco-compon              =  NO AND 
   tt-param.l-mco-histor-vida         =  NO AND 
   tt-param.l-mco-plano-compon        =  NO AND 
   tt-param.l-mab-tab-restdo          =  NO AND 
   tt-param.l-mab-restdo-tab          =  NO AND 
   tt-param.l-mao-ensaio              =  NO AND 
   tt-param.l-mao-ensaio-padr         =  NO AND 
   tt-param.l-mab-usuar-frota         =  NO AND 
   tt-param.l-mab-usuar-estab         =  NO AND 
   tt-param.l-mnd-proces-administ     =  NO AND 
   tt-param.l-mgf-param               =  NO AND 
   tt-param.l-mgf-event-param         =  NO AND 
   tt-param.l-mgf-event-grp-eqpto     =  NO AND 
   tt-param.l-mgf-grp-estoq           =  NO AND 
            /* 5*/                       
   tt-param.l-mab-eqpto                = NO AND 
   tt-param.l-mab-histor-ativid        = NO AND 
   tt-param.l-mab-histor-combust       = NO AND 
   tt-param.l-mab-eqpto-caract         = NO AND 
   tt-param.l-mab-comptmento-eqpto     = NO AND 
   tt-param.l-mab-period-manut         = NO AND 
   tt-param.l-mab-configur-eixo        = NO AND 
   tt-param.l-mab-programac-event      = NO AND 
   tt-param.l-mmv-eqpto-plano          = NO AND 
   tt-param.l-mgf-eqpto-implto         = NO AND 
   tt-param.l-mpn-histor-layout-eixo   = NO AND 
   tt-param.l-mpn-eqpto-serv           = NO AND 
   tt-param.l-mpn-hora-estimad         = NO AND
   tt-param.l-mmv-grp-eqpto            = NO AND
   tt-param.l-mmv-eqpto-grp-eqpto      = NO and
   tt-param.l-mab-relac-eqpto-sub-sist = NO THEN DO:

    /*se nenhuma tabela estiver selecionada, mas estiver selecionado Unidade ou TAG, entao rodar a importa‡Æo*/
    IF  tt-param.l-tab-unidade OR
        tt-param.l-tag         THEN DO:

        IF tt-param.l-tag THEN DO:
            RUN validaPag1 IN THIS-PROCEDURE.
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.

        RETURN "OK":U.

    END.
    IF  tt-param.l-val-param THEN DO:
        IF tt-param.l-val-param THEN DO:
            RUN validaPag1 IN THIS-PROCEDURE.
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        end.

        RETURN "OK":U.

    end.
    ELSE DO:
         /*Pelo menos um cadastro deve ser selecionado para Importa‡Æo*/
         RUN utp/ut-msgs.p (INPUT 'show':U,                            
                            INPUT 30660,                               
                            INPUT "":U). 
         RETURN "NOK":U.     
    END.
END.
ELSE DO:
    IF tt-param.dir-entrada = "":U THEN DO:
        /*Diretorio de Importa‡Æo em Branco*/
        {utp/ut-liter.i Diret¢rio_de_Importa‡Æo *}
        RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                           INPUT 3145,
                           INPUT RETURN-VALUE).
        RUN setFolder IN hFolder (INPUT 6).
        apply "ENTRY":U to cInputDir in frame fPage7.               
        RETURN "NOK":U.
    end.
    ELSE DO:
        RUN validaPag1 IN THIS-PROCEDURE.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN validaPag2 IN THIS-PROCEDURE.
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN validaPag3 IN THIS-PROCEDURE.
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN validaPag4 IN THIS-PROCEDURE.
                    IF RETURN-VALUE = "OK":U THEN
                        RUN validaPag5 IN THIS-PROCEDURE.
                end.
            end.
        end.
    end.
end.

IF RETURN-VALUE = "OK":U THEN
    RETURN "OK":U.
ELSE
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaArquivo wReport 
PROCEDURE validaArquivo :
/*------------------------------------------------------------------------------
  Purpose:     Valida o arquivo de importa‡Æo .txt
  Parameters:  nome do .txt, nome da tabela (cadastro)
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pArquivo AS CHAR FORMAT "X(9)":U NO-UNDO.
DEF INPUT PARAM pNomCadastro AS CHAR FORMAT "X(50)":U NO-UNDO.

RUN utp/ut-liter.p (trim(pNomCadastro), "*", "").
if search(tt-param.dir-entrada + pArquivo) = ? THEN DO:
         /*O Arquivo de Importa‡Æo &2, referente ao Cadastro &1, nÆo foi encontrado no Diret¢rio de Importa‡Æo &3 indicado.*/
         RUN utp/ut-msgs.p (INPUT 'show':U,                            
                            INPUT 30655,                               
                            INPUT RETURN-VALUE + "~~" + pArquivo + "~~" + tt-param.dir-entrada). 
         RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPag1 wReport 
PROCEDURE validaPag1 :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes da Pag 1.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param.l-tag  THEN DO:
    /*estabel da tag*/
    IF tt-param.c-estab-tag =  "":U  THEN DO:
        /*Estabel tag branco*/
         {utp/ut-liter.i Estabelecimento_TAG *}
         RUN utp/ut-msgs.p (INPUT 'show':U,                            
                            INPUT 3145,                               
                            INPUT RETURN-VALUE). 
         ASSIGN l-ok = NO.   

    END.
    ELSE
        IF NOT CAN-FIND (FIRST estabelec WHERE estabelec.cod-estabel = tt-param.c-estab-tag NO-LOCK) THEN DO:
            /*nao existe estabel para a chave informada*/
             {utp/ut-liter.i Estabelecimento *}
             RUN utp/ut-msgs.p (INPUT 'show':U,                            
                                INPUT 2,                               
                                INPUT RETURN-VALUE). 
             ASSIGN l-ok = NO.   
        END.

    /*ccusto da tag*/
    IF tt-param.c-cc-tag =  "":U  THEN DO:
        /*ccusto tag branco*/
         {utp/ut-liter.i Centro_de_Custo_TAG *}
         RUN utp/ut-msgs.p (INPUT 'show':U,                            
                            INPUT 3145,                               
                            INPUT RETURN-VALUE). 
         ASSIGN l-ok = NO.   
    END.
    ELSE
        IF NOT CAN-FIND (FIRST tt_ccusto_integr WHERE tt_ccusto_integr.ttv_cod_ccusto = tt-param.c-cc-tag NO-LOCK) THEN DO:
            /*nao existe ccusto para a chave informada*/
             {utp/ut-liter.i Centro_de_Custo *}
             RUN utp/ut-msgs.p (INPUT 'show':U,                            
                                INPUT 2,                               
                                INPUT RETURN-VALUE). 
             ASSIGN l-ok = NO.   
        END.
END.


IF tt-param.l-mab-marca THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr015.txt":U, INPUT "Marcas":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-model THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr016.txt":U, INPUT "Modelo - Equipamento/Componente":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-consu-model THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr006.txt":U, INPUT "Consumo PadrÆo por Modelo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tempo-padr THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr078.txt":U, INPUT "Tempo PadrÆo Execu‡Æo Servi‡os":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-ativid THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr001.txt":U, INPUT "Atividades":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-trajeto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr028.txt":U, INPUT "Trajeto":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-caract THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr098.txt":U, INPUT "Caracter¡sticas":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-comptmento THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr003.txt":U, INPUT "Compartimentos àleo/Filtros":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-estrut-mec THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr009.txt":U, INPUT "Estrutura Mecƒnica":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-sist THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr023.txt":U, INPUT "Sistema Mecƒnico":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-sub-sist THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr025.txt":U, INPUT "Sub-Sistema":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-sit-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr024.txt":U, INPUT "Situa‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-grp-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr011.txt":U, INPUT "Grupo Equipamento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-eqpto-sub-sist THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr008.txt":U, INPUT "Rela‡Æo Grupo Equipamento X Sub-Sistema":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-posto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr021.txt":U, INPUT "Posto Abastecimento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-bomba THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr002.txt":U, INPUT "Bomba":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-tip-mater THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr026.txt":U, INPUT "Tipo Material":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-tip-mater-item THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr027.txt":U, INPUT "Tipo Material X Item Estoque":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-grp-event THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr012.txt":U, INPUT "Grupo Evento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-event THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr010.txt":U, INPUT "Evento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-motoris THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr017.txt":U, INPUT "Motorista":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-motoris-model THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr018.txt":U, INPUT "Motorista X Modelo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-integr-cargo THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr107.txt":U, INPUT "Integra‡Æo Cargos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.


IF l-ok = NO THEN DO:
    ASSIGN l-ok = YES.
    RUN setFolder IN hFolder (INPUT 1).
    RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPag2 wReport 
PROCEDURE validaPag2 :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes da Pag 2.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param.l-mmv-param THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr034.txt":U, INPUT "Parƒmetros Manuten‡Æo Mecƒnica":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-ofici THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr033.txt":U, INPUT "Oficinas":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-setor-ofici THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr036.txt":U, INPUT "Setor Oficina":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-func-ofici THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr032.txt":U, INPUT "Funcion rio Oficina":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-plandor THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr077.txt":U, INPUT "Planejador das Ordens de Manuten‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-plano-prevent THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr035.txt":U, INPUT "Plano Manuten‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tar-plano THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr037.txt":U, INPUT "Item Plano Preventiva":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tar-plano-item THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr041.txt":U, INPUT "Materiais Necess rios Tarefa":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tar-plano-epi THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr038.txt":U, INPUT "Equipamentos Prote‡Æo Necess rios":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tar-plano-ferram THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr039.txt":U, INPUT "Ferramentas Necess rias":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-tar-plano-ficha THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr040.txt":U, INPUT "Ficha M‚todo Associada Tarefa":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mmv-tar-plano-esp THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr00145.txt":U, INPUT "Especialidade Associada Tarefa":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mmv-tar-plano-esp-curso THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr00146.txt":U, INPUT "Treinamentos da Especialidade da Tarefa":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mi-espec THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "mn112.txt":U, INPUT "Especialidade":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mi-curso-trein THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "mn267.txt":U, INPUT "Treinamentos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mi-turno THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "mn015.txt":U, INPUT "Turnos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mi-turno-ciclo THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "mn016.txt":U, INPUT "Horas Turno":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mmv-func-turno THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr00142.txt":U, INPUT "Turnos Funcion rio":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mmv-func-curso-trein THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr144.txt":U, INPUT "Treinamentos Funcion rio":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF tt-param.l-mmv-func-especialid  THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr00143.txt":U, INPUT "Especialidade Funcion rio":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
                
          
IF l-ok = NO THEN DO:
    ASSIGN l-ok = YES.
    RUN setFolder IN hFolder (INPUT 2).
    RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPag3 wReport 
PROCEDURE validaPag3 :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes da Pag 3.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param.l-mpn-param THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr094.txt":U, INPUT "Parƒmetros Pneu":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-tip-borracha THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr054.txt":U, INPUT "Tipo Borracha":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-medid THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr049.txt":U, INPUT "Medidas":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-pos-pneu THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr052.txt":U, INPUT "Posi‡äes":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-layout THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr047.txt":U, INPUT "Layout dos Eixos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-layout-eixo-pos THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr048.txt":U, INPUT "Layout Eixo Posi‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-ambien-trab THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr042.txt":U, INPUT "Ambiente Trabalho":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-serv THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr053.txt":U, INPUT "Servi‡os":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-tip-serv THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr124.txt":U, INPUT "Tipo Servi‡o":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-desen THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr043.txt":U, INPUT "Desenho":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-km-esperad THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr046.txt":U, INPUT "Durabilidade Esperada Pneu":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-model THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr050.txt":U, INPUT "Modelo Pneu":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-pneu THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr051.txt":U, INPUT "Pneu":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-histor-vida THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr045.txt":U, INPUT "Hist¢rico Vida Pneu":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF l-ok = NO THEN DO:
    ASSIGN l-ok = YES.
    RUN setFolder IN hFolder (INPUT 3).
    RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPag4 wReport 
PROCEDURE validaPag4 :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes da Pag 4.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Componente*/
IF l-habilit-componentes THEN DO:

    IF tt-param.l-mco-compon THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr029.txt":U, INPUT "Componentes":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mco-histor-vida THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr030.txt":U, INPUT "Hist¢rico Vida Componente":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mco-plano-compon THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr100.txt":U, INPUT "Plano X Componente":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.

END.

/*Analise Oleos*/
IF l-habilit-analise-oleos THEN DO:
    IF tt-param.l-mab-tab-restdo THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr102.txt":U, INPUT "Tabela de Resultados":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mab-restdo-tab THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr101.txt":U, INPUT "Resultados da Tabela":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mao-ensaio THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr103.txt":U, INPUT "Ensaios":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mao-ensaio-padr THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr104.txt":U, INPUT "Padräes Ensaios":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
END.

/*Manut Doctos*/
IF l-habilit-manut-doctos THEN DO:
    IF tt-param.l-mab-usuar-frota THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr114.txt":U, INPUT "Usu rio Frotas":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mab-usuar-estab THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr123.txt":U, INPUT "Usu rio X Estabelecimento":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mnd-proces-administ THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr109.txt":U, INPUT "Processo Administrativo":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
END.

/*Gerencial Frotas*/
IF l-habilit-gerencial-frotas THEN DO:
    IF tt-param.l-mgf-param THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr092.txt":U, INPUT "Parƒmetro Gerencial Frotas":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mgf-event-param THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr079.txt":U, INPUT "Parametriza‡Æo Evento":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mgf-event-grp-eqpto THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr080.txt":U, INPUT "Evento X Grupo Equipamento":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
    IF tt-param.l-mgf-grp-estoq THEN DO:
        RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr091.txt":U, INPUT "Grupo Estoque - Pneus":U).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-ok = NO.
    END.
END.


IF l-ok = NO THEN DO:
    ASSIGN l-ok = YES.
    RUN setFolder IN hFolder (INPUT 4).
    RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPag5 wReport 
PROCEDURE validaPag5 :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes da Pag 5.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param.l-mab-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr007.txt":U, INPUT "Equipamentos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-histor-ativid THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr013.txt":U, INPUT "Hist¢rico Setor Grupo Atividade Equipamento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-histor-combust THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr014.txt":U, INPUT "Hist¢rico Combust¡vel Equipamento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-eqpto-caract THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr097.txt":U, INPUT "Caracter¡sticas Equipamentos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-comptmento-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr004.txt":U, INPUT "Compartimento Equipamentos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-period-manut THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr020.txt":U, INPUT "Per¡odo Manuten‡Æo Compartimento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-configur-eixo THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr005.txt":U, INPUT "Configura‡Æo Eixo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-programac-event THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr022.txt":U, INPUT "Programa‡Æo de Eventos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-eqpto-plano THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr031.txt":U, INPUT "Equipamento Plano Manuten‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mgf-eqpto-implto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr093.txt":U, INPUT "Equipamento X Implementos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-histor-layout-eixo THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr044.txt":U, INPUT "Hist¢rico Layout Eixo Equipamento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-eqpto-serv THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr099.txt":U, INPUT "Servi‡os de Pneus em Equipamentos":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mpn-hora-estimad THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr125.txt":U, INPUT "Percurso Estimado Mensal":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-grp-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr126.txt":U, INPUT "Grupo Equipamento Manuten‡Æo":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mmv-eqpto-grp-eqpto THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr127.txt":U, INPUT "Equipamento X Grupo Equipamento":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.
IF tt-param.l-mab-relac-eqpto-sub-sist THEN DO:
    RUN validaArquivo IN THIS-PROCEDURE (INPUT "fr128.txt":U, INPUT "Relac. Eqpto X Sub-Sist":U).
    IF RETURN-VALUE = "NOK":U THEN
        ASSIGN l-ok = NO.
END.

IF l-ok = NO THEN DO:
    ASSIGN l-ok = YES.
    RUN setFolder IN hFolder (INPUT 5).
    RETURN "NOK":U.
END.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

