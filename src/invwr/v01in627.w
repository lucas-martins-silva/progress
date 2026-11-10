&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V01IN627 2.00.00.056 } /*** "010056" 10/08/2026 16:13:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in627 MUT}
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
/* ---------------------------------------------------------------------
   Campo usuar-mater.char-1
   posicao 1: Utilizacao material
           2 a 9: Lotacao
           10: Atualiza Requisicao
   --------------------------------------------------------------------- */

&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{include/i-vrtab.i usuar-mater}

def var c-lotacao-aux as char no-undo.
DEF VAR l-usuar-pregao-aux AS LOG NO-UNDO.
    {cdp/cd0669.i}  /** Utilizado para definiá∆o da tt-erro **/

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Número" column-label "Número"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia".

def var h_api_ccusto         as handle no-undo.

define var c-formato-ccusto as char no-undo.  
/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 

def var i-empresa like param-global.empresa-prin no-undo.

/* Vari†veis Integraá∆o ME*/
DEF VAR l-tg-integr-usuar-me        AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l-create-tg-integr-usuar-me AS LOGICAL INITIAL NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES usuar-mater
&Scoped-define FIRST-EXTERNAL-TABLE usuar-mater


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR usuar-mater.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS usuar-mater.usuar-comprador ~
usuar-mater.mo-codigo usuar-mater.usuar-aprovador usuar-mater.usuar-solic ~
usuar-mater.lim-solic usuar-mater.tp-preco usuar-mater.usuar-requis ~
usuar-mater.lim-requis usuar-mater.usuar-requis-manut ~
usuar-mater.lim-requis-manut usuar-mater.cod-grp-compra ~
usuar-mater.sc-codigo usuar-mater.perm-alt-cont usuar-mater.cont-acesso-cc 
&Scoped-define ENABLED-TABLES usuar-mater
&Scoped-define FIRST-ENABLED-TABLE usuar-mater
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-10 RECT-14 RECT-15 RECT-16 ~
RECT-2 RECT-6 RECT-7 tg-usuario-me TOGGLE-1 TOGGLE-2 l-usuar-pregao ~
l-permissao tg-preco-item-dd tg-oculta-valor tg-visualiza-narrativa ~
tg-compra-itens-predef 
&Scoped-Define DISPLAYED-FIELDS usuar-mater.usuar-comprador ~
usuar-mater.mo-codigo usuar-mater.usuar-aprovador usuar-mater.usuar-solic ~
usuar-mater.lim-solic usuar-mater.tp-preco usuar-mater.usuar-requis ~
usuar-mater.lim-requis usuar-mater.usuar-requis-manut ~
usuar-mater.lim-requis-manut usuar-mater.cod-grp-compra ~
usuar-mater.sc-codigo usuar-mater.perm-alt-cont usuar-mater.cont-acesso-cc 
&Scoped-define DISPLAYED-TABLES usuar-mater
&Scoped-define FIRST-DISPLAYED-TABLE usuar-mater
&Scoped-Define DISPLAYED-OBJECTS c-moeda-descr tg-usuario-me TOGGLE-1 ~
TOGGLE-2 l-usuar-pregao l-restric l-altera-conta l-altera-cc l-utilizacao ~
l-altera-req c-lotacao l-permissao tg-preco-item-dd tg-oculta-valor ~
tg-visualiza-narrativa tg-compra-itens-predef texto1 text10 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-lotacao 
&Scoped-define ADM-ASSIGN-FIELDS usuar-mater.usuar-comprador c-lotacao ~
usuar-mater.perm-alt-cont 
&Scoped-define ADM-MODIFY-FIELDS c-lotacao 

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
DEFINE VARIABLE c-lotacao AS CHARACTER FORMAT "X(20)":U 
     LABEL "Lotaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 20.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-descr AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88.

DEFINE VARIABLE text10 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.43 BY 4.6.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.72 BY 4.38.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 1.42.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.43 BY 2.8.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 2.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.43 BY 3.75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 4.38.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 3.25.

DEFINE VARIABLE l-altera-cc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-altera-conta AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-altera-req AS LOGICAL INITIAL no 
     LABEL "Altera Requisiá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-permissao AS LOGICAL INITIAL no 
     LABEL "Controle Permiss‰es Contrato" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE l-restric AS LOGICAL INITIAL no 
     LABEL "Fornec Restr Compras" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 TOOLTIP "Movimenta Fornecedor com Restriá∆o para Compras" NO-UNDO.

DEFINE VARIABLE l-usuar-pregao AS LOGICAL INITIAL no 
     LABEL "Usu†rio Preg∆o Eletrìnico" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .88 TOOLTIP "Usu†rio com permiss∆o para Preg∆o Eletrìnica" NO-UNDO.

DEFINE VARIABLE l-utilizacao AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-oculta-valor AS LOGICAL INITIAL no 
     LABEL "Oculta Valor da Solicitaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .71 NO-UNDO.

DEFINE VARIABLE tg-compra-itens-predef AS LOGICAL INITIAL no 
     LABEL "Compra itens prÇ-definidos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.
     
DEFINE VARIABLE tg-preco-item-dd AS LOGICAL INITIAL yes 
     LABEL "Sugerir Preáo Item DÇbito Direto" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

DEFINE VARIABLE tg-usuario-me AS LOGICAL INITIAL no 
     LABEL "Usu†rio ME" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.29 BY .5 TOOLTIP "Identifica se o Comprador ser† Usu†rio do ME" NO-UNDO.

