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
{include/i-prgvrs.i V01AD107 2.00.00.026 } /*** "010026" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad107 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-estabelec as rowid no-undo.

def buffer b-estabelec for estabelec.

DEF VAR hDBOproxy AS HANDLE NO-UNDO.

/*--- Miniflexibilizaá∆o EMS 203 ---*/
{cdp/cdcfgfin.i} 


/******  BANCOS HIST‡RICOS ******/
/*-- Definiá∆o da tt-tabela ---*/
{bhp/bh9999.i1}

{cdp/cd1000.i}
/********************************/

{cdp/cdcfgdis.i} /* Definiá∆o dos PrÇ-processadores - Distribuiá∆o */
{include/i_prdvers.i}

/*** Vari†veis para integraá∆o EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?  no-undo.
def var c-handle            as char            no-undo.
def var c-opcao-int         as char            no-undo.
def var i-retorno-erro      as integer init ?  no-undo.
    /* ** 5 => Quando parÉmetro "nao-integra" e o registro j† est† integrado **
       ** 6 => Erro de integraá∆o no SISDOC                                  **
       ** 7 => Erro de integraá∆o no EMS                                     ** */
/********* Fim vari†veis para integraá∆o ******/

DEFINE VARIABLE h-cd0403-crm    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bodi00959     AS HANDLE  NO-UNDO.
DEFINE VARIABLE integr-ems-ou-gps-ativa  AS LOGICAL NO-UNDO INITIAL FALSE.

RUN utp/ut-crm12.p (OUTPUT integr-ems-ou-gps-ativa) .

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLTopic ESTABELEC
&GLOBAL-DEFINE XMLTableName ESTABELEC
&GLOBAL-DEFINE XMLTableNameMult ESTABELECS 
&GLOBAL-DEFINE XMLPublicFields 
&GLOBAL-DEFINE XMLKeyFields cod-estabel
&GLOBAL-DEFINE XMLSender DIS
&GLOBAL-DEFINE XMLExcludeFields

{method/xmlsmrt.i}


/* MINifLEXIBILIZAÄ∂O */ 
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

{utp/ut-glob.i}

/******Modulo RAC ****************/
{btb/btb008za.i0} 
/********************************/

{cdp~/cd0666.i} /** Definiá∆o da Temp-Table de tt-erro **/

def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo.
def var h_handle_container as handle                 no-undo.

DEF VAR l-integra-paradigma AS LOG    NO-UNDO INITIAL NO.
DEF VAR h-axsvd011          AS HANDLE NO-UNDO.
DEF VAR c-action            AS CHAR   NO-UNDO.

DEF TEMP-TABLE tt_log_erro  NO-UNDO
    FIELD ttv_num_cod_erro  AS INT  INIT ?
    FIELD ttv_des_msg_ajuda AS CHAR INIT ?
    FIELD ttv_des_msg_erro  AS CHAR INIT ?.

