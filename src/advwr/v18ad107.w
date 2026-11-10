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
{include/i-prgvrs.i V18AD107 2.00.00.037 } /*** "010037" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v18ad107 MUT}
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

{bhp/bh9999.i1}
/* MINifLEXIBILIZA€¶O */ 
{cdp/cdcfgman.i}
{cdp/cdcfgfin.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}
/******Modulo RAC ****************/
{btb/btb008za.i0} 
/********************************/
{cdp~/cd0666.i} /** Defini‡Æo da Temp-Table de tt-erro **/
{cdp~/cd9043.i} /** Defini‡Æo da Temp-Table RowErrors **/
/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.      
def new global shared var gr-estabelec as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-estabel for estabelec.

def var c-cod-estabel like estabelec.cod-estabel no-undo.

DEF VAR hDBOproxy AS HANDLE NO-UNDO.

/* Integra‡Æo EAI */
&IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN

DEFINE NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 

DEF VAR h-axsvd011 AS HANDLE NO-UNDO.
DEF VAR c-action   AS CHAR   NO-UNDO.
DEF VAR hShowMsg   AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro  NO-UNDO
       FIELD ttv_num_cod_erro  AS INT  INIT ?
       FIELD ttv_des_msg_ajuda AS CHAR INIT ?
       FIELD ttv_des_msg_erro  AS CHAR INIT ?.
&ENDIF
    /* ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
       ** 6 => Erro de integra‡Æo no SISDOC                                  **
       ** 7 => Erro de integra‡Æo no EMS                                     ** */
/********* Fim vari veis para integra‡Æo ******/

/*************Multiplanta********************/
/* Não é mais utilizado o multiplanta no Datasul 11
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}
{cdp/cdapi216.i}
{mcinc/mcapi282.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.
*/
/************Fim*****************************/

def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo.
def var h_handle_container as handle                 no-undo.

DEFINE TEMP-TABLE RowErrorsEAI NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-estab-ctas-impto NO-UNDO LIKE estab-ctas-impto.
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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.nome 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-estabel estabelec.nome 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estabelec.cod-estabel 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-estabel|y|y|mgadm.estabelec.cod-estabel
cod-emitente||y|mgadm.estabelec.cod-emitente
ep-codigo||y|mgadm.estabelec.ep-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-estabel",
     Keys-Supplied = "cod-estabel,cod-emitente,ep-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.72 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-estabel AT ROW 1.33 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estabelec.nome AT ROW 2.33 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     rt-key AT ROW 1.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.54
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN estabelec.cod-estabel IN FRAME f-main
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cod-estabel':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = estabelec
           &WHERE = "WHERE estabelec.cod-estabel eq key-value"
       }
  END CASE.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

&Scoped-define SELF-NAME estabelec.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-estabel V-table-Win
ON LEAVE OF estabelec.cod-estabel IN FRAME f-main /* Item */
DO:

  def var c-handles as char no-undo.

  RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                         INPUT 'chave-target',
                                         OUTPUT c-handles).

  if c-handles <> '' then DO:
     run pi-seta-campo in widget-handle(entry(1,c-handles)).
     run pi-seta-campo in widget-handle(entry(2,c-handles)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) . 
   EMPTY TEMP-TABLE tt-estab-ctas-impto.

   FOR EACH  estab-ctas-impto NO-LOCK
       WHERE estab-ctas-impto.cod-estab =  estabelec.cod-estabel:
       CREATE tt-estab-ctas-impto.
       BUFFER-COPY estab-ctas-impto TO tt-estab-ctas-impto.
   END.
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
do trans:
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  assign c-cod-estabel = input frame {&frame-name} estabelec.cod-estabel.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
    return 'ADM-ERROR':U.

  assign estabelec.cod-estabel = c-cod-estabel.

  if adm-new-record then do:

     assign estabelec.grupo-aloca = estabelec.cod-estabel. 

     /* Inclui registro na tabela estab-mat */
     run pi-inclui-estab-mat (INPUT rowid(estabelec)).

     IF CAN-FIND (FIRST tt-estab-ctas-impto) THEN DO:
        RUN pi-copia-estab-ctas-impto (INPUT tt-estab-ctas-impto.cod-estab,
                                       INPUT estabelec.cod-estabel).
     END.
    
  end.     
  else do:
      for first estab-mat exclusive-lock
          where estab-mat.cod-estabel = c-cod-estabel.
      end.

      /* Replica informacoes para estab-mat */
      if avail   estab-mat then do:
          assign estab-mat.cod-emitente = estabelec.cod-emitente
                 estab-mat.deposito-cq  = estabelec.deposito-cq
                 estab-mat.dep-rej-cq   = estabelec.dep-rej-cq.
          find current estab-mat no-lock no-error.
      end.
  end.

  /*****[ Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC ]******/
