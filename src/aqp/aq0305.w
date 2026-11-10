&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID
       .
DEFINE TEMP-TABLE tt-carg-rural-aux NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-liber-carg NO-UNDO LIKE liber-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-liber-carg-aux NO-UNDO LIKE liber-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-liber-carg-brw NO-UNDO LIKE liber-carg
       field r-rowid as rowid
       field checkSum as int initial 0.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0305 2.00.00.019 } /*** 010019 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0305 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0305
&GLOBAL-DEFINE Version        2.00.00.018

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     

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

&GLOBAL-DEFINE ttParent         tt-carg-rural
&GLOBAL-DEFINE hDBOParent       h-boin00961
&GLOBAL-DEFINE DBOParentTable   carg-rural
&GLOBAL-DEFINE DBOParentDestroy YES


&GLOBAL-DEFINE ttSon1           tt-liber-carg
&GLOBAL-DEFINE hDBOSon1         h-boin00982
&GLOBAL-DEFINE DBOSon1Table     liber-carg
&GLOBAL-DEFINE DBOSon1Destroy   YES


&GLOBAL-DEFINE page0Fields  tt-carg-rural.cod-estabel tt-carg-rural.num-carg tt-carg-rural.cod-placa tt-carg-rural.qti-comptmento tt-carg-rural.val-densidade ~
                            fi-tot-peso fi-tot-qtd fi-qtd-total tt-carg-rural.dat-trans tt-carg-rural.cod-rota tt-carg-rural.cod-usuario

&GLOBAL-DEFINE page1Browse  brLiberCarg   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                        */
DEFINE VARIABLE iLinha             AS INTEGER           NO-UNDO.
DEFINE VARIABLE d-val-densidade    AS DECIMAL           NO-UNDO.
DEFINE VARIABLE i-idi-desc-sem-rot AS INTEGER           NO-UNDO.
DEFINE VARIABLE c-descarregar      AS CHARACTER         NO-UNDO.
DEFINE VARIABLE c-situacao         AS CHARACTER         NO-UNDO.
DEFINE VARIABLE d-tot-val-quant    AS DECIMAL           NO-UNDO.
DEFINE VARIABLE d-val-peso-liq     AS DECIMAL           NO-UNDO.
DEFINE VARIABLE i-idi-tip-aferic   AS INTEGER           NO-UNDO.
DEFINE VARIABLE l-contr-qualid     AS LOGICAL           NO-UNDO.
DEFINE VARIABLE l-balanca          AS LOGICAL           NO-UNDO.
DEFINE VARIABLE l-fraciona         AS LOGICAL           NO-UNDO.
DEFINE VARIABLE l-aprov-auto       AS LOGICAL           NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin684     AS HANDLE NO-UNDO. /* item-uni-estab   */
DEFINE VARIABLE h-boin00983   AS HANDLE NO-UNDO. /* item-estab-rural */
DEFINE VARIABLE h-boin00981   AS HANDLE NO-UNDO. /* pesagem          */


DEFINE VARIABLE h-boin417     AS HANDLE NO-UNDO. /* tab-unidade */
DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO. /* item */
DEFINE VARIABLE h-boad107na   AS HANDLE NO-UNDO. /* estabelec */
DEFINE VARIABLE h-boin00975   AS HANDLE NO-UNDO. /* rota-coleta */
DEFINE VARIABLE h-boin124a    AS HANDLE NO-UNDO. /* ficha-cq    */
DEFINE VARIABLE h-boin282     AS HANDLE NO-UNDO.  /* param-cq    */

DEFINE BUFFER bf-tt-liber-carg-brw FOR tt-liber-carg-brw.

DEFINE TEMP-TABLE tt-selecionado NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-sit   AS INT.

DEFINE NEW GLOBAL SHARED VARIABLE v_num-carg-aq0305  AS INTEGER NO-UNDO.

DEFINE VARIABLE c-observacao  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE l-inicializou AS LOGICAL INITIAL NO NO-UNDO.

/* Roteiro inspe‡Æo */
{cdp/cd0666.i}
{cqp/cqapi001a.i}

{cdp/cd0031.i} /* seguranca por estabelecimento */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brLiberCarg

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-liber-carg-brw

