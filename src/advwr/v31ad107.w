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
{include/i-prgvrs.i V31AD107 2.00.00.006 } /*** "010006" 25/06/2025 16:21:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v31ad107 MUT}
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
def var c-conta-ipi-fat   as char no-undo.
def var c-conta-icms-ft   as char no-undo.
def var c-conta-recven    as char no-undo.
def var c-conta-fin-pag   as char no-undo.
def var c-conta-cusprod   as char no-undo.
def var c-conta-icmsub-ft as char no-undo.
def var c-conta-iss       as char no-undo.
def var c-conta-pis-rec   as char no-undo.
def var c-conta-devolucao as char no-undo.
def var c-conta-desconto  as char no-undo.
def var c-conta-credito   as char no-undo.
def var c-formato         as char no-undo.
def var l-habilita        as log  no-undo.
def var i-empresa         like param-global.empresa-prin  no-undo.

DEFINE TEMP-TABLE tt-estab-internac NO-UNDO LIKE estab-internac
    FIELD r-rowid AS ROWID.


/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/*Inicio Unifica‡Æo de Conceitos CONTA CONTABIL 2011*/
DEF VAR i-empresaCtContabel LIKE param-global.empresa-prin NO-UNDO.
def var h-v01ad107         as handle no-undo.
def var h-v02ad107         as handle no-undo.
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var v_cod_cta          as char   no-undo.
def var v_des_cta          as char   no-undo.
def var v_cod_ccust        as char   no-undo.
def var v_des_ccust        as char   no-undo.
def var v_cod_format_cta   as char   no-undo.
def var v_cod_format_ccust as char   no-undo.
def var v_cod_format_inic  as char   no-undo.
def var v_cod_format_fim   as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
def var v_num_tip_cta      as int    no-undo.
def var v_num_sit_cta      as int    no-undo.
def var v_log_utz_ccust    as log    no-undo.
DEF VAR v_cod_format_inic_ccust AS CHAR NO-UNDO.
DEF VAR v_cod_format_fim_ccust AS CHAR NO-UNDO.
DEF VAR l-utiliza-ccusto   AS LOG NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

/*Fim Unifica‡Æo de Conceitos CONTA CONTABIL 2011*/

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
&Scoped-Define ENABLED-FIELDS estabelec.ct-recven estabelec.ct-cusprod ~
estabelec.ct-devolucao 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS rt-key c-ct-dif-total-nota 
&Scoped-Define DISPLAYED-FIELDS estabelec.ct-recven estabelec.sc-recven ~
estabelec.ct-cusprod estabelec.sc-cusprod estabelec.ct-devolucao ~
estabelec.sc-devolucao 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-ct-dif-total-nota c-sc-dif-total-nota 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estabelec.sc-recven estabelec.sc-cusprod ~
estabelec.sc-devolucao 
&Scoped-define ADM-ASSIGN-FIELDS estabelec.sc-recven estabelec.sc-cusprod ~
estabelec.sc-devolucao 

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
DEFINE VARIABLE c-ct-dif-total-nota AS CHARACTER FORMAT "X(20)":U 
     LABEL "Dif Total da Nota" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-dif-total-nota AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC Dif Total da Nota" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.ct-recven AT ROW 1.29 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-recven AT ROW 2.29 COL 33 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-cusprod AT ROW 3.29 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-cusprod AT ROW 4.29 COL 33 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-devolucao AT ROW 5.29 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-devolucao AT ROW 6.29 COL 33 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-ct-dif-total-nota AT ROW 7.29 COL 33 COLON-ALIGNED
     c-sc-dif-total-nota AT ROW 8.29 COL 33 COLON-ALIGNED
     rt-key AT ROW 1 COL 2
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
         HEIGHT             = 8.58
         WIDTH              = 86.43.
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

ASSIGN 
       c-ct-dif-total-nota:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-sc-dif-total-nota IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-sc-dif-total-nota:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN estabelec.sc-cusprod IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-devolucao IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-recven IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME c-ct-dif-total-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON ENTRY OF c-ct-dif-total-nota IN FRAME f-main /* Dif Total da Nota */
