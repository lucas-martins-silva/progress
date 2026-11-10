&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL,  sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0100A 2.00.00.052 } /*** "010052" 20/01/2026 15:36:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100a MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&GLOBAL-DEFINE DBOVersion 1.1

{cxbo/bocx220c.i tt-item-doc-est}
{cxbo/bocx220c.i tt-item-doc-est-aux}
{cxbo/bocx220c.i tt-item-doc-est-cancela}

{include/boerrtab.i}
{cdp/cdcfgmat.i}

/* definiá∆o da tt-recebe */
{imp/im0100.i}

DEFINE BUFFER b-tt-item-doc-est for tt-item-doc-est.    

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---           */
&GLOBAL-DEFINE Program          IM0100A
&GLOBAL-DEFINE Version        2.00.00.052

/*&GLOBAL-DEFINE Folder           YES*/
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)                     

&GLOBAL-DEFINE WindowType     Master
&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btCancel btExit btHelp ~
                              btOK btHelp2

&GLOBAL-DEFINE ttParent         tt-item-doc-est
&GLOBAL-DEFINE hDBOParent       h-bocx220d
&GLOBAL-DEFINE DBOParentTable   item-doc-est
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-item-doc-est
&GLOBAL-DEFINE hDBOSon1         h-bocx220c
&GLOBAL-DEFINE DBOSon1Table     tt-item-doc-est
&GLOBAL-DEFINE DBOSon1Destroy   YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE rowsreturn            AS   integer                            NO-UNDO.
DEFINE VARIABLE i-seq                 AS   integer                            NO-UNDO.
DEFINE VARIABLE i-parc                AS   integer                            NO-UNDO.
DEFINE VARIABLE c-item                like item.it-codigo                     NO-UNDO.
DEFINE VARIABLE l-verifica            AS   logical                            NO-UNDO.
DEFINE VARIABLE d-quant               like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE d-quantidade          like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE i-num-ordem           like ordem-compra.numero-ordem          NO-UNDO.
DEFINE VARIABLE l-alt                 AS   logical                            NO-UNDO initial no.
DEFINE VARIABLE d-calc-quantidade     like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE de-qt-total           like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE de-qt-informada       like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE de-qt-a-informar      like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE de-preco-total        LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE de-preco-total-mo     LIKE item-doc-est.preco-total[1]        NO-UNDO.
define variable d-qtd-do-forn         as decimal format ">>>>,>>>,>>9.9999":U no-undo.
DEFINE VARIABLE de-acumula            like ordens-embarque.quantidade         NO-UNDO.
DEFINE VARIABLE cont                  AS   integer                            NO-UNDO.
DEFINE VARIABLE l-verifica-alteracao  AS   logical                            NO-UNDO.
DEFINE VARIABLE cont-rowid            AS   integer                            NO-UNDO.
DEFINE VARIABLE c-rowid               AS   char                               NO-UNDO.
DEFINE VARIABLE ro-rowid              AS   rowid                              NO-UNDO.
DEFINE VARIABLE ro-prox-rowid         AS   rowid                              NO-UNDO.
DEFINE VARIABLE de-quant-tot          AS   DECIMAL                            NO-UNDO.
DEFINE VARIABLE de-quant-a-informar   AS   DECIMAL                            NO-UNDO.
DEFINE VARIABLE de-peso-liquido-total LIKE item-doc-est.peso-liquido          NO-UNDO.
DEFINE VARIABLE de-quant-total-aux    LIKE prazo-compra.quantidade            NO-UNDO.
DEFINE VARIABLE l-lote-avancado       AS LOGICAL                              NO-UNDO.
DEF TEMP-TABLE tt-item-totais NO-UNDO
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD quantidade   LIKE prazo-compra.quantidade
    INDEX codigo IS UNIQUE
        numero-ordem
        parcela.

DEF TEMP-TABLE ttEmbarque NO-UNDO
    FIELD marcado      AS   LOGICAL
    FIELD selecionado  AS   CHAR FORMAT "X(1)":U
    FIELD embarque     LIKE ordens-embarque.embarque /*AS   CHARACTER FORMAT 'x(12)':U*/
    field numero-ordem LIKE ordens-embarque.numero-ordem
    field parcela      LIKE ordens-embarque.parcela
    field sequencial   AS   INTEGER
    FIELD r-Rowid      AS   ROWID.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE {&hDBOSon1} AS HANDLE NO-UNDO.

DEFINE input-output PARAMETER table FOR tt-item-doc-est.
DEFINE input-output PARAMETER table FOR tt-recebe.
DEFINE input        PARAMETER l-chama-carregado AS logical NO-UNDO.
DEFINE INPUT        PARAMETER l-dep-ext         AS LOGICAL NO-UNDO.
DEFINE output       PARAMETER table FOR tt-bo-erro.

DEFINE VARIABLE pr-rowid   AS rowid  NO-UNDO.
DEFINE VARIABLE ph-handle  AS handle NO-UNDO.
DEFINE VARIABLE h-bocx220a AS handle NO-UNDO.
DEFINE VARIABLE h-bocx225na AS HANDLE NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
{cep/ceapi030.i} /*tt-dados-fda*/
{cdp/cd0666.i}
&ENDIF
DEF VAR h-im0100a1 AS HANDLE NO-UNDO.
DEF VAR cembarque  AS CHARACTER FORMAT 'x(20)':U NO-UNDO.
DEF VAR h-boin274  AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item-doc-est

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-item-doc-est.it-codigo tt-item-doc-est.numero-ordem tt-item-doc-est.parcela fnEmbarque(tt-item-doc-est.numero-ordem, tt-item-doc-est.parcela) @ cembarque tt-item-doc-est.lote tt-item-doc-est.dt-vali-lote tt-item-doc-est.cod-refer tt-item-doc-est.quantidade tt-item-doc-est.un tt-item-doc-est.qtd-do-forn tt-item-doc-est.un-fornec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 /*Chamada UPC - Before-open-browse*/ &IF DEFINED(bf_mat_versao_ems) &THEN     IF c-nom-prog-upc-mg97 <> "" THEN DO:         RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-OPEN-BROWSE", ~
                                               INPUT "tt-item-doc-est", ~
                                               INPUT THIS-PROCEDURE, ~
                                               INPUT FRAME {&FRAME-NAME}:HANDLE, ~
                                               INPUT STRING(BUFFER tt-item-doc-est:HANDLE), ~
                                               INPUT ?) NO-ERROR.     END.     /*Fim chamada upc*/ &ELSE &ENDIF OPEN QUERY {&SELF-NAME} FOR EACH tt-item-doc-est                             WHERE tt-item-doc-est.tipo-con-est <> 1                             AND   tt-item-doc-est.l-selecionado NO-LOCK                                 BY tt-item-doc-est.numero-ordem                                 BY tt-item-doc-est.parcela                                 BY tt-item-doc-est.sequencial.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-item-doc-est
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-item-doc-est


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-quantidade wWindow 
FUNCTION fn-quantidade RETURNS DECIMAL
  (/* parameter*/) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmbarque wWindow 
FUNCTION fnEmbarque RETURNS CHARACTER
  (pnumero-ordem AS INTEGER, pparcela AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
              DISABLED
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
              DISABLED
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
              DISABLED
       MENU-ITEM miAbout        LABEL "&Sobre..."     
              DISABLED.

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100.43 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-cancela 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/ii-can":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-elimina 
     LABEL "Elimina" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-inclui 
     LABEL "Inclui" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "X(03)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-lote-fabricante AS CHARACTER FORMAT "X(10)":U 
     LABEL "Lote Fabr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fabr AS CHARACTER FORMAT "X(60)":U 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(3)":U 
     LABEL "UN" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-fornec AS CHARACTER FORMAT "X(3)":U 
     LABEL "UN Fornec" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-do-forn AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Fornec" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-rest AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo Restante" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-inf AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total Informado" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-fabr-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Fabr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-val-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vali Lote" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE dt-valid-lote-fabric AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Fabr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote/SÇrie" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 27.57 BY .88 NO-UNDO.

DEFINE VARIABLE quant AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE refer AS CHARACTER FORMAT "X(20)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.43 BY 7.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.57 BY 2.21.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-item-doc-est SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wWindow _FREEFORM
  QUERY BROWSE-1 DISPLAY
      tt-item-doc-est.it-codigo              width 17 format "x(16)":U
      tt-item-doc-est.numero-ordem           width 10 format "zzzzz9,99":U
      tt-item-doc-est.parcela                width 06 format ">>>>9":U
      fnEmbarque(tt-item-doc-est.numero-ordem, tt-item-doc-est.parcela) @ cembarque COLUMN-LABEL 'Embarque':U FORMAT 'x(20)':U
      tt-item-doc-est.lote                   width 11 format "x(40)":U
      tt-item-doc-est.dt-vali-lote           width 10 format "99/99/9999":U
      tt-item-doc-est.cod-refer              width 09 format "x(8)":U
      tt-item-doc-est.quantidade             width 17 column-label "Nossa Qtde":U
      tt-item-doc-est.un          format "x(3)":U                       column-label "UN":U
      tt-item-doc-est.qtd-do-forn format "->>>,>>>,>>9.9999":U width 17 column-label "Qtde Fornec":U
      tt-item-doc-est.un-fornec   format "x(3)":U                       column-label "UN Fornec":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 56.57 BY 9.58
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-filtro AT ROW 1.13 COL 1.57 HELP
          "Filtra Embarques"
     btQueryJoins AT ROW 1.17 COL 84.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 88.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 92.72 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 96.72 HELP
          "Ajuda"
     btOK AT ROW 14.38 COL 1.86
     btCancel AT ROW 14.38 COL 12.57
     btHelp2 AT ROW 14.38 COL 90.72
     rtToolBar AT ROW 14.13 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.43 BY 14.63
         FONT 1.

DEFINE FRAME fPage1
     BROWSE-1 AT ROW 1.33 COL 2
     c-cod-depos AT ROW 1.67 COL 69.43 COLON-ALIGNED
     c-un AT ROW 5.58 COL 69.43 COLON-ALIGNED
     c-un-fornec AT ROW 7.58 COL 69.43 COLON-ALIGNED
     de-qtd-do-forn AT ROW 6.58 COL 69.43 COLON-ALIGNED
     btUpdateSon1 AT ROW 11 COL 12
     bt-elimina AT ROW 11 COL 22.14
     lote AT ROW 1.58 COL 69.43 COLON-ALIGNED
     dt-val-lote AT ROW 2.58 COL 69.43 COLON-ALIGNED
     c-lote-fabricante AT ROW 3.58 COL 69.43 COLON-ALIGNED HELP
          "Lote Fabr"
     dt-valid-lote-fabric AT ROW 4.58 COL 69.43 COLON-ALIGNED HELP
          "Validade Fabr"
     dt-fabr-lote AT ROW 5.58 COL 69.43 COLON-ALIGNED
     c-nome-fabr AT ROW 6.58 COL 69.43 COLON-ALIGNED
     refer AT ROW 3.58 COL 69.43 COLON-ALIGNED
     quant AT ROW 4.58 COL 69.43 COLON-ALIGNED
     bt-cancela AT ROW 7.46 COL 91 HELP
          "Cancela alteraá‰es"
     bt-sav AT ROW 7.46 COL 95 HELP
          "Confirma alteraá‰es"
     de-tot-inf AT ROW 8.92 COL 69.57 COLON-ALIGNED
     de-saldo-rest AT ROW 9.92 COL 69.57 COLON-ALIGNED
     bt-inclui AT ROW 11 COL 2
     RECT-1 AT ROW 1.33 COL 59.29
     RECT-2 AT ROW 8.79 COL 59.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 2.75
         SIZE 100.14 BY 11.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.75
         WIDTH              = 100.72
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-filtro IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB BROWSE-1 1 fPage1 */
/* SETTINGS FOR BUTTON bt-cancela IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-sav IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-depos:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN c-un IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-fornec IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-do-forn IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-rest IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tot-inf IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
/*Chamada UPC - Before-open-browse*/
&IF DEFINED(bf_mat_versao_ems) &THEN
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-OPEN-BROWSE",
                                        INPUT "tt-item-doc-est",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT STRING(BUFFER tt-item-doc-est:HANDLE),
                                        INPUT ?) NO-ERROR.
    END.
    /*Fim chamada upc*/
