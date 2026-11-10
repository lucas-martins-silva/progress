&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V02IN046 2.00.00.020}  /*** "010020" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN046 MUT}
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

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-classif-fisc as rowid no-undo.
def buffer b-classif-fisc for classif-fisc.

def var i-tipo-movto as integer no-undo.

{include/i_dbvers.i}
{cdp/cd7300.i1}
{cdp/cd9860.i} /* Bancos Historicos */
{cdp/cdapi203.i}

/*** Vari†veis para integraá∆o EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?   no-undo.
def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var l-origem-int        as logical init yes no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
    /* ** 5 => Quando parÉmetro "nao-integra" e o registro j† est† integrado **
       ** 6 => Erro de integraá∆o no SISDOC                                  **
       ** 7 => Erro de integraá∆o no EMS                                     ** */
/********* Fim vari†veis para integraá∆o ******/


{bhp/bh9999.i1}

def var c-container  as char          no-undo.
def var wh-container as widget-handle no-undo.

def var h_v10in046   as handle       no-undo.
def var h_v11in046   as handle       no-undo.
def var h_b01in01092 as handle       no-undo.


/* Integraá∆o EAI */
&IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN

DEFINE NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 

{cdp/cd9043.i}
DEF VAR h-axsof001 AS HANDLE NO-UNDO.
DEF VAR c-action   AS CHAR   NO-UNDO.
DEF VAR hShowMsg   AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro  NO-UNDO
       FIELD ttv_num_cod_erro  AS INT  INIT ?
       FIELD ttv_des_msg_ajuda AS CHAR INIT ?
       FIELD ttv_des_msg_erro  AS CHAR INIT ?.
&ENDIF