DO:
    ASSIGN c-ct-dif-total-nota:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON F5 OF c-ct-dif-total-nota IN FRAME f-main /* Dif Total da Nota */
DO:
    RUN limpaErros.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,    /* EMPRESA EMS2 */
                                              input  "FTP",                  /* M¹DULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-ct-dif-total-nota:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON LEAVE OF c-ct-dif-total-nota IN FRAME f-main /* Dif Total da Nota */
DO:
  IF c-ct-dif-total-nota:SCREEN-VALUE <> "" THEN DO:
        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-ct-dif-total-nota NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-ct-dif-total-nota:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  "",                  /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN DO:
                ASSIGN c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-sc-dif-total-nota:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-sc-dif-total-nota:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-sc-dif-total-nota:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-dif-total-nota V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-dif-total-nota IN FRAME f-main /* Dif Total da Nota */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-dif-total-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON ENTRY OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Total da Nota */
DO:
  ASSIGN c-sc-dif-total-nota:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON F5 OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Total da Nota */
OR MOUSE-SELECT-DBLCLICK OF c-sc-dif-total-nota IN FRAME f-main
DO:
    RUN limpaErros.
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,  /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-sc-dif-total-nota:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-dif-total-nota V-table-Win
ON LEAVE OF c-sc-dif-total-nota IN FRAME f-main /* CC Dif Total da Nota */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-sc-dif-total-nota).
    ASSIGN c-sc-dif-total-nota:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-cusprod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-cusprod V-table-Win
ON ENTRY OF estabelec.ct-cusprod IN FRAME f-main /* Custo Prod Vendido */
DO:   
    ASSIGN estabelec.ct-cusprod:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-cusprod V-table-Win
ON F5 OF estabelec.ct-cusprod IN FRAME f-main /* Custo Prod Vendido */
DO:  
   RUN limpaErros.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,    /* EMPRESA EMS2 */
                                              input  "FTP",                  /* M¹DULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
        ASSIGN estabelec.ct-cusprod:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-cusprod V-table-Win
ON LEAVE OF estabelec.ct-cusprod IN FRAME f-main /* Custo Prod Vendido */
DO:   
    IF estabelec.ct-cusprod:SCREEN-VALUE <> "" THEN DO:
        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-cusprod NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-cusprod:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-cusprod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  "",                  /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN estabelec.sc-cusprod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-cusprod:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-cusprod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-cusprod:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-cusprod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-cusprod:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-cusprod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-cusprod IN FRAME f-main /* Custo Prod Vendido */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-devolucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON ENTRY OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devolu‡Æo */
DO:   
    ASSIGN estabelec.ct-devolucao:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON F5 OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devolu‡Æo */
DO:  
   RUN limpaErros.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,    /* EMPRESA EMS2 */
                                              input  "FTP",                  /* M¹DULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-devolucao:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON LEAVE OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devolu‡Æo */
DO:   
    IF estabelec.ct-devolucao:SCREEN-VALUE <> "" THEN DO:

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-devolucao NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-devolucao:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-devolucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  "",                  /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN DO:
                ASSIGN estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            END.
            ELSE 
                ASSIGN estabelec.sc-devolucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-devolucao:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-devolucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-devolucao:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-devolucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-devolucao:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devolu‡Æo */
DO:
    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-recven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-recven V-table-Win
ON ENTRY OF estabelec.ct-recven IN FRAME f-main /* Receita Vendas */
DO:
    ASSIGN estabelec.ct-recven:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-recven V-table-Win
ON F5 OF estabelec.ct-recven IN FRAME f-main /* Receita Vendas */
DO:  
   RUN limpaErros.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,    /* EMPRESA EMS2 */
                                              input  "FTP",                  /* M¹DULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-recven:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-recven V-table-Win
ON LEAVE OF estabelec.ct-recven IN FRAME f-main /* Receita Vendas */
DO:   
   IF estabelec.ct-recven:SCREEN-VALUE <> "" THEN DO:
        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-recven NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN estabelec.ct-recven:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-recven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  "",                  /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN DO:
                ASSIGN estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN estabelec.sc-recven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-recven:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN estabelec.sc-recven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-recven:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-recven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-recven:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-recven V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-recven IN FRAME f-main /* Receita Vendas */
