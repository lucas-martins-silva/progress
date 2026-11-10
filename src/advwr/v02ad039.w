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
{include/i-prgvrs.i V02AD039 2.00.00.024 } /*** "010024" 06/11/2023 16:48:34  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02ad039 MUT}
&ENDIF

{fch/fchdis/fchdis0004.i3}/* temp-table ttOrdeSpecialPaymentCondition */

DEFINE TEMP-TABLE tt-simula-cond-pagto NO-UNDO LIKE ttOrdeSpecialPaymentCondition
    FIELD calc-data-pagto   AS LOGICAL
    FIELD calc-nr-dias-venc AS LOGICAL
    FIELD calc-perc-pagto   AS LOGICAL
    FIELD calc-vl-pagto     AS LOGICAL.

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
/* Integraá∆o EAI */                                           
def new global shared var v-prog-version    as char    no-undo.
def new global shared var v-prog-obj        as char    no-undo.
def new global shared var v_log_eai_habilit as logical no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var l-vendor as log no-undo.
def var l-erro   as log no-undo.
def var l-eai    as log init no no-undo.
def var h-ut-integration as handle                  no-undo.
def var cAction          as character               no-undo.

def var c-acao   as char no-undo.

DEF VAR hShowMsg         AS HANDLE NO-UNDO.
DEF VAR c-old-descricao  AS CHAR   NO-UNDO.

/**/
DEF VAR h_folder       AS HANDLE   NO-UNDO.
DEF VAR l-data-fixa    AS LOGICAL  NO-UNDO.
DEF VAR h-handle-atual AS HANDLE   NO-UNDO.
DEF VAR h_v03ad039     AS HANDLE   NO-UNDO.
/**/

DEFINE TEMP-TABLE tt-cond-pag NO-UNDO LIKE cond-pagto.

{cdp/cd7300.i1}  /* Multiplanta */
{cdp/cdapi217.i}

{bhp/bh9999.i1}

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var i-int-mg         as inte no-undo.

{cdp/cd0404i1.i} /* Definiá∆o da temp-table tt-cond-pagto-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

DEFINE TEMP-TABLE RowErrorsEai NO-UNDO
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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cond-pagto
&Scoped-define FIRST-EXTERNAL-TABLE cond-pagto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cond-pagto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cond-pagto.descricao 
&Scoped-define ENABLED-TABLES cond-pagto
&Scoped-define FIRST-ENABLED-TABLE cond-pagto
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS cond-pagto.cod-cond-pag ~
cond-pagto.descricao cond-pagto.log-1 
&Scoped-define DISPLAYED-TABLES cond-pagto
&Scoped-define FIRST-DISPLAYED-TABLE cond-pagto


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cond-pagto.cod-cond-pag 

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cond-pagto.cod-cond-pag AT ROW 1.17 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cond-pagto.descricao AT ROW 1.17 COL 41.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     cond-pagto.log-1
          AT ROW 1.21 COL 76.57
          LABEL "Data Fixa"
          VIEW-AS TOGGLE-BOX
          SIZE 12.43 BY .83
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cond-pagto
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
         HEIGHT             = 1.33
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{method/dbotterr.i}
{include/boerrtab.i}
{include/i_prdvers.i}

DEFINE VARIABLE h-cd0404-crm AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

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

/* SETTINGS FOR FILL-IN cond-pagto.cod-cond-pag IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX cond-pagto.log-1 IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN cond-pagto.log-1:HIDDEN IN FRAME f-main           = TRUE.


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

&Scoped-define SELF-NAME cond-pagto.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.cod-cond-pag V-table-Win
ON F5 OF cond-pagto.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=cond-pagto.cod-cond-pag
                     &campozoom=cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cond-pagto.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.descricao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.descricao V-table-Win
ON LEAVE OF cond-pagto.descricao IN FRAME f-main /* Descriá∆o */
DO:
   if   cond-pagto.descricao:screen-value in frame {&frame-name} = "" then do:
        run utp/ut-msgs.p (input "show":U, input 2838, input return-value).
        return no-apply.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.log-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.log-1 V-table-Win
