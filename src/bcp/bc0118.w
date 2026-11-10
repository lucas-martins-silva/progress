&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0118 2.00.00.027 } /*** "010027" 08/12/2023 11:49:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0118 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgint.i} /* versao de produto */
{include/i_dbtype.i}
{include/i_fnctrad.i}

CREATE WIDGET-POOL.

&GLOBAL-DEFINE Program        BC0118
&GLOBAL-DEFINE Version        2.00.00.027

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Local Default
&GLOBAL-DEFINE GoTo           YES

&GLOBAL-DEFINE page0Widgets   btHelp  bt-sea btexit bt-filtro br-tt-bc-etiqueta bt-det bt-mod bt-del bt-va-para bt-refresh bt-trans-erro

&GLOBAL-DEFINE page1Widgets   

/* Local Variable Definitions ---                                       */
/* definition tem-table */
DEFINE TEMP-TABLE tt-bc-etiqueta   NO-UNDO LIKE bc-etiqueta
            FIELD estado-des AS CHARACTER FORMAT 'x(30)':U LABEL 'Descriá∆o':U.

DEFINE TEMP-TABLE tt-bc-tipo-trans NO-UNDO LIKE bc-tipo-trans.

DEFINE TEMP-TABLE ttWm-box-bc NO-UNDO
            FIELD  cod-local   AS CHAR 
            FIELD  cod-estabel AS CHAR 
            FIELD  bloco       AS CHAR 
            FIELD  rua         AS CHAR 
            FIELD  nivel       AS CHAR 
            FIELD  coluna      AS CHAR 
            FIELD  id-box      AS INT 
            INDEX id IS PRIMARY id-box.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO /* obtido atraves do bc0201 */
            FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U   LABEL 'Sequància'
            FIELD titulo     AS CHARACTER FORMAT 'x(50)':U   LABEL 'T°tulo'
            FIELD titulo-col AS CHARACTER FORMAT 'x(50)':U   LABEL 'T°tulo Coluna'
            FIELD atributo   AS CHARACTER FORMAT 'x(100)':U  LABEL 'Atributo'
            FIELD formato    AS CHARACTER FORMAT 'x(30)':U   LABEL 'Formato'
            FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U   LABEL 'Tipo Dado'
            FIELD per-alt    AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Altera?'
            FIELD inicial    AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Inicial'
            FIELD final      AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Final'
            FIELD conteudo   AS CHARACTER FORMAT 'x(100)':U  LABEL 'Conte£do'
            FIELD faixa      AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Faixa?'
            INDEX id IS PRIMARY atributo.

DEFINE TEMP-TABLE tt-estrutura-wms  NO-UNDO LIKE tt-estrutura.
DEFINE TEMP-TABLE tt-estrutura-comp NO-UNDO LIKE tt-estrutura.

DEFINE TEMP-TABLE tt-estrutura-aux NO-UNDO 
            FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U
            FIELD titulo     AS CHARACTER FORMAT 'x(50)':U
            FIELD titulo-col AS CHARACTER FORMAT 'x(50)':U
            FIELD atributo   AS CHARACTER FORMAT 'x(100)':U
            FIELD formato    AS CHARACTER FORMAT 'x(30)':U
            FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U
            FIELD per-alt    AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Altera?'
            FIELD inicial    AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Inicial'
            FIELD final      AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Final'
            FIELD conteudo   AS CHARACTER FORMAT 'x(100)':U  LABEL 'Conte£do'
            FIELD faixa      AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Faixa?'.

DEFINE TEMP-TABLE tt-estrut-tab NO-UNDO
            FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U
            FIELD titulo     AS CHARACTER FORMAT 'x(50)':U
            FIELD titulo-col AS CHARACTER FORMAT 'x(50)':U
            FIELD atributo   AS CHARACTER FORMAT 'x(100)':U
            FIELD formato    AS CHARACTER FORMAT 'x(30)':U
            FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U
            FIELD per-alt    AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Altera?'
            FIELD inicial    AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Inicial'
            FIELD final      AS CHARACTER FORMAT 'x(100)':U  LABEL 'Valor Final'
            FIELD conteudo   AS CHARACTER FORMAT 'x(100)':U  LABEL 'Conte£do'
            FIELD posicao    AS INTEGER   FORMAT '>>9':U     LABEL 'Posiá∆o'
            FIELD faixa      AS LOGICAL   FORMAT 'Sim/N∆o':U LABEL 'Faixa?'.   

DEFINE TEMP-TABLE tt-bc-estado-etiq NO-UNDO LIKE bc-estado-etiq.

DEFINE BUFFER b-bc-etiqueta   FOR bc-etiqueta.
DEFINE BUFFER b-tt-estrut-tab FOR tt-estrut-tab.

DEFINE NEW GLOBAL SHARED VAR v_cod_grp_usuar_lst AS CHARACTER FORMAT "x(3)":U LABEL "Grupo Usu†rios"  COLUMN-LABEL "Grupo" NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR vAcessType AS INTEGER NO-UNDO.

DEFINE VARIABLE wh-pesquisa        AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE v-num-nivel        AS INTEGER FORMAT ">>>>,>>>9":U NO-UNDO.
DEFINE VARIABLE v-num-nivel-contrl AS INTEGER FORMAT ">>>>,>>>9":U NO-UNDO.
DEFINE VARIABLE v-num-tamanho      AS INTEGER                      NO-UNDO.
DEFINE VARIABLE v-des-chave        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE rw-bctrans         AS ROWID                        NO-UNDO.
DEFINE VARIABLE l-apaga            AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE h-query            AS WIDGET-HANDLE.
DEFINE VARIABLE h-browse           AS WIDGET-HANDLE.
DEFINE VARIABLE c-condicao         AS CHAR INIT ""                 NO-UNDO.
DEFINE VARIABLE v-log-aux          AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE h_bosc030          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h_acomp            AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bc0803           AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-program          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE lAlterouWMS        AS LOG                          NO-UNDO.
DEFINE VARIABLE c-indice           AS CHARACTER                    NO-UNDO.

DEFINE VARIABLE v-tip-procura AS LOGICAL FORMAT 'Sim/N∆o':U INITIAL NO LABEL "CritÇrio de Busca"
       VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Por Nr Etiqueta", YES,
                                                  "Por Nr Serie", NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-bc-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-bc-etiqueta

/* Definitions for BROWSE br-tt-bc-etiqueta                             */
&Scoped-define FIELDS-IN-QUERY-br-tt-bc-etiqueta tt-bc-etiqueta.nr-etiq tt-bc-etiqueta.cod-estabel tt-bc-etiqueta.it-codigo tt-bc-etiqueta.progressivo tt-bc-etiqueta.lote tt-bc-etiqueta.referencia tt-bc-etiqueta.localizacao tt-bc-etiqueta.estado-des tt-bc-etiqueta.ativo tt-bc-etiqueta.qt-item tt-bc-etiqueta.usuar-producao tt-bc-etiqueta.dt-producao tt-bc-etiqueta.hr-producao tt-bc-etiqueta.usuar-criacao tt-bc-etiqueta.dt-criacao tt-bc-etiqueta.hr-criacao tt-bc-etiqueta.linha-prod tt-bc-etiqueta.nr-ord-produ tt-bc-etiqueta.cdd-embarq tt-bc-etiqueta.nr-resumo tt-bc-etiqueta.nr-seq-fat tt-bc-etiqueta.nr-entrega tt-bc-etiqueta.serie tt-bc-etiqueta.nr-nota-fis tt-bc-etiqueta.nome-abrev tt-bc-etiqueta.usuar-expedicao tt-bc-etiqueta.dt-expedicao tt-bc-etiqueta.hr-expedicao tt-bc-etiqueta.usuar-separacao tt-bc-etiqueta.dt-separacao tt-bc-etiqueta.hr-separacao tt-bc-etiqueta.cod-transp tt-bc-etiqueta.caracter-livre-1 tt-bc-etiqueta.caracter-livre-2 tt-bc-etiqueta.caracter-livre-3 tt-bc-etiqueta.caracter-livre-4 tt-bc-etiqueta.caracter-livre-5 tt-bc-etiqueta.cd-trans tt-bc-etiqueta.char-1 tt-bc-etiqueta.char-2 tt-bc-etiqueta.check-sum tt-bc-etiqueta.cod-depos tt-bc-etiqueta.cod-layout tt-bc-etiqueta.data-1 tt-bc-etiqueta.data-2 tt-bc-etiqueta.data-livre-1 tt-bc-etiqueta.data-livre-2 tt-bc-etiqueta.data-livre-3 tt-bc-etiqueta.data-livre-4 tt-bc-etiqueta.data-livre-5 tt-bc-etiqueta.dec-1 tt-bc-etiqueta.dec-2 tt-bc-etiqueta.decimal-livre-1 tt-bc-etiqueta.decimal-livre-2 tt-bc-etiqueta.decimal-livre-3 tt-bc-etiqueta.decimal-livre-4 tt-bc-etiqueta.decimal-livre-5 tt-bc-etiqueta.detalhe tt-bc-etiqueta.dt-validade tt-bc-etiqueta.fm-codigo tt-bc-etiqueta.ge-codigo tt-bc-etiqueta.int-1 tt-bc-etiqueta.int-2 tt-bc-etiqueta.inteiro-livre-1 tt-bc-etiqueta.inteiro-livre-2 tt-bc-etiqueta.inteiro-livre-3 tt-bc-etiqueta.inteiro-livre-4 tt-bc-etiqueta.inteiro-livre-5 tt-bc-etiqueta.log-1 tt-bc-etiqueta.log-2 tt-bc-etiqueta.log-datasul tt-bc-etiqueta.logico-livre-1 tt-bc-etiqueta.logico-livre-2 tt-bc-etiqueta.logico-livre-3 tt-bc-etiqueta.logico-livre-4 tt-bc-etiqueta.logico-livre-5 tt-bc-etiqueta.nat-operacao tt-bc-etiqueta.nr-etiq-pai tt-bc-etiqueta.nr-pedcli tt-bc-etiqueta.nr-pedido tt-bc-etiqueta.nr-trans tt-bc-etiqueta.num-versao tt-bc-etiqueta.qt-un-1 tt-bc-etiqueta.qt-un-2 tt-bc-etiqueta.qt-un-3 tt-bc-etiqueta.qt-un-4 tt-bc-etiqueta.qt-un-5 tt-bc-etiqueta.turno tt-bc-etiqueta.un tt-bc-etiqueta.un-1 tt-bc-etiqueta.un-2 tt-bc-etiqueta.un-3 tt-bc-etiqueta.un-4 tt-bc-etiqueta.un-5 tt-bc-etiqueta.nr-romaneio tt-bc-etiqueta.dt-inventario tt-bc-etiqueta.hr-inventario tt-bc-etiqueta.usuar-inventario tt-bc-etiqueta.nr-contagem tt-bc-etiqueta.nr-operacao /*Vagner*/ &IF '{&mgcld_version}' >= '2.04' &THEN tt-bc-etiqueta.id-docto tt-bc-etiqueta.cod-controle-serie tt-bc-etiqueta.cod-embalagem tt-bc-etiqueta.cod-montadora tt-bc-etiqueta.cod-idioma tt-bc-etiqueta.cod-agrupador1 tt-bc-etiqueta.cod-agrupador2 tt-bc-etiqueta.cod-agrupador3 tt-bc-etiqueta.cod-agrupador4 tt-bc-etiqueta.cod-agrupador5 tt-bc-etiqueta.ep-codigo tt-bc-etiqueta.numero-ordem tt-bc-etiqueta.parcela tt-bc-etiqueta.num-pedido tt-bc-etiqueta.nro-docto tt-bc-etiqueta.serie-docto tt-bc-etiqueta.nat-operacao-docto tt-bc-etiqueta.cod-emitente-docto tt-bc-etiqueta.id-box tt-bc-etiqueta.cod-local tt-bc-etiqueta.sequencia-docto tt-bc-etiqueta.dt-recebimento tt-bc-etiqueta.hr-recebimento tt-bc-etiqueta.usuar-recebimento tt-bc-etiqueta.nr-volume &ENDIF   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-bc-etiqueta   
&Scoped-define SELF-NAME br-tt-bc-etiqueta
&Scoped-define QUERY-STRING-br-tt-bc-etiqueta FOR EACH tt-bc-etiqueta NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tt-bc-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-bc-etiqueta NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-bc-etiqueta tt-bc-etiqueta
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-bc-etiqueta tt-bc-etiqueta


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-tt-bc-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-filtro bt-refresh btQueryJoins ~
btReportsJoins btExit btHelp bt-sea v-log-datasul br-tt-bc-etiqueta bt-det ~
bt-trans-erro bt-mod bt-del RECT-59 rtToolBar rtToolBar-2 
&Scoped-Define DISPLAYED-OBJECTS v-cod-layout v-descricao v-num-versao ~
v-log-datasul iNrEtiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Eventos treeview*/
{utp/ut-4gltreeview.i}

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Elimina Etiqueta" 
     SIZE 4 BY 1.25 TOOLTIP "Elimina Etiqueta"
     FONT 4.

DEFINE BUTTON bt-det 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Detalhe Etiqueta/Transaá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhe Etiqueta/Transaá∆o"
     FONT 4.

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image~\im-fil":U
     IMAGE-INSENSITIVE FILE "image~\ii-fil":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON bt-mod 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Modifica Etiqueta/Transaá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Modifica Etiqueta/Transaá∆o"
     FONT 4.

DEFINE BUTTON bt-refresh 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Refresh" 
     SIZE 4 BY 1.25 TOOLTIP "Refresh"
     FONT 4.

DEFINE BUTTON bt-sea 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Pesquisa Layout" 
     SIZE 4 BY 1.08 TOOLTIP "Pesquisa Layout".

DEFINE BUTTON bt-trans-erro 
     IMAGE-UP FILE "image/im-open.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-open.bmp":U
     LABEL "Detalhe Erro Transaá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhe Erro Transaá∆o"
     FONT 4.

DEFINE BUTTON bt-va-para 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "go" 
     SIZE 4 BY 1.25 TOOLTIP "V† Para".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25 TOOLTIP "Sa°da"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25 TOOLTIP "Ajuda"
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Relacionada"
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio"
     FONT 4.

DEFINE VARIABLE iNrEtiqueta AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Qtd Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-layout AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Layout" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE v-descricao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 36.86 BY .88.