DO:
      apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-cusprod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-cusprod V-table-Win
ON ENTRY OF estabelec.sc-cusprod IN FRAME f-main /* CC Custo Prod */
DO:
    ASSIGN estabelec.sc-cusprod:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-cusprod V-table-Win
ON F5 OF estabelec.sc-cusprod IN FRAME f-main /* CC Custo Prod */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-cusprod IN FRAME f-main
DO:
   RUN limpaErros.
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,  /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-cusprod:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-cusprod V-table-Win
ON LEAVE OF estabelec.sc-cusprod IN FRAME f-main /* CC Custo Prod */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-cusprod).
    ASSIGN estabelec.sc-cusprod:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-devolucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-devolucao V-table-Win
ON ENTRY OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devolu‡Æo */
DO:
    ASSIGN estabelec.sc-devolucao:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-devolucao V-table-Win
ON F5 OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devolu‡Æo */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-devolucao IN FRAME f-main
DO:
    RUN limpaErros.
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,  /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-devolucao:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-devolucao V-table-Win
ON LEAVE OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devolu‡Æo */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-devolucao).
    ASSIGN estabelec.sc-devolucao:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-recven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-recven V-table-Win
ON ENTRY OF estabelec.sc-recven IN FRAME f-main /* CC Receita Ven */
DO:
    ASSIGN estabelec.sc-recven:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-recven V-table-Win
