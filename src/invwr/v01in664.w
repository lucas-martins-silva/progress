&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V01IN664 2.00.00.007 } /*** 010007 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in664 MUT}
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

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

define buffer b-consumo-estab for consumo-estab.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

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

def var v_cod_estabel        as char   no-undo.

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
&Scoped-define EXTERNAL-TABLES consumo-estab
&Scoped-define FIRST-EXTERNAL-TABLE consumo-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR consumo-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS consumo-estab.qt-entrada ~
consumo-estab.qt-saida 
&Scoped-define ENABLED-TABLES consumo-estab
&Scoped-define FIRST-ENABLED-TABLE consumo-estab
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 
&Scoped-Define DISPLAYED-FIELDS consumo-estab.cod-estabel-prin ~
consumo-estab.ct-codigo consumo-estab.sc-codigo consumo-estab.it-codigo ~
consumo-estab.periodo consumo-estab.qt-entrada consumo-estab.qt-saida 
&Scoped-define DISPLAYED-TABLES consumo-estab
&Scoped-define FIRST-DISPLAYED-TABLE consumo-estab
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-conta c-desc-ccusto ~
c-desc-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS consumo-estab.cod-estabel-prin ~
consumo-estab.ct-codigo consumo-estab.sc-codigo consumo-estab.it-codigo ~
consumo-estab.periodo 

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
DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 53.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.5.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     consumo-estab.cod-estabel-prin AT ROW 1.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     c-desc-estabel AT ROW 1.25 COL 33.29 COLON-ALIGNED NO-LABEL
     consumo-estab.ct-codigo AT ROW 2.25 COL 25.72 COLON-ALIGNED
          LABEL "Conta Cont bil"
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     c-desc-conta AT ROW 2.25 COL 44.29 COLON-ALIGNED NO-LABEL
     consumo-estab.sc-codigo AT ROW 3.25 COL 25.72 COLON-ALIGNED
          LABEL "Centro de Custo"
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     c-desc-ccusto AT ROW 3.25 COL 44.29 COLON-ALIGNED NO-LABEL
     consumo-estab.it-codigo AT ROW 4.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 4.25 COL 43.86 COLON-ALIGNED NO-LABEL
     consumo-estab.periodo AT ROW 5.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     consumo-estab.qt-entrada AT ROW 6.75 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     consumo-estab.qt-saida AT ROW 7.75 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-key-2 AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.consumo-estab
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
         HEIGHT             = 7.88
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN consumo-estab.cod-estabel-prin IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN consumo-estab.ct-codigo IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN consumo-estab.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN consumo-estab.periodo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN consumo-estab.sc-codigo IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
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

&Scoped-define SELF-NAME consumo-estab.cod-estabel-prin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.cod-estabel-prin V-table-Win
ON F5 OF consumo-estab.cod-estabel-prin IN FRAME f-main /* Estabelecimento Principal */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=consumo-estab.cod-estabel-prin
                       &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.cod-estabel-prin V-table-Win
ON LEAVE OF consumo-estab.cod-estabel-prin IN FRAME f-main /* Estabelecimento Principal */
DO:

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estabel
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             consumo-estab.cod-estabel-prin"}

      
    find estabelec where
         estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.        

    ASSIGN consumo-estab.ct-codigo:FORMAT IN frame {&frame-name} = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT consumo-estab.ct-codigo.

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

        if c-formato-conta <> "" then
            assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
        if c-formato-ccusto <> "" then
            assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.cod-estabel-prin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF consumo-estab.cod-estabel-prin IN FRAME f-main /* Estabelecimento Principal */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME consumo-estab.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.ct-codigo V-table-Win
