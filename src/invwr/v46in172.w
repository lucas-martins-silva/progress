&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V46IN172 2.00.00.055 } /*** "010055" 25/05/2026 12:13:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v46in172 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-handle1         as character no-undo.
def var wh-cd0903         as handle    no-undo.


def temp-table tt-pedido NO-UNDO
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli.

def buffer b-ped-item for ped-item.

def var de-ipi-ant like classif-fisc.aliquota-ipi.
def var i-exporta      as integer.
def var l-aberto       as logical.
def var l-parcial      as logical.
def var l-pendente     as logical.
def var i-cont         as integer.
def var c-class-fiscal as char.
def var c-fator        as char.

&IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
DEF VAR c-class-fiscal-ant LIKE ITEM.class-fiscal.
&ENDIF

DEF VAR i-apuracao-ant  AS INTEGER NO-UNDO.
DEF VAR dt-docto-ini    AS DATE NO-UNDO.
DEF VAR dt-docto-fim    AS DATE NO-UNDO.
DEF VAR l-atualiza-dt   AS LOGICAL INIT NO NO-UNDO.
DEF VAR l-exp-ap-it-doc AS LOGICAL INIT NO NO-UNDO.
DEF VAR h-acomp         AS HANDLE NO-UNDO.
DEF VAR c-processo      AS CHARACTER NO-UNDO.

{cdp/cd4000.i}
{cdp/cd9990.i1}
{cdp/cd7300.i1}
{cdp/cdapi206.i2}

def var l-estab-am as logical.
DEF VAR hProgramZoom AS HANDLE NO-UNDO.

DEFINE VARIABLE l-funcao-nfe    AS LOGICAL      NO-UNDO INITIAL NO.

/*--- Nota Fiscal Eletronica ---*/
ASSIGN l-funcao-nfe = IF CAN-FIND(funcao NO-LOCK WHERE funcao.cd-funcao = "SPP-NFE":U) THEN YES ELSE NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.class-fiscal item.cod-servico ~
item.fator-reaj-icms item.aliquota-ISS item.aliquota-ipi item.cd-trib-icm ~
item.cd-trib-iss item.cd-trib-ipi item.ind-ipi-dife item.incentivado 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-23 RECT-24 RECT-25 RECT-26 ~
c-cod-familia-impto c-desc-familia-impto 
&Scoped-Define DISPLAYED-FIELDS item.class-fiscal item.cod-servico ~
item.fator-reaj-icms item.aliquota-ISS item.aliquota-ipi item.cd-trib-icm ~
item.cd-trib-iss item.cd-trib-ipi item.ind-ipi-dife item.incentivado 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS i-cod-ncm c-desc-classif-fisc ~
c-desc-cod-servico c-cod-inss c-desc-inss rs-apuracao c-cod-familia-impto ~
c-desc-familia-impto c-nr-dcr-item c-cod-sefazsp c-cod-ean tg-susp-ipi ~
l-combust l-incide-is 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-ean AS CHARACTER FORMAT "x(14)" 
     LABEL "C¢d GTIN (Trib)":R16 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 TOOLTIP "C¢digo GTIN/EAN p/ NF-e na Unidade Tribut†vel (campo cEANTrib)".

DEFINE VARIABLE c-cod-familia-impto AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam°lia IPI" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-inss AS CHARACTER FORMAT "X(8)":U 
     LABEL "Serviáo INSS" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-sefazsp AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "C¢digo SEFAZ-SP" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-classif-fisc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cod-servico AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-familia-impto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-inss AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 51.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-dcr-item AS CHARACTER FORMAT "X(12)":U 
     LABEL "DCR Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-ncm AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE VARIABLE text-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .75 NO-UNDO.

DEFINE VARIABLE text-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .75 NO-UNDO.

DEFINE VARIABLE text-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .75 NO-UNDO.

DEFINE VARIABLE rs-apuracao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Decendial", 1,
"Mensal", 2
     SIZE 26.57 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 3.75.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 3.75.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 3.75.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 4.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 1.5.

