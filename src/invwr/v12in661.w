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
{include/i-prgvrs.i V12IN661 2.00.00.018 } /*** "010018" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V12IN661 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEF VAR i-empresa          LIKE param-global.empresa-prin NO-UNDO.

DEF VAR c-zoom-cod-conta   AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-conta  AS CHAR   NO-UNDO.
DEF VAR c-zoom-cod-ccusto  AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-ccusto AS CHAR   NO-UNDO.
DEF VAR c-conta            AS CHAR   NO-UNDO.
DEF VAR i-num-tip-cta-cta  AS INT    NO-UNDO.
DEF VAR i-num-sit-cta      AS INT    NO-UNDO.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.
DEF VAR l-utiliza-cc       AS LOG    NO-UNDO.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo.
def var c-cod-estabel           as CHAR no-undo.

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.


def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as int  format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as char format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as char format "x(60)"    label "Mensagem Erro"  column-label "Inconsistˆncia"
    .

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
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estab-mat.cod-cta-e-benef-unif ~
estab-mat.cod-ccusto-e-benef-unif estab-mat.cod-cta-saida-benef-unif ~
estab-mat.cod-ccusto-saida-benef-unif estab-mat.cod-cta-contag-f-unif ~
estab-mat.cod-ccusto-contag-f-unif estab-mat.cod-cta-absor-unif ~
estab-mat.cod-ccusto-absor-unif 
&Scoped-define ENABLED-TABLES estab-mat
&Scoped-define FIRST-ENABLED-TABLE estab-mat
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS estab-mat.cod-cta-e-benef-unif ~
estab-mat.cod-ccusto-e-benef-unif estab-mat.cod-cta-saida-benef-unif ~
estab-mat.cod-ccusto-saida-benef-unif estab-mat.cod-cta-contag-f-unif ~
estab-mat.cod-ccusto-contag-f-unif estab-mat.cod-cta-absor-unif ~
estab-mat.cod-ccusto-absor-unif 
&Scoped-define DISPLAYED-TABLES estab-mat
&Scoped-define FIRST-DISPLAYED-TABLE estab-mat
&Scoped-Define DISPLAYED-OBJECTS c-desc-ent-benef ~
c-desc-ccusto-e-benef-unif c-desc-sai-benef c-desc-ccusto-saida-benef ~
c-desc-contagem-fisico c-desc-cod-ccusto-contag-f-unif ~
c-desc-abs-residual-medio c-desc-cod-ccusto-absor-unif 

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
DEFINE VARIABLE c-desc-abs-residual-medio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-e-benef-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-saida-benef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cod-ccusto-absor-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cod-ccusto-contag-f-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-contagem-fisico AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ent-benef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE c-desc-sai-benef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 10.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-mat.cod-cta-e-benef-unif AT ROW 1.25 COL 27.86 COLON-ALIGNED WIDGET-ID 42
          LABEL "Conta Entrada Beneficiamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-ent-benef AT ROW 1.25 COL 47.86 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-e-benef-unif AT ROW 2.17 COL 27.86 COLON-ALIGNED WIDGET-ID 38
          LABEL "Centro de custo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-ccusto-e-benef-unif AT ROW 2.17 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     estab-mat.cod-cta-saida-benef-unif AT ROW 3.29 COL 27.86 COLON-ALIGNED WIDGET-ID 44
          LABEL "Conta Saida Beneficiamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-sai-benef AT ROW 3.29 COL 47.86 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-saida-benef-unif AT ROW 4.21 COL 27.86 COLON-ALIGNED WIDGET-ID 40
          LABEL "Centro de custo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-ccusto-saida-benef AT ROW 4.21 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     estab-mat.cod-cta-contag-f-unif AT ROW 5.33 COL 27.86 COLON-ALIGNED WIDGET-ID 54
          LABEL "Conta Contagem Fisico"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-contagem-fisico AT ROW 5.33 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     estab-mat.cod-ccusto-contag-f-unif AT ROW 6.25 COL 27.86 COLON-ALIGNED WIDGET-ID 48
          LABEL "Centro de custo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-cod-ccusto-contag-f-unif AT ROW 6.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     estab-mat.cod-cta-absor-unif AT ROW 7.38 COL 27.86 COLON-ALIGNED WIDGET-ID 52
          LABEL "Conta Absorcao"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-abs-residual-medio AT ROW 7.38 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     estab-mat.cod-ccusto-absor-unif AT ROW 8.29 COL 27.86 COLON-ALIGNED WIDGET-ID 46
          LABEL "Centro de custo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-cod-ccusto-absor-unif AT ROW 8.29 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     rt-mold AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
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
         HEIGHT             = 10.5
         WIDTH              = 91.29.
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

/* SETTINGS FOR FILL-IN c-desc-abs-residual-medio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-e-benef-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-saida-benef IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cod-ccusto-absor-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cod-ccusto-contag-f-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-contagem-fisico IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ent-benef IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sai-benef IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-absor-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-contag-f-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-e-benef-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-saida-benef-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-contag-f-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-e-benef-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-saida-benef-unif IN FRAME f-main
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

&Scoped-define SELF-NAME estab-mat.cod-ccusto-absor-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-absor-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-absor-unif IN FRAME f-main /* Centro de custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-absor-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-absor-unif IN FRAME f-main /* Centro de custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-ccusto-absor-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
              c-desc-cod-ccusto-absor-unif:screen-value    in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-absor-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-absor-unif IN FRAME f-main /* Centro de custo */
