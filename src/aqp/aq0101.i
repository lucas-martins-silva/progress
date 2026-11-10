&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-event-aquis-rural NO-UNDO LIKE event-aquis-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-param-aquis-rural NO-UNDO LIKE param-aquis-rural
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0101 2.00.00.019 } /*** "010019" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        {1}
&GLOBAL-DEFINE Version        2.00.00.019

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Geral,Ev. Financ, Peso Qualid.,Impostos

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            {2}
&GLOBAL-DEFINE Copy           {2}
&GLOBAL-DEFINE Update         {2}
&GLOBAL-DEFINE Delete         {2}
&GLOBAL-DEFINE Undo           {2}
&GLOBAL-DEFINE Cancel         {2}
&GLOBAL-DEFINE Save           {2}

&GLOBAL-DEFINE ttTable        tt-param-aquis-rural
&GLOBAL-DEFINE hDBOTable      h-boin00968
&GLOBAL-DEFINE DBOTable       param-aquis-rural

&GLOBAL-DEFINE page0KeyFields tt-param-aquis-rural.cod-estabel
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-param-aquis-rural.qti-analis-isento tt-param-aquis-rural.cod-cta-aquis-rural ~
                              tt-param-aquis-rural.cod-ccusto-aquis-rural tt-param-aquis-rural.cod-periodo ~
                              tt-param-aquis-rural.cod-cta-dif-quant tt-param-aquis-rural.cod-ccusto-dif-quant
                                    
&GLOBAL-DEFINE page2Fields    l-ativa-facelift
&GLOBAL-DEFINE page3Fields    l-ativa-facelift
&GLOBAL-DEFINE page4Fields    l-imp-sanidade tt-param-aquis-rural.dsl-formul-event

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR c-zoom-cod-conta       AS CHAR NO-UNDO.
DEF VAR c-zoom-desc-conta      AS CHAR NO-UNDO.
DEF VAR c-conta                AS CHAR NO-UNDO.
DEF VAR l-utiliza-ccusto       AS LOG  NO-UNDO.
def var c-formato-conta        as char no-undo.
def var c-formato-ccusto       as char no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin176    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107    AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-text      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin01006  AS HANDLE NO-UNDO. /*event-aquis-rural*/
DEFINE VARIABLE h-boin01020  AS HANDLE NO-UNDO. /*config-peso-qualid*/
DEFINE VARIABLE h-api-financ AS HANDLE NO-UNDO. /*api de dados do financeiro*/

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

{cdp/cdunif001.i} /* Vari veis da unifica‡Æo de conceito Conta Cont bil e Centro de Custo */
DEFINE VARIABLE c-empresa       LIKE param-global.empresa-prin NO-UNDO.

DEFINE VARIABLE l-consulta AS LOGICAL NO-UNDO.

{utils/formulDef.i} /* tt-variaveis - usada na fórmula */

DEFINE TEMP-TABLE tt-peso-qualid NO-UNDO
    field cod-estabel LIKE config-peso-qualid.cod-estabel
    field it-codigo   as char format "x(16)" label "Item"
    field cod-exame   as char                label "C¢d. Exame"
    field cod-comp    as char                label "Componente"
    field qtd-period  as char                label "Qtd. Per¡odos"
    field dat-inic    as char                label "Valid. Inicial"
    field dat-fim     as char                label "Valid. Final"
    field cdn-period  as char                label "Per¡odo"
    field val-peso    as char                label "Peso %"
    field desc-item   as char format "x(18)" label "Descri‡Æo Item"
    field desc-exame  as char format "x(30)" label "Descri‡Æo Exame"
    field desc-comp   as char format "x(60)" label "Descri‡Æo Componente"
    field cdn-seq     like config-peso-qualid.cdn-seq
    field r-rowid     as rowid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEvenFin

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-event-aquis-rural tt-peso-qualid

/* Definitions for BROWSE brEvenFin                                     */
&Scoped-define FIELDS-IN-QUERY-brEvenFin tt-event-aquis-rural.it-codigo ~
tt-event-aquis-rural.cod-evento ~
fnEventoDesc(tt-event-aquis-rural.cod-evento) ~
fnTipoDesc(tt-event-aquis-rural.cdn-tipo) tt-event-aquis-rural.cod-exame ~
tt-event-aquis-rural.cod-comp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEvenFin 
&Scoped-define QUERY-STRING-brEvenFin FOR EACH tt-event-aquis-rural NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brEvenFin OPEN QUERY brEvenFin FOR EACH tt-event-aquis-rural NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brEvenFin tt-event-aquis-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brEvenFin tt-event-aquis-rural


