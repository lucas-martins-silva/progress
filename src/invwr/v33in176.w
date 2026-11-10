&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V33IN176 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V33IN176 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
{cdp/cdcfgmat.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var c-estabelec     like estabelec.cod-estabel      no-undo.
def var c-num-ord-inv   like item-doc-est.num-ord-inv   no-undo.
def var de-qtd-max-aux  like item-doc-est.quantidade[1] no-undo.
def var i-ord-aux       like item-doc-est.nr-ord-prod   no-undo.
def var l-baixa-ce      as logical                      no-undo.
def var l-habilita      as logical                      no-undo.
def var c-formato-conta as char                         no-undo.
define variable c-empresa       LIKE empresa.ep-codigo  NO-UNDO.
DEFINE VARIABLE d-dt-trans AS DATE        NO-UNDO.

{cdp/cdunif001.i} /* Vari†veis da unificaá∆o de conceito Conta Cont†bil e Centro de Custo */

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
&Scoped-define EXTERNAL-TABLES saldo-terc item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc, item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold d-quantidade i-ord-prod 
&Scoped-Define DISPLAYED-OBJECTS i-seq c-item c-desc-item d-quantidade ~
i-ord-prod c-ct-codigo fi-c-desc-conta c-sc-codigo fi-c-desc-ccusto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro de Custo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE d-quantidade AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE i-ord-prod AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-seq AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-seq AT ROW 1.25 COL 19 COLON-ALIGNED
     c-item AT ROW 2.25 COL 19 COLON-ALIGNED
     c-desc-item AT ROW 2.25 COL 37 COLON-ALIGNED NO-LABEL
     d-quantidade AT ROW 4.5 COL 19 COLON-ALIGNED
     i-ord-prod AT ROW 5.5 COL 19 COLON-ALIGNED HELP
          "Informe o numero da ordem de produá∆o"
     c-ct-codigo AT ROW 6.5 COL 19 COLON-ALIGNED WIDGET-ID 10
     fi-c-desc-conta AT ROW 6.5 COL 37.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-sc-codigo AT ROW 7.5 COL 19 COLON-ALIGNED WIDGET-ID 16
     fi-c-desc-ccusto AT ROW 7.5 COL 37.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.saldo-terc,movind.item-doc-est
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
         HEIGHT             = 8
         WIDTH              = 78.
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

/* SETTINGS FOR FILL-IN c-ct-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-seq IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME c-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo V-table-Win
ON ENTRY OF c-ct-codigo IN FRAME f-main /* Conta */
DO:

    ASSIGN c-ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = "x(20)":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo V-table-Win
ON LEAVE OF c-ct-codigo IN FRAME f-main /* Conta */
DO:

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN v_cod_cta_ctbl = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").
    
    IF d-dt-trans <> ? THEN DO:

        /* Busca dados da conta cont†bil */
        EMPTY TEMP-TABLE tt_log_erro.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                       INPUT        "",                 /* PLANO DE CONTAS */
                                                       INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                       INPUT        d-dt-trans, /* DATA TRANSACAO */   
                                                       OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                       OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                       OUTPUT TABLE tt_log_erro).       /* ERROS */

        IF  RETURN-VALUE = "OK":U THEN DO:
            /* Busca formato de apresentaá∆o da conta cont†bil */
            RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                               INPUT  "",                   /* PLANO CONTAS */
                                                               INPUT  d-dt-trans,   /* DATA DE TRANSACAO */
                                                               OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                               OUTPUT TABLE tt_log_erro).   /* ERROS */
            
            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
                   fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
            
            /* Aplica a mascara no campo */
            IF  p_cod_format_cta_ctbl <> "" THEN
                ASSIGN c-ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_cta_ctbl.
        
            /* Verifica se a conta utiliza centro de custo */
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                               INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                               INPUT  "",                 /* PLANO CONTAS */
                                                               INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                               INPUT  d-dt-trans, /* DT TRANSACAO */
                                                               OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                               OUTPUT TABLE tt_log_erro). /* ERROS */
            IF  NOT p_log_ccusto THEN
                ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       fi-c-desc-ccusto:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
                       c-sc-codigo:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            ELSE DO:
                ASSIGN c-sc-codigo:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.
                APPLY "ENTRY":U TO c-sc-codigo  IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.
        ELSE
            ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME f-main /* Conta */
