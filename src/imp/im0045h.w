&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque2 NO-UNDO LIKE ordens-embarque
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0045H 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0045h MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.
{cxbo/bocx220d.i tt-ordens}
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0045H
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE Folder         No
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE DBOVersion      1.1

&GLOBAL-DEFINE FolderLabels   Ordens

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-ordens
&GLOBAL-DEFINE hDBOTable      h-bocx220d
&GLOBAL-DEFINE DBOTable       embarque-imp

&GLOBAL-DEFINE page0KeyFields cEmbarque ~
                              cCodEstabel
                              
&GLOBAL-DEFINE page0Fields cIdentificContainer ~
                           cTipoContainer ~
            			   dDtPrevDev ~
			               dDtDevol

&GLOBAL-DEFINE page1Fields 

/*&GLOBAL-DEFINE page2Fields    */

/* Parameters Definitions ---                                           */

def input param pcod-estabel as char no-undo.
def input param pembarque as char no-undo.


define temp-table tt-parametro NO-UNDO like tt-ordens.
define buffer b-tt-ordens for tt-ordens.
define temp-table tt-delordem no-undo
     field r-rowid as rowid.

/* Local Variable Definitions ---                                       */
def var c-embarque    LIKE embarque-imp.embarque no-undo.
def var c-cod-estabel as char no-undo.
def var iRowresturned as int no-undo.
def var rowsreturn    as integer no-undo.

def var cAntIdentificCont as char no-undo.
def var cAntTipoCont      as char no-undo.
def var dAntDataPrevDev   as date no-undo.
def var dAntDataDevol     as date no-undo.

def var i-cont          as int no-undo.
def var i-cont-2        as int no-undo.
def var lprox           as logical initial yes no-undo.
def var lant            as logical initial yes no-undo.
def var lSituacao       as logical no-undo.
def var lnovomod        as logical no-undo.
def var c-embar-ant     LIKE embarque-imp.embarque no-undo.
def var c-cod-estab-ant as char no-undo.
def var pidentific      as char no-undo.
def var ptipo           as char no-undo.
def var cReturn         as char no-undo.
def var r-rowid         as rowid no-undo.
def var lreturn         as logical no-undo.
def var c-un            LIKE ITEM.un no-undo.
def var c-un-fornec     LIKE cotacao-item.un no-undo.
def var c-un2           LIKE ITEM.un no-undo.
def var c-un-fornec2    LIKE cotacao-item.un no-undo.
    
/* Local Variable Definitions (DBOs Handles) --- */

DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx220     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225-2   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin082     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274     AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordens-embarque2 tt-ordens-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-embarque2.numero-ordem ~
tt-ordens-embarque2.parcela tt-ordens-embarque2.quantidade ~
fnUn(fnItem(tt-ordens-embarque2.numero-ordem)) @ c-un ~
tt-ordens-embarque2.qt-do-forn ~
fnUnFornec(tt-ordens-embarque2.numero-ordem) @ c-un-fornec 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-embarque2 NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-ordens-embarque2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-embarque2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-embarque2


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-embarque.numero-ordem ~
tt-ordens-embarque.parcela tt-ordens-embarque.quantidade ~
fnUn(fnItem(tt-ordens-embarque.numero-ordem)) @ c-un2 ~
tt-ordens-embarque.qt-do-forn ~
fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-ordens-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtToolBar btFirst btPrev ~
btNext btLast btAdd btUpdate btCancel btSave btQueryJoins btReportsJoins ~
btExit btHelp cIdentificContainer cTipoContainer dDtPrevDev ~
dDtDevol 
&Scoped-Define DISPLAYED-OBJECTS cembarque cCodEstabel cIdentificContainer ~
cTipoContainer dDtPrevDev dDtDevol 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMaintenance 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMaintenance 
FUNCTION fnUn RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMaintenance 
FUNCTION fnUnFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       RULE
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\im-can":U
     LABEL "Cancel" 
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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cCodEstabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque AS CHARACTER FORMAT "X(16)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE cIdentificContainer AS CHARACTER FORMAT "X(20)" 
     LABEL "Identificaá∆o Container" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE dDtPrevDev AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Prev. Devoluá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cTipoContainer AS CHARACTER FORMAT "X(20)" 
     LABEL "Tipo Container" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE dDtDevol AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Devoluá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.58
     BGCOLOR 7 .

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image\add-all":U
     IMAGE-INSENSITIVE FILE "image\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btcarac 
     LABEL "Caracter°sticas" 
     SIZE 13.57 BY 1.

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image\del-all":U
     IMAGE-INSENSITIVE FILE "image\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-embarque2 SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-ordens-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenance _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-ordens-embarque2.numero-ordem FORMAT "zzzzz9,99":U
      tt-ordens-embarque2.parcela FORMAT ">>>>9":U
      tt-ordens-embarque2.quantidade FORMAT ">>>>>,>>9.9999":U
      fnUn(fnItem(tt-ordens-embarque2.numero-ordem)) @ c-un COLUMN-LABEL "Un" FORMAT "xx":U
      tt-ordens-embarque2.qt-do-forn COLUMN-LABEL "Qtde Fornec" FORMAT ">>>>>,>>9.9999":U
      fnUnFornec(tt-ordens-embarque2.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8.46
         FONT 1.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMaintenance _STRUCTURED
  QUERY brSon2 DISPLAY
      tt-ordens-embarque.numero-ordem FORMAT "zzzzz9,99":U
      tt-ordens-embarque.parcela FORMAT ">>>>9":U
      tt-ordens-embarque.quantidade FORMAT ">>>>>,>>9.9999":U
      fnUn(fnItem(tt-ordens-embarque.numero-ordem)) @ c-un2 COLUMN-LABEL "Un" FORMAT "xx":U
      tt-ordens-embarque.qt-do-forn COLUMN-LABEL "Qtde Fornec" FORMAT ">>>>>,>>9.9999":U
      fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8.46
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.17 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.17 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.17 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.17 COL 13.57 HELP
          "Èltima ocorrància"
     btAdd AT ROW 1.17 COL 31 HELP
          "Inclui nova ocorrància"
     btUpdate AT ROW 1.17 COL 35.14 HELP
          "Altera ocorrància corrente"
     btCancel AT ROW 1.17 COL 39.43 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.17 COL 43.57 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.17 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86.72 HELP
          "Ajuda"
     cembarque AT ROW 2.75 COL 20 COLON-ALIGNED
     cCodEstabel AT ROW 2.75 COL 55 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R7
     cIdentificContainer AT ROW 3.96 COL 20 COLON-ALIGNED
     cTipoContainer AT ROW 3.96 COL 55 COLON-ALIGNED
     dDtPrevDev AT ROW 4.88 COL 20 COLON-ALIGNED WIDGET-ID 2
     dDtDevol AT ROW 4.88 COL 55 COLON-ALIGNED WIDGET-ID 4
     RECT-1 AT ROW 2.63 COL 1
     RECT-2 AT ROW 3.79 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.54
         FONT 1.

DEFINE FRAME fPage1
     brSon2 AT ROW 1.75 COL 49.43
     brSon1 AT ROW 1.83 COL 3.86
     btAddAllTarget AT ROW 3.71 COL 39.29
     btAddTarget AT ROW 4.88 COL 39.29
     btDelTarget AT ROW 6 COL 39.29
     btDelAllTarget AT ROW 7.13 COL 39.29
     btcarac AT ROW 10.33 COL 49.29
     "Ordens sem container" VIEW-AS TEXT
          SIZE 16.72 BY .54 AT ROW 1.13 COL 4.57
     "Ordens do Container" VIEW-AS TEXT
          SIZE 15.72 BY .54 AT ROW 1.13 COL 49.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.86 ROW 6.08
         SIZE 85.72 BY 10.42
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque2 T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.67
         WIDTH              = 90.57
         MAX-HEIGHT         = 17.46
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 17.46
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN cCodEstabel IN FRAME fpage0
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN cembarque IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon2 TEXT-2 fPage1 */
/* BROWSE-TAB brSon1 brSon2 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-ordens-embarque2"
     _FldNameList[1]   = Temp-Tables.tt-ordens-embarque2.numero-ordem
     _FldNameList[2]   = Temp-Tables.tt-ordens-embarque2.parcela
     _FldNameList[3]   = Temp-Tables.tt-ordens-embarque2.quantidade
     _FldNameList[4]   > "_<CALC>"
"fnUn(fnItem(tt-ordens-embarque2.numero-ordem)) @ c-un" "Un" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-ordens-embarque2.qt-do-forn
"tt-ordens-embarque2.qt-do-forn" "Qtde Fornec" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnUnFornec(tt-ordens-embarque2.numero-ordem) @ c-un-fornec" "Un Fornec" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-ordens-embarque"
     _FldNameList[1]   = Temp-Tables.tt-ordens-embarque.numero-ordem
     _FldNameList[2]   = Temp-Tables.tt-ordens-embarque.parcela
     _FldNameList[3]   = Temp-Tables.tt-ordens-embarque.quantidade
     _FldNameList[4]   > "_<CALC>"
"fnUn(fnItem(tt-ordens-embarque.numero-ordem)) @ c-un2" "Un" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-ordens-embarque.qt-do-forn
"tt-ordens-embarque.qt-do-forn" "Qtde Fornec" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec" "Un Fornec" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    
    run Eliminatemptable in h-bocx225-2 (input-output table tt-delordem).
    
    for each tt-ordens-embarque:
       delete tt-ordens-embarque.
    end.
    
    {&OPEN-QUERY-brSon2}
    
    /*--- Habilita campos contidos no {&page0Fields} ---*/
    &IF "{&page0Fields}":U <> "":U &THEN
        DO WITH FRAME fPage0:
            ENABLE {&page0Fields} btCancel.
        END.
    &ENDIF
    
    apply "entry" to cIdentificContainer in frame fPage0.        
    
    &IF "{&page0Fields}":U <> "":U &THEN
        DO WITH FRAME fPage0:
            disable btAdd btFirst btNext btPrev btLast btsave btupdate.
        END.
    &ENDIF
    
    assign cAntIdentificCont                                = cIdentificContainer:screen-value in frame fPage0
           cAntTipoCont                                     = cTipoContainer:screen-value in frame fPage0  
           dAntDataPrevDev                                  = date(dDtPrevDev:screen-value in frame fPage0)
           dAntDataDevol                                    = date(dDtDevol:screen-value in frame fPage0)
           cIdentificContainer:screen-value in frame fPage0 = ""
           cTipoContainer:screen-value in frame fPage0      = ""
   	       dDtPrevDev:screen-value in frame fPage0          = ?
    	   dDtDevol:screen-value in frame fPage0            = ? 
           lnovomod                                         = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wMaintenance
ON CHOOSE OF btAddAllTarget IN FRAME fPage1
DO:
   
   assign lSituacao = yes.
   if avail tt-ordens-embarque2 then do:
        run AddAllOrdemEmbarque in h-bocx225-2 ( input cIdentificContainer:screen-value in frame fPage0,
                                                 input cTipoContainer:screen-value in frame fPage0,
                                                 INPUT dDtPrevDev:screen-value in frame fPage0,
                                                 INPUT dDtDevol:screen-value in frame fPage0,
                                                 input-output table tt-delordem,
                                                 input table tt-ordens-embarque2).   
     
        assign cIdentificContainer = cIdentificContainer:screen-value in frame fPage0
               cTipoContainer      = cTipoContainer:screen-value in frame fPage0
               dDtPrevDev          = date(dDtPrevDev:screen-value in frame fPage0)
               dDtDevol            = date(dDtDevol:screen-value in frame fPage0).
              
        run openqueriesSon2 in this-procedure.
         
        run openqueriesSon in this-procedure.
        
        if lnovomod = yes then do:
            enable btsave with frame fPage0.
        end.   
        
        enable btdeltarget btdelalltarget with frame fPage1.
        
        disable btaddalltarget with frame fPage1.
   end.
   
   RUN piAbilitaDesabilitaBotoes in this-procedure.   
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wMaintenance
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
  
  assign lSituacao = yes.  
  if avail tt-ordens-embarque2 then do:  
        run AddOrdemEmbarque in h-bocx225-2 (input cIdentificContainer:screen-value in frame fPage0,
                                             input cTipoContainer:screen-value in frame fPage0,
                                             INPUT dDtPrevDev:screen-value in frame fPage0,
                                             INPUT dDtDevol:screen-value in frame fPage0,
                                             input-output table tt-delordem,     
                                             input tt-ordens-embarque2.r-rowid).
        
        assign cIdentificContainer = cIdentificContainer:screen-value in frame fPage0
               cTipoContainer      = cTipoContainer:screen-value in frame fPage0
               dDtPrevDev          = date(dDtPrevDev:screen-value in frame fPage0)
               dDtDevol            = date(dDtDevol:screen-value in frame fPage0).
          
        run openqueriesSon2 in this-procedure.
          
        run openqueriesSon in this-procedure.
        
        if lnovomod = yes then do:
            if avail tt-ordens-embarque then
                enable btsave with frame fPage0.
        end.  
        enable btdeltarget btdelalltarget with frame fPage1.
  end.
  else do:
      disable btaddtarget btaddalltarget with frame fPage1. 
  end.
  
  RUN piAbilitaDesabilitaBotoes in this-procedure.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    
    
    
    ENABLE btFirst btNext btupdate btPrev btLast 
    with frame fPage0.
     
    disable cIdentificContainer cTipoContainer dDtPrevDev dDtDevol btcancel btsave with frame fPage0.
    
    run piCancelaAlteracao in h-bocx225-2 (input lSituacao,
                                           input cAntIdentificCont,
                                           input cAntTipoCont,
					                       input dAntDataPrevDev,
                                           INPUT dAntDataDevol,
                                           input-output table tt-delordem, 
                                           input table tt-ordens-embarque,
                                           input table tt-ordens-embarque2).

    assign cIdentificContainer:screen-value in frame fPage0 = cAntIdentificCont
           cTipoContainer:screen-value in frame fPage0      = cAntTipoCont
	       dDtPrevDev:screen-value in frame fPage0          = string(dAntDataPrevDev)
	       dDtDevol:screen-value in frame fPage0            = string(dAntDataDevol)
           cIdentificContainer = cAntIdentificCont
           cTipoContainer      = cAntTipoCont
	       dDtPrevDev          = dAntDataPrevDev
           dDtDevol            = dAntDataDevol
           lnovomod            = no.
    
    run openqueriesSon2 in this-procedure.
    
    run openqueriesSon in this-procedure.

     run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                        input tt-ordens.cod-estabel,
                                        output lreturn).
                                        
     if lreturn = no then do:
         disable btadd 
                 with frame fPage0.        
     end.                                     
     else do:
         enable btadd 
                with frame fPage0.        
     end.  
    
    RUN piAbilitaDesabilitaBotoes in this-procedure.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btcarac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btcarac wMaintenance