&ELSE
&ENDIF
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-doc-est
                            WHERE tt-item-doc-est.tipo-con-est <> 1
                            AND   tt-item-doc-est.l-selecionado NO-LOCK
                                BY tt-item-doc-est.numero-ordem
                                BY tt-item-doc-est.parcela
                                BY tt-item-doc-est.sequencial.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON ENTRY OF BROWSE-1 IN FRAME fPage1
DO:
    apply "value-changed" to browse-1 in frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON MOUSE-SELECT-CLICK OF BROWSE-1 IN FRAME fPage1
DO:

  apply "value-changed" to browse-1 in frame fpage1. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME fPage1
DO:
       apply "choose" to btUpdateSon1 in frame fpage1.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON VALUE-CHANGED OF BROWSE-1 IN FRAME fPage1
DO:
    def var c-lote as char no-undo.

    if avail tt-item-doc-est then do:  
        if browse-1:num-selected-rows in frame fPage1 = 0 then do:
            /* Para a execuá∆o do processo dever  ser selecionado um registro. */
            run utp/ut-msgs.p (input "show":U,
                               input 16595,
                               input "":U).
        end.
        if browse-1:num-selected-rows in frame fPage1 <> 0 then do:
             browse browse-1:fetch-selected-row(int(browse-1:num-selected-rows)).
             assign i-seq       = tt-item-doc-est.sequencial
                    c-item      = tt-item-doc-est.it-codigo
                    i-num-ordem = tt-item-doc-est.numero-ordem
                    i-parc      = tt-item-doc-est.parcela
                    ro-rowid    = rowid(tt-item-doc-est).
        end.
    end.  

    find b-tt-item-doc-est
        where rowid(b-tt-item-doc-est) = ro-rowid no-lock no-error.
    if avail b-tt-item-doc-est then
        find next b-tt-item-doc-est no-lock no-error.
    if rowid(b-tt-item-doc-est) <> ? then                                          
        assign ro-prox-rowid = rowid(b-tt-item-doc-est).
    else 
        assign ro-prox-rowid = ro-rowid.

    /* Atualiza as variaveis com os valores da quantidade a informar e quantidade informada.
       Verifica se o total das quantidades informadas Ç menor que a das ordens de embarque,
       se for habilita o bot∆o inclui. */

    find tt-recebe 
        where tt-recebe.numero-ordem = i-num-ordem 
          and tt-recebe.parcela      = i-parc no-error.
    if  avail tt-recebe then do:

        assign d-calc-quantidade = tt-recebe.quantidade-informada
               d-quant           = tt-recebe.quantidade-a-informar.

        if tt-recebe.quantidade-a-informar = 0 then DO:

            assign tt-recebe.verifica-quantidade = no.
        END.

        if tt-recebe.verifica-quantidade   = yes then 
            enable bt-inclui with frame fpage1.
        else disable bt-inclui with frame fpage1.           
    end.

    /* Atualiza na tela com o lote, data de validate e referencia se j† foram informados, e o total informado
     e o saldo restante */

    find tt-item-doc-est 
        where tt-item-doc-est.numero-ordem = i-num-ordem 
          and tt-item-doc-est.parcela      = i-parc 
          and tt-item-doc-est.sequencial   = i-seq no-error.

    if avail tt-item-doc-est then do:
        assign lote:screen-value in frame fpage1 = tt-item-doc-est.lote
               dt-val-lote:screen-value in frame fpage1 = string(tt-item-doc-est.dt-vali-lote)
               refer:screen-value in frame fpage1 = tt-item-doc-est.cod-refer
               quant:screen-value in frame fpage1 = string(tt-item-doc-est.quantidade)
               c-un:screen-value in frame fPage1 = tt-item-doc-est.un
               de-qtd-do-forn:screen-value in frame fPage1 = string(tt-item-doc-est.qtd-do-forn)
               c-un-fornec:screen-value in frame fPage1 = tt-item-doc-est.un-fornec.
            &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            IF l-lote-avancado THEN
               ASSIGN c-lote-fabricante:screen-value in frame fpage1    = tt-item-doc-est.cod-lote-fabrican
                      dt-valid-lote-fabric:screen-value in frame fpage1 = string(tt-item-doc-est.dat-valid-lote-fabrican)
                      c-nome-fabr:screen-value in frame fpage1          = tt-item-doc-est.nom-fabrican
                      dt-fabr-lote:screen-value in frame fpage1         = string(tt-item-doc-est.dat-fabricc-lote).
            &ENDIF
            
        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
            ASSIGN c-cod-depos:SCREEN-VALUE IN FRAME fPage1 = tt-item-doc-est.cod-depos.

        if tt-item-doc-est.tipo-con-est > 2 then do:
            assign de-tot-inf:screen-value    in frame fpage1 = string(d-calc-quantidade)
                   de-saldo-rest:screen-value in frame fpage1 = string(d-quant).
        end.

        if tt-item-doc-est.tipo-con-est = 2 then do:
            if tt-item-doc-est.lote = "" then 
                 assign de-tot-inf:screen-value    in frame fpage1 = "0"
                        de-saldo-rest:screen-value in frame fpage1 = "1".
            else
                 assign de-tot-inf:screen-value    in frame fpage1 = "1"
                        de-saldo-rest:screen-value in frame fpage1 = "0".
        end.
        if tt-item-doc-est.lote <> "" then assign l-verifica-alteracao = yes.
        else assign l-verifica-alteracao = no.
    end.

    /* Verifica se existe mais de uma ocorrància para a mesma ordem, se existir 
      habilita o bot∆o elimina */

    for each tt-item-doc-est 
        where tt-item-doc-est.numero-ordem = i-num-ordem 
          and tt-item-doc-est.parcela      = i-parc 
          and tt-item-doc-est.tipo-con-est <> 2 no-lock:
        assign cont = cont + 1.
    end.
    if cont > 1 then 
        enable  bt-elimina with frame fpage1.
    else
        disable bt-elimina with frame fpage1.

    enable btUpdateSon1 with frame fpage1.
    assign l-alt = yes
            cont = 0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela wWindow
ON CHOOSE OF bt-cancela IN FRAME fPage1 /* Can */
DO:
    for each tt-bo-erro no-lock:
       delete tt-bo-erro.
    end.
    assign l-verifica = no.

    disable lote 
            quant
            dt-val-lote
            refer 
            bt-cancela 
            bt-sav 
        with frame fpage1.

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN c-cod-depos:SENSITIVE IN FRAME fPage1 = NO.

    IF l-lote-avancado THEN
        DISABLE c-lote-fabricante
            dt-valid-lote-fabric
            c-nome-fabr
            dt-fabr-lote WITH FRAME fPage1.

    /*** Verifica se o registro j† foi alterado uma vez, se foi atualiza a quantidade a informar e
     *** a quantidade informada, fazendo o calculo inverso que foi realizado na pi-altera       */
    if tt-item-doc-est.situacao = yes then do:
        find tt-recebe
            where tt-recebe.numero-ordem = i-num-ordem 
              and tt-recebe.parcela      = i-parc no-error.
        if avail tt-recebe then
            assign tt-recebe.quantidade-informada  = tt-recebe.quantidade-informada     
                                                   + dec(quant:screen-value in frame fpage1)
                   tt-recebe.quantidade-a-informar = tt-recebe.quantidade-a-informar 
                                                   - dec(quant:screen-value in frame fpage1).

    end.

    assign lote:screen-value  in frame fpage1          = ""
           quant:screen-value in frame fpage1          = ""
           de-qtd-do-forn:screen-value in frame fPage1 = ""
           dt-val-lote:screen-value in frame fpage1    = ""
           refer:screen-value  in frame fpage1         = "".

    IF l-lote-avancado THEN
       ASSIGN c-lote-fabricante:screen-value  in frame fpage1 = ""
              dt-valid-lote-fabric:screen-value  in frame fpage1 = ""
              c-nome-fabr:screen-value  in frame fpage1  = ""
              dt-fabr-lote:screen-value  in frame fpage1 = "".

    enable bt-Elimina
           browse-1 with frame fpage1.
    assign l-alt = no.

    reposition {&BROWSE-NAME} to rowid ro-rowid.
    apply "entry" to browse-1 in frame fpage1.            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina wWindow
ON CHOOSE OF bt-elimina IN FRAME fPage1 /* Elimina */
DO:
    def var i as integer no-undo.

    assign i = 0.

    /* Verifica se algum registro foi selecionado no browse, se for atualiza
       o numero da ordem e a sequencia em i-num-ordem e i-seq.
       Pergunta ao usu†rio se tem certeza que deseja excluir o registro */

    if browse-1:num-selected-rows in frame fPage1 = 0 then do:
        /* Para a execuá∆o do processo dever  ser selecionado um registro. */
        run utp/ut-msgs.p (input "show":U,
                           input 16595,
                           input "":U).
    end. 

    if browse-1:num-selected-rows in frame fPage1 <> 0 then do:

        browse browse-1:fetch-selected-row(int(browse-1:num-selected-rows)).
        assign i-num-ordem = tt-item-doc-est.numero-ordem
               i-seq = tt-item-doc-est.sequencial.

        run utp/ut-msgs.p (input "show":U,
                           input 550,
                           input Return-value).

        /*Verifica se n∆o Ç o £ltimo registro da ordem*/

        if return-value = "yes":U then do:

            for each tt-item-doc-est no-lock 
                where tt-item-doc-est.numero-ordem = i-num-ordem 
                  and tt-item-doc-est.tipo-con-est > 2:
                assign i = i + 1.
            end.

            if i > 1 then do:   

                find tt-item-doc-est 
                    where tt-item-doc-est.numero-ordem = i-num-ordem 
                      and tt-item-doc-est.parcela      = i-parc 
                      and tt-item-doc-est.sequencial   = i-seq  no-error.
                if avail tt-item-doc-est then do:

                    find tt-recebe
                        where tt-recebe.numero-ordem = i-num-ordem 
                          and tt-recebe.parcela      = i-parc no-error.
                    if avail tt-recebe then do:

                        if tt-item-doc-est.lote <> "":U then DO:
                            assign tt-recebe.quantidade-a-informar = /*tt-recebe.quantidade-total -*/ tt-recebe.quantidade-a-informar + tt-item-doc-est.quantidade
                                   tt-recebe.quantidade-informada = tt-recebe.quantidade-informada - tt-item-doc-est.quantidade
                                   de-qt-total = tt-recebe.quantidade-total.
                        END.

                        assign tt-recebe.verifica-quantidade = yes.
                        delete tt-item-doc-est.
                        run executeDelete in h-bocx220c (input i-num-ordem, input i-seq, input i-parc).
                    end.
                     find b-tt-item-doc-est 
                    where b-tt-item-doc-est.numero-ordem = i-num-ordem 
                      and b-tt-item-doc-est.sequencial   = i-seq no-lock no-error.
                    if avail b-tt-item-doc-est then 
                        delete b-tt-item-doc-est.

                    {&OPEN-QUERY-BROWSE-1}
                    run findfirst in h-bocx220c. 
                end.    
                end.
            else do:
                run utp/ut-msgs.p (input "show":U,
                                   input 19549,
                                   input c-item).
            end.
        end.
    end.  

    /* 
    ** Verifica se o total das quantidades informadas e menor que a quantidade total das ordens de embarque,
    ** se for habilita o bt-inclui. 
    */

    find first tt-item-doc-est
         where tt-item-doc-est.numero-ordem = i-num-ordem 
           and tt-item-doc-est.situacao     = no no-error.
    if not avail tt-item-doc-est then 
        assign l-verifica = yes.
    else 
        assign l-verifica = no.

    if l-verifica = yes then do:
        for each tt-item-doc-est 
            where tt-item-doc-est.numero-ordem = i-num-ordem:
            assign de-acumula = de-acumula + tt-item-doc-est.quantidade.
        end.
        if de-acumula < de-qt-total then 
            enable bt-inclui with frame fpage1.
        else  
            disable bt-inclui with frame fpage1.
    end.

    reposition {&BROWSE-NAME} to rowid ro-prox-rowid no-error.        
    apply "entry" to browse-1 in frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wWindow
