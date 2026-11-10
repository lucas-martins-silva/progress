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
{include/i-prgvrs.i V04IN087 2.00.00.029 } /*** 010029 ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in087 MUT}
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
def new global shared var v-row-parent    as rowid   no-undo.                                
def new global shared var i-programa-re   as integer no-undo.
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def buffer b-despesa for despesa-aces.
def buffer b-emitente for emitente. 
 
def var l-inclui as logical   no-undo.
def var c-handle as character no-undo.
def var i-cod-emit like emitente.cod-emitente no-undo.
def var h_principal as handle no-undo.
def var h_v05in087  as handle no-undo.
def var l-erro      as l      no-undo.
def var da-dt-aux   as date   no-undo.
def var wgh-label   as widget-handle no-undo.

def var i-cgc       as int init 1.
def var l-novo      as log.
def var c-formato   as char  no-undo.

 
{cdp/cd4300.i3} 
{cdp/cd0101.i50}

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

{rep/re9800.i} /* Flags para Codigos de Observacao */
{cdp/cdunif001.i} /* Vari veis da unifica‡Æo de conceito Conta Cont bil e Centro de Custo */

def var c-estabelec as char no-undo.

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
&Scoped-define EXTERNAL-TABLES despesa-aces
&Scoped-define FIRST-EXTERNAL-TABLE despesa-aces


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR despesa-aces.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS despesa-aces.cod-esp despesa-aces.tp-despesa ~
despesa-aces.dt-emissao despesa-aces.dt-vencto despesa-aces.ct-tr-fornec ~
despesa-aces.sc-tr-fornec despesa-aces.observacao 
&Scoped-define ENABLED-TABLES despesa-aces
&Scoped-define FIRST-ENABLED-TABLE despesa-aces
&Scoped-Define ENABLED-OBJECTS rt-key RECT-12 
&Scoped-Define DISPLAYED-FIELDS despesa-aces.cod-forn-ac ~
despesa-aces.ser-docto-ac despesa-aces.nat-oper-ac despesa-aces.cod-esp ~
despesa-aces.tp-despesa despesa-aces.dt-emissao despesa-aces.dt-vencto ~
despesa-aces.ct-tr-fornec despesa-aces.sc-tr-fornec despesa-aces.observacao 
&Scoped-define DISPLAYED-TABLES despesa-aces
&Scoped-define FIRST-DISPLAYED-TABLE despesa-aces
&Scoped-Define DISPLAYED-OBJECTS fi-fornec c-cgc fi-natureza fi-especie ~
fi-despesa fi-conta fi-ccusto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS despesa-aces.cod-forn-ac c-cgc ~
despesa-aces.ser-docto-ac c-nro-docto-ac despesa-aces.nat-oper-ac 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-c-cgc 
       MENU-ITEM m_Pessoa_Fsica LABEL "Pessoa F¡sica" 
       MENU-ITEM m_Pessoa_Jurdica LABEL "Pessoa Jur¡dica"
       MENU-ITEM m_Estrangeiro  LABEL "Estrangeiro"   
       MENU-ITEM m_Trading      LABEL "Trading"       .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-especie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-docto-ac AS CHARACTER FORMAT "x(16)":U INITIAL 0 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     despesa-aces.cod-forn-ac AT ROW 1.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     fi-fornec AT ROW 1.25 COL 42 COLON-ALIGNED NO-LABEL
     c-cgc AT ROW 2.25 COL 30.72 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     despesa-aces.ser-docto-ac AT ROW 3.25 COL 70.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-nro-docto-ac AT ROW 3.25 COL 30.72 COLON-ALIGNED
     despesa-aces.nat-oper-ac AT ROW 4.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     fi-natureza AT ROW 4.25 COL 41 COLON-ALIGNED NO-LABEL
     despesa-aces.cod-esp AT ROW 5.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     fi-especie AT ROW 5.25 COL 36 COLON-ALIGNED NO-LABEL
     despesa-aces.tp-despesa AT ROW 6.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-despesa AT ROW 6.25 COL 35.57 COLON-ALIGNED NO-LABEL
     despesa-aces.dt-emissao AT ROW 7.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     despesa-aces.dt-vencto AT ROW 7.25 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     despesa-aces.ct-tr-fornec AT ROW 8.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     fi-conta AT ROW 8.25 COL 49.43 COLON-ALIGNED NO-LABEL
     despesa-aces.sc-tr-fornec AT ROW 9.25 COL 30.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     fi-ccusto AT ROW 9.25 COL 49.43 COLON-ALIGNED NO-LABEL
     despesa-aces.observacao AT ROW 10.75 COL 6 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 77.14 BY 1
     rt-key AT ROW 1 COL 1
     RECT-12 AT ROW 10.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.despesa-aces
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
         HEIGHT             = 11.08
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       c-cgc:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cgc:HANDLE.