DEFINE VARIABLE tg-visualiza-narrativa AS LOGICAL INITIAL no 
     LABEL "Visualiza Narrativa do Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 TOOLTIP "Visualizar Narrativa do Item" NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Usu†rio ME" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.29 BY .5 TOOLTIP "Identifica se o Aprovador Ç um Usu†rio do ME" NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL no 
     LABEL "Usu†rio ME" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.29 BY .5 TOOLTIP "Identifica se o Solicitante Ç um Usu†rio do ME" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     usuar-mater.usuar-comprador AT ROW 1.08 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .88
     usuar-mater.mo-codigo AT ROW 1.25 COL 41.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-moeda-descr AT ROW 1.25 COL 45.43 COLON-ALIGNED HELP
          "Descriá∆o da moeda" NO-LABEL
     tg-usuario-me AT ROW 1.29 COL 14.72
     usuar-mater.usuar-aprovador AT ROW 1.79 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .88
     TOGGLE-1 AT ROW 1.99 COL 14.72 WIDGET-ID 2
     usuar-mater.usuar-solic AT ROW 2.49 COL 2 //aqui
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .88
     TOGGLE-2 AT ROW 2.69 COL 14.72 WIDGET-ID 4
     usuar-mater.lim-solic AT ROW 3.08 COL 45.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     usuar-mater.tp-preco AT ROW 3.29 COL 69.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "MÇdio", 1,
                    "Base", 2,
                    "Reposiá∆o", 3,
                    "Èltima Entrada", 4
          SIZE 16 BY 3.5
     usuar-mater.usuar-requis AT ROW 3.22 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .88
     usuar-mater.lim-requis AT ROW 4.08 COL 45.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     usuar-mater.usuar-requis-manut AT ROW 3.92 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 19.57 BY .88
     usuar-mater.lim-requis-manut AT ROW 5.08 COL 45.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     l-usuar-pregao AT ROW 4.63 COL 2
     l-restric AT ROW 5.84 COL 2
     l-altera-conta AT ROW 6.53 COL 2
     usuar-mater.cod-grp-compra AT ROW 7.33 COL 45.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     l-altera-cc AT ROW 7.22 COL 2
     usuar-mater.sc-codigo AT ROW 8.33 COL 45.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.14 BY .88
     l-utilizacao AT ROW 7.87 COL 2
     l-altera-req AT ROW 8.54 COL 2
     c-lotacao AT ROW 9.33 COL 45.86 COLON-ALIGNED
     l-permissao AT ROW 10.1 COL 2
     tg-preco-item-dd AT ROW 10.67 COL 28.86 HELP
          "Sugerir Preáo Item DÇbito Direto"
     tg-oculta-valor AT ROW 10.67 COL 59
     usuar-mater.perm-alt-cont AT ROW 10.8 COL 2 HELP
          "Permite alterar contrato de outros"
          LABEL "Altera Contrato Outros"
          VIEW-AS TOGGLE-BOX
          SIZE 24.43 BY .83
     tg-visualiza-narrativa AT ROW 11.42 COL 28.86 HELP
          "Visualizar Narrativa do Item"
     tg-compra-itens-predef AT ROW 11.42 COL 59 HELP
          "Compra itens prÇ-definidos"
     usuar-mater.cont-acesso-cc AT ROW 11.50 COL 2 HELP
          "Controla o acesso por centro de custo"
          LABEL "Controle Contrato por CC"
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     texto1 AT ROW 2.46 COL 66.57 COLON-ALIGNED NO-LABEL
     text10 AT ROW 9.45 COL 2 NO-LABEL
     RECT-1 AT ROW 1 COL 1
     RECT-10 AT ROW 2.63 COL 68
     RECT-14 AT ROW 1 COL 28
     RECT-15 AT ROW 9.7 COL 1
     RECT-16 AT ROW 10.5 COL 28
     RECT-2 AT ROW 5.7 COL 1
     RECT-6 AT ROW 2.63 COL 28
     RECT-7 AT ROW 7.13 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.usuar-mater
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
         HEIGHT             = 14.5
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-lotacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-moeda-descr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX usuar-mater.cont-acesso-cc IN FRAME f-main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX l-altera-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-altera-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-altera-req IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-altera-req:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-restric IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-restric:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-utilizacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX usuar-mater.perm-alt-cont IN FRAME f-main
   2 EXP-LABEL EXP-HELP                                                 */
/* SETTINGS FOR FILL-IN text10 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN texto1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX usuar-mater.usuar-comprador IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME c-lotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lotacao V-table-Win
ON F5 OF c-lotacao IN FRAME f-main /* Lotaá∆o */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=inzoom/z01in042.w
                       &campo=c-lotacao
                       &campozoom=cc-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lotacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-lotacao IN FRAME f-main /* Lotaá∆o */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.cod-grp-compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.cod-grp-compra V-table-Win
ON F5 OF usuar-mater.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in455.w
                     &campo=usuar-mater.cod-grp-compra
                     &campozoom=cod-grp-compra}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.cod-grp-compra V-table-Win
ON MOUSE-SELECT-DBLCLICK OF usuar-mater.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.mo-codigo V-table-Win
ON F5 OF usuar-mater.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                     &campo=usuar-mater.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.mo-codigo V-table-Win
ON LEAVE OF usuar-mater.mo-codigo IN FRAME f-main /* Moeda */
DO:

  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao 
                   &variavel-ref=c-moeda-descr
                   &where="moeda.mo-codigo = input frame {&frame-name} usuar-mater.mo-codigo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF usuar-mater.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                     &campo=usuar-mater.mo-codigo
                     &campozoom=mo-codigo}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.sc-codigo V-table-Win
ON F5 OF usuar-mater.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
   assign l-implanta = yes.

   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   IF v_titulo_ccusto <> "" THEN
       ASSIGN usuar-mater.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
   ELSE
       ASSIGN usuar-mater.sc-codigo:SCREEN-VALUE = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.sc-codigo V-table-Win
