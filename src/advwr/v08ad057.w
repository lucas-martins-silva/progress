&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V08AD057 2.00.00.019}  /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08ad057 MUT}
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

/* Include de verificacao de versao do EMS */
{cdp/cdcfgfin.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
 
def var c-conta-valida as char no-undo.
def var i-conta-aux as int no-undo init 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cta-corrente
&Scoped-define FIRST-EXTERNAL-TABLE cta-corrente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cta-corrente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cta-corrente.conta-saldo ~
cta-corrente.conta-juros-recebidos cta-corrente.conta-juros-pagos ~
cta-corrente.conta-tit-desc cta-corrente.conta-despes-banc ~
cta-corrente.conta-despes-financ cta-corrente.conta-impto-oper-financ 
&Scoped-define ENABLED-TABLES cta-corrente
&Scoped-define FIRST-ENABLED-TABLE cta-corrente
&Scoped-Define DISPLAYED-FIELDS cta-corrente.conta-saldo ~
cta-corrente.conta-juros-recebidos cta-corrente.conta-juros-pagos ~
cta-corrente.conta-tit-desc cta-corrente.conta-despes-banc ~
cta-corrente.conta-despes-financ cta-corrente.conta-impto-oper-financ 
&Scoped-define DISPLAYED-TABLES cta-corrente
&Scoped-define FIRST-DISPLAYED-TABLE cta-corrente


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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cta-corrente.conta-saldo AT ROW 1.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-juros-recebidos AT ROW 2.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-juros-pagos AT ROW 3.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-tit-desc AT ROW 4.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-despes-banc AT ROW 5.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-despes-financ AT ROW 6.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     cta-corrente.conta-impto-oper-financ AT ROW 7.25 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cta-corrente
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
         HEIGHT             = 7.54
         WIDTH              = 66.57.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME cta-corrente.conta-despes-banc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-banc V-table-Win
ON F5 OF cta-corrente.conta-despes-banc IN FRAME f-main /* Despesa Banc†ria */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-banc V-table-Win
ON LEAVE OF cta-corrente.conta-despes-banc IN FRAME f-main /* Despesa Banc†ria */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}  
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-despes-banc no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-despes-banc:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-despes-banc:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end. 
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-banc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-despes-banc IN FRAME f-main /* Despesa Banc†ria */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-despes-financ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-financ V-table-Win
ON F5 OF cta-corrente.conta-despes-financ IN FRAME f-main /* Despesa Financeira */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-financ V-table-Win
ON LEAVE OF cta-corrente.conta-despes-financ IN FRAME f-main /* Despesa Financeira */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}  
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-despes-financ no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-despes-financ:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-despes-financ:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end. 
    &ENDIF
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-despes-financ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-despes-financ IN FRAME f-main /* Despesa Financeira */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-impto-oper-financ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-impto-oper-financ V-table-Win
ON F5 OF cta-corrente.conta-impto-oper-financ IN FRAME f-main /* Impto Operac Financ */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-impto-oper-financ V-table-Win
ON LEAVE OF cta-corrente.conta-impto-oper-financ IN FRAME f-main /* Impto Operac Financ */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}  
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-impto-oper-financ no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-impto-oper-financ:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-impto-oper-financ:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end. 
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-impto-oper-financ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-impto-oper-financ IN FRAME f-main /* Impto Operac Financ */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-juros-pagos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-pagos V-table-Win
ON F5 OF cta-corrente.conta-juros-pagos IN FRAME f-main /* Cta Juros Pagos */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-pagos V-table-Win
ON LEAVE OF cta-corrente.conta-juros-pagos IN FRAME f-main /* Cta Juros Pagos */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}  
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-juros-pagos no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-juros-pagos:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-juros-pagos:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end. 
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-pagos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-juros-pagos IN FRAME f-main /* Cta Juros Pagos */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-juros-recebidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-recebidos V-table-Win
ON F5 OF cta-corrente.conta-juros-recebidos IN FRAME f-main /* Cta Juros Recebidos */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-recebidos V-table-Win
ON LEAVE OF cta-corrente.conta-juros-recebidos IN FRAME f-main /* Cta Juros Recebidos */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}  
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-juros-recebidos no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-juros-recebidos:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-juros-recebidos:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end.  
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-juros-recebidos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-juros-recebidos IN FRAME f-main /* Cta Juros Recebidos */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-saldo V-table-Win
ON F5 OF cta-corrente.conta-saldo IN FRAME f-main /* Cta Saldo */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-saldo V-table-Win
ON LEAVE OF cta-corrente.conta-saldo IN FRAME f-main /* Cta Saldo */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-saldo no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-saldo:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then  
        assign cta-corrente.conta-saldo:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end.   
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-saldo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-saldo IN FRAME f-main /* Cta Saldo */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-tit-desc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-tit-desc V-table-Win
ON F5 OF cta-corrente.conta-tit-desc IN FRAME f-main /* Cta Tit Descontados */
DO:
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z02ad049.w
                   &campo={&self-name}
                   &campozoom=conta-contabil}
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-tit-desc V-table-Win
ON LEAVE OF cta-corrente.conta-tit-desc IN FRAME f-main /* Cta Tit Descontados */
DO:
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cd9998.i}
    assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-tit-desc no-error.
    if  error-status:error then do:
        assign cta-corrente.conta-tit-desc:format in frame {&FRAME-NAME} = "x(20)".
    end.
    else do:
        if avail param-global then 
        assign cta-corrente.conta-tit-desc:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
    end. 
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-tit-desc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.conta-tit-desc IN FRAME f-main /* Cta Tit Descontados */
DO:
    Apply 'F5' to self.
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