/* Definitions for BROWSE brPesoQualid                                  */
&Scoped-define FIELDS-IN-QUERY-brPesoQualid tt-peso-qualid.it-codigo tt-peso-qualid.cod-exame tt-peso-qualid.cod-comp tt-peso-qualid.qtd-period tt-peso-qualid.dat-inic tt-peso-qualid.dat-fim tt-peso-qualid.cdn-period tt-peso-qualid.val-peso tt-peso-qualid.desc-item tt-peso-qualid.desc-exame tt-peso-qualid.desc-comp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPesoQualid   
&Scoped-define SELF-NAME brPesoQualid
&Scoped-define QUERY-STRING-brPesoQualid FOR EACH tt-peso-qualid
&Scoped-define OPEN-QUERY-brPesoQualid OPEN QUERY {&SELF-NAME} FOR EACH tt-peso-qualid.
&Scoped-define TABLES-IN-QUERY-brPesoQualid tt-peso-qualid
&Scoped-define FIRST-TABLE-IN-QUERY-brPesoQualid tt-peso-qualid


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brEvenFin}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brPesoQualid}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-param-aquis-rural.cod-estabel 
&Scoped-define ENABLED-TABLES tt-param-aquis-rural
&Scoped-define FIRST-ENABLED-TABLE tt-param-aquis-rural
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave bt-altera-period btQueryJoins btReportsJoins btExit btHelp ~
c-desc-estabel 
&Scoped-Define DISPLAYED-FIELDS tt-param-aquis-rural.cod-estabel 
&Scoped-define DISPLAYED-TABLES tt-param-aquis-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-param-aquis-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEventoDesc wMaintenance 
FUNCTION fnEventoDesc RETURNS CHARACTER
  (p-cod-evento AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDesc wMaintenance 
FUNCTION fnTipoDesc RETURNS CHARACTER
  (p-cdn-tipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-altera-period 
     IMAGE-UP FILE "image/im-f-erp.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-f-erp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Alterar Data Fechamento C lculo".

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-cc-difer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ct AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ct-difer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE VARIABLE l-ativa-facelift AS CHARACTER FORMAT "X(1)":U 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

DEFINE BUTTON bt-eliminar-pesos 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir-pesos 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar-pesos 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-formul-imp-sanidade 
     IMAGE-UP FILE "image/im-calc4":U
     IMAGE-INSENSITIVE FILE "image/ii-calc4":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Tela de cria‡Æo de f¢rmula".

DEFINE VARIABLE l-imp-sanidade AS CHARACTER FORMAT "X(30)":U INITIAL "Imposto Sanidade Rural:" 
      VIEW-AS TEXT 
     SIZE 16.7 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEvenFin FOR 
      tt-event-aquis-rural SCROLLING.

DEFINE QUERY brPesoQualid FOR 
      tt-peso-qualid SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEvenFin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEvenFin wMaintenance _STRUCTURED
  QUERY brEvenFin NO-LOCK DISPLAY
      tt-event-aquis-rural.it-codigo FORMAT "x(16)":U WIDTH 16.43
      tt-event-aquis-rural.cod-evento COLUMN-LABEL "C¢d Evento" FORMAT "x(16)":U
            WIDTH 15.43
      fnEventoDesc(tt-event-aquis-rural.cod-evento) COLUMN-LABEL "Descri‡Æo Evento" FORMAT "x(50)":U
            WIDTH 32.43
      fnTipoDesc(tt-event-aquis-rural.cdn-tipo) COLUMN-LABEL "Tipo" FORMAT "x(20)":U
            WIDTH 14.86
      tt-event-aquis-rural.cod-exame FORMAT ">>>>>9":U
      tt-event-aquis-rural.cod-comp FORMAT ">>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84.14 BY 8.5 FIT-LAST-COLUMN.

DEFINE BROWSE brPesoQualid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPesoQualid wMaintenance _FREEFORM
  QUERY brPesoQualid DISPLAY
      tt-peso-qualid.it-codigo
 tt-peso-qualid.cod-exame
 tt-peso-qualid.cod-comp 
 tt-peso-qualid.qtd-period
 tt-peso-qualid.dat-inic FORMAT 'X(10)'
 tt-peso-qualid.dat-fim  FORMAT 'X(10)' WIDTH 10
 tt-peso-qualid.cdn-period
 tt-peso-qualid.val-peso
 tt-peso-qualid.desc-item
 tt-peso-qualid.desc-exame
 tt-peso-qualid.desc-comp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84.14 BY 8.5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     bt-altera-period AT ROW 1.13 COL 64.72 WIDGET-ID 6
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-param-aquis-rural.cod-estabel AT ROW 3.5 COL 19.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .88
     c-desc-estabel AT ROW 3.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.33
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     tt-param-aquis-rural.dsl-formul-event AT ROW 1.92 COL 21.14 NO-LABEL WIDGET-ID 8
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 56.86 BY 2.67
     bt-formul-imp-sanidade AT ROW 3.38 COL 78.14 WIDGET-ID 4
     l-imp-sanidade AT ROW 1.79 COL 2.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84 BY 9.75 WIDGET-ID 600.

DEFINE FRAME fPage2
     brEvenFin AT ROW 1 COL 1 WIDGET-ID 300
     bt-incluir AT ROW 9.67 COL 1 WIDGET-ID 2
     bt-eliminar AT ROW 9.67 COL 11 WIDGET-ID 4
     l-ativa-facelift AT ROW 9.67 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 9.75 WIDGET-ID 200.

DEFINE FRAME fPage1
     tt-param-aquis-rural.qti-analis-isento AT ROW 2.5 COL 18 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tt-param-aquis-rural.cod-cta-aquis-rural AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-desc-ct AT ROW 3.5 COL 39.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-param-aquis-rural.cod-ccusto-aquis-rural AT ROW 4.5 COL 18 COLON-ALIGNED WIDGET-ID 2
          LABEL "C. Custo Aquisi‡Æo Rural"
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-desc-sc AT ROW 4.5 COL 39.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-param-aquis-rural.cod-cta-dif-quant AT ROW 5.5 COL 18 COLON-ALIGNED WIDGET-ID 28
          LABEL "Conta Diferen‡a Qtd"
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-desc-ct-difer AT ROW 5.5 COL 39.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-param-aquis-rural.cod-ccusto-dif-quant AT ROW 6.5 COL 18 COLON-ALIGNED WIDGET-ID 26
          LABEL "C.Custo Diferen‡a Qtd"
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-desc-cc-difer AT ROW 6.5 COL 39.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-param-aquis-rural.cod-periodo AT ROW 7.5 COL 18 COLON-ALIGNED WIDGET-ID 16
          LABEL "éltimo Per¡odo Fechado"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 9.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brPesoQualid AT ROW 1 COL 1 WIDGET-ID 500
     bt-incluir-pesos AT ROW 9.67 COL 1 WIDGET-ID 2
     bt-modificar-pesos AT ROW 9.67 COL 11 WIDGET-ID 8
     bt-eliminar-pesos AT ROW 9.67 COL 21 WIDGET-ID 4
     l-ativa-facelift AT ROW 9.67 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT "X(1)":U
           VIEW-AS TEXT 
          SIZE 1 BY .67
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 9.75 WIDGET-ID 400.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-event-aquis-rural T "?" NO-UNDO mgind event-aquis-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-param-aquis-rural T "?" NO-UNDO mgind param-aquis-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.33
         WIDTH              = 90
         MAX-HEIGHT         = 38.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.58
         VIRTUAL-WIDTH      = 182.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-periodo IN FRAME fPage1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brEvenFin 1 fPage2 */
/* SETTINGS FOR FILL-IN l-ativa-facelift IN FRAME fPage2
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brPesoQualid 1 fPage3 */
/* SETTINGS FOR FILL-IN l-ativa-facelift IN FRAME fPage3
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME fPage4
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEvenFin
/* Query rebuild information for BROWSE brEvenFin
     _TblList          = "Temp-Tables.tt-event-aquis-rural"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _FldNameList[1]   > Temp-Tables.tt-event-aquis-rural.it-codigo
"tt-event-aquis-rural.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-event-aquis-rural.cod-evento
"tt-event-aquis-rural.cod-evento" "C¢d Evento" ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnEventoDesc(tt-event-aquis-rural.cod-evento)" "Descri‡Æo Evento" "x(50)" ? ? ? ? ? ? ? no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnTipoDesc(tt-event-aquis-rural.cdn-tipo)" "Tipo" "x(20)" ? ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-event-aquis-rural.cod-exame
     _FldNameList[6]   = Temp-Tables.tt-event-aquis-rural.cod-comp
     _Query            is OPENED
*/  /* BROWSE brEvenFin */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPesoQualid
/* Query rebuild information for BROWSE brPesoQualid
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-peso-qualid.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brPesoQualid */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPesoQualid
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brPesoQualid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPesoQualid wMaintenance
ON VALUE-CHANGED OF brPesoQualid IN FRAME fPage3
DO:
  IF AVAILABLE tt-peso-qualid AND
     tt-peso-qualid.it-codigo <> ""  THEN
      ASSIGN bt-eliminar-pesos:SENSITIVE = YES.
  ELSE
      ASSIGN bt-eliminar-pesos:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-altera-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-period wMaintenance
ON CHOOSE OF bt-altera-period IN FRAME fpage0
DO:
  
  {&WINDOW-NAME}:SENSITIVE = NO.
  
  RUN aqp/aq0101a.w(INPUT-OUTPUT tt-param-aquis-rural.cod-periodo,
                    INPUT-OUTPUT tt-param-aquis-rural.cod-livre-2).
        
  ASSIGN tt-param-aquis-rural.cod-periodo:SCREEN-VALUE IN FRAME fPage1 = tt-param-aquis-rural.cod-periodo.

  {&WINDOW-NAME}:SENSITIVE = YES.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wMaintenance
ON CHOOSE OF bt-eliminar IN FRAME fPage2 /* Eliminar */
DO:

    IF AVAILABLE tt-event-aquis-rural THEN DO:
  
        RUN goToKey IN h-boin01006 (INPUT tt-event-aquis-rural.cod-estabel,
                                          tt-event-aquis-rural.it-codigo,
                                          tt-event-aquis-rural.cod-evento).
        
        
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT  3051, /* Confirma elimina‡Æo */
                              INPUT "").
            IF RETURN-VALUE = "YES":U THEN DO:
                RUN emptyRowErrors  IN h-boin01006.
                RUN deleteRecord    IN h-boin01006.
                RUN getRowErrors IN h-boin01006(OUTPUT TABLE rowerrors).
                IF CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                    IF CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                        RETURN NO-APPLY.
                END.
    
                RUN pi-carrega-browse IN THIS-PROCEDURE.
        
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-eliminar-pesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-pesos wMaintenance
ON CHOOSE OF bt-eliminar-pesos IN FRAME fPage3 /* Eliminar */
DO:

    IF AVAILABLE tt-peso-qualid AND
       tt-peso-qualid.it-codigo <> ""  THEN DO:
  
        RUN goToKey IN h-boin01020 (INPUT tt-peso-qualid.cod-estabel,
                                    INPUT tt-peso-qualid.it-codigo,
                                    INPUT tt-peso-qualid.cod-exame,
                                    INPUT tt-peso-qualid.cod-comp,
                                    INPUT tt-peso-qualid.cdn-seq).

        IF RETURN-VALUE = "OK":U THEN DO:    

            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT  3051, /* Confirma elimina‡Æo */
                              INPUT "").
            IF RETURN-VALUE = "YES":U THEN DO:
                RUN emptyRowErrors  IN h-boin01020.
                RUN deleteRecord    IN h-boin01020.
                RUN getRowErrors    IN h-boin01020(OUTPUT TABLE rowerrors).
                IF CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                    IF CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                        RETURN NO-APPLY.
                END.
                ELSE DO: /*Apagar todos os filhos da configura‡Æo*/
            
                    RUN deleteRecordsPesoPeriod IN h-boin01020(INPUT tt-peso-qualid.cod-estabel,
                                                               INPUT tt-peso-qualid.it-codigo,
                                                               INPUT tt-peso-qualid.cod-exame,
                                                               INPUT tt-peso-qualid.cod-comp,
                                                               INPUT tt-peso-qualid.cdn-seq).
            
                END.
            
                RUN pi-carrega-browse IN THIS-PROCEDURE.
            
            END.

        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-formul-imp-sanidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-formul-imp-sanidade wMaintenance
