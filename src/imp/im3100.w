&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados. 
**
** Este fonte e de propriedade exclusiva da DATASUL,  sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3100 2.00.00.055 } /*** "010055" 11/12/2025 08:58:33 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3100 MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}

def var l-ok                       as log    no-undo.
def var l-formato                  as log    no-undo.
def var c-arq-digita               as char   no-undo.
def var c-terminal                 as char   no-undo.
def var hProgramZoom               as handle no-undo.
def var h-bocx220                  as handle no-undo.
def var h-bocx220a                 as handle no-undo.
def var h-bocx220c                 as handle no-undo.
def var h-boin682                  as handle no-undo.
def var hShowMsg                   as handle no-undo.
def var i-cont                     as int    no-undo.
def var c-formato                  as char   no-undo.
def var l-criou                    as log    no-undo init no.
def var l-verifica-erro            as log    no-undo init no.
def var c-num-embarque             LIKE embarque-imp.embarque  no-undo.
def var l-chama-carregado          as log    no-undo init no.
def var i-seq-erro                 as int    no-undo.
def var i-tst-docto                as int    no-undo.
def var l-emit-diferente           as log    no-undo.
def var l-fornec-fundap            as log    no-undo.
def var c-formato-cta-ctbl         as char   no-undo.
def var i-empresa-prin             as CHAR FORMAT "x(5)"    no-undo.
def var i-contador                 as int    no-undo.
def var c-return                   as char   no-undo.
def var c-titulo                   like conta-contab.titulo no-undo.
DEF VAR c-numero-docto             LIKE docum-est.nro-docto    NO-UNDO.
DEF VAR c-serie-docto              LIKE docum-est.serie-docto  NO-UNDO.
DEF VAR c-emitente-docto           LIKE docum-est.cod-emitente NO-UNDO.
DEF VAR c-nat-operacao             LIKE docum-est.nat-operacao NO-UNDO.
DEF VAR l-executar                 AS LOGICAL NO-UNDO.
DEF VAR rs-classif-nf-aux          AS INTEGER NO-UNDO.
DEF VAR c-conta-transit-import     LIKE param-imp.ct-transit-import NO-UNDO.
DEF VAR c-conta-transit-import-aux LIKE param-imp.ct-transit-import NO-UNDO.
DEF VAR c-ccusto-transit-import    LIKE param-imp.sc-transit-import NO-UNDO.
DEF VAR i-quebra                   as integer     no-undo.
DEFINE VARIABLE i-seq-item-serie   AS INTEGER     NO-UNDO.
DEF VAR i-empresa                  LIKE param-global.empresa-prin NO-UNDO.
DEF VAR h-boar0178                 AS HANDLE NO-UNDO.
DEF VAR c-trad-aux                 AS CHAR   NO-UNDO.
DEF VAR v-i-nro-docto              AS INT    NO-UNDO.
DEF VAR c-liter                    AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR h-bopy2003                 AS HANDLE NO-UNDO.
DEF VAR l-dep-ext                  AS LOG NO-UNDO.
DEF VAR l-log-embarq-transf-draw   AS LOG    NO-UNDO.
DEF VAR c-retorno                  AS CHAR   NO-UNDO.
DEF VAR h-boin375                  AS HANDLE NO-UNDO.
DEF VAR dt-trans-aux               AS DATE   NO-UNDO.
def var c-formato-nf               as char format "x(16)":U no-undo.
DEF VAR i-tipo-comprov-aux         AS INT    NO-UNDO.
DEF VAR cAuxTraducao001            AS CHAR   NO-UNDO.

DEF BUFFER b-ordens-embarque FOR ordens-embarque.
DEF BUFFER b-docum-est       FOR docum-est.
DEF BUFFER b-item-doc-est    FOR item-doc-est.
DEF BUFFER b-embarque-imp    FOR embarque-imp.

{include/boerrtab.i}
{imp/im0100x.i tt-parametros}
{cxbo/bocx220c.i tt-item-doc-est}
{cxbo/bocx220c.i tt-itens-aux} /* Temp-table auxiliar para criaá∆o dos itens do desembarque */  
{imp/im0100.i}
{cdp/cd2508.i}
{cdp/cd4300.i3}  /*Variòveis para o cd4300.i4 */
{cdp/cd0101.i50} /*Variòveis para o re1001b.i51*/

def temp-table tt-retorno no-undo like tt-bo-erro.

def var c-key-value as char no-undo.

define temp-table tt-param-re1005rp
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.

define temp-table tt-digita
    field r-docum-est        as rowid.

def var raw-param as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita   as raw.

{inbo/boin01066.i tt-docto-estoq-internac}

DEFINE VARIABLE h-bocx250na     AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-trata-dep-ext AS LOGICAL     NO-UNDO.

def new global shared var adm-broker-hdl as handle no-undo.
def new global shared var l-nff          as log init no no-undo.
DEF VAR p-nff AS LOGICAL NO-UNDO.

DEFINE VARIABLE l-trans-drawback AS LOGICAL  INITIAL NO   NO-UNDO.
/* Definiá∆o de PrÇ-Processadores */

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD embarque             AS CHAR
    FIELD cod-estabel          AS CHAR
    FIELD docto                AS CHAR
    FIELD serie                AS CHAR
    FIELD nat-operacao         AS CHAR 
    FIELD ccod-estabel-fisc    AS CHAR
    FIELD declaracao-import    AS CHAR
    FIELD data-emissao         AS DATE 
    FIELD data-trans           AS DATE
    FIELD ct-transit           AS CHAR
    FIELD sc-transit           AS CHAR
    FIELD nff                  AS LOG
    FIELD data-di              AS DATE
    FIELD data-cotacao         AS DATE
    FIELD idi-nf-simples-remes AS INT.


DEFINE VARIABLE c-empresa   LIKE param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE c-estabelec AS CHARACTER                   NO-UNDO.
{cdp/cdunif001.i} /* Vari†veis da unificaá∆o de conceito Conta Cont†bil e Centro de Custo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-sel

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cembarque ccod-estabel ccod-emitente ~
ddata-trans ddata-emissao cnr-docto cserie cnatureza ccod-estabel-fisc ~
ddata-cotacao ccod-decl-imp ddata-di cb-tipo-comprov c-ct-transit c-sc-transit f-estab-fat ~
f-pto-vda f-timbrado f-dt-vto l-envia-dep-ext l-att-docto-receb-auto l-nota-fisc-fat EDITOR-2 
&Scoped-Define DISPLAYED-OBJECTS cembarque ccod-estabel ccod-emitente ~
ddata-trans ddata-emissao cnr-docto cserie cnatureza ccod-estabel-fisc ~
ddata-cotacao ccod-decl-imp ddata-di cb-tipo-comprov c-ct-transit fi-c-desc-conta ~
c-sc-transit fi-c-desc-ccusto f-estab-fat f-pto-vda f-timbrado f-dt-vto ~
l-envia-dep-ext l-att-docto-receb-auto l-nota-fisc-fat EDITOR-2 d-cot-var-cambial d-cotacao

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-ccusto-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cta-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE desc-ccusto-aplic-nf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.14 BY .88 NO-UNDO.

DEFINE VARIABLE desc-cta-aplic-nf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-classif-nf AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nota M∆e", 1,
"Nota Filha", 2
     SIZE 10.86 BY 2 NO-UNDO.

DEFINE VARIABLE l-nf-simples-remessa AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Simples Remessa" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 51 BY 1.5 NO-UNDO.

DEFINE VARIABLE c-ct-transit AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-sc-transit AS CHARACTER FORMAT "x(20)" 
     LABEL "Sub-Conta Transit" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE ccod-decl-imp AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declaraá∆o Importaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-fisc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Estabelecimento Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cnatureza AS CHARACTER FORMAT "x(6)":U 
     LABEL "Natureza Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-docto AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nro Docto" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cserie AS CHARACTER FORMAT "X(10)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-cotacao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Cotaá∆o Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.
     
DEFINE VARIABLE d-cotacao AS DEC FORMAT ">>>,>>9.9999999999":U  
     LABEL "Cotaá∆o Moeda" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.     

DEFINE VARIABLE ddata-di AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-emissao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-trans AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-cot-var-cambial AS DEC FORMAT ">>>,>>9.9999999999":U  
     LABEL "Cotaá∆o Calc Imp" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE f-dt-vto AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Vto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-estab-fat AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Estab Fat" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE f-pto-vda AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Pto Vda" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE f-timbrado AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Timbrado" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-ccusto AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-conta AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-envia-dep-ext AS LOGICAL INITIAL no 
     LABEL "Envia Mercadoria Dep¢sito Externo" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-nota-fisc-fat AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Fatura" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.
     
DEFINE VARIABLE l-att-docto-receb-auto AS LOGICAL INITIAL NO
     LABEL "Atualiza Documento no Recebimento Automaticamente" 
     VIEW-AS TOGGLE-BOX
     size 40 BY .83 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-gtos-aduana 
     LABEL "Sim. Gtos. Aduana" 
     SIZE 15 BY 1.

DEFINE BUTTON btconferencia 
     LABEL "&Conferància" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btpesoscubagem 
     LABEL "&Pesos e &Cubagem" 
     SIZE 15 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .25
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 13.5
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 13.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 13.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .
     
DEFINE VARIABLE cb-tipo-comprov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Comprov" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO .     


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-sel
     cembarque AT ROW 1.25 COL 18 COLON-ALIGNED
     ccod-estabel AT ROW 1.25 COL 50.14 COLON-ALIGNED
     ccod-emitente AT ROW 2.25 COL 18 COLON-ALIGNED
     ddata-trans AT ROW 2.25 COL 50.14 COLON-ALIGNED
     ddata-emissao AT ROW 3.25 COL 18 COLON-ALIGNED     
     cnr-docto AT ROW 3.25 COL 50.14 COLON-ALIGNED
     cserie AT ROW 4.25 COL 18 COLON-ALIGNED
     cnatureza AT ROW 4.25 COL 50.14 COLON-ALIGNED
     ccod-estabel-fisc AT ROW 5.25 COL 18 COLON-ALIGNED
     ddata-cotacao AT ROW 5.25 COL 50.14 COLON-ALIGNED     
     ccod-decl-imp AT ROW 6.25 COL 18 COLON-ALIGNED
     d-cotacao AT ROW 6.25 COL 50.14 COLON-ALIGNED
     ddata-di AT ROW 7.25 COL 50.14 COLON-ALIGNED
     cb-tipo-comprov AT ROW 7.25 COL 18 COLON-ALIGNED
     d-cot-var-cambial AT ROW 8.25 COL 50.14 COLON-ALIGNED
     c-ct-transit AT ROW 9.25 COL 18 COLON-ALIGNED
     fi-c-desc-conta AT ROW 9.25 COL 34.29 COLON-ALIGNED NO-LABEL
     c-sc-transit AT ROW 10.25 COL 18 COLON-ALIGNED
     fi-c-desc-ccusto AT ROW 10.25 COL 34.29 COLON-ALIGNED NO-LABEL
     f-estab-fat AT ROW 11.25 COL 18 COLON-ALIGNED WIDGET-ID 2
     f-pto-vda AT ROW 11.25 COL 32 COLON-ALIGNED WIDGET-ID 4
     f-timbrado AT ROW 11.25 COL 46.86 COLON-ALIGNED WIDGET-ID 6
     f-dt-vto AT ROW 11.25 COL 63 COLON-ALIGNED WIDGET-ID 8
     l-envia-dep-ext AT ROW 12.17 COL 20.14
     l-nota-fisc-fat AT ROW 12.17 COL 60
     l-att-docto-receb-auto AT ROW 12.17 COL 20
     EDITOR-2 AT ROW 13.04 COL 20 NO-LABEL
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 9 BY .88 AT ROW 13.04 COL 10.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 13.88
         FONT 1.

DEFINE FRAME f-relat
     bt-executar AT ROW 17.58 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 17.58 COL 13.86 HELP
          "Fechar"
     btpesoscubagem AT ROW 17.58 COL 25
     bt-gtos-aduana AT ROW 17.58 COL 40.72
     btconferencia AT ROW 17.58 COL 56.29
     bt-ajuda AT ROW 17.58 COL 70 HELP
          "Ajuda"
     "Simples Remessa" VIEW-AS TEXT
          SIZE 13 BY .88 AT ROW 1.67 COL 19.57
     "Desembarque" VIEW-AS TEXT
          SIZE 13 BY .88 AT ROW 1.67 COL 4
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 16.67 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-1 AT ROW 17.33 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 3.5 COL 2
     im-pg-sel AT ROW 2.5 COL 2.14
     im-pg-cla AT ROW 2.5 COL 17.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 18
         FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-cla
     l-nf-simples-remessa AT ROW 1.29 COL 31
     rs-classif-nf AT ROW 2.29 COL 31 NO-LABEL
     c-cta-aplic-nf AT ROW 4.5 COL 29 COLON-ALIGNED
     desc-cta-aplic-nf AT ROW 4.5 COL 45.86 COLON-ALIGNED NO-LABEL
     c-ccusto-aplic-nf AT ROW 5.5 COL 29 COLON-ALIGNED
     desc-ccusto-aplic-nf AT ROW 5.5 COL 45.86 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 13.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.17
         WIDTH              = 80.57
         MAX-HEIGHT         = 39.04
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.04
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-pg-cla:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-cla
                                                                        */