/* Definitions for BROWSE brLiberCarg                                   */
&Scoped-define FIELDS-IN-QUERY-brLiberCarg fn_descarregar(tt-liber-carg-brw.checkSum, tt-liber-carg-brw.idi-autoriz-descarga) @ c-descarregar fnSituacao(tt-liber-carg-brw.idi-aprova) @ c-situacao tt-liber-carg-brw.cdn-compart tt-liber-carg-brw.lote tt-liber-carg-brw.dt-vali-lote tt-liber-carg-brw.cod-depos &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ tt-liber-carg-brw.nr-ficha &ELSE tt-liber-carg-brw.num-livre-1 &ENDIF tt-liber-carg-brw.val-quant tt-liber-carg-brw.val-peso-liq tt-liber-carg-brw.codigo-rejei &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ tt-liber-carg-brw.cod-obs &ELSE SUBSTR(tt-liber-carg-brw.cod-livre-1, 1, 100) @ c-observacao &ENDIF   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLiberCarg   
&Scoped-define SELF-NAME brLiberCarg
&Scoped-define QUERY-STRING-brLiberCarg FOR EACH tt-liber-carg-brw NO-LOCK
&Scoped-define OPEN-QUERY-brLiberCarg OPEN QUERY {&SELF-NAME} FOR EACH tt-liber-carg-brw NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brLiberCarg tt-liber-carg-brw
&Scoped-define FIRST-TABLE-IN-QUERY-brLiberCarg tt-liber-carg-brw


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brLiberCarg}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-carg-rural.cod-usuario ~
tt-carg-rural.cod-estabel tt-carg-rural.dat-trans tt-carg-rural.num-carg ~
tt-carg-rural.cod-placa tt-carg-rural.qti-comptmento tt-carg-rural.cod-rota ~
tt-carg-rural.val-densidade 
&Scoped-define ENABLED-TABLES tt-carg-rural
&Scoped-define FIRST-ENABLED-TABLE tt-carg-rural
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btQueryJoins ~
btReportsJoins btExit btHelp btFirst btPrev btNext btLast btGoTo btSearch ~
btRefresh btAnalise fi-desc-estab c-des-rota bt-sav fi-qtd-total btAprovar ~
btReprovar btUpdateSon1 bt-dividir bt-unificar bt-liberar fi-tot-peso ~
fi-tot-qtd 
&Scoped-Define DISPLAYED-FIELDS tt-carg-rural.cod-usuario ~
tt-carg-rural.cod-estabel tt-carg-rural.dat-trans tt-carg-rural.num-carg ~
tt-carg-rural.cod-placa tt-carg-rural.qti-comptmento tt-carg-rural.cod-rota ~
tt-carg-rural.val-densidade 
&Scoped-define DISPLAYED-TABLES tt-carg-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-carg-rural
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estab c-des-rota fi-qtd-total ~
fi-tot-peso fi-tot-qtd 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacao wMasterDetail 
FUNCTION fnSituacao RETURNS CHARACTER
  ( iCdn-sit AS INTEGER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_descarregar wMasterDetail 
FUNCTION fn_descarregar RETURNS CHARACTER
  ( i-check AS INT , p-idi-autoriz-descarga AS INT)  FORWARD.

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
DEFINE BUTTON bt-dividir 
     LABEL "Dividir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-liberar 
     LABEL "Libera‡Æo" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 3.86 BY 1 TOOLTIP "Salvar".

DEFINE BUTTON bt-unificar 
     LABEL "Unificar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAnalise 
     LABEL "An lises" 
     SIZE 7.14 BY 1.25.

DEFINE BUTTON btAprovar 
     LABEL "Aprovar" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image/toolbar/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReprovar 
     LABEL "Reprovar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdateSon1 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-des-rota AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-total AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-peso AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-qtd AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Peso Liq" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 117 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 116 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLiberCarg FOR 
      tt-liber-carg-brw SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLiberCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLiberCarg wMasterDetail _FREEFORM
  QUERY brLiberCarg NO-LOCK DISPLAY
      fn_descarregar(tt-liber-carg-brw.checkSum, tt-liber-carg-brw.idi-autoriz-descarga)  @ c-descarregar COLUMN-LABEL 'Libera‡Æo' FORMAT "x(16)" WIDTH 16
      fnSituacao(tt-liber-carg-brw.idi-aprova)  @  c-situacao COLUMN-LABEL 'An lise' FORMAT "x(12)" 
      tt-liber-carg-brw.cdn-compart FORMAT ">>9":U COLUMN-LABEL 'Compart'
      tt-liber-carg-brw.lote FORMAT "x(40)":U WIDTH 15
      tt-liber-carg-brw.dt-vali-lote FORMAT "99/99/9999":U
      tt-liber-carg-brw.cod-depos FORMAT "x(3)":U      
      &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
      tt-liber-carg-brw.nr-ficha COLUMN-LABEL 'Roteiro'
      &ELSE
      tt-liber-carg-brw.num-livre-1 COLUMN-LABEL 'Roteiro'
      &ENDIF
      tt-liber-carg-brw.val-quant WIDTH 15
      tt-liber-carg-brw.val-peso-liq  WIDTH 15
      tt-liber-carg-brw.codigo-rejei
      &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
      tt-liber-carg-brw.cod-obs  COLUMN-LABEL 'Observa‡Æo' FORMAT "x(100)" WIDTH 25
      &ELSE
      SUBSTR(tt-liber-carg-brw.cod-livre-1, 1, 100) @ c-observacao COLUMN-LABEL 'Observa‡Æo' FORMAT "x(100)" WIDTH 2
      &ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 111 BY 10.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.08 COL 101.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.08 COL 105.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.08 COL 109.72 HELP
          "Sair"
     btHelp AT ROW 1.08 COL 113.72 HELP
          "Ajuda"
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
     btRefresh AT ROW 1.13 COL 25.72 WIDGET-ID 12
     btAnalise AT ROW 1.13 COL 31.86
     tt-carg-rural.cod-usuario AT ROW 3 COL 102.14 COLON-ALIGNED WIDGET-ID 36
          LABEL "Usu rio"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .88
     tt-carg-rural.cod-estabel AT ROW 3.04 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-desc-estab AT ROW 3.04 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-carg-rural.dat-trans AT ROW 3.04 COL 71 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-carg-rural.num-carg AT ROW 4.04 COL 11.86 COLON-ALIGNED
          LABEL "Carga"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-carg-rural.cod-placa AT ROW 4.04 COL 27.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-carg-rural.qti-comptmento AT ROW 4.04 COL 51.86 COLON-ALIGNED
          LABEL "Compartimentos"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     tt-carg-rural.cod-rota AT ROW 4.04 COL 71 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     c-des-rota AT ROW 4.04 COL 79.86 COLON-ALIGNED HELP
          "Descri‡Æo do Trajeto" NO-LABEL
     bt-sav AT ROW 5.46 COL 22.86
     fi-qtd-total AT ROW 5.5 COL 11.86 COLON-ALIGNED
     tt-carg-rural.val-densidade AT ROW 5.5 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     btAprovar AT ROW 17.46 COL 4.43 WIDGET-ID 16
     btReprovar AT ROW 17.46 COL 14.57 WIDGET-ID 18
     btUpdateSon1 AT ROW 17.46 COL 24.72 WIDGET-ID 20
     bt-dividir AT ROW 17.46 COL 34.86
     bt-unificar AT ROW 17.46 COL 45 WIDGET-ID 28
     bt-liberar AT ROW 17.46 COL 106.14 WIDGET-ID 26
     fi-tot-peso AT ROW 17.5 COL 81.29 RIGHT-ALIGNED WIDGET-ID 22
     fi-tot-qtd AT ROW 17.5 COL 104.57 RIGHT-ALIGNED WIDGET-ID 24
     rtToolBar AT ROW 1 COL 2
     rtParent AT ROW 2.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.14 BY 17.58
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brLiberCarg AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.29 ROW 6.67
         SIZE 111.72 BY 10.58
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
          
      END-FIELDS.
      TABLE: tt-carg-rural-aux T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-liber-carg T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-liber-carg-aux T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-liber-carg-brw T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field checkSum as int initial 0
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
         HEIGHT             = 17.58
         WIDTH              = 117.14
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


DEFINE TEMP-TABLE RowErrorsAux NO-UNDO 
    LIKE RowErrors.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-usuario IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-tot-peso IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-tot-qtd IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN tt-carg-rural.num-carg IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.qti-comptmento IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brLiberCarg 1 fPage1 */
ASSIGN 
       brLiberCarg:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLiberCarg
/* Query rebuild information for BROWSE brLiberCarg
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-liber-carg-brw NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brLiberCarg */
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


&Scoped-define BROWSE-NAME brLiberCarg
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brLiberCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLiberCarg wMasterDetail
ON ROW-DISPLAY OF brLiberCarg IN FRAME fPage1
DO:

    IF tt-liber-carg-brw.idi-autoriz-descarga = 1 THEN
       ASSIGN c-descarregar                  :BGCOLOR IN BROWSE brLiberCarg = 10 
              c-situacao                     :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.cdn-compart  :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.lote         :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.dt-vali-lote :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.cod-depos    :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.val-quant    :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.val-peso-liq :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.codigo-rejei :BGCOLOR IN BROWSE brLiberCarg = 10
              &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
              tt-liber-carg-brw.nr-ficha     :BGCOLOR IN BROWSE brLiberCarg = 10
              tt-liber-carg-brw.cod-obs      :BGCOLOR IN BROWSE brLiberCarg = 10. 
              &ELSE
              tt-liber-carg-brw.num-livre-1  :BGCOLOR IN BROWSE brLiberCarg = 10
              c-observacao                   :BGCOLOR IN BROWSE brLiberCarg = 10.
              &ENDIF
    ELSE IF tt-liber-carg-brw.idi-autoriz-descarga = 2 THEN
       ASSIGN c-descarregar                  :BGCOLOR IN BROWSE brLiberCarg = 12 
              c-situacao                     :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.cdn-compart  :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.lote         :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.dt-vali-lote :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.cod-depos    :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.val-quant    :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.val-peso-liq :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.codigo-rejei :BGCOLOR IN BROWSE brLiberCarg = 12
              &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
              tt-liber-carg-brw.nr-ficha     :BGCOLOR IN BROWSE brLiberCarg = 12
              tt-liber-carg-brw.cod-obs      :BGCOLOR IN BROWSE brLiberCarg = 12. 
              &ELSE
              tt-liber-carg-brw.num-livre-1  :BGCOLOR IN BROWSE brLiberCarg = 12
              c-observacao                   :BGCOLOR IN BROWSE brLiberCarg = 12.
              &ENDIF
    ASSIGN d-tot-val-quant = d-tot-val-quant + tt-liber-carg-brw.val-quant.
           d-val-peso-liq  = d-val-peso-liq  + tt-liber-carg-brw.val-peso-liq.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-dividir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dividir wMasterDetail
ON CHOOSE OF bt-dividir IN FRAME fPage0 /* Dividir */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0305b.w PERSISTENT SET h-prog-desp (INPUT tt-liber-carg-brw.r-rowid,
                                                  INPUT tt-carg-rural.r-rowid,
                                                  INPUT "Update":U,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 0,
                                                  INPUT YES) /* dividir */.
      
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).          
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.

    RUN openQueriesSonAux IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-liberar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-liberar wMasterDetail