ON CHOOSE OF bt-filtro IN FRAME fpage0 /* Filtro */
DO:
    RUN pi-filtroEmbarques.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui wWindow
ON CHOOSE OF bt-inclui IN FRAME fPage1 /* Inclui */
DO:
    run pi-inclui.

    {&OPEN-QUERY-BROWSE-1}

    reposition {&BROWSE-NAME} to rowid ro-rowid no-error.  
    apply "entry" to browse-1 in frame fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wWindow
ON CHOOSE OF bt-sav IN FRAME fPage1 /* Sav */
DO:    

    for each tt-bo-erro EXCLUSIVE-LOCK:
        delete tt-bo-erro.
    end.    

    /*********************************************************** 
    ** Inicio - Ponto UPC "BEFORE-BT-SAVE"
    ***********************************************************/
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-BT-SAVE",
                                        INPUT "tt-recebe",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT STRING(TEMP-TABLE tt-recebe:HANDLE),
                                        INPUT ?).
    END.
    /*********************************************************** 
    ** Fim - Ponto UPC "BEFORE-BT-SAVE"
    ***********************************************************/
	
    RUN pi-confirmar (input l-alt, 
                      input-output table tt-item-doc-est).

    /*********************************************************** 
    ** Inicio - Ponto UPC "BT-SAVE"
    ***********************************************************/
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BT-SAVE",
                                        INPUT "tt-recebe",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT STRING(TEMP-TABLE tt-recebe:HANDLE),
                                        INPUT ?).
    END.
    /*********************************************************** 
    ** Fim - Ponto UPC "BT-SAVE"
    ***********************************************************/

    RUN pi-carregaTT. /* caso o usu†rio informe um valor menor que a quantidade disponivel, criar uma nova linha com a diferenáa do valor informado */
    
    if return-value = "OK":U then do:       
        {&OPEN-QUERY-BROWSE-1}
        RUN openQuery in h-bocx220c (input 1).
        run findfirst in h-bocx220c. 
        enable browse-1 with frame fpage1.
        reposition {&BROWSE-NAME} to rowid ro-rowid.
        apply "entry":U to browse-1 in frame fpage1.
        assign l-alt = no.
    end.

    RETURN "OK":U.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    for each tt-item-doc-est:
       delete tt-item-doc-est.
    end.

    /*
    ** Erro criado para se o usu†rio clicar em cancelar  n∆o efetuar o desembarque. 
    */
    find first tt-bo-erro no-error.
    if not avail tt-bo-erro then do:
         run utp/ut-msgs.p (input "msg":U,
                                   input 19522,
                                   input return-value).
         create tt-bo-erro.
         assign tt-bo-erro.i-sequen     = tt-bo-erro.i-sequen + 1
                tt-bo-erro.cd-erro      = 19522
                tt-bo-erro.mensagem     = return-value.
    end.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    for each tt-bo-erro no-lock:
        delete tt-bo-erro.
    end.

    delete procedure h-bocx220c.
    ASSIGN h-bocx220c = ?.

    run cxbo/bocx220c.p persistent set h-bocx220c.

    IF c-nom-prog-upc-mg97 <> "" THEN 
    DO:
        RUN  pi-recebe-tt-item-doc-est IN h-bocx220c (INPUT TABLE tt-item-doc-est). 
        {method/custom.i &Event="BEFORE-CLICK-BTOK"
                         &Object="CONTAINER"
                         &ObjectHandle=h-bocx220c
                         &FrameHandle="FRAME fPage0:HANDLE"
                         &Table="tt-item-doc-est"
                         &RowidTable=ROWID(tt-item-doc-est)}
        RUN  pi-envia-tt-item-doc-est IN h-bocx220c (OUTPUT TABLE tt-item-doc-est).                
    END.

    run validaTableAdicionais in h-bocx220c (input table tt-item-doc-est,
                                             output table tt-bo-erro).

    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.        
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).        

        LEAVE.
    END.
    ELSE DO:
        for each tt-item-doc-est-aux:
             delete tt-item-doc-est-aux.
        end.
        assign l-verifica = yes.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wWindow
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    disable btUpdateSon1
            bt-Elimina 
            browse-1 with frame fpage1.

    assign browse-1:sensitive in frame fpage1 = no.

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN c-cod-depos:SENSITIVE IN FRAME fPage1 = YES.

    RUN pi-altera(i-seq, 
                  i-num-ordem, 
                  c-item, 
                  input table tt-item-doc-est).     
    if l-verifica = yes then 
         assign l-verifica = no.

    {&OPEN-QUERY-BROWSE-1}

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
        apply "entry":U to c-cod-depos in frame fpage1.
    ELSE
        apply "entry":U to lote in frame fpage1.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos wWindow
ON F5 OF c-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
  /* ZOOM SMART OBJECT */
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                     &campo=c-cod-depos
                     &campozoom=cod-depos
                     &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL quant wWindow
ON LEAVE OF quant IN FRAME fPage1 /* Qtde */
DO:

    run atualizaQtdeDoForn in h-bocx220c (input  input quant,
                                          input  i-num-ordem,
                                          input  c-item,
                                          output d-qtd-do-forn).

    assign de-qtd-do-forn:screen-value in frame fPage1 = string(d-qtd-do-forn).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL refer wWindow
ON F5 OF refer IN FRAME fPage1 /* Referància */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                       &campo="refer"
                       &campozoom="cod-refer"
                       &frame="fPage1"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL refer wWindow
ON LEAVE OF refer IN FRAME fPage1 /* Referància */
DO:
   &if '{&bf_lote_avancado_liberado}' = 'yes' &then
          RUN defaultLot.
   &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL refer wWindow