/* SETTINGS FOR FILL-IN desc-ccusto-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-cta-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
   FRAME-NAME                                                           */
ASSIGN 
       f-dt-vto:HIDDEN IN FRAME f-pg-sel           = TRUE.

ASSIGN 
       f-estab-fat:HIDDEN IN FRAME f-pg-sel           = TRUE.

ASSIGN 
       f-pto-vda:HIDDEN IN FRAME f-pg-sel           = TRUE.

ASSIGN 
       f-timbrado:HIDDEN IN FRAME f-pg-sel           = TRUE.

ASSIGN
       cb-tipo-comprov:HIDDEN IN FRAME f-pg-sel           = TRUE.       

/* SETTINGS FOR FILL-IN fi-c-desc-ccusto IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-conta IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       l-envia-dep-ext:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-cla
/* Query rebuild information for FRAME f-pg-cla
     _Query            is NOT OPENED
*/  /* FRAME f-pg-cla */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
       RUN validaArg.
       IF  RETURN-VALUE <> "OK" THEN
           RETURN NO-APPLY.
   END.
   ASSIGN l-executar = YES.
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gtos-aduana
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gtos-aduana w-relat
ON CHOOSE OF bt-gtos-aduana IN FRAME f-relat /* Sim. Gtos. Aduana */
DO:

  def var i-sequen as int  no-undo.

  ASSIGN i-sequen = 1.

  FOR EACH tt-bo-erro:
    DELETE tt-bo-erro.
  END.

  IF cembarque:SCREEN-VALUE IN FRAME f-pg-sel = "" THEN DO:
    {utp/ut-liter.i Embarque *}
    ASSIGN c-trad-aux = RETURN-VALUE.
    RUN utp/ut-msgs.p (INPUT "msg":U,
                       INPUT 265,
                       INPUT c-trad-aux).
    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen = i-sequen
           tt-bo-erro.cd-erro  = 265
           tt-bo-erro.mensagem = RETURN-VALUE
           tt-bo-erro.parametros = c-trad-aux.
    ASSIGN i-sequen = i-sequen + 1.
        
  END.
      
  IF ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel = "" THEN DO:
    {utp/ut-liter.i Estabelecimento *}
    ASSIGN c-trad-aux = RETURN-VALUE.
    RUN utp/ut-msgs.p (INPUT "msg":U,
                       INPUT 265,
                       INPUT c-trad-aux).
    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen = i-sequen
           tt-bo-erro.cd-erro  = 265
           tt-bo-erro.mensagem = RETURN-VALUE
           tt-bo-erro.parametros = c-trad-aux.
    ASSIGN i-sequen = i-sequen + 1.
  END.
  
  IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
    IF NOT VALID-HANDLE(hShowMsg) THEN
        run utp/showmessage.w PERSISTENT SET hShowMsg.
    ELSE DO:
        DELETE PROCEDURE hShowMsg.
        run utp/showmessage.w PERSISTENT SET hShowMsg.
    END.
    RUN setModal     IN hShowMsg (INPUT YES).
    run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
  END.
  ELSE 
    RUN local/arg/ar2047.w (INPUT ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel,
                            INPUT cembarque:SCREEN-VALUE IN FRAME f-pg-sel). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btconferencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btconferencia w-relat
ON CHOOSE OF btconferencia IN FRAME f-relat /* Conferància */
DO:
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
       RUN validaArg.
       IF  RETURN-VALUE <> "OK" THEN
           RETURN NO-APPLY.
    END.
    assign l-executar = no.
    do  transaction:
        run pi-executar.
        for each tt-parametros:
            delete tt-parametros.
        end.
        undo, leave.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btpesoscubagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btpesoscubagem w-relat
ON CHOOSE OF btpesoscubagem IN FRAME f-relat /* Pesos e Cubagem */
DO:
    run pi-valida-chamada-prog.

    if return-value <> "OK" then
        apply "entry" to cembarque in frame f-pg-sel.
    else
    run imp/im0100c.w (input ccod-estabel,
                       input cembarque,
                       input c-seg-usuario,
                       input cnatureza,
                       input NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME c-ccusto-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON ENTRY OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
  ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON F5 OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:   
   ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)"
          c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)" .
    
   ASSIGN INPUT FRAME f-pg-sel ddata-trans.

   IF  ddata-trans <> ? THEN 
       ASSIGN dt-trans-aux = ddata-trans.
   ELSE 
       ASSIGN dt-trans-aux = TODAY.

   run pi_zoom_ccusto_x_cta_ctbl in h_api_ccusto (input             c-empresa,                      /* EMPRESA EMS2 */
                                                  input INPUT FRAME f-pg-sel ccod-estabel,          /* ESTABELECIMENTO EMS2 */
                                                  input             yes,                            /* TODOS ESTABELECIMENTOS ? */
                                                  input             "",                             /* UNIDADE DE NEGOCIO */
                                                  input             "",                             /* PLANO CONTAS */
                                                  input             c-cta-aplic-nf:SCREEN-VALUE,    /* CONTA */
                                                  input             "",                             /* CODIGO DO PLANO CCUSTO */
                                                  input             dt-trans-aux, /* DATA DE TRANSACAO */
                                                  output            v_cod_ccusto,                   /* CODIGO CCUSTO */
                                                  output            v_des_ccusto,                   /* DESCRICAO CCUSTO */
                                                  output table      tt_log_erro).                   /* ERROS */

   
   IF RETURN-VALUE  = "OK" THEN
        ASSIGN c-ccusto-aplic-nf = v_cod_ccusto
               c-ccusto-aplic-nf:SCREEN-VALUE = v_cod_ccusto
               desc-ccusto-aplic-nf:SCREEN-VALUE = v_des_ccusto.

   IF p_cod_format_cta_ctbl <> "" then
        ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_cta_ctbl.                    
                           
   DISP c-ccusto-aplic-nf desc-ccusto-aplic-nf WITH FRAME f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON LEAVE OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:

    ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)".
    ASSIGN c-ccusto-aplic-nf = c-ccusto-aplic-nf:SCREEN-VALUE.    

    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    IF c-ccusto-aplic-nf <> ""  THEN DO:
        run pi_busca_dados_ccusto in h_api_ccusto (input        c-empresa,                           /* EMPRESA EMS2 */
                                                   input        "",                                  /* CODIGO DO PLANO CCUSTO */
                                                   input        c-ccusto-aplic-nf,                   /* CCUSTO */
                                                   INPUT        dt-trans-aux, /* DATA DE TRANSACAO */
                                                   output       v_des_ccusto,                        /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).                        /* ERROS */ 
        IF RETURN-VALUE = "OK" THEN do:
            IF  p_cod_format_ccusto <> ""  THEN
                ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_ccusto.
            ASSIGN desc-ccusto-aplic-nf:SCREEN-VALUE = v_des_ccusto. 
        END.
        ELSE DO:            
            ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)"
                   desc-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = "".
        END.
    END.
    ELSE DO:
        ASSIGN desc-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = "".        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
  APPLY "f5":U TO SELF IN FRAME f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-ct-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit w-relat
ON ENTRY OF c-ct-transit IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit w-relat
ON F5 OF c-ct-transit IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME f-pg-sel = v_des_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit w-relat
ON LEAVE OF c-ct-transit IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN SELF:FORMAT = "X(20)".

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = INPUT FRAME f-pg-sel c-ct-transit.
    
    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.


    /* Busca dados da conta cont†bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresentaá∆o da conta cont†bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  dt-trans-aux,         /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               fi-c-desc-conta:SCREEN-VALUE IN FRAME f-pg-sel = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.

        /* Verifica se a conta utiliza centro de custo */
        ASSIGN c-estabelec = INPUT FRAME f-pg-sel ccod-estabel.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  NOT p_log_ccusto THEN
            ASSIGN c-sc-transit:SCREEN-VALUE     IN FRAME f-pg-sel = ""
                   fi-c-desc-ccusto:SCREEN-VALUE IN FRAME f-pg-sel = ""
                   c-sc-transit:SENSITIVE        IN FRAME f-pg-sel = NO.
        ELSE DO:
            ASSIGN c-sc-transit:SENSITIVE   IN FRAME f-pg-sel = YES.
            APPLY "ENTRY":U TO c-sc-transit IN FRAME f-pg-sel.
        END.
    END.
    ELSE DO:
        ASSIGN fi-c-desc-conta:SCREEN-VALUE  IN FRAME f-pg-sel = ""
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-sc-transit:SCREEN-VALUE     IN FRAME f-pg-sel = "".

        ASSIGN c-sc-transit:SENSITIVE IN FRAME f-pg-sel = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit w-relat
ON MOUSE-SELECT-DBLCLICK OF c-ct-transit IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME c-cta-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON ENTRY OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
  ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla       = "X(20)"
         c-ccusto-aplic-nf:SENSITIVE IN FRAME f-pg-cla = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON F5 OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)":U.

    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input        c-empresa,              /* EMPRESA EMS2 */
                                                   input        "CEP",                  /* MÖDULO */         
                                                   input        "",                     /* PLANO DE CONTAS */
                                                   input        "(nenhum)",             /* FINALIDADES */ 
                                                   input        dt-trans-aux,           /* DATA TRANSACAO */ 
                                                   output       v_cod_cta_ctbl,         /* CODIGO CONTA */   
                                                   output       v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                                   output       v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro).           /* ERROS */ 
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN c-cta-aplic-nf = v_cod_cta_ctbl
               c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl
               desc-cta-aplic-nf = v_des_cta_ctbl
               desc-cta-aplic-nf:SCREEN-VALUE = v_des_cta_ctbl.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON LEAVE OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
     ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "x(20)"
            v_cod_cta_ctbl = c-cta-aplic-nf:SCREEN-VALUE.

     ASSIGN INPUT FRAME f-pg-sel ddata-trans.

     IF  ddata-trans <> ? THEN 
         ASSIGN dt-trans-aux = ddata-trans.
     ELSE 
         ASSIGN dt-trans-aux = TODAY.

     run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT        c-empresa,                                      /* EMPRESA EMS2 */
                                                    INPUT        "",                                             /* PLANO DE CONTAS */
                                                    INPUT-OUTPUT v_cod_cta_ctbl,                                 /* CONTA */
                                                    INPUT        dt-trans-aux,                           /* DATA TRANSACAO */   
                                                    OUTPUT       v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                                    OUTPUT       v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                                    OUTPUT       v_num_sit_cta_ctbl,                             /* SITUAÄ«O DA CONTA */
                                                    OUTPUT       v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                                    OUTPUT TABLE tt_log_erro).                                   /* ERROS */     
  
      IF RETURN-VALUE = "OK" THEN DO:
         ASSIGN c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl
                c-cta-aplic-nf              = v_cod_cta_ctbl
                desc-cta-aplic-nf           = v_des_cta_ctbl.
         IF p_cod_format_cta_ctbl <> "" THEN 
             ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_cta_ctbl.
         ELSE
             ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)":U.
     END.
     ELSE
       
    
     ASSIGN c-cta-aplic-nf    = v_cod_cta_ctbl
            desc-cta-aplic-nf = v_des_cta_ctbl.
     

     IF c-cta-aplic-nf:SENSITIVE <> NO THEN DO:
         ASSIGN c-estabelec = INPUT FRAME f-pg-sel ccod-estabel.
         run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,          /* EMPRESA EMS 2 */
                                                            input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                            input  "",                 /* PLANO CONTAS */
                                                            input  c-cta-aplic-nf,     /* CONTA */
                                                            input  today,              /* DT TRANSACAO */
                                                            output p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                            output table tt_log_erro). /* ERROS */
         IF NOT AVAIL tt_log_erro THEN DO:             
             IF NOT p_log_ccusto THEN
                 ASSIGN c-ccusto-aplic-nf:SENSITIVE = NO
                        c-ccusto-aplic-nf:SCREEN-VALUE = ""
                        c-ccusto-aplic-nf = ""
                        desc-ccusto-aplic-nf:SCREEN-VALUE = ""
                        desc-ccusto-aplic-nf = "".
             ELSE
                 ASSIGN c-ccusto-aplic-nf:SENSITIVE = YES.
         END.
     END.
     disp c-cta-aplic-nf desc-cta-aplic-nf with frame f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-sc-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit w-relat
ON ENTRY OF c-sc-transit IN FRAME f-pg-sel /* Sub-Conta Transit */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit w-relat
ON F5 OF c-sc-transit IN FRAME f-pg-sel /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN c-estabelec = INPUT FRAME f-pg-sel ccod-estabel.
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT c-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                  /* Unidade de Negocio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* CΩdigo da Conta*/
                                                   INPUT "",                  /* CΩdigo do Plano de Centro de Custo*/
                                                   INPUT dt-trans-aux,        /* Data da Transacao*/
                                                   OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME f-pg-sel = v_des_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit w-relat
