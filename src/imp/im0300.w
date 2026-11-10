&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
          mguni            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-despes-ped-compra NO-UNDO LIKE despes-ped-compra
       Field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
       Field r-rowid as rowid
       Field RowNum as int.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0300 2.00.00.011 } /*** "010011" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0300 MIM}
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
&GLOBAL-DEFINE Program          IM0300
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Despesas

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         tt-pedido-compr
&GLOBAL-DEFINE hDBOParent       h-boin295
&GLOBAL-DEFINE DBOParentTable   pedido-compr

&GLOBAL-DEFINE ttSon1           tt-despes-ped-compra
&GLOBAL-DEFINE hDBOSon1         h-bocx341
&GLOBAL-DEFINE DBOSon1Table     despes-ped-compra

&GLOBAL-DEFINE page0Fields      tt-pedido-compr.num-pedido ~
                                tt-pedido-compr.data-pedido ~
                                tt-pedido-compr.cod-emitente
                                

&GLOBAL-DEFINE page1Browse      brSon1




/* Parameters Definitions ---                                           */


/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE p-cod-emitente AS INTEGER                  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-num-pedido   AS INTEGER                  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-add-ccp      AS LOGICAL                  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-moeda-g      AS INTEGER INITIAL 0        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-conv-g       AS LOGICAL INITIAL YES      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE da-conv-g      AS DATE FORMAT "99/99/9999" NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-cgc                 AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-retorno             AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-it-codigo           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE i-numero-ordem        AS INTEGER                      NO-UNDO.
DEFINE VARIABLE c-desc-desp           LIKE desp-imp.descricao         NO-UNDO.
DEFINE VARIABLE l-incide              AS LOGICAL FORMAT "Sim/NÆo"     NO-UNDO.
DEFINE VARIABLE c-nome-abrev-desp     LIKE emitente.nome-abrev        NO-UNDO.
DEFINE VARIABLE c-desc-moeda          LIKE moeda.descricao            NO-UNDO.
DEFINE VARIABLE c-desc-cond-pagto     LIKE cond-pagto.descricao       NO-UNDO.
DEFINE VARIABLE c-desc-pto-contr      LIKE pto-contr.descricao        NO-UNDO.
DEFINE VARIABLE c-desc-tipo-despesa   LIKE tipo-rec-desp.descricao    NO-UNDO.
DEFINE VARIABLE i-tipo                LIKE tipo-rec-desp.tipo         NO-UNDO.
DEFINE VARIABLE c-tipo                AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE de-val-desp-moeda     LIKE despes-ped-compra.val-desp NO-UNDO.
DEFINE VARIABLE l-somente-consulta    AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-imposto             AS LOGICAL                      NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---*/
DEFINE VARIABLE h-boad039     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad259     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx085     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx095     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx110     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx140     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx341     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin295     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin295desc AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-despesas NO-UNDO
    FIELD cod-desp          LIKE desp-imp.cod-desp
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD mo-codigo         LIKE despes-ped-compra.mo-codigo
    FIELD cod-emitente-desp LIKE despes-ped-compra.cod-emitente-desp
    FIELD cod-cond-pag      LIKE despes-ped-compra.cod-cond-pag
    FIELD cod-pto-contr     LIKE despes-ped-compra.cod-pto-contr
    FIELD cod-incoterm-rat  LIKE despes-ped-compra.cod-incoterm-rat
    FIELD tp-despesa        LIKE despes-ped-compra.tp-despesa.

DEFINE TEMP-TABLE tt-pedidos NO-UNDO
    FIELD num-pedido        LIKE despes-ped-compra.num-pedido.

