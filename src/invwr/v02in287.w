&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V02IN287 2.00.00.087 } /*** "010087" 01/10/2026 14:36:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in287 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var l-inclui    as logical no-undo.
def new global shared var l-tem-movto as logical no-undo.
def new global shared var l-erro      as logical no-undo.
def new global shared var h-window    as handle  no-undo.

def var c-conta as char no-undo.
def var c-rs-saldo-dt-consumo as char no-undo.

/* Vari†veis necess†rias Ö chamada da api cdapi005 */
def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo.

DEF VAR c-cod-lote-wms-ext-ant AS CHAR NO-UNDO.
           

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

{cdp/cdcfgmat.i}

def buffer b-param-estoq for param-estoq.

/********************Multiplanta-SMC***********************/
/* Datasul 11 nao utiliza mais multiplanta
def var i-tipo-movto   as integer no-undo.
{cdp/cd7300.i1}
{cdp/cdapi216.i}
{mcinc/mcapi279.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.
*/
/*******************FIM-SMC********************************/
/* Seguranca por Estabelecimento */
{cdp/cd0031.i}


/* Definicao Temp-table RowErrors */
{method/dbotterr.i}

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.depos-pad param-estoq.pg-diario ~
param-estoq.estab-uni param-estoq.ult-pg-diario param-estoq.cons-invent ~
param-estoq.cons-prev-estab param-estoq.gera-contab 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-10 RECT-11 RECT-13 RECT-5 RECT-7 ~
rc-rateia RECT-12 c-estabel-pad tg-integra-wms c-cod-lote-wms ~
c-cod-lote-wms-ext tg-mult-ref l-aprovacao valida-req-cc tb-consumo-aad ~
rs-rateia-un l-rastreab l-dep-fechado l-armazem-geral rs-saldo-dt-consumo ~
un-medida 
&Scoped-Define DISPLAYED-FIELDS param-estoq.depos-pad param-estoq.pg-diario ~
param-estoq.estab-uni param-estoq.ult-pg-diario param-estoq.cons-invent ~
param-estoq.cons-prev-estab param-estoq.gera-contab 
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
&Scoped-Define DISPLAYED-OBJECTS c-estabelec c-deposito tg-integra-wms ~
c-cod-lote-wms c-cod-lote-wms-ext tg-mult-ref l-aprovacao valida-req-cc ~
tb-consumo-aad rs-rateia-un l-rastreab l-dep-fechado l-armazem-geral ~
rs-saldo-dt-consumo un-medida 

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
DEFINE VARIABLE c-cod-lote-wms AS CHARACTER FORMAT "x(40)" 
     LABEL "Lote Alocaá∆o WMS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-lote-wms-ext AS CHARACTER FORMAT "x(40)" 
     LABEL "Lote Aloc WMS Ext" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-pad LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-saldo-dt-consumo AS CHARACTER FORMAT "X(256)":U INITIAL "Consiste Saldo Data Consumo" 
      VIEW-AS TEXT 
     SIZE 25.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-un-medida AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE FI-GERA-CONTAB AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-rateia-un AS CHARACTER FORMAT "X(256)":U INITIAL "Rateia Valor Unidade Neg¢cio" 
      VIEW-AS TEXT 
     SIZE 25.14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Considera Invent†rio" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE rs-rateia-un AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Autom†tico (C†lculo Preáo MÇdio)", 1,
"Manual (C†lculo Rateio Unidade Neg¢cio - Batch)", 2
     SIZE 41 BY 1.38 NO-UNDO.

DEFINE VARIABLE rs-saldo-dt-consumo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "N∆o Consiste", 1,
"Todos Per°odos", 2,
"Somente Per°odos Anteriores", 3
     SIZE 46 BY 2.1 NO-UNDO.

DEFINE VARIABLE un-medida AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Informa", 1,
"Default Item", 2
     SIZE 33.29 BY .92 NO-UNDO.

DEFINE RECTANGLE rc-rateia
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 2.08.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 2.17.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.58.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.75.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.57 BY 2.79.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 7.46.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 2.29.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.58.

DEFINE VARIABLE l-aprovacao AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE l-armazem-geral AS LOGICAL INITIAL no 
     LABEL "ArmazÇm Geral" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE l-dep-fechado AS LOGICAL INITIAL no 
     LABEL "Dep Fechado" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE l-rastreab AS LOGICAL INITIAL no 
     LABEL "Gera Rastreabilidade Cont†bil" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE tb-consumo-aad AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-integra-wms AS LOGICAL INITIAL no 
     LABEL "Integra WMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.86 BY .79 NO-UNDO.

DEFINE VARIABLE tg-mult-ref AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.57 BY .88 NO-UNDO.

DEFINE VARIABLE valida-req-cc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-estabel-pad AT ROW 1.13 COL 28.72 COLON-ALIGNED HELP
          ""
          LABEL "":R7
     c-estabelec AT ROW 1.13 COL 36.72 COLON-ALIGNED NO-LABEL
     param-estoq.depos-pad AT ROW 2.17 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-deposito AT ROW 2.17 COL 36.72 COLON-ALIGNED NO-LABEL
     tg-integra-wms AT ROW 3.29 COL 2.14
     c-cod-lote-wms AT ROW 3.33 COL 29 COLON-ALIGNED
     param-estoq.pg-diario AT ROW 3.42 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     param-estoq.estab-uni AT ROW 4.08 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 11.86 BY .88
     c-cod-lote-wms-ext AT ROW 4.29 COL 29 COLON-ALIGNED WIDGET-ID 14
     param-estoq.ult-pg-diario AT ROW 4.42 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tg-mult-ref AT ROW 4.92 COL 2.14
     l-aprovacao AT ROW 5.75 COL 2.14
     param-estoq.cons-invent AT ROW 6.33 COL 56 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Saldo", 1,
"Contagem", 2
          SIZE 30.86 BY .88
     valida-req-cc AT ROW 6.54 COL 2.14
     tb-consumo-aad AT ROW 7.38 COL 2.14
     param-estoq.cons-prev-estab AT ROW 8.17 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .88
     rs-rateia-un AT ROW 8.21 COL 46 NO-LABEL
     l-rastreab AT ROW 9 COL 2.14
     l-dep-fechado AT ROW 9.75 COL 2.14 WIDGET-ID 10
     l-armazem-geral AT ROW 9.75 COL 25 WIDGET-ID 12
     param-estoq.gera-contab AT ROW 10.58 COL 56 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Integra", 1,
