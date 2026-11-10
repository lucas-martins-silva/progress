&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V23IN090 2.00.00.018}  /*** "010018" ***/
 
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v23in090 MUT}
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
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
 
def var i-emitente like emitente.cod-emitente.
def new global shared var l-re3000a-inclui as logical no-undo.
def var c-natureza like docum-est.nat-operacao.
def var i-especie     as integer     no-undo.
def var i-observa     as integer     no-undo.
def var c-per-cotacao as char        no-undo.
def var dt-emissao    like docum-est.dt-emissao no-undo.
def var l-nff         as logical     no-undo.
def var l-atualizou-nff as l init no no-undo.
def var c-parametro     as char      no-undo.
def var c-estabelec as char no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
DEFINE VARIABLE c-empresa LIKE param-global.empresa-prin NO-UNDO.
{cdp/cdcfgdis.i}
 
{rep/re9800.i} /* Flags para Codigos de Observacao */
def temp-table tt-inicializa
    field cod-emitente      like docum-est.cod-emitente     initial ?
    field uf                like docum-est.uf               initial ?
    field nat-operacao      like docum-est.nat-operacao     initial ?
    field esp-docto         like docum-est.esp-docto        initial ?
    field cod-observa       like docum-est.cod-observa      initial ?
    field despesa-nota      like docum-est.despesa-nota     initial ?
    field tot-peso          like docum-est.tot-peso         initial ?    
    field valor-frete       like docum-est.valor-frete      initial ?    
    field valor-mercad      like docum-est.valor-mercad     initial ?
    field tot-desconto      like docum-est.tot-desconto     initial ?. 
 
DEFINE VARIABLE h_v22in090 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v23in090 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v17in090 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_re3001a  AS HANDLE NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.uf docum-est.mo-codigo ~
docum-est.cotacao-dia docum-est.valor-frete-me docum-est.valor-seguro-me ~
docum-est.valor-embal-me docum-est.valor-outras-me ~
docum-est.valor-mercad-me docum-est.ct-transit docum-est.sc-transit 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 rt-key cb-vl-tot-nota ~ de-arredonda
&Scoped-Define DISPLAYED-FIELDS docum-est.uf docum-est.nff ~
docum-est.mo-codigo docum-est.cotacao-dia docum-est.valor-frete-me ~
docum-est.valor-seguro-me docum-est.valor-embal-me ~
docum-est.valor-outras-me docum-est.despesa-nota-me ~
docum-est.valor-mercad-me docum-est.ct-transit docum-est.sc-transit 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-uf cb-via-transp fi-moeda cb-vl-tot-nota  de-arredonda  ~
fi-c-desc-conta  fi-c-desc-ccusto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS docum-est.uf cb-via-transp docum-est.nff 
&Scoped-define ADM-MODIFY-FIELDS cb-via-transp docum-est.nff 

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
DEFINE VARIABLE cb-via-transp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Rodoferrovi†rio" 
     DROP-DOWN-LIST
     SIZE 25.43 BY 1 NO-UNDO.

DEFINE VARIABLE fi-c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 4.38.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 4.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 3.13.

DEFINE VARIABLE cb-vl-tot-nota AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Desconto","1",
                     "Sobretaxa","2"
     DROP-DOWN-LIST
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE de-arredonda AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.uf AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     fi-uf AT ROW 1.17 COL 23.57 COLON-ALIGNED NO-LABEL
     cb-via-transp AT ROW 4.17 COL 17 COLON-ALIGNED
     docum-est.nff AT ROW 5.54 COL 26
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .83
     docum-est.mo-codigo AT ROW 6.54 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-moeda AT ROW 6.54 COL 27.43 COLON-ALIGNED NO-LABEL
     docum-est.cotacao-dia AT ROW 7.54 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     docum-est.valor-frete-me AT ROW 8.96 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.valor-seguro-me AT ROW 9.96 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.valor-embal-me AT ROW 10.96 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     cb-vl-tot-nota AT ROW 11 COL 48 COLON-ALIGNED NO-LABEL
     de-arredonda AT ROW 11 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 18
  
     docum-est.valor-outras-me AT ROW 11.96 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.despesa-nota-me AT ROW 8.96 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.valor-mercad-me AT ROW 9.96 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.ct-transit AT ROW 2.17 COL 17 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-c-desc-conta AT ROW 2.17 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     docum-est.sc-transit AT ROW 3.17 COL 17 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-c-desc-ccusto AT ROW 3.17 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     RECT-1 AT ROW 1 COL 1
     RECT-3 AT ROW 8.75 COL 1
     rt-key AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 12
         WIDTH              = 85.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-via-transp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN docum-est.despesa-nota-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-uf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX docum-est.nff IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN docum-est.uf IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME docum-est.cotacao-dia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cotacao-dia V-table-Win