DEFINE TEMP-TABLE tt-ordem-desp NO-UNDO
    FIELD cod-desp          LIKE cotacao-item-cex.cod-desp         
    FIELD sequencia         LIKE despes-ped-compra.sequencia
    FIELD mo-codigo         LIKE cotacao-item-cex.mo-codigo        
    FIELD cod-emitente-desp LIKE cotacao-item-cex.cod-emitente-desp
    FIELD cod-cond-pag      LIKE cotacao-item-cex.cod-cond-pag     
    FIELD cod-pto-contr     LIKE cotacao-item-cex.cod-pto-contr    
    FIELD tp-despesa        LIKE cotacao-item-cex.tp-despesa 
    FIELD val-desp          LIKE despes-ped-compra.val-desp.

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
&Scoped-define INTERNAL-TABLES tt-despes-ped-compra

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-despes-ped-compra.sequencia ~
tt-despes-ped-compra.cod-desp fnDescDesp() @ c-desc-desp ~
fnMoedaParam() @ de-val-desp-moeda fnIncide() @ l-incide ~
tt-despes-ped-compra.val-desp tt-despes-ped-compra.mo-codigo ~
fnMoeda(tt-despes-ped-compra.mo-codigo) @ c-desc-moeda ~
tt-despes-ped-compra.cod-emitente-desp fnNomeAbrev() @ c-nome-abrev-desp ~
tt-despes-ped-compra.cod-cond-pag fnCondPagto() @ c-desc-cond-pagto ~
tt-despes-ped-compra.cod-pto-contr fnPtoContr() @ c-desc-pto-contr ~
tt-despes-ped-compra.tp-despesa fnTpDesp() @ c-desc-tipo-despesa ~
fnTpDesp2() @ c-tipo tt-despes-ped-compra.cod-incoterm-rat 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-despes-ped-compra NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-despes-ped-compra NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-despes-ped-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-despes-ped-compra


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch bt-param bt-importacao1 btQueryJoins btReportsJoins ~
btExit btHelp c-nome-abrev c-nr-proc-imp 
&Scoped-Define DISPLAYED-FIELDS tt-pedido-compr.num-pedido ~
tt-pedido-compr.data-pedido tt-pedido-compr.cod-emitente 
&Scoped-define DISPLAYED-TABLES tt-pedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE tt-pedido-compr
&Scoped-Define DISPLAYED-OBJECTS cb-situacao c-nome-abrev cb-natureza ~
c-nr-proc-imp c-incoterm i-cod-itiner c-desc-itiner 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCondPagto wMasterDetail 
FUNCTION fnCondPagto RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIncide wMasterDetail 
FUNCTION fnIncide RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
(p-cod-moeda AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoedaParam wMasterDetail 
FUNCTION fnMoedaParam RETURNS DECIMAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtoContr wMasterDetail 
FUNCTION fnPtoContr RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTpDesp wMasterDetail 
FUNCTION fnTpDesp RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTpDesp2 wMasterDetail 
FUNCTION fnTpDesp2 RETURNS CHARACTER FORWARD.

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
       MENU-ITEM miParam        LABEL "&Parƒmetros"   
       MENU-ITEM miImport       LABEL "Processo de I&mporta‡Æo"
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
DEFINE BUTTON bt-importacao1 
     IMAGE-UP FILE "image/im-bloq3.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Processo de Importa‡Æo".

DEFINE BUTTON bt-param 
     IMAGE-UP FILE "image/im-param.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Parƒmetros".

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

DEFINE VARIABLE cb-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE cb-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-itiner LIKE itinerario.descricao
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm AS CHARACTER FORMAT "X(03)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev LIKE emitente.nome-abrev
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp LIKE processo-imp.nr-proc-imp
     LABEL "Processo Imp":R23 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner LIKE processo-imp.cod-itiner
     LABEL "Itiner rio":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.58.

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

DEFINE VARIABLE c-desc-moeda-param LIKE moeda.descricao
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-total LIKE despes-ped-compra.val-desp
     LABEL "Valor Total":R16 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda LIKE moeda.mo-codigo
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-despes-ped-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-despes-ped-compra.sequencia FORMAT ">>9":U WIDTH 3.43
      tt-despes-ped-compra.cod-desp FORMAT ">>,>>9":U WIDTH 7.43
      fnDescDesp() @ c-desc-desp COLUMN-LABEL "Descri‡Æo" WIDTH 24.43
      fnMoedaParam() @ de-val-desp-moeda COLUMN-LABEL "Valor Moeda Param"
            WIDTH 17.43
      fnIncide() @ l-incide COLUMN-LABEL "Incide Valor" WIDTH 12.43
      tt-despes-ped-compra.val-desp COLUMN-LABEL "Valor Desp" FORMAT ">>>>>,>>>,>>9.99999":U
            WIDTH 13.43
      tt-despes-ped-compra.mo-codigo COLUMN-LABEL "Moeda Desp" FORMAT ">9":U
            WIDTH 10.43
      fnMoeda(tt-despes-ped-compra.mo-codigo) @ c-desc-moeda COLUMN-LABEL "Descri‡Æo"
            WIDTH 9.43
      tt-despes-ped-compra.cod-emitente-desp FORMAT ">>>>>>>>9":U
            WIDTH 8.86
      fnNomeAbrev() @ c-nome-abrev-desp COLUMN-LABEL "Nome Abrev"
            WIDTH 12.29
      tt-despes-ped-compra.cod-cond-pag FORMAT ">>>9":U WIDTH 10.43
      fnCondPagto() @ c-desc-cond-pagto COLUMN-LABEL "Descri‡Æo"
            WIDTH 30.29
      tt-despes-ped-compra.cod-pto-contr FORMAT ">>,>>9":U WIDTH 10
      fnPtoContr() @ c-desc-pto-contr COLUMN-LABEL "Descri‡Æo"
            WIDTH 30.29
      tt-despes-ped-compra.tp-despesa COLUMN-LABEL "Tipo Despesa" FORMAT ">>9":U
            WIDTH 12.57
      fnTpDesp() @ c-desc-tipo-despesa COLUMN-LABEL "Descri‡Æo"
            WIDTH 30.29
      fnTpDesp2() @ c-tipo COLUMN-LABEL "Tipo"
      tt-despes-ped-compra.cod-incoterm-rat FORMAT "x(3)":U WIDTH 15.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 5.58
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
     bt-param AT ROW 1.13 COL 65.57
     bt-importacao1 AT ROW 1.13 COL 70
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-pedido-compr.num-pedido AT ROW 3 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-pedido-compr.data-pedido AT ROW 3 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-situacao AT ROW 3 COL 67 COLON-ALIGNED
     tt-pedido-compr.cod-emitente AT ROW 4 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-abrev AT ROW 4 COL 28 COLON-ALIGNED HELP
          "" NO-LABEL
     cb-natureza AT ROW 4 COL 67 COLON-ALIGNED
     c-nr-proc-imp AT ROW 5 COL 18 COLON-ALIGNED HELP
          ""
          LABEL "Processo Imp":R23
     c-incoterm AT ROW 5 COL 36 COLON-ALIGNED
     i-cod-itiner AT ROW 5 COL 44 HELP
          ""
          LABEL "Itiner rio":R10
     c-desc-itiner AT ROW 5 COL 57 COLON-ALIGNED HELP
          "" NO-LABEL
     rtParent AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 14.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 6.75 COL 2
     btUpdateSon1 AT ROW 6.75 COL 12
     btDeleteSon1 AT ROW 6.75 COL 22
     de-valor-total AT ROW 6.92 COL 45 COLON-ALIGNED HELP
          ""
          LABEL "Valor Total":R16
     i-moeda AT ROW 6.92 COL 65 COLON-ALIGNED HELP
          ""
     c-desc-moeda-param AT ROW 6.92 COL 69 COLON-ALIGNED HELP
          "" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 84.43 BY 7
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-despes-ped-compra T "?" NO-UNDO mgcex despes-ped-compra
      ADDITIONAL-FIELDS:
          Field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pedido-compr T "?" NO-UNDO movind pedido-compr
      ADDITIONAL-FIELDS:
          Field r-rowid as rowid
          Field RowNum as int
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
         WIDTH              = 90.14
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FILL-IN c-desc-itiner IN FRAME fPage0
   NO-ENABLE LIKE = mgcex.itinerario.descricao EXP-LABEL EXP-SIZE       */
/* SETTINGS FOR FILL-IN c-incoterm IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage0
   LIKE = mgadm.emitente.nome-abrev EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-nr-proc-imp IN FRAME fPage0
   LIKE = mgcex.processo-imp.nr-proc-imp EXP-LABEL EXP-SIZE             */
/* SETTINGS FOR COMBO-BOX cb-natureza IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-situacao IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-pedido-compr.cod-emitente IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-pedido-compr.data-pedido IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-itiner IN FRAME fPage0
   NO-ENABLE ALIGN-L LIKE = mgcex.processo-imp.cod-itiner EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN tt-pedido-compr.num-pedido IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FILL-IN c-desc-moeda-param IN FRAME fPage1
   NO-ENABLE LIKE = mguni.moeda.descricao EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN de-valor-total IN FRAME fPage1
   NO-ENABLE LIKE = mgcex.despes-ped-compra.val-desp EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN i-moeda IN FRAME fPage1
   NO-ENABLE LIKE = mguni.moeda.mo-codigo EXP-SIZE                      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-despes-ped-compra"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-despes-ped-compra.sequencia
"tt-despes-ped-compra.sequencia" ? ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-despes-ped-compra.cod-desp
"tt-despes-ped-compra.cod-desp" ? ? "integer" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"fnDescDesp() @ c-desc-desp" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"fnMoedaParam() @ de-val-desp-moeda" "Valor Moeda Param" ? ? ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" ""
     _FldNameList[5]   > "_<CALC>"
"fnIncide() @ l-incide" "Incide Valor" ? ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tt-despes-ped-compra.val-desp
"tt-despes-ped-compra.val-desp" "Valor Desp" ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.tt-despes-ped-compra.mo-codigo
"tt-despes-ped-compra.mo-codigo" "Moeda Desp" ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"fnMoeda(tt-despes-ped-compra.mo-codigo) @ c-desc-moeda" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[9]   > Temp-Tables.tt-despes-ped-compra.cod-emitente-desp
"tt-despes-ped-compra.cod-emitente-desp" ? ? "integer" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" ""
     _FldNameList[10]   > "_<CALC>"
"fnNomeAbrev() @ c-nome-abrev-desp" "Nome Abrev" ? ? ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" ""
     _FldNameList[11]   > Temp-Tables.tt-despes-ped-compra.cod-cond-pag
"tt-despes-ped-compra.cod-cond-pag" ? ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[12]   > "_<CALC>"
"fnCondPagto() @ c-desc-cond-pagto" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30.29" yes no no "U" "" ""
     _FldNameList[13]   > Temp-Tables.tt-despes-ped-compra.cod-pto-contr
"tt-despes-ped-compra.cod-pto-contr" ? ? "integer" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[14]   > "_<CALC>"
"fnPtoContr() @ c-desc-pto-contr" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30.29" yes no no "U" "" ""
     _FldNameList[15]   > Temp-Tables.tt-despes-ped-compra.tp-despesa
"tt-despes-ped-compra.tp-despesa" "Tipo Despesa" ? "integer" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" ""
     _FldNameList[16]   > "_<CALC>"
"fnTpDesp() @ c-desc-tipo-despesa" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30.29" yes no no "U" "" ""
     _FldNameList[17]   > "_<CALC>"
"fnTpDesp2() @ c-tipo" "Tipo" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[18]   > Temp-Tables.tt-despes-ped-compra.cod-incoterm-rat
"tt-despes-ped-compra.cod-incoterm-rat" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" ""
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    /*IF fnIncide() THEN
        ASSIGN de-valor-total = de-valor-total + fnMoedaParam().
    DISP de-valor-total WITH FRAME fPage1.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-importacao1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao1 wMasterDetail
ON CHOOSE OF bt-importacao1 IN FRAME fPage0 /* Button 1 */
DO:
    /*
    ** Executa Processo de Importa‡Æo (im0040) parametrizado para a inclusÆo.
    */
    IF AVAIL tt-pedido-compr THEN DO:
        ASSIGN p-cod-emitente = tt-pedido-compr.cod-emitente
               p-num-pedido   = tt-pedido-compr.num-pedido
               l-add-ccp      = YES.
        RUN imp/im0040.w.
        RUN afterDisplayFields.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param wMasterDetail
ON CHOOSE OF bt-param IN FRAME fPage0 /* Button 1 */
DO:
    RUN ccp/cc9022.w.
    
    ASSIGN i-moeda:SCREEN-VALUE IN FRAME fPage1 =  STRING(i-moeda-g)
           c-desc-moeda-param:SCREEN-VALUE IN FRAME fPage1 = fnMoeda(i-moeda-g).
    RUN openQueriesSon.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    RUN pi-botoes (INPUT "incluir").
    
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    {masterdetail/addson.i &ProgramSon="imp/im0300a.w"
                           &PageNumber="1"}
                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    EMPTY TEMP-TABLE tt-despesas.
    EMPTY TEMP-TABLE tt-pedidos.

    CREATE tt-despesas.
    ASSIGN tt-despesas.cod-desp          = INPUT BROWSE brSon1 tt-despes-ped-compra.cod-desp
           tt-despesas.val-desp          = INPUT BROWSE brSon1 tt-despes-ped-compra.val-desp
           tt-despesas.mo-codigo         = INPUT BROWSE brSon1 tt-despes-ped-compra.mo-codigo
           tt-despesas.cod-emitente-desp = INPUT BROWSE brSon1 tt-despes-ped-compra.cod-emitente-desp
           tt-despesas.cod-cond-pag      = INPUT BROWSE brSon1 tt-despes-ped-compra.cod-cond-pag
           tt-despesas.cod-pto-contr     = INPUT BROWSE brSon1 tt-despes-ped-compra.cod-pto-contr
           tt-despesas.cod-incoterm-rat  = INPUT BROWSE brSon1 tt-despes-ped-compra.cod-incoterm-rat
           tt-despesas.tp-despesa        = INPUT BROWSE brSon1 tt-despes-ped-compra.tp-despesa.
    
    CREATE tt-pedidos.
    ASSIGN tt-pedidos.num-pedido = INPUT FRAME fPage0 tt-pedido-compr.num-pedido.

    RUN pi-botoes (INPUT "eliminar").  
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    APPLY "ENTRY" TO brSon1.
    
    {masterdetail/deleteson.i &PageNumber="1"}
    IF  RETURN-VALUE = 'OK' THEN DO:
        RUN showErrorsDBO(INPUT h-bocx341).

        RUN SetAtualizaDespesasOrdem IN h-bocx341(INPUT NO).
        RUN atualizaDespesasOrdem IN h-bocx341 (INPUT 3,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT TABLE tt-despesas,
                                                INPUT TABLE tt-pedidos).
    END.

    RUN atualizaValorTotal.

    

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
    {method/zoomreposition.i &ProgramZoom="inzoom/z14in295.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    RUN pi-botoes (INPUT "alterar").
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    APPLY "ENTRY" TO brSon1.
    {masterdetail/updateson.i &ProgramSon="imp/im0300a.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miImport wMasterDetail
ON CHOOSE OF MENU-ITEM miImport /* Processo de Importa‡Æo */
DO:
  APPLY 'choose' TO bt-importacao1 IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miParam wMasterDetail
ON CHOOSE OF MENU-ITEM miParam /* Parƒmetros */
DO:
  APPLY 'choose' TO bt-param IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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
    IF VALID-HANDLE(h-boin295) THEN DO:
        DELETE PROCEDURE h-boin295.
        ASSIGN h-boin295 = ?.
    END.
       
    IF VALID-HANDLE(h-bocx341) THEN DO:
        DELETE PROCEDURE h-bocx341.
        ASSIGN h-bocx341 = ?.
    END.

    IF  VALID-HANDLE(h-boin295desc) THEN DO:
        DELETE PROCEDURE h-boin295desc.
        ASSIGN h-boin295desc = ?.
    END.

    IF  VALID-HANDLE(h-bocx140) THEN DO:
        DELETE PROCEDURE h-bocx140.
        ASSIGN h-bocx140 = ?.
    END.

    IF  VALID-HANDLE(h-bocx115) THEN DO:
        DELETE PROCEDURE h-bocx115.
        ASSIGN h-bocx115 = ?.
    END.

    IF  VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF  VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF  VALID-HANDLE(h-boad039) THEN DO:
        DELETE PROCEDURE h-boad039.
        ASSIGN h-boad039 = ?.
    END.                           

    IF  VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF  VALID-HANDLE(h-boad259) THEN DO:
        DELETE PROCEDURE h-boad259.
        ASSIGN h-boad259 = ?.
    END.

    IF  VALID-HANDLE(h-bocx085) THEN DO:
        DELETE PROCEDURE h-bocx085.
        ASSIGN h-bocx085 = ?.
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
    IF AVAIL tt-pedido-compr THEN
        ASSIGN cb-situacao:SCREEN-VALUE IN FRAME fPage0 = {ininc/i02in295.i 04 tt-pedido-compr.situacao}
               cb-natureza:SCREEN-VALUE IN FRAME fPage0 = {ininc/i01in295.i 04 tt-pedido-compr.natureza}.

    RUN getDescCgcEmitente    IN h-boin295desc (INPUT  tt-pedido-compr.cod-emitente,
                                                OUTPUT c-nome-abrev,
                                                OUTPUT c-cgc).
    RUN findPedido             IN h-bocx140    (INPUT  tt-pedido-compr.num-pedido,
                                                OUTPUT c-retorno).
    IF c-retorno = ""  THEN DO:

        RUN getCharfield      IN h-bocx140     (INPUT  "nr-proc-imp",
                                                OUTPUT c-nr-proc-imp).
        RUN getIntfield       IN h-bocx140     (INPUT  "cod-itiner",
                                                OUTPUT i-cod-itiner).
        IF l-somente-consulta = NO THEN DO:
            ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1    = YES.
            IF NUM-RESULTS("brSon1":U) > 0 THEN DO:
                ASSIGN btUpdateSon1:SENSITIVE IN FRAME fPage1 = YES
                       btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES.
            END.
        END.
        ELSE 
            RUN pi-desabilita-botoes.
        APPLY 'ENTRY' TO BROWSE brSon1.    
        
    END.
    ELSE DO:
        ASSIGN c-nr-proc-imp = ""
               i-cod-itiner  = 0.
        RUN pi-desabilita-botoes.
    END.

    RUN findCodigo            IN h-bocx115     (INPUT  i-cod-itiner,
                                                OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField      IN h-bocx115     (INPUT  "descricao",
                                                OUTPUT c-desc-itiner).
    ELSE
        ASSIGN c-desc-itiner = "".

    RUN getIncoterm           IN h-bocx341 (INPUT  tt-pedido-compr.num-pedido,
                                            OUTPUT c-incoterm).
    
    ASSIGN i-moeda:SCREEN-VALUE IN FRAME fPage1 =  STRING(i-moeda-g)
           c-desc-moeda-param:SCREEN-VALUE IN FRAME fPage1 = fnMoeda(i-moeda-g).
        
    DISP c-nome-abrev 
         c-nr-proc-imp 
         c-incoterm
         i-cod-itiner 
         c-desc-itiner 
         WITH FRAME fPage0.
    DISP de-valor-total
         WITH FRAME fPage1.

    
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
    ASSIGN bt-importacao1:SENSITIVE IN FRAME fPage0 = YES
           bt-param:SENSITIVE IN FRAME fPage0 = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValorTotal wMasterDetail 
PROCEDURE atualizaValorTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN de-valor-total = 0.

    FOR EACH tt-despes-ped-compra:
        IF  fnIncide() THEN
            ASSIGN de-valor-total = de-valor-total + fnMoedaParam().
    END.

    DISP de-valor-total WITH FRAME fPage1.

    RETURN "OK".
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
    ASSIGN de-valor-total = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
 DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
 ASSIGN cAuxTraducao001 = {ininc/i02in295.i 03}.
 RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
 ASSIGN cb-situacao:LIST-ITEM-PAIRS IN FRAME fPage0 = cAuxTraducao001.
&else
 ASSIGN cb-situacao:LIST-ITEMS IN FRAME fPage0 = {ininc/i02in295.i 03}.
&endif
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {ininc/i01in295.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
        ASSIGN cb-natureza:LIST-ITEM-PAIRS IN FRAME fPage0 = cAuxTraducao002.
    &else
        ASSIGN cb-natureza:LIST-ITEMS IN FRAME fPage0 = {ininc/i01in295.i 03}.
    &endif

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
    
    DEFINE VARIABLE i-num-pedido LIKE {&ttParent}.num-pedido NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-num-pedido AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Pedido"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-pedido.
        
        RUN emptyRowErrors  IN h-bocx341.

        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-num-pedido).
        
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Pedido" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.

        RUN validatePedidoCompr IN h-bocx341 (INPUT i-num-pedido).
        
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getRowErrors IN h-bocx341 (OUTPUT TABLE RowErrors).
            FIND FIRST RowErrors NO-ERROR.
            IF AVAIL RowErrors THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT RowErrors.errorNumber, INPUT RowErrors.ErrorParameters).
                RETURN NO-APPLY.
            END.    
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-pedido  btGoToOK btGoToCancel 
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
    IF NOT VALID-HANDLE(h-boin295) THEN
        RUN inbo/boin295q01.p PERSISTENT SET h-boin295. /*BO pedido-compr*/
        
    RUN setConstraintPedEmitNome IN h-boin295 (INPUT 0,
                                               INPUT 99999999,
                                               INPUT 0,
                                               INPUT 99999999,
                                               INPUT "",
                                               INPUT "ZZZZZZZZZZZZ").

    RUN openQueryStatic IN h-boin295 (INPUT "PedEmitNomeByPedido":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx341) THEN 
        RUN cxbo/bocx341.p PERSISTENT SET h-bocx341. /*BO despes-ped-compra*/

    IF  NOT VALID-HANDLE(h-boin295desc) THEN
        RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc. /*BO pedido-compr*/

    RUN openQueryStatic IN h-boin295desc (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-bocx140) THEN
        RUN cxbo/bocx140.p PERSISTENT SET h-bocx140. /*BO processo-imp*/

    IF  NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115. /*BO itinerario*/

    IF  NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095. /*BO desp-imp*/

    IF  NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005. /*BO moeda*/
    
    IF  NOT VALID-HANDLE(h-boad039) THEN
        RUN adbo/boad039.p PERSISTENT SET h-boad039. /*BO cond-pagto*/

    IF  NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110. /*BO pto-contr*/

    IF  NOT VALID-HANDLE(h-boad259) THEN
        RUN adbo/boad259.p PERSISTENT SET h-boad259. /*BO tipo-rec-desp*/

    IF  NOT VALID-HANDLE(h-bocx085) THEN
        RUN cxbo/bocx085.p PERSISTENT SET h-bocx085. /*BO cotacao-item-cex*/
    
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
    IF AVAIL tt-pedido-compr THEN DO:
        ASSIGN rRepositionSon = ?.
        ASSIGN de-valor-total = 0.
        
        {masterdetail/openqueriesson.i &Parent="pedido-compr"
                                       &Query="Pedido"
                                       &PageNumber="1"}
                                       
        
        
        RUN atualizaValorTotal.
    END.

    IF c-nr-proc-imp = "" THEN
        RUN pi-desabilita-botoes.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-botoes wMasterDetail 
PROCEDURE pi-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-tipo AS CHARACTER NO-UNDO.

    ASSIGN l-imposto = NO.

    IF c-tipo = "alterar":U 
    OR c-tipo = "eliminar":U THEN DO:
        RUN emptyRowErrors  IN h-bocx341.

        IF AVAIL tt-despes-ped-compra THEN  DO:
                /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
            RUN goToKey IN h-bocx341 (INPUT tt-despes-ped-compra.num-pedido,
                                      INPUT tt-despes-ped-compra.sequencia,
                                      INPUT tt-despes-ped-compra.cod-desp).
            
            RUN validateDespesaUsuario IN h-bocx341. 
            IF RETURN-VALUE = "NOK" THEN DO:
                RUN getRowErrors IN h-bocx341 (OUTPUT TABLE RowErrors).
                FIND FIRST RowErrors NO-ERROR.
                IF AVAIL RowErrors THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT RowErrors.errorNumber, INPUT RowErrors.ErrorParameters).
                    RETURN "NOK":U.
                END.    
            END.
            RUN retornaDespesaImposto IN h-bocx341 (INPUT  tt-despes-ped-compra.num-pedido,                                                   
                                                    INPUT  tt-despes-ped-compra.cod-desp,
                                                    INPUT "",                                                                                 
                                                    INPUT "",                                                                                 
                                                    INPUT 1,                                                                                  
                                                    OUTPUT l-imposto).                                                                        
                                                                                                                                              
            IF l-imposto THEN DO:                                                                                                                
                IF c-tipo = "alterar" THEN                                                                                                
                    RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 32052, INPUT "").                                                                
                ELSE 
                    /* Inicio -- Projeto Internacional */
                    DO:
                        /* Inicio -- Projeto Internacional*/
                        DEFINE VARIABLE c-lbl-caso-as-despesas-que-estiverem AS CHARACTER   NO-UNDO.
                        {utp/ut-liter.i "Caso_as_despesas_que_estiverem_sendo_alteradas_/_eliminadas_/_criadas_para_este_(s)_pedidos(s)_influenciarem_em_outras_despesas_e_impostos_j _calculado_,_os_seus_valores_serÆo_automaticamente_recalculado" *}
                        ASSIGN c-lbl-caso-as-despesas-que-estiverem = TRIM(RETURN-VALUE).
                        RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 30229, INPUT c-lbl-caso-as-despesas-que-estiverem + ".").
                    END.                                                        
            END.        
        END.
    END.

    IF NOT l-imposto THEN
        /* Inicio -- Projeto Internacional */
        DO:
            /* Inicio -- Projeto Internacional*/
            DEFINE VARIABLE c-lbl-caso-as-despesas-que-estiverem-2 AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i "Caso_as_despesas_que_estiverem_sendo_alteradas_/_eliminadas_/_criadas_para_este_(s)_pedidos(s)_influenciarem_em_outras_despesas_e_impostos_j _calculado_,_os_seus_valores_serÆo_automaticamente_recalculado" *}
            ASSIGN c-lbl-caso-as-despesas-que-estiverem = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 30229, INPUT c-lbl-caso-as-despesas-que-estiverem-2 + ".").
        END.                                                        

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-botoes wMasterDetail 
PROCEDURE pi-desabilita-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1    = NO
           btUpdateSon1:SENSITIVE IN FRAME fPage1 = NO
           btDeleteSon1:SENSITIVE IN FRAME fPage1 = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-somente-consulta wMasterDetail 
