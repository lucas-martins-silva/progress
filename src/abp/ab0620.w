&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttReserva NO-UNDO LIKE mab-reserva
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttViagem NO-UNDO LIKE mab-viagem
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
{include/i-prgvrs.i AB0620 2.00.00.004}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0620 MAB}
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
&GLOBAL-DEFINE Program          AB0620
&GLOBAL-DEFINE Version          2.00.00.002

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Reservas, Viagens

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             yes
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         ttEqpto
&GLOBAL-DEFINE hDBOParent       hDBPEqpto
&GLOBAL-DEFINE DBOParentTable   mab-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttReserva
&GLOBAL-DEFINE hDBOSon1         hDBOReserva
&GLOBAL-DEFINE DBOSon1Table     mab-reserva
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttViagem
&GLOBAL-DEFINE hDBOSon2         hDBOViagem
&GLOBAL-DEFINE DBOSon2Table     mab-viagem
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      ttEqpto.cod-eqpto ttEqpto.ep-codigo ttEqpto.cod-grp-eqpto ttEqpto.idi-tip-eqpto

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iEmp    LIKE mab-eqpto.ep-codigo         NO-UNDO.
DEFINE VARIABLE cEqpto  AS CHARACTER FORMAT "x(16)"      NO-UNDO.
DEFINE VARIABLE dataIni AS DATE      FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE dataFim AS DATE      FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE lOK     AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE c-cod-empresa LIKE empresa.ep-codigo     NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModel     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hPrograma     AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttReserva ttViagem

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttReserva.num-reserva ~
ttReserva.dat-reserva-inicial ttReserva.hra-reserva-inicial ~
ttReserva.dat-reserva-final ttReserva.hra-reserva-final ~
fnRetornaEmpresa (ttReserva.ep-codigo-matr) @ c-cod-empresa ~
ttReserva.cod-estabel-matr ttReserva.cod-matr ~
fnNomMotoris(ttReserva.cod-matr) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttReserva NO-LOCK ~
    BY ttReserva.val-dat-hora-invrtda-inic DESCENDING ~
       BY ttReserva.num-reserva
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttReserva NO-LOCK ~
    BY ttReserva.val-dat-hora-invrtda-inic DESCENDING ~
       BY ttReserva.num-reserva.
&Scoped-define TABLES-IN-QUERY-brSon1 ttReserva
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttReserva


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttViagem.num-viagem ~
ttViagem.dat-saida ttViagem.hra-saida ttViagem.dat-ret ttViagem.hra-ret ~
fnRetornaEmpresa (ttViagem.ep-codigo-matr) @ c-cod-empresa ~
ttViagem.cod-estabel-matr ttViagem.cod-matr fnNomMotoris(ttViagem.cod-matr) ~
ttViagem.cod-rota fnDescTrajeto(ttViagem.cod-rota) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttViagem NO-LOCK ~
    BY ttViagem.val-dat-hora-invrtda-inic DESCENDING ~
       BY ttViagem.num-viagem
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttViagem NO-LOCK ~
    BY ttViagem.val-dat-hora-invrtda-inic DESCENDING ~
       BY ttViagem.num-viagem.