if cta-corrente.conta-saldo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cta-corrente.conta-juros-recebidos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cta-corrente.conta-juros-pagos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
/*if cta-corrente.conta-despesas:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.*/
if cta-corrente.conta-tit-desc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

if cta-corrente.conta-despes-banc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cta-corrente.conta-despes-financ:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cta-corrente.conta-impto-oper-financ:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "cta-corrente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cta-corrente"}

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

  {include/i-valid.i}
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-saldo
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-deb-princ = conta-contab.ct-codigo
              cta-corrente.sc-deb-princ = conta-contab.sc-codigo.
  End.
  
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-juros-recebidos
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-juros-rec = conta-contab.ct-codigo
              cta-corrente.sc-juros-rec = conta-contab.sc-codigo.
  End.
  
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-juros-pagos
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-juros-pg = conta-contab.ct-codigo
              cta-corrente.sc-juros-pg = conta-contab.sc-codigo.
  End.
  
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-despes-banc
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-despes-banc = conta-contab.ct-codigo
              cta-corrente.sc-despes-banc = conta-contab.sc-codigo.            
  End.

  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-despes-financ
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-despes-financ = conta-contab.ct-codigo
              cta-corrente.sc-despes-financ = conta-contab.sc-codigo.            
  End.
  
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-impto-oper-financ
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-impto-oper-financ = conta-contab.ct-codigo
              cta-corrente.sc-impto-oper-financ = conta-contab.sc-codigo.            
  End.
                       
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = input frame {&FRAME-NAME} cta-corrente.conta-tit-desc
             no-lock no-error.
  
  If avail conta-contab then do:
       assign cta-corrente.ct-tit-desc = conta-contab.ct-codigo
              cta-corrente.sc-tit-desc = conta-contab.sc-codigo.            
  End.
&ENDIF

  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  apply "leave" to cta-corrente.conta-saldo in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-juros-recebidos in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-juros-pagos in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-tit-desc in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-despes-banc in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-despes-financ in frame {&frame-name}.
  apply "leave" to cta-corrente.conta-impto-oper-financ in frame {&frame-name}.
