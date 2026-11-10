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
{include/i-prgvrs.i V01IN087 2.00.00.007 } /*** "010007" 17/10/2024 16:48:35 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in087 MUT}
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
def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

/* Variáveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Variáveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 
def var v_log_utz_ccusto     as log    no-undo.

/* Local Variable Definitions ---                                       */

def buffer b-despesa for despesa-aces.
def buffer b-emitente for emitente.

def var l-inclui as logical   no-undo.
def var c-handle as character no-undo.
def var i-cod-emit like emitente.cod-emitente no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
def var c-estabelec as char no-undo.
def var c-formato   as char no-undo.

DEF VAR oCbTipoCte     AS rep.list.TipoCteList            NO-UNDO.

{cdp/cdcfgdis.i}

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
&Scoped-define EXTERNAL-TABLES despesa-aces
&Scoped-define FIRST-EXTERNAL-TABLE despesa-aces


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR despesa-aces.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS despesa-aces.cod-esp despesa-aces.tp-despesa ~
despesa-aces.dt-emissao despesa-aces.dt-vencto despesa-aces.ct-tr-fornec ~
despesa-aces.sc-tr-fornec despesa-aces.observacao 
&Scoped-define ENABLED-TABLES despesa-aces
&Scoped-define FIRST-ENABLED-TABLE despesa-aces
&Scoped-Define ENABLED-OBJECTS rt-key RECT-5 
&Scoped-Define DISPLAYED-FIELDS despesa-aces.cod-forn-ac ~
despesa-aces.ser-docto-ac despesa-aces.nro-docto-ac ~
despesa-aces.nat-oper-ac despesa-aces.cod-esp despesa-aces.tp-despesa ~
despesa-aces.dt-emissao despesa-aces.dt-vencto despesa-aces.ct-tr-fornec ~
despesa-aces.sc-tr-fornec despesa-aces.observacao 
&Scoped-define DISPLAYED-TABLES despesa-aces
&Scoped-define FIRST-DISPLAYED-TABLE despesa-aces
&Scoped-Define DISPLAYED-OBJECTS fi-fornec fi-natureza fi-especie ~
fi-despesa fi-conta fi-ccusto cb-tipo-cte 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS despesa-aces.cod-forn-ac ~
despesa-aces.ser-docto-ac despesa-aces.nro-docto-ac ~
despesa-aces.nat-oper-ac 
&Scoped-define ADM-ASSIGN-FIELDS despesa-aces.ct-tr-fornec ~
despesa-aces.sc-tr-fornec despesa-aces.observacao 

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
DEFINE VARIABLE cb-tipo-cte AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo CT-e" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-especie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     despesa-aces.cod-forn-ac AT ROW 1.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-fornec AT ROW 1.33 COL 45 COLON-ALIGNED NO-LABEL
     despesa-aces.ser-docto-ac AT ROW 2.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     despesa-aces.nro-docto-ac AT ROW 3.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     despesa-aces.nat-oper-ac AT ROW 4.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fi-natureza AT ROW 4.33 COL 43.57 COLON-ALIGNED NO-LABEL
     despesa-aces.cod-esp AT ROW 5.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     fi-especie AT ROW 5.33 COL 38.29 COLON-ALIGNED NO-LABEL
     despesa-aces.tp-despesa AT ROW 6.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-despesa AT ROW 6.33 COL 37.72 COLON-ALIGNED NO-LABEL
     despesa-aces.dt-emissao AT ROW 7.33 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     despesa-aces.dt-vencto AT ROW 7.33 COL 60.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     despesa-aces.ct-tr-fornec AT ROW 8.33 COL 32.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-conta AT ROW 8.33 COL 52.43 COLON-ALIGNED NO-LABEL
     cb-tipo-cte AT ROW 10.33 COL 32.72 COLON-ALIGNED
	 despesa-aces.sc-tr-fornec AT ROW 9.33 COL 32.72 COLON-ALIGNED
          LABEL "Cento Custo"
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-ccusto AT ROW 9.33 COL 52.43 COLON-ALIGNED NO-LABEL
     despesa-aces.observacao AT ROW 12 COL 6.14 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 77.14 BY .88
     rt-key AT ROW 1 COL 1
     RECT-5 AT ROW 11.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.despesa-aces
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
         HEIGHT             = 11.29
         WIDTH              = 86.72.
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

/* SETTINGS FOR COMBO-BOX cb-tipo-cte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN despesa-aces.cod-forn-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.ct-tr-fornec IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-especie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-fornec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN despesa-aces.nat-oper-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.nro-docto-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.observacao IN FRAME f-main
   ALIGN-L 2                                                            */
