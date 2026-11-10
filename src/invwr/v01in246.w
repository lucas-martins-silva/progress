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
{include/i-prgvrs.i V01IN246 2.00.00.014 } /*** "010014" 13/02/2025 15:16:05 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN246 MUT}
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

{include/i-vrtab.i natureza-despesa}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-natureza-despesa for natureza-despesa.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Námero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".

def var h_api_cta_ctbl       as handle no-undo.
def var c-formato-conta      as char no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari˜veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.

/* Vari veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 
def var v_log_utz_ccusto     as log    no-undo.

DEFINE VARIABLE h_api_cta_pat AS HANDLE     NO-UNDO.
DEFINE VARIABLE p_cod_cta_pat AS CHARACTER  FORMAT "x(18)"  NO-UNDO.
DEFINE VARIABLE v_des_cta_pat AS CHARACTER  FORMAT "x(32)"  NO-UNDO.

def var i-empresa like param-global.empresa-prin no-undo.

{cdp/cdcfgmat.i}

/* ************** Multiplanta ************** */
&if "{&bf_mat_versao_ems}" >= "2.062" &then
    def var i-tipo-movto as integer no-undo.
    {cdp/cd7300.i1}
    {cdp/cdapi263.i}
&endif
/* ************** Multiplanta ************** */

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
&Scoped-define EXTERNAL-TABLES natureza-despesa
&Scoped-define FIRST-EXTERNAL-TABLE natureza-despesa


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natureza-despesa.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natureza-despesa.descricao ~
natureza-despesa.ct-codigo natureza-despesa.atualiza-pt 
&Scoped-define ENABLED-TABLES natureza-despesa
&Scoped-define FIRST-ENABLED-TABLE natureza-despesa
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold
&Scoped-Define DISPLAYED-FIELDS natureza-despesa.nat-despesa ~
natureza-despesa.descricao natureza-despesa.ct-codigo ~
natureza-despesa.atualiza-pt 
&Scoped-define DISPLAYED-TABLES natureza-despesa
&Scoped-define FIRST-DISPLAYED-TABLE natureza-despesa
&Scoped-Define DISPLAYED-OBJECTS c-titulo ct-patrimonio ~
c-titulo-ct-patrimonio cc-patrimonio c-titulo-cc-patrimonio 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS natureza-despesa.nat-despesa 

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
DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-cc-patrimonio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ct-patrimonio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE cc-patrimonio AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE ct-patrimonio AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natureza-despesa.nat-despesa AT ROW 1.17 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     natureza-despesa.descricao AT ROW 2.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     natureza-despesa.ct-codigo AT ROW 3.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     c-titulo AT ROW 3.71 COL 42.14 COLON-ALIGNED NO-LABEL
     ct-patrimonio AT ROW 4.71 COL 21.29 COLON-ALIGNED
     c-titulo-ct-patrimonio AT ROW 4.71 COL 42.14 COLON-ALIGNED NO-LABEL
     cc-patrimonio AT ROW 5.71 COL 21.29 COLON-ALIGNED WIDGET-ID 4
     c-titulo-cc-patrimonio AT ROW 5.71 COL 42.14 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     natureza-despesa.atualiza-pt AT ROW 6.71 COL 23.43
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natureza-despesa
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
         HEIGHT             = 7
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

/* SETTINGS FOR FILL-IN c-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-cc-patrimonio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ct-patrimonio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN natureza-despesa.nat-despesa IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME natureza-despesa.atualiza-pt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natureza-despesa.atualiza-pt V-table-Win
ON VALUE-CHANGED OF natureza-despesa.atualiza-pt IN FRAME f-main /* Atualiza Patrim“nio */
DO:
    IF natureza.atualiza-pt:CHECKED IN FRAME {&frame-name}  = YES THEN DO:           
       ENABLE ct-patrimonio cc-patrimonio WITH FRAME {&frame-name}.
       
       ASSIGN ct-patrimonio:FORMAT = "x(18)".       
       
    END.   
    ELSE DO:
        DISABLE ct-patrimonio cc-patrimonio WITH FRAME {&frame-name}.
        ASSIGN ct-patrimonio:SCREEN-VALUE = ''
               cc-patrimonio:SCREEN-VALUE = ''.
    END.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cc-patrimonio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-patrimonio V-table-Win
