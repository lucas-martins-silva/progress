&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V06IN218 2.00.00.033 } /*** 010033 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V06IN218 MUT}
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

def new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.
def new global shared var c-it-codigo   like item.it-codigo no-undo. 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-saldo for saldo-estoq.

def var dt-inspecao    as date no-undo.
def var c-op-des1      as char no-undo.
def var l-deleta-erros as logical no-undo.

/**************  Unifica»’o de conceitos ****************/
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Variÿveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Variÿveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo. 
/**************  Unifica»’o de conceitos ****************/

def var i-empresa like param-global.empresa-prin no-undo.
def var dt-transacao like movto-estoq.dt-trans no-undo.

{cdp/cdcfgdis.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

{cdp/cd0666.i}

&if "{&bf_mat_versao_ems}" >= "2.062" &then

    {cdp/cd9590.i} /*** Variaveis unidade negocio ***/

    {cep/ceapi001k.i}

    DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
    DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
&ELSE
    {cep/ceapi001.i}
&ENDIF

DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

def var c-cod-deposito      as char    no-undo.
def var c-cod-localizacao   as char    no-undo.
def var l-loc-unica         as log     no-undo.

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
&Scoped-define EXTERNAL-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq, item, saldo-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.dt-trans movto-estoq.ct-codigo ~
movto-estoq.sc-codigo movto-estoq.cod-depos movto-estoq.un 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-cod-unid-negoc 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans movto-estoq.nro-docto ~
movto-estoq.serie-docto movto-estoq.ct-codigo movto-estoq.sc-codigo ~
movto-estoq.it-codigo item.desc-item movto-estoq.cod-estabel ~
movto-estoq.cod-depos item.cod-localiz movto-estoq.cod-localiz ~
movto-estoq.lote saldo-estoq.dt-vali-lote movto-estoq.cod-refer ~
movto-estoq.quantidade movto-estoq.un 
&Scoped-define DISPLAYED-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-define SECOND-DISPLAYED-TABLE item
&Scoped-define THIRD-DISPLAYED-TABLE saldo-estoq
&Scoped-Define DISPLAYED-OBJECTS c-cod-unid-negoc i-per-ppm 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-depos 
       MENU-ITEM mZoomDep       LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-localiz 
       MENU-ITEM mZoomLoc       LABEL "Zoom de Localiza‡Æo"
       MENU-ITEM mZoomSalLoc    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-refer 
       MENU-ITEM mZoomRef       LABEL "Zoom de Referˆncia"
       MENU-ITEM mZoomSalRef    LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-per-ppm AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Concentracao/Ppm" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 11.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.17 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.nro-docto AT ROW 2.17 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     movto-estoq.serie-docto AT ROW 2.17 COL 44.43 COLON-ALIGNED
          LABEL "S‚rie"
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     movto-estoq.ct-codigo AT ROW 3.17 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     movto-estoq.sc-codigo AT ROW 4.21 COL 17.72 COLON-ALIGNED
          LABEL "Centro Custo"
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     c-cod-unid-negoc AT ROW 5.17 COL 17.72 COLON-ALIGNED
     movto-estoq.it-codigo AT ROW 6.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 7.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 58.43 BY .88
     movto-estoq.cod-estabel AT ROW 8.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     movto-estoq.cod-depos AT ROW 9.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     item.cod-localiz AT ROW 10.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.cod-localiz AT ROW 11.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.lote AT ROW 12.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     saldo-estoq.dt-vali-lote AT ROW 13.42 COL 17.72 COLON-ALIGNED
          LABEL "":R29
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     i-per-ppm AT ROW 14.42 COL 17.72 COLON-ALIGNED HELP
          "Fator de Concentra‡Æo / Ppm"
     movto-estoq.cod-refer AT ROW 15.42 COL 17.72 COLON-ALIGNED
          LABEL "":R12
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     movto-estoq.quantidade AT ROW 16.42 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     movto-estoq.un AT ROW 16.42 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 6.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-estoq,mgind.item,mgind.saldo-estoq
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
         HEIGHT             = 16.5
         WIDTH              = 77.86.
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

ASSIGN 
       c-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       movto-estoq.cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN item.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       movto-estoq.cod-refer:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.dt-vali-lote IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN i-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.nro-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.quantidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.sc-codigo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON F5 OF c-cod-unid-negoc IN FRAME f-main
DO:

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="c-cod-unid-negoc"
                             &Frame1="{&frame-name}"
                             &EnableImplant="NO"}
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON F5 OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-depos
        &campo2     = movto-estoq.cod-localiz
        &campo3     = movto-estoq.lote
        &campo4     = movto-estoq.cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-localiz
        &campozoom  = cod-localiz
        &campo2     = movto-estoq.cod-depos
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.lote
        &campozoom3 = lote
        &campo4     = movto-estoq.cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON F5 OF movto-estoq.cod-refer IN FRAME f-main