ON LEAVE OF docum-est.cotacao-dia IN FRAME f-main /* Cotaá∆o Dia */
DO:
  apply "leave" to docum-est.valor-frete-me in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.ct-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON ENTRY OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:

    ASSIGN SELF:FORMAT = "X(20)".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON LEAVE OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:

    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = /*INPUT FRAME f-main*/ docum-est.ct-transit.
    
    /* Busca dados da conta cont†bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresentaá∆o da conta cont†bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  dt-trans-aux,         /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.
    
        /* Verifica se a conta utiliza centro de custo */
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        ASSIGN docum-est.sc-transit:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        IF  NOT p_log_ccusto THEN
            ASSIGN docum-est.sc-transit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        ELSE DO:
            RUN GET-ATTRIBUTE ('adm-new-record').
            IF  RETURN-VALUE = "NO":U THEN DO: /* Est† alterando um registro */
                APPLY "ENTRY":U TO docum-est.sc-transit IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.
    END.
    ELSE
        ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON F5 OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                     &campo=docum-est.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON LEAVE OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda
                     &where="moeda.mo-codigo = input frame {&frame-name} docum-est.mo-codigo"}
    if input frame {&frame-name} docum-est.mo-codigo = 0 then 
        assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1"
               docum-est.cotacao-dia:sensitive in frame {&frame-name} = no.
    else do:
      find first cotacao 
           where cotacao.mo-codigo = input frame {&frame-name} docum-est.mo-codigo
           and   cotacao.ano-periodo = c-per-cotacao no-lock no-error.
      assign docum-est.cotacao-dia:screen-value in frame {&FRAME-NAME} = if available cotacao then
                                                                        string(cotacao.cotacao[day(dt-emissao)])
                                                                        else "0".
      assign docum-est.cotacao-dia:sensitive in frame {&frame-name} = yes.
      apply 'entry' to docum-est.cotacao-dia in frame {&frame-name}.       
      return no-apply.
    end.    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.sc-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON ENTRY OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:
    
    ASSIGN SELF:FORMAT = "X(20)".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON LEAVE OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:

    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = INPUT FRAME f-main docum-est.sc-transit.
    
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca m†scara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  dt-trans-aux,        /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
        /* Aplica a m†scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.uf V-table-Win
ON F5 OF docum-est.uf IN FRAME f-main /* Unid Federaá∆o */
DO:
    assign l-implanta = yes. 
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=docum-est.uf
                       &campozoom=estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.uf V-table-Win
