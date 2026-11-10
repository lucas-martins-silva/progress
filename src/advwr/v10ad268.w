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
/*ROUTINE-LEVEL ON ERROR UNDO, THROW.*/

{include/i-prgvrs.i V10AD268 2.00.00.081 } /*** "010081" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v10ad268 MUT}
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

def new global shared var gr-transporte as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable v-row-parent      as rowid                     no-undo.
define variable l-exporta         as logical                   no-undo.
define variable v-nome-abrev      like transporte.nome-abrev   no-undo.
define variable c-nome-transp     AS CHARACTER FORMAT "x(80)"  no-undo.
define variable c-cgc-transp      like transporte.cgc          no-undo.
define variable c-cgc             like transporte.cgc          no-undo.
define variable c-ins-estadual    like transporte.ins-estadual no-undo.

DEFINE VARIABLE h-bofi230 AS HANDLE     NO-UNDO.

define buffer b-transp    for transporte.
define buffer b-estab     for estab-cli.
define buffer b-nota      for nota-fiscal.
define buffer b-ped       for ped-venda.
define buffer b-emitente  for emitente.
define buffer b-imag-for  for imag-for.
define buffer b-ender-red for ender-red.
define buffer b-embarque  for embarque.
define buffer b-pre-fatur for pre-fatur.

define buffer b-remito        for remito.
define buffer b-doc-fiscal    for doc-fiscal.
define buffer b-loc-entr      for loc-entr.
define buffer b-simul-emb     for simul-emb.

DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 

{cdp/cd7300.i1}
{cdp/cdapi253.i}

{bhp/bh9999.i1}

{adbo/boad098.i tt-emitente}
{btb/btb009za.i} /* Definiá∆o tt_erros_conexao */

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{cdp/cdcfgdis.i}
/** WBD: BEGIN_NULL_CODE **/
{include/i-freeac.i}
/** WBD: END_NULL_CODE **/
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.

{cdp/cd0402i1.i} /* Definiá∆o da temp-table tt-transporte-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
{include/i_prdvers.i}

/* Definiá∆o das temp-tables evolu°das */
{cdp/cdapi366b.i}

/* {method/dbotterr.i} */  /** temp-table RowErrors **/
def var h-bosc025 as handle no-undo.
DEF VAR h-api     as handle no-undo.
DEFINE VAR h-axsvd007 AS HANDLE NO-UNDO.
DEFINE VARIABLE c-action AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?
.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT              
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE RowErrorsEAI NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE VARIABLE h-cd0402-crm AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

DEFINE VARIABLE h-v01ad00500 AS HANDLE NO-UNDO.

/*Portado AP*/
DEFINE VARIABLE l-funcao-portador-ap AS LOGICAL NO-UNDO.
{include/getdefinedfunction.i}
ASSIGN l-funcao-portador-ap = &IF DEFINED(BF_FIN_PORTADOR_AP) &THEN YES &ELSE GetDefinedFunction("SPP-PORTADOR-AP") &ENDIF.

def temp-table tt_control_id_clien_fornec no-undo
    field tta_cdn_clien_fornec             as Integer format ">>>,>>>,>>9" initial 0 label "Cliente/Fornecedor" column-label "Cliente/Fornecedor"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad                 as character format "x(20)" label "Id Estadual" column-label "Id Estadual"
    field tta_cod_aplicat_orig             as character format "x(8)" label "Aplicativo Origem" column-label "Aplic Orig"
    index tt_idx_id                        is primary unique
          tta_cdn_clien_fornec             ascending
    .

def temp-table tt_erro_msg no-undo
    field ttv_num_msg_erro                 as integer format ">>>>>>9" label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_help_erro                as character format "x(200)"
    index tt_num_erro                     
          ttv_num_msg_erro                 ascending
    .

/*Verifica se vai ser c¢digo £nico para Cliente, Fornecedor e Transportador*/
DEFINE VARIABLE l-cod-unico  AS LOGICAL     NO-UNDO.

RUN hbbo/boParamFuncaoProdut.p PERSISTENT SET h-api.
RUN pi_existe_funcao IN h-api (INPUT "Codigo Unico Cliente Fornecedor Transportador",
                               OUTPUT l-cod-unico).
DELETE PROCEDURE h-api.

/****************************************************************/
&GLOBAL-DEFINE XMLProducer       no
&GLOBAL-DEFINE XMLTopic          TRANSPORTE
&GLOBAL-DEFINE XMLTableName      TRANSPORTE
&GLOBAL-DEFINE XMLTableNameMult  TRANSPORTES 
&GLOBAL-DEFINE XMLPublicFields 
&GLOBAL-DEFINE XMLKeyFields      COD-TRANSP,NOME-ABREV
&GLOBAL-DEFINE XMLSender         DIS
&GLOBAL-DEFINE XMLExcludeFields

{method/xmlsmrt.i}