/* Não é mais utilizado o multiplanta no Datasul 11
    for each tt-smc-estabelec:
        delete tt-smc-estabelec.
    end.
    assign  c-transacao = "SMC022".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign  i-tipo-movto = if estabelec.cod-estabel:sensitive in frame {&frame-name}
                           then 1 else 2.
    run pi-cria-tt-dados-smc (i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
*/    
  /***[Fim da Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC]***/

    /* Integra‡Æo EAI ->> Sender de Estabelecimento */
    &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
    IF v_log_eai_habilit THEN DO:

        IF NOT VALID-HANDLE(h-axsvd011) THEN
            RUN adapters/xml/vd2/axsvd011.p PERSISTENT SET h-axsvd011.

        ASSIGN c-action = IF adm-new-record THEN "add":U
                          ELSE "upd":U.

        IF AVAIL estabelec THEN
        RUN piTransUpsert IN h-axsvd011 (INPUT c-action,
                                         INPUT ROWID(estabelec),
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
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.

        IF VALID-HANDLE(h-axsvd011) THEN DO:
           DELETE PROCEDURE h-axsvd011.
           ASSIGN h-axsvd011 = ?.
        END.
        IF VALID-HANDLE(hShowMsg) THEN DO:
           {method/showmessage.i3}
        END.
    END.
    &ENDIF
    
    &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx041.p PERSISTENT SET hDBOproxy.
        RUN replicaEstabelecimento IN hDBOproxy(INPUT input frame {&frame-name} estabelec.cod-estabel,
                                                INPUT input frame {&frame-name} estabelec.nome,
                                                OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            RUN destroy IN hDBOproxy.
            undo, return "ADM-ERROR":U.
        END.
        RUN destroy IN hDBOproxy.
    END.
    &ENDIF
    
    RUN send-eai('CREATE').

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */ 
end.
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
    ASSIGN c-cod-estabel = estabelec.cod-estabel.

  /*****[ Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC ]******/
/* Não é mais utilizado o multiplanta no Datasul 11
    for each tt-smc-estabelec:
        delete tt-smc-estabelec.
    end.
    assign c-transacao    = "SMC022"
           i-tipo-movto   = 3.
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    run pi-cria-tt-dados-smc(i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
*/
  /***[Fim da Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC]***/  



/*********************************** ATENCAO USO DE PREPROCESSADOR ******************************/

&if '{&bf_dis_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR */

     /*******************************************************/
     /** Verifica relacionamento com tabela Grupo Embarque **/
     /*******************************************************/

     if can-find (first eq-grp-embarq where
                        eq-grp-embarq.cod-estabel = estabelec.cod-estabel) then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-relacao-com-grupo AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "rela‡Æo_com_Grupo_de_Embarque_(EQ0101)" *}
        ASSIGN c-lbl-liter-relacao-com-grupo = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-estabelecimento-po AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento_possui_rela‡Æo_com_Grupo_de_Embarque" *}
        ASSIGN c-lbl-liter-estabelecimento-po = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "show",
                           input 1170,
                           input c-lbl-liter-estabelecimento + "~~" + c-lbl-liter-relacao-com-grupo + "~~" + c-lbl-liter-estabelecimento-po + ",").
        return 'ADM-ERROR'.
     end.

  &endif   /* FIM PREPROCESSADOR */