ON MOUSE-SELECT-DBLCLICK OF refer IN FRAME fPage1 /* Referància */
DO:
   apply 'F5' to self in frame {&frame-name}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hShowMsg)   THEN DO:
        DELETE PROCEDURE hShowMsg.
        ASSIGN hShowMsg = ?.
    END.

    IF VALID-HANDLE(h-bocx220c) THEN DO:
        DELETE PROCEDURE h-bocx220c.
        ASSIGN h-bocx220c = ?.
    END.

    IF VALID-HANDLE(h-bocx225na) THEN DO:
        DELETE PROCEDURE h-bocx225na.
        ASSIGN h-bocx225na = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wWindow 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     enable browse-1 
            btUpdateSon1 
            with frame fpage1.

     ENABLE bt-filtro
         WITH FRAME fPage0.

     disable bt-elimina 
             lote 
             dt-val-lote 
             refer 
             quant 
         with frame fpage1.

     IF l-lote-avancado THEN
         disable c-lote-fabricante
                 dt-valid-lote-fabric
                 c-nome-fabr
                 dt-fabr-lote
         with frame fpage1.
     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        IF CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "LOTE-AVANCADO"
                                    AND funcao.ativo = YES) THEN DO:

            IF i-pais-impto-usuario = 1 /* Brasil */ THEN
                ASSIGN l-lote-avancado = YES
                       wWindow:HEIGHT = wWindow:HEIGHT + 4
                       FRAME fPage0:HEIGHT = FRAME fPage0:HEIGHT + 4
                       rtToolBar:ROW IN FRAME fPage0 = rtToolBar:ROW IN FRAME fPage0 + 4
                       btOk:ROW IN FRAME fPage0 = btOk:ROW IN FRAME fPage0 + 4
                       btCancel:ROW IN FRAME fPage0 = btCancel:ROW IN FRAME fPage0 + 4
                       btHelp2:ROW IN FRAME fPage0 = btHelp2:ROW IN FRAME fPage0 + 4
                       FRAME fpage1:HEIGHT  = FRAME fpage1:HEIGHT + 4
                       bt-inclui:ROW IN FRAME fPage1 = bt-inclui:ROW IN FRAME fPage1 + 4
                       btUpdateSon1:ROW IN FRAME fPage1 = btUpdateSon1:ROW IN FRAME fPage1 + 4
                       bt-elimina:ROW IN FRAME fPage1 = bt-elimina:ROW IN FRAME fPage1 + 4
                       browse-1:HEIGHT IN FRAME fPage1 = browse-1:HEIGHT IN FRAME fPage1 + 4
                       rect-2:ROW IN FRAME fPage1 = rect-2:ROW IN FRAME fPage1 + 4
                       de-tot-inf:ROW IN FRAME fPage1 = de-tot-inf:ROW IN FRAME fPage1 + 4
                       de-saldo-rest:ROW IN FRAME fPage1 = de-saldo-rest:ROW IN FRAME fPage1 + 4
                       rect-1:HEIGHT IN FRAME fPage1 = rect-1:HEIGHT IN FRAME fPage1 + 4
                       bt-cancela:ROW IN FRAME fPage1 = bt-cancela:ROW IN FRAME fPage1 + 4
                       bt-sav:ROW IN FRAME fPage1 = bt-sav:ROW IN FRAME fPage1 + 4
                       c-un-fornec:ROW IN FRAME fPage1 = c-un-fornec:ROW IN FRAME fPage1 + 4
                       de-qtd-do-forn:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1 + 4
                       c-un:ROW IN FRAME fPage1 = c-un:ROW IN FRAME fPage1 + 4
                       quant:ROW IN FRAME fPage1 = quant:ROW IN FRAME fPage1 + 4
                       refer:ROW IN FRAME fPage1 = refer:ROW IN FRAME fPage1 + 4
                       de-saldo-rest:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = de-saldo-rest:ROW IN FRAME fPage1
                       de-tot-inf:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = de-tot-inf:ROW IN FRAME fPage1
                       c-un-fornec:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = c-un-fornec:ROW IN FRAME fPage1
                       de-qtd-do-forn:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1 
                       c-un:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = c-un:ROW IN FRAME fPage1 
                       quant:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = quant:ROW IN FRAME fPage1 
                       refer:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = refer:ROW IN FRAME fPage1. 
            ELSE
                ASSIGN l-lote-avancado                  = YES
                       wWindow:HEIGHT                   = wWindow:HEIGHT + 4
                       FRAME fPage0:HEIGHT              = FRAME fPage0:HEIGHT + 4
                       rtToolBar:ROW IN FRAME fPage0    = rtToolBar:ROW IN FRAME fPage0 + 4
                       btOk:ROW IN FRAME fPage0         = btOk:ROW IN FRAME fPage0 + 4
                       btCancel:ROW IN FRAME fPage0     = btCancel:ROW IN FRAME fPage0 + 4
                       btHelp2:ROW IN FRAME fPage0      = btHelp2:ROW IN FRAME fPage0 + 4
                       FRAME fpage1:HEIGHT              = FRAME fpage1:HEIGHT + 4
                       bt-inclui:ROW IN FRAME fPage1    = bt-inclui:ROW IN FRAME fPage1 + 4
                       btUpdateSon1:ROW IN FRAME fPage1 = btUpdateSon1:ROW IN FRAME fPage1 + 4
                       bt-elimina:ROW IN FRAME fPage1   = bt-elimina:ROW IN FRAME fPage1 + 4
                       browse-1:HEIGHT IN FRAME fPage1  = browse-1:HEIGHT IN FRAME fPage1 + 4
                       rect-2:ROW IN FRAME fPage1       = rect-2:ROW IN FRAME fPage1 + 4

                       c-cod-depos:HIDDEN IN FRAME fPage1 = NO
                       c-un:LABEL IN FRAME fPage1         = ""
                       c-un-fornec:LABEL IN FRAME fPage1  = ""
                       
                       lote:ROW IN FRAME fPage1                 = lote:ROW IN FRAME fPage1 + 1
                       dt-val-lote:ROW IN FRAME fPage1          = dt-val-lote:ROW IN FRAME fPage1 + 1
                       c-lote-fabricante:ROW IN FRAME fPage1    = c-lote-fabricante:ROW IN FRAME fPage1 + 1
                       dt-valid-lote-fabric:ROW IN FRAME fPage1 = dt-valid-lote-fabric:ROW IN FRAME fPage1 + 1
                       dt-fabr-lote:ROW IN FRAME fPage1         = dt-fabr-lote:ROW IN FRAME fPage1 + 1
                       c-nome-fabr:ROW IN FRAME fPage1          = c-nome-fabr:ROW IN FRAME fPage1 + 1
                       refer:ROW IN FRAME fPage1                = refer:ROW IN FRAME fPage1 + 5
                       quant:ROW IN FRAME fPage1                = quant:ROW IN FRAME fPage1 + 5
                       c-un:ROW IN FRAME fPage1                 = quant:ROW IN FRAME fPage1
                       c-un:COL IN FRAME fPage1                 = 91.0
                       de-qtd-do-forn:ROW IN FRAME fPage1       = de-qtd-do-forn:ROW IN FRAME fPage1 + 4
                       c-un-fornec:ROW IN FRAME fPage1          = de-qtd-do-forn:ROW IN FRAME fPage1
                       c-un-fornec:COL IN FRAME fPage1          = 91.0
                       de-tot-inf:ROW IN FRAME fPage1           = de-tot-inf:ROW IN FRAME fPage1 + 4
                       de-saldo-rest:ROW IN FRAME fPage1        = de-saldo-rest:ROW IN FRAME fPage1 + 4
                       rect-1:HEIGHT IN FRAME fPage1            = rect-1:HEIGHT IN FRAME fPage1 + 4
                       bt-cancela:ROW IN FRAME fPage1           = bt-cancela:ROW IN FRAME fPage1 + 4
                       bt-sav:ROW IN FRAME fPage1               = bt-sav:ROW IN FRAME fPage1 + 4
                        
                       de-qtd-do-forn:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1       = de-qtd-do-forn:ROW IN FRAME fPage1 
                       quant:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1                = quant:ROW IN FRAME fPage1 
                       refer:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1                = refer:ROW IN FRAME fPage1
                       lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1                 = lote:ROW IN FRAME fPage1
                       dt-val-lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = dt-val-lote:ROW IN FRAME fPage1
                       c-lote-fabricante:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1    = c-lote-fabricante:ROW IN FRAME fPage1
                       dt-valid-lote-fabric:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = dt-valid-lote-fabric:ROW IN FRAME fPage1 
                       dt-fabr-lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1         = dt-fabr-lote:ROW IN FRAME fPage1 
                       c-nome-fabr:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = c-nome-fabr:ROW IN FRAME fPage1
                       de-saldo-rest:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1        = de-saldo-rest:ROW IN FRAME fPage1
                       de-tot-inf:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1           = de-tot-inf:ROW IN FRAME fPage1.                 
    
        END.
        ELSE DO:
            ASSIGN c-lote-fabricante:HIDDEN IN FRAME fPage1 = YES
                   dt-valid-lote-fabric:HIDDEN IN FRAME fPage1 = YES
                   c-nome-fabr:HIDDEN IN FRAME fPage1 = YES
                   dt-fabr-lote:HIDDEN IN FRAME fPage1 = YES.

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                ASSIGN c-cod-depos:HIDDEN IN FRAME fPage1    = NO
                       c-un:LABEL IN FRAME fPage1            = ""
                       c-un-fornec:LABEL IN FRAME fPage1     = ""
        
                       lote:ROW IN FRAME fPage1        = lote:ROW IN FRAME fPage1 + 1
                       dt-val-lote:ROW IN FRAME fPage1 = dt-val-lote:ROW IN FRAME fPage1 + 1
                       refer:ROW IN FRAME fPage1       = refer:ROW IN FRAME fPage1 + 1
                       quant:ROW IN FRAME fPage1       = quant:ROW IN FRAME fPage1 + 1
                       c-un:ROW IN FRAME fPage1        = quant:ROW IN FRAME fPage1
                       c-un:COL IN FRAME fPage1        = 91.0
                       c-un-fornec:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1
                       c-un-fornec:COL IN FRAME fPage1 = 91.0
                        
                       c-un-fornec:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1    = c-un-fornec:ROW IN FRAME fPage1
                       de-qtd-do-forn:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1 
                       c-un:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1           = c-un:ROW IN FRAME fPage1 
                       quant:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = quant:ROW IN FRAME fPage1 
                       refer:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = refer:ROW IN FRAME fPage1
                       lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1           = lote:ROW IN FRAME fPage1
                       dt-val-lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1    = dt-val-lote:ROW IN FRAME fPage1. 
            END.

        END.
    &ELSE
        ASSIGN c-lote-fabricante:HIDDEN IN FRAME fPage1 = YES
               dt-valid-lote-fabric:HIDDEN IN FRAME fPage1 = YES
               c-nome-fabr:HIDDEN IN FRAME fPage1 = YES
               dt-fabr-lote:HIDDEN IN FRAME fPage1 = YES.
        
        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
            ASSIGN c-cod-depos:HIDDEN IN FRAME fPage1    = NO
                   c-un:LABEL IN FRAME fPage1            = ""
                   c-un-fornec:LABEL IN FRAME fPage1     = ""
    
                   lote:ROW IN FRAME fPage1        = lote:ROW IN FRAME fPage1 + 1
                   dt-val-lote:ROW IN FRAME fPage1 = dt-val-lote:ROW IN FRAME fPage1 + 1
                   refer:ROW IN FRAME fPage1       = refer:ROW IN FRAME fPage1 + 1
                   quant:ROW IN FRAME fPage1       = quant:ROW IN FRAME fPage1 + 1
                   c-un:ROW IN FRAME fPage1        = quant:ROW IN FRAME fPage1
                   c-un:COL IN FRAME fPage1        = 91.0
                   c-un-fornec:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1
                   c-un-fornec:COL IN FRAME fPage1 = 91.0
                    
                   c-un-fornec:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1    = c-un-fornec:ROW IN FRAME fPage1
                   de-qtd-do-forn:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1 = de-qtd-do-forn:ROW IN FRAME fPage1 
                   c-un:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1           = c-un:ROW IN FRAME fPage1 
                   quant:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = quant:ROW IN FRAME fPage1 
                   refer:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1          = refer:ROW IN FRAME fPage1
                   lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1           = lote:ROW IN FRAME fPage1
                   dt-val-lote:SIDE-LABEL-HANDLE:ROW IN FRAME fPage1    = dt-val-lote:ROW IN FRAME fPage1. 
        END.

    &ENDIF

    
    enable browse-1 
           btUpdateSon1 
           with frame fpage1.

    ENABLE bt-filtro
        WITH FRAME fPage0.

    disable bt-elimina 
            lote 
            dt-val-lote 
            refer 
            quant 
        with frame fpage1.

    IF l-lote-avancado THEN
        DISABLE c-lote-fabricante
                dt-valid-lote-fabric
                c-nome-fabr
                dt-fabr-lote
        with frame fpage1.
    

    apply "entry":U to browse-1 in frame fpage1.                   

    run initializeDBos in this-procedure.

    /* passa todos os registros para selecionado = no */
    FOR EACH tt-item-doc-est:
        ASSIGN tt-item-doc-est.l-selecionado = YES.
    END.
    {&OPEN-QUERY-BROWSE-1}

    apply "value-changed" to browse-1 in frame fpage1. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTotais wWindow 
PROCEDURE carregaTotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    ** Grava valores totais para validaÁıes de quantidade
    */
    FOR EACH tt-item-doc-est:
        FIND tt-item-totais NO-LOCK
            WHERE tt-item-totais.numero-ordem = tt-item-doc-est.numero-ordem
            AND   tt-item-totais.parcela      = tt-item-doc-est.parcela NO-ERROR.
        IF  NOT AVAIL tt-item-totais THEN DO:
            CREATE tt-item-totais.
            ASSIGN tt-item-totais.numero-ordem = tt-item-doc-est.numero-ordem
                   tt-item-totais.parcela      = tt-item-doc-est.parcela
                   tt-item-totais.quantidade   = tt-item-doc-est.quantidade.
        END. /* IF  NOT AVAIL tt-item-totais */
        ELSE DO:
            ASSIGN tt-item-totais.quantidade   = tt-item-totais.quantidade + tt-item-doc-est.quantidade.
        END. /* ELSE DO: */
    END. /* FOR EACH tt-item-doc-est: */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultLot wWindow 