ON ENTRY OF cc-patrimonio IN FRAME f-main /* CC Patrimonial */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-patrimonio V-table-Win
ON F5 OF cc-patrimonio IN FRAME f-main /* CC Patrimonial */
DO:         
    RUN pi_zoom_ccusto in h_api_ccusto (INPUT i-empresa,           /* EMPRESA EMS2 */
                                        INPUT "",                  /* CODIGO DO PLANO CCUSTO */
                                        INPUT "",                  /* UNIDADE DE NEGOCIO */
                                        INPUT TODAY,               /* DATA DE TRANSACAO */
                                        OUTPUT v_cod_ccusto,       /* CODIGO CCUSTO */
                                        OUTPUT v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                        OUTPUT TABLE tt_log_erro). /* ERROS */ 
    
       
    IF v_cod_ccusto <> "" THEN DO:
        ASSIGN cc-patrimonio:SCREEN-VALUE = v_cod_ccusto.
        ASSIGN c-titulo-cc-patrimonio:SCREEN-VALUE = v_titulo_ccusto.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-patrimonio V-table-Win
ON LEAVE OF cc-patrimonio IN FRAME f-main /* CC Patrimonial */
DO:
    ASSIGN v_cod_ccusto = INPUT cc-patrimonio.

    RUN pi_busca_dados_ccusto.

    ASSIGN c-titulo-cc-patrimonio:SCREEN-VALUE = v_titulo_ccusto.
    IF not can-find(tt_log_erro) THEN
        ASSIGN cc-patrimonio:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-patrimonio V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cc-patrimonio IN FRAME f-main /* CC Patrimonial */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natureza-despesa.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natureza-despesa.ct-codigo V-table-Win
ON ENTRY OF natureza-despesa.ct-codigo IN FRAME f-main /* Conta */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natureza-despesa.ct-codigo V-table-Win
ON F5 OF natureza-despesa.ct-codigo IN FRAME f-main /* Conta */
DO:
   assign l-implanta = yes.
                     
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MÎDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN natureza-despesa.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-titulo:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natureza-despesa.ct-codigo V-table-Win
ON LEAVE OF natureza-despesa.ct-codigo IN FRAME f-main /* Conta */
DO:
                   
    /*** Busca dados da conta cont bil *****************/
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT natureza-despesa.ct-codigo.
    RUN pi_busca_dados_cta_ctbl.
      
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.
    END.    
    assign c-titulo:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natureza-despesa.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natureza-despesa.ct-codigo IN FRAME f-main /* Conta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-patrimonio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-patrimonio V-table-Win
ON ENTRY OF ct-patrimonio IN FRAME f-main /* Conta Patrimonial */
DO:
  ASSIGN SELF:FORMAT = "x(18)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-patrimonio V-table-Win
ON F5 OF ct-patrimonio IN FRAME f-main /* Conta Patrimonial */
DO:             
    RUN pi_zoom_cta_pat IN h_api_cta_pat(OUTPUT p_cod_cta_pat,
                                         OUTPUT v_des_cta_pat,
                                         OUTPUT TABLE tt_log_erro).
                                         
    IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        ASSIGN ct-patrimonio:SCREEN-VALUE           = p_cod_cta_pat.
               c-titulo-ct-patrimonio:SCREEN-VALUE  = v_des_cta_pat.            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-patrimonio V-table-Win