&if '{&bf_dis_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR */

/*      /*******************************************************/                        */
/*      /** Verifica relacionamento com tabela Usuario Embarque **/                      */
/*      /*******************************************************/                        */
/*                                                                                       */
     if can-find (first eq-usuar-embarq-estab where
                        eq-usuar-embarq-estab.cod-estabel = estabelec.cod-estabel) then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-relacao-com-usuari AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "rela‡Æo_com_Usu rio_Embarque_(EQ0105)" *}
        ASSIGN c-lbl-liter-relacao-com-usuari = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-estabelecimento-po-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento_possui_rela‡Æo_com_Usu rio_Embarque" *}
        ASSIGN c-lbl-liter-estabelecimento-po-2 = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "show",
                           input 1170,
                           input c-lbl-liter-estabelecimento-2 + "~~" + c-lbl-liter-relacao-com-usuari + "~~" + c-lbl-liter-estabelecimento-po-2 + ",").
        return 'ADM-ERROR'.
     end.

  &endif   /* FIM PREPROCESSADOR */

  /**** Valida‡äes de elimina‡Æo ***********/
  run pi-valida-eliminacao.
  if  return-value <> "OK":U then
    return "ADM-ERROR".

  /* Integra‡Æo EAI ->> Sender de Estabelecimento */
  &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
      IF v_log_eai_habilit THEN DO:
        IF NOT VALID-HANDLE(h-axsvd011) THEN
            RUN adapters/xml/vd2/axsvd011.p PERSISTENT SET h-axsvd011.

        IF AVAIL estabelec THEN
          RUN piTransDelete IN h-axsvd011 (INPUT  ROWID(estabelec),
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
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}
           UNDO, RETURN "ADM-ERROR":U.
        END.

        IF VALID-HANDLE(h-axsvd011) THEN DO:
           DELETE PROCEDURE h-axsvd011.
           ASSIGN h-axsvd011 = ?.
        END.
        IF VALID-HANDLE(hShowMsg) THEN DO:
               {method/showmessage.i3}
        END.
      END.
  &ENDIF

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx041.p PERSISTENT SET hDBOproxy.
            RUN eliminaEstabelecimento IN hDBOproxy(INPUT c-cod-estabel,
                                                    OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> 'INTERNAL':U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="YES"}
                {method/showmessage.i3}
                RUN destroy IN hDBOproxy.
                UNDO, RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
    &ENDIF
    
  RUN send-eai('DELETE').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  for each historico-up where historico-up.cod-estabel = c-cod-estabel exclusive-lock:
      delete historico-up.
  end.

  FOR EACH estab-ctas-impto EXCLUSIVE-LOCK
      WHERE estab-ctas-impto.cod-estab =  c-cod-estabel:
      DELETE estab-ctas-impto.
  END.

