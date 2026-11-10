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
{include/i-prgvrs.i V07IN287 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in287 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var l-inclui as logical no-undo.

def new global shared var l-erro as logical no-undo.
def buffer b-param-estoq for param-estoq.

def var i-empresa like param-global.empresa-prin no-undo.

DEF VAR c-estab-pad LIKE param-estoq.estabel-pad NO-UNDO.

{cdp/cdcfgdis.i}

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Námero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari˜veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari˜veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.
def var v_cod_formato        as char   no-undo.

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 c-ccusto-trans c-ccusto-acerto ~
c-ccusto-inven-ent c-ccusto-inven-sai c-ccusto-mob 
&Scoped-Define DISPLAYED-OBJECTS c-conta-trans c-desc-trans c-ccusto-trans ~
c-desc-cc-trans c-conta-acerto c-desc-acerto c-ccusto-acerto ~
c-desc-cc-acerto c-conta-inven-ent c-desc-inven-ent c-ccusto-inven-ent ~
c-desc-cc-inven-ent c-conta-inven-sai c-desc-inven-sai c-ccusto-inven-sai ~
c-desc-cc-inven-sai c-conta-mob c-desc-tr-mob c-ccusto-mob c-desc-cc-tr-mob 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-conta-trans c-conta-acerto ~
c-conta-inven-ent c-conta-inven-sai c-conta-mob 
&Scoped-define ADM-MODIFY-FIELDS c-conta-trans c-conta-acerto ~
c-conta-inven-ent c-conta-inven-sai c-conta-mob 

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
DEFINE VARIABLE c-ccusto-acerto AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Acerto":R20 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-ccusto-inven-ent AS CHARACTER FORMAT "x(20)" 
     LABEL "C Custo Inv Entrada":R20 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-ccusto-inven-sai AS CHARACTER FORMAT "x(20)" 
     LABEL "C Custo Inv Sa¡da":R20 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-ccusto-mob AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo MOB":R20 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-ccusto-trans AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Trans":R20 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-conta-acerto AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Acerto":R12 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-conta-inven-ent AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Inv Entrada":R18 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-conta-inven-sai AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Inv Sa¡da":R16 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-conta-mob AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta MOB":R11 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-conta-trans AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Trans":R12 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-desc-acerto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc-acerto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc-inven-ent AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc-inven-sai AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc-tr-mob AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc-trans AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-inven-ent AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-inven-sai AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tr-mob AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-trans AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-conta-trans AT ROW 2.5 COL 23 COLON-ALIGNED
     c-desc-trans AT ROW 2.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-ccusto-trans AT ROW 3.5 COL 23 COLON-ALIGNED
     c-desc-cc-trans AT ROW 3.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-conta-acerto AT ROW 4.5 COL 23 COLON-ALIGNED
     c-desc-acerto AT ROW 4.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-ccusto-acerto AT ROW 5.5 COL 23 COLON-ALIGNED
     c-desc-cc-acerto AT ROW 5.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-conta-inven-ent AT ROW 6.5 COL 23 COLON-ALIGNED
     c-desc-inven-ent AT ROW 6.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-ccusto-inven-ent AT ROW 7.5 COL 23 COLON-ALIGNED
     c-desc-cc-inven-ent AT ROW 7.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-conta-inven-sai AT ROW 8.5 COL 23 COLON-ALIGNED
     c-desc-inven-sai AT ROW 8.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-ccusto-inven-sai AT ROW 9.5 COL 23 COLON-ALIGNED
     c-desc-cc-inven-sai AT ROW 9.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-conta-mob AT ROW 10.5 COL 23 COLON-ALIGNED
     c-desc-tr-mob AT ROW 10.5 COL 41.57 COLON-ALIGNED NO-LABEL
     c-ccusto-mob AT ROW 11.5 COL 23 COLON-ALIGNED
     c-desc-cc-tr-mob AT ROW 11.5 COL 41.57 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
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
         HEIGHT             = 13.08
         WIDTH              = 87.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN c-conta-acerto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-conta-inven-ent IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-conta-inven-sai IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-conta-mob IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-conta-trans IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-desc-acerto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc-acerto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc-inven-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc-inven-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc-tr-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc-trans IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-inven-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-inven-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tr-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-trans IN FRAME f-main
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

&Scoped-define SELF-NAME c-ccusto-acerto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-acerto V-table-Win
ON ENTRY OF c-ccusto-acerto IN FRAME f-main /* Centro Custo Acerto */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-acerto V-table-Win
ON F5 OF c-ccusto-acerto IN FRAME f-main /* Centro Custo Acerto */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN c-ccusto-acerto:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-cc-acerto:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-acerto V-table-Win
ON LEAVE OF c-ccusto-acerto IN FRAME f-main /* Centro Custo Acerto */
DO:
    IF INPUT FRAME {&frame-name} c-ccusto-acerto <> "" THEN 
    DO:   
       RUN pi-desc-ccusto (INPUT  INPUT FRAME {&frame-name} c-ccusto-acerto,
                           OUTPUT c-desc-cc-acerto).
        
       IF RETURN-VALUE = "OK" AND c-desc-cc-acerto <> "" THEN
       DO:
          RUN pi-format-ccusto (OUTPUT c-formato-ccusto).
          ASSIGN c-ccusto-acerto:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto
                 c-desc-cc-acerto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-cc-acerto.
       END.    
       ELSE
           ASSIGN c-desc-cc-acerto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE ASSIGN c-ccusto-acerto:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                c-desc-cc-acerto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-acerto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-acerto IN FRAME f-main /* Centro Custo Acerto */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ccusto-inven-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-ent V-table-Win
ON ENTRY OF c-ccusto-inven-ent IN FRAME f-main /* C Custo Inv Entrada */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-ent V-table-Win
ON F5 OF c-ccusto-inven-ent IN FRAME f-main /* C Custo Inv Entrada */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN c-ccusto-inven-ent:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-cc-inven-ent:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-ent V-table-Win
ON LEAVE OF c-ccusto-inven-ent IN FRAME f-main /* C Custo Inv Entrada */
DO:
    IF INPUT FRAME {&frame-name} c-ccusto-inven-ent <> "" THEN 
    DO:   
       RUN pi-desc-ccusto (INPUT  INPUT FRAME {&frame-name} c-ccusto-inven-ent,
                           OUTPUT c-desc-cc-inven-ent).
        
       IF RETURN-VALUE = "OK" AND c-desc-cc-inven-ent <> "" THEN
       DO:
          RUN pi-format-ccusto (OUTPUT c-formato-ccusto).
          ASSIGN c-ccusto-inven-ent:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto
                 c-desc-cc-inven-ent:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-cc-inven-ent.
       END.    
       ELSE
           ASSIGN c-desc-cc-inven-ent:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE ASSIGN c-ccusto-inven-ent:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                c-desc-cc-inven-ent:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-inven-ent IN FRAME f-main /* C Custo Inv Entrada */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ccusto-inven-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-sai V-table-Win
ON ENTRY OF c-ccusto-inven-sai IN FRAME f-main /* C Custo Inv Sa¡da */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-sai V-table-Win
ON F5 OF c-ccusto-inven-sai IN FRAME f-main /* C Custo Inv Sa¡da */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN c-ccusto-inven-sai:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-cc-inven-sai:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-sai V-table-Win
ON LEAVE OF c-ccusto-inven-sai IN FRAME f-main /* C Custo Inv Sa¡da */
DO:
    IF INPUT FRAME {&frame-name} c-ccusto-inven-sai <> "" THEN 
    DO:   
       RUN pi-desc-ccusto (INPUT  INPUT FRAME {&frame-name} c-ccusto-inven-sai,
                           OUTPUT c-desc-cc-inven-sai).
        
       IF RETURN-VALUE = "OK" AND c-desc-cc-inven-sai <> "" THEN
       DO:
          RUN pi-format-ccusto (OUTPUT c-formato-ccusto).
          ASSIGN c-ccusto-inven-sai:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto
                 c-desc-cc-inven-sai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-cc-inven-sai.
       END.    
       ELSE
           ASSIGN c-desc-cc-inven-sai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE ASSIGN c-ccusto-inven-sai:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                c-desc-cc-inven-sai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-inven-sai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-inven-sai IN FRAME f-main /* C Custo Inv Sa¡da */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ccusto-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-mob V-table-Win
ON ENTRY OF c-ccusto-mob IN FRAME f-main /* Centro Custo MOB */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-mob V-table-Win
ON F5 OF c-ccusto-mob IN FRAME f-main /* Centro Custo MOB */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN c-ccusto-mob:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-cc-tr-mob:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-mob V-table-Win
ON LEAVE OF c-ccusto-mob IN FRAME f-main /* Centro Custo MOB */
DO:
    IF INPUT FRAME {&frame-name} c-ccusto-mob <> "" THEN 
    DO:   
       RUN pi-desc-ccusto (INPUT  INPUT FRAME {&frame-name} c-ccusto-mob,
                           OUTPUT c-desc-cc-tr-mob).
        
       IF RETURN-VALUE = "OK" AND c-desc-cc-tr-mob <> "" THEN
       DO:
          RUN pi-format-ccusto (OUTPUT c-formato-ccusto).
          ASSIGN c-ccusto-mob:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto
                 c-desc-cc-tr-mob:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-cc-tr-mob.
       END.    
       ELSE
           ASSIGN c-desc-cc-tr-mob:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE ASSIGN c-ccusto-mob:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
                c-desc-cc-tr-mob:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-mob V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-mob IN FRAME f-main /* Centro Custo MOB */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ccusto-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-trans V-table-Win
ON ENTRY OF c-ccusto-trans IN FRAME f-main /* Centro Custo Trans */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-trans V-table-Win
ON F5 OF c-ccusto-trans IN FRAME f-main /* Centro Custo Trans */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN c-ccusto-trans:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-cc-trans:SCREEN-VALUE = v_titulo_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-trans V-table-Win
ON LEAVE OF c-ccusto-trans IN FRAME f-main /* Centro Custo Trans */
DO:
    IF INPUT FRAME {&frame-name} c-ccusto-trans <> "" THEN 
    DO:   
       RUN pi-desc-ccusto (INPUT  INPUT FRAME {&frame-name} c-ccusto-trans,
                           OUTPUT c-desc-cc-trans).
        
       IF RETURN-VALUE = "OK" AND c-desc-cc-trans <> "" THEN
       DO:
          RUN pi-format-ccusto (OUTPUT c-formato-ccusto).
          ASSIGN c-ccusto-trans:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto
                 c-desc-cc-trans:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-cc-trans.
       END.    
       ELSE
           ASSIGN c-desc-cc-trans:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE ASSIGN c-ccusto-trans:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                c-desc-cc-trans:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-trans V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-trans IN FRAME f-main /* Centro Custo Trans */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-acerto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-acerto V-table-Win
ON ENTRY OF c-conta-acerto IN FRAME f-main /* Conta Acerto */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-estabel-pad").
    ASSIGN c-estab-pad = RETURN-VALUE.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN c-ccusto-acerto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-acerto V-table-Win
ON F5 OF c-conta-acerto IN FRAME f-main /* Conta Acerto */
DO:
   assign l-implanta = yes.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-conta-acerto:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-acerto:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-acerto V-table-Win
ON LEAVE OF c-conta-acerto IN FRAME f-main /* Conta Acerto */
DO:

    /* Faz o leave do campo de conta contabil e busca se ela utiliza centro de custo */
    {cep/ce0101.i c-desc-acerto c-ccusto-acerto c-desc-cc-acerto}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-acerto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-acerto IN FRAME f-main /* Conta Acerto */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-inven-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-ent V-table-Win
ON ENTRY OF c-conta-inven-ent IN FRAME f-main /* Conta Inv Entrada */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-estabel-pad").
    ASSIGN c-estab-pad = RETURN-VALUE.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN c-ccusto-inven-ent:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-ent V-table-Win
ON F5 OF c-conta-inven-ent IN FRAME f-main /* Conta Inv Entrada */
DO:
  
   assign l-implanta = yes.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-conta-inven-ent:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-inven-ent:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-ent V-table-Win
ON LEAVE OF c-conta-inven-ent IN FRAME f-main /* Conta Inv Entrada */
DO:

    /* Faz o leave do campo de conta contabil e busca se ela utiliza centro de custo */
    {cep/ce0101.i c-desc-inven-ent c-ccusto-inven-ent c-desc-cc-inven-ent}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-inven-ent IN FRAME f-main /* Conta Inv Entrada */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-inven-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-sai V-table-Win
ON ENTRY OF c-conta-inven-sai IN FRAME f-main /* Conta Inv Sa¡da */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-estabel-pad").
    ASSIGN c-estab-pad = RETURN-VALUE.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN c-ccusto-inven-sai:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-sai V-table-Win
ON F5 OF c-conta-inven-sai IN FRAME f-main /* Conta Inv Sa¡da */
DO:
   assign l-implanta = yes.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-conta-inven-sai:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-inven-sai:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-sai V-table-Win
ON LEAVE OF c-conta-inven-sai IN FRAME f-main /* Conta Inv Sa¡da */
DO:
                                           
    /* Faz o leave do campo de conta contabil e busca se ela utiliza centro de custo */
    {cep/ce0101.i c-desc-inven-sai c-ccusto-inven-sai c-desc-cc-inven-sai}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-inven-sai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-inven-sai IN FRAME f-main /* Conta Inv Sa¡da */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-mob V-table-Win
ON ENTRY OF c-conta-mob IN FRAME f-main /* Conta MOB */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-estabel-pad").
    ASSIGN c-estab-pad = RETURN-VALUE.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN c-ccusto-mob:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-mob V-table-Win
ON F5 OF c-conta-mob IN FRAME f-main /* Conta MOB */
DO:

   assign l-implanta = yes.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-conta-mob:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-tr-mob:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-mob V-table-Win
ON LEAVE OF c-conta-mob IN FRAME f-main /* Conta MOB */
DO:

    /* Faz o leave do campo de conta contabil e busca se ela utiliza centro de custo */
    {cep/ce0101.i c-desc-tr-mob c-ccusto-mob c-desc-cc-tr-mob}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-mob V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-mob IN FRAME f-main /* Conta MOB */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-trans V-table-Win
ON ENTRY OF c-conta-trans IN FRAME f-main /* Conta Trans */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-estabel-pad").
    ASSIGN c-estab-pad = RETURN-VALUE.

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN c-ccusto-trans:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-trans V-table-Win
ON F5 OF c-conta-trans IN FRAME f-main /* Conta Trans */
DO:
   assign l-implanta = yes.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-conta-trans:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-trans:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.                    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-trans V-table-Win
ON LEAVE OF c-conta-trans IN FRAME f-main /* Conta Trans */
DO:

    /* Faz o leave do campo de conta contabil e busca se ela utiliza centro de custo */
    {cep/ce0101.i c-desc-trans c-ccusto-trans c-desc-cc-trans}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-trans V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-trans IN FRAME f-main /* Conta Trans */
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
  if c-conta-trans:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-conta-acerto:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-conta-inven-ent:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-conta-inven-sai:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-conta-mob:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-ccusto-trans:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-ccusto-acerto:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-ccusto-inven-ent:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-ccusto-inven-sai:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  if c-ccusto-mob:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.

  {utp/ut-liter.i Conta_Acerto *}
  assign c-conta-acerto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Transit_Transfer *}
  assign c-conta-trans:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Entradas_Invent *}
  assign c-conta-inven-ent:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Sa¡das_Invent *}
  assign c-conta-inven-sai:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Transit¢ria_MOB *}
  assign c-conta-mob:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Centro_Custo_Acerto *}
  assign c-ccusto-acerto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Transit_Transfer *}
  assign c-ccusto-trans:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Entradas_Invent *}
  assign c-ccusto-inven-ent:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Sa¡das_Invent *}
  assign c-ccusto-inven-sai:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Transit¢ria_MOB *}
  assign c-ccusto-mob:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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
  {include/i-vldfrm.i}

  /* Dispatch standard ADM method.                             */
