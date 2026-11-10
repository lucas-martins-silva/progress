&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-eqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-movto-km-eqpto NO-UNDO LIKE mab-movto-km-eqpto
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
{include/i-prgvrs.i AB0618 2.00.00.005 } /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0618 MAB}
&ENDIF
    {abp/ab0618.i1}                                             


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
&GLOBAL-DEFINE Program          AB0618
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Hist¢rico

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           yes

&GLOBAL-DEFINE AddParent        no
&GLOBAL-DEFINE CopyParent       no
&GLOBAL-DEFINE UpdateParent     no
&GLOBAL-DEFINE DeleteParent     no

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       no
&GLOBAL-DEFINE DeleteSon1       no

&GLOBAL-DEFINE ttParent         TTmab-eqpto
&GLOBAL-DEFINE hDBOParent       hDBOEqpto
&GLOBAL-DEFINE DBOParentTable   mab-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           TTmab-movto-km-eqpto
&GLOBAL-DEFINE hDBOSon1         hDBOMovtoKmEqpto
&GLOBAL-DEFINE DBOSon1Table     mab-movto-km-eqpto
&GLOBAL-DEFINE DBOSon1Destroy   YES
                                
&GLOBAL-DEFINE page0Fields      {&ttParent}.ep-codigo {&ttParent}.cod-eqpto {&ttParent}.idi-tip-eqpto {&ttParent}.log-cont-sec btImprimir btExcel
                                
&GLOBAL-DEFINE page1Browse      brSon1   

/* Global Variable Definitions ---                                      */
def new global shared var gr-mab-eqpto as rowid no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescUn    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescUnSec AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescTpDoc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.
/** Vari†veis Auxiliares no c†lculo do Percurso Per°odo **/
DEFINE VARIABLE Val1       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE Val2       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE Val3       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE Val4       AS DECIMAL    NO-UNDO.