PROCEDURE defaultLot :
DEFINE VARIABLE h-bocx140 AS HANDLE        NO-UNDO.
    DEFINE VARIABLE c-fm-codigo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-boin172 AS HANDLE        NO-UNDO.
    DEFINE VARIABLE i-tipo-con-est AS INTEGER  NO-UNDO.
    DEFINE VARIABLE c-return AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-sugere-lote AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE h-ceapi030    AS HANDLE    NO-UNDO.
    define variable l-amostra     as log       no-undo.
    define variable i-tp-amostra  as int       no-undo.

    IF NOT VALID-HANDLE (h-boin172) THEN
        RUN inbo/boin172.p PERSISTENT SET h-boin172.

    IF VALID-HANDLE(h-boin172) THEN DO:
        RUN openQuery IN h-boin172(INPUT 1).
        RUN goToKey IN h-boin172 (input tt-item-doc-est.it-codigo).
        IF (RETURN-VALUE <> "NOK") THEN DO:
            RUN getIntField IN h-boin172 (INPUT "tipo-con-est", OUTPUT i-tipo-con-est).
            RUN getCharField IN h-boin172 (INPUT "fm-codigo", OUTPUT c-fm-codigo).
        END.
    END.
   
    IF (i-tipo-con-est = 3 or i-tipo-con-est = 4) then do:
         &if '{&bf_lote_avancado_liberado}' = 'yes' &then
             if l-lote-avancado then do:
                    
                 IF NOT VALID-HANDLE(h-bocx140) THEN DO:
                     RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
                     RUN openQuery IN h-bocx140 (INPUT 1) NO-ERROR.
                 END.

                 empty temp-table tt-dados-fda.
                 empty temp-table tt-valores.
                 empty temp-table tt-erro.
                 
                 RUN findPedido IN h-bocx140 (INPUT tt-item-doc-est.num-pedido,
                                              OUTPUT c-return).
                 IF c-return <> "NOK" THEN
                    RUN getCharField IN h-bocx140 (INPUT "cod-estabel":U, OUTPUT c-cod-estabel).
                 
                 
                 create tt-dados-fda.
                 assign tt-dados-fda.cod-estabel     = c-cod-estabel
                        tt-dados-fda.it-codigo       = tt-item-doc-est.it-codigo
                        tt-dados-fda.cod-refer       = refer:SCREEN-VALUE IN FRAME fPage1
                        tt-dados-fda.cod-modul-dtsul = "MRE"
                        tt-dados-fda.cod-usuario     = c-seg-usuario
                        tt-dados-fda.cod-depos       = tt-item-doc-est.cod-depos
                        tt-dados-fda.cod-localiz     = ""
                        tt-dados-fda.fm-codigo       = c-fm-codigo.
                
                 IF NOT VALID-HANDLE(h-ceapi030) THEN
                     RUN cep/ceapi030.p PERSISTENT SET h-ceapi030(input table tt-dados-fda,
                                                                  output table tt-valores, 
                                                                  output table tt-erro).  
                 RUN pi-executar IN h-ceapi030 (input table tt-dados-fda,
                                                output table tt-valores,
                                                output table tt-erro).
                 FIND FIRST tt-dados-fda NO-ERROR.
                 IF AVAIL tt-dados-fda THEN
                     run pi-param-esp in h-ceapi030 (input tt-dados-fda.it-codigo,
                                                     input "",
                                                     input tt-dados-fda.cod-estabel,
                                                     output l-sugere-lote,
                                                     output l-amostra,
                                                     output i-tp-amostra).
                 
                 FOR FIRST tt-valores NO-LOCK :
                    IF l-sugere-lote THEN
                        ASSIGN lote:SCREEN-VALUE IN FRAME fPage1 = tt-valores.lote.
                    ASSIGN dt-val-lote:SCREEN-VALUE IN FRAME fPage1 = string(tt-valores.dt-val).
                     
                 END.
                 IF VALID-HANDLE(h-bocx140) THEN DO:
                      DELETE PROCEDURE h-bocx140.
                      ASSIGN h-bocx140 = ?.
                 END.
                 IF VALID-HANDLE (h-ceapi030) THEN DO:
                     DELETE PROCEDURE h-ceapi030.
                     ASSIGN h-ceapi030 = ?.
                 END.
                  IF CAN-FIND (tt-erro) THEN
                     RUN cdp/cd0666.w (INPUT TABLE tt-erro).
             end.
         &endif
    END.
    IF VALID-HANDLE (h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*--- Verifica se o DBO j† est† inicializado ---*/

    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
        run cxbo/bocx220c.p persistent set h-bocx220c.    
    END.
    
    IF NOT VALID-HANDLE(h-bocx225na) THEN DO:
        RUN cxbo/bocx225na.p PERSISTENT SET h-bocx225na.
    END.

    find first tt-item-doc-est no-error.
    if avail tt-item-doc-est then do:

        RUN carregaTable in h-bocx220c (input table tt-item-doc-est,
                                        output cont-rowid).
        /*
        ** Grava valores totais para validaÁıes de quantidade
        */
        RUN carregaTotais.
        RUN openQuery in h-bocx220c (input 1).
        RUN findFirst in h-bocx220c.
        {&OPEN-QUERY-BROWSE-1}
        run findfirst in h-bocx220c.
    end.

    apply "entry":U to browse-1 in frame fpage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wWindow 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera wWindow 
PROCEDURE pi-altera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE input PARAMETER i-seq        AS integer NO-UNDO.
 DEFINE input PARAMETER i-num-ordem  AS integer NO-UNDO.
 DEFINE input PARAMETER c-item       AS char NO-UNDO.
 DEFINE input PARAMETER table for tt-item-doc-est.

    find first tt-item-doc-est
       where tt-item-doc-est.numero-ordem = i-num-ordem 
         and tt-item-doc-est.parcela      = i-parc 
         and tt-item-doc-est.sequencial   = i-seq  no-error.
    if avail tt-item-doc-est then do:
        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                RUN defaultLot.
        &endif
        
        if tt-item-doc-est.tipo-con-est = 3 then do:

            enable lote 
                   dt-val-lote 
                   quant with frame fpage1.
            IF l-lote-avancado THEN
                enable c-lote-fabricante
                       dt-valid-lote-fabric
                       c-nome-fabr
                       dt-fabr-lote
                       with frame fpage1.

            disable refer with frame fpage1.
        end.
        else 

            if tt-item-doc-est.tipo-con-est = 2 then do:

                enable lote with frame fpage1.
                disable quant 
                        dt-val-lote 
                        refer with frame fpage1.
            end.
            else do: 
                IF tt-item-doc-est.tipo-con-est = 4 AND l-lote-avancado THEN
                    ENABLE  c-lote-fabricante
                            dt-valid-lote-fabric
                            c-nome-fabr
                            dt-fabr-lote with frame fpage1.



                enable lote 
                       dt-val-lote 
                       refer 
                       quant with frame fpage1.
                refer:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

                if tt-item-doc-est.cod-refer <> "" then
                    assign refer:screen-value in frame fpage1 = tt-item-doc-est.cod-refer.
            end.

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
            c-cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

        if tt-item-doc-est.lote <> "" then
            assign l-alt = yes.
        else 
            assign l-alt = no.

        /*
        ** Verifica se o registro j† foi alterado uma vez, se foi atualiza a quantidade a informar e
        ** a quantidade informada diminuindo o valor informado anteriormente 
        */
        if tt-item-doc-est.situacao = yes then do:
            find tt-recebe
               where tt-recebe.numero-ordem = i-num-ordem 
                 and tt-recebe.parcela      = i-parc no-error.
            if avail tt-recebe then
                assign tt-recebe.quantidade-informada  = tt-recebe.quantidade-informada     
                                                       - dec(quant:screen-value in frame fpage1)
                       tt-recebe.quantidade-a-informar = tt-recebe.quantidade-a-informar 
                                                       + dec(quant:screen-value in frame fpage1)
                       d-quantidade                    = dec(quant:screen-value in frame fpage1).

        end.
        else assign d-quantidade = 0.
    end.

    enable bt-cancela 
           bt-sav with frame fpage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela wWindow 
PROCEDURE pi-cancela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTT wWindow 
PROCEDURE pi-carregaTT :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF VAR h-bocx225na AS HANDLE    NO-UNDO.
    DEF VAR c-return    AS CHARACTER NO-UNDO.
    DEF VAR cembarque   AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx225na) THEN RUN cxbo/bocx225na.p PERSISTENT SET h-bocx225na.
 
    FOR EACH tt-item-doc-est:
        RUN FindOrdensEmbarque IN h-bocx225na (INPUT tt-item-doc-est.numero-ordem, INPUT tt-item-doc-est.parcela, OUTPUT c-return).
        IF  c-return = "" THEN 
            RUN getCharField IN h-bocx225na ("embarque":U, 
                                             OUTPUT cembarque).
        ELSE 
            ASSIGN cembarque = "".

        IF  cembarque <> "" THEN DO:
            IF  NOT CAN-FIND(FIRST ttEmbarque WHERE ttEmbarque.embarque = cembarque) THEN DO:
                CREATE ttEmbarque.
                ASSIGN ttEmbarque.embarque     = cembarque
                       ttEmbarque.marcado      = tt-item-doc-est.l-selecionado
                       ttEmbarque.selecionado  = "*" WHEN tt-item-doc-est.l-selecionado
                       ttEmbarque.selecionado  = ""  WHEN NOT tt-item-doc-est.l-selecionado 
                       ttEmbarque.numero-ordem = tt-item-doc-est.numero-ordem
                       ttEmbarque.parcela      = tt-item-doc-est.parcela
                       ttEmbarque.sequencial   = tt-item-doc-est.sequencial.
            END. /* IF  NOT CAN-FIND(FIRST ttEmbarque */
        END. /* IF  cembarque <> "" THEN DO: */
        ELSE NEXT.
    END. /* FOR EACH tt-item-doc-est: */

    RUN pi-monta-ttEmbarque (INPUT TABLE ttEmbarque). /* carrega a tt que alimenta o browse do im0100a */
    
    IF VALID-HANDLE(h-bocx225na) THEN DO:
        DELETE PROCEDURE h-bocx225na.
        ASSIGN h-bocx225na = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-confirmar wWindow 
