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
{include/i-prgvrs.i V03IN587 2.00.00.006 } /*** 010006 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in587 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* global variable definitions */
&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
    &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
        &SCOP l-log-alerta-gestor param-contrat.log-alerta-gestor
        &SCOP l-log-control-alerta param-contrat.log-control-alerta
        &SCOP c-des-email-alerta param-contrat.des-e-mail-alerta
    &ELSE
        &SCOP l-log-alerta-gestor substring(param-contrat.char-1,41,1)
        &SCOP l-log-control-alerta param-contrat.log-2
        &SCOP c-des-email-alerta substring(param-contrat.char-1,1,40)
    &ENDIF
&ENDIF

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var v-row-parent as rowid no-undo.

/* Engenharia Geracao Antecipacao base Evento de Compra */
DEFINE VARIABLE c-formato        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-formato1       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-conta-contabil AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-centro-custo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-empresa        LIKE empresa.ep-codigo NO-UNDO.
DEFINE VARIABLE c-cod-estabel    LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE h_v02in587 AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gc-cod-estabel AS CHARACTER NO-UNDO.

def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var h_api_cta_ctbl     as handle no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
DEF VAR c-desc-conta       AS CHAR   NO-UNDO.
DEF VAR c-desc-ccusto      AS CHAR   NO-UNDO.
def var v_des_ccusto       as char   no-undo.
def var v_cod_ccusto       as char   no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_cod_formato      as char   no-undo.
DEF VAR c-zoom-cod-conta   AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-conta  AS CHAR   NO-UNDO.
DEF VAR c-zoom-cod-ccusto  AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-ccusto AS CHAR   NO-UNDO.
DEF VAR c-formato-ccusto   AS CHAR   NO-UNDO.
DEF VAR c-format-conta     AS CHAR   NO-UNDO.
DEF VAR c-format-ccusto    AS CHAR   NO-UNDO.
DEF VAR i-num-tip-cta-cta  AS INT    NO-UNDO.
DEF VAR i-num-sit-cta      AS INT    NO-UNDO.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.
DEF VAR c-conta            AS CHAR   NO-UNDO.
DEF VAR l-utiliza-cc       AS LOG    NO-UNDO.
def var v_log_utz_ccusto   as log    no-undo.
DEF VAR v_cod_finalid      AS CHAR   NO-UNDO.
DEF VAR v_cod_modul        AS CHAR   NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as int  format ">>>>,>>9":U label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as char format "x(40)":U    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as char format "x(60)":U    label "Mensagem Erro"  column-label "Inconsistˆncia".

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
&Scoped-define EXTERNAL-TABLES param-contrat
&Scoped-define FIRST-EXTERNAL-TABLE param-contrat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-contrat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-contrat.perc-alert-saldo ~
param-contrat.cod-esp-antecip param-contrat.serie-antecip ~
param-contrat.cod-cta-cred-antecip param-contrat.cod-ccusto-cred-antecip 
&Scoped-define ENABLED-TABLES param-contrat
&Scoped-define FIRST-ENABLED-TABLE param-contrat
&Scoped-Define ENABLED-OBJECTS rt-mold rt-mold-2 text-1 
&Scoped-Define DISPLAYED-FIELDS param-contrat.perc-alert-saldo ~
param-contrat.cod-esp-antecip param-contrat.serie-antecip ~
param-contrat.cod-cta-cred-antecip param-contrat.cod-ccusto-cred-antecip 
&Scoped-define DISPLAYED-TABLES param-contrat
&Scoped-define FIRST-DISPLAYED-TABLE param-contrat
&Scoped-Define DISPLAYED-OBJECTS tb-envia-email-gestor ~
tb-controle-alerta-saldo c-email-alert fi-des-especie fi-titulo fi-ccusto ~
text-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-envia-email-gestor ~
tb-controle-alerta-saldo param-contrat.perc-alert-saldo c-email-alert 
&Scoped-define ADM-ASSIGN-FIELDS tb-envia-email-gestor ~
tb-controle-alerta-saldo c-email-alert 
&Scoped-define ADM-MODIFY-FIELDS tb-envia-email-gestor ~
tb-controle-alerta-saldo c-email-alert 

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
DEFINE VARIABLE c-email-alert AS CHARACTER FORMAT "X(40)":U 
     LABEL "E-mail Alerta" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-especie AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U INITIAL "RevisÆo Contrato" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.92.

