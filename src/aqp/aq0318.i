&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-dest-cust-naocfedade NO-UNDO LIKE dest-cust-naocfedade
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-estabelec NO-UNDO LIKE estabelec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-histor-naocfedade NO-UNDO LIKE histor-naocfedade
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-naocfedade-carg NO-UNDO LIKE naocfedade-carg
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-naocfedade-carg-atual NO-UNDO LIKE naocfedade-carg
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0318 2.00.00.012 } /*** 010012 ***/

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
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Movimentos, Penaliza‡äes

&GLOBAL-DEFINE page0Widgets   btExit btHelp br-naocfedade-carg btSelecao btAtualiza btReabertura btEncerrar
&GLOBAL-DEFINE page1Widgets   br-histor-naocfedade bt-incluir bt-modificar bt-eliminar
&GLOBAL-DEFINE page2Widgets   br-dest-cust-naocfedade bt-incluir-2 bt-modificar-2 bt-eliminar-2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
DEF VAR p-dif-quantidade       AS LOG NO-UNDO.
DEF VAR p-problema-qualidade   AS LOG NO-UNDO.
DEF VAR p-nao-coleta           AS LOG NO-UNDO.
DEF VAR p-pendente             AS LOG NO-UNDO.
DEF VAR p-em-analise           AS LOG NO-UNDO.
DEF VAR p-resolvida            AS LOG NO-UNDO.
DEF VAR p-estabelecimento      AS CHAR    NO-UNDO.
DEF VAR p-carga-ini            AS INTEGER NO-UNDO.
DEF VAR p-carga-fim            AS INTEGER NO-UNDO.
DEF VAR p-nao-conformidade-ini AS INTEGER NO-UNDO.
DEF VAR p-nao-confirmidade-fim AS INTEGER NO-UNDO.
DEF VAR p-data-ini             AS DATE    NO-UNDO.
DEF VAR p-data-fim             AS DATE    NO-UNDO.
DEF VAR i-rows-returned        AS INTEGER NO-UNDO.
DEF VAR c-char-1               AS CHAR NO-UNDO.
DEF VAR c-nome-fornecedor      AS CHAR NO-UNDO.
DEF VAR c-desc-evento          AS CHAR NO-UNDO.

DEF VAR h-boin01009            AS HANDLE  NO-UNDO.
DEF VAR h-boin01010            AS HANDLE  NO-UNDO.
DEF VAR h-boin01013            AS HANDLE  NO-UNDO.
DEF VAR h-boad107na            AS HANDLE  NO-UNDO.
DEF VAR h-boin627zm            AS HANDLE  NO-UNDO.
DEF VAR h-boad098na            AS HANDLE  NO-UNDO.
DEF VAR h-apb061za             AS HANDLE  NO-UNDO.
DEF VAR h-boin00961            AS HANDLE  NO-UNDO.


{inbo/boin01009.i1 tt-gera-nc row-errors-nc}


DEFINE VARIABLE c-penalizado     AS CHARACTER EXTENT 2  NO-UNDO.
DEFINE VARIABLE c-penalizado-brw AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-situacao-brw   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-tipo-nc-brw    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-it-codigo-brw  AS CHARACTER           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod-estabel AS CHARACTER INITIAL ? NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_num-carg    AS INTEGER  INITIAL ? NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dest-cust-naocfedade

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-dest-cust-naocfedade tt-histor-naocfedade ~
tt-naocfedade-carg

/* Definitions for BROWSE br-dest-cust-naocfedade                       */
&Scoped-define FIELDS-IN-QUERY-br-dest-cust-naocfedade tt-dest-cust-naocfedade.cdn-destin fnNomeFornecedor(tt-dest-cust-naocfedade.cdn-destin) fnPenalizado(tt-dest-cust-naocfedade.cod-propried) @ c-penalizado-brw tt-dest-cust-naocfedade.cod-event-financ fnBuscaDesc(tt-dest-cust-naocfedade.cod-event-financ) tt-dest-cust-naocfedade.dat-vencto tt-dest-cust-naocfedade.val-dest   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dest-cust-naocfedade   
&Scoped-define SELF-NAME br-dest-cust-naocfedade
&Scoped-define QUERY-STRING-br-dest-cust-naocfedade FOR EACH tt-dest-cust-naocfedade NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-dest-cust-naocfedade OPEN QUERY {&SELF-NAME} FOR EACH tt-dest-cust-naocfedade NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-dest-cust-naocfedade ~
tt-dest-cust-naocfedade
&Scoped-define FIRST-TABLE-IN-QUERY-br-dest-cust-naocfedade tt-dest-cust-naocfedade


/* Definitions for BROWSE br-histor-naocfedade                          */
&Scoped-define FIELDS-IN-QUERY-br-histor-naocfedade tt-histor-naocfedade.dat-histor fnAcaoHist(tt-histor-naocfedade.idi-tip-histor) tt-histor-naocfedade.cod-usuar fnNomeUser(tt-histor-naocfedade.cod-usuar) tt-histor-naocfedade.des-narrat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-histor-naocfedade   
&Scoped-define SELF-NAME br-histor-naocfedade
&Scoped-define QUERY-STRING-br-histor-naocfedade FOR EACH tt-histor-naocfedade NO-LOCK BY tt-histor-naocfedade.idi-tip-histor INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-histor-naocfedade OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-naocfedade NO-LOCK BY tt-histor-naocfedade.idi-tip-histor INDEXED-REPOSITION .
&Scoped-define TABLES-IN-QUERY-br-histor-naocfedade tt-histor-naocfedade
&Scoped-define FIRST-TABLE-IN-QUERY-br-histor-naocfedade tt-histor-naocfedade