PROCEDURE pi-confirmar :
/*
    ** Atualiza a tt-item-doc-est com os valores informados nos campos lote, dt-val-lote, refer
    ** e quant, se a quantidade informada for menor que a quantidade das ordens de embarque, Ç
    ** criado um novo registro  com os campos lote, dt-val-lote e refer vazios e o campo quantidade
    ** recebe a quantidade das ordens de embarque menos oa quantidade informada.
    */
    define input        parameter l-alt as logical no-undo.
    define input-output parameter table for tt-item-doc-est.

    DEFINE VARIABLE l-verif           AS   LOGICAL INITIAL NO      NO-UNDO.
    DEFINE VARIABLE de-quant-total    LIKE prazo-compra.quantidade NO-UNDO.
    DEFINE VARIABLE l-numeroSerie     AS LOGICAL    NO-UNDO.

    DEF VAR c-item-estab-char-2 AS CHAR FORMAT "x(256)" NO-UNDO. 
    DEF VAR c-item-char-2       AS CHAR FORMAT "x(256)" NO-UNDO.
    DEF VAR c-cod-estabel       AS CHAR FORMAT "x(05)"  NO-UNDO.
    DEF VAR h-boin684 AS HANDLE NO-UNDO.
    DEF VAR h-boin172 AS HANDLE NO-UNDO.
    DEF VAR h-bocx140 AS HANDLE NO-UNDO.
    DEF VAR c-return  AS CHAR   NO-UNDO.

    assign input frame fPage1
        lote
        dt-val-lote
        refer
        quant
        de-qtd-do-forn.

    IF l-lote-avancado THEN
       ASSIGN INPUT FRAME fPage1
              c-lote-fabricante
              dt-valid-lote-fabric
              c-nome-fabr
              dt-fabr-lote.

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN INPUT FRAME fPage1 
               c-cod-depos.

    find first tt-item-doc-est
        where tt-item-doc-est.numero-ordem =  i-num-ordem 
          and tt-item-doc-est.parcela      =  i-parc
          and tt-item-doc-est.lote         =  lote
          AND tt-item-doc-est.dt-vali-lote <> dt-val-lote
          and not l-alt no-error.
    if avail tt-item-doc-est then do:
        run utp/ut-msgs.p (input "show":U,
                           input 26642,
                           input ""). 
        return no-apply.
    end.

    /*
    ** Verifica se o lote informado j† existe para uma mesma ordem 
    */
    find first tt-item-doc-est
        where tt-item-doc-est.numero-ordem =  i-num-ordem 
          and tt-item-doc-est.parcela      =  i-parc
          and tt-item-doc-est.lote         =  lote
          and tt-item-doc-est.tipo-con-est >  2 
          and lote                         <> ""
          and not l-alt no-error.
    if avail tt-item-doc-est then do:
        run utp/ut-msgs.p (input "show":U,
                           input 25289,
                           input string(lote) + "~~" + string(i-num-ordem)). 
        if return-value = "no":U then
            return no-apply.
    end.    

    
    /*
    ** Validaá∆o dos campos informados 
    */
    find tt-item-doc-est
        where tt-item-doc-est.numero-ordem = i-num-ordem 
          and tt-item-doc-est.parcela      = i-parc 
          and tt-item-doc-est.sequencial   = i-seq no-error.
    if avail tt-item-doc-est then do:

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
            IF NOT VALID-HANDLE(h-bocx140) THEN DO:
                RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
                RUN openQuery IN h-bocx140 (INPUT 1) NO-ERROR.
            END.                         
            RUN findPedido IN h-bocx140 (INPUT tt-item-doc-est.num-pedido,
                                         OUTPUT c-return).
            IF c-return <> "NOK" THEN
                RUN getCharField IN h-bocx140 (INPUT "cod-estabel":U, OUTPUT c-cod-estabel).
    
            DELETE PROCEDURE h-bocx140. /* ocorre erro progress ao usar destroy */
            ASSIGN h-bocx140 = ?.
    
            IF NOT VALID-HANDLE (h-boin684) THEN /* item x estabelecimento */
                RUN inbo/boin684.p PERSISTENT SET h-boin684.
                                
            IF VALID-HANDLE(h-boin684) THEN DO:
                RUN openQueryStatic IN h-boin684 (INPUT "Main":U) NO-ERROR.
                run goToKey in h-boin684 (INPUT tt-item-doc-est.it-codigo,
                                          INPUT c-cod-estabel).
                IF RETURN-VALUE = "OK" THEN
                    RUN getCharField IN h-boin684 (INPUT "char-2", OUTPUT c-item-estab-char-2).
    
                RUN destroy IN h-boin684.
                                        
            END.
    
            IF NOT VALID-HANDLE (h-boin172) THEN /* item */
                RUN inbo/boin172.p PERSISTENT SET h-boin172.
                                
            IF VALID-HANDLE(h-boin172) THEN DO:
                RUN openQuery IN h-boin172(INPUT 1).
                RUN goToKey IN h-boin172 (input tt-item-doc-est.it-codigo).
                IF RETURN-VALUE = "OK" THEN
                    RUN getCharField IN h-boin172 (INPUT "char-2", OUTPUT c-item-char-2).
    
                RUN destroy IN h-boin172.
                                        
            END.
                    
            IF tt-item-doc-est.nr-ato-concessorio <> "" THEN DO:
                IF (SUBSTRING(c-item-estab-char-2,34,3) <> "" OR
                    SUBSTRING(c-item-char-2,316,3)      <> "") AND
                    c-cod-depos <> SUBSTRING(c-item-estab-char-2,34,3) AND
                    c-cod-depos <> SUBSTRING(c-item-char-2,316,3) THEN DO:
    
                    /* O dep¢sito &1 n∆o Ç o dep¢sito &2 padr∆o do item. ~~ Deseja que altere para o dep¢sito &2 padr∆o do item? */
                    {utp/ut-liter.i "Drawback" *}
                    run utp/ut-msgs.p (input "show":U,
                                       input 55811, 
                                       input c-cod-depos + "~~" + TRIM(RETURN-VALUE)). 
                    if return-value = "yes":U THEN DO:
                        IF SUBSTRING(c-item-estab-char-2,34,3) <> "" THEN
                            ASSIGN c-cod-depos = SUBSTRING(c-item-estab-char-2,34,3).
                        ELSE
                            ASSIGN c-cod-depos = SUBSTRING(c-item-char-2,316,3).
                    END.                    
                END.
            END.
            ELSE DO:            
                IF l-dep-ext THEN DO:
                    IF (SUBSTRING(c-item-estab-char-2,31,3) <> "" OR
                        SUBSTRING(c-item-char-2,313,3)      <> "") AND
                        c-cod-depos <> SUBSTRING(c-item-estab-char-2,31,3) AND
                        c-cod-depos <> SUBSTRING(c-item-char-2,313,3) THEN DO:
        
                        /* O dep¢sito &1 n∆o Ç o dep¢sito &2 padr∆o do item. ~~ Deseja que altere para o dep¢sito &2 padr∆o do item? */
                        {utp/ut-liter.i "Externo" *}
                        run utp/ut-msgs.p (input "show":U,
                                           input 55811, 
                                           input c-cod-depos + "~~" + TRIM(RETURN-VALUE)). 
                        if return-value = "yes":U THEN DO:
                            IF SUBSTRING(c-item-estab-char-2,31,3) <> "" THEN
                                ASSIGN c-cod-depos = SUBSTRING(c-item-estab-char-2,31,3).
                            ELSE
                                ASSIGN c-cod-depos = SUBSTRING(c-item-char-2,313,3).
                        END.                    
                    END.
                END.
            END.             
        END.


        for each tt-bo-erro no-lock:
            delete tt-bo-erro.
        end.
        run validaAdicionais in h-bocx220c (INPUT c-cod-depos,
                                            INPUT l-dep-ext,
                                            input lote,
                                            input dt-val-lote,
                                            input refer,
                                            input quant,
                                            input de-qt-a-informar,
                                            input table tt-item-doc-est,
                                            input l-alt,
                                            input i-seq,
                                            input i-num-ordem,
                                            input i-parc,
                                            output table tt-bo-erro).
    end.

    /*
    ** Validacao Quantidade
    */
    IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
        ASSIGN de-quant-total = quant.
        FOR EACH tt-item-doc-est
            WHERE tt-item-doc-est.numero-ordem = i-num-ordem
              AND tt-item-doc-est.parcela      = i-parc 
              AND tt-item-doc-est.sequencial  <> i-seq NO-LOCK:
            ASSIGN de-quant-total = de-quant-total
                                  + tt-item-doc-est.quantidade.
        END.
        FIND tt-item-totais
            WHERE tt-item-totais.numero-ordem = i-num-ordem
              AND tt-item-totais.parcela      = i-parc NO-LOCK NO-ERROR.
        IF de-quant-total > tt-item-totais.quantidade THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 15535,
                               INPUT "").
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen = 1
                   tt-bo-erro.cd-erro  = 15535
                   tt-bo-erro.mensagem = RETURN-VALUE.
        END.
    END.

    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.            
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        Return "NOK":U.
    END.
    ELSE DO:
        find tt-recebe 
            where tt-recebe.numero-ordem = i-num-ordem
              and tt-recebe.parcela      = i-parc no-error.

        if avail tt-recebe then do:
            assign tt-recebe.quantidade-informada  = tt-recebe.quantidade-informada  + quant
                   tt-recebe.quantidade-a-informar = tt-recebe.quantidade-a-informar - quant
                   de-qt-a-informar                = tt-recebe.quantidade-a-informar
                   de-qt-informada                 = tt-recebe.quantidade-informada
                   de-qt-total                     = tt-recebe.quantidade-total
                   de-preco-total                  = tt-recebe.preco-total
                   de-preco-total-mo               = tt-recebe.preco-total-mo
                   de-peso-liquido-total           = tt-recebe.peso-liquido-total.
        end.

        for each tt-item-doc-est-aux:
            delete tt-item-doc-est-aux.
        end.

        /* Atualiza a temptable principal com os dados informados */
        find tt-item-doc-est 
            where tt-item-doc-est.numero-ordem = i-num-ordem
              and tt-item-doc-est.parcela      = i-parc
              and tt-item-doc-est.sequencial   = i-seq no-error.

        if avail tt-item-doc-est then do:
            FIND FIRST ITEM 
                 WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-LOCK NO-ERROR.

            IF AVAIL ITEM AND item.tipo-con-est = 2 THEN
            ASSIGN de-peso-liquido-total = tt-item-doc-est.peso-liquido
                   de-quant-total-aux    = tt-item-doc-est.quantidade
                   l-numeroSerie         = YES.

           assign tt-item-doc-est.lote            = lote
                  tt-item-doc-est.dt-vali-lote   = dt-val-lote
                  tt-item-doc-est.cod-refer      = refer
                  tt-item-doc-est.preco-total    = IF l-numeroSerie THEN
                                                   (quant * tt-item-doc-est.preco-total) / tt-item-doc-est.quantidade
                                                   ELSE
                                                    (quant * de-preco-total)/ de-qt-total
                  tt-item-doc-est.preco-total-mo = IF l-numeroSerie THEN 
                                                   (quant * tt-item-doc-est.preco-total-mo) / tt-item-doc-est.quantidade
                                                   ELSE (quant * de-preco-total-mo) / de-qt-total
                  tt-item-doc-est.quantidade     = quant
                  tt-item-doc-est.situacao       = yes.
                  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                      IF l-lote-avancado THEN
                          ASSIGN tt-item-doc-est.cod-lote-fabrican       =  c-lote-fabricante:SCREEN-VALUE IN FRAME fPage1
                                 tt-item-doc-est.dat-valid-lote-fabrican =  date(dt-valid-lote-fabric:SCREEN-VALUE IN FRAME fPage1)
                                 tt-item-doc-est.nom-fabrican            =  c-nome-fabr:SCREEN-VALUE IN FRAME fPage1      
                                 tt-item-doc-est.dat-fabricc-lote        =  date(dt-fabr-lote:SCREEN-VALUE IN FRAME fPage1).         
                  &ENDIF
            &if '{&bf_mat_versao_ems}' < '2.05' &then
                IF l-numeroSerie THEN                                             
                   ASSIGN tt-item-doc-est.peso-liquido = (quant * de-peso-liquido-total) / tt-item-doc-est.quantidade.
                ELSE
                   ASSIGN tt-item-doc-est.peso-liquido = (quant * de-peso-liquido-total)/ de-qt-total.
            &ELSE
                IF l-numeroSerie THEN
                   ASSIGN tt-item-doc-est.peso-liquido = (tt-item-doc-est.quantidade * de-peso-liquido-total) / de-quant-total-aux.
                ELSE
                   ASSIGN tt-item-doc-est.peso-liquido = (tt-item-doc-est.quantidade * de-peso-liquido-total) / de-qt-total.
            &ENDIF

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
                ASSIGN tt-item-doc-est.cod-depos = c-cod-depos.

            run atualizaQtdeDoForn in h-bocx220c (input  tt-item-doc-est.quantidade,
                                                  input  i-num-ordem,
                                                  input  c-item,
                                                  output d-qtd-do-forn).

            assign tt-item-doc-est.qtd-do-forn = d-qtd-do-forn.

            /* 
            ** Verifica se a quantidade informada Ç menor que a da ordem-embarque se for cria um novo registro
            ** com os mesmos dados do anterior, mas com o lote, dt-vali-lote e cod-refer em branco 
            */

            find first b-tt-item-doc-est 
                where b-tt-item-doc-est.numero-ordem = i-num-ordem 
                  and b-tt-item-doc-est.parcela      = i-parc 
                  and b-tt-item-doc-est.lote         = "" no-lock no-error.
            if not avail b-tt-item-doc-est then do:
                find last b-tt-item-doc-est 
                    where b-tt-item-doc-est.numero-ordem = i-num-ordem
                      and b-tt-item-doc-est.parcela      = i-parc no-lock no-error.
                if avail  b-tt-item-doc-est then do:

                    if de-qt-a-informar > 0 then do:
                        assign i-seq      = i-seq + 1
                               l-verif    = yes
                               cont-rowid = cont-rowid + 1.
                        assign c-rowid = "0x0" + string(cont-rowid,"9999999").
                        create tt-item-doc-est-aux.
                        assign tt-item-doc-est-aux.numero-ordem       = tt-item-doc-est.numero-ordem
                               tt-item-doc-est-aux.parcela            = tt-item-doc-est.parcela 
                               tt-item-doc-est-aux.nr-proc-imp        = tt-item-doc-est.nr-proc-imp
                               tt-item-doc-est-aux.quantidade         = tt-recebe.quantidade-a-informar
                               tt-item-doc-est-aux.encerra-pa         = tt-item-doc-est.encerra-pa
                               tt-item-doc-est-aux.it-codigo          = tt-item-doc-est.it-codigo                           
                               tt-item-doc-est-aux.tipo-con-est       = tt-item-doc-est.tipo-con-est
                               tt-item-doc-est-aux.r-rowid            = to-rowid(c-rowid)
                               tt-item-doc-est-aux.sequencial         = b-tt-item-doc-est.sequencial + 1
                               tt-item-doc-est-aux.class-fiscal       = tt-item-doc-est.class-fiscal
                               tt-item-doc-est-aux.nr-ato-concessorio = tt-item-doc-est.nr-ato-concessorio
                               tt-item-doc-est-aux.preco-total        = (tt-item-doc-est.preco-total
                                                                      / tt-item-doc-est.quantidade)
                                                                      * tt-recebe.quantidade-a-informar
                               tt-item-doc-est-aux.preco-total-mo     = (tt-item-doc-est.preco-total-mo
                                                                      / tt-item-doc-est.quantidade)
                                                                      * tt-recebe.quantidade-a-informar
                               tt-item-doc-est-aux.num-pedido         = tt-item-doc-est.num-pedido
                               tt-item-doc-est-aux.tp-despesa         = tt-item-doc-est.tp-despesa
                               tt-item-doc-est-aux.cod-depos          = tt-item-doc-est.cod-depos
                               tt-item-doc-est-aux.lote               = ""
                               tt-item-doc-est-aux.dt-vali-lote       = ?
                               tt-item-doc-est-aux.cod-refer          = ""
                               tt-item-doc-est-aux.l-regime           = tt-item-doc-est.l-regime
                               tt-item-doc-est-aux.aliquota-ipi       = tt-item-doc-est.aliquota-ipi
                               tt-item-doc-est-aux.un-fornec          = tt-item-doc-est.un-fornec
                               tt-item-doc-est-aux.un                 = tt-item-doc-est.un.
                        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                            IF l-lote-avancado THEN
                               ASSIGN tt-item-doc-est-aux.cod-lote-fabrican       =  ""
                                      tt-item-doc-est-aux.dat-valid-lote-fabrican =  ?
                                      tt-item-doc-est-aux.nom-fabrican            =  ""      
                                      tt-item-doc-est-aux.dat-fabricc-lote        =  ?.
                        &ENDIF
                        
                        &if '{&bf_mat_versao_ems}' >= '2.062' &then
                            IF l-numeroSerie THEN
                                ASSIGN tt-item-doc-est-aux.peso-liquido   = tt-item-doc-est.peso-liquido.
                            ELSE
                                ASSIGN tt-item-doc-est-aux.peso-liquido   = (tt-recebe.quantidade-a-informar * de-peso-liquido-total) / de-qt-total.
                        &ENDIF

                        IF tt-item-doc-est.l-ordens-embarque THEN
                            ASSIGN tt-item-doc-est-aux.peso-liquido       = tt-item-doc-est.peso-liquido
                                   tt-item-doc-est-aux.peso-bruto         = tt-item-doc-est.peso-bruto
                                   tt-item-doc-est-aux.l-ordens-embarque  = tt-item-doc-est.l-ordens-embarque
                                   tt-item-doc-est-aux.cd-trib-ii         = tt-item-doc-est.cd-trib-ii    
                                   tt-item-doc-est-aux.cd-trib-ipi        = tt-item-doc-est.cd-trib-ipi   
                                   tt-item-doc-est-aux.cd-trib-icms       = tt-item-doc-est.cd-trib-icms  
                                   tt-item-doc-est-aux.aliquota-ii        = tt-item-doc-est.aliquota-ii   
                                   tt-item-doc-est-aux.aliquota-icms      = tt-item-doc-est.aliquota-icms.
                        
                        run atualizaQtdeDoForn in h-bocx220c (input  tt-item-doc-est-aux.quantidade,
                                                              input  i-num-ordem,
                                                              input  c-item,
                                                              output d-qtd-do-forn).

                        assign tt-item-doc-est-aux.qtd-do-forn = d-qtd-do-forn.
                    end.
                end.
            end.

            if d-quantidade <> 0 then do:
                if d-quantidade < tt-item-doc-est.quantidade then do:
                    find first tt-item-doc-est
                        where tt-item-doc-est.numero-ordem = i-num-ordem 
                          and tt-item-doc-est.parcela      = i-parc 
                          and tt-item-doc-est.lote         = "":U no-error.
                    if avail tt-item-doc-est then do:
                        assign tt-item-doc-est.quantidade = tt-item-doc-est.quantidade 
                                                          - (quant - d-quantidade ).
                        run atualizaQtdeDoForn in h-bocx220c (input  tt-item-doc-est.quantidade,
                                                              input  i-num-ordem,
                                                              input  c-item,
                                                              output d-qtd-do-forn).

                        assign tt-item-doc-est.qtd-do-forn = d-qtd-do-forn.
                    end.
                end.
                else 
                    if d-quantidade > tt-item-doc-est.quantidade then do:
                        find first tt-item-doc-est
                            where tt-item-doc-est.numero-ordem = i-num-ordem
                              and tt-item-doc-est.parcela      = i-parc 
                              and tt-item-doc-est.lote         = "":U no-error.
                        if avail tt-item-doc-est then do:
                            assign tt-item-doc-est.quantidade = tt-item-doc-est.quantidade 
                                                              + ( d-quantidade - quant).
                        run atualizaQtdeDoForn in h-bocx220c (input  tt-item-doc-est.quantidade,
                                                              input  i-num-ordem,
                                                              input  c-item,
                                                              output d-qtd-do-forn).

                        assign tt-item-doc-est.qtd-do-forn = d-qtd-do-forn.
                        end.
                    end.
            end.
        end.

        /* 
        ** Se o novo registro foi criado atualiza temptable principal
        */
        find first tt-item-doc-est-aux no-lock no-error.
        if avail tt-item-doc-est-aux then do:
            create tt-item-doc-est.
            assign tt-item-doc-est.numero-ordem       = tt-item-doc-est-aux.numero-ordem
                   tt-item-doc-est.parcela            = tt-item-doc-est-aux.parcela
                   tt-item-doc-est.nr-proc-imp        = tt-item-doc-est-aux.nr-proc-imp 
                   tt-item-doc-est.quantidade         = tt-item-doc-est-aux.quantidade
                   tt-item-doc-est.qtd-do-forn        = tt-item-doc-est-aux.qtd-do-forn
                   tt-item-doc-est.un-fornec          = tt-item-doc-est-aux.un-fornec
                   tt-item-doc-est.un                 = tt-item-doc-est-aux.un
                   tt-item-doc-est.encerra-pa         = tt-item-doc-est-aux.encerra-pa
                   tt-item-doc-est.it-codigo          = tt-item-doc-est-aux.it-codigo
                   tt-item-doc-est.tipo-con-est       = tt-item-doc-est-aux.tipo-con-est
                   tt-item-doc-est.r-rowid            = tt-item-doc-est-aux.r-rowid     
                   tt-item-doc-est.sequencial         = tt-item-doc-est-aux.sequencial
                   tt-item-doc-est.class-fiscal       = tt-item-doc-est-aux.class-fiscal
                   tt-item-doc-est.nr-ato-concessorio = tt-item-doc-est-aux.nr-ato-concessorio
                   tt-item-doc-est.preco-total        = tt-item-doc-est-aux.preco-total
                   tt-item-doc-est.preco-total-mo     = tt-item-doc-est-aux.preco-total-mo
                   tt-item-doc-est.num-pedido         = tt-item-doc-est-aux.num-pedido
                   tt-item-doc-est.tp-despesa         = tt-item-doc-est-aux.tp-despesa
                   tt-item-doc-est.cod-depos          = tt-item-doc-est-aux.cod-depos
                   tt-item-doc-est.quant-total        = de-qt-total
                   tt-item-doc-est.lote               = tt-item-doc-est-aux.lote 
                   tt-item-doc-est.dt-vali-lote       = tt-item-doc-est-aux.dt-vali-lote  
                   tt-item-doc-est.cod-refer          = tt-item-doc-est-aux.cod-refer
                   tt-item-doc-est.l-regime           = tt-item-doc-est-aux.l-regime
                   tt-item-doc-est.aliquota-ipi       = tt-item-doc-est-aux.aliquota-ipi.
                &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                    IF l-lote-avancado THEN
                       ASSIGN tt-item-doc-est.cod-lote-fabrican       = tt-item-doc-est-aux.cod-lote-fabrican      
                              tt-item-doc-est.dat-valid-lote-fabrican = tt-item-doc-est-aux.dat-valid-lote-fabrican
                              tt-item-doc-est.nom-fabrican            = tt-item-doc-est-aux.nom-fabrican           
                              tt-item-doc-est.dat-fabricc-lote        = tt-item-doc-est-aux.dat-fabricc-lote.       
                &ENDIF

            &if '{&bf_mat_versao_ems}' >= '2.062' &then
                ASSIGN tt-item-doc-est.peso-liquido   = tt-item-doc-est-aux.peso-liquido.
            &ENDIF
            
            IF tt-item-doc-est-aux.l-ordens-embarque THEN
                ASSIGN tt-item-doc-est.peso-liquido       = tt-item-doc-est-aux.peso-liquido
                       tt-item-doc-est.peso-bruto         = tt-item-doc-est-aux.peso-bruto
                       tt-item-doc-est.l-ordens-embarque  = tt-item-doc-est-aux.l-ordens-embarque
                       tt-item-doc-est.cd-trib-ii         = tt-item-doc-est-aux.cd-trib-ii    
                       tt-item-doc-est.cd-trib-ipi        = tt-item-doc-est-aux.cd-trib-ipi   
                       tt-item-doc-est.cd-trib-icms       = tt-item-doc-est-aux.cd-trib-icms  
                       tt-item-doc-est.aliquota-ii        = tt-item-doc-est-aux.aliquota-ii   
                       tt-item-doc-est.aliquota-icms      = tt-item-doc-est-aux.aliquota-icms.
            
        end.

        find first tt-item-doc-est 
            where tt-item-doc-est.quantidade = 0 
              and tt-item-doc-est.tipo-con-est <>  2 no-lock no-error.
        if avail tt-item-doc-est then do:
            run executeDelete in h-bocx220c (input tt-item-doc-est.numero-ordem, 
                                             input tt-item-doc-est.sequencial, 
                                             input tt-item-doc-est.parcela).
            delete tt-item-doc-est.
        end.

        for each tt-item-doc-est-aux no-lock:
            delete tt-item-doc-est-aux.
        end.

        run limpaTabela in h-bocx220c.

        disable lote 
                dt-val-lote 
                refer 
                quant 
                bt-sav
                bt-cancela with frame fpage1.
                enable btUpdateSon1 
                bt-Elimina with frame fpage1.

        assign lote        = "":U
               dt-val-lote = ?
               refer       = "":U
               quant       = 0
               de-qtd-do-forn = 0
               l-verifica  = yes.

        disp lote
             dt-val-lote
             refer
             quant
             de-qtd-do-forn
             with frame fPage1.

        IF l-lote-avancado THEN DO:
            DISABLE c-lote-fabricante   
                    dt-valid-lote-fabric
                    c-nome-fabr         
                    dt-fabr-lote      
                    with frame fpage1.

            assign c-lote-fabricante   = ""
                   dt-valid-lote-fabric = ?
                   c-nome-fabr          = ""
                   dt-fabr-lote         = ?.

             disp c-lote-fabricante   
                  dt-valid-lote-fabric
                  c-nome-fabr         
                  dt-fabr-lote       
                  with frame fPage1.
        END.

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
            ASSIGN c-cod-depos:SENSITIVE IN FRAME fPage1 = NO.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-tt-item-doc-est wWindow 
