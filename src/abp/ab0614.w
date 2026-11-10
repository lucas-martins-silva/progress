&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-reserva NO-UNDO LIKE mab-reserva
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-reserva-implto NO-UNDO LIKE mab-reserva-implto
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
{include/i-prgvrs.i AB0614 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0614 MAB}
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
&GLOBAL-DEFINE Program          AB0614
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

&GLOBAL-DEFINE ttParent         TTmab-reserva
&GLOBAL-DEFINE hDBOParent       hDBOReserva
&GLOBAL-DEFINE DBOParentTable   mab-reserva
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           TTmab-reserva-implto
&GLOBAL-DEFINE hDBOSon1         hDBOReserImplto
&GLOBAL-DEFINE DBOSon1Table     mab-reserva-implto
&GLOBAL-DEFINE DBOSon1Destroy   YES


&GLOBAL-DEFINE page0Fields      TTmab-reserva.num-reserva TTmab-reserva.hra-reserva-inicial ~
                                TTmab-reserva.hra-reserva-final TTmab-reserva.dat-reserva-inicial ~
                                TTmab-reserva.dat-reserva-final TTmab-reserva.cod-eqpto ~
                                TTmab-reserva.ep-codigo TTmab-reserva.cod-matr ~
                                TTmab-reserva.ep-codigo-matr TTmab-reserva.cod-estabel-matr ~
                                TTmab-reserva.cod-rota-dest TTmab-reserva.cod-rota-orig ~
                                TTmab-reserva.cod-usuar TTmab-reserva.dat-atualiz ~
                                TTmab-reserva.val-km-estimad