DEFINE VARIABLE v-num-versao AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Vers∆o" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE v-log-datasul AS LOGICAL INITIAL no 
     LABEL "Padr∆o Datasul" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tt-bc-etiqueta FOR 
      tt-bc-etiqueta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-bc-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-bc-etiqueta wWindow _FREEFORM
  QUERY br-tt-bc-etiqueta NO-LOCK DISPLAY
      tt-bc-etiqueta.nr-etiq 
      tt-bc-etiqueta.cod-estabel 
      tt-bc-etiqueta.it-codigo 
      tt-bc-etiqueta.progressivo 
      tt-bc-etiqueta.lote 
      tt-bc-etiqueta.referencia 
      tt-bc-etiqueta.localizacao 
      tt-bc-etiqueta.estado-des
      tt-bc-etiqueta.ativo      
      tt-bc-etiqueta.qt-item 
      tt-bc-etiqueta.usuar-producao 
      tt-bc-etiqueta.dt-producao 
      tt-bc-etiqueta.hr-producao 
      tt-bc-etiqueta.usuar-criacao 
      tt-bc-etiqueta.dt-criacao 
      tt-bc-etiqueta.hr-criacao 
      tt-bc-etiqueta.linha-prod 
      tt-bc-etiqueta.nr-ord-produ 
      tt-bc-etiqueta.cdd-embarq 
      tt-bc-etiqueta.nr-resumo 
      tt-bc-etiqueta.nr-seq-fat
      tt-bc-etiqueta.nr-entrega
      tt-bc-etiqueta.serie 
      tt-bc-etiqueta.nr-nota-fis 
      tt-bc-etiqueta.nome-abrev 
      tt-bc-etiqueta.usuar-expedicao 
      tt-bc-etiqueta.dt-expedicao 
      tt-bc-etiqueta.hr-expedicao 
      tt-bc-etiqueta.usuar-separacao
      tt-bc-etiqueta.dt-separacao 
      tt-bc-etiqueta.hr-separacao
      tt-bc-etiqueta.cod-transp
      tt-bc-etiqueta.caracter-livre-1
      tt-bc-etiqueta.caracter-livre-2
      tt-bc-etiqueta.caracter-livre-3
      tt-bc-etiqueta.caracter-livre-4
      tt-bc-etiqueta.caracter-livre-5
      tt-bc-etiqueta.cd-trans
      tt-bc-etiqueta.char-1 
      tt-bc-etiqueta.char-2 
      tt-bc-etiqueta.check-sum 
      tt-bc-etiqueta.cod-depos 
      tt-bc-etiqueta.cod-layout 
      tt-bc-etiqueta.data-1 
      tt-bc-etiqueta.data-2 
      tt-bc-etiqueta.data-livre-1 
      tt-bc-etiqueta.data-livre-2 
      tt-bc-etiqueta.data-livre-3 
      tt-bc-etiqueta.data-livre-4 
      tt-bc-etiqueta.data-livre-5 
      tt-bc-etiqueta.dec-1 
      tt-bc-etiqueta.dec-2 
      tt-bc-etiqueta.decimal-livre-1 
      tt-bc-etiqueta.decimal-livre-2 
      tt-bc-etiqueta.decimal-livre-3 
      tt-bc-etiqueta.decimal-livre-4 
      tt-bc-etiqueta.decimal-livre-5 
      tt-bc-etiqueta.detalhe 
      tt-bc-etiqueta.dt-validade 
      tt-bc-etiqueta.fm-codigo 
      tt-bc-etiqueta.ge-codigo 
      tt-bc-etiqueta.int-1 
      tt-bc-etiqueta.int-2 
      tt-bc-etiqueta.inteiro-livre-1 
      tt-bc-etiqueta.inteiro-livre-2 
      tt-bc-etiqueta.inteiro-livre-3
      tt-bc-etiqueta.inteiro-livre-4 
      tt-bc-etiqueta.inteiro-livre-5
      tt-bc-etiqueta.log-1 
      tt-bc-etiqueta.log-2 
      tt-bc-etiqueta.log-datasul 
      tt-bc-etiqueta.logico-livre-1 
      tt-bc-etiqueta.logico-livre-2 
      tt-bc-etiqueta.logico-livre-3 
      tt-bc-etiqueta.logico-livre-4 
      tt-bc-etiqueta.logico-livre-5 
      tt-bc-etiqueta.nat-operacao 
      tt-bc-etiqueta.nr-etiq-pai 
      tt-bc-etiqueta.nr-pedcli 
      tt-bc-etiqueta.nr-pedido 
      tt-bc-etiqueta.nr-trans 
      tt-bc-etiqueta.num-versao 
      tt-bc-etiqueta.qt-un-1 
      tt-bc-etiqueta.qt-un-2 
      tt-bc-etiqueta.qt-un-3 
      tt-bc-etiqueta.qt-un-4 
      tt-bc-etiqueta.qt-un-5 
      tt-bc-etiqueta.turno 
      tt-bc-etiqueta.un 
      tt-bc-etiqueta.un-1 
      tt-bc-etiqueta.un-2 
      tt-bc-etiqueta.un-3 
      tt-bc-etiqueta.un-4 
      tt-bc-etiqueta.un-5 
      tt-bc-etiqueta.nr-romaneio
      tt-bc-etiqueta.dt-inventario
      tt-bc-etiqueta.hr-inventario 
      tt-bc-etiqueta.usuar-inventario
      tt-bc-etiqueta.nr-contagem
      tt-bc-etiqueta.nr-operacao
      tt-bc-etiqueta.id-docto 
      tt-bc-etiqueta.cod-controle-serie 
      tt-bc-etiqueta.cod-embalagem 
      tt-bc-etiqueta.cod-montadora 
      tt-bc-etiqueta.cod-idioma 
      tt-bc-etiqueta.cod-agrupador1 
      tt-bc-etiqueta.cod-agrupador2 
      tt-bc-etiqueta.cod-agrupador3 
      tt-bc-etiqueta.cod-agrupador4 
      tt-bc-etiqueta.cod-agrupador5
      tt-bc-etiqueta.ep-codigo
      tt-bc-etiqueta.numero-ordem
      tt-bc-etiqueta.parcela
      tt-bc-etiqueta.num-pedido
      tt-bc-etiqueta.nro-docto
      tt-bc-etiqueta.serie-docto
      tt-bc-etiqueta.nat-operacao-docto
      tt-bc-etiqueta.cod-emitente-docto
      tt-bc-etiqueta.id-box
      tt-bc-etiqueta.cod-local
      tt-bc-etiqueta.sequencia-docto
      tt-bc-etiqueta.dt-recebimento
      tt-bc-etiqueta.hr-recebimento
      tt-bc-etiqueta.usuar-recebimento
      tt-bc-etiqueta.nr-volume
        
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47 BY 11.25
         FONT 1 ROW-HEIGHT-CHARS .62 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-filtro AT ROW 1.17 COL 1.72 HELP
          "Filtro"
     bt-refresh AT ROW 1.17 COL 6 HELP
          "Confirma alteraá‰es"
     bt-va-para AT ROW 1.17 COL 10.14 HELP
          "V† Para"
     btQueryJoins AT ROW 1.17 COL 74 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 78 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 82 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86 HELP
          "Ajuda"
     bt-sea AT ROW 2.88 COL 65.29 HELP
          "Pesquisa"
     v-cod-layout AT ROW 3 COL 22 COLON-ALIGNED HELP
          "C¢digo do Layout de Registros"
     v-descricao AT ROW 3 COL 26.29 COLON-ALIGNED HELP
          "Descriá∆o do layout de registros." NO-LABEL
     v-num-versao AT ROW 4 COL 22 COLON-ALIGNED HELP
          "Vers∆o do layout de registros."
     v-log-datasul AT ROW 4.08 COL 28.29 HELP
          "Indica se o layout Ç padr∆o da Datasul ou do cliente."
     br-tt-bc-etiqueta AT ROW 5.25 COL 1
     iNrEtiqueta AT ROW 16.63 COL 37.14 COLON-ALIGNED
     bt-det AT ROW 17.71 COL 73.86 HELP
          "Altera ocorrància corrente"
     bt-trans-erro AT ROW 17.71 COL 78 HELP
          "Altera ocorrància corrente"
     bt-mod AT ROW 17.71 COL 82 HELP
          "Altera ocorrància corrente"
     bt-del AT ROW 17.71 COL 86 HELP
          "Elimina ocorrància corrente"
     RECT-59 AT ROW 2.75 COL 1
     rtToolBar AT ROW 17.58 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 18.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.21
         WIDTH              = 90.14
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}
//liga o facelift
&GLOBAL-DEFINE aplica_facelift YES
{include/i_fcldef.i}
{include/i_fclfrm.i fpage0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-tt-bc-etiqueta v-log-datasul fpage0 */
ASSIGN 
       br-tt-bc-etiqueta:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR BUTTON bt-va-para IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iNrEtiqueta IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-cod-layout IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-descricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-num-versao IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-bc-etiqueta
/* Query rebuild information for BROWSE br-tt-bc-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-bc-etiqueta NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-tt-bc-etiqueta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tt-bc-etiqueta
&Scoped-define SELF-NAME br-tt-bc-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-bc-etiqueta wWindow
ON ROW-DISPLAY OF br-tt-bc-etiqueta IN FRAME fpage0
DO:

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-bc-etiqueta wWindow
ON VALUE-CHANGED OF br-tt-bc-etiqueta IN FRAME fpage0
DO:
   IF AVAILABLE tt-bc-etiqueta THEN DO:
      RUN emptyTree IN h-4gltreeview NO-ERROR.
        
      ASSIGN cExpClp  = "expanded"
             cFont    = "font=1"
             cFgColor = "fgcolor=0".
                  
      RUN pi-create-node IN THIS-PROCEDURE (INPUT "p":U + STRING(tt-bc-etiqueta.nr-etiq),
                                            INPUT "",
                                            INPUT "Etiqueta:" + " ":U + STRING(tt-bc-etiqueta.progressivo),
                                            INPUT "image/treeview/tvpics/barcode.bmp",
                                            INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont).       
           
      RUN pi-create-node IN THIS-PROCEDURE (INPUT "i":U + STRING(tt-bc-etiqueta.nr-etiq),
                                            INPUT "p":U + STRING(tt-bc-etiqueta.nr-etiq),
                                            INPUT "Movimentaá∆o":U,
                                            INPUT "image/treeview/tvpics/field.bmp",
                                            INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.
        
      /* verifica se existem transacoes para etiqueta */
      IF CAN-FIND(FIRST bc-trans-etiq WHERE bc-trans-etiq.nr-etiq = tt-bc-etiqueta.nr-etiq no-lock) THEN DO:
         RUN pi-popula-treeview-transacao (INPUT tt-bc-etiqueta.nr-etiq).
      END.  

      RUN pi-atualizaTreeview.   
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del wWindow
ON CHOOSE OF bt-del IN FRAME fpage0 /* Elimina Etiqueta */
DO: 
   DEF VAR i-nr-etiq LIKE bc-etiqueta.nr-etiq NO-UNDO.  

   IF c-codigo-node <> "" THEN DO:
      FIND FIRST bc-estado-etiq 
           WHERE bc-estado-etiq.cod-estado = tt-bc-etiqueta.cod-estado NO-LOCK NO-ERROR.
      IF c-codigo-node BEGINS "p":U THEN DO:
         IF AVAILABLE bc-estado-etiq THEN DO:
            IF bc-estado.per-eliminar = YES THEN DO:
               IF LOOKUP(bc-estado-etiq.gr-usuar-elim,v_cod_grp_usuar_lst) = 0 THEN DO:
                  /* Usu†rio sem permiss∆o de Eliminaá∆o de Etiqueta */
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT 27778,
                                     INPUT "").
                  RETURN.
               END. /* if */.
            END.
            ELSE DO:
               /* Opá∆o de Eliminaá∆o de Etiqueta desabilitada */
               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 27779,
                                  INPUT "").
               RETURN.
            END.
         END.
         ELSE DO:
            /* N∆o localizado Estado de Etiqueta para Alteraá∆o */
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27773,
                               INPUT "").       
            RETURN.
         END.

         RUN utp/ut-msgs.p ("show":U,
                            28157,
                            STRING(tt-bc-etiqueta.nr-etiq)).

         CASE (RETURN-VALUE = "yes"):
            WHEN TRUE THEN DO:
               ASSIGN i-nr-etiq = tt-bc-etiqueta.nr-etiq.
               DO TRANSACTION:
                  FIND FIRST bc-etiqueta 
                       WHERE bc-etiqueta.nr-etiq = i-nr-etiq EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAILABLE bc-etiqueta THEN DO:
                     FOR EACH bc-trans-etiq 
                        WHERE bc-trans-etiq.nr-etiq = bc-etiqueta.nr-etiq EXCLUSIVE-LOCK:
                        FIND FIRST bc-trans
                             WHERE bc-trans.nr-trans = bc-trans-etiq.nr-trans EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL bc-trans THEN DO:
                           FOR EACH bc-trans-erros 
                              WHERE bc-trans-erros.nr-trans = bc-trans.nr-trans EXCLUSIVE-LOCK:
                              DELETE bc-trans-erros.
                           END.

                           FOR EACH bc-trans-filho 
                              WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans EXCLUSIVE-LOCK:
                              DELETE bc-trans-filho.
                           END.
                           DELETE bc-trans.
                        END.

                        FOR EACH bc-trans-filho-etiq
                           WHERE bc-trans-filho-etiq.nr-trans = bc-trans-etiq.nr-trans
                             AND bc-trans-filho-etiq.nr-etiq  = bc-trans-etiq.nr-etiq EXCLUSIVE-LOCK:
                           DELETE bc-trans-filho-etiq.
                        END.
                        DELETE bc-trans-etiq.
                     END.
                     DELETE bc-etiqueta.

                     DELETE tt-bc-etiqueta.

                  END.
               END.

               {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
               APPLY "VALUE-CHANGED" TO  br-tt-bc-etiqueta IN FRAME fpage0.                   
            END.
            WHEN FALSE THEN DO:
               RETURN NO-APPLY.
            END.
         END CASE. 
      END.
      ELSE DO:
         IF c-codigo-node BEGINS "i":U OR c-codigo-node BEGINS "t":U THEN DO:
            /* N∆o Ç poss°vel a eliminaá∆o de transaá∆o */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27780,
                               INPUT "").
         END.
         ELSE DO:
            /* N∆o identificado registro para Eliminaá∆o */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27781,
                               INPUT "").
         END.
      END.        
   END.
   ELSE DO:
      /* Selecione um Layout v†lido para Etiqueta */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27771,
                         INPUT ""). 
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det wWindow
ON CHOOSE OF bt-det IN FRAME fpage0 /* Detalhe Etiqueta/Transaá∆o */
DO:
   IF c-codigo-node <> "" THEN DO:
      IF c-codigo-node BEGINS "p":U THEN DO:
         ems:
         DO ON ERROR UNDO ems, LEAVE ems
            ON ENDKEY UNDO ems, LEAVE ems
            ON QUIT UNDO ems, LEAVE ems
            ON STOP UNDO ems, LEAVE ems:
            RUN pi-det-bc-etiqueta.                                            
         END. /* do ems */
         IF ERROR-STATUS:ERROR = YES AND ERROR-STATUS:GET-NUMBER(1) <> 6456 THEN DO: 
            /* Ocorreram erros de execuá∆o de subprogramas */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27766,
                               INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
         END.
      END.
      ELSE DO:
         IF c-codigo-node BEGINS "t":U THEN DO:
            ASSIGN ERROR-STATUS:ERROR = NO.
            ems:
            DO ON ERROR UNDO ems, LEAVE ems
               ON ENDKEY UNDO ems, LEAVE ems
               ON QUIT UNDO ems, LEAVE ems
               ON STOP UNDO ems, LEAVE ems:
               RUN pi-det-bc-trans. 
            END. /* do ems */
            IF ERROR-STATUS:ERROR = YES AND ERROR-STATUS:GET-NUMBER(1) <> 6456 THEN DO: 
               /* Ocorreram erros de execuá∆o de subprogramas */
               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 27766,
                                  INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
            END. 
         END.
         ELSE DO:
            /* N∆o identificado registro para Detalhe */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27770,
                               INPUT "").       
         END.
      END.
   END.
   ELSE DO:
      /* Selecione um Layout v†lido para Etiqueta */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27771,
                         INPUT ""). 
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wWindow
ON CHOOSE OF bt-filtro IN FRAME fpage0 /* Filtro */
DO:
   DEF VAR cCod-EstabelIni AS CHAR NO-UNDO.
   DEF VAR cCod-EstabelFim AS CHAR NO-UNDO.
   DEF VAR cCod-LocalIni   AS CHAR NO-UNDO.
   DEF VAR cCod-LocalFim   AS CHAR NO-UNDO.
   DEF VAR cBlocoIni       AS CHAR NO-UNDO.
   DEF VAR cBlocoFim       AS CHAR NO-UNDO.
   DEF VAR cRuaIni         AS CHAR NO-UNDO.
   DEF VAR cRuaFim         AS CHAR NO-UNDO.
   DEF VAR cColunaIni      AS CHAR NO-UNDO.
   DEF VAR cColunaFim      AS CHAR NO-UNDO.
   DEF VAR cNivelIni       AS CHAR NO-UNDO.
   DEF VAR cNivelFim       AS CHAR NO-UNDO.

   ASSIGN ERROR-STATUS:ERROR = NO.
   ems:
   DO ON ERROR UNDO ems, LEAVE ems
      ON ENDKEY UNDO ems, LEAVE ems
      ON QUIT UNDO ems, LEAVE ems
      ON STOP UNDO ems, LEAVE ems:    

      FOR EACH tt-estrutura:
         ASSIGN tt-estrutura.faixa = NO.
      END.

      /** CAMPO WMS **/

      FIND FIRST tt-estrutura 
           WHERE tt-estrutura.atributo = 'bc-etiqueta.id-box':U NO-ERROR.
      IF AVAIL tt-estrutura AND CONNECTED("MGSCM":U) THEN DO:
         
         CREATE tt-estrutura-aux.
         BUFFER-COPY tt-estrutura TO tt-estrutura-aux.
         DELETE tt-estrutura.

         /** CRIANDO OS VALORES DE COORDENADA DO WMS **/
         FIND FIRST tt-estrutura-wms NO-LOCK NO-ERROR.
         IF NOT AVAIL tt-estrutura-wms THEN DO:

            CREATE tt-estrutura.
            ASSIGN tt-estrutura.sequencia  = 999999991
                   tt-estrutura.titulo     = "Bloco"
                   tt-estrutura.titulo-col = "Bloco"
                   tt-estrutura.atributo   = "Bloco":U
                   tt-estrutura.formato    = "x(3)":U
                   tt-estrutura.tipo-dado  = "CHARACTER":U
                   tt-estrutura.inicial    = ''  
                   tt-estrutura.final      = fill('Z':U,3).

            CREATE tt-estrutura.
            ASSIGN tt-estrutura.sequencia  = 999999992
                   tt-estrutura.titulo     = "Rua"
                   tt-estrutura.titulo-col = "Rua"
                   tt-estrutura.atributo   = "Rua":U
                   tt-estrutura.formato    = "x(3)":U
                   tt-estrutura.tipo-dado  = "CHARACTER":U
                   tt-estrutura.inicial    = ''  
                   tt-estrutura.final      = fill('Z':U,3).

            CREATE tt-estrutura.
            ASSIGN tt-estrutura.sequencia  = 999999993
                   tt-estrutura.titulo     = "N°vel"
                   tt-estrutura.titulo-col = "N°vel"
                   tt-estrutura.atributo   = "Nivel":U
                   tt-estrutura.formato    = "x(3)":U
                   tt-estrutura.tipo-dado  = "CHARACTER":U
                   tt-estrutura.inicial    = ''  
                   tt-estrutura.final      = fill('Z':U,3).

            CREATE tt-estrutura.
            ASSIGN tt-estrutura.sequencia  = 999999994
                   tt-estrutura.titulo     = "Coluna"
                   tt-estrutura.titulo-col = "Coluna"
                   tt-estrutura.atributo   = "Coluna":U
                   tt-estrutura.formato    = "x(3)":U
                   tt-estrutura.tipo-dado  = "CHARACTER":U
                   tt-estrutura.inicial    = ''  
                   tt-estrutura.final      = fill('Z':U,3).
         END.
         ELSE DO:
            FOR EACH tt-estrutura-wms:
               CREATE tt-estrutura.
               BUFFER-COPY tt-estrutura-wms TO tt-estrutura.
            END.
         END.
      END.
      ELSE
         EMPTY TEMP-TABLE ttWm-box-bc.

      /** CAMPO WMS **/
      RUN bcp/bc0118a.w (INPUT-OUTPUT TABLE tt-estrutura) NO-ERROR.

      IF ERROR-STATUS:ERROR = YES THEN DO: 
         /* Ocorreram erros de execuá∆o de subprogramas */
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 27766,
                            INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
         RETURN 'NOK':U.
      END.

      /** retornar o campo id-box **/
      FIND FIRST tt-estrutura-aux NO-ERROR.
      IF AVAIL tt-estrutura-aux AND CONNECTED("MGSCM":U) THEN DO:
         CREATE tt-estrutura.
         BUFFER-COPY tt-estrutura-aux TO tt-estrutura.
         DELETE tt-estrutura-aux.
      END.

      /** CAMPO WMS  - MONTAGEM DA TT-WM-BOX PARA LEITURA **/
      FIND FIRST tt-estrutura 
           WHERE tt-estrutura.atributo = 'bc-etiqueta.id-box':U NO-ERROR.
      IF AVAIL tt-estrutura AND CONNECTED("MGSCM":U) THEN DO:
         /** verificar se alguma faixa foi alterada **/
         FIND FIRST tt-estrutura 
              WHERE tt-estrutura.sequencia > 999999990 
                AND (tt-estrutura.inicial  <> ''  
                  OR tt-estrutura.final    <> fill('Z':U,3)) NO-ERROR.
         IF AVAIL tt-estrutura THEN DO:
            ASSIGN lAlterouWMS = NO
                   cCod-EstabelIni = ""
                   cCod-EstabelFim = "ZZZ"
                   cCod-LocalIni   = ""
                   cCod-LocalFim   = "ZZZ".

            FIND FIRST tt-estrutura     
                 WHERE tt-estrutura.atributo = "cod-estabel" NO-ERROR.
            FIND FIRST tt-estrutura-wms
                 WHERE tt-estrutura-wms.atributo = "cod-estabel" NO-ERROR.

            IF AVAIL tt-estrutura THEN DO:
               ASSIGN cCod-EstabelIni = tt-estrutura.inicial
                      cCod-EstabelFim = tt-estrutura.final.

               IF AVAIL tt-estrutura-wms
                  AND (tt-estrutura.inicial <> tt-estrutura-wms.inicial 
                    OR tt-estrutura.final   <> tt-estrutura-wms.final) THEN 
                  ASSIGN lAlterouWMS = YES.

               IF AVAIL tt-estrutura-wms THEN
                  DELETE tt-estrutura-wms.
                   
               CREATE tt-estrutura-wms.
               BUFFER-COPY tt-estrutura TO tt-estrutura-wms.
            END.

            FIND FIRST tt-estrutura 
                 WHERE tt-estrutura.atributo = "cod-local" NO-ERROR.
                 
            FIND FIRST tt-estrutura-wms
                 WHERE tt-estrutura-wms.atributo = "cod-local" NO-ERROR.

            IF AVAIL tt-estrutura THEN DO:
               
               ASSIGN cCod-LocalIni = tt-estrutura.inicial
                      cCod-LocalFim = tt-estrutura.final.

               IF AVAIL tt-estrutura-wms
                   AND (tt-estrutura.inicial <> tt-estrutura-wms.inicial 
                     OR tt-estrutura.final   <> tt-estrutura-wms.final) THEN 
                  ASSIGN lAlterouWMS = YES.

               IF AVAIL tt-estrutura-wms THEN
                  DELETE tt-estrutura-wms.
                  
                CREATE tt-estrutura-wms.
                BUFFER-COPY tt-estrutura TO tt-estrutura-wms.
            END.

            EMPTY TEMP-TABLE tt-estrutura-wms.

            FOR EACH tt-estrutura
               WHERE tt-estrutura.sequencia > 999999990:

               FIND FIRST tt-estrutura-wms 
                    WHERE tt-estrutura-wms.atributo = tt-estrutura.atributo NO-ERROR.

               IF tt-estrutura.atributo = "bloco":U THEN
                  ASSIGN cBlocoIni = tt-estrutura.inicial
                         cBlocoFim = tt-estrutura.final.

               IF tt-estrutura.atributo = "Rua":U THEN
                  ASSIGN cRuaIni = tt-estrutura.inicial
                         cRuaFim = tt-estrutura.final.

               IF tt-estrutura.atributo = "Coluna":U THEN
                  ASSIGN cColunaIni = tt-estrutura.inicial
                         cColunaFim = tt-estrutura.final.

               IF tt-estrutura.atributo = "Nivel":U THEN
                  ASSIGN cNivelIni = tt-estrutura.inicial
                         cNivelFim = tt-estrutura.final.

               IF AVAIL tt-estrutura-wms
                   AND (tt-estrutura.inicial  <> tt-estrutura-wms.inicial 
                     OR tt-estrutura.final <> tt-estrutura-wms.final) THEN 
                  ASSIGN lAlterouWMS = YES.

               IF AVAIL tt-estrutura-wms THEN
                  DELETE tt-estrutura-wms.
               ELSE 
                  ASSIGN lAlterouWMS = YES. /* caso seja a primeira vez ele nao tera ttwms*/

               CREATE tt-estrutura-wms.
               BUFFER-COPY tt-estrutura TO tt-estrutura-wms.

               DELETE tt-estrutura.

            END.

            IF lAlterouWMS THEN DO:

               EMPTY TEMP-TABLE ttWm-box-bc.

               RUN bcp/bc0118wms.p (INPUT cCod-EstabelIni,
                                    INPUT cCod-EstabelFim,
                                    INPUT cCod-LocalIni,
                                    INPUT cCod-LocalFim,
                                    INPUT cBlocoIni,
                                    INPUT cBlocoFim,
                                    INPUT cRuaIni,
                                    INPUT cRuaFim,
                                    INPUT cColunaIni,
                                    INPUT cColunaFim,
                                    INPUT cNivelIni,
                                    INPUT cNivelFim,
                                    OUTPUT TABLE ttWm-box-bc).
            END.
         END.
         ELSE DO: 
            FOR EACH tt-estrutura
               WHERE tt-estrutura.sequencia > 999999990:
               DELETE tt-estrutura.
            END.

            EMPTY TEMP-TABLE tt-estrutura-wms.

            EMPTY TEMP-TABLE ttWm-box-bc.
         END.
      END.
   END.

   RUN pi-cria-condicao.
   RETURN 'ok':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mod wWindow
