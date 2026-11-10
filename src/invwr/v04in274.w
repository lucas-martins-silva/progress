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
{include/i-prgvrs.i V04IN274 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in274 MUT}
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

{include/i-vrtab.i moeda}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{ccp/cc9999.i}
{cdp/cdcfgmat.i}

def new shared var l-preco-bruto as logical no-undo.

def var de-val-orig         as decimal   no-undo format ">>>>>>>>>>>>>>9,99".
def var date-data           as date      no-undo.
def var da-data             as date      no-undo.
def var h_api_ccusto        as handle    no-undo.
def var v_cod_ccusto        as character no-undo.
def var v_des_ccusto        as character no-undo.
def var h_api_cta_ctbl      as handle    no-undo.
def var v_cod_cta_ctbl      as char      no-undo.
def var v_des_cta_ctbl      as character no-undo.
def var v_num_tip_cta_ctbl  as char      no-undo. 
def var v_num_sit_cta_ctbl  as char      no-undo. 
def var v_ind_finalid_cta   as char      no-undo. 
def var v_cod_formato       as char      no-undo.
def var c-empresa           as character no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro      as integer format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda     as character format "x(40)"  label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro      as character format "x(60)"  label "Mensagem Erro"   column-label "Inconsistˆncia".

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
&Scoped-define EXTERNAL-TABLES ordem-compra
&Scoped-define FIRST-EXTERNAL-TABLE ordem-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ordem-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ordem-compra.tp-despesa 
&Scoped-define ENABLED-TABLES ordem-compra
&Scoped-define FIRST-ENABLED-TABLE ordem-compra
&Scoped-Define ENABLED-OBJECTS RECT-9 
&Scoped-Define DISPLAYED-FIELDS ordem-compra.tp-despesa ~
ordem-compra.cod-unid-negoc 
&Scoped-define DISPLAYED-TABLES ordem-compra
&Scoped-define FIRST-DISPLAYED-TABLE ordem-compra
&Scoped-Define DISPLAYED-OBJECTS i-mo-codigo c-desc-moeda de-preco ~
c-natureza de-aliquota-ipi c-situacao de-valor-ipi c-origem de-preco-unit ~
fi-tp-despesa de-preco-orig c-numero-nota tb-expect date-data-movto ~
c-ct-codigo c-desc-ct c-sc-codigo c-desc-sc c-des-unid-negoc ~
c-cod-estab-gestor fi-estabel-gestor 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-expect c-cod-estab-gestor 
&Scoped-define ADM-ASSIGN-FIELDS tb-expect c-cod-estab-gestor 
&Scoped-define ADM-MODIFY-FIELDS tb-expect c-cod-estab-gestor 

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
DEFINE VARIABLE c-cod-estab-gestor LIKE estabelec.cod-estabel
     LABEL "Estab Gestor":R13 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ct AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(14)" INITIAL "1" 
     LABEL "Natureza":R10 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-numero-nota AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R20 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER FORMAT "X(12)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(14)" INITIAL "1" 
     LABEL "Situa‡Æo":R10 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE date-data-movto AS DATE FORMAT "99/99/9999" 
     LABEL "Data Movimento":R21 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliquota-ipi AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Aliquota IPI" 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.
                                            
DEFINE VARIABLE de-preco AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o" 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-orig AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o Origem" 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-unit AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Preco Unit" 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-ipi AS DECIMAL FORMAT ">>>>>>,>>9.99999":U INITIAL 0 
     LABEL "Valor IPI" 
     VIEW-AS FILL-IN 
     SIZE 16.50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-gestor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-despesa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 10.46.