ON LEAVE OF c-sc-transit IN FRAME f-pg-sel /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    ASSIGN INPUT FRAME f-pg-sel ddata-trans.
    
    IF  ddata-trans <> ? THEN 
        ASSIGN dt-trans-aux = ddata-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = INPUT FRAME f-pg-sel c-sc-transit.

    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca m†scara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  dt-trans-aux,        /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME f-pg-sel = v_des_ccusto.
        /* Aplica a m†scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN SELF:FORMAT IN FRAME f-pg-sel = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME f-pg-sel = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit w-relat
ON MOUSE-SELECT-DBLCLICK OF c-sc-transit IN FRAME f-pg-sel /* Sub-Conta Transit */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente w-relat
ON F5 OF ccod-emitente IN FRAME f-pg-sel /* Emitente */
DO:
    {method/ZoomFields.i
     &ProgramZoom="adzoom/z13ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="ccod-emitente"
     &Frame1="f-pg-sel"
     &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-emitente IN FRAME f-pg-sel /* Emitente */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON F5 OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
    {method/ZoomFields.i
     &ProgramZoom="adzoom/z10ad107.w"
     &FieldZoom1="cod-estabel"
     &FieldScreen1="ccod-estabel"
     &Frame1="f-pg-sel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON LEAVE OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
    /* busca os dados do embarque */
    /* s¢ entra neste if caso tenha informado o embarque e o estabelecimento. 
       A verificaá∆o do cod-emitente serve apenas para n∆o aplicar o leave mais de uma vez, pois o usuario pode ter alterado algum dado na m∆o e se aplicasse o leave no campo estas 
       alteraá‰es seriam perdidas*/
    IF cembarque:SCREEN-VALUE     IN FRAME f-pg-sel <> "" AND
       ccod-estabel:SCREEN-VALUE  IN FRAME f-pg-sel <> "" AND
       ccod-emitente:SCREEN-VALUE IN FRAME f-pg-sel = "0"  THEN DO:

        RUN busca-dados-embarque. 
    END. /*fim busca dados do embarque */
    
    

    IF ccod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN
        RUN pi-trata-dep-ext-internac.

    RUN pi-habilita-fatura.
    RUN pi-busca-cotacao-moeda.
    
    /* N∆o permite usar simples remessa se for drawback */
    IF CAN-FIND (FIRST ordens-embarque 
                 WHERE ordens-embarque.cod-estabel = ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel
                   AND ordens-embarque.embarque    = cembarque:SCREEN-VALUE IN FRAME f-pg-sel    
                   AND trim(substring(ordens-embarque.char-1,1,20)) <> "" /*DIT*/) OR l-log-embarq-transf-draw THEN DO:
                     
        ASSIGN l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla   = NO
               l-nf-simples-remessa:SENSITIVE IN FRAME f-pg-cla = NO.               

        APPLY "VALUE-CHANGED":U TO l-nf-simples-remessa IN FRAME f-pg-cla.

    END.
    ELSE
        ASSIGN l-nf-simples-remessa:SENSITIVE IN FRAME f-pg-cla = YES.
    

    IF l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla THEN
        apply "VALUE-CHANGED":U to rs-classif-nf in frame f-pg-cla.

    RUN pi-habilita-decl-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON F5 OF ccod-estabel-fisc IN FRAME f-pg-sel /* Estabelecimento Fiscal */
DO:
    {method/ZoomFields.i
     &ProgramZoom="adzoom/z10ad107.w"
     &FieldZoom1="cod-estabel"
     &FieldScreen1="ccod-estabel-fisc"
     &Frame1="f-pg-sel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel-fisc IN FRAME f-pg-sel /* Estabelecimento Fiscal */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cembarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON ENTRY OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
  RUN pi-verifica-nota-simples-remessa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON F5 OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z04cx220.w"
     &FieldZoom1="embarque"
     &FieldScreen1="cembarque"
     &Frame1="f-pg-sel"
     &FieldZoom2="cod-estabel"
     &FieldScreen2="ccod-estabel"
     &Frame2="f-pg-sel"
     &FieldZoom3="cod-emitente"
     &FieldScreen3="ccod-emitente"
     &Frame3="f-pg-sel"
     &FieldZoom4="cod-estab-fisc"
     &FieldScreen4="ccod-estabel-fisc"
     &Frame4="f-pg-sel"
     &FieldZoom5="ct-transit-import"
     &FieldScreen5="c-ct-transit"
     &Frame5="f-pg-sel"
     &FieldZoom6="declaracao-import"
     &FieldScreen6="ccod-decl-imp"
     &Frame6="f-pg-sel"
     &FieldZoom7="data-di"
     &FieldScreen7="ddata-di"
     &Frame7="f-pg-sel"
     &FieldZoom8="sc-transit-import"
     &FieldScreen8="c-sc-transit"
     &Frame8="f-pg-sel"
     &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON LEAVE OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:

  RUN pi-verifica-nota-simples-remessa.

  APPLY "LEAVE":U TO ccod-estabel  IN FRAME f-pg-sel.
  APPLY "LEAVE":U TO c-ct-transit  IN FRAME f-pg-sel.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ddata-cotacao w-relat
ON LEAVE OF ddata-cotacao IN FRAME f-pg-sel /* data cotacao */
DO:  
    RUN pi-busca-cotacao-moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON MOUSE-SELECT-DBLCLICK OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnatureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON F5 OF cnatureza IN FRAME f-pg-sel /* Natureza Operaá∆o */
DO:
    assign l-implanta = yes.

    {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                 &campo="cnatureza"
                 &campozoom="nat-operacao"
                 &frame="f-pg-sel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON MOUSE-SELECT-DBLCLICK OF cnatureza IN FRAME f-pg-sel /* Natureza Operaá∆o */
DO:  
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnr-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnr-docto w-relat
ON LEAVE OF cnr-docto IN FRAME f-pg-sel /* Nro Docto */
DO:
    IF i-pais-impto-usuario = 21 THEN DO:
    
        IF  cnr-docto:SCREEN-VALUE IN FRAME f-pg-sel <> "0"
        AND cnr-docto:SCREEN-VALUE IN FRAME f-pg-sel <> "" THEN 
            assign cnr-docto:screen-value in frame f-pg-sel = left-trim(string(dec(input frame f-pg-sel cnr-docto),c-formato-nf)).
    END.
    ELSE DO:
        ASSIGN v-i-nro-docto = INT(cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
        
        IF ERROR-STATUS:ERROR = NO THEN DO:
            IF LENGTH(trim(cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME})) < 7 THEN
                ASSIGN cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING( "0000000" , 1 , 7 - LENGTH(trim(cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}))) + TRIM(cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cserie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON F5 OF cserie IN FRAME f-pg-sel /* SÇrie */
DO:
    assign l-implanta = yes.    
    {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo="cserie"
                       &campozoom="serie"
                       &frame="f-pg-sel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON MOUSE-SELECT-DBLCLICK OF cserie IN FRAME f-pg-sel /* SÇrie */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME l-nota-fisc-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-nota-fisc-fat w-relat
ON VALUE-CHANGED OF l-nota-fisc-fat IN FRAME f-pg-sel /* Nota Fiscal */
DO:

   ASSIGN INPUT FRAME f-pg-sel d-cot-var-cambial.

   IF SELF:CHECKED AND 
      AVAIL param-estoq-internac AND param-estoq-internac.log-atu-ce-var-camb AND 
      AVAIL param-imp AND param-imp.log-descons-iva-tit-mercad THEN
       ASSIGN d-cot-var-cambial:SENSITIVE IN FRAME {&FRAME-NAME} = YES.       
   ELSE
       ASSIGN d-cot-var-cambial:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
              d-cot-var-cambial:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME l-nf-simples-remessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-nf-simples-remessa w-relat
ON VALUE-CHANGED OF l-nf-simples-remessa IN FRAME f-pg-cla /* Nota Fiscal Simples Remessa */
DO:
    assign rs-classif-nf = 1.
    disp rs-classif-nf with frame f-pg-cla.

    if  input l-nf-simples-remessa THEN
        ASSIGN rs-classif-nf:SENSITIVE IN FRAME f-pg-cla = YES.
    ELSE
        ASSIGN rs-classif-nf           :SENSITIVE IN FRAME f-pg-cla = NO
               c-cta-aplic-nf          :SENSITIVE IN FRAME f-pg-cla = NO 
               c-ccusto-aplic-nf       :SENSITIVE IN FRAME f-pg-cla = NO.

    RUN pi-habilita-fatura.

    RUN pi-habilita-decl-imp.

    apply "VALUE-CHANGED":U to rs-classif-nf in frame f-pg-cla.
    apply "LEAVE":U to c-cta-aplic-nf in frame f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-classif-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-classif-nf w-relat
ON VALUE-CHANGED OF rs-classif-nf IN FRAME f-pg-cla
DO:
    assign c-cta-aplic-nf:screen-value in frame f-pg-cla = ''
           c-cta-aplic-nf = ''
           desc-cta-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           desc-cta-aplic-nf = ''
           c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           c-ccusto-aplic-nf = ''
           desc-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           desc-ccusto-aplic-nf = ''. 

    find first param-imp no-lock
         where param-imp.cod-estabel = INPUT FRAME f-pg-sel ccod-estabel NO-ERROR.

    if  avail param-imp then 
         assign c-conta-transit-import   = param-imp.ct-transit-import
                c-ccusto-transit-import  = param-imp.sc-transit-import.

    if  rs-classif-nf:sensitive then do:
        enable c-cta-aplic-nf with frame f-pg-cla.
        enable c-ccusto-aplic-nf with frame f-pg-cla.
        
        if  avail param-imp then do:
            assign c-cta-aplic-nf:screen-value    in frame f-pg-cla = param-imp.cod-cta-aplic-nf-simples-remes
                   c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = param-imp.cod-subconta-nf-simples-remes.
        end.

        if  input rs-classif-nf = 2 then do:
            assign c-ct-transit:screen-value in frame f-pg-sel = c-cta-aplic-nf:screen-value in frame f-pg-cla
                   c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
            ASSIGN c-cta-aplic-nf          :SENSITIVE IN FRAME f-pg-cla = NO
                   c-ccusto-aplic-nf       :SENSITIVE IN FRAME f-pg-cla = NO.
        end.
        ELSE DO:
            ASSIGN c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-conta-transit-import
                   c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-ccusto-transit-import.
        END.
    end.
    ELSE
        ASSIGN c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-conta-transit-import
               c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-ccusto-transit-import.
   /*
   ** Variavel "rs-classif-nf-aux" utilizada na trigger "on leave of cembarque"
   */
    ASSIGN rs-classif-nf-aux = rs-classif-nf.
    
    apply "LEAVE":U to c-cta-aplic-nf in frame f-pg-cla.  
    APPLY "LEAVE":U TO c-ct-transit IN FRAME f-pg-sel.
    APPLY "LEAVE":U TO cembarque IN FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-relat:handle ).
/* ******* Editado automaticamente para o projeto de facelift ******* */

{utp/ut9000.i "IM3100" "2.00.00.055"} /* 11/12/2025 08:58:33 */

do with frame f-relat:
    &IF "{&PGSEL}" <> "" &THEN
        if  im-pg-sel:load-image("image/im-fldup") then.
        assign im-pg-sel:height = 1.20
               im-pg-sel:row    = 1.50.
    &ENDIF
    
    &IF "{&PGCLA}" <> "" &THEN
        if  im-pg-cla:load-image("image/im-fldup") then.
        assign im-pg-cla:height = 1.20
               im-pg-cla:row    = 1.50.
    &ENDIF
end.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - inicio */
/************************************************************************************/
/************************************************************************************/
def var c-list-folders   as char no-undo.
def var i-current-folder as int  no-undo.
def var wh-label-sel     as widget-handle no-undo.
def var wh-label-cla     as widget-handle no-undo.

/**********************************************************
** Troca de pˇgina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/
&if "{&PGSEL}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-sel,":U.
&endif

&if "{&PGCLA}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-cla,":U.
&endif

if  substring(c-list-folders, length(c-list-folders)) = "," then
    assign c-list-folders = substring(c-list-folders, 1, length(c-list-folders) - 1).

on  CTRL-TAB,SHIFT-CTRL-TAB anywhere do:
    def var h_handle  as handle no-undo.
    def var c_imagem  as char   no-undo.
    def var l_direita as log    no-undo.
    l_direita = last-event:label = 'CTRL-TAB':U.

    block1:
    repeat:
        if  l_direita then
            assign i-current-folder = if i-current-folder = num-entries(c-list-folders) then 1 else i-current-folder + 1.
        else
            assign i-current-folder = if i-current-folder = 1 then num-entries(c-list-folders) else i-current-folder - 1.

        assign c_imagem = entry(i-current-folder, c-list-folders)
               h_handle = frame f-relat:first-child
               h_handle = h_handle:first-child.

        do  while valid-handle(h_handle):
            if  h_handle:type = 'image':U and
                h_handle:name = c_imagem  then do:
                if  h_handle:sensitive = no then next block1.
                apply 'mouse-select-click':U to h_handle.
                leave block1.
            end.
            h_handle = h_handle:next-sibling.
        end.
    end.
end.

/**********************************************************
** Procedure de troca de pˇgina por CTRL-TAB
**********************************************************/
procedure pi-first-child:
&IF "{&product_version}" >= "12.1.X.2307" &THEN
    {include/i-rpfch.i relDtv}
&ELSE
/* **** Editado automaticamente para o projeto de facelift **** */
    def input param wh-entry-folder as widget-handle.

    assign wh-entry-folder = wh-entry-folder:first-child
           wh-entry-folder = wh-entry-folder:first-child.

    do  while(valid-handle(wh-entry-folder)):
        if  wh-entry-folder:sensitive = yes       and
            wh-entry-folder:type <> 'rectangle':U and
            wh-entry-folder:type <> 'image':U     and
            wh-entry-folder:type <> 'browse':U    then do:
            apply 'entry':U to wh-entry-folder.
            leave.
        end.
        else
            assign wh-entry-folder = wh-entry-folder:next-sibling.
    end.
&ENDIF
end.
/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - final  */
/************************************************************************************/
/************************************************************************************/

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ccod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cembarque:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    ccod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cserie:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cnatureza:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    ccod-estabel-fisc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    c-ct-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    c-sc-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.

    RUN enable_UI.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.


/* Ajuste do formato do campo conta de acordo com o produto - EMS ou Magnus */    

find first param-global no-lock no-error.
ASSIGN c-empresa = param-global.empresa-prin.

/* inicializaá∆o dos valores de tela */
assign ddata-trans      :screen-value in frame f-pg-sel = string(today)
       ddata-emissao    :screen-value in frame f-pg-sel = string(today)
       ddata-di         :screen-value in frame f-pg-sel = string(today)
       ddata-cotacao    :screen-value in frame f-pg-sel = string(today)
       btpesoscubagem   :visible      in frame f-relat  = true.

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-dados-embarque w-relat 
PROCEDURE busca-dados-embarque :
    FOR EACH embarque-imp NO-LOCK USE-INDEX codigo
       WHERE embarque-imp.embarque    = cembarque:SCREEN-VALUE IN FRAME f-pg-sel
       AND   embarque-imp.cod-estabel = ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel:                

        IF embarque-imp.situacao = 2 THEN NEXT. 
    
        FIND FIRST param-imp WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.
        IF NOT AVAIL param-imp THEN NEXT.
        
        FIND FIRST historico-embarque WHERE
                   historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                   historico-embarque.embarque    = embarque-imp.embarque
                   NO-LOCK NO-ERROR.
    
        IF NOT AVAIL historico-embarque THEN NEXT.
        FIND itinerario WHERE
             itinerario.cod-itiner = historico-embarque.cod-itiner
             NO-LOCK NO-ERROR.
    
        IF NOT AVAIL itinerario THEN NEXT.
        
        RELEASE historico-embarque.
        
        FIND historico-embarque WHERE
             historico-embarque.cod-estabel   = embarque-imp.cod-estabel AND
             historico-embarque.embarque      = embarque-imp.embarque    AND
             historico-embarque.cod-itiner    = itinerario.cod-itiner    AND
             historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
             USE-INDEX pto-contr NO-LOCK NO-ERROR.
        
        IF NOT AVAIL historico-embarque THEN NEXT.
        FIND FIRST ordens-embarque WHERE
                   ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
                   ordens-embarque.embarque    = embarque-imp.embarque    NO-LOCK NO-ERROR.
             
        IF  AVAIL ordens-embarque THEN DO:
            FIND processo-imp WHERE
                 processo-imp.cod-estabel = ordens-embarque.cod-estabel AND
                 processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
                 NO-LOCK NO-ERROR.
            IF  AVAIL processo-imp THEN DO:
                ASSIGN ccod-estabel-fisc:SCREEN-VALUE IN FRAME f-pg-sel = processo-imp.estab-fisc.
                
                FIND FIRST emitente WHERE
                           emitente.cod-emitente = processo-imp.cod-exportador NO-LOCK NO-ERROR.
                IF  AVAIL emitente THEN
                    ASSIGN ccod-emitente:SCREEN-VALUE IN FRAME f-pg-sel = STRING(processo-imp.cod-exportador).
            END.
        END.

        assign c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel  = param-imp.ct-transit-import WHEN INPUT FRAME f-pg-cla rs-classif-nf <> 2 
               c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel  = param-imp.sc-transit-import WHEN INPUT FRAME f-pg-cla rs-classif-nf <> 2
               ccod-decl-imp:SCREEN-VALUE IN FRAME f-pg-sel = embarque-imp.declaracao-import
               ddata-di:SCREEN-VALUE IN FRAME f-pg-sel      = STRING(embarque-imp.data-di).

    end.
    
    APPLY "LEAVE":U TO c-ct-transit IN FRAME f-pg-sel.

    return "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-sel im-pg-cla bt-executar bt-cancelar btpesoscubagem 
         bt-gtos-aduana btconferencia bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY l-nf-simples-remessa rs-classif-nf 
          c-cta-aplic-nf desc-cta-aplic-nf c-ccusto-aplic-nf 
          desc-ccusto-aplic-nf 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE l-nf-simples-remessa rs-classif-nf 
         c-cta-aplic-nf c-ccusto-aplic-nf 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY cembarque ccod-estabel ccod-emitente ddata-trans ddata-emissao 
          cnr-docto cserie cnatureza ccod-estabel-fisc ddata-cotacao ccod-decl-imp
          d-cotacao ddata-di cb-tipo-comprov c-ct-transit fi-c-desc-conta c-sc-transit 
          fi-c-desc-ccusto f-estab-fat f-pto-vda f-timbrado f-dt-vto 
          l-envia-dep-ext l-att-docto-receb-auto l-nota-fisc-fat EDITOR-2 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE cembarque ccod-estabel ccod-emitente ddata-trans ddata-emissao 
         cnr-docto cserie cnatureza ccod-estabel-fisc ddata-cotacao ccod-decl-imp
         d-cotacao ddata-di cb-tipo-comprov c-ct-transit c-sc-transit f-estab-fat f-pto-vda 
         f-timbrado f-dt-vto l-envia-dep-ext l-att-docto-receb-auto l-nota-fisc-fat EDITOR-2 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-relat 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finanáas -> handle Conta Cont†bil */
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finanáas -> handle Centro de Custo */
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    IF i-pais-impto-usuario = 9 /* Paraguai */  THEN DO:
        IF VALID-HANDLE(h-bopy2003) THEN
            RUN destroy IN h-bopy2003.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-relat 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  NOT VALID-HANDLE(h-boar0178) THEN
          RUN local/arg/boar0178.p PERSISTENT SET h-boar0178.
  END.

  IF i-pais-impto-usuario = 9 THEN
       IF NOT VALID-HANDLE(h-bopy2003) THEN
          RUN local/pry/bopy2003.p PERSISTENT SET h-bopy2003.

  IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN inbo/boin682.p PERSISTENT SET h-boin682.
  RUN openQueryStatic IN h-boin682 (INPUT "MAIN":U) NO-ERROR.
  RUN findfirst IN h-boin682.
  RUN GetIntField IN h-boin682  (INPUT "empresa-prin":U,
                                 OUTPUT i-empresa-prin).

  /* Chamada EPC */
  IF  c-nom-prog-upc-mg97 <> "" THEN DO:
      RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-INITIALIZE", 
                                      INPUT "CONTAINER",
                                      INPUT THIS-PROCEDURE,
                                      INPUT FRAME {&FRAME-NAME}:HANDLE,
                                      INPUT ?,
                                      INPUT ?) NO-ERROR.
  END.
  
  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      ASSIGN bt-gtos-aduana:visible in frame f-relat = TRUE.
      ENABLE bt-gtos-aduana WITH FRAME f-relat.
  END.
  ELSE DO:
      ASSIGN bt-gtos-aduana:visible in frame f-relat = FALSE.
  END.

  IF NOT AVAIL param-estoq THEN
      FOR FIRST param-estoq NO-LOCK: END.

  IF NOT AVAIL param-estoq-internac THEN
      FOR FIRST param-estoq-internac NO-LOCK: END.

  IF NOT AVAIL param-global THEN
      FOR FIRST param-global NO-LOCK: END.   

  IF NOT (AVAIL param-estoq-internac AND param-estoq-internac.log-atu-ce-var-camb) THEN
      ASSIGN d-cot-var-cambial:HIDDEN IN FRAME f-pg-sel = YES.

  /*Quando tem valor na param-estoq deve ser considerado o que est† nesse campo e n∆o na param-global*/
  IF  SUBSTRING(param-estoq.char-2,68,1) <> "" THEN
      ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S").
  ELSE DO:
      {cdp/cd4300.i4  "yes" param-global.char-2}             
      {cdp/cd0101.i51 "yes"}
  END.

  IF  NOT l-ut-ser  /*n∆o utiliza serie*/
      AND i-pais-impto-usuario <> 1 /*brasil*/ THEN
      ASSIGN cserie:HIDDEN       IN FRAME {&FRAME-NAME} = YES
             cserie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,69,5).

  if i-pais-impto-usuario = 21 /*Ecuador*/ then do:
     assign cnr-docto:format in frame {&FRAME-NAME} = "x(15)".

     assign c-formato-nf = "999999999999999". /* Formato de 15 posiá‰es */

     IF  cnr-docto:SCREEN-VALUE IN FRAME f-pg-sel <> "0"
     AND cnr-docto:SCREEN-VALUE IN FRAME f-pg-sel <> "" THEN DO:

         if length(left-trim(string(input frame f-pg-sel cnr-docto, c-formato-nf))) > length(c-formato-nf) then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 36151, 
                               input length(c-formato-nf)).

            apply "entry":U to cnr-docto in frame f-pg-sel.
            return "NOK":U.
         end. 
         assign cnr-docto:screen-value in frame f-pg-sel = left-trim(string(dec(input frame f-pg-sel cnr-docto),c-formato-nf)).
     END.
  end.

  ASSIGN l-envia-dep-ext:HIDDEN IN FRAME {&FRAME-NAME} = YES.  

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
    ASSIGN cnr-docto:FORMAT IN FRAME f-pg-sel        = "x(7)"
           f-timbrado:VISIBLE IN FRAME f-pg-sel      = TRUE
           f-dt-vto:VISIBLE IN FRAME f-pg-sel        = TRUE
           f-estab-fat:VISIBLE IN FRAME f-pg-sel     = TRUE
           f-pto-vda:VISIBLE IN FRAME f-pg-sel       = TRUE
           cb-tipo-comprov:VISIBLE IN FRAME f-pg-sel = TRUE.
           
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        ASSIGN cAuxTraducao001 = {local/pry/py2inc/i00py2008.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-comprov:LIST-ITEM-PAIRS in frame f-pg-sel = cAuxTraducao001.
        ASSIGN cb-tipo-comprov:SCREEN-VALUE IN FRAME {&frame-name} = entry(2, cb-tipo-comprov:LIST-ITEM-PAIRS).
    &else
        ASSIGN cb-tipo-comprov:LIST-ITEMS in frame f-pg-sel = {local/pry/py2inc/i00py2008.i 03}.
        ASSIGN cb-tipo-comprov:SCREEN-VALUE IN FRAME {&frame-name} = entry(1, cb-tipo-comprov:LIST-ITEMS)
    &endif 
  END.
  ELSE DO:
    ASSIGN f-timbrado:VISIBLE IN FRAME f-pg-sel      = FALSE
           f-dt-vto:VISIBLE IN FRAME f-pg-sel        = FALSE
           f-estab-fat:VISIBLE IN FRAME f-pg-sel     = FALSE
           f-pto-vda:VISIBLE IN FRAME f-pg-sel       = FALSE
           cb-tipo-comprov:VISIBLE IN FRAME f-pg-sel = FALSE.
  END.

  apply "VALUE-CHANGED":U to l-nota-fisc-fat      in frame f-pg-sel.
  apply "VALUE-CHANGED":U to l-nf-simples-remessa in frame f-pg-cla.
  APPLY "entry":U TO cEmbarque IN FRAME f-pg-sel.
  RETURN NO-APPLY.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error on stop  undo, return error:

    DEFINE VARIABLE l-emite-duplic  AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE i-cont-nr-serie AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-tipo-nf-simples-remessa AS INT   NO-UNDO.
    DEFINE VARIABLE l-cont-lote-nota-mae AS LOGICAL    NO-UNDO.

    ASSIGN INPUT FRAME f-pg-sel
           cembarque
           ccod-estabel
           ccod-emitente
           ddata-trans
           ddata-emissao 
           cnr-docto
           cserie
           cnatureza 
           ccod-estabel-fisc 
           c-ct-transit
           c-sc-transit
           ccod-decl-imp 
           ddata-di 
           ddata-cotacao
           d-cot-var-cambial
           d-cotacao
           editor-2 NO-ERROR.
     
    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

        ASSIGN INPUT FRAME f-pg-sel
               f-timbrado
               f-dt-vto
               f-estab-fat
               f-pto-vda NO-ERROR. 
           
        RUN pi-valida-campos IN h-bopy2003 (INPUT cnr-docto,
                                            INPUT ccod-emitente,
                                            INPUT ddata-emissao,
                                            INPUT f-timbrado,
                                            INPUT f-dt-vto,
                                            INPUT f-estab-fat,
                                            INPUT f-pto-vda,
                                            INPUT {local/pry/py2inc/i00py2008.i 06 cb-tipo-comprov:SCREEN-VALUE IN FRAME {&frame-name}},
                                            OUTPUT TABLE tt-bo-erro).

        IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
            IF NOT VALID-HANDLE(hShowMsg) THEN
                run utp/showmessage.w PERSISTENT SET hShowMsg.
            ELSE DO:
                DELETE PROCEDURE hShowMsg.
                run utp/showmessage.w PERSISTENT SET hShowMsg.
            END.
            RUN setModal     IN hShowMsg (INPUT YES).
            run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
            RETURN NO-APPLY.
        END.
              
    END.

    FOR EACH tt-itens-aux: 
        DELETE tt-itens-aux. 
    END.

    ASSIGN i-seq-item-serie = 0.

    IF  i-pais-impto-usuario = 21 THEN DO:
        FIND FIRST param-estoq NO-LOCK NO-ERROR.
        IF  AVAIL param-estoq AND SUBSTRING(param-estoq.char-2,68,1) = "N" THEN DO:           
            ASSIGN cserie = SUBSTR(param-estoq.char-2,69,5).
        END.
    END.

    if valid-handle(h-bocx220a) then
        delete procedure h-bocx220a.
    run cxbo/bocx220a.p persistent set h-bocx220a.

    IF l-executar THEN DO:

        IF INPUT FRAME f-pg-cla l-nf-simples-remessa THEN
            ASSIGN i-tipo-nf-simples-remessa = INPUT FRAME f-pg-cla rs-classif-nf.
        ELSE
            ASSIGN i-tipo-nf-simples-remessa = 0.

        RUN findDocumentoImp IN h-bocx220a (INPUT ccod-estabel,
                                            INPUT cembarque,
                                            INPUT ccod-emitente,
                                            INPUT i-tipo-nf-simples-remessa, 
                                            OUTPUT c-numero-docto,
                                            OUTPUT c-serie-docto,
                                            OUTPUT c-emitente-docto,
                                            OUTPUT c-nat-operacao).
        IF RETURN-VALUE = ""     OR
           RETURN-VALUE = "OK":U THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.errorsubtype = "Question".
            {utp/ut-liter.i Embarque_j†_possui_um_documento_gerado_no_recebimento * }
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 30152,
                               INPUT RETURN-VALUE + "~~" +
                                     string(c-numero-docto) + "~~" +
                                     string(c-serie-docto) + "~~" +
                                     string(c-emitente-docto) + "~~" +
                                     string(c-nat-operacao)).
            IF RETURN-VALUE = "NO" THEN DO:
               SESSION:SET-WAIT-STATE("":U).
               RETURN NO-APPLY.
            END.
        END.
    END.

    IF d-cot-var-cambial:SENSITIVE IN FRAME f-pg-sel THEN DO:
        IF d-cot-var-cambial = 0 THEN DO:
            {utp/ut-liter.i "Cotaá∆o da Variaá∆o Cambial" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 7965,
                               INPUT TRIM(RETURN-VALUE)). /* &1 deve ser diferente de 0. */
            SESSION:SET-WAIT-STATE("":U).
            RETURN NO-APPLY.
        END.
    END.
    
    IF d-cotacao = 0 THEN DO:
        {utp/ut-liter.i "Cotaá∆o Moeda" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 7965,
                           INPUT TRIM(RETURN-VALUE)). /* &1 deve ser diferente de 0. */
        SESSION:SET-WAIT-STATE("":U).
        RETURN NO-APPLY.
    END.

    for each tt-parametros:
        delete tt-parametros.
    end.    

    create tt-parametros.
    assign tt-parametros.cod-estabel          = ccod-estabel
           tt-parametros.embarque             = cembarque
           tt-parametros.cod-emitente         = ccod-emitente
           tt-parametros.da-transacao         = ddata-trans
           tt-parametros.da-emissao           = ddata-emissao
           tt-parametros.nro-docto            = cnr-docto
           tt-parametros.serie                = cserie
           tt-parametros.nat-operacao         = cnatureza
           tt-parametros.estab-fisc           = ccod-estabel-fisc
           tt-parametros.ct-transit           = c-ct-transit
           tt-parametros.sc-transit           = c-sc-transit
           tt-parametros.declaracao-import    = ccod-decl-imp
           tt-parametros.da-di                = ddata-di
           tt-parametros.da-cotacao           = ddata-cotacao
           tt-parametros.observacao           = editor-2
           tt-parametros.usuario              = v_cod_usuar_corren
           tt-parametros.i-pais-impto-usuario = i-pais-impto-usuario
           tt-parametros.d-cotacao            = d-cotacao.

    if l-nota-fisc-fat:hidden in frame f-pg-sel = no then
        assign l-nff = input frame f-pg-sel l-nota-fisc-fat
               tt-parametros.nff = l-nff.

    IF l-trata-dep-ext THEN
        ASSIGN tt-parametros.envia-dep-ext = l-envia-dep-ext:CHECKED IN FRAME {&FRAME-NAME}
               l-dep-ext                   = l-envia-dep-ext:CHECKED IN FRAME {&FRAME-NAME}.
    ELSE
        ASSIGN l-dep-ext = NO.

    assign tt-parametros.l-nf-simples-remessa     = input frame f-pg-cla l-nf-simples-remessa
           tt-parametros.idi-nf-simples-remes     = input frame f-pg-cla rs-classif-nf
           tt-parametros.conta-contabil           = input frame f-pg-cla c-cta-aplic-nf
           tt-parametros.ct-codigo                = input frame f-pg-cla c-cta-aplic-nf
           tt-parametros.sc-codigo                = input frame f-pg-cla c-ccusto-aplic-nf.

    run setAcompanhamento in h-bocx220a (input yes).

    RUN ValidaEmitenteEmbarque IN h-bocx220a (INPUT TABLE tt-parametros,
                                              OUTPUT l-emit-diferente,
                                              OUTPUT l-fornec-fundap).

    IF  l-emit-diferente THEN DO:
        FIND FIRST param-re NO-LOCK
             WHERE param-re.usuario = v_cod_usuar_corren NO-ERROR.
        IF  NOT AVAIL param-re OR param-re.rec-out-for = NO THEN DO:
            run utp/ut-msgs.p (input "show":U,
                           INPUT 8851,
                           input ccod-emitente).
            SESSION:SET-WAIT-STATE("":U).
            RETURN NO-APPLY.
        END.

        run utp/ut-msgs.p (input "show":U,
                           INPUT 28666,
                           input ccod-emitente).
    END.
    
    IF l-fornec-fundap THEN DO:        
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 27238,
                           INPUT ""). /* Pa°s do emitente igual ao pa°s do estabelecimento. */
        SESSION:SET-WAIT-STATE("":U).
        RETURN NO-APPLY.
    END.

    IF  CAN-FIND(FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = cnatureza
                   AND natur-oper.imp-nota) THEN DO:
        ASSIGN i-tst-docto = INT(cnr-docto) NO-ERROR.
        IF  ERROR-STATUS:ERROR THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 30511,
                               INPUT cnr-docto).
            SESSION:SET-WAIT-STATE("":U).
            RETURN NO-APPLY.
        END.
    END.   
    
    //Controla lote do item na nota m∆e
    FIND FIRST natur-operac-internac NO-LOCK 
         WHERE natur-operac-internac.cod-natur-operac = cnatureza NO-ERROR.
    IF AVAIL natur-operac-internac THEN
        ASSIGN l-cont-lote-nota-mae = natur-operac-internac.log-livre-1.
    ELSE
        ASSIGN l-cont-lote-nota-mae = NO.
    
    RUN pi-valida-conta-contabil IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN DO:
        SESSION:SET-WAIT-STATE("":U).
        RETURN NO-APPLY.
    END.

    run validarParametrosdesembarque in h-bocx220a (input  table tt-parametros,
                                                    output table tt-bo-erro).

    IF CAN-FIND(FIRST tt-bo-erro) THEN do:
        assign c-num-embarque = "".    
        IF NOT VALID-HANDLE(hShowMsg) THEN
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        if valid-handle(h-bocx220a) then
            delete procedure h-bocx220a.
        leave.
    end.

    /*inicio validacoes Nota Fiscal Simples Remessa*/
    IF  INPUT FRAME f-pg-cla l-nf-simples-remessa /*Nota Fiscal Simples Remessa*/  AND INPUT FRAME f-pg-cla rs-classif-nf = 1 /*Nota Mae*/ THEN DO:
        RUN ValidaNotaFiscalMaeSimplesRemessa   IN h-bocx220a (INPUT tt-parametros.ct-codigo, OUTPUT TABLE tt-bo-erro).            
    END.
    /*fim validacoes Nota Fiscal Simples Remessa*/

    /* 
    ** s¢ deleta a tt-item-doc-est se o numero do embarque for diferente do embarque anterior, sen∆o
    ** o programa im0100a.w abre com os dados carregados 
    */
    if  cembarque <> c-num-embarque then do:
        IF l-executar  THEN
            assign c-num-embarque = cembarque.

        for each tt-item-doc-est:
            delete tt-item-doc-est.
        end.
        assign l-chama-carregado = no.
    end.
    else 
        assign l-chama-carregado = yes.     

    IF CAN-FIND(FIRST tt-bo-erro) THEN do:
        assign c-num-embarque = "".    
        IF NOT VALID-HANDLE(hShowMsg) THEN
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        if valid-handle(h-bocx220a) then
            delete procedure h-bocx220a.
        leave.
    end.
    else do:

        /* Executa programa para solicitar dados do pedimento/despacho plaza */
        IF  l-executar = YES
        AND NOT(INPUT FRAME f-pg-cla l-nf-simples-remessa /*Nota Fiscal Simples Remessa*/  AND INPUT FRAME f-pg-cla rs-classif-nf = 1 /*Nota Mae*/)
        AND CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "spp-controle-aduana-internac"
                       AND funcao.ativo     = YES) THEN DO:
            
            ASSIGN w-relat:SENSITIVE = NO.
            RUN imp/im3100b.w (INPUT INPUT ccod-decl-imp,
                               INPUT INPUT ddata-di,
                               OUTPUT l-ok,
                               OUTPUT TABLE tt-docto-estoq-internac).
            ASSIGN w-relat:SENSITIVE = YES.

            IF  l-ok = NO THEN
                RETURN NO-APPLY.
        END.

        IF d-cot-var-cambial <> 0 THEN DO:
            FIND FIRST tt-docto-estoq-internac EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL tt-docto-estoq-internac THEN DO:
                CREATE tt-docto-estoq-internac.
                ASSIGN tt-docto-estoq-internac.data-di = ddata-di /* Campo obrigat¢rio */. 
            END.
    
            ASSIGN tt-docto-estoq-internac.cotacao-ce = d-cot-var-cambial.
        END.

        run gerarItensdesembarque in h-bocx220a (input        table tt-parametros,
                                                 input-output table tt-item-doc-est,
                                                 output       table tt-bo-erro).
        
        if not can-find(first tt-bo-erro) then do:            
            
            RUN isTransfDrawback IN h-bocx220a (INPUT TABLE tt-parametros,
                                                OUTPUT l-trans-drawback).

            IF  l-executar = YES 
            AND NOT l-trans-drawback THEN DO:
                find first tt-item-doc-est
                     where tt-item-doc-est.tipo-con-est > 1 no-error.
                if avail tt-item-doc-est then do:
                    /* 
                    ** se na tt-item-doc-est tiver algum item diferente de serial 
                    ** Ç chamado o programa im0100a.w 
                    */
                    if l-chama-carregado = no then do:
                        for each tt-recebe:
                            delete tt-recebe.
                        end.                   
                        FOR EACH tt-itens-aux: 
                            DELETE tt-itens-aux. 
                        END.
                        for each tt-item-doc-est 
                            where tt-item-doc-est.tipo-con-est <> 2:

                            create tt-recebe. 
                            assign tt-recebe.quantidade-informada  = 0
                                   tt-recebe.quantidade-total      = tt-item-doc-est.quantidade
                                   tt-recebe.quantidade-a-informar = tt-item-doc-est.quantidade
                                   tt-recebe.numero-ordem          = tt-item-doc-est.numero-ordem
                                   tt-recebe.parcela               = tt-item-doc-est.parcela
                                   tt-recebe.preco-total           = tt-item-doc-est.preco-total
                                   tt-recebe.preco-total-mo        = tt-item-doc-est.preco-total-mo
                                   tt-recebe.peso-liquido-total    = tt-item-doc-est.peso-liquido.
                         end.

                    end.

                    IF  (INPUT FRAME f-pg-cla l-nf-simples-remessa      /*    Nota Fiscal Simples Remessa */ 
                    AND  INPUT FRAME f-pg-cla rs-classif-nf = 1         /* E  Nota M∆e */ 
                    AND  l-cont-lote-nota-mae)                          /* E  Controla lote do item na nota m∆e */
                    OR  (INPUT FRAME f-pg-cla l-nf-simples-remessa      /* OU Nota Fiscal Simples Remessa */ 
                    AND  INPUT FRAME f-pg-cla rs-classif-nf <> 1)       /* E  N∆o Ç Nota M∆e */ 
                    OR  (NOT INPUT FRAME f-pg-cla l-nf-simples-remessa) /* OU N∆o Ç Nota Fiscal Simples Remessa */ 
                    THEN DO:

                        ASSIGN i-seq-item-serie = 0.
                        /* Quebra a tt-item-doc-est quando existir item controlado por numero de serie para gerar os movimentos de estoque */
                        FOR EACH tt-item-doc-est:
                            IF  tt-item-doc-est.tipo-con-est = 2 then do:
                                ASSIGN i-quebra = 0.
                                REPEAT:
                                    ASSIGN i-quebra         = i-quebra + 1
                                           i-seq-item-serie = i-seq-item-serie + 1.
        
                                    CREATE tt-itens-aux.
                                    BUFFER-COPY tt-item-doc-est EXCEPT sequencial TO tt-itens-aux.
                                    ASSIGN tt-itens-aux.quantidade   = 1
                                           tt-itens-aux.qtd-do-forn  = 1
                                           tt-itens-aux.tipo-con-est = 2                                                          
                                           tt-itens-aux.sequencial   = i-seq-item-serie.
                        
                                    IF i-quebra = tt-item-doc-est.quantidade THEN LEAVE.
                                END. /* REPEAT: */
                            END. /* IF  tt-item-doc-est.tipo-con-est = 2 */
                            ELSE DO:
                                ASSIGN i-seq-item-serie = i-seq-item-serie + 1.
                                CREATE tt-itens-aux.
                                BUFFER-COPY tt-item-doc-est EXCEPT sequencial TO tt-itens-aux.
                                ASSIGN tt-itens-aux.sequencial = i-seq-item-serie.
                            END. /* ELSE DO: */
                        END.

                        run imp/im0100a.w (input-output table tt-itens-aux,
                                           input-output table tt-recebe, 
                                           input l-chama-carregado, 
                                           INPUT l-dep-ext,
                                           output table tt-bo-erro).
    
                        FOR EACH tt-item-doc-est:
                            DELETE tt-item-doc-est.
                        END.
    
                        FOR EACH tt-itens-aux:
                            FIND FIRST tt-item-doc-est NO-LOCK
                                WHERE tt-item-doc-est.numero-ordem = tt-itens-aux.numero-ordem
                                  AND tt-item-doc-est.parcela      = tt-itens-aux.parcela NO-ERROR.
                            IF  NOT AVAIL tt-item-doc-est THEN DO:
    
                                CREATE tt-item-doc-est.
                                BUFFER-COPY tt-itens-aux TO tt-item-doc-est.
                            END.
                            ELSE DO:
                                ASSIGN tt-item-doc-est.quantidade   = tt-item-doc-est.quantidade   + tt-itens-aux.quantidade
                                       tt-item-doc-est.qtd-do-forn  = tt-item-doc-est.qtd-do-forn  + tt-itens-aux.qtd-do-forn
                                       tt-item-doc-est.peso-liquido = tt-item-doc-est.peso-liquido + tt-itens-aux.peso-liquido
                                       tt-item-doc-est.peso-bruto   = tt-item-doc-est.peso-bruto   + tt-itens-aux.peso-bruto.
                            END.                                                           
                        END.
    
                        IF  NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                            run calculaValoresInternacional in h-bocx220a (input        table tt-parametros,
                                                                           input-output table tt-itens-aux,
                                                                           output       table tt-bo-erro).
    
                            run calculaValoresInternacional in h-bocx220a (input        table tt-parametros,
                                                                           input-output table tt-item-doc-est,
                                                                           output       table tt-bo-erro).
                        END.

                        /* 
                        ** procedimento criado para saber se foi clicado em cancela no programa im0100a.w,
                        ** mostra na  tela a mensagem "O desembarque n∆o pode ser efetuado", e p†ra 
                        ** a execuá∆o do programa 
                        */           
                        find first tt-item-doc-est 
                            where tt-item-doc-est.lote         =  "" 
                              and tt-item-doc-est.tipo-con-est <> 1 no-error.
                        if avail tt-item-doc-est then do:
                            find first tt-bo-erro no-error.
                            if not avail tt-bo-erro then do:
                                run utp/ut-msgs.p (input "msg":U,
                                                   input 19522,
                                                   input return-value).
                                create tt-bo-erro.
                                assign tt-bo-erro.i-sequen = 1
                                       tt-bo-erro.cd-erro  = 19522
                                       tt-bo-erro.mensagem = return-value.    
                            end.
                        end.

                       

                    END.
                    ELSE DO: /* Nota Remessa M∆e e N∆o Controla lote do item na nota m∆e */

                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 34141, INPUT "").
                        
                        FOR EACH tt-item-doc-est EXCLUSIVE-LOCK BREAK BY tt-item-doc-est.it-codigo:
                            CASE tt-item-doc-est.tipo-con-est:
                                WHEN 2 THEN DO:
                                    IF FIRST-OF (tt-item-doc-est.it-codigo) THEN ASSIGN i-cont-nr-serie = 1.
                                    ASSIGN tt-item-doc-est.lote = "LNSRMX" + STRING(i-cont-nr-serie)
                                           i-cont-nr-serie      = i-cont-nr-serie + 1.
                                    FOR EACH  tt-itens-aux
                                        WHERE tt-itens-aux.numero-ordem  = tt-item-doc-est.numero-ordem
                                        AND   tt-itens-aux.parcela       = tt-item-doc-est.parcela:
                                        ASSIGN tt-itens-aux.lote = "LNSRMX" + STRING(i-cont-nr-serie).
                                    END. /* FOR EACH  tt-itens-aux */
                                END. /* WHEN 2 THEN */
                                WHEN 3 THEN DO:
                                    ASSIGN tt-item-doc-est.lote         = "LNSRMX"
                                           tt-item-doc-est.dt-vali-lote = 12/31/9999.
                                    FOR EACH  tt-itens-aux
                                        WHERE tt-itens-aux.numero-ordem  = tt-item-doc-est.numero-ordem
                                        AND   tt-itens-aux.parcela       = tt-item-doc-est.parcela:
                                        ASSIGN tt-itens-aux.lote         = "LNSRMX"
                                               tt-itens-aux.dt-vali-lote = 12/31/9999.
                                    END. /* FOR EACH  tt-itens-aux */
                                END. /* WHEN 3 THEN */
                                WHEN 4 THEN DO:
                                    ASSIGN tt-item-doc-est.lote         = "LNSRMX"
                                           tt-item-doc-est.dt-vali-lote = 12/31/9999.
                                    RUN inbo/boin375.p PERSISTENT SET h-boin375.
                                    RUN buscaReferenciaPadrao IN h-boin375 (INPUT  tt-item-doc-est.it-codigo, OUTPUT tt-item-doc-est.cod-refer).
                                    FOR EACH  tt-itens-aux
                                        WHERE tt-itens-aux.numero-ordem  = tt-item-doc-est.numero-ordem
                                        AND   tt-itens-aux.parcela       = tt-item-doc-est.parcela:
                                        ASSIGN tt-itens-aux.lote         = "LNSRMX"
                                               tt-itens-aux.dt-vali-lote = 12/31/9999
                                               tt-itens-aux.cod-refer    = tt-item-doc-est.cod-refer.
                                    END. /* FOR EACH  tt-itens-aux */
                        
                                    IF  VALID-HANDLE(h-boin375) THEN DO:
                                        DELETE PROCEDURE h-boin375.
                                        ASSIGN h-boin375 = ?.
                                    END. /* IF  VALID-HANDLE(h-boin375) */
                                END. /* WHEN 4 THEN */
                            END CASE. /* CASE tt-item-doc-est.tipo-con-est: */
                        END.
                        
                        ASSIGN l-chama-carregado = YES.

                    END.
                end.            
                
                IF  INPUT FRAME f-pg-cla l-nf-simples-remessa /* Nota Fiscal Simples Remessa */ 
                AND INPUT FRAME f-pg-cla rs-classif-nf = 2    /* Nota Filha                  */
                THEN DO: 
                    FOR EACH tt-item-doc-est:
                        RUN pi-docto-relac-nota-filha.
                    END.    
                END.    
            END.
            ELSE DO:
                /*Se n∆o for nacionalizaá∆o n∆o ir† solicitar que o usu†rio informe lote, numero de sÇrie e referencia,
                  essas informaá‰es ser∆o preenchidas com um lote fict°cio conforme abaixo para evitar validaá‰es do recebimento*/
                ASSIGN i-contador = 1.
                FOR EACH tt-item-doc-est:
                    IF  tt-item-doc-est.tipo-con-est = 2 then do:
                        ASSIGN i-quebra = 0.
                        REPEAT:
                            ASSIGN i-quebra         = i-quebra + 1
                                   i-seq-item-serie = i-seq-item-serie + 1.

                            CREATE tt-itens-aux.
                            BUFFER-COPY tt-item-doc-est EXCEPT sequencial TO tt-itens-aux.
                            ASSIGN tt-itens-aux.quantidade   = 1 
                                   tt-itens-aux.qtd-do-forn  = 1
                                   tt-itens-aux.tipo-con-est = 2                                                          
                                   tt-itens-aux.sequencial   = i-seq-item-serie.
            
                            /*Se n∆o for nacionalizaá∆o n∆o ir† solicitar que o usu†rio informe lote, numero de sÇrie e referencia,
                            essas informaá‰es ser∆o preenchidas com um lote fict°cio conforme abaixo para evitar validaá‰es do recebimento*/
                            IF tt-itens-aux.lote = "" THEN DO:
                                ASSIGN tt-itens-aux.lote = "zawbvcts" + STRING(i-contador,"9999":U)
                                       tt-itens-aux.situacao = YES
                                       tt-itens-aux.dt-vali-lote = 12/31/9999.
                                ASSIGN i-contador = i-contador + 1.
        
                                IF tt-itens-aux.tipo-con-est = 4 THEN DO:
                                    RUN inbo/boin375.p PERSISTENT SET h-boin375.
                                    RUN buscaReferenciaPadrao IN h-boin375 (INPUT  tt-item-doc-est.it-codigo, OUTPUT tt-itens-aux.cod-refer).
                                    DELETE PROCEDURE h-boin375.
                                END.
                            END.

                            IF i-quebra = tt-item-doc-est.quantidade THEN LEAVE.
                        END. /* REPEAT: */
                    END. /* IF  tt-item-doc-est.tipo-con-est = 2 */
                    ELSE DO:
                        ASSIGN i-seq-item-serie = i-seq-item-serie + 1.
                        CREATE tt-itens-aux.
                        BUFFER-COPY tt-item-doc-est EXCEPT sequencial TO tt-itens-aux.
                        ASSIGN tt-itens-aux.sequencial = i-seq-item-serie.

                        /*Se n∆o for nacionalizaá∆o n∆o ir† solicitar que o usu†rio informe lote, numero de sÇrie e referencia,
                        essas informaá‰es ser∆o preenchidas com um lote fict°cio conforme abaixo para evitar validaá‰es do recebimento*/
                        IF tt-itens-aux.lote = "" THEN DO:
                            ASSIGN tt-itens-aux.lote = "zawbvcts" + STRING(i-contador,"9999":U)
                                   tt-itens-aux.situacao = YES
                                   tt-itens-aux.dt-vali-lote = 12/31/9999.
                            ASSIGN i-contador = i-contador + 1.
    
                            IF tt-itens-aux.tipo-con-est = 4 THEN DO:
                                RUN inbo/boin375.p PERSISTENT SET h-boin375.
                                RUN buscaReferenciaPadrao IN h-boin375 (INPUT  tt-item-doc-est.it-codigo, OUTPUT tt-itens-aux.cod-refer).
                                DELETE PROCEDURE h-boin375.
                            END.
                        END.
                    END. /* ELSE DO: */
                END.

                EMPTY TEMP-TABLE tt-item-doc-est.

                FOR EACH tt-itens-aux:
                    FIND FIRST tt-item-doc-est NO-LOCK
                        WHERE tt-item-doc-est.numero-ordem = tt-itens-aux.numero-ordem
                          AND tt-item-doc-est.parcela      = tt-itens-aux.parcela NO-ERROR.
                    IF  NOT AVAIL tt-item-doc-est THEN DO:

                        CREATE tt-item-doc-est.
                        BUFFER-COPY tt-itens-aux TO tt-item-doc-est.
                    END.
                    ELSE DO:
                        ASSIGN tt-item-doc-est.quantidade  = tt-item-doc-est.quantidade  + tt-itens-aux.quantidade
                               tt-item-doc-est.qtd-do-forn = tt-item-doc-est.qtd-do-forn + tt-itens-aux.qtd-do-forn.
                    END.
                END.

                IF  NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                    run calculaValoresInternacional in h-bocx220a (input        table tt-parametros,
                                                                   input-output table tt-itens-aux,
                                                                   output       table tt-bo-erro).

                    run calculaValoresInternacional in h-bocx220a (input        table tt-parametros,
                                                                   input-output table tt-item-doc-est,
                                                                   output       table tt-bo-erro).
                END.
            END.

            if not can-find(first tt-bo-erro) then do:

                /* Executa procedure para atualizar dados de aduana */                
                RUN atualizaDoctoInternac IN h-bocx220a (INPUT TABLE tt-docto-estoq-internac).

                if l-chama-carregado = yes then do:
                    for each tt-item-doc-est:
                        assign tt-item-doc-est.situacao = yes.
                    end.
                end.

                run executarDesembarque in h-bocx220a (input  table tt-parametros,
                                                       input  table tt-item-doc-est,
                                                       INPUT  TABLE tt-itens-aux,
                                                       output table tt-bo-erro,
                                                       output table tt-retorno).
            end.
            else
                assign c-num-embarque = "".

        end.
        else
            assign c-num-embarque = "".

        /*Se n∆o for nacionalizaá∆o e foi informado lote fict°cio, zera as informaá‰es do lote, referencia ou numero de serie,
        para n∆o abrir o im0100a carregado caso o usu†rio nacionalize o embarque sem fechar o programa im0100*/
        FOR EACH tt-item-doc-est:
            IF tt-item-doc-est.lote = "zawbvcts99" THEN DO:
                ASSIGN tt-item-doc-est.lote = ""
                       tt-item-doc-est.situacao = NO
                       tt-item-doc-est.dt-vali-lote = ?
                       tt-item-doc-est.cod-refer = "".
            END.
        END.

        find first tt-bo-erro no-error.
        if avail tt-bo-erro then do:
            if not valid-handle(hShowMsg) then
                run utp/showmessage.w persistent set hShowMsg.
            ELSE DO:
                delete procedure hShowMsg.            
                run utp/showmessage.w persistent set hShowMsg.
            END.
            assign l-verifica-erro = no.            
            RUN setModal     IN hShowMsg (INPUT YES).
            run showMessages IN hShowMsg (input table tt-bo-erro).                        
            if valid-handle(h-bocx220a) then
                delete procedure h-bocx220a.
            leave.
        end.
        else do:
            IF NOT l-executar THEN DO:
                RUN pi-gera-relat-acomp IN THIS-PROCEDURE.
            END.
            ELSE DO:

                IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

                    FIND FIRST docum-est
                         WHERE docum-est.serie-docto  = cserie   
                           AND docum-est.nro-docto    = cnr-docto 
                           AND docum-est.cod-emitente = ccod-emitente
                           AND docum-est.nat-operacao = cnatureza NO-LOCK NO-ERROR.

                    IF AVAIL docum-est THEN DO:
                        
                        ASSIGN i-tipo-comprov-aux = cb-tipo-comprov:LOOKUP(cb-tipo-comprov:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    
                        RUN pi-atualiza-campos IN h-bopy2003 (INPUT i-ep-codigo-usuario,
                                                              INPUT docum-est.serie-docto,
                                                              INPUT docum-est.nro-docto,
                                                              INPUT docum-est.cod-emitente,
                                                              INPUT docum-est.nat-operacao,
                                                              INPUT f-timbrado,
                                                              INPUT f-dt-vto,
                                                              INPUT f-estab-fat,
                                                              INPUT f-pto-vda,
                                                              INPUT INT(cnr-docto),
                                                              INPUT 0,
                                                              INPUT 0,
                                                              INPUT i-tipo-comprov-aux,
                                                              INPUT "":U). 
                    END.                    
                END.
                
                IF INPUT FRAME f-pg-sel l-att-docto-receb-auto AND l-executar THEN DO:                

                    EMPTY TEMP-TABLE tt-param-re1005rp.
                    EMPTY TEMP-TABLE tt-digita.
                    
                    EMPTY TEMP-TABLE tt-param.
                     
                    
                    FIND FIRST docum-est
                         WHERE docum-est.serie-docto  = cserie 
                           AND docum-est.nro-docto    = cnr-docto 
                           AND docum-est.cod-emitente = ccod-emitente
                           AND docum-est.nat-operacao = cnatureza NO-LOCK NO-ERROR.
                    IF AVAIL docum-est THEN DO:
                        create tt-digita.
                        assign tt-digita.r-docum-est = rowid(docum-est).
                        
                        CREATE tt-param-re1005rp.
                        ASSIGN tt-param-re1005rp.usuario         = c-seg-usuario
                               tt-param-re1005rp.destino         = 3
                               tt-param-re1005rp.data-exec       = today
                               tt-param-re1005rp.hora-exec       = time
                               tt-param-re1005rp.arquivo         = SESSION:TEMP-DIRECTORY + "re1005rp.tmp".
                               
                               
                        CREATE tt-param.
                        ASSIGN tt-param.usuario         = c-seg-usuario
                               tt-param.destino         = 3
                               tt-param.data-exec       = TODAY
                               tt-param.hora-exec       = TIME
                               tt-param.arquivo         = SESSION:TEMP-DIRECTORY + "re1005rp.tmp".
                
                        
                        raw-transfer tt-param  to raw-param.
                        
                        EMPTY TEMP-TABLE tt-raw-digita.
                                    
                        for each tt-digita:
                            create tt-raw-digita.
                            raw-transfer tt-digita to tt-raw-digita.raw-digita.
                        end.
                        
                        &SCOPED-DEFINE PDF NO
                        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.
                        run rep/re1005rp.p (input raw-param, input table tt-raw-digita).
                        
                        {include/i-rptrm.i}
                    END.            
                END.

                assign c-num-embarque = "".

                run utp/ut-msgs.p (input "Show":U,
                                   input 17673,
                                   input "").

                assign cembarque:SCREEN-VALUE IN FRAM f-pg-sel = ""
                       cembarque         = ""
                       ccod-estabel      = ""
                       ccod-emitente     = 0
                       ddata-trans       = today
                       ddata-emissao     = today
                       cnr-docto         = ""
                       cserie = ""
                       cnatureza         = ""
                       ccod-estabel-fisc = ""
                       c-ct-transit      = ""
                       c-sc-transit      = ""
                       ccod-decl-imp     = ""
                       ddata-di          = today
                       ddata-cotacao     = today
                       editor-2          = "".

                disp cembarque 
                     ccod-estabel 
                     ccod-emitente
                     ddata-trans 
                     ddata-emissao 
                     cnr-docto 
                     cserie
                     cnatureza 
                     ccod-estabel-fisc 
                     c-ct-transit
                     c-sc-transit
                     ccod-decl-imp 
                     ddata-di 
                     editor-2 
                     ddata-cotacao
                     with frame f-pg-sel.

                if not l-ut-ser  /*n∆o utiliza serie*/
                   and i-pais-impto-usuario <> 1 /*brasil*/ THEN
                    ASSIGN cserie:HIDDEN IN FRAME {&FRAME-NAME} = YES
                           cserie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,69,5).

                IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
                    ASSIGN f-timbrado  = 0
                           f-dt-vto    = ?
                           f-estab-fat = 0
                           f-pto-vda   = 0.

                    DISP f-timbrado  
                           f-dt-vto  
                           f-estab-fat
                           f-pto-vda
                        with frame f-pg-sel.
                END.
            END.
        end.
    end.

    delete procedure h-bocx220a.    
    ASSIGN h-bocx220a = ?.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat-acomp w-relat 
