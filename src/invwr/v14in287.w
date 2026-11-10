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
{include/i-prgvrs.i V14IN287 2.00.00.081 } /*** "010081" 11/09/2026 11:20:17 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v14in287 MUT}
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* Local Variable Definitions ---                                       */
{cdp/cd4300.i3}  /*Vari˜veis para o cd4300.i4 */
{cdp/cd0101.i50} /*Vari˜veis para o re1001b.i51*/
{cdp/cdunif001.i} /* Vari veis da unifica‡Æo de conceito Conta Cont bil e Centro de Custo */
def var c-empresa   like param-global.empresa-prin no-undo.
def var c-estabelec like param-estoq.estabel-pad   no-undo.

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-18 rt-key RECT-19 i-gera-ap ~
l-integra-wms l-usa-rga l-utiliza-serie tg-usa-dt-trans-fasb tg-ctbz-gfe ~
c-serie-padrao tg-l-mult-nat-receb fi-vlr-min-detracao tg-validacao-conta ~
tg-l-imp-ret-dupli tg-remito-outra-moeda tg-considera-desp tg-considera-imp ~
tg-var-camb c-item-dif-total-nota c-ct-dif-total-nota c-sc-dif-total-nota 
&Scoped-Define DISPLAYED-OBJECTS i-gera-ap l-integra-wms l-usa-rga ~
l-utiliza-serie l-rec-fisico tg-usa-dt-trans-fasb tg-ctbz-gfe ~
l-dif-contagem c-serie-padrao tg-l-mult-nat-receb fi-vlr-min-detracao ~
tg-validacao-conta tg-l-imp-ret-dupli tg-remito-outra-moeda ~
tg-considera-desp tg-considera-imp tg-var-camb c-item-dif-total-nota ~
c-des-item-dif-total-nota c-ct-dif-total-nota c-des-ct-dif-total-nota ~
c-sc-dif-total-nota c-des-sc-dif-total-nota c-gera-ap c-text-dif-total-nota 

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
DEFINE VARIABLE c-ct-dif-total-nota AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Dif Arredondamento" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-ct-dif-total-nota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item-dif-total-nota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-sc-dif-total-nota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-gera-ap AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 22.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-item-dif-total-nota AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item Dif Arredondamento" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-dif-total-nota AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC Dif Arredondamento" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-padrao AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie PadrÆo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-dif-total-nota AS CHARACTER FORMAT "X(256)":U INITIAL "Diferen‡a de arredondamento no total do documento" 
      VIEW-AS TEXT 
     SIZE 44 BY .67 NO-UNDO.

DEFINE VARIABLE fi-vlr-min-detracao AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Valor m¡nimo para detra‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-gera-ap AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Integra", 1,
"Exporta", 2
     SIZE 20 BY 1.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 8.25.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.25.

DEFINE VARIABLE l-dif-contagem AS LOGICAL INITIAL no 
     LABEL "Contabiliza Diferen‡a Contagem":L15 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83.

DEFINE VARIABLE l-integra-wms AS LOGICAL INITIAL no 
     LABEL "Integra WMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-rec-fisico AS LOGICAL INITIAL no 
     LABEL "Receb F¡sico":L15 
     VIEW-AS TOGGLE-BOX
     SIZE 17.43 BY .83.