ON ENTRY OF consumo-estab.ct-codigo IN FRAME f-main /* Conta Cont bil */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE consumo-estab.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.ct-codigo V-table-Win
ON F5 OF consumo-estab.ct-codigo IN FRAME f-main /* Conta Cont bil */
DO:

   assign l-implanta          = yes.
                    
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* MàDULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.ct-codigo V-table-Win
ON LEAVE OF consumo-estab.ct-codigo IN FRAME f-main /* Conta Cont bil */
DO:
     
    find estabelec where
         estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.        

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT consumo-estab.ct-codigo.

    /* Busca dados da conta cont bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
		assign v_cod_estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE consumo-estab.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN consumo-estab.sc-codigo:SCREEN-VALUE = "".
            ASSIGN c-desc-ccusto:SCREEN-VALUE = "".
            DISABLE consumo-estab.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF consumo-estab.ct-codigo IN FRAME f-main /* Conta Cont bil */
DO:

    apply 'F5' to self.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME consumo-estab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.it-codigo V-table-Win
ON F5 OF consumo-estab.it-codigo IN FRAME f-main /* Item */
DO:

    assign l-implanta = yes.

    {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                    &tabela=consumo-estab
                    &atributo=it-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.it-codigo V-table-Win
ON LEAVE OF consumo-estab.it-codigo IN FRAME f-main /* Item */
DO:

    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-desc-item
                     &where="item.it-codigo = input frame {&frame-name} consumo-estab.it-codigo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME consumo-estab.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.sc-codigo V-table-Win
ON F5 OF consumo-estab.sc-codigo IN FRAME f-main /* Centro de Custo */
DO:
    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,          /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN consumo-estab.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.sc-codigo V-table-Win
ON LEAVE OF consumo-estab.sc-codigo IN FRAME f-main /* Centro de Custo */
DO:
    {cdp/cd9998.i}
    ASSIGN v_cod_ccusto = INPUT consumo-estab.sc-codigo.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL consumo-estab.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF consumo-estab.sc-codigo IN FRAME f-main /* Centro de Custo */
DO:
    apply 'F5' to self.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if consumo-estab.it-codigo:load-mouse-pointer        ("image/lupa.cur") in frame {&frame-name} then.
  if consumo-estab.ct-codigo:load-mouse-pointer        ("image/lupa.cur") in frame {&frame-name} then.
  if consumo-estab.sc-codigo:load-mouse-pointer        ("image/lupa.cur") in frame {&frame-name} then.
  if consumo-estab.cod-estabel-prin:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "consumo-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "consumo-estab"}

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

    def var gravar as logical initial true no-undo.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    
    find estabelec where
         estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.        

    /* Busca dados conta cont bil */
    assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_cta_ctbl = input frame {&frame-name} consumo-estab.ct-codigo.
    assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        run utp/ut-msgs.p (input "show", 
                           input 17006, 
                           STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).

        assign gravar = false.
    end.

    /* Verifica se a conta utiliza centro de custo */
	assign v_cod_estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin.
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */

    IF v_log_utz_ccusto THEN DO:
        /* Busca centro de custo */
        assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
        ASSIGN v_cod_ccusto = input frame {&frame-name} consumo-estab.sc-codigo.
        assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
        
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        
            assign gravar = false.
        end.  
    END.
    
    if gravar then
       assign consumo-estab.ct-codigo = v_cod_cta_ctbl
              consumo-estab.sc-codigo = v_cod_ccusto.       

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

  /* Elimina handle's */
  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
  if valid-handle(h_api_ccusto) then
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Handle da API Conta Contÿbil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto.  

    if available consumo-estab then do with frame {&frame-name}:

        find estabelec where
            estabelec.cod-estabel = consumo-estab.cod-estabel-prin
            no-lock no-error.
        assign c-desc-estabel:screen-value = if available estabelec 
                                             then estabelec.nome 
                                             else "".

                
                find estabelec where
                         estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin no-lock no-error.
                assign i-empresa = estabelec.ep-codigo when avail estabelec.    
        
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

        if c-formato-conta <> "" then
            assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
        if c-formato-ccusto <> "" then
            assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.  

        /* Busca dados conta cont bil */
        ASSIGN v_cod_cta_ctbl = consumo-estab.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */

        ASSIGN consumo-estab.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.

        /* Busca centro de custo */
        ASSIGN v_cod_ccusto = consumo-estab.sc-codigo.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
        
        ASSIGN consumo-estab.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
        ASSIGN c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.


        find item where
            item.it-codigo = consumo-estab.it-codigo
            no-lock no-error.
        assign c-desc-item:screen-value = if available item 
                                          then item.desc-item
                                          else "".

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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

    find first param-global no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

    if not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    if consumo-estab.cod-estabel-prin:sensitive in frame {&frame-name} = yes and
        consumo-estab.ct-codigo:sensitive       in frame {&frame-name} = yes and
        consumo-estab.sc-codigo:sensitive       in frame {&frame-name} = yes and 
        consumo-estab.it-codigo:sensitive       in frame {&frame-name} = yes and 
        consumo-estab.periodo:sensitive         in frame {&frame-name} = yes and 
        can-find(b-consumo-estab
        where b-consumo-estab.cod-estabel-prin = input frame {&frame-name} consumo-estab.cod-estabel-prin and
              b-consumo-estab.ct-codigo        = input frame {&frame-name} consumo-estab.ct-codigo        and
              b-consumo-estab.sc-codigo        = input frame {&frame-name} consumo-estab.sc-codigo        and   
              b-consumo-estab.it-codigo        = input frame {&frame-name} consumo-estab.it-codigo        and   
              b-consumo-estab.periodo          = input frame {&frame-name} consumo-estab.periodo) 
              then do:
        run utp/ut-msgs.p (input "show", input 35, input "").
        return 'adm-error'.
    end.

    find estabelec where
        estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin
        no-lock no-error.
    if not available estabelec then do:
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to consumo-estab.cod-estabel-prin in frame {&frame-name}.
        return 'adm-error'.
    end.                    

    find item where
        item.it-codigo = input frame {&frame-name} consumo-estab.it-codigo
        no-lock no-error.
    if not available item then do:
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to consumo-estab.it-codigo in frame {&frame-name}.
        return 'adm-error'.
    end.

    
    find estabelec where
         estabelec.cod-estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.        
    
  
    /* Busca dados conta cont bil */
    assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_cta_ctbl = input frame {&frame-name} consumo-estab.ct-codigo.
    assign consumo-estab.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        run utp/ut-msgs.p (input "show", 
                           input 17006, 
                           STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).

        apply "entry" to consumo-estab.ct-codigo in frame {&frame-name}.
        return 'adm-error'.
    end.
    
    if lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and
       lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) = 0 and
       lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) = 0 then do:  
    /*if conta -contab.estoque  <> 1 and 
        conta -contab.estoque <> 3 and 
        conta -contab.estoque <> 6 then do: */
        run utp/ut-msgs.p (input "show", input 16285, input "").
        return 'adm-error'.
    end.    

    /* Verifica se a conta utiliza centro de custo */
	assign v_cod_estabel = input frame {&frame-name} consumo-estab.cod-estabel-prin.
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */

    IF v_log_utz_ccusto THEN DO:
        /* Busca centro de custo */
        assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
        ASSIGN v_cod_ccusto = input frame {&frame-name} consumo-estab.sc-codigo.
        assign consumo-estab.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
        
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
    
            apply "entry" to consumo-estab.sc-codigo in frame {&frame-name}.
            return 'adm-error'.
        end.        
    END.

    find first estab-mat where
        estab-mat.cod-estabel-prin = input frame {&frame-name} consumo-estab.cod-estabel-prin
        no-lock no-error.
    if not available estab-mat then do:
        {utp/ut-liter.i Estabelecimento_Principal * r}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to consumo-estab.cod-estabel-prin in frame {&frame-name}.
        return 'adm-error'.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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

/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "consumo-estab"}

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

