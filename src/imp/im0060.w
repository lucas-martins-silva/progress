&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item
       field r-rowid as rowid
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0060 2.00.00.070 } /*** "010070" 10/07/2026 16:52:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0060 MIM}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0060
&GLOBAL-DEFINE Version        2.00.00.070

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE FolderLabels   Importa‡Æo

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-cotacao-item
&GLOBAL-DEFINE hDBOTable      hDBOCotacao-itemi
&GLOBAL-DEFINE DBOTable       cotacao-item

&GLOBAL-DEFINE page0KeyFields tt-cotacao-item.numero-ordem ~
                              tt-cotacao-item.cod-emitente ~
                              tt-cotacao-item.it-codigo ~
                              tt-cotacao-item.seq-cotac
&GLOBAL-DEFINE page0Fields    i-mapa-cotacao ~
                              c-cod-incoterm ~
                              i-cod-pto-contr ~
                              i-cod-fabricante ~
                              i-cdn-pais-orig ~
                              c-class-fiscal ~
                              c-nbs ~
                              i-regime-import ~
                              de-aliq-ii ~
                              tg-ex-tarifario ~
                              de-aliq-ipi ~
                              i-cod-itiner ~
                              tt-cotacao-item.log-gerac-autom-despes
                                                            
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable}         as handle no-undo.
define variable hDBOEmitente         as handle no-undo.
define variable hDBOCotacao-item-cex as handle no-undo.
define variable hDBOPto-contr        as handle no-undo.
define variable hDBOItem             as handle no-undo.
define variable hDBOCotacao-item     as handle no-undo.
define variable hDBOOrdem-compra     as handle no-undo.
define variable hDBOInco-cx          as handle no-undo.
define variable hDBOItiner           as handle no-undo.
define variable hDBOParam-imp        as handle no-undo.
define variable h-boin046            as handle no-undo.
define variable h-boun006            as handle no-undo.
define variable h-bocx319            as handle no-undo.
define variable h-bodi01157          as handle no-undo.

def new global shared var gr-ordem-compra           as rowid no-undo.
def new global shared var gr-cotacao-item-cex       as rowid no-undo.
def new global shared var gr-cotacao-item-i         as rowid no-undo. 
def new global shared var gc-opcao-im0060           as char  no-undo.

def new global shared var is-cod-itiner             as int   no-undo.

def new global shared var gi-numero-ordem-i         like ordem-compra.numero-ordem no-undo.
def new global shared var gi-cod-emitente-i         like emitente.cod-emitente     no-undo.
def new global shared var gc-it-codigo-i            like item.it-codigo            no-undo.
def new global shared var gi-seq-cotac-i            like cotacao-item.seq-cotac    no-undo.
def new global shared var gi-num-pedido-i           like pedido-compr.num-pedido   no-undo.
def new global shared var gl-returnok               as   logical                   no-undo.
def new global shared var gc-char-1                 like cotacao-item.char-1       no-undo.
def new global shared var gc-char-2                 like cotacao-item.char-2       no-undo.
def new global shared var gi-cdn-pais-orig-i        as integer format ">>,>>9":U   no-undo.

def new global shared var v-int-1                   as integer                     no-undo.
def new global shared var gda-entrega-embarque      as date                        no-undo.
DEF NEW GLOBAL SHARED VAR gc-ex-tarifario           AS CHARACTER                   NO-UNDO.

def new global shared var l-mudou-valores           as logical init no             no-undo.
def new global shared var gl-regime-i               as logical                     no-undo.
def new global shared var gde-aliquota-ipi-i        as decimal                     no-undo.
DEF NEW GLOBAL SHARED VAR gl-log-gerac-autom-despes AS LOGICAL                     NO-UNDO.

/* Vari veis */
def var i-tipo-contr         as integer no-undo.
def var i-numero-ordem       as integer no-undo.
def var i-informa            as integer no-undo.
def var c-cod-estabel        as char    no-undo.
def var h-bocx155            as handle  no-undo.
def var c-return             as char    no-undo.
def var i-cont               as integer no-undo.
def var h-bofi013            as handle  no-undo.
def var c-return-emit-cex    as char    no-undo.
def var c-return-incoterm    as char    no-undo.
def var i-regime-import-ant  as integer no-undo.
def var c-class-fiscal-ant   as char    no-undo.
def var i-cdn-pais-orig-ant  as integer no-undo.
def var de-aliq-ipi-ant      as decimal no-undo.
DEF VAR l-param-imp          AS LOGICAL NO-UNDO.
DEF VAR l-gerac-cotac-despes-impto AS LOGICAL NO-UNDO.
DEF VAR i-cod-itinerario     AS INTEGER NO-UNDO.
DEF VAR c-char-2             AS CHARACTER NO-UNDO.
DEF VAR c-char-1             AS CHARACTER NO-UNDO.
DEF VAR l-im0010             AS LOGICAL   NO-UNDO.
DEF VAR i-mapa               LIKE cotacao-item-cex.mapa-cotacao NO-UNDO.
DEF VAR c-nbs-aux            as char no-undo.

/* Includes */
{cdp/cd4300.i3}
{include/boerrtab.i}
{cdp/cdcfgmat.i} /*Defini‡Æo dos pre-processadores*/
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/
{utp/ut-glob.i}

/* Temp-tables */
{inbo/boin082i.i tt-cotacao-imp}    /* Defini‡Æo temp-table auxiliar (importa‡Æo) */
{inbo/boin082.i  tt-cotacao-item-i} /* Defini‡Æo temp-table auxiliar (importa‡Æo) */

