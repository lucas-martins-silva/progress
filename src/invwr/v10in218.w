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
{include/i-prgvrs.i V10IN218 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10IN218 MUT}
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
 
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def var h_v07in218 as handle.
def var h_v09in218 as handle.
def var h_v14in218 as handle.
def var h_window   as handle.
def var c-container as c.

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "Nœmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

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

def var i-empresa   like param-global.empresa-prin no-undo.
def var c-estabelec as char                        no-undo.

{cdp/cd9590.i}    /*Include verifica‡Æo Unidade Neg¢cio*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-descricao

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.op-seq 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.op-seq movto-estoq.descricao-db 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-ct-aplic c-desc-ct-aplic c-sc-aplic ~
c-desc-sc-aplic c-cod-un-db c-desc-un-db 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-ct-aplic c-sc-aplic c-cod-un-db 

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
DEFINE VARIABLE c-cod-un-db AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Neg Aplica‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-aplic AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Aplica‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ct-aplic AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sc-aplic AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un-db AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-aplic AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro de Custo" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.43 BY 6.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-descricao
     movto-estoq.op-seq AT ROW 1.33 COL 83.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.86 BY .46
     c-ct-aplic AT ROW 1.38 COL 20.29 COLON-ALIGNED WIDGET-ID 4
     c-desc-ct-aplic AT ROW 1.38 COL 39.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-sc-aplic AT ROW 2.42 COL 20.29 COLON-ALIGNED WIDGET-ID 10
     c-desc-sc-aplic AT ROW 2.42 COL 39.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-cod-un-db AT ROW 3.46 COL 20.29 COLON-ALIGNED WIDGET-ID 2
     c-desc-un-db AT ROW 3.46 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     movto-estoq.descricao-db AT ROW 4.54 COL 3.14 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 82.29 BY 3.25
     rt-mold AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 7
         WIDTH              = 87.
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
/* SETTINGS FOR FRAME f-descricao
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-descricao:SCROLLABLE       = FALSE
       FRAME f-descricao:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-un-db IN FRAME f-descricao
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-ct-aplic IN FRAME f-descricao
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-ct-aplic IN FRAME f-descricao
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sc-aplic IN FRAME f-descricao
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un-db IN FRAME f-descricao
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-aplic IN FRAME f-descricao
   NO-ENABLE 3                                                          */
/* SETTINGS FOR EDITOR movto-estoq.descricao-db IN FRAME f-descricao
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.op-seq:HIDDEN IN FRAME f-descricao           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-descricao
/* Query rebuild information for FRAME f-descricao
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-descricao */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-un-db
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-db V-table-Win
ON F5 OF c-cod-un-db IN FRAME f-descricao /* Unid Neg Aplica‡Æo */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="c-cod-un-db"
                             &Frame1="f-descricao"
                             &EnableImplant="no"}
                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-db V-table-Win
ON LEAVE OF c-cod-un-db IN FRAME f-descricao /* Unid Neg Aplica‡Æo */
DO:
  {include/leave.i &tabela=unid-negoc
                   &atributo-ref=des-unid-negoc
                   &variavel-ref=c-desc-un-db
                   &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} c-cod-un-db"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-db V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-un-db IN FRAME f-descricao /* Unid Neg Aplica‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-aplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-aplic V-table-Win