DEFINE VARIABLE l-usa-rga AS LOGICAL INITIAL no 
     LABEL "Usa RGA" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-utiliza-serie AS LOGICAL INITIAL no 
     LABEL "Utiliza S‚rie" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-considera-desp AS LOGICAL INITIAL no 
     LABEL "Considera Despesas como Custo do Produto" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-considera-imp AS LOGICAL INITIAL no 
     LABEL "Considera Imposto como Custo do Produto" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ctbz-gfe AS LOGICAL INITIAL no 
     LABEL "Integra Contabilidade x GFE" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-l-imp-ret-dupli AS LOGICAL INITIAL no 
     LABEL "Sugere Imposto Retido Duplicata" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE tg-l-mult-nat-receb AS LOGICAL INITIAL no 
     LABEL "Usa M£ltiplas Naturezas no Recebimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-remito-outra-moeda AS LOGICAL INITIAL no 
     LABEL "Permite Moeda do Remito diferente do Pedido" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-usa-dt-trans-fasb AS LOGICAL INITIAL no 
     LABEL "Usa Data de Transa‡Æo Moeda FASB" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE tg-validacao-conta AS LOGICAL INITIAL no 
     LABEL "Validar Contas Cont beis" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-var-camb AS LOGICAL INITIAL no 
     LABEL "Utiliza Cota‡Æo Alternativa para C lculo de Impostos de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 65 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-gera-ap AT ROW 1.29 COL 31.29 NO-LABEL
     l-integra-wms AT ROW 2.29 COL 31.43
     l-usa-rga AT ROW 2.29 COL 49 HELP
          "Indica o uso de RGA"
     l-utiliza-serie AT ROW 2.29 COL 65.43 HELP
          "Indica o uso de RGA"
     l-rec-fisico AT ROW 3.5 COL 6
     tg-usa-dt-trans-fasb AT ROW 3.5 COL 39 WIDGET-ID 10
     tg-ctbz-gfe AT ROW 4.46 COL 39 WIDGET-ID 8
     l-dif-contagem AT ROW 4.5 COL 6
     c-serie-padrao AT ROW 5.38 COL 61 COLON-ALIGNED
     tg-l-mult-nat-receb AT ROW 5.5 COL 6
     fi-vlr-min-detracao AT ROW 6.38 COL 61 COLON-ALIGNED WIDGET-ID 20
     tg-validacao-conta AT ROW 6.5 COL 6 WIDGET-ID 14
     tg-l-imp-ret-dupli AT ROW 7.5 COL 6
     tg-remito-outra-moeda AT ROW 7.5 COL 6 WIDGET-ID 12
     tg-considera-desp AT ROW 8.5 COL 6 WIDGET-ID 4
     tg-considera-imp AT ROW 9.5 COL 6 WIDGET-ID 6
     tg-var-camb AT ROW 10.5 COL 6 WIDGET-ID 18
     c-item-dif-total-nota AT ROW 12.46 COL 24.57 COLON-ALIGNED
     c-des-item-dif-total-nota AT ROW 12.46 COL 40.43 COLON-ALIGNED NO-LABEL
     c-ct-dif-total-nota AT ROW 13.46 COL 24.57 COLON-ALIGNED
     c-des-ct-dif-total-nota AT ROW 13.46 COL 40.43 COLON-ALIGNED NO-LABEL
     c-sc-dif-total-nota AT ROW 14.46 COL 24.57 COLON-ALIGNED
     c-des-sc-dif-total-nota AT ROW 14.46 COL 40.43 COLON-ALIGNED NO-LABEL
     c-gera-ap AT ROW 1.5 COL 6.86 COLON-ALIGNED NO-LABEL
     c-text-dif-total-nota AT ROW 11.5 COL 2 COLON-ALIGNED NO-LABEL
     RECT-18 AT ROW 3.25 COL 1
     rt-key AT ROW 1 COL 1
     RECT-19 AT ROW 11.88 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82 BY 14.75.


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
         HEIGHT             = 14.75
         WIDTH              = 82.
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-ct-dif-total-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item-dif-total-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-sc-dif-total-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-gera-ap IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-dif-total-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-dif-contagem IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-dif-contagem:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-rec-fisico IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-rec-fisico:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-ct-dif-total-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON ENTRY OF c-ct-dif-total-nota IN FRAME f-main /* Conta Dif Arredondamento */
DO:
  ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON F5 OF c-ct-dif-total-nota IN FRAME f-main /* Conta Dif Arredondamento */
DO:
    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  TODAY,              /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-des-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON LEAVE OF c-ct-dif-total-nota IN FRAME f-main /* Conta Dif Arredondamento */
DO:
    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    ASSIGN SELF:FORMAT = "X(20)"
           v_cod_cta_ctbl = INPUT FRAME f-main c-ct-dif-total-nota.

    /* Busca dados da conta cont bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?°O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */

    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresenta‡Æo da conta cont bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  TODAY,                /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               c-des-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl NO-ERROR.
    
        /* Verifica se a conta utiliza centro de custo */
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  TODAY,              /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  NOT p_log_ccusto THEN
            ASSIGN c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = ""
                   c-des-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        ELSE DO:
            ASSIGN c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            APPLY "ENTRY":U TO c-sc-dif-total-nota IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END.
    ELSE
        ASSIGN c-des-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-dif-total-nota IN FRAME f-main /* Conta Dif Arredondamento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item-dif-total-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-dif-total-nota V-table-Win
ON F5 OF c-item-dif-total-nota IN FRAME f-main /* Item Dif Arredondamento */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=c-item-dif-total-nota
                       &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-dif-total-nota V-table-Win
ON LEAVE OF c-item-dif-total-nota IN FRAME f-main /* Item Dif Arredondamento */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-des-item-dif-total-nota
                     &where="item.it-codigo = input frame {&frame-name}
                             c-item-dif-total-nota"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-dif-total-nota V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-dif-total-nota IN FRAME f-main /* Item Dif Arredondamento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-dif-total-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON ENTRY OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Arredondamento */
