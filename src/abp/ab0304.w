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
{include/i-prgvrs.i AB0304 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0304 MAB}
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
&GLOBAL-DEFINE Program          AB0304
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels    Implemento

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
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       YES

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


&GLOBAL-DEFINE page0Fields    TTmab-viagem.num-viagem ~
                              TTmab-viagem.dat-saida ~
                              TTmab-viagem.hra-saida ~
                              TTmab-viagem.ep-codigo ~
                              TTmab-viagem.cod-eqpto ~
                              TTmab-viagem.ep-codigo-matr ~
                              TTmab-viagem.cod-estabel-matr ~
                              TTmab-viagem.cod-matr ~
                              TTmab-viagem.dat-ret ~
                              TTmab-viagem.hra-ret ~
                              TTmab-viagem.num-reserva

&GLOBAL-DEFINE page1Browse      brSon1    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescModel AS CHARACTER FORMAT "x(30)" NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModel     AS HANDLE NO-UNDO.

DEF VAR c-cod-empresa LIKE empresa.ep-codigo NO-UNDO.

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
TTmab-viagem.num-reserva TTmab-viagem.ep-codigo TTmab-viagem.cod-eqpto ~
TTmab-viagem.dat-saida TTmab-viagem.hra-saida TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.dat-ret ~
TTmab-viagem.hra-ret 
&Scoped-define ENABLED-TABLES TTmab-viagem
&Scoped-define FIRST-ENABLED-TABLE TTmab-viagem
&Scoped-Define ENABLED-OBJECTS RECT-29 rtParent rtToolBar RECT-31 btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete ~
btQueryJoins btReportsJoins btExit btHelp cDescEqpto cDescMot fiData 
&Scoped-Define DISPLAYED-FIELDS TTmab-viagem.num-viagem ~
TTmab-viagem.num-reserva TTmab-viagem.ep-codigo TTmab-viagem.cod-eqpto ~
TTmab-viagem.dat-saida TTmab-viagem.hra-saida TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.dat-ret ~
TTmab-viagem.hra-ret 
&Scoped-define DISPLAYED-TABLES TTmab-viagem
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-viagem
&Scoped-Define DISPLAYED-OBJECTS cDescEqpto cDescMot fiData 

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
  (   pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
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

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88 NO-UNDO.

DEFINE VARIABLE cDescMot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiData AS CHARACTER FORMAT "X(20)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.21.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.29 BY 3.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

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
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 82 BY 6.13
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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-viagem.num-viagem AT ROW 2.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.num-reserva AT ROW 2.83 COL 75.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-viagem.ep-codigo AT ROW 4.92 COL 10.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-eqpto AT ROW 4.92 COL 15.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescEqpto AT ROW 4.92 COL 26.14 COLON-ALIGNED NO-LABEL
     TTmab-viagem.dat-saida AT ROW 4.92 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-saida AT ROW 4.92 COL 79.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     TTmab-viagem.ep-codigo-matr AT ROW 5.92 COL 10.14 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-estabel-matr AT ROW 5.92 COL 15.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-matr AT ROW 5.92 COL 20.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMot AT ROW 5.92 COL 30.86 COLON-ALIGNED NO-LABEL
     TTmab-viagem.dat-ret AT ROW 5.92 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-ret AT ROW 5.92 COL 79.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiData AT ROW 4.21 COL 63 COLON-ALIGNED NO-LABEL
     RECT-29 AT ROW 2.67 COL 1
     rtParent AT ROW 4 COL 1
     rtToolBar AT ROW 1 COL 1
     RECT-31 AT ROW 4.5 COL 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 7.33 COL 2
     btDeleteSon1 AT ROW 7.33 COL 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 9.38
         SIZE 84.43 BY 7.63
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN TTmab-viagem.ep-codigo-matr IN FRAME fPage0
   EXP-LABEL                                                            */
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
     _TblList          = "Temp-Tables.TTmab-viagem-implto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fnRetornaEmpresa (TTmab-viagem-implto.ep-codigo) @ c-cod-empresa" "Empresa" ? ? ? ? ? ? ? ? no "C¢digo da empresa do equipamento" no no "7.72" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.TTmab-viagem-implto.cod-eqpto
"TTmab-viagem-implto.cod-eqpto" "Equipamento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "abp/ab0304a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0304b.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "abp/ab0304a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    /** Customiza‡Æo do delete record **/
    run piElimina in this-procedure.
    if return-value = "NOK":U then
        return no-apply.
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
    {method/zoomreposition.i &ProgramZoom="frzoom~\z01fr064.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "abp/ab0304a.w":U). 
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE (hDBOModel) THEN
       RUN destroy IN hDBOModel.


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
{utp/ut-liter.i "Data" }
ASSIGN fiData:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Sa¡da" }
ASSIGN TTmab-viagem.dat-saida:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Retorno" }
ASSIGN TTmab-viagem.dat-ret:LABEL IN FRAME fPage0 = RETURN-VALUE.
IF AVAIL  TTmab-viagem THEN 
    IF TTmab-viagem.num-viagem:SCREEN-VALUE IN FRAME fPage0 <> "" 
        OR  TTmab-viagem.num-viagem:SCREEN-VALUE IN FRAME fPage0 <> "0" THEN DO:
        
          ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = YES.
    END.
    ELSE DO:
       
        ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO.

   END.

  
   FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto,
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
   END.

    FOR FIRST mab-motoris FIELDS (ep-codigo cod-estabel cod-matr nom-motoris)
        WHERE mab-motoris.ep-codigo   = INPUT FRAME fPage0 TTmab-viagem.ep-codigo-matr
          AND mab-motoris.cod-estabel = INPUT FRAME fPage0 TTmab-viagem.cod-estabel-matr
          AND mab-motoris.cod-matr    = INPUT FRAME fPage0 TTmab-viagem.cod-matr NO-LOCK:
              ASSIGN cDescMot = mab-motoris.nom-motoris.
              DISP cDescMot WITH FRAME fPage0.
   END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMasterDetail 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL  TTmab-viagem THEN 
IF TTmab-viagem.num-viagem:SCREEN-VALUE IN FRAME fPage0 <> "" 
   OR  TTmab-viagem.num-viagem:SCREEN-VALUE IN FRAME fPage0 <> "0" THEN DO:
        
          ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = YES.
    END.
    ELSE DO:
       
        ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO.

   END.

 FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto,
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
   END.

   
   FOR FIRST mab-motoris FIELDS (ep-codigo cod-estabel cod-matr nom-motoris)
    WHERE mab-motoris.ep-codigo   = INPUT FRAME fPage0 TTmab-viagem.ep-codigo-matr
      AND mab-motoris.cod-estabel = INPUT FRAME fPage0 TTmab-viagem.cod-estabel-matr
      AND mab-motoris.cod-matr    = INPUT FRAME fPage0 TTmab-viagem.cod-matr NO-LOCK:
          ASSIGN cDescMot = mab-motoris.nom-motoris.
          DISP cDescMot WITH FRAME fPage0.
   END.


RETURN "Ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp~/ut-liter.i Equipamento }
ASSIGN TTmab-viagem.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.

 FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto,
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
   END.

    
   FOR FIRST mab-motoris FIELDS (ep-codigo cod-estabel cod-matr nom-motoris)
       WHERE mab-motoris.ep-codigo   = INPUT FRAME fPage0 TTmab-viagem.ep-codigo-matr
         AND mab-motoris.cod-estabel = INPUT FRAME fPage0 TTmab-viagem.cod-estabel-matr
         AND mab-motoris.cod-matr    = INPUT FRAME fPage0 TTmab-viagem.cod-matr NO-LOCK:
             ASSIGN cDescMot = mab-motoris.nom-motoris.
             DISP cDescMot WITH FRAME fPage0.
   END.


  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMasterDetail 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



IF AVAIL  TTmab-viagem THEN 
   IF TTmab-viagem.num-viagem:SCREEN-VALUE IN FRAME fPage0 <> "" 
   OR   TTmab-viagem.num-viagem <> 0  THEN DO:
        
          ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = YES.
    END.
    ELSE DO:
        ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO.
   END.

 FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto,
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
   END.

    
   FOR FIRST mab-motoris FIELDS (ep-codigo cod-estabel cod-matr nom-motoris)
       WHERE mab-motoris.ep-codigo   = INPUT FRAME fPage0 TTmab-viagem.ep-codigo-matr
         AND mab-motoris.cod-estabel = INPUT FRAME fPage0 TTmab-viagem.cod-estabel-matr
         AND mab-motoris.cod-matr    = INPUT FRAME fPage0 TTmab-viagem.cod-matr NO-LOCK:
             ASSIGN cDescMot = mab-motoris.nom-motoris.
             DISP cDescMot WITH FRAME fPage0.
  END.



 RETURN "OK":U.

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
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "mab-viagem":U).
            
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

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE(hDBOModel) OR
       hDBOModel:TYPE <> "PROCEDURE":U OR
       hDBOModel:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        RUN frbo~/bofr016.p PERSISTENT SET hDBOModel.
    END.
    RUN openQueryStatic IN hDBOModel (INPUT "Main":U) NO-ERROR.

   
    
  
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piElimina wMasterDetail 
PROCEDURE piElimina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

/** Bloco de elimina‡Æo **/
viagem:
do transaction on error undo ,return "NOK":U 
               on stop  undo ,return "NOK":U:
    /** Verifica se tabela cont‚m relacionamentos **/
    if can-find(first TTmab-viagem-implto)
       then do:
        {utp~/ut-liter.i "Viagem"}
        assign cTexto = return-value.
        {utp~/ut-liter.i "Relacionamentos"}
        run utp~/ut-msgs.p (input "SHOW":U,
                           input 968,
                           input cTexto + "~~" + return-value).
        if return-value = "NO":U then do:
            undo viagem, return "NOK":U.
        end.
        else do:
            /** Elimina os registros das tabelas filhas da viagem **/
            run eliminaFilhos in {&hDBOParent} (input TTmab-viagem.r-rowid).
            if return-value = "NOK":U then do:
                run piMostraErros in this-procedure.
                undo viagem, return "NOK":U.
            end.
        end.
    end.
    
    /** Elimina o registro corrente da viagem **/
    run deleteRecord in this-procedure.
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
        undo viagem, return "NOK":U.
    end.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMasterDetail 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOParent} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOParent}.

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
  (   pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
      pCodEqpto as CHAR ) :
    
    def var cDesc as char FORMAT "x(30)" no-undo.

    FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
          WHERE mab-eqpto.ep-codigo =  pCodEmp 
          AND   mab-eqpto.cod-eqpto =  pCodEqpto NO-LOCK,
          EACH mab-model FIELDS (cod-model des-model)
               WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
               ASSIGN cDesc = mab-model.des-model.
               
    END.

  
  RETURN cDesc.



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