/* Pesquisa */
define new global shared variable adm-broker-hdl as handle no-undo.
define variable wh-pesquisa as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cotacao-item.numero-ordem ~
tt-cotacao-item.cod-emitente tt-cotacao-item.it-codigo ~
tt-cotacao-item.seq-cotac tt-cotacao-item.log-gerac-autom-despes 
&Scoped-define ENABLED-TABLES tt-cotacao-item
&Scoped-define FIRST-ENABLED-TABLE tt-cotacao-item
&Scoped-Define ENABLED-OBJECTS rtKeys rtKeys-2 rtToolBar btUpdate btUndo ~
btCancel btSave bt-desp-imp btQueryJoins btReportsJoins btExit btHelp ~
c-nome-abrev1 l-cot-aprovada i-mapa-cotacao c-cod-incoterm i-cod-pto-contr ~
c-descricao i-cod-fabricante c-nome-abrev2 i-cdn-pais-orig c-class-fiscal ~
c-nbs i-regime-import de-aliq-ii tg-ex-tarifario de-aliq-ipi i-cod-itiner ~
c-itinerario 
&Scoped-Define DISPLAYED-FIELDS tt-cotacao-item.numero-ordem ~
tt-cotacao-item.cod-emitente tt-cotacao-item.it-codigo ~
tt-cotacao-item.seq-cotac tt-cotacao-item.log-gerac-autom-despes 
&Scoped-define DISPLAYED-TABLES tt-cotacao-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-cotacao-item
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev1 l-cot-aprovada ~
i-mapa-cotacao c-cod-incoterm i-cod-pto-contr c-descricao i-cod-fabricante ~
c-nome-abrev2 i-cdn-pais-orig c-desc-cdn-pais-orig c-class-fiscal ~
c-desc-class-fiscal c-nbs c-desc-nbs i-regime-import c-desc-regime ~
de-aliq-ii tg-ex-tarifario de-aliq-ipi i-cod-itiner c-itinerario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
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
DEFINE BUTTON bt-desp-imp 
     IMAGE-UP FILE "image\im-orcto":U
     LABEL "Despesas de Importa‡Æo" 
     SIZE 4 BY 1.25 TOOLTIP "Despesas de Importa‡Æo".

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-class-fiscal AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "Classifica‡Æo Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cdn-pais-orig AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-class-fiscal AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nbs AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-regime AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-itinerario AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-nbs AS CHARACTER FORMAT "X(256)" 
     LABEL "NBS" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev1 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev2 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ii AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Al¡quota Imposto de Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ipi AS DECIMAL FORMAT ">>9.99" INITIAL 10 
     LABEL "Al¡quota IPI":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-cdn-pais-orig AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Pa¡s de Origem" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fabricante AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Ponto de Controle Base" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-mapa-cotacao AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mapa de Cota‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-regime-import AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Regime Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.38.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-cot-aprovada AS LOGICAL INITIAL no 
     LABEL "Cota‡Æo Aprovada" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE tg-ex-tarifario AS LOGICAL INITIAL no 
     LABEL "Ex-Tarif rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     bt-desp-imp AT ROW 1.13 COL 69.72
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-cotacao-item.numero-ordem AT ROW 2.75 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-cotacao-item.cod-emitente AT ROW 3.75 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-abrev1 AT ROW 3.75 COL 49.43 COLON-ALIGNED NO-LABEL
     tt-cotacao-item.it-codigo AT ROW 4.75 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-cotacao-item.seq-cotac AT ROW 5.75 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     l-cot-aprovada AT ROW 5.75 COL 45.29
     i-mapa-cotacao AT ROW 7 COL 38 COLON-ALIGNED HELP
          "Mapa de cota‡Æo de despesas."
     c-cod-incoterm AT ROW 8 COL 38 COLON-ALIGNED HELP
          "Incoterm."
     i-cod-pto-contr AT ROW 9 COL 38 COLON-ALIGNED HELP
          "Ponto de controle base."
     c-descricao AT ROW 9 COL 45.29 COLON-ALIGNED NO-LABEL
     i-cod-fabricante AT ROW 10 COL 38 COLON-ALIGNED HELP
          "Fabricante do material no exterior."
     c-nome-abrev2 AT ROW 10 COL 49.29 COLON-ALIGNED NO-LABEL
     i-cdn-pais-orig AT ROW 11 COL 38 COLON-ALIGNED
     c-desc-cdn-pais-orig AT ROW 11 COL 46 COLON-ALIGNED NO-LABEL
     c-class-fiscal AT ROW 12 COL 38 COLON-ALIGNED HELP
          "Classifica‡Æo fiscal do item."
     c-desc-class-fiscal AT ROW 12 COL 48.29 COLON-ALIGNED NO-LABEL
     c-nbs AT ROW 13 COL 38 COLON-ALIGNED HELP
          "NBS do item." WIDGET-ID 2
     c-desc-nbs AT ROW 13 COL 49.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     i-regime-import AT ROW 14 COL 38 COLON-ALIGNED HELP
          "Regime de importa‡Æo."
     c-desc-regime AT ROW 14 COL 42.29 COLON-ALIGNED NO-LABEL
     de-aliq-ii AT ROW 15 COL 38 COLON-ALIGNED HELP
          "Al¡quota do Imposto de Importa‡Æo."
     tg-ex-tarifario AT ROW 16 COL 40
     de-aliq-ipi AT ROW 16.75 COL 38 COLON-ALIGNED
     i-cod-itiner AT ROW 17.75 COL 38 COLON-ALIGNED
     c-itinerario AT ROW 17.75 COL 45.29 COLON-ALIGNED NO-LABEL
     tt-cotacao-item.log-gerac-autom-despes AT ROW 18.75 COL 40
          LABEL "Gera‡Æo Autom tica de Despesas"
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     rtKeys AT ROW 2.5 COL 1.29
     rtKeys-2 AT ROW 6.92 COL 1.29
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 18.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-cotacao-item T "?" NO-UNDO movind cotacao-item
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
         TITLE              = "Cota‡Æo do Item (Importa‡Æo)"
         HEIGHT             = 18.88
         WIDTH              = 90.43
         MAX-HEIGHT         = 20.29
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.29
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-cdn-pais-orig IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-class-fiscal IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-nbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-regime IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-cotacao-item.log-gerac-autom-despes IN FRAME fpage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Cota‡Æo do Item (Importa‡Æo) */
OR ENDKEY OF {&WINDOW-name} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:persistent then RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Cota‡Æo do Item (Importa‡Æo) */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desp-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desp-imp wMaintenance
ON CHOOSE OF bt-desp-imp IN FRAME fpage0 /* Despesas de Importa‡Æo */
DO:
    /* 
    ** Instƒnciar BO campo de tabela estrangeira (cotacao-item-cex)
    */ 
    {btb/btb008za.i1 cxbo/bocx085na.p YES}
    {btb/btb008za.i2 cxbo/bocx085na.p '' hDBOCotacao-item-cex}
    RUN openQueryStatic IN hDBOCotacao-item-cex (input "Main":U) no-error.
    
    IF i-mapa-cotacao = 0 THEN DO: /*a informa‡Æo do mapa da cota‡Æo somente ‚ 
                                    atualizada quando a mesma ‚ aprovada no im0010*/
        RUN piRetornaMapaCotacao in hDBOCotacao-item-cex (INPUT  tt-cotacao-item.numero-ordem,
                                                          INPUT  tt-cotacao-item.cod-emitente,
                                                          INPUT  tt-cotacao-item.it-codigo,
                                                          INPUT  tt-cotacao-item.seq-cotac,
                                                          INPUT  tt-cotacao-item.data-cotacao,
                                                          OUTPUT i-mapa).

        run findMapaCotacao in hDBOCotacao-item-cex (input tt-cotacao-item.numero-ordem,
                                                     input tt-cotacao-item.cod-emitente,
                                                     input tt-cotacao-item.it-codigo,
                                                     input tt-cotacao-item.seq-cotac,
                                                     input tt-cotacao-item.data-cotacao,
                                                     input i-mapa).
    END.
    ELSE
        run findMapaCotacao in hDBOCotacao-item-cex (input tt-cotacao-item.numero-ordem,
                                                     input tt-cotacao-item.cod-emitente,
                                                     input tt-cotacao-item.it-codigo,
                                                     input tt-cotacao-item.seq-cotac,
                                                     input tt-cotacao-item.data-cotacao,
                                                     input i-mapa-cotacao).
    run getRowid in hDBOCotacao-item-cex (output gr-cotacao-item-cex).
    run imp/im0010.w.
    ASSIGN l-im0010 = YES.
    RUN displayFields IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:

    disable i-mapa-cotacao
            c-cod-incoterm
            i-cod-pto-contr
            i-cod-fabricante
            i-regime-import
            c-class-fiscal
            c-nbs
            i-cdn-pais-orig
            de-aliq-ii
            tg-ex-tarifario
            btUndo
            btCancel
            btSave
            i-cod-itiner
            tt-cotacao-item.log-gerac-autom-despes
            with frame fPage0.
            
    enable  btUpdate
            bt-desp-imp    
            with frame fPage0.
            
    assign menu-item miUpdate:sensitive in MENU mbMain = yes
           menu-item miUndo:sensitive   in MENU mbMain = no
           menu-item miCancel:sensitive in MENU mbMain = no
           menu-item miSave:sensitive   in MENU mbMain = no.
           
    if  c-class-fiscal:screen-value = "" then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    else
        assign c-class-fiscal:format in frame {&frame-name} = "9999.99.99":U.

    if  c-nbs:screen-value = "" then
        assign c-nbs:format in frame {&frame-name} = "x(9)":U.
    else
        assign c-nbs:format in frame {&frame-name} = "9.9999.99.99":U.
        
    run displayFields in this-procedure.

    /* Para o internacional o campo de ex-tarif rio nÆo deve ser apresentado */
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN tg-ex-tarifario:HIDDEN IN FRAME {&frame-name} = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    def var c-return-value as char no-undo.

    for each tt-cotacao-imp:
        delete tt-cotacao-imp.
    end.    

    empty temp-table tt-bo-erro.

    /*
    ** Grava valores da tela
    */
    assign input frame fPage0 i-mapa-cotacao
                              c-cod-incoterm
                              i-cod-pto-contr
                              i-cod-fabricante
                              i-cdn-pais-orig
                              i-regime-import
                              c-class-fiscal
                              c-nbs
                              de-aliq-ii
                              tg-ex-tarifario
                              de-aliq-ipi
                              i-cod-itiner.

    /*
    ** Confirma Al¡quota do Imposto de Importa‡Æo = 0
    */ 
    if  de-aliq-ii = 0 then do:

        {utp/ut-liter.i Al¡quota_II_=_0_(Isento) mim L}
        run utp/ut-msgs.p (input "show":U,
                           input 701,
                           input trim(return-value)).
        if  return-value = "no":U then
            return no-apply.
    end.

    create tt-cotacao-imp.
    assign tt-cotacao-imp.numero-ordem   = tt-cotacao-item.numero-ordem
           tt-cotacao-imp.cod-emitente   = tt-cotacao-item.cod-emitente
           tt-cotacao-imp.it-codigo      = tt-cotacao-item.it-codigo
           tt-cotacao-imp.seq-cotac      = tt-cotacao-item.seq-cotac
           tt-cotacao-imp.mapa-cotacao   = i-mapa-cotacao
           tt-cotacao-imp.cod-incoterm   = c-cod-incoterm
           tt-cotacao-imp.cod-pto-contr  = i-cod-pto-contr
           tt-cotacao-imp.cod-fabricante = i-cod-fabricante
           tt-cotacao-imp.cdn-pais-orig  = i-cdn-pais-orig
           tt-cotacao-imp.regime-import  = i-regime-import
           tt-cotacao-imp.class-fiscal   = c-class-fiscal
           tt-cotacao-imp.aliq-ii        = de-aliq-ii
           tt-cotacao-imp.aliq-ipi       = de-aliq-ipi
           tt-cotacao-imp.cod-itiner     = i-cod-itiner
           tt-cotacao-imp.i-informa      = i-informa
           tt-cotacao-imp.da-entrega-embarque = gda-entrega-embarque
           tt-cotacao-imp.nbs            = c-nbs.

    IF tg-ex-tarifario:CHECKED IN FRAME fPage0 THEN
        ASSIGN tt-cotacao-imp.l-ex-tarifario = YES.
    ELSE
        ASSIGN tt-cotacao-imp.l-ex-tarifario = NO.
    
    run setUsuario in hDBOCotacao-itemi (input c-seg-usuario).
    
    if  gc-opcao-im0060 = "create":U then do:

        if  gi-num-pedido-i <> 0 then do:
            FOR EACH tt-bo-erro:
                DELETE tt-bo-erro.
            END.
            
            run validateIncotermPedido in hDBOCotacao-itemi (input gi-num-pedido-i,
                                                             input tt-cotacao-imp.numero-ordem,
                                                             input tt-cotacao-imp.cod-incoterm,
                                                             output table tt-bo-erro append).
            assign c-return-value = return-value.                                                             
        end.

        if  c-return-value <> "NOK":U  THEN DO: 
            FOR EACH tt-bo-erro:
                DELETE tt-bo-erro.
            END.
            run validateCreateImp in hDBOCotacao-itemi (input table tt-cotacao-item,
                                                        input table tt-cotacao-imp,
                                                        output table tt-bo-erro append).  
        END.
    end.
    else do:
        FOR EACH tt-bo-erro:
            DELETE tt-bo-erro.
        END.
        run validateUpdateImp in hDBOCotacao-itemi (input table tt-cotacao-imp,
                                                    input tt-cotacao-item.r-rowid,
                                                    output table tt-bo-erro append).
    end.
   
    assign c-return-value = return-value.
    
    if can-find(first tt-bo-erro) then do:

        if  not valid-handle(hShowMsg) then
            run utp/showmessage.w persistent set hShowMsg.            

        run showMessages IN hShowMsg (input table tt-bo-erro).

        if c-return-value = "NOK":U and can-find(first tt-bo-erro where
                                                       tt-bo-erro.ErrorSubType <> "WARNING") then do:
            return "NOK":U. 
        end.
    end.
    
    /*  
    ** Tratamento regime de importa‡Æo/al¡quota do ipi
    */
    if  tt-cotacao-imp.regime-import <> 0 then 
        assign gl-regime-i = yes.
    else
        assign gl-regime-i = no.
    
    disable i-mapa-cotacao
            c-cod-incoterm
            i-cod-pto-contr
            i-cod-fabricante
            i-regime-import
            c-class-fiscal
            c-nbs
            i-cdn-pais-orig
            de-aliq-ii
            tg-ex-tarifario
            i-cod-itiner
            btUndo
            btCancel
            btSave
            tt-cotacao-item.log-gerac-autom-despes
            with frame fPage0.
            
    enable  btUpdate
            bt-desp-imp    
            with frame fPage0.
            
    assign menu-item miUpdate:sensitive in MENU mbMain = yes
           menu-item miUndo:sensitive   in MENU mbMain = no
           menu-item miCancel:sensitive in MENU mbMain = no
           menu-item miSave:sensitive   in MENU mbMain = no.
           
    if  gc-opcao-im0060 = "create":U then do:

        assign gl-returnok          = yes
               gc-opcao-im0060      = ""
               v-int-1              = tt-cotacao-imp.cod-itiner
               gi-cdn-pais-orig-i   = input frame fPage0 i-cdn-pais-orig
               gc-ex-tarifario      = IF tt-cotacao-imp.l-ex-tarifario THEN "1":U ELSE "":U. /*A informa‡Æo ‚ armazenada em vari vel global pois os dados de importa‡Æo do 
                                                                                               registro da tabela cotacao-item ‚ atualizado no banco pelo programa chamador*/

        if  tt-cotacao-imp.da-entrega-embarque = ? then
            tt-cotacao-imp.da-entrega-embarque = today.
        
        {ccp/cc9019.i50}
        assign i-mapa-cotacao-i50   = tt-cotacao-imp.mapa-cotacao
               c-cod-incoterm-i50   = tt-cotacao-imp.cod-incoterm
               i-cod-pto-contr-i50  = tt-cotacao-imp.cod-pto-contr
               c-class-fiscal-i50   = tt-cotacao-imp.class-fiscal
               de-aliq-ii-i50       = tt-cotacao-imp.aliq-ii
               c-nbs-i50            = tt-cotacao-imp.nbs.
        {ccp/cc9019.i51 "no"}
        {cdp/cd4300.i4 "no" gc-char-1}
        
        {ocp/oc0201.i50}
        assign i-regime-import-i50  = tt-cotacao-imp.regime-import
               i-cod-fabricante-i50 = tt-cotacao-imp.cod-fabricante
               c-data-base-i50      = string(tt-cotacao-imp.da-entrega-embarque).
        {ocp/oc0201.i51 "no"}
        {cdp/cd4300.i4 "no" gc-char-2}

        ASSIGN gl-log-gerac-autom-despes = tt-cotacao-item.log-gerac-autom-despes:CHECKED IN FRAME fPage0.
        
        apply "choose":U to btExit in frame fPage0.
    end.           

    if  c-return-value = "OK":U and can-find(first tt-bo-erro) then do:

        if not valid-handle(hShowMsg) then
            run utp/showmessage.w persistent set hShowMsg.
        
        run showMessages IN hShowMsg (input table tt-bo-erro).
    end.    

    if  de-aliq-ipi-ant <> input frame fPage0 de-aliq-ipi then do:

        assign l-mudou-valores    = yes
               gde-aliquota-ipi-i = input frame fPage0 de-aliq-ipi.

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Al¡quota_do_IPI" *}
        run utp/ut-msgs.p (input "show":U,
                           input 16159,
                           input RETURN-VALUE + "~~" +
                                 string(de-aliq-ipi-ant) + "~~" +
                                 string(input frame fPage0 de-aliq-ipi)).

        assign de-aliq-ipi-ant = input frame fPage0 de-aliq-ipi.
    end.

    if  c-class-fiscal:screen-value = "" then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    else
        assign c-class-fiscal:format in frame {&frame-name} = "9999.99.99":U.
        
    IF  REPLACE(c-nbs:screen-value,".","") <> ""
    AND LENGTH(REPLACE(c-nbs:screen-value,".","")) >= 9 THEN
        assign c-nbs:format in frame {&frame-name} = "9.9999.99.99":U.
    else 
        assign c-nbs:format in frame {&frame-name} = "x(9)":U.
        
    /*Chamada UPC*/
    {method/custom.i &Event="AFTER-SAVE-FIELDS"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="{&DBOTable}"
                     &RowidTable=?}

     IF VALID-HANDLE({&hDBOTable}) THEN DO:
         EMPTY TEMP-TABLE tt-bo-erro.

         RUN validateDespImp IN {&hDBOTable} (INPUT tt-cotacao-item.numero-ordem,
                                              INPUT tt-cotacao-item.cod-emitente, 
                                              INPUT tt-cotacao-item.it-codigo,    
                                              INPUT tt-cotacao-item.seq-cotac,
                                              OUTPUT TABLE tt-bo-erro).
        
         if  RETURN-VALUE = "NOK":U and can-find(first tt-bo-erro) then do:

              if not valid-handle(hShowMsg) then
                  run utp/showmessage.w persistent set hShowMsg.

              run showMessages IN hShowMsg (input table tt-bo-erro).
              RETURN "OK":U.
         end.    

     END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    apply "choose":U to btCancel in frame fPage0.
    apply "choose":U to btUpdate in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    run findPk-emitente in h-bocx155(input tt-cotacao-item.cod-emitente,output c-return-emit-cex).
    if  c-return-emit-cex <> "" then do:
        {utp/ut-table.i mgcex emitente-cex 1}
         run utp/ut-msgs.p (input "show",
                            input 2,
                            input return-value).
    end.
            
    enable  i-mapa-cotacao
            c-cod-incoterm
            i-cod-pto-contr
            i-cod-fabricante
            i-regime-import
            i-cdn-pais-orig
            de-aliq-ii
            tg-ex-tarifario
            btUndo
            btCancel
            btSave
            with frame fPage0.            
    
    /*
    ** Habilita classifica‡Æo fiscal quando item for branco e d‚bito direto
    */            
    run gotoKey in hDBOItem (input tt-cotacao-item.it-codigo:screen-value in frame fPage0).
    run getIntfield in hDBOItem (input "tipo-contr":U, output i-tipo-contr).
    if  i-tipo-contr = 4 then
        enable c-class-fiscal c-nbs with frame fPage0.
    
    /*
    ** Habilita c¢digo do itiner rio quando parƒmetros estiver para informa Data do Embarque
    */
    assign i-informa = 0.

    run gotoKey in hDBOOrdem-compra (input integer(tt-cotacao-item.numero-ordem:screen-value in frame fPage0)).
    if  return-value = "OK":U then
        run getCharfield in hDBOOrdem-compra (input "cod-estabel":U,output c-cod-estabel).

    run gotoKey in hDBOParam-imp (input c-cod-estabel).
    if  return-value = "OK":U THEN DO:
        run getIntfield in hDBOParam-imp (input "int-1":U,output i-informa).
        ASSIGN l-param-imp = YES.
    END.
    
    if  i-informa = 2 or
        i-informa = 3 then
        enable i-cod-itiner with frame fPage0.
            
    disable btUpdate
            bt-Desp-imp
            with frame fPage0.
            
    assign menu-item miUpdate:sensitive in menu mbMain = no
           menu-item miUndo:sensitive   in menu mbMain = yes
           menu-item miCancel:sensitive in menu mbMain = yes
           menu-item miSave:sensitive   in menu mbMain = yes
           gl-regime-i                                 = no.
    
    apply "entry":U to i-mapa-cotacao in frame fPage0.
    
    if  gc-opcao-im0060 = "create":U then do:
        disable i-mapa-cotacao with frame fPage0.                    
        apply "entry":U to c-cod-incoterm in frame fPage0.
    end.

    if  c-class-fiscal:screen-value <> "" then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
        
    if  c-nbs:screen-value <> "" then
        assign c-nbs:format in frame {&frame-name} = "x(9)":U.
        
    /*Chamada UPC*/
    {method/custom.i &Event="AFTER-ENABLE-FIELDS"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="{&DBOTable}"
                     &RowidTable=?}

    /*Fim chamada UPC*/

    /* Para o internacional o campo de ex-tarif rio nÆo deve ser apresentado */
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN tg-ex-tarifario:HIDDEN IN FRAME {&frame-name} = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenance
ON ENTRY OF c-class-fiscal IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    if  c-class-fiscal:screen-value = "" then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    else
        assign c-class-fiscal:format in frame {&frame-name} = "9999.99.99":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenance
ON F5 OF c-class-fiscal IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    {include/zoomvar.i &prog-zoom  = inzoom/z01in046.w
                       &campo      = c-class-fiscal
                       &campozoom  = class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenance
ON LEAVE OF c-class-fiscal IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    
    if  error-status:get-number(1) <> 0 then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    else
        assign c-class-fiscal:format in frame {&frame-name} = "9999.99.99":U.

    do  i-cont = 1 to length(c-class-fiscal:screen-value in frame {&frame-name}):
        if  substr(c-class-fiscal:screen-value in frame {&frame-name},i-cont,1) = "" then
            assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    end.
 
    {method/referencefields.i &HandleDBOLeave="h-boin046" 
                              &KeyValue1="input frame fPage0 c-class-fiscal"
                              &Fieldname1="descricao" 
                              &FieldScreen1="c-desc-class-fiscal"
                              &frame1="fPage0"} 
                              
    if  c-class-fiscal-ant <> input frame fPage0 c-class-fiscal then do:

        assign c-class-fiscal-ant = input frame fPage0 c-class-fiscal.

        /* Busca o regime de importacao padrao */
        run buscaRegimePadrao in h-bocx319 (input  input frame fPage0 i-cdn-pais-orig,
                                            input  input frame fPage0 c-class-fiscal, 
                                            output i-regime-import).
        /* Busca aliquotas II e IPI */
        run calculateII_IPI in hDBOCotacao-itemi (input  tt-cotacao-item.it-codigo,   
                                                  input  tt-cotacao-item.numero-ordem,
                                                  input  tt-cotacao-item.aliquota-ipi,
                                                  input  input frame fPage0 c-class-fiscal,              
                                                  input  input frame fPage0 i-cdn-pais-orig,             
                                                  input  input frame fPage0 i-regime-import,             
                                                  output de-aliq-ii, 
                                                  output de-aliq-ipi).

        disp i-regime-import de-aliq-ii de-aliq-ipi with frame fPage0.
        apply "leave":U to i-regime-import in frame fPage0.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-class-fiscal IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    apply "f5":U to self in frame fPage0.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-incoterm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm wMaintenance
ON F5 OF c-cod-incoterm IN FRAME fpage0 /* Incoterm */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z10cx025.w"
                         &FieldZoom1="cod-incoterm"
                         &FieldScreen1="c-cod-incoterm"
                         &frame1="fPage0"
                         &RunMethod="RUN setConstraintMain IN hDBOInco-cx."
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-cod-incoterm IN FRAME fpage0 /* Incoterm */
DO:
    apply "f5":U to self in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenance
ON F5 OF c-nbs IN FRAME fpage0 /* NBS */
DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di01157.w"
                         &FieldZoom1="cod-nbs"
                         &FieldScreen1="c-nbs"
                         &Frame1="fpage0"
                         &FieldZoom2="desc-nbs"
                         &FieldScreen2="c-desc-nbs"
                         &Frame2="fpage0"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenance
ON LEAVE OF c-nbs IN FRAME fpage0 /* NBS */
DO:
    DEF VAR c-nbs-limpo AS CHAR NO-UNDO.
        
    ASSIGN c-nbs-limpo = REPLACE(c-nbs:SCREEN-VALUE IN FRAME fpage0,".","").

    IF  REPLACE(c-nbs:SCREEN-VALUE IN FRAME fpage0,".","") <> ""
    AND LENGTH(REPLACE(c-nbs:SCREEN-VALUE IN FRAME fpage0,".","")) >= 9 THEN
       ASSIGN c-nbs:FORMAT IN FRAME fpage0 = "9.9999.99.99" NO-ERROR.
    ELSE 
       ASSIGN c-nbs:FORMAT IN FRAME fpage0 = "x(9)" NO-ERROR.
              
    {method/referencefields.i &HandleDBOLeave="h-bodi01157"
                              &KeyValue1="c-nbs-limpo"
                              &FieldName1="desc-nbs"
                              &FieldScreen1="c-desc-nbs"
                              &Frame1="fpage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-nbs IN FRAME fpage0 /* NBS */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cotacao-item.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cotacao-item.cod-emitente wMaintenance
ON LEAVE OF tt-cotacao-item.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    {method/referencefields.i &HandleDBOLeave="hDBOEmitente"
                              &KeyValue1="tt-cotacao-item.cod-emitente"
                              &Fieldname1="nome-abrev"
                              &FieldScreen1="c-nome-abrev1"
                              &frame1="fPage0"}
                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-pais-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-pais-orig wMaintenance
ON F5 OF i-cdn-pais-orig IN FRAME fpage0 /* Pa¡s de Origem */
DO:

    {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                       &campozoom="cod-pais"
                       &campo="i-cdn-pais-orig"
                       &campozoom2="nome-pais"              
                       &campo2="c-desc-cdn-pais-orig"                 
                       &frame="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-pais-orig wMaintenance
ON LEAVE OF i-cdn-pais-orig IN FRAME fpage0 /* Pa¡s de Origem */
DO:
    
    {method/referencefields.i &HandleDBOLeave="h-boun006"
                              &KeyValue1="i-cdn-pais-orig:screen-value in frame fPage0"
                              &FindMethod="findCh_pais"
                              &Fieldname1="nome-pais"
                              &FieldScreen1="c-desc-cdn-pais-orig"
                              &frame1="fPage0"}
                              
    if  i-cdn-pais-orig-ant <> input frame fPage0 i-cdn-pais-orig then do:

        assign i-cdn-pais-orig-ant = input frame fPage0 i-cdn-pais-orig.

        /* Busca o regime de importacao padrao */
        run buscaRegimePadrao in h-bocx319 (input  input frame fPage0 i-cdn-pais-orig,
                                            input  input frame fPage0 c-class-fiscal, 
                                            output i-regime-import).

        /* Busca aliquotas II e IPI */
        run calculateII_IPI in hDBOCotacao-itemi (input  tt-cotacao-item.it-codigo,   
                                                  input  tt-cotacao-item.numero-ordem,
                                                  input  tt-cotacao-item.aliquota-ipi,
                                                  input  input frame fPage0 c-class-fiscal,              
                                                  input  input frame fPage0 i-cdn-pais-orig,             
                                                  input  input frame fPage0 i-regime-import,             
                                                  output de-aliq-ii, 
                                                  output de-aliq-ipi).

        disp i-regime-import de-aliq-ii de-aliq-ipi with frame fPage0.
        apply "leave":U to i-regime-import in frame fPage0.
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-pais-orig wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cdn-pais-orig IN FRAME fpage0 /* Pa¡s de Origem */
DO:
   apply "f5":U to self in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-fabricante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fabricante wMaintenance
ON F5 OF i-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:
    assign l-implanta = no.

    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="i-cod-fabricante"   
                       &campozoom="cod-emitente"              
                       &frame="fPage0"
                       &campo2="c-nome-abrev2"
                       &campozoom2="nome-abrev"
                       &frame2="fPage0"}                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fabricante wMaintenance
ON LEAVE OF i-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:
    {method/referencefields.i &HandleDBOLeave="hDBOEmitente"
                              &KeyValue1="integer(i-cod-fabricante:screen-value in frame fPage0)"
                              &Fieldname1="nome-abrev"
                              &FieldScreen1="c-nome-abrev2"
                              &frame1="fPage0"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fabricante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:
    apply "f5":U to self in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner wMaintenance
ON F5 OF i-cod-itiner IN FRAME fpage0 /* Itiner rio */
DO:
    assign l-implanta = no.

    {include/zoomvar.i &prog-zoom="cxzoom/z01cx115.w"
                       &campo="i-cod-itiner"
                       &campozoom="cod-itiner"
                       &frame="fPage0"
                       &campo2="c-itinerario"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner wMaintenance
ON LEAVE OF i-cod-itiner IN FRAME fpage0 /* Itiner rio */
DO:
    {method/referencefields.i &HandleDBOLeave="hDBOItiner"
                              &KeyValue1="integer(i-cod-itiner:screen-value in frame fPage0)"
                              &Fieldname1="descricao"
                              &FieldScreen1="c-itinerario"
                              &frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-itiner IN FRAME fpage0 /* Itiner rio */
DO:
    apply "f5":U to self in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wMaintenance
ON F5 OF i-cod-pto-contr IN FRAME fpage0 /* Ponto de Controle Base */
DO:

    if integer(i-cod-itiner:screen-value in frame fPage0) <> 0 then
        assign is-cod-itiner = integer(i-cod-itiner:screen-value in frame fPage0).
    {include/zoomvar.i &prog-zoom = cxzoom/z01cx120.w
                       &campo     = i-cod-pto-contr
                       &campozoom = cod-pto-contr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wMaintenance
ON LEAVE OF i-cod-pto-contr IN FRAME fpage0 /* Ponto de Controle Base */
DO:
    {method/referencefields.i &HandleDBOLeave="hDBOPto-contr"
                              &KeyValue1="integer(i-cod-pto-contr:screen-value in frame fPage0)"
                              &Fieldname1="descricao"
                              &FieldScreen1="c-descricao"
                              &frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-pto-contr IN FRAME fpage0 /* Ponto de Controle Base */
DO:
    apply "f5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-regime-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-regime-import wMaintenance
ON F5 OF i-regime-import IN FRAME fpage0 /* Regime Importa‡Æo */
DO:

    if  c-class-fiscal:sensitive in frame fPage0 = yes then do:
        /* Para itens debito direto retorna tambem a classificacao fiscal do regime */
        {method/zoomfields.i &ProgramZoom="cxzoom/z01cx319.w"
                             &FieldZoom1="regime-import"
                             &FieldScreen1="i-regime-import"
                             &Frame1="fPage0"
                             &FieldZoom2="des-regim-import"
                             &FieldScreen2="c-desc-regime"
                             &Frame2="fPage0"
                             &FieldZoom3="cod-pais"
                             &FieldScreen3="i-cdn-pais-orig"
                             &Frame3="fPage0"
                             &FieldZoom4="class-fiscal"
                             &FieldScreen4="c-class-fiscal"
                             &Frame4="fPage0"
                             &RunMethod="run setaFaixa in hProgramZoom (input input frame fPage0 i-cdn-pais-orig, input input frame fPage0 c-class-fiscal)."
                             &EnableImplant="no"}
    end.
    else do:
        {method/zoomfields.i &ProgramZoom="cxzoom/z01cx319.w"
                             &FieldZoom1="regime-import"
                             &FieldScreen1="i-regime-import"
                             &Frame1="fPage0"
                             &FieldZoom2="des-regim-import"
                             &FieldScreen2="c-desc-regime"
                             &Frame2="fPage0"
                             &FieldZoom3="cod-pais"
                             &FieldScreen3="i-cdn-pais-orig"
                             &Frame3="fPage0"
                             &RunMethod="run setaFaixa in hProgramZoom (input input frame fPage0 i-cdn-pais-orig, input input frame fPage0 c-class-fiscal)."
                             &EnableImplant="no"}
    end.

                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-regime-import wMaintenance
ON LEAVE OF i-regime-import IN FRAME fpage0 /* Regime Importa‡Æo */
DO:
    
    run gotokey in h-bocx319 (input input frame fPage0 i-cdn-pais-orig,
                              input input frame fPage0 i-regime-import,
                              input input frame fPage0 c-class-fiscal).
    if  return-value = "OK":U then 
        run getCharField in h-bocx319 (input "des-regim-import":U,
                                       output c-desc-regime).
    else 
        assign c-desc-regime = "":U.
    
    disp c-desc-regime with frame fPage0.

     if  c-class-fiscal:sensitive in frame fPage0 = yes then 
         apply "leave":U to c-class-fiscal in frame fPage0.

    if  i-regime-import-ant <> input frame fPage0 i-regime-import then do:
        
        assign i-regime-import-ant = input frame fPage0 i-regime-import.

        /* Busca aliquotas II e IPI */
        run calculateII_IPI in hDBOCotacao-itemi (input  tt-cotacao-item.it-codigo,   
                                                  input  tt-cotacao-item.numero-ordem,
                                                  input  tt-cotacao-item.aliquota-ipi,
                                                  input  input frame fPage0 c-class-fiscal,              
                                                  input  input frame fPage0 i-cdn-pais-orig,             
                                                  input  input frame fPage0 i-regime-import,             
                                                  output de-aliq-ii, 
                                                  output de-aliq-ipi).

        disp de-aliq-ii de-aliq-ipi with frame fPage0.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-regime-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-regime-import IN FRAME fpage0 /* Regime Importa‡Æo */
DO:
    apply "f5":U to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- L¢gica para inicializa‡Æo do programam ---*/
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

    if  valid-handle(hDBOEmitente) then
        run destroy in hDBOEmitente.
        
    if  valid-handle(hDBOCotacao-item-cex) then
        run destroy in hDBOCotacao-item-cex.
        
    if  valid-handle(hDBOPto-contr) then
        run destroy in hDBOPto-contr.

    if  valid-handle(hDBOItem) then
        run destroy in hDBOItem.

    if  valid-handle(hDBOOrdem-compra) then
        run destroy in hDBOOrdem-compra.
        
    if  valid-handle(hDBOCotacao-item) then
        run destroy in hDBOCotacao-item.        
        
    if  valid-handle(hDBOInco-cx) then
        run destroy in hDBOInco-cx.

    if  valid-handle(hDBOParam-imp) then
        run destroy in hDBOParam-imp.

    if  valid-handle(hDBOItiner) then
        run destroy in hDBOItiner.
    
    if  valid-handle(h-bocx155) then
        delete procedure h-bocx155.

    if  valid-handle(h-bocx319) then do:
        delete procedure h-bocx319.
        assign h-bocx319 = ?.
    end.

    if  valid-handle(h-boin046) then do:
        delete procedure h-boin046.
        assign h-boin046 = ?.
    end.

    if  valid-handle(h-boun006) then do:
        delete procedure h-boun006.
        assign h-boun006 = ?.
    end.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayfields wMaintenance 
PROCEDURE afterDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  c-class-fiscal:screen-value in frame {&frame-name} = "" then
        assign c-class-fiscal:format in frame {&frame-name} = "x(8)":U.
    else
        assign c-class-fiscal:format in frame {&frame-name} = "9999.99.99":U.

    IF  REPLACE(c-nbs:SCREEN-VALUE IN FRAME {&frame-name},".","") <> ""
    AND LENGTH(REPLACE(c-nbs:SCREEN-VALUE IN FRAME {&frame-name},".","")) >= 9 THEN
       ASSIGN c-nbs:FORMAT IN FRAME {&frame-name} = "9.9999.99.99" NO-ERROR.
    ELSE 
       ASSIGN c-nbs:FORMAT IN FRAME {&frame-name} = "x(9)" NO-ERROR.
        
    if  avail tt-cotacao-item then do:
        assign i-informa = 0.
        run gotoKey in hDBOOrdem-compra (input integer(tt-cotacao-item.numero-ordem:screen-value in frame fPage0)).
        if  return-value = "OK":U then
            run getCharfield in hDBOOrdem-compra (input "cod-estabel":U,output c-cod-estabel).
        run gotoKey in hDBOParam-imp (input c-cod-estabel).
        if  return-value = "OK":U THEN DO:
            run getIntfield in hDBOParam-imp (input "int-1":U,output i-informa).
            ASSIGN l-param-imp = YES.
        END.

        {ccp/cc9019.i50}
        {cdp/cd4300.i4 "yes" tt-cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    
        {ocp/oc0201.i50}
        {cdp/cd4300.i4 "yes" tt-cotacao-item.char-2}
        {ocp/oc0201.i51 "yes"}
        
        assign l-cot-aprovada   = tt-cotacao-item.cot-aprovada
               i-mapa-cotacao   = i-mapa-cotacao-i50
               c-cod-incoterm   = c-cod-incoterm-i50
               i-cod-pto-contr  = i-cod-pto-contr-i50
               i-cod-fabricante = i-cod-fabricante-i50
               i-regime-import  = i-regime-import-i50
               c-class-fiscal   = c-class-fiscal-i50
               de-aliq-ii       = de-aliq-ii-i50
               de-aliq-ipi      = tt-cotacao-item.aliquota-ipi
               i-cod-itiner     = tt-cotacao-item.int-1
               i-cdn-pais-orig  = tt-cotacao-item.cdn-pais-orig
               tg-ex-tarifario  = IF TRIM(SUBSTRING(tt-cotacao-item.char-1,148,1)) = "1":U THEN YES ELSE NO
               c-nbs            = c-nbs-i50.
               
        IF l-im0010 THEN DO:
            RUN gotoKey      IN {&hDBOTable} (INPUT tt-cotacao-item.numero-ordem,
                                              INPUT tt-cotacao-item.cod-emitente,
                                              INPUT tt-cotacao-item.it-codigo,
                                              INPUT tt-cotacao-item.seq-cotac).

            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN {&hDBOTable} (INPUT "char-1":U, OUTPUT c-char-1).
                {cdp/cd4300.i4 "yes" c-char-1}
                {ccp/cc9019.i51 "yes"}
                ASSIGN i-mapa-cotacao   = i-mapa-cotacao-i50.
            END.
        END.
        disp l-cot-aprovada 
             i-mapa-cotacao
             c-cod-incoterm
             i-cod-pto-contr
             i-cod-fabricante
             i-cdn-pais-orig
             i-regime-import
             c-class-fiscal
             c-nbs
             de-aliq-ii
             tg-ex-tarifario
             de-aliq-ipi
             i-cod-itiner
             with frame fPage0.

        run gotoKey in hDBOItem (input tt-cotacao-item.it-codigo).
        run getIntfield in hDBOItem (input "tipo-contr":U, output i-tipo-contr).

        IF  i-tipo-contr <> 4 THEN DO:
            {method/ReferenceFields.i
                &HandleDBOLeave="hDBOItem"
                &KeyValue1="tt-cotacao-item.it-codigo"
                &FieldName1="class-fiscal"
                &FieldScreen1="c-class-fiscal"
                &Frame1="fPage0"}
        END.
        
        if  gc-opcao-im0060 = "create":U then do:
            /* Busca o valor padrÆo do incoterm e ponto de controle */
            run findPk-emitente in h-bocx155(input tt-cotacao-item.cod-emitente,output c-return-emit-cex).
    
            if  c-return-emit-cex = "" then do:
    
                run getCharfield in h-bocx155(input "cod-incoterm-imp",
                                              output c-return-incoterm).
    
                assign c-cod-incoterm:screen-value in frame fPage0 = c-return-incoterm.  
                
                run getIntfield in h-bocx155 (input "cod-pto-contr",
                                              output c-return).
               
                assign i-cod-pto-contr:screen-value in frame fPage0 = c-return.
    
                IF i-informa = 2 OR 
                   i-informa = 3 THEN DO:
                    run getintfield in h-bocx155 (input "cod-itiner-imp",
                                                  output i-cod-itinerario).
                    ASSIGN i-cod-itiner:SCREEN-VALUE IN FRAME fPage0 = STRING(i-cod-itinerario)
                           i-cod-itinerario = 0.
                END.
    
                /* Busca o valor padrao do fabricante, do pais de origem e do regime de importacao padrao */
                run setDefaultsIm0060 in hDBOCotacao-itemi (input  input frame fPage0 tt-cotacao-item.it-codigo,
                                                            input  input frame fPage0 tt-cotacao-item.cod-emitente,
                                                            input  input frame fPage0 c-class-fiscal, 
                                                            output i-cod-fabricante,
                                                            output i-cdn-pais-orig,
                                                            output i-regime-import).
                disp i-cod-fabricante i-cdn-pais-orig i-regime-import with frame fPage0.

                IF CAN-FIND (FIRST funcao 
                             WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                               AND funcao.ativo = YES) THEN DO:

                    RUN setDefaultsHIS IN {&hDBOTable} (INPUT tt-cotacao-item.r-rowid,
                                                        OUTPUT i-cod-fabricante).

                END.
                
                /* Busca aliquotas II e IPI */
                run calculateII_IPI in hDBOCotacao-itemi (input  tt-cotacao-item.it-codigo,   
                                                          input  tt-cotacao-item.numero-ordem,
                                                          input  tt-cotacao-item.aliquota-ipi,
                                                          input  input frame fPage0 c-class-fiscal,              
                                                          input  input frame fPage0 i-cdn-pais-orig,             
                                                          input  input frame fPage0 i-regime-import,             
                                                          output de-aliq-ii, 
                                                          output de-aliq-ipi).
    
                disp de-aliq-ii de-aliq-ipi with frame fPage0.
            end.
            
            if  c-nbs = "" then do:
                run getCharfield in hDBOItem (input "char-1":U, output c-nbs-aux).                
                assign c-nbs = substr(c-nbs-aux,342,20).
                display c-nbs with frame fPage0.
            end.
        end.
        else 
            assign i-regime-import-ant = input frame fPage0 i-regime-import
                   c-class-fiscal-ant  = input frame fPage0 c-class-fiscal
                   i-cdn-pais-orig-ant = input frame fPage0 i-cdn-pais-orig.

        
        apply "leave":U to tt-cotacao-item.cod-emitente in frame fPage0.
        apply "leave":U to i-cod-pto-contr              in frame fPage0.
        apply "leave":U to i-cod-itiner                 in frame fPage0.
        apply "leave":U to c-class-fiscal               in frame fPage0.
        apply "leave":U to c-nbs                        in frame fPage0.
        apply "leave":U to i-regime-import              in frame fPage0.
        apply "leave":U to i-cod-fabricante             in frame fPage0.
        apply "leave":U to i-cdn-pais-orig              in frame fPage0.
    end.

    ASSIGN l-im0010 = NO.

    RETURN "OK":U.
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
    
    assign de-aliq-ipi-ant = tt-cotacao-item.aliquota-ipi
           l-im0010        = NO.

    IF  gc-opcao-im0060 = "create":U THEN DO:
        APPLY "choose":U TO btUpdate IN FRAME fPage0.
        ASSIGN tt-cotacao-item.log-gerac-autom-despes:SENSITIVE IN FRAME fPage0 = YES.
        IF l-param-imp THEN DO:
            RUN getLogfield IN hDBOParam-imp (INPUT "log-gerac-cotac-despes-impto":U,
                                              OUTPUT l-gerac-cotac-despes-impto).
            ASSIGN tt-cotacao-item.log-gerac-autom-despes:CHECKED IN FRAME fPage0 = l-gerac-cotac-despes-impto.
        END.
        /*Sugere a informa‡Æo de EX Tarif rio de acordo com o Item - CD2510 */
        RUN gotoKey IN hDBOItem (INPUT tt-cotacao-item.it-codigo:SCREEN-VALUE IN frame fPage0).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN hDBOItem (INPUT "char-2":U, OUTPUT c-char-2).
            IF TRIM(SUBSTRING(c-char-2,269,1)) = "1":U THEN
                ASSIGN tg-ex-tarifario:CHECKED IN FRAME {&FRAME-NAME} = YES.
            ELSE
                ASSIGN tg-ex-tarifario:CHECKED IN FRAME {&FRAME-NAME} = NO.
        END.
    END.
    ELSE DO:
        ASSIGN btUpdate:SENSITIVE IN FRAME fPage0 = YES
               tt-cotacao-item.log-gerac-autom-despes:SENSITIVE IN FRAME fPage0 = NO.
    END.
    
    /* Para o internacional o campo de ex-tarif rio nÆo deve ser apresentado */
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN tg-ex-tarifario:HIDDEN IN FRAME {&frame-name} = YES.
    END.
    
    apply "leave":U to i-cod-fabricante in frame fPage0.
    apply "leave":U to i-cdn-pais-orig  in frame fPage0.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayfields wMaintenance 
PROCEDURE beforeDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    if  gc-opcao-im0060 = "create":U then do:
        
        for each tt-cotacao-item:
            delete tt-cotacao-item.
        end.
        
        create tt-cotacao-item.
        assign tt-cotacao-item.numero-ordem = gi-numero-ordem-i   
               tt-cotacao-item.cod-emitente = gi-cod-emitente-i   
               tt-cotacao-item.it-codigo    = gc-it-codigo-i      
               tt-cotacao-item.seq-cotac    = gi-seq-cotac-i      
               tt-cotacao-item.aliquota-ipi = gde-aliquota-ipi-i. 
    end.    
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
    
    define variable rGoTo AS ROWID NO-UNDO.
    
    define variable i-numero-ordem LIKE {&ttTable}.numero-ordem NO-UNDO.
    define variable i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    define variable c-it-codigo    LIKE {&tttable}.it-codigo    NO-UNDO.
    define variable i-seq-cotac    LIKE {&ttTable}.seq-cotac    NO-UNDO.
    
    DEFINE frame fGoToRecord
        i-numero-ordem    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-cod-emitente    AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-it-codigo       AT ROW 3.21 COL 17.72 COLON-ALIGNED
        i-seq-cotac       AT ROW 4.21 COL 17.72 COLON-ALIGNED        
        btGoToOK          AT ROW 5.63 COL 2.14
        btGoToCancel      AT ROW 5.63 COL 13
        rtGoToButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Cota‡Æo do Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN frame fGoToRecord DO:
        ASSIGN i-numero-ordem
               i-cod-emitente
               c-it-codigo
               i-seq-cotac.
        
        RUN goToKey IN {&hDBOTable} (input i-numero-ordem, 
                                     input i-cod-emitente,
                                     input c-it-codigo,
                                     input i-seq-cotac).
        IF RETURN-VALUE = "NOK":U then DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Cota‡Æo_do_Item" *}
            RUN utp/ut-msgs.p (input "SHOW":U, input 2, input RETURN-VALUE).            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (input rGoTo).

        APPLY "GO":U TO frame fGoToRecord.
    END.
    
    ENABLE btGotoOK btGotoCancel i-numero-ordem i-cod-emitente c-it-codigo i-seq-cotac
        WITH frame fGoToRecord.
        
    assign i-numero-ordem:height = 0.88
           i-numero-ordem:width  = 10
           i-cod-emitente:height = 0.88
           i-cod-emitente:width  = 10
           c-it-codigo:height    = 0.88
           c-it-codigo:width     = 16
           i-seq-cotac:height    = 0.88
           i-seq-cotac:width     = 3.

    WAIT-FOR "GO":U OF frame fGoToRecord.
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
    /*--- Verifica se o DBO j  est  inicializado ---*/
    if  not valid-handle({&hDBOTable}) 
    or  {&hDBOTable}:type <> "PROCEDURE":U 
    or  {&hDBOTable}:file-name <> "inbo/boin082i.p":U then do:
        {btb/btb008za.i1 inbo/boin082i.p yes}
        {btb/btb008za.i2 inbo/boin082i.p '' {&hDBOTable}}
    end.

    if  not valid-handle(h-bocx155) 
    or  h-bocx155:type <> "PROCEDURE":U 
    or  h-bocx155:file-name <> "cxbo/bocx155.p":U then
        run cxbo/bocx155.p persistent set h-bocx155.

    /* 
    ** Instƒnciar BO campo de tabela estrangeira (pais-aliquota)
    */ 
    if  not valid-handle(h-bocx319)
    or  h-bocx319:type <> "PROCEDURE":U 
    or  h-bocx319:file-name <> "cxbo/bocx319.p":U then
        run cxbo/bocx319.p persistent set h-bocx319.
    run openQueryStatic in h-bocx319 (input "Main":U) no-error.

    /* 
    ** Instƒnciar BO campo de tabela estrangeira (classif-fisc)
    */ 
    if  not valid-handle(h-boin046)
    or  h-boin046:type <> "PROCEDURE":U 
    or  h-boin046:file-name <> "inbo/boin046na.p":U then
        run inbo/boin046na.p persistent set h-boin046.
    run openQueryStatic in h-boin046 (input "Main":U) no-error.
    
    /* 
    ** Instƒnciar BO campo de tabela estrangeira (pais) bo 1.1
    */ 
    if  not valid-handle(h-boun006) then do:
        {btb/btb008za.i1 unbo/boun006.p }
        {btb/btb008za.i2 unbo/boun006.p '' h-boun006}
    end.
    run openQuery in h-boun006 (input 4).

    /* 
    ** Instƒnciar BO campo de tabela estrangeira (emitente)
    */ 
    if  not valid-handle(hDBOEmitente) 
    or  hDBOEmitente:type <> "PROCEDURE":U 
    or  hDBOEmitente:file-name <> "adbo/boad098na.p":U then do:
        {btb/btb008za.i1 adbo/boad098na.p yes}
        {btb/btb008za.i2 adbo/boad098na.p '' hDBOEmitente}
    end.
    run openQueryStatic in hDBOEmitente (input "Main":U) no-error.
    
    /* 
    ** Instƒnciar BO campo de tabela estrangeira (cotacao-item-cex)
    */ 
    {btb/btb008za.i1 cxbo/bocx085na.p yes}
    {btb/btb008za.i2 cxbo/bocx085na.p '' hDBOCotacao-item-cex}
    run openQueryStatic in hDBOCotacao-item-cex (input "Main":U) no-error.
    
    /*
    ** Instƒnciar BO campo de tabela estrangeira (pto-contr)
    */
    if  not valid-handle(hDBOPto-contr) 
    or  hDBOPto-contr:type <> "PROCEDURE":U 
    or  hDBOPto-contr:file-name <> "cxbo/bocx110na.p":U then do:
        {btb/btb008za.i1 cxbo/bocx110na.p yes}
        {btb/btb008za.i2 cxbo/bocx110na.p '' hDBOPto-contr}
    end.
    run openQueryStatic in hDBOPto-contr (input "Main":U) no-error.
    
    /*
    ** Instƒnciar BO campo de tabela estrangeira (item)
    */
    if  not valid-handle(hDBOItem) 
    or  hDBOItem:type <> "PROCEDURE":U 
    or  hDBOItem:file-name <> "inbo/boin172na.p":U then do:
        {btb/btb008za.i1 inbo/boin172na.p yes}
        {btb/btb008za.i2 inbo/boin172na.p '' hDBOItem}
    end.
    run openQueryStatic in hDBOItem (input "Main":U) no-error.    
                                         
    /*
    ** Instƒnciar BO campo de tabela estrangeira (incoterm)
    */
    if  not valid-handle(hDBOInco-cx) 
    or  hDBOInco-cx:type <> "PROCEDURE":U 
    or  hDBOInco-cx:file-name <> "cxbo/bocx255na.p":U then do:
        {btb/btb008za.i1 cxbo/bocx025na.p yes}
        {btb/btb008za.i2 cxbo/bocx025na.p '' hDBOInco-cx}
    end.
    run openQueryStatic in hDBOInco-cx (input "Main":U) no-error.    
    
    /*
    ** Instƒnciar BO campo de tabela estrangeira (param-imp)
    */
    if  not valid-handle(hDBOParam-imp) 
    or  hDBOParam-imp:type <> "PROCEDURE":U 
    or  hDBOParam-imp:file-name <> "cxbo/bocx250na.p":U  then do:
        {btb/btb008za.i1 cxbo/bocx250na.p yes}
        {btb/btb008za.i2 cxbo/bocx250na.p '' hDBOParam-imp}
    end.
    run openQueryStatic in hDBOParam-imp (input "Main":U) no-error.

    /*
    ** Instƒnciar BO campo de tabela estrangeira (Itinerario)
    */
    if  not valid-handle(hDBOItiner)
    or  hDBOItiner:type <> "PROCEDURE":U 
    or  hDBOItiner:file-name <> "cxbo/bocx115na.p":U then do:
        {btb/btb008za.i1 cxbo/bocx115na.p yes}
        {btb/btb008za.i2 cxbo/bocx115na.p '' hDBOItiner}
    end.
    run openQueryStatic in hDBOItiner (input "Main":U) no-error.

    /*
    ** Instƒnciar BO campo de tabela estrangeira (ordem-compra)
    */
    if  not valid-handle(hDBOOrdem-compra) 
    or  hDBOOrdem-compra:type <> "PROCEDURE":U 
    or  hDBOOrdem-compra:file-name <> "inbo/boin274na.p":U then do:
        {btb/btb008za.i1 inbo/boin274na.p yes}
        {btb/btb008za.i2 inbo/boin274na.p '' hDBOOrdem-compra}
    end.
    run openQueryStatic in hDBOOrdem-compra (input "Main":U) no-error.

    /*
    ** Descri‡Æo NBS
    */
    if not valid-handle(h-bodi01157)     or
       h-bodi01157:type <> "PROCEDURE":U or
       h-bodi01157:file-name <> "dibo/bodi01157.p":U then do:
        {btb/btb008za.i1 dibo/bodi01157.p yes}
        {btb/btb008za.i2 dibo/bodi01157.p '' h-bodi01157}
    end.
    run openQueryStatic in h-bodi01157 (input "Main":U) no-error.
    
    /*
    ** Posicionamento se chamado para modifica‡Æo
    */    
    if  gr-cotacao-item-i <> ? then do:
        run setConstraintRowid in {&hDBOTable} (input gr-cotacao-item-i) no-error.
        run openQueryStatic in {&hDBOTable} (input "Rowid":U) no-error.
    end.
    else do:
        if  gr-ordem-compra <> ? then do:
            /*
            ** Instƒnciar BO campo de tabela estrangeira (cotacao-item)
            */
            if  not valid-handle(hDBOCotacao-item)  
            or  {&hDBOTable}:type <> "PROCEDURE":U 
            or  {&hDBOTable}:file-name <> "inbo/boin082.p":U  then do:
                {btb/btb008za.i1 inbo/boin082.p yes}
                {btb/btb008za.i2 inbo/boin082.p '' hDBOCotacao-item}
            end.
            
            run findRowid   in hDBOOrdem-compra (input gr-ordem-compra).
            run getIntField in hDBOOrdem-compra (input "numero-ordem":U,output i-numero-ordem).
            
            run gotoCotacaoAprovada in hDBOCotacao-item (input i-numero-ordem).
            run getRowid            in hDBOCotacao-item (output gr-cotacao-item-i) no-error.
            run setConstraintRowid  in {&hDBOTable}     (input gr-cotacao-item-i) no-error.
            run openQueryStatic     in {&hDBOTable}     (input "Rowid":U) no-error.
        end.
    end.

    enable bt-desp-imp with frame fPage0.
        
    /*--- Seta cursor do mousr para lupa, quando estiver posicionado
      sobre o fill-in ---*/
    c-cod-incoterm:load-mouse-pointer("image/lupa.cur":U)   in frame fPage0.
    i-cod-pto-contr:load-mouse-pointer("image/lupa.cur":U)  in frame fPage0.
    i-cod-fabricante:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
    c-class-fiscal:load-mouse-pointer("image/lupa.cur":U)   in frame fPage0.        
    c-nbs:load-mouse-pointer("image/lupa.cur":U)            in frame fPage0.
    i-regime-import:load-mouse-pointer("image/lupa.cur":U)  in frame fPage0.        
    i-cdn-pais-orig:load-mouse-pointer("image/lupa.cur":U)  in frame fPage0.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