DEFINE VARIABLE tb-controle-alerta-saldo AS LOGICAL INITIAL no 
     LABEL "Controle de Alerta Saldo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.43 BY .83 NO-UNDO.

DEFINE VARIABLE tb-envia-email-gestor AS LOGICAL INITIAL no 
     LABEL "Envia e-mail  para Gestor T‚cnico" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-envia-email-gestor AT ROW 1.58 COL 18.57 HELP
          "Indica se ser  enviado e-mail para gestor t‚cnico do contrato."
     tb-controle-alerta-saldo AT ROW 2.38 COL 18.57 HELP
          "Indica se o controle de alerta para saldo do contrato est  ativ"
     param-contrat.perc-alert-saldo AT ROW 3.29 COL 16.43 COLON-ALIGNED HELP
          "Percentual de alerta"
          LABEL "Perc Alerta Saldo" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-email-alert AT ROW 4.29 COL 16.43 COLON-ALIGNED HELP
          "Informe o E-mail de Alerta"
     param-contrat.cod-esp-antecip AT ROW 6.5 COL 16.43 COLON-ALIGNED FORMAT "X(02)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     param-contrat.serie-antecip AT ROW 7.5 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     param-contrat.cod-cta-cred-antecip AT ROW 8.5 COL 16.43 COLON-ALIGNED
          LABEL "Conta Cr‚dito"
          VIEW-AS FILL-IN 
          SIZE 20.29 BY .88
     param-contrat.cod-ccusto-cred-antecip AT ROW 9.5 COL 16.43 COLON-ALIGNED
          LABEL "Centro Custo"
          VIEW-AS FILL-IN 
          SIZE 20.29 BY .88
     fi-des-especie AT ROW 6.5 COL 22.86 COLON-ALIGNED NO-LABEL
     fi-titulo AT ROW 8.5 COL 36.86 COLON-ALIGNED NO-LABEL
     fi-ccusto AT ROW 9.5 COL 36.86 COLON-ALIGNED NO-LABEL
     text-1 AT ROW 1.08 COL 2.57 NO-LABEL
     "Gera‡Æo Antecipa‡Æo - Evento" VIEW-AS TEXT
          SIZE 22 BY .71 AT ROW 5.5 COL 2.57
     rt-mold AT ROW 1.38 COL 1
     rt-mold-2 AT ROW 5.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-contrat
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
         HEIGHT             = 9.75
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-email-alert IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN param-contrat.cod-esp-antecip IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN param-contrat.cod-cta-cred-antecip IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-des-especie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN param-contrat.perc-alert-saldo IN FRAME f-main
   1 EXP-LABEL EXP-FORMAT EXP-HELP                                      */
/* SETTINGS FOR FILL-IN param-contrat.cod-ccusto-cred-antecip IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-controle-alerta-saldo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tb-envia-email-gestor IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME param-contrat.cod-esp-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-esp-antecip V-table-Win
ON F5 OF param-contrat.cod-esp-antecip IN FRAME f-main /* Esp‚cie */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=param-contrat.cod-esp-antecip
                       &campozoom=cod-esp
                       &frame=f-main
                       &campo2=fi-des-especie
                       &campozoom2=descricao
                       &frame2=f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-esp-antecip V-table-Win
ON LEAVE OF param-contrat.cod-esp-antecip IN FRAME f-main /* Esp‚cie */
DO:
    RUN pi-leave-especie IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-esp-antecip V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-contrat.cod-esp-antecip IN FRAME f-main /* Esp‚cie */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-contrat.cod-cta-cred-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-cta-cred-antecip V-table-Win
ON ENTRY OF param-contrat.cod-cta-cred-antecip IN FRAME f-main /* Conta Cr‚dito */
DO:
    assign param-contrat.cod-cta-cred-antecip:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)":U
           param-contrat.cod-ccusto-cred-antecip:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-cta-cred-antecip V-table-Win
