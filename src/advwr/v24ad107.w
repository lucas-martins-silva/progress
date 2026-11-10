&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
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
{include/i-prgvrs.i V24AD107 2.00.00.026 } /*** 010026 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v24ad107 MUT}
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
&Scoped-Define ENABLED-FIELDS estabelec.ct-icms-ft estabelec.sc-icms-ft ~
estabelec.ct-icms-comp estabelec.sc-icms-comp estabelec.ct-ext-icms ~
estabelec.sc-ext-icms estabelec.cod-cta-icms-ativ-recup ~
estabelec.cod-ccusto-icms-ativ-recup 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS lbl-ct-icm lbl-sc-icm 
&Scoped-Define DISPLAYED-FIELDS estabelec.ct-icms-ft estabelec.sc-icms-ft ~
estabelec.ct-icms-comp estabelec.sc-icms-comp estabelec.ct-ext-icms ~
estabelec.sc-ext-icms estabelec.cod-cta-icms-ativ-recup ~
estabelec.cod-ccusto-icms-ativ-recup 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS ct-icm c-conta-icms sc-icm c-ccusto-icms ~
c-conta-icms-ft c-ccusto-icms-ft c-conta-icms-comp c-ccusto-icms-comp ~
c-ct-ext-icms c-sc-ext-icms c-desc-conta-ativo-rec c-desc-ccusto-ativo-rec ~
lbl-ct-icm lbl-sc-icm 

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
DEFINE VARIABLE c-ccusto-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-ccusto-icms-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-ccusto-icms-ft AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta-icms-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta-icms-ft AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-ext-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-ativo-rec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta-ativo-rec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-ext-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE ct-icm AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE lbl-ct-icm AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.57 BY .67
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE lbl-sc-icm AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18.57 BY .67
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE sc-icm AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ct-icm AT ROW 1.42 COL 24.86 COLON-ALIGNED NO-LABEL
     c-conta-icms AT ROW 1.42 COL 43.43 COLON-ALIGNED NO-LABEL
     sc-icm AT ROW 2.42 COL 24.86 COLON-ALIGNED NO-LABEL
     c-ccusto-icms AT ROW 2.42 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     estabelec.ct-icms-ft AT ROW 3.58 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-conta-icms-ft AT ROW 3.58 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.sc-icms-ft AT ROW 4.58 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-ccusto-icms-ft AT ROW 4.58 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     estabelec.ct-icms-comp AT ROW 5.75 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-conta-icms-comp AT ROW 5.75 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.sc-icms-comp AT ROW 6.75 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-ccusto-icms-comp AT ROW 6.75 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     estabelec.ct-ext-icms AT ROW 7.92 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-ct-ext-icms AT ROW 7.92 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.sc-ext-icms AT ROW 8.92 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-sc-ext-icms AT ROW 8.92 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     estabelec.cod-cta-icms-ativ-recup AT ROW 10.08 COL 24.86 COLON-ALIGNED WIDGET-ID 14
          LABEL "ICMS de Ativo a Recuperar"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-conta-ativo-rec AT ROW 10.08 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-icms-ativ-recup AT ROW 11.08 COL 24.86 COLON-ALIGNED WIDGET-ID 12
          LABEL "ICMS de Ativo a Recuperar"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-ccusto-ativo-rec AT ROW 11.08 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     lbl-ct-icm AT ROW 1.54 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     lbl-sc-icm AT ROW 2.5 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 18
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
         HEIGHT             = 11.25
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

/* SETTINGS FOR FILL-IN c-ccusto-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ccusto-icms-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ccusto-icms-ft IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-conta-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-conta-icms-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-conta-icms-ft IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ct-ext-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-ativo-rec IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-ccusto-ativo-rec:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-conta-ativo-rec IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-conta-ativo-rec:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-sc-ext-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-icms-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-icms-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ct-icm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN sc-icm IN FRAME f-main
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

&Scoped-define SELF-NAME estabelec.cod-ccusto-icms-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-ccusto-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-ativ-recup V-table-Win
ON F5 OF estabelec.cod-ccusto-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-icms-ativ-recup:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-ccusto-ativo-rec:SCREEN-VALUE = v_titulo_ccusto.
   END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-ccusto-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   {cdp/cd0602.i4 estabelec.cod-ccusto-icms-ativ-recup c-desc-ccusto-ativo-rec} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-icms-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-cta-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-ativ-recup V-table-Win
ON F5 OF estabelec.cod-cta-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* MÖDULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.cod-cta-icms-ativ-recup:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-conta-ativo-rec:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-cta-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   {cdp/cd0602.i3 estabelec.cod-cta-icms-ativ-recup c-desc-conta-ativo-rec 
                  estabelec.cod-ccusto-icms-ativ-recup c-desc-ccusto-ativo-rec TRUE}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-icms-ativ-recup IN FRAME f-main /* ICMS de Ativo a Recuperar */
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-ext-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-icms V-table-Win
ON ENTRY OF estabelec.ct-ext-icms IN FRAME f-main /* Cta Estorno ICMS */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.sc-ext-icms WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-icms V-table-Win
ON F5 OF estabelec.ct-ext-icms IN FRAME f-main /* Cta Estorno ICMS */
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
       ASSIGN estabelec.ct-ext-icms:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-ct-ext-icms:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-icms V-table-Win
