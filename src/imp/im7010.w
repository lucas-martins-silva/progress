&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-imp-embal NO-UNDO LIKE decla-import-embal
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-imp-embal-aux NO-UNDO LIKE decla-import-embal
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-embarq NO-UNDO LIKE decla-import-embarq
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-embarq-aux NO-UNDO LIKE decla-import-embarq
       FIELD r-Rowid      AS ROWID
       FIELD nat-operacao LIKE natur-oper.nat-operacao.
DEFINE TEMP-TABLE tt-decla-import-ord NO-UNDO LIKE decla-import-ord
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-ord-aux NO-UNDO LIKE decla-import-ord
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-despes-decla-import-aux NO-UNDO LIKE despes-decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-due-siscomex NO-UNDO LIKE due-siscomex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-embarque-imp-aux NO-UNDO LIKE embarque-imp
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-histor-decla-import NO-UNDO LIKE histor-decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-histor-decla-import-aux NO-UNDO LIKE histor-decla-import
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7010 2.00.00.003 } /*** "010003" 10/07/2026 16:52:58 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7010 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7010
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp brSource brTarget btAddAllTarget btAddTarget btAlterar btDelAllTarget btDelTarget btSelecao
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
/*DEFINIÄ«O DA tt-param-exec*/
{cxbo/bocx00488.i1}

{cdp/cd9098.i} /* Vari†veis do z01di040 */
{utp/ut-glob.i}
{cdp/cdcfgmat.i}/* Include Pre-processadores */
{include/boerrtab.i} /*tt-bo-erro*/
{cxbo/bocx225.i tt-ordens-embarque} 
{cxbo/bocx225e.i tt-ordens-desemb}


DEF TEMP-TABLE tt-param NO-UNDO
    FIELD usuario           LIKE param-re.usuario 
    FIELD destino           AS INT  
    FIELD data-exec         AS DATE 
    FIELD hora-exec         AS INT 
    FIELD arquivo           AS CHAR. 
DEFINE TEMP-TABLE tt-erro-relat NO-UNDO
    FIELD msg-erro AS CHARACTER FORMAT "X(300)".
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bocx220na     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx220       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383a      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx407       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx115       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx230       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx225       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx225e      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx250       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin274       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx384       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx406       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx390       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0420a       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7010b       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx386       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin245na     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin667na     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00487     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00488     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRowsReturned   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-duimp-informada  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-retorno        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-primeiro       AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE l-gera-historico AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE l-exclui-relacionamentos AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE l-cotacao                AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE hCaller         AS HANDLE      NO-UNDO.
DEFINE VARIABLE d-dt-efetiva    AS DATE        NO-UNDO.
DEFINE VARIABLE l-add-all       AS LOGICAL INITIAL NO   NO-UNDO.
DEFINE VARIABLE l-remove-all    AS LOGICAL INITIAL NO   NO-UNDO.
DEFINE VARIABLE l-elimina-despesas AS LOGICAL INITIAL YES    NO-UNDO.
DEFINE VARIABLE i-cod-itiner      LIKE historico-embarque.cod-itiner       NO-UNDO.
DEFINE VARIABLE i-cod-itiner-aux  LIKE historico-embarque.cod-itiner       NO-UNDO.
DEFINE VARIABLE d-dat-prev-origin    LIKE historico-embarque.dt-previsao      NO-UNDO.
DEFINE VARIABLE c-nome-abrev      LIKE emitente.nome-abrev                 NO-UNDO.
DEFINE VARIABLE i-pto-desembarque LIKE itinerario.pto-desembarque NO-UNDO.
DEFINE VARIABLE l-zoom            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iETime            AS INTEGER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl        AS HANDLE  NO-UNDO.
DEFINE VARIABLE wh-pesquisa      AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-contador       AS INTEGER NO-UNDO.
DEFINE VARIABLE l-valida-viatransp AS   LOGICAL                  NO-UNDO. 
DEFINE VARIABLE l-via-transp       AS   LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-primer-embarq    AS   LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-gera-despesa     AS   LOGICAL         INIT YES         NO-UNDO.

DEF VAR c-return-ordens-emb  AS CHAR NO-UNDO.
DEF VAR c-return-ordem-compr AS CHAR NO-UNDO.
DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
DEF VAR i-cod-emitente       LIKE ordem-compra.cod-emitente NO-UNDO.
DEF VAR de-cdd-siscomex-dts  LIKE duimp-siscomex.cdd-siscomex-dts NO-UNDO.
DEF VAR l-encontrou          AS LOGICAL NO-UNDO.
DEF VAR l-todos-iguais       AS LOGICAL NO-UNDO.
DEF VAR c-nat-operacao-aux   LIKE natur-oper.nat-operacao NO-UNDO.
DEF VAR i-despachante-param  LIKE embarque-imp.cod-despachante NO-UNDO.

DEF VAR l-primeiro-embarque-aux AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR c-natur-oper-aux        LIKE decla-import.cod-natur-oper NO-UNDO.
DEF VAR d-dat-duimp-aux         LIKE duimp-siscomex.dtz-reg-siscomex NO-UNDO.
DEF VAR l-atualiza-notaMae AS LOGICAL NO-UNDO.
/* variaveis da procedure retornaDados-tela da bocx404*/
def var vpeso-bruto-i1  AS DECIMAL FORMAT '>>>>,>>9.9999999999'  no-undo. 
def var vpeso-liquido-i1 AS DECIMAL FORMAT '>>>>,>>9.9999999999' no-undo.  
def var vcubagem           like ordens-embarque.val-cub-tot no-undo.
def var vtrib-ii-i1        as integer no-undo.
def var vtrib-ipi-i1       as integer no-undo.
def var vtrib-icms-i1      as integer no-undo.
def var vtrib-pis-i1       as integer no-undo.
def var vtrib-cofins-i1    as integer no-undo.
def var vde-aliq-ii-i1     as decimal format ">>>9.9999" no-undo.
def var vde-aliq-ipi-i1    as decimal format ">>>9.99" no-undo.
def var vde-aliq-icms-i1   as decimal format ">>>9.99" no-undo.
def var vde-aliq-pis-i1    as decimal format ">>9.9999" no-undo.
def var vde-aliq-cofins-i1 as decimal format ">>9.9999" no-undo.

def var vsuspensoII     AS LOGICAL NO-UNDO.
def var vsuspensoIPI    AS LOGICAL NO-UNDO.
def var vsuspensoICMS   AS LOGICAL NO-UNDO.
def var vsuspensoPIS    AS LOGICAL NO-UNDO.
def var vsuspensoCOFINS AS LOGICAL NO-UNDO.
DEF VAR l-init-im0400   AS LOGICAL NO-UNDO.
DEF VAR l-deltarget     AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embarque-imp tt-decla-import-embarq-aux

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-embarque-imp.embarque fnFornecedor(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ c-nome-abrev tt-embarque-imp.cod-estabel tt-embarque-imp.cod-incoterm fnItinerario(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ i-cod-itiner fnDataNacionaliz(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ d-dat-prev-origin   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define QUERY-STRING-brSource FOR EACH tt-embarque-imp NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-imp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-embarque-imp
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-embarque-imp


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-decla-import-embarq-aux.cod-estab tt-decla-import-embarq-aux.cod-embarq i-num-duimp-dts tt-decla-import-embarq-aux.nat-operacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget tt-decla-import-embarq-aux.nat-operacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-brTarget tt-decla-import-embarq-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brTarget tt-decla-import-embarq-aux
&Scoped-define SELF-NAME brTarget
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-decla-import-embarq-aux NO-LOCK
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-embarq-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTarget tt-decla-import-embarq-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-decla-import-embarq-aux


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp i-num-duimp-dts c-cod-duimp-siscomex i-num-versao c-cod-estab ~
d-dat-duimp brSource brTarget btAddAllTarget btAddTarget btDelTarget ~
btDelAllTarget btSelecao btAlterar btSaveNat 
&Scoped-Define DISPLAYED-OBJECTS i-num-duimp-dts c-cod-duimp-siscomex ~
i-num-versao c-cod-estab d-dat-duimp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataNacionaliz wWindow 
FUNCTION fnDataNacionaliz RETURNS DATE
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFornecedor wWindow 
FUNCTION fnFornecedor RETURNS CHARACTER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItinerario wWindow 
FUNCTION fnItinerario RETURNS INTEGER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image/add-all":U
     IMAGE-INSENSITIVE FILE "image/ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btAlterar 
     IMAGE-UP FILE "image/im-mod.bmp":U
     LABEL "Alterar" 
     SIZE 4 BY 1.25 TOOLTIP "Altera Natureza de Operaá∆o".

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image/del-all":U
     IMAGE-INSENSITIVE FILE "image/ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveNat 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "Confirmar" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Natureza de Operaá∆o".

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-carga.bmp":U
     LABEL "Seleá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Seleá∆o Embarques".

DEFINE VARIABLE c-cod-duimp-siscomex AS CHARACTER FORMAT "x(15)" 
     LABEL "DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-duimp AS DATE FORMAT "99/99/9999" 
     LABEL "Data Registro Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-duimp-dts AS INTEGER FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-versao AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Vers∆o DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-embarque-imp SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-decla-import-embarq-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wWindow _FREEFORM
  QUERY brSource NO-LOCK DISPLAY
      tt-embarque-imp.embarque FORMAT "X(16)":U WIDTH 17
      fnFornecedor(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ c-nome-abrev FORMAT "X(20)"
      tt-embarque-imp.cod-estabel FORMAT "X(3)":U
      tt-embarque-imp.cod-incoterm FORMAT "X(3)":U
      fnItinerario(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ i-cod-itiner FORMAT ">>,>>9"
      fnDataNacionaliz(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque) @ d-dat-prev-origin FORMAT "99/99/9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 38.72 BY 10
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wWindow _FREEFORM
  QUERY brTarget NO-LOCK DISPLAY
      tt-decla-import-embarq-aux.cod-estab FORMAT "x(5)":U
      tt-decla-import-embarq-aux.cod-embarq FORMAT "x(16)":U WIDTH 17
      i-num-duimp-dts FORMAT ">>>>>>>>>>>9":U COLUMN-LABEL "Num DUIMP Intern"
      tt-decla-import-embarq-aux.nat-operacao FORMAT "X(06)":U
      ENABLE
          tt-decla-import-embarq-aux.nat-operacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 10
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     i-num-duimp-dts AT ROW 2.75 COL 16.86 COLON-ALIGNED HELP
          "N£mero Declaraá∆o de Importaá∆o EMS"
     c-cod-duimp-siscomex AT ROW 2.75 COL 47.72 COLON-ALIGNED HELP
          "C¢digo DI Siscomex"
     i-num-versao AT ROW 2.75 COL 79.57 COLON-ALIGNED WIDGET-ID 2
     c-cod-estab AT ROW 3.75 COL 16.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento."
     d-dat-duimp AT ROW 3.75 COL 47.72 COLON-ALIGNED HELP
          "Data da DI"
     brSource AT ROW 5.08 COL 2.14
     brTarget AT ROW 5.08 COL 50
     btAddAllTarget AT ROW 7.08 COL 41.86
     btAddTarget AT ROW 8.08 COL 41.86
     btDelTarget AT ROW 9.08 COL 41.86
     btDelAllTarget AT ROW 10.08 COL 41.86
     btSelecao AT ROW 15.25 COL 37
     btAlterar AT ROW 15.25 COL 50.14
     btSaveNat AT ROW 15.25 COL 54.14
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-imp-embal T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-imp-embal-aux T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-embarq T "?" NO-UNDO mgcex decla-import-embarq
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-embarq-aux T "?" NO-UNDO mgcex decla-import-embarq
      ADDITIONAL-FIELDS:
          FIELD r-Rowid      AS ROWID
          FIELD nat-operacao LIKE natur-oper.nat-operacao
      END-FIELDS.
      TABLE: tt-decla-import-ord T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-ord-aux T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-despes-decla-import T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-despes-decla-import-aux T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-due-siscomex T "?" NO-UNDO mgcex due-siscomex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-embarque-imp-aux T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-histor-decla-import T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-histor-decla-import-aux T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.63
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.86
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSource d-dat-duimp fpage0 */
/* BROWSE-TAB brTarget brSource fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-imp NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-embarq-aux NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTarget */
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
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
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


&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wWindow
ON CHOOSE OF btAddAllTarget IN FRAME fpage0
DO:
    IF l-duimp-informada THEN DO:
        RUN pi-empty-row-errors.
        DO TRANS:
            RUN pi-addAll.
            IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES}

                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorType    <> "INTERNAL":U
                             AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                    UNDO,LEAVE.                            

            END.   
        END.
    
        ASSIGN l-add-all = NO.
        RUN mostra-di-manual.
    
        RUN pi-busca-historicos-di IN hCaller.
        RUN pi-busca-despesas-di   IN hCaller.
    END.
    RUN pi-sugere-despachante.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wWindow
ON CHOOSE OF btAddTarget IN FRAME fpage0
DO:
    IF l-duimp-informada THEN DO:
        RUN pi-empty-row-errors. 
            DO TRANS:
                RUN pi-add.
                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal=YES}
                    IF  CAN-FIND(FIRST RowErrors 
                                 WHERE RowErrors.ErrorType    <> "INTERNAL":U
                                 AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                        UNDO,LEAVE.                            

                END.   
            END.   
        RUN pi-busca-historicos-di IN hCaller.
        RUN pi-busca-despesas-di   IN hCaller.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wWindow
ON CHOOSE OF btAlterar IN FRAME fpage0 /* Alterar */
DO:
  RUN pi-altera-natureza-operacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wWindow
ON CHOOSE OF btDelAllTarget IN FRAME fpage0
DO:
    assign l-deltarget = yes.
    
    IF l-duimp-informada THEN DO:
        RUN pi-empty-row-errors.
        DO TRANS:
            RUN pi-removeAll.
            IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES}
                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorType    <> "INTERNAL":U
                             AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                    UNDO,LEAVE.                            
            END.   
        END.  
    END.
    ELSE DO:
        RUN pi-removeAllAutomatico.
    END.
    RUN pi-sugere-despachante.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wWindow
ON CHOOSE OF btDelTarget IN FRAME fpage0
DO:
    assign l-deltarget = yes.
    
    IF l-duimp-informada THEN DO:
        RUN pi-empty-row-errors.
        DO TRANS:
            RUN pi-remove.
            IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES}
                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorType    <> "INTERNAL":U
                             AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                    UNDO,LEAVE.                                    
            END.   
        END.  
    END.
    ELSE DO:
        RUN pi-removeAutomatico.
    END.       
    RUN pi-sugere-despachante.
    
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


&Scoped-define SELF-NAME btSaveNat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveNat wWindow
ON CHOOSE OF btSaveNat IN FRAME fpage0 /* Confirmar */
DO:
  RUN pi-altera-nat-ordens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wWindow
ON CHOOSE OF btSelecao IN FRAME fpage0 /* Seleá∆o */
DO:
  RUN pi-selecao-embarque-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}
on  'F5', mouse-select-dblclick of tt-decla-import-embarq-aux.nat-operacao in browse brTarget do:

    if  num-results("brTarget") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {method/zoomfields.i 
                 &ProgramZoom="inzoom/z04in245.w"
                 &FieldZoom1="nat-operacao"
                 &FieldScreen1="tt-decla-import-embarq-aux.nat-operacao"
                 &browse1="brTarget"}
                 WAIT-FOR CLOSE OF hProgramZoom.
        assign l-zoom = no.
    end.
end.

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx220na) THEN DO:
    DELETE PROCEDURE h-bocx220na.
    ASSIGN h-bocx220na = ?.
