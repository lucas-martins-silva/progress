&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
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
{include/i-prgvrs.i V35AD107 2.00.00.025 } /*** 010025 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v35ad107 MUT}
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

{cdp/cdcfgdis.i}

&glob bf_mat_cd0602  yes   /* Validacao conta com tratamento empresa na include cd0602.i2 */

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-estabelec as rowid no-undo.

/* Parameters Definitions ---                                           */

{cdp/cd4300.i3}  /* Definicao de variŸveis para o CD4300.i4  */
{cdp/cd0602.i50} /* Definicao de variŸveis para o CD0602.i51 */


/* Local Variable Definitions ---                                       */
def var l-erro-conta            as logical no-undo.
def var i-trib-pis              as int  no-undo.
def var l-ciap-mri-ativo        as LOG  no-undo.
def var c-cod-estabel           as CHAR no-undo.

def var i-empresa like param-global.empresa-prin no-undo.

DEF BUFFER bf-estabelec FOR estabelec.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
DEF VAR h-boin879           AS HANDLE NO-UNDO.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
         field ttv_des_msg_ajuda as character format "x(40)"  label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)"  label "Mensagem Erro" column-label "Inconsistància".

/* Vari†veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.cod-cta-icms-presmdo ~
estabelec.cod-ccusto-icms-presmdo estabelec.ct-ipi-ft estabelec.sc-ipi-ft ~
estabelec.ct-ext-ipi estabelec.sc-ext-ipi ~
estabelec.cod-cta-icms-antecip-unif estabelec.cod-ccusto-icms-antecip-unif 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS lbl-ct-ipi lbl-sc-ipi 
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-cta-icms-presmdo ~
estabelec.cod-ccusto-icms-presmdo estabelec.ct-ipi-ft estabelec.sc-ipi-ft ~
estabelec.ct-ext-ipi estabelec.sc-ext-ipi ~
estabelec.cod-cta-icms-antecip-unif estabelec.cod-ccusto-icms-antecip-unif 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-tit-cta-icms-presmdo ~
c-tit-ccusto-icms-presmdo ct-ipi c-tit-ct-ipi sc-ipi c-tit-sc-ipi ~
c-tit-ct-ipi-ft c-tit-sc-ipi-ft c-tit-ct-ext-ipi c-sc-ext-ipi ~
c-tit-cta-icms-antecip c-tit-ccusto-icms-antecip lbl-ct-ipi lbl-sc-ipi 

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
DEFINE VARIABLE c-sc-ext-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ccusto-icms-antecip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ccusto-icms-presmdo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-ext-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-ipi-ft AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-cta-icms-antecip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-cta-icms-presmdo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-ipi-ft AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE ct-ipi AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE lbl-ct-ipi AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-sc-ipi AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.29 BY .67 NO-UNDO.

DEFINE VARIABLE sc-ipi AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-cta-icms-presmdo AT ROW 1.42 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-cta-icms-presmdo AT ROW 1.42 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-icms-presmdo AT ROW 2.42 COL 24.86 COLON-ALIGNED
          LABEL "Centro Custo Icms presmdo"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-ccusto-icms-presmdo AT ROW 2.42 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     ct-ipi AT ROW 3.58 COL 24.86 COLON-ALIGNED NO-LABEL
     c-tit-ct-ipi AT ROW 3.58 COL 43.43 COLON-ALIGNED NO-LABEL
     sc-ipi AT ROW 4.58 COL 24.86 COLON-ALIGNED NO-LABEL
     c-tit-sc-ipi AT ROW 4.58 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     estabelec.ct-ipi-ft AT ROW 5.75 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-ct-ipi-ft AT ROW 5.75 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.sc-ipi-ft AT ROW 6.75 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-sc-ipi-ft AT ROW 6.75 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     estabelec.ct-ext-ipi AT ROW 7.92 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-ct-ext-ipi AT ROW 7.92 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.sc-ext-ipi AT ROW 8.92 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-sc-ext-ipi AT ROW 8.92 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     estabelec.cod-cta-icms-antecip-unif AT ROW 10.08 COL 24.86 COLON-ALIGNED
          LABEL "Conta icm antecip"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-cta-icms-antecip AT ROW 10.08 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-icms-antecip-unif AT ROW 11.08 COL 24.86 COLON-ALIGNED
          LABEL "C custo ICMS Antecip"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-tit-ccusto-icms-antecip AT ROW 11.08 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     lbl-ct-ipi AT ROW 3.75 COL 9.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     lbl-sc-ipi AT ROW 4.71 COL 4.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 11.29
         WIDTH              = 84.
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

/* SETTINGS FOR FILL-IN c-sc-ext-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ccusto-icms-antecip IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ccusto-icms-presmdo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-ext-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-ipi-ft IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-cta-icms-antecip IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-cta-icms-presmdo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-ipi-ft IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-icms-antecip-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-icms-presmdo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-icms-antecip-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ct-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN sc-ipi IN FRAME f-main
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

&Scoped-define SELF-NAME estabelec.cod-ccusto-icms-antecip-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-antecip-unif V-table-Win
ON F5 OF estabelec.cod-ccusto-icms-antecip-unif IN FRAME f-main /* C custo ICMS Antecip */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-icms-antecip-unif:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-ccusto-icms-antecip:SCREEN-VALUE = v_titulo_ccusto.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-antecip-unif V-table-Win
ON LEAVE OF estabelec.cod-ccusto-icms-antecip-unif IN FRAME f-main /* C custo ICMS Antecip */
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.cod-ccusto-icms-antecip-unif c-tit-ccusto-icms-antecip}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-antecip-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-icms-antecip-unif IN FRAME f-main /* C custo ICMS Antecip */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-icms-presmdo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-presmdo V-table-Win
ON F5 OF estabelec.cod-ccusto-icms-presmdo IN FRAME f-main /* Centro Custo Icms presmdo */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-icms-presmdo:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-ccusto-icms-presmdo:SCREEN-VALUE = v_titulo_ccusto.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-presmdo V-table-Win
ON LEAVE OF estabelec.cod-ccusto-icms-presmdo IN FRAME f-main /* Centro Custo Icms presmdo */
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.cod-ccusto-icms-presmdo c-tit-ccusto-icms-presmdo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-presmdo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-icms-presmdo IN FRAME f-main /* Centro Custo Icms presmdo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-icms-antecip-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-antecip-unif V-table-Win
ON ENTRY OF estabelec.cod-cta-icms-antecip-unif IN FRAME f-main /* Conta icm antecip */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ENABLE estabelec.cod-ccusto-icms-antecip-unif WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-antecip-unif V-table-Win
ON F5 OF estabelec.cod-cta-icms-antecip-unif IN FRAME f-main /* Conta icm antecip */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M‡DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.cod-cta-icms-antecip-unif:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-cta-icms-antecip:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-antecip-unif V-table-Win
ON LEAVE OF estabelec.cod-cta-icms-antecip-unif IN FRAME f-main /* Conta icm antecip */
DO:

    {cdp/cd0602.i3 estabelec.cod-cta-icms-antecip-unif c-tit-cta-icms-antecip
                   estabelec.cod-ccusto-icms-antecip-unif c-tit-ccusto-icms-antecip TRUE}     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-antecip-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-icms-antecip-unif IN FRAME f-main /* Conta icm antecip */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-icms-presmdo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-presmdo V-table-Win