ON VALUE-CHANGED OF cond-pagto.log-1 IN FRAME f-main /* Data Fixa */
DO:
    IF NOT INPUT FRAME {&FRAME-NAME} cond-pagto.log-1 THEN DO:
        RUN select-page         IN h-handle-atual (INPUT 1).
        RUN enable-folder-page  IN h_folder (INPUT 2).
        RUN disable-folder-page IN h_folder (INPUT 3).
    END.
    ELSE DO:
        RUN select-page         IN h-handle-atual (INPUT 1).
        RUN disable-folder-page IN h_folder (INPUT 2).
        RUN enable-folder-page  IN h_folder (INPUT 3).
    END.
    IF adm-new-record THEN
       RUN pi-habilita-campos  IN h_v03ad039.

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

  if cond-pagto.cod-cond-pag:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  /**/
  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
  /** Verifica se existe a funá∆o e se est† ativa **/
  IF CAN-FIND(funcao NO-LOCK WHERE
              funcao.cd-funcao = "spp-data-fixa" AND
              funcao.ativo)                      THEN DO:
      ASSIGN cond-pagto.log-1:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  END.
  &ENDIF
  /**/

  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

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
  {src/adm/template/row-list.i "cond-pagto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cond-pagto"}

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

  /**/
  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
  /** Verifica se existe a funá∆o e se est† ativa **/
  IF CAN-FIND(funcao NO-LOCK WHERE
              funcao.cd-funcao = "spp-data-fixa" AND
              funcao.ativo)                      THEN DO:

      IF adm-new-record THEN DO:
          ASSIGN cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME} = NO.
          APPLY 'VALUE-CHANGED' TO cond-pagto.log-1 IN FRAME {&FRAME-NAME}.
      END.
  END.
  &ENDIF
  /**/

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

 DEFINE VARIABLE hPdapi700a               AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hPdapi700b               AS HANDLE      NO-UNDO.
 DEFINE VARIABLE bCondicaoValidaMaisNegoc AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE h-acomp                  AS HANDLE      NO-UNDO.
 
  {include/i-valid.i}
 /**/
 &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
 /** Verifica se existe a funá∆o e se est† ativa **/
 IF CAN-FIND(funcao NO-LOCK WHERE
             funcao.cd-funcao = "spp-data-fixa" AND
             funcao.ativo)                      THEN DO:
     ASSIGN l-data-fixa = INPUT FRAME {&FRAME-NAME} cond-pagto.log-1.
 END.
 &ENDIF
 /**/

 IF NOT adm-new-record THEN
   ASSIGN c-old-descricao = cond-pagto.descricao.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
  IF RETURN-VALUE = 'ADM-ERROR':U THEN
      RETURN 'ADM-ERROR':U.

  {cdp/cd0002i1.i cond-pagto} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

/********************Multiplanta***********************/
  assign c-transacao = "ADM004".
  {cdp/cd7300.i5 "001" c-transacao}
  if cond-pagto.cod-cond-pag:sensitive in frame {&frame-name}  
     then assign ind-tipo-movto = 1.
     else assign ind-tipo-movto = 2.   
  run pi-cria-tt-dados (input ind-tipo-movto).
   {cdp/cd7300.i6 "001" c-transacao}