ON LEAVE OF estabelec.ct-ext-icms IN FRAME f-main /* Cta Estorno ICMS */
DO:

    {cdp/cd0602.i3 estabelec.ct-ext-icms c-ct-ext-icms 
                   estabelec.sc-ext-icms c-sc-ext-icms TRUE}    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-icms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-ext-icms IN FRAME f-main /* Cta Estorno ICMS */
DO:
   apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ext-icms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-icm IN FRAME f-main /* ct-icm */
DO:
   apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-icm V-table-Win
ON F5 OF ct-icm IN FRAME f-main /* ct-icm */
DO:
   IF adm-new-record AND adm-adding-record  THEN DO:        
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
           ASSIGN ct-icm:SCREEN-VALUE IN FRAME f-main = v_cod_cta_ctbl.
           ASSIGN c-conta-icms:SCREEN-VALUE IN FRAME f-main = v_titulo_cta_ctbl.
       END. 
   
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME ct-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-icm V-table-Win
ON ENTRY OF ct-icm IN FRAME f-main
DO:
   IF adm-new-record AND  adm-adding-record THEN
     ASSIGN SELF:FORMAT = "x(20)". 
   ELSE DO:  
      run utp/ut-msgs.p ( input "SHOW",
                         input 53892,
                         input return-value).
    
      RUN pi-set-color-label(INPUT 12,INPUT 1).
      APPLY "entry" TO estabelec.ct-icms-ft IN FRAME f-main.
      DISABLE ct-icm sc-icm with frame {&frame-name}.
      RETURN NO-APPLY.

   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME ct-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-icm V-table-Win
ON LEAVE OF ct-icm IN FRAME f-main
DO:
 
    ASSIGN ct-icm:format in frame {&frame-name} = "x(20)":u.
    ASSIGN ct-icm = ct-icm:SCREEN-VALUE IN FRAME f-main.

    {cdp/cd0602.i3 ct-icm c-conta-icms 
                  sc-icm c-ccusto-icms TRUE}  
           
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-icm V-table-Win
ON LEAVE OF sc-icm IN FRAME f-main 
DO:
    ASSIGN sc-icm:format in frame {&frame-name} = "x(20)":u.
    ASSIGN sc-icm = sc-icm:SCREEN-VALUE IN FRAME f-main.
    {cdp/cd0602.i4 sc-icm c-ccusto-icms}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME estabelec.ct-icms-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-comp V-table-Win