"Exporta", 2
          SIZE 28 BY .88
     rs-saldo-dt-consumo AT ROW 11.58 COL 2.86 NO-LABEL WIDGET-ID 6
     un-medida AT ROW 12.71 COL 51.57 NO-LABEL
     FILL-IN-1 AT ROW 5.54 COL 46.86 NO-LABEL
     fi-rateia-un AT ROW 7.46 COL 46.86 NO-LABEL
     FI-GERA-CONTAB AT ROW 10 COL 46.72 NO-LABEL
     c-saldo-dt-consumo AT ROW 10.75 COL 2.72 NO-LABEL WIDGET-ID 4 DEBLANK 
     c-un-medida AT ROW 11.96 COL 46.72 COLON-ALIGNED NO-LABEL DEBLANK 
     RECT-1 AT ROW 1 COL 1
     RECT-10 AT ROW 10.17 COL 45
     RECT-11 AT ROW 12 COL 45
     RECT-13 AT ROW 3.21 COL 1
     RECT-5 AT ROW 3.21 COL 45
     RECT-7 AT ROW 5.79 COL 45
     rc-rateia AT ROW 7.75 COL 45
     RECT-12 AT ROW 11 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 12.83
         WIDTH              = 86.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabel-pad IN FRAME f-main
   NO-DISPLAY LIKE = mgadm.estabelec.cod-estabel EXP-LABEL              */
/* SETTINGS FOR FILL-IN c-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-saldo-dt-consumo IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-un-medida IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FI-GERA-CONTAB IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN fi-rateia-un IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fi-rateia-un:PRIVATE-DATA IN FRAME f-main     = 
                "Rateia Valor Unidade Neg¢cio".

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       FILL-IN-1:PRIVATE-DATA IN FRAME f-main     = 
                "Considera Invent†rio".

ASSIGN 
       l-dep-fechado:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       l-rastreab:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       tg-mult-ref:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-estabel-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-pad V-table-Win
ON F5 OF c-estabel-pad IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=c-estabel-pad
                     &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-pad V-table-Win
ON LEAVE OF c-estabel-pad IN FRAME f-main
DO:
  {include/leave.i &tabela=estabelec 
                   &atributo-ref=nome
                   &variavel-ref=c-estabelec
                   &where="estabelec.cod-estabel=input frame {&frame-name} c-estabel-pad"} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estabel-pad IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.depos-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.depos-pad V-table-Win
ON F5 OF param-estoq.depos-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                     &campo=param-estoq.depos-pad
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.depos-pad V-table-Win
ON LEAVE OF param-estoq.depos-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  {include/leave.i &tabela=deposito 
                   &atributo-ref=nome
                   &variavel-ref=c-deposito
                   &where="deposito.cod-depos=input frame {&frame-name} param-estoq.depos-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.depos-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.depos-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-integra-wms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-integra-wms V-table-Win
ON VALUE-CHANGED OF tg-integra-wms IN FRAME f-main /* Integra WMS */
DO:
   IF tg-integra-wms:CHECKED IN FRAME {&frame-name} = YES THEN
       ASSIGN c-cod-lote-wms:SENSITIVE IN FRAME {&frame-name} = YES.
   ELSE
       ASSIGN c-cod-lote-wms:SENSITIVE IN FRAME {&frame-name} = NO
              c-cod-lote-wms:SCREEN-VALUE IN FRAME {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
  if c-estabel-pad:load-mouse-pointer ('image~\lupa.cur') in frame {&frame-name} then.
  if param-estoq.depos-pad:load-mouse-pointer   ('image~\lupa.cur') in frame {&frame-name} then.

  {utp/ut-liter.i Valida_Centro_Custo * R}
  assign valida-req-cc:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Aprovaá∆o_Requisiá∆o * R}
  assign l-aprovacao:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Estabelecimento_Padr∆o * R}
  assign c-estabel-pad:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Item_com_M£ltiplas_Referàncias * R}
  assign tg-mult-ref:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualiza_Consumo_AtÇ_a_Data * R}
  assign tb-consumo-aad:label in frame {&frame-name} = return-value.

    {utp/ut-liter.i Lote_Aloc_WMS_Ext * R}
    assign c-cod-lote-wms-ext:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Dep_Fechado * R}
  assign l-dep-fechado:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i ArmazÇm_Geral * R}
  assign l-armazem-geral:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Todos_Per°odos * R}
  assign c-rs-saldo-dt-consumo = "N∆o Consiste,1," + return-value + ",2,".

  {utp/ut-liter.i Somente_Per°odos_Anteriores * R}
  assign c-rs-saldo-dt-consumo = c-rs-saldo-dt-consumo + return-value + ",3"
      rs-saldo-dt-consumo:radio-buttons in frame {&frame-name} = c-rs-saldo-dt-consumo.


  &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
  {utp/ut-liter.i Rateia_Valor_Unidade_Neg¢cio * R}
  assign fi-rateia-un:screen-value in frame {&frame-name} = return-value.
  &endif

  &if "{&bf_mat_versao_ems}":U < "2.062":U &then
  assign rc-rateia   :hidden in frame {&frame-name} = yes
         fi-rateia-un:hidden in frame {&frame-name} = yes
         rs-rateia-un:hidden in frame {&frame-name} = yes.      
  &endif

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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

  assign l-inclui = yes.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind param-estoq gera-contab fi-gera-contab}  

  {utp/ut-liter.i Unidade_de_Medida * r}
      assign c-un-medida = return-value.
      disp c-un-medida with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var c-cod-estab-aux         LIKE c-estabel-pad.
def var l-aprovacao-aux         LIKE l-aprovacao.
def var l-valida-aux            LIKE valida-req-cc.
DEF VAR l-dep-fechado-aux       LIKE l-dep-fechado.
DEF VAR l-armazem-geral-aux     LIKE l-armazem-geral.
DEF VAR rs-saldo-dt-consumo-aux LIKE rs-saldo-dt-consumo.
DEF VAR l-rastreab-aux          LIKE l-rastreab.
DEF VAR tg-mult-ref-aux         LIKE tg-mult-ref.
DEF VAR tg-integra-wms-aux      LIKE tg-integra-wms.
DEF VAR c-cod-lote-wms-aux      LIKE c-cod-lote-wms.
DEF VAR c-cod-lote-wms-ext-aux  LIKE c-cod-lote-wms-ext.
DEF VAR rs-rateia-un-aux        LIKE rs-rateia-un.
def var l-valida-saldo  as logical no-undo.
DEF VAR l-achou         AS LOG  NO-UNDO.
DEF VAR c-texto1        AS CHAR NO-UNDO.
DEF VAR c-texto2        AS CHAR NO-UNDO.
DEF VAR c-texto3        AS CHAR NO-UNDO.
DEF VAR l-agrupa-emp    AS LOG  NO-UNDO.
DEF VAR l-medio-global  AS LOG  NO-UNDO.
DEF VAR h-acomp         AS HANDLE NO-UNDO.  
DEF VAR h-ceapi405      AS HANDLE NO-UNDO.