DO:
  &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-localiz
        &campozoom  = cod-localiz
        &campo2     = movto-estoq.cod-depos
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.lote
        &campozoom3 = lote
        &campo4     = movto-estoq.cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-refer IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON ENTRY OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  ASSIGN movto-estoq.ct-codigo:FORMAT in frame {&FRAME-NAME} = "x(20)".
  ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON F5 OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
   assign l-implanta = yes.
                     
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M…DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  INPUT movto-estoq.dt-trans, /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   if return-value = "OK" then
       ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON LEAVE OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
    assign self:format = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT movto-estoq.ct-codigo.

    /* Busca dados da conta contÙbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        INPUT movto-estoq.dt-trans, /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  INPUT movto-estoq.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  INPUT movto-estoq.dt-trans, /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
            DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON LEAVE OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:

 if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
    find first saldo-estoq use-index lote
         where saldo-estoq.lote      = input frame {&frame-name} movto-estoq.lote
         and   saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
    if  avail saldo-estoq then 
        disp saldo-estoq.dt-vali-lote @ saldo-estoq.dt-vali-lote with frame {&frame-name}.
 end.

 &if defined (bf_man_per_ppm) &then
    if item.tipo-con-est = 3 AND ITEM.tipo-formula = 2 OR ITEM.tipo-formula = 3  then do: /* lote */
       find first b-saldo
           where  b-saldo.it-codigo   = movto-estoq.it-codigo:SCREEN-VALUE IN frame {&frame-name} 
           and    b-saldo.lote        = movto-estoq.lote:SCREEN-VALUE IN frame {&frame-name}  
           /*and    b-saldo.cod-depos  <> movto-estoq.cod-depos:SCREEN-VALUE IN frame {&frame-name} */
           no-lock no-error.
       if  avail b-saldo then do:
           ASSIGN i-per-ppm = b-saldo.per-ppm.      
           disp b-saldo.per-ppm @ i-per-ppm with frame {&frame-name}.
           disable i-per-ppm with frame {&frame-name}.
       end.  
       /*
       else do:
           ASSIGN i-per-ppm = ITEM.per-ppm.
           DISP ITEM.per-ppm @ i-per-ppm WITH FRAME {&frame-name}.
           disable i-per-ppm with frame {&frame-name}.
       end.
       */
    end.
    ELSE DO:
      ASSIGN i-per-ppm = 0.
      DISP    i-per-ppm WITH FRAME {&frame-name}.
      disable i-per-ppm with frame {&frame-name}.
    END.
 &endif



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDep /* Zoom de Dep¢sitos */
DO:
      {include/zoom.i &prog-zoom="inzoom/z01in084.w"
                    &tabela=movto-estoq
                    &atributo=cod-depos}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLoc /* Zoom de Localiza‡Æo */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} movto-estoq.cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    {include/zoom.i
        &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomRef /* Zoom de Referˆncia */
DO:
  {include/zoomvar.i &prog-zoom = inzoom/z01in377.w
                     &campo     = movto-estoq.cod-refer
                     &campozoom = cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
  apply "F5" to movto-estoq.cod-depos in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLoc /* Zoom de Saldos */
DO:
  apply "F5" to movto-estoq.cod-localiz in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRef /* Zoom de Saldos */
DO:
  apply "F5" to movto-estoq.cod-refer in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rt-key
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rt-key V-table-Win
ON MOUSE-SELECT-CLICK OF rt-key IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON F5 OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
   IF v_log_utz_ccusto THEN DO:
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input INPUT movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
       
       if return-value = "OK" then
           ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto.       
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON LEAVE OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                   &tabela=movto-estoq
                   &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  apply 'F5' to self.
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

{utp/ut-liter.i Conta * L}
assign movto-estoq.ct-codigo:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Centro_Custo * L}
assign movto-estoq.sc-codigo:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Localiza‡Æo_PadrÆo MCQ L}
assign item.cod-localiz:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Data_de_Validade MCQ L}
assign saldo-estoq.dt-vali-lote:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Referˆncia MCQ L}
assign movto-estoq.cod-refer:label in frame {&frame-name} = trim(return-value).