PROCEDURE pi-gera-relat-acomp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE("general":U).

    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.arquivo         = SESSION:TEMP-DIRECTORY + "im0100.tmp".
    FIND FIRST tt-retorno NO-ERROR.

    IF AVAIL tt-retorno AND
             tt-parametros.nro-docto = "" THEN
       ASSIGN tt-parametros.nro-docto = tt-retorno.parametros. /*numero do documento qndo controle pro ser-estab, gera nota faturamento*/

    RUN imp/im3100rp.p (INPUT TABLE tt-parametros,
                        INPUT TABLE tt-param).

    SESSION:SET-WAIT-STATE("":U).

    {include/i-rptrm.i}

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-fatura w-relat 
PROCEDURE pi-habilita-fatura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
                
    ASSIGN l-log-embarq-transf-draw = NO.           
    IF NOT VALID-HANDLE(h-bocx220) THEN 
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.  

    RUN findPk_Codigo IN h-bocx220 (INPUT ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel,
                                    INPUT cembarque:SCREEN-VALUE IN FRAME f-pg-sel,
                                    OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN GetLogField IN h-bocx220 (INPUT "log-embarq-transf-draw":U,
                                      OUTPUT l-log-embarq-transf-draw).
        
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.      

    find first param-imp no-lock
         where param-imp.cod-estabel = INPUT FRAME f-pg-sel ccod-estabel NO-ERROR.
    IF l-log-embarq-transf-draw OR l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla OR (AVAIL param-imp AND param-imp.log-descons-iva-tit-mercad) THEN
        ASSIGN l-nota-fisc-fat:CHECKED IN FRAME f-pg-sel = YES
               l-nota-fisc-fat:SENSITIVE IN FRAME f-pg-sel = NO.
    ELSE
        ASSIGN l-nota-fisc-fat:SENSITIVE IN FRAME f-pg-sel = YES.

    APPLY "VALUE-CHANGED":U TO l-nota-fisc-fat IN FRAME f-pg-sel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-decl-imp w-relat 
PROCEDURE pi-habilita-decl-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
                
    IF l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla AND INPUT FRAME f-pg-cla rs-classif-nf = 1 /*Nota Mae*/ THEN
        ASSIGN ccod-decl-imp:SCREEN-VALUE IN FRAME f-pg-sel = ""
               ccod-decl-imp:SENSITIVE    IN FRAME f-pg-sel = NO.
    ELSE
        ASSIGN ccod-decl-imp:SENSITIVE IN FRAME f-pg-sel = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dep-ext-internac w-relat 
PROCEDURE pi-trata-dep-ext-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF NOT VALID-HANDLE(h-bocx250na) THEN
       RUN cxbo/bocx250na.p PERSISTENT SET h-bocx250na.

   RUN getTrataDepExternos IN h-bocx250na (INPUT ccod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           OUTPUT l-trata-dep-ext).

   IF l-trata-dep-ext THEN
        ASSIGN l-envia-dep-ext:HIDDEN IN FRAME {&FRAME-NAME} = NO.
   ELSE
        ASSIGN l-envia-dep-ext:HIDDEN  IN FRAME {&FRAME-NAME} = YES
               l-envia-dep-ext:CHECKED IN FRAME {&FRAME-NAME} = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/* *** Editado automaticamente para o projeto de facelift *** */
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {include/i-rptrp.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-chamada-prog w-relat 
PROCEDURE pi-valida-chamada-prog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-sequen as int  no-undo.
def var c-return as char no-undo.

    ASSIGN i-sequen = 1.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    ASSIGN INPUT FRAME f-pg-sel cembarque
                                ccod-estabel
                                cnatureza.

    IF  cembarque = "" THEN DO:
        {utp/ut-liter.i Embarque *}
            ASSIGN c-trad-aux = RETURN-VALUE.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 265,
                           INPUT c-trad-aux ).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-sequen
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = RETURN-VALUE
               tt-bo-erro.parametros = c-trad-aux.
        ASSIGN i-sequen = i-sequen + 1.
    END.
   
    IF  ccod-estabel = "" THEN DO:
        {utp/ut-liter.i Estabelecimento *}
            ASSIGN c-trad-aux = RETURN-VALUE.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 265,
                           INPUT c-trad-aux).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-sequen
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = RETURN-VALUE
               tt-bo-erro.parametros = c-trad-aux.
        ASSIGN i-sequen = i-sequen + 1.
    END.

    IF  cnatureza = "" THEN DO:
        {utp/ut-liter.i Natureza_de_operaá∆o *}
            ASSIGN c-trad-aux = RETURN-VALUE.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 265,
                           INPUT c-trad-aux).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-sequen
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = RETURN-VALUE
               tt-bo-erro.parametros = c-trad-aux.
        ASSIGN i-sequen = i-sequen + 1.
    END.

    IF  cembarque <> "" AND 
        ccod-estabel <> "" AND
        cnatureza <> "" THEN DO:

        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
        RUN findPk_Codigo IN h-bocx220 (INPUT ccod-estabel,
                                        INPUT cembarque,
                                        OUTPUT c-return).
        IF  c-return <> "" THEN DO:
            {utp/ut-liter.i Embarque *}
                ASSIGN c-trad-aux = RETURN-VALUE.
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 2,
                               INPUT c-trad-aux).
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen = i-sequen
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = RETURN-VALUE
                   tt-bo-erro.parametros = c-trad-aux.
            ASSIGN i-sequen = i-sequen + 1.
        END.
        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.

    END.

    IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        return "NOK".
    END.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conta-contabil w-relat 