ON CHOOSE OF bt-mod IN FRAME fpage0 /* Modifica Etiqueta/Transaá∆o */
DO:
   IF c-codigo-node <> "" THEN DO:
      IF c-codigo-node BEGINS "p":U THEN DO:     
         FIND FIRST bc-etiqueta
              WHERE bc-etiqueta.nr-etiq = tt-bc-etiqueta.nr-etiq NO-LOCK NO-ERROR.

         FIND FIRST bc-estado-etiq 
              WHERE bc-estado-etiq.cod-estado = bc-etiqueta.cod-estado NO-LOCK NO-ERROR.
         IF AVAILABLE bc-estado-etiq THEN DO:
            IF bc-estado-etiq.per-modificar = YES THEN DO:
               IF LOOKUP(bc-estado-etiq.gr-usuar-mod,v_cod_grp_usuar_lst) = 0 THEN DO:
                  /* Usu†rio sem permiss∆o de Alteraá∆o de Etiqueta */
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT 27774,
                                     INPUT "").   
                  RETURN.
               END /* if */.
            END.
            ELSE DO:
               /* Opá∆o de Alteraá∆o de Etiqueta desabilitada */
               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 27775,
                                  INPUT "").  
               RETURN.
            END.
         END.
         ELSE DO:
            /* N∆o localizado Estado de Etiqueta para Alteraá∆o */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27773,
                               INPUT "").       
            RETURN.
         END.
         ems:
         DO ON ERROR UNDO ems, LEAVE ems
            ON ENDKEY UNDO ems, LEAVE ems
            ON QUIT UNDO ems, LEAVE ems
            ON STOP UNDO ems, LEAVE ems:
            RUN pi-mod-bc-etiqueta.                                            
         END.
         IF ERROR-STATUS:ERROR = YES AND ERROR-STATUS:GET-NUMBER(1) <> 6456 THEN DO: 
            /* Ocorreram erros de execuá∆o de subprogramas */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27766,
                               INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
         END.
      END.
      ELSE DO:
         IF c-codigo-node BEGINS "t":U THEN DO:
            ASSIGN ERROR-STATUS:ERROR = NO.
            ems:
            DO ON ERROR UNDO ems, LEAVE ems
               ON ENDKEY UNDO ems, LEAVE ems
               ON QUIT UNDO ems, LEAVE ems
               ON STOP UNDO ems, LEAVE ems:
               RUN pi-mod-bc-trans.
            END.
            IF ERROR-STATUS:ERROR = YES AND ERROR-STATUS:GET-NUMBER(1) <> 6456 THEN DO: 
               /* Ocorreram erros de execuá∆o de subprogramas */
               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 27766,
                                  INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
            END.
         END.
         ELSE DO:
            /* Nao identificado registro para Modificar */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27775,
                               INPUT "").  
         END.
      END.
   END.
   ELSE DO:
      /* Selecione um Layout v†lido para Etiqueta */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27771,
                         INPUT ""). 
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-refresh wWindow
ON CHOOSE OF bt-refresh IN FRAME fpage0 /* Refresh */
DO:
   ASSIGN iNrEtiqueta = 0
          iNrEtiqueta:SCREEN-VALUE IN FRAME fpage0 = "0".

   IF c-condicao = '' THEN DO:    
      RUN pi-cria-condicao.
       
      IF c-condicao = '' THEN
         RETURN NO-APPLY.
   END.

   RUN utp/ut-acomp.p PERSISTENT SET h_acomp.

   {utp/ut-liter.i Processando *}
   RUN pi-inicializar IN h_acomp (INPUT RETURN-VALUE).

   {utp/ut-liter.i Lendo_Etiquetas *}
   RUN pi-acompanhar IN h_acomp (INPUT RETURN-VALUE).

   RUN pi-open-br-tt-bc-etiqueta.

   {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

   APPLY "VALUE-CHANGED":U TO  br-tt-bc-etiqueta IN FRAME fpage0.

   RUN pi-finalizar IN h_acomp.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sea wWindow
ON CHOOSE OF bt-sea IN FRAME fpage0 /* Pesquisa Layout */
DO:
   {method/zoomfields.i &ProgramZoom="clzoom/z01cl023.w"
                        &FieldZoom1="cod-layout"
                        &FieldScreen1="v-cod-layout"
                        &Frame1="fPage0"
                        &FieldZoom2="descricao"
                        &FieldScreen2="v-descricao"
                        &Frame2="fPage0"
                        &FieldZoom3="num-versao"
                        &FieldScreen3="v-num-versao"
                        &Frame3="fPage0"
                        &FieldZoom4="log-datasul"
                        &FieldScreen4="v-log-datasul"
                        &Frame4="fPage0"
                        &EnableImplant="NO"}
   WAIT-FOR CLOSE OF hProgramZoom. 
 
   RUN pi-popula-tt-estrutura.

   IF RETURN-VALUE <> 'OK':U  THEN DO:
      EMPTY TEMP-TABLE tt-estrutura.
      EMPTY TEMP-TABLE tt-bc-etiqueta.  
   END.
   ELSE DO:
      RUN pi-popula-tt-bc-tipo-trans.
      RUN pi-ordena-coluna.
      RUN pi-popula-br-bc-etiqueta.
      RUN pi-cria-condicao.
      RUN pi-open-br-tt-bc-etiqueta.
   END.

   {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
   APPLY "VALUE-CHANGED" TO br-tt-bc-etiqueta IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-trans-erro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-trans-erro wWindow
ON CHOOSE OF bt-trans-erro IN FRAME fpage0 /* Detalhe Erro Transaá∆o */
DO:
   IF VALID-HANDLE(h-4gltreeview) THEN DO:
      IF c-codigo-node BEGINS "t":U THEN DO:
         ASSIGN ERROR-STATUS:ERROR = NO.
         ems:
         DO ON ERROR UNDO ems, leave ems
            ON ENDKEY UNDO ems, leave ems
            ON QUIT UNDO ems, leave ems
            ON STOP UNDO ems, leave ems:
            RUN pi-det-bc-trans-erro. 
         END.
         IF ERROR-STATUS:ERROR = YES THEN DO: 
            /* Ocorreram erros de execuá∆o de subprogramas */
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 27766,
                               INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
         END.
      END.
      ELSE DO:
         /* N∆o identificado registro para Detalhar Erros de Transaá∆o */
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 27772,
                            INPUT ""). 
      END.
   END.
   ELSE DO:
      /* Selecione um Layout v†lido para Etiqueta */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27771,
                         INPUT ""). 
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-va-para wWindow
ON CHOOSE OF bt-va-para IN FRAME fpage0 /* go */
DO:
   DEFINE VARIABLE teste AS HANDLE.
   DEFINE VARIABLE v-log-aux AS LOGICAL NO-UNDO.

   SESSION:SET-WAIT-STATE("GENERAL":U).
   RUN gotorecord.
   IF RECID(bc-etiqueta) <> ? THEN DO:
      
      EMPTY TEMP-TABLE tt-bc-etiqueta.

      IF v-tip-procura = YES THEN do:
         FOR EACH b-bc-etiqueta
            WHERE b-bc-etiqueta.nr-etiq = bc-etiqueta.nr-etiq NO-LOCK:
            CREATE tt-bc-etiqueta.
            BUFFER-COPY b-bc-etiqueta TO tt-bc-etiqueta.
         END.
      END.
      ELSE DO: 
         FOR EACH b-bc-etiqueta
            WHERE b-bc-etiqueta.progressivo = bc-etiqueta.progressivo NO-LOCK:
            CREATE tt-bc-etiqueta.
            BUFFER-COPY b-bc-etiqueta TO tt-bc-etiqueta.
         END.
      END.

      IF v-log-datasul:CHECKED IN FRAME {&FRAME-NAME} = YES  THEN DO:
         ASSIGN v-log-aux = YES.
      END.
      ELSE DO:
         ASSIGN v-log-aux = NO.
      END.

      IF bc-etiqueta.cod-layout  <> INPUT FRAME {&FRAME-NAME} v-cod-layout OR
         bc-etiqueta.num-versao  <> INPUT FRAME {&FRAME-NAME} v-num-versao OR
         bc-etiqueta.log-datasul <> v-log-aux  THEN DO:

         /* Selecionada Etiqueta com outro Layout */
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 27767,
                            INPUT " ").        

         ASSIGN v-cod-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(bc-etiqueta.cod-layout).
                v-num-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(bc-etiqueta.num-versao).
         IF bc-etiqueta.log-datasul = YES THEN
            ASSIGN v-log-datasul:CHECKED IN FRAME {&FRAME-NAME} = YES.
         IF bc-etiqueta.log-datasul = NO THEN
            ASSIGN v-log-datasul:CHECKED IN FRAME {&FRAME-NAME} = NO.
      END.

      ASSIGN iNrEtiqueta = 0
             iNrEtiqueta:SCREEN-VALUE IN FRAME fpage0 = "0".

      FOR EACH tt-bc-etiqueta:

         ASSIGN iNrEtiqueta = iNrEtiqueta + 1
                iNrEtiqueta:SCREEN-VALUE IN FRAME fpage0 = STRING(iNrEtiqueta).

         FIND FIRST tt-bc-estado-etiq
              WHERE tt-bc-estado-etiq.cod-estado = tt-bc-etiqueta.cod-estado NO-LOCK NO-ERROR.
         IF AVAILABLE tt-bc-estado-etiq THEN 
            ASSIGN tt-bc-etiqueta.estado-des = STRING(tt-bc-estado-etiq.cod-estado,"ZZ9":U) + "-":U + tt-bc-estado-etiq.descricao.
         ELSE
            ASSIGN tt-bc-etiqueta.estado-des = STRING(tt-bc-estado-etiq.cod-estado,"ZZ9":U).
      END.
      
      {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
   END.
   SESSION:SET-WAIT-STATE("":U).
   IF AVAILABLE bc-etiqueta THEN
      APPLY "VALUE-CHANGED":U TO  br-tt-bc-etiqueta IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
   RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
   RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


FUNCTION SetListViewStyle RETURNS LOGICAL
  (INPUT ip_iHwnd AS INT,
   INPUT ip_iStyle AS INT)  FORWARD.
    &GLOB HWND_TOPMOST -1
    &GLOB HWND_NOTOPMOST -2

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padrío para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padrío para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padrío para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
   ON SHIFT-CTRL-TAB ANYWHERE
      RUN prevFolder IN hFolder.
&ENDIF

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- Padrío para janelas GUI ---*/

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

RUN beforeInitializeInterface IN THIS-PROCEDURE.
/*--- Block principal do programa ---*/
DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
   FIND FIRST bc-layout 
        WHERE bc-layout.cod-tipo-layout = 3 NO-LOCK NO-ERROR.
   IF AVAILABLE bc-layout THEN DO:
      ASSIGN v-cod-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(bc-layout.cod-layout)
             v-descricao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = bc-layout.descricao
             v-num-versao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = string(bc-layout.num-versao).
   END.  
   ELSE DO:
      /* N∆o existem layouts para o programa bc0118 */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27764,
                         INPUT " ").        
   END.
   RUN pi-popula-br-bc-etiqueta. 
   /*--- Seta cursor do mouse para normal ---*/
   SESSION:SET-WAIT-STATE("":U).

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
RETURN 'ok':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
   
      RUN setParentFrame IN h-4gltreeview (INPUT FRAME fPage0:HANDLE).
   
      RUN initializeObject IN h-4gltreeview.
   
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.
   
      RUN repositionObject IN h-4gltreeview ( 5.25 , 49.00 ) NO-ERROR.
      RUN resizeObject IN h-4gltreeview ( 12.25 , 42.00 ) NO-ERROR.
   END.
   
   IF AVAIL bc-layout THEN DO:
      RUN pi-popula-tt-estrutura.
      RUN pi-popula-tt-estrut-tab.
      RUN pi-popula-br-bc-etiqueta.
   END.
   
   EMPTY TEMP-TABLE tt-bc-estado-etiq.
   
   FOR EACH bc-estado-etiq NO-LOCK:
      CREATE tt-bc-estado-etiq.
      BUFFER-COPY bc-estado-etiq TO tt-bc-estado-etiq.
   END.
    
   RUN pi-atualizaTreeview.   
   
   RUN applyEntry IN h-4gltreeview (INPUT "").
   
   APPLY "VALUE-CHANGED":U TO  br-tt-bc-etiqueta IN FRAME fpage0. 
   
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Associa o ImageList ao TreeView    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR chTreeView  AS COM-HANDLE NO-UNDO.
   DEF VAR chImageList AS COM-HANDLE NO-UNDO.
   
   IF NOT AVAILABLE bc-layout THEN DO:
      FIND FIRST bc-layout 
           WHERE bc-layout.cod-tipo-layout = 3 NO-LOCK NO-ERROR.
      IF AVAILABLE bc-layout THEN DO:
         ASSIGN v-cod-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(bc-layout.cod-layout)
                v-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = bc-layout.descricao
                v-num-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(bc-layout.num-versao).
      END.  
      ELSE DO:
         /* N∆o existem layouts para o programa bc0118 */
         RUN utp/ut-msgs.p (INPUT "SHOW":U,
                            INPUT 27764,
                            INPUT " ").
      END.
   END.
   RETURN 'OK':U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gotorecord wWindow 