ON CHOOSE OF bt-formul-imp-sanidade IN FRAME fPage4
DO:

    RUN createTTVariaveisImptoSanid IN {&hDBOTable}.
    RUN getTTVariaveisImptoSanid    IN {&hDBOTable} (OUTPUT TABLE tt-variaveis).

    DEFINE VARIABLE c-formul-imp AS CHARACTER NO-UNDO.
    c-formul-imp = tt-param-aquis-rural.dsl-formul-event:SCREEN-VALUE IN FRAME fPage4.
    RUN utils/formulCad.w (INPUT "Tela de cria‡Æo de f¢rmula":U,
                           INPUT TABLE tt-variaveis,
                           INPUT-OUTPUT c-formul-imp).
    ASSIGN tt-param-aquis-rural.dsl-formul-event:SCREEN-VALUE IN FRAME fPage4 = c-formul-imp
           tt-param-aquis-rural.dsl-formul-event = c-formul-imp.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage2 /* Incluir */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.
   
    FIND FIRST tt-param-aquis-rural NO-ERROR.

    IF AVAIL tt-param-aquis-rural THEN DO:
        SESSION:SET-WAIT-STATE("general":U).
        RUN aqp/aq0101b.w PERSISTENT SET h-prog-desp (INPUT ?,
                                                      INPUT tt-param-aquis-rural.r-rowid,
                                                      INPUT "Add":U,
                                                      INPUT THIS-PROCEDURE,
                                                      INPUT 2).
          
        IF VALID-HANDLE(h-prog-desp) THEN DO:
            RUN initializeInterface IN h-prog-desp.
             
            SESSION:SET-WAIT-STATE("":U).
             
            WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
        END.
        
        /*RUN openQueriesSon IN THIS-PROCEDURE.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-incluir-pesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-pesos wMaintenance
ON CHOOSE OF bt-incluir-pesos IN FRAME fPage3 /* Incluir */
DO:
    DEFINE VARIABLE h-prog-pesos AS HANDLE NO-UNDO.
   
    IF AVAIL tt-param-aquis-rural THEN DO:
        SESSION:SET-WAIT-STATE("general":U).
        RUN aqp/aq0101c.w PERSISTENT SET h-prog-pesos (INPUT ?,
                                                       INPUT tt-param-aquis-rural.r-rowid,
                                                       INPUT "Add":U,
                                                       INPUT THIS-PROCEDURE,
                                                       INPUT 3).
          
        IF VALID-HANDLE(h-prog-pesos) THEN DO:
            RUN initializeInterface IN h-prog-pesos.
             
            SESSION:SET-WAIT-STATE("":U).
             
            WAIT-FOR CLOSE OF h-prog-pesos FOCUS CURRENT-WINDOW.
        END.
        
        RUN pi-carrega-browse IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar-pesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-pesos wMaintenance
