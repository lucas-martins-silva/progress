&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-abastec-lubrific NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAmostraOleo NO-UNDO LIKE mao-amostra-oleo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttComptmentoEqpto NO-UNDO LIKE mab-comptmento-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttItemLubrific NO-UNDO LIKE mab-item-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttMaoEnsaio NO-UNDO LIKE mao-ensaio
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttRestdoEnsaio NO-UNDO LIKE mao-restdo-ensaio
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0601 2.00.00.003} /*** "010003" 28/11/2023 20:51:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0601 MAO}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AO0601
&GLOBAL-DEFINE Version          2.00.00.003

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Ensaios, Lubrificaá‰es

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        no
&GLOBAL-DEFINE CopyParent       no
&GLOBAL-DEFINE UpdateParent     no
&GLOBAL-DEFINE DeleteParent     no

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       no
&GLOBAL-DEFINE DeleteSon1       no

&GLOBAL-DEFINE AddSon2          no
&GLOBAL-DEFINE CopySon2         no
&GLOBAL-DEFINE UpdateSon2       no
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         ttComptmentoEqpto
&GLOBAL-DEFINE hDBOParent       ComptmentoEqpto
&GLOBAL-DEFINE DBOParentTable   mab-comptmento-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttRestdoEnsaio
&GLOBAL-DEFINE hDBOSon1         hDBORestdoEnsaio
&GLOBAL-DEFINE DBOSon1Table     mao-restdo-ensaio
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttItemLubrific
&GLOBAL-DEFINE hDBOSon2         hDBOItemLubrific
&GLOBAL-DEFINE DBOSon2Table     mab-item-lubrific
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      ttComptmentoEqpto.ep-codigo ttComptmentoEqpto.cod-eqpto ttComptmentoEqpto.cod-comptmento ttComptmentoEqpto.cod-tip-mater 

&GLOBAL-DEFINE page1Browse      brSon1
&global-define VALUE-CHANGED1   yes  
&GLOBAL-DEFINE page2Browse      brSon2

&GLOBAL-DEFINE NumRowsReturned 100000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescEstado       AS CHARACTER  format "x(22)"        NO-UNDO.
DEFINE VARIABLE cDescEnsaio       AS CHARACTER  format "x(35)"        NO-UNDO.
DEFINE VARIABLE cAmostra          AS CHARACTER  format "x(35)"        NO-UNDO.
DEFINE variable dData             like mab-abastec-lubrific.dat-movto no-undo.
DEFINE VARIABLE lOK               AS LOGICAL initial no   NO-UNDO.
DEFINE VARIABLE idResultado       AS INTEGER    NO-UNDO.
DEFINE VARIABLE dDataInvIni       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dDataInvFim       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cModel            AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cMatl             AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cComptoEpto       AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE c-cod-ensaio      like {&ttSon1}.cod-ensaio  NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMatl    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCompto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOEnsaio    AS HANDLE     NO-UNDO.

def new global shared var gr-mab-eqpto       as rowid no-undo.


 /***** Temp de Seleá∆o para o Filtro de REsultados *******/

def temp-table ttSelecao no-undo
     field c-ensaio-ini     as char     initial "":U
     field c-ensaio-fim     as char     initial "ZZZZZZZZ":U
     field d-data-ini       as date     initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
     field d-data-fim       as date     initial 12/31/9999
     field i-lubrific-ini   as int      initial 0
     field i-lubrific-fim   as int      initial 999999999
     field c-evento-ini     as char     initial "":U
     field c-evento-fim     as char     initial "ZZZZZZZZ":U
     field c-item-ini       as char     initial "":U
     field c-item-fim       as char     initial "ZZZZZZZZZZZZZZZ":U
     field lPadrao          as logical  initial yes
     field lNPadrao         as logical  initial yes
     field lData            as logical  initial yes
     field lTexto           as logical  initial yes
     field lNumerico        as logical  initial yes 
     field lTabela          as logical  initial yes 
     field lAprovado        as logical  initial yes 
     field lReprovado       as logical  initial yes 
     field lPendente        as logical  initial yes 
     field lAprovUsuar      as logical  initial yes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttRestdoEnsaio ttItemLubrific

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ~
fnEnsaio (ttRestdoEnsaio.cod-ensaio) @ cDescEnsaio ~
fnEstado (ttRestdoEnsaio.idi-estado-ensaio) @ cDescEstado ~
ttRestdoEnsaio.dat-restdo-ensaio ttRestdoEnsaio.des-val-restdo ~
ttRestdoEnsaio.log-padrao ttRestdoEnsaio.num-amostra-oleo ~
fnAmostra (ttRestdoEnsaio.num-amostra-oleo) @ cAmostra ~
ttRestdoEnsaio.num-tabela ttRestdoEnsaio.des-val-min ~
ttRestdoEnsaio.des-val-max 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttRestdoEnsaio NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttRestdoEnsaio NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttRestdoEnsaio
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttRestdoEnsaio


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ~
fnData (ttItemLubrific.num-docto) @ dData ttItemLubrific.cod-evento ~
ttItemLubrific.val-quant ttItemLubrific.cd-tipo ttItemLubrific.it-codigo ~
ttItemLubrific.cod-amostra-fisic ttItemLubrific.num-docto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttItemLubrific NO-LOCK ~
    BY ttItemLubrific.num-docto
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttItemLubrific NO-LOCK ~
    BY ttItemLubrific.num-docto.
