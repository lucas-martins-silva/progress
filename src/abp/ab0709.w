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
{include/i-prgvrs.i AB0709 2.00.00.003}  /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0709 MAB}
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
&GLOBAL-DEFINE Program        AB0709
&GLOBAL-DEFINE Version        2.00.00.001
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
&GLOBAL-DEFINE page1Widgets   tg-mab-marca tg-mab-model tg-mab-consu-model tg-mmv-tempo-padr ~
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
                              tg-gerar-cabecalho ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution ~
                              btInputDir
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      text-Modelo text-cadpg1 text-Evento text-Motorista
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

/** CHAMA TEMP TABLE PARAMETROS**/
{abp/ab0709.i1}

/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
/***************************************************************************/
                                                  /** Definiá∆o vari†veis **/

DEFINE VARIABLE l-habilit-componentes AS LOGICAL      INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-gerencial-frotas AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-manut-doctos AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-analise-oleos AS LOGICAL    INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-pneus        AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-habilit-manut-mec    AS LOGICAL     INITIAL YES NO-UNDO.
DEFINE VARIABLE l-ok                      as logical  INITIAL YES NO-UNDO.
DEFINE VARIABLE l-tg-gerar-cabecalho AS LOGICAL       INITIAL YES NO-UNDO.

DEFINE VARIABLE c-terminal AS CHARACTER  NO-UNDO.