ON LEAVE OF usuar-mater.sc-codigo IN FRAME f-main /* Centro Custo */
DO:

    {cdp/cd9998.i}

    /**  Funá∆o retirada pois as informaá‰es para centro de custo e lotaÁ„o s∆o de tabelas diferentes
    ***
    if c-lotacao:screen-value in frame {&frame-name} = "" then do:
        assign c-lotacao = input frame {&frame-name} usuar-mater.sc-codigo.
        display c-lotacao with frame {&frame-name}.
    end.        
    **/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF usuar-mater.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tg-usuario-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-usuario-me V-table-Win
ON VALUE-CHANGED OF tg-usuario-me IN FRAME f-main /* Usu·rio ME */
DO:     
    IF tg-usuario-me:CHECKED in frame {&frame-name} = YES THEN DO:
        ASSIGN l-tg-integr-usuar-me = YES.    
    END.
    ELSE DO:
        ASSIGN l-tg-integr-usuar-me = NO.    
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.usuar-aprovador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.usuar-aprovador V-table-Win
ON VALUE-CHANGED OF usuar-mater.usuar-aprovador IN FRAME f-main /* Aprovador */
DO:

    RUN pi-trata-habilitacao-me-aprovador.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.usuar-comprador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.usuar-comprador V-table-Win
ON VALUE-CHANGED OF usuar-mater.usuar-comprador IN FRAME f-main /* Comprador */
DO: 

    &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
        ASSIGN l-restric:SENSITIVE IN FRAME {&FRAME-NAME} =
               INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-comprador.

        IF INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-comprador = NO THEN
            ASSIGN l-restric:CHECKED IN FRAME {&FRAME-NAME} = NO.
    &ENDIF  

    RUN pi-trata-habilitacao-me-comprador.

    IF AVAIL param-compra AND param-compra.int-2 = 1 THEN
        ASSIGN usuar-mater.cod-grp-compra:SENSITIVE IN FRAME {&FRAME-NAME} =
               INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-comprador.
    ELSE
        ASSIGN usuar-mater.cod-grp-compra:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME usuar-mater.usuar-requis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.usuar-requis V-table-Win
ON VALUE-CHANGED OF usuar-mater.usuar-requis IN FRAME f-main /* Requisitante */
DO:

  if usuar-mater.usuar-requis:checked in frame {&frame-name} = yes 
  then 
    assign usuar-mater.lim-requis:sensitive in frame {&frame-name} = yes.
  else 
    assign usuar-mater.lim-requis:sensitive in frame {&frame-name} = no.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.usuar-requis-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.usuar-requis-manut V-table-Win
ON VALUE-CHANGED OF usuar-mater.usuar-requis-manut IN FRAME f-main /* Requis Manut */
DO:
  if usuar-mater.usuar-requis-manut:checked in frame {&frame-name} = yes 
  then 
      assign usuar-mater.lim-requis-manut:sensitive in frame {&frame-name} = yes.

  else 
      assign usuar-mater.lim-requis-manut:sensitive in frame {&frame-name} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.usuar-solic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.usuar-solic V-table-Win
ON VALUE-CHANGED OF usuar-mater.usuar-solic IN FRAME f-main /* Solicitante */
DO:
    IF INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-solic = YES THEN
        ASSIGN usuar-mater.lim-solic:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN usuar-mater.lim-solic:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    RUN pi-trata-habilitacao-me-solicitante.

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

if usuar-mater.mo-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if usuar-mater.cod-grp-compra:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if usuar-mater.sc-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if c-lotacao:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Altera_Requisiá∆o * l}
assign l-altera-req:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Altera_Conta * l}
assign l-altera-conta:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Altera_Centro_Custo * l}
assign l-altera-cc:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Utilizaá‰es_Material * l}
assign l-utilizacao:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Lotaá∆o * r}
assign c-lotacao:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Controle_Permiss‰es_Contrato * l}
assign l-permissao:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Sugere_Preáo_Item_DÇbito_Direto * l}
assign tg-preco-item-dd:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Visualiza_Narrativa_do_Item * l}
assign tg-visualiza-narrativa:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Compra_itens_prÇ-definidos * l}
assign tg-compra-itens-predef:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Usu†rio_Preg∆o_Eletrìnico * l}
ASSIGN l-usuar-pregao:LABEL IN FRAME {&FRAME-NAME} =  TRIM(RETURN-VALUE).

{utp/ut-liter.i Oculta_Valor_da_Solicitaá∆o * l}
assign tg-oculta-valor:label in frame {&frame-name} = trim(return-value).

find first param-global no-lock no-error.

FUNCTION fn-funcao-me-ativa RETURNS LOGICAL ():
    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U
           AND funcao.ativo     = YES NO-ERROR.
    RETURN AVAIL funcao.
END FUNCTION.

FUNCTION fn-aprovador-existe RETURNS LOGICAL
    ( INPUT pc-cod-usuario AS CHARACTER ):

    RETURN CAN-FIND(FIRST aprovador
                    WHERE aprovador.cod-aprov = pc-cod-usuario).
END FUNCTION.

FUNCTION fn-requisitante-existe RETURNS LOGICAL
    ( INPUT pc-cod-usuario AS CHARACTER ):

    RETURN CAN-FIND(FIRST requisitante
                    WHERE requisitante.nome-abrev = pc-cod-usuario).
END FUNCTION.

FUNCTION fn-aprovador-flag-me RETURNS LOGICAL
    ( INPUT pc-cod-usuario AS CHARACTER ):

    FIND FIRST aprovador NO-LOCK
         WHERE aprovador.cod-aprov = pc-cod-usuario NO-ERROR.

    IF AVAIL aprovador THEN
        RETURN SUBSTRING(aprovador.char-2,1,1) = "Y":U.

    RETURN NO.