/* SETTINGS FOR FILL-IN despesa-aces.sc-tr-fornec IN FRAME f-main
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.ser-docto-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME despesa-aces.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-esp V-table-Win
ON F5 OF despesa-aces.cod-esp IN FRAME f-main /* Esp‚cie */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-esp IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=despesa-aces.cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-esp V-table-Win
ON LEAVE OF despesa-aces.cod-esp IN FRAME f-main /* Esp‚cie */
DO:
    {include/leave.i &tabela=espec-ap
                     &atributo-ref=descricao
                     &variavel-ref=fi-especie
                     &where="espec-ap.cod-esp = input frame {&frame-name}
                             despesa-aces.cod-esp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.cod-forn-ac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-forn-ac V-table-Win
ON F5 OF despesa-aces.cod-forn-ac IN FRAME f-main /* C¢digo Fornecedor Acess¢rio */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-forn-ac IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=despesa-aces.cod-forn-ac
                       &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-forn-ac V-table-Win
ON LEAVE OF despesa-aces.cod-forn-ac IN FRAME f-main /* C¢digo Fornecedor Acess¢rio */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-fornec
                     &where="emitente.cod-emitente = input frame {&frame-name}
                             despesa-aces.cod-forn-ac"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.ct-tr-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON ENTRY OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON F5 OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
    
   assign i-ep-codigo-usuario = param-global.empresa-prin
          l-implanta          = yes. 

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN despesa-aces.ct-tr-fornec:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN fi-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON LEAVE OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
                             
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT despesa-aces.ct-tr-fornec.

    /* Busca dados da conta contÙbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,             /* EMPRESA EMS 2 */
                                                           input  c-estabelec,           /* ESTABELECIMENTO EMS2 */
                                                           input  "",                    /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,        /* CONTA */
                                                           input  today,                 /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,      /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).    /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE sc-tr-fornec WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN sc-tr-fornec:SCREEN-VALUE = "".
            ASSIGN fi-ccusto:SCREEN-VALUE = "".
            DISABLE sc-tr-fornec WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN fi-conta:SCREEN-VALUE = v_titulo_cta_ctbl. 
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.nat-oper-ac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.nat-oper-ac V-table-Win
ON F5 OF despesa-aces.nat-oper-ac IN FRAME f-main /* Natureza */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.nat-oper-ac IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=despesa-aces.nat-oper-ac
                       &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.nat-oper-ac V-table-Win
ON LEAVE OF despesa-aces.nat-oper-ac IN FRAME f-main /* Natureza */
DO:
    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh-target", OUTPUT c-handle).
    if  valid-handle(widget-handle(c-handle)) then do with frame {&frame-name}:
        find natur-oper where
             natur-oper.nat-operacao = input despesa-aces.nat-oper-ac
             no-lock no-error.
        if  avail natur-oper then do:
            assign i-cod-emit = input frame {&frame-name} despesa-aces.cod-forn-ac.
            
            if  session:set-wait-state ("GENERAL":U) then .
            run pi-seta-natureza in widget-handle(c-handle)
                (input rowid(natur-oper), i-cod-emit).
            if  session:set-wait-state ("":U) then .
        end.        
    end.    
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-natureza
                     &where="natur-oper.nat-operacao = input frame {&frame-name}
                             despesa-aces.nat-oper-ac"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.sc-tr-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON F5 OF despesa-aces.sc-tr-fornec IN FRAME f-main /* Cento Custo */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN despesa-aces.sc-tr-fornec:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN fi-ccusto:SCREEN-VALUE = v_titulo_ccusto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON LEAVE OF despesa-aces.sc-tr-fornec IN FRAME f-main /* Cento Custo */
DO:
    /*{cdp/cd9998.i}*/
    ASSIGN v_cod_ccusto = INPUT despesa-aces.sc-tr-fornec.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

     ASSIGN fi-ccusto:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.tp-despesa V-table-Win
ON F5 OF despesa-aces.tp-despesa IN FRAME f-main /* Tipo Despesa */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.tp-despesa IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=despesa-aces.tp-despesa
                       &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.tp-despesa V-table-Win