/** Vari†veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}



/*zoom smart*/
/* DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.                      */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

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
     SIZE 30 BY 4.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 9.75.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 2.25.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 2.25.

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
     LABEL "Caracter°sticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-comptmento AS LOGICAL INITIAL no 
     LABEL "Compartimentos ‡leo/Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-consu-model AS LOGICAL INITIAL no 
     LABEL "Consumo Padr∆o por Modelo" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto-sub-sist AS LOGICAL INITIAL no 
     LABEL "Relac Grp Eqpto X Sub-Sist" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-estrut-mec AS LOGICAL INITIAL no 
     LABEL "Estrutura MecÉnica" 
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
     LABEL "Sistema MecÉnico" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-sit-eqpto AS LOGICAL INITIAL no 
     LABEL "Situaá∆o" 
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
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tempo-padr AS LOGICAL INITIAL no 
     LABEL "Tempo Padr∆o Execuá∆o Serviáos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE text-cadpg2 AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 11.08.

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
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mi-turno-ciclo AS LOGICAL INITIAL no 
     LABEL "Horas Turno" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-curso-trein AS LOGICAL INITIAL no 
     LABEL "Treinamentos Funcion†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-especialid AS LOGICAL INITIAL no 
     LABEL "Especialidade Funcion†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-ofici AS LOGICAL INITIAL no 
     LABEL "Funcion†rio Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-func-turno AS LOGICAL INITIAL no 
     LABEL "Turnos Funcion†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-ofici AS LOGICAL INITIAL no 
     LABEL "Oficinas" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-param AS LOGICAL INITIAL no 
     LABEL "ParÉmetros Manutená∆o MecÉnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-plandor AS LOGICAL INITIAL no 
     LABEL "Planejador das Ordens de Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-plano-prevent AS LOGICAL INITIAL no 
     LABEL "Plano Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-setor-ofici AS LOGICAL INITIAL no 
     LABEL "Setor Oficina" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano AS LOGICAL INITIAL no 
     LABEL "Item Plano Preventiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-epi AS LOGICAL INITIAL no 
     LABEL "Equipamentos Proteá∆o Necess†rios" 
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
     LABEL "Ferramentas Necess†rias" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-ficha AS LOGICAL INITIAL no 
     LABEL "Ficha MÇtodo Associada Tarefa" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-tar-plano-item AS LOGICAL INITIAL no 
     LABEL "Materias Necess†rios Tarefa" 
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
     LABEL "Layout Eixo Posiá∆o" 
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
     LABEL "ParÉmetros Pneu" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-pneu AS LOGICAL INITIAL no 
     LABEL "Cadastro Pneus" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-pos-pneu AS LOGICAL INITIAL no 
     LABEL "Posiá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-serv AS LOGICAL INITIAL no 
     LABEL "Serviáos" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-tip-borracha AS LOGICAL INITIAL no 
     LABEL "Tipo Borracha" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-tip-serv AS LOGICAL INITIAL no 
     LABEL "Tipo Serviáo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 2 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-AnaliseOl AS CHARACTER FORMAT "X(256)":U INITIAL "An†lise de ‡leos" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE text-Componentes AS CHARACTER FORMAT "X(256)":U INITIAL "Componentes" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE text-Gerencial AS CHARACTER FORMAT "X(256)":U INITIAL "Gerencial Frotas" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE text-ManutDoctos AS CHARACTER FORMAT "X(256)":U INITIAL "Manutená∆o de Documentos" 
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
     LABEL "Usu†rio X Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-usuar-frota AS LOGICAL INITIAL no 
     LABEL "Usu†rio Frotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mao-ensaio AS LOGICAL INITIAL no 
     LABEL "Ensaios" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mao-ensaio-padr AS LOGICAL INITIAL no 
     LABEL "Padr‰es de Ensaio" 
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
     LABEL "Parametrizaá∆o Evento" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-grp-estoq AS LOGICAL INITIAL no 
     LABEL "Grupo Estoque - Pneus" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mgf-param AS LOGICAL INITIAL no 
     LABEL "ParÉmetro Gerencial Frotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mnd-proces-administ AS LOGICAL INITIAL no 
     LABEL "Processo Administrativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE text-cadastros AS CHARACTER FORMAT "X(256)":U INITIAL "Cadastros" 
      VIEW-AS TEXT 
     SIZE 8.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-grpeqptomanut AS CHARACTER FORMAT "X(256)":U INITIAL "Grupo Equipamento Manutená∆o" 
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
     LABEL "Configuraá∆o Eixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto AS LOGICAL INITIAL no 
     LABEL "Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-eqpto-caract AS LOGICAL INITIAL no 
     LABEL "Caracter°sticas Equipamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-ativid AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Setor Grupo Atividade Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-histor-combust AS LOGICAL INITIAL no 
     LABEL "Hist¢rico Combust°vel Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-period-manut AS LOGICAL INITIAL no 
     LABEL "Per°odo Manutená∆o Compartimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mab-programac-event AS LOGICAL INITIAL no 
     LABEL "Programaá∆o de Eventos" 
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
     LABEL "Equipamento Plano Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mmv-grp-eqpto AS LOGICAL INITIAL no 
     LABEL "Grupo Equipamento Manutená∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mpn-eqpto-serv AS LOGICAL INITIAL no 
     LABEL "Serviáo de Pneus em Equipamentos" 
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

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Diret¢rio de Exportaá∆o" 
      VIEW-AS TEXT 
     SIZE 17.14 BY .63
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
     SIZE 28.72 BY .79
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
         SIZE 90 BY 17.08
         FONT 1.