ON ENTRY OF estabelec.cod-cta-icms-presmdo IN FRAME f-main /* Conta Icms Presumido */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.cod-ccusto-icms-presmdo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-presmdo V-table-Win
ON F5 OF estabelec.cod-cta-icms-presmdo IN FRAME f-main /* Conta Icms Presumido */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M‡DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.cod-cta-icms-presmdo:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-cta-icms-presmdo:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-presmdo V-table-Win
ON LEAVE OF estabelec.cod-cta-icms-presmdo IN FRAME f-main /* Conta Icms Presumido */
DO:

    /* Include que faz o leave do campo usando a API de financas */
    {cdp/cd0602.i3 estabelec.cod-cta-icms-presmdo c-tit-cta-icms-presmdo 
                   estabelec.cod-ccusto-icms-presmdo c-tit-ccusto-icms-presmdo TRUE}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-presmdo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-icms-presmdo IN FRAME f-main /* Conta Icms Presumido */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-ext-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-ipi V-table-Win
ON ENTRY OF estabelec.ct-ext-ipi IN FRAME f-main /* Cta Estorno IPI */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.sc-ext-ipi WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-ipi V-table-Win
ON F5 OF estabelec.ct-ext-ipi IN FRAME f-main /* Cta Estorno IPI */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M‡DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.ct-ext-ipi:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-ext-ipi:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-ipi V-table-Win
ON LEAVE OF estabelec.ct-ext-ipi IN FRAME f-main /* Cta Estorno IPI */
DO:
    {cdp/cd0602.i3 estabelec.ct-ext-ipi c-tit-ct-ext-ipi
                   estabelec.sc-ext-ipi c-sc-ext-ipi TRUE}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-ext-ipi IN FRAME f-main /* Cta Estorno IPI */