END.

IF VALID-HANDLE(h-bocx220) THEN DO:
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.
END.

IF VALID-HANDLE(h-bocx383) THEN DO:
    DELETE PROCEDURE h-bocx383.
    ASSIGN h-bocx383 = ?.
END.

IF VALID-HANDLE(h-bocx383a) THEN DO:
    DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.
END.

IF VALID-HANDLE(h-bocx407) THEN DO:
    DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
END.

IF VALID-HANDLE(h-bocx115) THEN DO:
    DELETE PROCEDURE h-bocx115.
    ASSIGN h-bocx115 = ?.
END.

IF VALID-HANDLE(h-bocx230) THEN DO:
    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx230 = ?.
END.

IF VALID-HANDLE(h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

IF VALID-HANDLE(h-bocx225e) THEN DO:
    DELETE PROCEDURE h-bocx225e.
    ASSIGN h-bocx225e = ?.
END.

IF VALID-HANDLE(h-bocx250) THEN DO:
    DELETE PROCEDURE h-bocx250.
    ASSIGN h-bocx250 = ?.
END.

IF VALID-HANDLE(h-boin274) THEN DO:
    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
END.

IF VALID-HANDLE(h-boad098) THEN DO:
    DELETE PROCEDURE h-boad098.
    ASSIGN h-boad098 = ?.
END.

IF VALID-HANDLE(h-bocx384) THEN DO:
    DELETE PROCEDURE h-bocx384.
    ASSIGN h-bocx384 = ?.
END.

IF VALID-HANDLE(h-bocx404) THEN DO:
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
END.

IF VALID-HANDLE(h-bocx406) THEN DO:
    DELETE PROCEDURE h-bocx406.
    ASSIGN h-bocx406 = ?.
END.

IF VALID-HANDLE(h-bocx390) THEN DO:
    DELETE PROCEDURE h-bocx390.
    ASSIGN h-bocx390 = ?.
END.

IF VALID-HANDLE(h-im0420a) THEN DO:
    DELETE PROCEDURE h-im0420a.
    ASSIGN h-im0420a = ?.
END.

IF VALID-HANDLE(h-im7010b) THEN DO:
    DELETE PROCEDURE h-im7010b.
    ASSIGN h-im7010b = ?.
END.

IF VALID-HANDLE(h-bocx386) THEN DO:
    DELETE PROCEDURE h-bocx386.
    ASSIGN h-bocx386 = ?.
END.

IF VALID-HANDLE(h-boin245na) THEN DO:
    DELETE PROCEDURE h-boin245na.
    ASSIGN h-boin245na = ?.
END.

IF VALID-HANDLE(h-boin667na) THEN DO:
    DELETE PROCEDURE h-boin667na.
    ASSIGN h-boin667na = ?.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST tt-decla-import: END.

    ASSIGN tt-decla-import-embarq-aux.nat-operacao          :READ-ONLY IN BROWSE brTarget = YES.

    IF l-duimp-informada THEN DO:
        ASSIGN l-init-im0400 = YES.
        RUN mostra-di-manual.
    END.

    IF NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
    /* verifica se h† documento gerado no recebimento, 
     se sim, bloqueia a vinculaá∆o/desvinculaá∆o dos embarques */
    RUN piDoctoRecebimento IN h-bocx383a(INPUT INPUT FRAME fPage0 c-cod-duimp-siscomex, OUTPUT l-encontrou).
    
    IF l-encontrou THEN DO:
        DISABLE btAddAllTarget 
                btAddTarget 
                btDelAllTarget 
                btDelTarget 
                btSelecao
            WITH FRAME fPage0.
    END.

    RUN retorna-spp-via-transp-dif (OUTPUT l-valida-viatransp).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN initializeDBOs IN THIS-PROCEDURE.              
              

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executa-parametros-busca wWindow 
PROCEDURE executa-parametros-busca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-param-exec.

    DEFINE VARIABLE c-lb-acomp AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-embarque-imp.

/* Browser com embarques a vincular */
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Embarques"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    IF c-lb-acomp = "":U THEN DO:
       {utp/ut-liter.i "Buscando_Embarques_a_Vincular"}
       ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    END.
    RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp).
    ASSIGN c-lb-acomp = "":U.

    RUN piBuscaOrdensVincular IN h-bocx00488 (INPUT  TABLE tt-param-exec,
                                              INPUT  i-num-duimp-dts,
                                              OUTPUT TABLE tt-embarque-imp).

    {utp/ut-liter.i "Carregando_Embarques_a_Vincular"}
    RUN pi-acompanhar in h-acomp (input RETURN-VALUE).
    {&OPEN-QUERY-brSource}
    RUN pi-finalizar in h-acomp.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesasDUIMP wWindow 
PROCEDURE geraDespesasDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms  LIKE decla-import.num-di-ems  NO-UNDO.
DEF INPUT PARAM pCodEstab  LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT PARAM pCodEmbarq LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

RUN pi-gera-despesas IN h-bocx407 (INPUT pCodEmbarq,
                                   INPUT pCodEstab,
                                   INPUT pNumDiEms,
                                   INPUT pCddSiscomexDts).

RUN getRowErrors     IN h-bocx407 (OUTPUT TABLE RowErrors APPEND).

IF  CAN-FIND(FIRST RowErrors 
             WHERE RowErrors.ErrorType <> "INTERNAL":U
             AND   RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraHistoricoDUIMP wWindow 
PROCEDURE geraHistoricoDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms  LIKE decla-import.num-di-ems  NO-UNDO.
DEF INPUT PARAM pCodEstab  LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT PARAM pCodEmbarq LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

DEFINE VARIABLE i-seq                AS INTEGER  INIT 0                    NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz LIKE historico-embarque.cod-pto-contr NO-UNDO.
DEFINE VARIABLE i-cdn-pto-chegad     LIKE historico-embarque.cod-pto-contr NO-UNDO.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT pCodEmbarq,
                                               INPUT pCodEstab,
                                               OUTPUT i-seq-nacionaliz).

RUN retorna-ponto-nacionalizacao IN h-bocx407 (INPUT pCodEmbarq,
                                               INPUT pCodEstab,
                                               OUTPUT i-cdn-pto-nacionaliz).

RUN retorna-ponto-chegada IN h-bocx407 (INPUT pCodEmbarq,
                                        INPUT pCodEstab,
                                        OUTPUT i-cdn-pto-chegad).

EMPTY TEMP-TABLE tt-histor-decla-import.