DEFINE FRAME fPage2
     tg-mmv-param AT ROW 2.54 COL 13
     tg-mmv-ofici AT ROW 3.54 COL 13
     tg-mmv-setor-ofici AT ROW 4.54 COL 13
     tg-mmv-func-ofici AT ROW 5.54 COL 13
     tg-mmv-plandor AT ROW 6.54 COL 13
     tg-mi-turno AT ROW 7.54 COL 13 WIDGET-ID 12
     tg-mi-turno-ciclo AT ROW 8.54 COL 13 WIDGET-ID 14
     tg-mi-curso-trein AT ROW 9.54 COL 13 WIDGET-ID 10
     tg-mi-espec AT ROW 10.54 COL 13 WIDGET-ID 8
     tg-mmv-plano-prevent AT ROW 11.54 COL 13
     tg-mmv-tar-plano AT ROW 2.54 COL 45.14
     tg-mmv-tar-plano-item AT ROW 3.54 COL 45.14
     tg-mmv-tar-plano-epi AT ROW 4.54 COL 45.14
     tg-mmv-tar-plano-ferram AT ROW 5.54 COL 45.14
     tg-mmv-tar-plano-ficha AT ROW 6.54 COL 45.14
     tg-mmv-tar-plano-esp AT ROW 7.54 COL 45.14 WIDGET-ID 26
     tg-mmv-tar-plano-esp-curso AT ROW 8.54 COL 45.14 WIDGET-ID 28
     tg-mmv-func-turno AT ROW 9.54 COL 45.14 WIDGET-ID 16
     tg-mmv-func-curso-trein AT ROW 10.54 COL 45.14 WIDGET-ID 18
     tg-mmv-func-especialid AT ROW 11.54 COL 45.14 WIDGET-ID 20
     tg-marca-todos AT ROW 13.08 COL 61
          LABEL "Marcar Todos"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     text-cadpg2 AT ROW 1.46 COL 10.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     RECT-23 AT ROW 13 COL 59
     RECT-27 AT ROW 1.67 COL 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13.21
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
          "An†lise de ‡leos" NO-LABEL
     text-ManutDoctos AT ROW 1.75 COL 44 COLON-ALIGNED HELP
          "Manutená∆o de Documentos" NO-LABEL
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
     tg-gerar-cabecalho AT ROW 11.29 COL 3.29
     rsAll AT ROW 2.08 COL 3.29 NO-LABEL
     rsDestiny AT ROW 4.21 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 5.46 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btDestinyFile AT ROW 5.42 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 5.46 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.58 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     cInputDir AT ROW 10.04 COL 3.29 HELP
          "Nome do Diret¢rio de Exportaá∆o" NO-LABEL
     btInputDir AT ROW 10 COL 43.29 HELP
          "Escolha do nome do arquivo"
     text-imprime AT ROW 1.29 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.46 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 6.83 COL 1.14 COLON-ALIGNED NO-LABEL
     text-entrada AT ROW 9.08 COL 1.86 COLON-ALIGNED HELP
          "Diret¢rio de Exportaá∆o" NO-LABEL
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
          "Grupo Equipamento Manutená∆o" NO-LABEL
     tg-relac-eqpto-sub-sist AT ROW 7.92 COL 49.43
     RECT-26 AT ROW 12.08 COL 58
     RECT-34 AT ROW 1.75 COL 6
     RECT-35 AT ROW 9.46 COL 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage1
     tg-mab-ativid AT ROW 1.92 COL 4
     tg-mab-trajeto AT ROW 2.83 COL 4
     tg-mab-caract AT ROW 3.79 COL 4
     tg-mab-comptmento AT ROW 4.71 COL 4
     tg-mab-estrut-mec AT ROW 5.67 COL 4
     tg-mab-sist AT ROW 6.58 COL 4
     tg-mab-sub-sist AT ROW 7.38 COL 4
     tg-mab-sit-eqpto AT ROW 9.13 COL 4
     tg-mab-grp-eqpto AT ROW 10.04 COL 4
     tg-mab-eqpto-sub-sist AT ROW 1.92 COL 29
     tg-mab-posto AT ROW 2.83 COL 29
     tg-mab-bomba AT ROW 3.79 COL 29
     tg-mab-tip-mater AT ROW 4.71 COL 29
     tg-mab-tip-mater-item AT ROW 5.67 COL 29
     tg-mab-grp-event AT ROW 9.38 COL 56
     tg-mab-event AT ROW 10.29 COL 56
     tg-mab-motoris AT ROW 6.75 COL 56
     tg-mab-motoris-model AT ROW 7.71 COL 56
     tg-marca-todos AT ROW 12.17 COL 60
     text-cadpg1 AT ROW 1.25 COL 3.72 COLON-ALIGNED HELP
          "Cadastros" NO-LABEL
     text-Evento AT ROW 8.75 COL 55 COLON-ALIGNED HELP
          "Evento" NO-LABEL
     text-Motorista AT ROW 6.08 COL 55 COLON-ALIGNED HELP
          "Motorista" NO-LABEL
     tg-integr-cargo AT ROW 8.25 COL 4
     tg-mab-marca AT ROW 1.92 COL 56
     tg-mab-model AT ROW 2.83 COL 56
     tg-mab-consu-model AT ROW 3.79 COL 56
     tg-mmv-tempo-padr AT ROW 4.71 COL 56
     text-Modelo AT ROW 1.25 COL 55 COLON-ALIGNED HELP
          "Modelo" NO-LABEL
     RECT-19 AT ROW 1.5 COL 2
     RECT-20 AT ROW 9 COL 54
     RECT-21 AT ROW 6.38 COL 54
     RECT-22 AT ROW 12.08 COL 58
     RECT-18 AT ROW 1.5 COL 54
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
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
         HEIGHT             = 17.08
         WIDTH              = 90
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
ASSIGN 
       text-cadpg1:PRIVATE-DATA IN FRAME fPage1     = 
                "Cadastros".

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
                "An†lise de ‡leos".