PROCEDURE gotorecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar"
         SIZE 10 BY 1
         BGCOLOR 8.

   DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK"
         SIZE 10 BY 1
         BGCOLOR 8.

   DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

   DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
   DEFINE VARIABLE v-nr-etiq     LIKE bc-etiqueta.nr-etiq     NO-UNDO LABEL "N£mero".
   DEFINE VARIABLE v-progressivo LIKE bc-etiqueta.progressivo NO-UNDO LABEL "N£mero".

   DEFINE FRAME fGoToRecord
        v-tip-procura AT ROW 1.21 COL 17.72 COLON-ALIGNED
        v-nr-etiq  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        v-progressivo AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Nr Etiqueta/Nr Serial" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
   &IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
      {utp/ut-liter.i V†_Para_Nr_Etiqueta/Nr_Serial *}
      ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
      RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
   &ENDIF

   ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
      ASSIGN v-nr-etiq v-progressivo.
      IF INPUT FRAME fGoToRecord v-tip-procura = YES THEN DO:
         IF v-nr-etiq = 0 THEN
            RETURN NO-APPLY.

         FIND FIRST bc-etiqueta
              WHERE bc-etiqueta.nr-etiq = v-nr-etiq NO-LOCK NO-ERROR.
      END.
      ELSE DO:
         IF v-progressivo = "" THEN
            RETURN NO-APPLY.

         FIND FIRST bc-etiqueta
              WHERE bc-etiqueta.progressivo = v-progressivo NO-LOCK NO-ERROR.
      END.

      IF NOT AVAIL bc-etiqueta THEN DO:
         /*Vagner*/
         {utp/ut-liter.i Etiqueta * L}
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 2,
                           INPUT TRIM(RETURN-VALUE)).
         RETURN NO-APPLY.
      END.

      APPLY "GO":U TO FRAME fGoToRecord.
   END.

   ON "VALUE-CHANGED":U OF v-tip-procura IN FRAME fGoToRecord DO:
      IF INPUT FRAME fGoToRecord v-tip-procura = NO  THEN do:
         ASSIGN v-progressivo:VISIBLE IN FRAME fGoToRecord = YES
                v-nr-etiq:VISIBLE IN FRAME fGoToRecord     = NO
                v-tip-procura                              = NO.
      END.
      ELSE DO:
         ASSIGN v-progressivo:VISIBLE IN FRAME fGoToRecord = NO
                v-nr-etiq:VISIBLE IN FRAME fGoToRecord     = YES
                v-tip-procura                              = YES.
      END.                                                
   END.
   DISPLAY v-tip-procura
           v-progressivo
           v-nr-etiq
      WITH FRAME fGoToRecord. 

   ENABLE v-tip-procura
          v-progressivo
          v-nr-etiq
          btGoToOK
          btGoToCancel
      WITH FRAME fGoToRecord. 
   
   ASSIGN v-nr-etiq:VISIBLE IN FRAME fGoToRecord = NO. 

   IF v-tip-procura = NO  THEN do:
      ASSIGN v-progressivo:VISIBLE IN FRAME fGoToRecord = YES
             v-nr-etiq:VISIBLE IN FRAME fGoToRecord     = NO.
      APPLY "ENTRY":U TO v-progressivo IN FRAME fGoToRecord.
   END.
   ELSE DO:
      ASSIGN v-progressivo:VISIBLE IN FRAME fGoToRecord = NO
             v-nr-etiq:VISIBLE IN FRAME fGoToRecord     = YES.
             
      APPLY "ENTRY":U TO v-nr-etiq IN FRAME fGoToRecord.
   END.     

   WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-br-bc-etiqueta-vis1 wWindow 