ON F5 OF estabelec.sc-recven IN FRAME f-main /* CC Receita Ven */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-recven IN FRAME f-main
DO:
    RUN limpaErros.
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,  /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-recven:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-recven V-table-Win
ON LEAVE OF estabelec.sc-recven IN FRAME f-main /* CC Receita Ven */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-recven).
    ASSIGN estabelec.sc-recven:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if estabelec.ct-recven:load-mouse-pointer    ("image/lupa.cur") then.
  if estabelec.sc-recven:load-mouse-pointer    ("image/lupa.cur") then.
  if estabelec.ct-cusprod:load-mouse-pointer   ("image/lupa.cur") then.
  if estabelec.sc-cusprod:load-mouse-pointer   ("image/lupa.cur") then.
  if estabelec.ct-devolucao:load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-devolucao:load-mouse-pointer ("image/lupa.cur") then.
  if c-ct-dif-total-nota:load-mouse-pointer ("image/lupa.cur") then.
  if c-sc-dif-total-nota:load-mouse-pointer ("image/lupa.cur") then.

  if estabelec.sc-recven    :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-cusprod   :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-devolucao :sensitive in frame {&FRAME-NAME} = NO then.
  if c-sc-dif-total-nota    :sensitive in frame {&FRAME-NAME} = NO then.

  /*Unifica‡Æo de conceitos Conta-contabil ems5*/
   find first param-global no-lock no-error.
   IF AVAIL param-global THEN DO:
       ASSIGN i-empresaCtContabel = param-global.empresa-prin.
   END.

   RUN IniHandlers.

  /* Formatos de conta e centro de custo EMS5 */
  ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
         v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".
  /*Grava‡Æo de Formatos em Tela*/
  ASSIGN estabelec.sc-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
         estabelec.sc-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
         estabelec.sc-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
         estabelec.ct-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
         estabelec.ct-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
         estabelec.ct-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta.

  IF  i-pais-impto-usuario = 6 /* Uruguai */ 
  OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN
      ASSIGN c-sc-dif-total-nota:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             c-ct-dif-total-nota:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta.
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IniHandlers V-table-Win 
PROCEDURE IniHandlers :
/*------------------------------------------------------------------------------
  Purpose: Iniciar formatos para contas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Inicio Unifica‡Æo de Conceitos CONTA CONTABIL 2011*/
    RUN prgint\utb\utb743za.py PERSISTENT SET h_api_cta.
    RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccust.
   
    /* ---------------- CONTA ---------------------------------------------------------------------------------------*/
    RUN limpaErros.
    RUN pi_retorna_formato_cta_ctbl in h_api_cta (input i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  input  "",                 /* PLANO CONTAS */
                                                  input  today,              /* DATA DE TRANSACAO */
                                                  output v_cod_format_cta,   /* FORMATO cta */
                                                  output table tt_log_erro). /* ERROS */

    IF NOT CAN-FIND(tt_log_erro)
    OR RETURN-VALUE = "OK" THEN 
        ASSIGN v_cod_format_fim = v_cod_format_cta.
    
    /* ------------- CENTRO DE CUSTO --------------------------------------------------------------------------------------------*/
    RUN limpaErros.
    RUN pi_retorna_formato_ccusto in h_api_ccust (input  i-empresaCtContabel,    /* EMPRESA EMS2 */
                                                  input  "",                     /* PLANO CCUSTO */
                                                  input  today,                  /* DATA DE TRANSACAO */
                                                  output v_cod_format_ccust,     /* FORMATO CCUSTO */
                                                  output table tt_log_erro).     /* ERROS */

    IF NOT CAN-FIND(tt_log_erro)
    OR RETURN-VALUE = "OK" THEN 
        ASSIGN v_cod_format_fim_ccust = v_cod_format_ccust.

    /*Fim Unifica¯Êo de Conceitos CONTA CONTABIL 2011*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LimpaErros V-table-Win 
PROCEDURE LimpaErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN /*v_cod_cta         = ""   /* CODIGO CONTA */*/
           v_des_cta         = ""   /* DESCRICAO CONTA */
           v_ind_finalid_cta = ""   /* FINALIDADE DA CONTA */
           v_cod_ccust       = ""   /* CODIGO CCUSTO */
           v_des_ccust       = "".  /* DESCRICAO CCUSTO */

    FOR EACH tt_log_erro:
      DELETE tt_log_erro.
    END.
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
 
  /*{utp/ut-liter.i Custo_Prod_Vendas MCD l}
  assign estabelec.conta-cusprod:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-liter.i Transit¢ria_Devolu‡Æo MCD l}
  assign estabelec.conta-devolucao:label in frame {&frame-name} = trim(return-value).*/

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
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */       

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    RUN pi-verifica-ccusto (estabelec.ct-recven,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-recven = "".
    RUN pi-verifica-ccusto (estabelec.ct-cusprod,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-cusprod =  "".
    RUN pi-verifica-ccusto (estabelec.ct-devolucao,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-devolucao = "".              

    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

    DISABLE estabelec.sc-recven
            estabelec.sc-cusprod
            estabelec.sc-devolucao with frame {&frame-name}.

    IF  i-pais-impto-usuario = 6 /* Uruguai */ 
    OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN c-ct-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
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

    RUN pi-disp-estab-internac (INPUT TABLE tt-estab-internac).

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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif        
    

    IF AVAIL estabelec THEN DO:
      RUN pi-verifica-ccusto (estabelec.ct-recven,OUTPUT l-utiliza-ccusto).
      ASSIGN estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
      RUN pi-verifica-ccusto (estabelec.ct-cusprod,OUTPUT l-utiliza-ccusto).
      ASSIGN estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
      RUN pi-verifica-ccusto (estabelec.ct-devolucao,OUTPUT l-utiliza-ccusto).
      ASSIGN estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.

       IF  i-pais-impto-usuario = 6 /* Uruguai */ 
       OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
           RUN pi-verifica-ccusto (c-ct-dif-total-nota,OUTPUT l-utiliza-ccusto).
           ASSIGN c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
       END.
    END.

    IF  i-pais-impto-usuario = 6 /* Uruguai */ 
    OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN c-ct-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      
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
 /*FIND FIRST param-global NO-LOCK NO-ERROR.
  if  avail param-global then do:
      assign estabelec.conta-recven:format    in frame {&FRAME-NAME} = param-global.formato-conta-contabil
             estabelec.conta-cusprod:format   in frame {&FRAME-NAME} = param-global.formato-conta-contabil
             estabelec.conta-devolucao:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil.
  end.*/
                
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  DISABLE estabelec.sc-recven    with frame {&frame-name}.
  DISABLE estabelec.sc-cusprod   with frame {&frame-name}.
  DISABLE estabelec.sc-devolucao with frame {&frame-name}.
  
  IF  i-pais-impto-usuario = 6 /* Uruguai */ 
  OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN
      ASSIGN c-ct-dif-total-nota:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-sc-dif-total-nota:HIDDEN IN FRAME {&FRAME-NAME} = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disp-estab-internac V-table-Win 
PROCEDURE pi-disp-estab-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-estab-internac.

    FIND FIRST tt-estab-internac EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL tt-estab-internac THEN DO:
        IF  i-pais-impto-usuario = 6 /* Uruguai */ 
        OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
           ASSIGN c-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(tt-estab-internac.cod-livre-1,1,20) 
                  c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(tt-estab-internac.cod-livre-1,21,20).
        END.
    END.
    ELSE
        IF  i-pais-impto-usuario = 6 /* Uruguai */ 
        OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN 
            ASSIGN c-ct-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-sc-dif-total-nota:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-estab-internac-ury V-table-Win 
PROCEDURE pi-get-estab-internac-ury :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM pc-ct-dif-total-nota AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pc-sc-dif-total-nota AS CHAR NO-UNDO.
                  
    ASSIGN pc-ct-dif-total-nota = INPUT FRAME {&FRAME-NAME} c-ct-dif-total-nota 
           pc-sc-dif-total-nota = INPUT FRAME {&FRAME-NAME} c-sc-dif-total-nota.

    RETURN "OK":U.
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
DEF INPUT PARAM ph-v01ad107 AS HANDLE NO-UNDO.
DEF INPUT PARAM ph-v02ad107 AS HANDLE NO-UNDO.

ASSIGN h-v01ad107 = ph-v01ad107
       h-v02ad107 = ph-v02ad107.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-centro V-table-Win 
PROCEDURE pi-valida-centro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEF INPUT PARAMETER p-centro AS CHAR NO-UNDO.

   RUN LimpaErros.
   
   RUN pi_busca_dados_ccusto IN h_api_ccust (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                             INPUT        "",                  /* PLANO DE CONTAS */
                                             INPUT        p-centro,            /* CCUSTO */
                                             INPUT        TODAY,               /* DATA TRANSACAO */   
                                             OUTPUT       v_des_ccust,         /* DESCRICAO CCUSTO */
                                             OUTPUT TABLE tt_log_erro).        /* ERROS */
   
   /* validacao da conta */
   IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK" THEN
      RETURN "adm-error".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conta V-table-Win 
PROCEDURE pi-valida-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   {include/i-vldfrm.i}
   
   DEF INPUT PARAMETER p-conta AS CHAR NO-UNDO.
   
   ASSIGN i-empresaCtContabel = param-global.empresa-prin.
   
   IF p-conta <> "" THEN DO:
       
       ASSIGN v_cod_cta = p-conta.
       RUN limpaErros.

       RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel,     /* EMPRESA EMS2 */
                                                 INPUT        "",                      /* PLANO DE CONTAS */
                                                 INPUT-OUTPUT v_cod_cta,               /* CONTA */
                                                 INPUT        TODAY,                   /* DATA TRANSACAO */   
                                                 OUTPUT       v_des_cta,               /* DESCRICAO CONTA */
                                                 OUTPUT       v_num_tip_cta,           /* TIPO DA CONTA */
                                                 OUTPUT       v_num_sit_cta,           /* SITUAø°O DA CONTA */
                                                 OUTPUT       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                 OUTPUT TABLE tt_log_erro).            /* ERROS */
       
       /* validacao da conta */
       IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK" THEN DO:
           FOR FIRST tt_log_erro:
               RUN utp/ut-msgs.p (INPUT 'show',
                                  INPUT 17006, 
                                  INPUT STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
               RETURN "adm-error".
           END.
       END.
   END. /* FIM IF p-conta <> "" THEN DO: */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ContaCentro V-table-Win 
PROCEDURE pi-valida-ContaCentro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-conta  AS CHAR NO-UNDO.
    DEF INPUT PARAMETER p-centro AS CHAR NO-UNDO.

    run pi_valida_conta_contabil in h_api_cta (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                               input  estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                               input  "",                    /* UNIDADE NEGàCIO */
                                               input  "",                    /* PLANO CONTAS */ 
                                               input  p-conta,               /* CONTA */
                                               input  "",                    /* PLANO CCUSTO */ 
                                               input  p-centro,              /* CCUSTO */
                                               input  today,                 /* DATA TRANSACAO */
                                               output table tt_log_erro).    /* ERROS */

    IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK" THEN DO:
        FOR FIRST tt_log_erro:
            RUN utp/ut-msgs.p (INPUT 'show',
            INPUT 17006, 
            INPUT STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        RETURN "adm-error".
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

    IF NOT estabelec.ct-recven:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-recven).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            {utp/ut-liter.i "Receita Vendas" *}
            run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
            apply 'entry':U to estabelec.ct-recven in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-recven).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                {utp/ut-liter.i "CC Receita Ven" *}
                run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
                apply 'entry':U to estabelec.sc-recven in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-recven, INPUT FRAME {&FRAME-NAME} estabelec.sc-recven).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-recven IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-cusprod:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-cusprod).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            {utp/ut-liter.i "Custo Prod Vendido" *}
            run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
            apply 'entry':U to estabelec.ct-cusprod in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-cusprod).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                {utp/ut-liter.i "CC Custo Prod" *}
                run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
                apply 'entry':U to estabelec.sc-cusprod in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-cusprod, INPUT FRAME {&FRAME-NAME} estabelec.sc-cusprod).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-cusprod IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-devolucao:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-devolucao).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            {utp/ut-liter.i "Trans Devolu‡Æo" *}
            run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
            apply 'entry':U to estabelec.ct-devolucao in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-devolucao).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                {utp/ut-liter.i "CC Trans Devolu‡Æo" *}
                run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
                apply 'entry':U to estabelec.sc-devolucao in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-devolucao, INPUT FRAME {&FRAME-NAME} estabelec.sc-devolucao).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-devolucao IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.

    IF  i-pais-impto-usuario = 6 /* Uruguai */ 
    OR  i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-ct-dif-total-nota).
        IF RETURN-VALUE = "adm-error" THEN DO:
             {utp/ut-liter.i "Dif Total Nota" *}
             run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
             apply 'entry':U to c-ct-dif-total-nota in frame {&FRAME-NAME}.
             return 'adm-error'.
        END.
        IF c-sc-dif-total-nota:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-sc-dif-total-nota).
            IF RETURN-VALUE = "adm-error" THEN DO:
                 {utp/ut-liter.i "CC Dif Total Nota" *}
                 run utp/ut-msgs.p ("show",47,TRIM(RETURN-VALUE)).
                 apply 'entry':U to c-sc-dif-total-nota in frame {&FRAME-NAME}.
                 return 'adm-error'.
            END.
            RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-ct-dif-total-nota, INPUT FRAME {&FRAME-NAME} c-sc-dif-total-nota).
            IF RETURN-VALUE = "adm-error" THEN DO:
                APPLY 'entry':U TO c-sc-dif-total-nota IN FRAME {&FRAME-NAME}.
                RETURN 'adm-error'.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-ccusto V-table-Win 
PROCEDURE pi-verifica-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-conta AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-log  AS LOG  NO-UNDO.

RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                  INPUT  "",                  /* ESTABELECIMENTO EMS2 */
                                                  INPUT  "",                  /* PLANO CONTAS */
                                                  INPUT  p-conta,             /* CONTA */
                                                  INPUT  TODAY,               /* DT TRANSACAO */
                                                  OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                  OUTPUT TABLE tt_log_erro).  /* ERROS */       
ASSIGN p-log = v_log_utz_ccust.


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

