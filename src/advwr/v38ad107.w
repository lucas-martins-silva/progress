&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V38AD107 2.00.00.020 } /*** 010020 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v38ad107 MUT}
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
&Scoped-Define ENABLED-FIELDS estabelec.cod-cta-pis-substto ~
estabelec.cod-ccusto-pis-substto estabelec.cod-cta-cofins-substto ~
estabelec.cod-ccusto-cofins-substto estabelec.cod-cta-pis-ativ-recup ~
estabelec.cod-ccusto-pis-ativ-recup estabelec.cod-cta-cofins-ativ-recup ~
estabelec.cod-ccusto-cofins-ativ-recup 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-cta-pis-substto ~
estabelec.cod-ccusto-pis-substto estabelec.cod-cta-cofins-substto ~
estabelec.cod-ccusto-cofins-substto estabelec.cod-cta-pis-ativ-recup ~
estabelec.cod-ccusto-pis-ativ-recup estabelec.cod-cta-cofins-ativ-recup ~
estabelec.cod-ccusto-cofins-ativ-recup 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-tit-ct-pis-subst-recup ~
c-tit-sc-pis-subst-recup c-tit-ct-cofins-subst-recup ~
c-tit-sc-cofins-subst-recup c-tit-ct-pis-ativo-recup ~
c-tit-sc-pis-ativo-recup c-tit-ct-cofins-ativo-recup ~
c-tit-sc-cofins-ativo-recup 

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
DEFINE VARIABLE c-tit-ct-cofins-ativo-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-cofins-subst-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-pis-ativo-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-pis-subst-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-cofins-ativo-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-cofins-subst-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-pis-ativo-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-pis-subst-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-cta-pis-substto AT ROW 2.46 COL 22 COLON-ALIGNED WIDGET-ID 24
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-pis-subst-recup AT ROW 2.46 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-pis-substto AT ROW 3.46 COL 22 COLON-ALIGNED WIDGET-ID 16
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-pis-subst-recup AT ROW 3.46 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     estabelec.cod-cta-cofins-substto AT ROW 4.63 COL 22 COLON-ALIGNED WIDGET-ID 20
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-cofins-subst-recup AT ROW 4.63 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-cofins-substto AT ROW 5.63 COL 22 COLON-ALIGNED WIDGET-ID 12
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-cofins-subst-recup AT ROW 5.63 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     estabelec.cod-cta-pis-ativ-recup AT ROW 6.79 COL 22 COLON-ALIGNED WIDGET-ID 22
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-pis-ativo-recup AT ROW 6.79 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-pis-ativ-recup AT ROW 7.79 COL 22 COLON-ALIGNED WIDGET-ID 14
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-pis-ativo-recup AT ROW 7.79 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     estabelec.cod-cta-cofins-ativ-recup AT ROW 8.96 COL 22 COLON-ALIGNED WIDGET-ID 18
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-cofins-ativo-recup AT ROW 8.96 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-cofins-ativ-recup AT ROW 9.96 COL 22 COLON-ALIGNED WIDGET-ID 10
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-cofins-ativo-recup AT ROW 9.96 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.estabelec
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

/* SETTINGS FOR FILL-IN c-tit-ct-cofins-ativo-recup IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-ct-cofins-ativo-recup:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tit-ct-cofins-subst-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-pis-ativo-recup IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-ct-pis-ativo-recup:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tit-ct-pis-subst-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-cofins-ativo-recup IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-sc-cofins-ativo-recup:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tit-sc-cofins-subst-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-pis-ativo-recup IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-sc-pis-ativo-recup:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tit-sc-pis-subst-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-cofins-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-cofins-substto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-pis-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-pis-substto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-cofins-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-cofins-substto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-pis-ativ-recup IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-pis-substto IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME estabelec.cod-ccusto-cofins-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-ccusto-cofins-ativ-recup IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-ativ-recup V-table-Win
ON F5 OF estabelec.cod-ccusto-cofins-ativ-recup IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-cofins-ativ-recup:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-cofins-ativo-recup:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-ccusto-cofins-ativ-recup IN FRAME f-main
DO:
   {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-ativ-recup c-tit-sc-cofins-ativo-recup} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-cofins-ativ-recup IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-cofins-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-substto V-table-Win
ON ENTRY OF estabelec.cod-ccusto-cofins-substto IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-substto V-table-Win
ON F5 OF estabelec.cod-ccusto-cofins-substto IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-cofins-substto:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-cofins-subst-recup:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-substto V-table-Win
ON LEAVE OF estabelec.cod-ccusto-cofins-substto IN FRAME f-main
DO:
   {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-substto c-tit-sc-cofins-subst-recup}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-cofins-substto IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-pis-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-ccusto-pis-ativ-recup IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-ativ-recup V-table-Win
ON F5 OF estabelec.cod-ccusto-pis-ativ-recup IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-pis-ativ-recup:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-pis-ativo-recup:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-ccusto-pis-ativ-recup IN FRAME f-main
DO:
   {cdp/cd0602.i4 estabelec.cod-ccusto-pis-ativ-recup c-tit-sc-pis-ativo-recup}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-pis-ativ-recup IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-pis-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-substto V-table-Win
ON ENTRY OF estabelec.cod-ccusto-pis-substto IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-substto V-table-Win
ON F5 OF estabelec.cod-ccusto-pis-substto IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-pis-substto:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-pis-subst-recup:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-substto V-table-Win
ON LEAVE OF estabelec.cod-ccusto-pis-substto IN FRAME f-main
DO:
   {cdp/cd0602.i4 estabelec.cod-ccusto-pis-substto c-tit-sc-pis-subst-recup}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-pis-substto IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-cofins-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-cta-cofins-ativ-recup IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-cofins-ativ-recup WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-ativ-recup V-table-Win
ON F5 OF estabelec.cod-cta-cofins-ativ-recup IN FRAME f-main
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
      ASSIGN estabelec.cod-cta-cofins-ativ-recup:SCREEN-VALUE = v_cod_cta_ctbl.
      ASSIGN c-tit-ct-cofins-ativo-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-cta-cofins-ativ-recup IN FRAME f-main
DO:
   {cdp/cd0602.i3 estabelec.cod-cta-cofins-ativ-recup c-tit-ct-cofins-ativo-recup
                  estabelec.cod-ccusto-cofins-ativ-recup c-tit-sc-cofins-ativo-recup TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-cofins-ativ-recup IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-cofins-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-substto V-table-Win
ON ENTRY OF estabelec.cod-cta-cofins-substto IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-cofins-substto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-substto V-table-Win
ON F5 OF estabelec.cod-cta-cofins-substto IN FRAME f-main
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
       ASSIGN estabelec.cod-cta-cofins-substto:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-cofins-subst-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-substto V-table-Win
ON LEAVE OF estabelec.cod-cta-cofins-substto IN FRAME f-main
DO:
   {cdp/cd0602.i3 estabelec.cod-cta-cofins-substto c-tit-ct-cofins-subst-recup
                  estabelec.cod-ccusto-cofins-substto c-tit-sc-cofins-subst-recup TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-cofins-substto IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-pis-ativ-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-ativ-recup V-table-Win
ON ENTRY OF estabelec.cod-cta-pis-ativ-recup IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-pis-ativ-recup WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-ativ-recup V-table-Win
ON F5 OF estabelec.cod-cta-pis-ativ-recup IN FRAME f-main
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
       ASSIGN estabelec.cod-cta-pis-ativ-recup:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-pis-ativo-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-ativ-recup V-table-Win
ON LEAVE OF estabelec.cod-cta-pis-ativ-recup IN FRAME f-main
DO:
   {cdp/cd0602.i3 estabelec.cod-cta-pis-ativ-recup c-tit-ct-pis-ativo-recup
                  estabelec.cod-ccusto-pis-ativ-recup c-tit-sc-pis-ativo-recup TRUE} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-ativ-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-pis-ativ-recup IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-pis-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-substto V-table-Win
ON ENTRY OF estabelec.cod-cta-pis-substto IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-pis-substto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-substto V-table-Win
ON F5 OF estabelec.cod-cta-pis-substto IN FRAME f-main
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
       ASSIGN estabelec.cod-cta-pis-substto:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-pis-subst-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-substto V-table-Win
ON LEAVE OF estabelec.cod-cta-pis-substto IN FRAME f-main
DO:
   {cdp/cd0602.i3 estabelec.cod-cta-pis-substto c-tit-ct-pis-subst-recup
                  estabelec.cod-ccusto-pis-substto c-tit-sc-pis-subst-recup TRUE} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-pis-substto IN FRAME f-main
DO:
   apply "F5" to self.
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

  if estabelec.cod-cta-pis-substto:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-ccusto-pis-substto:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-cta-cofins-substto:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-ccusto-cofins-substto:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-cta-pis-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-ccusto-pis-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-cta-cofins-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .                  
  if estabelec.cod-ccusto-cofins-ativ-recup:load-mouse-pointer("image~\lupa.cur") then .

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
  /* Ponha na pi-validate todas as validaÓÔes */
  /* N“o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  IF i-pais-impto-usuario = 1 THEN DO:
      /* Todos os assignµs n“o feitos pelo assign-record devem ser feitos aqui */  
      /* Code placed here will execute AFTER standard behavior.    */
      
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
        
      assign estabelec.cod-cta-pis-substto        = input frame {&frame-name} estabelec.cod-cta-pis-substto.
      assign estabelec.cod-cta-cofins-substto     = input frame {&frame-name} estabelec.cod-cta-cofins-substto.    
      assign estabelec.cod-ccusto-pis-substto       = input frame {&frame-name} estabelec.cod-ccusto-pis-substto.
      assign estabelec.cod-ccusto-cofins-substto    = input frame {&frame-name} estabelec.cod-ccusto-cofins-substto. 

      /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
      RUN pi-log-ciap-mri.    
      IF  l-ciap-mri-ativo THEN DO:
          assign estabelec.cod-cta-pis-ativ-recup     = input frame {&frame-name} estabelec.cod-cta-pis-ativ-recup.
          ASSIGN estabelec.cod-cta-cofins-ativ-recup  = input frame {&frame-name} estabelec.cod-cta-cofins-ativ-recup.

          assign estabelec.cod-ccusto-pis-ativ-recup    = input frame {&frame-name} estabelec.cod-ccusto-pis-ativ-recup.
          ASSIGN estabelec.cod-ccusto-cofins-ativ-recup = input frame {&frame-name} estabelec.cod-ccusto-cofins-ativ-recup.

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
  
  DISABLE estabelec.cod-cta-pis-substto WITH FRAME {&FRAME-NAME}.
  DISABLE estabelec.cod-ccusto-pis-substto WITH FRAME {&FRAME-NAME}.
  DISABLE estabelec.cod-cta-cofins-substto WITH FRAME {&FRAME-NAME}.
  DISABLE estabelec.cod-ccusto-cofins-substto WITH FRAME {&FRAME-NAME}.

  RUN pi-habilita-desabilita-ciap-mri.

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
                
    RUN pi-habilita-desabilita-ciap-mri.

    /*** Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/   
    IF  l-ciap-mri-ativo THEN DO:

        /* Busca as descriá‰es */
        {cdp/cd0602.i3 estabelec.cod-cta-pis-ativ-recup c-tit-ct-pis-ativo-recup
                       estabelec.cod-ccusto-pis-ativ-recup c-tit-sc-pis-ativo-recup FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 estabelec.cod-ccusto-pis-ativ-recup c-tit-sc-pis-ativo-recup}
        end.
        
        {cdp/cd0602.i3 estabelec.cod-cta-cofins-ativ-recup c-tit-ct-cofins-ativo-recup
                       estabelec.cod-ccusto-cofins-ativ-recup c-tit-sc-cofins-ativo-recup FALSE}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-ativ-recup c-tit-sc-cofins-ativo-recup}
        end.

    END.

    /* Busca as descriá‰es */
    {cdp/cd0602.i3 estabelec.cod-cta-pis-substto c-tit-ct-pis-subst-recup
                   estabelec.cod-ccusto-pis-substto c-tit-sc-pis-subst-recup FALSE}      
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-pis-substto c-tit-sc-pis-subst-recup}
    end.    
    
    {cdp/cd0602.i3 estabelec.cod-cta-cofins-substto c-tit-ct-cofins-subst-recup
                   estabelec.cod-ccusto-cofins-substto c-tit-sc-cofins-subst-recup FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-substto c-tit-sc-cofins-subst-recup}
    end.  

    RUN pi-formata-campos.   
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
  
  ENABLE estabelec.cod-cta-pis-substto WITH FRAME {&FRAME-NAME}.
  ENABLE estabelec.cod-ccusto-pis-substto WITH FRAME {&FRAME-NAME}.
  ENABLE estabelec.cod-cta-cofins-substto WITH FRAME {&FRAME-NAME}.
  ENABLE estabelec.cod-ccusto-cofins-substto WITH FRAME {&FRAME-NAME}.

  
  IF adm-new-record AND adm-adding-record THEN DO:
    run pi-desformata-campos.  
  END.

  run pi-habilita-desabilita-ciap-mri.

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

  {utp/ut-liter.i Conta_PIS_Ativo_Recup * R}
  assign estabelec.cod-cta-pis-ativ-recup:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C_Custo_PIS_Ativo_Recup * R}
  assign estabelec.cod-ccusto-pis-ativ-recup:label in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_COFINS_Ativo_Recup * R}
  assign estabelec.cod-cta-cofins-ativ-recup:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C_Custo_COFINS_Ativo_Recup * R}
  assign estabelec.cod-ccusto-cofins-ativ-recup:label in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Conta_PIS_Subst_Recuperar * R}
  assign estabelec.cod-cta-pis-substto:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C_Custo_PIS_Subst_Recuperar * R}
  assign estabelec.cod-ccusto-pis-substto:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_COFINS_Subst_Recuperar * R}
  assign estabelec.cod-cta-cofins-substto:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C_Custo_COFINS_Subst_Recup * R}
  assign estabelec.cod-ccusto-cofins-substto:label in frame {&frame-name} = return-value.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :

  run pi-desformata-campos.
    
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */
  if c-formato-conta <> "" then do:
      if estabelec.cod-cta-pis-substto:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-pis-substto:format       in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-cofins-substto:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-cofins-substto:format    in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-pis-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-pis-ativ-recup:format    in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-cofins-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-cofins-ativ-recup:format IN frame {&FRAME-NAME} = c-formato-conta.   
  end.
  if c-formato-ccusto <> "" then do:
      if estabelec.cod-ccusto-pis-substto:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-pis-substto:format       in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-cofins-substto:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-cofins-substto:format    IN frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-pis-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-pis-ativ-recup:format    in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-cofins-ativ-recup:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-cofins-ativ-recup:format in frame {&FRAME-NAME} = c-formato-ccusto.       
  end.           
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :

    ASSIGN estabelec.cod-cta-pis-ativ-recup       :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-pis-ativ-recup    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-cofins-ativ-recup    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-cofins-ativ-recup :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-pis-substto          :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-pis-substto       :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-cofins-substto       :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-cofins-substto    :format in frame {&frame-name} = "x(20)":u.
  
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

  RUN pi-log-ciap-mri.
  
  /* PIS */
  IF l-ciap-mri-ativo THEN
      assign estabelec.cod-cta-pis-ativ-recup:hidden     in frame {&frame-name} = NO
             c-tit-ct-pis-ativo-recup:hidden             in frame {&frame-name} = NO
             estabelec.cod-ccusto-pis-ativ-recup:hidden  in frame {&frame-name} = NO
             c-tit-sc-pis-ativo-recup:hidden             in frame {&frame-name} = NO.
  ELSE
      assign estabelec.cod-cta-pis-ativ-recup:hidden     in frame {&frame-name} = YES
             c-tit-ct-pis-ativo-recup:hidden             in frame {&frame-name} = YES
             estabelec.cod-ccusto-pis-ativ-recup:hidden  in frame {&frame-name} = YES
             c-tit-sc-pis-ativo-recup:hidden             in frame {&frame-name} = YES.

  /* COFINS */
  IF l-ciap-mri-ativo THEN
      assign estabelec.cod-cta-cofins-ativ-recup:hidden     in frame {&frame-name} = NO
             c-tit-ct-cofins-ativo-recup:hidden             in frame {&frame-name} = NO
             estabelec.cod-ccusto-cofins-ativ-recup:hidden  in frame {&frame-name} = NO
             c-tit-sc-cofins-ativo-recup:hidden             in frame {&frame-name} = NO.
  ELSE
      assign estabelec.cod-cta-cofins-ativ-recup:hidden     in frame {&frame-name} = YES
             c-tit-ct-cofins-ativo-recup:hidden             in frame {&frame-name} = YES
             estabelec.cod-ccusto-cofins-ativ-recup:hidden  in frame {&frame-name} = YES
             c-tit-sc-cofins-ativo-recup:hidden             in frame {&frame-name} = YES.    

  /* Atualiza as vari†veis de tela, pois elas podem estar escondidas no momento da atualizaá∆o pelo padr∆o */
  IF  l-ciap-mri-ativo AND AVAIL estabelec THEN
      ASSIGN estabelec.cod-cta-pis-ativ-recup:SCREEN-VALUE       IN FRAME {&Frame-name} = estabelec.cod-cta-pis-ativ-recup
             estabelec.cod-ccusto-pis-ativ-recup:SCREEN-VALUE    IN FRAME {&Frame-name} = estabelec.cod-ccusto-pis-ativ-recup
             estabelec.cod-cta-cofins-ativ-recup:SCREEN-VALUE    IN FRAME {&Frame-name} = estabelec.cod-cta-cofins-ativ-recup
             estabelec.cod-ccusto-cofins-ativ-recup:SCREEN-VALUE IN FRAME {&Frame-name} = estabelec.cod-ccusto-cofins-ativ-recup.

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
        IF {cdp/cd9870.i1 c-cod-estabel "ems"} THEN /*funcao de integracao do Recebimeto com o RI cadastrada*/
           ASSIGN l-ciap-mri-ativo = YES.  
    &ENDIF

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

   run pi-habilita-desabilita-ciap-mri.
   
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
        {cdp/cd0602.i estabelec.cod-cta-pis-substto}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-pis-substto}
        end. 
              
        {cdp/cd0602.i estabelec.cod-cta-cofins-substto}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-cofins-substto}
        end.

        /*** ICMS ATIVO A RECUPERAR - Habilitado se a rotina de CIAP estiver ativa ou o M¢dulo de MRI estiver integrado ao EMS ***/
        RUN pi-log-ciap-mri.    
        IF  l-ciap-mri-ativo THEN DO:
            {cdp/cd0602.i estabelec.cod-cta-pis-ativ-recup}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 estabelec.cod-ccusto-pis-ativ-recup}
            end.
                        
            {cdp/cd0602.i estabelec.cod-cta-cofins-ativ-recup}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 estabelec.cod-ccusto-cofins-ativ-recup}            
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