if movto-estoq.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if movto-estoq.ct-codigo:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
if movto-estoq.sc-codigo:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
if movto-estoq.cod-depos:load-mouse-pointer   ("image~\rbm.cur") in frame {&frame-name} then.
if movto-estoq.cod-refer:load-mouse-pointer   ("image~\rbm.cur") in frame {&frame-name} then.
if movto-estoq.cod-localiz:load-mouse-pointer ("image~\rbm.cur") in frame {&frame-name} then.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
{utp/ut-liter.i Unidade_de_Neg¢cio * L}
ASSIGN c-cod-unid-negoc:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

c-cod-unid-negoc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
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
  {src/adm/template/row-list.i "movto-estoq"}
  {src/adm/template/row-list.i "item"}
  {src/adm/template/row-list.i "saldo-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "saldo-estoq"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    
        IF  VALID-HANDLE(h-ceapi001k) THEN DELETE PROCEDURE h-ceapi001k.
        IF  VALID-HANDLE(h-cdapi024)  THEN RUN pi-finalizar IN h-cdapi024.

        ASSIGN h-ceapi001k = ?
               h-cdapi024  = ?.
    &endif

  IF  VALID-HANDLE(h_api_cta_ctbl) THEN delete object h_api_cta_ctbl.
  IF  VALID-HANDLE(h_api_ccusto)   THEN delete object h_api_ccusto.

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

  find first param-global no-lock no-error.
  find first param-cq     no-lock no-error.
  find first param-estoq  no-lock no-error.

  &if defined(bf_dis_default_UN) &then
      FIND FIRST param-mat    NO-LOCK NO-ERROR.
  &endif

  find item where item.it-codigo = ficha-cq.it-codigo no-lock no-error.
  find estabelec where estabelec.cod-estabel = ficha-cq.cod-estabel no-lock no-error.

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      RUN cep/ceapi014.p (input ficha-cq.it-codigo,
                          INPUT ficha-cq.cod-estabel,
                          OUTPUT c-cod-deposito,
                          OUTPUT c-cod-localizacao,
                          OUTPUT l-loc-unica).

      disp c-cod-localizacao @ item.cod-localiz
           with frame {&frame-name}.
  &ELSE
      disp item.cod-localiz
           with frame {&frame-name}.
  &ENDIF
  
  disp ficha-cq.serie-docto                            @ movto-estoq.serie-docto
       ficha-cq.nro-docto                              @ movto-estoq.nro-docto
       dt-inspecao                                     @ movto-estoq.dt-trans
       ficha-cq.it-codigo                              @ movto-estoq.it-codigo
       item.desc-item                                   
       ficha-cq.cod-estabel                            @ movto-estoq.cod-estabel
       estabelec.dep-rej-cq                            @ movto-estoq.cod-depos
       &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN 
           &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                ficha-cq.cod-refer                         @ movto-estoq.cod-refer
           &ELSE 
                substr(ficha-cq.char-1,1,8)                @ movto-estoq.cod-refer
           &ENDIF
       &ENDIF
       ficha-cq.cod-localiz                            @ movto-estoq.cod-localiz
       ficha-cq.lote                                   @ movto-estoq.lote with frame {&frame-name}.

  &if defined(bf_dis_default_UN) &then
      IF AVAIL param-mat AND param-mat.ind-sit-un = 2 THEN /*unidade de medida default do item*/
          DISP ITEM.un       @ movto-estoq.un WITH FRAME {&FRAME-NAME}.
  &endif

  &if defined (bf_man_per_ppm) &then    
      ASSIGN i-per-ppm = ficha-cq.per-ppm.
      DISP   i-per-ppm  with frame {&frame-name}.
      DISABLE i-per-ppm with frame {&frame-name}.
  &endif

  if  item.tipo-contr <> 4 then do:
      if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
      enable movto-estoq.lote
              movto-estoq.cod-refer with frame {&frame-name}.

          find first b-saldo use-index lote
              where b-saldo.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
              and   b-saldo.lote      = input frame {&frame-name} movto-estoq.lote
              no-lock no-error.
          if  avail b-saldo THEN DO:
              disp b-saldo.dt-vali-lote @ saldo-estoq.dt-vali-lote
                   &IF "{&bf_mat_versao_ems}" < "2.04" &THEN
                        b-saldo.cod-refer    @ movto-estoq.cod-refer
                   &ENDIF
                   with frame {&frame-name}.
              &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
                   IF  INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer = "" THEN
                       DISP b-saldo.cod-refer    @ movto-estoq.cod-refer
                            WITH FRAME {&FRAME-NAME}.
              &ENDIF
          END.
      end.
  end.

  if  item.tipo-con-est = 2
      then disp 1 @ movto-estoq.quantidade with frame {&frame-name}.
      else disp 0 @ movto-estoq.quantidade with frame {&frame-name}.
  if  item.tipo-con-est <> 2 then
      enable movto-estoq.quantidade with frame {&frame-name}.
  if  input frame {&frame-name} movto-estoq.serie-docto = "" then
      enable movto-estoq.serie-docto with frame {&frame-name}.
  if  input frame {&frame-name} movto-estoq.nro-docto = "" then
      enable movto-estoq.nro-docto with frame {&frame-name}.
  enable movto-estoq.dt-trans with frame {&frame-name}.
  enable movto-estoq.cod-localiz with frame {&frame-name}.

  &if defined (bf_man_per_ppm) &then    

    if item.tipo-con-est = 3 then do: /* lote */
       IF ITEM.TIPO-FORMULA = 1 THEN ASSIGN I-PER-PPM:LABEL in frame {&frame-name} = 'NÆo Utiliza'.
       IF ITEM.tipo-formula = 4 THEN ASSIGN i-per-ppm:LABEL IN FRAME {&frame-name} = 'Ve¡culo'.
       IF ITEM.tipo-formula = 2 THEN DO:
           ASSIGN i-per-ppm:FORMAT             IN FRAME {&frame-name} = ">>9.9999".
           ASSIGN i-per-ppm:LABEL              in frame {&frame-name} = 'Concentra‡Æo(%)'.
       END.
       IF ITEM.tipo-formula = 3 THEN DO:
          ASSIGN i-per-ppm:LABEL in frame {&frame-name} = 'PPM'.
       END.
       ASSIGN i-per-ppm = ficha-cq.per-ppm.
       DISPLAY i-per-ppm with frame {&frame-name}.
    END.
  &endif

    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN

        DISABLE movto-estoq.cod-refer with frame {&frame-name}.

        /* HABILITA OS CAMPOS SE NECESSARIO */
        IF item.tipo-con-est = 4 THEN DO:
            IF substr(param-estoq.char-2,1,1) = "#" THEN
                ENABLE movto-estoq.cod-refer with frame {&frame-name}.

            FIND FIRST saldo-estoq
                WHERE saldo-estoq.it-codigo = ficha-cq.it-codigo
                AND   saldo-estoq.lote      = ficha-cq.lote
                NO-LOCK NO-ERROR.
            IF NOT AVAIL saldo-estoq THEN
                ENABLE movto-estoq.cod-refer with frame {&frame-name}.
        END.
    &ENDIF

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
      
        ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = NO
               c-cod-unid-negoc = "".

        /*** Somente sugere unidade de neg¢cio se a empresa utiliza unidade de neg¢cio. ***/
        IF  l-unidade-negocio = YES
        AND l-mat-unid-negoc  = YES THEN DO:
            IF  ficha-cq.nr-ord-produ <> 0 THEN DO:
                FIND ord-prod
                    WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ NO-LOCK NO-ERROR.
                IF  AVAIL ord-prod THEN
                    ASSIGN c-cod-unid-negoc = ord-prod.cod-unid-negoc.
            END.

            IF  ficha-cq.nr-ord-produ = 0
            OR  c-cod-unid-negoc      = "" THEN DO:
                IF  VALID-HANDLE(h-cdapi024) THEN
                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT ficha-cq.cod-estabel,
                                                             INPUT ficha-cq.it-codigo,
                                                             INPUT ficha-cq.cod-depos,
                                                             OUTPUT c-cod-unid-negoc).
            END.
        END.

        ASSIGN c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-unid-negoc.

        /* Habilita o campo se utilizar unidade de negocio e se a ficha de cq nÆo for via Ordem de Produ‡Æo */
        IF  l-unidade-negocio = YES
        AND l-mat-unid-negoc  = YES
        AND ficha-cq.nr-ord-produ = 0 THEN
            ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE 
            ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &else
        ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    &endif


    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        run pi-atualiza-formatos.
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


    &if defined (bf_man_per_ppm) &then    
    &else
        ASSIGN i-per-ppm:HIDDEN IN FRAME f-main = YES.
    &endif

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    
        IF  NOT VALID-HANDLE(h-ceapi001k) THEN
            RUN cep/ceapi001k.p persistent set h-ceapi001k.

        IF  NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p persistent set h-cdapi024.

        ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = NO.
    &else
        ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    &endif

    /* Handle da API Conta Contÿbil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-formatos V-table-Win 
PROCEDURE pi-atualiza-formatos :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  input frame {&frame-name} movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  input frame {&frame-name} movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */ 

    /* Formatando conta e centro de custo */
    if c-formato-conta <> "" then do:
        assign movto-estoq.ct-codigo:format  in frame {&FRAME-NAME} = c-formato-conta.
    end.
    if c-formato-ccusto <> "" then do:
        assign movto-estoq.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
    end. 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno V-table-Win 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param r-ficha-cq  as rowid no-undo.
  def input param de-inspecao as date  no-undo.

  assign dt-inspecao = de-inspecao.

  find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
  if avail ficha-cq then run local-enable-fields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica V-table-Win 