END FUNCTION.

FUNCTION fn-requisitante-flag-me RETURNS LOGICAL
    ( INPUT pc-cod-usuario AS CHARACTER ):

    FIND FIRST requisitante NO-LOCK
         WHERE requisitante.nome-abrev = pc-cod-usuario NO-ERROR.

    IF AVAIL requisitante THEN
        RETURN requisitante.log-1.

    RETURN NO.
END FUNCTION.

PROCEDURE pi-grava-flag-me-rel:
    DEFINE VARIABLE c-char-2 AS CHARACTER NO-UNDO.

    FOR FIRST aprovador EXCLUSIVE-LOCK
        WHERE aprovador.cod-aprov = usuar-mater.cod-usuario:

        c-char-2 = aprovador.char-2.
        IF c-char-2 = ? THEN
            c-char-2 = "":U.

        c-char-2 = c-char-2 + FILL(" ":U,100).

        SUBSTRING(c-char-2,1,1) =
            IF usuar-mater.usuar-aprovador:CHECKED IN FRAME {&FRAME-NAME}
               AND INPUT FRAME {&FRAME-NAME} TOGGLE-1
            THEN "Y":U
            ELSE " ":U.

        ASSIGN aprovador.char-2 = SUBSTRING(c-char-2,1,100).
    END.

    FOR FIRST requisitante EXCLUSIVE-LOCK
        WHERE requisitante.nome-abrev = usuar-mater.cod-usuario:

        ASSIGN requisitante.log-1 =
               (usuar-mater.usuar-solic:CHECKED IN FRAME {&FRAME-NAME}
                AND INPUT FRAME {&FRAME-NAME} TOGGLE-2).
    END.
END PROCEDURE.

PROCEDURE pi-trata-habilitacao-me-comprador:
    DEFINE VARIABLE l-habilita AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN l-habilita =
               fn-funcao-me-ativa()
           AND NOT l-create-tg-integr-usuar-me
           AND INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-comprador
           AND CAN-FIND(FIRST comprador
                        WHERE comprador.cod-comprado = usuar-mater.cod-usuario).

        ASSIGN tg-usuario-me:SENSITIVE = l-habilita.

        IF NOT l-habilita THEN
            ASSIGN tg-usuario-me:CHECKED = NO
                   l-tg-integr-usuar-me  = NO.
        ELSE
            ASSIGN l-tg-integr-usuar-me = tg-usuario-me:CHECKED.
    END.
END PROCEDURE.

PROCEDURE pi-trata-habilitacao-me-aprovador:
    DEFINE VARIABLE l-habilita AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        /*
           N∆o validar a existància na tabela aprovador neste ponto.

           Motivo:
           - O TOGGLE-1 representa a flag "Usu†rio ME" ao lado de Aprovador.
           - A habilitaá∆o visual deve obedecer ao campo usuar-mater.usuar-aprovador.
           - Em alguns fluxos, principalmente alteraá∆o/duplicaá∆o/inclus∆o,
             o registro relacionado em aprovador pode ainda n∆o estar dispon°vel
             no momento da habilitaá∆o da tela.
           - A gravaá∆o continua sendo feita depois do assign-record, na
             procedure pi-grava-flag-me-rel.
        */
        ASSIGN l-habilita =
               fn-funcao-me-ativa()
           AND NOT l-create-tg-integr-usuar-me
           AND INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-aprovador.

        ASSIGN TOGGLE-1:SENSITIVE = l-habilita.

        IF NOT l-habilita THEN
            ASSIGN TOGGLE-1:CHECKED = NO.
    END.
END PROCEDURE.

PROCEDURE pi-trata-habilitacao-me-solicitante:
    DEFINE VARIABLE l-habilita AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN l-habilita =
               fn-funcao-me-ativa()
           AND NOT l-create-tg-integr-usuar-me
           AND INPUT FRAME {&FRAME-NAME} usuar-mater.usuar-solic
           AND fn-requisitante-existe(usuar-mater.cod-usuario).

        ASSIGN TOGGLE-2:SENSITIVE = l-habilita.

        IF NOT l-habilita THEN
            ASSIGN TOGGLE-2:CHECKED = NO.
    END.
END PROCEDURE.

PROCEDURE pi-trata-habilitacao-usuario-me:

    RUN pi-trata-habilitacao-me-comprador.
    RUN pi-trata-habilitacao-me-aprovador.
    RUN pi-trata-habilitacao-me-solicitante.

