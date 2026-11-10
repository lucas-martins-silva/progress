&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
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
{include/i-prgvrs.i IM0045C 2.00.00.031 } /*** "010031" 10/11/2025 16:51:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0045c MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{inbo/boin295.i tt-pedido-compr} /* definido em include para nao referenciar banco */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0045C
&GLOBAL-DEFINE Version        2.00.00.031
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Pedidos

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-pedido-compr
&GLOBAL-DEFINE hDBOSon1         h-bocx225b
&GLOBAL-DEFINE DBOSon1Table     pedido-compr

&GLOBAL-DEFINE ttSon2           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon2         h-bocx225
&GLOBAL-DEFINE DBOSon2Table     ordens-embarque

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */
def input param pcod-estabel as char no-undo.
def input param pembarque    LIKE embarque-imp.embarque no-undo.

/* Local Variable Definitions ---                                       */
def var cItem          as char                no-undo.
def var c-idiom-usuar  as char format "x(12)" no-undo.
def var c-return       as char                no-undo.
def var r-chave        as rowid               no-undo.
def var c-nr-proc-imp  like processo-imp.nr-proc-imp no-undo.
def var cf-nr-proc-imp like processo-imp.nr-proc-imp no-undo.
def var p-mensagem     as char format "x(60)" NO-UNDO.
def var i-seq-erro     as int                 no-undo.
def var c-un           like ITEM.un           no-undo.
def var c-un-fornec    like cotacao-item.un   no-undo.

DEF VAR l-via-transp       AS LOGICAL         NO-UNDO.
DEF VAR l-primer-ped       AS LOGICAL         NO-UNDO.
DEF VAR l-valida-viatransp AS LOGICAL         NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx140     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin082     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00451   AS HANDLE NO-UNDO.

DEFINE VARIABLE v-cod-proces-imp-f      AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-proces-imp-i      AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-item-f            AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-item-i            AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-fornec-f          AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-cod-fornec-i          AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ped-compra-f      AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ped-compra-i      AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ordem-compra-f    AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ordem-compra-i    AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE i-num-ordens-embarque   AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE i-num-ordens-inicial    AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE i-num-ordens-vinculadas AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-dat-pedido-f          AS      DATE         format "99/99/9999" NO-UNDO.
DEFINE VARIABLE v-dat-pedido-i          AS      DATE         format "99/99/9999" NO-UNDO.
DEFINE VARIABLE v-passou                AS      LOGICAL      initial no          NO-UNDO.
DEFINE VARIABLE l-sel                   AS      LOGICAL INITIAL NO               NO-UNDO.
DEFINE VARIABLE l-cria                  AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-possui-antecip        AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-IFRIC22               AS      LOGICAL                          NO-UNDO.

ASSIGN l-IFRIC22 = CAN-FIND(FIRST funcao
                            WHERE funcao.cd-funcao = "SPP-IFRIC22":U
                              AND funcao.ativo).

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017 as handle no-undo.
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    def var h-boun178 as handle no-undo.
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF

{cxbo/bocx225.i tt-ordens-embarque-comp}

/* Global Variable Definitions                                          */
def new global shared var i-num-pedido-imp as integer no-undo.

{cdp/cdcfgmat.i} /* Include uso de pre-processadores para modulo BN*/
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/

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
&Scoped-define INTERNAL-TABLES tt-pedido-compr tt-ordens-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-pedido-compr.num-pedido tt-pedido-compr.data-pedido fnProcesso(input tt-pedido-compr.num-pedido) @ c-nr-proc-imp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-pedido-compr NO-LOCK     BY tt-pedido-compr.num-pedido
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido-compr NO-LOCK     BY tt-pedido-compr.num-pedido.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-pedido-compr
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-pedido-compr


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-embarque.numero-ordem ~
tt-ordens-embarque.parcela ~
fnItem(input tt-ordens-embarque.numero-ordem) @ cItem ~
tt-ordens-embarque.quantidade ~
fnUn(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un ~
tt-ordens-embarque.qt-do-forn ~
fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec ~
tt-ordens-embarque.nr-proc-imp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-embarque NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-ordens-embarque NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProcesso wMasterDetail 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT)  FORWARD.

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
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-ordens 
     LABEL "Ordens" 
     SIZE 10 BY 1.