PROCEDURE pi-envia-tt-item-doc-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  tt-item-doc-est
  Notes:Esta procedure tem por objetivo enviar a tt-item-doc-est para um programa 
        upc espec°fico para a TCA, neste programa upc s∆o cadastradas todas informaá‰es
        na tt-item-doc-est para efetuar o desembarque, a upc Ç rodada antes da abertura
        deste programa.
        Favor n∆o eliminar esta procedure.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER table FOR tt-item-doc-est.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtroEmbarques wWindow 
PROCEDURE pi-filtroEmbarques :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    IF  CAN-FIND(FIRST tt-item-doc-est) THEN DO:
        RUN imp/im0100a1.w PERSISTENT SET h-im0100a1 (INPUT  THIS-PROCEDURE, 
                                                      INPUT  TABLE tt-item-doc-est /*,
                                                      OUTPUT TABLE ttEmbarque*/ ).

        IF  VALID-HANDLE (h-im0100a1) THEN DO:
            RUN initializeInterface IN h-im0100a1.
            WAIT-FOR CLOSE OF h-im0100a1 FOCUS CURRENT-WINDOW.
        END. /* IF  VALID-HANDLE (h-im0100a1) */
    END. /* IF  CAN-FIND(FIRST tt-item-doc-est) */
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui wWindow 
PROCEDURE pi-inclui :
/*
    ** Cria um novo registro na tt-item-doc-est, com o lote, dt-val-lote e refer vazios e
    ** o campo quantidade com o saldo que falta informar
    */

    /* 
    ** Verifica se algum registro foi selecionado no browse, se for atualiza
    ** o numero da ordem e a sequencia em i-num-ordem e i-seq.
    ** Pergunta ao usu†rio se tem certeza que deseja excluir o registro 
    */

    if browse-1:num-selected-rows in frame fPage1 = 0 then do:
        /* Para a execuá∆o do processo dever  ser selecionado um registro. */
        run utp/ut-msgs.p (input "show":U,
                           input 16595,
                           input "":U).
    end.

    if browse-1:num-selected-rows in frame fPage1 <> 0 then do:
        browse browse-1:fetch-selected-row(int(browse-1:num-selected-rows)).
        assign i-num-ordem = tt-item-doc-est.numero-ordem
               i-seq       = tt-item-doc-est.sequencial.
    end.

    for each tt-item-doc-est-aux no-lock:
        delete tt-item-doc-est-aux.
    end.

    FOR EACH b-tt-item-doc-est WHERE
             b-tt-item-doc-est.numero-ordem = i-num-ordem AND
             b-tt-item-doc-est.parcela      = i-parc:
             ASSIGN de-quant-tot = de-quant-tot + b-tt-item-doc-est.quantidade.
    END.

    ASSIGN de-quant-a-informar = (tt-recebe.quantidade-a-informar + tt-recebe.quantidade-informada) - de-quant-tot
           de-quant-tot = 0.

    find last b-tt-item-doc-est 
      where b-tt-item-doc-est.numero-ordem = i-num-ordem
        and b-tt-item-doc-est.parcela      = i-parc no-lock no-error.
    if avail b-tt-item-doc-est then do:
        find first tt-item-doc-est
           where tt-item-doc-est.numero-ordem = i-num-ordem
             and tt-item-doc-est.parcela      = i-parc no-error.
        if  avail tt-item-doc-est then do:

            create tt-item-doc-est-aux.            
            assign tt-item-doc-est-aux.numero-ordem       = tt-item-doc-est.numero-ordem
                   tt-item-doc-est-aux.parcela            = tt-item-doc-est.parcela 
                   tt-item-doc-est-aux.it-codigo          = tt-item-doc-est.it-codigo
                   tt-item-doc-est-aux.nr-proc-imp        = tt-item-doc-est.nr-proc-imp 
                   tt-item-doc-est-aux.quantidade         = de-quant-a-informar /*tt-recebe.quantidade-a-informar*/
                   tt-item-doc-est-aux.lote               = ""
                   tt-item-doc-est-aux.dt-vali-lote       = ?
                   tt-item-doc-est-aux.cod-refer          = ""
                   tt-item-doc-est-aux.tipo-con-est       = tt-item-doc-est.tipo-con-est
                   tt-item-doc-est-aux.encerra-pa         = tt-item-doc-est.encerra-pa
                   tt-item-doc-est-aux.sequencial         = b-tt-item-doc-est.sequencial + 1
                   tt-item-doc-est-aux.r-rowid            = tt-item-doc-est.r-rowid
                   tt-item-doc-est-aux.class-fiscal       = tt-item-doc-est.class-fiscal
                   tt-item-doc-est-aux.nr-ato-concessorio = tt-item-doc-est.nr-ato-concessorio
                   tt-item-doc-est-aux.preco-total        = (tt-item-doc-est.preco-total
                                                          / tt-item-doc-est.quantidade)
                                                          * tt-recebe.quantidade-a-informar
                   tt-item-doc-est-aux.preco-total        = (tt-item-doc-est.preco-total-mo
                                                          / tt-item-doc-est.quantidade)
                                                          * tt-recebe.quantidade-a-informar
                   tt-item-doc-est-aux.num-pedido         = tt-item-doc-est.num-pedido
                   tt-item-doc-est-aux.tp-despesa         = tt-item-doc-est.tp-despesa
                   tt-item-doc-est-aux.cod-depos          = tt-item-doc-est.cod-depos
                   tt-item-doc-est-aux.l-regime           = tt-item-doc-est.l-regime
                   tt-item-doc-est-aux.aliquota-ipi       = tt-item-doc-est.aliquota-ipi
                   tt-item-doc-est-aux.un                 = tt-item-doc-est.un
                   tt-item-doc-est-aux.un-fornec          = tt-item-doc-est.un-fornec
                   de-quant-a-informar = 0

                   tt-item-doc-est-aux.peso-liquido       = tt-item-doc-est.peso-liquido
                   tt-item-doc-est-aux.peso-bruto         = tt-item-doc-est.peso-bruto
                   tt-item-doc-est-aux.l-ordens-embarque  = tt-item-doc-est.l-ordens-embarque
                   tt-item-doc-est-aux.cd-trib-ii         = tt-item-doc-est.cd-trib-ii    
                   tt-item-doc-est-aux.cd-trib-ipi        = tt-item-doc-est.cd-trib-ipi   
                   tt-item-doc-est-aux.cd-trib-icms       = tt-item-doc-est.cd-trib-icms  
                   tt-item-doc-est-aux.aliquota-ii        = tt-item-doc-est.aliquota-ii   
                   tt-item-doc-est-aux.aliquota-icms      = tt-item-doc-est.aliquota-icms.      
           
            run atualizaQtdeDoForn in h-bocx220c (input  tt-item-doc-est-aux.quantidade,
                                                  input  i-num-ordem,
                                                  input  c-item,
                                                  output d-qtd-do-forn).

            assign tt-item-doc-est-aux.qtd-do-forn = d-qtd-do-forn.
        end.
    end.

    find first tt-item-doc-est-aux no-error.
    if avail tt-item-doc-est-aux then do:
          create tt-item-doc-est.
          assign tt-item-doc-est.numero-ordem       = tt-item-doc-est-aux.numero-ordem
                 tt-item-doc-est.parcela            = tt-item-doc-est-aux.parcela
                 tt-item-doc-est.it-codigo          = tt-item-doc-est-aux.it-codigo
                 tt-item-doc-est.nr-proc-imp        = tt-item-doc-est-aux.nr-proc-imp                        
                 tt-item-doc-est.quantidade         = tt-item-doc-est-aux.quantidade     
                 tt-item-doc-est.qtd-do-forn        = tt-item-doc-est-aux.qtd-do-forn
                 tt-item-doc-est.un-fornec          = tt-item-doc-est-aux.un-fornec
                 tt-item-doc-est.un                 = tt-item-doc-est-aux.un
                 tt-item-doc-est.lote               = tt-item-doc-est-aux.lote                  
                 tt-item-doc-est.dt-vali-lote       = tt-item-doc-est-aux.dt-vali-lote  
                 tt-item-doc-est.cod-refer          = tt-item-doc-est-aux.cod-refer           
                 tt-item-doc-est.tipo-con-est       = tt-item-doc-est-aux.tipo-con-est
                 tt-item-doc-est.encerra-pa         = tt-item-doc-est-aux.encerra-pa
                 tt-item-doc-est.sequencial         = tt-item-doc-est-aux.sequencial 
                 tt-item-doc-est.r-rowid            = tt-item-doc-est-aux.r-rowid
                 tt-item-doc-est.class-fiscal       = tt-item-doc-est-aux.class-fiscal
                 tt-item-doc-est.nr-ato-concessorio = tt-item-doc-est-aux.nr-ato-concessorio
                 tt-item-doc-est.preco-total        = tt-item-doc-est-aux.preco-total
                 tt-item-doc-est.preco-total-mo     = tt-item-doc-est-aux.preco-total-mo
                 tt-item-doc-est.num-pedido         = tt-item-doc-est-aux.num-pedido
                 tt-item-doc-est.tp-despesa         = tt-item-doc-est-aux.tp-despesa
                 tt-item-doc-est.cod-depos          = tt-item-doc-est-aux.cod-depos
                 tt-item-doc-est.l-regime           = tt-item-doc-est-aux.l-regime
                 tt-item-doc-est.aliquota-ipi       = tt-item-doc-est-aux.aliquota-ipi
                 tt-item-doc-est.peso-liquido       = tt-item-doc-est-aux.peso-liquido
                 tt-item-doc-est.peso-bruto         = tt-item-doc-est-aux.peso-bruto
                 tt-item-doc-est.l-ordens-embarque  = tt-item-doc-est-aux.l-ordens-embarque
                 tt-item-doc-est.cd-trib-ii         = tt-item-doc-est-aux.cd-trib-ii    
                 tt-item-doc-est.cd-trib-ipi        = tt-item-doc-est-aux.cd-trib-ipi   
                 tt-item-doc-est.cd-trib-icms       = tt-item-doc-est-aux.cd-trib-icms  
                 tt-item-doc-est.aliquota-ii        = tt-item-doc-est-aux.aliquota-ii   
                 tt-item-doc-est.aliquota-icms      = tt-item-doc-est-aux.aliquota-icms.  
          
    end.

    find tt-recebe 
        where tt-recebe.numero-ordem = i-num-ordem 
          and tt-recebe.parcela      = i-parc 
          no-error.
    if avail tt-recebe then
        assign tt-recebe.verifica-quantidade = no.

    for each tt-item-doc-est-aux no-lock:
        delete tt-item-doc-est-aux.
    end.

    disable bt-inclui 
        with frame fpage1.
    enable btUpdateSon1 
        with frame fpage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-ttEmbarque wWindow 
