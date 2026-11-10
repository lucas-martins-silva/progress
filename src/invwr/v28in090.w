&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V28IN090 2.00.00.021 } /*** "010021" 15/09/2026 18:31:14 ***/
{include/i-license-manager.i v28in090 MUT}

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

 -----------------------------------------------------------------------*/
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

{include/i-vrtab.i unid-feder}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.
/* Parameters Definitions ---                                           */

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo.
/* Vari·veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari·veis centro de custo */
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

/* Local Variable Definitions ---                                       */

{rep/re9999.i1} /* Flags para Codigos de Observacao */

def var rw-natureza         as rowid   no-undo.
def var l-inclui            as logical no-undo.
def var h-handle-aux1       as handle  no-undo.
def var c-natureza          like docum-est.nat-operacao no-undo.
def var i-especie           as integer no-undo.
def var i-observa           as integer no-undo.

def var h_api_cta_ctbl      as handle  no-undo.
def var h_api_ccusto        as handle  no-undo.
def var oTipoOperacaoUtil   as rep.utils.TipoOperacaoUtil no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}

{rep/re9999.i2 "new"}

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.ct-transit docum-est.sc-transit ~
docum-est.valor-frete docum-est.tot-peso docum-est.valor-seguro ~
docum-est.valor-outras docum-est.valor-embal docum-est.dt-venc-icm ~
docum-est.dt-venc-ipi docum-est.dt-venc-iss docum-est.usuario ~
docum-est.tipo-dfe-docto 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS c-tipo-oper c-label-compra-gov ~
c-desc-ente-gov c-desc-oper-gov rect-gov RECT-4 rt-2 rt-key RECT-26 RECT-27 ~
RECT-28 
&Scoped-Define DISPLAYED-FIELDS docum-est.ct-transit docum-est.sc-transit ~
docum-est.valor-frete docum-est.tot-peso docum-est.valor-seguro ~
docum-est.valor-outras docum-est.valor-embal docum-est.dt-venc-icm ~
docum-est.nff docum-est.dt-venc-ipi docum-est.nf-emitida-est ~
docum-est.estorn-comis docum-est.dt-venc-iss docum-est.usuario ~
docum-est.tipo-dfe-docto 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS c-arrendador c-tipo-oper c-origem ~
de-valor-pedagio fi-conta-ctbl fi-centro-custo c-label-compra-gov ~
c-desc-ente-gov c-desc-oper-gov tg-memorando-exp c-it-serv c-desc-item ~
c-contrato-leasing 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS docum-est.valor-frete ~
docum-est.valor-seguro docum-est.valor-outras docum-est.valor-embal ~
docum-est.nff docum-est.nf-emitida-est docum-est.estorn-comis 

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
DEFINE VARIABLE c-arrendador AS CHARACTER FORMAT "X(06)":U 
     LABEL "Arrendador" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-contrato-leasing AS CHARACTER FORMAT "X(12)":U 
     LABEL "Contrato Leasing" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ente-gov AS CHARACTER FORMAT "X(40)":U 
     LABEL "Tp Ente Gov" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-oper-gov AS CHARACTER FORMAT "X(60)":U 
     LABEL "Tp Oper Gov" 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-serv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item Serviáo" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-compra-gov AS CHARACTER FORMAT "X(20)":U INITIAL "Compra Gov" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER FORMAT "X(3)":U 
     LABEL "Origem Documento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-oper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-pedagio AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Ped†gio" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-centro-custo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-ctbl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 1.17.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.43 BY 3.33.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 1.17.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 3.33.

DEFINE RECTANGLE rect-gov
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 1.5.

DEFINE RECTANGLE rt-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 8.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 2.25.

