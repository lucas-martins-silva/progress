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
{include/i-prgvrs.i V02IN128 2.00.01.009 } /*** 010109 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in128 MUT}
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
 
def new global shared var gr-movto-estoq as rowid no-undo.
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def var c-conta   like movto-estoq.ct-codigo NO-UNDO.
def var sc-conta   like movto-estoq.sc-codigo NO-UNDO.

def var i-empresa like param-global.empresa-prin no-undo.  /* verificar como vai ficar */
find first param-estoq  no-lock no-error.
find first param-global no-lock no-error.
/* if avail param-global THEN DO:                         */
/*         assign i-empresa = param-global.empresa-prin.  */
/*         &if defined (bf_dis_consiste_conta) &then      */
/*                 {cdp/cd9970.i param-estoq.estabel-pad} */
/*         &endif                                         */
/* END.                                                   */
/***********API FINANCAS****************/
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var p_cod_format_cta_ctbl   as char   no-undo.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR v_des_cta_ctbl        AS CHAR NO-UNDO.
DEF VAR v_num_tip_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_num_sit_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_ind_finalid_cta AS CHAR NO-UNDO.
DEF VAR v_des_ccusto AS CHAR NO-UNDO.


run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contÿbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situa»’o Conta" column-label "Situa»’o Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contÿbil".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".

/***************************************/

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.quantidade ~
movto-estoq.num-ord-inv movto-estoq.saldo-req movto-estoq.nr-ord-produ ~
movto-estoq.lote movto-estoq.dt-trans movto-estoq.dt-nf-saida ~
movto-estoq.nat-operacao movto-estoq.serie-docto movto-estoq.nro-docto ~
movto-estoq.tipo-trans movto-estoq.cod-emitente 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.quantidade ~
movto-estoq.num-ord-inv movto-estoq.saldo-req movto-estoq.nr-ord-produ ~
movto-estoq.cod-localiz movto-estoq.lote movto-estoq.per-ppm ~
movto-estoq.dt-trans movto-estoq.dt-nf-saida movto-estoq.nat-operacao ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.tipo-trans ~
movto-estoq.cod-emitente movto-estoq.ct-codigo movto-estoq.sc-codigo ~
movto-estoq.cod-unid-negoc 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-nr-pedido i-numero-ordem dt-vali-lote ~
c-esp-doc c-emitente c-titulo sc-titulo c-des-unid-negoc c-texto 

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
DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 54.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-esp-doc AS CHARACTER FORMAT "X(25)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedido AS CHARACTER FORMAT "X(12)" 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vali-lote AS DATE FORMAT "99/99/9999" 
     LABEL "Validade Lote":R16 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE sc-titulo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.13.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 12.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.quantidade AT ROW 1.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     movto-estoq.num-ord-inv AT ROW 1.25 COL 63.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-estoq.saldo-req AT ROW 2.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     movto-estoq.nr-ord-produ AT ROW 2.25 COL 63.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     movto-estoq.cod-localiz AT ROW 3.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     c-nr-pedido AT ROW 3.25 COL 63.86 COLON-ALIGNED HELP
          "N£mero do Pedido do Cliente"
     movto-estoq.lote AT ROW 4.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.57 BY .88
     i-numero-ordem AT ROW 4.29 COL 63.86 COLON-ALIGNED
     dt-vali-lote AT ROW 5.25 COL 19 COLON-ALIGNED
     movto-estoq.per-ppm AT ROW 5.25 COL 33.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-esp-doc AT ROW 5.25 COL 63.86 COLON-ALIGNED
     movto-estoq.dt-trans AT ROW 6.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     movto-estoq.dt-nf-saida AT ROW 6.29 COL 63.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     movto-estoq.nat-operacao AT ROW 7.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     movto-estoq.serie-docto AT ROW 8.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-estoq.nro-docto AT ROW 8.25 COL 42 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     movto-estoq.tipo-trans AT ROW 8.38 COL 65.72 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa¡da", 2
          SIZE 12.14 BY 1.5
     movto-estoq.cod-emitente AT ROW 9.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     c-emitente AT ROW 9.25 COL 31 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     movto-estoq.ct-codigo AT ROW 10.25 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-titulo AT ROW 10.25 COL 37.57 COLON-ALIGNED NO-LABEL
     movto-estoq.sc-codigo AT ROW 11.25 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     sc-titulo AT ROW 11.25 COL 37.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     movto-estoq.cod-unid-negoc AT ROW 12.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-des-unid-negoc AT ROW 12.25 COL 25.29 COLON-ALIGNED NO-LABEL
     c-texto AT ROW 7.63 COL 63.29 COLON-ALIGNED NO-LABEL
     "Centro de Custo:" VIEW-AS TEXT
          SIZE 11.57 BY .88 AT ROW 11.25 COL 9 WIDGET-ID 12
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 7.92 COL 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 12.5
         WIDTH              = 84.57.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 12.5
       FRAME f-main:WIDTH            = 84.57.