ON CHOOSE OF bt-modificar-pesos IN FRAME fPage3 /* Modificar */
DO:
    DEFINE VARIABLE h-prog-pesos AS HANDLE NO-UNDO.
    DEFINE VARIABLE pRowid       AS ROWID  NO-UNDO.

    IF AVAIL tt-param-aquis-rural AND
       AVAIL tt-peso-qualid THEN DO:

        RUN goToKey IN h-boin01020 (INPUT tt-peso-qualid.cod-estabel,
                                          tt-peso-qualid.it-codigo,
                                          tt-peso-qualid.cod-exame,
                                          tt-peso-qualid.cod-comp,
                                          tt-peso-qualid.cdn-seq).

        RUN getRowid IN h-boin01020(OUTPUT pRowid ).

        SESSION:SET-WAIT-STATE("general":U).

        RUN aqp/aq0101c.w PERSISTENT SET h-prog-pesos (INPUT pRowid,
                                                       INPUT tt-param-aquis-rural.r-rowid,
                                                       INPUT "Update":U,
                                                       INPUT THIS-PROCEDURE,
                                                       INPUT 3).

        IF VALID-HANDLE(h-prog-pesos) THEN DO:

            RUN initializeInterface IN h-prog-pesos.

            SESSION:SET-WAIT-STATE("":U).

            WAIT-FOR CLOSE OF h-prog-pesos FOCUS CURRENT-WINDOW.

        END.

        RUN pi-carrega-browse IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="inzoom/z01in00968.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-param-aquis-rural.cod-ccusto-aquis-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-aquis-rural wMaintenance
ON ENTRY OF tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fPage1 /* C. Custo Aquisi‡Æo Rural */
DO:
  
    assign tt-param-aquis-rural.cod-ccusto-aquis-rural:format in frame fPage1 = "X(20)".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-aquis-rural wMaintenance