DEFINE VARIABLE l-combust AS LOGICAL INITIAL no 
     LABEL "Item Combust°vel/Solvente" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-incide-is AS LOGICAL INITIAL no 
     LABEL "Incide IS" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-susp-ipi AS LOGICAL INITIAL no 
     LABEL "Suspens∆o IPI" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.class-fiscal AT ROW 1.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .88
     i-cod-ncm AT ROW 1.25 COL 28.86 COLON-ALIGNED HELP
          "Extens∆o NCM para Produtos Qu°micos e Petroqu°micos" NO-LABEL
     c-desc-classif-fisc AT ROW 1.25 COL 32.72 COLON-ALIGNED NO-LABEL
     item.cod-servico AT ROW 2.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-cod-servico AT ROW 2.25 COL 24.43 COLON-ALIGNED NO-LABEL
     c-cod-inss AT ROW 3.25 COL 17 COLON-ALIGNED
     c-desc-inss AT ROW 3.25 COL 24.43 COLON-ALIGNED NO-LABEL
     item.fator-reaj-icms AT ROW 4.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     rs-apuracao AT ROW 4.75 COL 45 NO-LABEL
     item.aliquota-ISS AT ROW 5.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     item.aliquota-ipi AT ROW 6.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-cod-familia-impto AT ROW 6.25 COL 39 COLON-ALIGNED
     c-desc-familia-impto AT ROW 6.25 COL 49.5 COLON-ALIGNED NO-LABEL
     c-nr-dcr-item AT ROW 7.25 COL 17 COLON-ALIGNED HELP
          "N£mero DCR do item"
     c-cod-sefazsp AT ROW 7.25 COL 43 COLON-ALIGNED
     c-cod-ean AT ROW 7.25 COL 63 COLON-ALIGNED HELP
          "C¢digo GTIN/EAN p/ NF-e na Unidade Tribut†vel (campo cEANTrib)"
     tg-susp-ipi AT ROW 8.33 COL 53
     item.cd-trib-icm AT ROW 9 COL 5 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Tributado", 1,
"Isento", 2,
"Outros", 3,
"Reduzido", 4
          SIZE 12.57 BY 3
     item.cd-trib-iss AT ROW 9 COL 21 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Tributado", 1,
"Isento", 2,
"Outros", 3,
"Reduzido", 4
          SIZE 12.57 BY 3
     item.cd-trib-ipi AT ROW 9 COL 37 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Tributado", 1,
"Isento", 2,
"Outros", 3,
"Reduzido", 4
          SIZE 12.57 BY 3
     item.ind-ipi-dife AT ROW 9.08 COL 53
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .71
     item.incentivado AT ROW 9.83 COL 53
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .71
     l-combust AT ROW 10.58 COL 53
     l-incide-is AT ROW 11.33 COL 53 WIDGET-ID 2 HELP
        "Item possui incidància de IS - Imposto Seletivo"
     text-2 AT ROW 4.25 COL 41 COLON-ALIGNED NO-LABEL
     text-3 AT ROW 8.17 COL 3 COLON-ALIGNED NO-LABEL
     text-4 AT ROW 8.17 COL 19 COLON-ALIGNED NO-LABEL
     text-5 AT ROW 8.17 COL 35 COLON-ALIGNED NO-LABEL
     RECT-22 AT ROW 8.5 COL 4
     RECT-23 AT ROW 8.5 COL 20
     RECT-24 AT ROW 8.5 COL 36
     RECT-25 AT ROW 8.25 COL 52
     RECT-26 AT ROW 4.5 COL 41
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.33
         WIDTH              = 84.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-ean IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-ean:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-cod-familia-impto:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-inss IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-sefazsp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-classif-fisc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cod-servico IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-familia-impto:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-inss IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-dcr-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-ncm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-combust IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-incide-is IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-apuracao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-5 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg-susp-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-familia-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-familia-impto V-table-Win
ON F5 OF c-cod-familia-impto IN FRAME f-main /* Fam°lia IPI */
DO:
&if "{&bf_dis_versao_ems}" >= "2.062" &then
  {method/zoomfields.i &ProgramZoom="inzoom/z01in741.w"
                       &FieldZoom1="cod-familia-impto"
                       &FieldScreen1="c-cod-familia-impto"
                       &Frame1="f-main"
                       &FieldZoom2="des-familia-impto"
                       &FieldScreen2="c-desc-familia-impto"
                       &Frame2="f-main"
                       &EnableImplant="NO"}
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-familia-impto V-table-Win
ON LEAVE OF c-cod-familia-impto IN FRAME f-main /* Fam°lia IPI */
DO:
&if "{&bf_dis_versao_ems}" >= "2.062" &then
    {include/leave.i &tabela=familia-impto
                     &atributo-ref=des-familia-impto
                     &variavel-ref=c-desc-familia-impto
                     &where="familia-impto.cod-familia-impto = input frame {&frame-name} c-cod-familia-impto"}