ON F5 OF param-contrat.cod-cta-cred-antecip IN FRAME f-main /* Conta Cr‚dito */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF c-zoom-cod-conta <> "" THEN
        assign param-contrat.cod-cta-cred-antecip:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
               fi-titulo:screen-value               in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-cta-cred-antecip V-table-Win
ON LEAVE OF param-contrat.cod-cta-cred-antecip IN FRAME f-main /* Conta Cr‚dito */
DO:
    IF param-contrat.cod-cta-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

        ASSIGN c-conta = input frame {&frame-name} param-contrat.cod-cta-cred-antecip.
        ASSIGN c-cod-estabel = "1".
        
        /*RUN Get-Field-Screen-Value IN adm-broker-hdl
     	   (INPUT THIS-PROCEDURE,
     	    INPUT 'it-codigo').*/
        
        
        RUN pi-desc-conta ( INPUT-OUTPUT c-conta,      
                            OUTPUT       c-desc-conta,
                            OUTPUT       l-utiliza-cc).

        IF RETURN-VALUE = "OK":U THEN DO:

            RUN pi-format-conta (OUTPUT c-format-conta).

            ASSIGN param-contrat.cod-cta-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-conta
                   param-contrat.cod-cta-cred-antecip:FORMAT       IN FRAME {&FRAME-NAME} = c-format-conta
                   fi-titulo:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = c-desc-conta.

            IF NOT l-utiliza-cc THEN
                ASSIGN param-contrat.cod-ccusto-cred-antecip:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
                       fi-ccusto:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = ""
                       param-contrat.cod-ccusto-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        END.
        ELSE
            ASSIGN param-contrat.cod-cta-cred-antecip:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)":U
                   param-contrat.cod-cta-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-titulo:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = ""
                   param-contrat.cod-ccusto-cred-antecip:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
                   param-contrat.cod-ccusto-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-ccusto:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE
        ASSIGN param-contrat.cod-cta-cred-antecip:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)":U
               fi-titulo:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = ""
               param-contrat.cod-ccusto-cred-antecip:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               param-contrat.cod-ccusto-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-ccusto:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-cta-cred-antecip V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-contrat.cod-cta-cred-antecip IN FRAME f-main /* Conta Cr‚dito */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-contrat.cod-ccusto-cred-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-ccusto-cred-antecip V-table-Win
ON ENTRY OF param-contrat.cod-ccusto-cred-antecip IN FRAME f-main /* Centro Custo */
DO:
    assign param-contrat.cod-ccusto-cred-antecip:format in frame {&FRAME-NAME} = "x(20)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-ccusto-cred-antecip V-table-Win