DO:
  ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON F5 OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Arredondamento */
DO:

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT c-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                  /* Unidade de Negocio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* C«digo da Conta*/
                                                   INPUT "",                  /* C«digo do Plano de Centro de Custo*/
                                                   INPUT TODAY,               /* Data da Transacao*/
                                                   OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
               c-des-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON LEAVE OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Arredondamento */
DO:

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN SELF:FORMAT = "X(20)"
           v_cod_ccusto = INPUT FRAME f-main c-sc-dif-total-nota.
    
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  TODAY,              /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca mÿscara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  TODAY,               /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN c-des-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
        /* Aplica a m scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto NO-ERROR.
    END.
    ELSE
        ASSIGN c-des-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Arredondamento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-padrao V-table-Win
ON F5 OF c-serie-padrao IN FRAME f-main /* S‚rie PadrÆo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=c-serie-padrao
                       &campozoom=serie}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-padrao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-serie-padrao IN FRAME f-main /* S‚rie PadrÆo */
DO:
    apply "f5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-rec-fisico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-rec-fisico V-table-Win
ON VALUE-CHANGED OF l-rec-fisico IN FRAME f-main /* Receb F¡sico */
DO:

    if input frame {&frame-name} l-rec-fisico then do:
        enable l-dif-contagem     with frame {&frame-name}.
        /*****enable c-dif-fisico       with frame {&frame-name}.*****/
    end.        
    else do:
        disable l-dif-contagem with frame {&frame-name}.
        assign  l-dif-contagem:checked in frame {&frame-name} = no.
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-utiliza-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-utiliza-serie V-table-Win
ON VALUE-CHANGED OF l-utiliza-serie IN FRAME f-main /* Utiliza S‚rie */
DO:
  IF l-utiliza-serie:CHECKED IN FRAME {&FRAME-NAME} THEN
      ASSIGN c-serie-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             c-serie-padrao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  ELSE
      ASSIGN c-serie-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-l-mult-nat-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-l-mult-nat-receb V-table-Win