DEFINE BUTTON btFirst-2 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLast-2 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext-2 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev-2 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btselecao 
     LABEL "Sele‡Æo" 
     SIZE 15 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-pedido-compr SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-ordens-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-pedido-compr.num-pedido
      tt-pedido-compr.data-pedido COLUMN-LABEL "Data Pedido"
      fnProcesso(input tt-pedido-compr.num-pedido) @ c-nr-proc-imp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 34.72 BY 5.96
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-ordens-embarque.numero-ordem FORMAT ">>>>>9,99":U
      tt-ordens-embarque.parcela FORMAT ">>>>9":U
      fnItem(input tt-ordens-embarque.numero-ordem) @ cItem COLUMN-LABEL "Item" FORMAT "x(16)":U
      tt-ordens-embarque.quantidade FORMAT ">>>>>,>>9.9999":U
      fnUn(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un COLUMN-LABEL "Un" FORMAT "xx":U
      tt-ordens-embarque.qt-do-forn COLUMN-LABEL "Qtde Forn" FORMAT ">>>>>,>>9.9999":U
      fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx":U
            WIDTH 9.14
      tt-ordens-embarque.nr-proc-imp FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 43.72 BY 5.96
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
     tt-embarque-imp.cod-estabel AT ROW 2.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 3.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btNext-2 AT ROW 1.17 COL 37.86 HELP
          "Pr¢xima ocorrˆncia"
     brSon2 AT ROW 1.17 COL 43
     btLast-2 AT ROW 2.71 COL 37.86 HELP
          "éltima ocorrˆncia"
     btPrev-2 AT ROW 4.29 COL 37.86 HELP
          "Ocorrˆncia anterior"
     btFirst-2 AT ROW 5.83 COL 37.86 HELP
          "Primeira ocorrˆncia"
     bt-ordens AT ROW 7.13 COL 2
     btselecao AT ROW 7.13 COL 21.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.38
         SIZE 87.14 BY 7.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
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
         HEIGHT             = 14.17
         WIDTH              = 90.43
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
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
/* BROWSE-TAB brSon2 btNext-2 fPage1 */
ASSIGN 
       btselecao:HIDDEN IN FRAME fPage1           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido-compr NO-LOCK
    BY tt-pedido-compr.num-pedido.
     _END_FREEFORM
     _OrdList          = "Temp-Tables.tt-pedido-compr.num-pedido|yes"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-ordens-embarque"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-ordens-embarque.numero-ordem
"tt-ordens-embarque.numero-ordem" ? ">>>>>9,99" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-ordens-embarque.parcela
     _FldNameList[3]   > "_<CALC>"
"fnItem(input tt-ordens-embarque.numero-ordem) @ cItem" "Item" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-ordens-embarque.quantidade
     _FldNameList[5]   > "_<CALC>"
"fnUn(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un" "Un" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-ordens-embarque.qt-do-forn
"tt-ordens-embarque.qt-do-forn" "Qtde Forn" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnUnFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec" "Un Fornec" "xx" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.tt-ordens-embarque.nr-proc-imp
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF l-IFRIC22 THEN DO:
      RUN piVerificaDespachanteInformado.
  END.
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
  IF l-IFRIC22 THEN DO:
      RUN piVerificaDespachanteInformado.
  END.
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ordens wMasterDetail
ON CHOOSE OF bt-ordens IN FRAME fPage1 /* Ordens */
DO:
    
    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN DO:
        assign i-num-pedido-imp = {&FIRST-TABLE-IN-QUERY-brSon1}.num-pedido.
        run imp/im0045a.w (input tt-embarque-imp.cod-estabel:screen-value in frame fPage0,
                           input tt-embarque-imp.embarque:screen-value    in frame fPage0).
    
        RUN openQueriesSon in THIS-PROCEDURE.                       
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    IF l-IFRIC22 THEN DO:
        RUN piVerificaDespachanteInformado.
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFirst-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst-2 wMasterDetail
ON CHOOSE OF btFirst-2 IN FRAME fPage1 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:

    DEF VAR l-mensagem AS LOGICAL NO-UNDO.

    /* Chamada UPC - consist-contab */ 
    &IF DEFINED(bf_dis_versao_ems) &THEN
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else    
    &endif
    
    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.
   
    IF l-IFRIC22 THEN DO:
        RUN piEmbarqPossuiAntecip IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                  INPUT tt-embarque-imp.embarque,
                                                  OUTPUT l-possui-antecip).
        IF l-possui-antecip THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 55715, INPUT "").
            IF RETURN-VALUE = "YES":U THEN
                RUN piEliminaAntecipEmbarque IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                             INPUT tt-embarque-imp.embarque).
            ELSE DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
    END.

    RUN validateEliminacaoOrdem IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                              INPUT tt-embarque-imp.embarque,
                                              OUTPUT p-mensagem).
    
    IF p-mensagem <> "" THEN DO:
        
        run utp/ut-msgs.p (input "show":U,
                           input 28547,
                           input string(tt-embarque-imp.embarque) + "~~" + p-mensagem).
    
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.



    ASSIGN l-mensagem = NO.
    for each tt-ordens-embarque:
        &if '{&bf_mat_versao_ems}' = '2.062' &then
                RUN BuscaEqEmbarqPrazCompra IN h-bocx225 (INPUT tt-ordens-embarque.numero-ordem,
                                                          INPUT tt-ordens-embarque.parcela).
                IF RETURN-VALUE = "OK":U THEN DO:
                    IF NOT l-mensagem THEN DO:
                        ASSIGN l-mensagem = YES.
                        run utp/ut-msgs.p (input "show":U,
                                           input 30879,
                                           input "").
                        if return-value = "NO":U then do:
                             SESSION:SET-WAIT-STATE("":U). 
                             LEAVE.
                        end.
                    END.
                END.
            &endif
         RUN validateDelete in h-bocx225 (input-output tt-ordens-embarque.r-rowid,
                                          output table RowErrors).
    
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            run openQueriesSon in this-procedure.            
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.        
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).        
            RUN openQueriesSon in this-procedure.                
            LEAVE.
        END.
        ELSE DO:
            if avail tt-ordens-embarque then 
                delete tt-ordens-embarque.
        END.
    end.    
    run openQueriesSon in this-procedure.

    /* Licenciamento Importacao */
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    
    run  piNecessitaLiEmbarque in h-bocx225 (input tt-embarque-imp.cod-estabel, 
                                             input tt-embarque-imp.embarque,    
                                             output table rowErrors).
    if  can-find (first rowErrors) then do:

        if  not valid-handle(hShowMsg) then
            run utp/ut-show-msgs.w persistent set hShowMsg.

        run showMessages in hShowMsg (input table RowErrors).
    end.
    
    &endif

    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLast-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast-2 wMasterDetail
