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
{include/i-prgvrs.i V01AD129 2.00.00.044 } /*** "010044" 27/06/2023 11:14:12  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad129 MUT}
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
def new global shared var v-row-parent as rowid   no-undo.            
def new global shared var gr-gr-cli    as rowid   no-undo.   
def new global shared var l-exporta    as logical no-undo init no.                 
def new global shared var l-modifica   as logical no-undo init no.

/*************Multiplanta********************/

def var i-tipo-movto     as integer             no-undo.
def var l-cria           as logical initial no  no-undo.
def var teste            as char                no-undo.
def var c-reg-alter      as char                no-undo.
def var rs-op-exporta    as integer format 99   no-undo.
def var l-ok-cred        as logical             no-undo.
def var c-natur          as char                no-undo.
def var i-natureza       as integer             no-undo.
def var l-exporta-cli    as logical             no-undo.
def var c-pergunta-cli	 as character			no-undo.
def var c-help-cli       as character           no-undo.

def var i                as integer             no-undo.
def var l-alterado       as logical             no-undo.
def var h-acr783za       as handle              no-undo.
def var c-portador       as char                no-undo.
def var c-cart-bcia      as char                no-undo.
def var c-tip-fluxo-financ as char              no-undo.

define buffer      b-gr-cli     for  gr-cli.
define temp-table  tt-grupo-cli NO-UNDO like gr-cli.


{cdp/cd7300.i1}
{cdp/cdapi232.i}