/** Vari†veis do Filtro **/
DEF VAR vDataHoraInvertidaIni AS DECIMAL FORMAT "999999999999" no-undo.
DEF VAR vDataHoraInvertidafim AS DECIMAL FORMAT "999999999999" no-undo.
def var da-data-ini           as date    format "99/99/9999"   no-undo.
def var da-data-fim           as date    format "99/99/9999"   no-undo.
def var c-hora-ini            as char    format "99:99:99"     no-undo.
def var c-hora-fim            as char    format "99:99:99"     no-undo.
def var i-docto-ini           as integer                       no-undo.
def var i-docto-fim           as integer                       no-undo.
def var l-alterou             as logical                       no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.*/

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
&Scoped-define INTERNAL-TABLES TTmab-movto-km-eqpto

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 TTmab-movto-km-eqpto.dat-movto ~
TTmab-movto-km-eqpto.hra-inicial TTmab-movto-km-eqpto.val-hodom-horim ~
getDescUn ()  @ cDescUn TTmab-movto-km-eqpto.val-km-real ~
TTmab-movto-km-eqpto.val-livre-1 ~
getDescUnSec (TTmab-movto-km-eqpto.ep-codigo , TTmab-movto-km-eqpto.cod-eqpto)  @ cDescUnSec ~
TTmab-movto-km-eqpto.val-livre-2 TTmab-movto-km-eqpto.num-docto ~
getDescOrig (TTmab-movto-km-eqpto.idi-origem)  @ cDescTpDoc ~
TTmab-movto-km-eqpto.log-abastec-prim  ~
getDescStatus (TTmab-movto-km-eqpto.num-docto)  @ cDescStatus
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH TTmab-movto-km-eqpto NO-LOCK ~
    BY TTmab-movto-km-eqpto.val-dat-hora-invrtda DESCENDING
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmab-movto-km-eqpto NO-LOCK ~
    BY TTmab-movto-km-eqpto.val-dat-hora-invrtda DESCENDING.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmab-movto-km-eqpto
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmab-movto-km-eqpto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-eqpto.ep-codigo TTmab-eqpto.cod-eqpto ~
TTmab-eqpto.idi-tip-eqpto TTmab-eqpto.log-cont-sec 
&Scoped-define ENABLED-TABLES TTmab-eqpto
&Scoped-define FIRST-ENABLED-TABLE TTmab-eqpto
&Scoped-Define ENABLED-OBJECTS RECT-5 rtParent rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btParam btConsultEqpto btImprimir btExcel~
btQueryJoins btReportsJoins btExit btHelp cDescEqpto cDescPercurso cUnModel ~
cDescPercursoSec cUnModelSec 
&Scoped-Define DISPLAYED-FIELDS TTmab-eqpto.ep-codigo TTmab-eqpto.cod-eqpto ~
TTmab-eqpto.idi-tip-eqpto TTmab-eqpto.log-cont-sec 
&Scoped-define DISPLAYED-TABLES TTmab-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-eqpto
&Scoped-Define DISPLAYED-OBJECTS cDescEqpto cDescPercurso cUnModel ~
cDescPercursoSec cUnModelSec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescOrig wMasterDetail 
FUNCTION getDescOrig RETURNS CHARACTER
  ( pTipo as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescUN wMasterDetail 
FUNCTION getDescUN RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescUnSec wMasterDetail 
FUNCTION getDescUnSec RETURNS CHARACTER
&IF "{&mguni_version}" >= "2.071" &THEN
  (pEpCodigo AS CHARACTER , pCodEqpto AS CHARACTER  )  FORWARD.
&ELSE
  (pEpCodigo AS INTEGER , pCodEqpto AS CHARACTER  )  FORWARD.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescStatus wMasterDetail 
FUNCTION getDescStatus RETURNS CHARACTER
  (pNumDocto AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "Pr¢&ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM m_parametros   LABEL "Pa&rÉmetros"    ACCELERATOR "CTRL-K"
       MENU-ITEM m_Consulta_Equipamento LABEL "Co&nsulta Equipamento" ACCELERATOR "CTRL-E"
       RULE
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-P"
       MENU-ITEM miExcel        LABEL "&Exporta Excel"
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
DEFINE BUTTON btConsultEqpto 
     IMAGE-UP FILE "image/mab-eqpto.bmp":U
     LABEL "Consulta do Equipamento" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta do Equipamento"
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

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-param.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-param.bmp":U
     LABEL "ParÉmetros" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros"
     FONT 4.

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btExcel
     IMAGE-UP FILE "image/excel":U
     LABEL "Exporta Excel" 
     SIZE 4 BY 1.25 TOOLTIP "Exporta Dados Excel".

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

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.
DEFINE VARIABLE cDescStatus AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.


DEFINE VARIABLE cDescPercurso AS DECIMAL FORMAT "->,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Prim†rio" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cDescPercursoSec AS DECIMAL FORMAT "->,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Secund†rio" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cUnModel AS CHARACTER FORMAT "X(08)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cUnModelSec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDetalhe01 
     LABEL "&Consulta" 
     SIZE 10 BY 1 TOOLTIP "Consulta".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      TTmab-movto-km-eqpto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      TTmab-movto-km-eqpto.dat-movto FORMAT "99/99/9999":U
      TTmab-movto-km-eqpto.hra-inicial FORMAT "99:99:99":U
      TTmab-movto-km-eqpto.val-hodom-horim FORMAT ">,>>>,>>9.9":U
      getDescUn ()  @ cDescUn FORMAT "x(02)":U WIDTH 3
      TTmab-movto-km-eqpto.val-km-real FORMAT ">>,>>>,>>9.9":U
      TTmab-movto-km-eqpto.val-livre-1 COLUMN-LABEL "Contador Sec." FORMAT "->>>>>>>>>>>9.9":U
      getDescUnSec (TTmab-movto-km-eqpto.ep-codigo , TTmab-movto-km-eqpto.cod-eqpto)  @ cDescUnSec FORMAT "x(02)":U
      TTmab-movto-km-eqpto.val-livre-2 COLUMN-LABEL "Uso Real Sec." FORMAT "->>>>>>>>>>>9.9":U
      TTmab-movto-km-eqpto.num-docto FORMAT ">>>,>>>,>>9":U
      getDescOrig (TTmab-movto-km-eqpto.idi-origem)  @ cDescTpDoc FORMAT "x(10)":U
            WIDTH 10
      TTmab-movto-km-eqpto.log-abastec-prim FORMAT "Sim/N∆o":U
      getDescStatus(TTmab-movto-km-eqpto.num-docto)  @ cDescStatus FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.75
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
     btParam AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btConsultEqpto AT ROW 1.13 COL 35 HELP
          "Inclui nova ocorrància"
     btExcel AT ROW 1.13 COL 64.86 HELP
          "Exporta Excel"
     btImprimir AT ROW 1.13 COL 69.86 HELP
          "Impress∆o"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-eqpto.ep-codigo AT ROW 2.96 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-eqpto.cod-eqpto AT ROW 2.96 COL 22.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 2.96 COL 38.29 COLON-ALIGNED NO-LABEL
     TTmab-eqpto.idi-tip-eqpto AT ROW 4 COL 21.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"N∆o Motorizado", 2
          SIZE 25.29 BY .71
     TTmab-eqpto.log-cont-sec AT ROW 4 COL 51
          VIEW-AS TOGGLE-BOX
          SIZE 19.57 BY .71
     cDescPercurso AT ROW 5.38 COL 19 COLON-ALIGNED
     cUnModel AT ROW 5.38 COL 35 COLON-ALIGNED NO-LABEL
     cDescPercursoSec AT ROW 5.38 COL 55.14 COLON-ALIGNED
     cUnModelSec AT ROW 5.38 COL 71.14 COLON-ALIGNED NO-LABEL
     "Percurso Per°odo" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 4.92 COL 2.29
     RECT-5 AT ROW 5.17 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btDetalhe01 AT ROW 8.92 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.88
         SIZE 84.43 BY 9.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-eqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-movto-km-eqpto T "?" NO-UNDO movfro mab-movto-km-eqpto
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
         TITLE              = "Consulta do Hist¢rico da Vida do Equipamento"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 26.25
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.25
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.TTmab-movto-km-eqpto"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.TTmab-movto-km-eqpto.val-dat-hora-invrtda|no"
     _FldNameList[1]   = Temp-Tables.TTmab-movto-km-eqpto.dat-movto
     _FldNameList[2]   = Temp-Tables.TTmab-movto-km-eqpto.hra-inicial
     _FldNameList[3]   = Temp-Tables.TTmab-movto-km-eqpto.val-hodom-horim
     _FldNameList[4]   > "_<CALC>"
"getDescUn ()  @ cDescUn" ? "x(02)" ? ? ? ? ? ? ? no ? no no "3" yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.TTmab-movto-km-eqpto.val-km-real
     _FldNameList[6]   > Temp-Tables.TTmab-movto-km-eqpto.val-livre-1
"TTmab-movto-km-eqpto.val-livre-1" "Contador Sec." "->>>>>>>>>>>9.9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"getDescUnSec (TTmab-movto-km-eqpto.ep-codigo , TTmab-movto-km-eqpto.cod-eqpto)  @ cDescUnSec" ? "x(02)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.TTmab-movto-km-eqpto.val-livre-2
"TTmab-movto-km-eqpto.val-livre-2" "Uso Real Sec." "->>>>>>>>>>>9.9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   = Temp-Tables.TTmab-movto-km-eqpto.num-docto
     _FldNameList[10]   > "_<CALC>"
"getDescOrig (TTmab-movto-km-eqpto.idi-origem)  @ cDescTpDoc" ? "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[11]   = Temp-Tables.TTmab-movto-km-eqpto.log-abastec-prim
     _Query            is OPENED
*/  /* BROWSE brSon1 */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Consulta do Hist¢rico da Vida do Equipamento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Consulta do Hist¢rico da Vida do Equipamento */
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
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fPage1
DO:
    IF NOT AVAIL TTmab-movto-km-eqpto OR TTmab-movto-km-eqpto.idi-origem = 4 THEN 
        ASSIGN btDetalhe01:SENSITIVE IN FRAME fPage1 = NO.
    ELSE 
        ASSIGN btDetalhe01:SENSITIVE IN FRAME fPage1 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btConsultEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsultEqpto wMasterDetail
ON CHOOSE OF btConsultEqpto IN FRAME fPage0 /* Consulta do Equipamento */
OR CHOOSE OF MENU-ITEM m_Consulta_Equipamento IN MENU mbMain DO:
    assign {&window-name}:sensitive = no.
    run buscaRowidEqpto in this-procedure.
    if return-value = "OK":U then
       RUN abp/ab0602.w.
    assign {&window-name}:sensitive = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDetalhe01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe01 wMasterDetail
ON CHOOSE OF btDetalhe01 IN FRAME fPage1 /* Consulta */
DO:
    /*--- Executa programa de Detalhe de filho ---*/
    run buscaDetalhe IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wMasterDetail
ON CHOOSE OF btImprimir IN FRAME fPage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miImprimir  IN MENU smFile DO:
    run piImprimir in this-procedure.
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wMasterDetail
ON CHOOSE OF btExcel IN FRAME fPage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miExcel  IN MENU smFile DO:
    run piExcel in this-procedure.
    apply "ENTRY":U to btExcel in frame fPage0.
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


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wMasterDetail
ON CHOOSE OF btParam IN FRAME fPage0 /* ParÉmetros */
OR CHOOSE OF MENU-ITEM m_parametros IN MENU mbMain DO:
    
   assign {&window-name}:sensitive = no.
   /** Programa ParÉmetros **/
   run abp/ab0618a.w (input-output da-data-ini,  
                      input-output da-data-fim,  
                      input-output c-hora-ini,   
                      input-output c-hora-fim,   
                      input-output i-docto-ini,  
                      input-output i-docto-fim,  
                      output       l-alterou ).
   assign {&window-name}:sensitive = yes.
   apply "ENTRY":U to btParam in frame fPage0.
   /** Busca os registros **/
   if l-alterou then DO:
       /*:T Reposiciona registro com base em um rowid */
       RUN repositionRecord IN THIS-PROCEDURE (INPUT {&ttParent}.r-rowid).
       if return-value = "NOK":U then
           run getFirst in this-procedure.
   end.
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
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr007.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-eqpto.cod-eqpto wMasterDetail
ON LEAVE OF TTmab-eqpto.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
  assign cCodModelo = "":U.
  if avail {&ttParent} then
      assign cCodModelo = {&ttParent}.cod-model.

  FOR FIRST mab-model
      WHERE mab-model.cod-model = cCodModelo NO-LOCK:
      ASSIGN cDescEqpto:SCREEN-VALUE IN FRAME fPage0 = mab-model.des-model
             cUnModel:SCREEN-VALUE IN FRAME fPage0   = mab-model.un.
      IF mab-model.log-cont-sec THEN
          ASSIGN cUnModelSec:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(mab-model.cod-livre-1,1,2).
      ELSE
          ASSIGN cUnModelSec:SCREEN-VALUE IN FRAME fPage0 = "":U.
  END.
  IF NOT AVAIL mab-model THEN DO:
      {utp/ut-liter.i "Modelo N∆o Encontrado"}
      ASSIGN cDescEqpto:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE
             cUnModel:SCREEN-VALUE IN FRAME fPage0   = ""
             cUnModelSec:SCREEN-VALUE IN FRAME fPage0   = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

{abp/ab9000.i}  /** Calculo para Data e Hora Invertida **/

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
/** Modelo Equipamento **/
/*if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.*/

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
/** Descriá‰es **/
apply "LEAVE":U to {&ttParent}.ep-codigo in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

/** Habilita/ Desabilita Bot‰es de inclus∆o dos browses **/
run piBotoes in this-procedure.

ASSIGN cDescPercurso    = 0
       Val1             = 0
       Val2             = 0.

/** Observaá∆o: O browse est† em ordem decrescente de data/hora, 
    ent∆o o primeiro registro Ç o £ltimo cadastrado **/
if avail {&ttSon1} then do:
    /** Pega Registro Inicial da Query **/
    run getFirst in {&hDBOSon1}.
    run getDecField in {&hDBOSon1} (input "val-km-real":U,
                                    output Val1).

    /** Pega Registro Final da Query **/
    run getLast in {&hDBOSon1}.
    run getDecField in {&hDBOSon1} (input "val-km-real":U,
                                    output Val2).

    /** Percurso do Per°odo Ç a diferenáa entre o final e o incial **/
    ASSIGN cDescPercurso    = Val1 - Val2.

end.
/** Mostra Percurso em tela **/
DISP cDescPercurso    WITH FRAME fPage0.

ASSIGN cDescPercursoSec    = 0
       Val3                = 0
       Val4                = 0.

if avail {&ttSon1} then do:
    /** Pega Registro Inicial da Query **/
    run getFirst in {&hDBOSon1}.
    run getDecField in {&hDBOSon1} (input "val-livre-2":U,
                                    output Val3).

    /** Pega Registro Final da Query **/
    run getLast in {&hDBOSon1}.
    run getDecField in {&hDBOSon1} (input "val-livre-2":U,
                                    output Val4).

    /** Percurso do Per°odo Ç a diferenáa entre o final e o incial **/
    ASSIGN cDescPercursoSec    = Val3 - Val4.

end.
/** Mostra Percurso em tela **/
DISP cDescPercursoSec WITH FRAME fPage0.

IF not(INPUT FRAME fPage0 TTmab-eqpto.log-cont-sec) then
    assign cUnModelSec:SCREEN-VALUE IN FRAME fPage0 = "":U.


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
/** Labels em tela **/
{utp/ut-liter.i "Un"}
assign cDescUn:label in browse brSon1 = trim(return-value).
{utp/ut-liter.i "Un_Sec"}
assign cDescUnSec:label in browse brSon1 = trim(return-value).
{utp/ut-liter.i "Origem"}
assign cDescTpDoc:label in browse brSon1 = trim(return-value).
{utp/ut-liter.i "Percurso Per°odo"}
assign cDescPercurso:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Consulta"}
assign btDetalhe01:label in frame fPage1 = "&":U + trim(return-value).
{utp/ut-liter.i "Abastecimento"}
assign TTmab-movto-km-eqpto.log-abastec-prim:label in browse brSon1 = trim(return-value).
{utp/ut-liter.i "Prim†rio"}
assign cDescPercurso:label in FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Secund†rio"}
assign cDescPercursoSec:label in FRAME fPage0 = trim(return-value).
{utp/ut-field.i movfro mab-abastec-lubrific idi-consist 1}
assign cDescStatus:label in browse brSon1 = trim(return-value).

ASSIGN btImprimir:SENSITIVE IN FRAME fPage0 = YES.
ASSIGN btExcel:SENSITIVE IN FRAME fPage0 = YES.

/** Carrega vari†veis do Filtro **/
assign vDataHoraInvertidaIni = 0
       vDataHoraInvertidafim = 0
       da-data-ini           = 01/01/1800
       da-data-fim           = 12/31/9999
       c-hora-ini            = "000000":U
       c-hora-fim            = "235959":U
       i-docto-ini           = 0
       i-docto-fim           = 999999999.

/** Reposiciona o Programa conforme uma vari†vel global **/
RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-mab-eqpto).

IF not(INPUT FRAME fPage0 TTmab-eqpto.log-cont-sec) then
    assign cUnModelSec:SCREEN-VALUE IN FRAME fPage0 = "":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDetalhe wMasterDetail 
PROCEDURE buscaDetalhe :
/*------------------------------------------------------------------------------
  Purpose:     buscaDetalhe
  Parameters:  <none>
  Notes:       Verifica qual o tipo de Movimento para chamar o detalhe
------------------------------------------------------------------------------*/
DEFINE VARIABLE hProgram AS HANDLE NO-UNDO.

if avail {&ttSon1} then do: 
    get current brSon1.
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&window-name}:sensitive = no.

    IF {&ttSon1}.num-docto > 0 THEN DO:
        case {&ttson1}.idi-origem:
            /** Abastecimento **/
            when 1 then do:
                for first mab-abastec-lubrific fields(num-docto)
                    where mab-abastec-lubrific.num-docto = {&ttSon1}.num-docto no-lock:
                    /*--- Executa programa de consulta ---*/
                    RUN abp/ab0611.w PERSISTENT SET hProgram.
                    
                    /** Validaá∆o do Handle **/
                    IF VALID-HANDLE(hProgram) AND
                       hProgram:Type = "PROCEDURE":U AND
                       hProgram:FILE-NAME = "abp/ab0611.w":U THEN do:
                        /*--- Inicializa programa de consulta ---*/
                        RUN initializeInterface IN hProgram.
                        /*:T Reposiciona registro com base em um rowid */
                        RUN repositionRecord IN hProgram (INPUT rowid(mab-abastec-lubrific)).
                    end.
                end.
            end.
            /** Pneus **/
            when 2 then do:
                for first mpn-movto-pneu fields(num-docto)
                    where mpn-movto-pneu.num-docto = {&ttSon1}.num-docto no-lock:
                    /*--- Executa programa de consulta ---*/
                    RUN pnp/pn0603.w PERSISTENT SET hProgram.
                    
                    /** Validaá∆o do Handle **/
                    IF VALID-HANDLE(hProgram) AND
                       hProgram:Type = "PROCEDURE":U AND
                       hProgram:FILE-NAME = "pnp/pn0603.w":U THEN do:
                        /*--- Inicializa programa de consulta ---*/
                        RUN initializeInterface IN hProgram.
                        /*:T Reposiciona registro com base em um rowid */
                        RUN repositionRecord IN hProgram (INPUT rowid(mpn-movto-pneu)).
                    end.
                end.
            end.
            /** Oficina **/
            when 3 then do:
                for first mmv-ord-manut fields(nr-ord-produ)
                    where mmv-ord-manut.nr-ord-produ = {&ttSon1}.num-docto no-lock:
                    /*--- Executa programa de consulta ---*/
                    RUN mvp/mv0606.w PERSISTENT SET hProgram.
                    
                    /** Validaá∆o do Handle **/
                    IF VALID-HANDLE(hProgram) AND
                       hProgram:Type = "PROCEDURE":U AND
                       hProgram:FILE-NAME = "mvp/mv0606.w":U THEN do:
                        /*--- Inicializa programa de consulta ---*/
                        RUN initializeInterface IN hProgram.
                        /*:T Reposiciona registro com base em um rowid */
                        RUN repositionRecord IN hProgram (INPUT rowid(mmv-ord-manut)).
                    end.
                end.
            end.
        end case.
    
        /** Espera pelo fechamento do programa **/
        wait-for "CLOSE":U of hProgram.
        if valid-handle(hProgram) then
            delete procedure hProgram.
    END.
    
    {&window-name}:sensitive = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    apply "ENTRY":U to btDetalhe01 in frame fPage1.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRowidEqpto wMasterDetail 