PROCEDURE pi-valida-conta-contabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    DEFINE VARIABLE i-num-finalid-cta AS INTEGER                NO-UNDO.
    DEFINE VARIABLE v_log_utz_ccusto  AS LOGICAL                NO-UNDO.
    DEFINE VARIABLE c-empresa         AS CHARACTER              NO-UNDO.

    EMPTY temp-table tt_log_erro.

    /* Busca empresa */
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN c-empresa = param-global.empresa-prin.

    IF NOT VALID-HANDLE(h_api_ccusto) THEN
        run prgint/utb/utb742za.py persistent set h_api_ccusto.
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    ASSIGN v_cod_cta_ctbl = INPUT FRAME f-pg-sel c-ct-transit 
           v_cod_ccusto   = INPUT FRAME f-pg-sel c-sc-transit.

    run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  c-empresa,  /* EMPRESA EMS2 */
                                                     input  "CEP",              /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  v_cod_cta_ctbl,     /* CONTA */
                                                     input  "(nenhum)",         /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */ 
                                                     output table tt_log_erro). /* ERROS */

    find first tt_log_erro no-lock no-error.

    if avail tt_log_erro then do:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Conta_Cont†bil" *}
                            
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
        APPLY "ENTRY":U TO c-ct-transit IN FRAME {&FRAME-NAME}.
                            
        /*delete object h_api_ccusto.
        delete object h_api_cta_ctbl.*/

        RETURN "NOK":U.
    end.
    else do:
        EMPTY temp-table tt_log_erro.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,  /* EMPRESA EMS 2 */
                                                           input  ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel,       /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        if v_log_utz_ccusto then do:
            EMPTY temp-table tt_log_erro.
            run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,       /* CCUSTO */
                                                       input  today,              /* DATA DE TRANSACAO */
                                                       output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */ 
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Centro_Custo" *}

                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
                APPLY "ENTRY":U TO c-sc-transit IN FRAME {&FRAME-NAME}.

                RETURN "NOK":U.
            end.
        end.
    end.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-nota-simples-remessa w-relat 