PROCEDURE pi-monta-ttEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER table FOR ttEmbarque.

    /* verifica o que foi filtrado */
    FOR EACH ttEmbarque:
        FOR EACH tt-item-doc-est: 
            IF fnEmbarque(tt-item-doc-est.numero-ordem, tt-item-doc-est.parcela) = ttEmbarque.embarque THEN
                ASSIGN tt-item-doc-est.l-selecionado = ttEmbarque.marcado.
        END.
    END.

    {&OPEN-QUERY-BROWSE-1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-tt-item-doc-est wWindow 
PROCEDURE pi-recebe-tt-item-doc-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  tt-item-doc-est
  Notes:Esta procedure tem por objetivo receber a tt-item-doc-est de um programa 
        upc espec°fico para a TCA, neste programa upc s∆o cadastradas todas informaá‰es
        na tt-item-doc-est para efetuar o desembarque, a upc Ç rodada antes da abertura
        deste programa.
        Favor n∆o eliminar esta procedure.       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER table FOR tt-item-doc-est.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-quantidade wWindow 
FUNCTION fn-quantidade RETURNS DECIMAL
  (/* parameter*/):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmbarque wWindow 
FUNCTION fnEmbarque RETURNS CHARACTER
  (pnumero-ordem AS INTEGER, pparcela AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR c-return    AS CHARACTER NO-UNDO.
    DEF VAR cembarque   AS CHARACTER NO-UNDO.

    RUN FindOrdensEmbarque IN h-bocx225na (INPUT pnumero-ordem, INPUT pparcela, OUTPUT c-return).
    IF  c-return = "" THEN 
        RUN getCharField IN h-bocx225na ("embarque":U, OUTPUT cembarque).
    ELSE 
        ASSIGN cembarque = "".
    
    RETURN cembarque.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