ON CHOOSE OF btLast-2 IN FRAME fPage1 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:

    &IF DEFINED(bf_dis_versao_ems) &THEN
        /* Chamada UPC - consist-contab */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else    
    &endif
    run setCreatehist in h-bocx225.

    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.

    for each tt-pedido-compr TRANSACTION ON ERROR UNDO, LEAVE:   
        run pi-recebe-idioma in h-bocx225 (input c-idiom-usuar).
        

        /* Via de Transporte */
        RUN piValidaViaTransp (INPUT tt-pedido-compr.num-pedido,
                               OUTPUT l-via-transp,
                               OUTPUT l-primer-ped).
        IF  l-valida-viatransp THEN DO: /* Fun‡ao spp-via-transp-dif */ 
            IF  l-via-transp THEN
                RUN utp/ut-msgs.p (input "show":U,
                                   input 54556, /* alerta */
                                   input STRING(tt-pedido-compr.num-pedido)).
        END.
        ELSE DO:
            IF  l-via-transp THEN DO: /* Via de transporte da ordem ‚ diferente da via de transporte do embarque */
                IF  l-primer-ped THEN DO: /* primeira ordem vinculada */
                    run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-pedido-compr.num-pedido)). /* confirma e atualiza */
                    if  return-value <> "yes" then do: 
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.
                    end.
                    ELSE DO:
                        RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                              INPUT tt-embarque-imp.cod-estabel).
                        RUN openQueriesSon IN THIS-PROCEDURE.
                    END.
                END.
                ELSE DO:
                    run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-pedido-compr.num-pedido)). /* erro */  
                    SESSION:SET-WAIT-STATE("":U).
                    LEAVE.
                END.
            END.
        END.
        
        RUN createPedidosEmbarque in h-bocx225 (input tt-embarque-imp.r-rowid,
                                                input tt-pedido-compr.num-pedido,
                                                output table RowErrors).
                                                
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            RUN openQueriesSon IN THIS-PROCEDURE.
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
            UNDO, RETURN NO-APPLY.
        END.
        ELSE
            delete tt-pedido-compr.
            
    end.
    
    RUN openQueriesSon in THIS-PROCEDURE.
    
    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext-2 wMasterDetail