DO:
   apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ipi V-table-Win
ON ENTRY OF ct-ipi IN FRAME f-main
DO:
  IF adm-new-record AND adm-adding-record THEN 
     ASSIGN SELF:FORMAT = "x(20)". 
  ELSE DO: 
      RUN utp/ut-msgs.p (INPUT "SHOW",
                         INPUT 53892, /*Utilizar bot„o 'Contas Impostos Recuperar'*/
                         INPUT "").

      RUN pi-set-color-label(INPUT 12,INPUT 1).
      APPLY "entry" to estabelec.ct-ipi-ft IN FRAME f-main.
      DISABLE ct-ipi sc-ipi with frame {&frame-name}.
      RETURN NO-APPLY.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME ct-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ipi V-table-Win
ON LEAVE OF ct-ipi IN FRAME f-main
DO:
 
    ASSIGN ct-ipi:format in frame {&frame-name} = "x(20)":u.
    ASSIGN ct-ipi = ct-ipi:SCREEN-VALUE IN FRAME f-main.

    {cdp/cd0602.i3 ct-ipi c-tit-ct-ipi 
                  sc-ipi c-tit-sc-ipi TRUE}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-ipi V-table-Win
ON LEAVE OF sc-ipi IN FRAME f-main 
DO:
    ASSIGN sc-ipi:format in frame {&frame-name} = "x(20)":u.
    ASSIGN sc-ipi = sc-ipi:SCREEN-VALUE IN FRAME f-main.
    {cdp/cd0602.i4 sc-ipi c-tit-sc-ipi}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ipi V-table-Win
ON F5 OF ct-ipi IN FRAME f-main
DO:
  IF adm-new-record AND adm-adding-record THEN 
     ASSIGN SELF:FORMAT = "x(20)". 
      
     run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl(input  i-empresa,           /* EMPRESA EMS2 */
                                                   input  "CEP",               /* M‡DULO */
                                                   input  "",                  /* PLANO DE CONTAS */
                                                   input  "(nenhum)",          /* FINALIDADES */
                                                   input  today,               /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro).  /* ERROS */ 

     IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN ct-ipi:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-ipi:SCREEN-VALUE = v_titulo_cta_ctbl.
     END. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-ipi IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-ipi-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON ENTRY OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.sc-ipi-ft WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON F5 OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M‡DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.ct-ipi-ft:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-ipi-ft:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON LEAVE OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
    {cdp/cd0602.i3 estabelec.ct-ipi-ft c-tit-ct-ipi-ft
                   estabelec.sc-ipi-ft c-tit-sc-ipi-ft TRUE}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-ext-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-ipi V-table-Win
ON F5 OF estabelec.sc-ext-ipi IN FRAME f-main /* CC Estorno IPI */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.sc-ext-ipi:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-sc-ext-ipi:SCREEN-VALUE = v_titulo_ccusto.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-ipi V-table-Win
ON LEAVE OF estabelec.sc-ext-ipi IN FRAME f-main /* CC Estorno IPI */
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.sc-ext-ipi c-sc-ext-ipi}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.sc-ext-ipi IN FRAME f-main /* CC Estorno IPI */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sc-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-ipi V-table-Win
ON ENTRY OF sc-ipi IN FRAME f-main
DO:
    
  IF adm-new-record AND adm-adding-record  THEN 
     ASSIGN SELF:FORMAT = "x(20)". 

  ELSE DO:     
    
      RUN utp/ut-msgs.p (INPUT "SHOW",
                         INPUT 53892, /*Utilizar bot„o 'Contas Impostos Recuperar'*/
                         INPUT "").
      RUN pi-set-color-label(INPUT 12,INPUT 2).
      apply "entry" to estabelec.ct-ipi-ft in frame f-main.
      DISABLE ct-ipi sc-ipi with frame {&frame-name}.
      return no-apply.
  END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-ipi V-table-Win