PROCEDURE buscaRowidEqpto :
/*------------------------------------------------------------------------------
  Purpose:     buscaRowidEqpto
  Parameters:  <none>
  Notes:       Guarda o rowid do equipamento atual em vari†vel global
------------------------------------------------------------------------------*/
if avail {&ttParent} then
    ASSIGN gr-mab-eqpto =  {&ttParent}.r-rowid.
else
    return "NOK":U.

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
    
    DEFINE VARIABLE cep-codigo   LIKE {&ttParent}.ep-codigo   NO-UNDO.
    DEFINE VARIABLE ccod-eqpto     LIKE {&ttParent}.cod-eqpto     NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cep-codigo      AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V† Para Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cep-codigo,
                                      input ccod-eqpto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Equipamento"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT trim(return-value)).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cep-codigo  
           ccod-eqpto    
           btGoToOK 
           btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

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
       {&hDBOParent}:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set {&hDBOParent}.
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado Combust°vel ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr060.p":U THEN DO:
        run frbo/bofr060.p persistent set {&hDBOSon1}.
    END.

    /*/*--- Modelo Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set hDBOModelo.
    END.
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.*/
      
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
/** Busca Data Hora Invertidas inicial e final para abrir a query **/
if da-data-ini <> ? and 
   da-data-fim <> ?  then do:
    run converteParaHoraInvertida (input  string(da-data-ini,"99/99/9999"),
                                   input  c-hora-ini,
                                   output vDataHoraInvertidaIni).
    run converteParaHoraInvertida (input  string(da-data-fim,"99/99/9999"),
                                   input  c-hora-fim,
                                   output vDataHoraInvertidafim).
    /** Seta as restriá‰es conforme filtro **/
    RUN  setConstraintParametros IN {&hDBOSon1} (input vDataHoraInvertidaIni,
                                                 input vDataHoraInvertidafim,
                                                 input i-docto-ini,  
                                                 input i-docto-fim) NO-ERROR.

    {masterdetail/openqueriesson.i &Parent="Eqpto"
                                   &Query="Parametros"
                                   &PageNumber="1"}
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
assign btDetalhe01:sensitive in frame fPage1    = yes
       btParam:sensitive in frame fPage0        = yes
       btConsultEqpto:sensitive in frame fPage0 = yes.