ON ENTRY OF estabelec.ct-icms-comp IN FRAME f-main /* Cta ICMS Complementar */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.sc-icms-comp WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-comp V-table-Win
ON F5 OF estabelec.ct-icms-comp IN FRAME f-main /* Cta ICMS Complementar */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* MÖDULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.ct-icms-comp:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-conta-icms-comp:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-comp V-table-Win
ON LEAVE OF estabelec.ct-icms-comp IN FRAME f-main /* Cta ICMS Complementar */
DO:
  {cdp/cd0602.i3 estabelec.ct-icms-comp c-conta-icms-comp 
                 estabelec.sc-icms-comp c-ccusto-icms-comp TRUE}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-icms-comp IN FRAME f-main /* Cta ICMS Complementar */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-icms-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON ENTRY OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.sc-icms-ft WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON F5 OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
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
       ASSIGN c-conta-icms-ft:SCREEN-VALUE = v_titulo_cta_ctbl.
       ASSIGN estabelec.ct-icms-ft:SCREEN-VALUE = v_cod_cta_ctbl.
   END.                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON LEAVE OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:

    {cdp/cd0602.i3 estabelec.ct-icms-ft c-conta-icms-ft 
                   estabelec.sc-icms-ft c-ccusto-icms-ft TRUE}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-ext-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-icms V-table-Win
ON ENTRY OF estabelec.sc-ext-icms IN FRAME f-main /* CC Estorno ICM */
DO:
    ASSIGN estabelec.sc-ext-icms:FORMAT IN FRAME {&FRAME-NAME} = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-icms V-table-Win
ON F5 OF estabelec.sc-ext-icms IN FRAME f-main /* CC Estorno ICM */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.sc-ext-icms:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-sc-ext-icms:SCREEN-VALUE = v_titulo_ccusto.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-icms V-table-Win
ON LEAVE OF estabelec.sc-ext-icms IN FRAME f-main /* CC Estorno ICM */
DO:
    {cdp/cd0602.i4 estabelec.sc-ext-icms c-sc-ext-icms}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ext-icms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.sc-ext-icms IN FRAME f-main /* CC Estorno ICM */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sc-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-icm V-table-Win
ON ENTRY OF sc-icm IN FRAME f-main
DO:    
   IF adm-new-record AND adm-adding-record  THEN    
       ASSIGN SELF:FORMAT = "x(20)". 
   
   ELSE DO:    
      run utp/ut-msgs.p(input "SHOW",
                        input 53892,
                        input return-value). 
                          
      RUN pi-set-color-label(INPUT 12,INPUT 2).                     
      apply "entry" to estabelec.ct-icms-ft in frame f-main.
      DISABLE ct-icm sc-icm with frame {&frame-name}.
      return no-apply.
   END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-icm V-table-Win
ON MOUSE-SELECT-DBLCLICK OF sc-icm IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-icms-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-icm V-table-Win
ON F5 OF sc-icm IN FRAME f-main /* sc-icm */
DO:

   IF adm-new-record AND adm-adding-record  THEN DO: 
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input today,               /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
   
       IF v_titulo_ccusto <> "" THEN DO:
           ASSIGN sc-icm:SCREEN-VALUE = v_cod_ccusto.
           ASSIGN c-ccusto-icms:SCREEN-VALUE = v_titulo_ccusto.
       END.  
   END.

 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME estabelec.sc-icms-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-comp V-table-Win