&ELSE
    assign cta-corrente.conta-saldo:SENSITIVE in frame {&FRAME-NAME} = no
           cta-corrente.conta-saldo:VISIBLE in frame {&FRAME-NAME} = no
           cta-corrente.conta-juros-recebidos:sensitive in frame {&FRAME-NAME} = no
           cta-corrente.conta-juros-recebidos:VISIBLE in frame {&FRAME-NAME} = no
           cta-corrente.conta-juros-pagos:sensitive in frame {&FRAME-NAME} = no
           cta-corrente.conta-juros-pagos:VISIBLE in frame {&FRAME-NAME} = no
           cta-corrente.conta-tit-desc:sensitive in frame {&FRAME-NAME} = NO
           cta-corrente.conta-tit-desc:VISIBLE in frame {&FRAME-NAME} = no  
           cta-corrente.conta-despes-banc:sensitive in frame {&FRAME-NAME} = no
           cta-corrente.conta-despes-banc:VISIBLE in frame {&FRAME-NAME} = no
           cta-corrente.conta-despes-financ:sensitive in frame {&FRAME-NAME} = no
           cta-corrente.conta-despes-financ:VISIBLE in frame {&FRAME-NAME} = no
           cta-corrente.conta-impto-oper-financ:sensitive in frame {&FRAME-NAME} = no
           cta-corrente.conta-impto-oper-financ:VISIBLE in frame {&FRAME-NAME} = no.
&ENDIF
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  Find first param-global no-lock no-error.
  If avail param-global then do:
     assign cta-corrente.conta-saldo:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil
            cta-corrente.conta-juros-recebidos:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil
            cta-corrente.conta-juros-pagos:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil
           /* cta-corrente.conta-despesas:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil*/
            cta-corrente.conta-tit-desc:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil            
            cta-corrente.conta-despes-banc:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil
            cta-corrente.conta-despes-financ:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil
            cta-corrente.conta-impto-oper-financ:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
  End.
&ENDIF

  /*
  Run utp/ut-limit.p (input "MIN",
                      input param-global.formato-conta-contabil).
  Assign apl-empr-banco.conta-aplicacao:screen-value = return-value.
  Assign apl-empr-banco.conta-correcao :screen-value = return-value.
  Assign apl-empr-banco.conta-juros    :screen-value = return-value.
  Assign apl-empr-banco.conta-ir       :screen-value = return-value.
  Assign apl-empr-banco.conta-ir-estad :screen-value = return-value.
  Assign apl-empr-banco.conta-desp-iof :screen-value = return-value.
  */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-Valida-Conta-Contabil V-table-Win 
PROCEDURE Pi-Valida-Conta-Contabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  Def input parameter c-conta-contabil as char no-undo.
  
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  Find conta-contab 
       where conta-contab.ep-codigo       = i-ep-codigo-usuario and 
             conta-contab.conta-contabil  = c-conta-contabil
             no-lock no-error.
  If not avail conta-contab then do:
      {utp/ut-table.i mgadm conta-contab 1}
      run utp/ut-msgs.p (input "show",
                         input 19,
                         input trim(c-conta-contabil)).
       Return 'ADM-ERROR':U.
  End.
  If conta-contab.tipo = 6 then do:
      run utp/ut-msgs.p (input "show",
                         input 911,
                         input "").
      Return 'ADM-error':U.
  End.
  If conta-contab.estado <> 3 then do:
      run utp/ut-msgs.p (input "show",
                         input 1062,
                         input Trim(c-conta-contabil)).
      Return 'ADM-ERROR':U.
  End.
  If conta-contab.caixa-bancos = 1 then do:
     run utp/ut-msgs.p (input "show",
                        input 7037,
                        input "").
     return 'adm-error':U.
  End.
  if c-conta-contabil = "" then do:
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value). 
     RETURN 'ADM-ERROR'.
  end. 
  
  if  i-conta-aux = 1 then do: /* conta-saldo */
      /* verifica se a conta Ç de sistema, do caixa e bancos e Ç conta de saldo */
      if  conta-contab.caixa-bancos <> 3 then do:
           run utp/ut-msgs.p (input "show",
                             input 16722,
                             input " ").
          RETURN 'ADM-ERROR':U. 
      end.
  end.
