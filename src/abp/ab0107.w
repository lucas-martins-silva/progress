&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-eqpto-sub-sist NO-UNDO LIKE mab-eqpto-sub-sist
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-grp-eqpto NO-UNDO LIKE mab-grp-eqpto
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
{include/i-prgvrs.i AB0107 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0107 MAB}
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
&GLOBAL-DEFINE Program          AB0107
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels    Sub_Sistemas

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         TTmab-grp-eqpto
&GLOBAL-DEFINE hDBOParent       hDBOGrpEqpto
&GLOBAL-DEFINE DBOParentTable   mab-grp-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1          TTmab-eqpto-sub-sist
&GLOBAL-DEFINE hDBOSon1        hDBOGrpSubSist 
&GLOBAL-DEFINE DBOSon1Table    mab-eqpto-sub-sist     
&GLOBAL-DEFINE DBOSon1Destroy  YES


&GLOBAL-DEFINE page0Fields   TTmab-grp-eqpto.cod-grp-eqpto ~
                             TTmab-grp-eqpto.des-grp-eqpto   
                                 

&GLOBAL-DEFINE page1Browse      brSon1    

/* Parameters Definitions ---                                           */
DEFINE VARIABLE cDescSist    AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE cCodSist     AS CHARACTER FORMAT "x(08)" NO-UNDO.