/*****************Fim Multiplanta**********************/


    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0404-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0404-crm.p PERSISTENT SET h-cd0404-crm.
      
        RUN sendToCRM IN h-cd0404-crm (INPUT cond-pagto.cod-cond-pag,
                                       OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0404-crm.
    END.

/*************** Integraá∆o EAI ************/
IF adm-new-record THEN
     ASSIGN c-acao = "add":U.
 ELSE
     ASSIGN c-acao = "upd":U.

      &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
         IF v_log_eai_habilit THEN DO:

         if can-find(first tt-cond-pag) then
            empty temp-table tt-cond-pag no-error.

              CREATE tt-cond-pag.
              BUFFER-COPY cond-pagto TO tt-cond-pag.
              RUN adapters/xml/vd2/axsvd001.p (INPUT c-acao,
                                                INPUT v-prog-obj,
                                                INPUT v-prog-version,
                                                INPUT TABLE tt-cond-pag,
                                                OUTPUT TABLE RowErrors).

          IF CAN-FIND(first RowErrors) THEN DO:
                  {method/showmessage.i1}
                  /*Transfere temp-table RowErrors para a tela de mensagens de erros*/
                  {method/showmessage.i2 &Modal="Yes"}
              IF NOT adm-new-record THEN DO:
                     ASSIGN cond-pagto.descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-old-descricao.
                     STOP.
              END.
              ELSE STOP.             
          END.

       END.

     &ENDIF.

     /**/
     /** Verifica se existe a funá∆o e se est† ativa **/
     IF CAN-FIND(funcao NO-LOCK WHERE
                 funcao.cd-funcao = "spp-data-fixa" AND
                 funcao.ativo)                      THEN DO:

         &IF "{&bf_dis_versao_ems}" >= "2.04"  AND
             "{&bf_dis_versao_ems}" <  "2.06" &THEN
         ASSIGN cond-pagto.log-1                                = l-data-fixa
                cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME} = cond-pagto.log-1.
         &ENDIF

         &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
         ASSIGN cond-pagto.log-dat-fix                          = l-data-fixa
                cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME} = cond-pagto.log-dat-fix.
         &ENDIF
     END.
     /**/
	 
	 

   /********** Fim Integraá∆o EAI *******/
   
   if adm-new-record then
     assign cAction = "CREATE".
   else
     assign cAction = "UPDATE".

   if not valid-handle(h-ut-integration) then
     run utp/ut-integration.p persistent set h-ut-integration.  
  
   empty temp-table RowErrorsEAI.    

   run eai-integration in h-ut-integration (input "PaymentCondition", /* Nome da transaá∆o     */
                                            input rowid(cond-pagto),         /* Registro da transaá∆o */
                                            input cAction,                   /* Evento da transaá∆o   */
                                            output table RowErrorsEAI).      /* Erros da transaá∆o    */ 
                                                                     
   if can-find(first RowErrorsEAI) then do:
      
     for each RowErrorsEAI:
         create RowErrors.
         buffer-copy RowErrorsEAI to RowErrors.
     end. 

     for each RowErrors:
         run utp/ut-msgs.p (input "show":U,
                            input RowErrors.ErrorNumber,
                            input RowErrors.ErrorParameters).
     end.
       
     return "ADM-ERROR":U.

   end. 
   
   if valid-handle(h-ut-integration) then do:
	  delete procedure h-ut-integration.
	  assign h-ut-integration = ?.
   end.

   IF  cond-pagto.log-cond-pagto-mais-negoc THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

        {utp/ut-liter.i "Integraá∆o_Mais_Neg¢cios"}
        RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

        {utp/ut-liter.i "Validando_condiá∆o_Mais_Neg¢cio"}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

        IF NOT VALID-HANDLE(hPdapi700a) THEN DO:
            RUN pdp/pdapi700a.p PERSISTENT SET hPdapi700a.
        END.

        IF NOT VALID-HANDLE(hPdapi700b) THEN DO:
            RUN pdp/pdapi700b.p PERSISTENT SET hPdapi700b.
        END.

        RUN pi-gera-somente-prazos-cond-pagto-mais-negoc IN hPdapi700b (INPUT cond-pagto.cod-cond-pag, OUTPUT TABLE tt-simula-cond-pagto).

        RUN valida-condicao-pagamento-mais-negoc IN hPdapi700a (INPUT cond-pagto.num-parcelas,
                                                                INPUT TABLE tt-simula-cond-pagto,
                                                                OUTPUT bCondicaoValidaMaisNegoc).

        RUN pi-finalizar IN h-acomp.
        DELETE PROCEDURE h-acomp NO-ERROR.

        IF bCondicaoValidaMaisNegoc = FALSE THEN DO:              
            run utp/ut-msgs.p (input "show":U, input 57679, input '').
            UNDO, RETURN "ADM-ERROR":U.
        END.
        
        IF VALID-HANDLE(hPdapi700a) THEN DO:
            DELETE PROCEDURE hPdapi700a.
        END.

        IF VALID-HANDLE(hPdapi700b) THEN DO:
            DELETE PROCEDURE hPdapi700b.
        END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-tabela     AS CHAR NO-UNDO.
    
    if can-find (first distrib-emit-estab where 
                       distrib-emit-estab.cod-cond-pag = cond-pagto.cod-cond-pag) then do:

       {utp/ut-table.i mgdis cond-pagto 1}
       assign c-tabela = return-value.
       {utp/ut-table.i mgdis distrib-emit-estab 1}
       run utp/ut-msgs.p ('show',
                           5,
                           c-tabela + '~~' + trim(return-value)).
       return 'ADM-ERROR'.                    
   end.

    if can-find (first canal-clien-estab where 
                       canal-clien-estab.cod-cond-pag = cond-pagto.cod-cond-pag) then do:

       {utp/ut-table.i mgdis cond-pagto 1}
       assign c-tabela = return-value.
       {utp/ut-table.i mgdis canal-clien-estab 1}
       run utp/ut-msgs.p ('show',
                           5,
                           c-tabela + '~~' + trim(return-value)).
       return 'ADM-ERROR'.                    
   end.
   