ON CHOOSE OF btNext-2 IN FRAME fPage1 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:

    def var qtde   as decimal no-undo.
    def var i-cont as integer no-undo.
    &IF DEFINED(bf_dis_versao_ems) &THEN
        /* Chamada UPC - consist-contab */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else    
    &endif
    run setCreatehist in h-bocx225.
    
    if brson1:num-selected-rows = 0 then leave.
    
    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.

    do i-cont = 1 to brson1:num-selected-rows:
    
        brson1:fetch-selected-row(i-cont).

        /* Via de Transporte */
        RUN piValidaViaTransp (INPUT  tt-pedido-compr.num-pedido,
                               OUTPUT l-via-transp,
                               OUTPUT l-primer-ped).
        IF  l-valida-viatransp THEN DO: /* Fun‡ao spp-via-transp-dif */ 
            IF  l-via-transp THEN
                RUN utp/ut-msgs.p (input "show":U,
                                   input 54556, /* alerta */
                                   input STRING(tt-pedido-compr.num-pedido)).
        END.
        ELSE DO:
            IF  l-via-transp THEN DO: /* Via de transporte da ordem ‚ diferente da via de transporte do embarque */
                IF  l-primer-ped THEN DO: /* primeira ordem vinculada */
                    run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-pedido-compr.num-pedido)). /* confirma e atualiza */
                    if  return-value <> "yes" then do: 
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.
                    end.
                    ELSE DO:
                        RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                              INPUT tt-embarque-imp.cod-estabel).
                        RUN openQueriesSon IN THIS-PROCEDURE.
                    END.
                END.
                ELSE DO:
                    run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-pedido-compr.num-pedido)). /* erro */  
                    SESSION:SET-WAIT-STATE("":U).
                    return no-apply.
                END.
            END.
        END.
        
        RUN createPedidosEmbarque in h-bocx225 (input tt-embarque-imp.r-rowid,
                                                input tt-pedido-compr.num-pedido,
                                                output table RowErrors).
        if can-find(first RowErrors) then
            assign i-cont = brson1:num-selected-rows + 1.

    end.
    
    RUN openQueriesSon in THIS-PROCEDURE.
                                            
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.            
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        undo, return no-apply.
    END.

    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev-2 wMasterDetail