/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-esp-doc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-pedido IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.ct-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-numero-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.sc-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN sc-titulo IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/
 
{utp/ut-field.i mgind movto-estoq esp-docto 1}
assign c-esp-doc:label in frame {&frame-name} = trim(return-value).
 
{utp/ut-field.i mgind movto-estoq tipo-trans 1}
assign c-texto = trim(return-value).
 
{utp/ut-field.i mgind pedido-compr num-pedido 1}
assign c-nr-pedido:label in frame {&frame-name} = trim(return-value).
 
{utp/ut-field.i mgind movto-estoq numero-ordem 1}
assign i-numero-ordem:label in frame {&frame-name} = trim(return-value).

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

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

    FIND FIRST estabelec 
        WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.
    ASSIGN i-empresa = IF AVAIL estabelec THEN estabelec.ep-codigo ELSE "".
   
    FIND unid-negoc
        WHERE unid-negoc.cod-unid-negoc = movto-estoq.cod-unid-negoc NO-LOCK NO-ERROR.
    ASSIGN c-des-unid-negoc = IF  AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".

    {cdp/cd9970.i movto-estoq.cod-estabel} /* Consiste conta cont bil */
                                                                                        
    ASSIGN c-conta = movto-estoq.ct-codigo
           sc-conta = movto-estoq.sc-codigo.

/*       FIND FIRST conta-contab                                                             */
/*         WHERE conta-contab.ep-codigo      = i-empresa                                     */
/*           AND conta-contab.conta-contabil = movto-estoq.conta-contabil NO-LOCK NO-ERROR.  */
/*     ASSIGN c-titulo = IF  AVAIL conta-contab THEN conta-contab.titulo ELSE "".            */
    /*ASSIGN c-titulo = "TESTE".  v_des_cta_ctbl.   */
   