ON F5 OF sc-ipi IN FRAME f-main
DO:
    IF adm-new-record AND adm-adding-record THEN DO:
        
        run pi_zoom_ccusto in h_api_ccusto(input i-empresa,           /* EMPRESA EMS2 */
                                 input "",                  /* CODIGO DO PLANO CCUSTO */
                                 input "",                  /* UNIDADE DE NEGOCIO */
                                 input today,               /* DATA DE TRANSACAO */
                                 output v_cod_ccusto,       /* CODIGO CCUSTO */
                                 output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                 output table tt_log_erro). /* ERROS */ 

        IF v_titulo_ccusto <> "" THEN 
            ASSIGN sc-ipi:SCREEN-VALUE = v_cod_ccusto
                   c-tit-sc-ipi:SCREEN-VALUE = v_titulo_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF sc-ipi IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-ipi-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON F5 OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.sc-ipi-ft:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-ipi-ft:SCREEN-VALUE = v_titulo_ccusto.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON LEAVE OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.sc-ipi-ft c-tit-sc-ipi-ft}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
DO:
  APPLY "f5" TO SELF.
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

  if  estabelec.ct-ext-ipi:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-cta-icms-presmdo:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.ct-ipi-ft:load-mouse-pointer("image~\lupa.cur") then .  
  if  estabelec.cod-cta-icms-antecip-unif:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.sc-ext-ipi:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-icms-presmdo:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.sc-ipi-ft:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-icms-antecip-unif:load-mouse-pointer("image~\lupa.cur") then .  

  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  NOT AVAIL param-global THEN DO:
      BELL.
      RUN utp/ut-msgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
  END.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  RUN pi-set-color-label(9,0).

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaÓÔes */
  /* N“o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  IF i-pais-impto-usuario = 1 THEN DO:
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
      /* Todos os assignµs n“o feitos pelo assign-record devem ser feitos aqui */  
      /* Code placed here will execute AFTER standard behavior.    */    

      IF  adm-new-record AND ct-ipi <> "" THEN DO:
          IF NOT CAN-FIND (FIRST estab-ctas-impto 
                           WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
                           AND   estab-ctas-impto.num-impto = 02) THEN DO:

              CREATE estab-ctas-impto.
              ASSIGN estab-ctas-impto.cod-estab = estabelec.cod-estabel
                     estab-ctas-impto.num-impto = 02
                     estab-ctas-impto.dat-inic-valid = 01/01/1800
                     estab-ctas-impto.dat-fim-valid = 12/30/9999
                     estab-ctas-impto.conta-imposto = ct-ipi
                     estab-ctas-impto.cod-ccusto-impto = sc-ipi.
          END.
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*ASSIGN INPUT FRAME {&frame-name} c-conta-pis-subs
         INPUT FRAME {&frame-name} estabelec.cod-cta-icms-antecip-unif
         INPUT FRAME {&frame-name} c-conta-cofins-subs
         INPUT FRAME {&frame-name} c-tit-cta-icms-presmdo-presmdo.*/

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
  /* Elimina handle's */
  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
  if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto.    
  IF VALID-HANDLE(h-boin879) THEN
    DELETE OBJECT h-boin879.
    
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
  
    disable ct-ipi sc-ipi with frame {&frame-name}.

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
    RUN pi-desformata-campos.
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        assign c-cod-estabel = estabelec.cod-estabel.
    end.
    else do:
        /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.

        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "cod-estabel":U).                                                         
        assign c-cod-estabel = RETURN-VALUE.
    end. 

    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  TODAY,              /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  TODAY,              /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */       
  
    
    IF estabelec.log-livre-1 = YES  AND NOT adm-new-record THEN DO: 
        
        IF NOT VALID-HANDLE(h-boin879) THEN
           RUN inbo/boin879.p PERSISTENT SET h-boin879.
        
        RUN openQueryStatic IN h-boin879 (INPUT "Main":U).
                                                                
        RUN goToKeyCustom IN h-boin879 ( INPUT estabelec.cod-estabel,
                                         INPUT 02,
                                         INPUT TODAY ).
                                         
        IF RETURN-VALUE = "OK":U THEN DO:
            
            RUN getCharField IN h-boin879 ( INPUT "conta-imposto":U,
                                            OUTPUT ct-ipi ).
            RUN getCharField IN h-boin879 ( INPUT "cod-ccusto-impto":U,
                                            OUTPUT sc-ipi ).
        END.
        
    END.
    
    display ct-ipi
            sc-ipi with frame {&frame-name}.
        
    /* Busca as descriá‰es */
    {cdp/cd0602.i3 estabelec.cod-cta-icms-presmdo c-tit-cta-icms-presmdo 
                   estabelec.cod-ccusto-icms-presmdo c-tit-ccusto-icms-presmdo FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-icms-presmdo c-tit-ccusto-icms-presmdo}
    end.
                   
    {cdp/cd0602.i3 ct-ipi c-tit-ct-ipi
                   sc-ipi c-tit-sc-ipi FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 sc-ipi c-tit-sc-ipi}
    end.
                   
    {cdp/cd0602.i3 estabelec.ct-ipi-ft c-tit-ct-ipi-ft
                   estabelec.sc-ipi-ft c-tit-sc-ipi-ft FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.sc-ipi-ft c-tit-sc-ipi-ft}
    end.
                   
    {cdp/cd0602.i3 estabelec.ct-ext-ipi c-tit-ct-ext-ipi
                   estabelec.sc-ext-ipi c-sc-ext-ipi FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.sc-ext-ipi c-sc-ext-ipi}
    end.
             
    {cdp/cd0602.i3 estabelec.cod-cta-icms-antecip-unif c-tit-cta-icms-antecip
                   estabelec.cod-ccusto-icms-antecip-unif c-tit-ccusto-icms-antecip FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-icms-antecip-unif c-tit-ccusto-icms-antecip} 
    end.

    run pi-formata-campos.
    RUN pi-set-color-label(INPUT 9, 0).
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
  
  enable ct-ipi sc-ipi with frame {&frame-name}.
   
  IF adm-new-record AND adm-adding-record THEN DO:
    run pi-desformata-campos.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if avail estabelec then do:
      assign i-empresa = estabelec.ep-codigo.
      assign c-cod-estabel = estabelec.cod-estabel.
  end.
  else do:
      /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
      run Get-Field-Screen-Value in adm-broker-hdl
       (input this-procedure, input "ep-codigo":U).
      ASSIGN i-empresa = RETURN-VALUE.

      run Get-Field-Screen-Value in adm-broker-hdl
       (input this-procedure, input "cod-estabel":U).                                                         
      assign c-cod-estabel = RETURN-VALUE.
  end.

  /* Handle da API Conta Contòbil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Conta_Estorno_IPI *}
  assign estabelec.ct-ext-ipi:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_Estorno_IPI *}
  assign estabelec.sc-ext-ipi:label in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_ICMS_Presumido *}
  assign estabelec.cod-cta-icms-presmdo:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_ICMS_Presumido *}
  assign estabelec.cod-ccusto-icms-presmdo:label in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_IPI_Recolher *}
  assign estabelec.ct-ipi-ft:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_IPI_Recolher *}
  assign estabelec.sc-ipi-ft:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_ICMS_Subs_Trib_Ant *}
  assign estabelec.cod-cta-icms-antecip-unif:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Centro_Custo_ICMS_Subs_Trib_Ant *}
  assign estabelec.cod-ccusto-icms-antecip-unif:label in frame {&frame-name} = return-value.


  RUN pi-set-color-label(INPUT 9,INPUT 0). 

/*
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  NOT AVAIL param-global THEN DO:
      BELL.
      RUN utp/ut-msgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
      RETURN.
  END. */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        assign c-cod-estabel = estabelec.cod-estabel.
    end.
    else do:
        /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.

        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "cod-estabel":U).                                                         
        assign c-cod-estabel = RETURN-VALUE.
    end.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
