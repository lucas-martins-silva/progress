&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-viagem NO-UNDO LIKE mab-viagem
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-viagem-implto NO-UNDO LIKE mab-viagem-implto
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
{include/i-prgvrs.i AB0616 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0616 MAB}
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
&GLOBAL-DEFINE Program          AB0616
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Implemento, Observa‡Æo

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
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

&GLOBAL-DEFINE ttParent         TTmab-viagem
&GLOBAL-DEFINE hDBOParent       hDBOViagem
&GLOBAL-DEFINE DBOParentTable   mab-viagem
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           TTmab-viagem-implto
&GLOBAL-DEFINE hDBOSon1         hDBOViagemImplto
&GLOBAL-DEFINE DBOSon1Table     mab-viagem-implto
&GLOBAL-DEFINE DBOSon1Destroy   YES


&GLOBAL-DEFINE page0Fields      TTmab-viagem.num-viagem TTmab-viagem.dat-saida ~
                                TTmab-viagem.hra-saida TTmab-viagem.ep-codigo ~
                                TTmab-viagem.cod-eqpto TTmab-viagem.cod-matr ~
                                TTmab-viagem.ep-codigo-matr TTmab-viagem.cod-estabel-matr~
                                TTmab-viagem.cod-rota TTmab-viagem.cod-usuar ~
                                TTmab-viagem.dat-atualiz TTmab-viagem.dat-ret ~
                                TTmab-viagem.hra-ret TTmab-viagem.num-reserva ~
                                TTmab-viagem.val-hodom-horim-final TTmab-viagem.val-hodom-horim-inicial
