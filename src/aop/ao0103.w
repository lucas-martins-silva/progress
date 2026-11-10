&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-tip-mater NO-UNDO LIKE mab-tip-mater
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mao-ensaio-padr NO-UNDO LIKE mao-ensaio-padr
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
{include/i-prgvrs.i AO0103 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0103 MAO}
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
&GLOBAL-DEFINE Program          AO0103
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Ensaios

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

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         tt-mab-tip-mater
&GLOBAL-DEFINE hDBOParent       HDBOmab-tip-mater
&GLOBAL-DEFINE DBOParentTable   mab-tip-mater
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-mao-ensaio-padr
&GLOBAL-DEFINE hDBOSon1         HDBOmao-ensaio-padr
&GLOBAL-DEFINE DBOSon1Table     mao-ensaio-padr
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-mab-tip-mater.cod-tip-mater ~
                                tt-mab-tip-mater.des-tip-mater

&GLOBAL-DEFINE page1Browse      brSon1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescModelo   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE cDescEnsaio   AS CHARACTER FORMAT "X(30)" NO-UNDO.
DEFINE VARIABLE c-modelo-ini  AS CHARACTER FORMAT "X(08)" INITIAL "":U         NO-UNDO.
DEFINE VARIABLE c-modelo-fim  AS CHARACTER FORMAT "X(08)" INITIAL "ZZZZZZZZ":U NO-UNDO.
DEFINE VARIABLE lOK           AS LOGICAL INITIAL NO   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-mao-ensaio-padr

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-mao-ensaio-padr.cod-model ~
fnDescModel (tt-mao-ensaio-padr.cod-model) @ cDescModelo ~
tt-mao-ensaio-padr.cod-ensaio ~
fnDescEnsaio(tt-mao-ensaio-padr.cod-ensaio) @ cDescEnsaio ~
tt-mao-ensaio-padr.log-padrao tt-mao-ensaio-padr.num-tabela ~
tt-mao-ensaio-padr.des-formato tt-mao-ensaio-padr.des-val-min ~
tt-mao-ensaio-padr.des-val-max 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-mao-ensaio-padr NO-LOCK ~
    BY tt-mao-ensaio-padr.cod-tip-mater ~
       BY tt-mao-ensaio-padr.cod-model ~
        BY tt-mao-ensaio-padr.cod-ensaio
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-mao-ensaio-padr NO-LOCK ~
    BY tt-mao-ensaio-padr.cod-tip-mater ~
       BY tt-mao-ensaio-padr.cod-model ~
        BY tt-mao-ensaio-padr.cod-ensaio.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-mao-ensaio-padr
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-mao-ensaio-padr


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-tip-mater.cod-tip-mater ~
tt-mab-tip-mater.des-tip-mater 
&Scoped-define ENABLED-TABLES tt-mab-tip-mater
&Scoped-define FIRST-ENABLED-TABLE tt-mab-tip-mater
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btCopy btQueryJoins btReportsJoins btExit btHelp rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-tip-mater.cod-tip-mater ~
tt-mab-tip-mater.des-tip-mater 
&Scoped-define DISPLAYED-TABLES tt-mab-tip-mater
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-tip-mater


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEnsaio wMasterDetail 
FUNCTION fnDescEnsaio RETURNS CHARACTER
  ( pcodensaio AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescModel wMasterDetail 
FUNCTION fnDescModel RETURNS CHARACTER
  ( pcodmodel AS CHAR )  FORWARD.

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
       MENU-ITEM m_Copiar       LABEL "&Copiar"        ACCELERATOR "CTRL-C"
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
DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

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

DEFINE BUTTON Btfil 
     IMAGE-UP FILE "image~\gr-par.bmp":U
     IMAGE-INSENSITIVE FILE "image~\ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4.14 BY 1.25.

DEFINE BUTTON btUpdateSon1 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-mao-ensaio-padr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-mao-ensaio-padr.cod-model FORMAT "x(8)":U WIDTH 8
      fnDescModel (tt-mao-ensaio-padr.cod-model) @ cDescModelo COLUMN-LABEL "Descriá∆o"
            WIDTH 40
      tt-mao-ensaio-padr.cod-ensaio FORMAT "x(8)":U WIDTH 8
      fnDescEnsaio(tt-mao-ensaio-padr.cod-ensaio) @ cDescEnsaio COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      tt-mao-ensaio-padr.log-padrao FORMAT "Sim/N∆o":U
      tt-mao-ensaio-padr.num-tabela FORMAT ">>>>9":U WIDTH 6
      tt-mao-ensaio-padr.des-formato FORMAT "x(60)":U
      tt-mao-ensaio-padr.des-val-min FORMAT "x(60)":U
      tt-mao-ensaio-padr.des-val-max FORMAT "x(60)":U
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
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-mab-tip-mater.cod-tip-mater AT ROW 2.83 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-mab-tip-mater.des-tip-mater AT ROW 2.83 COL 34.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     Btfil AT ROW 10.29 COL 80
     btAddSon1 AT ROW 10.33 COL 2
     btCopySon1 AT ROW 10.33 COL 12
     btUpdateSon1 AT ROW 10.33 COL 22
     btDeleteSon1 AT ROW 10.33 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.72 ROW 5.63
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-tip-mater T "?" NO-UNDO mgfro mab-tip-mater
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mao-ensaio-padr T "?" NO-UNDO mgfro mao-ensaio-padr
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
         HEIGHT             = 15.96
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
     _TblList          = "Temp-Tables.tt-mao-ensaio-padr"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-mao-ensaio-padr.cod-tip-mater|yes,Temp-Tables.tt-mao-ensaio-padr.cod-model|yes,Temp-Tables.tt-mao-ensaio-padr.cod-ensaio|yes"
     _FldNameList[1]   > Temp-Tables.tt-mao-ensaio-padr.cod-model
"tt-mao-ensaio-padr.cod-model" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnDescModel (tt-mao-ensaio-padr.cod-model) @ cDescModelo" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-mao-ensaio-padr.cod-ensaio
"tt-mao-ensaio-padr.cod-ensaio" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"fnDescEnsaio(tt-mao-ensaio-padr.cod-ensaio) @ cDescEnsaio" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.tt-mao-ensaio-padr.log-padrao
     _FldNameList[6]   > Temp-Tables.tt-mao-ensaio-padr.num-tabela
"tt-mao-ensaio-padr.num-tabela" ? ? "integer" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" ""
     _FldNameList[7]   = Temp-Tables.tt-mao-ensaio-padr.des-formato
     _FldNameList[8]   = Temp-Tables.tt-mao-ensaio-padr.des-val-min
     _FldNameList[9]   = Temp-Tables.tt-mao-ensaio-padr.des-val-max
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    assign lOK = no.
    run openQueriesSon in this-procedure.
    {masterdetail/addson.i &ProgramSon="aop/ao0103a.w"
                           &PageNumber="1"}
    run openQueriesSon in this-procedure.                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM m_Copiar IN MENU mbMain DO:

    RUN piCopiaFilhos IN THIS-PROCEDURE.
    apply "ENTRY":U to btcopy in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    assign lOK = no.   
    run openQueriesSon in this-procedure.
    {masterdetail/copyson.i &ProgramSon="aop/ao0103a.w"
                            &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}
    if num-results("brSon1":U) > 0 then
       assign Btfil:sensitive in frame fPage1 = yes.
    else    
       assign Btfil:sensitive in frame fPage1 = no.

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
&Scoped-define SELF-NAME Btfil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btfil wMasterDetail
ON CHOOSE OF Btfil IN FRAME fPage1 /* Filtro */
DO:
  assign {&window-name}:sensitive = no.
  run piFiltro in THIS-PROCEDURE.
  assign {&window-name}:sensitive = yes.

  apply "ENTRY":U to BtFil in frame fPage1.
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr026.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="aop/ao0103a.w"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL {&ttParent} THEN 
    ASSIGN btcopy:SENSITIVE IN FRAME fpage0 = YES.
ELSE 
    ASSIGN btcopy:SENSITIVE IN FRAME fpage0 = no.



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
IF AVAIL {&ttParent} THEN
    ASSIGN btcopy:SENSITIVE IN FRAME fpage0 = YES
           Btfil:sensitive  in frame fPage1 = yes.
ELSE 
    ASSIGN btcopy:SENSITIVE IN FRAME fpage0 = no
           Btfil:sensitive  in frame fPage1 = NO.

RETURN "OK":U.
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
    
    DEFINE VARIABLE cCodTpMater LIKE {&ttParent}.cod-tip-mater   view-as  fill-in  size  10.00 BY 0.88 no-undo.

    DEFINE FRAME fGoToRecord
        cCodTpMater       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V†_Para_Tipo_Material *}
    assign frame fGoToRecord:title = return-value.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodTpMater .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cCodTpMater ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Tipo_Material * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE ).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodTpMater  btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "frbo/bofr026.p":U THEN DO:
        RUN frbo/bofr026.p PERSISTENT SET  {&hDBOParent}.
    END.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR  
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr104.p":U THEN DO:
      RUN frbo/bofr104.p PERSISTENT SET  {&hDBOSon1}.
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
IF lOK THEN DO:
       /** Restriá‰es por Modelo **/
   run setConstraintFiltro in {&hDBOSon1} (input c-modelo-ini,     
                                           input c-modelo-fim).  

    {masterdetail/openqueriesson.i &Parent="TipoMaterial"
                                   &Query="Filtro"
                                   &PageNumber="1"}