ON CHOOSE OF bt-liberar IN FRAME fPage0 /* Libera‡Æo */
DO:
    DEFINE VARIABLE l-descarg-penden AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-cdn-pesagem    AS INTEGER NO-UNDO.
   
    /*Todos os compartimentos j  foram descarregados*/
    IF NOT CAN-FIND(FIRST tt-liber-carg-brw 
                    WHERE tt-liber-carg-brw.idi-autoriz-descarga = 0) THEN DO:
         RUN utp/ut-msgs.p(INPUT "show":U,
                           INPUT 54662, /* Todos os compartimentos já foram descarregados */
                           INPUT '').
         RETURN NO-APPLY.
    END.
 
    /* Selecione uma linha no browse*/
    IF NOT CAN-FIND(FIRST tt-liber-carg-brw 
                    WHERE (tt-liber-carg-brw.checkSum = 1 OR 
                           tt-liber-carg-brw.checkSum = 2)) THEN DO:
        
         RUN utp/ut-msgs.p(INPUT "show":U,
                           INPUT 54760, /*Selecione uma acao para a liberacao do compartimento.*/
                           INPUT ' ').
        RETURN NO-APPLY.
    END.
    
    APPLY 'CHOOSE':U TO bt-sav IN FRAME fPage0. 
    
    IF RETURN-VALUE <> "OK":U THEN    
        RETURN NO-APPLY.
    
    IF  VALID-HANDLE(h-boin00981) 
    AND VALID-HANDLE(h-boin00982) 
    AND VALID-HANDLE(h-boin00961) THEN DO:

        EMPTY TEMP-TABLE RowErrors.
        /* Busca todas as liber-carg ainda nÆo descarregadas
           e que estajam marcadas como decarregar(1) ou nÆo 
           descarregar(2) */        
        FOR EACH tt-liber-carg-brw 
           WHERE tt-liber-carg-brw.idi-autoriz-descarga = 0
             AND (tt-liber-carg-brw.checkSum = 1 OR 
                  tt-liber-carg-brw.checkSum = 2)
            BREAK BY tt-liber-carg-brw.idi-aprova 
                  BY tt-liber-carg-brw.checkSum
                  BY tt-liber-carg-brw.num-carg:
            
            IF tt-liber-carg-brw.idi-aprova = 1 THEN DO:
                RUN pi-cria-row-errors IN THIS-PROCEDURE(INPUT 54664, /*A situação do compartimento &1 da carga &2 está pendente.*/
                                                         INPUT STRING(tt-liber-carg-brw.cdn-compart) + "~~" + STRING(tt-liber-carg-brw.num-carg)).
                NEXT.                                                                                                       
            END.
            
            /* cria primeira pesagem */
            IF FIRST-OF(tt-liber-carg-brw.num-carg) THEN DO:
                IF i-idi-tip-aferic  = 1 THEN DO:
                     IF tt-liber-carg-brw.idi-aprova > 1 THEN DO:
                        RUN goToKey IN h-boin00981(INPUT tt-carg-rural.num-carg, INPUT 1).
                        IF RETURN-VALUE = "NOK":U THEN DO:                        
                            RUN createPesagem IN h-boin00981 (INPUT tt-carg-rural.num-carg,
                                                              INPUT 0, /* Peso */
                                                              INPUT ?, /* quantidade*/
                                                              INPUT 0, /* densidade*/
                                                              OUTPUT i-cdn-pesagem).
                            ASSIGN i-cdn-pesagem = 0.
                        END.
                     END.
                END.
            END.

            /* Cria pendencias de pesagem para os registros 
               marcados como descarrega(1) */    
            IF FIRST-OF(tt-liber-carg-brw.idi-aprova) 
                    AND tt-liber-carg-brw.checkSum  = 1 THEN DO:
                    
                IF i-idi-tip-aferic  = 1  THEN DO: /* PESO */  
                    IF tt-liber-carg-brw.idi-aprova > 1 THEN DO:
                        RUN createPesagem IN h-boin00981 (INPUT tt-carg-rural.num-carg,
                                                          INPUT 0, /* Peso */
                                                          INPUT ?, /* quantidade*/
                                                          INPUT 0, /* densidade*/
                                                          OUTPUT i-cdn-pesagem). 
             
                        EMPTY TEMP-TABLE RowErrorsAux NO-ERROR.
                        RUN getRowErrors IN h-boin00981(OUTPUT TABLE RowErrorsAux). 
                        FOR EACH RowErrorsAux
                           WHERE RowErrorsAux.ErrorType <> "INTERNAL":U:
                            CREATE RowErrors.
                            BUFFER-COPY RowErrorsAux TO RowErrors.
                        END.
                        
                        IF CAN-FIND(FIRST RowErrors) THEN LEAVE.                        
                    END.
                END.
            END.
            
            RUN repositionRecord IN h-boin00982(INPUT tt-liber-carg-brw.r-rowid).
        
            EMPTY TEMP-TABLE tt-liber-carg NO-ERROR.
            RUN getRecord IN h-boin00982(OUTPUT TABLE tt-liber-carg).
 
            FIND FIRST tt-liber-carg NO-ERROR.
            IF AVAIL tt-liber-carg THEN
                ASSIGN tt-liber-carg.idi-autoriz-descarga = tt-liber-carg-brw.checkSum
                       tt-liber-carg.cdn-pesagem          = i-cdn-pesagem.
             
            RUN setRecord    IN h-boin00982(INPUT TABLE tt-liber-carg).
            RUN updateRecord IN h-boin00982.
            EMPTY TEMP-TABLE RowErrorsAux NO-ERROR.
            RUN getRowErrors IN h-boin00982(OUTPUT TABLE RowErrorsAux). 
            
            FOR EACH RowErrorsAux
               WHERE RowErrorsAux.ErrorType <> "INTERNAL":U:
                CREATE RowErrors.
                BUFFER-COPY RowErrorsAux TO RowErrors.
            END.
            IF CAN-FIND(FIRST RowErrors) THEN LEAVE.
        END.
        
        IF CAN-FIND(FIRST RowErrors) THEN DO:
             {method/showmessage.i1}
             {method/showmessage.i2}
        END.

        RUN openQueriesSonAux IN THIS-PROCEDURE.
        
        RUN verificaDescargaPendente IN h-boin00982(INPUT tt-carg-rural.num-carg, OUTPUT l-descarg-penden).
        IF NOT l-descarg-penden THEN
            RUN atualizaSituacao IN h-boin00961(INPUT tt-carg-rural.num-carg, INPUT 3). /* DESCARGA CONCLUIDA*/
   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wMasterDetail