ON F5 OF tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fPage1 /* C. Custo Aquisi‡Æo Rural */
DO:
    
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto(INPUT c-empresa,           /* Empresa */
                                                  INPUT tt-param-aquis-rural.cod-estabel:SCREEN-VALUE IN FRAME fPage0, /* Estabelecimento */
                                                  INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                  INPUT "",                  /* Unidade de Negocio*/
                                                  INPUT "",                  /* Plano de Contas*/
                                                  INPUT v_cod_cta_ctbl,      /* C«digo da Conta*/
                                                  INPUT "",                  /* C«digo do Plano de Centro de Custo*/
                                                  INPUT TODAY,               /* Data da Transacao*/
                                                  OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                  OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                  OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
               c-desc-sc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-aquis-rural wMaintenance
ON LEAVE OF tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fPage1 /* C. Custo Aquisi‡Æo Rural */
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","")
           c-desc-sc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF v_cod_ccusto = "" THEN
        assign tt-param-aquis-rural.cod-ccusto-aquis-rural:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

    IF v_cod_ccusto <> "" THEN DO:
    
        RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   INPUT  v_cod_ccusto,       /* CCUSTO */
                                                   INPUT  TODAY,              /* DATA DE TRANSACAO */
                                                   OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    
        IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
    
            /* Busca mÿscara para o campo centro de custo */
            RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                           INPUT  "",                  /* PLANO CONTAS */
                                                           INPUT  TODAY,               /* DATA DE TRANSACAO */ 
                                                           OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).  /* ERROS */
            
            ASSIGN c-desc-sc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
    
            /* Aplica a mÿscara no campo */
            IF  p_cod_format_ccusto <> "" THEN
                ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
        END.
        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-aquis-rural wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fPage1 /* C. Custo Aquisi‡Æo Rural */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-aquis-rural.cod-ccusto-dif-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-dif-quant wMaintenance
ON ENTRY OF tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fPage1 /* C.Custo Diferen‡a Qtd */
DO:
  ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-dif-quant wMaintenance
ON F5 OF tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fPage1 /* C.Custo Diferen‡a Qtd */
DO:
  RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto(INPUT c-empresa,                                                     /* Empresa */
                                                INPUT tt-param-aquis-rural.cod-estabel:SCREEN-VALUE IN FRAME fPage0, /* Estabelecimento */
                                                INPUT NO,                                                            /* Considera Todos os Estabelecimentos ?*/
                                                INPUT "",                                                            /* Unidade de Negocio*/
                                                INPUT "",                                                            /* Plano de Contas*/
                                                INPUT v_cod_cta_ctbl,                                                /* C«digo da Conta*/
                                                INPUT "",                                                            /* C«digo do Plano de Centro de Custo*/
                                                INPUT TODAY,                                                         /* Data da Transacao*/
                                                OUTPUT v_cod_ccusto,                                                 /* Codigo CCusto*/
                                                OUTPUT v_des_ccusto,                                                 /* Descricao CCusto*/
                                                OUTPUT TABLE tt_log_erro).                                           /* Erros*/
  IF v_des_ccusto <> "" THEN
    ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
           c-desc-cc-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-dif-quant wMaintenance
ON LEAVE OF tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fPage1 /* C.Custo Diferen‡a Qtd */
DO:
  EMPTY TEMP-TABLE tt_log_erro.
  ASSIGN v_cod_ccusto = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","")
         c-desc-cc-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  IF v_cod_ccusto = "" THEN
    ASSIGN tt-param-aquis-rural.cod-ccusto-dif-quant:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

  IF v_cod_ccusto <> "" THEN DO:
  
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  TODAY,              /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
      /* Busca mÿscara para o campo centro de custo */
      RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                     INPUT  "",                  /* PLANO CONTAS */
                                                     INPUT  TODAY,               /* DATA DE TRANSACAO */ 
                                                     OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                     OUTPUT TABLE tt_log_erro).  /* ERROS */
      
      ASSIGN c-desc-cc-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
  
      /* Aplica a mÿscara no campo */
      IF p_cod_format_ccusto <> "" THEN
        ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-ccusto-dif-quant wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fPage1 /* C.Custo Diferen‡a Qtd */
DO:
  APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-aquis-rural.cod-cta-aquis-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-aquis-rural wMaintenance
ON ENTRY OF tt-param-aquis-rural.cod-cta-aquis-rural IN FRAME fPage1 /* Conta Aquisi‡Æo Rural */
DO:
    assign tt-param-aquis-rural.cod-cta-aquis-rural:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-aquis-rural wMaintenance
ON F5 OF tt-param-aquis-rural.cod-cta-aquis-rural IN FRAME fPage1 /* Conta Aquisi‡Æo Rural */
DO:
  
    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)",         /* FINALIDADES */
                                                   INPUT  TODAY,              /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */

    FIND FIRST tt_log_erro NO-ERROR.

    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN tt-param-aquis-rural.cod-cta-aquis-rural:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl
               c-desc-ct:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-aquis-rural wMaintenance