DEFINE TEMP-TABLE RowErrorsEAI NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS c-nome
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS RECT-4
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-estabel 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-nome 

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
DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(100)" 
     LABEL "Nome":R5 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 95 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-estabel AT ROW 1.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-nome AT ROW 2.25 COL 22 COLON-ALIGNED HELP
          "Nome Estabelecimento"
     RECT-4 AT ROW 1 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.33
         WIDTH              = 95.14.
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
  
    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "spp-portal-paradigma":U
           AND funcao.ativo NO-ERROR.

    IF AVAIL funcao THEN DO:
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF &if "{&bf_mat_versao_ems}" < "2.09" &then
               SUBSTRING(param-compra.char-2,103,1) = "S":U
           &ELSE
               param-compra.log-portal-paradigma
           &ENDIF
        THEN DO:
            ASSIGN l-integra-paradigma = YES.
        END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/i-valid.i}
  
  ASSIGN INPUT FRAME {&FRAME-NAME} c-nome.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  ASSIGN estabelec.nome = c-nome.
  
  /* Nao elimine essa linha - utilizada para erros retornados por UPCs **/
  if return-value = "adm-error":U then
    return "adm-error":U.
  if adm-new-record then do:  
     /* Inclui registro na tabela estab-mat */
     run pi-inclui-estab-mat (INPUT rowid(estabelec)).

     IF  i-pais-impto-usuario = 7 /* Chile */ THEN DO:
         IF  NOT VALID-HANDLE(h-bodi00959) THEN 
             RUN dibo/bodi00959.p PERSISTENT SET h-bodi00959.
         RUN pi-IncluirSerEstab IN h-bodi00959 (INPUT estabelec.ep-codigo,
                                                INPUT estabelec.cod-estabel).
         IF VALID-HANDLE(h-bodi00959) THEN DO:
            RUN destroy IN h-bodi00959.
            ASSIGN h-bodi00959 = ?.
         END.
     END.
  end.

    IF l-integra-paradigma THEN DO:

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

    IF integr-ems-ou-gps-ativa THEN DO:

        IF NOT VALID-HANDLE(h-cd0403-crm) THEN DO:
            RUN integracoes/adapters/emstocrm/cd0403-crm.p PERSISTENT SET h-cd0403-crm.
        END.
        RUN sendToCRM IN h-cd0403-crm (INPUT estabelec.cod-estabel, OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                     RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0403-crm.
    END.    

    ASSIGN c-nome:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.

    IF adm-new-record THEN
        RUN send-eai('CREATE').
    ELSE
        RUN send-eai('UPDATE').

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

         run cdp/cd2307.w (input rowid(estabelec),
                           input ?,
                           input c-opcao-int,
                           input "bergen",
                           output i-retorno-erro).
         if  i-retorno-erro = 6 or
             i-retorno-erro = 7 then
             undo, return "ADM-ERROR":U.

      end.  /* if i-integracao-sisdoc = 3 */     
      /***** Fim Integraá∆o EMS x SISDOC ****/

  /* Code placed here will execute AFTER standard behavior.    */
  &if '{&bf_dis_versao_ems}' < '2.07' &then
       {method/xmldef.i} 
    IF adm-new-record THEN DO:
       {method/xmlini.i ADD}
    END.
    ELSE DO:       
       {method/xmlini.i UPDATE}
    END.   
       {method/xmlprp.i}
       {method/xmlsnd.i}
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-indice AS CHAR NO-UNDO.

/************ BANCOS HIST‡RICOS ************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  l-funcao-banc-hist-adm then do:
        {bhp/bh9999.i 1 estabelec estabelec.cod-estabel '' '' '' '' ''}
        if  return-value <> "OK" then
            return error.
    end.

    /* Existe pedido de compra para este estabelecimento */
    if  can-find(first pedido-compr use-index end-entrega where
        pedido-compr.end-entrega = estabelec.cod-estabel)
    or  can-find(first pedido-compr use-index end-cobranca where
        pedido-compr.end-cobranca = estabelec.cod-estabel) then do:
        {utp/ut-liter.i pedidos_de_compra * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem bens neste estabelecimento */
    if  can-find(first bem where bem.cod-estabel =
        estabelec.cod-estabel) then do:
        {utp/ut-liter.i bens * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Estabelecimento possui titulos no CR */
    if  can-find(first titulo use-index estabel where
        titulo.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i t°tulos_no_CR * C}
        run utp/ut-msgs.p(input "show",
                          input 7623,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Estabelecimento possui pedidos de venda */
    if  can-find(first ped-venda use-index ch-estcli where
        ped-venda.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i pedidos_de_venda * C}
        run utp/ut-msgs.p(input "show",
                          input 7623,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem clientes para este estabelecimento */
    if  can-find (first estab-cli use-index ch-estcli where
        estab-cli.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i clientes * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existe regiao de venda para este estabelecimento */
    if  can-find (first regiao use-index ch-estabel where
        regiao.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i regi∆o_de_venda * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem parametros de pedidos para o estabelec */
    if  can-find (first para-ped use-index ch-estabel where
        para-ped.estab-padrao = estabelec.cod-estabel) then do:
        {utp/ut-liter.i parÉmetros_de_pedidos * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem NF's de Faturamento para este estabelecimento */
    if  can-find (first nota-fiscal of estabelec) then do:
        {utp/ut-liter.i nf's_de_faturamento * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem titulos do AP para este estabelecimento */
    if  can-find (first tit-ap use-index estab where
        tit-ap.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i t°tulos_do_AP * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem ParÉmetros Fam°lias x Estabel para este estabelecimento */
    if  can-find (first fam-uni-estab where
        fam-uni-estab.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i ParÉmetros_Fam°lias_x_Estabel * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem ParÉmetros Itens x Estabelec para este estabelecimento */
    if  can-find (first item-uni-estab where
        item-uni-estab.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i ParÉmetros_Itens_x_Estabelec * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Existem Linha de Produá∆o para este estabelecimento */
    if  can-find (first lin-prod where
        lin-prod.cod-estabel = estabelec.cod-estabel) then do:
        {utp/ut-liter.i Linha_de_Produá∆o * C}
        run utp/ut-msgs.p(input "show",
                          input 7622,
                          input trim(return-value)).
        return 'ADM-ERROR':U.
    end.

    /* Portador para este Estabelecimento */
    FOR EACH portador NO-LOCK
        WHERE portador.ep-codigo = estabelec.ep-codigo
        AND   portador.bancario  = no:
        IF  portador.char-2 = estabelec.cod-estabel THEN DO:
            {utp/ut-liter.i Portador * C}
            run utp/ut-msgs.p(input "show",
                              input 7622,
                              input trim(return-value)).
            return 'ADM-ERROR':U.
        END.
    END.

    /*********************************** ATENCAO USO DE PREPROCESSADOR ******************************/

  &if '{&bf_dis_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR */

    /*      /*******************************************************/                        */
    /*      /** Verifica relacionamento com tabela Usuario Embarque **/                      */
    /*      /*******************************************************/                        */
    /*                                                                                       */
     if can-find (first eq-usuar-embarq-estab where
                        eq-usuar-embarq-estab.cod-estabel = estabelec.cod-estabel) then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Estabelecimento" *}
    ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-relacao-com-usuari AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "relaá∆o_com_Usu†rio_Embarque_(EQ0105)" *}
    ASSIGN c-lbl-liter-relacao-com-usuari = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-estabelecimento-po AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Estabelecimento_possui_relaá∆o_com_Usu†rio_Embarque" *}
    ASSIGN c-lbl-liter-estabelecimento-po = TRIM(RETURN-VALUE).
    run utp/ut-msgs.p (input "show",
                           input 1170,
                           input c-lbl-liter-estabelecimento + "~~" + c-lbl-liter-relacao-com-usuari + "~~" + c-lbl-liter-estabelecimento-po + ",").
        return 'ADM-ERROR'.
     end.

  &endif   /* FIM PREPROCESSADOR */


  /**Existe calendario cadastrado para esse estabelecimento**/    
  find first calen-coml where
             calen-coml.ep-codigo = estabelec.ep-codigo and
             calen-coml.cod-estabel = estabelec.cod-estabel no-lock no-error.
  if avail calen-coml then do:
    run utp/ut-msgs.p (input "show",
                       input 8729,
                       input "").
    return 'ADM-ERROR':U. 
  end.      

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
      run cdp/cd2307.w (input rowid(estabelec),
                        input ?,
                        input c-opcao-int,
                        input "bergen",
                        output i-retorno-erro).
      if  i-retorno-erro = 5 or
          i-retorno-erro = 6 or
          i-retorno-erro = 7 then do:
          run notify ("pi-cancelar, tableio-source").
          return "ADM-ERROR":U.
      end.    

  end.  /* if i-integracao-sisdoc = 2 or ...*/     

  /***** Fim Integraá∆o EMS x SISDOC ****/

    /*{method/xmldef.i} 
    {method/xmlini.i DELETE}
    {method/xmlprp.i}
    {method/xmlsnd.i}*/

    /**** Validaá‰es de eliminaá∆o ***********/
   run pi-valida-eliminacao.
      if  return-value <> "OK":U then
          return "ADM-ERROR".

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx041.p PERSISTENT SET hDBOproxy.
            RUN eliminaEstabelecimento IN hDBOproxy(INPUT estabelec.cod-estabel,
                                                    OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> 'INTERNAL':U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="YES"}
                {method/showmessage.i3}
                RUN destroy IN hDBOproxy.
                UNDO, RETURN "ADM-ERROR":U.
            END.
            
            /* eliminando a tss-credenc para o estabelecimento deletado */
            FOR FIRST tss-credenc NO-LOCK 
                WHERE tss-credenc.idi-origem  = 1
                  AND tss-credenc.cod-empresa = "*" 
                  AND tss-credenc.cod-estabel = estabelec.cod-estabel:
            END.

            IF AVAIL tss-credenc THEN DO:
                FOR FIRST tss-credenc EXCLUSIVE-LOCK
                    WHERE tss-credenc.idi-origem  = 1
                      AND tss-credenc.cod-empresa = "*" 
                      AND tss-credenc.cod-estabel = estabelec.cod-estabel:
                END.
              
                IF AVAIL tss-credenc THEN
                    DELETE tss-credenc. 
            END.

            RUN destroy IN hDBOproxy.
        END.
    &ENDIF
    
    RUN send-eai('DELETE').

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .


    ASSIGN c-indice = estabelec.cod-estabel.

    FOR FIRST reg-inf-compl NO-LOCK
      WHERE reg-inf-compl.cod-tab-inform   = "CONTA-CONTAB-CD0403":U
        AND reg-inf-compl.cod-campo-inform = "CONTA-CONTAB-CD0403":U:
    END.

    IF AVAIL reg-inf-compl THEN DO:
      FOR FIRST inf-compl EXCLUSIVE-LOCK
          WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*18*/
            AND inf-compl.cod-indice  = c-indice:
      END.
      
      IF AVAIL inf-compl THEN
          DELETE inf-compl.
    END.

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
    {method/showmessage.i3}

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

  run pi-habilita-sped in h_handle_container (input YES).
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  DISABLE c-nome estabelec.cod-estabel WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

IF  AVAIL estabelec THEN DO:
    ASSIGN c-nome:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run get-attribute ('adm-new-record').

  /******* Integraá∆o EMS x SISDOC ******/

  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.

      if  i-integracao-sisdoc = 2 then do:
          assign c-opcao-int = "nao-integra".
          run cdp/cd2307.w (input rowid(estabelec),
                            input ?,
                            input c-opcao-int,
                            input "bergen",
                            output i-retorno-erro).
          if  i-retorno-erro = 5 or
              i-retorno-erro = 6 or
              i-retorno-erro = 7 then do:
              run notify ("pi-cancelar, tableio-source").
              return "ADM-ERROR":U.
          end.  /* if i-retorno-erro = 5 or ... */    
      end.  /* if i-integracao-sisdoc = 2 */     
  end.  /* if not adm-new-record */

  /***** Fim Integraá∆o EMS x SISDOC ****/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  run pi-habilita-sped in h_handle_container (input NO).
  
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  ENABLE c-nome WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if  avail estabelec then
      assign gr-estabelec = rowid(estabelec).

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
  &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx041.p PERSISTENT SET hDBOproxy.
        RUN replicaEstabelecimento IN hDBOproxy(INPUT input frame {&FRAME-NAME} estabelec.cod-estabel,
                                                INPUT input frame {&FRAME-NAME} c-nome,
                                                OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            RUN destroy IN hDBOproxy.
            undo, return "ADM-ERROR":U.
        END.
        RUN destroy IN hDBOproxy.
    END.
    &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    IF  adm-new-record = NO THEN
        RUN setOldBufferHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-estabel V-table-Win 
PROCEDURE pi-busca-estabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEF OUTPUT PARAM p-estab AS CHAR NO-UNDO.
  IF AVAIL estabelec THEN
    IF estabelec.cod-estabel <> "" THEN
        ASSIGN p-estab = INPUT FRAME f-main estabelec.cod-estabel.

  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui-estab-mat V-table-Win 
PROCEDURE pi-inclui-estab-mat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

         find first param-estoq no-lock no-error.
         if  avail param-estoq then
             run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                                 output da-iniper,   
                                 output da-fimper,
                                 output i-per-corrente,
                                 output i-ano-corrente,
                                 output da-iniper-fech,
                                 output da-fimper-fech).
        
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
               estab-mat.conta-extorno-icms = estabelec.conta-extorno-icms
               estab-mat.conta-extorno-ipi  = estabelec.conta-extorno-ipi
               estab-mat.conta-icms         = estabelec.conta-icms
               estab-mat.conta-icms-comp    = estabelec.conta-icms-comp
               estab-mat.conta-ipi          = estabelec.conta-ipi
               estab-mat.conta-ipi-fat      = estabelec.conta-ipi-fat
               estab-mat.custo-contab       = estabelec.custo-contab
               estab-mat.usa-on-line        = estabelec.usa-on-line
               estab-mat.usa-padrao         = estabelec.usa-padrao
               estab-mat.conta-icms-ft      = estabelec.conta-icms-ft
               estab-mat.cod-estabel-prin   = estabelec.cod-estabel  /*******/
               estab-mat.conta-pis-subs     = ""
               estab-mat.conta-finsoc-subs  = ""
               estab-mat.ct-pis-subs        = ""
               estab-mat.sc-pis-subs        = ""
               estab-mat.ct-finsoc-subs     = ""
               estab-mat.sc-finsoc-subs     = ""
               estab-mat.mensal-ate         = da-fimper-fech           when avail param-estoq
               estab-mat.sumar-ate          = da-fimper-fech           when avail param-estoq
               estab-mat.contab-ate         = da-fimper-fech           when avail param-estoq
               estab-mat.ult-fech-dia       = da-fimper-fech           when avail param-estoq
               estab-mat.ult-per-fech       = param-estoq.ult-per-fech when avail param-estoq
               &if "{&bf_mat_versao_ems}":U >= "2.07":U &then
               estab-mat.dat-inic-calc-med-diario = param-estoq.mensal-ate
               &ENDIF .
               
        &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx041.p PERSISTENT SET hDBOproxy.
            RUN replicaEstabelecimento IN hDBOproxy(INPUT estabelec.cod-estabel,
                                                    INPUT estabelec.nome,
                                                    OUTPUT TABLE RowErrors).
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="YES"}
                RUN destroy IN hDBOproxy.
                undo, return "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
        &ENDIF
     end. 
          
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

  {include/i-vldfrm.i}

  if  input frame {&FRAME-NAME} estabelec.cod-estabel = "" then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm estabelec 1}
      run utp/ut-msgs.p(input "show",
                        input 164,
                        input return-value).
      apply 'entry' to estabelec.cod-estabel in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  if  input frame {&frame-name} c-nome = "" then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p(input "show",
                        input 9013,
                        input "").
      apply 'entry' to c-nome in frame {&frame-name}.
      return 'ADM-ERROR':U.            
  end.

  if  estabelec.cod-estabel:sensitive in frame {&FRAME-NAME} = yes then do:  
      if  can-find(first b-estabelec 
               where b-estabelec.cod-estabel = input frame {&frame-name} estabelec.cod-estabel) then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm estabelec 1}
          run utp/ut-msgs.p(input "show",
                            input 1,
                            input return-value).
          apply 'entry' to estabelec.cod-estabel in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.              

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
    RUN eai-integration IN h-ut-integration (INPUT "Branch",              /* Nome da transaªío     */
                                                                                         INPUT ROWID(estabelec),      /* Registro da transaá∆o */
                                                                                         INPUT p-type,                /* Evento da transaá∆o   */
                                                                                         OUTPUT TABLE RowErrorsEAI).  /* Erros da transaá∆o    */

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