/** Habilita Somente se existir KM **/
if can-find(first {&ttSon1} no-lock) then
   assign btDetalhe01:sensitive in frame fPage1 = yes.
else    
   assign btDetalhe01:sensitive in frame fPage1 = no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wMasterDetail 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     piImprimir
  Parameters:  <none>
  Notes:       Chama tela de impress∆o de relat¢rio
------------------------------------------------------------------------------*/
assign {&window-name}:sensitive = no.
run abp/ab0618d.w (INPUT INPUT FRAME fPage0 {&ttPArent}.ep-codigo,
                   INPUT {&ttPArent}.cod-eqpto:SCREEN-VALUE IN FRAME fPage0,
                   INPUT da-data-ini,
                   INPUT da-data-fim,
                   INPUT c-hora-ini,
                   INPUT c-hora-fim,
                   INPUT i-docto-ini,
                   INPUT i-docto-fim).

assign {&window-name}:sensitive = yes.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wMasterDetail 
PROCEDURE piExcel :
/*------------------------------------------------------------------------------
  Purpose:     piImprimir
  Parameters:  <none>
  Notes:       Chama tela de impress∆o de relat¢rio
------------------------------------------------------------------------------*/
/****************************************************************************/
    EMPTY TEMP-TABLE tt-digita.
    EMPTY TEMP-TABLE tt-param.

    create tt-param.
    assign tt-param.destino         = 3
           tt-param.usuario         = c-seg-usuario
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.lParam          = NO
           tt-param.lGeraExcel      = YES
           tt-param.arquivo         = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U
           tt-param.arquivoExcel    = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".csv":U
           tt-param.ep-codigo       = INPUT FRAME fPage0 {&ttPArent}.ep-codigo
           tt-param.cod-eqpto       = {&ttPArent}.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
           tt-param.data-ini        = da-data-ini 
           tt-param.data-fim        = da-data-fim 
           tt-param.hora-ini        = c-hora-ini 
           tt-param.hora-fim        = c-hora-fim 
           tt-param.docto-ini       = i-docto-ini
           tt-param.docto-fim       = i-docto-fim.