PROCEDURE pi-br-bc-etiqueta-vis1 :
/*------------------------------------------------------------------------------
  Purpose:   Procedure para dar visible conforme ordem parametrizada  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {bcp/bc0118.i bc-etiqueta.nr-etiq tt-bc-etiqueta.nr-etiq}
   {bcp/bc0118.i bc-etiqueta.nr-etiq-pai tt-bc-etiqueta.nr-etiq-pai}
   {bcp/bc0118.i bc-etiqueta.it-codigo tt-bc-etiqueta.it-codigo}
   {bcp/bc0118.i bc-etiqueta.lote  tt-bc-etiqueta.lote}
   {bcp/bc0118.i bc-etiqueta.referencia tt-bc-etiqueta.referencia}
   {bcp/bc0118.i bc-etiqueta.fm-codigo tt-bc-etiqueta.fm-codigo}   
   {bcp/bc0118.i bc-etiqueta.cdd-embarq tt-bc-etiqueta.cdd-embarq}
   {bcp/bc0118.i bc-etiqueta.nr-resumo tt-bc-etiqueta.nr-resumo}
   {bcp/bc0118.i bc-etiqueta.cod-estabel tt-bc-etiqueta.cod-estabel}
   {bcp/bc0118.i bc-etiqueta.serie tt-bc-etiqueta.serie}
   {bcp/bc0118.i bc-etiqueta.nr-nota-fis tt-bc-etiqueta.nr-nota-fis}
   {bcp/bc0118.i bc-etiqueta.nr-ord-produ tt-bc-etiqueta.nr-ord-produ}
   {bcp/bc0118.i bc-etiqueta.dt-criacao tt-bc-etiqueta.dt-criacao}
   {bcp/bc0118.i bc-etiqueta.dt-producao tt-bc-etiqueta.dt-producao}
   {bcp/bc0118.i bc-etiqueta.dt-separacao tt-bc-etiqueta.dt-separacao}
   {bcp/bc0118.i bc-etiqueta.dt-expedicao tt-bc-etiqueta.dt-expedicao}
   {bcp/bc0118.i bc-etiqueta.hr-criacao tt-bc-etiqueta.hr-criacao}
   {bcp/bc0118.i bc-etiqueta.hr-producao tt-bc-etiqueta.hr-producao}
   {bcp/bc0118.i bc-etiqueta.hr-separacao tt-bc-etiqueta.hr-separacao}
   {bcp/bc0118.i bc-etiqueta.hr-expedicao tt-bc-etiqueta.hr-expedicao}
   {bcp/bc0118.i bc-etiqueta.usuar-criacao tt-bc-etiqueta.usuar-criacao}

   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-br-bc-etiqueta-vis2 wWindow 
PROCEDURE pi-br-bc-etiqueta-vis2 :
/*------------------------------------------------------------------------------
  Purpose:   Procedure para dar visible conforme ordem parametrizada     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {bcp/bc0118.i bc-etiqueta.usuar-producao tt-bc-etiqueta.usuar-producao}
   {bcp/bc0118.i bc-etiqueta.usuar-separacao tt-bc-etiqueta.usuar-separacao}
   {bcp/bc0118.i bc-etiqueta.usuar-expedicao tt-bc-etiqueta.usuar-expedicao}
   {bcp/bc0118.i bc-etiqueta.qt-item tt-bc-etiqueta.qt-item}
   {bcp/bc0118.i bc-etiqueta.qt-un-1 tt-bc-etiqueta.qt-un-1}
   {bcp/bc0118.i bc-etiqueta.qt-un-2 tt-bc-etiqueta.qt-un-2}
   {bcp/bc0118.i bc-etiqueta.qt-un-3 tt-bc-etiqueta.qt-un-3}
   {bcp/bc0118.i bc-etiqueta.qt-un-4 tt-bc-etiqueta.qt-un-4}
   {bcp/bc0118.i bc-etiqueta.qt-un-5 tt-bc-etiqueta.qt-un-5}
   {bcp/bc0118.i bc-etiqueta.nr-pedcli tt-bc-etiqueta.nr-pedcli}  
   {bcp/bc0118.i bc-etiqueta.nome-abrev tt-bc-etiqueta.nome-abrev}
   {bcp/bc0118.i bc-etiqueta.caracter-livre-1 tt-bc-etiqueta.caracter-livre-1}
   {bcp/bc0118.i bc-etiqueta.caracter-livre-2 tt-bc-etiqueta.caracter-livre-2}
   {bcp/bc0118.i bc-etiqueta.caracter-livre-3 tt-bc-etiqueta.caracter-livre-3}
   {bcp/bc0118.i bc-etiqueta.caracter-livre-4 tt-bc-etiqueta.caracter-livre-4}
   {bcp/bc0118.i bc-etiqueta.caracter-livre-5 tt-bc-etiqueta.caracter-livre-5}
   {bcp/bc0118.i bc-etiqueta.inteiro-livre-1 tt-bc-etiqueta.inteiro-livre-1}
   {bcp/bc0118.i bc-etiqueta.inteiro-livre-2 tt-bc-etiqueta.inteiro-livre-2}
   {bcp/bc0118.i bc-etiqueta.inteiro-livre-3 tt-bc-etiqueta.inteiro-livre-3}
   {bcp/bc0118.i bc-etiqueta.inteiro-livre-4 tt-bc-etiqueta.inteiro-livre-4}
   {bcp/bc0118.i bc-etiqueta.inteiro-livre-5 tt-bc-etiqueta.inteiro-livre-5}

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-br-bc-etiqueta-vis3 wWindow 
PROCEDURE pi-br-bc-etiqueta-vis3 :
/*------------------------------------------------------------------------------
  Purpose:   Procedure para dar visible conforme ordem parametrizada    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {bcp/bc0118.i bc-etiqueta.decimal-livre-1 tt-bc-etiqueta.decimal-livre-1}
   {bcp/bc0118.i bc-etiqueta.decimal-livre-2 tt-bc-etiqueta.decimal-livre-2}
   {bcp/bc0118.i bc-etiqueta.decimal-livre-3 tt-bc-etiqueta.decimal-livre-3}
   {bcp/bc0118.i bc-etiqueta.decimal-livre-4 tt-bc-etiqueta.decimal-livre-4}
   {bcp/bc0118.i bc-etiqueta.decimal-livre-5 tt-bc-etiqueta.decimal-livre-5}
   {bcp/bc0118.i bc-etiqueta.logico-livre-1 tt-bc-etiqueta.logico-livre-1}
   {bcp/bc0118.i bc-etiqueta.logico-livre-2 tt-bc-etiqueta.logico-livre-2}
   {bcp/bc0118.i bc-etiqueta.logico-livre-3 tt-bc-etiqueta.logico-livre-3}
   {bcp/bc0118.i bc-etiqueta.logico-livre-4 tt-bc-etiqueta.logico-livre-4}
   {bcp/bc0118.i bc-etiqueta.logico-livre-5 tt-bc-etiqueta.logico-livre-5}
   {bcp/bc0118.i bc-etiqueta.data-livre-1 tt-bc-etiqueta.data-livre-1}
   {bcp/bc0118.i bc-etiqueta.data-livre-2 tt-bc-etiqueta.data-livre-2}
   {bcp/bc0118.i bc-etiqueta.data-livre-3 tt-bc-etiqueta.data-livre-3}
   {bcp/bc0118.i bc-etiqueta.data-livre-4 tt-bc-etiqueta.data-livre-4}
   {bcp/bc0118.i bc-etiqueta.data-livre-5 tt-bc-etiqueta.data-livre-5}
   {bcp/bc0118.i bc-etiqueta.cod-estado tt-bc-etiqueta.estado-des}
   {bcp/bc0118.i bc-etiqueta.progressivo tt-bc-etiqueta.progressivo}
   {bcp/bc0118.i bc-etiqueta.nr-pedido tt-bc-etiqueta.nr-pedido}
   {bcp/bc0118.i bc-etiqueta.ge-codigo tt-bc-etiqueta.ge-codigo}
   {bcp/bc0118.i bc-etiqueta.un-1 tt-bc-etiqueta.un} /*Vagner*/
   {bcp/bc0118.i bc-etiqueta.un-1 tt-bc-etiqueta.un-1}
   {bcp/bc0118.i bc-etiqueta.un-2 tt-bc-etiqueta.un-2}
   {bcp/bc0118.i bc-etiqueta.un-3 tt-bc-etiqueta.un-3}
   {bcp/bc0118.i bc-etiqueta.un-4 tt-bc-etiqueta.un-4}
   {bcp/bc0118.i bc-etiqueta.un-5 tt-bc-etiqueta.un-5}

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-br-bc-etiqueta-vis4 wWindow 
PROCEDURE pi-br-bc-etiqueta-vis4 :
/*------------------------------------------------------------------------------
  Purpose:   Procedure para dar visible conforme ordem parametrizada 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {bcp/bc0118.i bc-etiqueta.detalhe tt-bc-etiqueta.detalhe}
   {bcp/bc0118.i bc-etiqueta.localizacao tt-bc-etiqueta.localizacao}
   {bcp/bc0118.i bc-etiqueta.nat-operacao tt-bc-etiqueta.nat-operacao}
   {bcp/bc0118.i bc-etiqueta.ativo tt-bc-etiqueta.ativo}
   {bcp/bc0118.i bc-etiqueta.cd-trans tt-bc-etiqueta.cd-trans}
   {bcp/bc0118.i bc-etiqueta.linha-prod tt-bc-etiqueta.linha-prod}
   {bcp/bc0118.i bc-etiqueta.turno tt-bc-etiqueta.turno}
   {bcp/bc0118.i bc-etiqueta.cod-layout tt-bc-etiqueta.cod-layout}
   {bcp/bc0118.i bc-etiqueta.num-versao tt-bc-etiqueta.num-versao}
   {bcp/bc0118.i bc-etiqueta.log-datasul tt-bc-etiqueta.log-datasul}
   {bcp/bc0118.i bc-etiqueta.dt-inventario tt-bc-etiqueta.dt-inventario}
   {bcp/bc0118.i bc-etiqueta.hr-inventario tt-bc-etiqueta.hr-inventario}
   {bcp/bc0118.i bc-etiqueta.usuar-inventario tt-bc-etiqueta.usuar-inventario}
   {bcp/bc0118.i bc-etiqueta.nr-contagem tt-bc-etiqueta.nr-contagem}
   {bcp/bc0118.i bc-etiqueta.nr-operacao tt-bc-etiqueta.nr-operacao}
   {bcp/bc0118.i bc-etiqueta.id-docto tt-bc-etiqueta.id-docto}
   {bcp/bc0118.i bc-etiqueta.cod-controle-serie tt-bc-etiqueta.cod-controle-serie}
   {bcp/bc0118.i bc-etiqueta.cod-embalagem tt-bc-etiqueta.cod-embalagem}
   {bcp/bc0118.i bc-etiqueta.cod-montadora tt-bc-etiqueta.cod-montadora}
   {bcp/bc0118.i bc-etiqueta.cod-idioma tt-bc-etiqueta.cod-idioma}
   {bcp/bc0118.i bc-etiqueta.cod-agrupador1 tt-bc-etiqueta.cod-agrupador1}
   {bcp/bc0118.i bc-etiqueta.cod-agrupador2 tt-bc-etiqueta.cod-agrupador2}
   {bcp/bc0118.i bc-etiqueta.cod-agrupador3 tt-bc-etiqueta.cod-agrupador3}
   {bcp/bc0118.i bc-etiqueta.cod-agrupador4 tt-bc-etiqueta.cod-agrupador4}
   {bcp/bc0118.i bc-etiqueta.cod-agrupador5 tt-bc-etiqueta.cod-agrupador5}
   {bcp/bc0118.i bc-etiqueta.ep-codigo tt-bc-etiqueta.ep-codigo} 
   {bcp/bc0118.i bc-etiqueta.numero-ordem tt-bc-etiqueta.numero-ordem} 
   {bcp/bc0118.i bc-etiqueta.parcela tt-bc-etiqueta.parcela} 
   {bcp/bc0118.i bc-etiqueta.num-pedido tt-bc-etiqueta.num-pedido}
   {bcp/bc0118.i bc-etiqueta.nro-docto tt-bc-etiqueta.nro-docto} 
   {bcp/bc0118.i bc-etiqueta.serie-docto tt-bc-etiqueta.serie-docto} 
   {bcp/bc0118.i bc-etiqueta.nat-operacao-docto tt-bc-etiqueta.nat-operacao-docto} 
   {bcp/bc0118.i bc-etiqueta.cod-emitente-docto tt-bc-etiqueta.cod-emitente-docto} 
   {bcp/bc0118.i bc-etiqueta.id-box tt-bc-etiqueta.id-box} 
   {bcp/bc0118.i bc-etiqueta.cod-local tt-bc-etiqueta.cod-local} 
   {bcp/bc0118.i bc-etiqueta.sequencia-docto tt-bc-etiqueta.sequencia-docto} 
   {bcp/bc0118.i bc-etiqueta.dt-recebimento tt-bc-etiqueta.dt-recebimento} 
   {bcp/bc0118.i bc-etiqueta.hr-recebimento tt-bc-etiqueta.hr-recebimento} 
   {bcp/bc0118.i bc-etiqueta.usuar-recebimento tt-bc-etiqueta.usuar-recebimento} 
   {bcp/bc0118.i bc-etiqueta.nr-volume tt-bc-etiqueta.nr-volume} 

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-br-bc-etiqueta-vis5 wWindow 
PROCEDURE pi-br-bc-etiqueta-vis5 :
/*------------------------------------------------------------------------------
  Purpose:   Procedure para dar visible conforme ordem parametrizada    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {bcp/bc0118.i bc-etiqueta.cod-depos tt-bc-etiqueta.cod-depos}
   {bcp/bc0118.i bc-etiqueta.dt-validade tt-bc-etiqueta.dt-validade}
   {bcp/bc0118.i bc-etiqueta.nr-trans tt-bc-etiqueta.nr-trans}
   {bcp/bc0118.i bc-etiqueta.transpo tt-bc-etiqueta.cod-transp} 
   {bcp/bc0118.i bc-etiqueta.char-1 tt-bc-etiqueta.char-1}
   {bcp/bc0118.i bc-etiqueta.char-2 tt-bc-etiqueta.char-2}
   {bcp/bc0118.i bc-etiqueta.dec-1 tt-bc-etiqueta.dec-1}
   {bcp/bc0118.i bc-etiqueta.dec-2 tt-bc-etiqueta.dec-2}
   {bcp/bc0118.i bc-etiqueta.int-1 tt-bc-etiqueta.int-1}
   {bcp/bc0118.i bc-etiqueta.int-2 tt-bc-etiqueta.int-2}
   {bcp/bc0118.i bc-etiqueta.log-1 tt-bc-etiqueta.log-1}
   {bcp/bc0118.i bc-etiqueta.log-2 tt-bc-etiqueta.log-2}       
   {bcp/bc0118.i bc-etiqueta.data-1 tt-bc-etiqueta.data-1}
   {bcp/bc0118.i bc-etiqueta.data-2 tt-bc-etiqueta.data-2}
   {bcp/bc0118.i bc-etiqueta.check-sum tt-bc-etiqueta.check-sum}
   {bcp/bc0118.i bc-etiqueta.nr-seq-fat tt-bc-etiqueta.nr-seq-fat}
   {bcp/bc0118.i bc-etiqueta.nr-entrega tt-bc-etiqueta.nr-entrega}
   {bcp/bc0118.i bc-etiqueta.nr-romaneio tt-bc-etiqueta.nr-romaneio}

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-indice wWindow 
PROCEDURE pi-cria-indice :
/*------------------------------------------------------------------------------
  Purpose:     visa encontrar o indice a ser considera na busca
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND FIRST tt-estrutura
        WHERE tt-estrutura.faixa = NO
          AND tt-estrutura.atributo = "bc-etiqueta.nr-etiq" NO-ERROR.
   IF AVAIL tt-estrutura THEN 
      ASSIGN c-indice = "USE-INDEX ch-nr-etq".
   ELSE DO:
      FIND FIRST tt-estrutura
           WHERE tt-estrutura.faixa = NO
             AND tt-estrutura.atributo = "bc-etiqueta.it-codigo" NO-ERROR.
      IF AVAIL tt-estrutura THEN 
         ASSIGN c-indice = "USE-INDEX ch-it-codigo".
      ELSE DO:
         FIND FIRST tt-estrutura
              WHERE tt-estrutura.faixa = NO
                AND tt-estrutura.atributo = "bc-etiqueta.cod-controle-serie" NO-ERROR.
         IF AVAIL tt-estrutura THEN 
            ASSIGN c-indice = "USE-INDEX ch-cod-controle-serie".
         ELSE DO:
            FIND FIRST tt-estrutura
                 WHERE tt-estrutura.faixa = NO
                   AND tt-estrutura.atributo = "bc-etiqueta.lote" NO-ERROR.
            IF AVAIL tt-estrutura THEN 
               ASSIGN c-indice = "USE-INDEX ch-lote".
            ELSE DO:
               FIND FIRST tt-estrutura
                    WHERE tt-estrutura.faixa = NO
                      AND tt-estrutura.atributo = "bc-etiqueta.cod-depos" NO-ERROR.
               IF AVAIL tt-estrutura THEN 
                  ASSIGN c-indice = "USE-INDEX ch-deposito".
               ELSE DO:
                  FIND FIRST tt-estrutura
                       WHERE tt-estrutura.faixa = NO
                         AND tt-estrutura.atributo = "bc-etiqueta.cod-estado" NO-ERROR.
                  IF AVAIL tt-estrutura THEN 
                     ASSIGN c-indice = "USE-INDEX ch-cod-estado".
                  ELSE DO:
                     FIND FIRST tt-estrutura
                          WHERE tt-estrutura.faixa = NO
                            AND tt-estrutura.atributo = "bc-etiqueta.dt-recebimento" NO-ERROR.
                     IF AVAIL tt-estrutura THEN 
                        ASSIGN c-indice = "USE-INDEX ch-dt-recebimento".
                     ELSE DO:
                        FIND FIRST tt-estrutura
                             WHERE tt-estrutura.faixa = NO
                               AND tt-estrutura.atributo = "bc-etiqueta.localizacao" NO-ERROR.
                        IF AVAIL tt-estrutura THEN 
                           ASSIGN c-indice = "USE-INDEX ch-localizacao".
                        ELSE DO:
                           FIND FIRST tt-estrutura
                                WHERE tt-estrutura.faixa = NO
                                  AND tt-estrutura.atributo = "bc-etiqueta.serie" NO-ERROR.
                           IF AVAIL tt-estrutura THEN 
                              ASSIGN c-indice = "USE-INDEX ch-serie".
                           ELSE DO:
                              FIND FIRST tt-estrutura
                                   WHERE tt-estrutura.faixa = NO
                                     AND tt-estrutura.atributo = "bc-etiqueta.usuar-recebimento" NO-ERROR.
                              IF AVAIL tt-estrutura THEN 
                                 ASSIGN c-indice = "USE-INDEX ch-usuar-recebimento".
                           END.
                        END.
                     END.
                  END.
               END.
            END.
         END.
      END.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-condicao wWindow 
PROCEDURE pi-cria-condicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE c-dia     AS CHARACTER.
   DEFINE VARIABLE c-mes     AS CHARACTER.
   DEFINE VARIABLE c-ano     AS CHARACTER.
   DEFINE VARIABLE c-inicial AS CHARACTER.
   DEFINE VARIABLE c-final   AS CHARACTER.
   DEFINE VARIABLE i-cont    AS INTEGER.

   ASSIGN c-condicao = 'FOR EACH bc-etiqueta':U
          c-indice   = ''.

   IF NOT CAN-FIND(FIRST tt-estrutura) THEN 
      RETURN 'OK':U.

   ASSIGN c-condicao = '' .

   FOR EACH tt-estrutura:
      FIND FIRST tt-estrutura-comp
           WHERE tt-estrutura-comp.sequencia = tt-estrutura.sequencia NO-LOCK NO-ERROR.

      ASSIGN tt-estrutura.faixa = (IF tt-estrutura-comp.inicial = tt-estrutura.inicial AND tt-estrutura-comp.final = tt-estrutura.final THEN YES ELSE NO).
   END.

   FOR EACH  tt-estrutura
       WHERE tt-estrutura.faixa = NO:

      IF c-condicao <> '' THEN
         ASSIGN c-condicao = c-condicao + " AND ":U.
         
      IF tt-estrutura.tipo-dado = 'CHARACTER':U  THEN DO:
         IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
            ASSIGN c-condicao = c-condicao + '(':U + tt-estrutura.atributo + " =  ":U + "'":U +  tt-estrutura.inicial + "')":U.
         END.
         ELSE DO:
            ASSIGN c-condicao = c-condicao + '(':U + tt-estrutura.atributo + " >= ":U + "'":U  + tt-estrutura.inicial + "'":U + " AND ":U.
            ASSIGN c-condicao = c-condicao + tt-estrutura.atributo + " <= ":U + "'":U  + tt-estrutura.final + "')":U .
         END.
      END.

      IF tt-estrutura.tipo-dado = 'DATE':U  THEN DO:
         IF SESSION:DATE-FORMAT = 'DMY':U THEN DO:
            IF TRIM(tt-estrutura.inicial) = '?':U OR tt-estrutura.inicial = ? THEN ASSIGN c-inicial = ?. ELSE DO:
               ASSIGN c-dia = SUBSTRING(trim(tt-estrutura.inicial),1,2)
                      c-mes = SUBSTRING(trim(tt-estrutura.inicial),3,2)
                      c-ano = SUBSTRING(trim(tt-estrutura.inicial),5,4)
                      c-inicial = c-dia + '/':U + c-mes + '/':U + c-ano.
            END.
            IF TRIM(tt-estrutura.final) = '?':U OR tt-estrutura.final = ? THEN ASSIGN c-final = ?. ELSE DO:
               ASSIGN c-dia = SUBSTRING(trim(tt-estrutura.final),1,2)
                      c-mes = SUBSTRING(trim(tt-estrutura.final),3,2)
                      c-ano = SUBSTRING(trim(tt-estrutura.final),5,4)
                      c-final = c-dia + '/':U + c-mes + '/':U + c-ano.
             END.
         END.
         ELSE DO:
            IF tt-estrutura.inicial = ? THEN ASSIGN c-inicial = ?. ELSE DO:
               ASSIGN c-dia = SUBSTRING(trim(tt-estrutura.inicial),7,2)
                      c-mes = SUBSTRING(trim(tt-estrutura.inicial),5,2)
                      c-ano = SUBSTRING(trim(tt-estrutura.inicial),1,4)
                      c-inicial = c-ano + '/':U + c-mes + '/':U + c-dia.
            END.
            IF tt-estrutura.final = ? THEN ASSIGN c-final = ?. ELSE DO:
               ASSIGN c-dia = SUBSTRING(trim(tt-estrutura.final),7,2)
                      c-mes = SUBSTRING(trim(tt-estrutura.final),5,2)
                      c-ano = SUBSTRING(trim(tt-estrutura.final),1,4)
                      c-final = c-dia + '/':U + c-mes + '/':U + c-ano.
            END.
         END.

         IF (trim(tt-estrutura.inicial) <> '?':U AND tt-estrutura.inicial <> ? ) AND (trim(tt-estrutura.final) <> '?':U AND  tt-estrutura.final <> ?) THEN DO:
            IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
               ASSIGN c-condicao = c-condicao + '(':U +  tt-estrutura.atributo + " =  ":U + c-inicial + ')':U.
            END.
            ELSE DO:
               ASSIGN c-condicao = c-condicao + '(':U + tt-estrutura.atributo + " >= ":U + c-inicial  + " AND ":U
                      c-condicao = c-condicao +  tt-estrutura.atributo + " <=  ":U + c-final + ')':U.
            END.
         END.
         ELSE DO:
            IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
               ASSIGN c-condicao = c-condicao + '(':U +  tt-estrutura.atributo + " = ? )":U .
            END.
            ELSE DO:
               IF tt-estrutura.inicial = ? OR TRIM(tt-estrutura.inicial) = '?':U OR TRIM(tt-estrutura.inicial) = '' THEN DO:
                  ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " = ?  or ":U
                         c-condicao = c-condicao +  tt-estrutura.atributo + " = '' OR ":U
                         c-condicao = c-condicao +  tt-estrutura.atributo + " <=  ":U + c-final + ")":U.
               END.
               IF tt-estrutura.final = ? OR TRim(tt-estrutura.final) = '?':U OR TRIM(tt-estrutura.final) = '' THEN DO:
                  ASSIGN c-condicao = c-condicao +  "(":U + tt-estrutura.atributo + " >= ":U + c-inicial + " OR":U
                         c-condicao = c-condicao +  tt-estrutura.atributo + " =  ? OR ":U
                         c-condicao = c-condicao +  tt-estrutura.atributo + " = '' )":U.
               END.
            END.
         END.
      END.

      IF tt-estrutura.tipo-dado = 'INTEGER':U  THEN DO:
         IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " =  ":U +  tt-estrutura.inicial + ")":U.
         END.
         ELSE DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " >= ":U + tt-estrutura.inicial + " AND ":U
                   c-condicao = c-condicao + tt-estrutura.atributo + " <= ":U + tt-estrutura.final + ")":U.
         END.
      END.

      IF tt-estrutura.tipo-dado = 'DECIMAL':U  THEN DO:
         IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " =  DEC('":U +  tt-estrutura.inicial + "'))":U.
         END.
         ELSE DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " >= DEC('":U + tt-estrutura.inicial + "') AND ":U
                   c-condicao = c-condicao + tt-estrutura.atributo + " <= DEC('":U + tt-estrutura.final + "'))":U.
         END. 
      END.

      IF tt-estrutura.tipo-dado = "LOGICAL":U THEN DO:
         ASSIGN c-inicial = REPLACE(TRIM(tt-estrutura.inicial),'SIM':U, 'YES':U)
                c-final   = REPLACE(TRIM(tt-estrutura.final), 'SIM':U,'YES':U).
         ASSIGN c-inicial = REPLACE(c-inicial,'NAO':U, 'NO':U)
                c-final   = REPLACE(c-final, 'NAO':U,'NO':U).
         ASSIGN c-inicial = REPLACE(c-inicial,'NAO':U, 'NO':U)
                c-final   = REPLACE(c-final, 'NAO':U,'NO':U).
         IF TRIM(tt-estrutura.inicial) = TRIM(tt-estrutura.final) THEN DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " =  ":U +  c-inicial + ")":U.
         END.
         ELSE DO:
            ASSIGN c-condicao = c-condicao + "(":U + tt-estrutura.atributo + " >= ":U + c-inicial  + " AND ":U.
            ASSIGN c-condicao = c-condicao + tt-estrutura.atributo + " <= ":U + c-final + ")":U.
         END. 
      END.
   END.

   /* tratamento para WMS */
   FIND FIRST ttWm-box-bc NO-ERROR.
   IF AVAIL ttWm-box-bc THEN DO:   
      ASSIGN c-condicao = 'FOR EACH ttWm-box-bc , EACH bc-etiqueta WHERE bc-etiqueta.id-box = ttWm-box-bc.id-box ':U +
                           ' AND bc-etiqueta.cod-local = ttWm-box-bc.cod-local AND bc-etiqueta.cod-estabel = ttWm-box-bc.cod-estabel ':U +
                           ' AND (bc-etiqueta.cod-layout = ':U + STRING(INPUT FRAME fPage0 v-cod-layout) + 
                           ' AND bc-etiqueta.num-versao = ':U + STRING(INPUT FRAME fPage0 v-num-versao) + 
                           ' AND bc-etiqueta.log-datasul = ':U + STRING(v-log-aux,"YES/NO") + ' ) ':U
                           + (IF c-condicao <> "":U THEN " AND ":U ELSE " ":U)
                           + c-condicao.
   END.
   ELSE DO: 
      IF c-condicao <> "" THEN DO:
         RUN pi-cria-indice.

         ASSIGN c-condicao = 'FOR EACH bc-etiqueta ':U + c-indice + ' WHERE ':U  +
                              ' (bc-etiqueta.cod-layout = ':U + STRING(INPUT FRAME fPage0 v-cod-layout) + 
                              ' AND bc-etiqueta.num-versao = ':U + STRING(INPUT FRAME fPage0 v-num-versao) + 
                              ' AND bc-etiqueta.log-datasul = ':U + STRING(v-log-aux,"YES/NO") + ' ) AND ':U
                              +  c-condicao.
      END.
      ELSE DO:
         {utp/ut-liter.i "confirmar_a_leitura_de_TODAS_as_etiqueta_do_banco_de_dados" *}
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 26715, 
                           INPUT RETURN-VALUE). /*Deseja &1 ?*/
         IF RETURN-VALUE <> "YES" THEN
            RETURN NO-APPLY.
                      
         ASSIGN c-condicao = 'FOR EACH bc-etiqueta WHERE ':U +
                              ' (bc-etiqueta.cod-layout = ':U + STRING(INPUT FRAME fPage0 v-cod-layout) + 
                              ' AND bc-etiqueta.num-versao = ':U + string(INPUT FRAME fPage0 v-num-versao) + ' ) ':U.
      END.
   END.   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-det-bc-etiqueta wWindow 