ASSIGN estabelec.ct-ext-ipi                    :format in frame {&frame-name} = "x(20)":u
           estabelec.sc-ext-ipi                    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-icms-presmdo          :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-icms-presmdo       :format in frame {&frame-name} = "x(20)":u
           ct-ipi                                  :format in frame {&frame-name} = "x(20)":u
           sc-ipi                                  :format in frame {&frame-name} = "x(20)":u
           estabelec.ct-ipi-ft                     :format in frame {&frame-name} = "x(20)":u
           estabelec.sc-ipi-ft                     :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-icms-antecip-unif     :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-icms-antecip-unif  :format in frame {&frame-name} = "x(20)":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.
    
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */
  if c-formato-conta <> "" then do:
      if estabelec.cod-cta-icms-presmdo:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-icms-presmdo:format in frame {&FRAME-NAME} = c-formato-conta.
        
      if ct-ipi:screen-value in frame {&frame-name} <> "" then
        assign ct-ipi:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.ct-ipi-ft:screen-value in frame {&frame-name} <> "" then
        assign estabelec.ct-ipi-ft:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.ct-ext-ipi:screen-value in frame {&frame-name} <> "" then
        assign estabelec.ct-ext-ipi:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-icms-antecip-unif:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-icms-antecip-unif:format in frame {&FRAME-NAME} = c-formato-conta.   
  end.
  if c-formato-ccusto <> "" then do:
      if estabelec.cod-ccusto-icms-presmdo:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-icms-presmdo:format     in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if sc-ipi:screen-value in frame {&frame-name} <> "" then
        assign sc-ipi:format     in frame {&FRAME-NAME} = c-formato-ccusto.
        
      if estabelec.sc-ipi-ft:screen-value in frame {&frame-name} <> "" then
        assign estabelec.sc-ipi-ft:format  in frame {&FRAME-NAME} = c-formato-ccusto.
        
      if estabelec.sc-ext-ipi:screen-value in frame {&frame-name} <> "" then
        assign estabelec.sc-ext-ipi:format in frame {&FRAME-NAME} = c-formato-ccusto.
        
      if estabelec.cod-ccusto-icms-antecip-unif:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-icms-antecip-unif:format   in frame {&FRAME-NAME} = c-formato-ccusto.       
  end.           
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-color-label V-table-Win 
PROCEDURE pi-set-color-label :
/*------------------------------------------------------------------------------
  Purpose: Alterar cor dos labels de contas e centro de custo a recuperar.
           Campos com a cor alterada devem ser atualizados clicando no bot„o 
           bt-contas
  Parameters:  pi-color: 9-azul 12-Vermelho
               pi-type: Campo que deve ser alterado.
  Notes:     
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pi-color AS INTEGER NO-UNDO.
DEFINE INPUT PARAM pi-type  AS INTEGER NO-UNDO.

 {utp/ut-liter.i Conta_IPI_Recuperar: *}
  assign lbl-ct-ipi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  
  {utp/ut-liter.i Centro_Custo_IPI_Recuperar: *}
  assign lbl-sc-ipi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.


    CASE pi-type:
        WHEN 0 THEN DO:
          ASSIGN lbl-ct-ipi:FGCOLOR IN FRAME f-main = pi-color /*9*/ 
                 lbl-sc-ipi:FGCOLOR IN FRAME f-main = pi-color. /*9*/
        END.
        WHEN 1 THEN DO:
          ASSIGN lbl-ct-ipi:FGCOLOR IN FRAME f-main = pi-color. /*12*/
        END.
        WHEN 2 THEN DO:
          ASSIGN lbl-sc-ipi:FGCOLOR IN FRAME f-main = pi-color /*12*/.
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-campo V-table-Win 
PROCEDURE pi-seta-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                 INPUT 'cod-estabel').
   ASSIGN c-cod-estabel = RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N“o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaÓÔes, pois neste ponto do programa o registro 
  ainda n“o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* ValidaÓ“o de dicionŸrio */

    assign l-erro-conta = no.
    find first param-global no-lock no-error.

    IF i-pais-impto-usuario = 1 THEN DO:

        if avail estabelec then do:
            assign i-empresa = estabelec.ep-codigo.
            assign c-cod-estabel = estabelec.cod-estabel.
        end.
        else do:
            /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
            run Get-Field-Screen-Value in adm-broker-hdl
             (input this-procedure, input "ep-codigo":U).
            ASSIGN i-empresa = RETURN-VALUE.
    
            run Get-Field-Screen-Value in adm-broker-hdl
             (input this-procedure, input "cod-estabel":U).                                                         
            assign c-cod-estabel = RETURN-VALUE.
        end.
    
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-msg-conta AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Favor informar corretamente a conta!" *}
        ASSIGN c-msg-conta = TRIM(RETURN-VALUE).
        /* Validando contas e centros de custo */
        {cdp/cd0602.i estabelec.cod-cta-icms-presmdo}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-icms-presmdo}
        end.
                
        IF adm-new-record THEN DO:
        {cdp/cd0602.i ct-ipi}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 sc-ipi}
            end.
        end.
        
        {cdp/cd0602.i estabelec.ct-ipi-ft}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.sc-ipi-ft}
        end.
        
        {cdp/cd0602.i estabelec.ct-ext-ipi}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.sc-ext-ipi}
        end.
        
        {cdp/cd0602.i estabelec.cod-cta-icms-antecip-unif}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-icms-antecip-unif}
        end.        

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
  {src/adm/template/snd-list.i "estabelec"}

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