&GLOBAL-DEFINE page2Fields      TTmab-viagem.dsl-obs
&GLOBAL-DEFINE page1Browse      brSon1    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cDescModel AS CHARACTER FORMAT "x(35)" NO-UNDO.
DEFINE VARIABLE c-cod-empresa LIKE empresa.ep-codigo   NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModel     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTraj      AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES TTmab-viagem-implto

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ~
fnRetornaEmpresa (TTmab-viagem-implto.ep-codigo) @ c-cod-empresa ~
TTmab-viagem-implto.cod-eqpto ~
getDescModel ( TTmab-viagem-implto.ep-codigo ,                            TTmab-viagem-implto.cod-eqpto) @ cDescModel 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH TTmab-viagem-implto NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmab-viagem-implto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmab-viagem-implto
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmab-viagem-implto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-viagem.num-viagem ~
TTmab-viagem.num-reserva TTmab-viagem.dat-atualiz TTmab-viagem.dat-saida ~
TTmab-viagem.hra-saida TTmab-viagem.val-hodom-horim-inicial ~
TTmab-viagem.dat-ret TTmab-viagem.hra-ret ~
TTmab-viagem.val-hodom-horim-final TTmab-viagem.cod-rota ~
TTmab-viagem.ep-codigo TTmab-viagem.cod-eqpto TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.cod-usuar 
&Scoped-define ENABLED-TABLES TTmab-viagem
&Scoped-define FIRST-ENABLED-TABLE TTmab-viagem
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 rtParent rtToolBar btFirst ~
btPrev btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit ~
btHelp fiDescRota fiDescModelo fiDescMoto fiData fiContador 
&Scoped-Define DISPLAYED-FIELDS TTmab-viagem.num-viagem ~
TTmab-viagem.num-reserva TTmab-viagem.dat-atualiz TTmab-viagem.dat-saida ~
TTmab-viagem.hra-saida TTmab-viagem.val-hodom-horim-inicial ~
TTmab-viagem.dat-ret TTmab-viagem.hra-ret ~
TTmab-viagem.val-hodom-horim-final TTmab-viagem.cod-rota ~
TTmab-viagem.ep-codigo TTmab-viagem.cod-eqpto TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.cod-usuar 
&Scoped-define DISPLAYED-TABLES TTmab-viagem
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-viagem
&Scoped-Define DISPLAYED-OBJECTS fiDescRota fiDescModelo fiDescMoto fiData ~
fiContador 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaEmpresa wMasterDetail 
FUNCTION fnRetornaEmpresa RETURNS CHARACTER
  (pEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescModel wMasterDetail 
FUNCTION getDescModel RETURNS CHARACTER
  ( pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF, 
    pCodEqpto as CHAR )  FORWARD.

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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "Re&lat¢rios"   
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
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fiContador AS CHARACTER FORMAT "X(10)":U INITIAL "Contador" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiData AS CHARACTER FORMAT "X(10)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMoto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescRota AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30.86 BY 2.63.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.63.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      TTmab-viagem-implto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      fnRetornaEmpresa (TTmab-viagem-implto.ep-codigo) @ c-cod-empresa COLUMN-LABEL "Empresa"
            WIDTH 7.72
      TTmab-viagem-implto.cod-eqpto COLUMN-LABEL "Equipamento" FORMAT "x(16)":U
      getDescModel ( TTmab-viagem-implto.ep-codigo , 
                          TTmab-viagem-implto.cod-eqpto) @ cDescModel COLUMN-LABEL "Descri‡Æo"
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 82 BY 4.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-viagem.num-viagem AT ROW 2.83 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.num-reserva AT ROW 2.83 COL 47.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.dat-atualiz AT ROW 2.83 COL 78.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.dat-saida AT ROW 4.5 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-saida AT ROW 4.5 COL 30.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.val-hodom-horim-inicial AT ROW 4.5 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.dat-ret AT ROW 5.5 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-ret AT ROW 5.5 COL 30.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.val-hodom-horim-final AT ROW 5.5 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.cod-rota AT ROW 6.92 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescRota AT ROW 6.92 COL 30.86 COLON-ALIGNED HELP
          "Descri‡Æo do Trajeto" NO-LABEL
     TTmab-viagem.ep-codigo AT ROW 7.92 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-eqpto AT ROW 7.92 COL 25.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 7.92 COL 41.29 COLON-ALIGNED NO-LABEL
     TTmab-viagem.ep-codigo-matr AT ROW 8.92 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-estabel-matr AT ROW 8.92 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-matr AT ROW 8.92 COL 30.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMoto AT ROW 8.92 COL 40.86 COLON-ALIGNED NO-LABEL
     TTmab-viagem.cod-usuar AT ROW 8.92 COL 78.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiData AT ROW 3.83 COL 14.72 COLON-ALIGNED NO-LABEL
     fiContador AT ROW 3.83 COL 54.72 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.13 COL 15.14
     RECT-3 AT ROW 4.13 COL 54.57
     rtParent AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.13
         FONT 1.

DEFINE FRAME fPage2
     TTmab-viagem.dsl-obs AT ROW 1.17 COL 2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 82 BY 4.5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.3 SCROLLABLE 
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 11.3 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-viagem T "?" NO-UNDO movfro mab-viagem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-viagem-implto T "?" NO-UNDO movfro mab-viagem-implto
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
         TITLE              = "Controle de Viagens"
         HEIGHT             = 16.13
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
   Size-to-Fit                                                          */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fPage2:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.TTmab-viagem-implto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fnRetornaEmpresa (TTmab-viagem-implto.ep-codigo) @ c-cod-empresa" "Empresa" ? ? ? ? ? ? ? ? no "C¢digo da empresa do equipamento" no no "7.72" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.TTmab-viagem-implto.cod-eqpto
"cod-eqpto" "Equipamento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"getDescModel ( TTmab-viagem-implto.ep-codigo , 
                          TTmab-viagem-implto.cod-eqpto) @ cDescModel" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Controle de Viagens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Controle de Viagens */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    {method/zoomreposition.i &ProgramZoom="frzoom~\z01fr064.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-eqpto wMasterDetail
ON LEAVE OF TTmab-viagem.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    run buscaModelo in this-procedure.
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOModel"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-matr wMasterDetail
ON LEAVE OF TTmab-viagem.cod-matr IN FRAME fPage0 /* cod-matr */
DO:
  {method/ReferenceFields.i
      &HandleDBOLeave="hDBOMoto"
      &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo-matr"
      &KeyValue2="input frame fPage0 {&ttParent}.cod-estabel-matr"
      &KeyValue3="input frame fPage0 {&ttParent}.cod-matr"
      &FieldName1="nom-motoris"
      &FieldScreen1="fiDescMoto"
      &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-rota wMasterDetail
ON LEAVE OF TTmab-viagem.cod-rota IN FRAME fPage0 /* Trajeto */
DO:
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOTraj"
        &KeyValue1="input frame fPage0 {&ttParent}.cod-rota"
        &FieldName1="des-trajeto"
        &FieldScreen1="fiDescRota"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Overide ap¢s finaliza‡Æo da tela
------------------------------------------------------------------------------*/
/** Modelo **/
IF VALID-HANDLE (hDBOModel) THEN
    RUN destroy IN hDBOModel.
/** Equipamento **/
IF VALID-HANDLE (hDBOEqpto) THEN
    RUN destroy IN hDBOEqpto.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.
/** Trajeto **/
if valid-handle(hDBOTraj) then
    run Destroy in hDBOTraj.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL {&ttParent} THEN DO:

/** Descri‡äes **/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-rota  in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-matr  in frame fPage0.

display {&ttParent}.dsl-obs with frame fPage2.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp~/ut-liter.i Motorista }
ASSIGN TTmab-viagem.ep-codigo-matr:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp~/ut-liter.i Data }
ASSIGN fiData:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.
{utp~/ut-liter.i Sa¡da }
ASSIGN TTmab-viagem.dat-saida:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp~/ut-liter.i Retorno }
ASSIGN TTmab-viagem.dat-ret:LABEL IN FRAME fPage0 = RETURN-VALUE.

