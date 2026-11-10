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
{include/i-prgvrs.i V39AD107 2.00.00.029 } /*** 010029 ***/



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
&Scoped-Define ENABLED-FIELDS estabelec.cod-cta-icms-entreg-fut ~
estabelec.cod-ccusto-icms-entreg-fut estabelec.cod-cta-ipi-entreg-fut ~
estabelec.cod-ccusto-ipi-entreg-fut estabelec.cod-cta-pis-entreg-fut ~
estabelec.cod-ccusto-pis-entreg-fut estabelec.cod-cta-cofins-entreg-fut ~
estabelec.cod-ccusto-cofins-entreg-fut 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-cta-icms-entreg-fut ~
estabelec.cod-ccusto-icms-entreg-fut estabelec.cod-cta-ipi-entreg-fut ~
estabelec.cod-ccusto-ipi-entreg-fut estabelec.cod-cta-pis-entreg-fut ~
estabelec.cod-ccusto-pis-entreg-fut estabelec.cod-cta-cofins-entreg-fut ~
estabelec.cod-ccusto-cofins-entreg-fut 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-tit-ct-icms-entreg-fut ~
c-tit-sc-icms-entreg-fut c-tit-ct-ipi-entreg-fut c-tit-sc-ipi-entreg-fut ~
c-tit-ct-pis-entreg-fut c-tit-sc-pis-entreg-fut c-tit-ct-cofins-entreg-fut ~
c-tit-sc-cofins-entreg-fut c-titulo c-titulo-2 

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
DEFINE VARIABLE c-tit-ct-cofins-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-icms-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-ipi-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-pis-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-cofins-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-icms-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-ipi-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-pis-entreg-fut AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .67 NO-UNDO.

DEFINE VARIABLE c-titulo-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-cta-icms-entreg-fut AT ROW 2 COL 22 COLON-ALIGNED WIDGET-ID 20
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-icms-entreg-fut AT ROW 2 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     estabelec.cod-ccusto-icms-entreg-fut AT ROW 3 COL 22 COLON-ALIGNED WIDGET-ID 12
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-icms-entreg-fut AT ROW 3 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     estabelec.cod-cta-ipi-entreg-fut AT ROW 4 COL 22 COLON-ALIGNED WIDGET-ID 34
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-ipi-entreg-fut AT ROW 4 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     estabelec.cod-ccusto-ipi-entreg-fut AT ROW 5 COL 22 COLON-ALIGNED WIDGET-ID 28
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-ipi-entreg-fut AT ROW 5 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     estabelec.cod-cta-pis-entreg-fut AT ROW 7.33 COL 22 COLON-ALIGNED WIDGET-ID 36
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-pis-entreg-fut AT ROW 7.33 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     estabelec.cod-ccusto-pis-entreg-fut AT ROW 8.33 COL 22 COLON-ALIGNED WIDGET-ID 30
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-pis-entreg-fut AT ROW 8.33 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     estabelec.cod-cta-cofins-entreg-fut AT ROW 9.33 COL 22 COLON-ALIGNED WIDGET-ID 32
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-cofins-entreg-fut AT ROW 9.33 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     estabelec.cod-ccusto-cofins-entreg-fut AT ROW 10.33 COL 22 COLON-ALIGNED WIDGET-ID 26
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-cofins-entreg-fut AT ROW 10.33 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     c-titulo AT ROW 1.17 COL 3 NO-LABEL WIDGET-ID 56 DISABLE-AUTO-ZAP 
     c-titulo-2 AT ROW 6.5 COL 3 NO-LABEL WIDGET-ID 58 DISABLE-AUTO-ZAP 
     RECT-2 AT ROW 1.54 COL 2 WIDGET-ID 52
     RECT-3 AT ROW 6.92 COL 2 WIDGET-ID 54
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
         HEIGHT             = 11.38
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN c-tit-ct-cofins-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-ct-cofins-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-tit-ct-icms-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-ipi-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-ct-ipi-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-tit-ct-pis-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-ct-pis-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-tit-sc-cofins-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-sc-cofins-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-tit-sc-icms-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-ipi-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-sc-ipi-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-tit-sc-pis-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tit-sc-pis-entreg-fut:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-titulo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-titulo-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-cofins-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-icms-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-ipi-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-pis-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-cofins-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-icms-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-ipi-entreg-fut IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-pis-entreg-fut IN FRAME f-main
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