ON ENTRY OF c-ct-aplic IN FRAME f-descricao /* Conta Aplica‡Æo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ENABLE c-sc-aplic WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-aplic V-table-Win
ON F5 OF c-ct-aplic IN FRAME f-descricao /* Conta Aplica‡Æo */
DO:


    def var v_cod_finalid as char no-undo.                                               
  /* assign v_cod_finalid = {adinc/i05ad049.i 4 9}. */ /* 9 - Saldo por grupo de estoque */
   assign v_cod_finalid = "(nenhum)".

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MODULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN c-ct-aplic:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-desc-ct-aplic:SCREEN-VALUE = v_titulo_cta_ctbl.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-aplic V-table-Win
ON LEAVE OF c-ct-aplic IN FRAME f-descricao /* Conta Aplica‡Æo */
DO:

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-ct-aplic.

    /* Busca dados da conta cont˜bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-sc-aplic WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN c-sc-aplic:SCREEN-VALUE = "".
            ASSIGN c-desc-sc-aplic:SCREEN-VALUE = "".
            DISABLE c-sc-aplic WITH FRAME {&FRAME-NAME}.
           
        END.

        /************************************************/

        /*TPLWZW*/
        /*A chamada abaixo, estava fazendo com que a movimenta‡Æo de estoque fosse gerada com a conta de debito e de credito iguais,*/
        /*o que est  errado. A conta de debito ser  buscada pelo programa v07in218, atrav‚s da execu‡Æo da procedure getDadosAplicacao */
             /*   run pi-atualiza-conta in h_v07in218 (input v_cod_cta_ctbl,
                                             input v_titulo_cta_ctbl,
                                             input v_ind_finalid_cta). */

    END.
    ASSIGN c-desc-ct-aplic:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-aplic V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-aplic IN FRAME f-descricao /* Conta Aplica‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-aplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-aplic V-table-Win
ON F5 OF c-sc-aplic IN FRAME f-descricao /* Centro de Custo */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN c-sc-aplic:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN c-desc-sc-aplic:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-aplic V-table-Win
ON LEAVE OF c-sc-aplic IN FRAME f-descricao /* Centro de Custo */
DO:
    {cdp/cd9998.i}
    ASSIGN v_cod_ccusto = INPUT c-sc-aplic.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */


    ASSIGN c-desc-sc-aplic:SCREEN-VALUE = v_titulo_ccusto. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-aplic V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-aplic IN FRAME f-descricao /* Centro de Custo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  IF c-ct-aplic:load-mouse-pointer("image/lupa.cur") then.
  if c-sc-aplic:load-mouse-pointer ("image/lupa.cur") then.
  if c-cod-un-db:load-mouse-pointer ("image/lupa.cur") then.
 
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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
  HIDE FRAME f-descricao.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDadosAplicacao V-table-Win 
PROCEDURE getDadosAplicacao :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p-cod-un-db AS char format "x(3)"  NO-UNDO.
  DEFINE OUTPUT PARAMETER p-ct-db     AS char format "x(20)" NO-UNDO.
  DEFINE OUTPUT PARAMETER p-sc-db     AS char format "x(20)" NO-UNDO.
 
  run pi-desformata-campos.
 
  assign p-cod-un-db = c-cod-un-db:screen-value IN FRAME {&FRAME-NAME}
         p-ct-db     = c-ct-aplic:screen-value  IN FRAME {&FRAME-NAME}
         p-sc-db     = c-sc-aplic:screen-value  IN FRAME {&FRAME-NAME}.  
         
  run pi-formata-campos.
  
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
 
  /*assign movto-estoq.descricao-db:sensitive in frame {&frame-name} = no. 
  disable movto-estoq.descricao-db with frame {&frame-name}.*/
 

  /* Handle da API Conta Contÿbil */
  if not valid-handle(h_api_cta_ctbl) then
      run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  if not valid-handle(h_api_ccusto) then
      run prgint\utb\utb742za.py persistent set h_api_ccusto.

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  disable movto-estoq.descricao-db with frame {&frame-name}.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  disable movto-estoq.descricao-db with frame {&frame-name}.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  /* Habilitar os campos corretamente */
  RUN local-display-fields.

  /*assign movto-estoq.descricao-db:sensitive in frame {&frame-name} = no. 
  disable movto-estoq.descricao-db with frame {&frame-name}.*/
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
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  assign movto-estoq.descricao-db:screen-value in frame {&frame-name} = "".

  find first param-global no-lock no-error.
  
  find estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.   

  /*run pi-atualiza-formatos.*/ 

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
  /* Code placed here will execute AFTER standard behavior.    */
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
  find first item where 
       item.it-codigo = return-value no-lock no-error.
  if avail item and 
     item.tipo-contr = 4 then 
     enable movto-estoq.descricao-db with frame {&frame-name}.
  else disable movto-estoq.descricao-db with frame {&frame-name}.
 
  assign movto-estoq.descricao-db:screen-value in frame {&frame-name} = "".

  find first param-global no-lock no-error.
  
  find estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