ON CHOOSE OF bt-sav IN FRAME fPage0 /* Sav */
DO:
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE d-resto     AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE d-qtd-total AS DECIMAL     NO-UNDO.
    
    IF l-balanca THEN DO:
        IF VALID-HANDLE({&hDBOParent}) THEN DO:
            EMPTY TEMP-TABLE RowErrors NO-ERROR.
            RUN emptyRowErrors  IN {&hDBOParent}.
            RUN updateDensidade IN {&hDBOParent}(INPUT tt-carg-rural.num-carg, 
                                                 INPUT INPUT FRAME fPage0 tt-carg-rural.val-densidade).
            RUN getRowErrors IN {&hDBOParent}(OUTPUT TABLE RowErrors).                                                     
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
                 {method/showmessage.i1}
                 {method/showmessage.i2}
                 RETURN NO-APPLY.
            END.                                     
                                                 
            ASSIGN d-val-densidade = INPUT FRAME fPage0 tt-carg-rural.val-densidade.
    
            APPLY 'CHOOSE' TO btRefresh IN FRAME fPage0.
        END.
    END.
    ELSE DO:        
        IF VALID-HANDLE(h-boin00982) THEN DO:
        
            ASSIGN d-qtd-total = INPUT FRAME fPage0 fi-qtd-total.            
        
            /* Se o compartimento estiver pendente ou nao descarregado e a quantidade for 
               maior que zero, pergunta se deseja zerar o compartimento */ 
            IF CAN-FIND(FIRST tt-liber-carg-brw  
                        WHERE ((tt-liber-carg-brw.checkSum = 0 OR tt-liber-carg-brw.checkSum = 2) 
                          AND tt-liber-carg-brw.val-quant > 0)
                          AND tt-liber-carg-brw.idi-autoriz-descarga = 0) THEN DO:
                          
                RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                                   INPUT 54729,
                                   INPUT ' '). /*Atenção! Quantidades serão zeradas! Confirma?*/
                                   
                IF RETURN-VALUE = "NO" THEN                    
                    RETURN NO-APPLY.
                          
                FOR EACH tt-liber-carg-brw
                   WHERE ((tt-liber-carg-brw.checkSum = 0 OR tt-liber-carg-brw.checkSum = 2) 
                     AND tt-liber-carg-brw.val-quant > 0
                     AND tt-liber-carg-brw.idi-autoriz-descarga = 0):
                    ASSIGN tt-liber-carg-brw.val-quant = 0.                               
                    RUN piUpdateLiberCarg IN THIS-PROCEDURE.
                END.
                APPLY 'CHOOSE' TO btRefresh IN FRAME fPage0.
            END.            
                
            
            RUN openQueryStatic IN h-boin00982 (INPUT "Main":U).    
            IF INPUT FRAME fPage0 fi-qtd-total > 0 THEN DO:            
                FOR EACH tt-liber-carg-brw
                   WHERE tt-liber-carg-brw.checkSum = 1  
                     AND tt-liber-carg-brw.idi-autoriz-descarga = 0: 
                   ASSIGN i-cont = i-cont + 1.
                END.
                
                IF i-cont > 0 THEN DO:                
                    FOR EACH tt-liber-carg-brw
                       WHERE tt-liber-carg-brw.checkSum = 1
                          AND tt-liber-carg-brw.idi-autoriz-descarga = 0
                         BREAK BY tt-liber-carg-brw.num-carg:         

                        RUN goTokey IN h-boin00982(INPUT tt-liber-carg-brw.num-carg, INPUT tt-liber-carg-brw.cdn-liber).
                        
                        IF RETURN-VALUE = 'OK':U THEN DO:
                            EMPTY TEMP-TABLE tt-liber-carg-aux NO-ERROR.

                            RUN getRecord IN h-boin00982(OUTPUT TABLE tt-liber-carg-aux).
                            FIND FIRST tt-liber-carg-aux NO-ERROR.
                            
                            IF l-fraciona THEN
                                ASSIGN tt-liber-carg-aux.val-quant = TRUNC((d-qtd-total  / i-cont) , 4).
                            ELSE
                                ASSIGN tt-liber-carg-aux.val-quant = TRUNC((d-qtd-total  / i-cont) , 0).
                               
                            ASSIGN d-resto = d-resto + tt-liber-carg-aux.val-quant.
                            
                            IF LAST-OF( tt-liber-carg-brw.num-carg) THEN                            
                                ASSIGN tt-liber-carg-aux.val-quant = tt-liber-carg-aux.val-quant + (d-qtd-total - d-resto).
                            
                            RUN emptyRowErrors IN H-boin00982.
                            RUN setRecord      IN h-boin00982(INPUT TABLE tt-liber-carg-aux).
                            RUN updateRecord   IN h-boin00982.                             
                            EMPTY TEMP-TABLE RowErrorsAux NO-ERROR.
                            RUN getRowErrors IN h-boin00982(OUTPUT TABLE RowErrorsAux). 
                            IF CAN-FIND(FIRST RowErrorsAux
                                        WHERE RowErrorsAux.ErrorType <> "INTERNAL":U) THEN DO:
                                CREATE RowErrors.
                                BUFFER-COPY RowErrorsAux TO RowErrors.
                                LEAVE.
                            END.    
                        END.
                    END.
                    IF CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
                        {method/showmessage.i1}
                        {method/showmessage.i2}
                    END.
                    
                    APPLY 'CHOOSE' TO btRefresh IN FRAME fPage0.
                    
                END.
                ELSE 
                     APPLY 'CHOOSE' TO btRefresh IN FRAME fPage0.

                ASSIGN fi-qtd-total = 0.
                    
                DISP fi-qtd-total 
                    WITH FRAME fPage0.
            END. 
        END.
    END.

    RETURN 'OK':U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-unificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-unificar wMasterDetail
ON CHOOSE OF bt-unificar IN FRAME fPage0 /* Unificar */
DO:
    DEFINE VARIABLE i-cont AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-msg  AS CHARACTER NO-UNDO.

    IF VALID-HANDLE({&hDBOSon1}) THEN DO:
      
        FOR EACH bf-tt-liber-carg-brw
           WHERE bf-tt-liber-carg-brw.cdn-compart = tt-liber-carg-brw.cdn-compart:
           ASSIGN i-cont = i-cont + 1.
        END.   
    
        {utp/ut-liter.i Unificar_o_Compartimento * }
        ASSIGN c-msg = RETURN-VALUE.
        {utp/ut-liter.i compartimento_dividido * }
        ASSIGN c-msg = c-msg + "~~" + RETURN-VALUE.
    
        IF i-cont = 1 then do:
            RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                               INPUT 54728, /* Não é possível unificar o compartimento!*/
                               INPUT tt-liber-carg-brw.cdn-compart).
            RETURN NO-APPLY.
        END.    
    
        RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                           INPUT 54660, /* Confirma unificação da linha selecionada? */
                           INPUT STRING(tt-liber-carg-brw.cdn-compart)).

        IF RETURN-VALUE = 'YES':U THEN DO:
        
            ASSIGN iLinha = brLiberCarg:FOCUSED-ROW IN FRAME fPage1 .
            RUN unificarLiberCarg IN {&hDBOSon1} (INPUT tt-liber-carg-brw.num-carg, 
                                                  INPUT tt-liber-carg-brw.cdn-compart,
                                                  INPUT tt-liber-carg-brw.r-rowId).
            RUN openQueriesSonAux IN THIS-PROCEDURE.
            REPOSITION brLiberCarg TO ROW (ilinha) NO-ERROR.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAnalise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAnalise wMasterDetail