OR "F5":U OF c-ct-codigo IN FRAME {&FRAME-NAME} DO:

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  d-dt-trans, /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON ENTRY OF c-sc-codigo IN FRAME f-main /* Sub-Conta */
DO:

    ASSIGN c-sc-codigo:FORMAT = "x(20)":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON LEAVE OF c-sc-codigo IN FRAME f-main /* Sub-Conta */
DO:

    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = REPLACE(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").
    
    IF d-dt-trans <> ? THEN DO:
        RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   INPUT  v_cod_ccusto,       /* CCUSTO */
                                                   INPUT  d-dt-trans, /* DATA DE TRANSACAO */
                                                   OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
        
        IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
            /* Busca m†scara para o campo centro de custo */
            RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  d-dt-trans, /* DATA DE TRANSACAO */ 
                                                           OUTPUT p_cod_format_ccusto,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
            
            ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
            /* Aplica a m†scara no campo */
            IF  p_cod_format_ccusto <> "" THEN
                ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
        END.
        ELSE
            ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME f-main /* Sub-Conta */
OR "F5":U OF c-sc-codigo IN FRAME {&FRAME-NAME} DO:

    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT c-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ? */
                                                   INPUT "",                  /* Unidade de Neg¢cio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* C¢digo da Conta*/
                                                   INPUT "",                  /* C¢digo do Plano de Centro de Custo*/
                                                   INPUT d-dt-trans,  /* Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,       /* C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/
    IF  v_des_ccusto <> "" THEN
        ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON F5 OF i-ord-prod IN FRAME f-main
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in271.w
                       &campo=i-ord-prod
                       &campozoom=nr-ord-produ}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON LEAVE OF i-ord-prod IN FRAME f-main
DO:

    if  input frame {&frame-name} i-ord-prod <> 0 then do:
        find ord-prod 
            where ord-prod.nr-ord-prod = input frame {&frame-name} i-ord-prod
            no-lock no-error.
        if  available ord-prod then do:
            ASSIGN c-ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-prod.ct-codigo
                   c-sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-prod.sc-codigo.
            
            APPLY "LEAVE":U TO c-ct-codigo IN FRAME {&FRAME-NAME}.
            APPLY "LEAVE":U TO c-sc-codigo IN FRAME {&FRAME-NAME}.
        end.
        disable c-ct-codigo with frame {&frame-name}.                
    end.                                                 
    else do:

       if  param-global.modulo-ce then
           assign c-ct-codigo:sensitive in frame {&frame-name} = 
                                    natur-oper.tipo = 1 /*entrada */
                                    and ((l-baixa-ce and not natur-oper.terceiros)
                                     or not l-baixa-ce
                                     or item.tipo-contr = 4  /*DDireto*/
                                     or item.tipo-contr = 1). /*Fisico*/
                                     
       else                                    
           assign c-ct-codigo:sensitive in frame {&frame-name} = no.
       
       if  input frame {&FRAME-NAME} i-ord-prod <> i-ord-aux 
       and  i-ord-prod:modified in frame {&FRAME-NAME} then
           assign c-ct-codigo:screen-value in frame {&frame-name} = ""
                  c-sc-codigo:screen-value in frame {&frame-name} = ""
                  fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                  fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

       assign i-ord-aux = input frame {&frame-name} i-ord-prod.

       if c-ct-codigo:sensitive in frame {&frame-name} = yes then do:
          apply 'entry' to c-ct-codigo .
       end.
    end.        
    assign i-ord-aux = input frame {&frame-name} i-ord-prod.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ord-prod IN FRAME f-main
DO:
  apply 'F5' to self.
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

{utp/ut-field.i mgind item-doc-est it-codigo 1}
assign c-item:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item-doc-est sequencia 1}
assign i-seq:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item-doc-est ct-codigo 1}
assign c-ct-codigo:label in frame {&frame-name} = return-value.