ON F5 OF param-contrat.cod-ccusto-cred-antecip IN FRAME f-main /* Centro Custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF RETURN-VALUE = "OK":U THEN do:
        IF c-zoom-cod-ccusto <> "" THEN
        assign param-contrat.cod-ccusto-cred-antecip:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
               fi-ccusto:screen-value               in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
    end. 
    ELSE
        assign param-contrat.cod-ccusto-cred-antecip:screen-value in frame {&FRAME-NAME} = ""
               fi-ccusto:screen-value               in frame {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-ccusto-cred-antecip V-table-Win
ON LEAVE OF param-contrat.cod-ccusto-cred-antecip IN FRAME f-main /* Centro Custo */
DO:
    assign param-contrat.cod-ccusto-cred-antecip:format in frame {&FRAME-NAME} = "x(20)":U.
    
    run pi-format-ccusto (OUTPUT c-format-ccusto).

    RUN pi-desc-ccusto (INPUT  input frame {&frame-name} param-contrat.cod-ccusto-cred-antecip,
                        OUTPUT c-desc-ccusto).

    IF RETURN-VALUE = "OK":U THEN
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-ccusto.
    ELSE
        ASSIGN param-contrat.cod-ccusto-cred-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-ccusto:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = "".
               
    IF not can-find(tt_log_erro) THEN
        assign param-contrat.cod-ccusto-cred-antecip:format in frame {&FRAME-NAME} = c-format-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-ccusto-cred-antecip V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-contrat.cod-ccusto-cred-antecip IN FRAME f-main /* Centro Custo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-controle-alerta-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-controle-alerta-saldo V-table-Win
ON VALUE-CHANGED OF tb-controle-alerta-saldo IN FRAME f-main /* Controle de Alerta Saldo */
DO:
  assign c-email-alert:sensitive in frame {&frame-name} = tb-controle-alerta-saldo:checked in frame {&frame-name}
         mgind.param-contrat.perc-alert-saldo:sensitive in frame {&frame-name} = tb-controle-alerta-saldo:checked in frame {&frame-name}.

  return "OK":U.

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
    {utp/ut-liter.i Envia_e-mail_para_Gestor_T‚cnico * r}
     assign tb-envia-email-gestor:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Controle_de_Alerta_Saldo * r}
     assign tb-controle-alerta-saldo:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i E-mail_Alerta * r}
     assign c-email-alert:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i RevisÆo_Contrato * r}
     assign TEXT-1:SCREEN-VALUE in frame {&frame-name} = trim(return-value).

    /* Engenharia Geracao Antecipacao base Evento de Compra */

    /* Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in */
    param-contrat.cod-esp-antecip:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&FRAME-NAME}.
    param-contrat.cod-cta-cred-antecip:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME {&FRAME-NAME}.
    param-contrat.cod-ccusto-cred-antecip:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/row-list.i "param-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-contrat"}

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
    DEFINE VARIABLE c-aux-email AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-aux-alerta-gestor AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-aux-alerta-gestor AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-aux-control-alerta AS LOGICAL    NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e
       nem na PI-validate. */

    assign c-aux-email          = string(input frame {&frame-name} c-email-alert,"x(40)":U)                               
           l-aux-control-alerta = input frame {&frame-name} tb-controle-alerta-saldo.

    &if "{&bf_mat_versao_ems}" >= "2.06" 
        &then ASSIGN  l-aux-alerta-gestor = input FRAME {&frame-name} tb-envia-email-gestor.
        &ELSE ASSIGN  c-aux-alerta-gestor = if tb-envia-email-gestor:checked in frame {&frame-name} then "1" else "0".
    &endif

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    assign {&c-des-email-alerta}   = c-aux-email  /*erro nesse assign*/
           {&l-log-control-alerta} = l-aux-control-alerta.

    &if "{&bf_mat_versao_ems}" >= "2.06" 
        &then ASSIGN  {&l-log-alerta-gestor} = l-aux-alerta-gestor.
        &ELSE ASSIGN  {&l-log-alerta-gestor} = c-aux-alerta-gestor.
    &endif


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

  delete object h_api_cta_ctbl.
  delete object h_api_ccusto.

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-email-alert            = {&c-des-email-alerta}
           tb-envia-email-gestor    = &if "{&bf_mat_versao_ems}" >= "2.06" &then {&l-log-alerta-gestor}
                                      &else if {&l-log-alerta-gestor} = "1" then YES else NO &endif
           tb-controle-alerta-saldo = {&l-log-control-alerta}.

    ASSIGN param-contrat.cod-cta-cred-antecip:format in frame {&FRAME-NAME} = "x(20)":U
           param-contrat.cod-ccusto-cred-antecip:format in frame {&FRAME-NAME} = "x(20)":U.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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

    APPLY "value-changed":U TO tb-controle-alerta-saldo      IN FRAME {&FRAME-NAME}.
    APPLY "leave":U         TO param-contrat.cod-esp-antecip IN FRAME {&FRAME-NAME}.
    APPLY "leave":U         TO param-contrat.cod-cta-cred-antecip       IN FRAME {&FRAME-NAME}.
    APPLY "leave":U         TO param-contrat.cod-ccusto-cred-antecip       IN FRAME {&FRAME-NAME}.

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

    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    /* Engenharia Geracao Antecipacao base Evento de Compra */
    IF  AVAIL param-contrat THEN
        ASSIGN gc-cod-estabel = param-contrat.cod-estabel.
    ELSE
        ASSIGN gc-cod-estabel = "":U.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = param-contrat.cod-estabel NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN i-empresa = estabelec.ep-codigo.
    ELSE
        ASSIGN i-empresa = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dados-conta V-table-Win 