ASSIGN 
       text-Componentes:PRIVATE-DATA IN FRAME fPage4     = 
                "Componentes".

ASSIGN 
       text-Gerencial:PRIVATE-DATA IN FRAME fPage4     = 
                "Gerencial Frotas".

ASSIGN 
       text-ManutDoctos:PRIVATE-DATA IN FRAME fPage4     = 
                "Manutená∆o de Documentos".

/* SETTINGS FOR FRAME fPage5
   Custom                                                               */
ASSIGN 
       text-cadastros:PRIVATE-DATA IN FRAME fPage5     = 
                "Cadastros".

ASSIGN 
       text-grpeqptomanut:PRIVATE-DATA IN FRAME fPage5     = 
                "Grupo Equipamento Manutená∆o".

/* SETTINGS FOR FRAME fPage7
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage7     = 
                "Diret¢rio de Exportaá∆o".

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
    {utp/ut-liter.i Diret¢rio_de_Exportaá∆o *}
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marca-todos wReport
ON VALUE-CHANGED OF tg-marca-todos IN FRAME fPage1 /* Marcar Todos */
DO:
    DO WITH FRAME fPage1:
          IF tg-marca-todos:CHECKED THEN
              ASSIGN    /*tg-tab-unidade:CHECKED = YES*/
                        /*tg-tag:CHECKED = YES*/
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
              ASSIGN    /*tg-tab-unidade:CHECKED = NO
                        tg-tag:CHECKED = NO*/
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
/*     APPLY "value-changed":U TO tg-tag. */


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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/
/* {report/mainblock.i} */

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
  Purpose:     Executa as validaá‰es padr‰es e chama o RP de Exportaá∆o.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

/* &IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN                      */
/* /***************************************************************************/ */
/*                                                           /*** Relat¢rio ***/ */
/* &ELSE                                                                         */
/***************************************************************************/
                                              /*** Exportaá∆o/Exportaá∆o ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    create tt-param.
    assign tt-param.usuario              = c-seg-usuario
           tt-param.destino              = input frame fPage7 rsDestiny
           tt-param.todos                = input frame fPage7 rsAll
           tt-param.l-tg-gerar-cabecalho = input frame fPage7 tg-gerar-cabecalho
           tt-param.execucao             = input frame fPage7 rsExecution
           tt-param.dir-entrada          = input frame fPage7 cInputDir
           tt-param.data-exec            = today
           tt-param.hora-exec            = time
           tt-param.i-origem             = 1 /** Exportaá∆o **/    
                    /* 1*/                                
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

    /*executa as validacoes dos dados da tela, e verifica a existencia dos arquivos de Exportaá∆o.*/
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

    {report/imrun.i abp/AB0709rp.p}

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
  Purpose:    Validacoes da Exportaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param.dir-entrada = "":U THEN DO:
    /*Diretorio de Exportaá∆o em Branco*/
    {utp/ut-liter.i Diret¢rio_de_Exportaá∆o *}
     RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 3145,
                        INPUT RETURN-VALUE).
    RUN setFolder IN hFolder (INPUT 6).
    apply "ENTRY":U to cInputDir in frame fPage7.
    RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

