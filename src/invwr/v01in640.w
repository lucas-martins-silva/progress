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
{include/i-prgvrs.i V01IN640 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN640 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-utiliz-natu-despes for utiliz-natu-despes.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

def var h_api_cta_ctbl       as handle no-undo.
def var c-formato-conta      as char no-undo.

/* Vari˜veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.

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
&Scoped-define EXTERNAL-TABLES utiliz-natu-despes
&Scoped-define FIRST-EXTERNAL-TABLE utiliz-natu-despes


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR utiliz-natu-despes.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS utiliz-natu-despes.ct-codigo 
&Scoped-define ENABLED-TABLES utiliz-natu-despes
&Scoped-define FIRST-ENABLED-TABLE utiliz-natu-despes
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS utiliz-natu-despes.cod-nat-despesa ~
utiliz-natu-despes.cod-utiliz utiliz-natu-despes.ct-codigo 
&Scoped-define DISPLAYED-TABLES utiliz-natu-despes
&Scoped-define FIRST-DISPLAYED-TABLE utiliz-natu-despes
&Scoped-Define DISPLAYED-OBJECTS c-desc-nat c-desc-utiliz c-desc-conta 

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
cod-utiliz||y|mgind.utiliz-natu-despes.cod-utiliz
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-utiliz"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nat AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-utiliz AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.57 BY 1.96.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.57 BY 2.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     utiliz-natu-despes.cod-nat-despesa AT ROW 1.33 COL 18.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     c-desc-nat AT ROW 1.33 COL 24.29 COLON-ALIGNED NO-LABEL
     utiliz-natu-despes.cod-utiliz AT ROW 2.33 COL 18.29 COLON-ALIGNED
          LABEL "C¢digo Utiliza‡Æo"
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc-utiliz AT ROW 2.33 COL 34.72 COLON-ALIGNED NO-LABEL
     utiliz-natu-despes.ct-codigo AT ROW 4.42 COL 18.29 COLON-ALIGNED
          LABEL "Conta"
          VIEW-AS FILL-IN 
          SIZE 20.14 BY .88
     c-desc-conta AT ROW 4.42 COL 38.72 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 3.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.utiliz-natu-despes
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
         HEIGHT             = 4.83
         WIDTH              = 79.57.
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

/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-nat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-utiliz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN utiliz-natu-despes.cod-nat-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN utiliz-natu-despes.cod-utiliz IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN utiliz-natu-despes.ct-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME utiliz-natu-despes.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL utiliz-natu-despes.ct-codigo V-table-Win
ON ENTRY OF utiliz-natu-despes.ct-codigo IN FRAME f-main /* Conta */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL utiliz-natu-despes.ct-codigo V-table-Win
ON F5 OF utiliz-natu-despes.ct-codigo IN FRAME f-main /* Conta */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                  input  "CEP",               /* MODULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF return-value = "OK" THEN DO:
       ASSIGN self:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL utiliz-natu-despes.ct-codigo V-table-Win
ON LEAVE OF utiliz-natu-despes.ct-codigo IN FRAME f-main /* Conta */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT utiliz-natu-despes.ct-codigo.

    run pi_busca_dados_cta_integr in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                     input        v_cod_cta_ctbl,      /* CONTA */
                                                     input        today,               /* DATA TRANSACAO */   
                                                     input        "CEP",               /* MODULO */
                                                     output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl,  /* SITUACAO DA CONTA */
                                                     output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).        /* ERROS */
    
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        if c-formato-conta <> "" then
            ASSIGN SELF:FORMAT = c-formato-conta.
        assign c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl. 
    END.                                                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL utiliz-natu-despes.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF utiliz-natu-despes.ct-codigo IN FRAME f-main /* Conta */
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