/*  RUN DISPATCH IN THIS-PROCEDURE ("CURRENT-CHANGED":U). */

  RUN dispatch IN THIS-PROCEDURE ('assign-record':U).

  IF  RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.

  if  avail param-estoq then do with frame {&frame-name}:
    
    /* Valida conta e centro de custo */
    {cep\ce0101.i1 c-conta-trans c-ccusto-trans}
    assign param-estoq.ct-tr-transf = input frame {&frame-name} c-conta-trans.
    assign param-estoq.sc-tr-transf = input frame {&frame-name} c-ccusto-trans.
    
    /* Valida conta e centro de custo */
    {cep\ce0101.i1 c-conta-acerto c-ccusto-acerto}
    assign param-estoq.ct-acerto    = input frame {&frame-name} c-conta-acerto.    
    assign param-estoq.sc-acerto    = input frame {&frame-name} c-ccusto-acerto.
    
    /* Valida conta e centro de custo */
    {cep\ce0101.i1 c-conta-inven-ent c-ccusto-inven-ent}
    assign param-estoq.ct-inven-ent = input frame {&frame-name} c-conta-inven-ent.
    assign param-estoq.sc-inven-ent = input frame {&frame-name} c-ccusto-inven-ent.
    
    /* Valida conta e centro de custo */
    {cep\ce0101.i1 c-conta-inven-sai c-ccusto-inven-sai}    
    assign param-estoq.ct-inven-sai = input frame {&frame-name} c-conta-inven-sai. 
    assign param-estoq.sc-inven-sai = input frame {&frame-name} c-ccusto-inven-sai.    
    
    /* Valida conta e centro de custo */
    {cep\ce0101.i1 c-conta-mob c-ccusto-mob}    
    assign param-estoq.ct-tr-mob    = input frame {&frame-name} c-conta-mob.    
    assign param-estoq.sc-tr-mob    = input frame {&frame-name} c-ccusto-mob.

  end.

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

  /* Code placed here will execute AFTER standard behavior.    */

   delete object h_api_cta_ctbl.
   delete object h_api_ccusto. 

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

  /* Code placed here will execute AFTER standard behavior.    */
  disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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

  /* Dispatch standard ADM method.                             */
  
   if  avail param-estoq and not l-inclui and not l-erro then do with frame {&FRAME-NAME}:
       
        assign i-empresa = i-ep-codigo-usuario.
        find estabelec where
             estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.   
                                                    
        ASSIGN c-conta-trans:SCREEN-VALUE      = param-estoq.ct-tr-transf.
        apply "leave" to c-conta-trans      in frame {&FRAME-NAME}.
        ASSIGN c-ccusto-trans:SCREEN-VALUE     = param-estoq.sc-tr-transf.
        apply "leave" to c-ccusto-trans     in frame {&FRAME-NAME}. 
        ASSIGN c-conta-acerto:SCREEN-VALUE     = param-estoq.ct-acerto.
        apply "leave" to c-conta-acerto     in frame {&FRAME-NAME}.       
        ASSIGN c-ccusto-acerto:SCREEN-VALUE    = param-estoq.sc-acerto.
        apply "leave" to c-ccusto-acerto    in frame {&FRAME-NAME}.   
        ASSIGN c-conta-inven-ent:SCREEN-VALUE  = param-estoq.ct-inven-ent.
        apply "leave" to c-conta-inven-ent  in frame {&FRAME-NAME}.  
        ASSIGN c-ccusto-inven-ent:SCREEN-VALUE = param-estoq.sc-inven-ent.
        apply "leave" to c-ccusto-inven-ent in frame {&FRAME-NAME}.
        ASSIGN c-conta-inven-sai:SCREEN-VALUE  = param-estoq.ct-inven-sai.
        apply "leave" to c-conta-inven-sai  in frame {&FRAME-NAME}.
        ASSIGN c-ccusto-inven-sai:SCREEN-VALUE = param-estoq.sc-inven-sai.
        apply "leave" to c-ccusto-inven-sai in frame {&FRAME-NAME}. 
        ASSIGN c-conta-mob:SCREEN-VALUE        = param-estoq.ct-tr-mob.
        apply "leave" to c-conta-mob        in frame {&FRAME-NAME}. 
        ASSIGN c-ccusto-mob:SCREEN-VALUE       = param-estoq.sc-tr-mob.
        apply "leave" to c-ccusto-mob       in frame {&FRAME-NAME}. 

   end.

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

  /* Code placed here will execute AFTER standard behavior.    */
  enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
