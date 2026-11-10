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
{include/i-prgvrs.i V08IN661 2.00.00.016 } /*** "010016" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08in661 MUT}
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


def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as int  format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as char format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as char format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància"
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
&Scoped-Define ENABLED-FIELDS estab-mat.cod-cta-invent-e-unif ~
estab-mat.cod-ccusto-invent-e-unif estab-mat.cod-cta-invent-saida-unif ~
estab-mat.cod-ccusto-invent-saida-unif estab-mat.cod-cta-mod-unif ~
estab-mat.cod-ccusto-mod-unif estab-mat.cod-cta-transf-unif ~
estab-mat.cod-ccusto-transf-unif estab-mat.cod-cta-recebto-f-unif ~
estab-mat.cod-ccusto-recebto-f-unif 
&Scoped-define ENABLED-TABLES estab-mat
&Scoped-define FIRST-ENABLED-TABLE estab-mat
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS estab-mat.cod-cta-invent-e-unif ~
estab-mat.cod-ccusto-invent-e-unif estab-mat.cod-cta-invent-saida-unif ~
estab-mat.cod-ccusto-invent-saida-unif estab-mat.cod-cta-mod-unif ~
estab-mat.cod-ccusto-mod-unif estab-mat.cod-cta-transf-unif ~
estab-mat.cod-ccusto-transf-unif estab-mat.cod-cta-recebto-f-unif ~
estab-mat.cod-ccusto-recebto-f-unif 
&Scoped-define DISPLAYED-TABLES estab-mat
&Scoped-define FIRST-DISPLAYED-TABLE estab-mat
&Scoped-Define DISPLAYED-OBJECTS c-desc-cta-inven-ent ~
c-desc-ccusto-inven-ent c-desc-cta-inven-sai c-desc-ccusto-inven-sai ~
c-desc-cta-mod-unif c-desc-ccusto-mod-unif c-desc-cta-transf-unif ~
c-desc-ccusto-transf-unif c-desc-cta-rec-fisico c-desc-ccusto-rec-fisico 

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
DEFINE VARIABLE c-desc-ccusto-inven-ent AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-inven-sai AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-mod-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-rec-fisico AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto-transf-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cta-inven-ent AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cta-inven-sai AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cta-mod-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cta-rec-fisico AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cta-transf-unif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 10.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-mat.cod-cta-invent-e-unif AT ROW 1.25 COL 26.57 COLON-ALIGNED WIDGET-ID 52
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-cta-inven-ent AT ROW 1.25 COL 48 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-invent-e-unif AT ROW 2.17 COL 26.57 COLON-ALIGNED WIDGET-ID 42
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-ccusto-inven-ent AT ROW 2.17 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     estab-mat.cod-cta-invent-saida-unif AT ROW 3.29 COL 26.57 COLON-ALIGNED WIDGET-ID 54
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-cta-inven-sai AT ROW 3.29 COL 48 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-invent-saida-unif AT ROW 4.21 COL 26.57 COLON-ALIGNED WIDGET-ID 44
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-ccusto-inven-sai AT ROW 4.21 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     estab-mat.cod-cta-mod-unif AT ROW 5.33 COL 26.57 COLON-ALIGNED WIDGET-ID 56
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-cta-mod-unif AT ROW 5.33 COL 48 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-mod-unif AT ROW 6.25 COL 26.57 COLON-ALIGNED WIDGET-ID 46
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-ccusto-mod-unif AT ROW 6.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     estab-mat.cod-cta-transf-unif AT ROW 7.38 COL 26.57 COLON-ALIGNED WIDGET-ID 60
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-cta-transf-unif AT ROW 7.38 COL 48 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-transf-unif AT ROW 8.29 COL 26.57 COLON-ALIGNED WIDGET-ID 50
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-ccusto-transf-unif AT ROW 8.29 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     estab-mat.cod-cta-recebto-f-unif AT ROW 9.42 COL 26.57 COLON-ALIGNED WIDGET-ID 58
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-cta-rec-fisico AT ROW 9.42 COL 48 COLON-ALIGNED NO-LABEL
     estab-mat.cod-ccusto-recebto-f-unif AT ROW 10.33 COL 26.57 COLON-ALIGNED WIDGET-ID 48
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-desc-ccusto-rec-fisico AT ROW 10.33 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.estab-mat
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
         WIDTH              = 91.
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

/* SETTINGS FOR FILL-IN c-desc-ccusto-inven-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-inven-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-mod-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-rec-fisico IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto-transf-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cta-inven-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cta-inven-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cta-mod-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cta-rec-fisico IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cta-transf-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-invent-e-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-invent-saida-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-mod-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-recebto-f-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-ccusto-transf-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-invent-e-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-invent-saida-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-mod-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-recebto-f-unif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN estab-mat.cod-cta-transf-unif IN FRAME f-main
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

&Scoped-define SELF-NAME estab-mat.cod-ccusto-invent-e-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-e-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-invent-e-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-e-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-invent-e-unif IN FRAME f-main
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                       OUTPUT c-zoom-desc-ccusto).

   IF RETURN-VALUE = "OK" THEN 
      assign estab-mat.cod-ccusto-invent-e-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
             c-desc-ccusto-inven-ent:screen-value in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-e-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-invent-e-unif IN FRAME f-main
DO:
   {cdp/cd0602.i4 estab-mat.cod-ccusto-invent-e-unif c-desc-ccusto-inven-ent} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-e-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-invent-e-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-invent-saida-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-saida-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-invent-saida-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-saida-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-invent-saida-unif IN FRAME f-main
DO:
   RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                       OUTPUT c-zoom-desc-ccusto).

   IF RETURN-VALUE = "OK" THEN 
      assign estab-mat.cod-ccusto-invent-saida-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
             c-desc-ccusto-inven-sai:screen-value in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-saida-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-invent-saida-unif IN FRAME f-main
DO:
   {cdp/cd0602.i4 estab-mat.cod-ccusto-invent-saida-unif c-desc-ccusto-inven-sai}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-invent-saida-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-invent-saida-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-mod-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-mod-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-mod-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-mod-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-mod-unif IN FRAME f-main
DO:
   RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

   IF RETURN-VALUE = "OK" THEN 
      assign estab-mat.cod-ccusto-mod-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
             c-desc-ccusto-mod-unif:screen-value in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-mod-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-mod-unif IN FRAME f-main
DO:
   {cdp/cd0602.i4 estab-mat.cod-ccusto-mod-unif c-desc-ccusto-mod-unif}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-mod-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-mod-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-recebto-f-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-recebto-f-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-recebto-f-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-recebto-f-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-recebto-f-unif IN FRAME f-main
DO:
   RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

   IF RETURN-VALUE = "OK" THEN  
      assign estab-mat.cod-ccusto-recebto-f-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
             c-desc-ccusto-rec-fisico:screen-value in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-recebto-f-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-recebto-f-unif IN FRAME f-main
DO:
    {cdp/cd0602.i4 estab-mat.cod-ccusto-recebto-f-unif c-desc-ccusto-rec-fisico}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-recebto-f-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-recebto-f-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-ccusto-transf-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-transf-unif V-table-Win
ON ENTRY OF estab-mat.cod-ccusto-transf-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-transf-unif V-table-Win
ON F5 OF estab-mat.cod-ccusto-transf-unif IN FRAME f-main
DO:
   RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

   IF RETURN-VALUE = "OK" THEN  
      assign estab-mat.cod-ccusto-transf-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
             c-desc-ccusto-transf-unif:SCREEN-VALUE in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-transf-unif V-table-Win
ON LEAVE OF estab-mat.cod-ccusto-transf-unif IN FRAME f-main
DO:
   {cdp/cd0602.i4 estab-mat.cod-ccusto-transf-unif c-desc-ccusto-transf-unif} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-ccusto-transf-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-ccusto-transf-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-invent-e-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-e-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-invent-e-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
          estab-mat.cod-ccusto-invent-e-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-e-unif V-table-Win
ON F5 OF estab-mat.cod-cta-invent-e-unif IN FRAME f-main
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).
  
    IF RETURN-VALUE = "OK" THEN  
       assign estab-mat.cod-cta-invent-e-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-cta-inven-ent:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-e-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-invent-e-unif IN FRAME f-main
DO:
   {cdp/cd0602.i3 estab-mat.cod-cta-invent-e-unif c-desc-cta-inven-ent
                  estab-mat.cod-ccusto-invent-e-unif c-desc-ccusto-inven-ent TRUE} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-e-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-invent-e-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-invent-saida-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-saida-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-invent-saida-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
          estab-mat.cod-ccusto-invent-saida-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-saida-unif V-table-Win
ON F5 OF estab-mat.cod-cta-invent-saida-unif IN FRAME f-main
DO:
   RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

   IF RETURN-VALUE = "OK" THEN 
      assign estab-mat.cod-cta-invent-saida-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
             c-desc-cta-inven-sai:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-saida-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-invent-saida-unif IN FRAME f-main
DO:
   {cdp/cd0602.i3 estab-mat.cod-cta-invent-saida-unif  c-desc-cta-inven-sai
                  estab-mat.cod-ccusto-invent-saida-unif c-desc-ccusto-inven-sai TRUE}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-invent-saida-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-invent-saida-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-mod-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-mod-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-mod-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
          estab-mat.cod-ccusto-mod-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-mod-unif V-table-Win
ON F5 OF estab-mat.cod-cta-mod-unif IN FRAME f-main
DO:
   RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).
   
   IF RETURN-VALUE = "OK" THEN 
      assign estab-mat.cod-cta-mod-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
             c-desc-cta-mod-unif:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-mod-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-mod-unif IN FRAME f-main
DO:
   {cdp/cd0602.i3 estab-mat.cod-cta-mod-unif  c-desc-cta-mod-unif
                  estab-mat.cod-ccusto-mod-unif c-desc-ccusto-mod-unif TRUE}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-mod-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-mod-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-recebto-f-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-recebto-f-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-recebto-f-unif IN FRAME f-main
DO:
   ASSIGN SELF:FORMAT = "x(20)".
          estab-mat.cod-ccusto-recebto-f-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-recebto-f-unif V-table-Win
ON F5 OF estab-mat.cod-cta-recebto-f-unif IN FRAME f-main
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-cta-recebto-f-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-cta-rec-fisico:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-recebto-f-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-recebto-f-unif IN FRAME f-main
DO:
    {cdp/cd0602.i3 estab-mat.cod-cta-recebto-f-unif c-desc-cta-rec-fisico
                  estab-mat.cod-ccusto-recebto-f-unif c-desc-ccusto-rec-fisico TRUE}        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-recebto-f-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-recebto-f-unif IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-cta-transf-unif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-transf-unif V-table-Win
ON ENTRY OF estab-mat.cod-cta-transf-unif IN FRAME f-main
DO:
    ASSIGN SELF:FORMAT = "x(20)".
          estab-mat.cod-ccusto-transf-unif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-transf-unif V-table-Win
ON F5 OF estab-mat.cod-cta-transf-unif IN FRAME f-main
DO:
   RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

   IF RETURN-VALUE = "OK" THEN 
       assign estab-mat.cod-cta-transf-unif:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
              c-desc-cta-transf-unif:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-transf-unif V-table-Win
ON LEAVE OF estab-mat.cod-cta-transf-unif IN FRAME f-main
DO:
   {cdp/cd0602.i3 estab-mat.cod-cta-transf-unif c-desc-cta-transf-unif
                  estab-mat.cod-ccusto-transf-unif c-desc-ccusto-transf-unif TRUE}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-cta-transf-unif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-cta-transf-unif IN FRAME f-main
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

  if estab-mat.cod-cta-invent-e-unif:load-mouse-pointer("image/lupa.cur")     in frame {&frame-name} then.
  if estab-mat.cod-cta-invent-saida-unif:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
  if estab-mat.cod-cta-mod-unif:load-mouse-pointer ("image/lupa.cur")         in frame {&frame-name} then.
  if estab-mat.cod-cta-transf-unif:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then.
  if estab-mat.cod-cta-recebto-f-unif:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then.

  if estab-mat.cod-ccusto-invent-e-unif:load-mouse-pointer("image/lupa.cur")     in frame {&frame-name} then.
  if estab-mat.cod-ccusto-invent-saida-unif:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
  if estab-mat.cod-ccusto-mod-unif:load-mouse-pointer("image/lupa.cur")          in frame {&frame-name} then.
  if estab-mat.cod-ccusto-transf-unif:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then.
  if estab-mat.cod-ccusto-recebto-f-unif:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then.

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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ).

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
                                                                           
    /* Busca as descriáÑes */
    {cdp/cd0602.i3 estab-mat.cod-cta-invent-e-unif c-desc-cta-inven-ent
                   estab-mat.cod-ccusto-invent-e-unif c-desc-ccusto-inven-ent FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-invent-e-unif c-desc-ccusto-inven-ent}
    end.
    else
    	assign estab-mat.cod-ccusto-invent-e-unif:screen-value in frame {&FRAME-NAME} = ""
	       c-desc-ccusto-inven-ent:screen-value in frame {&FRAME-NAME} = "".
	       
    {cdp/cd0602.i3 estab-mat.cod-cta-invent-saida-unif  c-desc-cta-inven-sai
                   estab-mat.cod-ccusto-invent-saida-unif c-desc-ccusto-inven-sai  FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-invent-saida-unif c-desc-ccusto-inven-sai}   
    end.
    else
    	assign estab-mat.cod-ccusto-invent-saida-unif:screen-value in frame {&FRAME-NAME} = ""
	       c-desc-ccusto-inven-sai:screen-value in frame {&FRAME-NAME} = "".
	       
    {cdp/cd0602.i3 estab-mat.cod-cta-mod-unif  c-desc-cta-mod-unif
                   estab-mat.cod-ccusto-mod-unif c-desc-ccusto-mod-unif FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-mod-unif c-desc-ccusto-mod-unif} 
    end.
    else
    	assign estab-mat.cod-ccusto-mod-unif:screen-value in frame {&FRAME-NAME} = ""
	       c-desc-ccusto-mod-unif:screen-value in frame {&FRAME-NAME} = "".
	       
    {cdp/cd0602.i3 estab-mat.cod-cta-recebto-f-unif c-desc-cta-rec-fisico
                   estab-mat.cod-ccusto-recebto-f-unif c-desc-ccusto-rec-fisico FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-recebto-f-unif c-desc-ccusto-rec-fisico} 
    end.
    else
    	assign estab-mat.cod-ccusto-recebto-f-unif:screen-value in frame {&FRAME-NAME} = ""
	       c-desc-ccusto-rec-fisico:screen-value in frame {&FRAME-NAME} = "".
	       
    {cdp/cd0602.i3 estab-mat.cod-cta-transf-unif c-desc-cta-transf-unif
                   estab-mat.cod-ccusto-transf-unif c-desc-ccusto-transf-unif FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
       {cdp/cd0602.i4 estab-mat.cod-ccusto-transf-unif c-desc-ccusto-transf-unif}
    end.    
    else
    	assign estab-mat.cod-ccusto-transf-unif:screen-value in frame {&FRAME-NAME} = ""
	       c-desc-ccusto-transf-unif:screen-value in frame {&FRAME-NAME} = "".
          
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

    IF adm-new-record AND adm-adding-record THEN 
        ASSIGN estab-mat.cod-cta-invent-e-unif:format        in frame {&FRAME-NAME} = "x(20)" 
               estab-mat.cod-cta-invent-saida-unif:format    in frame {&FRAME-NAME} = "x(20)"    
               estab-mat.cod-cta-mod-unif:format             in frame {&FRAME-NAME} = "x(20)"  
               estab-mat.cod-cta-transf-unif:format          in frame {&FRAME-NAME} = "x(20)"                                   
               estab-mat.cod-cta-recebto-f-unif:format       in frame {&FRAME-NAME} = "x(20)"  
               estab-mat.cod-ccusto-invent-e-unif:format     in frame {&FRAME-NAME} = "x(20)"                                   
               estab-mat.cod-ccusto-invent-saida-unif:format in frame {&FRAME-NAME} = "x(20)"
               estab-mat.cod-ccusto-mod-unif:format          in frame {&FRAME-NAME} = "x(20)"                                   
               estab-mat.cod-ccusto-transf-unif:format       in frame {&FRAME-NAME} = "x(20)" 
               estab-mat.cod-ccusto-recebto-f-unif:format    in frame {&FRAME-NAME} = "x(20)". 
    ELSE 
       ASSIGN estab-mat.cod-cta-invent-e-unif:format        in frame {&FRAME-NAME} = "x(20)".           
     
    /* Code placed here will execute AFTER standard behavior.    */ 
    &if  defined(ADM-MODIFY-FIELDS) &then
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    assign cod-cta-recebto-f-unif:sensitive      in frame {&frame-name} = param-estoq.rec-fisico
           cod-ccusto-recebto-f-unif:sensitive   in frame {&frame-name} = param-estoq.rec-fisico.
    
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
    
    /*{utp/ut-field.i mgind  estab-mat cod-cta-invent-e-unif 01}*/
    {utp/ut-liter.i "Conta Inventario Entrada" * r}         
    assign estab-mat.cod-cta-invent-e-unif:label     in frame {&frame-name} = return-value.
    /*{utp/ut-field.i mgind  estab-mat cod-cta-invent-saida-unif 01}*/
    {utp/ut-liter.i "Conta Inventario Saida" * r}
    assign estab-mat.cod-cta-invent-saida-unif:label in frame {&frame-name} = return-value. 
    /*{utp/ut-field.i mgind  estab-mat cod-cta-mod-unif 01}*/
    {utp/ut-liter.i "Conta Mao de obra direta" * r} 
    assign estab-mat.cod-cta-mod-unif:label          in frame {&frame-name} = return-value.       
    /*{utp/ut-field.i mgind  estab-mat cod-cta-transf-unif 01}*/
    {utp/ut-liter.i "Conta Transferencia" * r}
    assign estab-mat.cod-cta-transf-unif:label       in frame {&frame-name} = return-value.     
    /*{utp/ut-field.i mgind  estab-mat cod-cta-recebto-f-unif 01}*/
    {utp/ut-liter.i "Conta Recebimento Fisico" * r} 
    assign estab-mat.cod-cta-recebto-f-unif:label    in frame {&frame-name} = return-value.

    assign estab-mat.cod-ccusto-invent-e-unif:label     in frame {&frame-name} = 'Centro de custo'
           estab-mat.cod-ccusto-invent-saida-unif:label in frame {&frame-name} = 'Centro de custo'
           estab-mat.cod-ccusto-mod-unif:label          in frame {&frame-name} = 'Centro de custo'
           estab-mat.cod-ccusto-transf-unif:label       in frame {&frame-name} = 'Centro de custo'
           estab-mat.cod-ccusto-recebto-f-unif:label    in frame {&frame-name} = 'Centro de custo'.

    FOR first param-estoq  NO-LOCK: END.

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
                                                   output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input        STRING(i-empresa), /* EMPRESA EMS2 */
                                                          input        "CEP",             /* MÖDULO */
                                                          input        "",                /* PLANO DE CONTAS */
                                                          input        v_cod_cta_ctbl,    /* CONTA */
                                                          input        today,             /* DATA TRANSACAO */   
                                                          output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro).      /* ERROS */ 

    FIND FIRST tt_log_erro NO-ERROR.

    IF NOT AVAIL tt_log_erro THEN DO:
        assign p-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta }
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
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
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