PROCEDURE pi-verifica-nota-simples-remessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  INPUT FRAME f-pg-cla l-nf-simples-remessa THEN DO:
        IF  c-conta-transit-import = "" THEN 
            ASSIGN c-conta-transit-import = c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel.
          /* 
          ** A vari†vel rs-classif-nf-aux Ç carregada 
          ** com o valor inicial da vari†vel rs-classif-nf
          */
          IF rs-classif-nf-aux <> 1 OR
             rs-classif-nf-aux <> 2 THEN
              ASSIGN rs-classif-nf-aux = INPUT FRAME f-pg-cla rs-classif-nf.

          /*
          ** Caso o usu†rio tenha gerado um Docto de Entrada de Simples Remessa "Filha",
          ** e ira gerar novamente outro Docto de Entrada Simples Remessa "Filha"
          ** a vari†vel "rs-classif-nf" vem carregada como "Nota M∆e", apesar de 
          ** estar setado para geraá∆o da Nota Filha.
          */
          IF rs-classif-nf-aux <> rs-classif-nf THEN
              ASSIGN rs-classif-nf = rs-classif-nf-aux.
        /* Conta transitoria recebe como valor, a conta de 
        ** aplicaá∆o que foi informada na pasta "Simples Remessa" */
        IF rs-classif-nf = 2 THEN DO:            
            ASSIGN c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-cta-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
                   c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
        END.
            
    END. /* IF  INPUT FRAME f-pg-cla l-nf-simples-remessa */
    ELSE DO:
        IF   c-conta-transit-import-aux <> "" 
        AND  c-conta-transit-import-aux <> c-conta-transit-import THEN 
            ASSIGN c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel = c-conta-transit-import-aux.
    END. /* ELSE DO: */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    def input param p-issuer-hdl as handle no-undo.
    def input param p-state      as char   no-undo.

    run pi-trata-state (p-issuer-hdl, p-state).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaArg w-relat 