{utp/ut-liter.i "Centro_de_Custo" *}
assign c-sc-codigo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item-doc-est quantidade 1}
assign d-quantidade:label in frame {&frame-name} = return-value.

&if defined(bf_mat_desatualiza_ap) &then
    {utp/ut-field.i mgind item-doc-est nr-ord-produ 1}
    assign i-ord-prod:label in frame {&frame-name} = return-value.
&else
    {utp/ut-field.i mgind item-doc-est nr-ord-prod 1}
    assign i-ord-prod:label in frame {&frame-name} = return-value.
&endif  

if c-ct-codigo:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
if c-sc-codigo:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
if i-ord-prod:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

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
  {src/adm/template/row-list.i "saldo-terc"}
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}
  {src/adm/template/row-find.i "item-doc-est"}

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
    /*{include/i-valid.i}*/

      if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Elimina handle's */
  IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO:
      DELETE OBJECT h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
  END.

  IF  VALID-HANDLE(h_api_ccusto) THEN DO:
      DELETE OBJECT h_api_ccusto.
      ASSIGN h_api_ccusto = ?.
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
    if adm-new-record = yes then
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
  FOR FIRST param-global NO-LOCK: END.
  ASSIGN c-empresa = param-global.empresa-prin.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param nr-sequencia           like item-doc-est.sequencia      no-undo.  
def input param it-codigo              like item-doc-est.it-codigo      no-undo. 
def input param nat-operacao           like item-doc-est.nat-operacao   no-undo.
def input param de-qtd-max             like item-doc-est.quantidade[1]  no-undo.
def input param l-baixa-estoq          like item-doc-est.baixa-ce       no-undo.
def input param p-dt-trans             like docum-est.dt-trans          no-undo.
def input-output param quantidade      like item-doc-est.quantidade[1]  no-undo.
def input-output param nr-ord-prod     like item-doc-est.nr-ord-prod    no-undo.
def input-output param p-ct-codigo     like item-doc-est.ct-codigo      no-undo.
def input-output param p-sc-codigo     like item-doc-est.sc-codigo      no-undo.
def input-output param cod-estabel     like estabelec.cod-estabel       no-undo.
def input-output param num-ord-inv     like item-doc-est.num-ord-inv    no-undo.
def input-output param baixa-estoq     like item-doc-est.baixa-ce       no-undo.

assign i-seq:screen-value in frame {&frame-name} = string(nr-sequencia)
       c-item:screen-value in frame {&frame-name} = it-codigo
       d-quantidade:screen-value in frame {&frame-name} = string(quantidade)
       i-ord-prod:screen-value in frame {&frame-name} = string(nr-ord-prod)
       c-ct-codigo:screen-value in frame {&frame-name} = p-ct-codigo
       c-sc-codigo:screen-value in frame {&frame-name} = p-sc-codigo
       c-estabelec    = cod-estabel
       c-num-ord-inv  = num-ord-inv
       de-qtd-max-aux = de-qtd-max
       i-ord-aux      = nr-ord-prod
       l-baixa-ce     = l-baixa-estoq
       d-dt-trans     = p-dt-trans.

find ord-prod 
    where ord-prod.nr-ord-produ = nr-ord-prod no-lock no-error.

find item 
    where item.it-codigo = it-codigo no-lock no-error.
if  avail item then
    assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item.

find natur-oper 
    where natur-oper.nat-operacao = nat-operacao no-lock no-error.

/* N∆o abilita quantidade para notas de reajuste de preáo */
assign d-quantidade:sensitive in frame {&FRAME-NAME} = not can-do("6", string(natur-oper.tp-oper-terc)).