PROCEDURE pi-busca-dados-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-conta       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-num-tip-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-sit-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-finalid-cta AS INT  NO-UNDO.

    DEF VAR icont AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    
    assign v_cod_cta_ctbl    = p-cod-conta
           i-num-tip-cta-cta = 0
           i-num-sit-cta     = 0
           i-num-finalid-cta = 0.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        STRING(i-empresa),  /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */ 

    FIND FIRST tt_log_erro NO-ERROR.

    IF NOT AVAIL tt_log_erro THEN DO:
        DO icont = 1 TO NUM-ENTRIES(v_ind_finalid_cta):
            IF  {adinc/i05ad049.i 6 entry(icont,v_ind_finalid_cta) } <> 0 THEN DO:
                assign p-num-finalid-cta = {adinc/i05ad049.i 6 entry(icont,v_ind_finalid_cta) }
                       p-num-tip-cta     = v_num_tip_cta_ctbl
                       p-num-sit-cta     = v_num_sit_cta_ctbl.
                RETURN "OK":U.
            END.
        END.
    END.
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-ccusto V-table-Win 
PROCEDURE pi-desc-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ccuto       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    ASSIGN p-desc-ccusto = ''.

    run pi_busca_dados_ccusto in h_api_ccusto (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  p-ccuto,            /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    ASSIGN p-desc-ccusto = v_des_ccusto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-conta V-table-Win 
PROCEDURE pi-desc-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT-OUTPUT PARAM p-conta      AS CHAR NO-UNDO. 
    DEF OUTPUT       PARAM p-desc-conta AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-utiliza-cc AS LOG  NO-UNDO.

    ASSIGN p-desc-conta = ''.

    EMPTY TEMP-TABLE tt_log_erro.
    
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT p-conta,            /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  gc-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-conta,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    ASSIGN p-desc-conta = v_des_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-conta V-table-Win 
PROCEDURE pi-format-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-format-conta AS CHAR NO-UNDO.

    ASSIGN v_cod_formato = ''.

    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  today,              /* DATA DE TRANSACAO */ 
                                                       output v_cod_formato,      /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */

    ASSIGN p-format-conta = v_cod_formato.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-conta V-table-Win 
PROCEDURE pi-format-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-format-ccusto AS CHAR NO-UNDO.

    ASSIGN c-formato-ccusto = ''.

    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */

    ASSIGN p-format-ccusto = c-formato-ccusto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-especie V-table-Win 
PROCEDURE pi-leave-especie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST espec-ap
         WHERE espec-ap.cod-esp = INPUT FRAME {&FRAME-NAME} param-contrat.cod-esp-antecip NO-LOCK NO-ERROR.

    IF  AVAIL espec-ap THEN
        ASSIGN fi-des-especie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(espec-ap.descricao).
    ELSE
        ASSIGN fi-des-especie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conta V-table-Win 
PROCEDURE pi-valida-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-conta AS CHAR NO-UNDO.

    RUN pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                                     input  "CEP":U,              /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  p-cod-conta,        /* CONTA */
                                                     input  "(nenhum)":U,         /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */ 
                                                     output table tt_log_erro). /* ERROS */

    FIND FIRST tt_log_erro NO-ERROR.
    IF AVAIL tt_log_erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro
  ainda nÆo foi criado.