ON CHOOSE OF btAnalise IN FRAME fPage0 /* An lises */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN cqp/cq0222.w PERSISTENT SET h-prog-desp.   
      
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN pi-set-constraint-carga IN h-prog-desp(INPUT tt-carg-rural.it-codigo, INPUT tt-carg-rural.num-carg).
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).          
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.        
    END.
    
    APPLY 'CHOOSE' TO btRefresh IN FRAME fPage0.
    
    ASSIGN h-prog-desp = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprovar wMasterDetail
ON CHOOSE OF btAprovar IN FRAME fPage0 /* Aprovar */
DO:
    IF AVAIL tt-liber-carg-brw  THEN DO:

        ASSIGN tt-liber-carg-brw.idi-aprova = 2 /* Aprovado */
               iLinha                       = brLiberCarg:FOCUSED-ROW IN FRAME fPage1.

        RUN piUpdateLiberCarg IN THIS-PROCEDURE. 
        IF RETURN-VALUE = 'NOK' THEN
            ASSIGN  tt-liber-carg-brw.idi-aprova   = 1. /* PENDENTE*/
            
        {&OPEN-QUERY-brLiberCarg}

        REPOSITION brLiberCarg  TO ROW (ilinha) NO-ERROR.
    END.
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


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wMasterDetail
ON CHOOSE OF btRefresh IN FRAME fPage0
DO:
    RUN openQueriesSonAux IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btReprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReprovar wMasterDetail
ON CHOOSE OF btReprovar IN FRAME fPage0 /* Reprovar */
DO:

    DEFINE VARIABLE i-codigo-rejei AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cod-depos    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-observacao   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lok            AS LOGICAL     NO-UNDO.

    IF AVAIL tt-liber-carg-brw  THEN DO:
        ASSIGN i-codigo-rejei = tt-liber-carg-brw.codigo-rejei  
               &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */        
               c-observacao   = tt-liber-carg-brw.cod-obs.
               &ELSE
               c-observacao   = SUBSTR(tt-liber-carg-brw.cod-livre-1, 1, 100).
               &ENDIF
        
        ASSIGN c-cod-depos    = IF tt-liber-carg-brw.idi-aprova = 1 THEN "" ELSE tt-liber-carg-brw.cod-depos.
               
        {&WINDOW-NAME}:SENSITIVE = NO.
        
        RUN aqp/aq0305a.w(INPUT tt-carg-rural.cod-estabel,
                          INPUT-OUTPUT i-codigo-rejei, 
                          INPUT-OUTPUT c-cod-depos,
                          INPUT-OUTPUT c-observacao,
                          OUTPUT lok).
        IF lOk THEN DO:
            ASSIGN tt-liber-carg-brw.codigo-rejei = i-codigo-rejei
                   tt-liber-carg-brw.cod-depos    = c-cod-depos
                   tt-liber-carg-brw.idi-aprova   = 3 /* Reprovado*/
                   &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ 
                   tt-liber-carg-brw.cod-obs      = c-observacao.
                   &ELSE
                   OVERLAY(tt-liber-carg-brw.cod-livre-1, 1, 100) = c-observacao.
                   &ENDIF
        END.

        ASSIGN iLinha = brLiberCarg:FOCUSED-ROW IN FRAME fPage1.

        RUN piUpdateLiberCarg IN THIS-PROCEDURE.
        IF RETURN-VALUE = 'NOK' THEN
            ASSIGN  tt-liber-carg-brw.idi-aprova   = 1. /* PENDENTE*/

        {&OPEN-QUERY-brLiberCarg}
          
        REPOSITION brLiberCarg TO ROW (ilinha) NO-ERROR.
        {&WINDOW-NAME}:SENSITIVE = YES.

    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="inzoom/z01in00961.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage0 /* Modificar */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0305b.w PERSISTENT SET h-prog-desp (INPUT tt-liber-carg-brw.r-rowid,
                                                  INPUT tt-carg-rural.r-rowid,
                                                  INPUT "Update":U,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 0,
                                                  INPUT ?) /* dividir */ .
      
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).          
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.

    RUN openQueriesSonAux IN THIS-PROCEDURE.

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

ON MOUSE-SELECT-DBLCLICK OF brLiberCarg IN FRAME fPage1
DO:
    IF tt-liber-carg-brw.idi-aprova = 1 THEN DO: /* pendente*/   
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 54762, /* Compartimento &1 está pendente de análise */
                          INPUT tt-liber-carg-brw.cdn-compart).
        RETURN NO-APPLY.        
    END.

   GET CURRENT brLiberCarg.
   ASSIGN iLinha = brLiberCarg:FOCUSED-ROW IN FRAME fPage1.

   
   IF tt-liber-carg-brw.idi-aprova = 2 THEN DO: /* Aprovado */
       CASE tt-liber-carg-brw.checkSum:
           WHEN 0 THEN ASSIGN tt-liber-carg-brw.checkSum = 1. /* Descarregar */
           WHEN 1 THEN ASSIGN tt-liber-carg-brw.checkSum = 0. /* Branco */         
       END CASE.
   END.
   ELSE DO: /* Reprovado */
        CASE tt-liber-carg-brw.checkSum:
           WHEN 0 THEN ASSIGN tt-liber-carg-brw.checkSum = 1. /* Descarregar */
           WHEN 1 THEN ASSIGN tt-liber-carg-brw.checkSum = 2. /* Nao Descarregar */
           WHEN 2 THEN ASSIGN tt-liber-carg-brw.checkSum = 0. /* Branco */
       END CASE.  
   END.

   {&OPEN-QUERY-brLiberCarg}
   REPOSITION brLiberCarg TO ROW (ilinha) NO-ERROR.

END.