END PROCEDURE.

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
  {src/adm/template/row-list.i "usuar-mater"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "usuar-mater"}

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
  
  /* Vari†veis Integraá∆o ME */
  ASSIGN l-create-tg-integr-usuar-me = NO
         l-tg-integr-usuar-me        = NO
         tg-usuario-me:CHECKED IN FRAME {&FRAME-NAME} = NO
         TOGGLE-1:CHECKED     IN FRAME {&FRAME-NAME} = NO
         TOGGLE-2:CHECKED     IN FRAME {&FRAME-NAME} = NO.

  DISABLE tg-usuario-me TOGGLE-1 TOGGLE-2 WITH FRAME {&FRAME-NAME}.

  {utp/ut-rtlbl.i mgind requisitante tp-preco texto1}

   {utp/ut-liter.i Seguranáa_Contratos * l}
   assign text10:screen-value in frame {&frame-name} = trim(return-value).

   assign l-altera-conta:checked in frame {&frame-name} = no
          l-altera-cc:checked in frame {&frame-name}    = no
          l-utilizacao:checked in frame {&frame-name}   = no.

   assign usuar-mater.cont-acesso-cc:checked in frame {&frame-name} = no
          usuar-mater.perm-alt-cont:checked in frame {&frame-name}  = no.

   enable l-altera-conta
          l-altera-cc
          l-utilizacao with frame {&frame-name}.      

   &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
       ASSIGN l-restric:HIDDEN IN FRAME {&FRAME-NAME} = NO.
   &ENDIF 
                              
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &then              
            ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = NO.    

            IF param-compra.log-param-pregao-eletron THEN
                ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE
                ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then
            ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = NO.    

            IF substring(param-compra.char-2,22,1) = "1" THEN
                ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE
                ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        &else
            ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = YES.    
        &endif
    END.

    /* Atualiza a habilitaá∆o das flags Usu†rio ME ao entrar em manutená∆o/alteraá∆o */
    IF AVAIL usuar-mater THEN
        RUN pi-trata-habilitacao-usuario-me.

    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE vc-lbl-texto          AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE vc-lbl-ajuda          AS CHARACTER                 NO-UNDO.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    IF AVAIL param-compra THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &then    
            IF param-compra.log-param-pregao-eletron THEN
                ASSIGN l-usuar-pregao-aux = INPUT FRAME {&frame-name} l-usuar-pregao.
        &ELSE
            IF SUBSTRING(param-compra.char-2,22,1) = "1" THEN
                ASSIGN l-usuar-pregao-aux = INPUT FRAME {&frame-name} l-usuar-pregao.
        &endif
    END.

    if  usuar-mater.usuar-aprovador:checked    in frame {&frame-name} = no and
        usuar-mater.usuar-comprador:checked    in frame {&frame-name} = no and
        usuar-mater.usuar-requis:checked       in frame {&frame-name} = no and
        usuar-mater.usuar-solic:checked        in frame {&frame-name} = no AND
        usuar-mater.usuar-requis-manut:CHECKED IN FRAME {&FRAME-NAME} = NO then do:
            
        /**  Usu†rio dever† ser aprovador, comprador, requisitante ou solicitante. **/
        run utp/ut-msgs.p (input "show",
                           input 17609,
                           input "").
        apply "entry" to usuar-mater.usuar-comprador in frame {&frame-name}.
        return "adm-error".                    
    end.
        
    IF l-tg-integr-usuar-me = YES THEN DO:
        FOR FIRST comprador WHERE comprador.cod-comprado = usuar-mater.cod-usuario EXCLUSIVE-LOCK:
            ASSIGN comprador.comprador-me = YES.
        END. 
    END.
    ELSE DO:
        FOR FIRST comprador WHERE comprador.cod-comprado = usuar-mater.cod-usuario EXCLUSIVE-LOCK:
            ASSIGN comprador.comprador-me = NO.
        END. 
    END.
    
    if not adm-new-record and
        usuar-mater.usuar-aprovador:checked in frame {&frame-name} = no then do:
        for each tt-erro:
            delete tt-erro.
        end.
        /**  Verifica relacionamentos com o aprovador
        **/
        RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "cod-usuario").

        run cdp/cdapi175.p (input return-value ,
                            input 2 ,
                            output table tt-erro).
        find first tt-erro
            no-lock no-error.
        if available tt-erro then do:
            run cdp/cd0669.w (input table tt-erro).        
            apply "entry" to usuar-mater.usuar-aprovador in frame {&frame-name}.
            return "adm-error".                                
        end.        
    end.

    find centro-custo WHERE centro-custo.cc-codigo = input frame {&frame-name} c-lotacao
                      no-lock no-error.
    if not available centro-custo then do:    
        IF input frame {&frame-name} c-lotacao = "" THEN DO:
            {utp/ut-liter.i "Lotaá∆o_n∆o_informada." *}
            ASSIGN vc-lbl-texto = TRIM(RETURN-VALUE).
            
            FIND FIRST funcao WHERE funcao.cd-funcao = "Integra_MLA_EMS":U 
                              AND   funcao.ativo
                              NO-LOCK NO-ERROR. 
            IF AVAIL funcao THEN
                {utp/ut-liter.i "Para_informar_a_lotaá∆o_para_o_usu†rio_aprovador_do_MLA_utilize_a_rotina:_MLA0103." *}
            ELSE
                {utp/ut-liter.i "O_campo_lotaá∆o_n∆o_foi_informado._Verifique_a_parametrizaá∆o." *}

            ASSIGN vc-lbl-ajuda = TRIM(RETURN-VALUE).
            
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT  15825,
                               INPUT vc-lbl-texto + "~~" + vc-lbl-ajuda).
        END.
        ELSE DO:
            {utp/ut-liter.i Lotaá∆o * r}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input Trim(return-value)).
            apply "entry" to c-lotacao in frame {&frame-name}.
            return "adm-error".
        END.
    end.

    find moeda where 
        moeda.mo-codigo = input frame {&frame-name} usuar-mater.mo-codigo 
        no-lock no-error.
    if not avail moeda then do:
        {utp/ut-table.i mguni moeda 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply "entry" to usuar-mater.mo-codigo in frame {&frame-name}.
        return "adm-error".                    
    end.

    if input frame {&frame-name} usuar-mater.usuar-comprador and 
        avail param-compra and param-compra.int-2 = 1 then do:
        find grupo-compra where 
            grupo-compra.cod-grp-compra = input frame {&frame-name} usuar-mater.cod-grp-compra 
            no-lock no-error.
        if not avail grupo-compra then do:
            {utp/ut-table.i mgind grupo-compra 1}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value).
            apply "entry" to usuar-mater.cod-grp-compra in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.
    else assign usuar-mater.cod-grp-compra:screen-value in frame {&frame-name} = "".  

    /* Nova validaÁ„o do centro de custo */
    assign usuar-mater.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_ccusto = input frame {&frame-name} usuar-mater.sc-codigo.
    assign usuar-mater.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
    
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
                                               
    if v_titulo_ccusto = "" then do:                                           
        {utp/ut-field.i mgind usuar-mater sc-codigo 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply "entry" to usuar-mater.sc-codigo in frame {&frame-name}.
        return "adm-error".                                            
    END.   

    if adm-new-record = no then 
    if usuar-mater.usuar-requis:checked in frame {&frame-name} = no then do:
        find first usuar-ccusto where                    
            usuar-ccusto.cod-usuario = usuar-mater.cod-usuario 
            no-lock no-error.
        if available usuar-ccusto then do:
            run utp/ut-msgs.p (input "show", input 16004, input "").
            if return-value = "yes" then do:
                for each usuar-ccusto where 
                    usuar-ccusto.cod-usuario = usuar-mater.cod-usuario exclusive-lock:
                    delete usuar-ccusto.
                end.  
            end.   
            if return-value = "no" then do: 
                assign usuar-mater.usuar-requis:checked in frame {&frame-name} = yes.  
                apply "entry" to usuar-mater.usuar-requis in frame {&frame-name}.
                return "adm-error".
            end. 
        end.  
    end.  

    assign l-altera-conta 
           l-altera-cc    
           l-utilizacao
           l-altera-req
           c-lotacao-aux = input frame {&frame-name} c-lotacao
           l-permissao
           &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
           l-restric
           &ENDIF
           tg-preco-item-dd
           tg-visualiza-narrativa
           tg-oculta-valor
	   tg-compra-itens-predef. 

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if RETURN-VALUE = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.
       
    RUN pi-grava-flag-me-rel.

    if avail usuar-mater then do:
        if usuar-mater.usuar-solic:checked in frame {&frame-name} = no 
            then assign usuar-mater.lim-solic = 0.
        if usuar-mater.usuar-requis:checked in frame {&frame-name} = no 
            then assign usuar-mater.lim-requis = 0.
        if usuar-mater.usuar-requis-manut:checked in frame {&frame-name} = no 
            then assign usuar-mater.lim-requis-manut = 0.
    end.

    disp usuar-mater.lim-requis 
         usuar-mater.lim-requis-manut 
         usuar-mater.lim-solic with frame {&frame-name}.

    assign usuar-mater.log-1 = l-altera-conta
           usuar-mater.log-2 = l-altera-cc

           &if defined (bf_mat_versao_ems) &then
               &if '{&bf_mat_versao_ems}' < '2.06' &then
                   substring(usuar-mater.char-1,11,01) = if l-permissao
                                                        then "Y"
                                                        else "N"
               &else
                   usuar-mater.log-control-permis = l-permissao
               &endif
               &if '{&bf_mat_versao_ems}' >= '2.062' &then
                   usuar-mater.log-suger-preco-item-db-diret = tg-preco-item-dd:checked in frame {&frame-name}
               &else
                   overlay(usuar-mater.char-1,12,1) = if tg-preco-item-dd:checked in frame {&frame-name} then "S" else "N"
               &endif
           &endif

           substring(usuar-mater.char-1,01,01) = if l-utilizacao
                                                 then "Y"
                                                 else "N"
           &if defined(bf_mat_aprova_eletronica) &then
               substring(usuar-mater.char-1,10,01) = if l-altera-req
                                                 then "Y"
                                                 else "N"
           &endif 
           overlay(usuar-mater.char-1,15,1) = IF tg-visualiza-narrativa:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
           overlay(usuar-mater.char-1,21,1) = IF tg-oculta-valor:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
           overlay(usuar-mater.char-1,22,1) = IF tg-compra-itens-predef:CHECKED IN FRAME {&FRAME-NAME} THEN "Y":U ELSE "N":U.

    /* assign substring(usuar-mater.char-1,2,8) = string(c-lotacao-aux,"X(8)"). */
    assign usuar-mater.cod-lotacao = c-lotacao-aux.

    if  input frame {&frame-name} usuar-mater.usuar-comprador and 
        avail param-compra and param-compra.int-2 = 1         and
        input frame {&frame-name} usuar-mater.cod-grp-compra <> "" then do:
        find gr-cmp-comprad where gr-cmp-comprad.cod-comprado = usuar-mater.cod-usuario and
                                  gr-cmp-comprad.cod-grp-compra = input frame {&frame-name} usuar-mater.cod-grp-compra no-lock no-error.
        if  not avail gr-cmp-comprad then do:  
            create gr-cmp-comprad.
            assign gr-cmp-comprad.cod-comprado   = usuar-mater.cod-usuario
                   gr-cmp-comprad.cod-grp-compra = input frame {&frame-name} usuar-mater.cod-grp-compra.
        end.
    end.

    assign  usuar-mater.perm-alt-cont = input frame {&frame-name} usuar-mater.perm-alt-cont.

    &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN 
        usuar-mater.log-movto-fornec-restric = input frame {&frame-name} l-restric.
    &ENDIF    
    
    IF AVAIL usuar-mater THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &then              
            ASSIGN usuar-mater.log-usuar-pregao = l-usuar-pregao-aux.
        &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then 
            IF l-usuar-pregao-aux THEN DO:
                ASSIGN substring(usuar-mater.char-1,13,1) = "1".
            END.
            ELSE DO:
                ASSIGN substring(usuar-mater.char-1,13,1) = "0".
            END.
        &endif
    END.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui    */  
    /* Code placed here will execute AFTER standard behavior.                   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-usuario AS CHARACTER NO-UNDO.

    /* Guarda o usu†rio antes do delete padr∆o */
    IF AVAIL usuar-mater THEN
        ASSIGN c-cod-usuario = usuar-mater.cod-usuario.

    /* Dispatch standard ADM method. */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.


    IF c-cod-usuario <> "":U THEN
        RUN pi-limpa-flag-me-rel (INPUT c-cod-usuario).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto. 

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
  &endif.

  assign usuar-mater.lim-solic:sensitive in frame {&frame-name}        = no
         usuar-mater.lim-requis:sensitive in frame {&frame-name}       = no
         usuar-mater.lim-requis-manut:sensitive in frame {&frame-name} = no
         l-altera-conta:sensitive in frame {&frame-name}               = no
         l-altera-cc:sensitive in frame {&frame-name}                  = no
         l-utilizacao:sensitive in frame {&frame-name}                 = no
         l-altera-req:sensitive in frame {&frame-name}                 = no
         &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
               l-restric:SENSITIVE IN FRAME {&FRAME-NAME}              = NO
         &ENDIF  
         l-permissao:sensitive in frame {&frame-name}                  = no
         tg-preco-item-dd:sensitive in frame {&frame-name}             = NO
         tg-visualiza-narrativa:SENSITIVE IN FRAME {&FRAME-NAME}       = NO
         tg-oculta-valor:SENSITIVE IN FRAME {&FRAME-NAME}              = NO
         tg-compra-itens-predef:SENSITIVE IN FRAME {&FRAME-NAME}       = NO
         tg-usuario-me:SENSITIVE IN FRAME {&FRAME-NAME}                = NO
         TOGGLE-1:SENSITIVE IN FRAME {&FRAME-NAME}                     = NO
         TOGGLE-2:SENSITIVE IN FRAME {&FRAME-NAME}                     = NO.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  if avail usuar-mater then do with frame {&frame-name}:
  
    IF NOT CAN-FIND (FIRST comprador WHERE comprador.cod-comprado = usuar-mater.cod-usuario AND comprador.comprador-me = YES) THEN DO:
       ASSIGN tg-usuario-me:CHECKED IN FRAME {&frame-name} = NO.
    END.
    ELSE DO:
       ASSIGN tg-usuario-me:CHECKED IN FRAME {&frame-name} = YES.
    END.
    
    ASSIGN l-tg-integr-usuar-me = tg-usuario-me:CHECKED IN FRAME {&FRAME-NAME}
           TOGGLE-1:CHECKED     IN FRAME {&FRAME-NAME} = fn-aprovador-flag-me(usuar-mater.cod-usuario)
           TOGGLE-2:CHECKED     IN FRAME {&FRAME-NAME} = fn-requisitante-flag-me(usuar-mater.cod-usuario).
      
      find moeda where moeda.mo-codigo = usuar-mater.mo-codigo no-lock no-error.
      assign c-moeda-descr = if avail moeda then moeda.descricao else "".
      assign l-altera-conta:checked = usuar-mater.log-1
             l-altera-cc:checked    = usuar-mater.log-2
             l-utilizacao:checked   = if substring(usuar-mater.char-1,01,01) = "y" 
                                      then yes
                                      else no

             &if defined (bf_mat_versao_ems) &then
                 &if '{&bf_mat_versao_ems}' < '2.06' &then
                     l-permissao:checked = if substring(usuar-mater.char-1,11,01) = "y" 
                                              then yes
                                              else no
                 &else
                     l-permissao:checked = usuar-mater.log-control-permis
                 &endif
                 
             &endif

             l-altera-req:checked   = if substring(usuar-mater.char-1,10,01) = "y" 
                                      then yes
                                      else no.
             IF NOT adm-new-record THEN DO:
                &if defined (bf_mat_versao_ems) &then
                     &if '{&bf_mat_versao_ems}' >= '2.062' &then
                        ASSIGN tg-preco-item-dd:checked in frame {&frame-name} = usuar-mater.log-suger-preco-item-db-diret.
                     &else
                        ASSIGN tg-preco-item-dd:checked in frame {&frame-name} = if substring(usuar-mater.char-1,12,1) = "N" then no else YES.
                     &endif
                &ENDIF
                &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
                    ASSIGN l-restric = usuar-mater.log-movto-fornec-restric.
                    DISPLAY l-restric WITH FRAME {&FRAME-NAME}.
                    ASSIGN l-restric:HIDDEN IN FRAME {&FRAME-NAME} = NO.
                &ENDIF 
                ASSIGN tg-visualiza-narrativa:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(usuar-mater.char-1,15,1) = "S" THEN YES ELSE NO
                       tg-oculta-valor:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(usuar-mater.char-1,21,1) = "S":U THEN YES ELSE NO
                       tg-compra-itens-predef:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(usuar-mater.char-1,22,1) = "Y":U THEN YES ELSE NO.
             END.

       display usuar-mater.cod-lotacao @ c-lotacao 
              c-moeda-descr. 

  &if "{&bf_mat_versao_ems}" >= "2.07" &THEN
      ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME}    = NO
             l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             l-usuar-pregao:CHECKED IN FRAME {&FRAME-NAME}   = usuar-mater.log-usuar-pregao.
  &elseif "{&bf_mat_versao_ems}" >= "2.062" &THEN
      ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME}    = NO
             l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      IF substring(usuar-mater.char-1,13,1) = "1" THEN
          ASSIGN l-usuar-pregao:CHECKED IN FRAME {&FRAME-NAME} = YES.
      ELSE
          ASSIGN l-usuar-pregao:CHECKED IN FRAME {&FRAME-NAME} = NO.
  &else
      ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME}    = YES
             l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
  &endif
  END.
  
  {utp/ut-rtlbl.i mgind requisitante tp-preco texto1}

  {utp/ut-liter.i Seguranáa_Contratos * l}
  assign text10:screen-value in frame {&frame-name} = trim(return-value).

  /* Code placed here will execute AFTER standard behavior.    */

  /* Handle da API Centro Custo */
  run prgint/utb/utb742za.py persistent set h_api_ccusto.
  
  /*  */
  /* Passando empresa em branco assim a API de financas busca a empresa do usuario corrente */
  assign i-empresa = "". 

  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */ 
  
  if c-formato-ccusto <> "" then
      ASSIGN usuar-mater.sc-codigo:format in frame {&frame-name} = c-formato-ccusto.

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Vari†veis Integraá∆o ME */
  ASSIGN l-create-tg-integr-usuar-me = NO.
    
  /* Code placed here will execute AFTER standard behavior.    */

  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif.