ON F5 OF estabelec.sc-icms-comp IN FRAME f-main /* CC ICMS Compl */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.sc-icms-comp:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-ccusto-icms-comp:SCREEN-VALUE = v_titulo_ccusto.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-comp V-table-Win
ON LEAVE OF estabelec.sc-icms-comp IN FRAME f-main /* CC ICMS Compl */
DO:
    {cdp/cd0602.i4 estabelec.sc-icms-comp c-ccusto-icms-comp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.sc-icms-comp IN FRAME f-main /* CC ICMS Compl */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-icms-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON ENTRY OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
    ASSIGN estabelec.sc-icms-ft:FORMAT IN FRAME {&FRAME-NAME} = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON F5 OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.sc-icms-ft:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-ccusto-icms-ft:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON LEAVE OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
    {cdp/cd0602.i4 estabelec.sc-icms-ft c-ccusto-icms-ft}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
  APPLY "F5" TO SELF.
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

  if  estabelec.ct-ext-icms:load-mouse-pointer("image~\lupa.cur") then .  
  if  estabelec.ct-icms-comp:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.ct-icms-ft:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-cta-icms-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.sc-ext-icms:load-mouse-pointer("image~\lupa.cur") then .  
  if  estabelec.sc-icms-comp:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.sc-icms-ft:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-icms-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .  

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
  /* Ponha na pi-validate todas as validaÓÔes */
  /* N“o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  IF i-pais-impto-usuario = 1 THEN DO:
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
      /* Todos os assignµs n“o feitos pelo assign-record devem ser feitos aqui */  
      /* Code placed here will execute AFTER standard behavior.    */
      
      /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
      RUN pi-log-ciap-mri.
    
      IF  NOT l-ciap-mri-ativo THEN DO:
          &if "{&bf_mat_versao_ems}" >= "2.07" &then
              assign estabelec.cod-cta-icms-ativ-recup = "".
              assign estabelec.cod-ccusto-icms-ativ-recup = "".
          &endif
      END. 
      
      IF  adm-new-record AND ct-icm <> "" THEN DO:
          IF NOT CAN-FIND (FIRST estab-ctas-impto 
                           WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
                           AND   estab-ctas-impto.num-impto = 01) THEN DO:
    
                  CREATE estab-ctas-impto.
                  ASSIGN estab-ctas-impto.cod-estab = estabelec.cod-estabel
                         estab-ctas-impto.num-impto = 01
                         estab-ctas-impto.dat-inic-valid = 01/01/1800
                         estab-ctas-impto.dat-fim-valid = 12/30/9999
                         estab-ctas-impto.conta-imposto = ct-icm
                         estab-ctas-impto.cod-ccusto-impto = sc-icm.
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
         INPUT FRAME {&frame-name} c-conta-ativo-rec
         INPUT FRAME {&frame-name} c-conta-cofins-subs
         INPUT FRAME {&frame-name} c-conta-icms-presmdo.*/

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
  
  disable ct-icm sc-icm with frame {&frame-name}.


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
        run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.
        run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure, input "cod-estabel":U).                                                         
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
 
   IF estabelec.log-livre-1 = YES AND NOT adm-new-record THEN DO: 
       /*inicializaÁ„o do handle neste ponto para evitar 
         erro caso n„o tenha sido efetuado a aplicaÁ„o do delta 
         com a tabela estab-ctas-impto */
        IF NOT VALID-HANDLE(h-boin879) THEN
            RUN inbo/boin879.p persistent set h-boin879.
            RUN openQueryStatic IN h-boin879 (INPUT "Main":U).   
                                                       
        RUN goToKeyCustom IN h-boin879 ( INPUT estabelec.cod-estabel,
                                         INPUT 01,
                                         INPUT TODAY ).
        
        IF RETURN-VALUE = "OK":U THEN DO:
            
            RUN getCharField IN h-boin879 ( INPUT "conta-imposto":U,
                                            OUTPUT ct-icm ).
            
            RUN getCharField IN h-boin879 ( INPUT "cod-ccusto-impto":U,
                                            OUTPUT sc-icm ).
        END.
        
    END.        
    
    display ct-icm
            sc-icm with frame {&frame-name}.

    IF adm-new-record AND adm-adding-record THEN DO:
        run pi-desformata-campos.        
    END.
    ELSE DO:
        /* Busca as descriá‰es */
        {cdp/cd0602.i3 ct-icm c-conta-icms 
                   sc-icm c-ccusto-icms FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 sc-icm c-ccusto-icms}
        end.
        
        {cdp/cd0602.i3 estabelec.ct-icms-ft c-conta-icms-ft 
                   estabelec.sc-icms-ft c-ccusto-icms-ft FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 estabelec.sc-icms-ft c-ccusto-icms-ft}
        end.
        
        {cdp/cd0602.i3 estabelec.ct-icms-comp c-conta-icms-comp 
                   estabelec.sc-icms-comp c-ccusto-icms-comp FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 estabelec.sc-icms-comp c-ccusto-icms-comp}
        end.
            
        {cdp/cd0602.i3 estabelec.ct-ext-icms c-ct-ext-icms 
                   estabelec.sc-ext-icms c-sc-ext-icms FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 estabelec.sc-ext-icms c-sc-ext-icms}    
        end.      
    end.
    
    RUN pi-habilita-desabilita-ciap-mri.

    /*** Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/   
    IF  l-ciap-mri-ativo THEN DO:
        
        If available estabelec then
           display estabelec.cod-cta-icms-ativ-recup
                   estabelec.cod-ccusto-icms-ativ-recup
                   with frame {&frame-name}.
                    
        {cdp/cd0602.i3 estabelec.cod-cta-icms-ativ-recup c-desc-conta-ativo-rec 
                       estabelec.cod-ccusto-icms-ativ-recup c-desc-ccusto-ativo-rec FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
           {cdp/cd0602.i4 estabelec.cod-ccusto-icms-ativ-recup c-desc-ccusto-ativo-rec}
        end.
    END.    
     
    RUN pi-set-color-label(INPUT 9, INPUT 0).
    run pi-formata-campos.
 
    /* Como alguns campos de centro de custo ficam habilitados, este comando desabilita */
    /* run local-disable-fields. */ 
    
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

   enable ct-icm sc-icm with frame {&frame-name}.
   
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

  {utp/ut-liter.i Conta_Estorno_Icms *}
  assign estabelec.ct-ext-icms:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_Estorno_Icms *}
  assign estabelec.sc-ext-icms:label in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_ICMS_Recuperar: *}
  assign lbl-ct-icm:SCREEN-VALUE in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_ICMS_Recup: *}
  assign lbl-sc-icm:SCREEN-VALUE in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_ICMS_Recolher *}
  assign estabelec.ct-icms-ft:label in frame {&frame-name} = return-value. 
  
  {utp/ut-liter.i Centro_Custo_ICMS_Recolher *}
  assign estabelec.sc-icms-ft:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_ICMS_Complementar *}
  assign estabelec.ct-icms-comp:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_ICMS_Compl *}
  assign estabelec.sc-icms-comp:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_ICMS_Ativo_a_Recuperar *}
  assign estabelec.cod-cta-icms-ativ-recup:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Centro_Custo_ICMS_Ativo_a_Recup *}
  assign estabelec.cod-ccusto-icms-ativ-recup:label in frame {&frame-name} = return-value.


  RUN pi-set-color-label(INPUT 9, 0).


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
    ASSIGN ct-icm                              :format in frame {&frame-name} = "x(20)":u
           sc-icm                              :format in frame {&frame-name} = "x(20)":u
           estabelec.ct-icms-ft                :format in frame {&frame-name} = "x(20)":u
           estabelec.sc-icms-ft                :format in frame {&frame-name} = "x(20)":u
           estabelec.ct-icms-comp              :format in frame {&frame-name} = "x(20)":u
           estabelec.sc-icms-comp              :format in frame {&frame-name} = "x(20)":u
           estabelec.ct-ext-icms               :format in frame {&frame-name} = "x(20)":u
           estabelec.sc-ext-icms               :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-icms-ativ-recup   :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-icms-ativ-recup:format in frame {&frame-name} = "x(20)":u.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.


    
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */   
  IF c-formato-conta <> "" then do:
       if ct-icm:screen-value in frame {&frame-name} <> "" then 
         assign ct-icm:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.ct-icms-ft:screen-value in frame {&frame-name} <> "" then
        assign estabelec.ct-icms-ft:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.ct-icms-comp:screen-value in frame {&frame-name} <> "" then
        assign estabelec.ct-icms-comp:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.ct-ext-icms:screen-value in frame {&frame-name} <> "" then
        assign estabelec.ct-ext-icms:format in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-icms-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-icms-ativ-recup:format in frame {&FRAME-NAME} = c-formato-conta.   
  end.
  if c-formato-ccusto <> "" then do:
      if sc-icm:screen-value in frame {&frame-name} <> "" then
        assign sc-icm:format in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.sc-icms-ft:screen-value in frame {&frame-name} <> "" then
        assign estabelec.sc-icms-ft:format in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.sc-icms-comp:screen-value in frame {&frame-name} <> "" then
        assign estabelec.sc-icms-comp:format in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.sc-ext-icms:screen-value in frame {&frame-name} <> "" then
        assign estabelec.sc-ext-icms:format in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-icms-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-icms-ativ-recup:format in frame {&FRAME-NAME} = c-formato-ccusto.       
  end.           
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-desabilita-ciap-mri V-table-Win 
PROCEDURE pi-habilita-desabilita-ciap-mri :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
    RUN pi-log-ciap-mri.
  
    IF l-ciap-mri-ativo THEN    
       assign estabelec.cod-cta-icms-ativ-recup:hidden    in frame {&frame-name} = NO
              c-desc-conta-ativo-rec:hidden               in frame {&frame-name} = NO
              estabelec.cod-ccusto-icms-ativ-recup:hidden in frame {&frame-name} = NO
              c-desc-ccusto-ativo-rec:hidden              in frame {&frame-name} = NO.           
 
    Else
       assign estabelec.cod-cta-icms-ativ-recup:hidden    in frame {&frame-name} = YES
              c-desc-conta-ativo-rec:hidden               in frame {&frame-name} = YES
              estabelec.cod-ccusto-icms-ativ-recup:hidden in frame {&frame-name} = YES
              c-desc-ccusto-ativo-rec:hidden              in frame {&frame-name} = YES.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-ciap-mri V-table-Win 