ASSIGN estab-mat.cod-cta-invent-e-unif:format        in frame {&FRAME-NAME} = "x(20)" 
       estab-mat.cod-cta-invent-saida-unif:format    in frame {&FRAME-NAME} = "x(20)"    
       estab-mat.cod-cta-mod-unif:format             in frame {&FRAME-NAME} = "x(20)"  
       estab-mat.cod-cta-transf-unif:format          in frame {&FRAME-NAME} = "x(20)"                                   
       estab-mat.cod-cta-recebto-f-unif:format       in frame {&FRAME-NAME} = "x(20)"  
       estab-mat.cod-ccusto-invent-e-unif:format     in frame {&FRAME-NAME} = "x(20)"                                   
       estab-mat.cod-ccusto-invent-saida-unif:format in frame {&FRAME-NAME} = "x(20)"
       estab-mat.cod-ccusto-mod-unif:format          in frame {&FRAME-NAME} = "x(20)"                                   
       estab-mat.cod-ccusto-transf-unif:format       in frame {&FRAME-NAME} = "x(20)" 
       estab-mat.cod-ccusto-recebto-f-unif:format    in frame {&FRAME-NAME} = "x(20)". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */   
  IF c-formato-conta <> "" then do:
       if estab-mat.cod-cta-invent-e-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-invent-e-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-invent-saida-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-invent-saida-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-mod-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-mod-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-transf-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-transf-unif:format in frame {&FRAME-NAME} = c-formato-conta.

       if estab-mat.cod-cta-recebto-f-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-cta-recebto-f-unif:format in frame {&FRAME-NAME} = c-formato-conta.
       
  end.
  if c-formato-ccusto <> "" then do:
       if estab-mat.cod-ccusto-invent-e-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-invent-e-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-invent-saida-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-invent-saida-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-mod-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-mod-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-transf-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-transf-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.

       if estab-mat.cod-ccusto-recebto-f-unif:screen-value in frame {&frame-name} <> "" then 
         assign estab-mat.cod-ccusto-recebto-f-unif:format in frame {&FRAME-NAME} = c-formato-ccusto.      
  end.           
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-invent-e-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", 
                           input 19, 
                           input "").
        /* Conta Contabil Inv†lida */                   
        apply 'entry':U to estab-mat.cod-cta-invent-e-unif in frame {&FRAME-NAME}.
        return "adm-error".
    END.

    RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-invent-e-unif,
                              OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                              OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                              OUTPUT i-num-finalid-cta). /* conta-contab.estoque */

    IF RETURN-VALUE = "OK" THEN DO:
        if i-num-finalid-cta <> 2 then do:
           {include/i-vldprg.i} 
           run utp/ut-msgs.p(input "show", 
                             input 26459, 
                             input return-value).
           /* Conta Cont†bil deve ser de N∆o Consumo. */                  
           apply "entry" to estab-mat.cod-cta-invent-e-unif in frame {&frame-name}. 
           return 'ADM-ERROR':U.
        end. 
        {cdp/cd0611.i2 "estab-mat.cod-cta-invent-e-unif"}
    END.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-invent-e-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-invent-e-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            apply 'entry':U to estab-mat.cod-ccusto-invent-e-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else if RETURN-VALUE = "OK" then 
		assign estab-mat.cod-ccusto-invent-e-unif:screen-value in frame {&frame-name} = "".

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-invent-saida-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
       {include/i-vldprg.i}   
       run utp/ut-msgs.p (input "show", 
                          input 19, 
                          input "").
       /* Conta Contabil Inv†lida */                   
       apply 'entry':U to estab-mat.cod-cta-invent-saida-unif in frame {&FRAME-NAME}.
       return "adm-error".
    END.

    RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-invent-saida-unif,
                              OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                              OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                              OUTPUT i-num-finalid-cta). /* conta-contab.estoque */

    IF RETURN-VALUE = "OK" THEN DO:
        if i-num-finalid-cta <> 2 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p(input "show", 
                              input 26459, 
                              input return-value).
            /* Conta Cont†bil deve ser de N∆o Consumo. */                  
            apply "entry" to estab-mat.cod-cta-invent-saida-unif in frame {&frame-name}. 
            return 'ADM-ERROR':U.
        end. 
        {cdp/cd0611.i2 "estab-mat.cod-cta-invent-saida-unif"}
    END.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-invent-saida-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-invent-saida-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            apply 'entry':U to estab-mat.cod-ccusto-invent-saida-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else if RETURN-VALUE = "OK" then 
		assign estab-mat.cod-ccusto-invent-saida-unif:screen-value in frame {&frame-name} = "".
        
    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-mod-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
        {include/i-vldprg.i}   
        run utp/ut-msgs.p (input "show", 
                           input 19, 
                           input "").
        /* Conta Contabil Inv†lida */                   
        apply 'entry':U to estab-mat.cod-cta-mod-unif in frame {&FRAME-NAME}.   
        return "adm-error".
    END.

    RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-mod-unif,
                              OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                              OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                              OUTPUT i-num-finalid-cta). /* conta-contab.estoque */

    IF RETURN-VALUE = "OK" THEN DO:
        if i-num-finalid-cta <> 5  then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p(input "show", 
                              input 26458, 
                              input return-value).
            /* Conta Cont†bil deve ser de MOB. */                  
            apply "entry" to estab-mat.cod-cta-mod-unif in frame {&frame-name}. 
            return 'ADM-ERROR':U.
        END.
        {cdp/cd0611.i2 "estab-mat.cod-cta-mod-unif"}
    END.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-mod-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-mod-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            apply 'entry':U to estab-mat.cod-ccusto-mod-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else if RETURN-VALUE = "OK" then 
		assign estab-mat.cod-ccusto-mod-unif:screen-value in frame {&frame-name} = "".

    RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-transf-unif).
    IF RETURN-VALUE = "NOK" THEN DO:
       {include/i-vldprg.i} 
       run utp/ut-msgs.p(input "show", 
                         input 19, 
                         input "").
       /* Conta cont†bil  inexistente */                  
       apply "entry" to estab-mat.cod-cta-transf-unif in frame {&frame-name}. 
       return 'ADM-ERROR':U.      
    END.

    RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-transf-unif,
                              OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                              OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                              OUTPUT i-num-finalid-cta). /* conta-contab.estoque */

    IF RETURN-VALUE = "OK" THEN DO:
        if i-num-finalid-cta <> 4 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p(input "show", 
                              input 2786, 
                              input return-value).
            /* Conta Cont†bil deve ser de Transferància. */                  
            apply "entry" to estab-mat.cod-cta-transf-unif in frame {&frame-name}. 
            return 'ADM-ERROR':U.
        end. 
        {cdp/cd0611.i2 "estab-mat.cod-cta-transf-unif"}
    END.

    ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-transf-unif.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       v_titulo_cta_ctbl,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-transf-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_Custo" *}
            run utp/ut-msgs.p (input "show", 
                               input 2, 
                               input RETURN-VALUE).      
            apply 'entry':U to estab-mat.cod-ccusto-transf-unif in frame {&frame-name}.
            return "adm-error":U.
        END.
    END.
	else if RETURN-VALUE = "OK" then 
		assign estab-mat.cod-ccusto-transf-unif:screen-value in frame {&frame-name} = "".

    IF param-estoq.rec-fisico THEN DO:
        RUN pi-valida-conta (INPUT input frame {&frame-name} estab-mat.cod-cta-recebto-f-unif).
        IF RETURN-VALUE = "NOK" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p(input "show", 
                              input 19, 
                              input "").
            /* Conta cont†bil  inexistente */                  
            apply "entry" to estab-mat.cod-cta-recebto-f-unif in frame {&frame-name}. 
            return 'ADM-ERROR':U.   
        END.
    
        RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} estab-mat.cod-cta-recebto-f-unif,
                                  OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                                  OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                                  OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
    
        IF RETURN-VALUE = "OK" THEN DO:
            if (i-num-finalid-cta <> 2) and 
               (i-num-finalid-cta <> 7) then do:
               {include/i-vldprg.i}    
                run utp/ut-msgs.p(input "show", 
                                  input 26457, 
                                  input return-value).
                /* Conta Cont†bil deve ser N∆o Consumo ou Transit¢ria de compras. */                  
                apply "entry" to estab-mat.cod-cta-recebto-f-unif in frame {&frame-name}. 
                return 'ADM-ERROR':U.
            end. 
            {cdp/cd0611.i2 "estab-mat.cod-cta-recebto-f-unif"}
        END.
    
        ASSIGN c-conta = input frame {&frame-name} estab-mat.cod-cta-recebto-f-unif.
        RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                            OUTPUT       v_titulo_cta_ctbl,
                            OUTPUT       l-utiliza-cc).
    
        IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
            RUN pi-valida-ccusto(INPUT input frame {&frame-name} estab-mat.cod-ccusto-recebto-f-unif).
            IF RETURN-VALUE = "NOK" THEN DO:
                {include/i-vldprg.i}
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Centro_Custo" *}
                run utp/ut-msgs.p (input "show", 
                                   input 2, 
                                   input RETURN-VALUE).      
                apply 'entry':U to estab-mat.cod-ccusto-recebto-f-unif in frame {&frame-name}.
                return "adm-error":U.
            END.
        END.
    	else if RETURN-VALUE = "OK" then 
    		assign estab-mat.cod-ccusto-recebto-f-unif:screen-value in frame {&frame-name} = "".
    END.
		
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
                                        output v_titulo_ccusto ,       /* DESCRICAO CCUSTO */
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
                                                   input  "CEP",              /* MÖDULO */
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