{utp~/ut-liter.i "Contador"}
assign fiContador = trim(return-value).
display fiData
        fiContador
    with frame fPage0.
{utp~/ut-liter.i "Inicial"}
assign {&ttParent}.val-hodom-horim-inicial:label in frame fPage0 = trim(return-value).
{utp~/ut-liter.i "Final"}
assign {&ttParent}.val-hodom-horim-final:label in frame fPage0 = trim(return-value).
{utp~/ut-liter.i "Descri‡Æo"}
assign cDescModel:label in browse brSon1 = trim(return-value).

ASSIGN TTmab-viagem.dsl-obs:SENSITIVE IN FRAME fPage2 = YES
       TTmab-viagem.dsl-obs:READ-ONLY IN FRAME fPage2 = YES.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMasterDetail 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method~\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttParent}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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

    DEFINE VARIABLE  iNrViagem LIKE  {&ttParent}.num-viagem
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        iNrViagem          AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Viagem" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Viagem"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iNrViagem .
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iNrViagem ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Viagem" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iNrViagem btGoToCancel btGoToOK
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr064.p":U THEN DO:
        RUN  frbo~/bofr064.p PERSISTENT SET  {&hDBOParent}.
    END.
 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr065.p":U THEN DO:
        RUN frbo~/bofr065.p PERSISTENT SET {&hDBOSon1}.
    END.
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModel) OR
       hDBOModel:TYPE <> "PROCEDURE":U OR
       hDBOModel:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        RUN frbo~/bofr016.p PERSISTENT SET hDBOModel.
    END.
    RUN openQueryStatic IN hDBOModel (INPUT "Main":U) NO-ERROR.

   
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo~/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.    
  
    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo~\bofr017.p":U THEN DO:
        run frbo~/bofr017.p persistent set  hDBOMoto.
    END.
    
    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Trajeto  ---*/
    IF NOT VALID-HANDLE(hDBOTraj) OR
       hDBOTraj:TYPE <> "PROCEDURE":U OR
       hDBOTraj:FILE-NAME <> "frbo~\bofr028.p":U THEN DO:
        run frbo~/bofr028.p persistent set  hDBOTraj.
    END.
    
    RUN openQueryStatic IN hDBOTraj (INPUT "Main":U) NO-ERROR.

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
    
{masterdetail/openqueriesson.i &Parent="Viagem"
                               &Query="Viagem"
                               &PageNumber="1"}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaViagem wMasterDetail 
PROCEDURE setaViagem :
/*------------------------------------------------------------------------------
  Purpose:     setViagem
  Parameters:  entrada pRowid = Rowid da tabela <mab-viagem>
  Notes:       Reposiciona o programa em um registro
------------------------------------------------------------------------------*/
define input parameter pRowid as rowid no-undo.

/*:T Reposiciona registro com base em um rowid */
RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
if return-value = "NOK" then
    RUN getFirst IN THIS-PROCEDURE.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescModel wMasterDetail 
FUNCTION getDescModel RETURNS CHARACTER
  ( pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF, 
    pCodEqpto as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  getDescModel
    Notes:  Busca a descri‡Æo do modelo do equipamento
------------------------------------------------------------------------------*/
def var cDesc as char FORMAT "x(30)" no-undo.

/** Busca Modelo no Equipamento **/
FOR FIRST mab-eqpto FIELDS (cod-model)
    WHERE mab-eqpto.ep-codigo =  pCodEmp 
    AND   mab-eqpto.cod-eqpto =  pCodEqpto NO-LOCK,
    /** Busca Decsri‡Æo do Equipamento **/
    FIRST mab-model FIELDS (des-model)
    WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:

    ASSIGN cDesc = mab-model.des-model.           

END.

  RETURN cDesc. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