PROCEDURE pi-log-ciap-mri :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/

    ASSIGN l-ciap-mri-ativo  = NO.                 
                               
    /**** CIAP ***/
    &if defined (bf_dis_ciap) &then   
        ASSIGN l-ciap-mri-ativo = YES.
    &ELSEIF "{&bf_dis_versao_ems}":U >= "2.04":U &THEN  /*** MRI ***/
        IF {cdp/cd9870.i1 c-cod-estabel  "ems"} THEN 
        /*funcao de integracao do Recebimeto com o RI cadastrada*/
           ASSIGN l-ciap-mri-ativo = YES.  
    &ENDIF
    
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
    {utp/ut-liter.i Conta_ICMS_Recuperar: *}
    ASSIGN lbl-ct-icm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  
    {utp/ut-liter.i Centro_Custo_ICMS_Recup: *}
    ASSIGN lbl-sc-icm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.  

    CASE pi-type:
        WHEN 0 THEN DO:
          ASSIGN lbl-ct-icm:FGCOLOR IN FRAME f-main = pi-color /*9*/ 
                 lbl-sc-icm:FGCOLOR IN FRAME f-main = pi-color. /*9*/
        END.
        WHEN 1 THEN DO:
          ASSIGN lbl-ct-icm:FGCOLOR IN FRAME f-main = pi-color. /*12*/
        END.
        WHEN 2 THEN DO:
          ASSIGN lbl-sc-icm:FGCOLOR IN FRAME f-main = pi-color /*12*/.
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
   
/*
   /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
   RUN pi-log-ciap-mri.    
   IF  l-ciap-mri-ativo THEN DO:
       {cdp/cd0602.i estabelec.cod-cta-icms-ativ-recup}
       if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
          {cdp/cd0602.i0 estabelec.cod-ccusto-icms-ativ-recup}
       end.
   END.
*/
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

           
        IF adm-new-record THEN DO:
            /* Validando contas e centros de custo */
            {cdp/cd0602.i ct-icm}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 sc-icm}
            end.
        END.
                
        {cdp/cd0602.i estabelec.ct-icms-ft}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.sc-icms-ft}
        end.
        
        {cdp/cd0602.i estabelec.ct-icms-comp}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.sc-icms-comp}
        end.
                
        {cdp/cd0602.i estabelec.ct-ext-icms}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.sc-ext-icms}
        end.

        /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
        RUN pi-log-ciap-mri.    
        IF l-ciap-mri-ativo THEN DO:
            {cdp/cd0602.i estabelec.cod-cta-icms-ativ-recup}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 estabelec.cod-ccusto-icms-ativ-recup}
            end.
        END.

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