PROCEDURE validaArg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-boar0178) THEN
         RUN local/arg/boar0178.p PERSISTENT SET h-boar0178.

    IF  VALID-HANDLE(h-boar0178) THEN DO:
        EMPTY TEMP-TABLE tt-dados.

        CREATE tt-dados.
        ASSIGN tt-dados.embarque             =  cembarque:SCREEN-VALUE IN FRAME f-pg-sel         
               tt-dados.cod-estabel          =  ccod-estabel:SCREEN-VALUE IN FRAME f-pg-sel      
               tt-dados.docto                =  cnr-docto:SCREEN-VALUE IN FRAME f-pg-sel            
               tt-dados.serie                =  cserie:SCREEN-VALUE IN FRAME f-pg-sel            
               tt-dados.nat-operacao         =  cnatureza:SCREEN-VALUE IN FRAME f-pg-sel    
               tt-dados.ccod-estabel-fisc    =  ccod-estabel-fisc:SCREEN-VALUE IN FRAME f-pg-sel
               tt-dados.declaracao-import    =  ccod-decl-imp:SCREEN-VALUE IN FRAME f-pg-sel 
               tt-dados.data-emissao         =  DATE(ddata-emissao:SCREEN-VALUE IN FRAME f-pg-sel)
               tt-dados.data-trans           =  DATE(ddata-trans:SCREEN-VALUE IN FRAME f-pg-sel)      
               tt-dados.ct-transit           =  c-ct-transit:SCREEN-VALUE IN FRAME f-pg-sel
               tt-dados.sc-transit           =  c-sc-transit:SCREEN-VALUE IN FRAME f-pg-sel
               tt-dados.data-di              =  DATE(ddata-di:SCREEN-VALUE IN FRAME f-pg-sel)                
               tt-dados.data-cotacao         =  DATE(ddata-cotacao:SCREEN-VALUE IN FRAME f-pg-sel)
               tt-dados.idi-nf-simples-remes =  IF INPUT FRAME f-pg-cla l-nf-simples-remessa THEN INPUT FRAME f-pg-cla rs-classif-nf ELSE 3.     

        IF l-nota-fisc-fat:SCREEN-VALUE IN FRAME f-pg-sel = "YES" THEN 
            ASSIGN tt-dados.nff = YES.
        ELSE
            ASSIGN tt-dados.nff = NO.
    
        FOR EACH tt-bo-erro:
            DELETE tt-bo-erro.
        END.

        RUN validaArg IN h-boar0178 (INPUT TABLE tt-dados,
                                     OUTPUT TABLE tt-bo-erro).
        
        IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
            IF NOT VALID-HANDLE(hShowMsg) THEN
                run utp/showmessage.w PERSISTENT SET hShowMsg.
            ELSE DO:
                DELETE PROCEDURE hShowMsg.
                run utp/showmessage.w PERSISTENT SET hShowMsg.
            END.
            RUN setModal     IN hShowMsg (INPUT YES).
            run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
            return "NOK".
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-docto-relac-nota-filha w-relat 
PROCEDURE pi-docto-relac-nota-filha:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR r-mae AS ROWID NO-UNDO.

    FIND FIRST natur-oper NO-LOCK 
         WHERE natur-oper.nat-operacao = cnatureza NO-ERROR.    
    IF AVAIL natur-oper 
    AND natur-oper.terceiros        /* Operaá∆o com Terceiros  */ 
    AND natur-oper.tp-oper-terc = 4 /* Faturamento Consignaá∆o */ 
    THEN DO:
        FIND FIRST b-embarque-imp NO-LOCK                                                                                                           
             WHERE b-embarque-imp.cod-estab = ccod-estabel
               AND b-embarque-imp.embarque  = cembarque NO-ERROR.
        IF AVAIL b-embarque-imp THEN DO:
            IF TRIM(SUBSTRING(b-embarque-imp.char-1,21,20)) <> "" THEN /*Quebra de embarque*/
                RUN pi-nota-mae-relac(INPUT TRIM(SUBSTRING(b-embarque-imp.char-1,21,20)),
                                      INPUT ccod-estabel,
                                      OUTPUT r-mae).    
            ELSE /*Embarque original*/
                RUN pi-nota-mae-relac(INPUT cembarque,
                                      INPUT ccod-estabel,
                                      OUTPUT r-mae).     
        END.
        
        FIND FIRST b-docum-est NO-LOCK 
             WHERE ROWID(b-docum-est)   = r-mae 
               AND b-docum-est.ce-atual = YES NO-ERROR.                      
        IF AVAIL b-docum-est THEN DO:
            FIND FIRST b-item-doc-est OF b-docum-est NO-LOCK 
                 WHERE b-item-doc-est.it-codigo = tt-item-doc-est.it-codigo
                   AND b-item-doc-est.cod-refer = tt-item-doc-est.cod-refer NO-ERROR.            
            IF AVAIL b-item-doc-est THEN DO:
                ASSIGN tt-item-doc-est.nro-comp   = b-item-doc-est.nro-docto
                       tt-item-doc-est.nat-comp   = b-item-doc-est.nat-operacao
                       tt-item-doc-est.serie-comp = b-item-doc-est.serie-docto
                       tt-item-doc-est.seq-comp   = b-item-doc-est.sequencia.        
            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-nota-mae-relac w-relat 