ON CHOOSE OF btPrev-2 IN FRAME fPage1 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:

    DEF var l-mensagem AS LOGICAL NO-UNDO.

    def var i-cont as integer no-undo.
    &IF DEFINED(bf_dis_versao_ems) &THEN
        /* Chamada UPC - consist-contab */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else    
    &endif
    if brson2:num-selected-rows = 0 then leave.

    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.
    
    IF l-IFRIC22 THEN DO:
        /* Verifica quantas ordens-embarque tem, se for a ultima que esta desvinculando avisar sobre antecipacoes */
        RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                                INPUT tt-embarque-imp.embarque,
                                                OUTPUT i-num-ordens-embarque).

        RUN piEmbarqPossuiAntecip IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                  INPUT tt-embarque-imp.embarque,
                                                  OUTPUT l-possui-antecip).

        IF l-possui-antecip AND i-num-ordens-embarque = brson2:num-selected-rows THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 55715, INPUT "").
            IF RETURN-VALUE = "YES":U THEN
                RUN piEliminaAntecipEmbarque IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                             INPUT tt-embarque-imp.embarque).
            ELSE DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
    END.

    RUN validateEliminacaoOrdem IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                              INPUT tt-embarque-imp.embarque,
                                              OUTPUT p-mensagem).
    
    IF p-mensagem <> "" THEN DO:
        
        run utp/ut-msgs.p (input "show":U,
                           input 28547,
                           input string(tt-embarque-imp.embarque) + "~~" + p-mensagem).
    
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.

    ASSIGN l-mensagem = NO.
    do i-cont = 1 to brson2:num-selected-rows:
        brson2:fetch-selected-row(i-cont).
    
        &if '{&bf_mat_versao_ems}' = '2.062' &then
            RUN BuscaEqEmbarqPrazCompra IN h-bocx225 (INPUT tt-ordens-embarque.numero-ordem,
                                                      INPUT tt-ordens-embarque.parcela).
            IF RETURN-VALUE = "OK":U THEN DO:
                IF NOT l-mensagem THEN DO:
                    ASSIGN l-mensagem = YES.
                    run utp/ut-msgs.p (input "show":U,
                                       input 30879,
                                       input "").
                    if return-value = "NO":U then do:
                         SESSION:SET-WAIT-STATE("":U). 
                         LEAVE.
                    end.
                END.
            END.
        &endif
        RUN validateDelete in h-bocx225 (input-output tt-ordens-embarque.r-rowid,
                                         output table RowErrors).
                                         
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            assign i-cont = brson2:num-selected-rows + 1.        
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
            undo, return no-apply.
        END.
        ELSE DO:
            if avail tt-ordens-embarque then
                delete tt-ordens-embarque.
        END.
    end.
    
    run openQueriesSon in this-procedure.

    /* Licenciamento Importacao */
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    
    run  piNecessitaLiEmbarque in h-bocx225 (input tt-embarque-imp.cod-estabel, 
                                             input tt-embarque-imp.embarque,    
                                             output table rowErrors).
    if  can-find (first rowErrors) then do:

        if  not valid-handle(hShowMsg) then
            run utp/ut-show-msgs.w persistent set hShowMsg.

        run showMessages in hShowMsg (input table RowErrors).
    end.
    
    &endif

    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btselecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btselecao wMasterDetail
