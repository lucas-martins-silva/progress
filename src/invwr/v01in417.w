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

{include/i-prgvrs.i V01IN417 2.00.00.068 } /*** "010068" 28/07/2025 13:31:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in417 MUT}
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
&GLOBAL-DEFINE PAIS_MEXICO 4

/* Parameters Definitions ---                                           */

{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
{include/i_prdvers.i}

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-un-medida NO-UNDO LIKE tab-unidade.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR hDBOproxy AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
    DEF SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.
&ENDIF
/* Local Variable Definitions ---                             */
/*def GLOBAL shared var v_log_eai_habilit as logical no-undo. */
def new global shared var gr-tab-unidade as rowid no-undo.
def buffer b-tab-unidade for tab-unidade.

DEFINE VARIABLE h-cd0203-crm  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).

DEFINE TEMP-TABLE tt-tab-unidade-crm NO-UNDO
    FIELD descricao    AS CHARACTER
    FIELD un           AS CHARACTER 
    FIELD dimensao     AS INTEGER
    INDEX ix-chave un.


/*** Vari†veis para integraá∆o EMS x SISDOC ***/

DEF VAR i-integracao-sisdoc     AS INTEGER   INIT ?     NO-UNDO.
DEF VAR c-handle                AS CHARACTER            NO-UNDO.
DEF VAR c-opcao-int             AS CHARACTER            NO-UNDO.
DEF VAR i-retorno-erro          AS INTEGER   INIT ?     NO-UNDO.
DEF VAR l-integra-his           AS LOGICAL              NO-UNDO.
DEF VAR l-mostra-combo-dimensao AS LOGICAL   INITIAL NO NO-UNDO.
DEF VAR iDimensao               AS INTEGER              NO-UNDO.
    /* 
    ** 5 => Quando parÉmetro "nao-integra" e o registro j† est† integrado **
    ** 6 => Erro de integraá∆o no SISDOC                                  **
    ** 7 => Erro de integraá∆o no EMS                                     ** */

/********* Fim vari†veis para integraá∆o ******/       


/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.
{utp/ut-glob.i}
{cdp/cd7300.i1}
{cdp/cdapi218.i}

{mcinc/mcapi174.i}
def temp-table tt-dados-env-SMC    NO-UNDO like tt-dados-env.
def temp-table tt-replica-msg-SMC  NO-UNDO like tt-replica-msg.
def temp-table tt-control-env-SMC  NO-UNDO like tt-control-env.
def temp-table tt-integracao-SMC   NO-UNDO like tt-integracao.

/************Fim*****************************/


/***** Frotas ********/
{cdp/cd0666.i}
/*********************/

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE h-cdapi999     AS HANDLE NO-UNDO. 
&ENDIF

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
&Scoped-define EXTERNAL-TABLES tab-unidade
&Scoped-define FIRST-EXTERNAL-TABLE tab-unidade


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tab-unidade.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tab-unidade.descricao 
&Scoped-define ENABLED-TABLES tab-unidade
&Scoped-define FIRST-ENABLED-TABLE tab-unidade
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-sigla-un i-cod-fiscal 
&Scoped-Define DISPLAYED-FIELDS tab-unidade.un tab-unidade.descricao ~
tab-unidade.log-2 
&Scoped-define DISPLAYED-TABLES tab-unidade
&Scoped-define FIRST-DISPLAYED-TABLE tab-unidade
&Scoped-Define DISPLAYED-OBJECTS cbDimensao c-sigla-un c-unid-medida-afip ~
c-chave-un c-unid-medida-tigie c-un-siap tg-integra-his i-cod-fiscal 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tab-unidade.un 

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
DEFINE VARIABLE cbDimensao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dimens∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-chave-un AS CHARACTER FORMAT "x(3)" 
     LABEL "Chave Un" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-un AS CHARACTER FORMAT "x(10)" 
     LABEL "Sigla Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-un-siap AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Un SIAP" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-medida-afip AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Unidade Medida Afip" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-medida-tigie AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Medida TIGIE" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fiscal AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Cod Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.17.