utiliz-natu-despes.ct-codigo:load-mouse-pointer ("Image/lupa.cur") in frame {&frame-name}.

  {utp/ut-liter.i Conta * l}
  assign utiliz-natu-despes.ct-codigo:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "utiliz-natu-despes"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "utiliz-natu-despes"}

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
  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.

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
  
  /* Code placed here will execute PRIOR to standard behavior. */
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                     input  "",                  /* PLANO CONTAS */
                                                     input  today,               /* DATA DE TRANSACAO */
                                                     output c-formato-conta,     /* FORMATO CONTA */
                                                     output table tt_log_erro).  /* ERROS */    
  
  IF c-formato-conta <> "" THEN
    ASSIGN utiliz-natu-despes.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.  
    
  if avail utiliz-natu-despes then do:
    
    /* Buscando dados da conta cont bil */
    ASSIGN v_cod_cta_ctbl = utiliz-natu-despes.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input        "",                  /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,      /* CONTA */
                                                   input        today,               /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,  /* SITUACAO DA CONTA */
                                                   output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).        /* ERROS */
                                                   
    assign c-desc-conta = v_titulo_cta_ctbl.                                                       
    
  end.  
  
  {utp/ut-liter.i Conta * l}
  assign utiliz-natu-despes.ct-codigo:label in frame {&frame-name} = return-value.

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
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-valores V-table-Win 
PROCEDURE pi-grava-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param r-rowid as row.
def input-output param l-retorno as logical.
 
/* Buscando dados da conta cont bil */
ASSIGN v_cod_cta_ctbl = input frame {&frame-name} utiliz-natu-despes.ct-codigo.
run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               input        "",                  /* PLANO DE CONTAS */
                                               input-output v_cod_cta_ctbl,      /* CONTA */
                                               input        today,               /* DATA TRANSACAO */   
                                               output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                               output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                               output       v_num_sit_cta_ctbl,  /* SITUACAO DA CONTA */
                                               output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                               output table tt_log_erro).        /* ERROS */
                                               
find first tt_log_erro no-lock no-error.
if avail tt_log_erro then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 17006, 
                       STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                       
    assign l-retorno = no.                       
    apply 'entry' to utiliz-natu-despes.ct-codigo in frame {&frame-name}.
    return 'adm-error'.                
end.
else do:
    find current b-utiliz-natu-despes exclusive-lock no-error.
    assign b-utiliz-natu-despes.ct-codigo  = input frame {&frame-name} utiliz-natu-despes.ct-codigo
           l-retorno                     = yes.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-dados V-table-Win 
PROCEDURE pi-mostra-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param r-rowid as row.
        
enable utiliz-natu-despes.ct-codigo with frame {&frame-name}.
find b-utiliz-natu-despes where rowid(b-utiliz-natu-despes) = r-rowid no-error.
assign utiliz-natu-despes.cod-nat-despesa:screen-value in frame {&frame-name} = string(b-utiliz-natu-despes.cod-nat-despesa)
       utiliz-natu-despes.cod-utiliz:screen-value in frame {&frame-name} = string(b-utiliz-natu-despes.cod-utiliz)
       utiliz-natu-despes.ct-codigo:screen-value in frame {&frame-name} = string(b-utiliz-natu-despes.ct-codigo).
       
find natureza-despesa where 
     natureza-despesa.nat-despesa = input frame {&frame-name} utiliz-natu-despes.cod-nat-despesa 
     no-lock no-error.
if avail natureza-despesa then 
   assign c-desc-nat:screen-value in frame {&frame-name} = natureza-despesa.descricao.

find first utilizacao-mater where 
     utilizacao-mater.cod-utiliz = input frame {&frame-name} utiliz-natu-despes.cod-utiliz no-lock no-error.
if avail utilizacao-mater then 
   assign c-desc-utiliz:screen-value in frame {&frame-name} = utilizacao-mater.des-utiliz.

/* Buscando dados da conta cont bil */
if not valid-handle(h_api_cta_ctbl) then
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl. 
    
ASSIGN v_cod_cta_ctbl = input frame {&frame-name} utiliz-natu-despes.ct-codigo.
run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               input        "",                  /* PLANO DE CONTAS */
                                               input-output v_cod_cta_ctbl,      /* CONTA */
                                               input        today,               /* DATA TRANSACAO */   
                                               output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                               output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                               output       v_num_sit_cta_ctbl,  /* SITUACAO DA CONTA */
                                               output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                               output table tt_log_erro).        /* ERROS */
                                               
assign c-desc-conta:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.

/* Retorna formato da conta contabil */
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input  "",                  /* PLANO CONTAS */
                                                   input  today,               /* DATA DE TRANSACAO */
                                                   output c-formato-conta,     /* FORMATO CONTA */
                                                   output table tt_log_erro).  /* ERROS */    
  
IF c-formato-conta <> "" THEN
    ASSIGN utiliz-natu-despes.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-utiliz" "utiliz-natu-despes" "cod-utiliz"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "utiliz-natu-despes"}

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