&ENDIF 
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
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  {include/i-vldfrm.i}
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-saldo no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Cta_Saldo" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-saldo in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.
  
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-juros-recebidos no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Cta_Juros_Recebidos" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-juros-recebidos in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end. 

  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-juros-pagos no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Cta_Juros_Pagos" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-juros-pagos in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.
  
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-tit-desc no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Cta_Tit_Descontados" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-tit-desc in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.
    
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-despes-banc no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Despesa_Banc†ria" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-despes-banc in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.
  
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-despes-financ no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Despesa_Financeira" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-despes-financ in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.
  
  assign c-conta-valida = input frame {&frame-name} cta-corrente.conta-impto-oper-financ no-error.
  if  error-status:error then do:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Impto_Operac_Financ" *}
      run utp/ut-msgs.p (input "show",
                         input 164,
                         input RETURN-VALUE).
      apply "entry" to cta-corrente.conta-impto-oper-financ in frame {&frame-name}.                      
      RETURN 'ADM-ERROR':U. 
  end.  
  
  assign i-conta-aux = 1.
  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-saldo).
  if  return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      apply 'entry' to cta-corrente.conta-saldo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  
  assign i-conta-aux = 0.
  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-juros-recebidos).
  if  return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      apply 'entry' to cta-corrente.conta-juros-recebidos in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  
  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-juros-pagos).
  If Return-value = "ADM-ERROR" then do:
     {include/i-vldprg.i}
     Apply 'entry' to cta-corrente.conta-juros-pagos in frame {&frame-name}.
     Return 'ADM-ERROR':U.
  end.
  
  find conta-contab where conta-contab.ep-codigo      = i-ep-codigo-usuario
                      and conta-contab.conta-contabil = input frame {&FRAME-NAME} cta-corrente.conta-juros-pagos 
                      no-lock no-error. 
  if  conta-contab.contas-pagar <> 2 then do:      
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 34243,
                         input "").
      apply 'entry' to cta-corrente.conta-juros-pagos in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-tit-desc).
  if  Return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      Apply 'entry' to cta-corrente.conta-tit-desc in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  end.
  
  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-despes-banc).
  if  Return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      Apply 'entry' to cta-corrente.conta-despes-banc in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  end.

  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-despes-financ).
  if  Return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      Apply 'entry' to cta-corrente.conta-despes-financ in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  end.

  run Pi-Valida-Conta-Contabil (input frame {&FRAME-NAME} cta-corrente.conta-impto-oper-financ).
  if  Return-value = "ADM-ERROR" then do:
      {include/i-vldprg.i}
      Apply 'entry' to cta-corrente.conta-impto-oper-financ in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  end.

  find conta-contab where conta-contab.ep-codigo      = i-ep-codigo-usuario 
                      and conta-contab.conta-contabil = input frame {&FRAME-NAME} cta-corrente.conta-tit-desc 
                      no-lock no-error.
  
  if  avail conta-contab then do:
      if  conta-contab.caixa-bancos = 3 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 6238,
                             input "").
          apply 'entry' to cta-corrente.conta-tit-desc in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end. 
      if  conta-contab.contas-receb <> 2 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 809,
                             input "").
          apply 'entry' to cta-corrente.conta-tit-desc in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find param-fasb where param-fasb.ep-codigo = i-ep-codigo-usuario no-lock no-error.
      if  avail param-fasb and param-fasb.moeda-fasb <> 0 then do:
           find ext-fasb where ext-fasb.ep-codigo      = i-ep-codigo-usuario
                           and ext-fasb.conta-contabil = input frame {&frame-name} cta-corrente.conta-tit-desc
                           no-lock no-error.
            if  not avail ext-fasb then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 6239,
                                   input "").
                apply 'entry' to cta-corrente.conta-tit-desc in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.    
            if  ext-fasb.tp-taxacao <> 1 and ext-fasb.tp-taxacao <> 3 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 6240,
                                   input "").
                apply 'entry' to cta-corrente.conta-tit-desc in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.    
      end.
  end.                                                                   
&ENDIF
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
  {src/adm/template/snd-list.i "cta-corrente"}

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