PROCEDURE pi-det-bc-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR i-linha    AS INTEGER.
   DEF VAR l-modifica AS LOGICAL.

   ASSIGN l-modifica = NO.
   
   ems:
   DO ON ERROR UNDO ems, LEAVE ems
      ON ENDKEY UNDO ems, LEAVE ems
      ON QUIT UNDO ems, LEAVE ems
      ON STOP UNDO ems, LEAVE ems:    
      RUN bcp/bc0118c.w (INPUT l-modifica, /* indica que n∆o poder† alterar os atributos */
                         INPUT-OUTPUT TABLE tt-estrutura,
                         INPUT STRING(tt-bc-etiqueta.nr-etiq))  NO-ERROR.               
   END.
   IF  ERROR-STATUS:ERROR = YES THEN DO: 
      /* Ocorreram erros de execuá∆o de subprogramas */
      RUN utp/ut-msgs.p (INPUT "SHOW":U,
                         INPUT 27766,
                         INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).       
      RETURN 'NOK':U.
   END.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-det-bc-trans wWindow 
PROCEDURE pi-det-bc-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEF VAR dNrTrans LIKE bc-etiqueta.nr-trans NO-UNDO.

   IF INDEX(c-codigo-node, "|") > 0 THEN
      ASSIGN dNrTrans = DEC(TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U))).

   FIND FIRST bc-trans-etiq WHERE bc-trans-etiq.nr-trans = dNrTrans NO-LOCK NO-ERROR.

   ASSIGN vAcessType = 2. /* 1-Alteraá∆o, 2-Consulta   */

   RUN pi-trans-atualizada.    /* API gerada para transaá‰es atualizadas, pois ser∆o exibidos os dados */

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-det-bc-trans-erro wWindow 
PROCEDURE pi-det-bc-trans-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR l-apaga AS LOGICAL NO-UNDO.
   DEF VAR dNrTrans LIKE bc-etiqueta.nr-trans NO-UNDO.

   IF INDEX(c-codigo-node, "|") > 0 THEN
      ASSIGN dNrTrans = DEC(TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U))).

   IF CAN-FIND(FIRST bc-trans-erro 
               WHERE bc-trans-erro.nr-trans = dNrTrans) THEN DO:
      FIND FIRST bc-trans WHERE bc-trans.nr-trans = dNrTrans NO-LOCK NO-ERROR.
      RUN bcp/bc0203c.w (INPUT ROWID(bc-trans), INPUT-OUTPUT l-apaga).
   END.
   ELSE DO:
      /* Funcionalidade de Detalhe somente dispon°vel para Transaá‰es com erro */
      run utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27784,
                         INPUT " ").       
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mod-bc-etiqueta wWindow 
PROCEDURE pi-mod-bc-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR i-linha AS INTEGER.
   DEF VAR l-modifica AS LOGICAL.
   DEF VAR r-tt-bc-etiqueta AS RECID.

   ASSIGN l-modifica = YES.
    
   ems:
   DO ON ERROR UNDO ems, LEAVE ems
      ON ENDKEY UNDO ems, LEAVE ems
      ON QUIT UNDO ems, LEAVE ems
      ON STOP UNDO ems, LEAVE ems:    
      RUN bcp/bc0118b.w (INPUT l-modifica, /* indica que poder† alterar os atributos */
                         INPUT-OUTPUT TABLE tt-estrutura,
                         INPUT (STRING(tt-bc-etiqueta.nr-etiq)))  NO-ERROR.
   END.
   
   IF ERROR-STATUS:ERROR = YES THEN DO: 
      /* Ocorreram erros de execuá∆o de subprogramas */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27766,
                         INPUT ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES)).    
      RETURN 'NOK':U.
   END.
    
   FIND FIRST bc-etiqueta 
        WHERE bc-etiqueta.nr-etiq = tt-bc-etiqueta.nr-etiq NO-LOCK NO-ERROR.
   IF AVAILABLE bc-etiqueta THEN DO:
      BUFFER-COPY bc-etiqueta TO tt-bc-etiqueta NO-ERROR.
      DISPLAY tt-bc-etiqueta.nr-etiq 
              tt-bc-etiqueta.cod-estabel 
              tt-bc-etiqueta.it-codigo 
              tt-bc-etiqueta.progressivo 
              tt-bc-etiqueta.lote 
              tt-bc-etiqueta.referencia 
              tt-bc-etiqueta.localizacao 
              tt-bc-etiqueta.estado-des
              tt-bc-etiqueta.ativo      
              tt-bc-etiqueta.qt-item 
              tt-bc-etiqueta.usuar-producao 
              tt-bc-etiqueta.dt-producao 
              tt-bc-etiqueta.hr-producao 
              tt-bc-etiqueta.usuar-criacao 
              tt-bc-etiqueta.dt-criacao 
              tt-bc-etiqueta.hr-criacao 
              tt-bc-etiqueta.linha-prod 
              tt-bc-etiqueta.nr-ord-produ 
              tt-bc-etiqueta.cdd-embarq 
              tt-bc-etiqueta.nr-resumo 
              tt-bc-etiqueta.nr-seq-fat
              tt-bc-etiqueta.nr-entrega
              tt-bc-etiqueta.serie 
              tt-bc-etiqueta.nr-nota-fis 
              tt-bc-etiqueta.nome-abrev 
              tt-bc-etiqueta.usuar-expedicao 
              tt-bc-etiqueta.dt-expedicao 
              tt-bc-etiqueta.hr-expedicao 
              tt-bc-etiqueta.usuar-separacao
              tt-bc-etiqueta.dt-separacao 
              tt-bc-etiqueta.hr-separacao
              tt-bc-etiqueta.cod-transp
              tt-bc-etiqueta.caracter-livre-1
              tt-bc-etiqueta.caracter-livre-2
              tt-bc-etiqueta.caracter-livre-3
              tt-bc-etiqueta.caracter-livre-4
              tt-bc-etiqueta.caracter-livre-5
              tt-bc-etiqueta.cd-trans
              tt-bc-etiqueta.char-1 
              tt-bc-etiqueta.char-2 
              tt-bc-etiqueta.check-sum 
              tt-bc-etiqueta.cod-depos 
              tt-bc-etiqueta.cod-layout 
              tt-bc-etiqueta.data-1 
              tt-bc-etiqueta.data-2 
              tt-bc-etiqueta.data-livre-1 
              tt-bc-etiqueta.data-livre-2 
              tt-bc-etiqueta.data-livre-3 
              tt-bc-etiqueta.data-livre-4 
              tt-bc-etiqueta.data-livre-5 
              tt-bc-etiqueta.dec-1 
              tt-bc-etiqueta.dec-2 
              tt-bc-etiqueta.decimal-livre-1 
              tt-bc-etiqueta.decimal-livre-2 
              tt-bc-etiqueta.decimal-livre-3 
              tt-bc-etiqueta.decimal-livre-4 
              tt-bc-etiqueta.decimal-livre-5 
              tt-bc-etiqueta.detalhe 
              tt-bc-etiqueta.dt-validade 
              tt-bc-etiqueta.fm-codigo 
              tt-bc-etiqueta.ge-codigo 
              tt-bc-etiqueta.int-1 
              tt-bc-etiqueta.int-2 
              tt-bc-etiqueta.inteiro-livre-1 
              tt-bc-etiqueta.inteiro-livre-2 
              tt-bc-etiqueta.inteiro-livre-3
              tt-bc-etiqueta.inteiro-livre-4 
              tt-bc-etiqueta.inteiro-livre-5
              tt-bc-etiqueta.log-1 
              tt-bc-etiqueta.log-2 
              tt-bc-etiqueta.log-datasul 
              tt-bc-etiqueta.logico-livre-1 
              tt-bc-etiqueta.logico-livre-2 
              tt-bc-etiqueta.logico-livre-3 
              tt-bc-etiqueta.logico-livre-4 
              tt-bc-etiqueta.logico-livre-5 
              tt-bc-etiqueta.nat-operacao 
              tt-bc-etiqueta.nr-etiq-pai 
              tt-bc-etiqueta.nr-pedcli 
              tt-bc-etiqueta.nr-pedido 
              tt-bc-etiqueta.nr-trans 
              tt-bc-etiqueta.num-versao 
              tt-bc-etiqueta.qt-un-1 
              tt-bc-etiqueta.qt-un-2 
              tt-bc-etiqueta.qt-un-3 
              tt-bc-etiqueta.qt-un-4 
              tt-bc-etiqueta.qt-un-5 
              tt-bc-etiqueta.turno 
              tt-bc-etiqueta.un 
              tt-bc-etiqueta.un-1 
              tt-bc-etiqueta.un-2 
              tt-bc-etiqueta.un-3 
              tt-bc-etiqueta.un-4 
              tt-bc-etiqueta.un-5 
              tt-bc-etiqueta.nr-romaneio 
              tt-bc-etiqueta.dt-inventario
              tt-bc-etiqueta.nr-contagem            
              tt-bc-etiqueta.hr-inventario 
              tt-bc-etiqueta.usuar-inventario
              tt-bc-etiqueta.nr-operacao
              tt-bc-etiqueta.id-docto 
              tt-bc-etiqueta.cod-controle-serie 
              tt-bc-etiqueta.cod-embalagem 
              tt-bc-etiqueta.cod-montadora 
              tt-bc-etiqueta.cod-idioma 
              tt-bc-etiqueta.cod-agrupador1 
              tt-bc-etiqueta.cod-agrupador2 
              tt-bc-etiqueta.cod-agrupador3 
              tt-bc-etiqueta.cod-agrupador4 
              tt-bc-etiqueta.cod-agrupador5
              tt-bc-etiqueta.ep-codigo
              tt-bc-etiqueta.numero-ordem
              tt-bc-etiqueta.parcela
              tt-bc-etiqueta.num-pedido
              tt-bc-etiqueta.nro-docto
              tt-bc-etiqueta.serie-docto
              tt-bc-etiqueta.nat-operacao-docto
              tt-bc-etiqueta.cod-emitente-docto
              tt-bc-etiqueta.id-box
              tt-bc-etiqueta.cod-local
              tt-bc-etiqueta.sequencia-docto
              tt-bc-etiqueta.dt-recebimento
              tt-bc-etiqueta.hr-recebimento
              tt-bc-etiqueta.usuar-recebimento
              tt-bc-etiqueta.nr-volume
                  WITH browse br-tt-bc-etiqueta.
   END.
   ELSE DO:
      /* N∆o foi poss°vel atualizar Etiqueta */
      RUN utp/ut-msgs.p (INPUT "SHOW":U,
                         INPUT 27788,
                         INPUT "").    
   END.
   
   RETURN 'ok':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mod-bc-trans wWindow 
PROCEDURE pi-mod-bc-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR dNrTrans LIKE bc-etiqueta.nr-trans NO-UNDO.

   IF INDEX(c-codigo-node, "|") > 0 THEN
      ASSIGN dNrTrans = DEC(TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U))).

   FIND FIRST bc-trans-etiq 
        WHERE bc-trans-etiq.nr-trans = dNrTrans /*tt-bc-etiqueta.nr-trans*/ NO-LOCK NO-ERROR.

   ASSIGN vAcessType = 1. /* 1-Alteraá∆o, 2-Consulta   */

   RUN pi-trans-atualizada.    /* API gerada para transaá‰es atualizadas, pois ser∆o exibidos os dados mas n∆o podendo ser alterados   */

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-open-br-tt-bc-etiqueta wWindow 
PROCEDURE pi-open-br-tt-bc-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF v-log-datasul:CHECKED IN FRAME {&FRAME-NAME} = YES  THEN DO:
      ASSIGN v-log-aux = YES.
   END.
   ELSE DO:
      ASSIGN v-log-aux = NO.
   END.
   
   EMPTY TEMP-TABLE tt-bc-etiqueta.

   ASSIGN h-browse = br-tt-bc-etiqueta:HANDLE IN FRAME {&FRAME-NAME}.

   IF VALID-HANDLE(h-query) THEN DO:
      DELETE OBJECT h-query.
   END.

   CREATE QUERY h-query. 

   FIND FIRST ttWM-box-bc NO-ERROR.

   IF AVAIL ttWm-box-bc THEN DO:
      h-query:SET-BUFFERS(BUFFER ttWM-box-bc:HANDLE,BUFFER bc-etiqueta:HANDLE).
   END.
   ELSE DO: 
      h-query:SET-BUFFERS(BUFFER bc-etiqueta:HANDLE). 
   END.

   IF c-condicao <> "" THEN DO:
      h-query:QUERY-PREPARE(STRING(c-condicao)).
      h-query:QUERY-OPEN.
      h-query:GET-FIRST.
   END.

   DO WHILE AVAILABLE(bc-etiqueta):
      CREATE tt-bc-etiqueta.
      BUFFER-COPY bc-etiqueta TO tt-bc-etiqueta.

      ASSIGN iNrEtiqueta = iNrEtiqueta + 1.

      /* DESCRICAO DO ESTADO */
      FIND FIRST tt-estrutura 
           WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-estado':U NO-ERROR.
      IF AVAILABLE tt-estrutura THEN DO:
         FIND FIRST tt-bc-estado-etiq 
              WHERE tt-bc-estado-etiq.cod-estado = bc-etiqueta.cod-estado NO-LOCK NO-ERROR.
         IF AVAILABLE tt-bc-estado-etiq THEN
            ASSIGN tt-bc-etiqueta.estado-des = string(tt-bc-estado-etiq.cod-estado,"ZZ9":U) + "-":U + tt-bc-estado-etiq.descricao.
         ELSE
            ASSIGN tt-bc-etiqueta.estado-des = string(tt-bc-estado-etiq.cod-estado,"ZZ9":U).
      END.
      h-query:GET-NEXT.
   END.

   ASSIGN iNrEtiqueta:SCREEN-VALUE IN FRAME fpage0 = STRING(iNrEtiqueta).

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordena-coluna wWindow 
PROCEDURE pi-ordena-coluna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR v-num-cont AS INTEGER.
   DEFINE VAR wh-column  AS WIDGET-HANDLE.
   DEFINE VAR wh-browser AS WIDGET-HANDLE.
   DEFINE VAR c-atributo AS CHAR.

   ASSIGN wh-browser = BROWSE br-tt-bc-etiqueta:HANDLE.
   
   FOR EACH tt-estrutura BY tt-estrutura.sequencia:
      ASSIGN c-atributo = substring(tt-estrutura.atributo,INDEX(tt-estrutura.atributo,'.':U,1) + 1) .

      FIND FIRST tt-estrut-tab 
           WHERE tt-estrut-tab.atributo = c-atributo NO-ERROR.
      IF AVAILABLE tt-estrut-tab THEN DO:
         wh-browser:MOVE-COLUMN(tt-estrut-tab.posicao, tt-estrutura.sequencia) NO-ERROR.

         ASSIGN wh-column = wh-browser:FIRST-COLUMN.
         ASSIGN v-num-cont = 1.

         DO WHILE VALID-HANDLE(wh-column):
            IF wh-column:NAME = "estado-des":U THEN 
               FIND tt-estrut-tab WHERE tt-estrut-tab.atributo = "cod-estado" NO-ERROR.
            ELSE 
               FIND tt-estrut-tab WHERE tt-estrut-tab.atributo = wh-column:NAME NO-ERROR.

            IF AVAILABLE tt-estrut-tab THEN DO:
               ASSIGN tt-estrut-tab.posicao = v-num-cont.
               ASSIGN v-num-cont = v-num-cont + 1.
            END.
            wh-column = wh-column:NEXT-COLUMN.
         END.
      END.
   END.
   RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-br-bc-etiqueta wWindow 