ON LEAVE OF docum-est.uf IN FRAME f-main /* Unid Federaá∆o */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cod-estabel").
    find estabelec where
         estabelec.cod-estabel = return-value no-lock no-error. 
    if avail estabelec then do:
        {include/leave.i &tabela=unid-feder
                         &atributo-ref=no-estado
                         &variavel-ref=fi-uf
                         &where="unid-feder.pais   = estabelec.pais and
                                 unid-feder.estado = input frame {&frame-name}
                                 docum-est.uf"}
    end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.uf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.uf IN FRAME f-main /* Unid Federaá∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-embal-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-embal-me V-table-Win
ON LEAVE OF docum-est.valor-embal-me IN FRAME f-main /* Vl Embal ME */
DO:
    apply "leave" to docum-est.valor-frete-me in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-frete-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-frete-me V-table-Win
ON LEAVE OF docum-est.valor-frete-me IN FRAME f-main /* Vl Frete ME */
DO:
        assign docum-est.despesa-nota-me:screen-value in frame {&frame-name} = 
                                 string((input frame {&frame-name} docum-est.valor-frete-me)  + 
                                        (input frame {&frame-name} docum-est.valor-seguro-me) +
                                        (input frame {&frame-name} docum-est.valor-embal-me)  +
                                        (input frame {&frame-name} docum-est.valor-outras-me)).      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-outras-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-outras-me V-table-Win
ON LEAVE OF docum-est.valor-outras-me IN FRAME f-main /* Vl Outras ME */
DO:
    apply "leave" to docum-est.valor-frete-me in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-seguro-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-seguro-me V-table-Win
ON LEAVE OF docum-est.valor-seguro-me IN FRAME f-main /* Vl Seguro ME */
DO:
    apply "leave" to docum-est.valor-frete-me in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  find first param-estoq  no-lock no-error.
  find first param-global no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

  /* Busca empresa */
  ASSIGN c-empresa = param-global.empresa-prin.
 
  {utp/ut-field.i mgind docum-est via-transp 1}
  assign cb-via-transp:label in frame {&frame-name} = return-value.
 
  if docum-est.uf:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.mo-codigo:load-mouse-pointer("image/lupa.cur") then .
  docum-est.ct-transit:LOAD-MOUSE-POINTER("image/lupa.cur").
  docum-est.sc-transit:LOAD-MOUSE-POINTER("image/lupa.cur").
 
 
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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  assign l-nff = docum-est.nff:checked in frame {&frame-name}.
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.
 
  assign docum-est.nff = l-nff
         input frame {&frame-name} cb-via-transp
         docum-est.via-transp = {adinc/i01ad268.i 06 cb-via-transp}.
         docum-est.sit-docum = if docum-est.nff or
                                 (not docum-est.nff and
                                  not natur-oper.emite-duplic)
                                then 1 
                                else 2.
 
/*sempre pede na tela os campos -me e calcula os campos na moeda corrente multiplicando pela cotacao.
  Sempre que a moeda for zero, a cotaá∆o ser† 1*/
      assign docum-est.valor-frete     = docum-est.valor-frete-me  * docum-est.cotacao-dia
             docum-est.valor-seguro    = docum-est.valor-seguro-me * docum-est.cotacao-dia
             docum-est.valor-embal     = docum-est.valor-embal-me  * docum-est.cotacao-dia
             docum-est.valor-outras    = docum-est.valor-outras-me * docum-est.cotacao-dia
             docum-est.despesa-nota    = docum-est.valor-frete  + docum-est.valor-seguro
                                       + docum-est.valor-embal  + docum-est.valor-outras
             docum-est.valor-mercad    = docum-est.valor-mercad-me * docum-est.cotacao-dia.                                       
 
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
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

  assign i-empresa = i-ep-codigo-usuario.
      
  &if defined (bf_dis_consiste_conta) &then
      
      find estabelec where
           estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
      
      run cdp/cd9970.p (input rowid(estabelec),
                        output i-empresa).
  &endif
  

  DISPLAY docum-est.ct-transit
          docum-est.sc-transit WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO docum-est.sc-transit IN FRAME {&FRAME-NAME}.

  find moeda where moeda.mo-codigo = input frame {&frame-name} docum-est.mo-codigo no-lock no-error.
  assign fi-moeda:screen-value = if avail moeda then moeda.descricao else "":U.
 
 
  if  avail docum-est then do with frame {&frame-name}:
      cb-via-transp:screen-value = {adinc/i01ad268.i 04 docum-est.via-transp}.
      find estabelec where estabelec.cod-estabel = docum-est.cod-estabel
           no-lock no-error.
      if  avail estabelec then do:
          find unid-feder where unid-feder.pais   = estabelec.pais and
                                unid-feder.estado = input docum-est.uf
               no-lock no-error.                              
          assign fi-uf:screen-value  = if avail unid-feder then unid-feder.no-estado
                                       else "".
      end.
      assign c-per-cotacao = string(year(docum-est.dt-emissao),'9999')
                           + string(month(docum-est.dt-emissao),'99')
             dt-emissao    = docum-est.dt-emissao.
  end.
  else do with frame {&frame-name}:
      assign cb-via-transp:screen-value = {adinc/i01ad268.i 04 1}
             docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1".
  end.

   IF  i-pais-impto-usuario = 6 /* Uruguai */ THEN DO:
        FIND FIRST ext-docum-est NO-LOCK
            WHERE ext-docum-est.cod-emitente = docum-est.cod-emitente
              AND ext-docum-est.nat-operacao = docum-est.nat-operacao
              AND ext-docum-est.nro-docto    = docum-est.nro-docto   
              AND ext-docum-est.serie-docto  = docum-est.serie-docto 
              AND ext-docum-est.cod-param    = "arredondamentoTotalNota":U NO-ERROR.
        IF  AVAIL ext-docum-est THEN DO:
            ASSIGN cb-vl-tot-nota:SCREEN-VALUE IN FRAME {&frame-name} = STRING(ext-docum-est.num-livre-1)
                   de-arredonda  :SCREEN-VALUE IN FRAME {&frame-name} = STRING(ext-docum-est.val-livre-1).
        END.
        ELSE
            ASSIGN cb-vl-tot-nota:SCREEN-VALUE IN FRAME {&frame-name} = "1"
                   de-arredonda  :SCREEN-VALUE IN FRAME {&frame-name} = "0".
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  if adm-new-record = yes then do:
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  end.
  do with frame {&FRAME-NAME}:
      assign docum-est.nff:sensitive             = no
             docum-est.uf:sensitive              = param-re.alt-uf
             cb-via-transp:sensitive             = yes.
  end.
 
  if param-re.tp-doc-perm = 3 then
      assign docum-est.nff:sensitive in frame {&frame-name} = yes.
 
 
  if avail natur-oper  and 
  (natur-oper.transf = yes or natur-oper.terceiros = yes) then do:
        assign docum-est.mo-codigo = 0 
               docum-est.cotacao-dia = 1.    
        disable docum-est.mo-codigo
                docum-est.cotacao-dia with frame {&frame-name}.
  end.      
  
  if  avail natur-oper 
  and natur-oper.nota-rateio then do:
      enable docum-est.valor-mercad-me with frame {&frame-name}.
      assign docum-est.nff:sensitive in frame {&frame-name} = yes.
  end.
  else 
      disable docum-est.valor-mercad-me with frame {&frame-name}.     
          
  if avail docum-est and docum-est.mo-codigo = 0 then 
      disable docum-est.cotacao-dia with frame {&frame-name}.
  else 
      enable docum-est.cotacao-dia  with frame {&frame-name}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit V-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finanáas -> handle Conta Cont†bil */
      DELETE PROCEDURE h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
  END.
    
  IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finanáas -> handle Centro de Custo */
      DELETE PROCEDURE h_api_ccusto.
      ASSIGN h_api_ccusto = ?.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  assign cb-via-transp:list-items in frame {&frame-name} = {adinc/i01ad268.i 03}.
 
  IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
      RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
  IF  NOT VALID-HANDLE(h_api_ccusto) THEN
      RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


    IF  i-pais-impto-usuario = 6 /* Uruguai */ THEN
         ASSIGN cb-vl-tot-nota:HIDDEN IN FRAME {&FRAME-NAME} = NO
                cb-vl-tot-nota:SENSITIVE  = NO
                de-arredonda  :HIDDEN IN FRAME {&FRAME-NAME} = NO
                de-arredonda  :sensitive = NO.
     ELSE
         ASSIGN cb-vl-tot-nota:HIDDEN IN FRAME {&FRAME-NAME} = YES
                de-arredonda  :HIDDEN IN FRAME {&FRAME-NAME} = YES.

 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param table for tt-inicializa.
def input param da-dt-emissao like docum-est.dt-emissao no-undo.
find first tt-inicializa no-error.
 
if adm-new-record = yes and not l-atualizou-nff then do:
    assign l-atualizou-nff = yes.
    if param-re.tp-doc-perm = 1 then 
        assign docum-est.nff:checked in frame {&frame-name}  = yes.
    else if param-re.tp-doc-perm = 2 then 
        assign docum-est.nff:checked in frame {&frame-name} = no.
    else assign docum-est.nff:sensitive in frame {&frame-name} = yes
                docum-est.nff:checked in frame {&frame-name} = no.
end.
if param-re.tp-doc-perm = 3 then
    assign docum-est.nff:sensitive in frame {&frame-name} = yes.
 
assign c-per-cotacao = string(year(da-dt-emissao),'9999')
                     +  string(month(da-dt-emissao),'99')
       dt-emissao    = da-dt-emissao.
if l-re3000a-inclui and tt-inicializa.cod-emitente <> ? then do with frame {&FRAME-NAME}:
    assign i-emitente = tt-inicializa.cod-emitente.
    find cotacao where
         cotacao.mo-codigo  = input frame {&frame-name} docum-est.mo-codigo and
         cotacao.ano-periodo = c-per-cotacao no-lock no-error.
 
    assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = 
                                 if avail cotacao then
                                      string(cotacao.cotacao[day(da-dt-emissao)])
                                 else "1".
    if avail cotacao then 
        enable  docum-est.cotacao-dia with frame {&frame-name}.
    else 
        disable docum-est.cotacao-dia with frame {&frame-name}.
 
    if input frame {&frame-name} docum-est.mo-codigo = 0 then 
       assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1"
              docum-est.cotacao-dia:sensitive in frame {&frame-name} = no.
 
/*    find emitente where emitente.cod-emitente = i-emitente
 *          no-lock no-error.
 *     if  avail emitente then do:
 *         find unid-feder where unid-feder.pais   = emitente.pais and
 *                               unid-feder.estado = if tt-inicializa.uf = ? then emitente.estado
 *                                                   else tt-inicializa.uf
 *              no-lock no-error.                              
 *         assign docum-est.uf:screen-value = if avail unid-feder then unid-feder.estado
 *                                            else ""
 *                fi-uf:screen-value        = if avail unid-feder then unid-feder.no-estado
 *                                            else "".
 *         
 *     end.*/
 
    find emitente where emitente.cod-emitente = i-emitente
         no-lock no-error.
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cod-estabel").
 
    find estabelec where
         estabelec.cod-estabel = return-value no-lock no-error.
 
    if tt-inicializa.uf <> ? and avail estabelec then do:
        find unid-feder where unid-feder.pais   = estabelec.pais and
                              unid-feder.estado = tt-inicializa.uf no-lock no-error.                              
        assign docum-est.uf:screen-value = if avail unid-feder then unid-feder.estado
                                           else tt-inicializa.uf
               fi-uf:screen-value        = if avail unid-feder then unid-feder.no-estado
                                           else "".
    end.
end.
 
if l-re3000a-inclui and tt-inicializa.cod-observa <> ? 
            and tt-inicializa.nat-operacao <> ? then do with frame {&FRAME-NAME}:
 
    assign c-natureza = tt-inicializa.nat-operacao 
           i-especie  = tt-inicializa.esp-docto
           i-observa  = tt-inicializa.cod-observa.
 
    find natur-oper where natur-oper.nat-operacao = tt-inicializa.nat-operacao 
        no-lock no-error.
    if avail natur-oper then do:
 
        run pi-seta-flags-observacao (input tt-inicializa.cod-observa, input tt-inicializa.nat-operacao).
 
/*         /*  Determina Conta Contabil */                                                                         */
/*         if  l-transf then                                                                                       */
/*             assign docum-est.conta-transit:screen-value = param-estoq.conta-transf.                             */
/*         else                                                                                                    */
/*         /* Nao considera Faturamento de Consignacao que ira assumir a                                           */
/*            transitoria de fornecedores */                                                                       */
/*         if  natur-oper.terceiros and natur-oper.tp-oper-terc <> 4 then do:                                      */
/*             if  natur-oper.tp-oper-terc = 1 then                                           /*Entrada p/ Benef*/ */
/*                 assign docum-est.conta-transit:screen-value = param-estoq.conta-consig.                         */
/*             else if natur-oper.tp-oper-terc = 2 then                                       /*Retorno Benef*/    */
/*                 assign docum-est.conta-transit:screen-value = param-estoq.conta-terceiros.                      */
/*             else if natur-oper.tp-oper-terc = 5 then                                       /*Devol Consig*/     */
/*                 assign docum-est.conta-transit:screen-value = conta-aux[1].                                     */
/*             else                                                                                                */
/*                 assign docum-est.conta-transit:screen-value = conta-aux[2] .               /*Compra Consig*/    */
/*         end.                                                                                                    */
/*         else                                                                                                    */
/*         if  l-devolucao then                                                                                    */
/*             assign docum-est.conta-transit:screen-value = param-estoq.conta-dev-cli.                            */
/*         else                                                                                                    */
/*         if natur-oper.tipo = 2 and i-especie = 20 then /*devolucao a fornecedor*/                               */
/*             assign docum-est.conta-transit:screen-value = param-estoq.conta-devol.                              */
/*         else                                                                                                    */
/*             assign docum-est.conta-transit:screen-value = param-estoq.conta-fornec.                             */
/*                                                                                                                 */
        if natur-oper.transf = yes or 
           natur-oper.terceiros = yes then do:
              assign docum-est.mo-codigo = 0 
                     docum-est.cotacao-dia = 1.    
              disable docum-est.mo-codigo
                      docum-est.cotacao-dia with frame {&frame-name}.
        end.  
        else enable docum-est.mo-codigo
                    docum-est.cotacao-dia with frame {&frame-name}.
 
        if input frame {&frame-name} docum-est.mo-codigo = 0 then 
           assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1"
                  docum-est.cotacao-dia:sensitive in frame {&frame-name} = no.
 
 
        /*habilita campos de valores*/
        if l-transf = no then do:
            assign docum-est.valor-frete-me:sensitive     = yes
                   docum-est.valor-seguro-me:sensitive    = yes
                   docum-est.valor-embal-me:sensitive     = yes
                   docum-est.valor-outras-me:sensitive    = yes.
 
        end.
        
        if  natur-oper.nota-rateio then 
            assign docum-est.valor-mercad-me:sensitive = yes
                   docum-est.nff:checked in frame {&frame-name} = yes
                   docum-est.nff:sensitive in frame {&frame-name} = no.
            
        
    end.

    assign i-empresa = param-global.empresa-prin.
      
    &if defined (bf_dis_consiste_conta) &then
      
        find estabelec where
             estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
      
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif

/*     find conta-contab where conta-contab.ep-codigo = i-empresa and                                     */
/*                           conta-contab.conta-contabil = input docum-est.conta-transit                  */
/*          no-lock no-error.                                                                             */
/*     assign fi-conta-contabil:screen-value = if avail conta-contab then conta-contab.titulo else "":U.  */
end.
if tt-inicializa.nat-operacao <> ? and l-transf = no then 
    assign docum-est.valor-embal-me:sensitive     = yes
           docum-est.valor-frete-me:sensitive     = yes
           docum-est.valor-outras-me:sensitive    = yes
           docum-est.valor-seguro-me:sensitive    = yes.
 
if adm-new-record = yes and
   not l-transf         and
   docum-est.nff:checked in frame {&frame-name} = yes then do:
    enable docum-est.mo-codigo with frame {&frame-name}.
    assign docum-est.mo-codigo:screen-value in frame {&frame-name} = "0".
end.
 
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
def input param h-handle-1 as handle no-undo.
def input param h-handle-2 as handle no-undo.
def input param h-handle-3 as handle no-undo.
 
assign h_v22in090 = h-handle-1
       h_v17in090 = h-handle-2
       h_re3001a  = h-handle-3.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-totais V-table-Win 
PROCEDURE pi-retorna-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param table for tt-inicializa.
 
/*run pi-recria-tt-inicializa.
assign tt-inicializa.despesa-nota = input frame {&FRAME-NAME} docum-est.despesa-nota
       tt-inicializa.tot-peso     = input frame {&FRAME-NAME} docum-est.tot-peso   
       tt-inicializa.tot-desconto  = input frame {&FRAME-NAME} docum-est.tot-desconto     
       tt-inicializa.valor-mercad = input frame {&FRAME-NAME} docum-est.valor-mercad.*/
 
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
if adm-new-record = no then do:
    assign c-natureza = trim(docum-est.nat-operacao).
    find emitente where
         emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
    find estabele 
        where estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.         
end.
 
run pi-seta-flags-observacao (input i-observa, input c-natureza).
assign i-empresa = param-global.empresa-prin.
  
&if defined (bf_dis_consiste_conta) &then
  
    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  
    run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa).