DEFINE VARIABLE i-cod-transp AS INTEGER     NO-UNDO.
/*VARIµVEIS LOCALIZAÄ«O EQUADOR*/
DEFINE VARIABLE h-boec012 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-handle-container AS HANDLE      NO-UNDO.
/*FIM - VARIµVEIS LOCALIZAÄ«O EQUADOR*/

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
&Scoped-define EXTERNAL-TABLES transporte
&Scoped-define FIRST-EXTERNAL-TABLE transporte


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR transporte.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-cod-transp c-nome c-nome-abrev 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-cod-transp 
&Scoped-define ADM-ASSIGN-FIELDS c-nome c-nome-abrev 
&Scoped-define ADM-MODIFY-FIELDS c-nome c-nome-abrev 

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
DEFINE VARIABLE c-cod-transp AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Transportador":R16 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome Abreviado":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-transp AT ROW 1.25 COL 25 COLON-ALIGNED HELP
          "Digite o c¢digo do transportador"
     c-nome AT ROW 1.25 COL 36 COLON-ALIGNED NO-LABEL
     c-nome-abrev AT ROW 2.25 COL 25 COLON-ALIGNED HELP
          "Nome abreviado do transportador"
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.transporte
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
         HEIGHT             = 2.67
         WIDTH              = 88.72.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-transp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

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
  {src/adm/template/row-list.i "transporte"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "transporte"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    IF l-cod-unico THEN
        RUN pi-busca-cod-transp.
    ELSE DO:
        RUN get-attribute('adm-new-record':U).
        if  return-value = 'yes':U then do:
            find last b-transp no-lock no-error.
            if  avail b-transp then do:
                if  b-transp.cod-transp <> 99999 then do:
                     assign c-cod-transp = b-transp.cod-transp + 1.
                end.
                else do:
                    assign c-cod-transp = 1.
                    repeat:
                        find b-transp 
                           where b-transp.cod-transp = c-cod-transp no-lock no-error.
                              if  not avail b-transp then 
                                  leave.
                              else
                                  assign c-cod-transp = c-cod-transp + 1.
                    end.
                end.
            end.
            else do:
                 assign c-cod-transp = 1.
            end.
        
            disp c-cod-transp
                 with frame {&frame-name}.
        
        end.
    END.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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

    /******* Verifica se ouve alteraá∆o no seguinte campo: nome
               Chama o programa para atualizaá∆o dos dados do emitente ***/

    /*NOME*/
    IF AVAIL transporte
    AND i-pais-impto-usuario = 1
    AND CONNECTED("mgfis") 
    AND transporte.nome <> c-nome:INPUT-VALUE IN FRAME {&FRAME-NAME} THEN
    DO:
        RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
        RUN gravaAlteracao IN h-bofi230(INPUT STRING("T" + string(transporte.cod-transp)),
                                        INPUT 4,
                                        INPUT transporte.nome,
                                        INPUT c-nome:INPUT-VALUE IN FRAME {&FRAME-NAME},
                                        INPUT 03).
        DELETE PROCEDURE h-bofi230.
        ASSIGN h-bofi230 = ?.
    END.
    
    DO TRANS:
         /*Grava os valores da transporte antes da modificaá∆o.*/
         if  adm-new-record = no then 
             assign c-nome-transp = if avail transporte then transporte.nome       else ""
                    c-cgc-transp  = if avail transporte then transporte.cgc        else ""
                    v-nome-abrev  = if avail transporte then transporte.nome-abrev else "".

         /* =================== Verifica se n∆o est† sendo incluido um registro duplicado =================== */
         if  adm-new-record = yes then do:   
             if  can-find (transporte where transporte.cod-transp = input frame {&frame-name} c-cod-transp) then do:
                 {utp/ut-table.i mgadm transporte 1}
                 run utp/ut-msgs.p (input "show", input 1, input return-value).
                 apply 'entry' to c-cod-transp in frame {&frame-name}.
                 return "adm-error".
             end.
         end.

         /*Passa chave para criar a tabela de extená∆o transpdor-coleta*/
         if  adm-new-record = yes then   
             RUN pi-recebe-chave IN h-v01ad00500(INPUT input frame {&frame-name} c-cod-transp).

         if  can-find (transporte where transporte.nome-abrev  = input frame {&frame-name} c-nome-abrev
                                  and   transporte.cod-transp <> input frame {&frame-name} c-cod-transp) then do:
             {utp/ut-table.i mgadm transporte 1}
             run utp/ut-msgs.p (input "show", input 1, input return-value).
             apply 'entry' to c-nome-abrev in frame {&frame-name}.
             return "adm-error".
         end.

         if  input frame {&frame-name} c-nome = "" then do:
             {utp/ut-field.i mgadm transporte nome 1}
             run utp/ut-msgs.p (input "show", input 164, input return-value).
             return "adm-error".
         end.

         if  input frame {&frame-name} c-nome-abrev = "" then do:
             {utp/ut-field.i mgadm transporte nome-abrev 1}
             run utp/ut-msgs.p (input "show", input 164, input return-value).
             return "adm-error".
         end.  

         {include/i-valid.i}

         assign l-exporta = yes.
         if  avail transporte and adm-new-record = no then do:
             if  transporte.nome-abrev <> input frame {&frame-name} c-nome-abrev then do:
                 run utp/ut-msgs.p (input "show", input 16104, "").
                 if  return-value = "yes" then do:
                     find user-coml where user-coml.usuario = c-seg-usuario no-lock no-error.
                     if  not avail user-coml then do:
                         run utp/ut-msgs.p ("show", 16106, c-seg-usuario).             
                         return "adm-error".                     
                     end.
                     else do:
                         if  user-coml.inf-transp = no or
                             user-coml.inf-redesp = no then do:
                             run utp/ut-msgs.p ("show", 16105, c-seg-usuario).             
                             return "adm-error".                                              
                         end.
                     end.
                 end.
                 else assign l-exporta = no.
             end.
         end.

         /* Code placed here will execute PRIOR to standard behavior. */


        /* Ponha na pi-validate todas as validaá‰es */
        /* N∆o gravar nada no registro antes do dispatch do assign-record e 
           nem na PI-validate. */

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

        {method/xmldef.i}  

        IF adm-new-record THEN DO:
           {method/xmlini.i ADD}
        END.
        ELSE DO:
           {method/xmlini.i UPDATE}   
        END.   
           {method/xmlprp.i}
           {method/xmlsnd.i}

        if  RETURN-VALUE = 'ADM-ERROR':U then 
             return 'ADM-ERROR':U.

        /* Variaveis utilizadas na integraá∆o EMS2/NEOLOG */
        {cdp/cdapi090def.i}

        IF adm-new-record THEN DO:
            /* Include respons†vel pela envio de dados do EMS2 ao NEOLOG */
           {cdp/cdapi090.i CREATE transporte}
           /*Integraá∆o do cadastro de transportador ao sistemas especialistas*/
            RUN integraTransportador (INPUT "CREATE").
        END.
        ELSE DO:
            {cdp/cdapi090.i UPSERT transporte}
            /*Integraá∆o do cadastro de transportador ao sistemas especialistas*/
            RUN integraTransportador (INPUT "UPDATE").
        END.

        IF CAN-FIND (FIRST RowErrors WHERE 
                     RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.

        IF lIntCRM11 THEN DO:
            IF NOT VALID-HANDLE(h-cd0402-crm) THEN
                RUN integracoes/adapters/emstocrm/cd0402-crm.p PERSISTENT SET h-cd0402-crm.
    
            RUN sendToCRM IN h-cd0402-crm (INPUT transporte.cod-transp,
                                           OUTPUT TABLE RowErrors).

            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                UNDO, RETURN "ADM-ERROR":U.
            END.

            DELETE PROCEDURE h-cd0402-crm.
        END.

        IF v_log_eai_habilit THEN DO:
            IF NOT VALID-HANDLE(h-axsvd007) THEN
                RUN adapters/xml/vd2/axsvd007.p PERSISTENT SET h-axsvd007.

            IF adm-new-record THEN ASSIGN c-action = "add":U. 
            ELSE ASSIGN c-action = "upd":U.

            IF AVAIL transporte THEN
                RUN piTransUpsert IN h-axsvd007 (INPUT c-action,
                                                 INPUT ROWID(transporte),
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

            IF VALID-HANDLE(h-axsvd007) THEN DO:
               DELETE PROCEDURE h-axsvd007.
               ASSIGN h-axsvd007 = ?.
            END.
            IF VALID-HANDLE(hShowMsg) THEN DO:
               {method/showmessage.i3}
            END.
        END.

        /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
        /* Code placed here will execute AFTER standard behavior.    */    

        /*Mantem as atualizaá‰es das tabelas integradas*/
        RUN pi-atualiza-tab-integradas.

        assign ind-tipo-movto = if c-cod-transp:sensitive in frame {&frame-name} = yes  
                                then 1
                                else 2.

        /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
        {cdp/cd0002i1.i transporte}

        /********************Multiplanta***********************/

        assign c-transacao = "ADM040".
        {cdp/cd7300.i5 "001" c-transacao}

        run pi-cria-tt-dados (input ind-tipo-movto).

        {cdp/cd7300.i6 "001" c-transacao}    
    END.

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

   do with frame {&frame-name} on error undo, return "adm-error":
    assign {&adm-create-fields} {&adm-modify-fields}.
      assign transporte.cod-transp = c-cod-transp when adm-new-record = yes
             transporte.nome-abrev = c-nome-abrev
             transporte.nome       = c-nome
             no-error.

    if error-status:error then 
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
   end.           



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
   
        DEF VAR c-cod-transp LIKE transporte.cod-transp  NO-UNDO.
        DEF VAR c-nome-abrev LIKE transporte.nome-abrev  NO-UNDO.
        DEF VAR c-nome       AS CHARACTER FORMAT "X(80)" NO-UNDO.
        DEF VAR c-tabela     AS CHARACTER                NO-UNDO.
        def var texto-1      as char                     no-undo.
        def var texto-2      as CHAR                     no-undo.

        IF AVAIL transporte THEN
           ASSIGN c-cod-transp = transporte.cod-transp
                  c-nome-abrev = transporte.nome-abrev
                  c-nome       = transporte.nome
                  i-cod-transp = transporte.cod-transp.
        /********************Multiplanta***********************/
    
        assign ind-tipo-movto = 3
               c-transacao = "ADM040".
    
        {cdp/cd7300.i5 "001" c-transacao}
    
        run pi-cria-tt-dados (input ind-tipo-movto).
    
        {cdp/cd7300.i6 "001" c-transacao}    
    
        /*****[ LOCALIZAÄ«O EQUADOR ]**********************************************************************************/
        IF i-pais-impto-usuario = 21 THEN DO:
            IF NOT VALID-HANDLE(h-boec012) THEN DO:
                RUN local/ecu/ec2bo/boec012.p PERSISTENT SET h-boec012.
                RUN openQueryStatic IN h-boec012 (INPUT 'Main':U).
            END.            
            RUN goToKey IN h-boec012 (INPUT c-cod-transp).
            IF RETURN-VALUE = "OK":U THEN DO:            
                RUN emptyRowErrors IN h-boec012.
                RUN validateRecord IN h-boec012 (INPUT "DELETE":U).
                RUN getRowErrors   IN h-boec012 (OUTPUT TABLE RowErrors).
    
                IF CAN-FIND (FIRST RowErrors WHERE 
                                   RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"}
                    RETURN "ADM-ERROR":U.
                END.
            END.
        END.    
        /************************************************************************************************************/

        /*****[ BANCOS HIST‡RICOS ]************************************************************/
        if  not available(param-global) then
            find first param-global no-lock no-error.
    
        if  param-global.modulo-bh = yes
        then do:
            {bhp/bh9999.i 1 Transporte transporte.cod-transp transporte.nome-abrev '' '' '' ''}
            if  return-value <> "OK"
            then return "ADM-ERROR".
        end.
        /**************************************************************************************/
    
        /*********** MODULO AQR (Aquisiá∆o Produtos Rurais) *******************/

        if  not available(param-global) then
            find first param-global no-lock no-error.
    
        IF AVAIL param-global AND substring(param-global.char-2,101,1) = "S" THEN DO:
    
            IF CAN-FIND(FIRST preco-frete-coleta WHERE preco-frete-coleta.cod-transp = transporte.cod-transp) THEN DO:
    
                {utp/ut-table.i mgadm Transporte 1}
                assign texto-1 = return-value.
                {utp/ut-table.i mgind preco-frete-coleta 1}
                assign texto-2 = return-value.
                run utp/ut-msgs.p (input "show":U, input 5, input texto-1 + "~~" + texto-2).
                return "adm-error".
    
            END.

            IF CAN-FIND(FIRST carg-rural WHERE carg-rural.cod-transp = transporte.cod-transp) THEN DO:
    
                {utp/ut-table.i mgadm Transporte 1}
                assign texto-1 = return-value.
                {utp/ut-table.i movind carg-rural 1}
                assign texto-2 = return-value.
                run utp/ut-msgs.p (input "show":U, input 5, input texto-1 + "~~" + texto-2).
                return "adm-error".
    
            END.
    
        END.
    
        /*********** FIM MODULO AQR (Aquisiá∆o Produtos Rurais) **************/

        /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
        {cdp/cd0002i1.i1 transporte "no"}
        
        /*--- Validar se o transportador a ser eliminado est† relacionado a algum emitente [FO 1551743 - Liziane - 27/07/2007] --*/
        IF  CAN-FIND (FIRST emitente
                      WHERE emitente.cod-transp = transporte.cod-transp) THEN DO:
        
            {utp/ut-table.i mgadm Transporte 1}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 5906,
                               INPUT return-value).
            RETURN "adm-error".
        END.
        /*---*/

        /*--- Validar se o transportador a ser eliminado est† relacionado a algum canal cliente estabelecimento --*/
        if can-find (first canal-clien-estab where 
                           canal-clien-estab.cod-transp = transporte.cod-transp) then do:

           {utp/ut-table.i mgadm transporte 1}
           assign c-tabela = return-value.
           {utp/ut-table.i mgdis canal-clien-estab 1}
           run utp/ut-msgs.p ('show',
                               5,
                               c-tabela + '~~' + trim(return-value)).
           return 'ADM-ERROR'.                    
        end.
        /*---*/
    
            {method/xmldef.i}  
            {method/xmlini.i DELETE}
            {method/xmlprp.i}
            {method/xmlsnd.i}
    
      DO TRANS:

        IF lIntCRM11 THEN DO:
            IF NOT VALID-HANDLE(h-cd0402-crm) THEN
                RUN integracoes/adapters/emstocrm/cd0402-crm.p PERSISTENT SET h-cd0402-crm.

            RUN deleteFromCRM IN h-cd0402-crm (INPUT transporte.cod-transp,
                                               OUTPUT TABLE RowErrors).
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                UNDO, RETURN "ADM-ERROR":U.
            END.
            DELETE PROCEDURE h-cd0402-crm.
        END.

        /*Integraá∆o EAI*/
        RUN integraTransportador (INPUT "DELETE").
            
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).
        if return-value = 'ADM-ERROR':U THEN  
           return 'ADM-ERROR':U.
        ELSE
          /*deleta tabela extensao transpdor-coleta*/   
          RUN local-delete-record IN  h-v01ad00500(INPUT i-cod-transp).

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
            FOR FIRST transp-internac EXCLUSIVE-LOCK
                WHERE transp-internac.cod-transp = c-cod-transp:
                DELETE transp-internac.
            END.
        END.


        IF i-pais-impto-usuario = 21 THEN DO:
            IF NOT VALID-HANDLE(h-boec012) THEN DO:
                RUN local/ecu/ec2bo/boec012.p PERSISTENT SET h-boec012.
                RUN openQueryStatic IN h-boec012 (INPUT 'Main':U).
            END.            

            RUN goToKey IN h-boec012 (INPUT c-cod-transp).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN deleteRecord in h-boec012.
                IF RETURN-VALUE = "OK":U THEN
                    RUN pi-limpa-dados-localiz IN h-handle-container.
            END.
         
        end.


        IF v_log_eai_habilit THEN DO:
            IF NOT VALID-HANDLE(h-axsvd007) THEN
                RUN adapters/xml/vd2/axsvd007.p PERSISTENT SET h-axsvd007.
    
                    IF  AVAIL transporte THEN 
                        RUN piTransDelete IN h-axsvd007 (INPUT transporte.cod-transp,
                                                         INPUT transporte.nome-abrev,
                                                         INPUT transporte.nome, 
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
    
            IF VALID-HANDLE(h-axsvd007) THEN DO:
               DELETE PROCEDURE h-axsvd007.
               ASSIGN h-axsvd007 = ?.
            END.
            IF VALID-HANDLE(hShowMsg) THEN DO:
               {method/showmessage.i3}
            END.
        END.
      END.
      
        /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
        {cdp/cd0002i1.i1 transporte "yes"}

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

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    &if  defined(ADM-CREATE-FIELDS) &then
    disable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
    &endif.

    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif.

    RUN notify ('disable-fields, GROUP-ASSIGN-TARGET':U).

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
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
  /* Dispatch standard ADM method.                             */

  if  avail transporte then do:
      disp transporte.cod-transp @ c-cod-transp
           transporte.nome-abrev @ c-nome-abrev
           transporte.nome       @ c-nome with frame {&frame-name}.
      assign gr-transporte = rowid(transporte).
  end.
  else do:
       disp "" @ c-cod-transp
            "" @ c-nome-abrev
            "" @ c-nome with frame {&frame-name}.
  end.

  IF VALID-HANDLE(h-v01ad00500) THEN
    RUN local-display-fields IN h-v01ad00500.


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
/* Integraá‰es utilizando adpater publicam sempre todos os campos */
/*     IF adm-new-record = NO THEN
         RUN setOldBufferHandle. */

    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    assign c-cgc          = transporte.cgc
           c-ins-estadual = transporte.ins-estadual.

    &if  defined(ADM-MODIFY-FIELDS) &then
         enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif.

    RUN notify ('enable-fields, GROUP-ASSIGN-TARGET':U).

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

  {utp/ut-field.i mgadm transporte cod-transp 1}
  assign c-cod-transp:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgadm transporte nome-abrev 1}
  assign c-nome-abrev:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  RUN local-display-fields.

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0003i1.i transporte cdp/cd0402i1.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-tab-integradas V-table-Win 
PROCEDURE pi-atualiza-tab-integradas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ============================= MantÇm Integridade com Tabelas do Sistema ============================= */
    do on error undo, retry:

        if  adm-new-record = no then do:

            if  l-exporta = yes then do:

                if  session:set-wait-state("general") then.

                /*Atualizaá∆o do nome-abrev*/
                if  v-nome-abrev <> transporte.nome-abrev then do:

                    for each b-estab where b-estab.nome-transp = v-nome-abrev no-lock:
                        for first estab-cli where rowid(estab-cli) = rowid(b-estab) exclusive-lock :
                            assign estab-cli.nome-transp = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-nota
                        where b-nota.nome-transp = v-nome-abrev
                        or    b-nota.nome-tr-red = v-nome-abrev no-lock:
                        for first nota-fiscal where rowid(nota-fiscal) = rowid(b-nota) exclusive-lock:
                            if  b-nota.nome-transp = v-nome-abrev then
                                assign nota-fiscal.nome-transp = transporte.nome-abrev.
                            if  b-nota.nome-tr-red = v-nome-abrev then
                                assign nota-fiscal.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-ped
                        where b-ped.nome-transp = v-nome-abrev
                        or    b-ped.nome-tr-red = v-nome-abrev no-lock:
                        for first ped-venda where rowid(ped-venda) = rowid(b-ped) exclusive-lock :
                            if  b-ped.nome-transp = v-nome-abrev then
                                assign ped-venda.nome-transp = transporte.nome-abrev.
                            if  b-ped.nome-tr-red = v-nome-abrev then
                                assign ped-venda.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-emitente
                        where b-emitente.nome-tr-red = v-nome-abrev no-lock:
                        for first emitente where rowid(emitente) = rowid(b-emitente) exclusive-lock:
                            assign emitente.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-imag-for
                        where b-imag-for.nome-tr-red = v-nome-abrev no-lock:
                        for first imag-for where rowid(imag-for) = rowid(b-imag-for) exclusive-lock:
                            assign imag-for.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-ender-red
                        where b-ender-red.nome-tr-red = v-nome-abrev no-lock:
                        for first ender-red where rowid(ender-red) = rowid(b-ender-red) exclusive-lock:
                            assign ender-red.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-embarque
                        where b-embarque.nome-transp = v-nome-abrev no-lock:
                        for first embarque where rowid(embarque) = rowid(b-embarque) exclusive-lock:
                            assign embarque.nome-transp = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-pre-fatur
                        where b-pre-fatur.nome-transp = v-nome-abrev
                        or    b-pre-fatur.nome-tr-red = v-nome-abrev no-lock:
                        for first pre-fatur where rowid(pre-fatur) = rowid(b-pre-fatur) exclusive-lock:
                            if  b-pre-fatur.nome-transp = v-nome-abrev then
                                assign pre-fatur.nome-transp = transporte.nome-abrev.
                            if  b-pre-fatur.nome-tr-red = v-nome-abrev then
                                assign pre-fatur.nome-tr-red = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-remito
                        where b-remito.nome-transp = v-nome-abrev no-lock:
                        for first remito where rowid(remito) = rowid(b-remito) exclusive-lock:
                            if b-remito.nome-transp = v-nome-abrev then
                                assign remito.nome-transp = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-doc-fiscal
                        where b-doc-fiscal.nome-transp = v-nome-abrev no-lock:
                        for first doc-fiscal where rowid(doc-fiscal) = rowid(b-doc-fiscal) exclusive-lock:
                            if b-doc-fiscal.nome-transp = v-nome-abrev then 
                                assign doc-fiscal.nome-transp = transporte.nome-abrev.
                        end.
                    end.

                    for each  b-loc-entr
                        where b-loc-entr.nome-transp = v-nome-abrev no-lock:
                         for first loc-entr where rowid(loc-entr) = rowid(b-loc-entr) exclusive-lock:
                             if b-loc-entr.nome-transp = v-nome-abrev then
                                 assign loc-entr.nome-transp = transporte.nome-abrev.
                         end.
                     end.

                    /* SFA */
                    if CONNECTED("mgscm") THEN do:
                        run sfc/sfapi014.p persistent set h-api.
                        run atualizaTranspSFA in h-api (INPUT transporte.cod-transp,
                                                        input v-nome-abrev).
                        delete procedure h-api.
                        assign h-api = ?.
                    end.

                    for each  b-simul-emb
                        where b-simul-emb.nome-transp = v-nome-abrev no-lock:
                        for first simul-emb where rowid(simul-emb) = rowid(b-simul-emb) exclusive-lock:
                            if b-simul-emb.nome-transp = v-nome-abrev then
                                assign simul-emb.nome-transp = transporte.nome-abrev.
                        end.
                    end.

                    /*EXCLUSIVO DO M‡DULO DE FRETES*/
                    /******OBS: Os campos CGC e Raz∆o Social da tabela transporte-tf est∆o sendo 
                     atualizados na viewer V05AD268.W (Procedure - Local-assign-record)***********/

                    if not avail param-global then
                        FIND FIRST param-global NO-LOCK NO-ERROR.  

                end. /*Fim v-nome-abrev*/
                if  session:set-wait-state("") then.
            end. /*Fim l-exporta*/
        END. /*Fim adm-new-record*/
    end. /*Fim do on error*/  

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

      create tt-transporte-aux.
      buffer-copy transporte to tt-transporte-aux.
      create tt-dados-env.                  
      assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg   = 66
             tt-dados-env.ind-tipo-movto = i-tipo-movto
             tt-dados-env.identif-msg    = string(transporte.cod-transp).

      raw-transfer tt-transporte-aux to tt-dados-env.conteudo-msg.                                    
      assign i-seq = i-seq + 1.                              

  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-transporte-mg V-table-Win 
PROCEDURE pi-cria-tt-transporte-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-transporte-mg:
        delete tt-transporte-mg.
    end.

    create tt-transporte-mg.
    assign tt-transporte-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-transporte-mg.l-atualiza     = p-atualiza.

    /* Campos Iguais */
    assign tt-transporte-mg.cod-transp       = transporte.cod-transp
           tt-transporte-mg.nome             = fn-free-accent(transporte.nome)
           tt-transporte-mg.nome-abrev       = fn-free-accent(transporte.nome-abrev)
           tt-transporte-mg.endereco         = fn-free-accent(transporte.endereco)
           tt-transporte-mg.cidade           = fn-free-accent(transporte.cidade)
           tt-transporte-mg.pais             = transporte.pais
           tt-transporte-mg.cgc              = transporte.cgc
           tt-transporte-mg.ins-estadual     = transporte.ins-estadual
           tt-transporte-mg.contato          = fn-free-accent(transporte.contato)
           tt-transporte-mg.telefone         = transporte.telefone
           tt-transporte-mg.ramal            = transporte.ramal
           tt-transporte-mg.telefax          = transporte.telefax
           tt-transporte-mg.telex            = transporte.telex
           tt-transporte-mg.dec-1            = transporte.dec-1
           tt-transporte-mg.int-1            = transporte.int-1
           tt-transporte-mg.log-1            = transporte.log-1
           tt-transporte-mg.ins-municipal    = transporte.ins-municipal
           tt-transporte-mg.cx-postal        = transporte.cx-postal
           tt-transporte-mg.zip-code         = transporte.zip-code
           tt-transporte-mg.dec-2            = transporte.dec-2
           tt-transporte-mg.int-2            = transporte.int-2.


    /* Campos com valores diferentes */
    case transporte.via-transp:
        when 1 then assign tt-transporte-mg.via-transp = 1. /* Rodoviario      */
        when 2 then assign tt-transporte-mg.via-transp = 2. /* Aeronautico     */
        when 3 then assign tt-transporte-mg.via-transp = 3. /* Mar°timo        */
        when 4 then assign tt-transporte-mg.via-transp = 4. /* Ferrovi†rio     */
        when 5 then assign tt-transporte-mg.via-transp = 5. /* Rodoferrovi†rio */
        when 6 then assign tt-transporte-mg.via-transp = 6. /* Rodofluvial     */
        when 7 then assign tt-transporte-mg.via-transp = 6. /* Rodo-Aerovi†rio */
        when 8 then assign tt-transporte-mg.via-transp = 6. /* Outros          */
    end case.

    case transporte.natureza:
        when 1 then assign tt-transporte-mg.natureza = "F".
        when 2 then assign tt-transporte-mg.natureza = "J".
        when 3 then assign tt-transporte-mg.natureza = "E".
        when 4 then assign tt-transporte-mg.natureza = "E".
    end case.

    /* Campos com os formatos diferentes */
    assign tt-transporte-mg.bairro           = substring(string(fn-free-accent(transporte.bairro),"x(15)"),1,15)
           tt-transporte-mg.estado           = substring(string(fn-free-accent(transporte.estado),"x(02)"),1,2)
           tt-transporte-mg.cep              = int(transporte.cep)
           tt-transporte-mg.cod-emitente     = int(transporte.cod-emitente)
           tt-transporte-mg.char-1           = transporte.char-1
           tt-transporte-mg.char-2           = transporte.char-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0004i1.i "CD0402" "TRANSPORTE" transporte.cod-transp tt-transporte-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
                Purpose:                                                                                                                                          
                Notes:                                                                                                                                            
------------------------------------------------------------------------------*/
    define input param h-handle as handle no-undo.

    assign h-v01ad00500 = h-handle.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-rowid V-table-Win 
PROCEDURE pi-recebe-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter gr-transp as rowid no-undo.

assign gr-transporte = gr-transp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-nome-abrev V-table-Win 
PROCEDURE pi-retorna-nome-abrev :
/* -----------------------------------------------------------
  Purpose: Passa o valor do nome-abrev antes da alteraá∆o
  Parameters:  Nome-abrev
  Notes:       
-------------------------------------------------------------*/
  DEFINE output PARAMETER p-nome-abrev as char NO-UNDO.

  assign p-nome-abrev = v-nome-abrev.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-nome-abrev V-table-Win 
PROCEDURE pi-retorna-transp :
/* -----------------------------------------------------------
  Purpose: Passa o valor do nome-abrev antes da alteraá∆o
  Parameters:  Nome-abrev
  Notes:       
-------------------------------------------------------------*/
  DEFINE output PARAMETER p-cod-transp as int NO-UNDO.

  assign p-cod-transp = if avail transporte then transporte.cod-transp else 0.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-transporte-mg V-table-Win 
PROCEDURE pi-valida-transporte-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.

    return "OK".

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
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN transporte.cod-transp = c-cod-transp
       transporte.nome-abrev = c-nome-abrev:screen-value in frame {&frame-name}.

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
  {src/adm/template/snd-list.i "transporte"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraTransportador V-table-Win 
PROCEDURE integraTransportador :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  pType       AS CHARACTER           NO-UNDO.
  
  DEFINE VARIABLE h-cd1608          AS HANDLE          NO-UNDO.
  DEFINE VARIABLE i-cod-gr-forn     AS INTEGER         NO-UNDO.
  DEFINE VARIABLE i-portador        AS INTEGER         NO-UNDO.
  DEFINE VARIABLE i-cb-modalidade   AS INTEGER         NO-UNDO.
  DEFINE VARIABLE c-trad1           AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE c-trad2           AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE l-integr          AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE l-integra-ems5    AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE h-cdapi366b       AS HANDLE          NO-UNDO.
  DEFINE VARIABLE c-cod-arquivo-log AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE h-ut-integration  AS HANDLE          NO-UNDO.
  DEFINE VARIABLE c-true-type        AS CHARACTER       NO-UNDO.

  ASSIGN c-true-type = pType.
  
  IF NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.

  IF CAN-FIND(FIRST funcao 
              WHERE funcao.cd-funcao = "adm-cdf-ems-5.00"     
                AND funcao.ativo = YES                                          
                AND funcao.log-1 = YES)
  AND AVAIL param-global 
  AND param-global.log-2 = YES THEN
      ASSIGN l-integra-ems5 = YES.
  ELSE 
      ASSIGN l-integra-ems5 = NO.

  RUN cdp/cdapi366b.p PERSISTENT SET h-cdapi366b.

  IF l-cod-unico THEN DO:
      IF pType <> "DELETE" THEN DO:

          FOR FIRST emitente
              WHERE emitente.cod-emitente <> transporte.cod-transp
                AND emitente.nome-abrev = transporte.nome-abrev NO-LOCK:

              EMPTY TEMP-TABLE RowErrors.
              CREATE RowErrors.
              ASSIGN RowErrors.ErrorNumber  = 2811
                     RowErrors.ErrorSubType = "ERROR".

              RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 2811, INPUT STRING(emitente.cod-emitente)).
              ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

              RUN utp/ut-msgs.p (INPUT "help":U, INPUT 2811, INPUT STRING(emitente.cod-emitente)).
              ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

              UNDO, RETURN "ADM-ERROR":U.
          END.

          FIND FIRST emitente
               WHERE emitente.cod-emitente = transporte.cod-transp
                 AND emitente.identific   <> 1 NO-LOCK NO-ERROR.
          IF NOT AVAIL emitente THEN
              ASSIGN pType = "CREATE".

          
          IF pType = "CREATE" THEN DO:
              {utp/ut-liter.i "Deseja_cadastrar_o_transportador_como_fornecedor?"}
              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 32699,
                                 INPUT RETURN-VALUE).
          END.
          IF RETURN-VALUE = "YES" OR pType = "UPDATE" THEN DO:       
    
              IF pType = "CREATE" THEN DO:
    
                  IF AVAIL emitente THEN DO:
                      {utp/ut-liter.i "Fornecedor j† cadastrado com esse c¢digo. Deseja atualizar?"}
                      ASSIGN c-trad1 = RETURN-VALUE.
                      {utp/ut-liter.i "Sim:_Atualiza_o_fornecedor_existente_com_esse_c¢digo."}
                      ASSIGN c-trad2 = RETURN-VALUE.
                      {utp/ut-liter.i "N∆o:_Busca_uma_nova_numeraá∆o_dispon°vel."}
                      RUN utp/ut-msgs.p (INPUT "show",
                                         INPUT 32699,
                                         INPUT c-trad1 + "~~" + c-trad2 + CHR(10) + RETURN-VALUE).
                      IF RETURN-VALUE <> "YES" THEN DO:
                          RUN local-apply-entry.
                          FOR FIRST transpdor-coleta
                              WHERE transpdor-coleta.cod-transp = transporte.cod-transp EXCLUSIVE-LOCK:
                              ASSIGN transpdor-coleta.cod-transp = input frame {&frame-name} c-cod-transp.
                          END.
                          RELEASE transpdor-coleta.
                          ASSIGN transporte.cod-transp = input frame {&frame-name} c-cod-transp.
                      END.
                      ELSE
                          ASSIGN pType = "UPDATE".
                  END.
                  
                  IF pType = "CREATE" THEN DO:
                      ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
                      RUN cdp/cd0402c.w (OUTPUT i-cod-gr-forn,
                                         OUTPUT i-portador,
                                         OUTPUT i-cb-modalidade).
                      ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
                      APPLY 'ENTRY' TO {&WINDOW-NAME}.
                  END.
              END.

              RUN pi-integra-codigo-unico-ems5 (INPUT pType).

              EMPTY TEMP-TABLE tt_emitente_integr_new.
              EMPTY TEMP-TABLE tt_cont_emit_integr_new.  
              EMPTY TEMP-TABLE tt_retorno_clien_fornec.  
              EMPTY TEMP-TABLE tt_cta_emitente.

              IF pType = "UPDATE" THEN DO:

                  ASSIGN i-cod-gr-forn   = emitente.cod-gr-forn.

                  IF l-funcao-portador-ap THEN
                      ASSIGN i-portador      = emitente.portador-ap
                             i-cb-modalidade = emitente.modalidade-ap.
                  ELSE
                      ASSIGN i-portador      = emitente.portador
                             i-cb-modalidade = emitente.modalidade.
              END.

              FIND FIRST grupo-fornec  WHERE grupo-fornec.cod-gr-forn = i-cod-gr-forn NO-LOCK NO-ERROR.
              FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tipo = 2 /* Despesas */    NO-LOCK NO-ERROR.
              
              CREATE tt_emitente_integr_new.
              ASSIGN tt_emitente_integr_new.cod_versao_integracao = 1
                     tt_emitente_integr_new.cod_emitente          = transporte.cod-transp
                     tt_emitente_integr_new.identific             = 2 /* Fornecedor */
                     tt_emitente_integr_new.nome_abrev            = transporte.nome-abrev
                     tt_emitente_integr_new.nome_matriz           = transporte.nome-abrev
                     tt_emitente_integr_new.natureza              = transporte.natureza
                     tt_emitente_integr_new.cgc                   = transporte.cgc
                     tt_emitente_integr_new.cod_portador          = i-portador
                     tt_emitente_integr_new.modalidade            = i-cb-modalidade
                     tt_emitente_integr_new.data_implant          = TODAY
                     tt_emitente_integr_new.cod_gr_forn           = grupo-fornec.cod-gr-forn WHEN AVAIL grupo-fornec
                     tt_emitente_integr_new.ins_estadual          = transporte.ins-estadual
                     tt_emitente_integr_new.ins_municipal         = transporte.ins-municipal
                     tt_emitente_integr_new.estado                = transporte.estado
                     tt_emitente_integr_new.endereco              = transporte.endereco
                     tt_emitente_integr_new.bairro                = transporte.bairro
                     tt_emitente_integr_new.cep                   = transporte.cep
                     tt_emitente_integr_new.cod_pais              = transporte.pais
                     tt_emitente_integr_new.nom_cidade            = transporte.cidade
                     tt_emitente_integr_new.telefone[1]           = transporte.telefone
                     tt_emitente_integr_new.home_page             = transporte.home-page
                     tt_emitente_integr_new.zip_code              = transporte.zip-code
                     tt_emitente_integr_new.caixa_postal          = transporte.cx-postal
                     tt_emitente_integr_new.ramal[1]              = transporte.ramal
                     tt_emitente_integr_new.telefax               = transporte.telefax
                     tt_emitente_integr_new.ramal_fax             = transporte.ramal-fax
                     tt_emitente_integr_new.telex                 = transporte.telex
                     tt_emitente_integr_new.telef_modem           = transporte.telef-modem
                     tt_emitente_integr_new.ramal_modem           = transporte.ramal-modem
                     tt_emitente_integr_new.ender_text            = transporte.endereco_text
                     tt_emitente_integr_new.ven_sabado            = 1
                     tt_emitente_integr_new.ven_domingo           = 1
                     tt_emitente_integr_new.ven_feriado           = 1
                     tt_emitente_integr_new.e_mail                = transporte.e-mail
                     tt_emitente_integr_new.nome_emit             = transporte.nome
                     tt_emitente_integr_new.ep_codigo             = param-global.empresa-prin WHEN AVAIL param-global
                     tt_emitente_integr_new.ep_codigo_principal   = param-global.empresa-prin WHEN AVAIL param-global
                     tt_emitente_integr_new.num_tip_operac        = 1 /* ( 1 - Inclus∆o/Modificaá∆o, 2 - Eliminaá∆o) */
                     tt_emitente_integr_new.tp_desp_padrao        = tipo-rec-desp.tp-codigo WHEN AVAIL tipo-rec-desp
                     tt_emitente_integr_new.cod_gr_cli            = gr-cli.cod-gr-cli  WHEN AVAIL gr-cli
                     tt_emitente_integr_new.cod_rep               = gr-cli.cod-rep     WHEN AVAIL gr-cli
                     tt_emitente_integr_new.tp_rec_padrao         = gr-cli.tp-rec-desp WHEN AVAIL gr-cli
                     tt_emitente_integr_new.bonificacao           = gr-cli.bonificacao WHEN AVAIL gr-cli
                     tt_emitente_integr_new.ramo_atividade        = gr-cli.atividade   WHEN AVAIL gr-cli. 


              /* Executa procedure evoluida */
              IF VALID-HANDLE(h-cdapi366b) THEN DO:
                  RUN execute_evoluida_8 IN h-cdapi366b (INPUT        TABLE tt_emitente_integr_new,
                                                         INPUT        TABLE tt_cont_emit_integr_new,
                                                         INPUT-OUTPUT TABLE tt_retorno_clien_fornec,
                                                         INPUT              "",
                                                         INPUT-OUTPUT       c-cod-arquivo-log,
                                                         INPUT        TABLE tt_cta_emitente). 
                  DELETE PROCEDURE h-cdapi366b.
              END.

              FOR EACH tt_retorno_clien_fornec:
                  CREATE RowErrors.
                  ASSIGN RowErrors.ErrorNumber      = tt_retorno_clien_fornec.ttv_num_mensagem
                         RowErrors.ErrorDescription = tt_retorno_clien_fornec.ttv_des_mensagem 
                         RowErrors.ErrorHelp        = tt_retorno_clien_fornec.ttv_des_ajuda
                         RowErrors.ErrorSubType     = "ERROR":U.
              END.

              IF CAN-FIND (FIRST RowErrors WHERE 
                                 RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                  UNDO, RETURN "ADM-ERROR":U.
              END.

              /************* Integracao 2.00 X 5.00 *****************/
              FIND FIRST emitente
                   WHERE emitente.cod-emitente = transporte.cod-transp NO-LOCK NO-ERROR.
              
              IF AVAIL emitente AND l-integra-ems5 THEN DO:
                  RUN cdp/cd1608.p PERSISTENT SET h-cd1608
                                   (INPUT emitente.cod-emitente,
                                    INPUT emitente.cod-emitente,
                                    INPUT emitente.identific,
                                    INPUT YES,
                                    INPUT 1,
                                    INPUT 0,
                                    INPUT "utb765zb.tmp",
                                    INPUT "Terminal":U,
                                    INPUT "").
                  DELETE PROCEDURE h-cd1608.
              END.
          END.
      END.
  END.

  /*Integraá∆o EAI*/
  RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
  RUN eai-integration in h-ut-integration (INPUT "Carrier",            /* Nome da transaá∆o     */
                                           INPUT ROWID(transporte),    /* Registro da transaá∆o */
                                           INPUT c-true-type,          /* Evento da transaá∆o   */
                                           OUTPUT table RowErrorsEAI). /* Erros da transaá∆o    */ 
  FOR EACH RowErrorsEAI:
      CREATE RowErrors.
      BUFFER-COPY RowErrorsEAI TO RowErrors.
  END.

  IF CAN-FIND (FIRST RowErrors WHERE 
                     RowErrors.ErrorSubType = "ERROR":U) THEN DO:
      UNDO, RETURN "ADM-ERROR":U.
  END.
    
  DELETE PROCEDURE h-ut-integration.

  /*Fim integraá∆o EAI*/

  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cod-transp V-table-Win 
PROCEDURE pi-busca-cod-transp :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE v_hdl_api          AS HANDLE  NO-UNDO.
   DEFINE VARIABLE v_cdn_clien_fornec AS INTEGER NO-UNDO.
   
   RUN GET-ATTRIBUTE('adm-new-record':U).

   IF  RETURN-VALUE = 'yes':U THEN DO:
       RUN prgint/utb/utb506za.py PERSISTENT SET v_hdl_api.

       CREATE tt_control_id_clien_fornec.
       ASSIGN tt_control_id_clien_fornec.tta_cdn_clien_fornec = 0          /* FIXO: ZERO    */
              tt_control_id_clien_fornec.tta_cod_id_feder     = ""         /* EM BRANCO     */
              tt_control_id_clien_fornec.tta_cod_id_estad     = ""         /* EM BRANCO     */
              tt_control_id_clien_fornec.tta_cod_aplicat_orig = "DATASUL". /* FIXO: DATASUL */ 
        
       RUN pi_main_code_control_id_clien_fornec IN v_hdl_api (INPUT  1, /* Incluir/Buscar */
                                                              INPUT  TABLE tt_control_id_clien_fornec,
                                                              OUTPUT v_cdn_clien_fornec,
                                                              OUTPUT TABLE tt_erro_msg).
       IF CAN-FIND(FIRST tt_erro_msg) THEN DO:
           FOR EACH tt_erro_msg:

               CREATE RowErrors.
               ASSIGN RowErrors.ErrorNumber      = tt_erro_msg.ttv_num_msg_erro
                      RowErrors.ErrorDescription = tt_erro_msg.ttv_des_msg_erro
                      RowErrors.ErrorHelp        = tt_erro_msg.ttv_des_help_erro
                      RowErrors.ErrorSubType     = "ERROR":U.
           END.
           IF CAN-FIND (FIRST RowErrors WHERE 
                              RowErrors.ErrorSubType = "ERROR":U) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="YES"}
               UNDO, RETURN "ADM-ERROR":U.
           END.
       END.
       ELSE DO:
          ASSIGN c-cod-transp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v_cdn_clien_fornec).
       END.
        
       EMPTY TEMP-TABLE tt_control_id_clien_fornec.
       DELETE PROCEDURE v_hdl_api.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-codigo-unico-ems5 V-table-Win 