DEFINE VARIABLE raw-param AS RAW NO-UNDO.
RAW-TRANSFER tt-param TO raw-param.

RUN abp/ab0618rp.p  (INPUT       raw-param,
                     INPUT TABLE tt-raw-digita).

RUN utp/ut-msgs.p ( INPUT "SHOW",
                    INPUT 17567,
                    INPUT "Gerado Arquivo:" + tt-param.arquivoExcel).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescOrig wMasterDetail 
FUNCTION getDescOrig RETURNS CHARACTER
  ( pTipo as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  getDescOrig
    Notes:  Busca o tipo de documento de origem do movimento de KM
------------------------------------------------------------------------------*/
DEFINE VARIABLE pDesc AS CHARACTER  NO-UNDO.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {frinc/i00fr060.i 04 pTipo}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  pDesc = RETURN-VALUE.
&else
    ASSIGN pDesc = {frinc/i00fr060.i 04 pTipo}.
&endif

  RETURN pDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescUN wMasterDetail 
FUNCTION getDescUN RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  getDescUN
    Notes:  Busca a unidade 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.
if avail {&ttParent} then do:
      assign cCodModelo = {&ttParent}.cod-model.

      FOR FIRST mab-model
          WHERE mab-model.cod-model = cCodModelo NO-LOCK:
          ASSIGN cRetorno = mab-model.un.
      END.
      IF NOT AVAIL mab-model THEN DO:
          ASSIGN cRetorno = "".
      END.
end.
        
  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescUnSec wMasterDetail 
FUNCTION getDescUnSec RETURNS CHARACTER
&IF "{&mguni_version}" >= "2.071" &THEN
  (pEpCodigo AS CHARACTER , pCodEqpto AS CHARACTER  ) :
&ELSE
  (pEpCodigo AS INTEGER , pCodEqpto AS CHARACTER  ) :
&ENDIF
/*------------------------------------------------------------------------------
  Purpose:  getDescUnSec
    Notes:  Busca a unidade 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.
if  avail {&ttParent} then do:
    FIND FIRST mab-eqpto
         WHERE mab-eqpto.ep-codigo = pEpCodigo
           AND mab-eqpto.cod-eqpto = pCodEqpto
           AND mab-eqpto.log-cont-sec NO-LOCK NO-ERROR.
    IF  AVAIL mab-eqpto THEN DO:
        assign cCodModelo = {&ttParent}.cod-model.

        FOR FIRST mab-model
            WHERE mab-model.cod-model = cCodModelo NO-LOCK:
            ASSIGN cRetorno = SUBSTRING(mab-model.cod-livre-1, 1, 2).
        END.
        IF  NOT AVAIL mab-model THEN DO:
            ASSIGN cRetorno = "".
        END.
    END.
    ELSE
        ASSIGN cRetorno = "".
end.
        
  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescUN wMasterDetail 
/*------------------------------------------------------------------------------
------------------------------------------------------------------------------*/
FUNCTION getDescStatus RETURNS CHARACTER
  ( pNumDocto as integer ) :
    
    DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.
    for first mab-abastec-lubrific fields(num-docto idi-consist)
        where mab-abastec-lubrific.num-docto = pNumDocto no-lock:
        ASSIGN cRetorno = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
    END.
        
    RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