/* Definitions for BROWSE br-naocfedade-carg                            */
&Scoped-define FIELDS-IN-QUERY-br-naocfedade-carg tt-naocfedade-carg.cdn-naocfedade fnTipoNaoCfedade(tt-naocfedade-carg.idi-tip-naocfedade) @ c-tipo-nc-brw tt-naocfedade-carg.num-carg fnItem(tt-naocfedade-carg.num-carg) @ c-it-codigo-brw tt-naocfedade-carg.cod-pto-coleta tt-naocfedade-carg.cdn-compart tt-naocfedade-carg.dat-trans tt-naocfedade-carg.val-quant fnSituacaoNaocfedade(tt-naocfedade-carg.cdn-sit) @ c-situacao-brw   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-naocfedade-carg   
&Scoped-define SELF-NAME br-naocfedade-carg
&Scoped-define QUERY-STRING-br-naocfedade-carg FOR EACH tt-naocfedade-carg NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-naocfedade-carg OPEN QUERY {&SELF-NAME} FOR EACH tt-naocfedade-carg NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-naocfedade-carg tt-naocfedade-carg
&Scoped-define FIRST-TABLE-IN-QUERY-br-naocfedade-carg tt-naocfedade-carg


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-naocfedade-carg}

/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-histor-naocfedade}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-dest-cust-naocfedade}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define ENABLED-TABLES tt-estabelec
&Scoped-define FIRST-ENABLED-TABLE tt-estabelec
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 RECT-1 btSelecao btAtualiza ~
btReabertura btEncerrar btExit btHelp br-naocfedade-carg fi-des-naocfedade 
&Scoped-Define DISPLAYED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define DISPLAYED-TABLES tt-estabelec
&Scoped-define FIRST-DISPLAYED-TABLE tt-estabelec
&Scoped-Define DISPLAYED-OBJECTS fi-des-naocfedade 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAcaoHist wWindow 
FUNCTION fnAcaoHist RETURNS CHARACTER
     ( iAcaoHist AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaDesc wWindow 
FUNCTION fnBuscaDesc RETURNS CHARACTER
  ( cCodigoEvento AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wWindow 
FUNCTION fnItem RETURNS CHARACTER
  ( i-num-carg AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeFornecedor wWindow 
FUNCTION fnNomeFornecedor RETURNS CHARACTER
  (  cNomeFornecedor AS INT  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeUser wWindow 
FUNCTION fnNomeUser RETURNS CHARACTER
  ( cCodUser AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPenalizado wWindow 
FUNCTION fnPenalizado RETURNS CHARACTER
  ( pc-propried AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacaoNaocfedade wWindow 
FUNCTION fnSituacaoNaocfedade RETURNS CHARACTER PRIVATE
    ( iSituacaoNaocfedade AS INT ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoNaocfedade wWindow 
FUNCTION fnTipoNaocfedade RETURNS CHARACTER
  ( iTipoNaocfedade AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile        
       MENU-ITEM mi_param_selec LABEL "&Sele‡Æo/Parƒmetros" ACCELERATOR "CTRL-S"
       MENU-ITEM mi_atuliza     LABEL "&Atualizar"          ACCELERATOR "CTRL-R"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"               ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar":U.

DEFINE BUTTON btEncerrar 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "Atualiza":L 
     SIZE 4 BY 1.25 TOOLTIP "Encerrar NC":U.

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

DEFINE BUTTON btReabertura 
     IMAGE-UP FILE "image/im-undo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-undo.bmp":U
     LABEL "Reabrir":U 
     SIZE 4 BY 1.25 TOOLTIP "Reabrir NC":U.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "Sele‡Æo":U 
     SIZE 4 BY 1.25 TOOLTIP "Sele‡Æo/Parƒmetros":U.

DEFINE VARIABLE fi-des-naocfedade AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 117 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 117 BY 2.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 117 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-eliminar 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-eliminar-2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir-2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar-2 
     LABEL "Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dest-cust-naocfedade FOR 
      tt-dest-cust-naocfedade SCROLLING.

DEFINE QUERY br-histor-naocfedade FOR 
      tt-histor-naocfedade SCROLLING.

DEFINE QUERY br-naocfedade-carg FOR 
      tt-naocfedade-carg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dest-cust-naocfedade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dest-cust-naocfedade wWindow _FREEFORM
  QUERY br-dest-cust-naocfedade NO-LOCK DISPLAY
      tt-dest-cust-naocfedade.cdn-destin WIDTH 9
    fnNomeFornecedor(tt-dest-cust-naocfedade.cdn-destin) FORMAT "x(24)" COLUMN-LABEL "Nome" WIDTH 16
    fnPenalizado(tt-dest-cust-naocfedade.cod-propried) @ c-penalizado-brw FORMAT "x(24)" COLUMN-LABEL "Penalizado" WIDTH 16
    tt-dest-cust-naocfedade.cod-event-financ WIDTH 12
    fnBuscaDesc(tt-dest-cust-naocfedade.cod-event-financ) COLUMN-LABEL "Descri‡Æo" FORMAT "x(24)" WIDTH 20
    tt-dest-cust-naocfedade.dat-vencto WIDTH 14
    tt-dest-cust-naocfedade.val-dest  COLUMN-LABEL "Valor"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113.29 BY 6
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-histor-naocfedade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-histor-naocfedade wWindow _FREEFORM
  QUERY br-histor-naocfedade NO-LOCK DISPLAY
      tt-histor-naocfedade.dat-histor FORMAT "99/99/9999":U COLUMN-LABEL "Data":U
      fnAcaoHist(tt-histor-naocfedade.idi-tip-histor) FORMAT "x(16)":U WIDTH 21.14 COLUMN-LABEL "A‡Æo":U
      tt-histor-naocfedade.cod-usuar FORMAT "x(12)":U
      fnNomeUser(tt-histor-naocfedade.cod-usuar) FORMAT "x(32)" WIDTH 14.57 COLUMN-LABEL "Nome":U
      tt-histor-naocfedade.des-narrat FORMAT "x(2000)":U WIDTH 60
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113.14 BY 6
         FONT 1.

DEFINE BROWSE br-naocfedade-carg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-naocfedade-carg wWindow _FREEFORM
  QUERY br-naocfedade-carg NO-LOCK DISPLAY
      tt-naocfedade-carg.cdn-naocfedade FORMAT ">>>,>>>,>>9":U WIDTH 10 COLUMN-LABEL "NC":U
      fnTipoNaoCfedade(tt-naocfedade-carg.idi-tip-naocfedade) @ c-tipo-nc-brw FORMAT "x(16)" WIDTH 12 COLUMN-LABEL "Tipo":U
      tt-naocfedade-carg.num-carg FORMAT ">>>,>>>,>>9":U WIDTH 12 COLUMN-LABEL "Carga":U
      fnItem(tt-naocfedade-carg.num-carg) @ c-it-codigo-brw FORMAT "X(16)":U WIDTH 15 COLUMN-LABEL "Item":U
      tt-naocfedade-carg.cod-pto-coleta FORMAT "x(12)":U WIDTH 12 COLUMN-LABEL "Pto Coleta":U
      tt-naocfedade-carg.cdn-compart FORMAT ">>9":U WIDTH 12 COLUMN-LABEL "Compart.":U
      tt-naocfedade-carg.dat-trans FORMAT "99/99/9999":U WIDTH 13 COLUMN-LABEL "Data":U
      tt-naocfedade-carg.val-quant FORMAT ">>>>,>>>,>>9.9999":U WIDTH 12 COLUMN-LABEL "Quantidade":U
      fnSituacaoNaocfedade(tt-naocfedade-carg.cdn-sit) @ c-situacao-brw FORMAT "x(16)" WIDTH 23 COLUMN-LABEL "Situa‡Æo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 117 BY 8
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btSelecao AT ROW 1.21 COL 2.57 WIDGET-ID 8
     btAtualiza AT ROW 1.21 COL 7 WIDGET-ID 10
     btReabertura AT ROW 1.21 COL 100.86 HELP
          "Pr¢xima ocorrˆncia" WIDGET-ID 16
     btEncerrar AT ROW 1.21 COL 105.14 HELP
          "Pr¢xima ocorrˆncia" WIDGET-ID 12
     btExit AT ROW 1.21 COL 110 HELP
          "Sair"
     btHelp AT ROW 1.21 COL 114 HELP
          "Ajuda"
     tt-estabelec.cod-estabel AT ROW 3.33 COL 23.57 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-estabelec.nome AT ROW 3.33 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     br-naocfedade-carg AT ROW 5.08 COL 2 WIDGET-ID 200
     fi-des-naocfedade AT ROW 13.83 COL 2 NO-LABEL WIDGET-ID 28
     "Descri‡Æo:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 13.25 COL 2 WIDGET-ID 4
     rtToolBar-2 AT ROW 1.08 COL 2
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 119 BY 24.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-histor-naocfedade AT ROW 1.5 COL 1.86 WIDGET-ID 300
     bt-incluir AT ROW 7.67 COL 2.14 WIDGET-ID 2
     bt-modificar AT ROW 7.67 COL 12.14 WIDGET-ID 4
     bt-eliminar AT ROW 7.67 COL 22.14 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 17.13
         SIZE 115 BY 8.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     br-dest-cust-naocfedade AT ROW 1.5 COL 1.72 WIDGET-ID 400
     bt-incluir-2 AT ROW 7.67 COL 1.86 WIDGET-ID 2
     bt-modificar-2 AT ROW 7.67 COL 11.86 WIDGET-ID 4
     bt-eliminar-2 AT ROW 7.67 COL 21.86 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 17.17
         SIZE 115.14 BY 8.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-dest-cust-naocfedade T "?" NO-UNDO movind dest-cust-naocfedade
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-estabelec T "?" NO-UNDO mgind estabelec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-histor-naocfedade T "?" NO-UNDO movind histor-naocfedade
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-naocfedade-carg T "?" NO-UNDO movind naocfedade-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-naocfedade-carg-atual T "?" NO-UNDO movind naocfedade-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 24.75
         WIDTH              = 119
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-naocfedade-carg nome fpage0 */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-histor-naocfedade 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-dest-cust-naocfedade 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dest-cust-naocfedade
/* Query rebuild information for BROWSE br-dest-cust-naocfedade
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-dest-cust-naocfedade NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-dest-cust-naocfedade */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-histor-naocfedade
/* Query rebuild information for BROWSE br-histor-naocfedade
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-naocfedade NO-LOCK BY tt-histor-naocfedade.idi-tip-histor INDEXED-REPOSITION .
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-histor-naocfedade */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-naocfedade-carg
/* Query rebuild information for BROWSE br-naocfedade-carg
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-naocfedade-carg NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE br-naocfedade-carg */
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


&Scoped-define BROWSE-NAME br-naocfedade-carg
&Scoped-define SELF-NAME br-naocfedade-carg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-naocfedade-carg wWindow
ON ROW-DISPLAY OF br-naocfedade-carg IN FRAME fpage0
DO:
    DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

    CASE tt-naocfedade-carg.cdn-sit:
        WHEN 1 THEN ASSIGN i-cor = 12. /* vermelho */
        WHEN 2 THEN ASSIGN i-cor = 1 /*4*/ . /* amarelo */
        WHEN 3 THEN ASSIGN i-cor = /*10*/ 2 . /* verde */
    END CASE.




 ASSIGN /*tt-naocfedade-carg.cdn-naocfedade:BGCOLOR IN BROWSE br-naocfedade-carg = i-cor
        c-tipo-nc-brw:BGCOLOR IN BROWSE br-naocfedade-carg = i-cor
        tt-naocfedade-carg.num-carg:BGCOLOR IN BROWSE br-naocfedade-carg =  i-cor
        tt-naocfedade-carg.cod-pto-coleta:BGCOLOR IN BROWSE br-naocfedade-carg =  i-cor
        tt-naocfedade-carg.cdn-compart:BGCOLOR IN BROWSE br-naocfedade-carg = i-cor
        tt-naocfedade-carg.dat-trans:BGCOLOR IN BROWSE br-naocfedade-carg = i-cor
        tt-naocfedade-carg.val-quant:BGCOLOR IN BROWSE br-naocfedade-carg = i-cor*/
       c-situacao-brw:FGCOLOR IN BROWSE br-naocfedade-carg = i-cor.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-naocfedade-carg wWindow
ON VALUE-CHANGED OF br-naocfedade-carg IN FRAME fpage0
DO:
    IF br-naocfedade-carg:NUM-SELECTED-ROWS = 1 THEN DO:
        
        RUN piCarregaDesc.
        RUN piCarregaBrowseHist.
        RUN piVerificaButtons.
        RUN piVerificaFolder.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wWindow
ON CHOOSE OF bt-eliminar IN FRAME fPage1 /* Eliminar */
DO:
    RUN utp/ut-msgs.p ( INPUT "show":U, INPUT 550, INPUT "" ).
    IF  RETURN-VALUE = "no":U THEN
        RETURN NO-APPLY.
 
    IF VALID-HANDLE(h-boin01010) AND AVAIL tt-histor-naocfedade THEN DO:
        
        EMPTY TEMP-TABLE RowErrors                 NO-ERROR.
        RUN emptyRowErrors IN h-boin01010.                                      
        RUN goToKey        IN h-boin01010(INPUT tt-histor-naocfedade.cdn-naocfedade, INPUT tt-histor-naocfedade.cdn-histor).
        RUN deleteRecord   IN h-boin01010.
        RUN getRowErrors   IN h-boin01010 (OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="Yes"}
            {method/showmessage.i3}
            RETURN NO-APPLY.
        END.
    END.

    RUN piCarregaBrowseNaocfedade.
    RUN piCarregaBrowseHist.
    RUN piVerificaButtons.
    RUN piVerificaFolder.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-eliminar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-2 wWindow
ON CHOOSE OF bt-eliminar-2 IN FRAME fPage2 /* Eliminar */
DO:
    DEF VAR i-nr-pag AS INT NO-UNDO.

    RUN utp/ut-msgs.p ( INPUT "show":U, INPUT 550, INPUT "" ).
    IF  RETURN-VALUE = "no":U THEN
        RETURN NO-APPLY.

    IF VALID-HANDLE(h-boin01013) AND AVAIL tt-dest-cust-naocfedade THEN DO:
        
        EMPTY TEMP-TABLE RowErrors                 NO-ERROR.
        
        RUN emptyRowErrors IN h-boin01013.
        
        RUN repositionRecord IN h-boin01013(INPUT tt-dest-cust-naocfedade.r-rowid).
        RUN deleteRecord     IN h-boin01013.
        RUN getRowErrors     IN h-boin01013 (OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="Yes"}
            {method/showmessage.i3}
                RETURN NO-APPLY.
        END.
    END.
    
    RUN getCurrentFolder IN hFolder (OUTPUT i-nr-pag).
    RUN piCarregaBrowseNaocfedade.
    RUN piCarregaDesc.
    RUN piCarregaBrowseHist.
    RUN piVerificaButtons.
    RUN piVerificaFolder.
    RUN setFolder IN hFolder (INPUT i-nr-pag).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wWindow
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir */
DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.

    RUN aqp/AQ0318b.w (INPUT ?,
                       INPUT tt-naocfedade-carg.r-rowid,
                       INPUT "ADD":U,
                       INPUT THIS-PROCEDURE,
                       INPUT 1).
        
    RUN piCarregaBrowseNaocfedade.
    RUN piVerificaButtons.
    RUN piVerificaFolder.

    {&WINDOW-NAME}:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-incluir-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-2 wWindow
ON CHOOSE OF bt-incluir-2 IN FRAME fPage2 /* Incluir */
DO:
    DEF VAR i-nr-pag AS INT NO-UNDO.

    {&WINDOW-NAME}:SENSITIVE = FALSE.

    RUN aqp/AQ0318c.w (INPUT ?,
                       INPUT tt-naocfedade-carg.r-rowid,
                       INPUT "ADD":U,
                       INPUT THIS-PROCEDURE,
                       INPUT 1).
    
    RUN getCurrentFolder IN hFolder (OUTPUT i-nr-pag).
    RUN piCarregaBrowseNaocfedade.
    RUN piCarregaDesc.
    RUN piCarregaBrowseHist.
    RUN piVerificaButtons.
    RUN piVerificaFolder.
    RUN setFolder IN hFolder (INPUT i-nr-pag).

    {&WINDOW-NAME}:SENSITIVE = TRUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar wWindow
ON CHOOSE OF bt-modificar IN FRAME fPage1 /* Modificar */
DO:
    DEFINE VARIABLE  i-cdn-hist AS INT NO-UNDO.

    {&WINDOW-NAME}:SENSITIVE = FALSE.
    IF AVAIL tt-histor-naocfedade THEN DO:
        ASSIGN i-cdn-hist = tt-histor-naocfedade.cdn-histor.

        RUN aqp/AQ0318b.w (INPUT tt-histor-naocfedade.r-rowid,
                           INPUT tt-naocfedade-carg.r-rowid,
                           INPUT "UPDATE":U,
                           INPUT THIS-PROCEDURE,
                           INPUT 1).            
    
        IF RETURN-VALUE = "OK" THEN DO:
            RUN piCarregaBrowseNaocfedade.
            RUN piVerificaButtons.
            RUN piVerificaFolder.
        END.
        FOR FIRST tt-histor-naocfedade 
            WHERE tt-histor-naocfedade.cdn-histor = i-cdn-hist:
            REPOSITION br-histor-naocfedade TO ROWID ROWID(tt-histor-naocfedade). 
        END.
    END.
    {&WINDOW-NAME}:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-modificar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-2 wWindow
ON CHOOSE OF bt-modificar-2 IN FRAME fPage2 /* Modificar */
DO: 
    DEF VAR i-nr-pag AS INT NO-UNDO.

    {&WINDOW-NAME}:SENSITIVE = FALSE.
    
    RUN aqp/AQ0318c.w (INPUT tt-dest-cust-naocfedade.r-rowid,
                   INPUT tt-naocfedade-carg.r-rowid,
                   INPUT "UPDATE":U,
                   INPUT THIS-PROCEDURE,
                   INPUT 1).
    IF RETURN-VALUE = "OK" THEN DO:
        RUN getCurrentFolder IN hFolder (OUTPUT i-nr-pag).
        RUN piCarregaBrowseNaocfedade.
        RUN piCarregaDesc.
        RUN piCarregaBrowseHist.
        RUN piVerificaButtons.
        RUN piVerificaFolder.
        RUN setFolder IN hFolder (INPUT i-nr-pag).
    END.
    
    {&WINDOW-NAME}:SENSITIVE = TRUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0
OR CHOOSE OF MENU-ITEM mi_atuliza IN MENU smFile
DO:
    RUN piCarregaBrowseNaocfedade.
    RUN piCarregaDesc.
    RUN piCarregaBrowseHist.
    RUN piVerificaButtons.
    RUN piVerificaFolder.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEncerrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEncerrar wWindow
ON CHOOSE OF btEncerrar IN FRAME fpage0 /* Atualiza */
DO:
    RUN pi-resolver-nc IN THIS-PROCEDURE. /* RESOLVE */
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.
    RETURN "OK":U.
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


&Scoped-define SELF-NAME btReabertura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReabertura wWindow
ON CHOOSE OF btReabertura IN FRAME fpage0 /* Reabrir */
DO:
    RUN pi-reabrir-nc IN THIS-PROCEDURE. /* REABRE */
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.
    RETURN "OK":U.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wWindow
ON CHOOSE OF btSelecao IN FRAME fpage0 /* Sele‡Æo */
OR CHOOSE OF MENU-ITEM mi_param_selec IN MENU smFile
DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.

    RUN aqp/AQ0318a.w (INPUT-OUTPUT p-dif-quantidade,
                       INPUT-OUTPUT p-problema-qualidade,
                       INPUT-OUTPUT p-nao-coleta,
                       INPUT-OUTPUT p-pendente,            
                       INPUT-OUTPUT p-em-analise,          
                       INPUT-OUTPUT p-resolvida,           
                       INPUT-OUTPUT p-estabelecimento,     
                       INPUT-OUTPUT p-carga-ini,           
                       INPUT-OUTPUT p-carga-fim,           
                       INPUT-OUTPUT p-nao-conformidade-ini,
                       INPUT-OUTPUT p-nao-confirmidade-fim,
                       INPUT-OUTPUT p-data-ini,            
                       INPUT-OUTPUT p-data-fim ).           

    {&WINDOW-NAME}:SENSITIVE = TRUE.

    RUN piCarregaBrowseNaocfedade.
    RUN piBuscaEstabelec.
    RUN piCarregaDesc.
    RUN piCarregaBrowseHist.
    RUN piVerificaButtons.
    RUN piVerificaFolder.

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


&Scoped-define BROWSE-NAME br-dest-cust-naocfedade
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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

    IF VALID-HANDLE(h-boin01009) THEN DO:
        DELETE  PROCEDURE h-boin01009.
        ASSIGN h-boin01009 = ?.
    END.

    IF VALID-HANDLE(h-boin01010) THEN DO:
        DELETE  PROCEDURE h-boin01010.
        ASSIGN h-boin01010 = ?.
    END.

    IF VALID-HANDLE(h-boin01013) THEN DO:
        DELETE  PROCEDURE h-boin01013.
        ASSIGN h-boin01013 = ?.
    END.

    IF VALID-HANDLE(h-boin627zm) THEN DO:
        DELETE  PROCEDURE h-boin627zm.
        ASSIGN h-boin627zm = ?.
    END.
    
    IF VALID-HANDLE(h-boad098na) THEN DO:
        DELETE  PROCEDURE h-boad098na.
        ASSIGN h-boad098na = ?.
    END.
    
    IF VALID-HANDLE(h-apb061za) THEN DO:
        DELETE  PROCEDURE h-apb061za.
        ASSIGN h-apb061za = ?.
    END.

    IF VALID-HANDLE(h-boin00961) THEN DO:
        DELETE  PROCEDURE h-boin00961.
        ASSIGN h-boin00961 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Produtor * }
    ASSIGN c-penalizado[1] = RETURN-VALUE.
    {utp/ut-liter.i Transportador * }
    ASSIGN c-penalizado[2] = RETURN-VALUE.

    ASSIGN  p-dif-quantidade      = yes
            p-problema-qualidade  = yes
            p-nao-coleta          = yes
            p-pendente            = yes
            p-em-analise          = yes
            p-resolvida           = no
            p-carga-ini           = 0
            p-carga-fim           = 999999999
            p-nao-conformidade-ini = 0
            p-nao-confirmidade-fim = 999999999
            p-data-ini             = (TODAY - 30)
            p-data-fim             = TODAY.

    RUN piBuscaEstabelec.
    RUN piCarregaBrowseNaocfedade.
    RUN pi-verifica-consulta IN THIS-PROCEDURE.

    RUN pi-posiciona-carga IN THIS-PROCEDURE.
    IF AVAIL tt-naocfedade-carg THEN DO:

        RUN piBuscaEstabelec.
        RUN piCarregaDesc.
        RUN piCarregaBrowseHist.
        RUN piVerificaFolder.
    END.

    RUN piVerificaButtons.

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
    
    IF NOT VALID-HANDLE(h-boin01009) THEN DO:
        RUN inbo/boin01009.p PERSISTENT SET h-boin01009.
        IF VALID-HANDLE(h-boin01009) THEN
            RUN openQueryStatic IN h-boin01009(INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-boin01010) THEN DO:
        RUN inbo/boin01010.p PERSISTENT SET h-boin01010.
    END.

    IF NOT VALID-HANDLE(h-boin01013) THEN DO:
        RUN inbo/boin01013.p PERSISTENT SET h-boin01013.
    END.
    
    IF NOT VALID-HANDLE(h-boad107na) THEN DO:
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
        IF VALID-HANDLE(h-boad107na) THEN
            RUN openQueryStatic IN h-boad107na(INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-boin627zm) THEN DO:
        RUN inbo/boin627zm.p PERSISTENT SET h-boin627zm.
        IF VALID-HANDLE(h-boin627zm) THEN
            RUN openQueryStatic IN h-boin627zm (INPUT 'Default':U).
        RUN goToKey IN h-boin627zm (INPUT c-seg-usuario).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin627zm (INPUT "char-1":U, OUTPUT c-char-1).
            ASSIGN p-estabelecimento = SUBSTRING(c-char-1,16,5).
        END.
    END.
    
    IF NOT VALID-HANDLE(h-boad098na) THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
        IF VALID-HANDLE(h-boad098na) THEN
            RUN openQueryStatic IN h-boad098na(INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-boin00961) THEN DO:
        RUN inbo/boin00961.p PERSISTENT SET h-boin00961.
        IF VALID-HANDLE(h-boin00961) THEN
            RUN openQueryStatic IN h-boin00961(INPUT 'Main':U).
    END.

    IF NOT VALID-HANDLE(h-apb061za) THEN DO:
        RUN prgfin/apb/apb061za.p PERSISTENT SET h-apb061za.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOsonhandle wWindow 
PROCEDURE getDBOsonhandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Procedure necessária para inicialiar o dbo para a inclusão de registros
         no Browses filho(Movimentações/Penalizações)       
------------------------------------------------------------------------------*/


    DEFINE  INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.
    
    CASE pPageNumber:
            WHEN 1 THEN ASSIGN pDBOHandle = h-boin01010.
            WHEN 2 THEN ASSIGN pDBOHandle = h-boin01013.
    END CASE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wWindow 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Procedure que recebe os dados do atual registro da 
         tabela pai(naocfedade-carg)       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-naocfedade-carg-atual.

    EMPTY TEMP-TABLE tt-naocfedade-carg-atual.

    IF AVAIL tt-naocfedade-carg THEN DO:
        CREATE tt-naocfedade-carg-atual.
        BUFFER-COPY tt-naocfedade-carg TO tt-naocfedade-carg-atual.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-carga wWindow 
PROCEDURE pi-posiciona-carga :
/*------------------------------------------------------------------------------
  Purpose: POSICIONA CONFOMRE CARGA PASSADA VIA VARIAVEL SHARED    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_num-carg <> ? AND v_cod-estabel <> ? THEN DO:
        ASSIGN p-dif-quantidade = YES      
               p-problema-qualidade = YES   
               p-nao-coleta = YES           
               p-pendente = YES              
               p-em-analise = YES            
               p-resolvida = YES       
               p-estabelecimento = v_cod-estabel       
               p-carga-ini = v_num-carg           
               p-carga-fim = v_num-carg             
               p-nao-conformidade-ini = 0  
               p-nao-confirmidade-fim = 999999999 
               p-data-ini = DATE("01/01/1900")              
               p-data-fim = DATE("31/12/2099")
               v_cod-estabel = ?
               v_num-carg    = ?.

        APPLY 'CHOOSE' TO btAtualiza IN FRAME fPage0.

    END.                         

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reabrir-nc wWindow 
PROCEDURE pi-reabrir-nc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin01009) THEN DO:
        IF AVAIL tt-naocfedade-carg THEN DO:
            RUN emptyRowErrors IN h-boin01009.
            EMPTY TEMP-TABLE RowErrors no-error.
            EMPTY TEMP-TABLE row-errors-nc no-error.
            RUN reabrir-nc IN h-boin01009(INPUT tt-naocfedade-carg.cdn-naocfedade , OUTPUT TABLE row-errors-nc).
        END.

        FOR EACH row-errors-nc
           WHERE row-errors-nc.ErrorType <> "INTERNAL":U:
                CREATE RowErrors.
                BUFFER-COPY row-errors-nc TO RowErrors.
        END.  

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            RETURN "NOK".
        END. 
        
        {utp/ut-liter.i reaberta *}
        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 54894, /* Nao conformidade &1 &2*/
                          INPUT STRING(tt-naocfedade-carg.cdn-naocfedade) + "~~":U + RETURN-VALUE).

        APPLY 'CHOOSE' TO btAtualiza IN FRAME fPage0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-resolver-nc wWindow 
PROCEDURE pi-resolver-nc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin01009) THEN DO:
        IF AVAIL tt-naocfedade-carg THEN DO:

           EMPTY TEMP-TABLE RowErrors     NO-ERROR.
           EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
           RUN emptyRowErrors IN h-boin01009.
           RUN resolver-nc    IN h-boin01009(INPUT tt-naocfedade-carg.cdn-naocfedade,
                                             OUTPUT TABLE row-errors-nc).

        END.

        FOR EACH row-errors-nc
           WHERE row-errors-nc.ErrorType <> "INTERNAL":U:
            CREATE RowErrors.
            BUFFER-COPY row-errors-nc TO RowErrors.
        END.  

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            RETURN "NOK".
        END.  

        {utp/ut-liter.i resolvida *}
        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 54894, /* Nao conformidade &1 &2*/
                          INPUT STRING(tt-naocfedade-carg.cdn-naocfedade) + "~~":U + RETURN-VALUE).

        APPLY 'CHOOSE' TO btAtualiza IN FRAME fPage0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-consulta wWindow 
PROCEDURE pi-verifica-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF '{1}' = "aq0418" THEN DO:
        ASSIGN btReabertura:HIDDEN   IN FRAME fpage0 = YES
               btEncerrar:HIDDEN     IN FRAME fpage0 = YES
               btReabertura:HIDDEN   IN FRAME fpage0 = YES
               btEncerrar:HIDDEN     IN FRAME fpage0 = YES
               bt-incluir:HIDDEN     IN FRAME fpage1 = YES
               bt-modificar:HIDDEN   IN FRAME fpage1 = YES
               bt-eliminar:HIDDEN    IN FRAME fpage1 = YES
               bt-incluir-2:HIDDEN   IN FRAME fpage2 = YES
               bt-modificar-2:HIDDEN IN FRAME fpage2 = YES
               bt-eliminar-2:HIDDEN  IN FRAME fpage2 = YES.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEstabelec wWindow 
PROCEDURE piBuscaEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-estabelec AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-boad107na) THEN DO:                                       
        RUN goToKey IN h-boad107na(INPUT p-estabelecimento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Estabelecimento_padrÆo * }
            ASSIGN c-estabelec = RETURN-VALUE + "~~".
            {utp/ut-liter.i Usu rio_Materiais * }
            ASSIGN c-estabelec = c-estabelec + RETURN-VALUE + " (CD1700)":U.
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 34998, INPUT c-estabelec).
            RETURN NO-APPLY.
        END.
        
        RUN getCharField IN h-boad107na (INPUT "nome":U, OUTPUT c-estabelec).
        ASSIGN tt-estabelec.cod-estabel:SCREEN-VALUE IN FRAME fpage0 = p-estabelecimento
               tt-estabelec.nome:SCREEN-VALUE        IN FRAME fpage0 = c-estabelec.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaBrowseDest wWindow 
PROCEDURE piCarregaBrowseDest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin01013) THEN DO:
        IF AVAIL tt-naocfedade-carg THEN
            RUN setConstraintDest IN h-boin01013 (INPUT tt-naocfedade-carg.cdn-naocfedade).
        ELSE 
            RUN setConstraintDest IN h-boin01013 (INPUT 0).

            RUN openQueryStatic   IN h-boin01013 (INPUT "Dest":U) NO-ERROR.
    
            RUN getBatchRecords   IN h-boin01013 (INPUT ?,
                                                  INPUT NO,
                                                  INPUT 9999999,
                                                  OUTPUT i-rows-returned,
                                                  OUTPUT TABLE tt-dest-cust-naocfedade).

    END.

    {&OPEN-QUERY-br-dest-cust-naocfedade}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaBrowseHist wWindow 
PROCEDURE piCarregaBrowseHist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin01010) THEN DO:                                       
        IF AVAIL tt-naocfedade-carg THEN
            RUN setConstraintHist IN h-boin01010 (INPUT tt-naocfedade-carg.cdn-naocfedade).
        ELSE 
            RUN setConstraintHist IN h-boin01010 (INPUT 0).

        RUN openQueryStatic   IN h-boin01010 (INPUT "Hist":U) NO-ERROR.

        RUN getBatchRecords   IN h-boin01010 (INPUT ?,
                                              INPUT NO,
                                              INPUT 9999999,
                                              OUTPUT i-rows-returned,
                                              OUTPUT TABLE tt-histor-naocfedade).
    END.

    {&OPEN-QUERY-br-histor-naocfedade}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaBrowseNaocfedade wWindow 
PROCEDURE piCarregaBrowseNaocfedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cdn-naocfedade AS INTEGER  NO-UNDO.
                                          
    IF AVAIL tt-naocfedade-carg THEN
        ASSIGN i-cdn-naocfedade = tt-naocfedade-carg.cdn-naocfedade. 

    IF VALID-HANDLE(h-boin01009) THEN DO:
        RUN setConstraintNaocfedade IN h-boin01009(INPUT p-dif-quantidade,
                                                   INPUT p-problema-qualidade,
                                                   INPUT p-nao-coleta,
                                                   INPUT p-pendente,
                                                   INPUT p-em-analise,       
                                                   INPUT p-resolvida,           
                                                   INPUT p-estabelecimento,     
                                                   INPUT p-carga-ini,           
                                                   INPUT p-carga-fim,          
                                                   INPUT p-nao-conformidade-ini,
                                                   INPUT p-nao-confirmidade-fim,
                                                   INPUT p-data-ini,
                                                   INPUT p-data-fim).

        RUN openQueryStatic IN h-boin01009(INPUT 'Monitor':U).

        EMPTY TEMP-TABLE tt-naocfedade-carg NO-ERROR.

        RUN getBatchRecords IN h-boin01009(INPUT ?,
                                           INPUT NO,
                                           INPUT 9999999,
                                           OUTPUT i-rows-returned,
                                           OUTPUT TABLE tt-naocfedade-carg).
    END.

    {&OPEN-QUERY-br-naocfedade-carg}
    IF i-cdn-naocfedade > 0 THEN DO:
        IF CAN-FIND(FIRST tt-naocfedade-carg
                    WHERE tt-naocfedade-carg.cdn-naocfedade = i-cdn-naocfedade) THEN DO:
            FOR FIRST tt-naocfedade-carg
                WHERE tt-naocfedade-carg.cdn-naocfedade = i-cdn-naocfedade: 
                REPOSITION br-naocfedade-carg TO ROWID ROWID(tt-naocfedade-carg) NO-ERROR.
            END.
        END.           
    END.

    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDesc wWindow 