&endif
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-inss V-table-Win
ON LEAVE OF c-cod-inss IN FRAME f-main /* Fam°lia IPI */
DO:
&if "{&bf_dis_versao_ems}" >= "2.062" &then
    {include/leave.i &tabela=tab-serv-inss
                     &atributo-ref=des-serv-inss
                     &variavel-ref=c-desc-inss
                     &where="tab-serv-inss.cdn-serv-inss = integer(input frame {&frame-name} c-cod-inss)"}
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-familia-impto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-familia-impto IN FRAME f-main /* Fam°lia IPI */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-inss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-inss V-table-Win
ON F5 OF c-cod-inss IN FRAME f-main /* Serviáo INSS */
DO:

  {method/zoomfields.i &ProgramZoom="dizoom/z01di071.w"
                       &FieldZoom1="cdn-serv-inss"
                       &FieldScreen1="c-cod-inss"
                       &Frame1="f-main"
                       &FieldZoom2="des-serv-inss"
                       &FieldScreen2="c-desc-inss"
                       &Frame2="f-main"
                       &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-inss V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-inss IN FRAME f-main /* Serviáo INSS */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-sefazsp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-sefazsp V-table-Win
ON F5 OF c-cod-sefazsp IN FRAME f-main /* C¢digo SEFAZ-SP */
DO:
  {method/zoomfields.i &ProgramZoom="dizoom/z01di431.w"
                       &FieldZoom1="cdn-sefazsp"
                       &FieldScreen1="c-cod-sefazsp"
                       &Frame1="f-main"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-sefazsp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-sefazsp IN FRAME f-main /* C¢digo SEFAZ-SP */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON ENTRY OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "9999.99.99" NO-ERROR.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON LEAVE OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:

  /* Tratamento para n∆o demonstrar erro Progress 630 ao deixar a NCM em branco */
  IF  length(REPLACE(item.class-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","")) < 8 THEN
      ASSIGN item.class-fiscal:FORMAT IN FRAME  {&FRAME-NAME} = "X(8)" NO-ERROR.

  find classif-fisc
     where classif-fisc.class-fiscal = input frame {&frame-name} item.class-fiscal no-lock no-error.
  if avail classif-fisc
  and input frame {&frame-name} item.ind-ipi-dife = no then
     assign item.aliquota-ipi:screen-value in frame {&frame-name} = string(classif-fisc.aliquota-ipi).

  assign c-desc-classif-fisc:screen-value in frame {&frame-name} = if avail classif-fisc 
                                                                   then classif-fisc.descricao 
                                                                   else "":U. 

  IF AVAIL classif-fisc AND c-processo = "Display":U THEN 
      &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
          ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&frame-name} = string(classif-fisc.idi-tip-apurac-ipi). 
      &ELSE
          ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTR(classif-fisc.char-2,1,1).
      &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON F5 OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                     &campo=item.class-fiscal
                     &campozoom=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-servico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-servico V-table-Win
ON F5 OF item.cod-servico IN FRAME f-main /* Serviáo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di185.w
                     &campo=item.cod-servico
                     &campozoom=cod-servico}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-servico V-table-Win
ON LEAVE OF item.cod-servico IN FRAME f-main /* Serviáo */
DO:

{include/leave.i &tabela=tab-codser
                 &atributo-ref=descricao
                 &variavel-ref=c-desc-cod-servico
                 &where="tab-codser.cod-servico = input frame {&frame-name}
                                                    item.cod-servico"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-servico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-servico IN FRAME f-main /* Serviáo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.ind-ipi-dife
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ind-ipi-dife V-table-Win
ON VALUE-CHANGED OF item.ind-ipi-dife IN FRAME f-main /* Possui IPI Diferenciado */
DO:
  assign item.aliquota-ipi:sensitive = (input frame {&frame-name} 
                                          item.ind-ipi-dife = yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-apuracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-apuracao V-table-Win
ON VALUE-CHANGED OF rs-apuracao IN FRAME f-main
DO:

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 29494,
                       INPUT "").

    ASSIGN l-exp-ap-it-doc = IF RETURN-VALUE = "yes" THEN YES ELSE NO.

    IF l-exp-ap-it-doc THEN DO:
        RUN cdp/cd0603f.w (OUTPUT dt-docto-ini,
                           OUTPUT dt-docto-fim,
                           OUTPUT l-atualiza-dt).

        IF l-atualiza-dt = NO THEN
            ASSIGN l-exp-ap-it-doc = NO.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF  

  {utp/ut-liter.i Tipo_Apuraá∆o_de_IPI * }
  IF i-pais-impto-usuario = 1 THEN
      assign text-2:screen-value in frame {&frame-name} = RETURN-VALUE. 

  {utp/ut-field.i mgind item cd-trib-icm 2}
  assign text-3:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-field.i mgind item cd-trib-iss 2}
  assign text-4:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item cd-trib-ipi 2}
  assign text-5:screen-value in frame {&frame-name} = return-value.

  if item.cod-servico:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
  if item.class-fiscal:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  if c-cod-sefazsp:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  &if "{&bf_dis_versao_ems}" >= "2.062" &then
  if c-cod-familia-impto:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  &endif
  
    &if "{&bf_dis_versao_ems}" >= "2.062" &then
  if c-cod-inss:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  &endif
  
/************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i Tipo_Apuraá∆o_de_IPI * }
  IF i-pais-impto-usuario = 1 THEN
      assign text-2:screen-value in frame {&frame-name} = RETURN-VALUE. 

  {utp/ut-field.i mgind item cd-trib-icm 2}
  assign text-3:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-field.i mgind item cd-trib-iss 2}
  assign text-4:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item cd-trib-ipi 2}
  assign text-5:screen-value in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  /*if  not frame {&frame-name}:validate() then
 *       return 'ADM-ERROR':U.*/

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  DEFINE VARIABLE bo-ped-venda-cal AS HANDLE     NO-UNDO.
  ASSIGN c-processo = "Assign":U.

  assign de-ipi-ant = item.aliquota-ipi.

  IF NOT adm-new-record THEN
      ASSIGN c-class-fiscal-ant = ITEM.class-fiscal.

  find first param-global no-lock no-error.

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */


    apply 'leave' to input frame {&frame-name} item.class-fiscal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  assign item.dec-1 = int(i-cod-ncm:screen-value in frame {&frame-name}).

  ASSIGN INPUT FRAME {&FRAME-NAME} tg-susp-ipi.

  assign overlay(item.char-2,51,1) = IF tg-susp-ipi THEN "2" ELSE "1".

  assign input frame {&frame-name} l-combust.
  assign input frame {&frame-name} c-cod-sefazsp.
  
  &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
      find first item-dist where item-dist.it-codigo = item.it-codigo EXCLUSIVE-LOCK no-error.
      assign item-dist.cdn-sefazsp = c-cod-sefazsp 
             item-dist.log-combust = l-combust.
  &else
      assign overlay(item.char-1,254,4) = STRING(c-cod-sefazsp)
             overlay(item.char-1,258,1) = IF l-combust THEN "1" ELSE "".
  &endif
  assign input frame {&frame-name} c-nr-dcr-item.

  &IF "{&bf_dis_versao_ems}" < "2.071" &THEN
      assign overlay(item.char-2,217,12) = c-nr-dcr-item.  
  &ELSE
      assign item.cod-dcr-item = c-nr-dcr-item.
  &ENDIF

  IF i-pais-impto-usuario = 1 THEN DO:
      /* parametro incide is */
      ASSIGN INPUT FRAME {&frame-name} l-incide-is
             OVERLAY(ITEM.char-1,289,1) = IF l-incide-is THEN "S" ELSE "N".
  
      ASSIGN INPUT FRAME {&FRAME-NAME} c-cod-inss
             OVERLAY(ITEM.char-1,298,2) = STRING(c-cod-inss).
      
      &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
          FIND item-dist WHERE item-dist.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
          IF AVAIL item-dist THEN
              ASSIGN item-dist.idi-tip-apurac-ipi = INPUT FRAME {&frame-name} rs-apuracao.
      &ELSE
          ASSIGN overlay(ITEM.char-1,191,1) = string(INPUT FRAME {&FRAME-NAME} rs-apuracao).   
      &ENDIF

      &if "{&bf_dis_versao_ems}" >= "2.062" &then
          FIND FIRST item-mat EXCLUSIVE-LOCK
               WHERE item-mat.it-codigo = item.it-codigo NO-ERROR.
          IF  AVAIL item-mat THEN
              ASSIGN item-mat.cod-familia-impto = INPUT FRAME {&FRAME-NAME} c-cod-familia-impto.
      &endif

      IF i-apuracao-ant <> INPUT FRAME {&FRAME-NAME} rs-apuracao 
      AND l-exp-ap-it-doc THEN DO:
          run utp/ut-acomp.p persistent set h-acomp.
          {utp/ut-liter.i Exportaá∆o_do_tipo_apuraá∆o_do_IPI *}
          run pi-inicializar in h-acomp (input  Return-value ).
                                                
          FOR EACH it-doc-fisc 
              WHERE it-doc-fisc.dt-docto >= dt-docto-ini AND
                    it-doc-fisc.dt-docto <= dt-docto-fim AND 
                    it-doc-fisc.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK:
            IF it-doc-fisc.class-fiscal = ITEM.class-fiscal THEN DO:
                DEFINE VARIABLE c-aux AS CHARACTER  NO-UNDO.
                {utp/ut-liter.i Documento:_ *}
                ASSIGN c-aux = RETURN-VALUE + it-doc-fisc.nr-doc-fis.
                {utp/ut-liter.i Item:_ *}
                ASSIGN c-aux = c-aux + " -" + RETURN-VALUE + it-doc-fisc.it-codigo.
                RUN pi-acompanhar IN h-acomp (c-aux).

                &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                    ASSIGN it-doc-fisc.idi-tip-apurac-ipi = INPUT FRAME {&frame-name} rs-apuracao.
                &else
                    ASSIGN overlay(it-doc-fisc.char-2,21,1) = STRING(INPUT FRAME {&FRAME-NAME} rs-apuracao).
                &ENDIF
            END.
          END.
          run pi-finalizar in h-acomp.
      END.
  END.

  if  param-global.modulo-pd then do:

      IF (de-ipi-ant NE item.aliquota-ipi) OR 
         (NOT adm-new-record and c-class-fiscal-ant NE ITEM.class-fiscal) then do:
          run cdp/cd0903a.w (output i-exporta,
                             output l-aberto,
                             output l-parcial,
                             output l-pendente).
                             
          for each tt-pedido:
              delete tt-pedido.
          end. 
          
          
          IF  i-exporta = 1 THEN DO:
              {cdp/cd0903.i " "}
          END.
          ELSE IF  i-exporta = 2 THEN DO:
              {cdp/cd0903.i "and ped-item.aliquota-ipi = de-ipi-ant"}  
          END.    
          
          &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
              if not valid-handle(bo-ped-venda-cal) or
                 bo-ped-venda-cal:type <> "PROCEDURE":U or
                 bo-ped-venda-cal:file-name <> "dibo/bodi159cal.p" then
                 run dibo/bodi159cal.p persistent set bo-ped-venda-cal.
              run setaInstanciaHandles in bo-ped-venda-cal.
              run inicializaHandles    in bo-ped-venda-cal.

          &ENDIF

          for each tt-pedido:
              
              FOR FIRST ped-venda FIELDS( nr-pedcli nome-abrev cod-sit-ped esp-ped )
                   where ped-venda.nome-abrev = tt-pedido.nome-abrev
                   and   ped-venda.nr-pedcli   = tt-pedido.nr-pedcli NO-LOCK :

                  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
                      RUN calculateOrder IN bo-ped-venda-cal(INPUT rowid(ped-venda) ) .
                  &ELSE
                      run cdp/cd4323a.p (input rowid(ped-venda),
                                         input no,
                                         input i-pais-impto-usuario).

                      if  ped-venda.cod-sit-ped = 2 or 
                          (ped-venda.esp-ped = 2 AND  /*prog entrega j† atendida*/
                           CAN-FIND (FIRST ped-item OF ped-venda WHERE
                                           ped-item.qt-atendida > 0 )) THEN  DO:

                          run cdp/cd4323a.p (input rowid(ped-venda),
                                             input yes,
                                             input i-pais-impto-usuario).
                      end.
                  &ENDIF

                  delete tt-pedido.
              END.
          end.                                

          &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
              run finalizaHandles in bo-ped-venda-cal.
              delete procedure bo-ped-venda-cal.
          &ENDIF
          
         /******************Multiplanta******************/

         assign c-transacao = "DIS005".
         {cdp/cd7300.i5 "001" c-transacao}      

         if  param-global.modulo-mp and
             tt-replica-msg.log-replica-msg  = yes then do: 
             create tt-param.
             assign tt-param.it-codigo        = item.it-codigo
                    tt-param.aliquota-ipi-ant = de-ipi-ant
                    tt-param.aliquota-ipi-atu = item.aliquota-ipi
                    tt-param.i-exporta        = i-exporta
                    tt-param.l-aberto         = l-aberto
                    tt-param.l-parcial        = l-parcial
                    tt-param.l-pendente       = l-pendente.

             create tt-dados-env.                  
             assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg          = 3
             tt-dados-env.ind-tipo-movto        = 10
             tt-dados-env.identif-msg           = item.it-codigo.
             raw-transfer tt-param to tt-dados-env.conteudo-msg.                                    
             assign i-seq = i-seq + 1.                                     
         end.  

         {cdp/cd7300.i6 "001" c-transacao}
         find first tt-dados-env no-error.
         if  avail tt-dados-env then
         delete tt-dados-env.

         /**************Fim-Multiplanta*****************/

      end.
  end.    

  /*--- Nota Fiscal Eletronica ---*/
  IF l-funcao-nfe THEN DO:
      ASSIGN c-cod-ean = INPUT FRAME {&FRAME-NAME} c-cod-ean.
      &if  "{&bf_dis_versao_ems}"  >=  "2.05":U  &then
        FIND FIRST item-mat EXCLUSIVE-LOCK WHERE
            item-mat.it-codigo = item.it-codigo NO-ERROR.
        IF AVAIL item-mat THEN 
            assign item-mat.cod-ean = c-cod-ean.
      &else
          IF AVAIL ITEM THEN 
              assign OVERLAY(ITEM.char-1,133,16) = c-cod-ean.
      &endif
  END.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  ASSIGN c-cod-sefazsp:SENSITIVE IN FRAME {&frame-name} = NO
         l-combust:SENSITIVE     IN FRAME {&frame-name} = NO
         l-incide-is:SENSITIVE   IN FRAME {&frame-name} = NO 
         c-nr-dcr-item:SENSITIVE IN FRAME {&frame-name} = NO
         c-cod-inss:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
         i-cod-ncm:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
         tg-susp-ipi:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
        /* c-desc-inss:SENSITIVE   IN FRAME {&FRAME-NAME} = NO */.

  IF i-pais-impto-usuario = 1 THEN
      DISABLE rs-apuracao WITH FRAME {&FRAME-NAME}.
  
  /*--- Nota Fiscal Eletronica ---*/
  IF l-funcao-nfe THEN
      &if  "{&bf_dis_versao_ems}"  >=  "2.04":U  &then
          ASSIGN c-cod-ean:SENSITIVE IN FRAME {&frame-name} = NO.
      &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  avail item then do:

      ASSIGN c-processo = "Display":U.

      find classif-fisc 
          where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.

      /* Tratamento para n∆o demonstrar erro Progress 630 ao deixar a NCM em branco */
      IF  length(REPLACE(item.class-fiscal,".","")) < 8 THEN
          ASSIGN item.class-fiscal:FORMAT IN FRAME  {&FRAME-NAME} = "X(8)" NO-ERROR.
      ELSE
          ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "9999.99.99" NO-ERROR.

      assign c-desc-classif-fisc = if  avail classif-fisc 
                                   then classif-fisc.descricao
                                   else "":U.  

      find tab-codser 
          where tab-codser.cod-servico = item.cod-servico no-lock no-error.

      assign c-desc-cod-servico = if  avail tab-codser 
                                  then tab-codser.descricao
                                  else "":U

             /* Inicializa o parÉmetro Incorpora PIS/Cofins Total NF */
             i-cod-ncm                = int(item.dec-1).
    assign tg-susp-ipi   = substr(item.char-2,51,1) = "2".   /* 1 - N∆o suspenso, 2 - Suspenso */

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        find first item-dist where item-dist.it-codigo = item.it-codigo NO-LOCK no-error.
        assign c-cod-sefazsp = item-dist.cdn-sefazsp 
               l-combust     = item-dist.log-combust = yes.
    &else
        assign c-cod-sefazsp = int(substr(item.char-1,254,4))
               l-combust     = substr(item.char-1,258,1) = "1".
    &endif

    assign l-incide-is   = IF SUBSTRING(ITEM.char-1,289,1) = "S" THEN TRUE ELSE FALSE
           c-nr-dcr-item =  &IF "{&bf_dis_versao_ems}" < "2.071" &THEN
                                substring(item.char-2,217,12).
                            &else 
                                item.cod-dcr-item.
                            &endif 

    IF i-pais-impto-usuario = 1 THEN DO:
           
      &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
          FIND item-dist WHERE item-dist.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
          IF AVAIL item-dist THEN
              ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&frame-name} = string(item-dist.idi-tip-apurac-ipi).
      &ELSE
             ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = if substr(ITEM.char-1,191,1) = ? then "" else substr(ITEM.char-1,191,1).                 
      &ENDIF

      &if "{&bf_dis_versao_ems}" >= "2.062" &then
          FIND FIRST item-mat NO-LOCK
               WHERE item-mat.it-codigo = item.it-codigo NO-ERROR.
          ASSIGN c-cod-familia-impto = IF AVAIL item-mat THEN item-mat.cod-familia-impto ELSE ''.
          FIND FIRST familia-impto NO-LOCK
               WHERE familia-impto.cod-familia-impto = c-cod-familia-impto NO-ERROR.
          ASSIGN c-desc-familia-impto = IF AVAIL familia-impto THEN familia-impto.des-familia-impto ELSE ''.
          DISPLAY c-cod-familia-impto c-desc-familia-impto WITH FRAME {&FRAME-NAME}.
      &endif
      
      &if "{&bf_dis_versao_ems}" >= "2.062" &then
          ASSIGN c-cod-inss = SUBSTRING(ITEM.char-1,298,2).
          FIND FIRST tab-serv-inss
               WHERE tab-serv-inss.cdn-serv-inss = int(c-cod-inss) NO-LOCK NO-ERROR.
          IF AVAIL tab-serv-inss THEN
             ASSIGN c-desc-inss = tab-serv-inss.des-serv-inss.
          ELSE 
             ASSIGN c-desc-inss = "".
      &endif

    END.

    ASSIGN i-apuracao-ant = rs-apuracao.

  end.


  /*--- Nota Fiscal Eletronica ---*/
  IF l-funcao-nfe THEN DO:
     &if  "{&bf_dis_versao_ems}"  >=  "2.05":U  &then
        FIND FIRST item-mat NO-LOCK WHERE
            item-mat.it-codigo = item.it-codigo NO-ERROR.
        IF AVAIL item-mat THEN DO:
            assign c-cod-ean = item-mat.cod-ean.
            DISPLAY c-cod-ean WITH FRAME {&FRAME-NAME}.
        END.
     &ELSE
         IF AVAIL ITEM THEN DO:
             assign c-cod-ean = SUBSTR(ITEM.char-1,133,16).
             DISPLAY c-cod-ean WITH FRAME {&FRAME-NAME}.
         END.
     &ENDIF
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   assign item.aliquota-ipi:sensitive in frame {&frame-name} = item.ind-ipi-dife
          c-cod-sefazsp:SENSITIVE     IN FRAME {&frame-name} = YES
          l-combust:SENSITIVE         IN FRAME {&frame-name} = YES
          c-nr-dcr-item:SENSITIVE     IN FRAME {&frame-name} = YES
          c-cod-inss:SENSITIVE        IN FRAME {&FRAME-NAME} = YES
          i-cod-ncm:SENSITIVE         IN FRAME {&FRAME-NAME} = YES
          tg-susp-ipi:SENSITIVE       IN FRAME {&FRAME-NAME} = YES.

   IF i-pais-impto-usuario = 1 THEN DO:
      ENABLE rs-apuracao WITH FRAME {&FRAME-NAME}.
      ENABLE l-incide-is WITH FRAME {&FRAME-NAME}.
   END.
  
  /*--- Nota Fiscal Eletronica ---*/
  IF l-funcao-nfe THEN
      &if  "{&bf_dis_versao_ems}"  >=  "2.04":U  &then
            ASSIGN c-cod-ean:SENSITIVE IN FRAME {&frame-name} = YES.
      &endif

   run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /*  apply "value-changed" to item.ind-ipi-dife in frame {&frame-name}.*/

 
/*
 if item.ind-ipi-dife then
    enable item.aliquota-ipi with frame {&frame-name}. 
 else 
    disable item.aliquota-ipi with frame {&frame-name}.
*/
  /*find first estabelec where estabelec.pais   = "Brasil"
 *                        and   estabelec.estado = "AM" no-lock no-error.
 *   assign l-estab-am = avail estabelec.
 *   find first estabelec where estabelec.estado = "PE" no-lock no-error.
 *   if  avail estabelec and estabelec.estado = "PE" then
 *       enable item.incentivado with frame {&frame-name}.
 *   else
 *       disable item.incentivado with frame {&frame-name}. 
 *         
 *   if  l-estab-am = yes then
 *       enable item.nr-item-dcr with frame {&frame-name}.
 *   else
 *       disable item.nr-item-dcr with frame {&frame-name}.  */

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /*--- Nota Fiscal Eletronica ---*/
  IF l-funcao-nfe THEN
      ASSIGN c-cod-ean:HIDDEN IN FRAME {&frame-name} = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF i-pais-impto-usuario <> 1 THEN
      HIDE text-2      IN FRAME {&FRAME-NAME}
           rect-26     IN FRAME {&FRAME-NAME}
           rs-apuracao IN FRAME {&FRAME-NAME}.

    {utp/ut-liter.i C¢digo_Fam°lia_Imposto}
    assign c-cod-familia-impto:help in frame {&frame-name} = return-value.

    {utp/ut-liter.i C¢digo_Serviáo_INSS}
    assign c-cod-inss:help in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure, OUTPUT c-handle1).