PROCEDURE pi-integra-codigo-unico-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE v_hdl_api          AS HANDLE  NO-UNDO.
    DEFINE VARIABLE v_cdn_clien_fornec AS INTEGER NO-UNDO.

    RUN prgint/utb/utb506za.py PERSISTENT SET v_hdl_api.

    EMPTY TEMP-TABLE tt_control_id_clien_fornec.
    EMPTY TEMP-TABLE tt_erro_msg.

    CREATE tt_control_id_clien_fornec.
    ASSIGN tt_control_id_clien_fornec.tta_cdn_clien_fornec = transporte.cod-transp
           tt_control_id_clien_fornec.tta_cod_id_feder     = transporte.cgc
           tt_control_id_clien_fornec.tta_cod_id_estad     = transporte.ins-estadual
           tt_control_id_clien_fornec.tta_cod_aplicat_orig = "DATASUL".

    IF pType = "CREATE" THEN
        RUN pi_main_code_control_id_clien_fornec IN v_hdl_api (INPUT  4, /* Validar Inclus∆o*/
                                                               INPUT  TABLE tt_control_id_clien_fornec,
                                                               OUTPUT v_cdn_clien_fornec,
                                                               OUTPUT TABLE tt_erro_msg).
    ELSE IF c-cgc <> transporte.cgc 
         AND c-ins-estadual <> transporte.ins-estadual THEN
        RUN pi_main_code_control_id_clien_fornec IN v_hdl_api (INPUT  5, /* Validar Modificaá∆o*/
                                                               INPUT  TABLE tt_control_id_clien_fornec,
                                                               OUTPUT v_cdn_clien_fornec,
                                                               OUTPUT TABLE tt_erro_msg).

    EMPTY TEMP-TABLE RowErrors.
    
    IF CAN-FIND(FIRST tt_erro_msg) THEN DO:
       FOR EACH tt_erro_msg:

           CREATE RowErrors.
           ASSIGN RowErrors.ErrorNumber      = tt_erro_msg.ttv_num_msg_erro
                  RowErrors.ErrorDescription = tt_erro_msg.ttv_des_msg_erro
                  RowErrors.ErrorHelp        = tt_erro_msg.ttv_des_help_erro
                  RowErrors.ErrorSubType     = "ERROR":U.
       END.
       IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           UNDO, RETURN "ADM-ERROR":U.
        END.
    END.
    
    EMPTY TEMP-TABLE tt_control_id_clien_fornec.
    DELETE PROCEDURE v_hdl_api.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