ON CHOOSE OF btcarac IN FRAME fPage1 /* Caracter°sticas */
DO:
  if avail tt-ordens-embarque then do:
     run imp/im0045ca.w (input tt-ordens-embarque.r-rowid).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wMaintenance
ON CHOOSE OF btDelAllTarget IN FRAME fPage1
DO:
  assign lSituacao = no.  
  
  if lnovomod = yes then do:

        if avail tt-ordens-embarque then do:
            run DelAllOrdemEmbarque in h-bocx225-2 (input table tt-ordens-embarque,
                                                    input-output table tt-delordem).   
            
            run openqueriesSon in this-procedure.
            
            run openqueriesSon2 in this-procedure.
            
            enable btaddtarget btaddalltarget with frame fPage1.
        end.
        else do:
           disable btsave with frame fPage0.  
           disable btdeltarget btdelalltarget with frame fPage1.
        end.

        run pi-roda-bos in this-procedure.         

        if not avail tt-ordens-embarque then do:
            RUN findPk_codigo IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                               INPUT cEmbarque:screen-value in frame fPage0,
                                               output cReturn).
        end.
        else do:
            RUN findPk_codigo_container IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                                         INPUT cEmbarque:screen-value in frame fPage0,
                                                         input cIdentificContainer:screen-value in frame fPage0,
                                                         output cReturn).
        end.      
        
  end.
  else do:
        if avail tt-ordens-embarque then do:

            run DelAllOrdemEmbarque in h-bocx225-2 (input table tt-ordens-embarque,
                                                    input-output table tt-delordem).   
            
            run openqueriesSon in this-procedure.
            
            run openqueriesSon2 in this-procedure.
            
            enable btaddtarget btaddalltarget with frame fPage1.
        end.
        else do:
           disable btsave with frame fPage0.     
           disable btdeltarget btdelalltarget with frame fPage1.
        end.

        run pi-roda-bos in this-procedure.         
        if not avail tt-ordens-embarque then do:
            RUN findPk_codigo IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                               INPUT cEmbarque:screen-value in frame fPage0,
                                               output cReturn).
        end.
        else do:
            RUN findPk_codigo_container IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                                         INPUT cEmbarque:screen-value in frame fPage0,
                                                         input cIdentificContainer:screen-value in frame fPage0,
                                                         output cReturn).
        end.      
      
        run piReorganizaRegistros     in this-procedure.
  end.

  RUN piAbilitaDesabilitaBotoes in this-procedure.
  
  FOR EACH tt-delordem:
     delete tt-delordem.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wMaintenance
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:

  assign lSituacao = no.  
  
  if lnovomod = yes then do:

        if avail tt-ordens-embarque then do:
              run DelOrdemEmbarque in h-bocx225-2 (input tt-ordens-embarque.r-rowid,
                                                   input-output table tt-delordem).
              
              run openqueriesSon in this-procedure.
            
              run openqueriesSon2 in this-procedure.
                      
              enable btaddalltarget btaddtarget with frame fPage1.  
        end.
        else do:
           disable btsave with frame fPage0.     
           disable btdeltarget btdelalltarget with frame fPage1.
        end.

        run pi-roda-bos in this-procedure.         
        if not avail tt-ordens-embarque then do:
            RUN findPk_codigo IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                               INPUT cEmbarque:screen-value in frame fPage0,
                                               output cReturn).
        end.
        else do:
            RUN findPk_codigo_container IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                                         INPUT cEmbarque:screen-value in frame fPage0,
                                                         input cIdentificContainer:screen-value in frame fPage0,
                                                         output cReturn).
        end.      
        
  end.
  else do:
        if avail tt-ordens-embarque then do:

              run DelOrdemEmbarque in h-bocx225-2 (input tt-ordens-embarque.r-rowid,
                                                   input-output table tt-delordem).
              
              run openqueriesSon in this-procedure.
            
              run openqueriesSon2 in this-procedure.
                      
              enable btaddalltarget btaddtarget with frame fPage1.  
        end.
        else do:
           disable btsave with frame fPage0.     
           disable btdeltarget btdelalltarget with frame fPage1.
        end.

        run pi-roda-bos in this-procedure.         
        if not avail tt-ordens-embarque then do:
            RUN findPk_codigo IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                               INPUT cEmbarque:screen-value in frame fPage0,
                                               output cReturn).
        end.
        else do:
            RUN findPk_codigo_container IN {&hDBOTable} (INPUT cCodEstabel:screen-value in frame fPage0,
                                                         INPUT cEmbarque:screen-value in frame fPage0,
                                                         input cIdentificContainer:screen-value in frame fPage0,
                                                         output cReturn).
        end.      
      
        run piReorganizaRegistros     in this-procedure.

  end.

  RUN piAbilitaDesabilitaBotoes in this-procedure.
  
  FOR EACH tt-delordem:
     delete tt-delordem.
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
 
     RUN getFirst IN THIS-PROCEDURE.

     run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                        input tt-ordens.cod-estabel,
                                        output lreturn).
                                        
     if lreturn = no then do:
         disable btadd 
                 with frame fPage0.        
     end.                                     
     else do:
         enable btadd 
                with frame fPage0.        
     end.  
 
     RUN piAbilitaDesabilitaBotoes in this-procedure.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
  
     RUN getLast IN THIS-PROCEDURE.
     
     run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                        input tt-ordens.cod-estabel,
                                        output lreturn).
                                        
     if lreturn = no then do:
         disable btadd 
                 with frame fPage0.        
     end.                                     
     else do:
         enable btadd 
                with frame fPage0.        
     end.  
 
     RUN piAbilitaDesabilitaBotoes in this-procedure.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:

     run getNext IN THIS-PROCEDURE.

     run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                        input tt-ordens.cod-estabel,
                                        output lreturn).
                                        
     if lreturn = no then do:
         disable btadd 
                 with frame fPage0.        
     end.                                     
     else do:
         enable btadd 
                with frame fPage0.        
     end.  
     
     RUN piAbilitaDesabilitaBotoes in this-procedure.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:

     RUN getPrev IN THIS-PROCEDURE.
     run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                        input tt-ordens.cod-estabel,
                                        output lreturn).
                                        
     if lreturn = no then do:
         disable btadd 
                 with frame fPage0.        
     end.                                     
     else do:
         enable btadd 
                with frame fPage0.        
     end.  
 
     RUN piAbilitaDesabilitaBotoes in this-procedure.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