DO:
    {cdp/cd0602.i4 estab-mat.cod-ccusto-absor-unif c-desc-cod-ccusto-absor-unif}        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-absor-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-absor-unif IN FRAME f-main /* Centro de custo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-contag-f-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-contag-f-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-contag-f-unif IN FRAME f-main /* Centro de custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-contag-f-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-contag-f-unif IN FRAME f-main /* Centro de custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-ccusto-contag-f-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
              c-desc-cod-ccusto-contag-f-unif:screen-value    in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-contag-f-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-contag-f-unif IN FRAME f-main /* Centro de custo */
DO:
    {cdp/cd0602.i4 estab-mat.cod-ccusto-contag-f-unif c-desc-cod-ccusto-contag-f-unif}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-contag-f-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-contag-f-unif IN FRAME f-main /* Centro de custo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-e-benef-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-e-benef-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-e-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-e-benef-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-e-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-ccusto-e-benef-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
              c-desc-ccusto-e-benef-unif:screen-value        in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-e-benef-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-e-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    {cdp/cd0602.i4 estab-mat.cod-ccusto-e-benef-unif c-desc-ccusto-e-benef-unif}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-e-benef-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-e-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-saida-benef-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-saida-benef-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-saida-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-saida-benef-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-saida-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-ccusto-saida-benef-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
              c-desc-ccusto-saida-benef:screen-value             in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-saida-benef-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-saida-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    {cdp/cd0602.i4 estab-mat.cod-ccusto-saida-benef-unif c-desc-ccusto-saida-benef}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-saida-benef-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-saida-benef-unif IN FRAME f-main /* Centro de custo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-absor-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-absor-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-absor-unif IN FRAME f-main /* Conta Absorcao Unificado */
DO:
    ASSIGN SELF:FORMAT = "x(20)"
           estab-mat.cod-ccusto-absor-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-absor-unif V-table-Win