ON CHOOSE OF btselecao IN FRAME fPage1 /* Sele‡Æo */
DO:
    SESSION:SET-WAIT-STATE("general":U).
    run pi-bt-sel in this-procedure.         
    SESSION:SET-WAIT-STATE("":U).    
    assign l-sel = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMasterDetail 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    delete procedure h-boin172.  
    delete procedure h-boin082.  
    if valid-handle(h-bocx00451) then
       run Destroy in h-bocx00451.

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

    assign btselecao:HIDDEN IN FRAME fPage1 = NO.
    apply "choose":U to btselecao in frame fpage1.  /*executa o programa de parametros.*/

    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
       ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
       ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.

    RUN retorna-spp-via-transp-dif (OUTPUT l-valida-viatransp). 

    IF l-IFRIC22 THEN DO:
       RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                               INPUT tt-embarque-imp.embarque,
                                               OUTPUT i-num-ordens-inicial).
       
        IF CAN-FIND(FIRST {&ttSon2}) THEN
            EMPTY TEMP-TABLE tt-ordens-embarque-comp.

        FOR EACH {&ttSon2}:
            CREATE tt-ordens-embarque-comp.
            BUFFER-COPY {&ttSon2} TO tt-ordens-embarque-comp.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 2).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-estabel":U).
    &ENDIF
        
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx225b.p persistent set h-bocx225b.
    END.    
    
    &if defined (bf_dis_versao_ems) &then
     &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
         ENABLE btselecao with frame fPage1.
     &ENDIF 
    &endif
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) THEN DO:
       RUN cxbo/bocx225.p persistent set h-bocx225.    
    END.
    
    enable bt-ordens 
           btNext-2 
           btLast-2 
           btPrev-2 
           btFirst-2 
           brSon2 
           with frame fPage1.    
           
    /* busca idioma do usu rio */
    &IF '{&mgdis_version}' >= '2.06f' &THEN
        run fnbo/bofn017.p persistent set h-bofn017.
        run goTokey in h-bofn017 (input v_cod_usuar_corren).
        IF RETURN-VALUE = "OK" THEN DO:
            run getCurrent in h-bofn017 (output table tt_usuar_mestre).
            find first tt_usuar_mestre no-error.
            if   avail tt_usuar_mestre then
                assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
        end.
        delete procedure h-bofn017.
    &ELSE
        run unbo/boun178.p persistent set h-boun178.
        run findSrmstr_id in h-boun178 (input v_cod_usuar_corren, output c-return).
        if  c-return = "" then do:
            run getCurrent in h-boun178 (output table tt_usuar_mestre).
            find first tt_usuar_mestre no-error.
            if   avail tt_usuar_mestre then
                 assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
        end.
        delete procedure h-boun178.
    &ENDIF

    run pi-recebe-idioma in h-bocx225 (input c-idiom-usuar).

    IF NOT VALID-HANDLE(h-boin172) THEN DO:
        RUN inbo/boin172.p persistent set h-boin172.
    end.
    RUN openQueryStatic IN h-boin172(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin082) THEN DO:
        RUN inbo/boin082.p persistent set h-boin082.
    end.
    RUN openQueryStatic IN h-boin082(INPUT "Main":U).
    
    IF NOT VALID-HANDLE(h-bocx00451) AND l-IFRIC22 THEN
        RUN cxbo/bocx00451.p PERSISTENT SET h-bocx00451.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
def var rowsreturn2 as integer no-undo.   
    DEFINE VARIABLE r-embarque-imp as rowid NO-UNDO.
        
    for each tt-pedido-compr:
        delete tt-pedido-compr.
    end.
   
    IF AVAILABLE tt-embarque-imp THEN
        ASSIGN r-embarque-imp = tt-embarque-imp.r-rowid.
    ELSE
        ASSIGN r-embarque-imp = ?.
    /**
    {masterdetail/OpenQueriesSon.i
            &Parent="tt-embarque-imp"
            &Query="CodEstabel"
            &PageNumber="1"
            &QueryConstraint="2"
            &ConstraintParameters="r-embarque-imp"}    
    *****/
    &IF DEFINED(DBOVersion) <> 0 &THEN
         
         RUN setConstraint2 IN {&hDBOSon1} (INPUT r-embarque-imp
                                            &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        INPUT v-cod-proces-imp-f,  
                                                        INPUT v-cod-proces-imp-i,  
                                                        INPUT v-num-ped-compra-f,  
                                                        INPUT v-num-ped-compra-i,  
                                                        INPUT v-num-ordem-compra-f,
                                                        INPUT v-num-ordem-compra-i,
                                                        INPUT v-cod-item-f,        
                                                        INPUT v-cod-item-i,        
                                                        INPUT v-dat-pedido-f,      
                                                        INPUT v-dat-pedido-i
                                            &endif ).
         
         RUN openQuery IN {&hDBOSon1} (INPUT 2).                
         
         IF iRepositionPageNumber = 0 THEN
            RUN findFirst IN {&hDBOSon1}.
         
         run retornaTTpedidocompr IN {&hDBOSon1} (OUTPUT TABLE tt-pedido-compr).
         
    &ELSE
         RUN openQueryStatic IN {&hDBOSon1} (INPUT "CodEstabel":U).
         run retornaTTpedidocompr IN {&hDBOSon1} (OUTPUT TABLE tt-pedido-compr).
    &ENDIF                                             
    
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brson1.
 
    RUN openQuerybrSon2 in THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybrSon2 wMasterDetail 