/*    RUN showQueryJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
  /*  RUN showReportsJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    ASSIGN INPUT FRAME fPage0 dDtPrevDev NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {utp/ut-liter.i "Previs∆o_Devoluá∆o" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15370, 
                           INPUT RETURN-VALUE).        
        apply "entry" to dDtPrevDev in frame fPage0.
        RETURN NO-APPLY.
    END.

    ASSIGN INPUT FRAME fPage0 dDtDevol NO-ERROR.
    IF  ERROR-STATUS:ERROR THEN DO:
        {utp/ut-liter.i "Devoluá∆o" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15370, 
                           INPUT RETURN-VALUE).        
        apply "entry" to dDtDevol in frame fPage0.
        RETURN NO-APPLY.
    END.

    &IF "{&page0Fields}":U <> "":U &THEN
        DO WITH FRAME fPage0:
            ENABLE {&page0Fields} btFirst btNext btPrev btLast.
        END.
    &ENDIF

    &IF "{&page0Fields}":U <> "":U &THEN
        DO WITH FRAME fPage0:
            disable {&page0Fields} btcancel btsave.
        END.
    &ENDIF

    IF  INPUT FRAME fPage0 dDtDevol > TODAY THEN DO:
        {utp/ut-liter.i "Data_Devoluá∆o" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 55691, 
                           INPUT RETURN-VALUE).
    END.

    run piCriaOrdensEmbarque in h-bocx225-2 (input cIdentificContainer:screen-value in frame fPage0,
                                             input cTipoContainer:screen-value in frame fPage0,
                                             INPUT dDtPrevDev:screen-value in frame fPage0,
                                             INPUT dDtDevol:screen-value in frame fPage0,
                                             input table tt-ordens-embarque).
    
    for each tt-ordens-embarque2:
        delete tt-ordens-embarque2.
    end.
    
    for each tt-ordens-embarque:
        delete tt-ordens-embarque.
    end.
    
    assign cIdentificContainer = cIdentificContainer:screen-value in frame fPage0
           cTipoContainer      = cTipoContainer:screen-value in frame fPage0
	       dDtPrevDev          = date(dDtPrevDev:screen-value in frame fPage0)
	       dDtDevol            = date(dDtDevol:screen-value in frame fPage0)	
           lnovomod            = no.

    run pi-roda-bos in this-procedure.         
    
    
    RUN findPk_codigo_container IN {&hDBOTable} (INPUT  cCodEstabel:screen-value in frame fPage0,
                                                 INPUT  cEmbarque:screen-value in frame fPage0,
                                                 input  cIdentificContainer:screen-value in frame fPage0,
                                                 output cReturn).

    run piReorganizaRegistros in this-procedure. 

    run FindOrdensAdd in {&HDBOTABLE} (input tt-ordens.embarque,
                                       input tt-ordens.cod-estabel,
                                       output lreturn).

    if lreturn = no then do:
        disable btadd 
                with frame fPage0.        
    end.                                     
    else do:
        enable btadd 
               with frame fPage0.        
    end.  

    RUN piAbilitaDesabilitaBotoes in this-procedure.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    run Eliminatemptable in h-bocx225-2 (input-output table tt-delordem).
      
    ENABLE cIdentificContainer cTipoContainer dDtPrevDev dDtDevol btCancel btSave with frame fPage0.
    
    disable cembarque ccodestabel with frame fPage0.
    
    apply "entry" to cIdentificContainer in frame fPage0.
    
    disable btAdd btFirst btNext btPrev btLast btupdate with frame fPage0.

    assign cAntIdentificCont = cIdentificContainer:screen-value in frame fPage0
           cAntTipoCont      = cTipoContainer:screen-value in frame fPage0
           dAntDataPrevDev   = date(dDtPrevDev:screen-value in frame fPage0)
           dAntDataDevol     = date(dDtDevol:screen-value in frame fPage0)
           lnovomod          = yes.

    if avail tt-ordens-embarque then
       enable btsave with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME dDtPrevDev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dDtPrevDev wMaintenance
ON LEAVE OF dDtPrevDev IN FRAME fpage0 /* Data Prev. Devoluá∆o */
DO:
    ASSIGN INPUT FRAME fPage0 dDtPrevDev NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {utp/ut-liter.i "Previs∆o_Devoluá∆o" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15370, 
                           INPUT RETURN-VALUE).        
        apply "entry" to dDtPrevDev in frame fPage0.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME dDtPrevDev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dDtDevol wMaintenance