{include/i-freeac.i}
{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{cdp/cdcfgdis.i} /* Definiá∆o de Funá‰es */
{include/i_prdvers.i}

/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var h_v03ad129 as handle no-undo.
def var c-modalidade-ant as char no-undo.
def var c-modalidade-mg  as char no-undo.
def var i-modalidade-ant as int  no-undo.
def var i-modalidade     as int  no-undo.
def var i-ind-tipo-movto as inte no-undo.

def var h-acomp          as handle no-undo.
DEFINE VARIABLE c-nr-tabpre      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-mostra-erro-mg AS LOGICAL    NO-UNDO.

{cdp/cd0701i1.i} /* Definiá∆o da temp-table tt-gr-cli-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/


/************Fim*****************************/

{bhp/bh9999.i1}

/* Integraá∆o EAI */
&IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN

    DEFINE NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 

    {cdp/cd9043.i}
    define variable h-axsvd008 as handle    no-undo.
    define variable c-action   as character no-undo.
    define variable hShowMsg   as handle    no-undo.

    define temp-table tt_log_erro  no-undo
           field ttv_num_cod_erro  as integer   init ?
           field ttv_des_msg_ajuda as character init ?
           field ttv_des_msg_erro  as character init ?.

    define variable i-cod-gr-cli like gr-cli.cod-gr-cli no-undo. 
    define variable c-descricao  like gr-cli.descricao  no-undo. 

&ENDIF

DEFINE VARIABLE h-cd0701-crm    AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11       AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

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
&Scoped-define EXTERNAL-TABLES gr-cli
&Scoped-define FIRST-EXTERNAL-TABLE gr-cli


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gr-cli.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gr-cli.descricao 
&Scoped-define ENABLED-TABLES gr-cli
&Scoped-define FIRST-ENABLED-TABLE gr-cli
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 
&Scoped-Define DISPLAYED-FIELDS gr-cli.cod-gr-cli gr-cli.descricao 
&Scoped-define DISPLAYED-TABLES gr-cli
&Scoped-define FIRST-DISPLAYED-TABLE gr-cli
&Scoped-Define DISPLAYED-OBJECTS cb-natureza 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS gr-cli.cod-gr-cli gr-cli.descricao ~
cb-natureza 
&Scoped-define ADM-ASSIGN-FIELDS gr-cli.descricao cb-natureza 
&Scoped-define ADM-MODIFY-FIELDS gr-cli.descricao cb-natureza 

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
DEFINE VARIABLE cb-natureza AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.29 BY 1
     FONT 1 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.38.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     gr-cli.cod-gr-cli AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.50 BY .88
     gr-cli.descricao AT ROW 1.25 COL 32.55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.72 BY .88
     cb-natureza AT ROW 2.75 COL 27 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-key-2 AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.gr-cli
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
         HEIGHT             = 2.88
         WIDTH              = 90.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 2.88
       FRAME f-main:WIDTH            = 90.

/* SETTINGS FOR COMBO-BOX cb-natureza IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN gr-cli.cod-gr-cli IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN gr-cli.descricao IN FRAME f-main
   1 2 3                                                                */
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

  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 x Magnus I.01 */

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
  {src/adm/template/row-list.i "gr-cli"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gr-cli"}

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

  {utp~/ut-field.i mgadm gr-cli natureza 01}
  assign cb-natureza:label in frame {&frame-name} = trim(return-value).

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
    {include/i-valid.i}

    if  gr-cli.cod-gr-cli:sensitive in frame {&FRAME-NAME} then do:
        if  can-find(gr-cli where gr-cli.cod-gr-cli = input frame {&FRAME-NAME} gr-cli.cod-gr-cli) then do:
            {utp/ut-table.i mgadm gr-cli 1}.
            run utp/ut-msgs.p (input "show",
                               input 7,
                               input return-value).
            apply 'entry' to gr-cli.cod-gr-cli in frame {&FRAME-NAME}.
            return 'adm-error'.
        end.
    end.  

    if  input frame {&FRAME-NAME} gr-cli.cod-gr-cli = 0 then do:
        {utp/ut-field.i mgadm gr-cli cod-gr-cli 1}.
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input return-value).
        apply 'entry' to gr-cli.cod-gr-cli in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if  input frame {&FRAME-NAME} gr-cli.descricao = "" then do:
        {utp/ut-field.i mgadm gr-cli descricao 1}.
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input return-value).
        apply 'entry' to gr-cli.descricao in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    run pi-passa-modalidade in h_v03ad129 (output c-modalidade-ant).
    assign i-modalidade = {adinc/i03ad209.i 06 c-modalidade-ant}.


    for each tt-grupo-cli:
        delete tt-grupo-cli.
    end.

    if  avail gr-cli then 
        buffer-copy gr-cli to tt-grupo-cli.

    assign c-natur = input frame {&frame-name} cb-natureza.

    do  with frame {&frame-name}:
        i-natureza = {adinc/i03ad098.i  06 c-natur}.
    end.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    assign cb-natureza:screen-value = c-natur
           gr-cli.natureza = i-natureza.

    assign c-reg-alter = "".

    if  not adm-new-record then
        buffer-compare gr-cli except user-libcre to tt-grupo-cli save result in c-reg-alter.
    
    /*CHAMADA UPC*/

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "before-exporta-grupo-cli",

                                        INPUT "VIEWER",

                                        INPUT THIS-PROCEDURE,

                                        INPUT FRAME {&FRAME-NAME}:HANDLE,

                                        INPUT STRING(c-reg-alter),

                                        INPUT ROWID(gr-cli)).

    END.

    /*FIM CHAMADA UPC*/

    if  c-reg-alter <> "" then do:
        run cdp/cd0701b.w (output rs-op-exporta).        
    end.

    {cdp/cd0002i1.i gr-cli} /* Integraá∆o EMS 2.04 x Magnus I.01 */

    if  c-reg-alter <> "" then do:        
        /* 1 - N∆o exporta para os clientes.  *
         * 0 - Quando o processo Ç cancelado. */
        if  rs-op-exporta <> 1
        and rs-op-exporta <> 0 then do:
		
			find first tt-grupo-cli no-lock where tt-grupo-cli.cod-gr-cli = gr-cli.cod-gr-cli no-error.
			
			if tt-grupo-cli.perc-fat-ped <> gr-cli.perc-fat-ped
			and can-find(first emitente no-lock
						 where emitente.cod-gr-cli = gr-cli.cod-gr-cli
						   and substring(emitente.char-1,147,1) = "S") then do:
						   
				{utp/ut-liter.i Atená∆o!_O_percentual_m†ximo_de_faturamento_n∆o_ser†_exportado_para_todos_os_clientes! *}
				assign c-pergunta-cli = return-value.
				{utp/ut-liter.i O_percentual_m†ximo_de_faturamento_n∆o_ser†_exportado_para_os_clientes_que_possuem_controle_pelo_item_do_cliente. *}
				assign c-help-cli = return-value.
				run utp/ut-msgs.p(input "show",
								  input 17006,
								  input c-pergunta-cli + "~~" + c-help-cli).

			end.
				
            run pi-exporta-grupo-cli.
        end.
    end.

     /*CHAMADA UPC*/

    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "after-exporta-grupo-cli",
                                        INPUT "VIEWER",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT STRING(rs-op-exporta),
                                        INPUT ROWID(gr-cli)).
    END.

    /*FIM CHAMADA UPC*/