PROCEDURE pi-popula-br-bc-etiqueta :
/*------------------------------------------------------------------------------
  Purpose: Criar os registros no browser conforme layout informado (TAMANHO)    
------------------------------------------------------------------------------*/
   RUN pi-popula-br-bc-etiqueta-visible-yes.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.ativo':U) THEN ASSIGN tt-bc-etiqueta.ativo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.referencia':U) THEN ASSIGN tt-bc-etiqueta.referencia:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.serie':U) THEN ASSIGN tt-bc-etiqueta.serie:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.turno':U) THEN ASSIGN tt-bc-etiqueta.turno:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un':U) THEN ASSIGN tt-bc-etiqueta.un:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.   
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un-1':U) THEN ASSIGN tt-bc-etiqueta.un-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un-2':U) THEN ASSIGN tt-bc-etiqueta.un-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un-3':U) THEN ASSIGN tt-bc-etiqueta.un-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un-4':U) THEN ASSIGN tt-bc-etiqueta.un-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.un-5':U) THEN ASSIGN tt-bc-etiqueta.un-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-criacao':U) THEN ASSIGN tt-bc-etiqueta.usuar-criacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-expedicao':U) THEN ASSIGN tt-bc-etiqueta.usuar-expedicao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-producao':U) THEN ASSIGN tt-bc-etiqueta.usuar-producao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-separacao':U) THEN ASSIGN tt-bc-etiqueta.usuar-separacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-item':U) THEN ASSIGN tt-bc-etiqueta.qt-item:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-un-1':U) THEN ASSIGN tt-bc-etiqueta.qt-un-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-un-2':U) THEN ASSIGN tt-bc-etiqueta.qt-un-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-un-3':U) THEN ASSIGN tt-bc-etiqueta.qt-un-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-un-4':U) THEN ASSIGN tt-bc-etiqueta.qt-un-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.qt-un-5':U) THEN ASSIGN tt-bc-etiqueta.qt-un-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-resumo':U) THEN ASSIGN tt-bc-etiqueta.nr-resumo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-trans':U) THEN ASSIGN tt-bc-etiqueta.nr-trans:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.num-versao':U) THEN ASSIGN tt-bc-etiqueta.num-versao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.progressivo':U) THEN ASSIGN tt-bc-etiqueta.progressivo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-pedcli':U) THEN ASSIGN tt-bc-etiqueta.nr-pedcli:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-pedido':U) THEN ASSIGN tt-bc-etiqueta.nr-pedido:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-nota-fis':U) THEN ASSIGN tt-bc-etiqueta.nr-nota-fis:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-ord-produ':U) THEN ASSIGN tt-bc-etiqueta.nr-ord-produ:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.                          
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.ativo':U) THEN ASSIGN tt-bc-etiqueta.ativo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-etiq-pai':U) THEN ASSIGN tt-bc-etiqueta.nr-etiq-pai:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.caracter-livre-1':U) THEN ASSIGN tt-bc-etiqueta.caracter-livre-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.caracter-livre-2':U) THEN ASSIGN tt-bc-etiqueta.caracter-livre-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.caracter-livre-3':U) THEN ASSIGN tt-bc-etiqueta.caracter-livre-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.caracter-livre-4':U) THEN ASSIGN tt-bc-etiqueta.caracter-livre-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.caracter-livre-5':U) THEN ASSIGN tt-bc-etiqueta.caracter-livre-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cd-trans':U) THEN ASSIGN tt-bc-etiqueta.cd-trans:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.char-1':U) THEN ASSIGN tt-bc-etiqueta.char-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.char-2':U) THEN ASSIGN tt-bc-etiqueta.char-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.check-sum':U) THEN ASSIGN tt-bc-etiqueta.check-sum:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-depos':U) THEN ASSIGN tt-bc-etiqueta.cod-depos:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-estabel':U) THEN ASSIGN tt-bc-etiqueta.cod-estabel:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-estado':U) THEN ASSIGN tt-bc-etiqueta.estado-des:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-layout':U) THEN ASSIGN tt-bc-etiqueta.cod-layout:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-1':U) THEN ASSIGN tt-bc-etiqueta.data-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-2':U) THEN ASSIGN tt-bc-etiqueta.data-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-livre-1':U) THEN ASSIGN tt-bc-etiqueta.data-livre-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-livre-2':U) THEN ASSIGN tt-bc-etiqueta.data-livre-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.                               
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-livre-3':U) THEN ASSIGN tt-bc-etiqueta.data-livre-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-livre-4':U) THEN ASSIGN tt-bc-etiqueta.data-livre-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.data-livre-5':U) THEN ASSIGN tt-bc-etiqueta.data-livre-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dec-1':U) THEN ASSIGN tt-bc-etiqueta.dec-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dec-2':U) THEN ASSIGN tt-bc-etiqueta.dec-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.decimal-livre-1':U) THEN ASSIGN tt-bc-etiqueta.decimal-livre-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.decimal-livre-2':U) THEN ASSIGN tt-bc-etiqueta.decimal-livre-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.decimal-livre-3':U) THEN ASSIGN tt-bc-etiqueta.decimal-livre-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.decimal-livre-4':U) THEN ASSIGN tt-bc-etiqueta.decimal-livre-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.decimal-livre-5':U) THEN ASSIGN tt-bc-etiqueta.decimal-livre-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.detalhe':U) THEN ASSIGN tt-bc-etiqueta.detalhe:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-criacao':U) THEN ASSIGN tt-bc-etiqueta.dt-criacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-expedicao':U) THEN ASSIGN tt-bc-etiqueta.dt-expedicao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-producao':U) THEN ASSIGN tt-bc-etiqueta.dt-producao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-separacao':U) THEN ASSIGN tt-bc-etiqueta.dt-separacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-validade':U) THEN ASSIGN tt-bc-etiqueta.dt-validade:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.fm-codigo':U) THEN ASSIGN tt-bc-etiqueta.fm-codigo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.ge-codigo':U) THEN ASSIGN tt-bc-etiqueta.ge-codigo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-criacao':U) THEN ASSIGN tt-bc-etiqueta.hr-criacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-expedicao':U) THEN ASSIGN tt-bc-etiqueta.hr-expedicao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-producao':U) THEN ASSIGN tt-bc-etiqueta.hr-producao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-separacao':U) THEN ASSIGN tt-bc-etiqueta.hr-separacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.int-1':U) THEN ASSIGN tt-bc-etiqueta.int-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.int-2':U) THEN ASSIGN tt-bc-etiqueta.int-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.inteiro-livre-1':U) THEN ASSIGN tt-bc-etiqueta.inteiro-livre-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.inteiro-livre-2':U) THEN ASSIGN tt-bc-etiqueta.inteiro-livre-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.inteiro-livre-3':U) THEN ASSIGN tt-bc-etiqueta.inteiro-livre-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.inteiro-livre-4':U) THEN ASSIGN tt-bc-etiqueta.inteiro-livre-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.inteiro-livre-5':U) THEN ASSIGN tt-bc-etiqueta.inteiro-livre-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.it-codigo':U) THEN ASSIGN tt-bc-etiqueta.it-codigo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.linha-prod':U) THEN ASSIGN tt-bc-etiqueta.linha-prod:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.localizacao':U) THEN ASSIGN tt-bc-etiqueta.localizacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.log-1':U) THEN ASSIGN tt-bc-etiqueta.log-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.log-2':U) THEN ASSIGN tt-bc-etiqueta.log-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.log-datasul':U) THEN ASSIGN tt-bc-etiqueta.log-datasul:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.logico-livre-1':U) THEN ASSIGN tt-bc-etiqueta.logico-livre-1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.logico-livre-2':U) THEN ASSIGN tt-bc-etiqueta.logico-livre-2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.logico-livre-3':U) THEN ASSIGN tt-bc-etiqueta.logico-livre-3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.logico-livre-4':U) THEN ASSIGN tt-bc-etiqueta.logico-livre-4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.logico-livre-5':U) THEN ASSIGN tt-bc-etiqueta.logico-livre-5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.lote':U) THEN ASSIGN tt-bc-etiqueta.lote:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nat-operacao':U) THEN ASSIGN tt-bc-etiqueta.nat-operacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nome-abrev':U) THEN ASSIGN tt-bc-etiqueta.nome-abrev:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cdd-embarq':U) THEN ASSIGN tt-bc-etiqueta.cdd-embarq:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-etiq':U) THEN ASSIGN tt-bc-etiqueta.nr-etiq:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.             
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-transp':U) THEN ASSIGN tt-bc-etiqueta.cod-transp:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.             
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-seq-fat':U) THEN ASSIGN tt-bc-etiqueta.nr-seq-fat:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.  
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-entrega':U) THEN ASSIGN tt-bc-etiqueta.nr-entrega:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.  
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-romaneio':U) THEN ASSIGN tt-bc-etiqueta.nr-romaneio:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.  
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-inventario':U) THEN ASSIGN tt-bc-etiqueta.dt-inventario:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.   
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-inventario':U) THEN ASSIGN tt-bc-etiqueta.hr-inventario:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-inventario':U) THEN ASSIGN tt-bc-etiqueta.usuar-inventario:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-contagem':U) THEN ASSIGN tt-bc-etiqueta.nr-contagem:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.  
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-operacao':U) THEN ASSIGN tt-bc-etiqueta.nr-operacao:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.id-docto':U) THEN ASSIGN tt-bc-etiqueta.id-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-controle-serie':U) THEN ASSIGN tt-bc-etiqueta.cod-controle-serie:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-embalagem':U) THEN ASSIGN tt-bc-etiqueta.cod-embalagem:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-montadora':U) THEN ASSIGN tt-bc-etiqueta.cod-montadora:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-idioma':U) THEN ASSIGN tt-bc-etiqueta.cod-idioma:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-agrupador1':U) THEN ASSIGN tt-bc-etiqueta.cod-agrupador1:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-agrupador2':U) THEN ASSIGN tt-bc-etiqueta.cod-agrupador2:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-agrupador3':U) THEN ASSIGN tt-bc-etiqueta.cod-agrupador3:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-agrupador4':U) THEN ASSIGN tt-bc-etiqueta.cod-agrupador4:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-agrupador5':U) THEN ASSIGN tt-bc-etiqueta.cod-agrupador5:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO. 
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.ep-codigo':U) THEN ASSIGN tt-bc-etiqueta.ep-codigo:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.numero-ordem':U) THEN ASSIGN tt-bc-etiqueta.numero-ordem:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.parcela':U) THEN ASSIGN tt-bc-etiqueta.parcela:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.num-pedido':U) THEN ASSIGN tt-bc-etiqueta.num-pedido:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nro-docto':U) THEN ASSIGN tt-bc-etiqueta.nro-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.serie-docto':U) THEN ASSIGN tt-bc-etiqueta.serie-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nat-operacao-docto':U) THEN ASSIGN tt-bc-etiqueta.nat-operacao-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-emitente-docto':U) THEN ASSIGN tt-bc-etiqueta.cod-emitente-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.id-box':U) THEN ASSIGN tt-bc-etiqueta.id-box:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.cod-local':U) THEN ASSIGN tt-bc-etiqueta.cod-local:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.sequencia-docto':U) THEN ASSIGN tt-bc-etiqueta.sequencia-docto:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.dt-recebimento':U) THEN ASSIGN tt-bc-etiqueta.dt-recebimento:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.hr-recebimento':U) THEN ASSIGN tt-bc-etiqueta.hr-recebimento:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.usuar-recebimento':U) THEN ASSIGN tt-bc-etiqueta.usuar-recebimento:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.
   IF NOT CAN-FIND(FIRST tt-estrutura WHERE tt-estrutura.atributo = 'bc-etiqueta.nr-volume':U) THEN ASSIGN tt-bc-etiqueta.nr-volume:VISIBLE IN BROWSE br-tt-bc-etiqueta = NO.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-br-bc-etiqueta-visible-yes wWindow 