/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSist      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSubSist   AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES TTmab-eqpto-sub-sist

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 TTmab-eqpto-sub-sist.cod-sub-sist ~
getDescSubSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSubSist ~
getCodSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cCodSist ~
getDescSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSist 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmab-eqpto-sub-sist NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmab-eqpto-sub-sist
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmab-eqpto-sub-sist


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-grp-eqpto.cod-grp-eqpto ~
TTmab-grp-eqpto.des-grp-eqpto 
&Scoped-define ENABLED-TABLES TTmab-grp-eqpto
&Scoped-define FIRST-ENABLED-TABLE TTmab-grp-eqpto
&Scoped-define DISPLAYED-TABLES TTmab-grp-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-grp-eqpto
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btcopia btQueryJoins btReportsJoins btExit btHelp ~
RECT-28 rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-grp-eqpto.cod-grp-eqpto ~
TTmab-grp-eqpto.des-grp-eqpto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCodSist wMasterDetail 
FUNCTION getCodSist RETURNS CHARACTER
  ( pCodSubSist as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescSist wMasterDetail 
FUNCTION getDescSist RETURNS CHARACTER
  ( pCodSubSist as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescSubSist wMasterDetail 
FUNCTION getDescSubSist RETURNS CHARACTER
    ( pCodSubSist as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miAvancada     LABEL "Copia Sub-Siste&mas" ACCELERATOR "CTRL-D"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btcopia 
     IMAGE-UP FILE "image/copy-au.bmp":U
     IMAGE-INSENSITIVE FILE "image/copy-ai.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Copia Sub-Sistemas dos Grupos".

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      TTmab-eqpto-sub-sist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      TTmab-eqpto-sub-sist.cod-sub-sist COLUMN-LABEL "Sub-Sistema" FORMAT "x(8)":U
      getDescSubSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSubSist COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      getCodSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cCodSist COLUMN-LABEL "Sistema"
            WIDTH 8
      getDescSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSist COLUMN-LABEL "Descriá∆o"
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btcopia AT ROW 1.13 COL 47 HELP
         "Copia Sub-Sistemas dos Grupos"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-grp-eqpto.cod-grp-eqpto AT ROW 2.92 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-grp-eqpto.des-grp-eqpto AT ROW 4.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     RECT-28 AT ROW 2.75 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
     "Grupo:" VIEW-AS TEXT
          SIZE 5 BY .88 AT ROW 2.88 COL 16.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.04
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: TTmab-eqpto-sub-sist T "?" NO-UNDO mgfro mab-eqpto-sub-sist
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-grp-eqpto T "?" NO-UNDO mgfro mab-grp-eqpto
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
         TITLE              = "Manutená∆o dos Grupos de Equipamentos"
         HEIGHT             = 17.04
         WIDTH              = 90
         MAX-HEIGHT         = 17.04
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.04
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.TTmab-eqpto-sub-sist"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.TTmab-eqpto-sub-sist.cod-sub-sist
"TTmab-eqpto-sub-sist.cod-sub-sist" "Sub-Sistema" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"getDescSubSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSubSist" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"getCodSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cCodSist" "Sistema" ? ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"getDescSist (TTmab-eqpto-sub-sist.cod-sub-sist) @ cDescSist" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
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
ON END-ERROR OF wMasterDetail /* Manutená∆o dos Grupos de Equipamentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Manutená∆o dos Grupos de Equipamentos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "abp/ab0107a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0107b.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btcopia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btcopia wMasterDetail
ON CHOOSE OF btcopia IN FRAME fPage0
OR CHOOSE OF MENU-ITEM miAvancada IN MENU mbMain DO:
  RUN piCopiaSub IN THIS-PROCEDURE.
  apply "ENTRY":U to btcopia in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "abp/ab0107a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}
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
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr011.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "abp/ab0107a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp/ab0107b.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE (hDBOSist) THEN
       RUN destroy IN hDBOSist.

IF VALID-HANDLE (hDBOSubSist) THEN
       RUN destroy IN hDBOSubSist.


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

 assign btcopia:sensitive in frame fPage0 = yes.

RETURN "OK":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCopiaSub wMasterDetail 
PROCEDURE piCopiaSub :
/*------------------------------------------------------------------------------
  Purpose:  Copia os sub-sistemas entre os grupos de equipamentos.   
------------------------------------------------------------------------------*/
define variable hGrup     as handle    no-undo.
define variable cCodGrp-eqpto  as character no-undo.
       
for first mab-grp-eqpto
    where mab-grp-eqpto.cod-grp-eqpto = INPUT FRAME Fpage0 TTmab-grp-eqpto.cod-grp-eqpto no-lock:
    
    assign cCodGrp-eqpto = mab-grp-eqpto.cod-grp-eqpto.
                   
    if cCodGrp-eqpto  = ""  then return "NOK":U.
    
    /*--- Executa programa de inclus∆o de filho ---*/
    Run abp/ab0107c.w PERSISTENT SET hGrup.
     
    IF VALID-HANDLE(hGrup) THEN DO:
        /*--- Seta cursor do mouse para espera ---*/
        SESSION:SET-WAIT-STATE("GENERAL":U).
        assign {&window-name}:sensitive = no.

         /*--- Inicializa programa de inclus∆o de filho ---*/
        Run initializeInterface IN hGrup.

        run setaGrupo in hGrup (input ROWID(mab-grp-eqpto)).
    
        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).
        wait-for "CLOSE":U of hGrup.
        assign {&window-name}:sensitive = yes.
        
    END.
     
    if valid-handle(hGrup) then
        delete procedure hGrup.
    
      
END.

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

    DEFINE VARIABLE  cCodGrp LIKE  {&ttParent}.cod-grp-eqpto
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        cCodGrp         AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Grupo de Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Grupo_de_Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodGrp .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cCodGrp ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Grupo_de_Equipamentos" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodGrp btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr011.p":U THEN DO:
        RUN  frbo/bofr011.p PERSISTENT SET  {&hDBOParent}.
    END.
 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    
      /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr008.p":U THEN DO:
        RUN frbo/bofr008.p PERSISTENT SET {&hDBOSon1}.
    END.
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.
    

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOSist) OR
      hDBOSist:TYPE <> "PROCEDURE":U OR
      hDBOSist:FILE-NAME <> "frbo~\bofr023.p":U THEN DO:
       run "frbo/bofr023.p" persistent set hDBOSist.
   END.

   RUN openQueryStatic IN hDBOSist (INPUT "Main":U) NO-ERROR.
   
    /*:T--- Verifica se o DBO j† est† inicializado ---*/

   IF NOT VALID-HANDLE(hDBOSubSist) OR
     hDBOSubSist:TYPE <> "PROCEDURE":U OR
     hDBOSubSist:FILE-NAME <> "frbo~\bofr025.p":U THEN DO:
      run "frbo/bofr025.p" persistent set hDBOSubSist.
  END.

  RUN openQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.



   RETURN "OK":U.


       
  
    
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
    
    {masterdetail/openqueriesson.i &Parent="mab-grp-eqpto"
                                   &Query="mab-grp-eqpto"
                                   &PageNumber="1"}
    
 
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCodSist wMasterDetail 
FUNCTION getCodSist RETURNS CHARACTER
  ( pCodSubSist as CHAR) :
    
    def var cCod    as CHAR FORMAT "x(30)" no-undo.
    def var pCodSist as CHAR  no-undo.

    FOR FIRST mab-sub-sist FIELDS (cod-sub-sist)NO-LOCK
        WHERE mab-sub-sist.cod-sub-sist = pCodSubSist,
        FIRST  mab-sist FIELDS (cod-sistema)NO-LOCK
               WHERE mab-sist.cod-sistema = mab-sub-sist.cod-sistema:
               ASSIGN pCodSist = mab-sist.cod-sistema.

    END.

    run goToKey in hDBOSist      (input pCodSist).
    run getCharField in hDBOSist (input "cod-sistema":u,
                                  output cCod).
  RETURN cCod.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescSist wMasterDetail 
FUNCTION getDescSist RETURNS CHARACTER
  ( pCodSubSist as CHAR) :
    
    def var cDesc    as CHAR FORMAT "x(30)" no-undo.
    def var pCodSist as CHAR  no-undo.

    FOR FIRST mab-sub-sist FIELDS (cod-sub-sist)NO-LOCK
        WHERE mab-sub-sist.cod-sub-sist = pCodSubSist,
        FIRST  mab-sist FIELDS (cod-sistema)NO-LOCK
               WHERE mab-sist.cod-sistema = mab-sub-sist.cod-sistema:
               ASSIGN pCodSist = mab-sist.cod-sistema.

    END.

    run goToKey in hDBOSist      (input pCodSist).
    run getCharField in hDBOSist (input "des-sistema":u,
                                  output cDesc).
  RETURN cDesc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescSubSist wMasterDetail 
FUNCTION getDescSubSist RETURNS CHARACTER
    ( pCodSubSist as CHAR) :

      def var cDesc as CHAR FORMAT "x(30)" no-undo.

      run goToKey in hDBOSubSist      (input pCodSubSist).
      run getCharField in hDBOSubSist (input "des-sub-sist":u,
                                       output cDesc).
    RETURN cDesc.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