IF i-seq-nacionaliz <> 0 THEN DO:

    FOR EACH historico-embarque
        WHERE historico-embarque.embarque    = pCodEmbarq 
        AND   historico-embarque.cod-estabel = pCodEstab    
        AND   historico-embarque.sequencia   >= i-seq-nacionaliz NO-LOCK:

        IF NOT CAN-FIND(FIRST tt-histor-decla-import
                        WHERE tt-histor-decla-import.num-di-ems      = pNumDiEms
                        AND   tt-histor-decla-import.cdn-pto-control = historico-embarque.cod-pto-contr
                        AND   tt-histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

            FIND LAST tt-histor-decla-import NO-LOCK NO-ERROR.
            IF AVAIL tt-histor-decla-import THEN
                ASSIGN i-seq = tt-histor-decla-import.num-seq + 10.
            ELSE
                ASSIGN i-seq = 10.

            IF NOT CAN-FIND(FIRST tt-histor-decla-import
                            WHERE tt-histor-decla-import.num-di-ems = pNumDiEms
                            AND   tt-histor-decla-import.num-seq    = i-seq
                            AND   tt-histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

                CREATE tt-histor-decla-import.
                ASSIGN tt-histor-decla-import.num-di-ems               = pNumDiEms
                       tt-histor-decla-import.num-seq                  = i-seq
                       tt-histor-decla-import.cdn-pto-control          = historico-embarque.cod-pto-contr
                       tt-histor-decla-import.cdd-siscomex-dts         = pCddSiscomexDts
                       tt-histor-decla-import.descricao                = historico-embarque.descricao
                       tt-histor-decla-import.cdn-pto-nacionaliz       = i-cdn-pto-nacionaliz     
                       tt-histor-decla-import.nr-dias                  = historico-embarque.nr-dias  
                       tt-histor-decla-import.cdn-pto-chegad           = i-cdn-pto-chegad
                       tt-histor-decla-import.cod-meio-transp          = historico-embarque.id-meio-transp
                       tt-histor-decla-import.dat-efetiva              = ?
                       tt-histor-decla-import.dat-prev-origin          = historico-embarque.dt-previsao
                       tt-histor-decla-import.dat-ult-prev             = historico-embarque.dt-ult-previsao 
                       tt-histor-decla-import.dsl-obs                  = historico-embarque.observacao
                       OVERLAY(tt-histor-decla-import.cod-livre-1,6,2) = SUBSTRING(historico-embarque.char-1,1,2).
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-histor-decla-import) THEN DO:

        FOR EACH tt-histor-decla-import:
            EMPTY TEMP-TABLE tt-histor-decla-import-aux.
            CREATE tt-histor-decla-import-aux.
            BUFFER-COPY tt-histor-decla-import TO tt-histor-decla-import-aux.

            IF  TIME > iETime THEN DO:
                ASSIGN iETime = TIME + 10.
                IF  VALID-HANDLE(h-acomp) THEN 
                    IF NOT l-duimp-informada THEN
                        /* Inicio -- Projeto Internacional */
                        DO:
                        {utp/ut-liter.i "Gerando_Hist¢rico_DI_-_Pto_Controle" *}
                        RUN pi-acompanhar in h-acomp (RETURN-VALUE + ": " + STRING(tt-histor-decla-import.cdn-pto-control)).
                        END.         
            END.

            RUN emptyRowObject  IN h-bocx384.
            RUN openQueryStatic IN h-bocx384 (INPUT "Main":U).
            RUN emptyRowErrors  IN h-bocx384.
            RUN goToKey         IN h-bocx384 (INPUT tt-histor-decla-import-aux.num-di-ems,
                                              INPUT tt-histor-decla-import-aux.num-seq,
                                              INPUT tt-histor-decla-import-aux.cdd-siscomex-dts).
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN setRecord       IN h-bocx384 (INPUT TABLE tt-histor-decla-import-aux).
                RUN createRecord    IN h-bocx384.
                RUN getRowErrors    IN h-bocx384 (OUTPUT TABLE RowErrors APPEND).
                IF RETURN-VALUE = "NOK" THEN DO:                
                    RETURN "NOK":U.
                END.
            END.       
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tt-param-exec wWindow 
PROCEDURE get-tt-param-exec :
/*------------------------------------------------------------------------------
Purpose:  
Notes:  
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-param-exec.
  
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wWindow 
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    ASSIGN pDBOHandle = h-bocx383.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstabelecimentoDi wWindow 
PROCEDURE getEstabelecimentoDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pEstab LIKE decla-import.cod-estab NO-UNDO.

ASSIGN pEstab = c-cod-estab.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
        RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
        RUN openQueryStatic IN h-bocx00487(INPUT 'Main':U) NO-ERROR.
    END.
    
    IF NOT VALID-HANDLE(h-bocx220na) THEN DO:
        RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.
        RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-bocx383) THEN DO:
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
        RUN setConstraintByDiEMSSeq IN h-bocx383 (INPUT i-num-duimp-dts,
                                                  INPUT 99,
                                                  INPUT de-cdd-siscomex-dts).
        RUN openQueryStatic IN h-bocx383 (INPUT 'Main':U) NO-ERROR.
        RUN goToKey         IN h-bocx383 (INPUT i-num-duimp-dts,
                                          INPUT 99,
                                          INPUT de-cdd-siscomex-dts).
        RUN getRecord       IN h-bocx383 (OUTPUT TABLE tt-decla-import).                                      
    END.

    IF NOT VALID-HANDLE(h-bocx384) THEN DO:
        RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.
        RUN openQueryStatic IN h-bocx384 (INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-bocx407) THEN DO:
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
        RUN openQueryStatic IN h-bocx407 (INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE( h-bocx404) THEN DO:
        RUN cxbo/bocx404.p PERSISTENT SET  h-bocx404.
        RUN openQueryStatic IN  h-bocx404 (INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115.

    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p persistent set h-bocx230.

    IF NOT VALID-HANDLE(h-bocx225) THEN
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    IF NOT VALID-HANDLE(h-bocx225e) THEN
        RUN cxbo/bocx225e.p PERSISTENT SET h-bocx225e.

    IF NOT VALID-HANDLE(h-bocx250) THEN DO:
        RUN cxbo/bocx250na.p PERSISTENT SET h-bocx250.
        RUN openQueryStatic IN h-bocx250 (INPUT "Main":U).
    END.

    IF NOT VALID-HANDLE(h-boad098) THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET h-boad098.
        RUN openQueryStatic IN h-boad098 (INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-boin274) THEN
        RUN inbo/boin274.p PERSISTENT SET h-boin274.

    IF NOT VALID-HANDLE(h-bocx406) THEN
        RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.

    IF NOT VALID-HANDLE(h-bocx390) THEN
        RUN cxbo/bocx390.p PERSISTEN SET h-bocx390.

    IF NOT VALID-HANDLE(h-bocx00488) THEN 
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
        
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostra-di-manual wWindow 
PROCEDURE mostra-di-manual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR FIRST tt-decla-import: END.

IF VALID-HANDLE (h-bocx00487) THEN DO:
    RUN goToKey IN h-bocx00487 (INPUT i-num-duimp-dts).
    IF RETURN-VALUE = "OK" THEN DO:
            
        RUN getIntField      IN h-bocx00487 (INPUT 'num-versao-duimp',   OUTPUT i-num-versao).
        RUN getCharField     IN h-bocx00487 (INPUT 'cod-estabel',        OUTPUT c-cod-estab).
        RUN getCharField     IN h-bocx00487 (INPUT 'cod-duimp-siscomex', OUTPUT c-cod-duimp-siscomex).
        RUN getDateTimeField IN h-bocx00487 (INPUT 'dtz-reg-siscomex',   OUTPUT d-dat-duimp-aux).
                                                
        ASSIGN d-dat-duimp = DATE(string(DATE(d-dat-duimp-aux),"99/99/9999":U)).
        
        DISP c-cod-duimp-siscomex c-cod-estab d-dat-duimp i-num-duimp-dts i-num-versao WITH FRAME fPage0.
    
    END.                            
END.   

/*BROWSER SOURCE*/
IF NOT CAN-FIND(FIRST tt-param-exec) THEN
    RUN pi-cria-tt-param-exec.

IF l-init-im0400 or l-deltarget THEN
    ASSIGN l-init-im0400 = NO
           l-deltarget   = NO.
ELSE
    RUN executa-parametros-busca (INPUT TABLE tt-param-exec).

EMPTY TEMP-TABLE tt-decla-import-embarq.
EMPTY TEMP-TABLE tt-decla-import-embarq-aux.

/*BROWSER TARGET*/

RUN setConstraintByDI IN h-bocx407 (INPUT tt-decla-import.num-di-ems,
                                    INPUT tt-decla-import.cdd-siscomex-dts).
RUN openQueryStatic   IN h-bocx407 (INPUT "ByDI":U).
RUN getBatchRecords   IN h-bocx407 (INPUT ?,
                                    INPUT NO,
                                    INPUT 0,
                                    OUTPUT iRowsReturned,
                                    OUTPUT TABLE tt-decla-import-embarq).

FOR EACH tt-decla-import-embarq:
    CREATE tt-decla-import-embarq-aux.
    BUFFER-COPY tt-decla-import-embarq TO tt-decla-import-embarq-aux.
    
    RUN retornaNatOperacaoEmbarque IN h-bocx407 (INPUT  tt-decla-import-embarq.num-di-ems,
                                                 INPUT  tt-decla-import-embarq.cod-estab,
                                                 INPUT  tt-decla-import-embarq.cod-embarq,
                                                 INPUT  tt-decla-import-embarq.cdd-siscomex-dts,
                                                 OUTPUT tt-decla-import-embarq-aux.nat-operacao).
    IF RETURN-VALUE = "NOK":U THEN DO:
        DISABLE btAlterar
                btSaveNat WITH FRAME fPage0.
    END.
END.

{&OPEN-QUERY-brTarget}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add wWindow 
PROCEDURE pi-add :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR l-desp-geradas AS LOG NO-UNDO.
IF NOT AVAIL tt-decla-import THEN 
    FOR FIRST tt-decla-import: END.
    
RUN emptyRowErrors IN h-bocx384.
RUN emptyRowErrors IN h-bocx407.
RUN emptyRowErrors IN h-bocx220na.

DO  i-cont = 1 TO brSource:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brSource:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:        
        EMPTY TEMP-TABLE tt-decla-import-embarq.
        IF NOT CAN-FIND(FIRST tt-decla-import-embarq-aux
                        WHERE tt-decla-import-embarq-aux.cod-embarq = tt-embarque-imp.embarque) THEN DO: //manuela
            CREATE tt-decla-import-embarq.
            ASSIGN tt-decla-import-embarq.cod-embarq = tt-embarque-imp.embarque
                   tt-decla-import-embarq.cod-estab  = tt-embarque-imp.cod-estabel
                   tt-decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
                   tt-decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.

            ASSIGN l-gera-despesa = YES.
            RUN pi-verifica-pontos-controle (OUTPUT l-desp-geradas).
            IF RETURN-VALUE = "OK" THEN DO: 
               ASSIGN l-gera-despesa = l-desp-geradas.
               RUN pi-verifica-via-transp. 
               IF RETURN-VALUE = "OK" THEN DO: 
                    RUN pi-vincula-embarque-di.
                    IF RETURN-VALUE = "NOK":U THEN
                        UNDO, LEAVE.
               END.
               ELSE 
                  UNDO, LEAVE.
            END.
            ELSE DO:
                DELETE tt-embarque-imp.
                IF l-duimp-informada THEN DO:
                    RUN pi-busca-historicos-di IN hCaller.
                    RUN pi-busca-despesas-di   IN hCaller.
                END.
            END. 
        END.
    END.
END.
RUN mostra-di-manual.
RUN pi-sugere-despachante.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-addAll wWindow 
PROCEDURE pi-addAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR l-desp-geradas AS LOG NO-UNDO.

ASSIGN l-add-all = YES.
RUN emptyRowErrors IN h-bocx384.
RUN emptyRowErrors IN h-bocx407.
RUN emptyRowErrors IN h-bocx220na.

FOR EACH tt-embarque-imp:
    EMPTY TEMP-TABLE tt-decla-import-embarq.
    IF NOT CAN-FIND(FIRST tt-decla-import-embarq-aux
                    WHERE tt-decla-import-embarq-aux.cod-embarq = tt-embarque-imp.embarque) THEN DO:
        CREATE tt-decla-import-embarq.
        ASSIGN tt-decla-import-embarq.cod-embarq = tt-embarque-imp.embarque
               tt-decla-import-embarq.cod-estab  = tt-embarque-imp.cod-estabel
               tt-decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
               tt-decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.
        RUN pi-verifica-pontos-controle (OUTPUT l-desp-geradas).   
        IF RETURN-VALUE = "NOK" THEN
            LEAVE.
    END.                              
END.                 

IF l-gera-historico THEN DO:    
    FOR EACH tt-embarque-imp:
        EMPTY TEMP-TABLE tt-decla-import-embarq.
        IF NOT CAN-FIND(FIRST tt-decla-import-embarq
                        WHERE tt-decla-import-embarq.cod-embarq = tt-embarque-imp.embarque) THEN DO:
            CREATE tt-decla-import-embarq.
            ASSIGN tt-decla-import-embarq.cod-embarq = tt-embarque-imp.embarque
                   tt-decla-import-embarq.cod-estab  = tt-embarque-imp.cod-estabel
                   tt-decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
                   tt-decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.
            IF NOT CAN-FIND(FIRST RowErrors 
                            WHERE RowErrors.ErrorType <> "INTERNAL":U
                            AND   RowErrors.errorSubType = "ERROR") THEN DO:
                                ASSIGN l-gera-despesa = YES.
                RUN pi-vincula-embarque-di.
                IF RETURN-VALUE = "OK":U THEN DO:
                    DELETE tt-embarque-imp.
                    IF l-duimp-informada THEN DO:
                        RUN pi-busca-historicos-di IN hCaller.
                        RUN pi-busca-despesas-di   IN hCaller.
                    END.
                END.
                ELSE
                    RETURN "NOK":U.
            END.
        END.                              
    END.  
END.
ELSE DO: 
    FOR EACH RowErrors:
        DELETE RowErrors.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-nat-ordens wWindow 
PROCEDURE pi-altera-nat-ordens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE RowErrors.
RUN emptyRowErrors IN h-bocx407.

ASSIGN l-todos-iguais = YES
       l-atualiza-notaMae = NO.

FOR FIRST tt-decla-import-embarq-aux:
    ASSIGN c-nat-operacao-aux = tt-decla-import-embarq-aux.nat-operacao.
END.

FOR EACH tt-decla-import-embarq-aux:
    RUN pi-altera-nat-ordens IN h-bocx407 (INPUT tt-decla-import-embarq-aux.num-di-ems,
                                           INPUT tt-decla-import-embarq-aux.cod-estab,
                                           INPUT tt-decla-import-embarq-aux.cod-embarq,
                                           INPUT tt-decla-import-embarq-aux.nat-operacao,
                                           INPUT tt-decla-import-embarq-aux.cdd-siscomex-dts).

    IF tt-decla-import-embarq-aux.nat-operacao <> c-nat-operacao-aux THEN 
        ASSIGN l-todos-iguais = NO.

END.

RUN getRowErrors IN h-bocx407 (OUTPUT TABLE RowErrors).
IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:                   
   /*--- Inicializa janela de mensagens de erro ---*/
   {method/showmessage.i1}
   {method/showmessage.i2}  
   RETURN "NOK".
END.
ELSE DO:
    /* Se todas as naturezas forem iguais, a DI mostra a mesma em tela, caso contr†rio ser† branco. */
    IF NOT l-todos-iguais THEN 
        ASSIGN c-nat-operacao-aux = "".

    RUN pi-altera-nat-DI IN h-bocx407 (INPUT INPUT FRAME fPage0 i-num-duimp-dts,
                                       INPUT c-nat-operacao-aux,
                                       INPUT INPUT FRAME fPage0 i-num-duimp-dts).

    ASSIGN tt-decla-import-embarq-aux.nat-operacao          :READ-ONLY IN BROWSE brTarget = YES.

    IF l-duimp-informada THEN DO:
        DISABLE btSaveNat WITH FRAME fPage0.
        ENABLE btAlterar WITH FRAME fPage0.
    END.
END.


/* alteraá∆o da natureza de operaá∆o para a nota filha */
/* verifica se tem nota gerada para esta DI */
IF  VALID-HANDLE(h-bocx383a) THEN
        RUN piDoctoRecebimento IN h-bocx383a(INPUT c-cod-duimp-siscomex, OUTPUT l-encontrou).

IF l-encontrou THEN DO: /* encontrou alguma nota gerada */
    FOR EACH tt-decla-import-embarq-aux:

        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.declaracao-import      = c-cod-duimp-siscomex
            AND   docum-est.cod-estabel            = tt-decla-import-embarq-aux.cod-estab
            AND   TRIM(SUBSTRING(docum-est.char-1,1,20)) = tt-decla-import-embarq-aux.cod-embarq:

            /* docum-est.idi-nf-simples-remes = 1 -> nota m∆e
               docum-est.idi-nf-simples-remes = 2 -> nota filha */
            IF docum-est.idi-nf-simples-remes = 1 THEN DO:
    
                FOR EACH decla-import-ord EXCLUSIVE-LOCK
                    WHERE decla-import-ord.cod-estab  = tt-decla-import-embarq-aux.cod-estab
                    AND   decla-import-ord.num-di-ems = tt-decla-import-embarq-aux.num-di-ems
                    AND   decla-import-ord.cod-embarq = tt-decla-import-embarq-aux.cod-embarq
                    AND   decla-import-ord.cdd-siscomex-dts = tt-decla-import-embarq-aux.cdd-siscomex-dts:
    
                    RUN retornaDados-tela IN h-bocx404 (INPUT tt-decla-import-embarq-aux.cod-estab,
                                                        INPUT tt-decla-import-embarq-aux.cod-embarq,
                                                        INPUT decla-import-ord.num-ordem,
                                                        INPUT decla-import-ord.num-parcela,
                                                        INPUT tt-decla-import-embarq-aux.nat-operacao,
                                                        OUTPUT vtrib-ii-i1,
                                                        OUTPUT vtrib-ipi-i1,
                                                        OUTPUT vtrib-icms-i1,
                                                        OUTPUT vtrib-pis-i1,
                                                        OUTPUT vtrib-cofins-i1,
                                                        OUTPUT vde-aliq-ii-i1,
                                                        OUTPUT vde-aliq-ipi-i1,
                                                        OUTPUT vde-aliq-icms-i1,
                                                        OUTPUT vde-aliq-pis-i1,
                                                        OUTPUT vde-aliq-cofins-i1,
                                                        OUTPUT vsuspensoII,
                                                        OUTPUT vsuspensoIPI,
                                                        OUTPUT vsuspensoICMS,
                                                        OUTPUT vsuspensoPIS,
                                                        OUTPUT vsuspensoCOFINS).
                    /*atualizar AS ordens e suas adicoes */
                    ASSIGN decla-import-ord.idi-tributac-impto-import = vtrib-ii-i1
                           decla-import-ord.idi-tributac-ipi          = vtrib-ipi-i1
                           decla-import-ord.idi-tributac-pis          = vtrib-pis-i1
                           decla-import-ord.idi-tributac-cofins       = vtrib-cofins-i1
                           decla-import-ord.idi-tributac-icms         = vtrib-icms-i1
                           decla-import-ord.val-aliq-ii               = if decla-import-ord.idi-tributac-impto-import = 2 then 0 else decla-import-ord.val-aliq-ii
                           decla-import-ord.val-aliq-ipi              = if decla-import-ord.idi-tributac-ipi          = 2 then 0 else decla-import-ord.val-aliq-ipi
                           decla-import-ord.val-aliq-icms             = if decla-import-ord.idi-tributac-icms         = 2 then 0 else decla-import-ord.val-aliq-icms
                           decla-import-ord.val-aliq-pis              = if decla-import-ord.idi-tributac-pis          = 2 then 0 else decla-import-ord.val-aliq-pis
                           decla-import-ord.val-aliq-cofins           = if decla-import-ord.idi-tributac-cofins       = 2 then 0 else decla-import-ord.val-aliq-cofins.
                    
                    /* busca a adicao relaciona a ordem corrente*/
                    FOR FIRST decla-import-adic EXCLUSIVE-LOCK
                        WHERE decla-import-adic.num-di-ems = decla-import-ord.num-di-ems
                        AND   decla-import-adic.num-adic   = decla-import-ord.num-adic
                        AND   decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                        ASSIGN decla-import-adic.idi-tributac-impto-import = vtrib-ii-i1    
                               decla-import-adic.idi-tributac-ipi          = vtrib-ipi-i1   
                               decla-import-adic.idi-tributac-pis          = vtrib-pis-i1   
                               decla-import-adic.idi-tributac-cofins       = vtrib-cofins-i1
                               decla-import-adic.idi-tributac-icms         = vtrib-icms-i1
                               decla-import-adic.val-aliq-ii               = if decla-import-adic.idi-tributac-impto-import = 2 then 0 else decla-import-adic.val-aliq-ii    
                               decla-import-adic.val-aliq-ipi              = if decla-import-adic.idi-tributac-ipi          = 2 then 0 else decla-import-adic.val-aliq-ipi   
                               decla-import-adic.val-aliq-icms             = if decla-import-adic.idi-tributac-icms         = 2 then 0 else decla-import-adic.val-aliq-icms  
                               decla-import-adic.val-aliq-pis              = if decla-import-adic.idi-tributac-pis          = 2 then 0 else decla-import-adic.val-aliq-pis   
                               decla-import-adic.val-aliq-cofins           = if decla-import-adic.idi-tributac-cofins       = 2 then 0 else decla-import-adic.val-aliq-cofins. 
    
                    END.
    
                    ASSIGN l-atualiza-notaMae = YES.
                END. /* FOR EACH decla-import-ord EXCLUSIVE-LOCK */
            END. /* IF docum-est.idi-nf-simples-remes = 1 THEN DO: */
        END. /* for first docum-est */

        IF l-atualiza-notaMae = NO THEN DO:
         IF CAN-FIND(FIRST docum-est 
                     WHERE docum-est.declaracao-import            = c-cod-duimp-siscomex
                       AND docum-est.cod-estabel                  = tt-decla-import-embarq-aux.cod-estab
                       AND TRIM(SUBSTRING(docum-est.char-1,1,20)) = tt-decla-import-embarq-aux.cod-embarq
                       AND docum-est.idi-nf-simples-remes         = 1 
                       AND docum-est.ce-atual                     = YES USE-INDEX ch-di) THEN 
             ASSIGN l-atualiza-notaMae = YES.
        END.    
    END. /* for each tt-decla-import-embarq-aux: */


    
    /* fim - alteraá∆o da natureza de operaá∆o para a nota filha */
END.

IF NOT l-atualiza-notaMae THEN DO:
    FOR EACH tt-decla-import-embarq-aux:
    
        run setConstraint4 in h-bocx225 (input tt-decla-import-embarq-aux.cod-embarq, input tt-decla-import-embarq-aux.cod-estab).
        run OpenQuery in h-bocx225 (input 4).
        run findFirst in h-bocx225.
        run serverSendRows in h-bocx225 (input ?, input ?, input no, input ?, output iRowsReturned, output table tt-ordens-embarque).
        
        
        if  can-find(first tt-ordens-embarque) then DO:
                RUN loadOrdensDesemb IN h-bocx225e (INPUT TABLE tt-ordens-embarque,                /* tt-ordens-embarque */ 
                                                    INPUT tt-decla-import-embarq-aux.nat-operacao, /* nat-operacao       */
                                                    INPUT c-seg-usuario,                           /* usuario            */ 
                                                    INPUT yes,                                                   /* recarrega          */
                                                    INPUT NO,                                                   /* icms-diferido      */
                                                    INPUT NO,                                                    /* total              */
                                                    INPUT yes,                                                   /* recarrega-II       */
                                                    INPUT yes,                                                   /* recarrega-ipi      */
                                                    INPUT yes,                                                   /* recarrega-icms     */
                                                    INPUT yes,                                                   /* recarrega-pis      */
                                                    INPUT yes,                                                   /* recarrega-cof      */
                                                    INPUT YES,                                                   /* recarrega IBS UF   */
                                                    INPUT YES,                                                   /* recarrega IBS Mun  */
                                                    INPUT YES,                                                   /* recarrega CBS      */
                                                    INPUT YES,                                                   /* recarrega IS       */
                                                    INPUT yes,   /* peso-bruto   */                              /* recarrega-p-bruto  */
                                                    INPUT yes,   /* peso-liquido */                              /* recarrega-p-liqui  */
                                                    INPUT yes,   /* cubagem      */                              /* recarrega-cubagem  */
                                                    OUTPUT TABLE tt-ordens-desemb,                               /* tt-ordens-desemb   */
                                                    OUTPUT TABLE tt-bo-erro).                                    /* tt-bo-erro         */
                                                
    
                IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                    FOR EACH tt-ordens-desemb:
                        FOR EACH decla-import-ord EXCLUSIVE-LOCK
                                WHERE decla-import-ord.cod-estab   = tt-ordens-desemb.cod-estabel 
                                AND   decla-import-ord.cod-embarq  = tt-ordens-desemb.embarque    
                                AND   decla-import-ord.num-ordem   = tt-ordens-desemb.numero-ordem
                                AND   decla-import-ord.num-parcela = tt-ordens-desemb.parcela:     
        
                            assign decla-import-ord.idi-tributac-impto-import = tt-ordens-desemb.i-trib-ii
                                   decla-import-ord.idi-tributac-ipi          = tt-ordens-desemb.i-trib-ipi
                                   decla-import-ord.idi-tributac-icms         = tt-ordens-desemb.i-trib-icms
                                   decla-import-ord.idi-tributac-pis          = tt-ordens-desemb.i-trib-pis
                                   decla-import-ord.idi-tributac-cofins       = tt-ordens-desemb.i-trib-cofins
                                   decla-import-ord.val-aliq-ii               = if decla-import-ord.idi-tributac-impto-import = 2 then 0 else tt-ordens-desemb.de-aliq-ii     
                                   decla-import-ord.val-aliq-ipi              = if decla-import-ord.idi-tributac-ipi          = 2 then 0 else tt-ordens-desemb.de-aliq-ipi    
                                   decla-import-ord.val-aliq-icms             = if decla-import-ord.idi-tributac-icms         = 2 then 0 else tt-ordens-desemb.de-aliq-icms   
                                   decla-import-ord.val-aliq-pis              = if decla-import-ord.idi-tributac-pis          = 2 then 0 else tt-ordens-desemb.de-aliq-pis    
                                   decla-import-ord.val-aliq-cofins           = if decla-import-ord.idi-tributac-cofins       = 2 then 0 else tt-ordens-desemb.de-aliq-cofins.
        
        
                            assign decla-import-ord.log-suspens-impto-import = tt-ordens-desemb.l-suspensao-II
                                   decla-import-ord.log-suspens-ipi-import   = tt-ordens-desemb.l-suspensao-IPI.
                            
                            RUN buscaValoresUnitImpostos IN h-bocx404 (INPUT decla-import-ord.cod-item,
                                                                       OUTPUT decla-import-ord.val-unit-ipi,
                                                                       OUTPUT decla-import-ord.val-unit-pis,
                                                                       OUTPUT decla-import-ord.val-unit-cofins).
    
                            /* busca a adicao relaciona a ordem corrente*/
                            FOR FIRST decla-import-adic EXCLUSIVE-LOCK
                                WHERE decla-import-adic.num-di-ems = decla-import-ord.num-di-ems
                                AND   decla-import-adic.num-adic   = decla-import-ord.num-adic
                                AND   decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                                ASSIGN decla-import-adic.idi-tributac-impto-import = tt-ordens-desemb.i-trib-ii
                                       decla-import-adic.idi-tributac-ipi          = tt-ordens-desemb.i-trib-ipi   
                                       decla-import-adic.idi-tributac-pis          = tt-ordens-desemb.i-trib-pis   
                                       decla-import-adic.idi-tributac-cofins       = tt-ordens-desemb.i-trib-cofins
                                       decla-import-adic.idi-tributac-icms         = tt-ordens-desemb.i-trib-icms
                                       decla-import-adic.val-aliq-ii               = if decla-import-adic.idi-tributac-impto-import = 2 then 0 else decla-import-adic.val-aliq-ii    
                                       decla-import-adic.val-aliq-ipi              = if decla-import-adic.idi-tributac-ipi          = 2 then 0 else decla-import-adic.val-aliq-ipi   
                                       decla-import-adic.val-aliq-icms             = if decla-import-adic.idi-tributac-icms         = 2 then 0 else decla-import-adic.val-aliq-icms  
                                       decla-import-adic.val-aliq-pis              = if decla-import-adic.idi-tributac-pis          = 2 then 0 else decla-import-adic.val-aliq-pis   
                                       decla-import-adic.val-aliq-cofins           = if decla-import-adic.idi-tributac-cofins       = 2 then 0 else decla-import-adic.val-aliq-cofins.
            
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-natureza-operacao wWindow 
PROCEDURE pi-altera-natureza-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import-embarq-aux THEN DO:
    DO  i-cont = 1 TO brTarget:NUM-SELECTED-ROWS IN FRAME fPage0:
        IF  brTarget:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:  
            ASSIGN tt-decla-import-embarq-aux.nat-operacao          :READ-ONLY IN BROWSE brTarget = NO.

            reposition brTarget to rowid rowid(tt-decla-import-embarq-aux) no-error.
            apply "entry" to tt-decla-import-embarq-aux.nat-operacao in browse brTarget. 
            
            IF l-duimp-informada THEN DO:
                ENABLE btSaveNat WITH FRAME fPage0.
                DISABLE btAlterar WITH FRAME fPage0.
            END.
                
        END.
    END.
END.        

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-row-errors wWindow 
PROCEDURE pi-cria-row-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pErrorNumber      LIKE rowErrors.errorNumber     NO-UNDO.
DEFINE INPUT PARAM pErrorParameter   LIKE rowErrors.ErrorParameters NO-UNDO.

RUN utp/ut-msgs.p (INPUT 'msg',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

CREATE RowErrors.
ASSIGN RowErrors.ErrorNumber      = pErrorNumber
       RowErrors.ErrorType        = "EMS"
       RowErrors.ErrorParameters  = pErrorParameter
       RowErrors.errorDescription = RETURN-VALUE.

RUN utp/ut-msgs.p (INPUT 'help',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

RUN utp/ut-msgs.p (INPUT 'CodType',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

CASE RETURN-VALUE:
    WHEN '1' THEN
        ASSIGN RowErrors.ErrorSubType     = "ERROR".
    WHEN '2' THEN
        ASSIGN RowErrors.ErrorSubType     = "WARNING".
    WHEN '3' THEN
        ASSIGN RowErrors.ErrorSubType     = "QUESTION".
    WHEN '4' THEN
        ASSIGN RowErrors.ErrorSubType     = "INFORMATION".
END CASE.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-param-exec wWindow 
PROCEDURE pi-cria-tt-param-exec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-param-exec:
    DELETE tt-param-exec.
END.

IF NOT CAN-FIND(FIRST tt-param-exec) THEN
    CREATE tt-param-exec.

FOR FIRST tt-param-exec:
    ASSIGN tt-param-exec.cod-estabel-ini    = c-cod-estab
           tt-param-exec.cod-estabel-fim    = c-cod-estab
           tt-param-exec.embarque-ini       = ""
           tt-param-exec.embarque-fim       = "ZZZZZZZZZZZZ" 
           tt-param-exec.num-pedido-ini     = 0
           tt-param-exec.num-pedido-fim     = 99999999
           tt-param-exec.numero-ordem-ini   = 0
           tt-param-exec.numero-ordem-fim   = 99999999
           tt-param-exec.nr-proc-ini        = ""
           tt-param-exec.nr-proc-fim        = "ZZZZZZZZZZZZ".
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desvincula-embarque-di wWindow 
PROCEDURE pi-desvincula-embarque-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import-embarq THEN DO:
    EMPTY TEMP-TABLE tt-embarque-imp-aux.
    RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
    RUN goToKey         IN h-bocx220na (INPUT tt-decla-import-embarq.cod-estab, INPUT tt-decla-import-embarq.cod-embarq ).

    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getRecord IN h-bocx220na(OUTPUT TABLE tt-embarque-imp-aux).
        
        FOR FIRST  tt-embarque-imp-aux:
            ASSIGN tt-embarque-imp-aux.declaracao-import = ""
                   tt-embarque-imp-aux.data-di           = ?.

            &if '{&bf_mat_versao_ems}' >= '2.09' &then
            ASSIGN tt-embarque-imp-aux.num-di-ems = 0.
            &else
            ASSIGN tt-embarque-imp-aux.int-2 = 0.
            &endif
            
        END. /* FOR FIRST tt-embarque-imp-aux: */
    
        RUN setRecord IN h-bocx220na (INPUT TABLE tt-embarque-imp-aux).
        RUN updateRecord IN h-bocx220na.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        ELSE DO:
            RUN openQueryStatic IN h-bocx407 (INPUT 'Main':U).
            RUN goToKey         IN h-bocx407 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import-embarq.cod-embarq, INPUT tt-decla-import-embarq.cdd-siscomex-dts).
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN emptyRowErrors IN h-bocx407.
                RUN emptyRowObject IN h-bocx407.
                RUN setRecord      IN h-bocx407 (INPUT TABLE tt-decla-import-embarq).
                RUN deleteRecord   IN h-bocx407.
                RUN getRowErrors   IN h-bocx407 (OUTPUT TABLE RowErrors).
                IF RETURN-VALUE = "NOK":U THEN DO:                    
                    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal=YES}
                        RETURN "NOK":U.
                    END. /* IF  CAN-FIND(FIRST RowErrors */
                END. /* IF  RETURN-VALUE = "NOK":U */
            END. /* IF  RETURN-VALUE = "OK":U */
            ELSE RETURN "NOK":U.
        END. /* ELSE DO: */
    END. /* IF  RETURN-VALUE = "OK" */
END. /* IF  AVAIL tt-decla-import-embarq */
{&OPEN-QUERY-brSource}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empty-row-errors wWindow 
PROCEDURE pi-empty-row-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH RowErrors:
    DELETE RowErrors.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geraEmbalagens wWindow 
PROCEDURE pi-geraEmbalagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-bocx386) THEN
        RUN cxbo/bocx386.p PERSISTENT SET h-bocx386.

    RUN openQueryStatic IN h-bocx386(INPUT 'Main':U).
    
    FOR FIRST tt-decla-import: END.

    FOR EACH tt-decla-imp-embal:
        EMPTY TEMP-TABLE tt-decla-imp-embal-aux.
        CREATE tt-decla-imp-embal-aux.
        BUFFER-COPY tt-decla-imp-embal TO tt-decla-imp-embal-aux.
        ASSIGN tt-decla-imp-embal-aux.num-di-ems = tt-decla-import.num-di-ems
               tt-decla-imp-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.

        IF NOT l-duimp-informada THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Gerando_Embalagens" *}
            RUN pi-acompanhar IN h-acomp (RETURN-VALUE).
            END. 

        RUN emptyRowErrors IN h-bocx386.
        RUN emptyRowObject IN h-bocx386.
        RUN setRecord      IN h-bocx386 (INPUT TABLE tt-decla-imp-embal-aux).
        RUN createRecord   IN h-bocx386.
        
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx386(OUTPUT TABLE RowErrors APPEND).
        END.

    END.   

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geraRelat wWindow 
PROCEDURE pi-geraRelat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable c-key-value as character no-undo.

    DEFINE INPUT PARAM TABLE FOR RowErrors.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.arquivo         = session:temp-directory + "im0420.tmp".

    FOR FIRST tt-decla-import: END.

    RUN imp/im0420rp.p(INPUT TABLE tt-decla-import,
                       INPUT TABLE tt-param,
                       INPUT TABLE tt-erro-relat).

    /*Alterado 15/02/2005 - tech1007 - Alterado teste para que n∆o seja aberto o arquivo
      LST quando for gerado o arquivo RTF*/
    IF tt-param.destino = 3
       &IF "{&RTF}":U = "YES":U &THEN
       AND tt-param.l-habilitaRTF = NO
       &endif
       THEN DO:
        get-key-value section "Datasul_EMS2":U key "Show-Report-Program":U value c-key-value.
        
        if c-key-value = "":U or c-key-value = ?  then do:
            assign c-key-value = "Notepad.exe":U.
            put-key-value section "Datasul_EMS2":U key "Show-Report-Program":U value c-key-value no-error.
        end.

    IF SEARCH("utp/ut-showreport.r") <> ? OR SEARCH("utp/ut-showreport.p") <> ? THEN DO:
        RUN utp/ut-showreport.p (tt-param.arquivo).
    END.
    ELSE DO:
        run winexec (input c-key-value + chr(32) + tt-param.arquivo, input 1).
    END.


    end.

    return "OK":U.                                                               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-remove wWindow 
PROCEDURE pi-remove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).