if adm-new-record = yes then 
  disable usuar-mater.lim-solic
          usuar-mater.lim-requis
          usuar-mater.lim-requis-manut
          usuar-mater.cod-grp-compra 
          with frame {&frame-name}.

if avail usuar-mater then do:
     if adm-new-record = no then do:
         if  usuar-mater.usuar-solic:checked in frame {&frame-name} = yes then 
            enable usuar-mater.lim-solic with frame {&frame-name}.
         else disable usuar-mater.lim-solic with frame {&frame-name}.    

         if  usuar-mater.usuar-requis:checked in frame {&frame-name} = yes then 
             enable usuar-mater.lim-requis with frame {&frame-name}.
         else disable usuar-mater.lim-requis with frame {&frame-name}.

         if  usuar-mater.usuar-requis-manut:checked in frame {&frame-name} = yes then 
             enable usuar-mater.lim-requis-manut with frame {&frame-name}.
         else disable usuar-mater.lim-requis-manut with frame {&frame-name}.

         if  usuar-mater.usuar-comprador:checked in frame {&frame-name} = yes then do:
                  
              
             if avail param-compra and param-compra.int-2 = 1 then
                 enable usuar-mater.cod-grp-compra with frame {&frame-name}.
             else    
                 disable usuar-mater.cod-grp-compra with frame {&frame-name}.
         end.     
         else 
             disable usuar-mater.cod-grp-compra with frame {&frame-name}.
     end. 