PROCEDURE pi-verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param r-ficha-cq      as rowid   no-undo.
    def input  param de-qt-a-liberar as decimal no-undo.
    def output param de-qt-ant       as decimal no-undo.

    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.
    def var de-saldo      as integer no-undo.
    def var de-quantid    as decimal no-undo.
    def var de-aux        as decimal no-undo.

    find first param-global no-lock no-error.
    find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
    find item
        where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo no-lock no-error.

    find saldo-estoq use-index estabel-dep
         where saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
         and   saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
         and   saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
         and   saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
         and   saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
         and   saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
         no-lock no-error.
    if  not avail saldo-estoq then do:
        if  item.perm-saldo-neg = 0 then do:
            run utp/ut-msgs.p (input "show", input 1628, input "").
            return error.
        end.
        if  item.perm-saldo-neg = 1 then do:
            assign de-saldo = 0.
            run utp/ut-msgs.p (input "show", input 1629, input string(de-saldo)).
            if  return-value = 'no' then return error.
        end.
        create saldo-estoq.
        assign saldo-estoq.cod-estabel  = input frame {&frame-name} movto-estoq.cod-estabel
               saldo-estoq.cod-depos    = input frame {&frame-name} movto-estoq.cod-depos
               saldo-estoq.cod-localiz  = input frame {&frame-name} movto-estoq.cod-localiz
               saldo-estoq.lote         = input frame {&frame-name} movto-estoq.lote
               saldo-estoq.it-codigo    = input frame {&frame-name} movto-estoq.it-codigo
               saldo-estoq.cod-refer    = input frame {&frame-name} movto-estoq.cod-refer
               saldo-estoq.dt-vali-lote = input frame {&frame-name} saldo-estoq.dt-vali-lote.
    end.
    else do:
         if  input frame {&frame-name} movto-estoq.quantidade > saldo-estoq.qtidade-atu then do:
             if  item.perm-saldo-neg = 0 then do:
                 run utp/ut-msgs.p (input "show", input 1630, input "").
                 return error.
             end.
             if  item.perm-saldo-neg = 1 then do:
                 assign de-saldo = (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada
                                 -  saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).
                 run utp/ut-msgs.p (input "show", input 1629, input string(de-saldo)).
                 if  return-value = 'no' then return error.
             end.
         end.
    end.

    assign i-empresa = param-global.empresa-prin.

    find estabelec where
         estabelec.cod-estabel = saldo-estoq.cod-estabel no-lock no-error.
    if avail estabelec then
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

    assign dt-transacao = input frame {&frame-name} movto-estoq.dt-trans.
    assign v_cod_cta_ctbl = input frame {&frame-name} movto-estoq.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        dt-transacao,       /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */ 
    
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).     
        apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}.
        return error.              
    end.
    
    if  v_num_sit_cta_ctbl <> 3 then do:
        run utp/ut-msgs.p (input "show", input 21, input "").
        apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}. 
        return error.
    end.
    /* if  lookup(string(conta -contab.estoque),"1,2,3,5,6") = 0 then do: */
    if  lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and
        lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 and
        lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) = 0 and
        lookup({adinc/i05ad049.i 4 5}, v_ind_finalid_cta) = 0 and
        lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) = 0 then do:
        
        run utp/ut-msgs.p (input "show", input 107, input "").
        apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}.
        return error.
    end.

    /* Verifica se a conta utiliza centro de custo */
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  saldo-estoq.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  dt-transacao,       /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    
    /* Conta utiliza centro de custo? */
    if v_log_utz_ccusto then do:
        /* Busca dados do centro de custo */
        assign v_cod_ccusto = input frame {&frame-name} movto-estoq.sc-codigo.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  dt-transacao,       /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).     
            apply 'entry' to movto-estoq.sc-codigo in frame {&frame-name}.
            return error.              
        end.                                              
    end.                                           

    if (item.tipo-contr = 4 or item.tipo-contr = 1 or item.it-codigo = "")
    and ficha-cq.nat-operacao <> "" then do:
        find first item-doc-est
            {cdp/cd8900.i "item-doc-est" "ficha-cq"}
            and item-doc-est.nr-ficha = ficha-cq.nr-ficha no-lock no-error.
        if  not avail item-doc-est then do:
            run utp/ut-msgs.p (input "show", input 1367, input "").
            return error.
        end.
    end.
    if input frame {&frame-name} movto-estoq.quantidade <= 0 then do:
       run utp/ut-msgs.p (input "show",input 1368,input "").
       apply 'entry' to movto-estoq.quantidade in frame {&frame-name}. 
       return error.
    end.

    if  not item.fraciona
    and input frame {&frame-name} movto-estoq.quantidade
     <> int(input frame {&frame-name} movto-estoq.quantidade) then do:
        run utp/ut-msgs.p (input "show", input 1304, input "").
        return error.
    end.

    if  de-qt-a-liberar < input frame {&frame-name} movto-estoq.quantidade then do:
        run utp/ut-msgs.p (input "show", input 1630, input "").
        return error.
    end.

    if  (item.tipo-contr = 4 or item.tipo-contr = 1 or item.it-codigo = "")
    and ficha-cq.nat-operacao <> " "
    and input frame {&frame-name} movto-estoq.un <> item-doc-est.un then do:
        run utp/ut-msgs.p (input "show", input 1225, input "").
        return error.
    end.
    if  item.tipo-contr <> 4 and item.tipo-contr <> 1 and item.it-codigo <> ""
    and input frame {&frame-name} movto-estoq.un <> item.un then do:
        run utp/ut-msgs.p (input "show", input 1225, input "").
        return error.
    end.
    /* VALIDA REFERENCIA */
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        IF item.tipo-con-est = 4 THEN DO:
            IF NOT CAN-FIND(FIRST ref-item
                            WHERE ref-item.it-codigo = item.it-codigo
                            AND   ref-item.cod-refer = input frame {&frame-name} movto-estoq.cod-refer
                            NO-LOCK) THEN DO:
                RUN utp/ut-msgs.p (input "show", 
                                   INPUT 529, 
                                   input frame {&frame-name} movto-estoq.cod-refer
                                  ).
                APPLY 'entry' TO movto-estoq.cod-refer IN FRAME {&frame-name}.
                RETURN ERROR.
            END.
        END.
    &ENDIF

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
             
        IF  l-unidade-negocio = YES
        AND l-mat-unid-negoc  = YES
        AND ficha-cq.nr-ord-produ = 0 THEN DO:
            IF  NOT CAN-FIND(FIRST unid-negoc
                             WHERE unid-negoc.cod-unid-negoc = INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc) THEN DO:
                {utp/ut-liter.i Unidade_Neg¢cio * R}
                run utp/ut-msgs.p (input "show", input 2, input return-value).
                return error. 
            END.
        END.
    &endif

    if  item.tipo-contr = 4 or item.tipo-contr = 1 or item.it-codigo = "" then do:
        create tt-movto.
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
               tt-movto.serie-docto    = input frame {&frame-name} movto-estoq.serie-docto
               tt-movto.nro-docto      = input frame {&frame-name} movto-estoq.nro-docto
               tt-movto.ct-codigo      = input frame {&frame-name} movto-estoq.ct-codigo
               tt-movto.sc-codigo      = input frame {&frame-name} movto-estoq.sc-codigo
               tt-movto.it-codigo      = input frame {&frame-name} movto-estoq.it-codigo
               tt-movto.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
               tt-movto.cod-depos      = input frame {&frame-name} movto-estoq.cod-depos
               tt-movto.cod-localiz    = input frame {&frame-name} movto-estoq.cod-localiz
               tt-movto.lote           = input frame {&frame-name} movto-estoq.lote
               tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
               tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
               tt-movto.un             = if ficha-cq.nat-operacao <> ""
                                            then item-doc-est.un else item.un
               tt-movto.tipo-trans     = 2
               tt-movto.esp-docto      = 28
               tt-movto.descricao-db   = ficha-cq.narrativa
               tt-movto.cod-prog-orig  = "v06in218"
               tt-movto.cod-emitente   = tt-movto.cod-emitente
               tt-movto.usuario        = c-seg-usuario
               &if "{&bf_mat_versao_ems}" >= "2.062" &then
               tt-movto.cod-unid-negoc = IF  l-unidade-negocio AND l-mat-unid-negoc 
                                         THEN INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc 
                                         ELSE ""
               &endif
               l-deleta-erros          = yes.

        &if defined (bf_man_per_ppm) &then    
           ASSIGN tt-movto.per-ppm     = input frame {&frame-name} i-per-ppm.
        &endif

        &if "{&bf_mat_versao_ems}" >= "2.062" &then
            IF  VALID-HANDLE (h-ceapi001k) THEN
                RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                               input-output table tt-erro, 
                                               input        l-deleta-erros).
        &ELSE
            run cep/ceapi001.p (input-output table tt-movto,
                                input-output table tt-erro, 
                                input        l-deleta-erros).
        &ENDIF

        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSISTÒNCIAS DE CRIA€ÇO DO MOVTO-ESTOQ */
        find first tt-erro no-error.
        if  avail tt-erro then run cdp/cd0666.w (input table tt-erro).

        /* Localiza o movimento de estoque gerado, se nÆo houve erro */
        find first tt-movto no-error.
        find movto-estoq where rowid(movto-estoq) = r-mov-inv no-lock no-error.
        if  not avail movto-estoq then return 'adm-error'.
    end.
    else do:
        create tt-movto.
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
               tt-movto.serie-docto    = input frame {&frame-name} movto-estoq.serie-docto
               tt-movto.nro-docto      = input frame {&frame-name} movto-estoq.nro-docto
               tt-movto.ct-codigo      = input frame {&frame-name} movto-estoq.ct-codigo
               tt-movto.sc-codigo      = input frame {&frame-name} movto-estoq.sc-codigo
               tt-movto.it-codigo      = input frame {&frame-name} movto-estoq.it-codigo
               tt-movto.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
               tt-movto.cod-depos      = input frame {&frame-name} movto-estoq.cod-depos
               tt-movto.cod-localiz    = input frame {&frame-name} movto-estoq.cod-localiz
               tt-movto.lote           = input frame {&frame-name} movto-estoq.lote
               tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
               tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
               tt-movto.un             = input frame {&frame-name} movto-estoq.un
               tt-movto.tipo-trans     = 2
               tt-movto.esp-docto      = 28
               tt-movto.descricao-db   = ficha-cq.narrativa
               tt-movto.cod-prog-orig  = "v06in218"
               tt-movto.usuario        = c-seg-usuario
               tt-movto.cod-emitente   = ficha-cq.cod-emitente
               &if "{&bf_mat_versao_ems}" >= "2.062" &then
               tt-movto.cod-unid-negoc = IF  l-unidade-negocio AND l-mat-unid-negoc THEN INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc ELSE ""
               &endif
               l-deleta-erros          = no.

        &if defined (bf_man_per_ppm) &then    
           ASSIGN tt-movto.per-ppm     = input frame {&frame-name} i-per-ppm .
        &endif

        &if "{&bf_mat_versao_ems}" >= "2.062" &then
            IF  VALID-HANDLE (h-ceapi001k) THEN
                RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                               input-output table tt-erro, 
                                               input        l-deleta-erros).
        &ELSE
            run cep/ceapi001.p (input-output table tt-movto,
                                input-output table tt-erro, 
                                input        l-deleta-erros).
        &ENDIF

        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSISTÒNCIAS DE CRIA€ÇO DO MOVTO-ESTOQ */
        find first tt-erro no-error.
        if  avail tt-erro then do:
            run cdp/cd0666.w (input table tt-erro).
            return 'adm-error'.
        end.

        /* Localiza o movimento de estoque gerado, se nÆo houve erro */
        find first tt-movto no-error.
        find movto-estoq where rowid(movto-estoq) = tt-movto.r-mov-inv no-lock no-error.
        if  not avail movto-estoq then return 'adm-error'.

        run cdp/cd9750.p (input rowid(movto-estoq)). /* atualiza consumo */

        assign i-empresa = param-global.empresa-prin.

        find estabelec where
             estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).

        /* Busca finalidade da conta na api de financas */
        assign v_cod_cta_ctbl = input frame {&frame-name} movto-estoq.ct-codigo.
        run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,             /* EMPRESA EMS2 */
                                                              input  "CEP",                 /* MODULO */
                                                              input  "",                    /* PLANO DE CONTAS */
                                                              input  v_cod_cta_ctbl,        /* CONTA */
                                                              input  dt-transacao,          /* DATA TRANSACAO */   
                                                              output v_ind_finalid_cta,     /* FINALIDADES DA CONTA */
                                                              output table tt_log_erro).    /* ERROS */
        
        if return-value = "OK" then do:
            if (v_ind_finalid_cta = {adinc/i05ad049.i 4 1} or
                v_ind_finalid_cta = {adinc/i05ad049.i 4 3} or
                v_ind_finalid_cta = {adinc/i05ad049.i 4 6})  
            and movto-estoq.tipo-trans = 2
            and (item.data-ult-sai = ?   or item.data-ult-sai < movto-estoq.dt-trans) then
                assign item.data-ult-sai = movto-estoq.dt-trans.
        end.

    end.  
    assign ficha-cq.qt-a-liberar = ficha-cq.qt-a-liberar
                                 - input frame {&frame-name} movto-estoq.quantidade.

    if  ficha-cq.qt-a-liberar = 0 and ficha-cq.inspecionado then
        assign ficha-cq.liberada = yes.

    if  input frame {&frame-name} movto-estoq.dt-trans > ficha-cq.dt-inspecao
    or  ficha-cq.dt-inspecao = ? then
        assign ficha-cq.dt-inspecao = input frame {&frame-name} movto-estoq.dt-trans.

    assign de-quantid = input frame {&frame-name} movto-estoq.quantidade
           de-qt-ant  = input frame {&frame-name} movto-estoq.quantidade.

    for each rej-ficha
        where rej-ficha.nr-ficha   = ficha-cq.nr-ficha
        and   rej-ficha.dep-rej    = input frame {&frame-name} movto-estoq.cod-depos
        and   rej-ficha.quant-rej  > 0 exclusive-lock:

        if  rej-ficha.quant-rej <= de-quantid then
            assign de-aux              = rej-ficha.quant-rej
                   rej-ficha.quant-rej = 0
                   de-quantid          = de-quantid - de-aux.

        if  rej-ficha.quant-rej > de-quantid then do:
            assign rej-ficha.quant-rej = rej-ficha.quant-rej - de-quantid.
            leave.
        end.
    end.

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
  {src/adm/template/snd-list.i "movto-estoq"}
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "saldo-estoq"}

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