&Scoped-define TABLES-IN-QUERY-brSon2 ttViagem
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttViagem


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.cod-grp-eqpto ttEqpto.idi-tip-eqpto 
&Scoped-define ENABLED-TABLES ttEqpto
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btFiltro btQueryJoins btReportsJoins btExit btHelp ~
fiDescModelo 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.cod-grp-eqpto ttEqpto.idi-tip-eqpto 
&Scoped-define DISPLAYED-TABLES ttEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescTrajeto wMasterDetail 
FUNCTION fnDescTrajeto RETURNS CHARACTER
  ( codRota AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomMotoris wMasterDetail 
FUNCTION fnNomMotoris RETURNS CHARACTER
  ( codMatr AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaEmpresa wMasterDetail 
FUNCTION fnRetornaEmpresa RETURNS CHARACTER
  (pEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF /* parameter-definitions */ )  FORWARD.

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
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
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
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDetalhe1 
     LABEL "&Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDetalhe2 
     LABEL "&Detalhar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttReserva SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttViagem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttReserva.num-reserva FORMAT ">>>>>>>>9":U
      ttReserva.dat-reserva-inicial FORMAT "99/99/9999":U
      ttReserva.hra-reserva-inicial FORMAT "99:99:99":U
      ttReserva.dat-reserva-final FORMAT "99/99/9999":U
      ttReserva.hra-reserva-final FORMAT "99:99:99":U
      fnRetornaEmpresa (ttReserva.ep-codigo-matr) @ c-cod-empresa COLUMN-LABEL "Emp"
            WIDTH 5.14
      ttReserva.cod-estabel-matr COLUMN-LABEL "Estab" FORMAT "x(5)":U
            WIDTH 5.43
      ttReserva.cod-matr FORMAT "x(10)":U
      fnNomMotoris(ttReserva.cod-matr) COLUMN-LABEL "Nome" FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.08
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttViagem.num-viagem FORMAT ">>>>>>>>9":U
      ttViagem.dat-saida FORMAT "99/99/9999":U
      ttViagem.hra-saida FORMAT "99:99:99":U
      ttViagem.dat-ret FORMAT "99/99/9999":U
      ttViagem.hra-ret FORMAT "99:99:99":U
      fnRetornaEmpresa (ttViagem.ep-codigo-matr) @ c-cod-empresa COLUMN-LABEL "Emp"
            WIDTH 4.43
      ttViagem.cod-estabel-matr COLUMN-LABEL "Estab" FORMAT "x(5)":U
            WIDTH 5.43
      ttViagem.cod-matr FORMAT "x(10)":U
      fnNomMotoris(ttViagem.cod-matr) COLUMN-LABEL "Nome" FORMAT "x(30)":U
      ttViagem.cod-rota FORMAT "x(12)":U
      fnDescTrajeto(ttViagem.cod-rota) COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.08
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
     btFiltro AT ROW 1.13 COL 25.72 HELP
          "V† Para"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttEqpto.ep-codigo AT ROW 2.83 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.83 COL 28.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescModelo AT ROW 2.83 COL 44.43 COLON-ALIGNED NO-LABEL
     ttEqpto.cod-grp-eqpto AT ROW 3.83 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttEqpto.idi-tip-eqpto AT ROW 4.75 COL 24 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"N∆o Motorizado", 2
          SIZE 28 BY .75
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btDetalhe1 AT ROW 10.29 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.13
         SIZE 84.43 BY 10.5
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btDetalhe2 AT ROW 10.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.13
         SIZE 84.43 BY 10.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttReserva T "?" NO-UNDO movfro mab-reserva
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttViagem T "?" NO-UNDO movfro mab-viagem
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
         TITLE              = ""
         HEIGHT             = 17
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
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttReserva"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttReserva.val-dat-hora-invrtda-inic|no,Temp-Tables.ttReserva.num-reserva|yes"
     _FldNameList[1]   = Temp-Tables.ttReserva.num-reserva
     _FldNameList[2]   = Temp-Tables.ttReserva.dat-reserva-inicial
     _FldNameList[3]   = Temp-Tables.ttReserva.hra-reserva-inicial
     _FldNameList[4]   = Temp-Tables.ttReserva.dat-reserva-final
     _FldNameList[5]   = Temp-Tables.ttReserva.hra-reserva-final
     _FldNameList[6]   > "_<CALC>"
"fnRetornaEmpresa (ttReserva.ep-codigo-matr) @ c-cod-empresa" "Emp" ? ? ? ? ? ? ? ? no "Empresa do Motorista" no no "5.14" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.ttReserva.cod-estabel-matr
"cod-estabel-matr" "Estab" "x(5)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" ""
     _FldNameList[8]   = Temp-Tables.ttReserva.cod-matr
     _FldNameList[9]   > "_<CALC>"
"fnNomMotoris(ttReserva.cod-matr)" "Nome" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttViagem"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttViagem.val-dat-hora-invrtda-inic|no,Temp-Tables.ttViagem.num-viagem|yes"
     _FldNameList[1]   = Temp-Tables.ttViagem.num-viagem
     _FldNameList[2]   = Temp-Tables.ttViagem.dat-saida
     _FldNameList[3]   = Temp-Tables.ttViagem.hra-saida
     _FldNameList[4]   = Temp-Tables.ttViagem.dat-ret
     _FldNameList[5]   = Temp-Tables.ttViagem.hra-ret
     _FldNameList[6]   > "_<CALC>"
"fnRetornaEmpresa (ttViagem.ep-codigo-matr) @ c-cod-empresa" "Emp" ? ? ? ? ? ? ? ? no "Empresa do Motorista" no no "4.43" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.ttViagem.cod-estabel-matr
"cod-estabel-matr" "Estab" "x(5)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" ""
     _FldNameList[8]   = Temp-Tables.ttViagem.cod-matr
     _FldNameList[9]   > "_<CALC>"
"fnNomMotoris(ttViagem.cod-matr)" "Nome" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[10]   = Temp-Tables.ttViagem.cod-rota
     _FldNameList[11]   > "_<CALC>"
"fnDescTrajeto(ttViagem.cod-rota)" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDetalhe1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe1 wMasterDetail
ON CHOOSE OF btDetalhe1 IN FRAME fPage1 /* Detalhar */
DO:
get current brSon1.
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
RUN abp~/ab0614.w PERSISTENT SET hPrograma.

/* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
IF VALID-HANDLE(hPrograma) AND
   hPrograma:Type = "PROCEDURE":U AND
   hPrograma:FILE-NAME = "abp/ab0614.w":U THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
    RUN initializeInterface IN hPrograma.

run setaReserva in hPrograma (input {&ttSon1}.r-rowid).

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
wait-for "CLOSE":U of hPrograma.
assign {&window-name}:sensitive = yes.

if valid-handle(hPrograma) then
    delete procedure hPrograma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDetalhe2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe2 wMasterDetail
ON CHOOSE OF btDetalhe2 IN FRAME fPage2 /* Detalhar */
DO:

get current brSon2.
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.
/*--- Executa programa de inclus∆o de filho ---*/
RUN abp~/ab0616.w PERSISTENT SET hPrograma.

/* alterado por Valdir (tech264) novo mÇtodo de teste do valid-handle */
IF VALID-HANDLE(hPrograma) AND
   hPrograma:Type = "PROCEDURE":U AND
   hPrograma:FILE-NAME = "abp/ab0616.w":U THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
    RUN initializeInterface IN hPrograma.

run setaViagem in hPrograma (input {&ttSon2}.r-rowid).

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).
wait-for "CLOSE":U of hPrograma.
assign {&window-name}:sensitive = yes.

if valid-handle(hPrograma) then
    delete procedure hPrograma.

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


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage0 /* Filtro */
OR CHOOSE OF MENU-ITEM miFiltro IN MENU mbMain DO:
    run piFiltro in this-procedure.
    apply "ENTRY":U to btFiltro in frame fPage0.
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
    {method/zoomreposition.i &ProgramZoom="frzoom~\z01fr007.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMasterDetail
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    if avail {&ttParent} then do:
        {method~\referenceFields.i
            &HandleDBOLeave="hDBOModel"
            &KeyValue1="{&ttParent}.cod-model"
            &FieldName1="des-model"
            &FieldScreen1="fiDescModelo"
            &Frame1="fPage0"}     
    end.
    else assign fiDescModelo:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
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
  Notes:       Overide ap¢s finalizaá∆o da tela
------------------------------------------------------------------------------*/
/** Modelo **/
IF VALID-HANDLE (hDBOModel) THEN
    RUN destroy IN hDBOModel.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.

if valid-handle(hPrograma) then
    run Destroy in hPrograma.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/

apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

assign btDetalhe1:sensitive in frame fPage1 = if avail {&ttSon1} 
                                              then yes
                                              else no
       btDetalhe2:sensitive in frame fPage2 = if avail {&ttSon2} 
                                              then yes
                                              else no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override Ap¢s inicializaá∆o da tela
------------------------------------------------------------------------------*/
if avail {&ttParent} then 
    assign btFiltro:sensitive in frame fPage0          = yes
           menu-item miFiltro:sensitive in menu mbMain = yes.
else 
    assign btFiltro:sensitive in frame fPage0          = no
           menu-item miFiltro:sensitive in menu mbMain = no.

{utp~/ut-liter.i "Sa°da"}
assign {&ttSon2}.dat-saida:label in browse brSon2 = trim(return-value).
{utp~/ut-liter.i "Retorno"}
assign {&ttSon2}.dat-ret:label in browse brSon2 = trim(return-value).
{utp~/ut-liter.i "Inicial"}
assign {&ttSon1}.dat-reserva-inicial:label in browse brSon1 = trim(return-value).
{utp~/ut-liter.i "Final"}
assign {&ttSon1}.dat-reserva-final:label in browse brSon1 = trim(return-value).
{utp~/ut-liter.i "Equipamento"}
assign ttEqpto.ep-codigo:label in FRAME fPage0 = trim(return-value).
{utp~/ut-liter.i "Grupo"}
assign ttEqpto.cod-grp-eqpto:label in FRAME fPage0 = trim(return-value).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
assign dataIni = 01/01/1800
       dataFim = 12/31/9999.

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
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp~/ut-liter.i "V† Para Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cep-codigo,
                                      input ccod-eqpto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp~/ut-liter.i "Equipamento"}
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
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo~/bofr007.p persistent set {&hDBOParent}.
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr062.p":U THEN DO:
        run frbo~/bofr062.p persistent set {&hDBOSon1}.
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo~\bofr064.p":U THEN DO:
        run frbo~/bofr064.p persistent set {&hDBOSon2}.
    END.
    
    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModel) OR
       hDBOModel:TYPE <> "PROCEDURE":U OR
       hDBOModel:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        RUN frbo~/bofr016.p PERSISTENT SET hDBOModel.
    END.
    RUN openQueryStatic IN hDBOModel (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo~\bofr017.p":U THEN DO:
        run frbo~/bofr017.p persistent set  hDBOMoto.
    END.
    
    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  <none>
  Notes:       Seta as restriá‰es nas BOs do filhos e abre a query
------------------------------------------------------------------------------*/
/** Restriá‰es de data **/
run setConstraintData in {&hDBOSon1} (input dataIni,
                                      input dataFim).
run setConstraintData in {&hDBOSon2} (input dataIni,
                                      input dataFim).
/** Restriá‰es do motorista **/
run setConstraintEmpEqpto in {&hDBOSon1} (input ttEqpto.ep-codigo, tteqpto.cod-eqpto).
run setConstraintEmpEqpto in {&hDBOSon2} (input ttEqpto.ep-codigo, tteqpto.cod-eqpto).

 
/** Restriá‰es padr‰es (Empresa/Equipamento) **/    
{masterdetail/openqueriesson.i &Parent="EmpEqpto"
                               &Query="EqptoData"
                               &PageNumber="1"}
                               
{masterdetail/openqueriesson.i &Parent="EmpEqpto"
                               &Query="EqptoData"
                               &PageNumber="2"}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltro wMasterDetail 
PROCEDURE piFiltro :
/*------------------------------------------------------------------------------
  Purpose:     piFiltro
  Parameters:  <none>
  Notes:       Chama programa de filtro e atualiza programa pai
------------------------------------------------------------------------------*/
DEFINE VARIABLE rGoTo AS ROWID      NO-UNDO.

if avail {&ttParent} then do:
    assign iEmp   = {&ttParent}.ep-codigo
           cEqpto = {&ttParent}.cod-eqpto.
end.

assign {&window-name}:sensitive = no.
/** Programa Atualizaá∆o **/
run abp~/ab0620a.w (input-output dataIni,
                   input-output dataFim,
                   output       lOK).

assign {&window-name}:sensitive = yes.
IF lOk THEN
    run openQueriesSon in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescTrajeto wMasterDetail 
FUNCTION fnDescTrajeto RETURNS CHARACTER
  ( codRota AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE returnValue AS CHARACTER  NO-UNDO.

  FOR FIRST mab-trajeto WHERE mab-trajeto.cod-rota = codRota NO-LOCK:
      ASSIGN returnValue = mab-trajeto.des-rota.
  END.

  RETURN returnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomMotoris wMasterDetail 
FUNCTION fnNomMotoris RETURNS CHARACTER
  ( codMatr AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE returnValue AS CHARACTER  NO-UNDO.
 FOR FIRST mab-motoris WHERE mab-motoris.cod-matr = codMatr:
     ASSIGN returnValue = mab-motoris.nom-motoris.
 END.

  RETURN returnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaEmpresa wMasterDetail 
FUNCTION fnRetornaEmpresa RETURNS CHARACTER
  (pEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &IF "{&mguni_version}" >= "2.071" &THEN
      ASSIGN c-cod-empresa = pEmp.
  &ELSE
      ASSIGN c-cod-empresa = pEmp.
  &ENDIF
  
  RETURN STRING(c-cod-empresa).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