end. /*Transaction*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
    IF VALID-HANDLE(h-axsvd011) THEN DO:
       DELETE PROCEDURE h-axsvd011.
       ASSIGN h-axsvd011 = ?.
    END.
    IF VALID-HANDLE(hShowMsg) THEN DO:
       {method/showmessage.i3}
    END.
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

  run pi-habilita-sped in h_handle_container (input YES).
  RUN pi-habilita-btconta in h_handle_container (input YES).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
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

  run pi-habilita-sped in h_handle_container (input NO).
  RUN pi-habilita-btconta in h_handle_container (input NO).

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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

  if  avail estabelec then
      assign gr-estabelec = rowid(estabelec).
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter i-tipo-movto as integer.

/* Não é mais utilizado o multiplanta no Datasul 11
    if  param-global.modulo-mp
    and tt-replica-msg-SMC.log-replica-msg  = yes
    then do:
        create  tt-smc-estabelec.
        buffer-copy estabelec to tt-smc-estabelec.
        create  tt-dados-env-SMC.
        assign  tt-dados-env-SMC.num-sequencia  = i-seq
                tt-dados-env-SMC.cod-tipo-reg   = 282
                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                tt-dados-env-SMC.identif-msg    = string(estabelec.cod-estabel).
        raw-transfer tt-smc-estabelec to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-estab-ctas-impto V-table-Win 
PROCEDURE pi-copia-estab-ctas-impto :
/*------------------------------------------------------------------------------
  Purpose: Incluir registro estab-mat, quando inclui novo estabelecimento.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pCodEstabelOld LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAM pCodEstabelNew LIKE estabelec.cod-estabel NO-UNDO.
 
    DEFINE BUFFER bfestab-ctas-impto FOR estab-ctas-impto.
     
    FOR EACH  tt-estab-ctas-impto NO-LOCK
        WHERE tt-estab-ctas-impto.cod-estab = pCodEstabelOld:
     
        IF NOT CAN-FIND (FIRST bfestab-ctas-impto 
                         WHERE bfestab-ctas-impto.cod-estab = pCodEstabelNew
                         AND   bfestab-ctas-impto.num-impto = tt-estab-ctas-impto.num-impto ) THEN DO:

                         CREATE bfestab-ctas-impto.
                         ASSIGN bfestab-ctas-impto.cod-estab = pCodEstabelNew.
                         BUFFER-COPY tt-estab-ctas-impto EXCEPT cod-estab TO bfestab-ctas-impto.
                         
        END.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui-estab-mat V-table-Win 
PROCEDURE pi-inclui-estab-mat :
/*------------------------------------------------------------------------------
  Purpose: Incluir registro estab-mat, quando inclui novo estabelecimento.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input param r-estabelec as rowid.

 {cdp/cdcfgmat.i}
 &if defined(bf_mat_tipo_ressup) &then 
     find estabelec where rowid(estabelec) = r-estabelec no-lock no-error.
     if not can-find (estab-mat where estab-mat.cod-estabel = 
                      estabelec.cod-estabel) then do:

        &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
            find first param-estoq no-lock no-error.
            if  avail param-estoq then
                run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                                    output da-iniper,   
                                    output da-fimper,
                                    output i-per-corrente,
                                    output i-ano-corrente,
                                    output da-iniper-fech,
                                    output da-fimper-fech).
        &endif

        create estab-mat.
        assign estab-mat.cod-estabel = estabelec.cod-estabel
               estab-mat.dias-max-a  = 0
               estab-mat.dias-max-b  = 0
               estab-mat.dias-max-c  = 0
               estab-mat.dias-min-a  = 0
               estab-mat.dias-min-b  = 0
               estab-mat.dias-min-c  = 0
               estab-mat.nr-ord-per  = 0
               estab-mat.perc-acum-a = 0
               estab-mat.perc-acum-b = 0
               estab-mat.perc-acum-c = 0
               estab-mat.deposito-cq = estabelec.deposito-cq
               estab-mat.ct-icm      = estabelec.ct-icm
               estab-mat.sc-icm      = estabelec.sc-icm
               estab-mat.ct-ipi      = estabelec.ct-ipi
               estab-mat.sc-ipi      = estabelec.sc-ipi
               estab-mat.cod-emitente = estabelec.cod-emitente
               estab-mat.ct-icms-comp = estabelec.ct-icms-comp
               estab-mat.sc-icms-comp = estabelec.sc-icms-comp
               estab-mat.ct-icms-ft   = estabelec.ct-icms-ft
               estab-mat.sc-icms-ft   = estabelec.sc-icms-ft
               estab-mat.ct-ipi-ft    = estabelec.ct-ipi-ft
               estab-mat.sc-ipi-ft    = estabelec.sc-ipi-ft
               estab-mat.dep-rej-cq   = estabelec.dep-rej-cq
               estab-mat.ct-ext-icms  = estabelec.ct-ext-icms
               estab-mat.sc-ext-icms  = estabelec.sc-ext-icms
               estab-mat.ct-ext-ipi   = estabelec.ct-ext-ipi
               estab-mat.sc-ext-ipi   = estabelec.sc-ext-ipi
               estab-mat.custo-contab       = estabelec.custo-contab
               estab-mat.usa-on-line        = estabelec.usa-on-line
               estab-mat.usa-padrao         = estabelec.usa-padrao
               estab-mat.cod-estabel-prin   = estabelec.cod-estabel  /*******/
               estab-mat.ct-pis-subs        = ""
               estab-mat.sc-pis-subs        = ""
               estab-mat.ct-finsoc-subs     = ""
               estab-mat.sc-finsoc-subs     = "".

        &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
            assign estab-mat.mensal-ate         = da-fimper-fech           when avail param-estoq
                   estab-mat.sumar-ate          = da-fimper-fech           when avail param-estoq
                   estab-mat.contab-ate         = da-fimper-fech           when avail param-estoq
                   estab-mat.ult-fech-dia       = da-fimper-fech           when avail param-estoq
                   estab-mat.ult-per-fech       = param-estoq.ult-per-fech when avail param-estoq.
        &endif
        
        &if "{&mguni_version}" >= "2.071" &then
            assign estab-mat.dat-inic-calc-med-diario = today.
        &endif

     end.   
     release estab-mat.
 &endif       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    def input parameter h_container as handle no-undo.
    
    assign h_handle_container = h_container.
            
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

    {database/tgad/tdp/tdad107.i 'show' }

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

 /* Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

  if  estabelec.cod-estabel:sensitive in frame {&frame-name} = yes then do:
      if input frame {&frame-name} estabelec.cod-estabel = " " then do:
         {utp/ut-field.i mgadm estabelec cod-estabel 1}
         run utp/ut-msgs.p (input "show", input 164, input return-value).
          apply 'entry' to estabelec.cod-estabel in frame {&frame-name}.
          return 'adm-error'.         
      end.

      find b-estabel
          where b-estabel.cod-estabel = input frame {&frame-name}
                estabelec.cod-estabel no-lock no-error.
      if  avail b-estabel then do:
          {utp/ut-table.i mgadm estabelec 1}
          run utp/ut-msgs.p (input "show", input 7, input return-value).
          apply 'entry' to estabelec.cod-estabel in frame {&frame-name}.
          return 'adm-error'.
      end.
  end.
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
  {src/adm/template/sndkycas.i "cod-estabel" "estabelec" "cod-estabel"}
  {src/adm/template/sndkycas.i "cod-emitente" "estabelec" "cod-emitente"}
  {src/adm/template/sndkycas.i "ep-codigo" "estabelec" "ep-codigo"}

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
  {src/adm/template/snd-list.i "estabelec"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-eai V-table-Win 
PROCEDURE send-eai :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-type AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.  
    RUN eai-integration IN h-ut-integration (INPUT "Branch",              /* Nome da transa»’o     */
											 INPUT ROWID(estabelec),      /* Registro da transa‡Æo */
											 INPUT p-type,                /* Evento da transa‡Æo   */
											 OUTPUT TABLE RowErrorsEAI).  /* Erros da transa‡Æo    */

    IF VALID-HANDLE(h-ut-integration) THEN DO:
        DELETE PROCEDURE h-ut-integration.
        ASSIGN h-ut-integration = ?.
    END.

    IF CAN-FIND(FIRST RowErrorsEAI) THEN DO:
		FOR EACH RowErrorsEAI:
			CREATE RowErrors.
			BUFFER-COPY rowerrorseai TO RowErrors.
		END. 
		
		{method/showmessage.i1}
		{method/showmessage.i2 &Modal="Yes"}

		RETURN "ADM-ERROR":U.
	END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