DEFINE VARIABLE tg-memorando-exp AS LOGICAL INITIAL no 
     LABEL "Memorando Export" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-arrendador AT ROW 13.71 COL 40.72 COLON-ALIGNED WIDGET-ID 8
     c-tipo-oper AT ROW 10.25 COL 57.72 COLON-ALIGNED WIDGET-ID 2
     c-origem AT ROW 9.25 COL 57.72 COLON-ALIGNED
     de-valor-pedagio AT ROW 5.58 COL 41.72 COLON-ALIGNED
     docum-est.ct-transit AT ROW 1.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-conta-ctbl AT ROW 1.25 COL 43 COLON-ALIGNED NO-LABEL
     docum-est.sc-transit AT ROW 2.25 COL 23 COLON-ALIGNED
          LABEL "Centro Custo"
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-centro-custo AT ROW 2.25 COL 43 COLON-ALIGNED NO-LABEL
     docum-est.valor-frete AT ROW 3.58 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.tot-peso AT ROW 3.58 COL 41.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     docum-est.valor-seguro AT ROW 4.58 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.valor-outras AT ROW 4.58 COL 41.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.valor-embal AT ROW 5.58 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-label-compra-gov AT ROW 7 COL 1.43 COLON-ALIGNED NO-LABEL
     c-desc-ente-gov AT ROW 7.79 COL 9.86 COLON-ALIGNED
     c-desc-oper-gov AT ROW 7.79 COL 37.29 COLON-ALIGNED
     docum-est.dt-venc-icm AT ROW 9.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.nff AT ROW 3.5 COL 67.29
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .83
     docum-est.dt-venc-ipi AT ROW 10.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.nf-emitida-est AT ROW 4.5 COL 67.29
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     tg-memorando-exp AT ROW 6.5 COL 67.29
     docum-est.estorn-comis AT ROW 5.5 COL 67.29
          VIEW-AS TOGGLE-BOX
          SIZE 15.86 BY .83
     docum-est.dt-venc-iss AT ROW 11.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-it-serv AT ROW 12.5 COL 10.72 COLON-ALIGNED
     c-desc-item AT ROW 12.5 COL 23 COLON-ALIGNED NO-LABEL
     docum-est.usuario AT ROW 13.71 COL 10.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-contrato-leasing AT ROW 13.71 COL 67 COLON-ALIGNED WIDGET-ID 10
     docum-est.tipo-dfe-docto AT ROW 11.25 COL 57.72 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 25.29 BY .88
     rect-gov AT ROW 7.33 COL 2
     RECT-4 AT ROW 9 COL 1
     rt-2 AT ROW 1 COL 1
     rt-key AT ROW 1 COL 1
     RECT-26 AT ROW 12.38 COL 1
     RECT-27 AT ROW 9 COL 45.14
     RECT-28 AT ROW 13.54 COL 1 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 13.88
         WIDTH              = 86.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-arrendador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-contrato-leasing IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-serv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-pedagio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX docum-est.estorn-comis IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-centro-custo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta-ctbl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX docum-est.nf-emitida-est IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX docum-est.nff IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.sc-transit IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-memorando-exp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.valor-embal IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.valor-frete IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.valor-outras IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.valor-seguro IN FRAME f-main
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

&Scoped-define SELF-NAME docum-est.ct-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON ENTRY OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON F5 OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    assign i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = yes.


    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M‡DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN docum-est.ct-transit:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN fi-conta-ctbl:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON LEAVE OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:


    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT docum-est.ct-transit.

    /* Busca dados da conta contŸbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAõ¯O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,             /* EMPRESA EMS 2 */
                                                           input  docum-est.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "",                    /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,        /* CONTA */
                                                           input  today,                 /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,      /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).    /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE docum-est.sc-transit WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN docum-est.sc-transit:SCREEN-VALUE = "".
            ASSIGN fi-centro-custo:SCREEN-VALUE = "".
            DISABLE docum-est.sc-transit WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN fi-conta-ctbl:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.sc-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON F5 OF docum-est.sc-transit IN FRAME f-main /* Centro Custo */
DO:
    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */

   ASSIGN docum-est.sc-transit:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN fi-centro-custo:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON LEAVE OF docum-est.sc-transit IN FRAME f-main /* Centro Custo */
DO:
    /*{cdp/cd9998.i}*/
    ASSIGN v_cod_ccusto = INPUT docum-est.sc-transit.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN fi-centro-custo:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.sc-transit IN FRAME f-main /* Centro Custo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-embal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-embal V-table-Win
ON LEAVE OF docum-est.valor-embal IN FRAME f-main /* Embalagem */
DO:
    apply "leave" to docum-est.valor-frete in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-outras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-outras V-table-Win