ON LEAVE OF dDtDevol IN FRAME fpage0 /* Data Devoluá∆o */
DO:
    ASSIGN INPUT FRAME fPage0 dDtDevol NO-ERROR.
    IF  ERROR-STATUS:ERROR THEN DO:
        {utp/ut-liter.i "Devoluá∆o" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15370, 
                           INPUT RETURN-VALUE).        
        apply "entry" to dDtDevol in frame fPage0.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- L¢gica para inicializaá∆o do programam ---*/

   
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    IF VALID-HANDLE(h-boin082) THEN DO:
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.

    IF VALID-HANDLE(h-boin274) THEN DO:
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    IF VALID-HANDLE(h-bocx225) THEN DO:
        DELETE PROCEDURE h-bocx225.
        ASSIGN h-bocx225 = ?.
    END.

    IF VALID-HANDLE(h-bocx225-2) THEN DO:
        DELETE PROCEDURE h-bocx225-2.
        ASSIGN h-bocx225-2 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdisplayfields wMaintenance 
PROCEDURE afterdisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>             
  Notes:       
------------------------------------------------------------------------------*/
    if avail tt-ordens then do:
        assign cEmbarque:screen-value in frame fPage0           = tt-ordens.embarque
               cCodEstabel:screen-value in frame fPage0         = tt-ordens.cod-estabel
               cIdentificContainer:screen-value in frame fPage0 = tt-ordens.identific-container
               ctipocontainer:screen-value in frame fPage0      = tt-ordens.tipo-container
               dDtPrevDev:screen-value in frame fPage0          = string(tt-ordens.dDtPrevDev)
               dDtDevol:screen-value in frame fPage0            = string(tt-ordens.dDtDevol)
               cEmbarque           = tt-ordens.embarque
               cCodEstabel         = tt-ordens.cod-estabel
               cIdentificContainer = tt-ordens.identific-container
               cTipoContainer      = tt-ordens.tipo-container
               dDtPrevDev          = tt-ordens.dDtPrevDev
               dDtDevol            = tt-ordens.dDtDevol.
        
        run openqueriesSon  in this-procedure.
         
        run openqueriesSon2 in this-procedure.       
                
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN piAbilitaDesabilitaBotoes in this-procedure.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
    
    DEFINE VARIABLE c-embarque LIKE embarque-imp.embarque NO-UNDO.
    DEFINE VARIABLE c-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE VARIABLE cStatus as char no-undo.         
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED 
        c-embarque        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Embarque Imp" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-embarque.
        
        RUN findPk_codigo IN {&hDBOTable} (INPUT c-cod-estabel, INPUT c-embarque, output cStatus).
        
        IF cStatus <> "":U THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Embarque_Importaá∆o" *}
           RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                              INPUT 2, 
                              INPUT RETURN-VALUE).
           
           RETURN NO-APPLY.
        END.

        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
         
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
&IF "{&mguni_version}" >= "2.071" &THEN
    assign c-cod-estabel:width = 7.