ON 'VALUE-CHANGED':U OF brLiberCarg IN FRAME fPage1
DO:                                             
    RUN piApllyValueChangedBr IN THIS-PROCEDURE.
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
    IF VALID-HANDLE(h-boin684) THEN
        RUN destroy IN h-boin684 .

    IF VALID-HANDLE(h-boin00983) THEN
        RUN destroy IN h-boin00983 .

    IF VALID-HANDLE(h-boin00981) THEN
        RUN destroy IN h-boin00981 .
        
    IF VALID-HANDLE(h-boin00982) THEN
        RUN destroy IN h-boin00982 .        

    IF VALID-HANDLE(h-boin417) THEN
        RUN destroy IN h-boin417 .

    IF VALID-HANDLE(h-boin172na) THEN
        RUN destroy IN h-boin172na .

    IF VALID-HANDLE(h-boad107na) THEN
        RUN destroy IN h-boad107na .

    IF VALID-HANDLE(h-boin00975) THEN
        RUN destroy IN h-boin00975 .
        
    IF VALID-HANDLE(h-boin282) THEN
        RUN destroy IN h-boin282 .
        
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
    DEFINE VARIABLE i-dimensao       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tipo-cq        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-un             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome           AS CHARACTER   NO-UNDO.
    
    IF AVAIL tt-carg-rural AND l-inicializou THEN DO:
        RUN pi-criar-liber-carg IN THIS-PROCEDURE.
        
        /* ESTABELECIMENTO */
        IF VALID-HANDLE(h-boad107na) THEN DO:
            RUN goToKey IN h-boad107na(INPUT tt-carg-rural.cod-estabel).
            IF RETURN-VALUE = 'OK':U THEN
                RUN getCharField IN  h-boad107na (INPUT 'nome':U, OUTPUT c-nome).                           
            ELSE
                ASSIGN c-nome = "".
        END.
        
        /* ROTA-COLETA*/
        IF VALID-HANDLE(h-boin00975) THEN DO:
            RUN goToKey IN h-boin00975(INPUT tt-carg-rural.cod-rota).
            IF RETURN-VALUE = 'OK':U THEN
                RUN getCharField IN  h-boin00975 (INPUT 'des-rota':U, OUTPUT c-des-rota).            
            ELSE
                ASSIGN c-des-rota = "".
        END.
        
        /* PARAM-CQ */
        IF VALID-HANDLE(h-boin282) THEN
            RUN getIntField IN h-boin282(INPUT 'tipo-cq':U, OUTPUT i-tipo-cq).
            
        /* ITEM-UNI-ESTAB */
        IF VALID-HANDLE(h-boin684) THEN DO:
            RUN goToKey IN h-boin684(INPUT tt-carg-rural.it-codigo,INPUT tt-carg-rural.cod-estabel).            
            IF RETURN-VALUE = "OK" THEN
                RUN getLogField IN h-boin684 (INPUT 'contr-qualid':U, OUTPUT l-contr-qualid).
            ELSE 
                ASSIGN l-contr-qualid = NO.
        END.
        
        /* ITEM-ESTAB-RURAL*/
        IF VALID-HANDLE(h-boin00983) THEN DO:
            RUN goToKey IN h-boin00983(INPUT tt-carg-rural.it-codigo,INPUT tt-carg-rural.cod-estabel).
       
            IF RETURN-VALUE = "OK" THEN DO:
                RUN getIntField IN h-boin00983 (INPUT 'idi-desc-sem-rot':U, OUTPUT i-idi-desc-sem-rot).
                RUN getIntField IN h-boin00983 (INPUT 'idi-tip-aferic':U,   OUTPUT i-idi-tip-aferic).
            END. 
            ELSE 
                ASSIGN i-idi-desc-sem-rot = 0
                       i-idi-tip-aferic   = 0.         
        END.
        
        /* ITEM */
        IF VALID-HANDLE(h-boin172na) THEN DO:
            RUN goToKey IN h-boin172na(INPUT tt-carg-rural.it-codigo).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin172na (INPUT 'un':U, OUTPUT c-un).
                RUN getLogField IN h-boin172na (INPUT 'fraciona':U, OUTPUT l-fraciona).
            END.   
            ELSE
                ASSIGN c-un = ""
                       l-fraciona = NO.
        END.
        
        /* TAB-UNIDADE */
        IF VALID-HANDLE(h-boin417) THEN DO:
            RUN goToKey IN h-boin417(INPUT c-un).
            IF RETURN-VALUE = "OK":U THEN
                RUN getIntField IN h-boin417 (INPUT 'dimensao':U, OUTPUT i-dimensao).
             /* i-dimensao  = 1 - PESO 
                              4 - VOLUMETRICO
                i-idi-tip-aferic = 1- PESO
             */
            ASSIGN l-balanca =  i-idi-tip-aferic = 1 AND  (i-dimensao = 1 OR i-dimensao = 4).
        END.
        
        ASSIGN tt-carg-rural.val-densidade:VISIBLE IN FRAME fPage0 = l-balanca
               fi-qtd-total:VISIBLE                IN FRAME fPage0 = NOT l-balanca
               fi-desc-estab:SCREEN-VALUE          IN FRAME fPage0 = c-nome
               c-des-rota:SCREEN-VALUE             IN FRAME fPage0 = c-des-rota.
               
        IF fi-qtd-total:VISIBLE IN FRAME fPage0 AND NOT l-fraciona THEN
            ASSIGN fi-qtd-total:FORMAT IN FRAME fPage0 = '>>>>,>>>,>>9':U.
            
        IF tt-carg-rural.cdn-sit > 3 THEN /*{i01/in00961.i}*/
            ASSIGN bt-sav:SENSITIVE                      IN FRAME fPage0 = NO
                   btRefresh:SENSITIVE                   IN FRAME fPage0 = NO
                   btAnalise:SENSITIVE                   IN FRAME fPage0 = l-contr-qualid AND i-tipo-cq > 1
                   btAprovar:SENSITIVE                   IN FRAME fPage0 = NO
                   btReprovar:SENSITIVE                  IN FRAME fPage0 = NO
                   bt-dividir:SENSITIVE                  IN FRAME fPage0 = NO
                   bt-unificar:SENSITIVE                 IN FRAME fPage0 = NO
                   bt-liberar:SENSITIVE                  IN FRAME fPage0 = NO
                   btUpdateSon1:SENSITIVE                IN FRAME fPage0 = NO
                   tt-carg-rural.val-densidade:SENSITIVE IN FRAME fPage0 = NO 
                   fi-qtd-total:SENSITIVE                IN FRAME fPage0 = NO.
        ELSE DO:
        
            ASSIGN btRefresh:SENSITIVE    IN FRAME fPage0 = YES
                   btUpdateSon1:SENSITIVE IN FRAME fPage0 = YES
                   bt-liberar:SENSITIVE   IN FRAME fPage0 = YES
                   bt-sav:SENSITIVE       IN FRAME fPage0 = YES.
                  
            ASSIGN d-val-densidade = tt-carg-rural.val-densidade.
    
            REPOSITION brLiberCarg TO ROW (1) NO-ERROR.
            
            ENABLE tt-carg-rural.val-densidade
                   fi-qtd-total
                   WITH FRAME fPage0.                       
                   
            /* NAO TEM CQ(GLOBAL) ou NAO TEM CQ (item-uni-estab) */
            ASSIGN l-aprov-auto = i-tipo-cq = 0 OR NOT l-contr-qualid.
            
            ASSIGN tt-carg-rural.val-densidade:VISIBLE IN FRAME fPage0 = l-balanca
                   fi-qtd-total:VISIBLE                IN FRAME fPage0 = NOT l-balanca
                   btAnalise:SENSITIVE                 IN FRAME fPage0 = l-contr-qualid AND i-tipo-cq > 1
                   tt-carg-rural.val-densidade:SENSITIVE = l-balanca AND i-dimensao = 4. /* VOLUMETRICO */ 
            

            /* sE DIMENSAO FOR PESO, ATUALIZA DENSIDADE PARA FATOR 1*/
            IF l-balanca AND i-dimensao = 1 THEN      
                 ASSIGN bt-sav:SENSITIVE IN FRAME fPage0 = NO
                        tt-carg-rural.val-densidade:SCREEN-VALUE IN FRAME fPage0 = '1'.
        END.
    
        RUN openQueriesSonAux IN THIS-PROCEDURE.
        RUN piApllyValueChangedBr IN THIS-PROCEDURE.
        
        IF l-aprov-auto THEN 
            RUN aprovacaoAutomaticaCompart IN THIS-PROCEDURE.  
    END.   
    
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
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    IF VALID-HANDLE({&hDBOParent}) AND v_num-carg-aq0305 <> ? AND v_num-carg-aq0305 > 0 THEN DO:
        RUN goToKey IN {&hDBOParent} (INPUT v_num-carg-aq0305).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN NO-APPLY.        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).        
    END.   
    
     RUN inicializa-destroy-h-boin124a IN {&hDBOSon1}(INPUT 1). /* inicializa */ 
     ASSIGN l-inicializou = YES.
     RUN afterDisplayFields IN THIS-PROCEDURE. 
        
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovacaoAutomaticaCompart wMasterDetail 
PROCEDURE aprovacaoAutomaticaCompart :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-atualizou AS LOGICAL NO-UNDO.
    
    FOR EACH tt-liber-carg-brw
       WHERE tt-liber-carg-brw.idi-aprova = 1 : /* PENDENTE*/    
        ASSIGN tt-liber-carg-brw.idi-aprova = 2 /* Aprovado */
               l-atualizou = YES.
        RUN piUpdateLiberCarg IN THIS-PROCEDURE. 
        IF RETURN-VALUE = 'NOK' THEN
            ASSIGN  tt-liber-carg-brw.idi-aprova   = 1 /* PENDENTE*/
                    l-atualizou = NO.
    END.    
    IF l-atualizou THEN DO:
        RUN openQueriesSonAux IN THIS-PROCEDURE.
        RUN piApllyValueChangedBr IN THIS-PROCEDURE.    
    END.    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMasterDetail 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    RUN inicializa-destroy-h-boin124a IN {&hDBOSon1}(INPUT 2). /* destroy */
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
    
    DEFINE VARIABLE i-num-carg LIKE {&ttParent}.num-carg
        VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
    
    
    DEFINE FRAME fGoToRecord
        i-num-carg AT ROW 1.751 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Carga Rural" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Carga_Rural"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-carg .
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-num-carg).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Carga Rural":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-carg 
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
    
    /* carg-rural*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00961.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' {&hDBOParent}} 
    END.
    
    IF VALID-HANDLE({&hDBOParent}) THEN
        RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    /*liber-carg*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "inbo/boin00982.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00982.p YES}
        {btb/btb008za.i2 inbo/boin00982.p '' {&hDBOSon1}} 
    END.

    /* item-uni-estab */
    IF NOT VALID-HANDLE(h-boin684) OR 
       h-boin684:TYPE <> "PROCEDURE":U OR
       h-boin684:FILE-NAME <> "inbo/boin684.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin684.p YES}
        {btb/btb008za.i2 inbo/boin684.p '' h-boin684} 
    END.
    IF VALID-HANDLE(h-boin684) THEN
        RUN openQueryStatic IN h-boin684 (INPUT "Main":U) NO-ERROR.

    /* item-estab-rural */
    IF NOT VALID-HANDLE(h-boin00983) OR 
       h-boin00983:TYPE <> "PROCEDURE":U OR
       h-boin00983:FILE-NAME <> "inbo/boin00983.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00983.p YES}
        {btb/btb008za.i2 inbo/boin00983.p '' h-boin00983} 
    END.
    IF VALID-HANDLE(h-boin00983) THEN
        RUN openQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.

    /* pesagem  */
    IF NOT VALID-HANDLE(h-boin00981) OR 
       h-boin00981:TYPE <> "PROCEDURE":U OR
       h-boin00981:FILE-NAME <> "inbo/boin00981.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00981.p YES}
        {btb/btb008za.i2 inbo/boin00981.p '' h-boin00981} 
    END.    
    IF VALID-HANDLE(h-boin00981) THEN
        RUN openQueryStatic IN h-boin00981 (INPUT "Main":U) NO-ERROR.

    /* tab-unidade  */
    IF NOT VALID-HANDLE(h-boin417) OR 
       h-boin417:TYPE <> "PROCEDURE":U OR
       h-boin417:FILE-NAME <> "inbo/boin417.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin417.p YES}
        {btb/btb008za.i2 inbo/boin417.p '' h-boin417} 
    END.
    IF VALID-HANDLE(h-boin417) THEN
        RUN openQueryStatic IN h-boin417 (INPUT "Main":U) NO-ERROR.

    /* item  */
    IF NOT VALID-HANDLE(h-boin172na) OR 
       h-boin172na:TYPE <> "PROCEDURE":U OR
       h-boin172na:FILE-NAME <> "inbo/boin172na.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na} 
    END.
    IF VALID-HANDLE(h-boin172na) THEN
        RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.
        
    /* estabelec  */ 
    IF NOT VALID-HANDLE(h-boad107na) OR 
       h-boad107na:TYPE <> "PROCEDURE":U OR
       h-boad107na:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad107na.p YES}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na} 
    END.
    IF VALID-HANDLE(h-boad107na) THEN    
        RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR.

    /* rota-coleta  */ 
    IF NOT VALID-HANDLE(h-boin00975) OR 
       h-boin00975:TYPE <> "PROCEDURE":U OR
       h-boin00975:FILE-NAME <> "inbo/boin00975.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00975.p YES}
        {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975} 
    END.
    IF VALID-HANDLE(h-boin00975) THEN    
        RUN openQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.

     /* param-cq  */ 
    IF NOT VALID-HANDLE(h-boin282) OR 
       h-boin282:TYPE <> "PROCEDURE":U OR
       h-boin282:FILE-NAME <> "inbo/boin282.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin282.p YES}
        {btb/btb008za.i2 inbo/boin282.p '' h-boin282} 
    END.
    IF VALID-HANDLE(h-boin282) THEN    
        RUN openQueryStatic IN h-boin282 (INPUT "Main":U) NO-ERROR.       

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSonAux wMasterDetail 
PROCEDURE openQueriesSonAux :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00982) AND AVAIL tt-carg-rural THEN DO:
    
        ASSIGN iLinha = brLiberCarg:FOCUSED-ROW IN FRAME fPage1 .

        DEFINE VARIABLE iRowsReturned AS INTEGER   NO-UNDO.   
        DEFINE VARIABLE cCheck        AS CHARACTER NO-UNDO.
       
        EMPTY TEMP-TABLE tt-liber-carg     NO-ERROR.

        FOR EACH tt-liber-carg-brw
            WHERE (tt-liber-carg-brw.checkSum = 1 OR tt-liber-carg-brw.checkSum = 2):
            CREATE tt-selecionado.
            ASSIGN tt-selecionado.r-rowid = tt-liber-carg-brw.r-rowid
                   tt-selecionado.i-sit   = tt-liber-carg-brw.checkSum.
        END.

        EMPTY TEMP-TABLE tt-liber-carg-brw NO-ERROR.
        RUN setConstraintNumCarga IN h-boin00982 (INPUT tt-carg-rural.num-carg).
        RUN emptyRowObject        IN h-boin00982.
        RUN openQueryStatic       IN h-boin00982 (INPUT "NumCarg":U).
        RUN getBatchRecords       IN h-boin00982 (INPUT ?,
                                                 INPUT NO,
                                                 INPUT 9999,
                                                 OUTPUT iRowsReturned,
                                                 OUTPUT TABLE tt-liber-carg).
       
        FOR EACH tt-liber-carg:
            CREATE tt-liber-carg-brw.
            BUFFER-COPY tt-liber-carg TO tt-liber-carg-brw NO-ERROR.

            FIND FIRST tt-selecionado
                 WHERE tt-selecionado.r-rowid = tt-liber-carg-brw.r-rowid NO-ERROR.
            IF AVAIL tt-selecionado THEN
                ASSIGN tt-liber-carg-brw.checkSum = tt-selecionado.i-sit.
        END.

        EMPTY TEMP-TABLE tt-selecionado NO-ERROR.
       
        ASSIGN d-tot-val-quant = 0
               d-val-peso-liq  = 0.
     

        /*--- Abre a query associada ao browse da pÿgina {&PageNumber} ---*/
        {&OPEN-QUERY-brLiberCarg}

        IF CAN-FIND(FIRST tt-liber-carg-brw) THEN DO:

            IF ilinha <> ? THEN
                REPOSITION brLiberCarg TO ROW (ilinha) NO-ERROR.


            APPLY "VALUE-CHANGED":U TO BROWSE brLiberCarg.
    
             ASSIGN fi-tot-peso = d-tot-val-quant
                    fi-tot-qtd  = d-val-peso-liq.
    
             DISPLAY fi-tot-peso
                     fi-tot-qtd WITH FRAME fPage0.      
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-row-errors wMasterDetail 
PROCEDURE pi-cria-row-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT parameter p-num-msg AS INTEGER  no-undo.
    DEFINE INPUT parameter p-texto   AS CHARACTER format "x(255)" no-undo.    
    
    DEFINE VARIABLE iErrorSequence    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorSubType     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorDescription AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorHelp        AS CHARACTER  NO-UNDO.

    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        run utp/ut-msgs.p (input "msg":U,
                           input p-num-msg,
                           input p-texto).                       
        assign cErrorDescription = RETURN-VALUE.
        
        /** Busca o Tipo de Mensagem do EMS **/
        RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT p-num-msg,
                       INPUT p-texto).
        CASE {uninc/i01un001.i 06 RETURN-VALUE}:
        WHEN 1 THEN
            ASSIGN cErrorSubType = "ERROR":U.
        WHEN 2 THEN
            ASSIGN cErrorSubType = "WARNING":U.
        WHEN 3 THEN
            ASSIGN cErrorSubType = "QUESTION":U.
        WHEN 4 THEN
            ASSIGN cErrorSubType = "INFORMATION":U.
        END CASE.
        
        /** Busca Help da Mensagem **/
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-num-msg,  
                       INPUT p-texto).   
        ASSIGN cErrorHelp = RETURN-VALUE.
        
        /*--- Atualiza vari‰vel de sequÝncia de erros ---*/
        IF CAN-FIND(LAST rowErrors) THEN DO:
        FIND LAST rowErrors NO-ERROR.
        ASSIGN iErrorSequence = rowErrors.ErrorSequence + 1.
        END.
        ELSE
        ASSIGN iErrorSequence = iErrorSequence + 1.        
       
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorSequence    = iErrorSequence
           rowErrors.ErrorNumber      = p-num-msg
           rowErrors.ErrorType        = "EMS":U
           rowErrors.ErrorSubType     = cErrorSubType
           rowErrors.ErrorDescription = cErrorDescription
           rowErrors.ErrorHelp        = cErrorHelp
           rowErrors.ErrorParameters  = p-texto.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-liber-carg wMasterDetail 