/* N∆o habilita a Ordem de Produá∆o e a Conta de Aplicaá∆o para as notas de Faturamento */
/* Consignaá∆o e Reajuste Preáo. A conta ser† habilitada apenas para os itens com  tipo */
/* de controle F°sico ou DÇbito Direto.                                                 */

assign i-ord-prod:sensitive in frame {&FRAME-NAME} =   natur-oper.tipo = 1 
                                                   and not can-do("4,6", string(natur-oper.tp-oper-terc))
                                                   and (   param-global.modulo-cp
                                                        or param-global.modulo-mi ).

if  input frame {&FRAME-NAME} i-ord-prod = 0
and param-global.modulo-ce then
    assign c-ct-codigo:sensitive in frame {&frame-name} =   
                                               natur-oper.tipo = 1 /* Entrada */
                                           and (   can-do("1,4", string(item.tipo-contr))
                                                or (    not l-baixa-estoq
                                                    and not can-do("4,6", string(natur-oper.tp-oper-terc))) ).
else                                    
    assign c-ct-codigo:sensitive in frame {&frame-name} = no.

APPLY "LEAVE":U TO c-ct-codigo IN FRAME {&FRAME-NAME}.
APPLY "LEAVE":U TO c-sc-codigo IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava V-table-Win 
PROCEDURE pi-grava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param quantidade-aux     like item-doc-est.quantidade[1]  no-undo.
def output param nr-ord-prod-aux    like item-doc-est.nr-ord-prod    no-undo.
def output param c-ct-codigo-aux    like item-doc-est.ct-codigo      no-undo.
def output param c-sc-codigo-aux    like item-doc-est.sc-codigo      no-undo.
def output param item-pai-aux       like item-doc-est.item-pai       no-undo.
def output param cod-roteiro-aux    like item-doc-est.cod-roteiro    no-undo.
def output param op-codigo-aux      like item-doc-est.op-codigo      no-undo.

    find first reservas
         where reservas.nr-ord-prod = input frame {&frame-name} i-ord-prod 
           and reservas.it-codigo   = input frame {&frame-name} c-item no-lock no-error.

    assign quantidade-aux     = input frame {&frame-name} d-quantidade
           nr-ord-prod-aux    = input frame {&frame-name} i-ord-prod
           c-ct-codigo-aux    = input frame {&frame-name} c-ct-codigo
           c-sc-codigo-aux    = input frame {&frame-name} c-sc-codigo
           item-pai-aux       = if avail reservas then reservas.item-pai    else ""
           cod-roteiro-aux    = if avail reservas then reservas.cod-roteiro else ""
           op-codigo-aux      = if avail reservas then reservas.op-codigo   else 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida V-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-vldfrm.i}

   if  input frame {&frame-name} d-quantidade = 0 then do:
       /* mensagem: Quantidade deve ser diferente de zero */
       {include/i-vldprg.i}
       {utp/ut-liter.i Quantidade *}
       run utp/ut-msgs.p (input "show",input 1491,input return-value).
       apply 'entry' to d-quantidade in frame {&frame-name}.
       return 'adm-error':U.
    end.

   if  input frame {&frame-name} d-quantidade > de-qtd-max-aux then do:
       /* mensagem: Quantidade devolvida maior que quantidade faturada */
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",input 1303,input " ").
       apply 'entry' to d-quantidade in frame {&frame-name}.
       return 'adm-error':U.
    end.   


    if  input frame {&frame-name} i-ord-prod <> 0 then do:
        find ord-prod 
            where ord-prod.nr-ord-prod = input frame {&frame-name} i-ord-prod
            no-lock no-error.

        if  not avail ord-prod then do:
            /* mensagem: Ordem de produá∆o n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ord-prod 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  ord-prod.cod-estabel <> c-estabelec then do:
            /* mensagem: Ordem de produá∆o n∆o pertence ao estabelecimento da nota */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15189,input " ").
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  avail item and item.tipo-requis = 2 then do:
            /* mensagem: Item possui tipo de requisiá∆o por transferància */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5675,input " ").
        end.

        if  param-global.modulo-mi then do:
            find ord-manut 
                where ord-manut.nr-ord-prod = ord-prod.nr-ord-prod no-lock no-error.

            if  avail ord-manut then do:
                if  ord-manut.estado-om = 3 then do:
                    /* mensagem: Ordem de manutená∆o suspensa */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5676,input " ").
                    apply 'entry' to i-ord-prod in frame {&frame-name}.
                    return 'adm-error':U. 
                end.    

                if  ord-manut.estado-om = 4 then do:
                    if  ord-manut.estado = 8 then do:
                        /* mensagem: Ordem de manutená∆o terminada */
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",input 5676,input " ").
                        apply 'entry' to i-ord-prod in frame {&frame-name}.
                        return 'adm-error':U.
                    end.    

                    if  ord-manut.estado = 7 then do:
                        /* mensagem: Ordem de manutená∆o finalizada */
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",input 16314,input " ").
                        if  return-value = "no" then do:                               
                            apply 'entry' to i-ord-prod in frame {&frame-name}.
                            return 'adm-error':U.
                        end.
                    end.     
                end.    
            end.
        end.
        if  not avail ord-manut
        and ( ord-prod.estado = 7 or ord-prod.estado = 8 ) then do:
            /* mensagem: Ordem de produá∆o j† esta finalizada */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1202,input " ").
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.                

    if  input frame {&frame-name} i-ord-prod = 0 
    and input frame {&frame-name} c-ct-codigo <> "" then do:

        IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
        IF  NOT VALID-HANDLE(h_api_ccusto) THEN
            RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
        ASSIGN v_cod_cta_ctbl = REPLACE(c-ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").
        RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                       INPUT        "",                 /* PLANO DE CONTAS */
                                                       INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                       INPUT        d-dt-trans, /* DATA TRANSACAO */   
                                                       OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                       OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                       OUTPUT TABLE tt_log_erro).       /* ERROS */
        IF  RETURN-VALUE <> "OK":U THEN DO:
            /* mensagem: Conta cont†bil n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgadm conta-contab 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to c-ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if v_num_sit_cta_ctbl <> 3 then do:
            /**  Conta n∆o Ç de sistema **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 443,input " ").
            apply 'entry' to c-ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.  

        if not can-do("1,2,4,5",string(v_num_tip_cta_ctbl)) then do:
            /* mensagem: Conta deve ser de despesa, receita, ativo ou passivo */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5543,input " ").
            apply 'entry' to c-ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.  

        IF  v_ind_finalid_cta = {adinc/i05ad049.i 4 10} then do:
            /* mensagem: Conta n∆o aceita lancamentos do estoque */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15190,input " ").
            apply 'entry' to c-ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if not (lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) <> 0) then do:
            /* mensagem: Conta n∆o aceita lancamentos de requisiáÑes */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 107,input " ").
            apply 'entry' to c-ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.
        
    end.        

    if avail item and ( item.tipo-contr = 1 or item.tipo-contr = 4 ) 
    and   input frame {&frame-name} c-ct-codigo = "" then do:
        /* mensagem: Conta cont†bil deve ser informada */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 6726, input " ").
        apply 'entry' to c-ct-codigo in frame {&frame-name}.
        return 'adm-error':U.
    end.


   if  input frame {&frame-name} d-quantidade <> truncate(input frame {&frame-name} d-quantidade, 0)
   and item.fraciona = no  then do:
       /* mensagem: Valor n∆o pode ser fracionada campo item.fraciona = no */
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",input 847,input " ").
       apply 'entry' to d-quantidade in frame {&frame-name}.
       return 'adm-error':U.

   end.


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
  {src/adm/template/snd-list.i "saldo-terc"}
  {src/adm/template/snd-list.i "item-doc-est"}

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