ON LEAVE OF ct-patrimonio IN FRAME f-main /* Conta Patrimonial */
DO:
    /*** Busca dados da conta cont bil *****************/
    ASSIGN SELF:FORMAT = "x(18)".
    
    RUN pi_busca_dados_cta_pat.
    
    IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        ASSIGN c-titulo-ct-patrimonio:SCREEN-VALUE  = v_des_cta_pat.            
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-patrimonio V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-patrimonio IN FRAME f-main /* Conta Patrimonial */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if natureza-despesa.ct-codigo:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  IF ct-patrimonio:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  IF cc-patrimonio:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
  
  
  find first param-global no-lock no-error.

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
  {src/adm/template/row-list.i "natureza-despesa"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natureza-despesa"}

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
  DISABLE ct-patrimonio cc-patrimonio WITH FRAME {&frame-name}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN OVERLAY(natureza-despesa.char-1,1,18)  = ct-patrimonio:SCREEN-VALUE IN FRAME {&frame-name}
         OVERLAY(natureza-despesa.char-1,19,20) = cc-patrimonio:SCREEN-VALUE IN FRAME {&frame-name}.
   
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
    
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if return-value = 'ADM-ERROR':U then
        return  'ADM-ERROR':U.


    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    /* ************************************** Multiplanta ************************************** */
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        assign c-transacao = "MAT064".
        {cdp/cd7300.i5 "001" c-transacao}
        assign i-tipo-movto = if  natureza-despesa.nat-despesa:sensitive in frame {&frame-name} = yes 
                              then 1 
                              else 2.
    
        run pi-cria-tt-dados (input i-tipo-movto).

        {cdp/cd7300.i6 "001" c-transacao}
    &endif
    /* ************************************** Multiplanta ************************************** */ 
    ASSIGN OVERLAY(natureza-despesa.char-1,1,18)  = ct-patrimonio:SCREEN-VALUE IN FRAME {&frame-name}
           OVERLAY(natureza-despesa.char-1,19,20) = cc-patrimonio:SCREEN-VALUE IN FRAME {&frame-name}.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

     find first item where item.nat-despesa = natureza-despesa.nat-despesa 
          no-lock no-error.

     find first param-item-estab where param-item-estab.nat-despesa = natureza-despesa.nat-despesa 
          no-lock no-error.

     if (avail item) or 
        (avail param-item-estab) then do:
        {utp/ut-field.i mgind item nat-despesa 1}  
        {utp/ut-field.i mgind param-item-estab nat-despesa 1}  
         run utp/ut-msgs.p (input "show",
                            input 3,
                            input return-value).   
     end.
     
     /* NÆo executa na release 2.02 caso o item-mat-estab estiver relacionada a um natureza de opera‡Æo*/
        &if defined (bf_mat_consumo_estab) &then
             find first item-mat-estab where item-mat-estab.nat-despesa = natureza-despesa.nat-despesa 
             no-lock no-error.
             if (avail item-mat-estab) then do:
                {utp/ut-field.i mgind item-mat-estab nat-despesa 1}  
                 run utp/ut-msgs.p (input "show",
                                    input 3,
                                    input return-value).   
             end.
        &endif
        
     /* NÆo executa na release 2.04 caso o item-uni-estab estiver relacionada a um natureza de opera‡Æo*/
        &if "{&bf_mat_versao_ems}" >= "2.04" &then
             find first item-uni-estab where item-uni-estab.nat-despesa = natureza-despesa.nat-despesa 
             no-lock no-error.
             if (avail item-uni-estab) then do:
                {utp/ut-field.i mgind item-uni-estab nat-despesa 1}  
                 run utp/ut-msgs.p (input "show",
                                    input 3,
                                    input return-value).   
             end.
        &endif
     /*Não executa se tiver relacionamento com algum codigo de utilização cd0253*/
     else if can-find(first utiliz-natu-despes 
                where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa) then do:
        {utp/ut-field.i mgind item nat-despesa 1}  
        run utp/ut-msgs.p (input "show",
                           input 3,
                           input return-value).
        
     end.
     else RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).
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
  IF VALID-HANDLE(h_api_cta_ctbl) THEN 
    DELETE OBJECT h_api_cta_ctbl.
  
  IF VALID-HANDLE(h_api_ccusto) THEN 
    DELETE OBJECT h_api_ccusto.
    
  IF VALID-HANDLE(h_api_cta_pat) THEN
    DELETE OBJECT h_api_cta_pat.

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
  
  DISABLE ct-patrimonio cc-patrimonio WITH FRAME  {&frame-name}.

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

find first param-global no-lock no-error.

/*  */
/* Passando empresa em branco assim a API de financas busca a empresa do usuario corrente */
assign i-empresa = param-global.empresa-prin
       c-titulo-ct-patrimonio = ""
       c-titulo-cc-patrimonio = "".

/* Handle da API Conta Cont˜bil */
run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
run prgint\utb\utb742za.py persistent set h_api_ccusto.

IF NOT VALID-HANDLE(h_api_cta_pat) THEN 
    RUN prgfin/fas/fas914wd.py PERSISTENT SET h_api_cta_pat.