DO TRANS:

    IF  l-dep-fechado:CHECKED IN FRAME {&FRAME-NAME} = TRUE THEN DO:

        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                      INPUT 'l-agr-estab-emp').
        ASSIGN l-agrupa-emp = TRIM(RETURN-VALUE) = "yes".
    
    
        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                      INPUT 'tip-calc-med').
        ASSIGN l-medio-global = TRIM(RETURN-VALUE) = "2".
    
        IF  l-agrupa-emp
        OR  l-medio-global THEN DO:
            {utp/ut-liter.i "N∆o_Ç_possivel_utilizar_MÇdio_Global_ou_Fechamento_Agrupado_por_Empresa" *}
            ASSIGN c-texto1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i  "Quando_o_parametro_DEP_FECHADO_est†_selecionado_n∆o_Ç_poss°vel_utilizar_Medio_Global_ou_Fechamento_Agrupado_por_Empresa." *}
            RUN utp/ut-msgs.p("show",
                              17242,
                              c-texto1 + '~~' + TRIM(RETURN-VALUE)).
    
            RETURN "adm-error":U.
        END.

    END.
 
    IF AVAIL param-estoq THEN DO:
    
        IF  (l-dep-fechado:CHECKED IN FRAME {&FRAME-NAME} = FALSE AND SUBSTR(param-estoq.char-2,116,1) = "S") THEN DO:
             /*--- quando o parametro dep-fechado for desmarcado em tela, verifica 
                   se antes estava ligado e se existe saldo-terc do tipo deposito fechado.
                   se jah existir nao deixa desmarcar o parametro, pois entende-se que 
                   a funcao jah estah em uso ---*/
             
             ASSIGN l-achou = NO.
        
             FOR EACH  natur-oper FIELDS(nat-operacao tp-oper-terc)
                 WHERE natur-oper.tp-oper-terc >= 8 
                   AND natur-oper.tp-oper-terc <= 9 NO-LOCK:
        
                 IF  CAN-FIND(FIRST saldo-terc
                              WHERE saldo-terc.nat-operacao = natur-oper.nat-operacao)  THEN DO:
        
                     ASSIGN l-achou = YES.
                     {utp/ut-liter.i "Funcao_Deposito_Fechado" *}
                     ASSIGN c-texto1 = TRIM(RETURN-VALUE).
                     {utp/ut-liter.i "ser_desmarcada" *}
                     ASSIGN c-texto2 = TRIM(RETURN-VALUE).
                     {utp/ut-liter.i "Remessas_Deposito_Fechado" *}
                     ASSIGN c-texto3 = TRIM(RETURN-VALUE).
                     RUN utp/ut-msgs.p("show",32008,c-texto1 + '~~' + c-texto2 + '~~' + c-texto3).
                     RETURN "adm-error":U.
        
                 END.
             END.
             
             IF  NOT l-achou THEN DO:
                
                 FIND FIRST param-estoq EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAIL param-estoq THEN
                     ASSIGN OVERLAY(param-estoq.char-2,116,1) = IF  INPUT FRAME {&FRAME-NAME} l-dep-fechado THEN "S" ELSE "N".
                 FIND FIRST param-estoq NO-LOCK NO-ERROR.
             END.

        END.

        IF  (l-armazem-geral:CHECKED IN FRAME {&FRAME-NAME} = FALSE AND SUBSTR(param-estoq.char-2,115,1) = "S") THEN DO:
             /*--- quando o parametro dep-fechado for desmarcado em tela, verifica 
                   se antes estava ligado e se existe saldo-terc do tipo deposito fechado.
                   se jah existir nao deixa desmarcar o parametro, pois entende-se que 
                   a funcao jah estah em uso ---*/
             
             ASSIGN l-achou = NO.
        
             FOR EACH  natur-oper FIELDS(nat-operacao tp-oper-terc)
                 WHERE natur-oper.tp-oper-terc >= 10 
                   AND natur-oper.tp-oper-terc <= 11 NO-LOCK:
        
                 IF  CAN-FIND(FIRST saldo-terc
                              WHERE saldo-terc.nat-operacao = natur-oper.nat-operacao)  THEN DO:
        
                     ASSIGN l-achou = YES.
                     {utp/ut-liter.i "Funcao_ArmazÇm_Geral" *}
                     ASSIGN c-texto1 = TRIM(RETURN-VALUE).
                     {utp/ut-liter.i "ser_desmarcada" *}
                     ASSIGN c-texto2 = TRIM(RETURN-VALUE).
                     {utp/ut-liter.i "Remessas_ArmazÇm_Geral" *}
                     ASSIGN c-texto3 = TRIM(RETURN-VALUE).
                     RUN utp/ut-msgs.p("show",32008,c-texto1 + '~~' + c-texto2 + '~~' + c-texto3).
                     RETURN "adm-error":U.
        
                 END.
             END.
             
             IF  NOT l-achou THEN DO:
        
                 FIND FIRST param-estoq EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAIL param-estoq THEN
                     ASSIGN OVERLAY(param-estoq.char-2,115,1) = IF  INPUT FRAME {&FRAME-NAME} l-armazem-geral THEN "S" ELSE "N".
                 FIND FIRST param-estoq NO-LOCK NO-ERROR.
        
             END.
        END.
        
    END.
      
END.

find estabelec where
    estabelec.cod-estabel=input frame {&frame-name} c-estabel-pad
    no-lock no-error.
if not avail estabelec then do:
    {utp/ut-field.i mgind param-estoq estabel-pad 1}
    run utp/ut-msgs.p (input "show",input 47,input trim(return-value)).
    assign l-erro = yes.
    apply "entry" to c-estabel-pad in frame {&frame-name}.
    return "adm-error".
end.