assign l-inclui = not can-find (first b-param-estoq).

  /* Code placed here will execute PRIOR to standard behavior. */
  
   /* Handle da API Conta ContÙbil */
   run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
   /* Handle da API Centro Custo */
   run prgint\utb\utb742za.py persistent set h_api_ccusto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ct-acerto V-table-Win 
PROCEDURE pi-ct-acerto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "entry" to c-conta-acerto in frame {&frame-name}.
    return no-apply.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ct-iven-ent V-table-Win 
PROCEDURE pi-ct-iven-ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "entry" to c-conta-inven-ent in frame {&frame-name}.
    return no-apply.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ct-iven-sai V-table-Win 
PROCEDURE pi-ct-iven-sai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "entry" to c-conta-inven-sai in frame {&frame-name}.
    return no-apply.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ct-tr-mob V-table-Win 
PROCEDURE pi-ct-tr-mob :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "entry" to c-conta-mob in frame {&frame-name}.
    return no-apply.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ct-trans V-table-Win 
PROCEDURE pi-ct-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "entry" to c-conta-trans in frame {&frame-name}.
    return no-apply.
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
    DEFINE INPUT  PARAMETER p-ccuto       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-ccusto AS CHARACTER NO-UNDO.

    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  STRING(i-empresa),  /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  p-ccuto,            /* CCUSTO */
                                               INPUT  TODAY,              /* DATA DE TRANSACAO */
                                               OUTPUT v_titulo_ccusto ,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
       RETURN "NOK".
    
    ASSIGN p-desc-ccusto = v_titulo_ccusto  WHEN v_titulo_ccusto  <> "".

    RETURN "OK".    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-conta-trans:format      in frame {&FRAME-NAME} = "x(20)".
    assign c-conta-acerto:format     in frame {&FRAME-NAME} = "x(20)".
    assign c-conta-inven-ent:format  in frame {&FRAME-NAME} = "x(20)".
    assign c-conta-inven-sai:format  in frame {&FRAME-NAME} = "x(20)".
    assign c-conta-mob:format        in frame {&FRAME-NAME} = "x(20)".
    assign c-ccusto-trans:format     in frame {&FRAME-NAME} = "x(20)".
    assign c-ccusto-acerto:format    in frame {&FRAME-NAME} = "x(20)".
    assign c-ccusto-inven-ent:format in frame {&FRAME-NAME} = "x(20)".
    assign c-ccusto-inven-sai:format in frame {&FRAME-NAME} = "x(20)".
    assign c-ccusto-mob:format       in frame {&FRAME-NAME} = "x(20)".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-ccusto V-table-Win 
PROCEDURE pi-format-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAMETER p-format-ccusto AS CHAR INITIAL "X(20)" NO-UNDO.

    ASSIGN v_cod_formato = ''.

    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT  "",                 /* PLANO CCUSTO */
                                                   INPUT  TODAY,              /* DATA DE TRANSACAO */
                                                   OUTPUT v_cod_formato,      /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
                                                   
    IF NOT CAN-FIND(FIRST tt_log_erro)THEN 
       ASSIGN p-format-ccusto = v_cod_formato when v_cod_formato <> "".

    RETURN "OK".

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
  {src/adm/template/snd-list.i "param-estoq"}

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