end.
else do:

    {masterdetail/openqueriesson.i &Parent="TipoMaterial"
                                   &Query="TipoMaterial"
                                   &PageNumber="1"}

 end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCopiaFilhos wMasterDetail 
PROCEDURE piCopiaFilhos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable hEnsaios     as handle    no-undo.
       
for first {&ttParent}
    where {&ttParent}.cod-tip-mater = INPUT FRAME Fpage0 {&ttParent}.cod-tip-mater no-lock:
                   
    if AVAIL {&ttParent} then DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    assign {&window-name}:sensitive = no.
    
    /*--- Executa programa de inclus∆o de filho ---*/
    Run aop/ao0103c.w PERSISTENT SET hEnsaios.
     
    IF VALID-HANDLE(hEnsaios)
    AND hEnsaios:Type = "PROCEDURE":U 
    AND hEnsaios:FILE-NAME = "aop/ao0103c.w":U THEN
    /*--- Inicializa programa de inclus∆o de filho ---*/
    Run initializeInterface IN hEnsaios.
    run setaMaterial in hEnsaios (input {&ttParent}.r-rowid ).
     
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    wait-for "CLOSE":U of hEnsaios.
    assign {&window-name}:sensitive = yes.
     
    if valid-handle(hEnsaios) then
        delete procedure hEnsaios.
 END.