assign c-cod-estab-aux         = input frame {&frame-name} c-estabel-pad
       l-valida-aux            = input frame {&frame-name} valida-req-cc 
       l-aprovacao-aux         = input frame {&frame-name} l-aprovacao
       l-dep-fechado-aux       = input frame {&frame-name} l-dep-fechado 
       l-armazem-geral-aux     = input frame {&frame-name} l-armazem-geral
       rs-saldo-dt-consumo-aux = input frame {&frame-name} rs-saldo-dt-consumo 
       tg-mult-ref-aux         = input frame {&frame-name} tg-mult-ref 
       l-rastreab-aux          = input frame {&frame-name} l-rastreab
       tg-integra-wms-aux      = input frame {&frame-name} tg-integra-wms
       c-cod-lote-wms-aux      = input frame {&frame-name} c-cod-lote-wms
       c-cod-lote-wms-ext-aux  = input frame {&frame-name} c-cod-lote-wms-ext       
       rs-rateia-un-aux        = input frame {&frame-name} rs-rateia-un.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  RETURN-VALUE = 'ADM-ERROR':U then RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  assign c-estabel-pad       = c-cod-estab-aux
         valida-req-cc       = l-valida-aux          
         l-aprovacao         = l-aprovacao-aux
         l-dep-fechado       = l-dep-fechado-aux
         l-armazem-geral     = l-armazem-geral-aux
         rs-saldo-dt-consumo = rs-saldo-dt-consumo-aux
         tg-mult-ref         = tg-mult-ref-aux
         l-rastreab          = l-rastreab-aux
         tg-integra-wms      = tg-integra-wms-aux
         c-cod-lote-wms      = c-cod-lote-wms-aux
         c-cod-lote-wms-ext  = c-cod-lote-wms-ext-aux         
         rs-rateia-un        = rs-rateia-un-aux.

  if avail param-estoq then do transaction:
     assign param-estoq.estabel-pad = c-estabel-pad.

     IF l-dep-fechado = yes THEN
         ASSIGN OVERLAY(param-estoq.char-2,116,1) = "S".
     ELSE
         ASSIGN OVERLAY(param-estoq.char-2,116,1) = "N".

     IF l-armazem-geral = yes THEN
         ASSIGN OVERLAY(param-estoq.char-2,115,1) = "S".
     ELSE 
         ASSIGN OVERLAY(param-estoq.char-2,115,1) = "N".

     /*--- Verifica se valida saldo na data de consumo ---*/
     CASE rs-saldo-dt-consumo:
         WHEN 3 THEN /* Valida somente periodos anteriores */
            ASSIGN OVERLAY(param-estoq.char-1,31,1) = "2".
         WHEN 2 THEN
               ASSIGN OVERLAY(param-estoq.char-1,31,1) = "1".
         OTHERWISE /* Nao valida */
             ASSIGN OVERLAY(param-estoq.char-1,31,1) = "0".
     END.

     if  valida-req-cc = yes
         then assign substr(param-estoq.char-1,3,1,"character") = "Y".
         else assign substr(param-estoq.char-1,3,1,"character") = "N".

     if  l-aprovacao = yes
         then assign substr(param-estoq.char-1,4,1,"character") = "Y".
         else assign substr(param-estoq.char-1,4,1,"character") = "N".

     if  input frame {&frame-name} tb-consumo-aad = yes then
         assign param-estoq.dec-2 = 0.
     else
         assign param-estoq.dec-2 = 1.    

     &if defined (bf_mat_ref_lote) &then 
         if  tg-mult-ref = yes then
             assign OVERLAY(param-estoq.char-2,1,1) = "#".
         else
             assign OVERLAY(param-estoq.char-2,1,1) = "".
     &endif

     &if defined(BF_MAT_GL_POSTING_DETAILS) &then
         if l-rastreab = YES then
            assign OVERLAY(param-estoq.char-2,7,1) = "1".
         else
            assign OVERLAY(param-estoq.char-2,7,1) = "0".
     &endif

     if tg-integra-wms = yes then
          assign param-estoq.int-1 = 1.
     else
          assign param-estoq.int-1 = 0.

     ASSIGN OVERLAY(param-estoq.char-2,26,40)  = c-cod-lote-wms
            OVERLAY(param-estoq.char-2,276,40) = c-cod-lote-wms-ext.

     // DMANESTOQ-14136 - Uma vez passado por todas a validaá‰es, ao informar um lote no CE0101 dever† 
     // ajustar a quantidade alocada no lote generico para os atendimentos que j† est∆o em andamento.
     IF CAN-FIND(FIRST funcao // CD0101 > "WMS Externo" (WMS SAAS)
                 WHERE funcao.cd-funcao = "WMS-SAAS":U
                   AND funcao.ativo NO-LOCK) 
         AND 
         c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" 
         AND
         c-cod-lote-wms-ext-ant <> c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         THEN DO:

         RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
         {utp/ut-liter.i "Alocando_Atendimentos_em_Processo_aguarde..." *}
         RUN pi-inicializar IN h-acomp(RETURN-VALUE).

         EMPTY TEMP-TABLE RowErrors.
         RUN cep/ceapi405.p PERSISTENT SET h-ceapi405.
         RUN pi-alocarAtendEmProcesso IN h-ceapi405 (INPUT FRAME {&frame-name} c-cod-lote-wms-ext, OUTPUT TABLE RowErrors).
         DELETE OBJECT h-ceapi405 NO-ERROR.
         ASSIGN h-ceapi405 = ?.

         RUN pi-finalizar IN h-acomp.
         DELETE OBJECT h-acomp NO-ERROR.
         ASSIGN h-acomp = ?.

         IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
             {utp/ut-liter.i "Encontrado_erros_ao_alocar_Lote_WMS_Externo_em_Atendimentos_em_Processo" *}
             RUN utp/ut-msgs.p (INPUT "MSG",
                                INPUT 17386,
                                INPUT RETURN-VALUE).
             //RETURN "ADM-ERROR":U.
         END.
         ASSIGN c-cod-lote-wms-ext-ant = c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

     END.
      
     &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
         &if "{&bf_mat_versao_ems}":U < "2.08":U &then
             assign overlay(param-estoq.char-1,27,1) = string(rs-rateia-un).
         &else
             assign param-estoq.cdn-rat-un = rs-rateia-un.
         &endif
     &endif

     FIND FIRST param-mat EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL param-mat THEN
      CREATE param-mat.

     ASSIGN param-mat.ind-sit-un = INPUT FRAME {&FRAME-NAME} un-medida.

     /********************Multiplanta-SMC***********************/
     /* Datasul 11 nao utiliza mais multiplanta
       for each tt-smc-param-estoq:
         delete tt-smc-param-estoq.
       end.    
           assign c-transacao = "SMC016".
           {cdp/cd7300.i5 "001" c-transacao "-SMC"}
     
           assign i-tipo-movto = 2.
     
           run pi-cria-tt-dados-smc (input i-tipo-movto).
     
           {cdp/cd7300.i6 "001" c-transacao "-SMC"}
     */
     /******************Fim-Multiplanta-SMC********************/

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &IF "{&mguni_version}" >= "2.071" &THEN
      ASSIGN param-estoq.dat-inic-calc-med-diario = TODAY.
  &ENDIF

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
  {utp/ut-rtlbl.i mgind param-estoq cons-invent fill-in-1}  
  {utp/ut-rtlbl.i mgind param-estoq gera-contab fi-gera-contab}

  {utp/ut-liter.i Unidade_de_Medida * r}
  assign c-un-medida = return-value.
  disp c-un-medida with frame {&frame-name}.

  &if defined(BF_MAT_GL_POSTING_DETAILS) &then
      if  not avail param-estoq then
          find first param-estoq no-lock no-error.

      if available param-estoq then do:
          if  substring(param-estoq.char-2,7,1)  = "1" then
              assign l-rastreab:checked in frame {&frame-name} = YES.
          else
              assign l-rastreab:checked in frame {&frame-name} = NO.
      end.
  &endif

  find first param-mat no-lock no-error.
  if  avail param-mat then
      assign un-medida = param-mat.ind-sit-un.

  if  avail param-estoq then do:
      assign c-estabel-pad = IF l-seg-ativa-modulo THEN 
                                 IF CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = param-estoq.estabel-pad) THEN param-estoq.estabel-pad else "":U
                             ELSE param-estoq.estabel-pad.

      disp c-estabel-pad with frame {&frame-name}.
      find estabelec
          where estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.
      assign c-estabelec = if avail estabelec then estabelec.nome else "":U.
      find deposito
          where deposito.cod-depos = param-estoq.depos-pad no-lock no-error.
      assign c-deposito = if avail deposito then deposito.nome else "":U.
                                                                    
      if  substr(param-estoq.char-1,3,1,"char") = "Y"
          then assign valida-req-cc:checked in frame {&frame-name} = yes.
          else assign valida-req-cc:checked in frame {&frame-name} = no.

      if  substr(param-estoq.char-1,4,1,"char") = "Y"
          then assign l-aprovacao:checked in frame {&frame-name} = yes.
          else assign l-aprovacao:checked in frame {&frame-name} = no.

      if  param-estoq.dec-2 = 1
          then assign tb-consumo-aad:checked in frame {&frame-name} = no.
          else assign tb-consumo-aad:checked in frame {&frame-name} = yes.          

      if  param-estoq.int-1 = 1
          then assign tg-integra-wms:checked in frame {&frame-name} = yes.
          else assign tg-integra-wms:checked in frame {&frame-name} = no.          

      APPLY "value-changed" TO tg-integra-wms IN FRAME {&frame-name}.

      &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
          &if "{&bf_mat_versao_ems}":U < "2.08":U &then
              if substring(param-estoq.char-1,27,1) <> "" then
                 assign rs-rateia-un = int(substring(param-estoq.char-1,27,1)).
              else
                 assign rs-rateia-un = 1.
          &else
              assign rs-rateia-un = param-estoq.cdn-rat-un.
          &endif
          display rs-rateia-un with frame {&frame-name}.

          run pi-habilita-rateio-un (input (param-estoq.tp-fech = 1)).
      &endif

      IF  SUBSTR(param-estoq.char-1,31,1) = "2" THEN
          ASSIGN rs-saldo-dt-consumo = 3. /* Valida em Periodos Anteriores*/
      ELSE IF  SUBSTR(param-estoq.char-1,31,1) = "1" THEN
             ASSIGN rs-saldo-dt-consumo = 2. /* Valida Todos Periodos */
          ELSE
              ASSIGN rs-saldo-dt-consumo = 1. /* N∆o Valida */ 
    
      DISP rs-saldo-dt-consumo WITH FRAME {&FRAME-NAME}.

  end.

  {utp/ut-liter.i Consiste_Saldo_Data_Consumo}
  ASSIGN c-saldo-dt-consumo = TRIM(RETURN-VALUE).
  DISP c-saldo-dt-consumo WITH FRAME {&FRAME-NAME}.
  
  ASSIGN l-dep-fechado   = FALSE
         l-armazem-geral = false.
         
  IF AVAIL param-estoq THEN
    ASSIGN l-dep-fechado   = SUBSTR(param-estoq.char-2,116,1) = "S"
           l-armazem-geral = SUBSTR(param-estoq.char-2,115,1) = "S".

  DISP l-dep-fechado 
       l-armazem-geral WITH FRAME {&FRAME-NAME}.
       

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  RUN GET-ATTRIBUTE('adm-new-record').
  IF return-value = 'yes' THEN ASSIGN l-inclui = yes.
                          ELSE ASSIGN l-inclui = no.
  
  {utp/ut-rtlbl.i mgind param-estoq cons-invent fill-in-1}

  if  avail param-estoq then do:

      if  substr(param-estoq.char-1,3,1,"char") = "Y"
          then assign valida-req-cc:checked in frame {&frame-name} = yes.
          else assign valida-req-cc:checked in frame {&frame-name} = no.

      if  substr(param-estoq.char-1,4,1,"char") = "Y"
          then assign l-aprovacao:checked in frame {&frame-name} = yes.
          else assign l-aprovacao:checked in frame {&frame-name} = no.

      if  param-estoq.dec-2 = 1
          then assign tb-consumo-aad:checked in frame {&frame-name} = no.
          else assign tb-consumo-aad:checked in frame {&frame-name} = yes.

      &if defined (bf_mat_ref_lote) &then
          if  substr(param-estoq.char-2,1,1) = "#" then
              assign tg-mult-ref:checked in frame {&frame-name} = yes.
          else
              assign tg-mult-ref:checked in frame {&frame-name} = no.
      &endif

      &if defined(BF_MAT_GL_POSTING_DETAILS) &then
          if  substring(param-estoq.char-2,7,1)  = "1" then
              assign l-rastreab:checked in frame {&frame-name} = YES.
          else
              assign l-rastreab:checked in frame {&frame-name} = NO.
      &endif

      if  param-estoq.int-1 = 1
          then assign tg-integra-wms:checked in frame {&frame-name} = yes.
          else assign tg-integra-wms:checked in frame {&frame-name} = no.    

      IF tg-integra-wms:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN c-cod-lote-wms:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,26,40)
               c-cod-lote-wms:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 
      ELSE
          ASSIGN c-cod-lote-wms:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

      // CD0101 > "WMS Externo" (WMS SAAS)
      IF CAN-FIND(FIRST funcao
                  WHERE funcao.cd-funcao = "WMS-SAAS":U
                    AND funcao.ativo NO-LOCK) THEN 
        ASSIGN c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,276,40)
               c-cod-lote-wms-ext:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               c-cod-lote-wms-ext-ant = c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}. 
      ELSE
          ASSIGN c-cod-lote-wms-ext:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
          
  end.

  {utp/ut-liter.i Considera_Invent†rio MCE}
  ASSIGN fill-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  ENABLE l-dep-fechado WITH FRAME {&FRAME-NAME}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {utp/ut-glob.i}
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-rtlbl.i mgind param-estoq cons-invent fill-in-1}
  /* Dispatch standard ADM method.                             */

  assign l-inclui = not can-find (first b-param-estoq).

  find first param-global no-lock no-error.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined(BF_MAT_GL_POSTING_DETAILS) &then
      assign l-rastreab:hidden    in frame {&frame-name} = no
             l-rastreab:sensitive in frame {&frame-name} = yes.
  &endif

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN h-window = THIS-PROCEDURE.

  assign param-estoq.gera-contab:radio-buttons in frame {&frame-name} = 
                                  {ininc/i04in287.i 4 1} + ", 1," +
                                  {ininc/i04in287.i 4 2} + ", 2".

  &if defined (bf_mat_ref_lote) &then

      assign tg-mult-ref:hidden    in frame {&frame-name} = no
             tg-mult-ref:sensitive in frame {&frame-name} = yes.

  &endif
  
  /*Faz a mudanáa do armazenamento dos parametros Deposito Fechado/Armazem Geral da funá∆o para a param-estoq*/
  IF AVAIL param-estoq THEN DO:
  
      IF SUBSTR(param-estoq.char-2,116,1) <> "S" OR SUBSTR(param-estoq.char-2,115,1) <> "S" THEN DO:
       
       FIND FIRST funcao 
            WHERE funcao.cd-funcao = "SPP-DEP-FECH-ESTOQUE" 
              AND funcao.ativo = YES EXCLUSIVE-LOCK NO-ERROR.
       
       IF  AVAIL funcao THEN DO:

           FIND FIRST param-estoq EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL param-estoq THEN
               ASSIGN OVERLAY(param-estoq.char-2,116,1) = "S"
                      OVERLAY(param-estoq.char-2,115,1) = "S"
                      funcao.ativo = NO.
           FIND FIRST param-estoq NO-LOCK NO-ERROR.
           
       END.

      END.  
  
  END. 
  

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-lote-wms-ext    AS CHAR    NO-UNDO.
    DEF VAR c-lote-wms-param  AS CHAR    NO-UNDO.    
    DEF VAR d-tot-aloc-prod   AS DEC     NO-UNDO.  
    DEF VAR l-lote-wms        AS LOG     NO-UNDO.    
    DEF VAR h-ceapi405        AS HANDLE  NO-UNDO.
    DEF VAR h-acomp           AS HANDLE  NO-UNDO.
    
    
    
    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    /* Ponha aqui a validaá∆o de chave duplicada */

    /* Ponha aqui as demais validaá‰es */

    {utp/ut-rtlbl.i mgind param-estoq cons-invent fill-in-1}

    /***************** Validacao do param-estoq.cod-lote-wms  ********************/
    if tg-integra-wms:CHECKED IN FRAME {&frame-name} = YES AND c-cod-lote-wms:SCREEN-VALUE IN FRAME {&frame-name} = "" then do:
          {utp/ut-liter.i Lote_Alocaá∆o_WMS *}
          run utp/ut-msgs.p (input "show",
                             input 17386, /* O campo &1 deve ser preenchido. */
                             input  RETURN-VALUE).
          assign l-erro = yes.
          APPLY "entry" TO c-cod-lote-wms IN FRAME {&frame-name}.
          return "ADM-ERROR".
    end.
    /*****************************************************************************/ 
       
    // Emite mensagem de erro caso o usu†rio tente modificar ou deixar em branco o lote do wms externo 
    // e tenha saldo-estoq com quantidade alocada para o referido lote.    
    IF CAN-FIND(FIRST funcao // CD0101 > "WMS Externo" (WMS SAAS)
                WHERE funcao.cd-funcao = "WMS-SAAS":U
                  AND funcao.ativo NO-LOCK)
       AND SUBSTRING(param-estoq.char-2,276,40) <> "" THEN DO:
        ASSIGN c-lote-wms-ext   = c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               c-lote-wms-param = SUBSTRING(param-estoq.char-2,276,40). 
        ASSIGN d-tot-aloc-prod = 0.    
        FOR EACH saldo-estoq 
           WHERE saldo-estoq.lote = c-lote-wms-param NO-LOCK: 
           ASSIGN d-tot-aloc-prod = d-tot-aloc-prod + saldo-estoq.qt-aloc-prod.
        END. 
        
        IF c-cod-lote-wms-ext-ant <> c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           AND
           (c-lote-wms-ext = "" OR c-lote-wms-ext <> c-lote-wms-param)
           AND
           d-tot-aloc-prod > 0
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 58056, 
                               INPUT "").  
            ASSIGN l-erro = YES.
            APPLY "entry" TO c-cod-lote-wms-ext IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
        END. 
    END.
    
  IF tg-integra-wms:CHECKED IN FRAME {&frame-name} 
     AND
     CAN-FIND(FIRST funcao // CD0101 > "WMS Externo" (WMS SAAS)
              WHERE funcao.cd-funcao = "WMS-SAAS":U
                AND funcao.ativo NO-LOCK) THEN DO:
      
      // Emite mensagem de erro caso o usu†rio tente usar um lote igual ao "lote alocaá∆o wms externo" do CE0101.
      IF c-cod-lote-wms:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
         SUBSTRING(param-estoq.char-2,276,40) THEN DO:
          {utp/ut-liter.i CE0101 *}          
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 58068, 
                             INPUT RETURN-VALUE).
          ASSIGN l-erro = YES.
          APPLY "entry" TO c-cod-lote-wms IN FRAME {&FRAME-NAME}.
          RETURN "ADM-ERROR".
      END.                   
                  
      // Emite mensagem de erro caso o usu†rio tente usar um lote igual ao "lote alocaá∆o wms" do CE0101.
      IF SUBSTRING(param-estoq.char-2,26,40) = 
         c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
          {utp/ut-liter.i CE0101 *}          
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 58055, 
                             INPUT RETURN-VALUE).
          ASSIGN l-erro = YES.                               
          APPLY "entry" TO c-cod-lote-wms-ext IN FRAME {&FRAME-NAME}.
          RETURN "ADM-ERROR".
      END.               
  END.
    
  // Emite mensagem de erro caso o usu†rio tente usar um lote igual ao "lote alocaá∆o wms" do EQ0301.    
  IF CAN-FIND(FIRST funcao // CD0101 > "WMS Externo" (WMS SAAS)
              WHERE funcao.cd-funcao = "WMS-SAAS":U
                AND funcao.ativo NO-LOCK) 
      AND 
      c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
                
      ASSIGN l-lote-wms = NO.
      FOR EACH eq-param-embarq NO-LOCK:
          IF c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME} = eq-param-embarq.nom-lote-wms THEN DO:
              ASSIGN l-lote-wms = YES.
              LEAVE.
          END.
      END.
          
      IF l-lote-wms THEN DO:
          {utp/ut-liter.i EQ0301 *}          
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 58055, 
                             INPUT RETURN-VALUE).
          ASSIGN l-erro = YES.                               
          APPLY "entry" TO c-cod-lote-wms-ext IN FRAME {&FRAME-NAME}.
          RETURN "ADM-ERROR".
      END. 
  END.  

  // Emite mensagem de erro caso o usu†rio tente utilizar um lote que j† tenha saldo alocado (saldo-estoq.qt-aloc-prod) 
  // para que n∆o misture alocaá‰es j† existentes.
  IF CAN-FIND(FIRST funcao // CD0101 > "WMS Externo" (WMS SAAS)
              WHERE funcao.cd-funcao = "WMS-SAAS":U
                AND funcao.ativo NO-LOCK) THEN DO: 
      ASSIGN c-lote-wms-ext = c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
      ASSIGN d-tot-aloc-prod = 0.    
      FOR EACH saldo-estoq 
         WHERE saldo-estoq.lote = c-lote-wms-ext NO-LOCK: 
         ASSIGN d-tot-aloc-prod = d-tot-aloc-prod + saldo-estoq.qt-aloc-prod.
      END. 
      
      IF c-cod-lote-wms-ext-ant <> c-cod-lote-wms-ext:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         AND
         d-tot-aloc-prod > 0 THEN DO:

          {utp/ut-liter.i Lote_WMS_Externo_indicado_j†_possui_alocaá‰es_pr¢prias *}          
          RUN utp/ut-msgs.p (INPUT "show":U, 
                             INPUT 58056, 
                             INPUT RETURN-VALUE).
          ASSIGN l-erro = YES.                               
          APPLY "entry" TO c-cod-lote-wms-ext IN FRAME {&FRAME-NAME}.
          RETURN "ADM-ERROR".   
      END.
  END.          
   
  ASSIGN l-erro = no.

  /* As datas de fechamento do per°odo devem ser validadas
     apenas quando os campos estiverem habilitados */
  if  l-inclui    = yes
  or  l-tem-movto = no then do:

      /***************** Validacao do param-estoq.ult-per-fech  ********************/
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                    INPUT 'ult-per-fech').
      IF  return-value = "    /" OR return-value = ? OR return-value = "" THEN DO:
          {utp/ut-field.i mgind param-estoq ult-per-fech 1}
          RUN utp/ut-msgs.p (INPUT 'show',
                             INPUT 578, /* Per°odo Inv†lido*/
                             INPUT return-value).
          ASSIGN l-erro = yes.
          RUN pi-pagina2-ult-per-fech in h-window.
          RETURN "ADM-ERROR".
      END.
    
      run cdp/cdapi005.p (replace(return-value,"/",""),
                          output da-iniper,   
                          output da-fimper,
                          output i-per-corrente,
                          output i-ano-corrente,
                          output da-iniper-fech,
                          output da-fimper-fech).
    
      if  da-fimper-fech = ? then do:
          run utp/ut-msgs.p (input "show",
                             input 16459, /* Ano fiscal n∆o est† cadastrado */
                             input "").
          assign l-erro = yes.
          run pi-pagina2-ult-per-fech in h-window.
          return "adm-error".
      end.
      /*****************************************************************************/    
    
      /***************** Validacao do param-estoq.ult-fech-dia  ********************/
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                    INPUT 'ult-fech-dia').
    
      if  da-fimper-fech <> date(return-value) then do:
          {utp/ut-field.i mgind param-estoq ult-fech-dia 1}
          run utp/ut-msgs.p (input "show",
                             input 29928, /* &1 deve ser igual a &2 */
                             input return-value + "~~" +
                                   string(da-fimper-fech)).
          assign l-erro = yes.
          run pi-pagina2-ult-fech-dia in h-window.
          return "ADM-ERROR".
      end.
      /*****************************************************************************/    
    
      /***************** Validacao do param-estoq.mensal-ate ************************/
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                    INPUT 'mensal-ate').
    
      if  da-fimper-fech <> date(return-value) then do:
          {utp/ut-field.i mgind param-estoq mensal-ate 1}
          run utp/ut-msgs.p (input "show",
                             input 29928, /* &1 deve ser igual a &2 */
                             input return-value + "~~" +
                                   string(da-fimper-fech)).
          assign l-erro = yes.
          run pi-pagina2-mensal-ate in h-window.
          return "ADM-ERROR".
      end.
      /*****************************************************************************/    
    
      /***************** Validacao do param-estoq.contab-ate  **********************/
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                    INPUT 'contab-ate').
    
      if  da-fimper-fech <> date(return-value) then do:
          {utp/ut-field.i mgind param-estoq contab-ate 1}
          run utp/ut-msgs.p (input "show",
                             input 29928, /* &1 deve ser igual a &2 */
                             input return-value + "~~" +
                                   string(da-fimper-fech)).
          assign l-erro = yes.
          run pi-pagina2-contab-ate in h-window.
          return "ADM-ERROR".
      end.
      /*****************************************************************************/    

  end.

  /********************** Validacao de Contas **********************************/
  RUN pi-valida-contas.
  /*****************************************************************************/

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oi-cria V-table-Win 
PROCEDURE oi-cria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/        
def input parameter i-tipo-movto as integer.
/* Datasul 11 nao utiliza mais multiplanta
   if  param-global.modulo-mp and
        tt-replica-msg-SMC.log-replica-msg  = yes then do: 
        create tt-smc-param-estoq.
        buffer-copy param-estoq to tt-smc-param-estoq.
        create tt-dados-env-SMC.                  
        assign tt-dados-env-SMC.num-sequencia  = i-seq
               tt-dados-env-SMC.cod-tipo-reg   = 279
               tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
               tt-dados-env-SMC.identif-msg    = string(param-estoq.estabel-pad).
        raw-transfer tt-smc-param-estoq to tt-dados-env-SMC.conteudo-msg. 
        assign i-seq = i-seq + 1.                                     
   end.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-guarda-handle V-table-Win 
PROCEDURE pi-guarda-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-window as handle no-undo.

    assign h-window = p-window.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-rateio-un V-table-Win 
PROCEDURE pi-habilita-rateio-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-habilita as logical no-undo.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
assign rs-rateia-un:sensitive in frame {&frame-name} = p-habilita.
&endif                                                            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-contas V-table-Win 
PROCEDURE pi-valida-contas :
/***** Validacao do param-estoq.conta-trans *****/