&ELSE
    assign c-cod-estabel:width = 4.
&ENDIF
        
    ENABLE c-cod-estabel c-embarque btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN pi-roda-bos.
    
    RUN findPk_codigo IN {&hDBOTable} (INPUT pcod-estabel, INPUT pembarque, output cReturn).
    
    IF cReturn <> "":U THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Embarque_Importaá∆o" *}
       RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                          INPUT 2, 
                          INPUT RETURN-VALUE).
       
       RETURN NO-APPLY.
    END.
      
    /* Retorna rowid do registro corrente do DBO */
    RUN getrowid IN {&hDBOTable} (OUTPUT r-rowid).
     
    /* Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    enable btcarac brSon1 brSon2 btAddAllTarget btAddTarget btDelAllTarget btDelTarget
            with frame fPage1.

    run FindOrdensAdd in {&HDBOTABLE} (input  pembarque,
                                       input  pcod-estabel,
                                       output lreturn).
     
    if lreturn = no then do:
         disable btadd
                 with frame fPage0.        
    end.                                     
    else do:
         enable btadd
                with frame fPage0.        
    end.   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueriesSon wMaintenance 
PROCEDURE openqueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   

   run setConstraint5 in h-bocx225-2 (input cembarque,
                                      input ccodestabel,
                                      input cIdentificContainer).   
   
   run openquery in h-bocx225-2 (input 5). 

   run findFirst in h-bocx225-2.
    
   run serverSendRows in h-bocx225-2 (input ?,
                                      input "",
                                      input no,
                                      input 40,
                                      output rowsreturn,
                                      output table tt-ordens-embarque2).

   {&OPEN-QUERY-brSon1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueriesSon2 wMaintenance 
PROCEDURE openqueriesSon2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  
  run setConstraint5 in h-bocx225-2 (input cembarque,
                                     input ccodestabel,
                                     input cIdentificContainer).


  run openquery in h-bocx225-2 (input 6). 

  run findFirst in h-bocx225-2.
   
  run serverSendRows in h-bocx225-2 (input ?,
                                     input "",
                                     input no,
                                     input 40,
                                     output rowsreturn,
                                     output table tt-ordens-embarque).

  {&OPEN-QUERY-brSon2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-roda-bos wMaintenance 
PROCEDURE pi-roda-bos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 cxbo/bocx220d.p }
        {btb/btb008za.i2 cxbo/bocx220d.p '' {&hDBOTable}}
    END.

    run setconstraint1 in {&hDBOTable} (input pcod-estabel, input pembarque).     
    
    run openquery in {&hDBOTable} (input 1).
    
    IF NOT VALID-HANDLE(h-bocx225-2) THEN DO:
        {btb/btb008za.i1 cxbo/bocx225.p }
        {btb/btb008za.i2 cxbo/bocx225.p '' h-bocx225-2}
    END.

    IF NOT VALID-HANDLE(h-boin172) THEN DO:
        RUN inbo/boin172.p persistent set h-boin172.
    end.
    RUN openQueryStatic IN h-boin172(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin082) THEN DO:
        RUN inbo/boin082.p persistent set h-boin082.
    end.
    RUN openQueryStatic IN h-boin082(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin274) THEN DO:
        RUN inbo/boin274.p persistent set h-boin274.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAbilitaDesabilitaBotoes wMaintenance 
PROCEDURE piAbilitaDesabilitaBotoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     if not avail tt-ordens-embarque then do:
         disable btdeltarget btdelalltarget with frame fPage1. 
     end.
     else do:
         enable btdeltarget btdelalltarget with frame fPage1.
     end.

     if not avail tt-ordens-embarque2 then do:
         disable btaddtarget btaddalltarget with frame fPage1.      
     end.
     else do:
         enable btaddtarget btaddalltarget with frame fPage1.      
     end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReorganizaRegistros wMaintenance 
PROCEDURE piReorganizaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
  IF cReturn <> "":U THEN DO:
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Embarque_Importaá∆o" *}
     RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                        INPUT 2, 
                        INPUT RETURN-VALUE).
     
     RETURN NO-APPLY.
  END.
   /* Retorna rowid do registro corrente do DBO */
  RUN getrowid IN {&hDBOTable} (OUTPUT r-rowid).
   
  /* Reposiciona registro com base em um rowid */
  RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

  run openqueriesson in this-procedure.
  
  run openqueriesson2 in this-procedure.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMaintenance 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cStatus as char no-undo.

  RUN findOrdem in h-boin274 (input pnum-ordem, output cStatus).  
  RUN getCharField in h-boin274 (input "it-codigo", output c-descricao).
  
  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMaintenance 
FUNCTION fnUn RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un LIKE ITEM.un INIT "" NO-UNDO.

    RUN gotokey IN h-boin172(INPUT c-it-codigo).         
    RUN getCharField IN h-boin172(INPUT "un", OUTPUT c-codigo-un). 
    
    RETURN c-codigo-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMaintenance 
FUNCTION fnUnFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un-fornec LIKE cotacao-item.un INIT "" NO-UNDO.

    RUN goToCotacaoAprovada IN h-boin082(INPUT i-numero-ordem).         
    RUN getCharField IN h-boin082(INPUT "un", OUTPUT c-codigo-un-fornec). 
    
    RETURN c-codigo-un-fornec.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