DO  i-cont = 1 TO brTarget:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brTarget:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:    
        EMPTY TEMP-TABLE tt-decla-import-embarq.
        CREATE tt-decla-import-embarq.
        ASSIGN tt-decla-import-embarq.cod-embarq = tt-decla-import-embarq-aux.cod-embarq  
               tt-decla-import-embarq.cod-estab  = tt-decla-import-embarq-aux.cod-estab   
               tt-decla-import-embarq.num-di-ems = tt-decla-import-embarq-aux.num-di-ems
               tt-decla-import-embarq.cdd-siscomex-dts = tt-decla-import-embarq-aux.cdd-siscomex-dts
               tt-decla-import-embarq.r-Rowid    = tt-decla-import-embarq-aux.r-Rowid.  
        
        RUN pi-verifica-adicoes.
        IF RETURN-VALUE = "OK" THEN DO:                
            RUN pi-desvincula-embarque-di.
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
            ELSE DO:
                DELETE tt-decla-import-embarq-aux.
                IF l-duimp-informada THEN DO:
                    RUN pi-busca-historicos-di IN hCaller.
                    RUN pi-busca-despesas-di   IN hCaller.
                    RUN pi-busca-impostos      IN hCaller.
                END.
            END.                              
        END.
        ELSE
            RETURN "NOK":U.
    END.
