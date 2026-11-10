&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-eqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmgf-eqpto-implto NO-UNDO LIKE mgf-eqpto-implto
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
{include/i-prgvrs.i AB0123 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0123 MAB}
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
&GLOBAL-DEFINE Program          AB0123
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels    Equipamento

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

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent          TTmab-eqpto
&GLOBAL-DEFINE hDBOParent        hDBOEqpto
&GLOBAL-DEFINE DBOParentTable    mab-eqpto 
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1            TTmgf-eqpto-implto
&GLOBAL-DEFINE hDBOSon1          hDBOEqptoImplto
&GLOBAL-DEFINE DBOSon1Table      mgf-eqpto-implto
&GLOBAL-DEFINE DBOSon1Destroy   YES


&GLOBAL-DEFINE page0Fields    TTmab-eqpto.ep-codigo TTmab-eqpto.cod-eqpto    
                                

&GLOBAL-DEFINE page1Browse      brSon1    

/* Parameters Definitions ---                                           */

DEFINE VARIABLE cDescEqpto AS CHARACTER  FORMAT "x(30)" NO-UNDO.
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.

def new global shared var lImplto    as logical initial no no-undo.
def new global shared var lEqpto     as logical initial no no-undo.

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
&Scoped-define INTERNAL-TABLES TTmgf-eqpto-implto

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 TTmgf-eqpto-implto.dat-inicial ~
fnRetornaEmpresa (TTmgf-eqpto-implto.ep-codigo-eqpto) @ c-cod-empresa ~
TTmgf-eqpto-implto.cod-eqpto ~
fnDescricao (TTmgf-eqpto-implto.ep-codigo-eqpto,                        TTmgf-eqpto-implto.cod-eqpto) @ cDescEqpto ~
TTmgf-eqpto-implto.dat-final 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH TTmgf-eqpto-implto NO-LOCK ~
    BY TTmgf-eqpto-implto.ep-codigo-implto ~
       BY TTmgf-eqpto-implto.cod-implto ~
        BY TTmgf-eqpto-implto.dat-inicial DESCENDING
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmgf-eqpto-implto NO-LOCK ~
    BY TTmgf-eqpto-implto.ep-codigo-implto ~
       BY TTmgf-eqpto-implto.cod-implto ~
        BY TTmgf-eqpto-implto.dat-inicial DESCENDING.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmgf-eqpto-implto
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmgf-eqpto-implto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-eqpto.ep-codigo TTmab-eqpto.cod-eqpto 
&Scoped-define ENABLED-TABLES TTmab-eqpto
&Scoped-define FIRST-ENABLED-TABLE TTmab-eqpto
&Scoped-Define ENABLED-OBJECTS RECT-27 rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp fiDEscEmp ~
fiDescEqpto 
&Scoped-Define DISPLAYED-FIELDS TTmab-eqpto.ep-codigo TTmab-eqpto.cod-eqpto 
&Scoped-define DISPLAYED-TABLES TTmab-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-eqpto
&Scoped-Define DISPLAYED-OBJECTS fiDEscEmp fiDescEqpto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (   pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
      pCodEqpto as char )  FORWARD.

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
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
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

DEFINE VARIABLE fiDEscEmp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
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
      TTmgf-eqpto-implto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      TTmgf-eqpto-implto.dat-inicial FORMAT "99/99/9999":U
      fnRetornaEmpresa (TTmgf-eqpto-implto.ep-codigo-eqpto) @ c-cod-empresa COLUMN-LABEL "Empresa"
            WIDTH 8
      TTmgf-eqpto-implto.cod-eqpto FORMAT "x(16)":U WIDTH 16
      fnDescricao (TTmgf-eqpto-implto.ep-codigo-eqpto,
                       TTmgf-eqpto-implto.cod-eqpto) @ cDescEqpto COLUMN-LABEL "Descri‡Æo"
            WIDTH 30
      TTmgf-eqpto-implto.dat-final FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
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
     TTmab-eqpto.ep-codigo AT ROW 3 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fiDEscEmp AT ROW 3 COL 27.29 COLON-ALIGNED NO-LABEL
     TTmab-eqpto.cod-eqpto AT ROW 4 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescEqpto AT ROW 4 COL 37.29 COLON-ALIGNED NO-LABEL
     RECT-27 AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.67
         SIZE 84.43 BY 10.63
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
      TABLE: TTmgf-eqpto-implto T "?" NO-UNDO mgfro mgf-eqpto-implto
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
         TITLE              = "Relacionamento Implemento X Equipamento"
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
     _TblList          = "Temp-Tables.TTmgf-eqpto-implto"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.TTmgf-eqpto-implto.ep-codigo-implto|yes,Temp-Tables.TTmgf-eqpto-implto.cod-implto|yes,Temp-Tables.TTmgf-eqpto-implto.dat-inicial|no"
     _FldNameList[1]   = Temp-Tables.TTmgf-eqpto-implto.dat-inicial
     _FldNameList[2]   > "_<CALC>"
