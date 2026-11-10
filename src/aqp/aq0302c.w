&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttProdutCargAux NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttProdutCargSave NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0302C 2.00.00.029 } /*** 010029 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0302c MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0302c
&GLOBAL-DEFINE Version        2.00.00.025

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Produtores

&GLOBAL-DEFINE First            NO
&GLOBAL-DEFINE Prev             NO
&GLOBAL-DEFINE Next             NO
&GLOBAL-DEFINE Last             NO
&GLOBAL-DEFINE GoTo             NO
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         tt-pto-coleta
&GLOBAL-DEFINE hDBOParent       h-boin00966
&GLOBAL-DEFINE DBOParentTable   pto-coleta
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-produt-carg
&GLOBAL-DEFINE hDBOSon1         h-boin00965
&GLOBAL-DEFINE DBOSon1Table     produt-carg
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-pto-coleta.cod-pto-coleta tt-pto-coleta.des-pto-coleta
&GLOBAL-DEFINE page1Browse      brSon1


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pd-qtd-coleta-ponto   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pi-num-carg           AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pc-cod-pto-coleta     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cdn-identif AS INTEGER   NO-UNDO.


DEFINE VARIABLE i-cdn-sit AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-linha   AS INTEGER INITIAL 0 NO-UNDO.


/* Shared Variable Definitions ---                                      */
DEFINE NEW SHARED VARIABLE v_cdn-identif AS INTEGER NO-UNDO.   
DEFINE     SHARED VARIABLE v_l-fraciona  AS LOGICAL  NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin00961   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin00967   AS HANDLE    NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-produt-carg

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-produt-carg.cdn-produt-rural ~
fn-produtor(tt-produt-carg.cdn-produt-rural) tt-produt-carg.cod-propried ~
tt-produt-carg.cdn-repos tt-produt-carg.qtd-coleta ~
tt-produt-carg.cod-docto-produt tt-produt-carg.cod-ser-docto-produt ~
tt-produt-carg.cod-model-docto-produt ~
fn-responsavel(input tt-produt-carg.cdn-produt-rural, input tt-produt-carg.cdn-produt-respons, input tt-produt-carg.cod-propried, input tt-produt-carg.cod-pto-coleta) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-produt-carg NO-LOCK ~
    BY tt-produt-carg.cdn-produt-rural ~
       BY tt-produt-carg.cod-propried
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-produt-carg NO-LOCK ~
    BY tt-produt-carg.cdn-produt-rural ~
       BY tt-produt-carg.cod-propried.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-produt-carg
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-produt-carg


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define ENABLED-TABLES tt-pto-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-pto-coleta
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btQueryJoins ~
btReportsJoins btExit btHelp i-num-carg c-cod-carga c-cod-placa 
&Scoped-Define DISPLAYED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define DISPLAYED-TABLES tt-pto-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-pto-coleta
&Scoped-Define DISPLAYED-OBJECTS i-num-carg c-cod-carga c-cod-placa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-produtor wMasterDetail 
FUNCTION fn-produtor RETURNS CHARACTER
  (iProdutRural AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-responsavel wMasterDetail 
FUNCTION fn-responsavel RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT, i-cdn-produt-respons AS INT, c-cod-propried AS CHAR, c-cod-pto-coleta AS CHAR )  FORWARD.

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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE VARIABLE c-cod-carga AS CHARACTER FORMAT "X(15)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-placa AS CHARACTER FORMAT "X(10)":U 
     LABEL "Placa" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carg AS INTEGER FORMAT "->>>,>>>,>>9":U INITIAL 0 
     LABEL "Carga" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 2.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 111 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-can 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE VARIABLE d-qtd-coleta AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Coleta" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-coleta-produt AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-coletiva AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Coletiva" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 7.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-produt-carg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-produt-carg.cdn-produt-rural COLUMN-LABEL "C¢d." FORMAT ">>>,>>>,>>9":U
      fn-produtor(tt-produt-carg.cdn-produt-rural) COLUMN-LABEL "Produtor" FORMAT "x(80)":U
            WIDTH 20
      tt-produt-carg.cod-propried FORMAT "x(30)":U WIDTH 18.72
      tt-produt-carg.cdn-repos FORMAT ">>>,>>9":U
      tt-produt-carg.qtd-coleta COLUMN-LABEL "Quantidade" FORMAT ">>>>,>>>,>>9.9999":U
      tt-produt-carg.cod-docto-produt COLUMN-LABEL "Docto" FORMAT "x(16)":U
      tt-produt-carg.cod-ser-docto-produt COLUMN-LABEL "S‚rie" FORMAT "x(05)":U
            WIDTH 5
      tt-produt-carg.cod-model-docto-produt COLUMN-LABEL "Modelo" FORMAT "x(05)":U
      fn-responsavel(input tt-produt-carg.cdn-produt-rural, input tt-produt-carg.cdn-produt-respons, input tt-produt-carg.cod-propried, input tt-produt-carg.cod-pto-coleta) COLUMN-LABEL "Respons vel" FORMAT "x(3)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 73 BY 7.33
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-pto-coleta.cod-pto-coleta AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 3 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     i-num-carg AT ROW 4 COL 15 COLON-ALIGNED WIDGET-ID 8
     c-cod-carga AT ROW 4 COL 50 COLON-ALIGNED WIDGET-ID 10
     c-cod-placa AT ROW 4 COL 85.43 COLON-ALIGNED WIDGET-ID 12
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111 BY 18.25
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     d-qtd-coleta-produt AT ROW 3.08 COL 86.72 COLON-ALIGNED WIDGET-ID 26
     bt-can AT ROW 4 COL 96.72 WIDGET-ID 34
     bt-sav AT ROW 4 COL 100.72 WIDGET-ID 36
     btAddSon1 AT ROW 8.58 COL 76
     btDeleteSon1 AT ROW 8.58 COL 86
     d-qtd-coleta AT ROW 8.83 COL 12 COLON-ALIGNED WIDGET-ID 2
     d-qtd-coletiva AT ROW 8.83 COL 49 COLON-ALIGNED WIDGET-ID 4
     RECT-2 AT ROW 1.25 COL 76.14 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.75
         SIZE 106.43 BY 9.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: ttProdutCargAux T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: ttProdutCargSave T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
         HEIGHT             = 15.79
         WIDTH              = 110.86
         MAX-HEIGHT         = 18.25
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 18.25
         VIRTUAL-WIDTH      = 114.14
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
/* BROWSE-TAB brSon1 RECT-2 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-produt-carg"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-produt-carg.cdn-produt-rural|yes,Temp-Tables.tt-produt-carg.cod-propried|yes"
     _FldNameList[1]   > Temp-Tables.tt-produt-carg.cdn-produt-rural
"tt-produt-carg.cdn-produt-rural" "C¢d." ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-produtor(tt-produt-carg.cdn-produt-rural)" "Produtor" ? ? ? ? ? ? ? ? no "Produtor Rural" no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-produt-carg.cod-propried
"tt-produt-carg.cod-propried" ? ? "character" ? ? ? ? ? ? no ? no no "18.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-produt-carg.cdn-repos
     _FldNameList[5]   > Temp-Tables.tt-produt-carg.qtd-coleta
"tt-produt-carg.qtd-coleta" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-produt-carg.cod-docto-produt
"tt-produt-carg.cod-docto-produt" "Docto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-produt-carg.cod-ser-docto-produt
"tt-produt-carg.cod-ser-docto-produt" "S‚rie" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-produt-carg.cod-model-docto-produt
"tt-produt-carg.cod-model-docto-produt" "Modelo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fn-responsavel(input tt-produt-carg.cdn-produt-rural, input tt-produt-carg.cdn-produt-respons, input tt-produt-carg.cod-propried, input tt-produt-carg.cod-pto-coleta)" "Respons vel" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    IF NOT v_l-fraciona THEN
        ASSIGN tt-produt-carg.qtd-coleta:FORMAT IN BROWSE brSon1 = "->>>,>>>,>>9":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
/* Logica incluida no main-block */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wMasterDetail
ON CHOOSE OF bt-can IN FRAME fPage1 /* Can */
DO: 
    IF AVAILABLE {&ttSon1} THEN DO:            
        ASSIGN d-qtd-coleta-produt:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttSon1}.qtd-coleta).
              
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wMasterDetail
ON CHOOSE OF bt-sav IN FRAME fPage1 /* Sav */
DO:
    GET CURRENT brSon1 NO-LOCK.
        
    ASSIGN pi-cdn-identif = tt-produt-carg.cdn-identif WHEN AVAILABLE tt-produt-carg.    

    RUN pi-save IN THIS-PROCEDURE. 

    RUN openQueriesSon IN THIS-PROCEDURE.

    FIND FIRST tt-produt-carg NO-LOCK 
         WHERE tt-produt-carg.cdn-identif = pi-cdn-identif NO-ERROR.

    REPOSITION brSon1 TO ROWID ROWID(tt-produt-carg) NO-ERROR.

    brSon1:SELECT-NEXT-ROW().

    APPLY "ENTRY":U TO d-qtd-coleta IN FRAME fPage1.
    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:                           
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.    
    
    ASSIGN pi-cdn-identif = tt-produt-carg.cdn-identif WHEN AVAILABLE tt-produt-carg.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0302d.w PERSISTENT SET h-prog-desp (INPUT ?,
                                                  INPUT {&ttParent}.r-rowid,
                                                  INPUT "Add":U,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 0,
                                                  INPUT pi-cdn-identif).
      
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
         
        SESSION:SET-WAIT-STATE("":U).
         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
    
    IF pi-cdn-identif = ? THEN   
        FIND FIRST tt-produt-carg NO-ERROR.
    ELSE DO:
        RUN openQueriesSon IN THIS-PROCEDURE.        
        FIND FIRST tt-produt-carg 
             WHERE tt-produt-carg.cdn-identif = pi-cdn-identif NO-ERROR.
    END.     
 
    IF AVAILABLE tt-produt-carg THEN
       REPOSITION brSon1 TO ROWID ROWID(tt-produt-carg) NO-ERROR.

    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:

    IF CAN-FIND(FIRST produt-pto-coleta
                WHERE produt-pto-coleta.cdn-produt-rural = {&ttSon1}.cdn-produt-rural
                  AND produt-pto-coleta.cod-propried     = {&ttSon1}.cod-propried
                  AND produt-pto-coleta.cod-pto-coleta   = {&ttSon1}.cod-pto-coleta
                  AND produt-pto-coleta.log-respons) THEN DO:

        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT  54618, /*      Produtor respons vel nÆo pode ser deletado. */
                          INPUT ""). 
        RETURN "NOK":U.
    END.
    
    RUN goToKey IN {&hDBOSon1} (INPUT {&ttSon1}.cdn-identif).

    IF RETURN-VALUE = 'OK' THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT  3051, /* Confirma elimina‡Æo */
                          INPUT "").
         IF RETURN-VALUE = 'YES' THEN DO:

             IF i-cdn-sit = 6 THEN
                RUN pi-chama-aq0302b IN THIS-PROCEDURE.

             RUN deleteRecord IN {&hDBOSon1}.
             EMPTY TEMP-TABLE RowErrors NO-ERROR.

             RUN getRowErrors IN {&hDBOSon1} (OUTPUT TABLE RowErrors).  
             IF CAN-FIND(FIRST RowErrors
                         WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                 {method/showmessage.i1}
                 {method/showmessage.i2}
                 RETURN NO-APPLY.
             END.

             RUN openQueriesSon IN THIS-PROCEDURE.

         END.
    END.
    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain 
OR WINDOW-CLOSE OF wMasterDetail DO:
    DEFINE VARIABLE l-close AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-opcao AS INTEGER NO-UNDO.

    IF AVAIL {&ttSon1} THEN DO:
        RUN setConstraintRatearDiferenca IN {&hDBOSon1} (INPUT {&ttSon1}.num-carg,
                                                         INPUT {&ttSon1}.cod-pto-coleta,
                                                         INPUT {&ttSon1}.cdn-compart,
                                                         INPUT {&ttSon1}.cdn-repos,
                                                         INPUT pd-qtd-coleta-ponto, 
                                                         INPUT d-qtd-coletiva).
          
        RUN verificaRateio IN {&hDBOSon1}.
        IF RETURN-VALUE = 'OK' THEN DO:
            RUN aqp/aq0302ca.w(INPUT  pd-qtd-coleta-ponto - d-qtd-coletiva, INPUT d-qtd-coletiva, OUTPUT i-opcao).         
            IF i-opcao = 1 THEN DO: /* ratear */
                RUN ratearDiferenca IN {&hDBOSon1}. 
                ASSIGN l-close = YES.
            END.            
            ELSE IF i-opcao = 0 THEN /* Voltar */
                RETURN NO-APPLY.
            ELSE /* Atualizar */
               ASSIGN l-close = YES.
                
        END.
        ELSE 
            ASSIGN l-close = YES.
        
        
        IF l-close THEN DO:
            APPLY "CLOSE":U TO THIS-PROCEDURE.
            RETURN NO-APPLY.  
        END.
    END.
    ELSE DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.  
    END.

   
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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    {masterdetail/valuechanged.i &PageNumber="1"}

    IF AVAILABLE {&ttSon1} THEN DO:
        IF NUM-ENTRIES ("brSon1":U) > 0 THEN DO:
            GET CURRENT brSon1 NO-LOCK.
            ASSIGN d-qtd-coleta-produt:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttSon1}.qtd-coleta)
                   d-qtd-coleta-produt:SENSITIVE    IN FRAME fPage1 = YES.
        END.
    END.  
    ELSE DO:
        ASSIGN bt-can:SENSITIVE                 IN FRAME fPage1 = NO
               bt-sav:SENSITIVE                 IN FRAME fPage1 = NO
               d-qtd-coleta-produt:SENSITIVE    IN FRAME fPage1 = NO
               d-qtd-coleta-produt:SCREEN-VALUE IN FRAME fPage1 = "".
    END.

    APPLY "ENTRY":U TO d-qtd-coleta-produt IN FRAME fPage1.