END.

RUN mostra-di-manual.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-removeAll wWindow 
PROCEDURE pi-removeAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).

ASSIGN l-remove-all = YES.
RUN emptyRowErrors IN h-bocx407.
RUN emptyRowErrors IN h-bocx220na.

FOR EACH tt-decla-import-embarq-aux:
    EMPTY TEMP-TABLE tt-decla-import-embarq.
    CREATE tt-decla-import-embarq.
    BUFFER-COPY tt-decla-import-embarq-aux TO tt-decla-import-embarq.     
    RUN pi-verifica-adicoes.                                    
    IF RETURN-VALUE = "NOK" THEN
        LEAVE.
END.                 

IF l-exclui-relacionamentos THEN
    FOR EACH tt-decla-import-embarq-aux:
        EMPTY TEMP-TABLE tt-decla-import-embarq.
        CREATE tt-decla-import-embarq.
        BUFFER-COPY tt-decla-import-embarq-aux TO tt-decla-import-embarq.      

        RUN pi-remove-relacionamentos-embarq IN h-bocx407(INPUT tt-decla-import-embarq.cod-embarq,
                                                          INPUT tt-decla-import-embarq.cod-estab,
                                                          INPUT tt-decla-import-embarq.num-di-ems,
                                                          INPUT tt-decla-import-embarq.cdd-siscomex-dts).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN pi-desvincula-embarque-di.
            IF RETURN-VALUE = "OK":U THEN DO:

                IF l-elimina-despesas THEN DO:
                    RUN pi-busca-cotacoes-despesas  IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                                  INPUT tt-decla-import-embarq.cod-embarq,
                                                                  INPUT tt-decla-import-embarq.cod-estab ,
                                                                  INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                                  INPUT  YES,
                                                                  INPUT  l-elimina-despesas,
                                                                  OUTPUT l-cotacao).                            
                END.

                DELETE tt-decla-import-embarq-aux.
                IF l-duimp-informada THEN DO:
                    RUN pi-busca-historicos-di IN hCaller.
                    RUN pi-busca-despesas-di   IN hCaller.
                    RUN pi-busca-impostos      IN hCaller.
                END.
            END.
            ELSE
                RETURN "NOK":U.
        END.
        ELSE DO:
            RUN getRowErrors IN h-bocx384(OUTPUT TABLE RowErrors APPEND).
        END.                              
    END.   