/******************** Multiplanta ***********************/

    assign c-transacao = "ADM030".
    {cdp/cd7300.i5 "001" c-transacao}

    assign i-tipo-movto = if  gr-cli.cod-gr-cli:sensitive in frame {&frame-name} = yes 
                              then 1
                              else 2.

    IF  i-tipo-movto = 2 THEN DO: /*modificaá∆o*/
        &IF '{&bf_dis_versao_ems}' < '2.06' &THEN
            ASSIGN OVERLAY(gr-cli.char-1,2,1) = STRING(rs-op-exporta).
        &ELSE
            ASSIGN gr-cli.idi-atualiz-clien = rs-op-exporta.
        &ENDIF
    END.

    run pi-cria-tt-dados (input i-tipo-movto).

    {cdp/cd7300.i6 "001" c-transacao}

/****************** Fim Multiplanta ********************/ 

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0701-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0701-crm.p PERSISTENT SET h-cd0701-crm.

        RUN sendToCRM IN h-cd0701-crm (INPUT gr-cli.cod-gr-cli,
                                       OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0701-crm.
    END.



      /* Integraá∆o EAI ->> Sender de Grupo de Cliente */
    &if "{&bf_dis_versao_ems}" >= "2.04":U &then
    
    if  v_log_eai_habilit then do:

        if  not valid-handle(h-axsvd008) then
            run adapters/xml/vd2/axsvd008.p persistent set h-axsvd008.

        assign c-action = if adm-new-record then "add":U
                          else "upd":U.

        if  avail gr-cli then
            run piTransUpsert in h-axsvd008 (input c-action,
                                             input rowid(gr-cli),
                                             output table tt_log_erro).
        empty temp-table RowErrors no-error.

        for each tt_log_erro:

            create RowErrors.
            assign RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                   RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.ErrorSubType     = "ERROR":U.
        end.

        if  can-find (first RowErrors 
                          where RowErrors.ErrorSubType = "ERROR":U) then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            undo, return "ADM-ERROR":U.
        end.

        if  valid-handle(h-axsvd008) then do:

            delete procedure h-axsvd008.
            assign h-axsvd008 = ?.
        end.

        if  valid-handle(hShowMsg) then do:

           {method/showmessage.i3}
        end.
    end.

    &endif
    /* Fim Integraá∆o EAI ->> Sender de Grupo de Cliente */

    assign l-alterado = no.
    do i = 1 to num-entries(c-reg-alter):
       case entry(i,c-reg-alter):
          when "modalidade" then
              assign l-alterado = yes.
           when "portador" then
              assign l-alterado = yes.
           when "tp-rec-desp" then
               assign l-alterado = yes.
       end case.
    end.       

    /* Modifica grupo de cliente e alteraá∆o dos campos modalidade, portador, tp-rec-desp - integraá∆o para o UTB110AA */
    if i-tipo-movto = 2 and l-alterado then do:
        
        if  not valid-handle(h-acr783za) then
            run prgfin/acr/acr783za.p persistent set h-acr783za (input no).

        if rs-op-exporta = 1 then do: /* N∆o exporta para os clientes. */

           /* atualiza tabela grp_clien do grupo com traduá∆o */
           run pi_trad_inf_grp_clien_ems2_ems5 in h-acr783za
                                                 (input 3,
                                                  input string(gr-cli.cod-gr-cli),
                                                  input gr-cli.descricao,
                                                  input gr-cli.portador,
                                                  input gr-cli.modalidade,
                                                  input gr-cli.tp-rec-desp,
                                                  input yes,                // atualiza grp_clien
                                                  input no,                 // atualiza clien_financ
                                                  output c-portador,
                                                  output c-cart-bcia,
                                                  output c-tip-fluxo-financ,
                                                  output table tt_log_erro).
        end.
        
        if rs-op-exporta = 2 then do: /* Exportar conforme conte£do anterior */

           /* atualiza tabela grp_clien do grupo com traduá∆o - informaá‰es novas */
           run pi_trad_inf_grp_clien_ems2_ems5 in h-acr783za
                                                 (input  3,
                                                  input string(gr-cli.cod-gr-cli),
                                                  input gr-cli.descricao,
                                                  input gr-cli.portador,
                                                  input i-modalidade,
                                                  input gr-cli.tp-rec-desp,
                                                  input yes,                // atualiza grp_clien
                                                  input no,                 // atualiza clien_financ
                                                  output c-portador,
                                                  output c-cart-bcia,
                                                  output c-tip-fluxo-financ,
                                                  output table tt_log_erro).

            if not can-find(tt_log_erro) then do:
               find first tt-grupo-cli no-lock where tt-grupo-cli.cod-gr-cli = gr-cli.cod-gr-cli no-error.
               
               /* atualiza cliente financeiro com base nas informaá‰es anteriores do grupo de cliente com traduá∆o */
               run pi_trad_inf_grp_clien_ems2_ems5 in h-acr783za
                                                     (input 3,
                                                      input string(tt-grupo-cli.cod-gr-cli),
                                                      input '',
                                                      input tt-grupo-cli.portador,
                                                      input tt-grupo-cli.modalidade,
                                                      input tt-grupo-cli.tp-rec-desp,
                                                      input no,                      // atualiza grp_clien
                                                      input yes,                     // atualiza clien_financ
                                                      output c-portador,
                                                      output c-cart-bcia,
                                                      output c-tip-fluxo-financ,
                                                      output table tt_log_erro).
            end.
        end.

        if rs-op-exporta = 3 then do: /* Exportar para todos os clientes do grupo */

            /* atualiza tabela grp_clien do grupo e cliente financeiro com traduá∆o - informaá‰es novas */
           run pi_trad_inf_grp_clien_ems2_ems5 in h-acr783za
                                                 (input 3,
                                                  input string(gr-cli.cod-gr-cli),
                                                  input gr-cli.descricao,
                                                  input gr-cli.portador,
                                                  input i-modalidade,
                                                  input gr-cli.tp-rec-desp,
                                                  input yes,               // atualiza grp_clien
                                                  input yes,               // atualiza clien_financ
                                                  output c-portador,
                                                  output c-cart-bcia,
                                                  output c-tip-fluxo-financ,
                                                  output table tt_log_erro).
        end.
        
        if valid-handle(h-acr783za) then do:
           delete procedure h-acr783za.
           assign h-acr783za = ?.
        end.

        if can-find(tt_log_erro) then do:
           empty temp-table RowErrors no-error.
           for each tt_log_erro:
               create RowErrors.
               assign RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                      RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                      RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                      RowErrors.ErrorSubType     = "ERROR":U.
           end.
    
           if can-find (first RowErrors 
                        where RowErrors.ErrorSubType = "ERROR":U) then do:
              {method/showmessage.i1}
              {method/showmessage.i2 &Modal="YES"}
              undo, return "ADM-ERROR":U.
           end.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Gr-Cli gr-cli.cod-gr-cli '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

    /* Integraá∆o EAI ->> Sender de Grupo Cliente */
    &if "{&bf_dis_versao_ems}" >= "2.04":U &then
    
    if  v_log_eai_habilit then
        assign i-cod-gr-cli = gr-cli.cod-gr-cli
               c-descricao  = gr-cli.descricao.
    &endif
    /* Fim Integraá∆o EAI ->> Sender de Grupo Cliente */

    {cdp/cd0002i1.i1 gr-cli "no"} /* Integraá∆o EMS 2.04 x Magnus I.01 */

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0701-crm) THEN
          RUN integracoes/adapters/emstocrm/cd0701-crm.p PERSISTENT SET h-cd0701-crm.
        
        RUN deleteFromCRM IN h-cd0701-crm (INPUT gr-cli.cod-gr-cli,
                                           OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0701-crm.
    END.


    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    {cdp/cd0002i1.i1 gr-cli "yes"} /* Integraá∆o EMS 2.04 x Magnus I.01 */

    /* Integraá∆o EAI ->> Sender de Grupo Cliente */
    &if "{&bf_dis_versao_ems}" >= "2.04":U &then
    
    if  v_log_eai_habilit then do:

        if  not valid-handle(h-axsvd008) then
            run adapters/xml/vd2/axsvd008.p persistent set h-axsvd008.

        if  avail gr-cli then
            run piTransDelete in h-axsvd008 (input i-cod-gr-cli,
                                             input c-descricao, 
                                             output table tt_log_erro).
        empty temp-table RowErrors no-error.

        for each tt_log_erro:

            create RowErrors.
            assign RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                   RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.ErrorSubType     = "ERROR":U.
        end.

        if  can-find (first RowErrors 
                          where RowErrors.ErrorSubType = "ERROR":U) then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            undo, return "ADM-ERROR":U.
        end.

        if  valid-handle(h-axsvd008) then do:

            delete procedure h-axsvd008.
            assign h-axsvd008 = ?.
        end.

        if  valid-handle(hShowMsg) then do:
            {method/showmessage.i3}
        end.
    end.

    &endif
    /* Fim Integraá∆o EAI ->> Sender de Grupo Cliente */

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

  if  avail gr-cli then 
      assign gr-cli.descricao:sensitive in frame {&FRAME-NAME} = no
             l-modifica = no.

  /* Dispatch standard ADM method.   */

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

  if  avail gr-cli then
      assign cb-natureza:screen-value in frame {&frame-name} = {adinc/i03ad098.i 04 gr-cli.natureza}.
  else
      assign cb-natureza:screen-value in frame {&frame-name} = {adinc/i03ad098.i 04 01}.

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

    if  return-value = 'yes':U then 
        assign l-modifica = no.
    else      
        assign gr-cli.descricao:sensitive in frame {&FRAME-NAME} = yes
               l-modifica = yes.


    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    run pi-passa-modalidade in h_v03ad129 (output c-modalidade-ant).

    assign i-modalidade-ant = {adinc/i03ad209.i 06 c-modalidade-ant}.

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    /*CHAMADA UPC*/
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "after-enable-fields",
                                      INPUT "VIEWER",             
                                      INPUT THIS-PROCEDURE,       
                                      INPUT FRAME {&FRAME-NAME}:HANDLE,
                                      INPUT "gr-cli",                  
                                      INPUT ROWID(gr-cli)).            
    END.
    /*FIM CHAMADA UPC*/ 


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

  {utp~/ut-field.i mgadm gr-cli natureza 01}
  assign cb-natureza:label      in frame {&frame-name} = trim(return-value)
  .
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {adinc/i03ad098.i 03}.
      RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
      ASSIGN cb-natureza:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
  &else
      ASSIGN cb-natureza:list-items in frame {&frame-name} = {adinc/i03ad098.i 03}.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  if avail gr-cli then 
     assign gr-gr-cli = rowid(gr-cli).

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

    {cdp/cd0003i1.i gr-cli cdp/cd0701i1.p "l-mostra-erro-mg"}

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
         create tt-gr-cli-aux.
         buffer-copy gr-cli to tt-gr-cli-aux.
         create tt-dados-env.                  
         assign tt-dados-env.num-sequencia  = i-seq 
                tt-dados-env.cod-tipo-reg   = 79
                tt-dados-env.ind-tipo-movto = i-tipo-movto
                tt-dados-env.identif-msg    = string(gr-cli.cod-gr-cli).
         raw-transfer tt-gr-cli-aux to tt-dados-env.conteudo-msg.                                    
         assign i-seq = i-seq + 1.                                     
     end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-gr-cli-mg V-table-Win 