/*### Formato conta contabil*/


    run pi_retorna_formato_cta_ctbl in h_api_cta (input  i-empresa,                 /* EMPRESA EMS 2 */
                                                  input  "",                 /* PLANO CONTAS */
                                                  input  dt-trans, /* DATA DE TRANSACAO */
                                                  output p_cod_format_cta_ctbl,   /* FORMATO cta */
                                                  output table tt_log_erro). /* ERROS */

    run pi_retorna_formato_ccusto in h_api_ccust (input  i-empresa,                 /* EMPRESA EMS2 */
                                                  input  "",             /* PLANO CCUSTO */
                                                  input  dt-trans,              /* DATA DE TRANSACAO */
                                                  output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                  output table tt_log_erro). /* ERROS */

    run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,                /* EMPRESA EMS2 */
                                                      input        "",            /* PLANO DE CONTAS */
                                                      input-output c-conta,     /* CONTA */
                                                      input        dt-trans,              /* DATA TRANSACAO */
                                                      output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                      output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                      output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                      output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                      output table tt_log_erro).       /* ERROS */

    run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa,                 /* EMPRESA EMS2 */
                                                  input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                  input  sc-conta,            /* CCUSTO */
                                                  input  dt-trans,              /* DATA DE TRANSACAO */
                                                  output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                  output table tt_log_erro). /* ERROS */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
     
    assign movto-estoq.ct-codigo:format IN FRAME f-main = p_cod_format_cta_ctbl
           movto-estoq.sc-codigo:format IN FRAME f-main = p_cod_format_ccusto
           c-titulo:SCREEN-VALUE IN FRAME f-main = v_des_cta_ctbl
           sc-titulo:SCREEN-VALUE IN FRAME f-main = v_des_ccusto.

    /* Code placed here will execute AFTER standard behavior.    */
        
    for first emitente field (cod-emitente nome-abrev) where 
        emitente.cod-emitente = movto-estoq.cod-emitente 
        no-lock: end.
    if  avail emitente then
        assign c-emitente = emitente.nome-abrev.
    disp c-emitente with frame {&frame-name}.
       
    for first saldo-estoq field (cod-depos cod-estabel cod-localiz lote
                                  it-codigo dt-vali-lote ) where 
        saldo-estoq.cod-depos   = movto-estoq.cod-depos   and
        saldo-estoq.cod-estabel = movto-estoq.cod-estabel and
        saldo-estoq.cod-localiz = movto-estoq.cod-localiz and
        saldo-estoq.lote        = movto-estoq.lote        and
        saldo-estoq.it-codigo   = movto-estoq.it-codigo   
        no-lock: end.
    if  avail saldo-estoq then do:
    
    assign dt-vali-lote = saldo-estoq.dt-vali-lote.
    
    disp   dt-vali-lote with frame {&frame-name}.
    end.
    
    for first ordem-compra field (numero-ordem num-pedido) where
        ordem-compra.numero-ordem = movto-estoq.numero-ordem 
        no-lock: end.
    if available ordem-compra then 
       assign c-nr-pedido:screen-value in frame {&frame-name} = 
              string(ordem-compra.num-pedido,"zzzzz,zz9").
    else do:
        for first ord-prod field (nr-ord-produ nr-pedido) where
             ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ 
             no-lock: end.
        if  available ord-prod then
            assign c-nr-pedido:screen-value in frame {&frame-name} = 
                   string(ord-prod.nr-pedido).
    end. 
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-esp-doc:screen-value in frame {&frame-name} = RETURN-VALUE.
    &else
        ASSIGN c-esp-doc:screen-value in frame {&frame-name} = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
    &endif
    
    if  avail movto-estoq then
        disp movto-estoq.numero-ordem @ i-numero-ordem with frame {&frame-name}.

    HIDE movto-estoq.per-ppm IN FRAME {&FRAME-NAME}.
    
    &IF DEFINED (bf_man_per_ppm) &THEN
        if param-global.modulo-per-ppm THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-ERROR.
            IF AVAIL ITEM THEN DO:
                CASE ITEM.tipo-formula:
                    WHEN 2 THEN DO:
                        DISPLAY movto-estoq.per-ppm WITH FRAME {&FRAME-NAME}.
                        ASSIGN  movto-estoq.per-ppm:FORMAT        IN FRAME {&FRAME-NAME} = ">>9.9999":u.
                    END.
                    WHEN 3 THEN DO:
                       DISPLAY movto-estoq.per-ppm WITH FRAME {&FRAME-NAME}.
                       ASSIGN  movto-estoq.per-ppm:FORMAT       IN FRAME {&FRAME-NAME} = ">>>>,>>9.9999":u.
                    END.
                END CASE.
            END.
        END.        
    &ENDIF
    
   
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
 
{utp/ut-field.i mgind movto-estoq esp-docto 1}
assign c-esp-doc:label in frame {&frame-name} = trim(return-value).
 
{utp/ut-field.i mgind movto-estoq tipo-trans 1}
assign c-texto = trim(return-value).
 
{utp/ut-field.i mgind pedido-compr num-pedido 1}
assign c-nr-pedido:label in frame {&frame-name} = trim(return-value).
    
/*DEF VAR cod-conta AS CHAR.
ASSIGN cod-conta = movto-estoq.ct-codigo.
run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,                /* EMPRESA EMS2 */
                                          input        "",            /* PLANO DE CONTAS */
                                          input-output cod-conta,     /* CONTA */
                                          input        today,              /* DATA TRANSACAO */   
                                          output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                          output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                          output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                          output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                          output table tt_log_erro).       /* ERROS */ 
  */

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
  if avail movto-estoq then
      assign gr-movto-estoq = rowid(movto-estoq).
 
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
 
   /*Segue um exemplo de valida‡Æo de programa 
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
  {src/adm/template/snd-list.i "movto-estoq"}

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