RUN mostra-di-manual.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-removeAllAutomatico wWindow 
PROCEDURE pi-removeAllAutomatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-bocx220na) THEN
    RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.
        
FOR EACH tt-decla-import-embarq-aux:
    EMPTY TEMP-TABLE tt-decla-import-embarq.
    CREATE tt-decla-import-embarq.
    BUFFER-COPY tt-decla-import-embarq-aux TO tt-decla-import-embarq.

    EMPTY TEMP-TABLE tt-embarque-imp-aux.

    RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
    RUN goToKey IN h-bocx220na (INPUT tt-decla-import-embarq.cod-estab ,
                                INPUT tt-decla-import-embarq.cod-embarq). 
    IF RETURN-VALUE = "OK":U THEN
        RUN getRecord IN h-bocx220na (OUTPUT TABLE tt-embarque-imp-aux).

    FOR FIRST tt-embarque-imp-aux:
        IF NOT CAN-FIND(FIRST tt-embarque-imp
                        WHERE tt-embarque-imp.embarque    = tt-embarque-imp-aux.embarque    
                        AND   tt-embarque-imp.cod-estabel = tt-embarque-imp-aux.cod-estabel  ) THEN DO:
            CREATE tt-embarque-imp.
            BUFFER-COPY tt-embarque-imp-aux TO tt-embarque-imp.
            DELETE tt-decla-import-embarq-aux.
        END.                                                   
    END.
END.

{&OPEN-QUERY-brTarget}
{&OPEN-QUERY-brSource}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-removeAutomatico wWindow 
PROCEDURE pi-removeAutomatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-bocx220na) THEN
    RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.
            
DO  i-cont = 1 TO brTarget:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brTarget:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:    

        EMPTY TEMP-TABLE tt-embarque-imp-aux.
    
        RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
        RUN goToKey IN h-bocx220na (INPUT tt-decla-import-embarq-aux.cod-estab ,
                                    INPUT tt-decla-import-embarq-aux.cod-embarq). 
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx220na (OUTPUT TABLE tt-embarque-imp-aux).

        FOR FIRST tt-embarque-imp-aux:
            IF NOT CAN-FIND(FIRST tt-embarque-imp
                            WHERE tt-embarque-imp.embarque    = tt-embarque-imp-aux.embarque    
                            AND   tt-embarque-imp.cod-estabel = tt-embarque-imp-aux.cod-estabel  ) THEN DO:
                CREATE tt-embarque-imp.
                BUFFER-COPY tt-embarque-imp-aux TO tt-embarque-imp.
                DELETE tt-decla-import-embarq-aux.
            END.                                                   
        END.
    END.
END.      

{&OPEN-QUERY-brTarget}
{&OPEN-QUERY-brSource}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-selecao-embarque-di wWindow 
PROCEDURE pi-selecao-embarque-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im7010b.w PERSISTENT SET h-im7010b (INPUT THIS-PROCEDURE).
IF  VALID-HANDLE (h-im7010b) THEN DO:
    RUN initializeInterface IN h-im7010b.
    WAIT-FOR CLOSE OF h-im7010b FOCUS CURRENT-WINDOW.
END. 
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.


RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-parametros-di wWindow 
PROCEDURE pi-seta-parametros-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR tt-decla-import.
DEF INPUT PARAM TABLE FOR tt-decla-imp-embal.

FOR FIRST tt-decla-import: END.
ASSIGN i-despachante-param = INT(substring(tt-decla-import.cod-livre-1, 3, 9)).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-despachante wWindow 
PROCEDURE pi-sugere-despachante :
/*------------------------------------------------------------------------------
  Purpose: Realiza a sugest∆o de despachante para a DI    
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
/*    DEFINE VARIABLE i-cod-despachante        LIKE embarque-imp.cod-despachante  NO-UNDO.
    DEFINE VARIABLE i-cod-desp-embarq        LIKE embarque-imp.cod-despachante  NO-UNDO.
    DEFINE VARIABLE c-cod-livre-1            LIKE decla-import.cod-livre-1      NO-UNDO.
    DEFINE VARIABLE c-estab-di               LIKE decla-import-embarq.cod-estab NO-UNDO.
    DEFINE VARIABLE c-char-param-imp         AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-decla-import-embarq-aux-desp.

    IF l-duimp-informada THEN DO:
        FOR EACH tt-decla-import-embarq:
            CREATE tt-decla-import-embarq-aux-desp.
            BUFFER-COPY tt-decla-import-embarq TO tt-decla-import-embarq-aux-desp.
        END.

        RUN goToKey IN h-bocx383 (INPUT i-num-di-ems, INPUT i-num-seq-retif).

        IF RETURN-VALUE = "OK":U THEN DO:
            
            RUN getCharField  IN h-bocx383(INPUT "cod-livre-1":U, OUTPUT c-cod-livre-1).

            ASSIGN i-cod-despachante = int(SUBSTRING(c-cod-livre-1, 3, 9)) NO-ERROR.
    
            ASSIGN i-despachante-param = i-cod-despachante.
    
            RUN getCharField  IN h-bocx383(INPUT "cod-estab":U, OUTPUT c-estab-di).
        END.  
        ELSE DO:
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        FOR EACH tt-decla-import-embarq-aux:
            CREATE tt-decla-import-embarq-aux-desp.
            BUFFER-COPY tt-decla-import-embarq-aux TO tt-decla-import-embarq-aux-desp.
        END.

        FOR FIRST tt-decla-import-embarq-aux:
            ASSIGN c-estab-di   = tt-decla-import-embarq-aux.cod-estab.
        END.

        ASSIGN i-cod-despachante = INT(SUBSTRING(tt-decla-import.cod-livre-1, 3, 9)).
    END.
  
    RUN goToKey      IN h-bocx250 (INPUT c-estab-di).
    RUN getCharField IN h-bocx250 (INPUT "char-1":U, OUTPUT c-char-param-imp).

    /* N∆o h† despachante informado no parÉmetros de geraá∆o da DI */
    IF i-despachante-param = 0 THEN DO:

        /* Sugere o despachante do primeiro embarque vinculado */
        FOR EACH tt-decla-import-embarq-aux-desp:

            RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
            RUN goToKey         IN h-bocx220na (INPUT tt-decla-import-embarq-aux-desp.cod-estab, INPUT tt-decla-import-embarq-aux-desp.cod-embarq ).

            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getIntField IN h-bocx220na(INPUT "cod-despachante":U, OUTPUT i-cod-desp-embarq).
            END.              

            ASSIGN i-cod-despachante = i-cod-desp-embarq.
            
            LEAVE.
        END.
        
        /* Atualiza o despachante na DI */
        IF i-cod-despachante <> 0 THEN DO:

            IF l-duimp-informada THEN DO:
                RUN getRecord IN h-bocx383 (OUTPUT TABLE tt-decla-import).
    
                FOR FIRST tt-decla-import:
                    ASSIGN OVERLAY(tt-decla-import.cod-livre-1,3,9) = STRING(i-cod-despachante).
                END.
            
                RUN emptyRowErrors IN h-bocx383.
                RUN emptyRowObject IN h-bocx383.
                RUN setRecord      IN h-bocx383 (INPUT TABLE tt-decla-import).
                RUN updateRecord   IN h-bocx383.
            END.
            ELSE DO:
                ASSIGN OVERLAY(tt-decla-import.cod-livre-1,3,9) = STRING(i-cod-despachante).
            END.
        END.
    END.
    
  */      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-items-importacao wWindow 
PROCEDURE pi-valida-items-importacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF  TIME > iETime THEN DO:
    ASSIGN iETime = TIME + 10.
    IF  VALID-HANDLE(h-acomp) THEN 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Validando_Itens_Importaá∆o" *}
        RUN pi-acompanhar in h-acomp (RETURN-VALUE).
        END. 
END.