ON VALUE-CHANGED OF tg-l-mult-nat-receb IN FRAME f-main /* Usa M£ltiplas Naturezas no Recebimento */
DO: 
    IF  tg-l-mult-nat-receb:CHECKED IN FRAME f-main = TRUE THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 53407, INPUT "").
        IF  RETURN-VALUE = "NO" THEN DO:
            ASSIGN tg-l-mult-nat-receb:CHECKED IN FRAME f-main = FALSE.
        END.
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
  
  /************************ INTERNAL PROCEDURES ********************/

    
    {utp/ut-field.i mgind param-estoq gera-ap 1}
    display trim(return-value) + ":" @ c-gera-ap with frame {&frame-name}.
    
    {utp/ut-liter.i Integra_WMS *}
    assign l-integra-wms:label in frame {&frame-name} = return-value.
    if c-serie-padrao:load-mouse-pointer ("image/lupa.cur") then.

    RUN pi-traducao.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finan‡as -> handle Conta Cont bil */
      DELETE PROCEDURE h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
  END.

  IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finan‡as -> handle Centro de Custo */
      DELETE PROCEDURE h_api_ccusto.
      ASSIGN h_api_ccusto = ?.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  
  IF i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:
        {utp/ut-liter.i "Diferen‡a_de_arredondamento_no_total_do_documento" *}
        ASSIGN c-text-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

        IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
        IF  NOT VALID-HANDLE(h_api_ccusto) THEN
            RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

        c-item-dif-total-nota:LOAD-MOUSE-POINTER("image/lupa.cur").  
        c-ct-dif-total-nota:LOAD-MOUSE-POINTER("image/lupa.cur").
        c-sc-dif-total-nota:LOAD-MOUSE-POINTER("image/lupa.cur").

    END.
    ELSE DO:
        ASSIGN c-text-dif-total-nota    :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-item-dif-total-nota    :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-des-item-dif-total-nota:HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-ct-dif-total-nota      :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-des-ct-dif-total-nota  :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-sc-dif-total-nota      :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               c-des-sc-dif-total-nota  :HIDDEN    IN FRAME {&FRAME-NAME} = YES
               RECT-19                  :HIDDEN    IN FRAME {&FRAME-NAME} = YES.

        ASSIGN FRAME f-main:HEIGHT = 10.63.
    END.

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    FIND FIRST param-re     NO-LOCK NO-ERROR.
    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.

    IF AVAIL param-global THEN
        ASSIGN c-empresa = param-global.empresa-prin.

    /* Usa m£ltiplas naturezas no recebimento */    
    IF  NOT CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "USA-MULT-NAT-RECEB") THEN DO:
        /* Cria registro na tabela fun‡Æo para o parƒmetro... */
        CREATE funcao.
        ASSIGN funcao.cd-funcao = "USA-MULT-NAT-RECEB"
               funcao.descricao = "Usa multiplas naturezas no recebimento"
               funcao.ativo     = FALSE.
    END.

    /* Defini‡Æo/atribui‡Æo da vari vel l-mult-natur-receb -> Usa m£ltiplas naturezas no recebimento */
    {cdp/cd9701.i}
    ASSIGN tg-l-mult-nat-receb:CHECKED IN FRAME {&FRAME-NAME} = l-mult-natur-receb. /* funcao USA-MULT-NAT-RECEB */
    
    IF  tg-l-mult-nat-receb:CHECKED IN FRAME {&FRAME-NAME} = TRUE THEN /* Uma vez marcado o param m£ltiplas naturezas no recebimento */
        ASSIGN tg-l-mult-nat-receb:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.  /* nÆo deixa voltar atr s... */
           
    if avail param-estoq then DO:
       ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.
       
       &IF DEFINED(Bf_dis_usuario_estab) &THEN
            IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                                 AND funcao.ativo     = YES) THEN DO:
               RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                 INPUT-OUTPUT c-cod-estabel-usuar).
            END.
       &ENDIF
       assign c-estabelec = c-cod-estabel-usuar.
    END.
  
    if not available param-estoq then
        create param-estoq.
    else do:
           
        assign i-gera-ap = param-estoq.gera-ap
               l-integra-wms = (substring(param-estoq.char-2,6,1) = "1":U)
               l-usa-rga = param-estoq.log-usa-rga.               

        display i-gera-ap
                l-integra-wms with frame {&frame-name}.

    end.
    
    /*Diferente de Brasil*/
    IF  i-pais-impto-usuario <> 1 THEN DO:

        find first param-estoq-internac  no-lock no-error.

        IF AVAILABLE param-estoq-internac THEN
            ASSIGN tg-var-camb = param-estoq-internac.log-atu-ce-var-camb.
        ELSE
            ASSIGN tg-var-camb = NO.

        ASSIGN tg-considera-desp     = (substring(param-estoq.char-2,74,1)  = "S":U)
               tg-considera-imp      = (substring(param-estoq.char-2,75,1)  = "S":U)
               tg-remito-outra-moeda = (substring(param-estoq.char-2,101,1) = "S":U).

        IF substring(param-estoq.char-2,68,1) <> "":U THEN
            ASSIGN l-utiliza-serie = (substring(param-estoq.char-2,68,1) = "S":U).
        ELSE DO:
            {cdp/cd4300.i4  yes param-global.char-2}             
            {cdp/cd0101.i51 yes}
            ASSIGN l-utiliza-serie = l-ut-ser.
        END.
        
        display l-utiliza-serie 
                l-usa-rga        
                tg-considera-desp
                tg-considera-imp 
                tg-remito-outra-moeda 
                tg-var-camb
                with frame {&frame-name}.
            

        /*Para localiza‡Æo Equador e EUA sempre deve manter escondido esse parƒmetro e como NO
          A s‚rie padrÆo deve permanecer habilitada e deve ser obrigatoriamente informada*/
        IF i-pais-impto-usuario = 21 
            OR i-pais-impto-usuario = 3 THEN DO:           
            ASSIGN l-utiliza-serie:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   c-serie-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        END.
        ELSE
            IF l-utiliza-serie:CHECKED IN FRAME {&FRAME-NAME} THEN
                ASSIGN c-serie-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN c-serie-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 

        ASSIGN c-serie-padrao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,69,5).

        IF i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:
            ASSIGN c-item-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,132,16)                   
                   c-ct-dif-total-nota  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,148,20)
                   c-sc-dif-total-nota  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,168,20).

            APPLY "LEAVE":U TO c-item-dif-total-nota IN FRAME {&FRAME-NAME}.
            APPLY "LEAVE":U TO c-ct-dif-total-nota IN FRAME {&FRAME-NAME}.
            APPLY "LEAVE":U TO c-sc-dif-total-nota IN FRAME {&FRAME-NAME}.

            APPLY "ENTRY":U TO i-gera-ap IN FRAME {&FRAME-NAME}.
        END.

        // Localiza‡Æo Peru - Valor m¡nimo detra‡Æo
        IF i-pais-impto-usuario = 33  /* Peru */  THEN DO:
            {utp/ut-liter.i Valor_m¡nimo_para_detra‡Æo * L}
            ASSIGN fi-vlr-min-detracao:HIDDEN       IN FRAME {&FRAME-NAME} = NO
                   fi-vlr-min-detracao:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
                   fi-vlr-min-detracao:LABEL        IN FRAME {&FRAME-NAME} = RETURN-VALUE
                   fi-vlr-min-detracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = (IF AVAIL param-estoq-internac THEN string(param-estoq-internac.dec-1,">>>,>>>,>>>,>>9.9999") ELSE "0,0000").
        END.
        ELSE 
            ASSIGN fi-vlr-min-detracao:HIDDEN       IN FRAME {&FRAME-NAME} = YES.
    END.
    ELSE
        ASSIGN l-utiliza-serie:HIDDEN   IN FRAME {&FRAME-NAME} = YES
               c-serie-padrao:HIDDEN    IN FRAME {&FRAME-NAME} = YES
               l-usa-rga:HIDDEN         IN FRAME {&FRAME-NAME} = YES
               tg-considera-desp:HIDDEN IN FRAME {&FRAME-NAME} = YES
               tg-considera-imp:HIDDEN  IN FRAME {&FRAME-NAME} = YES
               tg-remito-outra-moeda:HIDDEN IN FRAME {&FRAME-NAME} = YES
               tg-var-camb:HIDDEN IN FRAME {&FRAME-NAME} = YES
               fi-vlr-min-detracao:HIDDEN IN FRAME {&FRAME-NAME} = YES.

    /*parƒmetro para ativar a valida‡Æo das contas cont beis*/
    /*O campo log-validac-cta por nÆo ser um campo mandat¢rio, o valor inicial dele ‚ nulo,para nÆo apresentar 
      erro progress em tela, ‚ verificado o conte£do do campo*/
    ASSIGN tg-validacao-conta:CHECKED IN FRAME {&FRAME-NAME} = IF param-estoq.log-validac-cta THEN YES ELSE NO. 

    RUN pi-traducao.

  
    /* Recebimento F¡sico */                                
    &if  defined(bf_mat_receb_fisico) &then
         if  i-pais-impto-usuario = 1 then do:  /* Brasil */
             assign l-rec-fisico:hidden in frame {&FRAME-NAME} = no
                    l-dif-contagem:hidden in frame {&FRAME-NAME} = NO
                    l-rec-fisico:sensitive in frame {&FRAME-NAME} = yes.
                       
             assign l-rec-fisico:checked in frame {&frame-name} = param-estoq.rec-fisico
                    l-dif-contagem:checked in frame {&frame-name} = ( substring(param-estoq.char-1,23,1) = "1":U).

             if  avail param-estoq
             and param-estoq.rec-fisico then do:
                 enable l-dif-contagem with frame {&frame-name}.
             end.            
             else do:
                 disable l-dif-contagem with frame {&frame-name}.
             end.
         
             {utp/ut-liter.i Contabiliza_Diferen‡a_Contagem * L}
             assign l-dif-contagem:label in frame {&frame-name} = return-value.
         end.
  &endif
                                
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
    IF i-pais-impto-usuario <> 1  THEN DO:        
        ENABLE l-dif-contagem WITH FRAME {&FRAME-NAME}.
        {utp/ut-liter.i Contabiliza_Diferen‡a_Contagem * L}
        ASSIGN l-dif-contagem:HIDDEN  IN FRAME {&FRAME-NAME} = NO
               l-dif-contagem:CHECKED IN FRAME {&FRAME-NAME} = (SUBSTRING(param-estoq.char-1,23,1) = "1":U)
               l-dif-contagem:LABEL   IN FRAME {&FRAME-NAME} = RETURN-VALUE
               tg-l-mult-nat-receb:HIDDEN  IN FRAME {&FRAME-NAME} = YES.
    END.
  &ENDIF      

    IF  i-pais-impto-usuario = 1 THEN DO: /* Brasil */
   
        /*sugere impostos retidos*/
        IF CAN-FIND(FIRST funcao WHERE 
                          funcao.cd-funcao = "spp-aut-impto":U AND
                          funcao.ativo) THEN
            ASSIGN tg-l-imp-ret-dupli:CHECKED IN FRAME {&FRAME-NAME} = YES.
            
        /* Usa data transa‡Æo moeda FASB** */
        ENABLE tg-usa-dt-trans-fasb WITH FRAME {&FRAME-NAME}.
        {utp/ut-liter.i Usa_Data_de_Transa‡Æo_Moeda_FASB  * L}

        ASSIGN tg-usa-dt-trans-fasb:CHECKED IN FRAME {&FRAME-NAME} = (SUBSTRING(param-estoq.char-1,30,1) = "1":U).                    
    END.
    ELSE DO:
        assign tg-l-imp-ret-dupli:hidden      in frame {&FRAME-NAME} = YES
               tg-l-imp-ret-dupli:sensitive   in frame {&FRAME-NAME} = no
               tg-usa-dt-trans-fasb:hidden    in frame {&FRAME-NAME} = YES
               tg-usa-dt-trans-fasb:sensitive in frame {&FRAME-NAME} = no.
               
    END.       
               
     /*contabilização do GFE*/
    IF CAN-FIND(FIRST funcao 
                WHERE funcao.cd-funcao = "SPP_TOTVSGFE"
                  AND funcao.ativo) THEN
        ASSIGN tg-ctbz-gfe:SENSITIVE = YES.
    ELSE    
        ASSIGN tg-ctbz-gfe:SENSITIVE = NO.

    IF SUBSTRING(param-estoq.char-1,29,1) = "S":U THEN
        ASSIGN tg-ctbz-gfe:CHECKED IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN tg-ctbz-gfe:CHECKED IN FRAME {&FRAME-NAME} = NO.

    {utp/ut-liter.i Integra_Contabilidade_x_GFE * R}
    assign tg-ctbz-gfe:LABEL in frame {&frame-name} = return-value.
    /***********************/   

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-parametros V-table-Win 
PROCEDURE pi-grava-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first param-estoq  exclusive-lock no-error.

    IF i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:
        RUN pi-validate.
        IF RETURN-VALUE = "ADM-ERROR":U THEN
            RETURN "ADM-ERROR":U.
    END.

    assign param-estoq.gera-ap              = input frame {&frame-name} i-gera-ap
           overlay(param-estoq.char-2,6,1)  = if input frame {&frame-name} l-integra-wms = yes then "1":U else "0":U
           param-estoq.log-validac-cta = input frame {&frame-name} tg-validacao-conta. /*parƒmetro para ativar a valida‡Æo das contas cont beis*/
 
           
           
    /*Tratamento parƒmetro utiliza s‚rie*/
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN OVERLAY(param-estoq.char-2,74,1)  = IF input frame {&frame-name} tg-considera-desp     THEN "S":U ELSE "N":U
               OVERLAY(param-estoq.char-2,75,1)  = IF input frame {&frame-name} tg-considera-imp      THEN "S":U ELSE "N":U
               OVERLAY(param-estoq.char-2,101,1) = IF input frame {&frame-name} tg-remito-outra-moeda THEN "S":U ELSE "N":U.

        if l-usa-rga:hidden in frame {&frame-name} = no then   
            assign param-estoq.log-usa-rga  = input frame {&frame-name} l-usa-rga. 
        /*Para EUA e Equador esse parƒmetro deve ser sempre NO*/
        IF i-pais-impto-usuario = 21 
            OR i-pais-impto-usuario = 3 THEN
            ASSIGN OVERLAY(param-estoq.char-2,68,1) = "N":U.    
        ELSE
            ASSIGN OVERLAY(param-estoq.char-2,68,1) = IF input frame {&frame-name} l-utiliza-serie THEN "S":U ELSE "N":U.

        ASSIGN OVERLAY(param-estoq.char-2,69,5) = c-serie-padrao:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        IF i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:
            ASSIGN OVERLAY(param-estoq.char-2,132,16) = input frame {&frame-name} c-item-dif-total-nota
                   OVERLAY(param-estoq.char-2,148,20) = input frame {&frame-name} c-ct-dif-total-nota
                   OVERLAY(param-estoq.char-2,168,20) = input frame {&frame-name} c-sc-dif-total-nota.
        END.

        FIND FIRST param-estoq-internac exclusive-lock no-error.

        IF NOT AVAILABLE param-estoq-internac THEN
            CREATE param-estoq-internac.
              
        ASSIGN param-estoq-internac.log-atu-ce-var-camb = input frame {&frame-name} tg-var-camb.
       
        // Localiza‡Æo Peru - Valor m¡nimo detra‡Æo
        IF i-pais-impto-usuario = 33  /* Peru */  THEN DO:
            IF AVAIL param-estoq-internac THEN 
                ASSIGN param-estoq-internac.dec-1 = INPUT FRAME {&FRAME-NAME} fi-vlr-min-detracao.
        END.
    END.
    if  l-rec-fisico:hidden in frame {&frame-name} = no then do:
        assign param-estoq.rec-fisico      = input frame {&frame-name} l-rec-fisico.

        if  l-dif-contagem:hidden in frame {&frame-name} = no 
        and l-dif-contagem:sensitive in frame {&frame-name} = yes then 
            assign overlay(param-estoq.char-1,23,1) = string(int(input frame {&frame-name} l-dif-contagem)).
        else
            assign overlay(param-estoq.char-1,23,1) = "0":U.
    end.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        ASSIGN overlay(param-estoq.char-1,23,1) = STRING(INT(l-dif-contagem:checked in frame {&frame-name})).
    &ENDIF 
    
    find first param-estoq  no-lock no-error.
    
    /* Usa m£ltiplas naturezas no recebimento */
    FOR FIRST funcao WHERE funcao.cd-funcao = "USA-MULT-NAT-RECEB" EXCLUSIVE-LOCK:
        ASSIGN funcao.ativo = tg-l-mult-nat-receb:CHECKED IN FRAME {&FRAME-NAME}.
    END.

    FIND FIRST funcao WHERE funcao.cd-funcao = "USA-MULT-NAT-RECEB" NO-LOCK NO-ERROR.

    IF  i-pais-impto-usuario = 1 THEN DO: /* Brasil */
    
        ASSIGN OVERLAY(param-estoq.char-1,30,1) = IF INPUT FRAME {&FRAME-NAME} tg-usa-dt-trans-fasb = YES THEN "1":U ELSE "0":U.
    
    
        /*sugere impostos retidos*/
        IF CAN-FIND(FIRST funcao WHERE 
                          funcao.cd-funcao = "spp-aut-impto":U) THEN    
            FOR FIRST funcao WHERE funcao.cd-funcao = "spp-aut-impto" EXCLUSIVE-LOCK:
                ASSIGN funcao.ativo = tg-l-imp-ret-dupli:CHECKED IN FRAME {&FRAME-NAME}.
            END.
        ELSE DO:
            CREATE funcao.
            ASSIGN funcao.cd-funcao = "spp-aut-impto"
                   funcao.descricao = "Sugere imposto retido duplicata"
                   funcao.ativo     = tg-l-imp-ret-dupli:CHECKED IN FRAME {&FRAME-NAME}.
        END.   
    END.
    
    /*contabilização do GFE*/
    ASSIGN OVERLAY(param-estoq.char-1,29,1) = IF tg-ctbz-gfe:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U
                                              ELSE "N":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-traducao V-table-Win 