DEFINE VARIABLE tg-integra-his AS LOGICAL INITIAL no 
     LABEL "Integraá∆o HIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tab-unidade.un AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     tab-unidade.descricao AT ROW 2.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     cbDimensao AT ROW 2.5 COL 50 COLON-ALIGNED
     tab-unidade.log-2 AT ROW 2.5 COL 70
          LABEL "Serviáo"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .83
     c-sigla-un AT ROW 3.5 COL 13.57 HELP
          "Obrigat¢rio p/ unidade de medida c/ sigla c/ mais de 2 caracteres"
     c-unid-medida-afip AT ROW 3.5 COL 20 COLON-ALIGNED
     c-chave-un AT ROW 3.5 COL 14.28 WIDGET-ID 2
     c-unid-medida-tigie AT ROW 3.5 COL 50 COLON-ALIGNED WIDGET-ID 4
     c-un-siap AT ROW 3.5 COL 50 COLON-ALIGNED HELP
          "Unidade de medida SIAP"
     tg-integra-his AT ROW 4.5 COL 22
     i-cod-fiscal AT ROW 4.5 COL 20 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.tab-unidade
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
         HEIGHT             = 4.63
         WIDTH              = 89.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-chave-un IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       c-chave-un:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-sigla-un IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-un-siap IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-un-siap:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-unid-medida-afip IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-unid-medida-afip:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-unid-medida-tigie IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-unid-medida-tigie:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cbDimensao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-cod-fiscal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tab-unidade.log-2 IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       tab-unidade.log-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-integra-his IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tab-unidade.un IN FRAME f-main
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
  {src/adm/template/row-list.i "tab-unidade"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tab-unidade"}

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
  DEFINE VARIABLE c-unid-medida-afip-aux AS CHARACTER FORMAT "X(3)"  NO-UNDO.
  DEFINE VARIABLE c-un-siap-aux          AS CHARACTER FORMAT "X(2)"  NO-UNDO.
  DEFINE VARIABLE c-sigla-unidade        AS CHARACTER FORMAT "X(10)" NO-UNDO.
  DEFINE VARIABLE c-chave-unidade        AS CHARACTER FORMAT "X(3)"  NO-UNDO.
  DEFINE VARIABLE c-cod-fiscal           AS CHARACTER                NO-UNDO.

  do transaction:
     if  not frame {&frame-name}:validate() then
         return 'ADM-ERROR':U.

     ASSIGN c-sigla-unidade = c-sigla-un:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            c-chave-unidade = c-chave-un:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /* Ponha aqui a validaá∆o de chave duplicada */
     if  tab-unidade.un:sensitive in frame {&frame-name} = yes then do:
        find first tab-unidade 
             where tab-unidade.un = input frame {&frame-name} tab-unidade.un no-lock no-error.
             if avail tab-unidade then do:
              {utp/ut-table.i mgind tab-unidade 1}
              run utp/ut-msgs.p( input "show",
                                 input 8,
                                 input return-value).
              apply 'entry' to tab-unidade.un in frame {&frame-name}.
              return 'adm-error'.
             end.

        if input frame {&frame-name} tab-unidade.un = "" then do:
              {utp/ut-field.i mgind tab-unidade un 1}
              run utp/ut-msgs.p( input "show",
                                 input 5793,
                                 input return-value).
              apply 'entry' to tab-unidade.un in frame {&frame-name}.
              return 'adm-error'.
        end.      
     end.   

     if  input frame {&frame-name} tab-unidade.descricao = "" then do:
         {utp/ut-field.i mgind tab-unidade descricao 1}
         run utp/ut-msgs.p( input "show",
                            input 5793,
                            input return-value).
         apply 'entry' to tab-unidade.descricao in frame {&frame-name}.
         return 'adm-error'.
    end.

    IF l-mostra-combo-dimensao THEN
        ASSIGN iDimensao = {ininc/i01in417.i 06 cbDimensao:SCREEN-VALUE IN FRAME {&FRAME-NAME}}.

    IF  i-pais-impto-usuario = 2 THEN /* Pa°s = Argentina (2) */
        ASSIGN c-unid-medida-afip-aux = c-unid-medida-afip:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               c-un-siap-aux          = c-un-siap:SCREEN-VALUE          IN FRAME {&FRAME-NAME}.

    IF i-pais-impto-usuario = 9 /*Paraguai*/ THEN
        ASSIGN c-cod-fiscal = i-cod-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    ASSIGN l-integra-his = LOGICAL(tg-integra-his:SCREEN-VALUE IN FRAME f-main ).
  &ENDIF      
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).   

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  IF  i-pais-impto-usuario = 1
  OR  i-pais-impto-usuario = 7 /* Chile */
  OR  i-pais-impto-usuario = 9 /* Paraguai */
  OR  i-pais-impto-usuario = 17 /* Colombia */ 
  OR  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN OVERLAY(tab-unidade.char-2,1,10) = c-sigla-unidade
             c-sigla-un:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-sigla-unidade.

  IF i-pais-impto-usuario = 4  /* Mexico*/
  OR i-pais-impto-usuario = 33 /* Peru*/ THEN 
      ASSIGN OVERLAY(tab-unidade.char-1,104,3) = c-chave-unidade
             c-chave-un:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN substring(tab-unidade.char-1,104,3) ELSE "".

  IF i-pais-impto-usuario = 9 /*Paraguai*/ THEN
      ASSIGN OVERLAY(tab-unidade.char-1,1,6) = c-cod-fiscal
             i-cod-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-fiscal.

  
   IF CAN-FIND (FIRST funcao 
             WHERE funcao.cd-funcao = "spp-integra-ems-his"
             AND   funcao.ativo     = YES) THEN DO:

      &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          ASSIGN tab-unidade.log-orig-ext = l-integra-his.
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN

             ASSIGN tab-unidade.log-1 = l-integra-his.
         &ENDIF
      &ENDIF.
   END.


  /* Code placed here will execute AFTER standard behavior.    */    

   IF l-mostra-combo-dimensao THEN DO:
       ASSIGN tab-unidade.dimensao = iDimensao.
       ASSIGN cbDimensao:screen-value in frame {&frame-name} =  {ininc/i01in417.i 04 iDimensao}.
   END.
   ELSE assign tab-unidade.dimensao = 1.

    IF  i-pais-impto-usuario = 2 THEN DO: /* Pa°s = Argentina (2) */
        ASSIGN OVERLAY(tab-unidade.char-1,1,3)                        = c-unid-medida-afip-aux
               OVERLAY(tab-unidade.char-1,4,2)                        = c-un-siap-aux
               c-unid-medida-afip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-medida-afip-aux 
               c-un-siap:SCREEN-VALUE          IN FRAME {&FRAME-NAME} = c-un-siap-aux.
    END.
    
    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN
        ASSIGN OVERLAY(tab-unidade.char-1,1,3) = c-unid-medida-tigie:INPUT-VALUE IN FRAME {&FRAME-NAME}.

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0203-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0203-crm.p PERSISTENT SET h-cd0203-crm.
        
        RUN sendToCRM IN h-cd0203-crm (INPUT tab-unidade.un,
                                    OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0203-crm.
    END.

    IF adm-new-record THEN ASSIGN c-action = "add".
                      ELSE ASSIGN c-action = "upd".

    RUN piIntegracao(INPUT IF c-action = "add" THEN "CREATE" ELSE "UPDATE").

    /****************************************************************/    
    /* Para execuá∆o de Adapter da Mensagem Unidade de Medida - EAI */
    /****************************************************************/
    &IF DEFINED (bf_man_204) &THEN 

   /* Execucao caso usuario possua integracao EAI */
      IF v_log_eai_habilit THEN DO:

        CREATE tt-un-medida.
        BUFFER-COPY tab-unidade TO tt-un-medida.
        RUN adapters/xml/ma2/axsma002.p (INPUT c-action,
                                         INPUT "CD0203.W",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT TABLE tt-un-medida,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-un-medida.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}

           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF


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

        if  i-retorno-erro = 6 or
            i-retorno-erro = 7 then
            undo, return "ADM-ERROR":U.

     end.  /* if i-integracao-sisdoc = 3 */     

/********** Fim Integraá∆o EMS x SISDOC **************/


/********************Multiplanta***********************/
      assign c-transacao = "UNI003".
     {cdp/cd7300.i5 "001" c-transacao}

   assign i-tipo-movto = if tab-unidade.un:sensitive in frame {&frame-name} then 1 else 2.
   if  param-global.modulo-mp and
       tt-replica-msg.log-replica-msg  = yes then do: 
       create tt-tab-unidade-aux.
       buffer-copy tab-unidade to tt-tab-unidade-aux.
       create tt-dados-env.                  
       assign tt-dados-env.num-sequencia  = i-seq 
              tt-dados-env.cod-tipo-reg   = 174
              tt-dados-env.ind-tipo-movto = i-tipo-movto
              tt-dados-env.identif-msg    = tab-unidade.un.
       raw-transfer tt-tab-unidade-aux to tt-dados-env.conteudo-msg.                                     
       assign i-seq = i-seq + 1.                                     
   end.

   {cdp/cd7300.i6 "001" c-transacao}

/******************Fim-Multiplanta********************/ 

/***GERAÄ«O DE TRANSAÄ«O MULTIPLANTA ESPEC÷FICO SMC****/
    for each tt-smc-tab-unidade:
        delete tt-smc-tab-unidade.
    end.
    assign c-transacao = "SMC009".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign i-tipo-movto = if tab-unidade.un:sensitive in frame {&frame-name} then 1 
                          else 2.
    run pi-cria-tt-dados-smc (i-tipo-movto).                          
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/***************FIM MULTIPLANTA SMC*******************/ 

    &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx067.p PERSISTENT SET hDBOproxy.
        RUN ReplicaUnidMed IN hDBOproxy(INPUT input frame {&frame-name} tab-unidade.un,
                                        INPUT input frame {&frame-name} tab-unidade.descricao,
                                        OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            RUN destroy IN hDBOproxy.
            undo, return "ADM-ERROR":U.
        END.
        RUN destroy IN hDBOproxy.
    END.
    &ENDIF

  end. /* do transaction */ 
  
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /** Integraá∆o EAI2 **/
    
        IF v_log_eai2_ativado THEN DO:                      
           FIND tab-unidade WHERE tab-unidade.un = input frame {&frame-name} tab-unidade.un NO-LOCK NO-ERROR.

           IF NOT VALID-HANDLE(h-cdapi999) OR
              h-cdapi999:TYPE <> "PROCEDURE":U OR
              h-cdapi999:FILE-NAME <> "cdp/cdapi999.p":U THEN DO:
              RUN cdp/cdapi999.p PERSISTENT SET h-cdapi999. 
           END.
                                                               
           RUN pi-sendUpsert IN h-cdapi999 (INPUT ROWID(tab-unidade), OUTPUT TABLE RowErrors).
           
           IF VALID-HANDLE(h-cdapi999) AND
              h-cdapi999:TYPE = "PROCEDURE":U AND
              h-cdapi999:FILE-NAME = "cdp/cdapi999.p":U THEN DO:
              DELETE PROCEDURE h-cdapi999 NO-ERROR.
              ASSIGN h-cdapi999 = ?.
           END.

           IF CAN-FIND(FIRST RowErrors) THEN DO:
              {method/showmessage.i1}
              {method/showmessage.i2}
              {method/showmessage.i3}
              RETURN "ADM-ERROR".
           END.                     
        END.
    &ENDIF


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
    
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-integra-ems-his" AND funcao.ativo = YES) THEN
          tg-integra-his:CHECKED IN FRAME f-main = NO.
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
  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
      define variable c-un   as character no-undo.
      define variable c-desc as character no-undo.
  
      assign c-un   = input frame {&frame-name} tab-unidade.un
             c-desc = input frame {&frame-name} tab-unidade.descricao.
  &ENDIF       

    /******Verifica integraá∆o HIS**********/
      &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
              IF CAN-FIND (FIRST funcao 
                         WHERE funcao.cd-funcao = "spp-integra-ems-his"
                         AND   funcao.ativo     = YES) THEN DO:
        
              &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
             
                  IF tab-unidade.log-orig-ext THEN DO:
            
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-unidade-de-medida-nao-pode-ser AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Unidade_de_medida_n∆o_pode_ser_eliminada" *}
                     ASSIGN c-lbl-liter-unidade-de-medida-nao-pode-ser = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-unidade-de-medida-possui-relac AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Unidade_de_medida_possui_relacionamento_no_Sistema_Hospitalar" *}
                     ASSIGN c-lbl-liter-unidade-de-medida-possui-relac = TRIM(RETURN-VALUE).
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT c-lbl-liter-unidade-de-medida-nao-pode-ser + "~~" + c-lbl-liter-unidade-de-medida-possui-relac ).
                     RETURN 'adm-error'.
                  END.
              &ELSE
                    IF tab-unidade.log-1 THEN DO:
                      
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-unidade-de-medida-nao-pode-ser-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "Unidade_de_medida_n∆o_pode_ser_eliminada" *}
                       ASSIGN c-lbl-liter-unidade-de-medida-nao-pode-ser-2 = TRIM(RETURN-VALUE).
                       DEFINE VARIABLE c-lbl-liter-unidade-de-medida-possui-relac-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "Unidade_de_medida_possui_relacionamento_no_Sistema_Hospitalar" *}
                       ASSIGN c-lbl-liter-unidade-de-medida-possui-relac-2 = TRIM(RETURN-VALUE).
                       RUN utp/ut-msgs.p (INPUT "show",
                                          INPUT 17006,
                                          INPUT c-lbl-liter-unidade-de-medida-nao-pode-ser-2 + "~~" + c-lbl-liter-unidade-de-medida-possui-relac-2 ).
                       RETURN 'adm-error'.
                    END.

              &ENDIF 
          END.
       &ENDIF
       
  /***************************************/
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

  /***** Fim Integraá∆o EMS x SISDOC ****/

  /***GERAÄ«O DE TRANSAÄ«O MULTIPLANTA ESPEC÷FICO SMC****/
    for each tt-smc-tab-unidade:
        delete tt-smc-tab-unidade.
    end.
    assign c-transacao = "SMC009".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign i-tipo-movto = 3.
    run pi-cria-tt-dados-smc (i-tipo-movto).                          
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}

  /***************FIM MULTIPLANTA SMC*******************/ 

  /* Execucao caso usuario possua integracao EAI */
  &IF DEFINED (bf_man_204) &THEN 
    IF v_log_eai_habilit THEN DO:
        FOR EACH tt-un-medida EXCLUSIVE-LOCK: DELETE tt-un-medida. END.
        CREATE tt-un-medida.
        BUFFER-COPY tab-unidade TO tt-un-medida.
    END.
  &ENDIF

  run pi-valida-eliminacao.
  if  return-value <> "OK":U then
     return "ADM-ERROR".

    &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx067.p PERSISTENT SET hDBOproxy.
        RUN eliminaUnidMed IN hDBOproxy(INPUT input frame {&frame-name} tab-unidade.un,
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

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0203-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0203-crm.p PERSISTENT SET h-cd0203-crm.
        
        RUN deleteFromCRM IN h-cd0203-crm (INPUT tab-unidade.un,
                                      OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0203-crm.
    END.

  RUN piIntegracao("DELETE").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
   /* Code placed here will execute AFTER standard behavior.    */

  /****************************************************************/    
  /* Para execuá∆o de Adapter da Mensagem Unidade de Medida - EAI */
  /****************************************************************/
  if NOT RETURN-VALUE = 'ADM-ERROR':U then DO:
    &IF DEFINED (bf_man_204) &THEN 
    /* Execucao caso usuario possua integracao EAI */
    IF v_log_eai_habilit THEN DO:
        IF CAN-FIND (FIRST tt-un-medida) THEN DO:
            RUN adapters/xml/ma2/axsma002.p (INPUT "del",
                                             INPUT "CD0203.W",
                                             INPUT c-prg-vrs,
                                             INPUT TABLE tt-un-medida,
                                             OUTPUT TABLE RowErrors).  
                DELETE tt-un-medida.
                IF CAN-FIND (FIRST RowErrors WHERE 
                                   RowErrors.ErrorSubType = "ERROR":U) THEN DO:

                   {method/showmessage.i1}
                   {method/showmessage.i2 &Modal="YES"}

                   undo, return "ADM-ERROR":U.
                END.
            END.
    END.
  &ENDIF
 END. 
 
  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
      /** Integraá∆o EAI2 **/
      
      IF v_log_eai2_ativado THEN DO:                                   
         IF NOT VALID-HANDLE(h-cdapi999) OR
            h-cdapi999:TYPE <> "PROCEDURE":U OR
            h-cdapi999:FILE-NAME <> "cdp/cdapi999.p":U THEN DO:
            RUN cdp/cdapi999.p PERSISTENT SET h-cdapi999. 
         END.
                                                           
         RUN pi-sendDelete IN h-cdapi999 (INPUT c-un, INPUT c-desc, OUTPUT TABLE RowErrors).
       
         IF VALID-HANDLE(h-cdapi999) AND
            h-cdapi999:TYPE = "PROCEDURE":U AND
            h-cdapi999:FILE-NAME = "cdp/cdapi999.p":U THEN DO:
            DELETE PROCEDURE h-cdapi999 NO-ERROR.
            ASSIGN h-cdapi999 = ?.
         END.
          
         IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            {method/showmessage.i3}
            RETURN "ADM-ERROR".
         END.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF  i-pais-impto-usuario = 2 THEN DO: /* Pa°s = Argentina (2) */
      DISABLE c-unid-medida-afip WITH FRAME {&FRAME-NAME}.
      DISABLE c-un-siap          WITH FRAME {&FRAME-NAME}.
  END.

  IF l-mostra-combo-dimensao THEN
      DISABLE cbDimensao WITH FRAME {&FRAME-NAME}.

  IF  i-pais-impto-usuario = 4 /* MÇxico */ THEN
      ASSIGN tab-unidade.log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             c-chave-un:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
             
  IF  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-chave-un:SENSITIVE IN FRAME {&FRAME-NAME} = NO.           

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
      ASSIGN i-cod-fiscal:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF  i-pais-impto-usuario = 1 /* Brasil */
  OR  i-pais-impto-usuario = 7 /* Chile */ 
  OR  i-pais-impto-usuario = 9 /* Paraguai */ 
  OR  i-pais-impto-usuario = 17 /* Colombia */
  OR  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-sigla-un:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN
        DISABLE c-unid-medida-tigie WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
        
    ASSIGN INPUT FRAME f-main c-unid-medida-tigie.

  /* Code placed here will execute PRIOR to standard behavior. */    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF l-mostra-combo-dimensao THEN DO:
      ASSIGN cbDimensao:VISIBLE      IN FRAME {&FRAME-NAME} = TRUE.
      ASSIGN cbDimensao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN
                                                                  {ininc/i01in417.i 04 tab-unidade.dimensao}
                                                              ELSE
                                                                  {ininc/i01in417.i 04 1}.
  END.
  ELSE 
      ASSIGN cbDimensao:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.

    /* Code placed here will execute AFTER standard behavior.    */
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND (FIRST funcao 
                   WHERE funcao.cd-funcao = "spp-integra-ems-his"
                   AND   funcao.ativo     = YES) THEN DO:
    
            &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                ASSIGN tg-integra-his:CHECKED IN FRAME f-main = IF AVAIL tab-unidade THEN tab-unidade.log-orig-ext ELSE NO.
            &ELSE
                ASSIGN tg-integra-his:CHECKED IN FRAME f-main = IF AVAIL tab-unidade THEN tab-unidade.log-1 ELSE NO.
            &ENDIF.
      END.
   &ENDIF
   
  IF  i-pais-impto-usuario = 2 THEN DO: /* Pa°s = Argentina (2) */
      IF  AVAIL tab-unidade THEN
          ASSIGN c-unid-medida-afip:SCREEN-VALUE IN FRAME f-main = SUBSTRING(tab-unidade.char-1,1,3)
                 c-un-siap:SCREEN-VALUE          IN FRAME f-main = SUBSTRING(tab-unidade.char-1,4,2).
      ELSE
          ASSIGN c-unid-medida-afip:SCREEN-VALUE IN FRAME f-main = STRING("0")
                 c-un-siap:SCREEN-VALUE          IN FRAME f-main = STRING("0").
  END.
  ELSE
      ASSIGN c-unid-medida-afip:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.

  IF  i-pais-impto-usuario = 1
  OR  i-pais-impto-usuario = 7 /* Chile */ 
  OR  i-pais-impto-usuario = 9 /* Paraguai */ 
  OR  i-pais-impto-usuario = 17 /* Colombia */ 
  OR  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-sigla-un:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN substring(tab-unidade.char-2,1,10) ELSE "".

   IF i-pais-impto-usuario = 4  /* MÇxico*/
   OR i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-chave-un:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN substring(tab-unidade.char-1,104,3) ELSE "".

   IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
      ASSIGN i-cod-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN substring(tab-unidade.char-1,1,6) ELSE "".

    IF SELF:NAME <> "bt-sav" AND 
       i-pais-impto-usuario = {&PAIS_MEXICO} THEN DO:
        ASSIGN c-unid-medida-tigie:SCREEN-VALUE = "".
        
        IF AVAILABLE(tab-unidade) THEN
            ASSIGN c-unid-medida-tigie:SCREEN-VALUE = SUBSTRING(tab-unidade.char-1,1,3).
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /******* Integraá∆o EMS x SISDOC ******/
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.  


      &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
          IF CAN-FIND (FIRST funcao 
                       WHERE funcao.cd-funcao = "spp-integra-ems-his"
                       AND   funcao.ativo     = YES) THEN DO:
    
             &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                   ASSIGN tg-integra-his:SENSITIVE IN FRAME f-main = NO.
             &ENDIF.
             
             &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
    
                IF tab-unidade.log-orig-ext = YES THEN DO:
    
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-unidade-de-medida-nao-pode-ser-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Unidade_de_medida_n∆o_pode_ser_alterada" *}
                    ASSIGN c-lbl-liter-unidade-de-medida-nao-pode-ser-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-unidade-de-medida-possui-relac-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Unidade_de_medida_possui_relacionamento_no_Sistema_Hospitalar" *}
                    ASSIGN c-lbl-liter-unidade-de-medida-possui-relac-3 = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                      INPUT c-lbl-liter-unidade-de-medida-nao-pode-ser-3 + "~~" + c-lbl-liter-unidade-de-medida-possui-relac-3 ).
    
                    run notify ("pi-cancelar, tableio-source").
                    return "ADM-ERROR":U.
                 END.
             &ELSE
               &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
               
                   IF tab-unidade.log-1 = YES THEN DO:
    
                      /* Inicio -- Projeto Internacional */
                      DEFINE VARIABLE c-lbl-liter-unidade-de-medida-nao-pode-ser-4 AS CHARACTER NO-UNDO.
                      {utp/ut-liter.i "Unidade_de_medida_n∆o_pode_ser_alterada" *}
                      ASSIGN c-lbl-liter-unidade-de-medida-nao-pode-ser-4 = TRIM(RETURN-VALUE).
                      DEFINE VARIABLE c-lbl-liter-unidade-de-medida-possui-relac-4 AS CHARACTER NO-UNDO.
                      {utp/ut-liter.i "Unidade_de_medida_possui_relacionamento_no_Sistema_Hospitalar" *}
                      ASSIGN c-lbl-liter-unidade-de-medida-possui-relac-4 = TRIM(RETURN-VALUE).
                      RUN utp/ut-msgs.p (INPUT "show",
                                         INPUT 17006,
                                         INPUT c-lbl-liter-unidade-de-medida-nao-pode-ser-4 + "~~" + c-lbl-liter-unidade-de-medida-possui-relac-4 ).
                      run notify ("pi-cancelar, tableio-source").
                      return "ADM-ERROR":U.
                   END.
                 &ENDIF
             &ENDIF
          END.
       &ENDIF
      end.  
  
  /* if not adm-new-record */

  /***** Fim Integraá∆o EMS x SISDOC ****/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        IF adm-new-record THEN
            ASSIGN tg-integra-his:CHECKED IN FRAME f-main = NO.
  &ENDIF.

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF  i-pais-impto-usuario = 2 THEN DO: /* Pa°s = Argentina (2) */
      ENABLE c-unid-medida-afip WITH FRAME {&FRAME-NAME}.
      ENABLE c-un-siap          WITH FRAME {&FRAME-NAME}.
  END.
      
  IF l-mostra-combo-dimensao THEN DO:
      ASSIGN cbDimensao:VISIBLE      IN FRAME {&FRAME-NAME} = TRUE.
      ASSIGN cbDimensao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL tab-unidade THEN
                                                                  {ininc/i01in417.i 04 tab-unidade.dimensao}
                                                              ELSE
                                                                  {ininc/i01in417.i 04 1}.
      ENABLE cbDimensao WITH FRAME {&FRAME-NAME}.
  END.
  ELSE 
      ASSIGN cbDimensao:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.

  IF  i-pais-impto-usuario = 4 /* MÇxico */ THEN
      ASSIGN tab-unidade.log-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             c-chave-un:SENSITIVE IN FRAME {&FRAME-NAME}        = YES.
             
  IF  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-chave-un:SENSITIVE IN FRAME {&FRAME-NAME}        = YES.           

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
      ASSIGN i-cod-fiscal:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  IF  i-pais-impto-usuario = 1 
  OR  i-pais-impto-usuario = 7 /* Chile */
  OR  i-pais-impto-usuario = 9 /* Paraguai */ 
  OR  i-pais-impto-usuario = 17 /* Colombia */ 
  OR  i-pais-impto-usuario = 33 /* Peru */ THEN
      ASSIGN c-sigla-un:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN DO:
        ENABLE c-unid-medida-tigie WITH FRAME {&FRAME-NAME}.        
    END.
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

  FIND FIRST param-global NO-LOCK NO-ERROR.
  
  ASSIGN l-mostra-combo-dimensao = IF AVAIL param-global THEN param-global.log-modul-gg ELSE NO.

  IF NOT l-mostra-combo-dimensao THEN DO:
      &IF DEFINED (bf_man_per_ppm) &THEN
          ASSIGN l-mostra-combo-dimensao = IF AVAIL param-global THEN param-global.modulo-per-ppm ELSE NO.
      &ENDIF
  END.

  IF NOT l-mostra-combo-dimensao THEN DO:
      ASSIGN l-mostra-combo-dimensao = IF AVAIL param-global AND substring(param-global.char-2,101,1) = "S" THEN YES ELSE NO.
  END.

  IF l-mostra-combo-dimensao THEN
      assign cbDimensao:VISIBLE    IN FRAME {&FRAME-NAME} = TRUE
             cbDimensao:LIST-ITEMS IN FRAME {&FRAME-NAME} = {ininc/i01in417.i 03}.
  ELSE
      ASSIGN cbDimensao:VISIBLE    IN FRAME {&FRAME-NAME} = FALSE.      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .        

  /* Code placed here will execute AFTER standard behavior.    */
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND (FIRST funcao 
                   WHERE funcao.cd-funcao = "spp-integra-ems-his"
                   AND   funcao.ativo     = YES) THEN DO:        
 
          tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = YES.
          tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      END. 
      ELSE DO:
         tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         tg-integra-his:ROW IN FRAME {&FRAME-NAME} = 1.
         tg-integra-his:COLUMN IN FRAME {&FRAME-NAME} = 1.
         tg-integra-his:WIDTH IN FRAME {&FRAME-NAME} = 1.
         tg-integra-his:HEIGHT IN FRAME {&FRAME-NAME} = 1.
      END.
   &ENDIF
   
   &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
       /* Carrega a vari·vel global v_log_eai2_ativado */
       RUN cdp/cd0101i.p. 
   &ENDIF
   
    IF  i-pais-impto-usuario = 2 THEN /* Pa°s = Argentina (2) */
        ASSIGN c-unid-medida-afip:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
               c-un-siap:HIDDEN          IN FRAME {&FRAME-NAME} = FALSE.

    IF  i-pais-impto-usuario = 4 /* MÇxico */ THEN
        ASSIGN tab-unidade.log-2:HIDDEN IN FRAME {&FRAME-NAME} = NO
               c-chave-un:HIDDEN IN FRAME {&FRAME-NAME}        = NO.
               
    IF  i-pais-impto-usuario = 33 /* Peru*/ THEN DO:    
        {utp/ut-liter.i "Cod_UM__Exportaá∆o" *}
        ASSIGN c-chave-un:LABEL IN FRAME {&FRAME-NAME}         = TRIM(RETURN-VALUE) 
               c-chave-un:SIDE-LABEL-HANDLE:ROW                = 4.5
               c-chave-un:ROW IN FRAME {&FRAME-NAME}           = 4.5                             
               c-chave-un:HIDDEN IN FRAME {&FRAME-NAME}        = NO.  
    END.           

    IF  i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN i-cod-fiscal:HIDDEN IN FRAME {&FRAME-NAME} = NO.

    ASSIGN c-sigla-un:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-sigla-un:HIDDEN IN FRAME {&FRAME-NAME}    = NO.
           
    IF  i-pais-impto-usuario <> 1 
    AND i-pais-impto-usuario <> 7 /* Chile */ 
    AND i-pais-impto-usuario <> 9 /* Paraguai */ 
    AND i-pais-impto-usuario <> 17 /* Colombia */ 
    AND i-pais-impto-usuario <> 33 /* Peru */  THEN
         ASSIGN c-sigla-un:HIDDEN IN FRAME {&FRAME-NAME} = YES.
                   
    IF  i-pais-impto-usuario = 7 /* Chile */ THEN
        ASSIGN c-sigla-un:FORMAT IN FRAME {&FRAME-NAME} = "x(4)".
    IF  i-pais-impto-usuario = 17 /* Colombia */ THEN
        ASSIGN c-sigla-un:FORMAT IN FRAME {&FRAME-NAME} = "x(6)".
                
    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN
        ASSIGN c-unid-medida-tigie:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
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

if avail tab-unidade then
  assign gr-tab-unidade = rowid(tab-unidade).

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

def input param i-tipo-movto as integer.
assign i-seq = 1.

    if  param-global.modulo-mp and
       tt-replica-msg-SMC.log-replica-msg  = yes then do: 
       create tt-smc-tab-unidade.
       buffer-copy tab-unidade to tt-smc-tab-unidade.
       create tt-dados-env-SMC.                  
       assign tt-dados-env-SMC.num-sequencia  = i-seq 
              tt-dados-env-SMC.cod-tipo-reg   = 174
              tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
              tt-dados-env-SMC.identif-msg    = tab-unidade.un.
       raw-transfer tt-smc-tab-unidade to tt-dados-env-SMC.conteudo-msg.                                     
       assign i-seq = i-seq + 1.                                     
   end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ignora-integracao V-table-Win 
PROCEDURE pi-ignora-integracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN                         
    IF CAN-FIND (FIRST funcao 
                    WHERE funcao.cd-funcao = "spp-integra-ems-his"
                    AND   funcao.ativo     = YES) THEN DO:                         
                      tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = NO.
                      tg-integra-his:ROW IN FRAME {&FRAME-NAME} = 1.
                      tg-integra-his:COLUMN IN FRAME {&FRAME-NAME} = 1.
                      tg-integra-his:WIDTH IN FRAME {&FRAME-NAME} = 1.
                      tg-integra-his:HEIGHT IN FRAME {&FRAME-NAME} = 1.
                  END.                   
&ENDIF

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

{database/tgin/tdp/tdin417.i 'show'}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao V-table-Win 
PROCEDURE piIntegracao :
/* -----------------------------------------------------------
  Purpose: Api para integraá‰es    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "UnitOfMeasure",    /* Nome da transaá∆o     */
                                             INPUT ROWID(tab-unidade), /* Registro da transaá∆o */
                                             INPUT pType,              /* Evento da transaá∆o   */
                                             OUTPUT TABLE RowErrors).  /* Erros da transaá∆o    */
    DELETE PROCEDURE h-ut-integration.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
         {method/showmessage.i1}
         {method/showmessage.i2 &Modal="YES"}
         {method/showmessage.i3}
         RETURN "ADM-ERROR".
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
  {src/adm/template/snd-list.i "tab-unidade"}

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