PROCEDURE pi-nota-mae-relac:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pc-cod-embarq-nota-filha   AS CHAR     NO-UNDO.
    DEF INPUT  PARAM pc-cod-estabel-nota-filha  AS CHAR     NO-UNDO.
    DEF OUTPUT PARAM pr-rowid-nota-mae          AS ROWID    NO-UNDO.

    DEF VAR l-sair AS LOG NO-UNDO.
    DEF VAR c-prox-embarq AS CHAR NO-UNDO.

    ASSIGN l-sair        = NO
           c-prox-embarq = pc-cod-embarq-nota-filha.   

    REPEAT WHILE l-sair = NO:        
                                                        
         /* N∆o encontrou nota para o embarque relacionado */
         IF NOT CAN-FIND(FIRST embarq-import-docto 
                         WHERE embarq-import-docto.cod-estab  = pc-cod-estabel-nota-filha 
                         AND   embarq-import-docto.cod-embarq = c-prox-embarq) THEN
            ASSIGN l-sair = YES. 

         FOR EACH embarq-import-docto FIELDS(cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
             WHERE embarq-import-docto.cod-estab  = pc-cod-estabel-nota-filha
             AND   embarq-import-docto.cod-embarq = c-prox-embarq  NO-LOCK:

             /* verifica se Ç a nota m∆e */ 
             FOR FIRST b-docum-est FIELDS(serie-docto nro-docto cod-emitente nat-operacao idi-nf-simples-remes embarque) 
                  WHERE b-docum-est.serie-docto  = embarq-import-docto.cod-ser-docto             
                    AND b-docum-est.nro-docto    = embarq-import-docto.cod-docto                 
                    AND b-docum-est.cod-emitente = embarq-import-docto.cdn-emitente              
                    AND b-docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:
             END. 
             /* se for nota filha grava o embarque de origem para prΩxima busca */
             IF b-docum-est.idi-nf-simples-remes   = 2 THEN DO:
                FOR FIRST b-embarque-imp NO-LOCK                                                                                                           
                    WHERE b-embarque-imp.cod-estab = embarq-import-docto.cod-estab                                                                    
                    AND   b-embarque-imp.embarque  = c-prox-embarq:                  
                    ASSIGN c-prox-embarq = SUBSTRING(b-embarque-imp.char-1,21,20).    
                END.
             END. 
    
             IF b-docum-est.idi-nf-simples-remes <> 1 THEN NEXT. /* Nota M∆e idi-nf-simples-remes = 1 */
             IF b-docum-est.embarque <> embarq-import-docto.cod-embarq THEN NEXT.
           
             ASSIGN l-sair = YES
                    pr-rowid-nota-mae = ROWID(b-docum-est).
         END.

         IF c-prox-embarq = "" THEN
            ASSIGN l-sair = YES. 
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-nota-mae-relac w-relat 
PROCEDURE pi-busca-cotacao-moeda:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-mo-codigo  AS INT NO-UNDO.
    DEF VAR data-cotacao AS DATE NO-UNDO.
    
    FIND embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = ccod-estabel:SCREEN-VALUE  IN FRAME f-pg-sel
           AND embarque-imp.embarque    = cembarque:SCREEN-VALUE     IN FRAME f-pg-sel  NO-ERROR.
    
    IF  NOT AVAIL embarque-imp THEN 
        RETURN NO-APPLY.
    
    FOR FIRST ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque:
    END.
    IF  NOT AVAIL ordens-embarque THEN
        RETURN NO-APPLY.
    
    FOR FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
    END.
    
    ASSIGN i-mo-codigo = IF AVAIL ordem-compra THEN ordem-compra.mo-codigo ELSE 0.
           data-cotacao = DATE(ddata-cotacao:SCREEN-VALUE  IN FRAME f-pg-sel).
    
    FOR FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = i-mo-codigo:
    END.    
    
    FIND FIRST cotacao NO-LOCK
         WHERE cotacao.mo-codigo   = i-mo-codigo
           AND cotacao.ano-periodo = STRING(YEAR(data-cotacao)) + STRING(MONTH(data-cotacao),"99")
           AND cotacao.cotacao[INT(DAY(data-cotacao))] <> 0 NO-ERROR.
    
    ASSIGN d-cotacao:SCREEN-VALUE IN FRAME f-pg-sel = STRING(IF AVAIL cotacao then cotacao.cotacao[int(day(data-cotacao))] ELSE 1). 
    
    IF d-cot-var-cambial:SENSITIVE IN FRAME f-pg-sel THEN 
        ASSIGN d-cot-var-cambial:SCREEN-VALUE IN FRAME f-pg-sel  = STRING(IF AVAIL cotacao then cotacao.cotacao[int(day(data-cotacao))] ELSE 1).
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