PROCEDURE pi-cria-tt-gr-cli-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        def input param p-ind-tipo-movto as int no-undo.
        def input param p-atualiza       as log no-undo.

        for each tt-gr-cli-mg:
            delete tt-gr-cli-mg.
        end.

        create tt-gr-cli-mg.
        assign tt-gr-cli-mg.ind-tipo-movto = p-ind-tipo-movto
               tt-gr-cli-mg.l-atualiza     = p-atualiza.

        /* Campos Iguais */
        assign tt-gr-cli-mg.cod-gr-cli      = gr-cli.cod-gr-cli
               tt-gr-cli-mg.descricao       = fn-free-accent(gr-cli.descricao)
               tt-gr-cli-mg.cod-transp      = gr-cli.cod-transp
               tt-gr-cli-mg.linha-produt    = gr-cli.linha-produt
               tt-gr-cli-mg.atividade       = gr-cli.atividade
               tt-gr-cli-mg.cod-rep         = gr-cli.cod-rep
               tt-gr-cli-mg.categoria       = gr-cli.categoria
               tt-gr-cli-mg.bonificacao     = gr-cli.bonificacao
               tt-gr-cli-mg.istr            = gr-cli.istr
               tt-gr-cli-mg.lim-credito     = gr-cli.lim-credito
               tt-gr-cli-mg.dt-lim-cred     = gr-cli.dt-lim-cred
               tt-gr-cli-mg.perc-fat-ped    = gr-cli.perc-fat-ped
               tt-gr-cli-mg.portador        = gr-cli.portador
               tt-gr-cli-mg.ind-fat-par     = gr-cli.ind-fat-par
               tt-gr-cli-mg.per-minfat      = gr-cli.per-minfat
               tt-gr-cli-mg.ind-apr-cred    = gr-cli.ind-apr-cred
               tt-gr-cli-mg.per-max-canc    = gr-cli.per-max-canc
               tt-gr-cli-mg.nr-tabpre       = gr-cli.nr-tabpre
               tt-gr-cli-mg.user-libcre     = gr-cli.user-libcre
               tt-gr-cli-mg.nr-mesina       = gr-cli.nr-mesina
               tt-gr-cli-mg.nr-peratr       = gr-cli.nr-peratr
               tt-gr-cli-mg.ind-moeda-tit   = gr-cli.ind-moeda-tit
               tt-gr-cli-mg.permissao       = gr-cli.permissao
               tt-gr-cli-mg.i-exporta       = rs-op-exporta.

        /* Campos Diferentes */
        assign tt-gr-cli-mg.cond-pagto      = gr-cli.cod-cond-pag
               tt-gr-cli-mg.int-1           = gr-cli.tp-rec-desp
               tt-gr-cli-mg.int-2           = gr-cli.atraso-max.

        if gr-cli.gera-difer = 1 then
           assign tt-gr-cli-mg.gera-difer = 0.
        if gr-cli.gera-difer = 2 then
           assign tt-gr-cli-mg.gera-difer = 1.

        if gr-cli.natureza = 1 then
           assign tt-gr-cli-mg.natureza = "F".
        if gr-cli.natureza = 2 then
           assign tt-gr-cli-mg.natureza = "J".
        if gr-cli.natureza = 3 then
           assign tt-gr-cli-mg.natureza = "E".
        if gr-cli.natureza = 4 then /* conforme obs. engenharia repres */
           assign tt-gr-cli-mg.natureza = "E".

        case gr-cli.modalidade:
             when 1 then assign tt-gr-cli-mg.modalidade = 0.
             when 2 then assign tt-gr-cli-mg.modalidade = 1.
             when 3 then assign tt-gr-cli-mg.modalidade = 2.
             when 4 then assign tt-gr-cli-mg.modalidade = 3.
             when 5 then assign tt-gr-cli-mg.modalidade = 4.
             when 6 then assign tt-gr-cli-mg.modalidade = 5.
             when 7 then assign tt-gr-cli-mg.modalidade = 6.
        end case.

        case gr-cli.ind-aval[1]:
             when 1 then assign tt-gr-cli-mg.ind-aval[1] = 0.
             when 2 then assign tt-gr-cli-mg.ind-aval[1] = 1.
             when 3 then assign tt-gr-cli-mg.ind-aval[1] = 2.
        end case.
        case gr-cli.ind-aval[2]:
             when 1 then assign tt-gr-cli-mg.ind-aval[2] = 0.
             when 2 then assign tt-gr-cli-mg.ind-aval[2] = 1.
             when 3 then assign tt-gr-cli-mg.ind-aval[2] = 2.
        end case.
        case gr-cli.ind-aval[3]:
             when 1 then assign tt-gr-cli-mg.ind-aval[3] = 0.
             when 2 then assign tt-gr-cli-mg.ind-aval[3] = 1.
             when 3 then assign tt-gr-cli-mg.ind-aval[3] = 2.
        end case.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-grupo-cli V-table-Win 