/* SETTINGS FOR FILL-IN despesa-aces.cod-forn-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-especie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-fornec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nro-docto-ac IN FRAME f-main
   NO-DISPLAY NO-ENABLE 1                                               */
/* SETTINGS FOR FILL-IN despesa-aces.nat-oper-ac IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.observacao IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN despesa-aces.ser-docto-ac IN FRAME f-main
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

&Scoped-define SELF-NAME c-cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON ENTRY OF c-cgc IN FRAME f-main
DO:
  if l-novo = yes then do:
  
  find b-emitente where 
     b-emitente.cod-emitente = input frame {&frame-name} despesa-aces.cod-forn-ac no-lock no-error.

     if avail b-emitente then 
        assign i-cgc = b-emitente.natureza
               l-novo = no.
  end. 
   
  if avail param-global then do:
   case i-cgc:
    when 1 then do:
     if  avail param-global and param-global.formato-id-pessoal <> "" then
      assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
    end. 
    when 2 then do: 
     if  avail param-global and param-global.formato-id-federal <> "" then
      assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
    end.
    otherwise  
      assign c-cgc:format in frame {&FRAME-NAME} = "x(19)".
   end.     
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON LEAVE OF c-cgc IN FRAME f-main
DO:
  
  if input frame {&frame-name} despesa-aces.cod-forn-ac = 0 then do:   
     find first b-emitente where 
                b-emitente.cgc = input frame {&frame-name} c-cgc no-lock no-error.
                
        if avail b-emitente then do:
           assign despesa-aces.cod-forn-ac:screen-value in frame {&frame-name} = string(b-emitente.cod-emitente)
                  fi-fornec:screen-value in frame {&frame-name} = string(b-emitente.nome-emit).               
        end.          
  end.   
             
  case i-cgc:
      when 1 then do:
         if  avail param-global and param-global.formato-id-pessoal <> "" then
             assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
      end. 
      when 2 then do: 
         if  avail param-global and param-global.formato-id-federal <> "" then
             assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
      end.
      otherwise 
         assign c-cgc:format in frame {&FRAME-NAME} = "x(19)".
      
  end.  
  
  assign c-formato = input frame {&FRAME-NAME} c-cgc no-error.

  if  ERROR-STATUS:ERROR then do:
      assign c-cgc:format in frame {&FRAME-NAME} = "x(19)".
  end.
      
  apply "leave" to despesa-aces.cod-forn-ac in frame {&frame-name}.    
                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-esp V-table-Win
ON F5 OF despesa-aces.cod-esp IN FRAME f-main /* Esp‚cie */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-esp IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=despesa-aces.cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-esp V-table-Win
ON LEAVE OF despesa-aces.cod-esp IN FRAME f-main /* Esp‚cie */
DO:
    {include/leave.i &tabela=espec-ap
                     &atributo-ref=descricao
                     &variavel-ref=fi-especie
                     &where="espec-ap.cod-esp = input frame {&frame-name}
                             despesa-aces.cod-esp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.cod-forn-ac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-forn-ac V-table-Win
ON F5 OF despesa-aces.cod-forn-ac IN FRAME f-main /* C¢digo Fornecedor Acess¢rio */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-forn-ac IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=despesa-aces.cod-forn-ac
                       &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-forn-ac V-table-Win
ON LEAVE OF despesa-aces.cod-forn-ac IN FRAME f-main /* C¢digo Fornecedor Acess¢rio */
DO:
    assign l-novo = yes. 
    
    if input frame {&frame-name} despesa-aces.cod-forn-ac <> 0 then do:
    
    {include/leave.i &tabela=b-emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-fornec
                     &where="b-emitente.cod-emitente = input frame {&frame-name}
                             despesa-aces.cod-forn-ac"}
                             
    {include/leave.i &tabela=b-emitente
                     &atributo-ref=cgc
                     &variavel-ref=c-cgc
                     &where="b-emitente.cod-emitente = input frame {&frame-name}
                             despesa-aces.cod-forn-ac"}
    end. 
    
    else assign c-cgc:screen-value in frame {&frame-name} = "". 
                                                        
 
    if  avail b-emitente and adm-new-record then do:
        find cond-pagto 
            where cond-pagto.cod-cond-pag = b-emitente.cod-cond-pag no-lock no-error.
        if  avail cond-pagto then
            disp (today + cond-pagto.prazos[1]) @ despesa-aces.dt-vencto
                 with frame {&frame-name}.
        else 
            disp today @ despesa-aces.dt-vencto
                 with frame {&frame-name}.
    end.
 
    if  adm-new-record then do:
        if  i-programa-re = 3 then do:              /* Recebimento Internacional */
            run pi-inicializa-campos in h_v05in087 (?). /*Executa com ? para inicializar informa‡äes emitente*/
            run pi-inicializa-campos in h_v05in087      /*Executa novamente para reatualizar a data*/
               (input input frame {&frame-name} despesa-aces.dt-emissao).
            
        end.
        else 
            run pi-cria-tt-docto in h_v05in087 ( input frame {&frame-name} despesa-aces.cod-forn-ac, ?, yes ).
    end.                
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.ct-tr-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON F5 OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
 
   DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
   IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
   ELSE 
        ASSIGN dt-trans-aux = TODAY.

   IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
   IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  i-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
   IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN despesa-aces.ct-tr-fornec:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN fi-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
   END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON ENTRY OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
    ASSIGN despesa-aces.ct-tr-fornec:FORMAT IN FRAME f-main = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON LEAVE OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
 
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    /* Unifica‡Æo de conceito conta cont bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = REPLACE(despesa-aces.ct-tr-fornec:SCREEN-VALUE IN FRAME f-main,".","").

    /* Busca dados da conta cont bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?€O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:

        /* Busca formato de apresenta‡Æo da conta cont bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  i-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  dt-trans-aux,         /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN despesa-aces.ct-tr-fornec:FORMAT IN FRAME f-main = "X(20)"
               despesa-aces.ct-tr-fornec:SCREEN-VALUE = v_cod_cta_ctbl
               fi-conta:SCREEN-VALUE IN FRAME f-main = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN despesa-aces.ct-tr-fornec:FORMAT = p_cod_format_cta_ctbl.
    
        /* Verifica se a conta utiliza centro de custo */
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  NOT p_log_ccusto THEN
            ASSIGN despesa-aces.sc-tr-fornec:FORMAT IN FRAME f-main = "X(20)"
                   despesa-aces.sc-tr-fornec:SCREEN-VALUE IN FRAME f-main = ""
                   fi-ccusto:SCREEN-VALUE IN FRAME f-main = ""
                   despesa-aces.sc-tr-fornec:SENSITIVE IN FRAME f-main = NO.
        ELSE DO:
            RUN GET-ATTRIBUTE ('adm-new-record').
            IF  RETURN-VALUE = "NO":U THEN DO: /* Est  alterando um registro */
                ASSIGN despesa-aces.sc-tr-fornec:SENSITIVE IN FRAME f-main = YES.
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME f-main.
                RETURN NO-APPLY.
            END.
        END.
    END.
    ELSE
        ASSIGN fi-conta:SCREEN-VALUE IN FRAME f-main = "".
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ct-tr-fornec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.ct-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
 
  apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.sc-tr-fornec IN FRAME f-main /* CCusto Transit¢ria Fornecedores */
DO:
 
  ASSIGN despesa-aces.sc-tr-fornec:FORMAT IN FRAME f-main = "x(20)".
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.sc-tr-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON F5 OF despesa-aces.sc-tr-fornec IN FRAME f-main /* CCusto Transit¢ria Fornecedores */
DO:
 
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT i-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                  /* Unidade de Negocio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* C½digo da Conta*/
                                                   INPUT "",                  /* C½digo do Plano de Centro de Custo*/
                                                   INPUT dt-trans-aux,        /* Data da Transacao*/
                                                   OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN despesa-aces.sc-tr-fornec:SCREEN-VALUE = v_cod_ccusto
               fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON LEAVE OF despesa-aces.sc-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
 
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = REPLACE(despesa-aces.sc-tr-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").
    
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca m scara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  i-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  dt-trans-aux,        /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
        /* Aplica a m scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN despesa-aces.sc-tr-fornec:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.sc-tr-fornec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.sc-tr-fornec IN FRAME f-main /* Conta Transit¢ria Fornecedores */
DO:
 
  apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.dt-emissao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.dt-emissao V-table-Win
ON LEAVE OF despesa-aces.dt-emissao IN FRAME f-main /* Data EmissÆo */
DO:
  /*
     Este c¢digo dever  ser executado quando se tratar do 
     Recebimento Internacional 
  */

  if i-programa-re = 3 then 
      run pi-inicializa-campos in h_v05in087 
         (input input frame {&frame-name} despesa-aces.dt-emissao).
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Estrangeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Estrangeiro V-table-Win
ON CHOOSE OF MENU-ITEM m_Estrangeiro /* Estrangeiro */
DO:
  assign i-cgc = 3.
  apply "entry" to c-cgc in frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pessoa_Fsica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pessoa_Fsica V-table-Win
ON CHOOSE OF MENU-ITEM m_Pessoa_Fsica /* Pessoa F¡sica */
DO:
  assign i-cgc = 1.
  apply "entry" to c-cgc in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pessoa_Jurdica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pessoa_Jurdica V-table-Win
ON CHOOSE OF MENU-ITEM m_Pessoa_Jurdica /* Pessoa Jur¡dica */
DO:
  assign i-cgc = 2.
  apply "entry" to c-cgc in frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Trading
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Trading V-table-Win
ON CHOOSE OF MENU-ITEM m_Trading /* Trading */
DO:
  assign i-cgc = 4.
  apply "entry" to c-cgc in frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.nat-oper-ac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.nat-oper-ac V-table-Win
ON F5 OF despesa-aces.nat-oper-ac IN FRAME f-main /* Natureza */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.nat-oper-ac IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=despesa-aces.nat-oper-ac
                       &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.nat-oper-ac V-table-Win
ON LEAVE OF despesa-aces.nat-oper-ac IN FRAME f-main /* Natureza */
DO:
 
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-natureza
                     &where="natur-oper.nat-operacao = input frame {&frame-name}
                             despesa-aces.nat-oper-ac"}
 
 
    if  adm-new-record then do:
        if  i-programa-re <> 3 then              
            run pi-cria-tt-docto in h_v05in087 ( ?, input frame {&frame-name} despesa-aces.nat-oper-ac, yes ).
    end.                                             
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.ser-docto-ac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ser-docto-ac V-table-Win
ON F5 OF despesa-aces.ser-docto-ac IN FRAME f-main /* S‚rie Documento */
DO:
  apply "MOUSE-SELECT-DBCLICK" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.ser-docto-ac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.ser-docto-ac IN FRAME f-main /* S‚rie Documento */
DO:
    l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=despesa-aces.ser-docto
                       &campozoom=serie}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.tp-despesa V-table-Win
ON F5 OF despesa-aces.tp-despesa IN FRAME f-main /* Tipo Despesa */
OR  MOUSE-SELECT-DBLCLICK OF despesa-aces.tp-despesa IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=despesa-aces.tp-despesa
                       &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.tp-despesa V-table-Win
ON LEAVE OF despesa-aces.tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
    {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao
                     &variavel-ref=fi-despesa
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name}
                             despesa-aces.tp-despesa"}
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
 
 
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  if avail docum-est then
     assign c-estabelec = docum-est.cod-estabel.
  find first param-global no-lock no-error.
  find first param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find estabelec where estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  find emitente where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.      
  find b-emitente where b-emitente.cod-emitente = despesa-aces.cod-forn-ac no-lock no-error.
  
  if  despesa-aces.cod-forn-ac:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.nat-oper-ac:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.cod-esp:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.tp-despesa:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.ser-docto-ac:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.ct-tr-fornec:load-mouse-pointer("image/lupa.cur") then .
  if  despesa-aces.sc-tr-fornec:load-mouse-pointer("image/lupa.cur") then .
  
  c-cgc:load-mouse-pointer ("image~\rbm.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "despesa-aces"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "despesa-aces"}

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
  assign l-inclui = yes.
  
  display docum-est.dt-emissao    @ despesa-aces.dt-emissao
          emitente.tp-desp-padrao @ despesa-aces.tp-despesa
          param-re.esp-def-dac    @ despesa-aces.cod-esp
          with frame {&frame-name}.
 
  find estabelec where
       estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  if avail estabelec then
     assign despesa-aces.ser-docto-ac:screen-value in frame {&frame-name} = estabelec.serie-manual.     
 
  IF NOT l-ut-ser
      AND i-pais-impto-usuario <> 1 THEN DO:

      IF NOT AVAIL param-estoq THEN
          FOR FIRST param-estoq NO-LOCK: END.

      ASSIGN despesa-aces.ser-docto-ac:screen-value in frame {&frame-name} = SUBSTRING(param-estoq.char-2,69,5).

  END.
  /*display param-estoq.conta-fornec @ despesa-aces.ct-tr-fornec
          with frame {&frame-name}.*/

  assign i-empresa = param-global.empresa-prin.
      
  &if defined (bf_dis_consiste_conta) &then
      
      find estabelec where
           estabelec.cod-estabel = c-estabelec no-lock no-error.
           
      if avail estabelec then     
         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
  &endif

  assign despesa-aces.ct-tr-fornec:screen-value in frame {&frame-name}  = param-estoq.ct-tr-fornec
         despesa-aces.sc-tr-fornec:screen-value in frame {&frame-name} = param-estoq.sc-tr-fornec.

  APPLY "leave":U TO despesa-aces.ct-tr-fornec IN FRAME {&frame-name}.
  APPLY "leave":U TO despesa-aces.sc-tr-fornec IN FRAME {&frame-name}.

  if i-programa-re = 3 then 
      run pi-inicializa-campos in h_v05in087 
         (input docum-est.dt-emissao).
 
 
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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  if  avail docum-est then do:
      assign despesa-aces.cod-emitente = docum-est.cod-emitente
             despesa-aces.nat-operacao = docum-est.nat-operacao
             despesa-aces.serie-docto  = docum-est.serie-docto
             despesa-aces.nro-docto    = docum-est.nro-docto.
  end.

  assign i-empresa = param-global.empresa-prin.
      
  &if defined (bf_dis_consiste_conta) &then
      
      find estabelec where
           estabelec.cod-estabel = c-estabelec no-lock no-error.
      if avail estabelec then     
         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
  &endif  

  assign despesa-aces.ct-tr-fornec = despesa-aces.ct-tr-fornec:SCREEN-VALUE IN FRAME {&frame-name}
         despesa-aces.sc-tr-fornec = despesa-aces.sc-tr-fornec:SCREEN-VALUE IN FRAME {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
 
  if avail despesa-aces then
    assign despesa-aces.nro-docto-ac = input frame {&frame-name} c-nro-docto-ac.
 
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
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  if  avail despesa-aces then do:
      if not adm-new-record then
        disp despesa-aces.nro-docto-ac @ c-nro-docto-ac with frame {&frame-name}.
 
      find docum-est where rowid(docum-est) = v-row-parent 
           no-lock no-error.

      find emitente where emitente.cod-emitente = docum-est.cod-emitente
           no-lock no-error.

          find b-emitente where b-emitente.cod-emitente = despesa-aces.cod-forn-ac 
               no-lock no-error.
           
      find natur-oper where natur-oper.nat-operacao = despesa-aces.nat-oper-ac
           no-lock no-error.
           
      find espec-ap where espec-ap.cod-esp = despesa-aces.cod-esp 
           no-lock no-error.
           
      find tipo-rec-desp where tipo-rec-desp.tp-codigo = despesa-aces.tp-despesa
           no-lock no-error.
           
               
        assign fi-fornec   = if avail b-emitente then b-emitente.nome-emit else ""
               fi-natureza = if avail natur-oper then natur-oper.denominacao else ""
               fi-especie  = if avail espec-ap then espec-ap.descricao else ""
               fi-despesa  = if avail tipo-rec-desp then tipo-rec-desp.descricao 
                           else "".   
                           

    assign i-empresa = param-global.empresa-prin.
        
    &if defined (bf_dis_consiste_conta) &then
        
        find estabelec where
             estabelec.cod-estabel = c-estabelec no-lock no-error.
        if avail estabelec then     
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa).
    &endif

    
  end.

   assign c-cgc:format in frame {&FRAME-NAME} = "x(19)".
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
   find b-emitente where 
           b-emitente.cod-emitente = despesa-aces.cod-forn-ac no-lock no-error.
           
        if avail b-emitente then do:
          if b-emitente.cod-emitente <> 0 then do:
             assign c-cgc:screen-value in frame {&frame-name} = b-emitente.cgc
                    fi-fornec   = if avail b-emitente then b-emitente.nome-emit else "".
             case b-emitente.natureza:
                when 1 then do:
                   if  avail param-global and param-global.formato-id-pessoal <> "" then
                   assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal no-error.
                end. 
                when 2 then do: 
                   if  avail param-global and param-global.formato-id-federal <> "" then
                   assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal no-error.
                end.
                otherwise  
                assign c-cgc:format in frame {&FRAME-NAME} = "x(19)" no-error.
             end.            
          end. 
          assign c-cgc:screen-value in frame {&frame-name} = b-emitente.cgc no-error.
        end.
           
        if  ERROR-STATUS:ERROR then do:
            assign c-cgc:format in frame {&FRAME-NAME} = "x(19)" no-error.
        end.   

   APPLY "LEAVE":U TO despesa-aces.ct-tr-fornec IN FRAME {&frame-name}.
   APPLY "LEAVE":U TO despesa-aces.sc-tr-fornec IN FRAME {&frame-name}.
 
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
 
  if  adm-new-record = no 
  and avail despesa-aces  then do:
      /* Recebimento Internacional */
 

      if  i-programa-re = 3    then 
           run pi-inicializa-data in h_v05in087 (input despesa-aces.dt-emissao).
      else 
          /* Recebimento Brasil */  
          run pi-cria-tt-docto in h_v05in087 ( despesa-aces.cod-forn-ac, despesa-aces.nat-oper-ac, no ).
  end.                    
 
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
  
   {utp/ut-field.i mgadm emitente cgc 1}
   assign c-cgc:label in frame {&frame-name} = trim(return-value).
  
  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  find first param-global no-lock no-error.  
 
  if i-pais-impto-usuario <> 1 then do:
    /*Quando tem valor na param-estoq deve ser considerado o que est  nesse campo e nÆo na param-global*/
    IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
        ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
    ELSE DO:
        {cdp/cd4300.i4  "yes" param-global.char-2}             
        {cdp/cd0101.i51 "yes"}
    END.
    if l-ut-ser = yes then
       assign despesa-aces.ser-docto-ac:hidden in frame {&frame-name} = no.
    else assign despesa-aces.ser-docto-ac:hidden in frame {&frame-name} = yes
                despesa-aces.cod-forn-ac:row in frame {&frame-name} = despesa-aces.cod-forn-ac:row + 1
                fi-fornec:row in frame {&frame-name} = despesa-aces.cod-forn-ac:row 
                wgh-label = despesa-aces.cod-forn-ac:SIDE-LABEL-HANDLE
                wgh-label:row = despesa-aces.cod-forn-ac:row 
                c-cgc:row in frame {&frame-name} = c-cgc:row + 1
                c-cgc:COL in frame {&frame-name} = c-cgc:COL + 34
                wgh-label = c-cgc:SIDE-LABEL-HANDLE
                wgh-label:row = c-cgc:row
                wgh-label:COL = c-cgc:COL - 6.6.
  end.

  IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
  IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h_handle1 as handle no-undo.
def input parameter h_handle2 as handle no-undo.
 
assign h_principal = h_handle1
       h_v05in087  = h_handle2.
 
/*
   Esta viewer ‚ utilizada tamb‚m pelo Recebimento Internacional.
   O segundo parƒmetro trata-se da viewer V06IN087 utilizada no
   programa RE3001F
*/
 
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
 
  if input frame {&frame-name} despesa-aces.cod-forn-ac = 0 then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show":U, input 6189, input "").
     apply "entry" to despesa-aces.cod-forn-ac in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end. 
 
  if input frame {&frame-name} c-nro-docto-ac = " "  then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show":U, input 16686, input "").
     apply "entry" to c-nro-docto-ac in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end. 
 
  if  l-inclui then do with frame {&frame-name}:
      find b-despesa where
           b-despesa.cod-emitente = docum-est.cod-emitente and
           b-despesa.nat-operacao = docum-est.nat-operacao and
           b-despesa.serie-docto  = docum-est.serie-docto  and
           b-despesa.nro-docto    = docum-est.nro-docto    and
           b-despesa.cod-forn-ac  = input despesa-aces.cod-forn-ac  and
           b-despesa.nat-oper-ac  = input despesa-aces.nat-oper-ac  and
           b-despesa.ser-docto-ac = input despesa-aces.ser-docto-ac and
           b-despesa.nro-docto-ac = input c-nro-docto-ac
           no-lock no-error.
      if  avail b-despesa then do:
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind despesa-aces 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          return 'ADM-ERROR':U.
      end.
  end.
  
  assign i-empresa = param-global.empresa-prin.
        
  &if defined (bf_dis_consiste_conta) &then
        
      find estabelec where
           estabelec.cod-estabel = c-estabelec no-lock no-error.
      if avail estabelec then     
         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
  &endif  
  
  RUN pi-valida-conta-ccusto.
  IF  RETURN-VALUE = "NOK":U THEN
    return 'ADM-ERROR':U.


 
  if  docum-est.cod-emitente = input despesa-aces.cod-forn-ac  
  and docum-est.nat-operacao = input despesa-aces.nat-oper-ac
  and docum-est.serie-docto  = input despesa-aces.ser-docto-ac 
  and docum-est.nro-docto    = input c-nro-docto-ac then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 7, input "").
      apply "entry":U to despesa-aces.cod-forn-ac in frame {&frame-name}. 
      return 'ADM-ERROR':U.
  end.
  if  i-pais-impto-usuario = 1   /**** Brasil *****/
  and param-global.modulo-of then do with frame {&frame-name}:
      find doc-fiscal where
           doc-fiscal.cod-estabel  = docum-est.estab-fisc            and
           doc-fiscal.serie        = input despesa-aces.ser-docto-ac and
           doc-fiscal.nr-doc-fis   = input c-nro-docto-ac            and
           doc-fiscal.cod-emitente = input despesa-aces.cod-forn-ac  and
           doc-fiscal.nat-operacao = input despesa-aces.nat-oper-ac no-lock no-error.
      if  available doc-fiscal then do:
          if  doc-fiscal.dt-docto <> docum-est.dt-trans then do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5136, input "").
              apply "entry":U to despesa-aces.cod-forn-ac in frame {&frame-name}. 
              return 'ADM-ERROR':U.
 
          end.
          else do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5137, input "").
              if  return-value = "no" then do:
                  apply "entry":U to despesa-aces.cod-forn-ac in frame {&frame-name}. 
                  return 'ADM-ERROR':U.
              end.    
          end.
      end.
  end.
  find tipo-rec-desp where
       tipo-rec-desp.tp-codigo = input frame {&frame-name} despesa-aces.tp-despesa
       no-lock no-error.
  if  not avail tipo-rec-desp or tipo-rec-desp.tipo = 1 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 4995, input "").
      apply "entry":U to despesa-aces.tp-despesa in frame {&frame-name}. 
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} despesa-aces.dt-emissao < today - param-re.var-emis
  then do:  
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 270, input "").
      apply "entry":U to despesa-aces.dt-emissao in frame {&frame-name}. 
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} despesa-aces.dt-vencto 
  <   input frame {&frame-name} despesa-aces.dt-emissao then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 3730, input "").
      apply "entry":U to despesa-aces.dt-vencto in frame {&frame-name}. 
      return 'ADM-ERROR':U.
  end.
  find natur-oper where
       natur-oper.nat-operacao = input frame {&frame-name} despesa-aces.nat-oper-ac
       no-lock no-error.
 
  if  natur-oper.emite-duplic and param-global.modulo-ap and avail param-ap 
  and input frame {&frame-name} despesa-aces.dt-vencto < param-ap.dt-ult-fec then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 270, input "").
      apply "entry":U to despesa-aces.dt-vencto in frame {&frame-name}. 
      return 'ADM-ERROR':U.
  end.
  
  find estabelec where 
       estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
  
  find emitente where 
       emitente.cod-emitente = input frame {&frame-name} despesa-aces.cod-forn-ac 
       no-lock no-error.
       
  if  i-pais-impto-usuario = 1 then   /**** Brasil *****/
        assign l-erro = yes.
  else         
        assign l-erro = no.
 

  if  emitente.estado = estabelec.estado and (natur-oper.nat-operacao begins "1"
  or natur-oper.nat-operacao begins "5") then
     assign l-erro = no.

  else 
  if  emitente.estado <> estabelec.estado
  and emitente.natureza = 3 /*"E"*/
  and (natur-oper.nat-operacao begins "3"
    or natur-oper.nat-operacao begins "7") then
       assign l-erro = no.
       
  else
  if  emitente.estado <> estabelec.estado
  and emitente.natureza <> 3 /*"E"*/
  and (natur-oper.nat-operacao begins "2"
    or natur-oper.nat-operacao begins "6") then
       assign l-erro = no.       
       
  if l-erro then do:
      /*"Natureza de Operacao nao confere com Movimentacao efetuada. Confirma?"*/
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5125, input "").
      if  return-value = "no" then do:
          apply "entry" to despesa-aces.nat-oper-ac in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conta-ccusto V-table-Win 