assign c-ct-aplic:format    in frame {&frame-name} = "x(20)":U
       c-sc-aplic:format    in frame {&frame-name} = "x(20)":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-epc V-table-Win 
PROCEDURE pi-epc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Chamada EPC para a assign record */
  {include/i-epc003.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
/* Formatando conta e centro de custo */
  if c-formato-conta <> "" then do:
      assign c-ct-aplic:format    in frame {&FRAME-NAME} = c-formato-conta.
  end.
  if c-formato-ccusto <> "" then do:
      assign c-sc-aplic:format    in frame {&FRAME-NAME} = c-formato-ccusto.
  end.           
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def input param l-habilita as l no-undo.

assign
    c-ct-aplic:screen-value in frame {&frame-name} = " "
    c-sc-aplic:screen-value in frame {&frame-name} = " "
    c-desc-ct-aplic:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = " "
    c-desc-sc-aplic:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = " "
    c-ct-aplic:sensitive    in frame {&FRAME-NAME} = l-habilita
    c-sc-aplic:sensitive    in frame {&FRAME-NAME} = l-habilita.

if l-unidade-negocio then
    assign c-cod-un-db:sensitive                   in frame {&frame-name} = l-habilita
           c-cod-un-db:SCREEN-VALUE                in frame {&frame-name} = " "
           c-desc-un-db:SCREEN-VALUE               in frame {&frame-name} = " ".
ELSE 
    assign c-cod-un-db:sensitive                   in frame {&frame-name} = NO
           c-cod-un-db:SCREEN-VALUE                in frame {&frame-name} = " "
           c-desc-un-db:SCREEN-VALUE               in frame {&frame-name} = " ".

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "it-codigo").     
find item where
     item.it-codigo = return-value 
     no-lock no-error.
     
if avail item and
   (item.tipo-contr = 1 or 
    item.tipo-contr = 4) then do:
    
    if item.ct-codigo <> "" then do:
       assign c-ct-aplic:screen-value in frame {&frame-name} = item.ct-codigo.
       apply 'leave' to c-ct-aplic in frame {&frame-name}. 
    end.
    if item.sc-codigo <> "" then do:
       assign c-sc-aplic:screen-value in frame {&frame-name} = item.sc-codigo.
       apply 'leave' to c-sc-aplic in frame {&frame-name}.
    end.    
      
end.     

  /* Se o item for D‚bito direto, habilita a leitura da descri‡Æo DD. Caso contr rio
     desabilita o campo */
  if avail item and item.tipo-contr = 4 then
    enable movto-estoq.descricao-db with frame {&frame-name}.
  else
    disable movto-estoq.descricao-db with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle1 as handle.
def input param p-handle2 as handle.
def input param p-handle3 as handle.
def input param p-handle4 as handle.
 
assign h_v07in218 = p-handle1
       h_v09in218 = p-handle2
       h_v14in218 = p-handle3
       h_window   = p-handle4.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-est V-table-Win 