/************************************************************ 
ESTA VALIDACAO JA ESTA SENDOR REALIZADA NA VIEWER (v07in287.w) 
*************************************************************/
/*
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT 'c-conta-trans').
  IF  return-value = '' then do:
      {utp/ut-field.i mgind param-estoq conta-transf 1}
      assign c-conta = return-value.
      RUN utp/ut-msgs.p (INPUT 'show', INPUT 158, INPUT c-conta).
      ASSIGN l-erro = yes.
      RETURN "ADM-ERROR".
      RUN pi-pagina6-ct-trans in h-window.
  END.
  ELSE DO:

     assign i-empresa = param-global.empresa-prin.

     &if defined (bf_dis_consiste_conta) &then

         find first estabelec where
              estabelec.cod-estabel = input frame {&frame-name} c-estabel-pad no-lock no-error.

         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
     &endif

      FIND FIRST conta-contab
          WHERE conta-contab.ep-codigo      = i-empresa
          and   conta-contab.conta-contabil = return-value no-lock no-error.
      IF  AVAIL conta-contab THEN DO:
          IF  conta-contab.estado <> 3 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 443, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-trans in h-window.
          END.
          IF  conta-contab.tipo = 6 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 444, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-trans in h-window.
          END.
          IF  conta-contab.estoque = 0 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 445, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-trans in h-window.
          END.
          IF  conta-contab.estoque = 9 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 446, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-trans in h-window.
          END.
      END.
  END.

  /***** Validacao do param-estoq.ct-acerto *****/
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT 'c-conta-acerto').
  IF  return-value = '' then do:
      {utp/ut-field.i mgind param-estoq conta-acerto 1}
      assign c-conta = return-value.
      RUN utp/ut-msgs.p (INPUT 'show', INPUT 158, INPUT c-conta).
      ASSIGN l-erro = yes.
      RETURN "ADM-ERROR".
      RUN pi-pagina6-ct-acerto in h-window.
  END.
  ELSE DO:

     assign i-empresa = param-global.empresa-prin.

     &if defined (bf_dis_consiste_conta) &then

         find first estabelec where
              estabelec.cod-estabel = input frame {&frame-name} c-estabel-pad no-lock no-error.

         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
     &endif

      FIND FIRST conta-contab
          WHERE conta-contab.ep-codigo      = i-empresa
          and   conta-contab.conta-contabil = return-value no-lock no-error.
      IF  AVAIL conta-contab THEN DO:
          IF  conta-contab.estado <> 3 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 443, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-acerto in h-window.
          END.
          IF  conta-contab.tipo = 6 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 444, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-acerto in h-window.
          END.
          IF  conta-contab.estoque = 0 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 445, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-acerto in h-window.
          END.
          IF  conta-contab.estoque = 9 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 446, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-acerto in h-window.
          END.
      END.
  END.

  /***** Validacao do param-estoq.ct-inven-ent *****/
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT 'c-conta-inven-ent').
  IF  return-value = '' then do:
      {utp/ut-field.i mgind param-estoq conta-inven-ent 1}
      assign c-conta = return-value.
      RUN utp/ut-msgs.p (INPUT 'show', INPUT 158, INPUT c-conta).
      ASSIGN l-erro = yes.
      RETURN "ADM-ERROR".
      RUN pi-pagina6-ct-inven-ent in h-window.
  END.
  ELSE DO:
      assign i-empresa = param-global.empresa-prin.

      &if defined (bf_dis_consiste_conta) &then

         find first estabelec where
              estabelec.cod-estabel = input frame {&frame-name} c-estabel-pad no-lock no-error.

          run cdp/cd9970.p (input rowid(estabelec),
                            output i-empresa).
      &endif  

      FIND FIRST conta-contab
          WHERE conta-contab.ep-codigo      = i-empresa
          and   conta-contab.conta-contabil = return-value no-lock no-error.
      IF  AVAIL conta-contab THEN DO:
          IF  conta-contab.estado <> 3 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 443, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-ent in h-window.
          END.
          IF  conta-contab.tipo = 6 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 444, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-ent in h-window.
          END.
          IF  conta-contab.estoque = 0 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 445, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-ent in h-window.
          END.
          IF  conta-contab.estoque = 9 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 446, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-ent in h-window.
          END.
      END.
  END.

  /***** Validacao do param-estoq.ct-inven-sai *****/
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT 'c-conta-inven-sai').
  IF  return-value = '' then do:
      {utp/ut-field.i mgind param-estoq conta-inven-sai 1}
      assign c-conta = return-value.
      RUN utp/ut-msgs.p (INPUT 'show', INPUT 158, INPUT c-conta).
      ASSIGN l-erro = yes.
      RETURN "ADM-ERROR".
      RUN pi-pagina6-ct-inven-sai in h-window.
  END.
  ELSE DO:

      assign i-empresa = param-global.empresa-prin.

      &if defined (bf_dis_consiste_conta) &then

         find first estabelec where
              estabelec.cod-estabel = input frame {&frame-name} c-estabel-pad no-lock no-error.

          run cdp/cd9970.p (input rowid(estabelec),
                            output i-empresa).
      &endif  

      FIND FIRST conta-contab
          WHERE conta-contab.ep-codigo      = i-empresa
          and   conta-contab.conta-contabil = return-value no-lock no-error.
      IF  AVAIL conta-contab THEN DO:
          IF  conta-contab.estado <> 3 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 443, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-sai in h-window.
          END.
          IF  conta-contab.tipo = 6 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 444, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-sai in h-window.
          END.
          IF  conta-contab.estoque = 0 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 445, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-sai in h-window.
          END.
          IF  conta-contab.estoque = 9 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 446, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-inven-sai in h-window.
          END.
      END.
  END.

  /** Validacao do param-estoq.ct-tr-mob **/
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT 'c-conta-mob').
  IF  return-value = '' then do:
      {utp/ut-field.i mgind param-estoq conta-mob 1}
      assign c-conta = return-value.
      RUN utp/ut-msgs.p (INPUT 'show', INPUT 158, INPUT c-conta).
      ASSIGN l-erro = yes.
      RETURN "ADM-ERROR".
      RUN pi-pagina6-ct-tr-mob in h-window.
  END.
  ELSE DO:

      assign i-empresa = param-global.empresa-prin.

      &if defined (bf_dis_consiste_conta) &then

         find first estabelec where
              estabelec.cod-estabel = input frame {&frame-name} c-estabel-pad no-lock no-error.

          run cdp/cd9970.p (input rowid(estabelec),
                            output i-empresa).
      &endif

      FIND FIRST conta-contab
          WHERE conta-contab.ep-codigo      = i-empresa
          and   conta-contab.conta-contabil = return-value no-lock no-error.
      IF  AVAIL conta-contab THEN DO:
          IF  conta-contab.estado <> 3 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 443, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-tr-mob in h-window.
          END.
          IF  conta-contab.tipo = 6 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 444, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-tr-mob in h-window.
          END.
          IF  conta-contab.estoque = 0 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 445, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-tr-mob in h-window.
          END.
          IF  conta-contab.estoque = 9 THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show', INPUT 446, INPUT '').
              ASSIGN l-erro = yes.
              RETURN "ADM-ERROR".
              RUN pi-pagina6-ct-tr-mob in h-window.
          END.
      END.
  END.
*/
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
  {src/adm/template/snd-list.i "param-estoq"}

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