PROCEDURE pi-seta-somente-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: procedure que identifica o programa como apenas de consulta.
------------------------------------------------------------------------------*/

    ASSIGN l-somente-consulta = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showErrorsDBO wMasterDetail 
PROCEDURE showErrorsDBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-handle as handle no-undo.

    run getRowErrors in p-handle ( output table RowErrors ).

    session:set-wait-state("":U).

    FOR EACH rowErrors WHERE rowErrors.errorType = "INTERNAL":U:
        DELETE rowErrors.
    END.

    if  can-find(first RowErrors) then  do:

        {method/showmessage.i1}

        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).

        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}

        wait-for close of hShowMsg.

    end.

    return (if can-find(first rowErrors 
                        where RowErrors.errorSubType = "ERROR":U) then "NOK":U
            else "OK":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCondPagto wMasterDetail 
FUNCTION fnCondPagto RETURNS CHARACTER:
    
    RUN findCodigo IN h-boad039 (INPUT  tt-despes-ped-compra.cod-cond-pag,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boad039 (INPUT  "descricao",
                                       OUTPUT c-desc-cond-pagto).
    ELSE 
        ASSIGN c-desc-cond-pagto = "".

    RETURN c-desc-cond-pagto.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER:
    
    RUN retornaDescDespesa IN h-bocx095 (INPUT  tt-despes-ped-compra.cod-desp,
                                         OUTPUT c-desc-desp).
    
    RETURN c-desc-desp.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIncide wMasterDetail 
FUNCTION fnIncide RETURNS LOGICAL:
    DEFINE VARIABLE l-inc-val-embal       AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE l-inc-val-seguro      AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE l-inc-val-frete       AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE l-inc-val-outras-desp AS LOGICAL                      NO-UNDO.

    RUN findCodigo  IN h-bocx095 (INPUT  tt-despes-ped-compra.cod-desp,
                                  OUTPUT c-retorno).
    IF c-retorno = "" THEN DO:
        RUN getLogField IN h-bocx095 (INPUT "inc-val-embal",
                                      OUTPUT l-inc-val-embal).
        RUN getLogField IN h-bocx095 (INPUT "inc-val-seguro",
                                      OUTPUT l-inc-val-seguro).
        RUN getLogField IN h-bocx095 (INPUT "inc-val-frete",
                                      OUTPUT l-inc-val-frete).
        RUN getLogField IN h-bocx095 (INPUT "inc-val-outras-desp",
                                      OUTPUT l-inc-val-outras-desp).

        IF l-inc-val-embal
        OR l-inc-val-seguro      
        OR l-inc-val-frete       
        OR l-inc-val-outras-desp THEN
            RETURN YES.
        ELSE
            RETURN NO.
    END.
    ELSE
        RETURN NO.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
(p-cod-moeda AS INTEGER):
    
    RUN findCodigo IN h-boun005 (INPUT  p-cod-moeda,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boun005(INPUT  "descricao",
                                      OUTPUT c-desc-moeda).
    ELSE
        ASSIGN c-desc-moeda = "".
    
    RETURN c-desc-moeda.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoedaParam wMasterDetail 
FUNCTION fnMoedaParam RETURNS DECIMAL:

    IF l-conv-g THEN DO:
        ASSIGN de-val-desp-moeda = 0.

        RUN retornaValorMoedaParamDespesa IN h-bocx341 (INPUT  tt-pedido-compr.num-pedido,
                                                        INPUT  tt-despes-ped-compra.cod-desp,
                                                        INPUT  tt-despes-ped-compra.sequencia,
                                                        INPUT  i-moeda-g,
                                                        OUTPUT TABLE tt-ordem-desp).
        
        FOR EACH tt-ordem-desp
            WHERE tt-ordem-desp.cod-desp          = tt-despes-ped-compra.cod-desp
            AND   tt-ordem-desp.sequencia         = tt-despes-ped-compra.sequencia
            AND   tt-ordem-desp.mo-codigo         = tt-despes-ped-compra.mo-codigo
            AND   tt-ordem-desp.cod-emitente-desp = tt-despes-ped-compra.cod-emitente-desp
            AND   tt-ordem-desp.cod-cond-pag      = tt-despes-ped-compra.cod-cond-pag
            AND   tt-ordem-desp.cod-pto-contr     = tt-despes-ped-compra.cod-pto-contr
            AND   tt-ordem-desp.tp-despesa        = tt-despes-ped-compra.tp-despesa :
            ASSIGN de-val-desp-moeda= de-val-desp-moeda + tt-ordem-desp.val-desp.
        END.
    END.
    ELSE DO:
        RUN "cdp/cd0812.p" (INPUT  tt-despes-ped-compra.mo-codigo,
                            INPUT  i-moeda-g,
                            INPUT  tt-despes-ped-compra.val-desp,
                            INPUT  da-conv-g,
                            OUTPUT de-val-desp-moeda).

        IF de-val-desp-moeda = ? THEN
            RETURN 0.0.
    END.
    RETURN de-val-desp-moeda.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER:
    
    RUN getDescCgcEmitente  IN h-boin295desc (INPUT  tt-despes-ped-compra.cod-emitente-desp,
                                              OUTPUT c-nome-abrev-desp,
                                              OUTPUT c-cgc).
    RETURN c-nome-abrev-desp.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtoContr wMasterDetail 
FUNCTION fnPtoContr RETURNS CHARACTER:
    
    RUN retornaDescricao IN h-bocx110 (INPUT  tt-despes-ped-compra.cod-pto-contr,
                                       OUTPUT c-desc-pto-contr).
    RETURN c-desc-pto-contr.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTpDesp wMasterDetail 
FUNCTION fnTpDesp RETURNS CHARACTER:
    
    RUN findCodigo IN h-boad259 (INPUT  tt-despes-ped-compra.tp-despesa,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boad259 (INPUT  "descricao",
                                       OUTPUT c-desc-tipo-despesa).
    ELSE
        ASSIGN c-desc-tipo-despesa = "".
    
    RETURN c-desc-tipo-despesa.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTpDesp2 wMasterDetail 
FUNCTION fnTpDesp2 RETURNS CHARACTER:
    
    RUN findCodigo IN h-boad259 (INPUT  tt-despes-ped-compra.tp-despesa,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN DO:
        RUN getIntField IN h-boad259 (INPUT  "tipo",
                                      OUTPUT i-tipo).

        RETURN {adinc/i01ad259.i 04 i-tipo}.
    END.
    ELSE
        RETURN "".
    
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