/* Retorna formato da conta contabil */
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CONTAS */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output c-formato-conta,    /* FORMATO CONTA */
                                                   output table tt_log_erro). /* ERROS */

IF c-formato-conta <> "" THEN
  ASSIGN natureza-despesa.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.
                                                   
/* Retorna formato do centro de custo */
run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* PLANO CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output c-formato-ccusto,   /* FORMATO CCUSTO */
                                               output table tt_log_erro). /* ERROS */                                                    

IF c-formato-ccusto <> "" THEN
  ASSIGN cc-patrimonio:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.
         
  /* Code placed here will execute PRIOR to standard behavior. */
if avail natureza-despesa then DO WITH FRAME {&FRAME-NAME}:

    /* Buscando dados da conta cont bil */
    ASSIGN v_cod_cta_ctbl = natureza-despesa.ct-codigo.
    
    RUN pi_busca_dados_cta_ctbl.                                                   
    
    /* Erros Conta Cont bil */
    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  AVAIL tt_log_erro THEN DO:
        assign c-titulo:SCREEN-VALUE = ''.
    END.
    ELSE DO:
        assign c-titulo:SCREEN-VALUE = v_titulo_cta_ctbl.
    END.                
    
    IF natureza-despesa.atualiza-pt:CHECKED THEN DO:
       /* Buscando dados da conta cont bil */
        ASSIGN ct-patrimonio:SCREEN-VALUE = SUBSTRING(natureza-despesa.char-1,1,18)  .
        
        RUN pi_busca_dados_cta_pat.                                                       

        /* Erros Conta Cont bil */
        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF AVAIL tt_log_erro THEN DO:
            ASSIGN c-titulo-ct-patrimonio:SCREEN-VALUE = ''.
        END.
        ELSE DO:
            ASSIGN c-titulo-ct-patrimonio:SCREEN-VALUE = v_des_cta_pat.
        END.
        
        /* Busca dados do centro de custo */
        ASSIGN v_cod_ccusto                 = SUBSTRING(natureza-despesa.char-1,19,20)
               cc-patrimonio:SCREEN-VALUE   = SUBSTRING(natureza-despesa.char-1,19,20).
                           
        RUN pi_busca_dados_ccusto.                                                      
           
        /* Setando titulos do centro de custo */  
        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF AVAIL tt_log_erro THEN DO:
            ASSIGN c-titulo-cc-patrimonio:SCREEN-VALUE = ''.
        END.
        ELSE DO:
            ASSIGN c-titulo-cc-patrimonio:SCREEN-VALUE = v_titulo_ccusto.
        END.
        /****************************************************/
        
    END.