end.
else
  disable usuar-mater.lim-solic
          usuar-mater.lim-requis
          usuar-mater.lim-requis-manut 
          usuar-mater.cod-grp-compra with frame {&frame-name}.

enable l-altera-conta
       l-altera-cc
       &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
           l-restric
       &ENDIF   
       l-utilizacao with frame {&frame-name}.        

&if defined(bf_mat_aprova_eletronica) &then
    enable l-altera-req with frame {&frame-name}.        
&endif

enable l-permissao
    usuar-mater.cont-acesso-cc
    usuar-mater.perm-alt-cont
    tg-preco-item-dd
    tg-visualiza-narrativa
    tg-oculta-valor
    tg-compra-itens-predef
    with frame {&frame-name}.

FIND FIRST param-compra NO-LOCK NO-ERROR.
IF AVAIL param-compra THEN DO:
    &IF "{&bf_mat_versao_ems}" >= "2.07" &then              
        ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = NO.    

        IF param-compra.log-param-pregao-eletron THEN
            ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = NO.    

        IF substring(param-compra.char-2,22,1) = "1" THEN
            ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN l-usuar-pregao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &else
        ASSIGN l-usuar-pregao:HIDDEN IN FRAME {&FRAME-NAME} = YES.    
    &endif
END.

ASSIGN l-create-tg-integr-usuar-me = NO.