DEFINE VARIABLE tb-expect AS LOGICAL INITIAL no 
     LABEL "Expect. Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-mo-codigo AT ROW 1.25 COL 18.14 COLON-ALIGNED
     c-desc-moeda AT ROW 1.25 COL 22 COLON-ALIGNED NO-LABEL
     de-preco AT ROW 1.25 COL 65.40 COLON-ALIGNED
     c-natureza AT ROW 2.25 COL 18.14 COLON-ALIGNED HELP
          "~"C~" = Compra/~"S~" = Servico/~"B~" = Beneficiamento"
     de-aliquota-ipi AT ROW 2.25 COL 65.40 COLON-ALIGNED
     c-situacao AT ROW 3.25 COL 18.14 COLON-ALIGNED HELP
          "N=Nao Confirm/C=Confirm/T=Cotada/E=Elimin/M=Em Cotacao/R=Termin"
     de-valor-ipi AT ROW 3.25 COL 65.40 COLON-ALIGNED
     c-origem AT ROW 4.25 COL 18.14 COLON-ALIGNED
     de-preco-unit AT ROW 4.25 COL 65.40 COLON-ALIGNED
     ordem-compra.tp-despesa AT ROW 5.25 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-tp-despesa AT ROW 5.25 COL 23.29 COLON-ALIGNED NO-LABEL
     de-preco-orig AT ROW 5.25 COL 65.40 COLON-ALIGNED
     c-numero-nota AT ROW 6.25 COL 18.14 COLON-ALIGNED
     tb-expect AT ROW 6.25 COL 37.14
     date-data-movto AT ROW 6.25 COL 65.40 COLON-ALIGNED
     c-ct-codigo AT ROW 7.25 COL 18.14 COLON-ALIGNED
     c-desc-ct AT ROW 7.25 COL 35 COLON-ALIGNED NO-LABEL
     c-sc-codigo AT ROW 8.25 COL 18.14 COLON-ALIGNED
     c-desc-sc AT ROW 8.25 COL 35 COLON-ALIGNED NO-LABEL
     ordem-compra.cod-unid-negoc AT ROW 9.25 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     c-des-unid-negoc AT ROW 9.25 COL 25 COLON-ALIGNED NO-LABEL
     c-cod-estab-gestor AT ROW 10.25 COL 18.14 COLON-ALIGNED HELP
          ""
          LABEL "Estab Gestor":R13
     fi-estabel-gestor AT ROW 10.25 COL 25.43 COLON-ALIGNED NO-LABEL
     RECT-9 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.29 BY 10.46.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ordem-compra
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
         HEIGHT             = 10.46
         WIDTH              = 85.29.
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
/* SETTINGS FOR FILL-IN c-cod-estab-gestor IN FRAME f-main
   NO-ENABLE 1 2 3 LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN c-ct-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ct IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-numero-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN date-data-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco-orig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco-unit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-gestor IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tp-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-mo-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-expect IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

  FIND FIRST param-compra NO-LOCK.
  IF avail param-compra THEN
      ASSIGN l-preco-bruto =  (param-compra.ipi-sobre-preco = 1).

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
  {src/adm/template/row-list.i "ordem-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ordem-compra"}

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
  &if defined(ADM-MODIFY-FIELDS) &then
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

    DEF VAR dt-plano-contas AS DATE NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    IF i-pais-impto-usuario <> 1 THEN
      ASSIGN de-valor-ipi:HIDDEN IN FRAME {&FRAME-NAME}    = YES
             de-aliquota-ipi:HIDDEN IN FRAME {&FRAME-NAME} = YES.

    if avail ordem-compra and ordem-compra.tp-despesa <> 0 then do:
        find first tipo-rec-desp no-lock 
             where tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa no-error.
        assign fi-tp-despesa = if not avail tipo-rec-desp then "" else tipo-rec-desp.descricao.
    end. 
    else
        assign fi-tp-despesa = "".

    FIND FIRST unid-negoc NO-LOCK 
         WHERE unid-negoc.cod-unid-negoc = ordem-compra.cod-unid-negoc NO-ERROR.
    ASSIGN c-des-unid-negoc = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".

    find first estabelec no-lock 
         where estabelec.cod-estabel = ordem-compra.cod-estabel no-error.
    assign c-empresa = estabelec.ep-codigo when avail estabelec.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    /*##### CONTA #####*/
    assign c-ct-codigo:format in frame {&frame-name} = "x(20)".
    assign v_cod_cta_ctbl = ordem-compra.ct-codigo.

    /* Busca um plano de contas v lido na data atual, e se nÆo encontrar, busca na data da ordem.  */
    ASSIGN dt-plano-contas = TODAY.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,                /* EMPRESA EMS2 */
                                                   input        "",                       /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,           /* CONTA */
                                                   input        dt-plano-contas,          /* DATA TRANSACAO */
                                                   output       v_des_cta_ctbl,           /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,       /* SITUA€ÇO DA CONTA */
                                                   output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).             /* ERROS */

    IF CAN-FIND(FIRST tt_log_erro) THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.

        ASSIGN dt-plano-contas = ordem-compra.data-emissao.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,                /* EMPRESA EMS2 */
                                                       input        "",                       /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,           /* CONTA */
                                                       input        dt-plano-contas,          /* DATA TRANSACAO */
                                                       output       v_des_cta_ctbl,           /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,       /* SITUA€ÇO DA CONTA */
                                                       output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).             /* ERROS */
    END.

    assign c-ct-codigo = if NOT can-find(tt_log_erro) then v_cod_cta_ctbl else ""
           c-desc-ct   = if NOT can-find(tt_log_erro) then v_des_cta_ctbl else "".

    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  c-empresa,                 /* EMPRESA EMS2 */
                                                       input  "",                        /* PLANO CONTAS */
                                                       input  dt-plano-contas,           /* DATA DE TRANSACAO */
                                                       output v_cod_formato,             /* FORMATO CONTA */
                                                       output table tt_log_erro).        /* ERROS */
    if not can-find(tt_log_erro) then
        assign c-ct-codigo:format in frame {&frame-name} = v_cod_formato.

    /*##### CENTRO CUSTO #####*/
    assign c-sc-codigo:format in frame {&frame-name} = "x(20)".
    assign v_cod_ccusto = ordem-compra.sc-codigo.
    run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,                /* EMPRESA EMS2 */
                                               input  "",                       /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,             /* CCUSTO */
                                               input  dt-plano-contas,          /* DATA DE TRANSACAO */
                                               output v_des_ccusto,             /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).       /* ERROS */

    assign c-sc-codigo = if can-find(tt_log_erro) then "" else v_cod_ccusto
           c-desc-sc   = if can-find(tt_log_erro) then "" else v_des_ccusto.

    run pi_retorna_formato_ccusto in h_api_ccusto (input  c-empresa,                 /* EMPRESA EMS2 */
                                                   input  "",                        /* PLANO CCUSTO */
                                                   input  dt-plano-contas,           /* DATA DE TRANSACAO */
                                                   output v_cod_formato,             /* FORMATO CCUSTO */
                                                   output table tt_log_erro).        /* ERROS */
    if not can-find(tt_log_erro) then
        assign c-sc-codigo:format in frame {&frame-name} = v_cod_formato.

    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

    /* Code placed here will execute AFTER standard behavior. */
    if  avail ordem-compra then do with frame {&frame-name}:
 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
     ASSIGN cAuxTraducao001 = {ininc/i01in274.i 04 ordem-compra.natureza}.
     run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                         INPUT "",
                         INPUT "").
     ASSIGN c-natureza:screen-value = RETURN-VALUE.
 &else
     ASSIGN c-natureza:screen-value = {ininc/i01in274.i 04 ordem-compra.natureza}.
 &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i02in274.i 04 ordem-compra.situacao}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN c-situacao:screen-value = RETURN-VALUE.
        &else
            ASSIGN c-situacao:screen-value = {ininc/i02in274.i 04 ordem-compra.situacao}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {ininc/i03in274.i 04 ordem-compra.origem}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN c-origem:screen-value   = RETURN-VALUE.
        &else
            ASSIGN c-origem:screen-value   = {ininc/i03in274.i 04 ordem-compra.origem}.
        &endif
        
    ASSIGN de-aliquota-ipi = ordem-compra.aliquota-ipi
           tb-expect       = ordem-compra.expectativa.
    end.
    else do:
         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
             DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
             ASSIGN cAuxTraducao004 = {ininc/i01in274.i 04 1}.
             run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                                 INPUT "",
                                 INPUT "").
             ASSIGN c-natureza:screen-value = RETURN-VALUE.
         &else
             ASSIGN c-natureza:screen-value = {ininc/i01in274.i 04 1}.
         &endif
         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao005 = {ininc/i02in274.i 04 1}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN c-situacao:screen-value = RETURN-VALUE.
        &else
            ASSIGN c-situacao:screen-value = {ininc/i02in274.i 04 1}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao006 = {ininc/i03in274.i 04 1}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao006)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN c-origem:screen-value   = RETURN-VALUE.
        &else
            ASSIGN c-origem:screen-value   = {ininc/i03in274.i 04 1}.
        &endif
        
        ASSIGN tb-expect = no.
    end.

    if avail ordem-compra then do:
        if ordem-compra.qt-acum-rec > 0 then do: 
            for last recebimento field (num-pedido numero-ordem data-movto numero-nota cod-movto)
               where recebimento.num-pedido   = ordem-compra.num-pedido
               and   recebimento.numero-ordem = ordem-compra.numero-ordem
               AND   recebimento.cod-movto = 1 no-lock: end.
            if avail recebimento then do:
                assign date-data-movto = recebimento.data-movto
                      c-numero-nota   = recebimento.numero-nota.
               disp date-data-movto
                    c-numero-nota with frame {&frame-name}.
            end.
            else do:
               assign c-numero-nota = ""
                        date-data-movto = ?.
               disp "" @ date-data-movto
                    "" @ c-numero-nota with frame {&frame-name}.
            end. 
        end.
        else do:
           assign c-numero-nota = ""
                  date-data-movto = ?.
           disp "" @ date-data-movto
                "" @ c-numero-nota with frame {&frame-name}.
        end.

        assign i-mo-codigo = i-moeda-g.

        disp i-mo-codigo with frame {&frame-name}.
        find moeda where moeda.mo-codigo = i-mo-codigo no-lock no-error. 
        if  avail moeda then
            assign c-desc-moeda:screen-value in frame {&frame-name} = moeda.descricao.

        /**
        if  not can-find (emitente where emitente.cod-emitente = ordem-compra.cod-emitente)
        then run utp/ut-msgs.p (input "show", input 2804, input "").
        **/

        if  ordem-compra.situacao <> 1 and ordem-compra.situacao <> 5 then do:
            assign da-data = if l-conv-g then ordem-compra.data-cotacao
                                         else da-conv-g.
            if  l-preco-bruto = no then
                assign de-valor-ipi = (ordem-compra.preco-unit
                                    *  ordem-compra.aliquota-ipi)
                                    / (100 + ordem-compra.aliquota-ipi).
            else do:
                if  ordem-compra.perc-descto > 0 then
                    assign de-val-orig = (ordem-compra.preco-unit * 100)
                                       / (100 - ordem-compra.perc-descto).
                else
                    assign de-val-orig = ordem-compra.preco-unit.
                assign de-valor-ipi = (de-val-orig
                                    * ordem-compra.aliquota-ipi)
                                    / (100 + ordem-compra.aliquota-ipi).
            end.
            assign de-preco      = ordem-compra.preco-unit - de-valor-ipi
                   de-preco-unit = ordem-compra.preco-unit
                   de-preco-orig = ordem-compra.preco-orig.
            if  ordem-compra.mo-codigo <> i-moeda-g then do:
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  i-moeda-g,
                                  input  de-preco,
                                  input  da-data,
                                  output de-preco).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  i-moeda-g,
                                  input  de-valor-ipi,
                                  input  da-data,
                                  output de-valor-ipi).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  i-moeda-g,
                                  input  de-preco-unit,
                                  input  da-data,
                                  output de-preco-unit).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  i-moeda-g,
                                  input  de-preco-orig,
                                  input  da-data,
                                  output de-preco-orig).
            end.
            if  de-preco        = ? then de-preco        = 0.
            if  de-aliquota-ipi = ? 
            or  de-preco        = 0 then de-aliquota-ipi = 0.
            if  de-valor-ipi    = ? then de-valor-ipi    = 0.
            if  de-preco-unit   = ? then de-preco-unit   = 0.
            if  de-preco-orig   = ? then de-preco-orig   = 0.
        end.
        else
            assign de-preco-unit   = 0
                   de-preco        = 0
                   de-aliquota-ipi = 0
                   de-valor-ipi    = 0
                   de-preco-orig   = 0.
        IF i-pais-impto-usuario = 1 THEN
            disp de-preco-unit
                 de-aliquota-ipi
                 de-preco
                 de-valor-ipi
                 de-preco-orig 
                 tb-expect 
                 with frame {&frame-name}.
        ELSE
            disp de-preco-unit
                 de-preco
                 de-preco-orig 
                 tb-expect 
                 with frame {&frame-name}.
    end.

    &if defined(bf_mat_contratos) &then
        if  not adm-new-record and
            avail ordem-compra then do:
            assign c-cod-estab-gestor = ordem-compra.cod-estab-gestor.
            find estabelec where estabelec.cod-estabel = c-cod-estab-gestor no-lock no-error.
            assign fi-estabel-gestor = if avail estabelec then estabelec.nome else "".
            disp fi-estabel-gestor
                 c-cod-estab-gestor with frame {&frame-name}.
        end.
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

    /* Dispatch standard ADM method.                          */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    &if defined(bf_mat_contratos) &then
        assign c-cod-estab-gestor:hidden in frame {&frame-name} = no
               fi-estabel-gestor:hidden in frame {&frame-name}  = no.
    &else
        assign c-cod-estab-gestor:hidden in frame {&frame-name} = yes
               fi-estabel-gestor:hidden in frame {&frame-name}  = yes.
    &endif  

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

  {utp/ut-field.i mgind ordem-compra natureza 1}
  assign c-natureza:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind ordem-compra situacao 1}
  assign c-situacao:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind ordem-compra origem 1}
  assign c-origem:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Data_do_Movimento MCC}
  assign date-data-movto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Pre‡o MCC}
  assign de-preco:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Aliquota_IPI MCC}
  assign de-aliquota-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Valor_IPI MCC}
  assign de-valor-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Pre‡o_Origem MCC}
  assign de-preco-orig:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Conta MCC}
  assign c-ct-codigo:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Centro_Custo MCC}
  assign c-sc-codigo:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Pre‡o_Unit *}
  assign de-preco-unit:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i N£mero_Documento *}
  assign c-numero-nota:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Expect._Compra * l}
  assign tb-expect:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Data_Movimento * l}
  assign date-data-movto:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Documento * l}
  assign c-numero-nota:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined(bf_mat_contratos) &then
      assign c-cod-estab-gestor:hidden in frame {&frame-name} = no
             fi-estabel-gestor:hidden  in frame {&frame-name} = no.
  &endif  
  
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

find moeda where moeda.mo-codigo = ordem-compra.mo-codigo 
    no-lock no-error.
if  avail moeda then
    assign gr-moeda = rowid(moeda).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "ordem-compra"}

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