PROCEDURE pi-valida-conta-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     realizar as valida‡äes da conta e centro de custo
               ** Unifica‡Æo de conceito **
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-num-finalid-cta AS INTEGER                NO-UNDO.
    DEFINE VARIABLE v_log_utz_ccusto  AS LOGICAL                NO-UNDO.
    DEFINE VARIABLE c-ct-transit-aux  LIKE docum-est.ct-transit NO-UNDO.
    DEFINE VARIABLE c-sc-transit-aux  LIKE docum-est.sc-transit NO-UNDO.
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN c-ct-transit-aux = REPLACE(despesa-aces.ct-tr-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","")
           c-sc-transit-aux = REPLACE(despesa-aces.sc-tr-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME},".","").
    
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_valida_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  i-empresa,          /* EMPRESA EMS2 */
                                                     INPUT  "CEP":U,            /* MODULO */
                                                     INPUT  "",                 /* PLANO CONTAS */ 
                                                     INPUT  c-ct-transit-aux,   /* CONTA */
                                                     INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                     INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */ 
                                                     OUTPUT TABLE tt_log_erro). /* ERROS */

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  AVAIL tt_log_erro THEN DO:
        /*{include/i-vldprg.i}*/
        {utp/ut-liter.i "'Conta Contabil'" *}
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
        APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt_log_erro.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  c-ct-transit-aux,   /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  v_log_utz_ccusto THEN DO:
            EMPTY TEMP-TABLE tt_log_erro.
            RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-empresa,          /* EMPRESA EMS2 */
                                                       INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       INPUT  c-sc-transit-aux,   /* CCUSTO */
                                                       INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                                       OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                       OUTPUT TABLE tt_log_erro). /* ERROS */ 
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
            IF  AVAIL tt_log_erro THEN DO:
                /*{include/i-vldprg.i}*/
                {utp/ut-liter.i "'Centro Custo'" *}
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
                APPLY "ENTRY":U TO despesa-aces.sc-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
    END.

    
    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_cta_ctbl = c-ct-transit-aux.   

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */

    RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa,         /* EMPRESA EMS2 */
                                                          INPUT        "CEP":U,           /* MàDULO */
                                                          INPUT        "",                /* PLANO DE CONTAS */
                                                          INPUT        v_cod_cta_ctbl,    /* CONTA */
                                                          INPUT        dt-trans-aux,      /* DATA TRANSACAO */   
                                                          OUTPUT       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          OUTPUT TABLE tt_log_erro).      /* ERROS */ 
    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt_log_erro THEN DO:
        
        ASSIGN i-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}.
        
        IF  v_num_sit_cta_ctbl <> 3 THEN DO: /* Sistema */
            /*{include/i-vldprg.i}*/
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 1062, INPUT "").
            APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
            RETURN "NOK":U.
        END.    
        IF  i-num-finalid-cta = 10 THEN DO: /* Nao Aceita Lan‡amentos */
            /*{include/i-vldprg.i}*/
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 445, INPUT "").
            APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
            RETURN "NOK":U.
        END.
        IF  l-transf THEN DO:
            IF  i-num-finalid-cta <> 4 THEN DO: /* Transferˆncia */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 747, INPUT "").
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
        ELSE IF l-ent-cons THEN DO:
            IF  i-num-finalid-cta <> 2 THEN DO: /* NÆo Consumo */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6323, INPUT "").
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
        
        IF  l-retorno THEN DO:
            /*--- se a natureza eh de retorno beneficiamento nao precisa verificar se eh consumo ou nao consumo ---*/
            IF  i-num-finalid-cta <> 1          /* Consumo */
            AND i-num-finalid-cta <> 2 THEN DO: /* NÆo Consumo */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6325, INPUT "").
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.        
        ELSE IF l-devolucao THEN DO:
            IF  i-num-finalid-cta <> 2          /* NÆo Consumo */
            AND i-num-finalid-cta <> 6          /* CPV */
            AND i-num-finalid-cta <> 8 THEN DO: /* Transit¢ria Devolu‡Æo */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6317, INPUT "").
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.  
        ELSE DO:
            IF  i-num-finalid-cta <> 2          /* NÆo Consumo */
            AND i-num-finalid-cta <> 4          /* Transferˆncia */
            AND i-num-finalid-cta <> 7 THEN DO: /* Transit¢ria Compras */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 438, INPUT "").
                APPLY "ENTRY":U TO despesa-aces.ct-tr-fornec IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
    END.       
    
    RETURN "OK":U.
    
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
  {src/adm/template/snd-list.i "despesa-aces"}

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