END.


ON RETURN OF FRAME fPage1 ANYWHERE 
DO: 
    APPLY 'choose':U TO bt-sav IN FRAME fPage1.
END.

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


    IF VALID-HANDLE({&hDBOParent}) AND
        {&hDBOParent}:TYPE = "PROCEDURE":U AND
        {&hDBOParent}:FILE-NAME = "inbo/boin00966.p":U THEN DO:
        DELETE PROCEDURE {&hDBOParent}.
        ASSIGN {&hDBOParent} = ?.
    END.

    IF VALID-HANDLE({&hDBOSon1}) AND
        {&hDBOSon1}:TYPE = "PROCEDURE":U AND
        {&hDBOSon1}:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE {&hDBOSon1}.
        ASSIGN {&hDBOSon1} = ?.
    END.
        
    IF VALID-HANDLE(h-boin00961) AND
        h-boin00961:TYPE = "PROCEDURE":U AND
        h-boin00961:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE h-boin00961.
        ASSIGN h-boin00961 = ?.
    END.

    IF VALID-HANDLE(h-boad098) AND
        h-boad098:TYPE = "PROCEDURE":U AND
        h-boad098:FILE-NAME = "adbo/boad098.p":U THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boin00967) AND
        h-boin00967:TYPE = "PROCEDURE":U AND
        h-boin00967:FILE-NAME = "inbo/boin00967.p":U THEN DO:
        DELETE PROCEDURE h-boin00967.
        ASSIGN h-boin00967 = ?.
    END.

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
    DEFINE VARIABLE c-format AS CHARACTER NO-UNDO.

    RUN getIntField IN h-boin00961 (INPUT "num-carg":U, OUTPUT i-num-carg) NO-ERROR.
    ASSIGN i-num-carg:SCREEN-VALUE IN FRAME fPage0 = STRING(i-num-carg).

    RUN getCharField IN h-boin00961 (INPUT "cod-carga":U, OUTPUT c-cod-carga) NO-ERROR.
    ASSIGN c-cod-carga:SCREEN-VALUE IN FRAME fPage0 = c-cod-carga.

    RUN getCharField IN h-boin00961 (INPUT "cod-placa":U, OUTPUT c-cod-placa) NO-ERROR.
    ASSIGN c-cod-placa:SCREEN-VALUE IN FRAME fPage0 = c-cod-placa.

    RUN getIntField IN h-boin00961 (INPUT "cdn-sit":U, OUTPUT i-cdn-sit) NO-ERROR.
    IF NOT v_l-fraciona THEN
        ASSIGN c-format = "->>>,>>>,>>9":U
               d-qtd-coleta-produt:FORMAT IN FRAME fPage1 = ">>>,>>>,>>9":U
               d-qtd-coleta:FORMAT        IN FRAME fPage1 = c-format
               d-qtd-coletiva:FORMAT      IN FRAME fPage1 = c-format.

    {&OPEN-QUERY-brSon1}

    RETURN 'OK':U.
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
    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
    RUN pi-posicionar IN THIS-PROCEDURE (INPUT NO).
    
    RETURN 'OK':U.
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
    {utp/ut-liter.i Quantidade * R }
    ASSIGN d-qtd-coleta-produt:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE). 

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaValores wMasterDetail 
PROCEDURE carregaValores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN d-qtd-coletiva = 0
           d-qtd-coleta   = pd-qtd-coleta-ponto.

    DISP d-qtd-coleta WITH FRAME fPage1.
    
    FOR EACH {&ttSon1}:
        ASSIGN d-qtd-coletiva = d-qtd-coletiva + {&ttSon1}.qtd-coleta.
    END.

    ASSIGN d-qtd-coletiva:SCREEN-VALUE IN FRAME fPage1 = STRING(d-qtd-coletiva).

    IF NOT CAN-FIND(FIRST produt-pto-coleta
                    WHERE produt-pto-coleta.cdn-produt-rural = {&ttSon1}.cdn-produt-rural
                      AND produt-pto-coleta.cod-propried     = {&ttSon1}.cod-propried
                      AND produt-pto-coleta.log-respons) THEN DO:

        ASSIGN d-qtd-coletiva:BGCOLOR IN FRAME fPage1 = ?.
        ASSIGN d-qtd-coletiva:FGCOLOR in FRAME fPage1 = 0.

    END.
    
    IF d-qtd-coleta = d-qtd-coletiva THEN                   
        ASSIGN d-qtd-coletiva:BGCOLOR IN FRAME fPage1 = 2.              
    ELSE
        ASSIGN d-qtd-coletiva:BGCOLOR IN FRAME fPage1 = 12.
        
    ASSIGN d-qtd-coletiva:FGCOLOR in FRAME fPage1 = 15.

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
    DEFINE VARIABLE iRowid AS INTEGER NO-UNDO.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' {&hDBOSon1}} 
    END.   

     RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.


    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOParent}} 
    END.
      
    RUN setConstraintCodigo IN {&hDBOParent} (INPUT pc-cod-pto-coleta, INPUT pc-cod-pto-coleta) NO-ERROR.  

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Codigo":U) NO-ERROR.
    
    RUN getBatchRecords IN {&hDBOParent} (INPUT ?,
                                          INPUT NO,
                                          INPUT 9999,
                                          OUTPUT iRowid,
                                          OUTPUT TABLE {&ttParent}).
    FIND FIRST {&ttParent} NO-ERROR.                                      
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00961) OR
       h-boin00961:TYPE <> "PROCEDURE":U OR
       h-boin00961:FILE-NAME <> "inbo/boin00961.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' h-boin00961} 
    END.
        
    RUN setConstraintNumCarg IN h-boin00961 (INPUT pi-num-carg, INPUT pi-num-carg) NO-ERROR.

    RUN openQueryStatic IN h-boin00961 (INPUT "NumCarg":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boad098) OR 
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098} 
    END.
    
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00967) OR 
       h-boin00967:TYPE <> "PROCEDURE":U OR
       h-boin00967:FILE-NAME <> "inbo/boin00967.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00967.p YES}
        {btb/btb008za.i2 inbo/boin00967.p '' h-boin00967} 
    END.
    
    RUN openQueryStatic IN h-boin00967 (INPUT "Main":U) NO-ERROR.

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
                                   
    RUN buscaProdutoresColetivos IN {&hDBOSon1}(INPUT pi-cdn-identif, 
                                                OUTPUT TABLE {&ttSon1}).                                   
    {&OPEN-QUERY-brSon1}                       
    FIND FIRST {&ttSon1} NO-ERROR.     
    IF AVAIL {&ttSon1} THEN DO:
        ASSIGN bt-can:SENSITIVE IN FRAME fPage1 = YES  
               bt-sav:SENSITIVE IN FRAME fPage1 = YES
               btAddSon1:SENSITIVE IN FRAME fPage1 = YES
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES.
        RUN carregaValores IN THIS-PROCEDURE.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-aq0302b wMasterDetail 