PROCEDURE pi-popula-br-bc-etiqueta-visible-yes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH tt-estrutura BY tt-estrutura.sequencia:
      PUT tt-estrutura.atributo SKIP.
      RUN pi-br-bc-etiqueta-vis1.
      RUN pi-br-bc-etiqueta-vis2.
      RUN pi-br-bc-etiqueta-vis3.
      RUN pi-br-bc-etiqueta-vis4.
      RUN pi-br-bc-etiqueta-vis5. 
   END.

   EMPTY TEMP-TABLE tt-estrutura-aux.

   FOR EACH tt-estrutura:
      CREATE tt-estrutura-aux.
      ASSIGN tt-estrutura-aux.sequencia  = tt-estrutura.sequencia  
             tt-estrutura-aux.titulo     = tt-estrutura.titulo
             tt-estrutura-aux.titulo-col = tt-estrutura.titulo-col
             tt-estrutura-aux.atributo   = tt-estrutura.atributo
             tt-estrutura-aux.formato    = tt-estrutura.formato
             tt-estrutura-aux.tipo-dado  = tt-estrutura.tipo-dado
             tt-estrutura-aux.inicial    = tt-estrutura.inicial
             tt-estrutura-aux.final      = tt-estrutura.final
             tt-estrutura-aux.per-alt    = tt-estrutura.per-alt
             tt-estrutura-aux.faixa      = tt-estrutura.faixa.
      DELETE tt-estrutura.
   END.

   FOR EACH tt-estrut-tab:
      FIND FIRST tt-estrutura-aux 
           WHERE tt-estrutura-aux.atributo = tt-estrut-tab.atributo NO-ERROR.
      IF NOT AVAILABLE tt-estrutura-aux THEN DO:
         CREATE tt-estrutura.
         ASSIGN tt-estrutura.sequencia  = tt-estrut-tab.sequencia  
                tt-estrutura.titulo     = tt-estrut-tab.titulo
                tt-estrutura.titulo-col = tt-estrut-tab.titulo-col
                tt-estrutura.atributo   = tt-estrut-tab.atributo
                tt-estrutura.formato    = tt-estrut-tab.formato
                tt-estrutura.tipo-dado  = tt-estrut-tab.tipo-dado
                tt-estrutura.inicial    = tt-estrut-tab.inicial
                tt-estrutura.final      = tt-estrut-tab.final
                tt-estrutura.per-alt    = tt-estrut-tab.per-alt.
      END.
   END.
   
   FOR EACH tt-estrutura BY tt-estrutura.sequencia:
      RUN pi-br-bc-etiqueta-vis1.
      RUN pi-br-bc-etiqueta-vis2.
      RUN pi-br-bc-etiqueta-vis3.
      RUN pi-br-bc-etiqueta-vis4. 
      RUN pi-br-bc-etiqueta-vis5.     
   END.
   
   EMPTY TEMP-TABLE tt-estrutura.

   FOR EACH tt-estrutura-aux:
      CREATE tt-estrutura.
      BUFFER-COPY tt-estrutura-aux TO tt-estrutura.
      DELETE tt-estrutura-aux.
   END.
   
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-treeview-transacao wWindow 
PROCEDURE pi-popula-treeview-transacao :
/*------------------------------------------------------------------------------
  Purpose: Popula Tre  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER iNrEtiq AS INTEGER NO-UNDO.

   FIND FIRST tt-bc-etiqueta 
        WHERE tt-bc-etiqueta.nr-etiq = iNrEtiq NO-LOCK NO-ERROR.
   IF AVAILABLE tt-bc-etiqueta THEN DO:

      RUN pi-popula-tt-bc-tipo-trans.

      FOR EACH bc-trans-etiq 
         WHERE bc-trans-etiq.nr-etiq  = tt-bc-etiqueta.nr-etiq NO-LOCK:
         FIND FIRST tt-bc-tipo-trans 
              WHERE tt-bc-tipo-trans.cd-trans = bc-trans-etiq.cd-trans NO-ERROR.
         IF AVAILABLE tt-bc-tipo-trans THEN DO:
            FIND FIRST bc-trans
                 WHERE bc-trans.nr-trans = bc-trans-etiq.nr-trans
                   AND bc-trans.cd-trans = bc-trans-etiq.cd-trans NO-LOCK NO-ERROR. 
            IF AVAIL  bc-trans THEN DO:
               RUN pi-create-node IN THIS-PROCEDURE (INPUT "t":U + STRING(tt-bc-etiqueta.nr-etiq) + "|" + STRING(bc-trans-etiq.nr-trans),
                                                     INPUT "i":U + STRING(tt-bc-etiqueta.nr-etiq),
                                                     INPUT STRING(bc-trans-etiq.nr-trans) + ' - ':U  + TRIM(tt-bc-tipo-trans.descricao),
                                                     INPUT "image/treeview/tvpics/fold.bmp",
                                                     INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.

            END.
         END.
      END.
   END.
   
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-tt-bc-tipo-trans wWindow 
PROCEDURE pi-popula-tt-bc-tipo-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   EMPTY TEMP-TABLE tt-bc-tipo-trans.

   FOR EACH bc-tipo-trans NO-LOCK:
      CREATE tt-bc-tipo-trans.
      BUFFER-COPY bc-tipo-trans TO tt-bc-tipo-trans.
   END.
   
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-tt-estrut-tab wWindow 
PROCEDURE pi-popula-tt-estrut-tab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Variable */
   DEF VAR h-buffer        AS HANDLE        NO-UNDO.
   DEF VAR h-field         AS HANDLE        NO-UNDO.
   DEF VAR wh-query        AS WIDGET-HANDLE NO-UNDO.
   DEF VAR v-num-cont      AS INTEGER       NO-UNDO.
   DEF VAR wh-browser      AS WIDGET-HANDLE NO-UNDO.
   DEF VAR wh-column       AS WIDGET-HANDLE NO-UNDO.
   DEF VAR p-row-tabela    AS ROWID         NO-UNDO.
   
   /* Buffer */
   CREATE BUFFER h-buffer FOR TABLE 'bc-etiqueta':U. 

   /* Query */
   CREATE QUERY wh-query.

   EMPTY TEMP-TABLE tt-estrut-tab.

   /* obtená∆o dos atributos da tabela bt-etiq */
   FIND FIRST tt-estrut-tab NO-ERROR.
   IF NOT AVAILABLE tt-estrut-tab THEN
      CREATE tt-estrut-tab.

   wh-query:SET-BUFFERS(h-buffer).                     
   wh-query:query-prepare("FOR EACH bc-etiqueta NO-LOCK":U).
   wh-query:query-open().
   wh-query:get-first().
   ASSIGN H-BUFFER = wh-query:get-buffer-handle(1).
   REPEAT v-num-cont = 1 TO H-BUFFER:NUM-FIELDS:
      h-field = H-BUFFER:BUFFER-FIELD(v-num-cont).
      CREATE tt-estrut-tab.
      ASSIGN tt-estrut-tab.atributo   = h-field:NAME
             tt-estrut-tab.titulo     = h-field:LABEL
             tt-estrut-tab.titulo-col = h-field:COLUMN-LABEL.
   END.                  

   ASSIGN wh-browser = BROWSE br-tt-bc-etiqueta:HANDLE NO-ERROR.
   ASSIGN wh-column = wh-browser:FIRST-COLUMN NO-ERROR.
   ASSIGN v-num-cont = 1.
   DO WHILE VALID-HANDLE(wh-column):
      FIND tt-estrut-tab WHERE tt-estrut-tab.atributo = wh-column:NAME NO-ERROR.
      IF AVAILABLE tt-estrut-tab THEN
         ASSIGN tt-estrut-tab.posicao = v-num-cont.
      ASSIGN v-num-cont = v-num-cont + 1.
      wh-column = wh-column:NEXT-COLUMN.
   END.
   RUN pi-ordena-coluna.
   
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-tt-estrutura wWindow 
PROCEDURE pi-popula-tt-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE v-log-aux   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE c-tamanho   AS CHAR    NO-UNDO.
   DEFINE VARIABLE i-tamanho   AS INTEGER NO-UNDO.
   DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

   EMPTY TEMP-TABLE tt-estrutura.

   IF v-log-datasul:CHECKED IN FRAME {&FRAME-NAME} = YES  THEN DO:
      ASSIGN v-log-aux = YES.
   END.
   ELSE DO:
      ASSIGN v-log-aux = NO.
   END.

   FIND FIRST bc-layout 
        WHERE bc-layout.cod-layout  = INPUT FRAME {&FRAME-NAME} v-cod-layout 
          AND bc-layout.log-datasul = v-log-aux
          AND bc-layout.num-versao  = INPUT FRAME {&FRAME-NAME} v-num-versao NO-LOCK NO-ERROR.
   IF AVAILABLE bc-layout THEN DO:
      IF bc-layout.cod-tipo-layout <> 3 THEN DO:
         /* Tipo de Layout Inv†lido para este programa */
         RUN utp/ut-msgs.p (INPUT "SHOW":U,
                            INPUT 27782,
                            INPUT " ").        
         RETURN 'NOK':U.
      END.
   END.

   FIND FIRST bc-layout-registro 
        WHERE bc-layout-registro.cod-layout  = INPUT FRAME {&FRAME-NAME} v-cod-layout
          AND bc-layout-registro.log-datasul = v-log-aux
          AND bc-layout-registro.num-versao  = INPUT FRAME  {&FRAME-NAME} v-num-versao NO-LOCK NO-ERROR.
   IF NOT AVAILABLE bc-layout-registro THEN DO:
      /* N∆o foram localizados Segmentos para o Layout */
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 27787,
                         INPUT " ").      
      RETURN 'NOK':U.
   END.
   
   IF CAN-FIND(FIRST bc-layout-registro-item
               WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro) THEN DO:
      ASSIGN i-sequencia = 1.

      FOR EACH bc-layout-registro-item NO-LOCK 
         WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro:

         CREATE tt-estrutura.
         ASSIGN tt-estrutura.sequencia  = i-sequencia
                tt-estrutura.titulo     = bc-layout-registro-item.id-inicial
                tt-estrutura.titulo-col = bc-layout-registro-item.id-final
                tt-estrutura.atributo   = TRIM(bc-layout-registro-item.valor-item)
                tt-estrutura.formato    = TRIM(bc-layout-registro-item.formato)
                tt-estrutura.tipo-dado  = TRIM(bc-layout-registro-item.tipo-dado).

         IF TRIM(bc-layout-registro-item.tipo-dado) = "CHARACTER":U THEN 
            ASSIGN tt-estrutura.inicial = ''  
                   tt-estrutura.final = fill('Z':U,50).

         IF TRIM(bc-layout-registro-item.tipo-dado) = "INTEGER":U THEN DO:
            ASSIGN c-tamanho = REPLACE(tt-estrutura.formato,'.':U,'').
            ASSIGN c-tamanho = REPLACE(c-tamanho,',':U,'').
            ASSIGN i-tamanho = LENGTH(c-tamanho).
            ASSIGN tt-estrutura.inicial = '0':U 
                   tt-estrutura.final = FILL('9':U,i-tamanho).
         END.

         IF TRIM(bc-layout-registro-item.tipo-dado) = "DECIMAL":U THEN DO:

            ASSIGN c-tamanho = REPLACE(tt-estrutura.formato,'.':U,'':U).
            ASSIGN c-tamanho = REPLACE(c-tamanho,',':U,'').
            ASSIGN i-tamanho = LENGTH(c-tamanho).

            ASSIGN tt-estrutura.inicial = '0':U
                   tt-estrutura.final = FILL('9':U,i-tamanho).
         END.

         IF TRIM(bc-layout-registro-item.tipo-dado) = "DATE":U THEN 
            ASSIGN tt-estrutura.inicial = ? 
                   tt-estrutura.final =  '31129999':U.

         IF TRIM(bc-layout-registro-item.tipo-dado) = "LOGICAL":U THEN 
            ASSIGN tt-estrutura.inicial = 'Nao':U 
                   tt-estrutura.final = 'Sim':U.

         IF bc-layout-registro-item.num-decimais = 1 THEN DO: 
            ASSIGN tt-estrutura.per-alt = YES. 
         END.
         ELSE DO:
            ASSIGN tt-estrutura.per-alt = NO. 
         END.

         ASSIGN i-sequencia = i-sequencia + 1.

      END.

      EMPTY TEMP-TABLE tt-estrutura-comp.

      FOR EACH tt-estrutura:
         CREATE tt-estrutura-comp.
         BUFFER-COPY tt-estrutura TO tt-estrutura-comp.
      END.
   END.
   ELSE DO:
      /* N∆o foram localizados Campos para o Layout */
      RUN utp/ut-msgs.p (input "SHOW":U,
                         input 27788,
                         input " ").   .
      RETURN 'NOK':U.
   END.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trans-atualizada wWindow 
PROCEDURE pi-trans-atualizada :
/*------------------------------------------------------------------------------
  Purpose:     Logica obtida do BC0203
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR c-detalhe-con AS CHARACTER  NO-UNDO.
   DEF VAR c-raw-con     AS RAW        NO-UNDO.
   DEF VAR c-char-con    AS CHARACTER  NO-UNDO.
   DEF VAR r-raw-temp    AS RAW        NO-UNDO.
   DEF VAR i-nr-trans    AS INTEGER    NO-UNDO.
   DEF VAR i-erro        AS INTEGER    NO-UNDO.
   DEF VAR c-mensagem    AS CHARACTER  NO-UNDO.

   FIND FIRST bc-tipo-trans 
        WHERE bc-tipo-trans.cd-trans = bc-trans-etiq.cd-trans NO-LOCK NO-ERROR.

   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = bc-trans-etiq.nr-trans
          AND bc-trans.cd-trans = bc-trans-etiq.cd-trans NO-LOCK NO-ERROR.

   IF vAcessType = 1 THEN DO:
      IF AVAIL bc-trans AND bc-trans.estado <> 2 THEN
         ASSIGN vAcessType = 1. /* modifica */
      ELSE 
         ASSIGN vAcessType = 2. /* somente consulta */
   END.    

   IF AVAIL(bc-tipo-trans) THEN DO:
      IF bc-trans-etiq.Ind-tipo-trans = 1 AND bc-trans-etiq.ind-processo = 1 THEN DO:
         IF vAcessType = 1 THEN
            FIND CURRENT bc-trans NO-LOCK NO-ERROR.
         ELSE
            FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.

         &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN  
            ASSIGN c-detalhe-con = (IF vAcessType = 1 THEN bc-trans.detalhe ELSE "")
                   c-raw-con     = (IF vAcessType = 1 THEN bc-trans.conteudo-trans ELSE bc-trans-etiq.conteudo-trans)
                   i-nr-trans    = (IF vAcessType = 1 THEN bc-trans.nr-trans ELSE bc-trans-etiq.nr-trans).

            RUN bcp/bc0803.w PERSISTENT SET h-bc0803 (THIS-PROCEDURE,
                                                      THIS-PROCEDURE,
                                                      INPUT i-nr-trans,
                                                      INPUT c-detalhe-con,
                                                      INPUT c-raw-con,
                                                      INPUT l-apaga).                                                   
            RUN dispatch IN h-bc0803('initialize') NO-ERROR.
         &ELSE                   
            ASSIGN c-detalhe-con = (IF vAcessType = 1 THEN bc-trans.detalhe ELSE "")
                   c-char-con    = (IF vAcessType = 1 THEN bc-trans.conteudo-trans ELSE bc-trans-etiq.conteudo-trans)
                   i-nr-trans    = (IF vAcessType = 1 THEN bc-trans.nr-trans ELSE bc-trans-etiq.nr-trans).

            RUN btb/btb928za.p (INPUT c-char-con,
                                OUTPUT r-raw-temp) NO-ERROR.

            IF ((ERROR-STATUS:ERROR OR ERROR-STATUS:GET-NUMBER(1) <> 0) AND ERROR-STATUS:GET-NUMBER(1) <> 138) OR RETURN-VALUE = "NOK" THEN DO:
               ASSIGN i-erro     = ERROR-STATUS:GET-NUMBER(1)
                      c-mensagem = ERROR-STATUS:GET-MESSAGE(1).

               IF RETURN-VALUE = "NOK" THEN DO:
                  {utp/ut-liter.i "Permiss∆o do Diret¢rio Tempor†rio" * L}
                  ASSIGN c-mensagem = TRIM(RETURN-VALUE)
                         i-erro     = OS-ERROR.
               END.

               {utp/ut-liter.i "de Convers∆o do Campo RAW" * L}
               RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                  INPUT 15837,
                                  INPUT TRIM(RETURN-VALUE) + " - (" + c-mensagem + " : " + STRING(i-erro) + ")").

               RETURN NO-APPLY.
            END.

            RUN bcp/bc0803.w PERSISTENT SET h-bc0803 (THIS-PROCEDURE,
                                                      THIS-PROCEDURE,
                                                      INPUT i-nr-trans,
                                                      INPUT c-detalhe-con,
                                                      INPUT c-raw-con,
                                                      INPUT l-apaga).                                                   
            RUN dispatch IN h-bc0803('initialize') NO-ERROR.
         &ENDIF
      END.

      IF bc-tipo-trans.prog-altera <> "" AND (bc-trans-etiq.Ind-tipo-trans = 2 OR bc-trans-etiq.ind-processo = 2) THEN DO:

         IF vAcessType = 1 THEN
            FIND CURRENT bc-trans NO-LOCK NO-ERROR.
         ELSE
            FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.

         ASSIGN l-apaga = NO.

         &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
            ASSIGN c-detalhe-con = (IF vAcessType = 1 THEN bc-trans.detalhe ELSE "")
                   c-raw-con     = (IF vAcessType = 1 THEN bc-trans.conteudo-trans ELSE bc-trans-etiq.conteudo-trans)
                   i-nr-trans    = (IF vAcessType = 1 THEN bc-trans.nr-trans ELSE bc-trans-etiq.nr-trans).

            RUN VALUE(bc-tipo-trans.prog-altera) PERSISTENT SET h-program (THIS-PROCEDURE,
                                                                           THIS-PROCEDURE,
                                                                           INPUT i-nr-trans,
                                                                           INPUT c-detalhe-con,
                                                                           INPUT c-raw-con,
                                                                           INPUT l-apaga).
            IF VALID-HANDLE(h-program) THEN                                                               
               RUN dispatch IN h-program('initialize') NO-ERROR.
         &ELSE
            ASSIGN c-detalhe-con = (IF vAcessType = 1 THEN bc-trans.detalhe ELSE "")
                   c-char-con    = (IF vAcessType = 1 THEN bc-trans.conteudo-trans ELSE bc-trans-etiq.conteudo-trans)
                   i-nr-trans    = (IF vAcessType = 1 THEN bc-trans.nr-trans ELSE bc-trans-etiq.nr-trans).

            RUN btb/btb928za.p (INPUT c-char-con,
                                OUTPUT r-raw-temp) NO-ERROR.

            IF ((ERROR-STATUS:ERROR OR ERROR-STATUS:GET-NUMBER(1) <> 0) AND ERROR-STATUS:GET-NUMBER(1) <> 138) OR RETURN-VALUE = "NOK" THEN DO:
               ASSIGN i-erro     = ERROR-STATUS:GET-NUMBER(1)
                      c-mensagem = ERROR-STATUS:GET-MESSAGE(1).

               IF RETURN-VALUE = "NOK" THEN DO:
                  {utp/ut-liter.i "Permiss∆o do Diret¢rio Tempor†rio" * L}
                  ASSIGN c-mensagem = TRIM(RETURN-VALUE)
                         i-erro     = OS-ERROR.
               END.

               {utp/ut-liter.i "de Convers∆o do Campo RAW" * L}
               RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                  INPUT 15837,
                                  INPUT TRIM(RETURN-VALUE) + " - (" + c-mensagem + " : " + STRING(i-erro) + ")").

               RETURN NO-APPLY.
            END.

            RUN VALUE(bc-tipo-trans.prog-altera) PERSISTENT SET h-program (THIS-PROCEDURE,
                                                                           THIS-PROCEDURE,
                                                                           INPUT i-nr-trans,
                                                                           INPUT c-detalhe-con,
                                                                           INPUT c-raw-con,
                                                                           INPUT l-apaga).
            IF VALID-HANDLE(h-program) THEN
               RUN dispatch IN h-program('initialize') NO-ERROR.
         &ENDIF
      END.      
   END.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ClickTreeView wMaintenance 
PROCEDURE pi-ClickTreeView :

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow wMaintenance 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloquei Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow wMaintenance 
PROCEDURE piLibWindow  :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:    Roda a Conex∆o e Desconex∆o dos coletores selecionados 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN destroyObject IN h-4gltreeview.
      DELETE PROCEDURE h-4gltreeview NO-ERROR.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados B-table-Win 
PROCEDURE pi-atualiza-dados:
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAM pNumTransacao AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM pDesDetalhe   AS CHAR      NO-UNDO.
   DEFINE INPUT PARAM pRawContent   AS RAW       NO-UNDO.
   DEFINE INPUT PARAM pLogApaga     AS LOGICAL   NO-UNDO.   
   DEFINE VARIABLE    r-raw-temp    AS RAW       NO-UNDO.
   
   ASSIGN r-raw-temp = pRawContent.

   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = pNumTransacao EXCLUSIVE-LOCK NO-ERROR.

   &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
      IF vAcessType = 1 THEN
         ASSIGN bc-trans.conteudo-trans = pRawContent.
   &ELSE
      IF vAcessType = 1 THEN
         ASSIGN bc-trans.conteudo-trans = STRING(r-raw-temp).
   &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaHandle B-table-Win 
PROCEDURE eliminaHandle :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   IF VALID-HANDLE(h-program) THEN
       DELETE PROCEDURE h-program.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