assign wh-cd0903 = widget-handle(c-handle1).

{cdp/cd9998.i}

/* Tratamento para n∆o demonstrar erro Progress 630 ao deixar a NCM em branco */
IF REPLACE(item.class-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","") = "" THEN
    ASSIGN item.class-fiscal:FORMAT IN FRAME  {&FRAME-NAME} = "X(8)" NO-ERROR.

find classif-fisc 
    where classif-fisc.class-fiscal = input frame {&frame-name} item.class-fiscal no-lock no-error.
if not avail classif-fisc then do:
      run utp/ut-msgs.p(input "show",
                        input 5670,
                        input "").
      run select-page in wh-cd0903 (3).                  
      apply "entry" to item.class-fiscal in frame {&frame-name}.
      return "adm-error".

end.

&IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
    IF NOT adm-new-record 
       AND c-class-fiscal-ant <> input frame {&frame-name} item.class-fiscal 
       AND ITEM.cod-destaq > 0 THEN DO:
       IF NOT CAN-FIND 
           (FIRST classif-destaq
            WHERE classif-destaq.class-fiscal = input frame {&frame-name} item.class-fiscal 
            AND   classif-destaq.cod-destaq   = item.cod-destaq NO-LOCK ) THEN DO:
           run utp/ut-msgs.p(input "show",
                             input 28575,
                             input "").
           run select-page in wh-cd0903 (3).                  
           apply "entry" to item.class-fiscal in frame {&frame-name}.
           return "adm-error".
       END.
    END.
&ENDIF

IF NOT adm-new-record 
AND c-class-fiscal-ant <> input frame {&frame-name} item.class-fiscal THEN DO:
    IF CAN-FIND(FIRST item-atrib-siscomex NO-LOCK
                WHERE item-atrib-siscomex.cod-item = item.it-codigo) THEN DO:
        run utp/ut-msgs.p(input "show",
                          input 57914,
                          input "").
        run select-page in wh-cd0903 (3).                  
        apply "entry" to item.class-fiscal in frame {&frame-name}.
        return "adm-error".
    END.
END.

if input frame {&frame-name} item.fator-reaj-icms = 0 then do:
    {utp/ut-field.i mgind item fator-reaj-icms 1}
    run utp/ut-msgs.p (input "show",
                       input 36,
                       input return-value).
    run select-page in wh-cd0903 (3).                   
    apply "entry" to item.fator-reaj-icms in frame {&frame-name}.                       
    return 'adm-error'.
end.

&if "{&bf_dis_versao_ems}" >= "2.062" &then
 IF  input frame {&frame-name} c-cod-familia-impto <> '' 
 AND NOT CAN-FIND(FIRST familia-impto NO-LOCK
                  WHERE familia-impto.cod-familia-impto = input frame {&frame-name} c-cod-familia-impto) THEN DO:
     {utp/ut-field.i mgind familia-impto cod-familia-impto 1}
     run utp/ut-msgs.p (input "show",
                        input 47,
                        input return-value).
     run select-page in wh-cd0903 (3).
     apply "entry" to c-cod-familia-impto in frame {&frame-name}.
     return 'adm-error'.
 END.
&endif
 
&if "{&bf_dis_versao_ems}" >= "2.062" &then
 IF  input frame {&frame-name} c-cod-inss <> '' 
 AND NOT CAN-FIND(FIRST tab-serv-inss NO-LOCK
                  WHERE tab-serv-inss.cdn-serv-inss = int(input frame {&frame-name} c-cod-inss)) THEN DO:
     {utp/ut-field.i mgdis tab-serv-inss cdn-serv-inss 1}
     run utp/ut-msgs.p (input "show",
                        input 47,
                        input return-value).
     run select-page in wh-cd0903 (3).
     apply "entry" to c-cod-inss in frame {&frame-name}.
     return 'adm-error'.
 END.
&endif

IF  input frame {&frame-name} c-cod-sefazsp <> '0' 
AND NOT CAN-FIND(FIRST produt-sefazsp NO-LOCK
                 WHERE produt-sefazsp.cdn-sefazsp = input frame {&frame-name} c-cod-sefazsp) THEN DO:
     {utp/ut-field.i mgdis produt-sefazsp cdn-sefazsp 1}
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
     run select-page in wh-cd0903 (3).
     apply "entry" to c-cod-sefazsp in frame {&frame-name}.
     return 'adm-error'.
END.


IF  TRIM(INPUT FRAME {&FRAME-NAME} c-cod-ean) <> "" THEN DO:
    FIND FIRST item-mat NO-LOCK 
    WHERE item-mat.it-codigo <> item.it-codigo 
    AND item-mat.cod-ean = TRIM(INPUT FRAME {&FRAME-NAME} c-cod-ean) NO-ERROR.

    IF AVAIL item-mat THEN DO:
        RUN utp/ut-msgs.p (input "show",
                           input 55922,
                           input item-mat.it-codigo).

        IF  RETURN-VALUE = "no" THEN DO:
            RUN select-page IN wh-cd0903 (3).
            APPLY "entry" TO c-cod-ean IN FRAME {&FRAME-NAME}.
            RETURN 'adm-error'.
        END.
    END.
END.   


/*--- Nota Fiscal Eletronica - cEANTrib ---*/
IF  l-funcao-nfe
AND TRIM(INPUT FRAME {&FRAME-NAME} c-cod-ean) <> "":U THEN DO:

    DEFINE VARIABLE h-bodi247 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iCodErro  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cRetorno1 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cRetorno2 AS CHARACTER   NO-UNDO.

    IF  TRIM(INPUT FRAME {&FRAME-NAME} c-cod-ean) <> "" THEN DO:

        RUN dibo/bodi247.p PERSISTENT SET h-bodi247.

        ASSIGN iCodErro = 0.

        RUN validaDigitoVerificadorGTIN IN h-bodi247 (INPUT TRIM(INPUT FRAME {&FRAME-NAME} c-cod-ean),
                                                      OUTPUT iCodErro,
                                                      OUTPUT cRetorno1,
                                                      OUTPUT cRetorno2).

        DELETE PROCEDURE h-bodi247.
        ASSIGN h-bodi247 = ?.

        IF  iCodErro <> 0 THEN DO:

            run utp/ut-msgs.p (input "show",
                               input iCodErro,
                               input cRetorno1 + "~~":U + cRetorno2).
            run select-page in wh-cd0903 (3).
            apply "entry" to c-cod-ean in frame {&frame-name}.
            return 'adm-error'.
        END.
    END.
END.
/*---*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

