&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-doc-est-cex NO-UNDO LIKE item-doc-est-cex
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
{include/i-prgvrs.i IM1001B 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM1001B MIM}
&ENDIF


CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM1001B
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1

&GLOBAL-DEFINE FolderLabels     Despesas

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

&GLOBAL-DEFINE AddSon1          yes
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       yes
&GLOBAL-DEFINE DeleteSon1       yes

&GLOBAL-DEFINE ttParent         tt-item-doc-est
&GLOBAL-DEFINE hDBOParent       h-boin176
&GLOBAL-DEFINE DBOParentTable   item-doc-est
&GLOBAL-DEFINE DBOParentDestroy NO

&GLOBAL-DEFINE ttSon1           tt-item-doc-est-cex
&GLOBAL-DEFINE hDBOSon1         h-bocx100
&GLOBAL-DEFINE DBOSon1Table     item-doc-est-cex

&GLOBAL-DEFINE page0Fields    tt-item-doc-est.sequencia ~
                              tt-item-doc-est.it-codigo ~
                              c-desc-item 
                              
&GLOBAL-DEFINE page1Browse    brSon1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var h-boin090       as handle                      no-undo.
def var i-cod-emitente  like item-doc-est.cod-emitente no-undo.
def var c-serie-docto   like item-doc-est.serie-docto  no-undo.
def var c-nro-docto     like item-doc-est.nro-docto    no-undo.
def var c-nat-operacao  like item-doc-est.nat-operacao no-undo.
def var c-desc-aux      as char                        no-undo.
def var l-erro          as log                         no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
def var h-bocx095 as handle no-undo.
DEFINE VARIABLE h-bocx310 AS HANDLE      NO-UNDO.