PROCEDURE openQuerybrSon2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var rowsreturn as integer no-undo.
    
    RUN setConstraint4 in h-bocx225 (input tt-embarque-imp.embarque,
                                     input tt-embarque-imp.cod-estabel).        
    RUN OpenQuery in h-bocx225 (input 2).
    RUN findFirst in h-bocx225.    
    RUN serverSendRows in h-bocx225 (input ?,
                                     input ?,
                                     input no,
                                     input ?,
                                     output rowsreturn,
                                     output table {&ttSon2}).
    {&OPEN-QUERY-brSon2}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-sel wMasterDetail 
PROCEDURE pi-bt-sel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if v-passou = no then 
        assign v-cod-proces-imp-f   = "ZZZZZZZZZZZZ"
               v-cod-proces-imp-i   = ""
               v-num-ped-compra-f   = 99999999
               v-num-ped-compra-i   = 0
               v-num-ordem-compra-f = 99999999
               v-num-ordem-compra-i = 0
               v-cod-item-f         = "ZZZZZZZZZZZZZZZZ"
               v-cod-item-i         = ""
               v-dat-pedido-f       = 12/31/9999
               v-dat-pedido-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               v-passou             = yes.

   assign l-cria = no.

   RUN imp/im0045pr.w(INPUT-OUTPUT v-cod-proces-imp-f,  
                      INPUT-OUTPUT v-cod-proces-imp-i,  
                      INPUT-OUTPUT v-num-ped-compra-f,  
                      INPUT-OUTPUT v-num-ped-compra-i,  
                      INPUT-OUTPUT v-num-ordem-compra-f,
                      INPUT-OUTPUT v-num-ordem-compra-i,
                      INPUT-OUTPUT v-cod-item-f,        
                      INPUT-OUTPUT v-cod-item-i,        
                      INPUT-OUTPUT v-dat-pedido-f,      
                      INPUT-OUTPUT v-dat-pedido-i,
                      OUTPUT       l-cria).
   IF l-cria THEN DO:
       RUN openQueriesSon IN THIS-PROCEDURE.
   END.
   ELSE
       assign v-cod-proces-imp-f   = ""
              v-cod-proces-imp-i   = ""
              v-cod-fornec-f       = 0
              v-cod-fornec-i       = 0
              v-num-ped-compra-f   = 0
              v-num-ped-compra-i   = 0
              v-num-ordem-compra-f = 0
              v-num-ordem-compra-i = 0
              v-cod-item-f         = ""
              v-cod-item-i         = ""
              v-dat-pedido-f       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-dat-pedido-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-passou             = NO.

    IF AVAIL {&FIRST-TABLE-IN-QUERY-brSon1} THEN
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN bt-ordens:SENSITIVE IN FRAME fPage1 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiValidaViaTransp wMasterDetail 
PROCEDURE PiValidaViaTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEF INPUT  PARAM p-pedido      LIKE ordem-compra.numero-ordem NO-UNDO.
        DEF OUTPUT PARAM p-via-transp  AS LOGICAL                     NO-UNDO.
        DEF OUTPUT PARAM p-primer-ped  AS LOGICAL                     NO-UNDO.

        RUN validaViaTranspPedxEmbarq IN h-bocx225  (INPUT  tt-embarque-imp.embarque,      
                                                     INPUT  tt-embarque-imp.cod-estabel, 
                                                     INPUT  2,
                                                     INPUT  p-pedido,  
                                                     OUTPUT p-via-transp,
                                                     OUTPUT p-primer-ped ).
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaDespachanteInformado wMasterDetail 
PROCEDURE piVerificaDespachanteInformado :
/*------------------------------------------------------------------------------
  Purpose:     Valida a informa‡Æo do despachante que ser  utilizado na vincula‡Æo
               das antecipa‡äes via IM0055 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                            INPUT tt-embarque-imp.embarque,
                                            OUTPUT i-num-ordens-vinculadas).

    IF  i-num-ordens-inicial < i-num-ordens-vinculadas THEN DO:
        /*verifica se o registro vinculado ‚ diferente */
        RUN piValidaDespachanteSalvoIFRIC IN h-bocx220(INPUT tt-embarque-imp.cod-estabel,
                                                       INPUT tt-embarque-imp.embarque,
                                                       output table RowErrors).
        
    END.
    ELSE DO: /*desvinculou a mesma quantidade de registros que vinculou*/
        IF i-num-ordens-inicial = i-num-ordens-vinculadas THEN DO:
            FOR EACH tt-ordens-embarque-comp:
                IF NOT CAN-FIND(FIRST {&ttSon2} 
                                WHERE {&ttSon2}.numero-ordem = tt-ordens-embarque-comp.numero-ordem
                                  AND {&ttSon2}.parcela      = tt-ordens-embarque-comp.parcela) THEN DO:
                    RUN piValidaDespachanteSalvoIFRIC IN h-bocx220(INPUT tt-embarque-imp.cod-estabel,
                                                                   INPUT tt-embarque-imp.embarque,
                                                                   output table RowErrors).
                END.
            END.
        END.
    END.
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}
                
    END. 
    {method/showmessage.i1}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-via-transp-dif wMasterDetail 