PROCEDURE pi-exporta-grupo-cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Aguarde,_exportando... *}
    RUN pi-inicializar IN h-acomp ( Return-value ).

    DO  ON STOP UNDO, LEAVE:
        /** exporta conforme parametro **/
        {cdp/cd0701.i1 YES h-acomp}
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

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

    {cdp/cd0004i1.i "CD0701" "GR-CLI" gr-cli.cod-gr-cli tt-gr-cli-mg.ind-tipo-movto tt-erros-mg.help-msg}

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

    def input param p-handle-mg as handle no-undo.

    assign h_v03ad129 = p-handle-mg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-gr-cli-mg V-table-Win 
PROCEDURE pi-valida-gr-cli-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.

    if gr-cli.modalidade = 8 then
       assign c-modalidade-mg = "Modalidade Cheque".
    if gr-cli.modalidade = 9 then
       assign c-modalidade-mg = "Modalidade Nota Promiss¢ria".

    if gr-cli.modalidade = 8
    or gr-cli.modalidade = 9 then do:

       if p-ind-tipo-movto = 3 then 
          assign p-ind-tipo-movto = 0.

       if p-ind-tipo-movto = 1 then do:
            run utp/ut-msgs.p (input "show",
                               input 19446,
                               input c-modalidade-mg).
            assign p-ind-tipo-movto = 0.
       end.

       if p-ind-tipo-movto = 2 then do:
          if gr-cli.modalidade <> i-modalidade-ant then do:
             if (gr-cli.modalidade = 8 and i-modalidade-ant = 9)
             or (gr-cli.modalidade = 9 and i-modalidade-ant = 8) then do:
                run utp/ut-msgs.p (input "show",
                                   input 19446,
                                   input c-modalidade-mg).
                assign p-ind-tipo-movto = 3.
             end.
             else do:
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao002 = {adinc/i03ad209.i 4 i-modalidade-ant}.
                    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                        INPUT "",
                                        INPUT "").
                    ASSIGN  c-modalidade-ant = RETURN-VALUE.
                &else
                    ASSIGN c-modalidade-ant = {adinc/i03ad209.i 4 i-modalidade-ant}.
                &endif
                run utp/ut-msgs.p (input "show",
                                   input 19485,
                                   input c-modalidade-mg + "~~" + c-modalidade-ant).
                if return-value = "yes" then
                   assign p-ind-tipo-movto = 3.
                else
                   return "NOK".
             end.
          end.
          else
             assign p-ind-tipo-movto = 0.
       end.
    end.

    if  p-ind-tipo-movto =  1 or 
        p-ind-tipo-movto = 2  then do:
        for each tt-erros-mg.
            delete tt-erros-mg.
        end.

        run pi-retorna-nr-tabpre in h_v03ad129 (output c-nr-tabpre).
        if  c-nr-tabpre <> "" then do:
            /*---- Conecta RPC do Magnus ----*/
            {cdp/cd0007i1.i "input  c-nr-tabpre, output table tt-erros-mg"
                            "cdp/cdz0003.p"
                            "testa-tb-preco"
                            "yes"}
            /**** Tratamento para que o Erro n∆o seja exibido duas vezes ****/                

            assign l-mostra-erro-mg = yes.                            
            find first tt-erros-mg no-error.
            if  avail tt-erros-mg then do:
                assign l-mostra-erro-mg = no.
                RETURN "NOK":U.
            end.
        end.
    end.
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
  {src/adm/template/snd-list.i "gr-cli"}

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