PROCEDURE piCarregaDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-naocfedade-carg THEN
        ASSIGN fi-des-naocfedade:SCREEN-VALUE IN FRAME fPage0 = tt-naocfedade-carg.des-naocfedade.
    ELSE        
        ASSIGN fi-des-naocfedade:SCREEN-VALUE IN FRAME fPage0 = "".
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaButtons wWindow 
PROCEDURE piVerificaButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-des-naocfedade:SENSITIVE IN FRAME fPage0 = YES
           fi-des-naocfedade:READ-ONLY IN FRAME fPage0 = YES.
    
    RUN pi-verifica-consulta IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN DO:
        IF AVAIL tt-naocfedade-carg THEN DO:
            IF tt-naocfedade-carg.cdn-sit <> 3 THEN
                ASSIGN btReabertura:SENSITIVE IN FRAME fpage0 = NO
                       btEncerrar:SENSITIVE IN FRAME fpage0 = YES.
            ELSE IF tt-naocfedade-carg.cdn-sit = 3 THEN
                ASSIGN btReabertura:SENSITIVE IN FRAME fpage0 = YES
                       btEncerrar:SENSITIVE IN FRAME fpage0 = NO
                       bt-incluir:SENSITIVE IN FRAME fpage1 = NO
                       bt-modificar:SENSITIVE IN FRAME fpage1 = NO
                       bt-eliminar:SENSITIVE IN FRAME fpage1 = NO
                       bt-incluir-2:SENSITIVE IN FRAME fpage2 = NO
                       bt-modificar-2:SENSITIVE IN FRAME fpage2 = NO
                       bt-eliminar-2:SENSITIVE IN FRAME fpage2 = NO.
        END.
        ELSE
            ASSIGN btReabertura:SENSITIVE IN FRAME fpage0 = NO
                   btEncerrar:SENSITIVE IN FRAME fpage0 = NO.
           
        /*Verifica Buttons do Browse br-histor-naocfedade*/        
        RUN piCarregaBrowseHist.
        
        IF NOT AVAIL tt-histor-naocfedade THEN
            ASSIGN bt-incluir:SENSITIVE IN FRAME fpage1 = YES
                   bt-modificar:SENSITIVE IN FRAME fpage1 = NO
                   bt-eliminar:SENSITIVE IN FRAME fpage1 = NO.
    
        IF AVAIL tt-histor-naocfedade THEN DO:
            
            ASSIGN bt-incluir:SENSITIVE IN FRAME fpage1 = YES
                   bt-modificar:SENSITIVE IN FRAME fpage1 = YES
                   bt-eliminar:SENSITIVE IN FRAME fpage1 = YES.
            FOR EACH tt-histor-naocfedade
                WHERE tt-histor-naocfedade.idi-tip-histor = 2 OR tt-histor-naocfedade.idi-tip-histor = 3:
                ASSIGN bt-incluir:SENSITIVE IN FRAME fpage1 = NO.
            END.
            
        END.
        /*FIM BUTTONS BROWSE HISTOR-NAOCFEDADE*/
        
        /*Verifica Buttons do Browse do folder 2*/
        RUN piCarregaBrowseDest.
        IF NOT AVAIL tt-dest-cust-naocfedade THEN
            ASSIGN bt-incluir-2:SENSITIVE   IN FRAME fpage2 = YES
                   bt-modificar-2:SENSITIVE IN FRAME fpage2 = NO
                   bt-eliminar-2:SENSITIVE  IN FRAME fpage2 = NO.
    
        IF AVAIL tt-dest-cust-naocfedade THEN
            ASSIGN bt-incluir-2:SENSITIVE IN FRAME fpage2 = YES
                   bt-modificar-2:SENSITIVE IN FRAME fpage2 = YES
                   bt-eliminar-2:SENSITIVE IN FRAME fpage2 = YES.
        /*FIM BUTTONS BROWSE dest-naocfedade*/
    
        IF fi-des-naocfedade:SCREEN-VALUE IN FRAME fpage0 = "" 
           AND NOT AVAIL tt-dest-cust-naocfedade
           AND NOT AVAIL tt-histor-naocfedade
           AND NOT AVAIL tt-naocfedade-carg THEN
            ASSIGN bt-incluir:SENSITIVE IN FRAME fpage1 = NO
                   bt-modificar:SENSITIVE IN FRAME fpage1 = NO
                   bt-eliminar:SENSITIVE IN FRAME fpage1 = NO
                   bt-incluir-2:SENSITIVE IN FRAME fpage2 = NO
                   bt-modificar-2:SENSITIVE IN FRAME fpage2 = NO
                   bt-eliminar-2:SENSITIVE IN FRAME fpage2 = NO.
    
        /*Verifica botäes se NC Resolvida*/
        IF AVAIL tt-naocfedade-carg THEN
            IF tt-naocfedade-carg.cdn-sit = 3 THEN
                ASSIGN btReabertura:SENSITIVE IN FRAME fpage0 = YES
                       btEncerrar:SENSITIVE IN FRAME fpage0 = NO
                       bt-incluir:SENSITIVE IN FRAME fpage1 = NO
                       bt-modificar:SENSITIVE IN FRAME fpage1 = NO
                       bt-eliminar:SENSITIVE IN FRAME fpage1 = NO
                       bt-incluir-2:SENSITIVE IN FRAME fpage2 = NO
                       bt-modificar-2:SENSITIVE IN FRAME fpage2 = NO
                       bt-eliminar-2:SENSITIVE IN FRAME fpage2 = NO.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaFolder wWindow 