ON LEAVE OF tt-param-aquis-rural.cod-cta-aquis-rural IN FRAME fPage1 /* Conta Aquisi‡Æo Rural */
DO:
  
    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").

    IF v_cod_cta_ctbl = "" THEN
        assign tt-param-aquis-rural.cod-cta-aquis-rural:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

    /* Busca dados da conta cont bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?°O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresenta»’o da conta contÿbil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  TODAY,                /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */

        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               c-desc-ct:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.
    
        /* Verifica se a conta utiliza centro de custo */
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  tt-param-aquis-rural.cod-estabel:SCREEN-VALUE IN FRAME fPage0, /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  TODAY,              /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */

        IF  NOT p_log_ccusto THEN
            ASSIGN tt-param-aquis-rural.cod-ccusto-aquis-rural:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-desc-sc:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = "".

        IF cAction <> "" THEN
            ASSIGN tt-param-aquis-rural.cod-ccusto-aquis-rural:SENSITIVE IN FRAME {&FRAME-NAME} = p_log_ccusto.
        
         
    END.
    ELSE
        ASSIGN c-desc-ct:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-aquis-rural wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-aquis-rural.cod-cta-aquis-rural IN FRAME fPage1 /* Conta Aquisi‡Æo Rural */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-aquis-rural.cod-cta-dif-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-dif-quant wMaintenance
ON ENTRY OF tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fPage1 /* Conta Diferen‡a Qtd */
DO:
  ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-dif-quant wMaintenance
ON F5 OF tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fPage1 /* Conta Diferen‡a Qtd */
DO:
  /* Unifica‡Æo de conceito conta cont bil e centro de custo */
  IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
  
  RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                 INPUT  "CEP":U,            /* MODULO */
                                                 INPUT  "",                 /* PLANO DE CONTAS */
                                                 INPUT  "(nenhum)",         /* FINALIDADES */
                                                 INPUT  TODAY,              /* DATA TRANSACAO */
                                                 OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                 OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                 OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                 OUTPUT TABLE tt_log_erro). /* ERROS */
  FIND FIRST tt_log_erro NO-ERROR.

  IF  v_des_cta_ctbl <> "" THEN
    ASSIGN tt-param-aquis-rural.cod-cta-dif-quant:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl
                                 c-desc-ct-difer :SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-dif-quant wMaintenance
ON LEAVE OF tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fPage1 /* Conta Diferen‡a Qtd */
DO:
  /* Unifica‡Æo de conceito conta cont bil e centro de custo */
  ASSIGN v_cod_cta_ctbl = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").

  IF v_cod_cta_ctbl = "" THEN
    ASSIGN tt-param-aquis-rural.cod-cta-dif-quant:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

  /* Busca dados da conta cont bil */
  EMPTY TEMP-TABLE tt_log_erro.
  RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                 INPUT        "",                 /* PLANO DE CONTAS */
                                                 INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                 INPUT        TODAY,              /* DATA TRANSACAO */
                                                 OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                 OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                 OUTPUT       v_num_sit_cta_ctbl, /* SITUA?°O DA CONTA */
                                                 OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                 OUTPUT TABLE tt_log_erro).       /* ERROS */
  IF RETURN-VALUE = "OK" THEN DO:
    /* Busca formato de apresenta»’o da conta contÿbil */
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                       INPUT  "",                   /* PLANO CONTAS */
                                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                                       OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).   /* ERROS */
    ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
           c-desc-ct-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    
    /* Aplica a mascara no campo */
    IF p_cod_format_cta_ctbl <> "" THEN
      ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.
  
    /* Verifica se a conta utiliza centro de custo */
    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,                                                     /* EMPRESA EMS 2 */
                                                       INPUT  tt-param-aquis-rural.cod-estabel:SCREEN-VALUE IN FRAME fPage0, /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                                                            /* PLANO CONTAS */
                                                       INPUT  v_cod_cta_ctbl,                                                /* CONTA */
                                                       INPUT  TODAY,                                                         /* DT TRANSACAO */
                                                       OUTPUT p_log_ccusto,                                                  /* UTILIZA CCUSTO ? */
                                                       OUTPUT TABLE tt_log_erro).                                            /* ERROS */
    IF NOT p_log_ccusto THEN
      ASSIGN tt-param-aquis-rural.cod-ccusto-dif-quant:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             c-desc-cc-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = "".

    IF cAction <> "" THEN
      ASSIGN tt-param-aquis-rural.cod-ccusto-dif-quant:SENSITIVE IN FRAME {&FRAME-NAME} = p_log_ccusto.
     
  END.
  ELSE ASSIGN c-desc-cc-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              c-desc-ct-difer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-cta-dif-quant wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fPage1 /* Conta Diferen‡a Qtd */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-param-aquis-rural.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-estabel wMaintenance