IF AVAIL usuar-mater THEN
    RUN pi-trata-habilitacao-usuario-me.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      ASSIGN l-restric:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ENDIF

  &if defined(bf_mat_aprova_eletronica) &then
    assign l-altera-req:hidden in frame {&frame-name} = no.
  &endif

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-rtlbl.i mgind requisitante tp-preco texto1}

  {utp/ut-liter.i Seguranáa_Contratos * l}
  assign text10 = trim(return-value).

  find first param-compra no-lock no-error.

  disable l-permissao tg-preco-item-dd tg-visualiza-narrativa tg-oculta-valor tg-compra-itens-predef tg-usuario-me TOGGLE-1 TOGGLE-2 with frame {&frame-name}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if avail usuar-mater then 
   assign gr-usuar-mater = rowid(usuar-mater).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.

     assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/



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
  {src/adm/template/snd-list.i "usuar-mater"}

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

PROCEDURE pi-limpa-flag-me-rel:
    DEFINE INPUT PARAMETER pc-cod-usuario AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-char-2 AS CHARACTER NO-UNDO.

    /* Comprador - limpa flag ME */
    FOR FIRST comprador EXCLUSIVE-LOCK
        WHERE comprador.cod-comprado = pc-cod-usuario:

        ASSIGN comprador.comprador-me = NO.
    END.

    /* Aprovador - limpa posiá∆o 1 do char-2 */
    FOR FIRST aprovador EXCLUSIVE-LOCK
        WHERE aprovador.cod-aprov = pc-cod-usuario:

        ASSIGN c-char-2 = aprovador.char-2.

        IF c-char-2 = ? THEN
            ASSIGN c-char-2 = "":U.

        ASSIGN c-char-2 = c-char-2 + FILL(" ":U,100).

        ASSIGN SUBSTRING(c-char-2,1,1) = " ":U
               aprovador.char-2        = SUBSTRING(c-char-2,1,100).
    END.

    /* Solicitante - limpa flag ME */
    FOR FIRST requisitante EXCLUSIVE-LOCK
        WHERE requisitante.nome-abrev = pc-cod-usuario:

        ASSIGN requisitante.log-1 = NO.
    END.
END PROCEDURE.