PROCEDURE pi-chama-aq0302b :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-texto AS CHARACTER   NO-UNDO.

    DO WHILE c-texto = "":       
        RUN aqp/aq0302b.w (INPUT-OUTPUT c-texto).
        RUN setConstraintTexto IN {&hDBOSon1}(INPUT c-texto).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicionar wMasterDetail 
PROCEDURE pi-posicionar PRIVATE :
/*------------------------------------------------------------------------------
  Purpose: Reposicionar browse no próx registro a ser atualizado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT param l-soma AS LOGICAL NO-UNDO.
    
    IF l-soma THEN
        ASSIGN i-linha = brSon1:FOCUSED-ROW IN FRAME fPage1 + 1. /*quando chamado pelo botão salvar, posiciona na próxima linha*/

    REPOSITION brSon1 TO ROW (i-linha) NO-ERROR. 

    IF AVAIL {&ttSon1} THEN
        ASSIGN d-qtd-coleta-produt:SCREEN-VALUE IN FRAME  fPage1 = STRING({&ttSon1}.qtd-coleta ).
    APPLY "ENTRY":U TO d-qtd-coleta-produt IN FRAME fPage1.
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save wMasterDetail 
PROCEDURE pi-save :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-texto AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE i-cdn-identif AS INTEGER NO-UNDO.

    IF  AVAIL {&ttSon1}
    AND {&ttSon1}.qtd-coleta = DECIMAL(d-qtd-coleta-produt:SCREEN-VALUE IN FRAME fPage1)THEN 
        RETURN "NOK":U.

    IF i-cdn-sit = 6 THEN
        RUN pi-chama-aq0302b IN THIS-PROCEDURE.

    RUN goToKey IN {&hDBOSon1} (INPUT {&ttSon1}.cdn-identif) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        EMPTY TEMP-TABLE ttProdutCargSave NO-ERROR.                  
        RUN getRecord IN {&hDBOSon1} (OUTPUT TABLE ttProdutCargSave).
        FOR FIRST ttProdutCargSave:                                  
            ASSIGN ttProdutCargSave.qtd-coleta = DECIMAL(d-qtd-coleta-produt:SCREEN-VALUE IN FRAME fPage1).
        
            RUN setRecord      IN {&hDBOSon1} (INPUT TABLE ttProdutCargSave).
            RUN emptyRowErrors IN {&hDBOSon1}.
            RUN updateRecord   IN {&hDBOSon1}. 
            
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN {&hDBOSon1} (OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                    RETURN NO-APPLY.
                END.    
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-produtor wMasterDetail 
FUNCTION fn-produtor RETURNS CHARACTER
  (iProdutRural AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE RESULT AS CHARACTER FORMAT "X(80)" NO-UNDO.
                   
    RUN findCodigo IN h-boad098(INPUT iProdutRural, 
                                OUTPUT RESULT).
    IF RESULT = "" THEN DO:        
        RUN goToKey IN h-boad098 (INPUT iProdutRural) NO-ERROR.
        RUN getCharfield IN h-boad098(INPUT "nome-emit", OUTPUT RESULT).
    END.
    
    RETURN RESULT.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-responsavel wMasterDetail 
FUNCTION fn-responsavel RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT, i-cdn-produt-respons AS INT, c-cod-propried AS CHAR, c-cod-pto-coleta AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

    IF CAN-FIND(FIRST produt-pto-coleta
                WHERE produt-pto-coleta.cdn-produt-rural = i-cdn-produt-rural
                  AND produt-pto-coleta.cod-propried     = c-cod-propried
                  AND produt-pto-coleta.cod-pto-coleta   = c-cod-pto-coleta
                  AND produt-pto-coleta.log-respons) THEN DO:

        {utp/ut-liter.i Sim *}
    END.
    ELSE DO:
        {utp/ut-liter.i NÆo * }
    END.

  RETURN RETURN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