ON F5 OF tt-param-aquis-rural.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {method/zoomfields.i &ProgramZoom="adzoom/z11ad107.w"
                       &FieldZoom1="cod-estabel"
                       &FieldScreen1="tt-param-aquis-rural.cod-estabel"
                       &Frame1="fPage0"
                       &FieldZoom2="nome"
                       &FieldScreen2="c-desc-estabel"
                       &Frame2="fPage0"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-estabel wMaintenance
ON LEAVE OF tt-param-aquis-rural.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
   {METHOD/referencefields.i 
        &HandleDBOLeave="h-boad107"
        &KeyValue1="input frame fpage0 tt-param-aquis-rural.cod-estabel"
        &FieldName1="nome"
        &FieldScreen1="c-desc-estabel"
        &Frame1="fPage0"}
        
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-aquis-rural    IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-aquis-rural.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEvenFin
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

tt-param-aquis-rural.cod-cta-aquis-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-param-aquis-rural.cod-ccusto-aquis-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-param-aquis-rural.cod-cta-dif-quant:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-param-aquis-rural.cod-ccusto-dif-quant:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-param-aquis-rural.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{utp/ut-liter.i "Qtd_An lises_Ext_Isentas"}
ASSIGN tt-param-aquis-rural.qti-analis-isento:LABEL IN FRAME fpage1 = RETURN-VALUE.

{utp/ut-liter.i "C._Custo_Aquisi‡Æo_Rural"}
ASSIGN tt-param-aquis-rural.cod-ccusto-aquis-rural:LABEL IN FRAME fpage1 = RETURN-VALUE.
       
/*reposicionamento de campos*/
ASSIGN tt-param-aquis-rural.cod-ccusto-aquis-rural:WIDTH  IN FRAME fpage1 = 21.

ASSIGN wh-text = tt-param-aquis-rural.cod-ccusto-aquis-rural:SIDE-LABEL-HANDLE
       wh-text:SCREEN-VALUE = RETURN-VALUE
       tt-param-aquis-rural.cod-ccusto-aquis-rural:COLUMN IN FRAME fpage1 = 20
       wh-text:COL = tt-param-aquis-rural.cod-ccusto-aquis-rural:COLUMN IN FRAME fpage1 - wh-text:WIDTH.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN bt-altera-period:SENSITIVE       IN FRAME fPage0 = btSave:SENSITIVE IN FRAME fPage0
           bt-formul-imp-sanidade:SENSITIVE IN FRAME fPage4 = btSave:SENSITIVE IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-estabel            IN FRAME fpage0.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-aquis-rural    IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-dif-quant      IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-dif-quant   IN FRAME fpage1.

  RUN pi-carrega-browse IN THIS-PROCEDURE.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF cAction = "ADD" THEN
        ASSIGN tt-param-aquis-rural.cod-cta-aquis-rural   :FORMAT IN FRAME fpage1 = "X(20)"
               tt-param-aquis-rural.cod-ccusto-aquis-rural:FORMAT IN FRAME fpage1 = "X(20)"
               tt-param-aquis-rural.cod-cta-dif-quant     :FORMAT IN FRAME fpage1 = "X(20)"
               tt-param-aquis-rural.cod-ccusto-dif-quant  :FORMAT IN FRAME fpage1 = "X(20)".
            
    IF tt-param-aquis-rural.cod-ccusto-aquis-rural <> "" THEN
        APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fpage1.

    IF tt-param-aquis-rural.cod-cta-aquis-rural <> "" THEN
        APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-aquis-rural IN FRAME fpage1.

    IF tt-param-aquis-rural.cod-cta-dif-quant <> "" THEN
        APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-dif-quant IN FRAME fpage1.

    IF tt-param-aquis-rural.cod-ccusto-dif-quant <> "" THEN
        APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-dif-quant IN FRAME fpage1.

    APPLY 'ENTRY' TO tt-param-aquis-rural.qti-analis-isento IN FRAME fpage1.

    ASSIGN bt-altera-period:SENSITIVE IN FRAME fPage0                 = btSave:SENSITIVE IN FRAME fPage0
           bt-formul-imp-sanidade:SENSITIVE IN FRAME fPage4           = btSave:SENSITIVE IN FRAME fPage0
           tt-param-aquis-rural.cod-periodo:SENSITIVE IN FRAME fPage1 = NO.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Busca empresa */
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN c-empresa = param-global.empresa-prin.

  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-aquis-rural    IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-aquis-rural IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-ccusto-dif-quant   IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-cta-dif-quant      IN FRAME fpage1.
  APPLY 'LEAVE' TO tt-param-aquis-rural.cod-estabel            IN FRAME fpage0.

  DISABLE btDelete WITH FRAME fpage0.

  ASSIGN bt-incluir      :SENSITIVE IN FRAME fPage2 = YES
         bt-incluir-pesos:SENSITIVE IN FRAME fPage3 = YES
         l-consulta                                 = '{1}' = 'aq0401':U.   

  IF l-consulta THEN DO:
    ASSIGN btUpdate:HIDDEN               IN FRAME fPage0 = YES
           btUndo:HIDDEN                 IN FRAME fPage0 = YES
           btSave:HIDDEN                 IN FRAME fPage0 = YES
           btCancel:HIDDEN               IN FRAME fPage0 = YES
           btAdd:HIDDEN                  IN FRAME fPage0 = YES
           btCopy:HIDDEN                 IN FRAME fPage0 = YES
           btDelete:HIDDEN               IN FRAME fPage0 = YES
           bt-altera-period:HIDDEN       IN FRAME fPage0 = YES
           bt-incluir:HIDDEN             IN FRAME fPage2 = YES
           bt-eliminar:HIDDEN            IN FRAME fPage2 = YES
           bt-incluir-pesos:HIDDEN       IN FRAME fPage3 = YES 
           bt-eliminar-pesos:HIDDEN      IN FRAME fPage3 = YES
           bt-modificar-pesos:HIDDEN     IN FRAME fPage3 = YES 
           bt-formul-imp-sanidade:HIDDEN IN FRAME fPage4 = YES 
           MENU-ITEM miAdd:SENSITIVE     IN MENU  smFile = NO
           MENU-ITEM miCopy:SENSITIVE    IN MENU  smFile = NO
           MENU-ITEM miUpdate:SENSITIVE  IN MENU  smFile = NO
           MENU-ITEM miDelete:SENSITIVE  IN MENU  smFile = NO
           MENU-ITEM miUndo:SENSITIVE    IN MENU  smFile = NO
           MENU-ITEM miCancel:SENSITIVE  IN MENU  smFile = NO
           MENU-ITEM miSave:SENSITIVE    IN MENU  smFile = NO.
           
    END.       

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDboSonHandle wMaintenance 
PROCEDURE getDboSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  param pi-son-page-number AS INT    NO-UNDO.
    DEF OUTPUT param p-handle       AS HANDLE NO-UNDO.

    IF pi-son-page-number = 2 THEN
        ASSIGN p-handle = h-boin01006.

    IF pi-son-page-number = 3 THEN
        ASSIGN p-handle = h-boin01020.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-param-aquis-rural.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
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
    
    DEFINE VARIABLE c-cod-estabel LIKE {&ttTable}.cod-estabel NO-UNDO
        VIEW-AS FILL-IN SIZE 6 BY 0.88 .
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.71 COL 23.52 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Parƒmetros de Aquis. Rural" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Parƒmetros_de_Aquis._Rural"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Parƒmetros_de_Aquis._Rural":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00968.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00968.p YES}
        {btb/btb008za.i2 inbo/boin00968.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boad107) OR
       h-boad107:TYPE <> "PROCEDURE":U OR
       h-boad107:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
         {btb/btb008za.i1 adbo/boad107na.p YES}
         {btb/btb008za.i2 adbo/boad107na.p '' h-boad107}              
    END.
    
    RUN openQueryStatic IN h-boad107(INPUT "Main":U) NO-ERROR.

    if not valid-handle(h-boin176)    or
      h-boin176:type <> "PROCEDURE":U or
      h-boin176:file-name <> "inbo/boin176.p":U then do:
       {btb/btb008za.i1 inbo/boin176.p yes}
       {btb/btb008za.i2 inbo/boin176.p '' h-boin176}
    end.
    run openQueryStatic in h-boin176 (input "Main":U) no-error.

    if not valid-handle(h-boin01006)    or
      h-boin01006:type <> "PROCEDURE":U or
      h-boin01006:file-name <> "inbo/boin01006.p":U then do:
       {btb/btb008za.i1 inbo/boin01006.p yes}
       {btb/btb008za.i2 inbo/boin01006.p '' h-boin01006}
    end.
    run openQueryStatic in h-boin01006 (input "Main":U) no-error.

    if not valid-handle(h-boin01020)    or
      h-boin01020:type <> "PROCEDURE":U or
      h-boin01020:file-name <> "inbo/boin01020.p":U then do:
       {btb/btb008za.i1 inbo/boin01020.p yes}
       {btb/btb008za.i2 inbo/boin01020.p '' h-boin01020}
    end.
    run openQueryStatic in h-boin01020 (input "Main":U) no-error.


    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    IF  NOT VALID-HANDLE(h-api-financ) THEN
        RUN prgfin/apb/apb061za.p PERSISTENT SET h-api-financ.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-browse wMaintenance 
PROCEDURE pi-carrega-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned  AS INTEGER NO-UNDO.

    /*Eventos financeiro*/
    IF AVAIL tt-param-aquis-rural THEN DO:
        
        EMPTY TEMP-TABLE tt-event-aquis-rural.

        RUN emptyRowObject            IN h-boin01006.
        RUN setConstraintEstabel      IN h-boin01006 (INPUT tt-param-aquis-rural.cod-estabel).
        RUN openQueryStatic           IN h-boin01006 (INPUT "Estabel":U)  NO-ERROR.
        RUN getBatchRecords           IN h-boin01006 (INPUT ?,
                                                      INPUT NO,
                                                      INPUT ?,
                                                      OUTPUT iRowsReturned,
                                                      OUTPUT TABLE tt-event-aquis-rural).

        {&OPEN-QUERY-brEvenFin}
    END.

    ASSIGN bt-eliminar:SENSITIVE IN FRAME fPage2 = CAN-FIND(FIRST tt-event-aquis-rural)
           brEvenFin:SENSITIVE   IN FRAME fPage2 = CAN-FIND(FIRST tt-event-aquis-rural).
    /********************/

    /*Pesos qualidade*/
    IF AVAIL tt-param-aquis-rural THEN DO:
        
        EMPTY TEMP-TABLE tt-peso-qualid.

        RUN getTTpesoQualid IN h-boin01020 (INPUT INPUT FRAME fPage0 tt-param-aquis-rural.cod-estabel,
                                            OUTPUT TABLE tt-peso-qualid).
        
        {&OPEN-QUERY-brPesoQualid}

    END.

    ASSIGN bt-modificar-pesos:SENSITIVE IN FRAME fPage3 = CAN-FIND(FIRST tt-peso-qualid)
           bt-eliminar-pesos:SENSITIVE IN FRAME fPage3 = CAN-FIND(FIRST tt-peso-qualid)     
           brPesoQualid:SENSITIVE   IN FRAME fPage3 = CAN-FIND(FIRST tt-peso-qualid).
    /********************/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RUN pi-carrega-browse IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEventoDesc wMaintenance 
FUNCTION fnEventoDesc RETURNS CHARACTER
  (p-cod-evento AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-des-evento AS CHARACTER FORMAT "X(50)" NO-UNDO.

    IF VALID-HANDLE(h-api-financ) THEN DO:
        
        RUN pi_retornar_dados_evento_financeiro IN h-api-financ (INPUT  p-cod-evento,
                                                                 OUTPUT c-des-evento).
        
        RETURN c-des-evento. /* Function return value. */
    END.
    ELSE DO:
        {utp/ut-liter.i "Evento_sem_descri‡Æo"}
        RETURN RETURN-VALUE. /* Function return value. */
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDesc wMaintenance 
FUNCTION fnTipoDesc RETURNS CHARACTER
  (p-cdn-tipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN {ininc/i01in01006.i  04 p-cdn-tipo} .   
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