&Scoped-define TABLES-IN-QUERY-brSon2 ttItemLubrific
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttItemLubrific


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttComptmentoEqpto.ep-codigo ~
ttComptmentoEqpto.cod-eqpto ttComptmentoEqpto.cod-comptmento ~
ttComptmentoEqpto.cod-tip-mater 
&Scoped-define ENABLED-TABLES ttComptmentoEqpto
&Scoped-define FIRST-ENABLED-TABLE ttComptmentoEqpto
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
fiDescEqpto fiDescCompto fiDescMatl 
&Scoped-Define DISPLAYED-FIELDS ttComptmentoEqpto.ep-codigo ~
ttComptmentoEqpto.cod-eqpto ttComptmentoEqpto.cod-comptmento ~
ttComptmentoEqpto.cod-tip-mater 
&Scoped-define DISPLAYED-TABLES ttComptmentoEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttComptmentoEqpto
&Scoped-Define DISPLAYED-OBJECTS fiDescEqpto fiDescCompto fiDescMatl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAmostra wMasterDetail 
FUNCTION fnAmostra RETURNS CHARACTER
     ( pAmostra as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnData wMasterDetail 
FUNCTION fnData RETURNS DATE
  ( pDocto as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEnsaio wMasterDetail 
FUNCTION fnEnsaio RETURNS CHARACTER
  ( pEnsaio as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstado wMasterDetail 
FUNCTION fnEstado RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "P&r¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fiDescCompto AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMatl AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON BtDetalhe01 
     LABEL "&Detalhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Combust°veis".

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil":U
     IMAGE-INSENSITIVE FILE "image/ii-fil":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btDetalhe02 
     LABEL "D&etalhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Comp/Filho".

DEFINE BUTTON btFiltro2 
     IMAGE-UP FILE "image/im-fil":U
     IMAGE-INSENSITIVE FILE "image/ii-fil":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttRestdoEnsaio SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttItemLubrific SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      fnEnsaio (ttRestdoEnsaio.cod-ensaio) @ cDescEnsaio COLUMN-LABEL "Ensaio"
            WIDTH 20
      fnEstado (ttRestdoEnsaio.idi-estado-ensaio) @ cDescEstado COLUMN-LABEL "Estado"
            WIDTH 20
      ttRestdoEnsaio.dat-restdo-ensaio FORMAT "99/99/9999":U WIDTH 10
      ttRestdoEnsaio.des-val-restdo FORMAT "x(40)":U WIDTH 25
      ttRestdoEnsaio.log-padrao FORMAT "Sim/N∆o":U WIDTH 5
      ttRestdoEnsaio.num-amostra-oleo FORMAT ">>>,>>>,>>9":U WIDTH 9
      fnAmostra (ttRestdoEnsaio.num-amostra-oleo) @ cAmostra COLUMN-LABEL "N£mero Amostra"
            WIDTH 15
      ttRestdoEnsaio.num-tabela FORMAT ">>>>9":U WIDTH 8
      ttRestdoEnsaio.des-val-min FORMAT "x(60)":U WIDTH 25
      ttRestdoEnsaio.des-val-max FORMAT "x(60)":U WIDTH 25
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.58
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      fnData (ttItemLubrific.num-docto) @ dData COLUMN-LABEL "Data"
            WIDTH 10
      ttItemLubrific.cod-evento FORMAT "x(08)":U
      ttItemLubrific.val-quant COLUMN-LABEL "Quantidade" FORMAT ">,>>>,>>9.99":U
            WIDTH 13.86
      ttItemLubrific.cd-tipo FORMAT ">>,>>9":U
      ttItemLubrific.it-codigo FORMAT "x(16)":U
      ttItemLubrific.cod-amostra-fisic FORMAT "x(12)":U
      ttItemLubrific.num-docto FORMAT ">>>,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.58
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttComptmentoEqpto.ep-codigo AT ROW 2.75 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttComptmentoEqpto.cod-eqpto AT ROW 2.75 COL 21.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescEqpto AT ROW 2.75 COL 37.43 COLON-ALIGNED NO-LABEL
     ttComptmentoEqpto.cod-comptmento AT ROW 3.75 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fiDescCompto AT ROW 3.75 COL 26.43 COLON-ALIGNED NO-LABEL
     ttComptmentoEqpto.cod-tip-mater AT ROW 4.75 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     fiDescMatl AT ROW 4.75 COL 26.43 COLON-ALIGNED NO-LABEL
     rtParent AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.83
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     BtDetalhe01 AT ROW 9.79 COL 2.14
     btFiltro AT ROW 9.79 COL 80 HELP
          "Filtro"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.17
         SIZE 84.43 BY 10.21
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.25 COL 2
     btDetalhe02 AT ROW 9.83 COL 2
     btFiltro2 AT ROW 9.83 COL 80 HELP
          "Filtro"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.13
         SIZE 84.43 BY 10.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-abastec-lubrific T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAmostraOleo T "?" NO-UNDO movfro mao-amostra-oleo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttComptmentoEqpto T "?" NO-UNDO mgfro mab-comptmento-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttItemLubrific T "?" NO-UNDO movfro mab-item-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttMaoEnsaio T "?" NO-UNDO mgfro mao-ensaio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttRestdoEnsaio T "?" NO-UNDO movfro mao-restdo-ensaio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Hist¢rico dos Ensaios"
         HEIGHT             = 16.83
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttRestdoEnsaio"
     _Options          = "NO-LOCK"
     _TblOptList       = ",, FIRST"
     _FldNameList[1]   > "_<CALC>"
"fnEnsaio (ttRestdoEnsaio.cod-ensaio) @ cDescEnsaio" "Ensaio" ? ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnEstado (ttRestdoEnsaio.idi-estado-ensaio) @ cDescEstado" "Estado" ? ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.ttRestdoEnsaio.dat-restdo-ensaio
"ttRestdoEnsaio.dat-restdo-ensaio" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[4]   > Temp-Tables.ttRestdoEnsaio.des-val-restdo
"ttRestdoEnsaio.des-val-restdo" ? ? "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.ttRestdoEnsaio.log-padrao
"ttRestdoEnsaio.log-padrao" ? ? "logical" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.ttRestdoEnsaio.num-amostra-oleo
"ttRestdoEnsaio.num-amostra-oleo" ? ? "integer" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"fnAmostra (ttRestdoEnsaio.num-amostra-oleo) @ cAmostra" "N£mero Amostra" ? ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.ttRestdoEnsaio.num-tabela
"ttRestdoEnsaio.num-tabela" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[9]   > Temp-Tables.ttRestdoEnsaio.des-val-min
"ttRestdoEnsaio.des-val-min" ? ? "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" ""
     _FldNameList[10]   > Temp-Tables.ttRestdoEnsaio.des-val-max
"ttRestdoEnsaio.des-val-max" ? ? "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttItemLubrific"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttItemLubrific.num-docto|yes"
     _FldNameList[1]   > "_<CALC>"
"fnData (ttItemLubrific.num-docto) @ dData" "Data" ? ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.ttItemLubrific.cod-evento
     _FldNameList[3]   > Temp-Tables.ttItemLubrific.val-quant
"ttItemLubrific.val-quant" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.ttItemLubrific.cd-tipo
     _FldNameList[5]   = Temp-Tables.ttItemLubrific.it-codigo
     _FldNameList[6]   = Temp-Tables.ttItemLubrific.cod-amostra-fisic
     _FldNameList[7]   = Temp-Tables.ttItemLubrific.num-docto
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Consulta Hist¢rico dos Ensaios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Consulta Hist¢rico dos Ensaios */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
  {masterdetail/valuechanged.i &PageNumber="1"}
  if num-entries("brSon1":u) > 0 then do:
      assign c-cod-ensaio = "":U.
      if avail {&ttSon1} then do:
          get Current brSon1 no-lock.
          assign c-cod-ensaio = {&ttSon1}.cod-ensaio.
          run buscaResultado in  {&hDBOSon1} (input {&ttSon1}.cod-ensaio,
                                              output idResultado).
      end.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtDetalhe01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtDetalhe01 wMasterDetail
ON CHOOSE OF BtDetalhe01 IN FRAME fPage1 /* Detalhar */
DO:
 assign {&window-name}:sensitive = no.
    /*--- Executa programa de Detalhe de filho ---*/
     if INPUT FRAME fPage1 brSon1:num-selected-rows > 0  then do: 
            ASSIGN rSon = {&ttSon1}.r-Rowid.
            run setaRegistro in this-procedure (input rSon).
     END.
assign {&window-name}:sensitive = yes.
apply "ENTRY":U to btDetalhe01 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDetalhe02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe02 wMasterDetail
ON CHOOSE OF btDetalhe02 IN FRAME fPage2 /* Detalhar */
DO:
/*--- Seta cursor do mouse para espera ---*/
 assign {&window-name}:sensitive = no.
   if INPUT FRAME fPage2 brSon2:num-selected-rows  > 0 then do:
      if avail {&ttSon2} then do:
          get Current brSon2 no-lock.
          run buscaTabela in  {&hDBOSon2} (input {&ttSon2}.num-docto,
                                           output table tt-mab-abastec-lubrific).
          /** Detalhe Lubrificaá∆o **/
          find first tt-mab-abastec-lubrific no-lock no-error.
          run abp/ab0611b.w (input table tt-mab-abastec-lubrific,
                             input table {&ttSon2},
                             INPUT {&ttSon2}.r-rowid).
      end.
   end.
   assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btDetalhe02 in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage1 /* Filtro */
DO:

  assign {&window-name}:sensitive = no.
  run piFiltro in this-procedure (input 1).
  assign {&window-name}:sensitive = yes.

  apply "ENTRY":U to btFiltro in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btFiltro2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro2 wMasterDetail
ON CHOOSE OF btFiltro2 IN FRAME fPage2 /* Filtro */
DO:
  assign {&window-name}:sensitive = no.
  run piFiltro in this-procedure (input 2).
  assign {&window-name}:sensitive = yes.
  apply "ENTRY":U to btFiltro2 in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z02fr004.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttComptmentoEqpto.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttComptmentoEqpto.cod-comptmento wMasterDetail
ON LEAVE OF ttComptmentoEqpto.cod-comptmento IN FRAME fPage0 /* Compartimento */
DO:
  
       run buscaDescricaoCompto  IN {&hDBOParent} (input frame fPage0 {&ttParent}.cod-comptmento,
                                                   output cComptoEpto ).
      assign fiDescCompto:screen-value in frame fPage0 = cComptoEpto .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttComptmentoEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttComptmentoEqpto.cod-eqpto wMasterDetail
ON LEAVE OF ttComptmentoEqpto.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
  
  if input frame fPage0 {&ttParent}.ep-codigo <> &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
        and {&ttParent}.cod-eqpto:screen-value in frame fPage0 <> "":U  then do:
          run buscaDescricao  IN {&hDBOParent} (input frame fPage0 {&ttParent}.ep-codigo,
                                                input frame fPage0 {&ttParent}.cod-eqpto,
                                                output cModel).
         assign fiDescEqpto:screen-value in frame fPage0 = cModel.
      end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttComptmentoEqpto.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttComptmentoEqpto.cod-tip-mater wMasterDetail
ON LEAVE OF ttComptmentoEqpto.cod-tip-mater IN FRAME fPage0 /* Tipo Material */
DO:
  
       run buscaDescricaoMatl  IN {&hDBOParent} (input frame fPage0 {&ttParent}.cod-tip-mater,
                                               output cMatl).
     assign fiDescMatl:screen-value in frame fPage0 = cMatl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (Ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.


/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.

/** Material **/
if valid-handle(hDBOTpMatl) then
    run destroy in hDBOTpMatl.

/** Compartimento **/
if valid-handle(hDBOCompto) then
    run destroy in hDBOCompto.


/** Ensaio **/
if valid-handle(hDBOEnsaio) then
    run destroy in hDBOEnsaio.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display dos campos em tela
------------------------------------------------------------------------------*/

/** Descriá∆o Modelo **/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.
/*** Descriá∆o compartimento ***/
apply "LEAVE":U to {&ttParent}.cod-comptmento in frame fPage0.
/***** Descriá∆o Tipo de Material ****/
apply "LEAVE":U to {&ttParent}.cod-tip-mater in frame fPage0.
/** Habilita/ Desabilita Bot‰es de inclus∆o dos browses **/
run piBotoes in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o da tela
------------------------------------------------------------------------------*/

create ttSelecao.
assign ttSelecao.c-ensaio-ini   =  "":U                                                                         
       ttSelecao.c-ensaio-fim   =  "ZZZZZZZZ":U                                                                 
       ttSelecao.d-data-ini     =  &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF     
       ttSelecao.d-data-fim     =  12/31/9999                                                                   
       ttSelecao.i-lubrific-ini =  0                                                                            
       ttSelecao.i-lubrific-fim =  999999999                                                                    
       ttSelecao.c-evento-ini   =  "":U                                                                         
       ttSelecao.c-evento-fim   =  "ZZZZZZZZ":U                                                                 
       ttSelecao.c-item-ini     =  "":U                                                                         
       ttSelecao.c-item-fim     =  "ZZZZZZZZZZZZZZZ":U                                                          
       ttSelecao.lPadrao        =  yes                                                                          
       ttSelecao.lNPadrao       =  yes                                                                          
       ttSelecao.lData          =  yes                                                                          
       ttSelecao.lTexto         =  yes                                                                          
       ttSelecao.lNumerico      =  yes                                                                          
       ttSelecao.lTabela        =  yes                                                                          
       ttSelecao.lAprovado      =  yes                                                                          
       ttSelecao.lReprovado     =  yes                                                                          
       ttSelecao.lPendente      =  yes                                                                          
       ttSelecao.lAprovUsuar    =  yes.                                                                     
    
assign lOK = YES.
run openQueriesSon in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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

    define var iep-codigo      LIKE {&ttParent}.ep-codigo      view-as  fill-in  size  5.00 BY 0.88 no-undo.
    define var ccod-eqpto      LIKE {&ttParent}.cod-eqpto      view-as  fill-in  size  16.00 BY 0.88 no-undo.
    define var ccod-comptmento LIKE {&ttParent}.cod-comptmento view-as  fill-in  size  10.00 BY 0.88 no-undo.

    DEFINE FRAME fGoToRecord
        iep-codigo        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        ccod-comptmento   AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE return-value FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V†_Para_Compartimento_do_Equipamento *}
    assign frame fGoToRecord:title = return-value.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iep-codigo  ccod-eqpto ccod-comptmento.

        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (input iep-codigo,     
                                      input ccod-eqpto,      
                                      input ccod-comptmento). 
       IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Compartimento_do_Equipamento * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, input return-value ).

            RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE iep-codigo  ccod-eqpto ccod-comptmento  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaPrograma wMasterDetail 
PROCEDURE inicializaPrograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pep-codigo      LIKE {&ttParent}.ep-codigo  no-undo.
def input param pcod-eqpto      as char no-undo.
def input param pcod-comptmento as char no-undo.
DEFINE variable rGoTo  AS ROWID      NO-UNDO.
/*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
 RUN goToKey IN {&hDBOParent} (input pep-codigo,     
                               input pcod-eqpto,      
                               input pcod-comptmento).
 IF RETURN-VALUE = "NOK":U THEN DO:
     {utp/ut-liter.i Compartimento_do_Equipamento * }
     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
     RETURN NO-APPLY.
 END.

 /*:T Retorna rowid do registro corrente do DBO */
 RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

 /*:T Reposiciona registro com base em um rowid */
 RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr004a.p":U THEN DO:
        run frbo/bofr004a.p persistent set {&hDBOParent}.
    END.

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado Resultado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr106a.p":U THEN DO:
        run frbo/bofr106a.p persistent set {&hDBOSon1}.
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Lubrificaá∆o ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
        run frbo/bofr058.p persistent set {&hDBOSon2}. 
    END.

 /*:T--- Modelo ---*/   
   IF NOT VALID-HANDLE(hDBOModelo) OR                                
      hDBOModelo:TYPE <> "PROCEDURE":U OR                            
      hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:            
       run frbo/bofr016.p persistent set hDBOModelo.                 
   END.        
/*:T--- Equipamento ---*/   
   IF NOT VALID-HANDLE(hDBOEqpto) OR                                
      hDBOEqpto:TYPE <> "PROCEDURE":U OR                            
      hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:            
       run frbo/bofr007.p persistent set hDBOEqpto.                 
   END.                                                                


/*:T--- Tipo de Material ---*/   
   IF NOT VALID-HANDLE(hDBOTpMatl) OR                                
      hDBOTpMatl:TYPE <> "PROCEDURE":U OR                            
      hDBOTpMatl:FILE-NAME <> "frbo/bofr026.p":U THEN DO:            
       run frbo/bofr026.p persistent set hDBOTpMatl.       

   END.        
/*:T--- Compartimento ---*/   
   IF NOT VALID-HANDLE(hDBOCompto) OR                                
      hDBOCompto:TYPE <> "PROCEDURE":U OR                            
      hDBOCompto:FILE-NAME <> "frbo/bofr003.p":U THEN DO:            
       run frbo/bofr003.p persistent set hDBOCompto.                 
   END.                                                                

/*:T--- Ensaio ---*/   
   IF NOT VALID-HANDLE(hDBOEnsaio) OR                                
      hDBOEnsaio:TYPE <> "PROCEDURE":U OR                            
      hDBOEnsaio:FILE-NAME <> "frbo/bofr103.p":U THEN DO:            
       run frbo/bofr103.p persistent set hDBOEnsaio.                 
   END.                                                                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 if lOK then do:
   find first ttSelecao no-lock no-error.
    /** Restriá‰es por Ensaio **/
   run setConstraintFiltro in {&hDBOSon1} (input ttSelecao.lPadrao,     
                                           input ttSelecao.lNPadrao,    
                                           input ttSelecao.lData,       
                                           input ttSelecao.lTexto,      
                                           input ttSelecao.lNumerico,   
                                           input ttSelecao.lTabela,     
                                           input ttSelecao.lAprovado,   
                                           input ttSelecao.lReprovado,
                                           input ttSelecao.lAprovUsuar,  
                                           input ttSelecao.lPendente,   
                                           input ttSelecao.c-ensaio-ini,
                                           input ttSelecao.c-ensaio-fim,
                                           input ttSelecao.d-data-ini,  
                                           input ttSelecao.d-data-fim).  

    {masterdetail/openqueriesson.i &Parent="Amostra"
                                   &Query="Filtro"
                                   &PageNumber="1"}


     /***** Restriá‰es por Lubrificaá∆o ****/
   run setConstraintFiltro in {&hDBOSon2} (input ttSelecao.c-item-ini,
                                           input ttSelecao.c-item-fim,
                                           input ttSelecao.d-data-ini,
                                           input ttSelecao.d-data-fim,
                                           input ttSelecao.c-evento-ini,
                                           input ttSelecao.c-evento-fim,
                                           input ttSelecao.i-lubrific-ini,
                                           input ttSelecao.i-lubrific-fim).

    {masterdetail/openqueriesson.i &Parent="Amostra"
                                   &Query="Filtro"
                                   &PageNumber="2"}
end. /*if lOk*/
else do:

    {masterdetail/openqueriesson.i &Parent="Amostra"
                                   &Query="Filtro"
                                   &PageNumber="1"}


    {masterdetail/openqueriesson.i &Parent="Amostra"
                                   &Query="Filtro"
                                   &PageNumber="2"}

end.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBotoes wMasterDetail 
PROCEDURE piBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita Bot‰es de inclus∆o dos browses
------------------------------------------------------------------------------*/
assign btDetalhe01:sensitive in frame fPage1 = yes
       btDetalhe02:sensitive in frame fPage2 = yes
       btFiltro:sensitive in frame fPage1 = yes
       btFiltro2:sensitive in frame fPage2 = yes.


if num-results("brSon1":U) > 0 then
   assign btDetalhe01:sensitive in frame fPage1 = yes
          btFiltro:sensitive in frame fPage1    = yes.
          

else    
   assign btDetalhe01:sensitive in frame fPage1 = no.

if num-results("brSon2":U) > 0 then
   assign btDetalhe02:sensitive in frame fPage2 = yes.
else    
   assign btDetalhe02:sensitive in frame fPage2 = no.




return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltro wMasterDetail 
PROCEDURE piFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pPage as int no-undo.
DEFINE VARIABLE rGoTo AS ROWID      NO-UNDO.

assign lOK = no.
if pPage = 1  then do:
     run aop/ao0601a.w (input-output  table ttSelecao,
                        input-output lOK).

end.
else do:
 run aop/ao0601b.w (input-output  table ttSelecao,
                    input-output  lOK).

end.

run openQueriesSon in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaRegistro wMasterDetail 
PROCEDURE setaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pRowid as rowid no-undo.
DEFINE VARIABLE hProgram AS HANDLE NO-UNDO.
  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /*--- Executa programa de inclus∆o de filho ---*/
  RUN aop/ao0602.w PERSISTENT SET hProgram.
  /** Validaá∆o do Handle **/
  IF VALID-HANDLE(hProgram) AND
     hProgram:Type = "PROCEDURE":U AND
     hProgram:FILE-NAME = "aop/ao0602.w":U THEN do:
      /*--- Inicializa programa de inclus∆o de filho ---*/
      RUN initializeInterface IN hProgram.
      /*:T Reposiciona registro com base em um rowid */
      RUN repositionRecord IN hProgram (INPUT pRowid).
  end.
  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U).
  wait-for "CLOSE":U of hProgram.
  if valid-handle (hProgram) then
      delete procedure hProgram.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAmostra wMasterDetail 
FUNCTION fnAmostra RETURNS CHARACTER
     ( pAmostra as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iNumAmostra like mao-amostra-oleo.cod-amostra-fisic NO-UNDO.

if can-find (first mao-amostra-oleo
                   where mao-amostra-oleo.num-amostra-oleo = pAmostra ) then do:
  for  first mao-amostra-oleo      fields ( num-amostra-oleo cod-amostra-fisic )                      
          where mao-amostra-oleo.num-amostra-oleo = pAmostra no-lock:
  end.
  if avail mao-amostra-oleo then do:
      assign iNumAmostra = mao-amostra-oleo.cod-amostra-fisic.
      RETURN iNumAmostra.
  end.
  else do:
      RETURN "":U.   /* Function return value. */
  end.
end.
else do:
   RETURN "":U.   /* Function return value. */
end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnData wMasterDetail 
FUNCTION fnData RETURNS DATE
  ( pDocto as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE variable dDtMovto  like   mab-abastec-lubrific.dat-movto    NO-UNDO.
 if can-find  (mab-abastec-lubrific 
               where mab-abastec-lubrific.num-docto = pDocto no-lock  ) then do:
     for first mab-abastec-lubrific fields (num-docto dat-movto )                                 
         where mab-abastec-lubrific.num-docto = pDocto no-lock :
     end.
    if avail mab-abastec-lubrific then do:
       assign dDtMovto =  mab-abastec-lubrific.dat-movto.
       return dDtMovto.
    end.
end.
else do:
  RETURN ?.   /* Function return value. */
end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEnsaio wMasterDetail 
FUNCTION fnEnsaio RETURNS CHARACTER
  ( pEnsaio as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.

if can-find (first mao-ensaio 
                   where mao-ensaio.cod-ensaio = pEnsaio ) then do:
  for  first mao-ensaio      fields (des-ensaio cod-ensaio des-abrev )                      
          where mao-ensaio.cod-ensaio = pEnsaio no-lock:
  end.
  if avail mao-ensaio then do:
      assign cDesc = mao-ensaio.des-abrev.
      RETURN cDesc.
  end.
  else do:
      RETURN "".   /* Function return value. */
  end.
end.
else do:
   RETURN "".   /* Function return value. */
end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstado wMasterDetail 
FUNCTION fnEstado RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {frinc/i00fr105.i 04 pEstado }.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  cDesc = RETURN-VALUE.
&else
    ASSIGN cDesc = {frinc/i00fr105.i 04 pEstado }.
&endif


  RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

