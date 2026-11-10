&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttOleo NO-UNDO LIKE mab-comptmento-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttPeriodo NO-UNDO LIKE mab-period-manut
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
{include/i-prgvrs.i AB0138C 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138c MAB}
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
&GLOBAL-DEFINE Program          AB0138C
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Per°odo

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
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         ttOleo
&GLOBAL-DEFINE hDBOParent       hDBOOleo
&GLOBAL-DEFINE DBOParentTable   mab-comptmento-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttPeriodo
&GLOBAL-DEFINE hDBOSon1         hDBOPeriodo
&GLOBAL-DEFINE DBOSon1Table     mab-period-manut
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      ttOleo.ep-codigo ttOleo.cod-comptmento ~
                                ttOleo.cod-eqpto

&GLOBAL-DEFINE page1Browse      brSon1

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pRowSon AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER pRowPai AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescCampo AS CHARACTER  format "x(35)" NO-UNDO.

/* Global Variables ---                                                 */
define new global shared variable iEmpresa like mab-comptmento-eqpto.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-comptmento-eqpto.cod-eqpto   no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttPeriodo

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttPeriodo.cod-evento ~
fnDescEvento(ttPeriodo.cod-evento) @ cDescCampo ttPeriodo.val-km-padr ~
ttPeriodo.val-km-estimad ttPeriodo.val-km-real 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttPeriodo NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttPeriodo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttPeriodo
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttPeriodo


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttOleo.ep-codigo ttOleo.cod-eqpto ~
ttOleo.cod-comptmento 
&Scoped-define ENABLED-TABLES ttOleo
&Scoped-define FIRST-ENABLED-TABLE ttOleo
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp fiDescModelo fiDescCompart 
&Scoped-Define DISPLAYED-FIELDS ttOleo.ep-codigo ttOleo.cod-eqpto ~
ttOleo.cod-comptmento 
&Scoped-define DISPLAYED-TABLES ttOleo
&Scoped-define FIRST-DISPLAYED-TABLE ttOleo
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fiDescCompart 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( cEvento as char )  FORWARD.

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
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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

DEFINE VARIABLE fiDescCompart AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon1 
     LABEL "&Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttPeriodo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttPeriodo.cod-evento FORMAT "x(8)":U
      fnDescEvento(ttPeriodo.cod-evento) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(35)":U
            WIDTH 30
      ttPeriodo.val-km-padr FORMAT ">>,>>>,>>9.9":U
      ttPeriodo.val-km-estimad FORMAT ">,>>>,>>9":U
      ttPeriodo.val-km-real FORMAT ">>,>>>,>>9.9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.13
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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttOleo.ep-codigo AT ROW 2.75 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttOleo.cod-eqpto AT ROW 3.75 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 3.75 COL 42.57 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     ttOleo.cod-comptmento AT ROW 4.75 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescCompart AT ROW 4.75 COL 37.57 COLON-ALIGNED HELP
          "Descriá∆o do Compartimento" NO-LABEL
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 9.33 COL 2
     btCopySon1 AT ROW 9.33 COL 12
     btUpdateSon1 AT ROW 9.33 COL 22
     btDeleteSon1 AT ROW 9.33 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 7.38
         SIZE 84.43 BY 9.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttOleo T "?" NO-UNDO mgfro mab-comptmento-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttPeriodo T "?" NO-UNDO mgfro mab-period-manut
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
     _TblList          = "Temp-Tables.ttPeriodo"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttPeriodo.cod-evento
     _FldNameList[2]   > "_<CALC>"