&Scoped-define SELF-NAME estabelec.cod-ccusto-cofins-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-ccusto-cofins-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-entreg-fut V-table-Win
ON F5 OF estabelec.cod-ccusto-cofins-entreg-fut IN FRAME f-main
DO:
    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 
   
    IF v_titulo_ccusto <> "" AND NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        ASSIGN estabelec.cod-ccusto-cofins-entreg-fut:SCREEN-VALUE = v_cod_ccusto.
        ASSIGN c-tit-sc-cofins-entreg-fut:SCREEN-VALUE = v_titulo_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-ccusto-cofins-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-entreg-fut c-tit-sc-cofins-entreg-fut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-cofins-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-cofins-entreg-fut IN FRAME f-main
DO:
   APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-icms-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-ccusto-icms-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-entreg-fut V-table-Win
ON F5 OF estabelec.cod-ccusto-icms-entreg-fut IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-icms-entreg-fut:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-icms-entreg-fut:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-ccusto-icms-entreg-fut IN FRAME f-main
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.cod-ccusto-icms-entreg-fut c-tit-sc-icms-entreg-fut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-icms-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-icms-entreg-fut IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-ipi-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-ipi-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-ccusto-ipi-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-ipi-entreg-fut V-table-Win
ON F5 OF estabelec.cod-ccusto-ipi-entreg-fut IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" AND NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
       ASSIGN estabelec.cod-ccusto-ipi-entreg-fut:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-ipi-entreg-fut:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-ipi-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-ccusto-ipi-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i4 estabelec.cod-ccusto-ipi-entreg-fut
                   c-tit-sc-ipi-entreg-fut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-ipi-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-ipi-entreg-fut IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-pis-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-ccusto-pis-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-entreg-fut V-table-Win
ON F5 OF estabelec.cod-ccusto-pis-entreg-fut IN FRAME f-main
DO:
    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 
   
    IF v_titulo_ccusto <> "" and not can-find(first tt_log_erro) THEN DO:
        ASSIGN estabelec.cod-ccusto-pis-entreg-fut:SCREEN-VALUE = v_cod_ccusto.
        ASSIGN c-tit-sc-pis-entreg-fut:SCREEN-VALUE = v_titulo_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-ccusto-pis-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i4 estabelec.cod-ccusto-pis-entreg-fut
                   c-tit-sc-pis-entreg-fut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-pis-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-pis-entreg-fut IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-cofins-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-cta-cofins-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-cofins-entreg-fut WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-entreg-fut V-table-Win
ON F5 OF estabelec.cod-cta-cofins-entreg-fut IN FRAME f-main
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
        ASSIGN estabelec.cod-cta-cofins-entreg-fut:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-tit-ct-cofins-entreg-fut:SCREEN-VALUE = v_titulo_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-cta-cofins-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i3 estabelec.cod-cta-cofins-entreg-fut    c-tit-ct-cofins-entreg-fut
                   estabelec.cod-ccusto-cofins-entreg-fut c-tit-sc-cofins-entreg-fut TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-cofins-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-cofins-entreg-fut IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-icms-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-cta-icms-entreg-fut IN FRAME f-main
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.cod-ccusto-icms-entreg-fut WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-entreg-fut V-table-Win
ON F5 OF estabelec.cod-cta-icms-entreg-fut IN FRAME f-main
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
       ASSIGN estabelec.cod-cta-icms-entreg-fut:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-icms-entreg-fut:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-cta-icms-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i3 estabelec.cod-cta-icms-entreg-fut c-tit-ct-icms-entreg-fut
                   estabelec.cod-ccusto-icms-entreg-fut c-tit-sc-icms-entreg-fut TRUE}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-icms-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-icms-entreg-fut IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-ipi-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-ipi-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-cta-ipi-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-ipi-entreg-fut WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-ipi-entreg-fut V-table-Win