------------------------------------------------------------------------------*/

    /* Validacao de Dicionario */
    {include/i-vldfrm.i}

    /* Engenharia Geracao Antecipacao base Evento de Compra */
    FIND FIRST espec-ap
         WHERE espec-ap.cod-esp = INPUT FRAME {&FRAME-NAME} param-contrat.cod-esp-antecip NO-LOCK NO-ERROR.

    IF  NOT AVAIL espec-ap THEN DO:
        {include/i-vldprg.i}
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Esp‚cie" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "entry":U TO param-contrat.cod-esp-antecip IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    ELSE DO:
        IF  espec-ap.tipo <> 2 THEN DO:
            {utp/ut-liter.i Antecipa‡Æo * R}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 144,
                               INPUT TRIM(RETURN-VALUE)).
            APPLY "entry":U TO param-contrat.cod-esp-antecip IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
    END.

    RUN pi-valida-conta (INPUT input frame {&frame-name} param-contrat.cod-cta-cred-antecip).
    IF RETURN-VALUE = "NOK":U THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 19,
                           INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip).
        APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.


    RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} param-contrat.cod-cta-cred-antecip,
                              OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                              OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                              OUTPUT i-num-finalid-cta). /* conta-contab.estoque */

    IF RETURN-VALUE = "OK":U THEN DO:
        IF  i-num-tip-cta-cta = 6 THEN DO:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 636,
                               INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip).
            APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
    
        IF  i-num-sit-cta <> 3 THEN DO:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 638,
                               INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip).
            APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
    END.

    assign v_cod_finalid = {adinc/i05ad049.i 4 1}
           v_cod_modul   = "APB":U.
    run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  v_cod_modul,        /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip, /* CONTA */
                                                     input  v_cod_finalid,      /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */  
                                                     output table tt_log_erro). /* ERROS */

    IF  RETURN-VALUE = "OK":U THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 637,
                           INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip).
        APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    assign v_cod_finalid = {adinc/i05ad049.i 4 3}
           v_cod_modul   = "APB":U.
    run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  v_cod_modul,        /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip, /* CONTA */
                                                     input  v_cod_finalid,      /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */  
                                                     output table tt_log_erro). /* ERROS */

    IF  RETURN-VALUE = "OK":U THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 289,
                           INPUT "":U).
        APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    assign v_cod_finalid = {adinc/i05ad049.i 4 3}
           v_cod_modul   = "CMG".
    run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  v_cod_modul,        /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip, /* CONTA */
                                                     input  v_cod_finalid,      /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */  
                                                     output table tt_log_erro). /* ERROS */

    IF  RETURN-VALUE = "OK":U THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 639,
                           INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip).
        APPLY "entry":U TO param-contrat.cod-cta-cred-antecip IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  gc-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    
    IF v_log_utz_ccusto THEN DO:
        /* Valida a conta e centro de custo e verifica se o centro de custo informado pertence ao Mapa da conta */
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                        input  gc-cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                        input  "",                 /* UNIDADE NEGàCIO */
                                                        input  "",                 /* PLANO CONTAS */ 
                                                        input  v_cod_cta_ctbl,     /* CONTA */
                                                        input  "",                 /* PLANO CCUSTO */ 
                                                        input  v_cod_ccusto,       /* CCUSTO */
                                                        input  today,              /* DATA TRANSACAO */
                                                        output table tt_log_erro). /* ERROS */
        
        IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK":U THEN DO:
            FOR FIRST tt_log_erro:
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 17006, 
                                   INPUT STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + 
                                         STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + 
                                         tt_log_erro.ttv_des_msg_ajuda).
                RETURN "NOK":U.
            END.
        END.
    END.
    
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ccusto V-table-Win 
PROCEDURE pi-zoom-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-ccusto      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT i-empresa,         /*Empresa*/
                                                   INPUT gc-cod-estabel, /*Estabelecimento */
                                                   INPUT NO,                /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                /*Unidade de Neg¢cio*/
                                                   INPUT "",                /*Plano de Contas*/
                                                   INPUT INPUT FRAME {&FRAME-NAME} param-contrat.cod-cta-cred-antecip, /*C¢digo da Conta*/
                                                   INPUT "",                /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT TODAY,             /*Data da Transa‡Æo*/
                                                   OUTPUT v_cod_ccusto,     /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,     /*Descri‡Æo CCusto*/
                                                   OUTPUT TABLE tt_log_erro ). /*Erros*/  
    ASSIGN p-ccusto      = v_cod_ccusto
           p-desc-ccusto = v_des_ccusto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-conta V-table-Win 
PROCEDURE pi-zoom-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-conta AS CHAR NO-UNDO.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  string(i-empresa),  /* EMPRESA EMS2 */
                                                   input  "CEP":U,              /* M…DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)":U,         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    ASSIGN p-conta      = v_cod_cta_ctbl
           p-desc-conta = v_des_cta_ctbl.

    RETURN "OK":U.

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
  {src/adm/template/snd-list.i "param-contrat"}

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