PROCEDURE pi-criar-liber-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE({&hDBOSon1}) THEN DO:

        IF AVAIL tt-carg-rural THEN DO:
            DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.
            RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.
            RUN goToKey         IN {&hDBOSon1} (INPUT INPUT FRAME fPage0 tt-carg-rural.num-carg, 1).            
            IF RETURN-VALUE = 'NOK' THEN DO:    
                IF NOT VALID-HANDLE(h-acomp) THEN
                    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
                 EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
                {utp/ut-liter.i Atualizando * }
                RUN pi-inicializar IN h-acomp(INPUT RETURN-VALUE).
                {utp/ut-liter.i Criando_Liber_Carg... * }
                RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).
        
                RUN createLiberCarg IN {&hDBOSon1}(INPUT INPUT FRAME fPage0 tt-carg-rural.num-carg,
                                                   INPUT INPUT FRAME fPage0 tt-carg-rural.qti-comptmento).
                
                RUN pi-finalizar in h-acomp.
    
                RUN getRowErrors IN {&hDBOSon1}(OUTPUT TABLE RowErrors).
    
                IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                    RETURN 'NOK':U.
                END.
            END.
        END.

    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piApllyValueChangedBr wMasterDetail 
PROCEDURE piApllyValueChangedBr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-sensitive  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-usuar-resp AS LOGICAL NO-UNDO.
    
    IF NUM-RESULTS ("brLiberCarg":U) > 0 THEN DO:
        GET CURRENT brLiberCarg NO-LOCK.
        
        ASSIGN l-sensitive = tt-carg-rural.cdn-sit <=3 AND tt-liber-carg-brw.val-quant > 0.
        
        ASSIGN bt-dividir:SENSITIVE   IN FRAME fPage0 = l-sensitive
               bt-unificar:SENSITIVE  IN FRAME fPage0 = l-sensitive.       
        IF l-aprov-auto THEN       
                ASSIGN btAprovar:SENSITIVE  IN FRAME fPage0 =  NO
                       btReprovar:SENSITIVE IN FRAME fPage0 =  NO.
        ELSE DO:        
            IF i-idi-desc-sem-rot = 0 THEN /* nao permite descarregar se aprpvação de roteiro */
                ASSIGN btAprovar:SENSITIVE  IN FRAME fPage0 = NO
                       btReprovar:SENSITIVE IN FRAME fPage0 = NO.
            ELSE DO:
                ASSIGN l-sensitive = NO.
                RUN habilitarBtAprovReprov IN {&hDBOSon1}(INPUT tt-liber-carg-brw.num-carg, INPUT tt-liber-carg-brw.cdn-liber, OUTPUT l-sensitive).
                ASSIGN btAprovar:SENSITIVE  IN FRAME fPage0 = l-sensitive
                       btReprovar:SENSITIVE IN FRAME fPage0 = l-sensitive.
                
            END.           
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piUpdateLiberCarg wMasterDetail 
PROCEDURE piUpdateLiberCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE({&hDBOSon1}) AND AVAIL tt-liber-carg-brw  THEN DO:

        RUN goToKey IN {&hDBOSon1} (INPUT tt-liber-carg-brw.num-carg, 
                                    INPUT tt-liber-carg-brw.cdn-compart).
        IF RETURN-VALUE = 'OK':U THEN DO:
            EMPTY TEMP-TABLE tt-liber-carg NO-ERROR.
            CREATE tt-liber-carg.
            BUFFER-COPY tt-liber-carg-brw EXCEPT checkSum TO tt-liber-carg NO-ERROR.

            EMPTY TEMP-TABLE rowErrors NO-ERROR.
            RUN emptyRowErrors IN  {&hDBOSon1}.

            RUN setRecord    IN {&hDBOSon1} (INPUT TABLE tt-liber-carg).
            RUN updateRecord IN {&hDBOSon1}.

            RUN getRowErrors   IN  {&hDBOSon1}(OUTPUT TABLE RowErrors).               
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
                 {method/showmessage.i1}
                 {method/showmessage.i2}
                 RETURN 'NOK':U.
            END.
        END.   
        RETURN 'OK':U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacao wMasterDetail 
FUNCTION fnSituacao RETURNS CHARACTER
  ( iCdn-sit AS INTEGER ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    RETURN {ininc/i01in00982.i 04 iCdn-sit}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_descarregar wMasterDetail 
FUNCTION fn_descarregar RETURNS CHARACTER
  ( i-check AS INT , p-idi-autoriz-descarga AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE c-return AS CHARACTER FORMAT 'x(30)'  NO-UNDO.

   IF p-idi-autoriz-descarga > 0 THEN 
       ASSIGN c-return = {ininc/i02in00982.i 04 p-idi-autoriz-descarga}.
   ELSE IF i-check > 0 THEN
       ASSIGN c-return = {ininc/i03in00982.i 04 i-check}.

   RETURN c-return .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