&endif

if  avail estabelec then do:
    find unid-feder where                   /* Verifica pais e estado */
         unid-feder.pais   = estabelec.pais and 
         unid-feder.estado = input frame {&frame-name} docum-est.uf
         no-lock no-error.
    if  not avail unid-feder then do:
        {utp/ut-table.i mguni unid-feder 1}
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 2, input return-value).
        apply "entry" to docum-est.uf in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
end.    
 
 
if  (docum-est.nff:checked in frame {&FRAME-NAME}     /*Docto Ç NFF e o usu†rio s¢ possue permiss∆o p/ Remitos*/
     and param-re.tp-doc-perm = 2)
or  (not docum-est.nff:checked in frame {&FRAME-NAME} /*Docto Ç remito e o usu†rio s¢ possue permiss∆o p/ NFF*/
     and param-re.tp-doc-perm = 1)      then do:
 
    if param-re.tp-doc-perm = 2 then  
        assign c-parametro = {ininc/i11in292.i 4 1} + "~~" + {ininc/i11in292.i 4 2}.     
    else                    
        assign c-parametro = {ininc/i11in292.i 4 2} + "~~" + {ininc/i11in292.i 4 1}.     
 
    {include/i-vldprg.i} 
    run utp/ut-msgs.p (input "show":U, input 16149, input c-parametro).
    apply "entry" to docum-est.nff in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.
 