"fnRetornaEmpresa (TTmgf-eqpto-implto.ep-codigo-eqpto) @ c-cod-empresa" "Empresa" ? ? ? ? ? ? ? ? no "C¢digo da Empresa do Equipamento" no no "8" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.TTmgf-eqpto-implto.cod-eqpto
"cod-eqpto" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"fnDescricao (TTmgf-eqpto-implto.ep-codigo-eqpto,
                       TTmgf-eqpto-implto.cod-eqpto) @ cDescEqpto" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.TTmgf-eqpto-implto.dat-final
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
ON END-ERROR OF wMasterDetail /* Relacionamento Implemento X Equipamento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Relacionamento Implemento X Equipamento */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0123a.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    assign lImplto = yes
           lEqpto  = no.
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr007.w"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp/ab0123a.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME TTmab-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-eqpto.cod-eqpto wMasterDetail
ON LEAVE OF TTmab-eqpto.cod-eqpto IN FRAME fPage0 /* Equipamento */
DO:
   if avail TTmab-eqpto then do:
        {method\referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="TTmab-eqpto.cod-model"
            &FieldName1="des-model"
            &FieldScreen1="fiDescEqpto"
            &Frame1="fPage0"}
    end.
    else
        assign fiDescEqpto:screen-value in frame fPage0 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-eqpto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-eqpto.ep-codigo wMasterDetail
ON LEAVE OF TTmab-eqpto.ep-codigo IN FRAME fPage0 /* Empresa */
DO:
  def var cDesc as char no-undo.
  if avail TTmab-eqpto then do:
        run buscaEmpresa in {&hDBOParent} (input input frame fPage0 TTmab-eqpto.ep-codigo,
                                           output cDesc).
        assign fiDescEmp:screen-value in frame fPage0 = cDesc. 
       
  end.
  else do:
      assign fiDescEmp:screen-value in frame fPage0 = "":U.
  end.
      
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

/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.




return "OK":U.
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
/** Descri‡Æo Modelo - Implemento**/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

/** Descri‡Æo Empresa - Implemento **/
apply "LEAVE":U to {&ttParent}.ep-codigo in frame fPage0.

RETURN "OK":U.

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
/**Label do Implemento***/
{utp/ut-liter.i "Implemento" MAB}
assign TTmab-eqpto.cod-eqpto:label in frame fPage0 = return-value.


/** Descri‡Æo Modelo - Implemento**/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

/** Descri‡Æo Empresa - Implemento **/
apply "LEAVE":U to {&ttParent}.ep-codigo in frame fPage0.

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

        DEFINE VARIABLE cep-codigo   LIKE {&ttParent}.ep-codigo           NO-UNDO.
        DEFINE VARIABLE ccod-eqpto   LIKE mgf-eqpto-implto.cod-implto     NO-UNDO.

        {utp/ut-liter.i "V  Para Implemento"}
        DEFINE FRAME fGoToRecord
            cep-codigo        AT ROW 1.21 COL 17.72 COLON-ALIGNED
            ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
            btGoToOK          AT ROW 3.63 COL 2.14
            btGoToCancel      AT ROW 3.63 COL 13
            rtGoToButton      AT ROW 3.38 COL 1
            SPACE(0.28)
            WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                 THREE-D SCROLLABLE TITLE return-value FONT 1
                 DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

        RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
        {utp/ut-liter.i "V  Para Implemento"}
        ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

        ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
            ASSIGN cep-codigo ccod-eqpto.

       

            /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
            RUN goToImplemento IN {&hDBOParent} (INPUT cep-codigo,
                                                 input ccod-eqpto).
            IF RETURN-VALUE = "NOK":U THEN DO:
                {utp/ut-liter.i "Implemento" MAB}
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).

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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        RUN  frbo/bofr007.p PERSISTENT SET  {&hDBOParent}.
    END.
 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Implemento":U) NO-ERROR.


      /*--- Verifica se o DBO Filho j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr093.p":U THEN DO:
        RUN frbo/bofr093.p PERSISTENT SET {&hDBOSon1}.
    END.

     /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.


  
  
    
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
    
    {masterdetail/openqueriesson.i &Parent="Mab-eqpto"
                                   &Query="Mab-eqpto"
                                   &PageNumber="1"}
    
 
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (   pCodEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
      pCodEqpto as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
def var cDesc as char format "x(30)" no-undo.

for first  mab-eqpto fields (ep-codigo cod-eqpto cod-model)
    where mab-eqpto.ep-codigo = pCodEmp
    and   mab-eqpto.cod-eqpto = pCodEqpto no-lock,
    first mab-model fields (cod-model des-model)
          where mab-model.cod-model = mab-eqpto.cod-model no-lock:
          assign cDesc = mab-model.des-model.
end.


  RETURN cDesc.   /* Function return value. */

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