IF NOT VALID-HANDLE(h-boin667na) THEN
    RUN inbo/boin667.p PERSISTENT SET h-boin667na.

RUN openQueryStatic IN h-boin667na (INPUT 'Main':U).

/*FOR EACH tt-decla-import-ord:
     RUN goToKey IN h-boin667na (INPUT tt-decla-import-ord.cod-item).
     IF RETURN-VALUE = "NOK" THEN DO:
        RUN pi-cria-row-errors (INPUT 17006,
                                INPUT 'Informaá‰es para item ' + tt-decla-import-ord.cod-item + ' importaá∆o n∆o cadastrada (cd2510)').
     END.
END.

*/
IF  CAN-FIND(FIRST RowErrors 
             WHERE RowErrors.ErrorType <> "INTERNAL":U
             AND   rowErrors.ErrorSubType = "ERROR":U) THEN DO:
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "NOK":U.
END.   



RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-naturezas wWindow 
PROCEDURE pi-valida-naturezas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF  TIME > iETime THEN DO:
    ASSIGN iETime = TIME + 10.
    IF  VALID-HANDLE(h-acomp) THEN 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Validando_Dados_Natureza" *}
        RUN pi-acompanhar in h-acomp (RETURN-VALUE).
        END. 
END.

IF NOT VALID-HANDLE(h-boin245na) THEN
    RUN inbo/boin245na.p PERSISTENT SET h-boin245na.

RUN openQueryStatic IN h-boin245na (INPUT 'Main':U).

FOR EACH tt-decla-import-embarq-aux:
     RUN goToKey IN h-boin245na (INPUT tt-decla-import-embarq-aux.nat-operacao).
     IF RETURN-VALUE = "NOK" THEN DO:
        RUN pi-cria-row-errors (INPUT 2,
                                INPUT "Natureza de Operaá∆o " + tt-decla-import-embarq-aux.nat-operacao + " (BROWSER DE EMBARQUES VINCULADOS)").
     END.
END.

IF  CAN-FIND(FIRST RowErrors 
             WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    RETURN "NOK":U.
END.   



RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-adicoes wWindow 
PROCEDURE pi-verifica-adicoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL(tt-decla-import-embarq) THEN DO:
    ASSIGN l-retorno = NO.
    RUN pi-verifica-relacionamentos IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                  INPUT tt-decla-import-embarq.cod-embarq,
                                                  INPUT tt-decla-import-embarq.cod-estab ,
                                                  INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                  OUTPUT l-retorno).

    RUN pi-busca-cotacoes-despesas  IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                  INPUT tt-decla-import-embarq.cod-embarq,
                                                  INPUT tt-decla-import-embarq.cod-estab ,
                                                  INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                  INPUT  NO,
                                                  INPUT  NO,
                                                  OUTPUT l-cotacao).

    IF l-retorno THEN DO:  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "excluir_as_integraá‰es?_Existem_Adiá‰es_e/ou_Despesas_para_este_Embarque" *}
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 26715,
                        INPUT RETURN-VALUE + '.').
        IF RETURN-VALUE = "YES" THEN DO: 
            /*Existe despesas no embarque que esta sendo desvinculado sem cotaá‰es deve ser feito pergunta se quer eliminar as despesas do acompanhamento de embarque (IM0055)*/
            

            for each despes-decla-import where despes-decla-import.num-di-ems = tt-decla-import-embarq.num-di-ems
                                           AND despes-decla-import.cdd-siscomex-dts = tt-decla-import-embarq.cdd-siscomex-dts:
                find FIRST desp-embarque WHERE desp-embarque.cod-estabel = tt-decla-import-embarq.cod-estab
                                           AND desp-embarque.embarque    = tt-decla-import-embarq.cod-embarq
                                           AND desp-embarque.cod-desp    = despes-decla-import.cdn-despes NO-LOCK NO-ERROR. 
                
                IF AVAIL desp-embarque THEN DO:
                    IF (despes-decla-import.val-desp - desp-embarque.val-desp) > 0 THEN
                        ASSIGN despes-decla-import.val-desp = despes-decla-import.val-desp - desp-embarque.val-desp.
                    ELSE DO:
                        run utp/ut-msgs.p (input "show",
                                           input 55765,
                                           input string(tt-decla-import-embarq.cod-embarq) + "~~" + string(desp-embarque.cod-desp)).
                        
                        IF RETURN-VALUE = "YES" THEN
                            DELETE despes-decla-import.
                    END.
                END.
            end.

            IF NOT l-cotacao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deseja-excluir-as-despesas-do AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Deseja_Excluir_as_despesas_do_embarque?" *}
                ASSIGN c-lbl-liter-deseja-excluir-as-despesas-do = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-declaracao-de-importacao-foi AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_Declaraá∆o_de_importaá∆o_foi_rateada_e_os_valores_foram_levados_para_as_despesas_do_embarque._Estas_despesas_encontram-se_com_os_valores_rateados_e_algumas_destas_n∆o_foram_cotadas_n∆o_sendo_poss°vel_voltar_ao_valor_original._Deseja_excluir_estas_despesas?" *}
                ASSIGN c-lbl-liter-a-declaracao-de-importacao-foi = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT 'show',
                                INPUT 27100,
                                INPUT c-lbl-liter-deseja-excluir-as-despesas-do + '~~' + c-lbl-liter-a-declaracao-de-importacao-foi).
                IF RETURN-VALUE = "YES" THEN
                    ASSIGN l-elimina-despesas = YES.
                ELSE
                    ASSIGN l-elimina-despesas = NO.

                RUN pi-log-elimina-despesas IN h-bocx407 (INPUT "im0420",
                                                          INPUT l-elimina-despesas).
            END.

            IF NOT l-remove-all THEN DO:
                RUN pi-remove-relacionamentos-embarq IN h-bocx407(INPUT tt-decla-import-embarq.cod-embarq,
                                                                  INPUT tt-decla-import-embarq.cod-estab,
                                                                  INPUT tt-decla-import-embarq.num-di-ems,
                                                                  INPUT tt-decla-import-embarq.cdd-siscomex-dts).
                IF RETURN-VALUE = "OK":U THEN DO:
                    IF l-elimina-despesas THEN DO:
                        RUN pi-busca-cotacoes-despesas  IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                                      INPUT tt-decla-import-embarq.cod-embarq,
                                                                      INPUT tt-decla-import-embarq.cod-estab ,
                                                                      INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                                      INPUT  YES,
                                                                      INPUT  l-elimina-despesas,
                                                                      OUTPUT l-cotacao).                            
                    END.
                    RETURN "OK":U.
                END.
                ELSE DO:
                    RUN getRowErrors  IN h-bocx407 (OUTPUT TABLE RowErrors).
                    IF  CAN-FIND(FIRST RowErrors 
                                 WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal=YES}
                        RETURN "NOK":U.
                    END.                
                END.                                        
            END.
            ELSE DO:
                /*quando for add all no primeiro registro que o usu†rio selecionar que Ç para regerar o hist¢rico Ç considerado para todos os proximos embarques essa opá∆o*/
                ASSIGN l-exclui-relacionamentos = YES.
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:                
            ASSIGN l-exclui-relacionamentos = NO.

            IF NOT l-cotacao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deseja-excluir-as-despesas-do-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Deseja_Excluir_as_despesas_do_embarque?" *}
                ASSIGN c-lbl-liter-deseja-excluir-as-despesas-do-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-declaracao-de-importacao-foi-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_Declaraá∆o_de_importaá∆o_foi_rateada_e_os_valores_foram_levados_para_as_despesas_do_embarque._Estas_despesas_encontram-se_com_os_valores_rateados_e_algumas_destas_n∆o_foram_cotadas_n∆o_sendo_poss°vel_voltar_ao_valor_original._Deseja_excluir_estas_despesas?" *}
                ASSIGN c-lbl-liter-a-declaracao-de-importacao-foi-2 = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT 'show',
                                INPUT 27100,
                                INPUT c-lbl-liter-deseja-excluir-as-despesas-do-2 + '~~' + c-lbl-liter-a-declaracao-de-importacao-foi-2).
                IF RETURN-VALUE = "YES" THEN
                    ASSIGN l-elimina-despesas = YES.
                ELSE
                    ASSIGN l-elimina-despesas = NO.

                RUN pi-log-elimina-despesas IN h-bocx407 (INPUT "im0420",
                                                          INPUT l-elimina-despesas).
            END.

            RETURN "NOK":U.     
        END.
    END.
    ELSE DO:
        for each despes-decla-import where despes-decla-import.num-di-ems = tt-decla-import-embarq.num-di-ems
                                       AND despes-decla-import.cdd-siscomex-dts = tt-decla-import-embarq.cdd-siscomex-dts:
            find FIRST desp-embarque WHERE desp-embarque.cod-estabel = tt-decla-import-embarq.cod-estab
                                       AND desp-embarque.embarque    = tt-decla-import-embarq.cod-embarq
                                       AND desp-embarque.cod-desp    = despes-decla-import.cdn-despes NO-LOCK NO-ERROR. 
            
            IF AVAIL desp-embarque THEN DO:
                IF (despes-decla-import.val-desp - desp-embarque.val-desp) > 0 THEN
                    ASSIGN despes-decla-import.val-desp = despes-decla-import.val-desp - desp-embarque.val-desp.
                ELSE DO:
                    run utp/ut-msgs.p (input "show",
                                       input 55765,
                                       input string(tt-decla-import-embarq.cod-embarq) + "~~" + string(desp-embarque.cod-desp)).
                    
                    IF RETURN-VALUE = "YES" THEN
                        DELETE despes-decla-import.
                END.
            END.
        end.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pontos-controle wWindow 
PROCEDURE pi-verifica-pontos-controle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER l-desp-geradas AS LOG NO-UNDO.

ASSIGN l-desp-geradas = YES.