ON LEAVE OF docum-est.valor-outras IN FRAME f-main /* Outras */
DO:
    apply "leave" to docum-est.valor-frete in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-seguro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-seguro V-table-Win
ON LEAVE OF docum-est.valor-seguro IN FRAME f-main /* Seguro */
DO:
    apply "leave" to docum-est.valor-frete in frame {&frame-name}.
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

  /* {utp/ut-liter.i Mod_Frete * r }
  assign fi-mod-frete:screen-value in frame {&frame-name} = trim(return-value). */

  /* {utp/ut-field.i mgind docum-est via-transp 1}
  assign cb-via-transp:label in frame {&frame-name} = return-value. */
  if docum-est.ct-transit:load-mouse-pointer("image/lupa.cur") then .

  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
  /* {utp/ut-rtlbl.i mgind docum-est mod-frete fi-mod-frete} */
  assign l-inclui = yes.

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e
  nem na PI-validate. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then
   RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */
  /* Code placed here will execute AFTER standard behavior.    */
  /* assign input frame {&frame-name} cb-via-transp
         docum-est.via-transp = {adinc/i01ad268.i 06 cb-via-transp}. */

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

  DELETE OBJECT oTipoOperacaoUtil NO-ERROR.
  ASSIGN oTipoOperacaoUtil = ?.

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
  DEFINE VARIABLE oTipoEnteGovList AS cdp.list.TipoEnteGovernamentalList NO-UNDO.
  DEFINE VARIABLE oTipoOperGovList AS cdp.list.TipoOperGovList NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if docum-est.tipo-dfe-docto = ? then
    assign docum-est.tipo-dfe-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

  /* Handle da API Conta Cont†bil */
  if not valid-handle(h_api_cta_ctbl) then
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  if not valid-handle(h_api_ccusto) then
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

  assign i-empresa = i-ep-codigo-usuario.
  find estabelec where
       estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  docum-est.dt-trans, /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  docum-est.dt-trans, /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */

  /* Busca dados da conta cont†bil */
  ASSIGN v_cod_cta_ctbl = docum-est.ct-transit.
  run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                 input        "",                 /* PLANO DE CONTAS */
                                                 input-output v_cod_cta_ctbl,     /* CONTA */
                                                 input        docum-est.dt-trans, /* DATA TRANSACAO */
                                                 output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                 output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                 output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                 output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                 output table tt_log_erro).       /* ERROS */

  /* Busca dados do centro de custo */
  ASSIGN v_cod_ccusto = docum-est.sc-transit.
  run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                             input  "",                 /* CODIGO DO PLANO CCUSTO */
                                             input  v_cod_ccusto,       /* CCUSTO */
                                             input  docum-est.dt-trans, /* DATA DE TRANSACAO */
                                             output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                             output table tt_log_erro). /* ERROS */

  /* Formatando conta e centro de custo */
  if c-formato-conta <> "" then
      assign docum-est.ct-transit:format in frame {&FRAME-NAME} = c-formato-conta.
  if c-formato-ccusto <> "" then
      assign docum-est.sc-transit:format in frame {&FRAME-NAME} = c-formato-ccusto.

  /* Setando titulos da conta contabil e do centro de custo */
  assign fi-conta-ctbl:screen-value        in frame {&frame-name} = v_titulo_cta_ctbl
         docum-est.ct-transit:screen-value in frame {&frame-name} = docum-est.ct-transit.
  assign fi-centro-custo:screen-value      in frame {&frame-name} = v_titulo_ccusto
         docum-est.sc-transit:screen-value in frame {&frame-name} = docum-est.sc-transit.


  /********************inicio contrato leasing************************************/
  ASSIGN c-arrendador      :screen-value in frame {&frame-name} = ""
         c-contrato-leasing:screen-value in frame {&frame-name} = "".
  FIND FIRST ext-docum-est NO-LOCK
         WHERE ext-docum-est.serie-docto  = docum-est.serie-docto
         AND   ext-docum-est.nro-docto    = docum-est.nro-docto
         AND   ext-docum-est.cod-emitente = docum-est.cod-emitente
         AND   ext-docum-est.nat-operacao = docum-est.nat-operacao
         AND   ext-docum-est.cod-param    = "contrato-leasing" NO-ERROR.
  IF AVAIL ext-docum-est THEN
       ASSIGN c-arrendador      :screen-value in frame {&frame-name} = SUBSTRING(ext-docum-est.cod-livre-2,1,6)
              c-contrato-leasing:screen-value in frame {&frame-name} = SUBSTRING(ext-docum-est.cod-livre-1,1,12).

  DISABLE c-arrendador
          c-contrato-leasing
          WITH FRAME {&FRAME-NAME}.
  /********************fim contrato leasing************************************/

  /* if  avail docum-est then do with frame {&frame-name}:
      cb-via-transp:screen-value = {adinc/i01ad268.i 04 docum-est.via-transp}.
  end.
  else do with frame {&frame-name}:
      assign cb-via-transp:screen-value = {adinc/i01ad268.i 04 1}.
  end.*/

  assign c-origem:screen-value in frame {&frame-name} = docum-est.origem.

  /* Memorando Exportaá∆o */
  ASSIGN tg-memorando-exp:CHECKED IN FRAME {&frame-name} = docum-est.log-memorando.

  /*Item Serviáo*/
  ASSIGN c-it-serv:SCREEN-VALUE IN FRAME {&frame-name} = SUBSTRING(docum-est.char-1,176,16). /* cod-item-serv */

  IF (c-it-serv:SCREEN-VALUE IN FRAME {&frame-name}) <> "" THEN DO:
      FIND FIRST item NO-LOCK
        WHERE ITEM.it-codigo = c-it-serv:SCREEN-VALUE IN FRAME {&frame-name} NO-ERROR.
      IF AVAIL ITEM THEN DO:
          ASSIGN c-desc-item:SCREEN-VALUE IN FRAME {&frame-name} = ITEM.desc-item.
      END.
  END.

  /*Pedagio*/
  ASSIGN de-valor-pedagio:SCREEN-VALUE IN FRAME {&frame-name} = SUBSTRING(docum-est.char-2,153,13).

  ASSIGN c-tipo-oper:SCREEN-VALUE IN FRAME {&frame-name} = oTipoOperacaoUtil:getNomeTipoOper(docum-est.idi-tip-operac).
  DISABLE c-tipo-oper WITH FRAME {&frame-name}.

  /* Busca descricoes de Compra Governamental */
  IF docum-est.cod-tipo-ente-gov > 0 THEN DO:
      oTipoEnteGovList = NEW cdp.list.TipoEnteGovernamentalList().
      ASSIGN c-desc-ente-gov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = oTipoEnteGovList:getDescricao(docum-est.cod-tipo-ente-gov).
      DELETE OBJECT oTipoEnteGovList.

      oTipoOperGovList = NEW cdp.list.TipoOperGovList().
      ASSIGN c-desc-oper-gov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = oTipoOperGovList:getDescricao(docum-est.cod-tipo-oper-gov).
      DELETE OBJECT oTipoOperGovList.
  END.
  ELSE DO:
      ASSIGN c-desc-ente-gov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             c-desc-oper-gov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  END.

  DISABLE c-desc-ente-gov c-desc-oper-gov WITH FRAME {&FRAME-NAME}.

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

  /* Memorando Exportaá∆o */
  ASSIGN tg-memorando-exp:HIDDEN IN FRAME {&FRAME-NAME}= NO.

  /* Handle da API Conta Cont†bil */
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint/utb/utb742za.py persistent set h_api_ccusto.

  IF oTipoOperacaoUtil = ? THEN oTipoOperacaoUtil = new rep.utils.TipoOperacaoUtil().

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  /* Code placed here will execute AFTER standard behavior.    */

  find unid-feder where
       docum-est.uf = unid-feder.estado and
       unid-feder.pais = emitente.pais no-lock no-error.
  if avail unid-feder then
     assign gr-unid-feder = rowid(unid-feder).

  find estabelec where
       estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro
  ainda n∆o foi criado.
------------------------------------------------------------------------------*/

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */


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
  {src/adm/template/snd-list.i "docum-est"}

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