ON LEAVE OF despesa-aces.tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
    {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao
                     &variavel-ref=fi-despesa
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name}
                             despesa-aces.tp-despesa"}
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

  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-global no-lock no-error.
  find first param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find estabelec where estabelec.cod-estabel = docum-est.cod-estabel
       no-lock no-error.
  find emitente where emitente.cod-emitente = docum-est.cod-emitente 
       no-lock no-error.
  despesa-aces.cod-forn-ac:load-mouse-pointer("image/lupa.cur").
  despesa-aces.nat-oper-ac:load-mouse-pointer("image/lupa.cur").
  despesa-aces.cod-esp:load-mouse-pointer("image/lupa.cur"). 
  despesa-aces.tp-despesa:load-mouse-pointer("image/lupa.cur").

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
  {src/adm/template/row-list.i "despesa-aces"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "despesa-aces"}

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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
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
  if  avail despesa-aces then do:
      find b-emitente where b-emitente.cod-emitente = despesa-aces.cod-forn-ac
           no-lock no-error.
      find emitente where emitente.cod-emitente = docum-est.cod-emitente
           no-lock no-error.
      find natur-oper where natur-oper.nat-operacao = despesa-aces.nat-oper-ac
           no-lock no-error.
      find espec-ap where espec-ap.cod-esp = despesa-aces.cod-esp 
           no-lock no-error.
      find tipo-rec-desp where tipo-rec-desp.tp-codigo = despesa-aces.tp-despesa
           no-lock no-error.

      assign fi-fornec   = if avail b-emitente then b-emitente.nome-emit else ""
             fi-natureza = if avail natur-oper then natur-oper.denominacao else ""
             fi-especie  = if avail espec-ap then espec-ap.descricao else ""
             fi-despesa  = if avail tipo-rec-desp then tipo-rec-desp.descricao 
                           else "".    
      
      /* Handle da API Conta Cont bil */
      run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
      /* Handle da API Centro Custo */
      run prgint\utb\utb742za.py persistent set h_api_ccusto.
        
      /* Retorna formato da conta contabil */
      run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,               /* EMPRESA EMS2 */
                                                         input  "",                      /* PLANO CONTAS */
                                                         input  despesa-aces.dt-emissao, /* DATA DE TRANSACAO */
                                                         output c-formato-conta,         /* FORMATO CONTA */
                                                         output table tt_log_erro).      /* ERROS */
      /* Retorna formato do centro de custo */
      run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                     input  "",                      /* PLANO CCUSTO */
                                                     input  despesa-aces.dt-emissao, /* DATA DE TRANSACAO */
                                                     output c-formato-ccusto,        /* FORMATO CCUSTO */
                                                     output table tt_log_erro).      /* ERROS */  
                                                       
      /* Busca dados da conta cont bil */
      ASSIGN v_cod_cta_ctbl = despesa-aces.ct-tr-fornec.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,               /* EMPRESA EMS2 */
                                                     input        "",                      /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,          /* CONTA */
                                                     input        despesa-aces.dt-emissao, /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,       /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl,      /* SITUA€ÇO DA CONTA */
                                                     output       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).            /* ERROS */ 
    
      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = despesa-aces.sc-tr-fornec.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                 input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,            /* CCUSTO */
                                                 input  despesa-aces.dt-emissao, /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro).      /* ERROS */
      
  end.
  
  /*Tipo CT-e*/
  oCbTipoCte = NEW rep.list.TipoCteList().
  cb-tipo-cte:LIST-ITEM-PAIRS IN FRAME  {&FRAME-NAME} = ",," + oCbTipoCte:getLista().
  DELETE OBJECT oCbTipoCte.   
  IF SUBSTRING(despesa-aces.char-1,63,2) = "" 
  or SUBSTRING(despesa-aces.char-1,63,2) = "00" THEN
     ASSIGN cb-tipo-cte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  else
     ASSIGN cb-tipo-cte:SCREEN-VALUE IN frame  {&FRAME-NAME} = string(INT(SUBSTRING(despesa-aces.char-1,63,2))).
  /*Fim Tipo CT-e*/
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 if c-formato-conta <> "" then
      assign despesa-aces.ct-tr-fornec:format in frame {&FRAME-NAME} = c-formato-conta.
  if c-formato-ccusto <> "" then
      assign despesa-aces.sc-tr-fornec:format in frame {&FRAME-NAME} = c-formato-ccusto.

  assign fi-conta  = v_titulo_cta_ctbl.
  assign fi-ccusto = v_titulo_ccusto.

  disp fi-fornec   
       fi-natureza 
       fi-especie  
       fi-despesa 
       despesa-aces.ct-tr-fornec
       fi-conta
       despesa-aces.sc-tr-fornec
       fi-ccusto
	   cb-tipo-cte
      with frame {&frame-name}.
 
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
  
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  if avail docum-est then do:         
    
    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.

        assign c-estabelec = docum-est.cod-estabel.
        
  end.
  
  {utp/ut-liter.i Centro_de_Custo * R}
  assign despesa-aces.sc-tr-fornec:label      in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Conta_Cont bil * R}
  assign despesa-aces.ct-tr-fornec:label      in frame {&frame-name} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

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
  {src/adm/template/snd-list.i "despesa-aces"}

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