end.  

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF natureza.atualiza-pt:CHECKED IN FRAME {&frame-name} = YES THEN DO:           
     ENABLE ct-patrimonio cc-patrimonio  WITH FRAME {&frame-name}.
     
     ENABLE cc-patrimonio WITH FRAME {&FRAME-NAME}.
  END.
     
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail natureza-despesa then 
    assign gr-natureza-despesa = rowid(natureza-despesa).
  

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

  /* Ponha aqui a valida‡Æo de chave duplicada */
  if natureza-despesa.nat-despesa:sensitive in frame {&frame-name} = yes
    and can-find (b-natureza-despesa where b-natureza-despesa.nat-despesa =
    input natureza-despesa.nat-despesa) then do:
      {utp/ut-field.i mgind natureza-despesa nat-despesa 1}
      run utp/ut-msgs.p (input 'show',
                         input 1,
                         input return-value).
      return 'adm-error'.
  end. 
  
  assign natureza-despesa.ct-codigo:format in frame {&frame-name} = "x(20)".
  assign v_cod_cta_ctbl = natureza-despesa.ct-codigo:screen-value.
  
  RUN pi_busca_dados_cta_ctbl.                                                 
  /* Erros Conta Cont˜bil */
  FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erro THEN DO:
      run utp/ut-msgs.p (input 'show',
                         input 17006,
                         STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                         
      assign natureza-despesa.ct-codigo:format in frame {&frame-name} = c-formato-conta.
      return 'adm-error'.      
  END.
  
  assign ct-patrimonio:format in frame {&frame-name} = "x(18)".
  IF  natureza-despesa.atualiza-pt:CHECKED = YES 
  AND ct-patrimonio:SCREEN-VALUE IN FRAME {&frame-name} <> '' THEN DO:
      /* Busca dados da conta contÿbil */
      assign ct-patrimonio:format in frame {&frame-name} = "x(18)".
            
      RUN pi_busca_dados_cta_pat.                                                     
     
      FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
      IF AVAIL tt_log_erro THEN DO:
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 17006,
                            STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
         
         APPLY "entry" TO ct-patrimonio IN FRAME {&frame-name}.
         RETURN 'ADM-ERROR':U.       
      END.
      ELSE DO:
          IF v_des_cta_pat = '' THEN DO:
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 37150,
                                 INPUT "").        
         
              APPLY "entry" TO ct-patrimonio IN FRAME {&frame-name}.
              RETURN 'ADM-ERROR':U.
          END.
      END.
      
       /* Busca dados do centro de custo */
      ASSIGN cc-patrimonio:FORMAT IN FRAME {&frame-name} = "x(20)".
      ASSIGN v_cod_ccusto = cc-patrimonio:SCREEN-VALUE.
      
      RUN pi_busca_dados_ccusto.                                                      
               
      /* Setando titulos do centro de custo */  
      FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
      IF AVAIL tt_log_erro THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT 17006,
                             STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
               
          APPLY "entry" to cc-patrimonio IN FRAME {&frame-name}.
          RETURN 'ADM-ERROR':U.
      END.
  END.
    
  /* Ponha aqui as demais valida‡äes */  
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign natureza-despesa.ct-codigo:format in frame {&frame-name} = c-formato-conta         
         cc-patrimonio:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ************************************** Multiplanta ************************************** */
    def input parameter i-tipo-movto as integer no-undo.

    &if "{&bf_mat_versao_ems}" >= "2.062" &then    
        if  param-global.modulo-mp and
            tt-replica-msg.log-replica-msg  = yes then do: 
            create tt-natureza-despesa-aux.
            buffer-copy natureza-despesa to tt-natureza-despesa-aux.
            create tt-dados-env.                  
            assign tt-dados-env.num-sequencia  = i-seq 
                   tt-dados-env.cod-tipo-reg   = 316
                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                   tt-dados-env.identif-msg    = string(natureza-despesa.nat-despesa).
            raw-transfer tt-natureza-despesa-aux to tt-dados-env.conteudo-msg.                                     
            assign i-seq = i-seq + 1.                                     
        end.
    &endif
END PROCEDURE.
/* ************************************** Multiplanta ************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_busca_dados_cta_ctbl V-table-Win 
PROCEDURE pi_busca_dados_cta_ctbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */   
                                                   OUTPUT       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_busca_dados_cta_pat V-table-Win 
PROCEDURE pi_busca_dados_cta_pat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      
    RUN pi_busca_dados_cta_pat IN h_api_cta_pat(INPUT i-empresa,                                            /* EMPRESA EMS2 */
                                                INPUT ct-patrimonio:SCREEN-VALUE IN FRAME {&frame-name},    /* CONTA PATRIMONIAL */
                                                OUTPUT v_des_cta_pat,                                       /* DESCRICAO CONTA PATRIMONIAL*/
                                                OUTPUT TABLE tt_log_erro).                                  /* ERROS */    
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_busca_dados_ccusto V-table-Win 
PROCEDURE pi_busca_dados_ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      
     RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS2 */
                                                INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                                INPUT  v_cod_ccusto,       /* CCUSTO */
                                                INPUT  TODAY,              /* DATA DE TRANSACAO */
                                                OUTPUT v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                OUTPUT TABLE tt_log_erro). /* ERROS */
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME        

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_verifica_utilizacao_ccusto V-table-Win 
PROCEDURE pi_verifica_utilizacao_ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      
    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  i-empresa,         /* EMPRESA EMS 2 */
                                                       INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                 /* PLANO CONTAS */
                                                       INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                       INPUT  TODAY,              /* DT TRANSACAO */
                                                       OUTPUT v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       OUTPUT TABLE tt_log_erro). /* ERROS */
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
  {src/adm/template/snd-list.i "natureza-despesa"}

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