ON F5 OF estab-mat.cod-cta-absor-unif IN FRAME f-main /* Conta Absorcao Unificado */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-cta-absor-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-abs-residual-medio:screen-value    in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-absor-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-absor-unif IN FRAME f-main /* Conta Absorcao Unificado */
DO:
   {cdp/cd0602.i3 estab-mat.cod-cta-absor-unif c-desc-abs-residual-medio
                  estab-mat.cod-ccusto-absor-unif c-desc-cod-ccusto-absor-unif TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-absor-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-absor-unif IN FRAME f-main /* Conta Absorcao Unificado */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-contag-f-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-contag-f-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-contag-f-unif IN FRAME f-main /* Conta Contagem Fisico Unif. */
DO:
    ASSIGN SELF:FORMAT = "x(20)"
           estab-mat.cod-ccusto-contag-f-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-contag-f-unif V-table-Win
ON F5 OF estab-mat.cod-cta-contag-f-unif IN FRAME f-main /* Conta Contagem Fisico Unif. */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-cta-contag-f-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-contagem-fisico:screen-value          in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-contag-f-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-contag-f-unif IN FRAME f-main /* Conta Contagem Fisico Unif. */
DO:
    {cdp/cd0602.i3 estab-mat.cod-cta-contag-f-unif c-desc-contagem-fisico
                   estab-mat.cod-ccusto-contag-f-unif c-desc-cod-ccusto-contag-f-unif TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-contag-f-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-contag-f-unif IN FRAME f-main /* Conta Contagem Fisico Unif. */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-e-benef-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-e-benef-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-e-benef-unif IN FRAME f-main /* Conta Entrada Beneficiamento */
DO:
    ASSIGN SELF:FORMAT = "x(20)"
           estab-mat.cod-ccusto-e-benef-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-e-benef-unif V-table-Win
ON F5 OF estab-mat.cod-cta-e-benef-unif IN FRAME f-main /* Conta Entrada Beneficiamento */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    assign estab-mat.cod-cta-e-benef-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
           c-desc-ent-benef:screen-value               in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-e-benef-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-e-benef-unif IN FRAME f-main /* Conta Entrada Beneficiamento */
DO:
    {cdp/cd0602.i3 estab-mat.cod-cta-e-benef-unif c-desc-ent-benef
                   estab-mat.cod-ccusto-e-benef-unif c-desc-ccusto-e-benef-unif TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-e-benef-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-e-benef-unif IN FRAME f-main /* Conta Entrada Beneficiamento */
DO:
    apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-saida-benef-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-saida-benef-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-saida-benef-unif IN FRAME f-main /* Conta Saida Beneficiamento */
DO:
    ASSIGN SELF:FORMAT = "x(20)"
           estab-mat.cod-ccusto-saida-benef-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-saida-benef-unif V-table-Win
ON F5 OF estab-mat.cod-cta-saida-benef-unif IN FRAME f-main /* Conta Saida Beneficiamento */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-cta-saida-benef-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-sai-benef:screen-value                   in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-saida-benef-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-saida-benef-unif IN FRAME f-main /* Conta Saida Beneficiamento */
DO:
    {cdp/cd0602.i3 estab-mat.cod-cta-saida-benef-unif c-desc-sai-benef
                   estab-mat.cod-ccusto-saida-benef-unif c-desc-ccusto-saida-benef TRUE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-saida-benef-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-saida-benef-unif IN FRAME f-main /* Conta Saida Beneficiamento */
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

  if estab-mat.cod-cta-e-benef-unif:load-mouse-pointer("image/lupa.cur")        in frame {&frame-name} then.
  if estab-mat.cod-ccusto-e-benef-unif:load-mouse-pointer("image/lupa.cur")     in frame {&frame-name} then.
  if estab-mat.cod-cta-saida-benef-unif:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then.
  if estab-mat.cod-ccusto-saida-benef-unif:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
  
  if estab-mat.cod-cta-contag-f-unif:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then.
  if estab-mat.cod-ccusto-contag-f-unif:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then.
  if estab-mat.cod-cta-absor-unif:load-mouse-pointer("image/lupa.cur")          in frame {&frame-name} then.
  if estab-mat.cod-ccusto-absor-unif:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

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
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /*if AVAIL estab-mat THEN
      ASSIGN estab-mat.cod-cta-contag-f-unif      = INPUT FRAME {&FRAME-NAME} estab-mat.cod-cta-contag-f-unif
             estab-mat.cod-ccusto-contag-f-unif   = INPUT FRAME {&FRAME-NAME} estab-mat.cod-ccusto-contag-f-unif
             estab-mat.cod-cta-absor-unif         = INPUT FRAME {&FRAME-NAME} estab-mat.cod-cta-absor-unif
             estab-mat.cod-ccusto-absor-unif      = INPUT FRAME {&FRAME-NAME} estab-mat.cod-ccusto-absor-unif
             estab-mat.cod-cta-entreg-fut-unif    = INPUT FRAME {&FRAME-NAME} estab-mat.cod-cta-entreg-fut-unif
             estab-mat.cod-ccusto-entreg-fut-unif = INPUT FRAME {&FRAME-NAME} estab-mat.cod-ccusto-entreg-fut-unif.
    */
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
  
  delete object h_api_cta_ctbl.
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

    /*&if  defined(ADM-CREATE-FIELDS) &then
       disable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
    &endif*/
    
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


    /* Code placed here will execute PRIOR to standard behavior.*/
    RUN pi-desformata-campos.
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 
               
    IF AVAIL estab-mat THEN DO:
        find estabelec WHERE
             estabelec.cod-estabel = estab-mat.cod-estabel no-lock no-error.
        if  avail estabelec THEN
            assign i-empresa = estabelec.ep-codigo.
        ASSIGN c-cod-estabel = estab-mat.cod-estabel.
    END.
    ELSE DO:
        FIND FIRST param-global no-lock no-error.
        ASSIGN i-empresa = param-global.empresa-prin.
    END.

        
    
    
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
                
    /* Busca as descri‡„es */      
    {cdp/cd0602.i3 estab-mat.cod-cta-absor-unif c-desc-abs-residual-medio
                  estab-mat.cod-ccusto-absor-unif c-desc-cod-ccusto-absor-unif FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-absor-unif c-desc-cod-ccusto-absor-unif} 
    end.
	else
		assign estab-mat.cod-ccusto-absor-unif:screen-value in frame {&frame-name}  = ""
			   c-desc-cod-ccusto-absor-unif:screen-value in frame {&frame-name} = "".
	
    {cdp/cd0602.i3 estab-mat.cod-cta-contag-f-unif c-desc-contagem-fisico
                   estab-mat.cod-ccusto-contag-f-unif c-desc-cod-ccusto-contag-f-unif FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-contag-f-unif c-desc-cod-ccusto-contag-f-unif}
    end.
	else
		assign estab-mat.cod-ccusto-contag-f-unif:screen-value in frame {&frame-name}  = ""
			   c-desc-cod-ccusto-contag-f-unif:screen-value in frame {&frame-name} = "".
	
    {cdp/cd0602.i3 estab-mat.cod-cta-e-benef-unif c-desc-ent-benef
                   estab-mat.cod-ccusto-e-benef-unif c-desc-ccusto-e-benef-unif FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-e-benef-unif c-desc-ccusto-e-benef-unif}
    end.
	else
		assign estab-mat.cod-ccusto-e-benef-unif:screen-value in frame {&frame-name}  = ""
			   c-desc-ccusto-e-benef-unif:screen-value in frame {&frame-name} = "".
	
    {cdp/cd0602.i3 estab-mat.cod-cta-saida-benef-unif c-desc-sai-benef
                   estab-mat.cod-ccusto-saida-benef-unif c-desc-ccusto-saida-benef FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-saida-benef-unif c-desc-ccusto-saida-benef}      
    end.  
	else
		assign estab-mat.cod-ccusto-saida-benef-unif:screen-value in frame {&frame-name}  = ""
			   c-desc-ccusto-saida-benef:screen-value in frame {&frame-name} = "".
    
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).
    
    /* Code placed here will execute AFTER standard behavior.    */
    
    IF adm-new-record AND adm-adding-record THEN
       ASSIGN estab-mat.cod-cta-e-benef-unif:format        in frame {&frame-name} = "x(20)"
              estab-mat.cod-cta-saida-benef-unif:format    in frame {&frame-name} = "x(20)"
              estab-mat.cod-cta-contag-f-unif:format       in frame {&frame-name} = "x(20)"
              estab-mat.cod-cta-absor-unif:format          in frame {&frame-name} = "x(20)"
              estab-mat.cod-ccusto-e-benef-unif:format     in frame {&frame-name} = "x(20)"
              estab-mat.cod-ccusto-saida-benef-unif:format in frame {&frame-name} = "x(20)"
              estab-mat.cod-ccusto-contag-f-unif:format    in frame {&frame-name} = "x(20)"
              estab-mat.cod-ccusto-absor-unif:format       in frame {&frame-name} = "x(20)".
    ELSE 
        ASSIGN estab-mat.cod-cta-e-benef-unif:format        in frame {&frame-name} = "x(20)".           
    
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    assign cod-cta-contag-f-unif:sensitive    in frame {&frame-name} = (param-estoq.rec-fisico or i-pais-impto-usuario <> 1)
                                                                        and substr(param-estoq.char-1,23,1) = "1"
           cod-ccusto-contag-f-unif:sensitive in frame {&frame-name} = (param-estoq.rec-fisico or i-pais-impto-usuario <> 1)
                                                                        and substr(param-estoq.char-1,23,1) = "1".

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

    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    run prgint\utb\utb742za.py persistent set h_api_ccusto.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    FOR FIRST param-estoq NO-LOCK: END.

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
    
    /* Code placed here will execute AFTER standard behavior.    */    
    
    if  avail estab-mat then do:
        find estabelec WHERE
             estabelec.cod-estabel = estab-mat.cod-estabel no-lock no-error.
        if avail estabelec THEN
            assign i-empresa = estabelec.ep-codigo.
    end.
    
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
                                                   output       v_titulo_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input        STRING(i-empresa), /* EMPRESA EMS2 */
                                                          input        "CEP",             /* M…DULO */
                                                          input        "",                /* PLANO DE CONTAS */
                                                          input        v_cod_cta_ctbl,    /* CONTA */
                                                          input        today,             /* DATA TRANSACAO */   
                                                          output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro).      /* ERROS */ 

    FIND FIRST tt_log_erro NO-ERROR.

    IF NOT AVAIL tt_log_erro THEN DO:
        assign p-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}
               p-num-tip-cta     = v_num_tip_cta_ctbl
               p-num-sit-cta     = v_num_sit_cta_ctbl.
        RETURN "OK":U.
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
                                               output v_titulo_ccusto,       /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
    
    ASSIGN p-desc-ccusto = v_titulo_ccusto.

    RETURN "ok".

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
                                                   OUTPUT       v_titulo_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  c-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-conta,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    
    ASSIGN p-desc-conta = v_titulo_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ccusto V-table-Win 
PROCEDURE pi-valida-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-ccusto AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_busca_dados_ccusto in h_api_ccusto (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  p-cod-ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,       /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */ 

    FIND FIRST tt_log_erro NO-ERROR.
    IF AVAIL tt_log_erro THEN
        RETURN "NOK".

    RETURN "ok".

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
                                                     input  "CEP",              /* MODULO */
                                                     input  "",                 /* PLANO CONTAS */ 
                                                     input  p-cod-conta,        /* CONTA */
                                                     input  "(nenhum)",         /* FINALIDADES */
                                                     input  today,              /* DATA DE TRANSACAO */ 
                                                     output table tt_log_erro). /* ERROS */

    FIND FIRST tt_log_erro NO-ERROR.
    IF AVAIL tt_log_erro THEN
        RETURN "NOK".

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
ASSIGN estab-mat.cod-cta-e-benef-unif:format        in frame {&frame-name} = "x(20)"
       estab-mat.cod-cta-saida-benef-unif:format    in frame {&frame-name} = "x(20)"
       estab-mat.cod-cta-contag-f-unif:format       in frame {&frame-name} = "x(20)"
       estab-mat.cod-cta-absor-unif:format          in frame {&frame-name} = "x(20)"
       estab-mat.cod-ccusto-e-benef-unif:format     in frame {&frame-name} = "x(20)"
       estab-mat.cod-ccusto-saida-benef-unif:format in frame {&frame-name} = "x(20)"
       estab-mat.cod-ccusto-contag-f-unif:format    in frame {&frame-name} = "x(20)"
       estab-mat.cod-ccusto-absor-unif:format       in frame {&frame-name} = "x(20)".  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.
  /* Formatando conta e centro de custo, somente se nÆo for "" os campos sÆo formatados */   
  IF c-formato-conta <> "" then do:
       if estab-mat.cod-cta-e-benef-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-e-benef-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-saida-benef-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-saida-benef-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-contag-f-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-contag-f-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-absor-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-absor-unif:format in frame {&FRAME-NAME} = c-formato-conta.
  end.
  if c-formato-ccusto <> "" then do:
       if estab-mat.cod-ccusto-e-benef-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-e-benef-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-saida-benef-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-saida-benef-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-contag-f-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-contag-f-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-absor-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-absor-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.      
  end.           
       
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

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-e-benef-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", 
                           input 19, 
                           input input frame {&frame-name} estab-mat.cod-cta-e-benef-unif).
        apply "entry" to estab-mat.cod-cta-e-benef-unif in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-e-benef-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-e-benef-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            /* Conta Contabil Inválida */                    
            apply 'entry':U to estab-mat.cod-ccusto-e-benef-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else 
		assign estab-mat.cod-ccusto-e-benef-unif:screen-value in frame {&frame-name} = "".

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-saida-benef-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", 
                           input 19, 
                           input input frame {&frame-name} estab-mat.cod-cta-saida-benef-unif).
        apply "entry" to estab-mat.cod-cta-saida-benef-unif in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-saida-benef-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-saida-benef-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            /* Conta Contabil Inválida */                    
            apply 'entry':U to estab-mat.cod-ccusto-saida-benef-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else 
		assign estab-mat.cod-ccusto-saida-benef-unif:screen-value in frame {&frame-name} = "".
    
    if  (param-estoq.rec-fisico or i-pais-impto-usuario <> 1)     
    AND substr(param-estoq.char-1,23,1) = "1" 
    AND input frame {&frame-name} estab-mat.cod-cta-contag-f-unif <> ? then do:
       
        RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-contag-f-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", 
                               input 19, 
                               input "").      
            /* Conta Contabil Inválida */                    
            apply 'entry':U to estab-mat.cod-cta-contag-f-unif in frame {&frame-name}.
            return "adm-error".
        end.
        else do:

            RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-contag-f-unif,
                                      OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                                      OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                                      OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
        
            IF RETURN-VALUE = "OK" THEN DO:
                if (i-num-finalid-cta <> 1) and 
                   (i-num-finalid-cta <> 2) then do:
                   {include/i-vldprg.i}    
                   run utp/ut-msgs.p(input "show", 
                                     input 26456, 
                                     input return-value).
                   /* Conta Contÿbil deve ser Consumo ou NÆo Consumo. */
                   apply "entry" to estab-mat.cod-cta-contag-f-unif in frame {&frame-name}. 
                   return 'ADM-ERROR':U.
                end. 
                {cdp/cd0611.i2 "estab-mat.cod-cta-contag-f-unif"}
            END.
        END.

        ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-contag-f-unif.
        RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                            OUTPUT       v_titulo_cta_ctbl,
                            OUTPUT       l-utiliza-cc).
    
        IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
            RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-contag-f-unif).
            IF RETURN-VALUE = "NOK" THEN DO:
                {include/i-vldprg.i}
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Centro_Custo" *}
                run utp/ut-msgs.p (input "show", 
                                   input 2, 
                                   input RETURN-VALUE).      
                /* Conta Contabil Inválida */                    
                apply 'entry':U to estab-mat.cod-ccusto-contag-f-unif in frame {&frame-name}.
                return "adm-error":U.
            END.
        END.
    	else 
    		assign estab-mat.cod-ccusto-contag-f-unif:screen-value in frame {&frame-name} = "".
    END.

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-absor-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", 
                           input 19, 
                           input "").      
        /* Conta Contabil Invÿlida */                    
        apply 'entry':U to estab-mat.cod-cta-absor-unif in frame {&frame-name}.
        return "adm-error".
    end.
    else do:

        RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-absor-unif,
                                  OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                                  OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                                  OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
    
        IF RETURN-VALUE = "OK" THEN DO:
            if  i-num-finalid-cta <> 2 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p(input "show", 
                                  input 26459, 
                                  input return-value).
                /* Conta Contÿbil deve ser de NÆo Consumo. */                  
                apply "entry" to estab-mat.cod-cta-absor-unif in frame {&frame-name}. 
                return 'ADM-ERROR':U.
            end. 
            {cdp/cd0611.i2 "estab-mat.cod-cta-absor-unif"}
        END.
    end.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-absor-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-absor-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            /* Conta Contabil Inválida */                    
            apply 'entry':U to estab-mat.cod-ccusto-absor-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else 
		assign estab-mat.cod-ccusto-absor-unif:screen-value in frame {&frame-name} = "".

    RETURN "OK".

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

    run pi_zoom_ccusto in h_api_ccusto (input string(i-empresa),   /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_titulo_ccusto,       /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 

    IF RETURN-VALUE = "OK" THEN DO:
       ASSIGN p-ccusto      = v_cod_ccusto
              p-desc-ccusto = v_titulo_ccusto .

       RETURN "ok".
    END.
    ELSE RETURN "NOK".

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
                                                   input  "CEP",              /* M…DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_titulo_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
       ASSIGN p-conta      = v_cod_cta_ctbl
              p-desc-conta = v_titulo_cta_ctbl.
       
       RETURN "OK".       
    END.
    ELSE RETURN "NOK".

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
  {src/adm/template/snd-list.i "estab-mat"}

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