&GLOBAL-DEFINE page2Fields      TTmab-reserva.dsl-obs

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
&Scoped-define INTERNAL-TABLES TTmab-reserva-implto

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ~
fnRetornaEmpresa (TTmab-reserva-implto.ep-codigo) @ c-cod-empresa ~
TTmab-reserva-implto.cod-eqpto ~
getDescModel (TTmab-reserva-implto.ep-codigo ,                           TTmab-reserva-implto.cod-eqpto) @ cDescModel 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH TTmab-reserva-implto NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmab-reserva-implto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmab-reserva-implto
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmab-reserva-implto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-reserva.num-reserva ~
TTmab-reserva.dat-atualiz TTmab-reserva.dat-reserva-inicial ~
TTmab-reserva.hra-reserva-inicial TTmab-reserva.dat-reserva-final ~
TTmab-reserva.hra-reserva-final TTmab-reserva.cod-rota-orig ~
TTmab-reserva.cod-rota-dest TTmab-reserva.ep-codigo TTmab-reserva.cod-eqpto ~
TTmab-reserva.val-km-estimad TTmab-reserva.cod-estabel-matr ~
TTmab-reserva.ep-codigo-matr TTmab-reserva.cod-matr TTmab-reserva.cod-usuar 
&Scoped-define ENABLED-TABLES TTmab-reserva
&Scoped-define FIRST-ENABLED-TABLE TTmab-reserva
&Scoped-Define ENABLED-OBJECTS RECT-2 rtParent rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
fiDescRotaO fiDescRotaD fiDescModel fiDescMoto fiData 
&Scoped-Define DISPLAYED-FIELDS TTmab-reserva.num-reserva ~
TTmab-reserva.dat-atualiz TTmab-reserva.dat-reserva-inicial ~
TTmab-reserva.hra-reserva-inicial TTmab-reserva.dat-reserva-final ~
TTmab-reserva.hra-reserva-final TTmab-reserva.cod-rota-orig ~
TTmab-reserva.cod-rota-dest TTmab-reserva.ep-codigo TTmab-reserva.cod-eqpto ~
TTmab-reserva.val-km-estimad TTmab-reserva.cod-estabel-matr ~
TTmab-reserva.ep-codigo-matr TTmab-reserva.cod-matr TTmab-reserva.cod-usuar 
&Scoped-define DISPLAYED-TABLES TTmab-reserva
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-reserva
&Scoped-Define DISPLAYED-OBJECTS fiDescRotaO fiDescRotaD fiDescModel ~
fiDescMoto fiData 

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
  ( &IF "{&mguni_version}" >= "2.071" &THEN pCodEmp AS CHAR &ELSE pCodEmp AS INT &ENDIF,
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

DEFINE VARIABLE fiData AS CHARACTER FORMAT "X(10)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 4.72 BY .67 NO-UNDO.

DEFINE VARIABLE fiDescModel AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMoto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescRotaD AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescRotaO AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 2.63.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 8.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      TTmab-reserva-implto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      fnRetornaEmpresa (TTmab-reserva-implto.ep-codigo) @ c-cod-empresa COLUMN-LABEL "Empresa"
            WIDTH 8
      TTmab-reserva-implto.cod-eqpto COLUMN-LABEL "Equipamento" FORMAT "x(16)":U
      getDescModel (TTmab-reserva-implto.ep-codigo ,
                          TTmab-reserva-implto.cod-eqpto) @ cDescModel COLUMN-LABEL "Descri‡Æo"
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 4
         FONT 2 ROW-HEIGHT-CHARS .46.


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
     TTmab-reserva.num-reserva AT ROW 2.75 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.dat-atualiz AT ROW 2.75 COL 53.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.dat-reserva-inicial AT ROW 4.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.hra-reserva-inicial AT ROW 4.33 COL 40.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.dat-reserva-final AT ROW 5.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.hra-reserva-final AT ROW 5.33 COL 40.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.cod-rota-orig AT ROW 6.79 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescRotaO AT ROW 6.79 COL 23.57 COLON-ALIGNED HELP
          "Descri‡Æo do Trajeto" NO-LABEL
     TTmab-reserva.cod-rota-dest AT ROW 7.79 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescRotaD AT ROW 7.79 COL 23.57 COLON-ALIGNED HELP
          "Descri‡Æo do Trajeto" NO-LABEL
     TTmab-reserva.ep-codigo AT ROW 8.79 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-reserva.cod-eqpto AT ROW 8.79 COL 18.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModel AT ROW 8.79 COL 34 COLON-ALIGNED NO-LABEL
     TTmab-reserva.val-km-estimad AT ROW 8.79 COL 78.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.cod-estabel-matr AT ROW 9.75 COL 18.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-reserva.ep-codigo-matr AT ROW 9.79 COL 13 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-reserva.cod-matr AT ROW 9.79 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMoto AT ROW 9.79 COL 34.57 COLON-ALIGNED NO-LABEL
     TTmab-reserva.cod-usuar AT ROW 9.79 COL 78.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiData AT ROW 3.67 COL 24.29 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 3.96 COL 24
     rtParent AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     TTmab-reserva.dsl-obs AT ROW 1.17 COL 2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 400 SCROLLBAR-VERTICAL
          SIZE 82 BY 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 13 SCROLLABLE 
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 13 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-reserva T "?" NO-UNDO movfro mab-reserva
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-reserva-implto T "?" NO-UNDO movfro mab-reserva-implto
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
         TITLE              = "Controle de Reservas"
         HEIGHT             = 17
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
/* SETTINGS FOR FILL-IN TTmab-reserva.ep-codigo-matr IN FRAME fPage0
   EXP-LABEL                                                            */
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
     _TblList          = "Temp-Tables.TTmab-reserva-implto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fnRetornaEmpresa (TTmab-reserva-implto.ep-codigo) @ c-cod-empresa" "Empresa" ? ? ? ? ? ? ? ? no "C¢digo da empresa do equipamento" no no "8" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.TTmab-reserva-implto.cod-eqpto
"cod-eqpto" "Equipamento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"getDescModel (TTmab-reserva-implto.ep-codigo ,
                          TTmab-reserva-implto.cod-eqpto) @ cDescModel" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
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
ON END-ERROR OF wMasterDetail /* Controle de Reservas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Controle de Reservas */
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr062.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-eqpto wMasterDetail
ON LEAVE OF TTmab-reserva.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    run buscaModelo in this-procedure.
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOModel"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModel"
        &Frame1="fPage0"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-matr wMasterDetail
ON LEAVE OF TTmab-reserva.cod-matr IN FRAME fPage0 /* cod-matr */
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


&Scoped-define SELF-NAME TTmab-reserva.cod-rota-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-dest wMasterDetail
ON LEAVE OF TTmab-reserva.cod-rota-dest IN FRAME fPage0 /* Trajeto Destino */
DO:
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOTraj"
        &KeyValue1="input frame fPage0 {&ttParent}.cod-rota-dest"
        &FieldName1="des-trajeto"
        &FieldScreen1="fiDescRotaD"
        &Frame1="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-rota-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-orig wMasterDetail
ON LEAVE OF TTmab-reserva.cod-rota-orig IN FRAME fPage0 /* Trajeto Origem */
DO:
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOTraj"
        &KeyValue1="input frame fPage0 {&ttParent}.cod-rota-orig"
        &FieldName1="des-trajeto"
        &FieldScreen1="fiDescRotaO"
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
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/
IF AVAIL {&ttParent}  THEN DO:

/** Descri‡äes **/
apply "LEAVE":U to {&ttParent}.cod-eqpto     in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-matr      in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-rota-orig in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-rota-dest in frame fPage0.

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
{utp~/ut-liter.i "Data Atualiza‡Æo"}
assign {&ttParent}.dat-atualiz:label in frame fPage0 = trim(return-value).
{utp~/ut-liter.i "Descri‡Æo"}
assign cDescModel:label in browse brSon1 = trim(return-value).
{utp~/ut-liter.i Data }
assign fiData = trim(return-value).
{utp~/ut-liter.i Inicial }
ASSIGN TTmab-reserva.dat-reserva-inicial:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp~/ut-liter.i Final }
ASSIGN TTmab-reserva.dat-reserva-final:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp~/ut-liter.i "Equipamento" }
ASSIGN TTmab-reserva.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.

display fiData
    with frame fPage0.

ASSIGN TTmab-reserva.dsl-obs:SENSITIVE IN FRAME fPage2 = YES
       TTmab-reserva.dsl-obs:READ-ONLY IN FRAME fPage2 = YES.

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

    DEFINE VARIABLE  iNrReser LIKE  {&ttParent}.num-reserva
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
   
    
    DEFINE FRAME fGoToRecord
        iNrReser          AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Reserva" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Reserva"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

   {utp/ut-liter.i Documento_Reserva  * L}
   assign   iNrReser:label in frame fGoToRecord = return-value.

    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iNrReser .
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iNrReser ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Reserva" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iNrReser btGoToCancel btGoToOK
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
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr062.p":U THEN DO:
        RUN  frbo~/bofr062.p PERSISTENT SET  {&hDBOParent}.
    END.
 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr063.p":U THEN DO:
        RUN frbo~/bofr063.p PERSISTENT SET {&hDBOSon1}.
    END.
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.

    /*--- DBO MOdelo ---*/
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
    
{masterdetail/openqueriesson.i &Parent="Reserva"
                               &Query="Reserva"
                               &PageNumber="1"}
                               
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaReserva wMasterDetail 
PROCEDURE setaReserva :
/*------------------------------------------------------------------------------
  Purpose:     setaReserva
  Parameters:  entrada pRowid = Rowid da tabela <mab-reserva>
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
  ( &IF "{&mguni_version}" >= "2.071" &THEN pCodEmp AS CHAR &ELSE pCodEmp AS INT &ENDIF,
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