PROCEDURE pi-recebe-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-estabelec as char no-undo.
    
    assign c-estabelec = p-estabelec.
    find first estabelec where
         estabelec.cod-estabel = c-estabelec no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec. 
    
    run pi-atualiza-formatos.

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
 /* Chamada EPC para a pi-validate */
 {include/i-epc002.i} 

 def var unid-negoc-db as char no-undo.
 assign unid-negoc-db = input c-cod-un-db.

 /* Validando unidade de negocio DB */
 if unid-negoc-db <> "" then do: 
     if not can-find (first unid-negoc
                      where unid-negoc.cod-unid-negoc = unid-negoc-db) then do:
         {utp/ut-table.i mgind unid-negoc 1}
         run utp/ut-msgs.p (input "show", 
                            input 2, 
                            input return-value + '~~' + unid-negoc-db).
         apply "entry" to c-cod-un-db in frame {&frame-name}.
         return 'adm-error'.
     end.
 end.


 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
 find first item where
      item.it-codigo = return-value no-lock no-error.
 if item.tipo-contr = 4 or
    item.tipo-contr = 1 or
    item.it-codigo = "" then do:
    
    
    find estabelec where
         estabelec.cod-estabel = c-estabelec no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec. 

    /* Validando Conta e Centro de Custo de aplicacao (DB) */

    run pi-desformata-campos.
    /* Conta */
    ASSIGN v_cod_cta_ctbl = c-ct-aplic:screen-value.
    /* Centro de custo */
    ASSIGN v_cod_ccusto = c-sc-aplic:screen-value.
    run pi-formata-campos.

    /* Busca dados da conta cont bil */
    
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */ 

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF AVAIL tt_log_erro THEN DO:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U,
                            input 17006,
                            STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                          
         apply "entry" to c-ct-aplic in frame {&frame-name}.
         return 'ADM-ERROR':U.
    END.

    if v_num_tip_cta_ctbl = 6 then do: 
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,
                           input 286,
                           input return-value).
        apply "entry" to c-ct-aplic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if v_num_sit_cta_ctbl <> 3 then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 443,
                          input return-value).
       apply "entry" to c-ct-aplic in frame {&frame-name}.                      
       return 'ADM-ERROR':U.
    end.
    if lookup("(nenhum)", v_ind_finalid_cta) <> 0 then do:
    /*if conta - contab.estoque = 0 then do:*/
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 445,
                          input return-value).
       apply "entry" to c-ct-aplic in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    if lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 then do:
    /*if conta - contab.estoque = 9 then do:*/
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 1784,
                          input return-value).
       apply "entry" to c-ct-aplic in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.

    /* Verifica se a conta utiliza centro de custo */
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF v_log_utz_ccusto THEN DO:
        /* Busca dados do centro de custo */
        ASSIGN v_cod_ccusto = INPUT c-sc-aplic.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
                                                 
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U,
                              input 17006,
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
           apply "entry" to c-sc-aplic in frame {&frame-name}.
           return 'ADM-ERROR':U.       
        end.
    END.
 end.

 /* Chamada EPC para a after validate */
 {include/i-epc019.i}

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
  {src/adm/template/snd-list.i "movto-estoq"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-unid-negoc-db V-table-Win 
PROCEDURE set-unid-negoc-db :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cod-un AS CHARACTER  NO-UNDO.

/*Unid Neg¢cio DB*/
if c-cod-un-db:sensitive in frame {&frame-name} then do:
    assign c-cod-un-db:screen-value in frame {&frame-name} = p-cod-un.

    apply 'leave' to c-cod-un-db in frame {&frame-name}.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDadosAplicacao V-table-Win 
PROCEDURE setDadosAplicacao :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-ct-db     AS char format "x(20)" NO-UNDO.
  DEFINE INPUT PARAMETER p-sc-db     AS char format "x(20)" NO-UNDO.
  DEFINE INPUT PARAMETER p-habilitado as logical no-undo.
 
  assign c-ct-aplic:screen-value  IN FRAME {&FRAME-NAME} = p-ct-db
         c-sc-aplic:screen-value  IN FRAME {&FRAME-NAME} = p-sc-db.
      
  assign c-ct-aplic:sensitive    in frame {&FRAME-NAME} = p-habilitado.
  assign c-sc-aplic:sensitive    in frame {&FRAME-NAME} = p-habilitado.      
           
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-formatos V-table-Win 
PROCEDURE pi-atualiza-formatos :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  today,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */ 

  IF c-formato-conta <> "" THEN
    ASSIGN c-ct-aplic:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.
  IF c-formato-ccusto <> "" THEN
    ASSIGN c-sc-aplic:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