find moeda where
     moeda.mo-codigo   = input frame {&frame-name} docum-est.mo-codigo no-lock no-error.
if not avail moeda then do:
    {utp/ut-table.i mguni moeda 1}
    {include/i-vldprg.i} 
    run utp/ut-msgs.p (input "show":U, input 2, input return-value).
    apply "entry" to docum-est.mo-codigo in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.     
 
if  natur-oper.nota-rateio 
and input frame {&FRAME-NAME} docum-est.valor-mercad-me = 0 then do:
    {include/i-vldprg.i} 
    run utp/ut-msgs.p (input "show":U, input 15114, input "").
    apply "entry" to docum-est.valor-mercad-me in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.
 
 
find first cotacao where
     cotacao.mo-codigo   = input frame {&frame-name} docum-est.mo-codigo and
     cotacao.ano-periodo = c-per-cotacao
     no-lock no-error.
if (not avail cotacao or 
   input frame {&frame-name} docum-est.cotacao-dia = 0) and
   input frame {&frame-name} docum-est.mo-codigo <> 0 then do:
    {include/i-vldprg.i} 
    run utp/ut-msgs.p (input "show":U, input 316, input moeda.descricao + "~~" + string(dt-emissao)).
    apply "entry" to docum-est.mo-codigo in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "docum-est"}

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

