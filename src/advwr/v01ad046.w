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
{include/i-prgvrs.i V01AD046 2.00.00.014 } /*** "010014" 05/02/2026 08:33:19 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad046 MUT}
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

def new global shared var gr-transporte as rowid no-undo.
define new global shared var gr-cont-tran as rowid no-undo.

def buffer b-contato for cont-tran.
def var l-posiciona as logical.

define variable c-cod-transp like cont-tran.cod-transp.

{cdp/cdcfgdis.i}
&IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
    DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
    DEFINE VARIABLE h-axsvd007 AS HANDLE     NO-UNDO.
    DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?.

    DEF VAR hShowMsg   AS HANDLE NO-UNDO.
&ENDIF
{include/i_prdvers.i}
{include/i_fnctrad.i}
DEFINE VARIABLE h-cd0402-crm    AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11       AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

{method/dbotterr.i}   /** temp-table RowErrors **/

{cdp/cdcfgfin.i} /* Defini‡Æo de Fun‡äes */
{include/i-freeac.i}
/*-------------- Integra‡Æo Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var c-chave-mg       as char no-undo.

{cdp/cd0402i2.i} /* Defini‡Æo da temp-table tt-transporte-mg */
{cdp/cd0001i1.i} /* Defini‡Æo da temp-table de erros tt-erro-mg */
/****************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cont-tran
&Scoped-define FIRST-EXTERNAL-TABLE cont-tran


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cont-tran.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cont-tran.nome cont-tran.cargo cont-tran.area ~
cont-tran.telefone cont-tran.ramal cont-tran.telefax cont-tran.ramal-fax ~
cont-tran.e-mail cont-tran.observacao 
&Scoped-define ENABLED-TABLES cont-tran
&Scoped-define FIRST-ENABLED-TABLE cont-tran
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-9  
&Scoped-Define DISPLAYED-FIELDS cont-tran.cod-transp cont-tran.sequencia ~
cont-tran.nome cont-tran.cargo cont-tran.area cont-tran.telefone ~
cont-tran.ramal cont-tran.telefax cont-tran.ramal-fax cont-tran.e-mail ~
cont-tran.observacao 
&Scoped-define DISPLAYED-TABLES cont-tran
&Scoped-define FIRST-DISPLAYED-TABLE cont-tran
&Scoped-Define DISPLAYED-OBJECTS fi-nome cnpj-cpf-contato cb-aplicacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cont-tran.cod-transp cont-tran.sequencia ~
cb-aplicacao cnpj-cpf-contato 
&Scoped-define ADM-ASSIGN-FIELDS cb-aplicacao cnpj-cpf-contato 
&Scoped-define ADM-MODIFY-FIELDS cb-aplicacao cnpj-cpf-contato 

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
DEFINE VARIABLE cb-aplicacao AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Aplica‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21.43 BY 1 NO-UNDO.

/*Elton - NF 3.10*/
DEFINE VARIABLE cnpj-cpf-contato AS CHARACTER FORMAT "X(20)":U 
     LABEL "CNPJ / CPF" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-observacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 8.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cont-tran.cod-transp AT ROW 1.17 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-nome AT ROW 1.17 COL 31.86 COLON-ALIGNED NO-LABEL
     cont-tran.sequencia AT ROW 2.17 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cont-tran.nome AT ROW 3.54 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52.72 BY .88
     cont-tran.cargo AT ROW 4.54 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     cont-tran.area AT ROW 5.54 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     cont-tran.telefone AT ROW 6.54 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     cont-tran.ramal AT ROW 6.54 COL 66.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     cont-tran.telefax AT ROW 7.54 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     cont-tran.ramal-fax AT ROW 7.54 COL 66.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     cont-tran.e-mail AT ROW 8.5 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52.72 BY .88
     /*Elton - NF 3.10*/
     cnpj-cpf-contato AT ROW 9.5 COL 23.14 COLON-ALIGNED HELP
          "CNPJ / CPF Autorizado - NFe (autXML)"
     cb-aplicacao AT ROW 10.58 COL 23.14 COLON-ALIGNED HELP
          "Informe a aplica‡Æo do contato":U
     cont-tran.observacao AT ROW 12.75 COL 4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 84.29 BY 3
     fi-observacao AT ROW 12 COL 4 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.29 COL 1
     RECT-9 AT ROW 12.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cont-tran
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
         HEIGHT             = 15.25
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

/* SETTINGS FOR COMBO-BOX cb-aplicacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN cont-tran.cod-transp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-observacao IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN cont-tran.sequencia IN FRAME f-main
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

&Scoped-define SELF-NAME cont-tran.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-tran.cod-transp V-table-Win
ON F5 OF cont-tran.cod-transp IN FRAME f-main /* Transportador */
DO:
  {include/zoom.i &prog-zoom="adzoom/z01ad268.w"
                  &tabela=cont-tran
                  &atributo=cod-transp}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-tran.cod-transp V-table-Win