PROCEDURE pi-traducao :
{utp/ut-liter.i Validar_Contas_Cont beis * R}
    assign tg-validacao-conta:LABEL in frame {&frame-name} = return-value.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
   {include/i-vldfrm.i}  /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
   DEF VAR i-num-finalid-cta       AS INT  NO-UNDO.
   DEF VAR v_log_utz_ccusto        AS LOG  NO-UNDO.
   DEF VAR c-ct-dif-total-nota-aux AS CHAR NO-UNDO.
   DEF VAR c-sc-dif-total-nota-aux AS CHAR NO-UNDO.

   IF i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:       

       ASSIGN c-item-dif-total-nota = INPUT FRAME {&FRAME-NAME} c-item-dif-total-nota.

       FIND FIRST item WHERE item.it-codigo = c-item-dif-total-nota NO-LOCK NO-ERROR.
       IF NOT AVAIL item THEN DO:
           {utp/ut-liter.i "Item_Dif_Arredondamento" *}
           RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
           APPLY "ENTRY":U TO c-item-dif-total-nota IN FRAME {&FRAME-NAME}.
           RETURN "ADM-ERROR":U.
       END.

       IF item.tipo-contr <> 2 /* Total */ THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, INPUT 15309, ""). /* Tipo de controle do item deve ser total. */
           APPLY "ENTRY":U TO c-item-dif-total-nota IN FRAME {&FRAME-NAME}.
           RETURN "ADM-ERROR":U.
       END.

       /* Valida‡Æo Conta e Centro de Custo */
       ASSIGN c-ct-dif-total-nota-aux = INPUT FRAME {&FRAME-NAME} c-ct-dif-total-nota
              c-sc-dif-total-nota-aux = INPUT FRAME {&FRAME-NAME} c-sc-dif-total-nota.

       EMPTY TEMP-TABLE tt_log_erro.
       RUN pi_valida_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                        INPUT  "CEP":U,            /* MODULO */
                                                        INPUT  "",                 /* PLANO CONTAS */ 
                                                        INPUT  c-ct-dif-total-nota-aux,   /* CONTA */
                                                        INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                        INPUT  TODAY,              /* DATA DE TRANSACAO */ 
                                                        OUTPUT TABLE tt_log_erro). /* ERROS */
     
       FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
       IF  AVAIL tt_log_erro THEN DO:
           {utp/ut-liter.i "Conta_Cont bil" *}
           RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
           APPLY "ENTRY":U TO c-ct-dif-total-nota IN FRAME {&FRAME-NAME}.
           RETURN "ADM-ERROR":U.
       END.
       ELSE DO:
          EMPTY TEMP-TABLE tt_log_erro.
          RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,               /* EMPRESA EMS 2 */
                                                             INPUT  c-estabelec,             /* ESTABELECIMENTO EMS2 */
                                                             INPUT  "",                      /* PLANO CONTAS */
                                                             INPUT  c-ct-dif-total-nota-aux, /* CONTA */
                                                             INPUT  TODAY,                   /* DT TRANSACAO */
                                                             OUTPUT v_log_utz_ccusto,        /* UTILIZA CCUSTO ? */
                                                             OUTPUT TABLE tt_log_erro).      /* ERROS */
          IF  v_log_utz_ccusto THEN DO:
              EMPTY TEMP-TABLE tt_log_erro.
              RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,               /* EMPRESA EMS2 */
                                                         INPUT  "",                      /* CODIGO DO PLANO CCUSTO */
                                                         INPUT  c-sc-dif-total-nota-aux, /* CCUSTO */
                                                         INPUT  TODAY,                   /* DATA DE TRANSACAO */
                                                         OUTPUT v_des_ccusto,            /* DESCRICAO DO CCUSTO */
                                                         OUTPUT TABLE tt_log_erro).      /* ERROS */ 
              FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
              IF  AVAIL tt_log_erro THEN DO:
                  /*{include/i-vldprg.i}*/
                  {utp/ut-liter.i "Centro_Custo" *}
                  RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
                  APPLY "ENTRY":U TO c-sc-dif-total-nota IN FRAME {&FRAME-NAME}.
                  RETURN "ADM-ERROR":U.
              END.
          END.
       END.
      /* Fim Valida‡Æo Conta e Centro de Custo */
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-parametros V-table-Win 
PROCEDURE pi-verifica-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF (i-pais-impto-usuario = 21 OR i-pais-impto-usuario = 3) AND
        NOT l-utiliza-serie:CHECKED IN FRAME {&FRAME-NAME}      THEN DO: /*Equador ou EUA ou Utiliza s‚rie Marcado*/

        IF INPUT FRAME {&FRAME-NAME} c-serie-padrao = "" THEN DO:
            {utp/ut-liter.i S‚rie_PadrÆo *}     
            run utp/ut-msgs.p (input "show":U, 
                               input 265, 
                               input RETURN-VALUE).
            apply "entry" to c-serie-padrao in frame {&frame-name}.
            return ERROR.
        END.

        IF NOT CAN-FIND(FIRST serie
                        WHERE serie.serie = INPUT FRAME {&FRAME-NAME} c-serie-padrao) THEN DO:
            {utp/ut-liter.i S‚rie *}     
            run utp/ut-msgs.p (input "show":U, 
                               input 2, 
                               input RETURN-VALUE).
            apply "entry" to c-serie-padrao in frame {&frame-name}.
            return ERROR.
        END.

    END.
    
    IF  i-pais-impto-usuario = 1 AND  /* Brasil */
        NOT tg-l-imp-ret-dupli:CHECKED IN FRAME {&FRAME-NAME} AND
    CAN-FIND(FIRST param-re WHERE 
                   substring(param-re.char-1,25,1) = "Y") THEN DO:
                       
        def var c-texto-1 as char no-undo.
        def var c-texto-2 as char no-undo.
        
        {utp/ut-liter.i "Parƒmetro_Sugere_Imposto_Retido_Duplicata_nÆo_pode_ser_desmarcado." *}
        Assign c-texto-1 = RETURN-VALUE.
        
        {utp/ut-liter.i "Existem_usu rios_do_Recebimento_(RE0101)_que_estÆo_com_a_op‡Æo_Utiliza_Config_Trib_Impostos_Retidos_selecionada." *}
        Assign c-texto-2 = RETURN-VALUE.
                
        run utp/ut-msgs.p (input "show":U,        
                           input 29693,           
                           input c-texto-1 + "~~" + c-texto-2).
        
        ASSIGN tg-l-imp-ret-dupli:CHECKED IN FRAME {&FRAME-NAME} = YES.    
        
        return ERROR.
    END. 
    
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