PROCEDURE retorna-spp-via-transp-dif :
/*------------------------------------------------------------------------------
  Purpose: Quando esta fun‡Æo estiver ativada o programa ir  apresentar um alerta avisando
  que a via de transporte da ordem ‚ diferente da via de transporte do embarque.
  Se a fun‡Æo nÆo estiver ativada, o programa ir  informar que esta diferente, permitindo 
  relacionar e atualizar o embarque. A partir da segunda ordem nÆo ser  permitido vincular
  ordens com via de transporte diferente.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER l-resultado    AS LOG NO-UNDO.
  
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-via-transp-dif'
            AND   ativo     = YES) THEN
    ASSIGN l-resultado =TRUE.
ELSE
    ASSIGN l-resultado =FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cStatus as char no-undo.
  
  RUN inbo/boin274.p persistent set h-boin274.
  RUN findOrdem in h-boin274 (input pnum-ordem, output cStatus).  
  RUN getCharField in h-boin274 (input "it-codigo", output c-descricao).
  delete procedure h-boin274.

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProcesso wMasterDetail 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer ) :
  
  assign cf-nr-proc-imp = "".
  RUN cxbo/bocx140.p persistent set h-bocx140.
  run findPedido in h-bocx140 (input p-num-pedido,output c-return).
  if c-return = "" then
    run getCharfield in h-bocx140 (input "nr-proc-imp":U,output cf-nr-proc-imp).

  IF VALID-HANDLE(h-bocx140) THEN DO:
    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.
  END.

  RETURN cf-nr-proc-imp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMasterDetail 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
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