ON LEAVE OF cont-tran.cod-transp IN FRAME f-main /* Transportador */
DO:
  {include/leave.i &tabela=transporte 
                   &atributo-ref=nome
                   &variavel-ref=fi-nome
                   &where="transporte.cod-transp = input frame {&frame-name} cont-tran.cod-transp"}.

    find last b-contato
        where b-contato.cod-transp = input frame {&frame-name} cont-tran.cod-transp
              no-lock no-error.
    assign cont-tran.sequencia:screen-value = if avail b-contato 
                                              then string(b-contato.sequencia + 1)
                                              else "1".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-tran.cod-transp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cont-tran.cod-transp IN FRAME f-main /* Transportador */
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

  {utp/ut-rtlbl.i mgadm cont-tran observacao fi-observacao}

  if  cont-tran.cod-transp:load-mouse-pointer("image~\lupa.cur") then .

  {btb/btb008za.i0} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */

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
  {src/adm/template/row-list.i "cont-tran"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cont-tran"}

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

  IF  adm-new-record THEN
      ASSIGN cb-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = {ADINC/I01AD046.I 04 1}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

{utp/ut-field.i mgadm cont-tran observacao 1}
display return-value @ fi-observacao with frame {&frame-name}.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
    
    IF adm-new-record THEN
      ASSIGN cb-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = {ADINC/I01AD046.I 04 1}.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE BUFFER b-cont-tran FOR cont-tran.

    DO TRANS:

      /* Code placed here will execute PRIOR to standard behavior. */
      if  not frame {&frame-name}:validate() then
          return 'ADM-ERROR':U.
    
      /* Ponha aqui a valida‡Æo de chave duplicada */
      if  cont-tran.cod-transp:sensitive in frame {&frame-name}
      and can-find(cont-tran 
             where cont-tran.cod-transp = input frame {&frame-name} cont-tran.cod-transp
               and cont-tran.sequencia  = input frame {&frame-name} cont-tran.sequencia)
      then do:
          {utp/ut-table.i mgadm cont-tran 1}
          run utp/ut-msgs.p (input "show", input 1, input return-value).
          return "adm-error".
      end.
    
      if input frame {&frame-name} cont-tran.nome = " " then do:
       run utp/ut-msgs.p (input "show",
                          input 5142,
                          input " ").
       apply 'entry' to cont-tran.nome in frame {&frame-name}.
       return "adm-error".
      end.                    
    
      /* Ponha aqui as demais valida‡äes */
    
      /* VALIDACAO INFORMAR MAIS DE UM CONTATO PARA O MESMO     */
      /* EMITENTE COM A APLICA°€O IGUAL A "DESTINATARIO XML NFE */
      IF  cb-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = {adinc/i01ad046.i 04 2} THEN DO: /* = Destinatÿrio XML NF-e */
          IF  adm-new-record THEN
              FIND FIRST b-cont-tran NO-LOCK
                   WHERE b-cont-tran.cod-transp = INPUT FRAME {&FRAME-NAME} cont-tran.cod-transp
                     AND &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN 
                             b-cont-tran.cdn-aplic-contat
                         &ELSE  
                             b-cont-tran.int-1
                         &ENDIF                   = 2 NO-ERROR.
          ELSE
              FIND FIRST b-cont-tran NO-LOCK
                   WHERE b-cont-tran.cod-transp = INPUT FRAME {&FRAME-NAME} cont-tran.cod-transp
                     AND &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN 
                             b-cont-tran.cdn-aplic-contat
                         &ELSE  
                             b-cont-tran.int-1
                         &ENDIF                   = 2
                     AND ROWID(b-cont-tran)      <> ROWID(cont-tran) NO-ERROR.
      
          if  avail b-cont-tran then do:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-ja-existe-outro-co AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "J _existe_outro_contato_com_a_aplica‡Æo_informada" *}
              ASSIGN c-lbl-liter-ja-existe-outro-co = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-nao-pode-ser-infor AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "NÆo_pode_ser_informado_mais_de_um_contato_com_a_Aplica‡Æo_igual_a_""""Destinat rio_XML_NF-e""""" *}
              ASSIGN c-lbl-liter-nao-pode-ser-infor = TRIM(RETURN-VALUE).
              run utp/ut-msgs.p (input "show":U, 
                                 input 17006, 
                                 input c-lbl-liter-ja-existe-outro-co + '.' + "~~" +
                                       c-lbl-liter-nao-pode-ser-infor + '.').
      
              apply 'entry' to cb-aplicacao in frame {&FRAME-NAME}.
              return 'adm-error'.
          end.
      END.
      /* FIM - VALIDACAO */


      /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
    
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      if  return-value = 'ADM-ERROR':U THEN
          return 'ADM-ERROR':U.
    
      FIND CURRENT cont-tran EXCLUSIVE-LOCK NO-ERROR.
      &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN 
         ASSIGN cont-tran.cdn-aplic-contat = {adinc/i01ad046.i 06 cb-aplicacao}.
      &ELSE  
         ASSIGN cont-tran.int-1 = {adinc/i01ad046.i 06 cb-aplicacao}.
      &ENDIF

      /*Elton - NF 3.10*/
      ASSIGN OVERLAY(cont-tran.char-1,1,20) = cnpj-cpf-contato:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

      /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */
      {cdp/cd0002i1.i cont-tran}
    
      /* Code placed here will execute AFTER standard behavior.    */
    
          IF lIntCRM11 THEN DO:
              IF NOT VALID-HANDLE(h-cd0402-crm) THEN
                  RUN integracoes/adapters/emstocrm/cd0402-crm.p PERSISTENT SET h-cd0402-crm.
      
              RUN sendToCRM IN h-cd0402-crm (INPUT cont-tran.cod-transp,
                                             OUTPUT TABLE RowErrors).
              IF CAN-FIND (FIRST RowErrors WHERE 
                                 RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                  {method/ShowMessage.i1}
                  {method/ShowMessage.i2 &Modal="YES"}
                  UNDO, RETURN "ADM-ERROR":U.
              END.
              DELETE PROCEDURE h-cd0402-crm.
          END.
          
          &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
          
            IF v_log_eai_habilit THEN DO:
                IF NOT VALID-HANDLE(h-axsvd007) THEN
                    RUN adapters/xml/vd2/axsvd007.p PERSISTENT SET h-axsvd007.
        
                for first transporte no-lock where transporte.cod-transp = input frame {&Frame-name} cont-tran.cod-transp: end.
        
                IF avail transporte <> ? THEN
                    RUN piTransUpsert IN h-axsvd007 (INPUT "upd":U,
                                                     INPUT rowid(transporte),
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
        &ENDIF.
        
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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  DEFINE VARIABLE iSeq AS INTEGER     NO-UNDO.

  {cdp/cd0002i1.i1 cont-tran "no"} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */

   assign c-cod-transp = input frame {&Frame-name} cont-tran.cod-transp.
   ASSIGN iSeq         = input frame {&frame-name} cont-tran.sequencia.

  
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    
      
    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0402-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0402-crm.p PERSISTENT SET h-cd0402-crm.

        RUN deleteContactFromCRM IN h-cd0402-crm (INPUT c-cod-transp,
                                                  INPUT iSeq,
                                                  OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0402-crm.
    END.
     

    &IF '{&BF_DIS_VERSAO_EMS}' >= "2.04" &THEN
        IF v_log_eai_habilit THEN DO:
            IF NOT VALID-HANDLE(h-axsvd007) THEN
                RUN adapters/xml/vd2/axsvd007.p PERSISTENT SET h-axsvd007.

            for first transporte no-lock where transporte.cod-transp = c-cod-transp: end.
    
            IF avail transporte <> ? THEN
                RUN piTransUpsert IN h-axsvd007 (INPUT "upd":U,
                                                 INPUT rowid(transporte),
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
    &ENDIF.

  {cdp/cd0002i1.i1 cont-tran "yes"} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */

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
  /* Code placed here will execute PRIOR to standard behavior. */

  find transporte where transporte.cod-transp = cont-tran.cod-transp no-lock no-error.
   assign fi-nome = if avail transporte then transporte.nome else " ".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-field.i mgadm cont-tran observacao 1}
  display return-value @ fi-observacao with frame {&frame-name}.

  if l-posiciona = yes then do:
     find transporte where rowid(transporte) = gr-transporte no-lock no-error.
     if avail transporte then do:
        find first cont-tran where cont-tran.cod-transp = transporte.cod-transp exclusive-loc no-error.
        if avail cont-tran then do:
            RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
        end.
     end.
     assign l-posiciona = no.
  end.

  /* posiciona o combo-box do cb-aplicao */


  IF  NOT AVAIL cont-tran THEN
      FIND FIRST cont-tran NO-LOCK
           WHERE cont-tran.cod-transp = input frame {&FRAME-NAME} cont-tran.cod-transp NO-ERROR.

  IF  AVAIL cont-tran THEN DO:
      IF  &IF   '{&bf_dis_versao_ems}' >= '2.09':U 
          &THEN cont-tran.cdn-aplic-contat
          &ELSE cont-tran.int-1
          &ENDIF   > 0 THEN
          ASSIGN cb-aplicacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
                                                                         {adinc/i01ad046.i 04 cont-tran.cdn-aplic-contat}
                                                                    &ELSE
                                                                         {adinc/i01ad046.i 04 cont-tran.int-1}
                                                                    &ENDIF 
                                                                    .
      ELSE           
          ASSIGN cb-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = {adinc/i01ad046.i 04 1}.
          
     /*Elton - NF 3.10*/
     IF NOT adm-new-record THEN
        ASSIGN cnpj-cpf-contato:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(cont-tran.char-1,1,20).
  END.
  ELSE 
      ASSIGN cb-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = {adinc/i01ad046.i 04 1}.
  /* fim - posiciona */
     
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
 
    DEFINE VARIABLE tp-integ AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLista   AS CHARACTER NO-UNDO.

    ASSIGN cLista = "".
    ASSIGN cLista = {adinc/i01ad046.i 03} NO-ERROR.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes":U &then
        RUN utp/ut-lstit.p (INPUT-OUTPUT cLista).
        ASSIGN cb-aplicacao:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cLista NO-ERROR.
    &else
        ASSIGN cb-aplicacao:LIST-ITEMS      IN FRAME {&FRAME-NAME} = cLista NO-ERROR.
    &endif

    RUN cdp/cd0360b.p (INPUT "",
                       INPUT "NF-e":U,
                       OUTPUT tp-integ).

    IF LOOKUP("TSS":U,tp-integ) > 0 
    OR LOOKUP("TC2":U,tp-integ) > 0 THEN
        ASSIGN cont-tran.e-mail:FORMAT IN FRAME {&FRAME-NAME} = "x(80)":U.
    ELSE
        ASSIGN cont-tran.e-mail:FORMAT IN FRAME {&FRAME-NAME} = "x(40)":U.
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    ASSIGN l-posiciona = YES.

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
  assign gr-cont-tran = if avail cont-tran then rowid(cont-tran) else ?.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

    {cdp/cd0003i1.i cont-tran cdp/cd0402i2.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-cont-tran-mg V-table-Win 
PROCEDURE pi-cria-tt-cont-tran-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-cont-tran-mg:
        delete tt-cont-tran-mg.
    end.

    create tt-cont-tran-mg.
    assign tt-cont-tran-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-cont-tran-mg.l-atualiza     = p-atualiza.

    /* Campos Iguais */
    assign tt-cont-tran-mg.cod-transp      = cont-tran.cod-transp
           tt-cont-tran-mg.sequencia       = cont-tran.sequencia
           tt-cont-tran-mg.nome            = fn-free-accent(cont-tran.nome)
           tt-cont-tran-mg.cargo           = fn-free-accent(cont-tran.cargo)
           tt-cont-tran-mg.area            = fn-free-accent(cont-tran.area)
           tt-cont-tran-mg.telefone        = cont-tran.telefone
           tt-cont-tran-mg.ramal           = cont-tran.ramal
           tt-cont-tran-mg.telefax         = cont-tran.telefax
           tt-cont-tran-mg.ramal-fax       = cont-tran.ramal-fax
           tt-cont-tran-mg.dec-1           = cont-tran.dec-1
           tt-cont-tran-mg.int-1           = cont-tran.int-1
           tt-cont-tran-mg.log-1           = cont-tran.log-1
           tt-cont-tran-mg.dec-2           = cont-tran.dec-2
           tt-cont-tran-mg.int-2           = cont-tran.int-2.

    /* Campos com formato diferente */
    assign tt-cont-tran-mg.e-mail          = substring(fn-free-accent(cont-tran.e-mail),1,25)
           tt-cont-tran-mg.observacao[1]   = substring(fn-free-accent(cont-tran.observacao),001,26)
           tt-cont-tran-mg.observacao[2]   = substring(fn-free-accent(cont-tran.observacao),027,26)
           tt-cont-tran-mg.observacao[3]   = substring(fn-free-accent(cont-tran.observacao),053,26)
           tt-cont-tran-mg.observacao[4]   = substring(fn-free-accent(cont-tran.observacao),079,26)
           tt-cont-tran-mg.observacao[5]   = substring(fn-free-accent(cont-tran.observacao),105,26)
           tt-cont-tran-mg.char-1          = fn-free-accent(cont-tran.char-1)
           tt-cont-tran-mg.char-2          = fn-free-accent(cont-tran.char-2).

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

    assign c-chave-mg = string(cont-tran.cod-transp) + string(cont-tran.sequencia).

    {cdp/cd0004i1.i "CD0402" "CONT-TRAN" c-chave-mg tt-cont-tran-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cont-tran-mg V-table-Win 
PROCEDURE pi-valida-cont-tran-mg :
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
  {src/adm/template/snd-list.i "cont-tran"}

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