END.

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
assign lOK = no.
run aop/ao0103b.w (input-output  c-modelo-ini,
                   INPUT-OUTPUT  c-modelo-fim,
                   input-output  lOK).


run openQueriesSon in this-procedure.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEnsaio wMasterDetail 
FUNCTION fnDescEnsaio RETURNS CHARACTER
  ( pcodensaio AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER FORMAT "x(30)" NO-UNDO.
  FOR FIRST mao-ensaio FIELDS (des-ensaio)
      WHERE mao-ensaio.cod-ensaio = pcodensaio NO-LOCK:
  END.
  IF AVAIL mao-ensaio THEN DO:
      ASSIGN cDesc = mao-ensaio.des-ensaio. 
      RETURN cDesc.
  END.
  ELSE DO:
     RETURN "".
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescModel wMasterDetail 
FUNCTION fnDescModel RETURNS CHARACTER
  ( pcodmodel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER FORMAT "x(40)" NO-UNDO.
  FOR FIRST mab-model FIELDS (des-model)
      WHERE mab-model.cod-model = pcodmodel NO-LOCK:
  END.
  IF AVAIL mab-model THEN DO:
      ASSIGN cDesc = mab-model.des-model. 
      RETURN cDesc.
  END.
  ELSE DO:
     {utp/ut-liter.i Todos_os_Modelos_de_Equipamentos * }
     RETURN return-value.
  END.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