ON F5 OF estabelec.cod-cta-ipi-entreg-fut IN FRAME f-main
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
        ASSIGN estabelec.cod-cta-ipi-entreg-fut:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-tit-ct-ipi-entreg-fut:SCREEN-VALUE = v_titulo_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-ipi-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-cta-ipi-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i3 estabelec.cod-cta-ipi-entreg-fut    c-tit-ct-ipi-entreg-fut
                   estabelec.cod-ccusto-ipi-entreg-fut c-tit-sc-ipi-entreg-fut TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-ipi-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-ipi-entreg-fut IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-pis-entreg-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-entreg-fut V-table-Win
ON ENTRY OF estabelec.cod-cta-pis-entreg-fut IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
   ENABLE estabelec.cod-ccusto-pis-entreg-fut WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-entreg-fut V-table-Win
ON F5 OF estabelec.cod-cta-pis-entreg-fut IN FRAME f-main
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
        ASSIGN estabelec.cod-cta-pis-entreg-fut:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-tit-ct-pis-entreg-fut:SCREEN-VALUE = v_titulo_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-entreg-fut V-table-Win
ON LEAVE OF estabelec.cod-cta-pis-entreg-fut IN FRAME f-main
DO:
    {cdp/cd0602.i3 estabelec.cod-cta-pis-entreg-fut    c-tit-ct-pis-entreg-fut
                   estabelec.cod-ccusto-pis-entreg-fut c-tit-sc-pis-entreg-fut TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-pis-entreg-fut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-pis-entreg-fut IN FRAME f-main
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
  if estabelec.cod-cta-icms-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .
  if estabelec.cod-ccusto-icms-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .

  if  estabelec.cod-cta-ipi-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-ipi-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .

  if  estabelec.cod-cta-pis-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-pis-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .

  if  estabelec.cod-cta-cofins-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .
  if  estabelec.cod-ccusto-cofins-entreg-fut:load-mouse-pointer("image~\lupa.cur") then .

  /* jucinei 01/07/2011 */
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

  {utp/ut-liter.i Entrega_Futura_/_Faturamento_Antecipado * R}
  assign c-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Faturamento_Antecipado * R}
  ASSIGN c-titulo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
 
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
    
    {utp/ut-liter.i Entrega_Futura_/_Faturamento_Antecipado * R}
    assign c-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  
    {utp/ut-liter.i Faturamento_Antecipado * R}
    ASSIGN c-titulo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.          

    /* jucinei 01/07/2011 */
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

   

    /* Busca as descriá‰es */ 
     {cdp/cd0602.i3 estabelec.cod-cta-icms-entreg-fut c-tit-ct-icms-entreg-fut
                    estabelec.cod-ccusto-icms-entreg-fut c-tit-sc-icms-entreg-fut FALSE}
     if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
         {cdp/cd0602.i4 estabelec.cod-ccusto-icms-entreg-fut c-tit-sc-icms-entreg-fut}
     end.

    {cdp/cd0602.i3 estabelec.cod-cta-ipi-entreg-fut c-tit-ct-ipi-entreg-fut
                   estabelec.cod-ccusto-ipi-entreg-fut c-tit-sc-ipi-entreg-fut FALSE}

    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-ipi-entreg-fut c-tit-sc-ipi-entreg-fut}
    end.    

    /* Busca as descriá‰es */
    {cdp/cd0602.i3 estabelec.cod-cta-pis-entreg-fut c-tit-ct-pis-entreg-fut
                   estabelec.cod-ccusto-pis-entreg-fut c-tit-sc-pis-entreg-fut FALSE}

    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-pis-entreg-fut c-tit-sc-pis-entreg-fut}
    end.  

    /* Busca as descriá‰es */
    {cdp/cd0602.i3 estabelec.cod-cta-cofins-entreg-fut c-tit-ct-cofins-entreg-fut
                   estabelec.cod-ccusto-cofins-entreg-fut c-tit-sc-cofins-entreg-fut FALSE}

    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-cofins-entreg-fut c-tit-sc-cofins-entreg-fut}
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
    
  {utp/ut-liter.i Conta_Provis∆o_IPI * R}
  assign estabelec.cod-cta-ipi-entreg-fut:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C._Custo_Provis∆o_IPI * R}
  assign estabelec.cod-ccusto-ipi-entreg-fut:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Entrega_Futura_/_Faturamento_Antecipado * R}
  assign c-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Faturamento_Antecipado * R}
  ASSIGN c-titulo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Conta_ICMS * R}
  assign estabelec.cod-cta-icms-entreg-fut:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_ICMS * R}
  assign estabelec.cod-ccusto-icms-entreg-fut:label in frame {&frame-name} = return-value.
   
  {utp/ut-liter.i Conta_IPI * R}
  assign estabelec.cod-cta-ipi-entreg-fut:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_IPI * R}
  assign estabelec.cod-ccusto-ipi-entreg-fut:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_PIS * R}
  assign estabelec.cod-cta-pis-entreg-fut:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_PIS * R}
  assign estabelec.cod-ccusto-pis-entreg-fut:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_COFINS * R}
  assign estabelec.cod-cta-cofins-entreg-fut:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Centro_Custo_COFINS * R}
  assign estabelec.cod-ccusto-cofins-entreg-fut:label in frame {&frame-name} = return-value.
  
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
ASSIGN estabelec.cod-cta-icms-entreg-fut      :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-ipi-entreg-fut       :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-ipi-entreg-fut    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-pis-entreg-fut       :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-icms-entreg-fut   :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-pis-entreg-fut    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-cta-cofins-entreg-fut    :format in frame {&frame-name} = "x(20)":u
           estabelec.cod-ccusto-cofins-entreg-fut :format in frame {&frame-name} = "x(20)":u.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.
    
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */    
  if c-formato-conta <> "" then do:
      IF estabelec.cod-cta-icms-entreg-fut:screen-value in frame {&frame-name} <> "" then
         ASSIGN estabelec.cod-cta-icms-entreg-fut:FORMAT    in frame {&FRAME-NAME} = c-formato-conta.

      if estabelec.cod-cta-ipi-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-ipi-entreg-fut:FORMAT    in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-pis-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-pis-entreg-fut:format    in frame {&FRAME-NAME} = c-formato-conta.
      
      if estabelec.cod-cta-cofins-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-cofins-entreg-fut:format in frame {&FRAME-NAME} = c-formato-conta.
  end.
 
  if c-formato-ccusto <> "" then do:
      IF estabelec.cod-ccusto-icms-entreg-fut:screen-value in frame {&frame-name} <> "" then
         ASSIGN estabelec.cod-ccusto-icms-entreg-fut:format    in frame {&FRAME-NAME} = c-formato-ccusto.

      if estabelec.cod-ccusto-ipi-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-ipi-entreg-fut:format    in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-pis-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-pis-entreg-fut:format    in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if estabelec.cod-ccusto-cofins-entreg-fut:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-cofins-entreg-fut:format in frame {&FRAME-NAME} = c-formato-ccusto.
  end.           
  
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
        {cdp/cd0602.i estabelec.cod-cta-icms-entreg-fut}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-icms-entreg-fut}  
        end.
        
        {cdp/cd0602.i estabelec.cod-cta-ipi-entreg-fut}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-ipi-entreg-fut}
        end. 

        /* Validando contas e centros de custo */
        {cdp/cd0602.i estabelec.cod-cta-pis-entreg-fut}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-pis-entreg-fut}
        end. 

        /* Validando contas e centros de custo */
        {cdp/cd0602.i estabelec.cod-cta-cofins-entreg-fut}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-cofins-entreg-fut}
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