PROCEDURE piVerificaFolder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR l-folder AS LOG NO-UNDO INITIAL NO.
    
    FOR EACH tt-histor-naocfedade:
        IF tt-histor-naocfedade.idi-tip-histor = 2 AND tt-naocfedade-carg.idi-tip-naocfedade <> 3 THEN
            ASSIGN l-folder = YES.
    END.

    IF valid-handle(hFolder) THEN
        RUN setEnabled IN hFolder (INPUT 2, INPUT l-folder).

    IF l-folder THEN
        RUN piCarregaBrowseDest.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecord wWindow 
PROCEDURE repositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF INPUT PARAM pr-rowid AS ROWID NO-UNDO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wWindow 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Reposiciona o registro dos Browses inferiores       
------------------------------------------------------------------------------*/


    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    CASE pPageNumber:
            WHEN 1 THEN RUN piCarregaBrowseHist.
            WHEN 2 THEN RUN piCarregaBrowseDest.
    END CASE.     

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAcaoHist wWindow 
FUNCTION fnAcaoHist RETURNS CHARACTER
     ( iAcaoHist AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Função para retornar a ação realizada a partir do inteiro da tabela
    Notes:  
------------------------------------------------------------------------------*/
    
    RETURN {ininc/i01in01010.i 04 iAcaoHist}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaDesc wWindow 
FUNCTION fnBuscaDesc RETURNS CHARACTER
  ( cCodigoEvento AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-desc-evento AS CHAR NO-UNDO.
    
    IF VALID-HANDLE(h-apb061za) THEN DO:
        RUN pi_retornar_dados_evento_financeiro in h-apb061za (INPUT cCodigoEvento, OUTPUT c-desc-evento).
    END.
    RETURN c-desc-evento.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wWindow 
FUNCTION fnItem RETURNS CHARACTER
  ( i-num-carg AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-boin00961) THEN DO:

        RUN goToKey IN h-boin00961(INPUT i-num-carg).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN  h-boin00961(INPUT "it-codigo", OUTPUT c-it-codigo).
    END.

    RETURN c-it-codigo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeFornecedor wWindow 
FUNCTION fnNomeFornecedor RETURNS CHARACTER
  (  cNomeFornecedor AS INT  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-nome-fornecedor AS CHAR NO-UNDO.
    
    RUN goToKey IN h-boad098na (INPUT cNomeFornecedor).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boad098na (INPUT "nome-abrev":U, OUTPUT c-nome-fornecedor).
        END.
        
    RETURN c-nome-fornecedor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeUser wWindow 
FUNCTION fnNomeUser RETURNS CHARACTER
  ( cCodUser AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST usuar_mestre NO-LOCK
       WHERE usuar_mestre.cod_usuario = cCodUser.
  IF AVAIL usuar_mestre THEN
      RETURN usuar_mestre.nom_usuario.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPenalizado wWindow 
FUNCTION fnPenalizado RETURNS CHARACTER
  ( pc-propried AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN IF pc-propried = "" THEN  c-penalizado[2] ELSE c-penalizado[1].   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacaoNaocfedade wWindow 
FUNCTION fnSituacaoNaocfedade RETURNS CHARACTER PRIVATE
    ( iSituacaoNaocfedade AS INT ):
/*------------------------------------------------------------------------------
  Purpose: Função para retornar a situação da não conformidade a partir 
           do inteiro da tabela  
    Notes:  
------------------------------------------------------------------------------*/
      
    RETURN {ininc/i02in01009.i 04 iSituacaoNaocfedade}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoNaocfedade wWindow 
FUNCTION fnTipoNaocfedade RETURNS CHARACTER
  ( iTipoNaocfedade AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Função para retornar o tipo da não conformidade a partir
           do inteiro da tabela 
    Notes:  
------------------------------------------------------------------------------*/

    RETURN {ininc/i01in01009.i 04 iTipoNaocfedade}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