"fnDescEvento(ttPeriodo.cod-evento) @ cDescCampo" "Descriá∆o" "x(35)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.ttPeriodo.val-km-padr
     _FldNameList[4]   = Temp-Tables.ttPeriodo.val-km-estimad
     _FldNameList[5]   = Temp-Tables.ttPeriodo.val-km-real
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    /** Inclus∆o tabela pai **/
    run piManutencaoPai (input "Add":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp\ab0138c2.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    /** Copia registro tabela pai **/
    run piManutencaoPai (input "Copy":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="abp\ab0138c2.w"
                            &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    /** Customizaá∆o do delete record **/
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
    assign iEmpresa = input frame fPage0 {&ttParent}.ep-codigo
           cEqpto   = input frame fPage0 {&ttParent}.cod-eqpto.
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr004.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    /** Atualiza registro corrente tabela pai **/
    run piManutencaoPai (input "Update":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp\ab0138c2.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME ttOleo.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-comptmento wMasterDetail
ON LEAVE OF ttOleo.cod-comptmento IN FRAME fPage0 /* Compartimento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="ttOleo.cod-comptmento:screen-value in frame fPage0"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescCompart"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttOleo.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-eqpto wMasterDetail
ON LEAVE OF ttOleo.cod-eqpto IN FRAME fPage0 /* Equipamento */
DO:
   if avail ttOleo then do:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}
   end.
   else 
       assign fiDescModelo:screen-value in frame fPage0 = "".
        
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
  Notes:       Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Compartimento **/
if valid-handle(hDBOComp) then
    run Destroy in hDBOComp.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/
/** Descriá‰es dos campos **/
apply "LEAVE":U to ttOleo.cod-eqpto      in frame fPage0.
apply "LEAVE":U to ttOleo.cod-comptmento in frame fPage0.

if not can-find(first ttOleo) then
    assign btAddSon1:sensitive in frame fPage1 = no.
else 
    assign btAddSon1:sensitive in frame fPage1 = yes.

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
if pRowSon <> ? then do:
    /*:T Reposiciona registro com base no rowid do browse do programa AB0138 */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowSon).
end.

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

{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="ttOleo.ep-codigo"
    &KeyValue2="ttOleo.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

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
    
    DEFINE VARIABLE cdnEmpresa LIKE {&ttParent}.ep-codigo    NO-UNDO.
    DEFINE VARIABLE codEqpto   LIKE {&ttParent}.cod-eqpto      NO-UNDO.
    DEFINE VARIABLE codComp    LIKE {&ttParent}.cod-comptmento NO-UNDO.
    
    
    DEFINE FRAME fGoToRecord
        cdnEmpresa        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        codEqpto          AT ROW 2.21 COL 17.72 COLON-ALIGNED
        codComp           AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V† Para Compartimento Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cdnEmpresa
               codEqpto   
               codComp.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cdnEmpresa , INPUT codEqpto, INPUT codComp ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Compartimento Equipamento"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cdnEmpresa codEqpto codComp  btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr004.p":U THEN DO:
        run frbo/bofr004.p persistent set {&hDBOParent}.
    END.
    
    RUN setConstraintRowEquipamento IN {&hDBOParent} (input pRowPai) NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Equipamento":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr020.p":U THEN DO:
        run frbo/bofr020.p persistent set {&hDBOSon1}. 
    END.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo~\bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.
    
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
    
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="1"}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piElimina wMasterDetail 
PROCEDURE piElimina :
/*------------------------------------------------------------------------------
  Purpose:     piElimina
  Parameters:  <none>
  Notes:       Substitui o deleteRecord padr∆o
------------------------------------------------------------------------------*/
compartimento:
do transaction on error undo ,return "NOK":U 
               on stop  undo ,return "NOK":U:

    /** Elimina os registros das tabelas filhas do compartimento do equipamento **/
    run eliminaFilhos in {&hDBOParent} (input ttOleo.r-rowid).
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
        undo compartimento, return "NOK":U.
    end.
    
    /** Elimina o registro corrente do compartimento **/
    run deleteRecord in this-procedure.
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
        undo compartimento, return "NOK":U.
    end.

end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piManutencaoPai wMasterDetail 
PROCEDURE piManutencaoPai :
/*------------------------------------------------------------------------------
  Purpose:     piManutencaoPai
  Parameters:  entrada pAction = Aá∆o a ser feita no programa 
               (Add, Copy, Update)
  Notes:       Chama programa para manutená∆o do pai
------------------------------------------------------------------------------*/
define input parameter pAction as character no-undo.

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Executa programa de inclus∆o de pai ---*/
RUN abp/ab0138c1.w PERSISTENT SET hParentProgram (INPUT pRowPai,
                                                  INPUT rCurrentParent,
                                                  INPUT pAction,
                                                  INPUT THIS-PROCEDURE).

/* Novo mÇtodo de teste do valid-handle */    
IF VALID-HANDLE(hParentProgram) OR
   hParentProgram:TYPE = "PROCEDURE":U OR
   hParentProgram:FILE-NAME = "abp~\ab0138c1.w":U THEN
    /*--- Inicializa programa de inclus∆o de pai ---*/
    RUN initializeInterface IN hParentProgram.

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMasterDetail 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( cEvento as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescEvento
    Notes:  Busca Descriá∆o do campo Evento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mab-event fields(des-evento) 
    where mab-event.cod-evento = cEvento no-lock:
    assign cRetorno = mab-event.des-evento.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