IF AVAIL(tt-decla-import-embarq) THEN DO:
    EMPTY TEMP-TABLE tt-embarque-imp-aux.
    ASSIGN l-retorno = YES.

    RUN valida-efetivacao-nacionaliz IN h-bocx407(INPUT tt-decla-import-embarq.num-di-ems,
                                                  INPUT tt-decla-import-embarq.cod-embarq, 
                                                  INPUT tt-decla-import-embarq.cod-estab,  
                                                  INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                  OUTPUT d-dt-efetiva).

    IF RETURN-VALUE = "NOK" THEN DO:
        RUN getRowErrors  IN h-bocx407 (OUTPUT TABLE RowErrors APPEND).

        IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            RETURN "NOK":U.
        END.                

    END.

    ASSIGN l-retorno = YES.
    RUN pi-verifica-pontos-de-controle IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                     INPUT tt-decla-import-embarq.cod-embarq,
                                                     INPUT tt-decla-import-embarq.cod-estab ,
                                                     INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                     OUTPUT l-retorno).
    IF NOT l-retorno THEN DO:  

        IF NOT l-add-all THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-de-nacionalizacao-eou-po AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Nacionalizaá∆o_e/ou_Ponto_de_Chegada_difere_da_Declaraá∆o_de_Importaá∆o" *}
            ASSIGN c-lbl-liter-ponto-de-nacionalizacao-eou-po = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT 'show',
                            INPUT 17006,
                            INPUT c-lbl-liter-ponto-de-nacionalizacao-eou-po + '!' + '~~~~' + c-lbl-liter-ponto-de-nacionalizacao-eou-po + '!').
            RETURN "NOK":U.                
        END.
        ELSE DO:
            RUN pi-cria-row-errors (INPUT 17006,
                                    INPUT 'Ponto de Nacionalizaá∆o e/ou Ponto de Chegada difere da Declaraá∆o de Importaá∆o!' + '~~~~' + 'Ponto de Nacionalizaá∆o e/ou Ponto de Chegada difere da Declaraá∆o de Importaá∆o!').
            NEXT.
        END.
    END.
    ELSE DO:

        /*VERIFICAR SE EXISTE PONTOS DE CONTROLE QUE N«O TENHAM NA DI*/
        IF NOT l-add-all THEN DO:
            /*VERIFICAR SE EXISTE DESPESAS QUE N«O TENHAM NA DI*/
            RUN pi-verifica-despesas-di IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                      INPUT tt-decla-import-embarq.cod-embarq,
                                                      INPUT tt-decla-import-embarq.cod-estab ,
                                                      INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                      OUTPUT l-retorno).
            IF NOT l-retorno THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Existem_despesas_no(s)_embarque(s)_que_n∆o_est∆o_na_Declaraá∆o_de_Importaá∆o._Deseja_gerar_despesas_conforme" *}
                RUN utp/ut-msgs.p (INPUT 'show',
                                INPUT 52167,
                                INPUT RETURN-VALUE + ' ' + '~~' + tt-decla-import-embarq.cod-embarq + '~~' + STRING(tt-decla-import-embarq.num-di-ems)).
                
                IF RETURN-VALUE <> "YES" THEN DO:     
                    ASSIGN l-desp-geradas = NO.
                END.
            END.
        END.
        ELSE DO:
            RUN pi-verifica-all-desp-histor-di IN h-bocx407 (INPUT tt-decla-import-embarq.num-di-ems,
                                                             INPUT tt-decla-import-embarq.cod-embarq,
                                                             INPUT tt-decla-import-embarq.cod-estab ,
                                                             INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                                             OUTPUT l-retorno).
            IF NOT l-retorno THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Existem_Pontos_de_Controle_E/OU_Despesas_no(s)_embarque(s)_que_n∆o_est∆o_na_Declaraá∆o_de_Importaá∆o._Os_pontos_de_controle_n∆o_ser∆o_integrados_com_a_DI._Deseja_gerar_as_despesas_conforme" *}
                RUN utp/ut-msgs.p (INPUT 'show',
                                INPUT 52167,
                                INPUT RETURN-VALUE + ' ' + '~~' + tt-decla-import-embarq.cod-embarq + '~~' + STRING(tt-decla-import-embarq.num-di-ems)).
                IF RETURN-VALUE = "YES" THEN DO:                     
                    /*quando for add all no primeiro registro que o usu†rio selecionar que Ç para regerar o hist¢rico Ç considerado para todos os proximos embarques essa opá∆o*/
                    ASSIGN l-gera-historico = YES.
                    RETURN "NOK":U.
                END.
                ELSE DO:
                    ASSIGN l-gera-historico = NO.
                    RETURN "NOK":U.     
                END.
            END.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-via-transp wWindow 
PROCEDURE pi-verifica-via-transp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAIL(tt-decla-import-embarq) THEN DO:
    ASSIGN l-via-transp     = NO
           l-primer-embarq  = NO.

    RUN validaViaTransporte IN h-bocx407(INPUT tt-decla-import-embarq.cod-embarq, 
                                         INPUT tt-decla-import-embarq.cod-estab,  
                                         INPUT tt-decla-import-embarq.num-di-ems,
                                         INPUT tt-decla-import-embarq.cdd-siscomex-dts,
                                         OUTPUT l-via-transp,
                                         OUTPUT l-primer-embarq ).  

    IF NOT l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */ 
        IF l-via-transp THEN DO: /* Via de transporte da DI Ç diferente da via de transporte do embarque */
           IF l-primer-embarq THEN DO: /* primeiro embarque */
              run utp/ut-msgs.p (input "show":U, input 54559, input STRING(tt-decla-import-embarq.cod-embarq)). /* confirma e atualiza */
              if  return-value <> "yes" then do: 
                  ASSIGN l-gera-historico = NO.
                  RETURN "NOK":U.
              end.
              ELSE DO:
                  ASSIGN l-gera-historico = YES.
                  RETURN "OK":U.
              END.
           END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula-embarque-di wWindow 
PROCEDURE pi-vincula-embarque-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import-embarq THEN DO:
    RUN goToKey IN h-bocx220na (INPUT tt-decla-import-embarq.cod-estab, INPUT tt-decla-import-embarq.cod-embarq).
    IF  RETURN-VALUE = "OK" THEN DO:
        IF  NOT l-duimp-informada THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Vinculando_Embarque" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE + " " + tt-decla-import-embarq.cod-embarq).
            END. 

        RUN emptyRowObject  IN h-bocx407.
        RUN openQueryStatic IN h-bocx407 (INPUT "Main":U).
        RUN emptyRowErrors  IN h-bocx407.
        RUN setRecord       IN h-bocx407 (INPUT TABLE tt-decla-import-embarq).
        RUN createRecord    IN h-bocx407.
        RUN getRowErrors    IN h-bocx407 (OUTPUT TABLE RowErrors APPEND).
        IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorType <> "INTERNAL":U
                     AND   RowErrors.ErrorSubType = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
        ELSE DO:
            IF  TIME > iETime THEN DO:
                ASSIGN iETime = TIME + 10.
                IF  VALID-HANDLE(h-acomp) THEN 
                    IF NOT l-duimp-informada THEN
                        /* Inicio -- Projeto Internacional */
                        DO:
                        {utp/ut-liter.i "Atualizando_dados_Embarque" *}
                        RUN pi-acompanhar in h-acomp (RETURN-VALUE + " " + tt-decla-import-embarq.cod-embarq).
                        END. 
            END.

            RUN getRecord IN h-bocx220na(OUTPUT TABLE tt-embarque-imp-aux).    
            FOR FIRST tt-embarque-imp-aux:
                IF  l-duimp-informada THEN DO:
                    FOR FIRST tt-decla-import: 
                    ASSIGN tt-embarque-imp-aux.declaracao-import = c-cod-duimp-siscomex
                           tt-embarque-imp-aux.data-di           = d-dat-duimp.

                    &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        ASSIGN tt-embarque-imp-aux.num-di-ems = tt-decla-import.num-di-ems.
                    &else
                        ASSIGN tt-embarque-imp-aux.int-2 = tt-decla-import.num-di-ems.
                    &endif
                    end.
                END. /* IF  l-duimp-informada */
                ELSE DO:
                    FOR FIRST tt-decla-import:
                        ASSIGN tt-embarque-imp-aux.declaracao-import = tt-decla-import.cod-di-siscomex
                               tt-embarque-imp-aux.data-di           = tt-decla-import.dat-di. //manuela

                        &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        ASSIGN tt-embarque-imp-aux.num-di-ems = tt-decla-import.num-di-ems.
                        &else
                        ASSIGN tt-embarque-imp-aux.int-2 = tt-decla-import.num-di-ems.
                        &endif
                    END. /* FOR FIRST tt-decla-import: */
                END.
            END.
            RUN setRecord    IN h-bocx220na (INPUT TABLE tt-embarque-imp-aux).
            RUN updateRecord IN h-bocx220na.
            RUN getRowErrors IN h-bocx220na (OUTPUT TABLE RowErrors APPEND).
            IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorType <> "INTERNAL":U
                         AND   RowErrors.ErrorSubType = "ERROR") THEN
                RETURN "NOK":U.
            ELSE DO:
                IF NOT CAN-FIND(FIRST histor-decla-import
                                WHERE histor-decla-import.num-di-ems = tt-decla-import-embarq.num-di-ems
                                  AND histor-decla-import.cdd-siscomex-dts = tt-decla-import-embarq.cdd-siscomex-dts) THEN DO:
                    RUN geraHistoricoDUIMP (INPUT tt-decla-import-embarq.num-di-ems,
                                         INPUT tt-decla-import-embarq.cod-estab,
                                         INPUT tt-decla-import-embarq.cod-embarq,
                                         INPUT tt-decla-import-embarq.cdd-siscomex-dts).
                    IF RETURN-VALUE = "NOK":U THEN
                        RETURN "NOK":U.
                END.

                IF l-gera-despesa = YES THEN
                        RUN geraDespesasDUIMP(INPUT tt-decla-import-embarq.num-di-ems,
                                           INPUT tt-decla-import-embarq.cod-estab,
                                           INPUT tt-decla-import-embarq.cod-embarq,
                                           INPUT tt-decla-import-embarq.cdd-siscomex-dts).
                IF RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
            END.
        END.                              
    END. 
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-via-transp-dif wWindow 
PROCEDURE retorna-spp-via-transp-dif :
/*------------------------------------------------------------------------------
  Purpose: Quando esta funªío estiver ativada o programa irˇ apresentar um alerta avisando
  que a via de transporte da ordem ≤ diferente da via de transporte do embarque.
  Se a funªío nío estiver ativada, o programa irˇ informar que esta diferente, permitindo 
  relacionar e atualizar o embarque. A partir da segunda ordem nío serˇ permitido vincular
  ordens com via de transporte diferente.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER l-resultado    AS LOG NO-UNDO.
  
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-via-transp-dif'
            AND   ativo     = YES) THEN
    ASSIGN l-resultado =TRUE.
ELSE
    ASSIGN l-resultado =FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaDUIMP wWindow 
PROCEDURE setaDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDuimp    LIKE duimp-siscomex.cod-duimp-dts    NO-UNDO.
DEF INPUT PARAM pNumVersao   LIKE duimp-siscomex.num-versao       NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE duimp-siscomex.cdd-siscomex-dts NO-UNDO.
DEF INPUT PARAM phCaller     AS HANDLE                            NO-UNDO.

ASSIGN i-num-duimp-dts = pNumDuimp       
       i-num-versao    = pNumVersao
       de-cdd-siscomex-dts = pCddSiscomexDts
       hCaller         = phCaller.
       l-duimp-informada  = YES .

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataNacionaliz wWindow 
FUNCTION fnDataNacionaliz RETURNS DATE
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN i-cod-itiner-aux = 0.
    RUN findFirstEmbarque IN h-bocx230 (INPUT p-cod-estabel,
                                        INPUT p-embarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner-aux).
    ELSE
        ASSIGN i-cod-itiner-aux = 0.

    RUN findCodigo in h-bocx115 (input i-cod-itiner-aux,
                                 output c-return).
    IF c-return = "" THEN
        RUN getIntField in h-bocx115 (input "pto-desembarque":U, output i-pto-desembarque).

    RUN findCh-itiner IN h-bocx230 (INPUT p-cod-estabel,
                                    INPUT p-embarque,
                                    INPUT i-cod-itiner-aux,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getDateField IN h-bocx230 (INPUT 'dt-previsao',
                                       OUTPUT d-dat-prev-origin).
    ELSE
        ASSIGN d-dat-prev-origin = ?.

    RETURN d-dat-prev-origin.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFornecedor wWindow 
FUNCTION fnFornecedor RETURNS CHARACTER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN i-cod-emitente = 0.
    RUN findEmbarque IN h-bocx225 (INPUT p-cod-estabel,
                                   INPUT p-embarque,
                                   OUTPUT c-return-ordens-emb).
    IF c-return-ordens-emb = "" THEN DO:
        RUN getintfield IN h-bocx225 ("numero-ordem", OUTPUT i-numero-ordem).
    
         RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                     OUTPUT c-return-ordem-compr).
         IF c-return-ordem-compr = "" THEN
            RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).
            IF i-cod-emitente <> 0 THEN
                RUN goToKey IN h-boad098 (INPUT STRING(i-cod-emitente)).
                IF RETURN-VALUE = "OK" THEN
                    RUN getCharField IN h-boad098 (INPUT "nome-abrev",
                                                   OUTPUT c-nome-abrev).
                ELSE
                    ASSIGN c-nome-abrev = "".     
    END.

    RETURN c-nome-abrev.
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItinerario wWindow 
FUNCTION fnItinerario RETURNS INTEGER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN findFirstEmbarque IN h-bocx230 (INPUT p-cod-estabel,
                                        INPUT p-embarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.
    
    RETURN i-cod-itiner.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