def new global shared var grDocumEst as rowid no-undo.
def var c-fornec      like emitente.nome-emit no-undo.
def var c-desp        like desp-imp.descricao no-undo.
def var rItemDocEst   as rowid                no-undo.

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
&Scoped-define INTERNAL-TABLES tt-item-doc-est-cex

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-item-doc-est-cex.cod-emitente-desp ~
fnFornec(tt-item-doc-est-cex.cod-emitente-desp) @ c-fornec ~
tt-item-doc-est-cex.cod-desp ~
fnDespesa(tt-item-doc-est-cex.cod-estabel, tt-item-doc-est-cex.embarque, tt-item-doc-est-cex.cod-desp) @ c-desp ~
tt-item-doc-est-cex.val-desp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-item-doc-est-cex NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-item-doc-est-cex NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-item-doc-est-cex
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-item-doc-est-cex


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item-doc-est.sequencia ~
tt-item-doc-est.it-codigo 
&Scoped-define ENABLED-TABLES tt-item-doc-est
&Scoped-define FIRST-ENABLED-TABLE tt-item-doc-est
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-desc-item 
&Scoped-Define DISPLAYED-FIELDS tt-item-doc-est.sequencia ~
tt-item-doc-est.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-item-doc-est
&Scoped-define FIRST-DISPLAYED-TABLE tt-item-doc-est
&Scoped-Define DISPLAYED-OBJECTS c-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ( input c-it-codigo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fndespesa wMasterDetail 
FUNCTION fndespesa RETURNS CHARACTER
  (input pc-cod-estabel as char,
   input pc-embarque as char,
   input i-cd-despesa as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnfornec wMasterDetail 
FUNCTION fnfornec RETURNS CHARACTER
  ( input i-cd-fornec as int )  FORWARD.

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

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.14 BY 2.54.

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

DEFINE BUTTON btUpdateSon1 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-item-doc-est-cex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-item-doc-est-cex.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnFornec(tt-item-doc-est-cex.cod-emitente-desp) @ c-fornec
      tt-item-doc-est-cex.cod-desp FORMAT ">>,>>9":U
      fnDespesa(tt-item-doc-est-cex.cod-estabel, tt-item-doc-est-cex.embarque, tt-item-doc-est-cex.cod-desp) @ c-desp
      tt-item-doc-est-cex.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 7.63
         FONT 1.


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
     tt-item-doc-est.sequencia AT ROW 3.04 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     tt-item-doc-est.it-codigo AT ROW 4.04 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-item AT ROW 4.04 COL 25.57 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.71 COL 1.43
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 15.29
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2.72
     btAddSon1 AT ROW 8.88 COL 2.86
     btUpdateSon1 AT ROW 8.88 COL 12.86
     btDeleteSon1 AT ROW 8.88 COL 23
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.67
         SIZE 84.43 BY 9.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-item-doc-est T "?" NO-UNDO movind item-doc-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-doc-est-cex T "?" NO-UNDO mgcex item-doc-est-cex
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
         HEIGHT             = 15.46
         WIDTH              = 90.57
         MAX-HEIGHT         = 20.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.21
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
     _TblList          = "Temp-Tables.tt-item-doc-est-cex"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-item-doc-est-cex.cod-emitente-desp
     _FldNameList[2]   > "_<CALC>"
"fnFornec(tt-item-doc-est-cex.cod-emitente-desp) @ c-fornec" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-item-doc-est-cex.cod-desp
     _FldNameList[4]   > "_<CALC>"
"fnDespesa(tt-item-doc-est-cex.cod-estabel, tt-item-doc-est-cex.embarque, tt-item-doc-est-cex.cod-desp) @ c-desp" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-item-doc-est-cex.val-desp
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
    {masterdetail/addson.i &ProgramSon="imp/im1001b1.w"
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

      run getrowid in h-boin090 (output grDocumEst).
    
        /*--- Executa programa de pesquisa ---*/
      RUN inzoom/z07in176.w PERSISTENT SET hProgramZoom.
      
      IF VALID-HANDLE(hProgramZoom) THEN DO:
          /*--- Seta, no programa de pesquisa, os campos que devem ser retornados
                Neste caso serÿ retornado o ROWID do registro selecionado ---*/
          RUN setFieldNamesHandles IN hProgramZoom (INPUT "ROWID":U, INPUT STRING(THIS-PROCEDURE)).
      
          Run setParameters in hProgramZoom (input tt-item-doc-est.cod-emitente,
                                             input tt-item-doc-est.nat-operacao,
                                             input tt-item-doc-est.serie-docto,
                                             input tt-item-doc-est.nro-docto).    
      
          /*--- Inicializa programa de pesquisa ---*/
          RUN initializeInterface IN hProgramZoom.         
    
      END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="imp/im1001b1.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


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
    IF VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.
        
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

    if avail tt-item-doc-est then do:
        /* Acessa Item */
        assign c-desc-item:screen-value in frame fPage0 = fnDescItem(input frame fPage0 tt-item-doc-est.it-codigo).
        
    end.
    else do:
    
        /*--- Limpa os valores de todos os campos em todas as viewer's ---*/
        assign tt-item-doc-est.sequencia:screen-value      in frame fPage0 = ""
               tt-item-doc-est.it-codigo:screen-value      in frame fPage0 = ""
               c-desc-item:screen-value                    in frame fPage0 = "".
    
    end.  
    
    run changeStateButtons in this-procedure.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeStateButtons wMasterDetail 
PROCEDURE changeStateButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-enable-bt as int.
        
    run enableButtons in h-boin090 ( input  "btImportacao":U,
                                     output i-enable-bt ).
    if  i-enable-bt = 0 then
        assign btAddSon1:sensitive in frame fPage1    = no
               btUpdateSon1:sensitive in frame fPage1 = no
               btDeleteSon1:sensitive in frame fPage1 = no.
    else do:
        assign btAddSon1:sensitive in frame fPage1    = yes
               btUpdateSon1:sensitive in frame fPage1 = yes
               btDeleteSon1:sensitive in frame fPage1 = yes.

        if not can-find(first tt-item-doc-est-cex) then 
            assign btUpdateSon1:sensitive in frame fPage1 = no
                   btDeleteSon1:sensitive in frame fPage1 = no.
             
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayerrors wMasterDetail 
PROCEDURE displayerrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("general":U).

    /*--- inicializa a tela de erros ---*/
    
    {method/showmessage.i1}
    
    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
    {method/showmessage.i2}

    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKeyParent wMasterDetail 
PROCEDURE getKeyParent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param i-codigo-em  as int  no-undo.
    def output param c-ser-docto  as char no-undo.
    def output param c-nr-docto   as char no-undo.
    def output param c-natur-oper as char no-undo.   
  
    run getKey in h-boin090 ( output i-cod-emitente,
                              output c-serie-docto,
                              output c-nro-docto,
                              output c-nat-operacao ). 
    
    assign c-ser-docto  = c-serie-docto
           c-nr-docto   = c-nro-docto
           i-codigo-em  = i-cod-emitente
           c-natur-oper = c-nat-operacao.

   return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Vÿ Para
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
         SIZE 75 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-sequencia    LIKE tt-item-doc-est.sequencia    VIEW-AS FILL-IN SIZE  4 BY .88 NO-UNDO.
    DEFINE VARIABLE c-it-codigo    LIKE tt-item-doc-est.it-codigo    VIEW-AS FILL-IN SIZE 17 BY .88 NO-UNDO.           
    DEFINE VARIABLE c-desc-item    AS CHAR FORMAT "X(60)":U            VIEW-AS FILL-IN SIZE 45 BY .88 NO-UNDO.       
    DEFINE VARIABLE i-cod-emitente LIKE tt-item-doc-est.cod-emitente NO-UNDO.
    DEFINE VARIABLE c-serie-docto  LIKE tt-item-doc-est.serie-docto  NO-UNDO.        
    DEFINE VARIABLE c-nro-docto    LIKE tt-item-doc-est.nro-docto    NO-UNDO.
    DEFINE VARIABLE c-nat-operacao LIKE tt-item-doc-est.nat-operacao NO-UNDO.    
    
    DEFINE FRAME fGoToRecord
        i-sequencia    AT ROW 1.21 COL 10.72 COLON-ALIGNED
        c-it-codigo    AT ROW 2.21 COL 10.72 COLON-ALIGNED
        c-desc-item    AT ROW 2.21 COL 30.00 no-label 
        btGoToOK       AT ROW 3.63 COL 2.14
        btGoToCancel   AT ROW 3.63 COL 13
        rtGoToButton   AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item do Documento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
                 
    ON "LEAVE":U OF i-sequencia IN FRAME fGoToRecord DO:
       assign input i-sequencia. 
       run returnItemDocEst in h-boin176 (input  i-sequencia,
                                          output c-it-codigo,
                                          output i-cod-emitente,
                                          output c-serie-docto,
                                          output c-nro-docto,
                                          output c-nat-operacao).
       if return-value = "OK":U then do: 
          run findItem in h-boin176 (input c-it-codigo). 
          run getDescriptionFields in h-boin176 (input  "desc-item":U, 
                                                 output c-desc-item).  
       end.                              
       else do:       
           assign i-sequencia    = 0
                  c-it-codigo    = "":U
                  i-cod-emitente = 0 
                  c-serie-docto  = "":U
                  c-nro-docto    = "":U
                  c-nat-operacao = "":U.                            
       end.    
       disp c-it-codigo 
            c-desc-item
            with frame fGoToRecord.                                
    END.             
         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        
        apply "LEAVE":U TO i-sequencia IN FRAME fGoToRecord.
       
        ASSIGN i-sequencia c-it-codigo c-desc-item.
        
        /* Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN h-boin176 (INPUT c-serie-docto,
                                  INPUT c-nro-docto,
                                  INPUT i-cod-emitente,
                                  INPUT c-nat-operacao,
                                  INPUT i-sequencia).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "ITEM" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN h-boin176 (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        /* Altera o estado dos bot„es conforme o tipo da nota */
                         
        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ON "CHOOSE":U OF btGoToCancel IN FRAME fGoToRecord DO:

        APPLY "GO":U TO FRAME fGoToRecord.

    END.
    
    ENABLE i-sequencia btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

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
    
    /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:       
        {btb/btb008za.i1 inbo/boin176.p}
        {btb/btb008za.i2 inbo/boin176.p '' {&hDBOParent}}     
    END.
  
   /* RUN openQueryStatic IN {&hDBOParent} (INPUT "OfDocumEst":U).*/
    
    /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:    
        {btb/btb008za.i1 cxbo/bocx100.p}
        {btb/btb008za.i2 cxbo/bocx100.p '' {&hDBOSon1}}    
    END.

    IF NOT VALID-HANDLE(h-bocx095) THEN
        run cxbo/bocx095.p persistent set h-bocx095.

    IF NOT VALID-HANDLE(h-bocx310) THEN
        run cxbo/bocx310.p persistent set h-bocx310.
    
    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    
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

    {masterdetail/openqueriesson.i &Parent="ItemDocEst"
                                   &Query="itemDocEst"
                                   &PageNumber="1"}                                  
 
    
    RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionItemDocEst wMasterDetail 
PROCEDURE repositionItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  run repositionRecord in h-boin176 (input tt-item-doc-est.r-rowid).
    
  return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters wMasterDetail 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param hboin090   as handle no-undo.
    def input param hboin176   as handle no-undo.
   
    if hboin090 <> ? then 
      assign h-boin090 = hboin090.
    
    if  hboin176 <> ? then
        assign h-boin176 = hboin176.
    else do:
        run inbo/boin176.p persistent set h-boin176.
        run openQueryStatic in h-boin176 ( input "Main":U ).
        run linkToDocumEst in h-boin176 ( input h-boin090 ).
    end.
    
    
    run getKeyParent ( output i-cod-emitente,
                       output c-serie-docto,
                       output c-nro-docto,
                       output c-nat-operacao ).
                       

    run setHandleDocumEst in h-boin176 ( input h-boin090 ).
    run setDocumEst in h-boin176.
        
    /*run getRowid in h-boin176(output rItemDocEst ).  */

    if  not valid-handle(h-boin176) then
        return "NOK":U. 

    return "OK":U.   
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ( input c-it-codigo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-desc-aux as char no-undo.

  run findItem in h-boin176 ( c-it-codigo ).

  IF  RETURN-VALUE = "OK":U then
      run getDescriptionFields in h-boin176 ( "desc-item":U, output c-desc-aux ).


  RETURN c-desc-aux.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fndespesa wMasterDetail 
FUNCTION fndespesa RETURNS CHARACTER
  (input pc-cod-estabel as char,
   input pc-embarque as char,
   input i-cd-despesa as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def var c-return  as char   no-undo. 
    def var c-descricao like desp-imp.descricao no-undo.

    RUN findDespesa IN h-bocx310 (INPUT pc-cod-estabel,
                                  INPUT pc-embarque,
                                  INPUT i-cd-despesa,
                                  OUTPUT c-return).
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx310(INPUT "descricao":U,
                                      OUTPUT c-descricao).
    END.
    
    IF TRIM(c-descricao) = "":U THEN DO:
        run findCodigo in h-bocx095(input i-cd-despesa, output c-return).
        
        if c-return = "" then
            run getCharfield in h-bocx095(input "descricao",output c-descricao).
    END.
    
    RETURN c-descricao.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnfornec wMasterDetail 
FUNCTION fnfornec RETURNS CHARACTER
  ( input i-cd-fornec as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    def var c-return                as char   no-undo.
    def var h-boad098               as handle no-undo.
    def var c-desc-aux              as char   no-undo.
    
    run adbo/boad098.p persistent set h-boad098.
    
    run findCodigo in h-boad098(input i-cd-fornec,output c-return).
    
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-desc-aux).  
        
    delete procedure h-boad098.
    
   return c-desc-aux. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