DEFINE VARIABLE h-cd0603-crm  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).

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
&Scoped-define EXTERNAL-TABLES classif-fisc
&Scoped-define FIRST-EXTERNAL-TABLE classif-fisc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-fisc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-fisc.descricao 
&Scoped-define ENABLED-TABLES classif-fisc
&Scoped-define FIRST-ENABLED-TABLE classif-fisc
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS classif-fisc.class-fiscal ~
classif-fisc.descricao 
&Scoped-define DISPLAYED-TABLES classif-fisc
&Scoped-define FIRST-DISPLAYED-TABLE classif-fisc


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS classif-fisc.class-fiscal 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 94.72 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     classif-fisc.class-fiscal AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     classif-fisc.descricao AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     rt-key AT ROW 1 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-fisc
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
         HEIGHT             = 2.29
         WIDTH              = 95.
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN classif-fisc.class-fiscal IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "classif-fisc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-fisc"}

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

    IF adm-new-record AND h_b01in01092 <> ? THEN 
        RUN pi-clear-browse IN h_b01in01092.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  do transaction:
     /* Code placed here will execute PRIOR to standard behavior. */
     {include/i-valid.i}

     /* Dispatch standard ADM method.                             */
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
     if RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

     /* Code placed here will execute AFTER standard behavior.    */

     assign c-transacao = "MAN002".
     {cdp/cd7300.i5 "001" c-transacao}

     assign i-tipo-movto = if  classif-fisc.class-fiscal:sensitive in frame {&frame-name} = yes 
                               then 1 
                               else 2.

     run pi-cria-tt-dados (input i-tipo-movto).

     {cdp/cd7300.i6 "001" c-transacao}
     find first tt-dados-env exclusive-lock no-error.
     if avail tt-dados-env then delete tt-dados-env.

      /******* Integraá∆o EMS x SISDOC ******/
      if i-integracao-sisdoc = ? then do:
         RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                     OUTPUT c-handle).
         run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.

      if i-integracao-sisdoc = 3 then do:
         if adm-new-record then
            assign c-opcao-int = "inclui".
         else 
            assign c-opcao-int = "modifica".

         run cdp/cd2302.w (input rowid(classif-fisc),
                           input c-opcao-int,
                           input "classif-fisc",
                           output i-retorno-erro,
                           output l-origem-int).
         if  i-retorno-erro = 6 or
             i-retorno-erro = 7 then
             undo, return "ADM-ERROR":U.

      end.  /* if i-integracao-sisdoc = 3 */     
      /***** Fim Integraá∆o EMS x SISDOC ****/

      /* Integraá∆o EAI ->> Sender de Classificaá∆o Fiscal */
      &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
          IF v_log_eai_habilit THEN DO:
            IF NOT VALID-HANDLE(h-axsof001) THEN
                RUN adapters/xml/of2/axsof001.p PERSISTENT SET h-axsof001.

            ASSIGN c-action = IF adm-new-record THEN "add":U
                              ELSE "upd":U.

            IF AVAIL classif-fisc THEN
              RUN piTransUpsert IN h-axsof001 (INPUT c-action,
                                               INPUT ROWID(classif-fisc),
                                               OUTPUT TABLE tt_log_erro).
            EMPTY TEMP-TABLE RowErrors.
            FOR EACH tt_log_erro:

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = ""
                       RowErrors.ErrorSubType     = "ERROR":U.
            END.
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
               {method/ShowMessage.i1}
               {method/ShowMessage.i2 &Modal="YES"}
               UNDO, RETURN "ADM-ERROR":U.
            END.

            IF VALID-HANDLE(h-axsof001) THEN DO:
               DELETE PROCEDURE h-axsof001.
               ASSIGN h-axsof001 = ?.
            END.
            IF VALID-HANDLE(hShowMsg) THEN DO:
               {method/ShowMessage.i3}
            END.
          END.
      &ENDIF
      
      /* INTEGRAÄ«O CRM11 */
     IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0603-crm) THEN
        RUN integracoes/adapters/emstocrm/cd0603-crm.p PERSISTENT SET h-cd0603-crm. 
        RUN sendToCRM IN h-cd0603-crm (INPUT classif-fisc.class-fiscal,
                                   OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0603-crm.
     END.


  end.  /* do transaction */
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

DO TRANS:

   &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
    DEF VAR c-class-fiscal LIKE classif-fisc.class-fiscal NO-UNDO.
    DEF VAR c-descricao    LIKE classif-fisc.descricao    NO-UNDO.

    IF AVAIL classif-fisc THEN
       ASSIGN c-class-fiscal = classif-fisc.class-fiscal
              c-descricao    = classif-fisc.descricao.
   &ENDIF

  /******* Integraá∆o EMS x SISDOC ******/

  if  i-integracao-sisdoc = ? then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                  OUTPUT c-handle).
      run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.

  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra".
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina".

  if  i-integracao-sisdoc = 2 or
      i-integracao-sisdoc = 3 then do:      
      run cdp/cd2302.w (input rowid(classif-fisc),
                        input c-opcao-int,
                        input "classif-fisc",
                        output i-retorno-erro,
                        output l-origem-int).
      if  i-retorno-erro = 5 or
          i-retorno-erro = 6 or
          i-retorno-erro = 7 then do:
          run notify ("pi-cancelar, tableio-source").
          return "ADM-ERROR":U.
      end.    

  end.  /* if i-integracao-sisdoc = 2 or ...*/     

  /***** Fim Integraá∆o EMS x SISDOC ****/ 

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Classif-Fisc classif-fisc.class-fiscal '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
      FOR EACH classif-destaq OF classif-fisc NO-LOCK:
          FOR FIRST ITEM fields(it-codigo class-fiscal cod-destaq) USE-INDEX class-fiscal
              WHERE ITEM.class-fiscal = classif-fisc.class-fiscal
              AND   ITEM.cod-destaq   = classif-destaq.cod-destaq NO-LOCK:
              run utp/ut-msgs.p (input "show":U, input 28568, input ITEM.it-codigo).
              return "ADM-ERROR":U.
          END.
      END.
      FOR EACH classif-destaq OF classif-fisc EXCLUSIVE-LOCK:
          DELETE classif-destaq.
      END.
  &ENDIF 

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Integraá∆o EAI ->> Sender de Classificaá∆o Fiscal */
  &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
      IF v_log_eai_habilit THEN DO:
        IF NOT VALID-HANDLE(h-axsof001) THEN
            RUN adapters/xml/of2/axsof001.p PERSISTENT SET h-axsof001.

        IF AVAIL classif-fisc THEN
          RUN piTransDelete IN h-axsof001 (INPUT c-class-fiscal,
                                           INPUT c-descricao,
                                           OUTPUT TABLE tt_log_erro).
        EMPTY TEMP-TABLE RowErrors.
        FOR EACH tt_log_erro:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                   RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.ErrorSubType     = "ERROR":U.
        END.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           {method/ShowMessage.i1}
           {method/ShowMessage.i2 &Modal="YES"}
           UNDO, RETURN "ADM-ERROR":U.
        END.

        IF VALID-HANDLE(h-axsof001) THEN DO:
           DELETE PROCEDURE h-axsof001.
           ASSIGN h-axsof001 = ?.
        END.
        IF VALID-HANDLE(hShowMsg) THEN DO:
               {method/ShowMessage.i3}
        END.
      END.
  &ENDIF
  
     /* INTEGRAÄ«O CRM11 */
     IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0603-crm) THEN
        RUN integracoes/adapters/emstocrm/cd0603-crm.p PERSISTENT SET h-cd0603-crm. 
        RUN sendToCRM IN h-cd0603-crm (INPUT classif-fisc.class-fiscal,
                                   OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0603-crm.
     END.



END. /* transaction */

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

  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
      IF VALID-HANDLE(wh-container) THEN
          run DisableFolder in wh-container(NO).
  &endif.

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

  /******* Integraá∆o EMS x SISDOC ******/
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.

      if  i-integracao-sisdoc = 2 then do:
          assign c-opcao-int = "nao-integra".
          run cdp/cd2302.w (input rowid(classif-fisc),
                            input c-opcao-int,
                            input "classif-fisc",
                            output i-retorno-erro,
                            output l-origem-int).
          if  i-retorno-erro = 5 or
              i-retorno-erro = 6 or
              i-retorno-erro = 7 then do:
              run notify ("pi-cancelar, tableio-source").
              return "ADM-ERROR":U.
          end.  /* if i-retorno-erro = 5 or ... */    
      end.  /* if i-integracao-sisdoc = 2 */     
  end.  /* if not adm-new-record */
  /***** Fim Integraá∆o EMS x SISDOC ****/

  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
      IF  VALID-HANDLE(wh-container) THEN
          run DisableFolder in wh-container(YES).
  &endif.

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

  RUN who-is-the-container in adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-container).
  assign wh-container = widget-handle(c-container).

  /* Code placed here will execute AFTER standard behavior.    */

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
  if avail classif-fisc then
     assign gr-classif-fisc = rowid(classif-fisc).

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

  /* Ponha aqui a validaá∆o de chave duplicada */

  if  classif-fisc.class-fiscal:sensitive in frame {&frame-name} = yes
      and can-find (b-classif-fisc where b-classif-fisc.class-fiscal = 
      input frame {&frame-name} classif-fisc.class-fiscal) then do:
     {utp/ut-table.i mgind classif-fisc 1}
      run utp/ut-msgs.p (input "show",
                         input 1,
                         input return-value).
      return "adm-error".
  end.

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do:
    create tt-classif-fisc-aux.
    buffer-copy classif-fisc to tt-classif-fisc-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 9
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = classif-fisc.class-fiscal.
    raw-transfer tt-classif-fisc-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                       
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-handle-imp V-table-Win 
PROCEDURE pi-pega-handle-atributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-handle1 AS HANDLE NO-UNDO.

    ASSIGN h_b01in01092 = p-handle1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-handle-desc V-table-Win 
PROCEDURE pi-pega-handle-desc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle2 as handle no-undo.

assign h_v11in046 = p-handle2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-handle-imp V-table-Win 
PROCEDURE pi-pega-handle-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle1 as handle no-undo.

assign h_v10in046 = p-handle1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/


  /* Ponha aqui a validaá∆o de chave duplicada */
  if classif-fisc.class-fiscal:sensitive in frame {&frame-name} then do:
     find classif-fisc where classif-fisc.class-fiscal = input frame {&frame-name} classif-fisc.class-fiscal no-lock no-error.
     if avail classif-fisc then do:     
        apply 'entry' to classif-fisc.class-fiscal.
        {utp/ut-table.i mgind classif-fisc 1}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        return 'adm-error'.     
     end.
   end.


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
  {src/adm/template/snd-list.i "classif-fisc"}

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

