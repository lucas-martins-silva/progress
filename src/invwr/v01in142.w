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
{include/i-prgvrs.i V01IN142 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i V01IN142 MUT}
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
def buffer b-grup-estoque for grup-estoque.

{include/i-vrtab.i grup-estoque}

/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.
{utp/ut-glob.i}
{cdp/cd7300.i1}
{cdp/cdapi219.i}
{mcinc/mcapi248.i}
{cdp/cdcfgmat.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.

/************Fim*****************************/

{bhp/bh9999.i1}


{cdp/cd0666.i} /** Definiá∆o da Temp-Table de tt-erro **/
{cdp/cd9043.i} /** Definiá∆o da Temp-Table RowErrors **/

DEFINE VARIABLE l-integra     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-copy-record AS LOGICAL INITIAL NO    NO-UNDO.

DEF VAR h-axsar006 AS HANDLE                NO-UNDO.
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEF SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INT  INITIAL ?
     FIELD ttv_des_msg_ajuda AS char INITIAL ?
     FIELD ttv_des_msg_erro  AS char INITIAL ?
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
&Scoped-define EXTERNAL-TABLES grup-estoque
&Scoped-define FIRST-EXTERNAL-TABLE grup-estoque


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-estoque.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-estoque.descricao 
&Scoped-define ENABLED-TABLES grup-estoque
&Scoped-define FIRST-ENABLED-TABLE grup-estoque
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold tg-integra-his 
&Scoped-Define DISPLAYED-FIELDS grup-estoque.ge-codigo ~
grup-estoque.descricao 
&Scoped-define DISPLAYED-TABLES grup-estoque
&Scoped-define FIRST-DISPLAYED-TABLE grup-estoque
&Scoped-Define DISPLAYED-OBJECTS tg-integra-his 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS grup-estoque.ge-codigo 

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
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.13.

DEFINE VARIABLE tg-integra-his AS LOGICAL INITIAL no 
     LABEL "Integraá∆o HIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.86 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-estoque.ge-codigo AT ROW 1.17 COL 36.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .88
     grup-estoque.descricao AT ROW 2.5 COL 36.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     tg-integra-his AT ROW 3.5 COL 38.14
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-estoque
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
         HEIGHT             = 3.71
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

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

/* SETTINGS FOR FILL-IN grup-estoque.ge-codigo IN FRAME f-main
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

run get-attribute ('adm-new-record').

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
  {src/adm/template/row-list.i "grup-estoque"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-estoque"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
  
           IF CAN-FIND(FIRST funcao
                       WHERE funcao.cd-funcao = "spp-sgt"
                       AND   funcao.ativo = YES)  THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-inclusao AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "inclus∆o" *}
              ASSIGN c-lbl-liter-inclusao = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-grupo-de-estoque AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Grupo_de_Estoque" *}
              ASSIGN c-lbl-liter-grupo-de-estoque = TRIM(RETURN-VALUE).
              RUN utp/ut-msgs.p (input "show",
                                   input 33548,
                                   input c-lbl-liter-inclusao + "~~" + c-lbl-liter-grupo-de-estoque ).
              
              RUN new-state('cancela').
              RETURN 'adm-error'.
        
           END.
    &endif.

    tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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
  /* Ponha aqui a validaá∆o de chave duplicada */
  if grup-estoque.ge-codigo:sensitive in frame {&frame-name} = yes
  and can-find (b-grup-estoque where b-grup-estoque.ge-codigo = input grup-estoque.ge-codigo) then do:
    {utp/ut-field.i mgind item ge-codigo 1}
    run utp/ut-msgs.p (input "show",
                       input 1,
                       input return-value).
    return('adm-error').
  end.  


  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    ASSIGN l-integra = tg-integra-his:CHECKED.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

    IF CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN DO:

&IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          ASSIGN grup-estoque.log-orig-ext          = l-integra.
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             ASSIGN grup-estoque.log-1                       = l-integra.
         &ENDIF
      &ENDIF.
  END. 


    /****************************************************************/    
    /* Para execuá∆o de Adapter da Mensagem Unidade de Medida - EAI */
    /****************************************************************/
    /* Execucao caso usuario possua integracao EAI */
  
    IF CAN-FIND(FIRST funcao NO-LOCK
                 WHERE funcao.cd-funcao = "spp-portal-paradigma":U
                   AND funcao.ativo) THEN DO:
        IF v_log_eai_habilit THEN DO:
            IF adm-new-record THEN ASSIGN c-action = "add":U. 
                              ELSE ASSIGN c-action = "upd":U.
    
              RUN PIUpsert IN h-axsar006 (INPUT  "":U,
                        INPUT  c-action,
                        INPUT  grup-estoque.ge-codigo,
                        INPUT  grup-estoque.descricao,
                        OUTPUT TABLE tt_log_erro).
              
            IF CAN-FIND(FIRST tt_log_erro) THEN DO:
                FOR EACH tt_log_erro:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Erro" *}
                    run utp/ut-msgs.p (input "show":U,
                                       input 17006,
                                       input RETURN-VALUE + " " + STRING(tt_log_erro.ttv_num_cod_erro) + "~~" +
                                             tt_log_erro.ttv_des_msg_erro).
                    return('adm-error':U).
    
      
                END.
            END.
        END.
    END.
  /* Code placed here will execute AFTER standard behavior.    */

/********************Multiplanta***********************/
   assign c-transacao = "MAT057".
  {cdp/cd7300.i5 "001" c-transacao}

   assign i-tipo-movto = if grup-estoque.ge-codigo:sensitive in frame {&frame-name} then 1 else 2.
   if  param-global.modulo-mp and
       tt-replica-msg.log-replica-msg  = yes then do: 
       create tt-grup-estoque-aux.
       buffer-copy grup-estoque to tt-grup-estoque-aux.
       create tt-dados-env.                  
       assign tt-dados-env.num-sequencia  = i-seq 
              tt-dados-env.cod-tipo-reg   = 175
              tt-dados-env.ind-tipo-movto = i-tipo-movto.
             tt-dados-env.identif-msg     = string(grup-estoque.ge-codigo).
       raw-transfer tt-grup-estoque-aux to tt-dados-env.conteudo-msg.
       assign i-seq = i-seq + 1.
   end.

   {cdp/cd7300.i6 "001" c-transacao}

/******************Fim-Multiplanta********************/ 


/********************Multiplanta-SMC***********************/

   for each tt-smc-grup-estoque:
    delete tt-smc-grup-estoque.
   end.

   assign c-transacao = "SMC013".
   {cdp/cd7300.i5 "001" c-transacao "-SMC"}

   assign i-tipo-movto = if grup-estoque.ge-codigo:sensitive in frame {&frame-name} then 1 else 2.
   if  param-global.modulo-mp and
       tt-replica-msg-SMC.log-replica-msg  = yes then do: 
       create tt-smc-grup-estoque.
       buffer-copy grup-estoque to tt-smc-grup-estoque.
       create tt-dados-env-SMC.                  
       assign tt-dados-env-SMC.num-sequencia  = i-seq 
              tt-dados-env-SMC.cod-tipo-reg   = 284
              tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto.
              tt-dados-env-SMC.identif-msg     = string(grup-estoque.ge-codigo).
       raw-transfer tt-smc-grup-estoque to tt-dados-env-SMC.conteudo-msg.
       assign i-seq = i-seq + 1.
   end.

   {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/******************Fim-Multiplanta-SMC********************/ 

tg-integra-his:SENSITIVE IN FRAME f-main = NO.
tg-integra-his:CHECKED IN FRAME f-main = l-integra.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
    
           IF CAN-FIND(FIRST funcao
                       WHERE funcao.cd-funcao = "spp-sgt"
                       AND   funcao.ativo = YES)  THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-copia AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Copia" *}
              ASSIGN c-lbl-liter-copia = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-grupo-de-estoque-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Grupo_de_Estoque" *}
              ASSIGN c-lbl-liter-grupo-de-estoque-2 = TRIM(RETURN-VALUE).
              RUN utp/ut-msgs.p (input "show",
                                 input 33548,
                                 input c-lbl-liter-copia + "~~" + c-lbl-liter-grupo-de-estoque-2 ).
              RETURN 'adm-error'.
       END.
    &endif.
    
    ASSIGN l-copy-record = YES.

    DEF VAR l-integrado AS LOGICAL.
    ASSIGN l-integrado = tg-integra-his:CHECKED IN FRAME f-main.

        RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

               &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        IF CAN-FIND (FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-integra-ems-his"
                     AND   funcao.ativo     = YES) THEN
           ASSIGN tg-integra-his:SENSITIVE IN FRAME f-main = YES
                  tg-integra-his:CHECKED IN FRAME f-main   = l-integrado.
        &ENDIF 
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
  
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
         IF CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "spp-sgt"
                     AND   funcao.ativo = YES)  THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-eliminacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Eliminaá∆o" *}
            ASSIGN c-lbl-liter-eliminacao = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-grupo-de-estoque-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_de_Estoque" *}
            ASSIGN c-lbl-liter-grupo-de-estoque-3 = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (input "show",
                               input 33548,
                               input c-lbl-liter-eliminacao + "~~" + c-lbl-liter-grupo-de-estoque-3 ).
            RETURN 'adm-error'.
        END.
  &endif.
  
  find first param-estoq no-lock no-error.
  find first ge-troca where (ge-troca.ge-origem = grup-estoque.ge-codigo
    or ge-troca.ge-destino = grup-estoque.ge-codigo)
    and ge-troca.dt-troca > param-estoq.ult-fech-dia no-lock no-error.
    if avail ge-troca then do:
     {utp/ut-field.i mgind item ge-codigo 1}
      run utp/ut-msgs.p (input "show",
                         input 3,
                         input return-value).   
    end.
    else do:

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
        if  not available(param-global) then
            find first param-global no-lock no-error.

        if  param-global.modulo-bh = yes
        then do:
            {bhp/bh9999.i 4 Grup-Estoque grup-estoque.ge-codigo '' '' '' '' ''}
            if  return-value <> "OK"
            then return "ADM-ERROR".
        end.
/************************************************************************************************************/
        run pi-valida-eliminacao.
              if  return-value <> "OK":U then
                 return "ADM-ERROR".

        RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .


        /****************************************************************/    
        /* Para execuá∆o de Adapter da Mensagem Unidade de Medida - EAI */
        /****************************************************************/
        if NOT RETURN-VALUE = 'ADM-ERROR':U then DO:
            /* Execucao caso usuario possua integracao EAI */
            IF v_log_eai_habilit THEN DO:
                ASSIGN c-action = "del":U.
                RUN PIUpsert IN h-axsar006 (INPUT  "":U,
                                            INPUT  c-action,
                                            INPUT  grup-estoque.ge-codigo,
                                            INPUT  grup-estoque.descricao,
                                            OUTPUT TABLE tt_log_erro).

                IF CAN-FIND(FIRST tt_log_erro) THEN DO:
                    FOR EACH tt_log_erro:
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-liter.i "Erro" *}
                        run utp/ut-msgs.p (input "show":U,
                                           input 17006,
                                           input RETURN-VALUE + " " + STRING(tt_log_erro.ttv_num_cod_erro) + "~~" +
                                                 tt_log_erro.ttv_des_msg_erro).
                        return('adm-error':U).
                    END.
                END.
            END.
        END.
    end.

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

  IF (valid-handle(h-axsar006) 
      and h-axsar006:type = "PROCEDURE":U 
      and h-axsar006:file-name = "adapters/xml/ar2/axsar006.p":U ) then DO:
      delete procedure h-axsar006.
      assign h-axsar006 = ?.
  END.

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND (FIRST funcao 
                       WHERE funcao.cd-funcao = "spp-integra-ems-his"
                       AND   funcao.ativo     = YES) THEN DO:
                    
    
        IF AVAIL grup-estoque THEN DO:
             &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                    ASSIGN tg-integra-his:CHECKED IN FRAME {&FRAME-NAME} = grup-estoque.log-orig-ext.
            &ELSE
                   ASSIGN tg-integra-his:CHECKED IN FRAME {&FRAME-NAME} = grup-estoque.log-1.
            &ENDIF.
             tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         END.
       END.
   &ENDIF
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
  
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND (FIRST funcao 
                       WHERE funcao.cd-funcao = "spp-integra-ems-his"
                       AND   funcao.ativo     = YES) THEN DO:
                         IF NOT adm-new-record THEN DO:
                            IF NOT CAN-FIND(FIRST ITEM OF grup-estoque) THEN
                                tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
                         END. ELSE DO:
                             tg-integra-his:CHECKED IN FRAME {&FRAME-NAME} = NO.
                         END.
      END.
     &ENDIF

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
  
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-integra-ems-his"
                   AND funcao.ativo     = YES) THEN DO:

        tg-integra-his:VISIBLE   IN FRAME {&FRAME-NAME} = YES.
        tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        
        /* FRAME {&FRAME-NAME}:HEIGHT =  FRAME {&FRAME-NAME}:HEIGHT + 1. */

    END.
    ELSE DO:
        rt-mold:HEIGHT         IN FRAME {&FRAME-NAME} =  rt-mold:HEIGHT IN FRAME {&FRAME-NAME} - 1.
        tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = NO.
        tg-integra-his:ROW     IN FRAME {&FRAME-NAME} = 1.
        tg-integra-his:COLUMN  IN FRAME {&FRAME-NAME} = 1.
        tg-integra-his:WIDTH   IN FRAME {&FRAME-NAME} = 1.
        tg-integra-his:HEIGHT  IN FRAME {&FRAME-NAME} = 1.
    END.

    run adapters/xml/ar2/axsar006.p persistent set h-axsar006 (OUTPUT TABLE tt_log_erro).

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

  if avail grup-estoque then
    assign gr-grup-estoque = rowid(grup-estoque).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao V-table-Win 
PROCEDURE pi-valida-eliminacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{database/tgin/tdp/tdin142.i 'show'}

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
  {src/adm/template/snd-list.i "grup-estoque"}

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