/* EAI */
&IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
 IF v_log_eai_habilit THEN DO:

  assign l-eai = yes.
  if can-find(first tt-cond-pag) then
     empty temp-table tt-cond-pag no-error.

    CREATE tt-cond-pag.
    BUFFER-COPY cond-pagto TO tt-cond-pag.

 END.
 ELSE
     assign l-eai = no.
&ENDIF

ASSIGN   l-vendor = no
         l-erro     = no.

  find first param-global no-lock no-error.       

  if param-global.modulo-05 = yes then    
      assign l-vendor = yes.

  if l-vendor then do:
    run pdp/pd2060.p (input input frame {&frame-name} cond-pagto.cod-cond-pag,
                     output l-erro).
  end.

  if l-erro = no then do:
/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Cond-Pagto cond-pagto.cod-cond-pag '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0404-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0404-crm.p PERSISTENT SET h-cd0404-crm.
      
        RUN deleteFromCRM IN h-cd0404-crm (INPUT cond-pagto.cod-cond-pag,
                                           OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0404-crm.
    END.

 {cdp/cd0002i1.i1 cond-pagto "no"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

 
 if not valid-handle(h-ut-integration) then
     run utp/ut-integration.p persistent set h-ut-integration.  
  
   empty temp-table RowErrorsEAI.    

   run eai-integration in h-ut-integration (input "PaymentCondition", /* Nome da transaá∆o     */
                                            input rowid(cond-pagto),         /* Registro da transaá∆o */
                                            input "DELETE",                   /* Evento da transaá∆o   */
                                            output table RowErrorsEAI).      /* Erros da transaá∆o    */ 
                                                                     
   if can-find(first RowErrorsEAI) then do:
      
     for each RowErrorsEAI:
         create RowErrors.
         buffer-copy RowErrorsEAI to RowErrors.
     end. 

     for each RowErrors:
         run utp/ut-msgs.p (input "show":U,
                            input RowErrors.ErrorNumber,
                            input RowErrors.ErrorParameters).
     end.
       
     return "ADM-ERROR":U.

   end. 
   
   if valid-handle(h-ut-integration) then do:
	  delete procedure h-ut-integration.
	  assign h-ut-integration = ?.
   end.
     DO TRANS:
         RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).
         if  return-value = 'ADM-ERROR':U then 
             return 'ADM-ERROR':U.
            
/*************** Integraá∆o EAI ***************/
         IF l-eai THEN DO:
         
            RUN adapters/xml/vd2/axsvd001.p (INPUT "del":U,
                                             INPUT v-prog-obj,
                                             INPUT v-prog-version,
                                             INPUT TABLE tt-cond-pag,
                                             OUTPUT TABLE RowErrors).
      
            IF CAN-FIND(first RowErrors) THEN DO:
                       {method/showmessage.i1}
                       /*Transfere temp-table RowErrors para a tela de mensagens de erros*/
                       {method/showmessage.i2 &Modal="Yes"}
                       UNDO, return 'ADM-ERROR':U.
            END.
         END.
     END.

  {cdp/cd0002i1.i1 cond-pagto "yes"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

  END.

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

  /**/
  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
  /** Verifica se existe a funá∆o e se est† ativa **/
  IF CAN-FIND(funcao NO-LOCK WHERE
              funcao.cd-funcao = "spp-data-fixa" AND
              funcao.ativo)                      THEN DO:
      DISABLE cond-pagto.log-1 with frame {&frame-name}.
  END.
  &ENDIF
  /**/

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

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
    /** Verifica se existe a funá∆o e se est† ativa **/
    IF CAN-FIND(funcao NO-LOCK WHERE
                funcao.cd-funcao = "spp-data-fixa" AND
                funcao.ativo)                      THEN DO:

        IF AVAIL cond-pagto THEN DO:
            &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                ASSIGN cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME} = cond-pagto.log-dat-fix.
            &ELSE
                ASSIGN cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME} = cond-pagto.log-1.
            &ENDIF
        END.

        IF VALID-HANDLE (h_folder) THEN DO:
            APPLY 'VALUE-CHANGED' TO cond-pagto.log-1 IN FRAME {&FRAME-NAME}.
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  /**/
  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
  /** Verifica se existe a funá∆o e se est† ativa **/
  IF CAN-FIND(funcao NO-LOCK WHERE
              funcao.cd-funcao = "spp-data-fixa" AND
              funcao.ativo)                      THEN DO:

      IF adm-new-record THEN
          ENABLE cond-pagto.log-1 WITH FRAME {&FRAME-NAME}.
  END.
  &ENDIF
  /**/

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

    {cdp/cd0003i1.i cond-pagto cdp/cd0404i1.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-cond-pagto-mg V-table-Win 
PROCEDURE pi-cria-tt-cond-pagto-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-cond-pagto-mg:
        delete tt-cond-pagto-mg.
    end.

    create tt-cond-pagto-mg.
    assign tt-cond-pagto-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-cond-pagto-mg.l-atualiza     = p-atualiza.

    /* Campos Iguais */
    assign tt-cond-pagto-mg.cod-cond-pag    = cond-pagto.cod-cond-pag
           tt-cond-pagto-mg.cod-vencto      = cond-pagto.cod-vencto
           tt-cond-pagto-mg.dia-mes-base    = cond-pagto.dia-mes-base
           tt-cond-pagto-mg.dia-mes-venc    = cond-pagto.dia-mes-venc
           tt-cond-pagto-mg.num-parcelas    = cond-pagto.num-parcelas
           tt-cond-pagto-mg.per-des-pgan    = cond-pagto.per-des-pgan
           tt-cond-pagto-mg.nr-dias-ante    = cond-pagto.nr-dias-ante
           tt-cond-pagto-mg.nr-dupdes       = cond-pagto.nr-dupdes
           tt-cond-pagto-mg.descricao       = cond-pagto.descricao
           tt-cond-pagto-mg.nr-tab-finan    = cond-pagto.nr-tab-finan
           tt-cond-pagto-mg.nr-ind-finan    = cond-pagto.nr-ind-finan
           tt-cond-pagto-mg.log-1           = &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN cond-pagto.log-dat-fix
                                              &ELSE cond-pagto.log-1 &ENDIF .

    do i-int-mg = 1 to 12:
       assign tt-cond-pagto-mg.prazos[i-int-mg]      = cond-pagto.prazos[i-int-mg]
              tt-cond-pagto-mg.cod-ven-par[i-int-mg] = cond-pagto.cod-ven-par[i-int-mg]
              tt-cond-pagto-mg.per-pg-dup[i-int-mg]  = cond-pagto.per-pg-dup[i-int-mg].
    end.

    /* Campos com Valores Diferentes */
    if cond-pagto.dia-sem-base = 8 then
       assign tt-cond-pagto-mg.dia-sem-base   = 0.
    else assign tt-cond-pagto-mg.dia-sem-base = cond-pagto.dia-sem-base.
    if cond-pagto.dia-sem-venc = 8 then
       assign tt-cond-pagto-mg.dia-sem-venc   = 0.
    else assign tt-cond-pagto-mg.dia-sem-venc = cond-pagto.dia-sem-venc.

    assign tt-cond-pagto-mg.dec-1           = cond-pagto.dec-1
           tt-cond-pagto-mg.dec-2           = cond-pagto.dec-2
           tt-cond-pagto-mg.int-1           = cond-pagto.int-1
           tt-cond-pagto-mg.int-2           = cond-pagto.int-2
           tt-cond-pagto-mg.char-1          = cond-pagto.char-1
           tt-cond-pagto-mg.char-2          = cond-pagto.char-2.

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
    create tt-cond-pagto-aux.
    buffer-copy cond-pagto to tt-cond-pagto-aux.    
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 31
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(cond-pagto.cod-cond-pag).
    raw-transfer tt-cond-pagto-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.
end.
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

    {cdp/cd0004i1.i "CD0404" "COND-PAGTO" tt-cond-pagto-mg.cod-cond-pag tt-cond-pagto-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-screen-value V-table-Win 
PROCEDURE pi-get-screen-value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-data-fixa AS LOGICAL    NO-UNDO.

    ASSIGN p-data-fixa = cond-pagto.log-1:CHECKED IN FRAME {&FRAME-NAME}.

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
DEFINE INPUT PARAMETER p-folder   AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER p-v03ad039 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER p-handle   AS HANDLE     NO-UNDO.

    ASSIGN h_folder       = p-folder
           h_v03ad039     = p-v03ad039
           h-handle-atual = p-handle.

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
    IF CAN-FIND(funcao NO-LOCK WHERE
                funcao.cd-funcao = "spp-data-fixa" AND
                funcao.ativo)                      THEN DO:

        IF VALID-HANDLE (h_folder) THEN DO:
            APPLY 'VALUE-CHANGED' TO cond-pagto.log-1 IN FRAME {&FRAME-NAME}.
        END.
    END.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cond-pagto-mg V-table-Win 
PROCEDURE pi-valida-cond-pagto-mg :
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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

    if int(cond-pagto.cod-cond-pag:screen-value) = 0 then do:
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      run utp/ut-msgs.p (input "show":U, input 3642, input " ").
      return 'ADM-ERROR':U.
    end.      

   find cond-pagto where cond-pagto.cod-cond-pag = int(cond-pagto.cod-cond-pag:screen-value) no-lock no-error.
   if avail cond-pagto and
            cond-pagto.cod-cond-pag:sensitive in frame {&frame-name} = yes then do:
     if cond-pagto.cod-cond-pag:sensitive in frame {&frame-name} = yes then do:
        {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
        {utp/ut-field.i mgadm cond-pagto cod-cond-pag 1}
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        return 'ADM-ERROR':U.
     end.
   end.     

   if   cond-pagto.descricao:screen-value in frame {&frame-name} = "" then do:
        run utp/ut-msgs.p (input "show":U, input 2838, input return-value).
        apply 'Entry':U to cond-pagto.descricao in frame f-main.       
        return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "cond-pagto"}

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

