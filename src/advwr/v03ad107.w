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
{include/i-prgvrs.i V03AD107 2.00.00.017 } /*** "010017" 25/06/2025 16:21:13  ***/


&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03AD107 MUT}
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
DEF VAR c-cod-estabel     AS CHAR NO-UNDO.
DEF VAR c-cod-empresa     AS CHAR NO-UNDO.

def var i-empresa         like param-global.empresa-prin  no-undo.

/*Inicio Unificaá∆o de Conceitos CONTA CONTABIL 2011*/
DEF VAR i-empresaCtContabel LIKE param-global.empresa-prin NO-UNDO.
def var h_api_cta          as handle no-undo.
def var h-v01ad107         as handle no-undo.
DEF VAR h-v02ad107         AS HANDLE NO-UNDO.
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
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".


/*Fim Unificaá∆o de Conceitos CONTA CONTABIL 2011*/

{cdp/cdcfgdis.i} /*definicao de pre-processadores*/

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
estabelec.ct-ipi-ft estabelec.ct-icms-ft estabelec.ct-icmsub-ft ~
estabelec.cod-cta-inss-recolh estabelec.ct-devolucao estabelec.ct-desconto ~
estabelec.ct-iss estabelec.ct-pis estabelec.ct-fins-pg 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS c-cod-cta-pis-substto ~
c-cod-cta-cofins-substto RECT-2 
&Scoped-Define DISPLAYED-FIELDS estabelec.ct-recven estabelec.sc-recven ~
estabelec.ct-cusprod estabelec.sc-cusprod estabelec.ct-ipi-ft ~
estabelec.sc-ipi-ft estabelec.ct-icms-ft estabelec.sc-icms-ft ~
estabelec.ct-icmsub-ft estabelec.sc-icmsub-ft estabelec.cod-cta-inss-recolh ~
estabelec.cod-ccusto-inss-recolh estabelec.ct-devolucao ~
estabelec.sc-devolucao estabelec.ct-desconto estabelec.sc-desconto ~
estabelec.ct-iss estabelec.sc-iss estabelec.ct-pis estabelec.sc-pis ~
estabelec.ct-fins-pg estabelec.sc-fins-pg 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-cod-cta-pis-substto ~
c-cod-ccusto-pis-substto c-cod-cta-cofins-substto ~
c-cod-ccusto-cofins-substto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estabelec.sc-recven estabelec.sc-cusprod ~
estabelec.sc-ipi-ft estabelec.sc-icms-ft estabelec.sc-icmsub-ft ~
c-cod-ccusto-pis-substto estabelec.cod-ccusto-inss-recolh ~
estabelec.sc-devolucao estabelec.sc-desconto estabelec.sc-iss ~
estabelec.sc-pis estabelec.sc-fins-pg c-cod-ccusto-cofins-substto 
&Scoped-define ADM-ASSIGN-FIELDS estabelec.sc-recven estabelec.sc-cusprod ~
estabelec.sc-ipi-ft estabelec.sc-icms-ft estabelec.sc-icmsub-ft ~
c-cod-ccusto-pis-substto estabelec.cod-ccusto-inss-recolh ~
estabelec.sc-devolucao estabelec.sc-desconto estabelec.sc-iss ~
estabelec.sc-pis estabelec.sc-fins-pg c-cod-ccusto-cofins-substto 

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
DEFINE VARIABLE c-cod-ccusto-cofins-substto AS CHARACTER FORMAT "x(20)" 
     LABEL "CC Cofins Substit" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-cod-ccusto-pis-substto AS CHARACTER FORMAT "x(20)" 
     LABEL "CC PIS Substituto" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-cod-cta-cofins-substto AS CHARACTER FORMAT "x(20)" 
     LABEL "Cta COFINS Subst" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE VARIABLE c-cod-cta-pis-substto AS CHARACTER FORMAT "x(20)" 
     LABEL "Cta PIS Substituto" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 13.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.ct-recven AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-recven AT ROW 1.21 COL 65.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-cusprod AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-cusprod AT ROW 2.21 COL 65.14 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-ipi-ft AT ROW 3.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-ipi-ft AT ROW 3.21 COL 65.14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-icms-ft AT ROW 4.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-icms-ft AT ROW 4.21 COL 65.14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-icmsub-ft AT ROW 5.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-icmsub-ft AT ROW 5.21 COL 65.14 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-cod-cta-pis-substto AT ROW 6.21 COL 20 COLON-ALIGNED
     c-cod-ccusto-pis-substto AT ROW 6.21 COL 65.14 COLON-ALIGNED WIDGET-ID 12
     estabelec.cod-cta-inss-recolh AT ROW 7.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.cod-ccusto-inss-recolh AT ROW 7.21 COL 65.14 COLON-ALIGNED WIDGET-ID 14
          LABEL "CC Inss Recolher"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-devolucao AT ROW 8.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-devolucao AT ROW 8.21 COL 65.14 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-desconto AT ROW 9.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-desconto AT ROW 9.21 COL 65.14 COLON-ALIGNED WIDGET-ID 18
          LABEL "CC Despesa (desc.)"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-iss AT ROW 10.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-iss AT ROW 10.21 COL 65.14 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-pis AT ROW 11.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-pis AT ROW 11.21 COL 65.14 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.ct-fins-pg AT ROW 12.21 COL 20 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     estabelec.sc-fins-pg AT ROW 12.21 COL 65.14 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-cod-cta-cofins-substto AT ROW 13.21 COL 20 COLON-ALIGNED
     c-cod-ccusto-cofins-substto AT ROW 13.21 COL 65.14 COLON-ALIGNED WIDGET-ID 26
     RECT-2 AT ROW 1 COL 1
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
         HEIGHT             = 13.63
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-cod-ccusto-cofins-substto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN c-cod-ccusto-pis-substto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-inss-recolh IN FRAME f-main
   NO-ENABLE 1 2 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN estabelec.sc-cusprod IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-desconto IN FRAME f-main
   NO-ENABLE 1 2 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN estabelec.sc-devolucao IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-fins-pg IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-icms-ft IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-icmsub-ft IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-ipi-ft IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-iss IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN estabelec.sc-pis IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-ccusto-cofins-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-cofins-substto V-table-Win
ON ENTRY OF c-cod-ccusto-cofins-substto IN FRAME f-main /* CC Cofins Substit */
DO:
    ASSIGN c-cod-ccusto-cofins-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-cofins-substto V-table-Win
ON F5 OF c-cod-ccusto-cofins-substto IN FRAME f-main /* CC Cofins Substit */
OR MOUSE-SELECT-DBLCLICK OF c-cod-ccusto-cofins-substto IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-ccusto-cofins-substto:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-cofins-substto V-table-Win
ON LEAVE OF c-cod-ccusto-cofins-substto IN FRAME f-main /* CC Cofins Substit */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-ccusto-cofins-substto).
    ASSIGN c-cod-ccusto-cofins-substto:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-ccusto-pis-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-pis-substto V-table-Win
ON ENTRY OF c-cod-ccusto-pis-substto IN FRAME f-main /* CC PIS Substituto */
DO:
    ASSIGN c-cod-ccusto-pis-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-pis-substto V-table-Win
ON F5 OF c-cod-ccusto-pis-substto IN FRAME f-main /* CC PIS Substituto */
OR MOUSE-SELECT-DBLCLICK OF c-cod-ccusto-pis-substto IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-ccusto-pis-substto:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto-pis-substto V-table-Win
ON LEAVE OF c-cod-ccusto-pis-substto IN FRAME f-main /* CC PIS Substituto */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-ccusto-pis-substto).
    ASSIGN c-cod-ccusto-pis-substto:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cta-cofins-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-cofins-substto V-table-Win
ON ENTRY OF c-cod-cta-cofins-substto IN FRAME f-main /* Cta COFINS Subst */
DO:
    ASSIGN c-cod-cta-cofins-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-ccusto-cofins-substto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-cofins-substto V-table-Win
ON F5 OF c-cod-cta-cofins-substto IN FRAME f-main /* Cta COFINS Subst */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-cofins-substto:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-cofins-substto V-table-Win
ON LEAVE OF c-cod-cta-cofins-substto IN FRAME f-main /* Cta COFINS Subst */
DO:
    IF c-cod-cta-cofins-substto:SCREEN-VALUE <> "" THEN DO:

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-cofins-substto NO-ERROR.
       
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN c-cod-cta-cofins-substto:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-cofins-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.

            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN c-cod-ccusto-cofins-substto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN c-cod-ccusto-cofins-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-ccusto-cofins-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN c-cod-ccusto-cofins-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-ccusto-cofins-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-ccusto-cofins-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-ccusto-cofins-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-cofins-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-cofins-substto IN FRAME f-main /* Cta COFINS Subst */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cta-pis-substto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-pis-substto V-table-Win
ON ENTRY OF c-cod-cta-pis-substto IN FRAME f-main /* Cta PIS Substituto */
DO:
    ASSIGN c-cod-cta-pis-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-ccusto-pis-substto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-pis-substto V-table-Win
ON F5 OF c-cod-cta-pis-substto IN FRAME f-main /* Cta PIS Substituto */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-pis-substto:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-pis-substto V-table-Win
ON LEAVE OF c-cod-cta-pis-substto IN FRAME f-main /* Cta PIS Substituto */
DO:
    IF c-cod-cta-pis-substto:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-pis-substto NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN c-cod-cta-pis-substto:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-pis-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN c-cod-ccusto-pis-substto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN c-cod-ccusto-pis-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-ccusto-pis-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN c-cod-ccusto-pis-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-ccusto-pis-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-ccusto-pis-substto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-ccusto-pis-substto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-pis-substto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-pis-substto IN FRAME f-main /* Cta PIS Substituto */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-inss-recolh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-inss-recolh V-table-Win
ON ENTRY OF estabelec.cod-ccusto-inss-recolh IN FRAME f-main /* CC Inss Recolher */
DO:
    ASSIGN estabelec.cod-ccusto-inss-recolh:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-inss-recolh V-table-Win
ON F5 OF estabelec.cod-ccusto-inss-recolh IN FRAME f-main /* CC Inss Recolher */
OR MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-inss-recolh IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.cod-ccusto-inss-recolh:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-inss-recolh V-table-Win
ON LEAVE OF estabelec.cod-ccusto-inss-recolh IN FRAME f-main /* CC Inss Recolher */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.cod-ccusto-inss-recolh).
    ASSIGN estabelec.cod-ccusto-inss-recolh:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-inss-recolh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-inss-recolh V-table-Win
ON ENTRY OF estabelec.cod-cta-inss-recolh IN FRAME f-main /* Conta Inss Recolher */
DO:
    ASSIGN estabelec.cod-cta-inss-recolh:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.cod-ccusto-inss-recolh:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-inss-recolh V-table-Win
ON F5 OF estabelec.cod-cta-inss-recolh IN FRAME f-main /* Conta Inss Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.cod-cta-inss-recolh:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-inss-recolh V-table-Win
ON LEAVE OF estabelec.cod-cta-inss-recolh IN FRAME f-main /* Conta Inss Recolher */
DO:
    IF estabelec.cod-cta-inss-recolh:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.cod-cta-inss-recolh NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.cod-cta-inss-recolh:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.cod-cta-inss-recolh:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.cod-ccusto-inss-recolh:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN estabelec.cod-ccusto-inss-recolh:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.cod-ccusto-inss-recolh:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.cod-ccusto-inss-recolh:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.cod-ccusto-inss-recolh:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.cod-ccusto-inss-recolh:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.cod-ccusto-inss-recolh:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-inss-recolh V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-inss-recolh IN FRAME f-main /* Conta Inss Recolher */
DO:
  apply 'f5' to self.
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

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
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

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-cusprod NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-cusprod:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-cusprod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
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


&Scoped-define SELF-NAME estabelec.ct-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-desconto V-table-Win
ON ENTRY OF estabelec.ct-desconto IN FRAME f-main /* Despesa (desconto) */
DO:
    ASSIGN estabelec.ct-desconto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-desconto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-desconto V-table-Win
ON F5 OF estabelec.ct-desconto IN FRAME f-main /* Despesa (desconto) */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-desconto:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-desconto V-table-Win
ON LEAVE OF estabelec.ct-desconto IN FRAME f-main /* Despesa (desconto) */
DO:
    IF estabelec.ct-desconto:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-desconto NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-desconto:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-desconto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.      

            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-desconto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-desconto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-desconto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-desconto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-desconto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-desconto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-desconto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-desconto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-desconto IN FRAME f-main /* Despesa (desconto) */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-devolucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON ENTRY OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devoluá∆o */
DO:
    ASSIGN estabelec.ct-devolucao:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-devolucao V-table-Win
ON F5 OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devoluá∆o */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.      

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
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
ON LEAVE OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devoluá∆o */
DO:
    IF estabelec.ct-devolucao:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-devolucao NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-devolucao:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-devolucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.      


            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
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
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-devolucao IN FRAME f-main /* Trans Devoluá∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-fins-pg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-fins-pg V-table-Win
ON ENTRY OF estabelec.ct-fins-pg IN FRAME f-main /* Cta FINSOCIAL Pagar */
DO:
    ASSIGN estabelec.ct-fins-pg:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-fins-pg:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-fins-pg V-table-Win
ON F5 OF estabelec.ct-fins-pg IN FRAME f-main /* Cta FINSOCIAL Pagar */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-fins-pg:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-fins-pg V-table-Win
ON LEAVE OF estabelec.ct-fins-pg IN FRAME f-main /* Cta FINSOCIAL Pagar */
DO:
    IF estabelec.ct-fins-pg:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-fins-pg NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-fins-pg:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-fins-pg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-fins-pg:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE
                ASSIGN estabelec.sc-fins-pg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-fins-pg:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-fins-pg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-fins-pg:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-fins-pg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-fins-pg:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-fins-pg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-fins-pg IN FRAME f-main /* Cta FINSOCIAL Pagar */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-icms-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON ENTRY OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
    ASSIGN estabelec.ct-icms-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-icms-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON F5 OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-icms-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON LEAVE OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
    IF estabelec.ct-icms-ft:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-icms-ft NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-icms-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-icms-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-icms-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-icms-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-icms-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-icms-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-icms-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-icms-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-icms-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icms-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-icms-ft IN FRAME f-main /* ICMS Recolher */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-icmsub-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icmsub-ft V-table-Win
ON ENTRY OF estabelec.ct-icmsub-ft IN FRAME f-main /* ICMSUB Recolher */
DO:
    ASSIGN estabelec.ct-icmsub-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-icmsub-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icmsub-ft V-table-Win
ON F5 OF estabelec.ct-icmsub-ft IN FRAME f-main /* ICMSUB Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-icmsub-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icmsub-ft V-table-Win
ON LEAVE OF estabelec.ct-icmsub-ft IN FRAME f-main /* ICMSUB Recolher */
DO:
    IF estabelec.ct-icmsub-ft:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-icmsub-ft NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-icmsub-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-icmsub-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-icmsub-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-icmsub-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-icmsub-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-icmsub-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-icmsub-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-icmsub-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-icmsub-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-icmsub-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-icmsub-ft IN FRAME f-main /* ICMSUB Recolher */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-ipi-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON ENTRY OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
    ASSIGN estabelec.ct-ipi-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-ipi-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON F5 OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-ipi-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON LEAVE OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
    IF estabelec.ct-ipi-ft:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-ipi-ft NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-ipi-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-ipi-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-ipi-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-ipi-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-ipi-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-ipi-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-ipi-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-ipi-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-ipi-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-ipi-ft V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-ipi-ft IN FRAME f-main /* IPI Recolher */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-iss V-table-Win
ON ENTRY OF estabelec.ct-iss IN FRAME f-main /* ISS Recolher */
DO:
    ASSIGN estabelec.ct-iss:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-iss V-table-Win
ON F5 OF estabelec.ct-iss IN FRAME f-main /* ISS Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-iss:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-iss V-table-Win
ON LEAVE OF estabelec.ct-iss IN FRAME f-main /* ISS Recolher */
DO:
    IF estabelec.ct-iss:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-iss NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-iss:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-iss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-iss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-iss:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-iss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-iss:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-iss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-iss:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-iss V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-iss IN FRAME f-main /* ISS Recolher */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ct-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-pis V-table-Win
ON ENTRY OF estabelec.ct-pis IN FRAME f-main /* PIS Recolher */
DO:
    ASSIGN estabelec.ct-pis:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-pis:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-pis V-table-Win
ON F5 OF estabelec.ct-pis IN FRAME f-main /* PIS Recolher */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
                                              input  "",                     /* PLANO DE CONTAS */
                                              input  "(nenhum)",             /* FINALIDADES */
                                              input  today,                  /* DATA TRANSACAO */
                                              output v_cod_cta,              /* CODIGO CONTA */
                                              output v_des_cta,              /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).     /* ERROS */ 
    
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN estabelec.ct-pis:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-pis V-table-Win
ON LEAVE OF estabelec.ct-pis IN FRAME f-main /* PIS Recolher */
DO:
    IF estabelec.ct-pis:SCREEN-VALUE <> "" THEN DO:

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-pis NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN estabelec.ct-pis:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-pis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */                          
            IF v_log_utz_ccust THEN
                ASSIGN estabelec.sc-pis:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN estabelec.sc-pis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       estabelec.sc-pis:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE
            ASSIGN estabelec.sc-pis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   estabelec.sc-pis:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN estabelec.sc-pis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               estabelec.sc-pis:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ct-pis V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ct-pis IN FRAME f-main /* PIS Recolher */
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

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                              input  "FTP",                  /* MÖDULO */
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

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} estabelec.ct-recven NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA∞ÄO DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN estabelec.ct-recven:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   estabelec.ct-recven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
            RUN limpaErros.

            IF VALID-HANDLE(h-v01ad107) THEN
                RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
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

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
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


&Scoped-define SELF-NAME estabelec.sc-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-desconto V-table-Win
ON ENTRY OF estabelec.sc-desconto IN FRAME f-main /* CC Despesa (desc.) */
DO:
    ASSIGN estabelec.sc-desconto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-desconto V-table-Win
ON F5 OF estabelec.sc-desconto IN FRAME f-main /* CC Despesa (desc.) */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-desconto IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-desconto:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-desconto V-table-Win
ON LEAVE OF estabelec.sc-desconto IN FRAME f-main /* CC Despesa (desc.) */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-desconto).
    ASSIGN estabelec.sc-desconto:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-devolucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-devolucao V-table-Win
ON ENTRY OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devoluá∆o */
DO:
    ASSIGN estabelec.sc-devolucao:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-devolucao V-table-Win
ON F5 OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devoluá∆o */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-devolucao IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
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
ON LEAVE OF estabelec.sc-devolucao IN FRAME f-main /* CC Trans Devoluá∆o */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-devolucao).
    ASSIGN estabelec.sc-devolucao:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-fins-pg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-fins-pg V-table-Win
ON ENTRY OF estabelec.sc-fins-pg IN FRAME f-main /* CC FINSOCIAL P */
DO:
    ASSIGN estabelec.sc-fins-pg:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-fins-pg V-table-Win
ON F5 OF estabelec.sc-fins-pg IN FRAME f-main /* CC FINSOCIAL P */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-fins-pg IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-fins-pg:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-fins-pg V-table-Win
ON LEAVE OF estabelec.sc-fins-pg IN FRAME f-main /* CC FINSOCIAL P */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-fins-pg).
    ASSIGN estabelec.sc-fins-pg:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-icms-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON ENTRY OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
    ASSIGN estabelec.sc-icms-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON F5 OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-icms-ft IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-icms-ft:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icms-ft V-table-Win
ON LEAVE OF estabelec.sc-icms-ft IN FRAME f-main /* CC Desp ICMS */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-icms-ft).
    ASSIGN estabelec.sc-icms-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-icmsub-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icmsub-ft V-table-Win
ON ENTRY OF estabelec.sc-icmsub-ft IN FRAME f-main /* CC ICMSUB Rec */
DO:
    ASSIGN estabelec.sc-icmsub-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icmsub-ft V-table-Win
ON F5 OF estabelec.sc-icmsub-ft IN FRAME f-main /* CC ICMSUB Rec */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-icmsub-ft IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-icmsub-ft:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-icmsub-ft V-table-Win
ON LEAVE OF estabelec.sc-icmsub-ft IN FRAME f-main /* CC ICMSUB Rec */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-icmsub-ft).
    ASSIGN estabelec.sc-icmsub-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-ipi-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON ENTRY OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
DO:
    ASSIGN estabelec.sc-ipi-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON F5 OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-ipi-ft IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-ipi-ft:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-ipi-ft V-table-Win
ON LEAVE OF estabelec.sc-ipi-ft IN FRAME f-main /* CC IPI Fat */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-ipi-ft).
    ASSIGN estabelec.sc-ipi-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-iss V-table-Win
ON ENTRY OF estabelec.sc-iss IN FRAME f-main /* CC ISS */
DO:
    ASSIGN estabelec.sc-iss:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-iss V-table-Win
ON F5 OF estabelec.sc-iss IN FRAME f-main /* CC ISS */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-iss IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-iss:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-iss V-table-Win
ON LEAVE OF estabelec.sc-iss IN FRAME f-main /* CC ISS */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-iss).
    ASSIGN estabelec.sc-iss:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.sc-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-pis V-table-Win
ON ENTRY OF estabelec.sc-pis IN FRAME f-main /* CC PIS */
DO:
    ASSIGN estabelec.sc-pis:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-pis V-table-Win
ON F5 OF estabelec.sc-pis IN FRAME f-main /* CC PIS */
OR MOUSE-SELECT-DBLCLICK OF estabelec.sc-pis IN FRAME f-main
DO :
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    
    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                       input  "",                   /* UNIDADE DE NEGOCIO */
                                       input  today,                /* DATA DE TRANSACAO */
                                       output v_cod_ccust,          /* CODIGO CCUSTO */
                                       output v_des_ccust,          /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN estabelec.sc-pis:screen-value in frame {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.sc-pis V-table-Win
ON LEAVE OF estabelec.sc-pis IN FRAME f-main /* CC PIS */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-pis).
    ASSIGN estabelec.sc-pis:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
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

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    run pi_zoom_ccusto in h_api_ccust (input  c-cod-empresa,        /* EMPRESA EMS2 */
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

  if estabelec.ct-ipi-ft                 :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-icms-ft                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-recven                 :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-cusprod                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-icmsub-ft              :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-pis                    :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-devolucao              :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-desconto               :load-mouse-pointer ("image/lupa.cur") then.
  if c-cod-cta-pis-substto               :load-mouse-pointer ("image/lupa.cur") then.
  if c-cod-ccusto-pis-substto            :load-mouse-pointer ("image/lupa.cur") then.
  if c-cod-cta-cofins-substto            :load-mouse-pointer ("image/lupa.cur") then.
  if c-cod-ccusto-cofins-substto         :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.cod-cta-inss-recolh       :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.cod-ccusto-inss-recolh    :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-recven                 :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-cusprod                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-ipi-ft                 :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-icms-ft                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-icmsub-ft              :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-devolucao              :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-desconto               :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-fins-pg                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-fins-pg                :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ct-iss                    :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-iss                    :load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.sc-pis                    :load-mouse-pointer ("image/lupa.cur") then.

  if estabelec.sc-recven                 :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-cusprod                :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-ipi-ft                 :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-icms-ft                :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-icmsub-ft              :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-devolucao              :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-desconto               :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-fins-pg                :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-iss                    :sensitive in frame {&FRAME-NAME} = NO then.
  if c-cod-ccusto-pis-substto            :sensitive in frame {&FRAME-NAME} = NO then.
  if c-cod-ccusto-cofins-substto         :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.cod-ccusto-inss-recolh    :sensitive in frame {&FRAME-NAME} = NO then.
  if estabelec.sc-pis                    :sensitive in frame {&FRAME-NAME} = NO then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
   /*Unificaªío de conceitos Conta-contabil ems5*/
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-empresaCtContabel = param-global.empresa-prin.

    RUN IniHandlers.

/* Formatos de conta e centro de custo EMS5 */
    ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
           v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".

/* Gravaªío de formatos de tela */ 

ASSIGN estabelec.sc-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-ipi-ft                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-icms-ft                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-icmsub-ft              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-desconto               :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-iss                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-pis                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.sc-fins-pg                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.cod-ccusto-inss-recolh    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       c-cod-ccusto-cofins-substto         :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       c-cod-ccusto-pis-substto            :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
       estabelec.ct-fins-pg                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-iss                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-ipi-ft                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-icms-ft                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-icmsub-ft              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-pis                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.ct-desconto               :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       c-cod-cta-pis-substto               :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       c-cod-cta-cofins-substto            :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
       estabelec.cod-cta-inss-recolh       :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta NO-ERROR.
       
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IniHandlers V-table-Win 
PROCEDURE IniHandlers :
/*------------------------------------------------------------------------------
  Purpose: Iniciar formatos para contas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Inicio Unificaªío de Conceitos CONTA CONTABIL 2011*/
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccust.
   
    IF  VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formato-cta-ccust V-table-Win 
PROCEDURE pi-formato-cta-ccust :
/*------------------------------------------------------------------------------
  Purpose: Iniciar formatos para contas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-busca-empresa IN h-v02ad107 (OUTPUT c-cod-empresa).

    RUN pi_retorna_formato_cta_ctbl in h_api_cta (input c-cod-empresa,       /* EMPRESA EMS2 */
                                                  input  "",                 /* PLANO CONTAS */
                                                  input  today,              /* DATA DE TRANSACAO */
                                                  output v_cod_format_cta,   /* FORMATO cta */
                                                  output table tt_log_erro). /* ERROS */

    IF NOT CAN-FIND(tt_log_erro)
    OR RETURN-VALUE = "OK" THEN 
        ASSIGN v_cod_format_fim = v_cod_format_cta.
    
    RUN limpaErros.
    RUN pi_retorna_formato_ccusto in h_api_ccust (input  c-cod-empresa,          /* EMPRESA EMS2 */
                                                  input  "",                     /* PLANO CCUSTO */
                                                  input  today,                  /* DATA DE TRANSACAO */
                                                  output v_cod_format_ccust,     /* FORMATO CCUSTO */
                                                  output table tt_log_erro).     /* ERROS */

    IF NOT CAN-FIND(tt_log_erro)
    OR RETURN-VALUE = "OK" THEN 
        ASSIGN v_cod_format_fim_ccust = v_cod_format_ccust.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empresa-formato V-table-Win 
PROCEDURE pi-empresa-formato :
/*------------------------------------------------------------------------------
  Purpose: Iniciar formatos para contas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    IF  VALID-HANDLE(h-v02ad107) THEN
        RUN pi-busca-empresa IN h-v02ad107 (OUTPUT c-cod-empresa).

    RUN pi-formato-cta-ccust.

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i ICMS_a_Recolher MCD l}estabelec.ct-icms-ft:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Trans_Receita_Vendas MCD l}estabelec.ct-recven:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Custo_Prod_Vendas MCD l}estabelec.ct-cusprod:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Transit¢ria_Devoluá∆o MCD l}estabelec.ct-devolucao:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i COFINS_a_Recolher MCD l}estabelec.ct-fins-pg:label in frame {&frame-name} = return-value.
  
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

  ASSIGN INPUT FRAME {&FRAME-NAME} c-cod-ccusto-cofins-substto 
         INPUT FRAME {&FRAME-NAME} c-cod-ccusto-pis-substto 
         INPUT FRAME {&FRAME-NAME} c-cod-cta-cofins-substto 
         INPUT FRAME {&FRAME-NAME} c-cod-cta-pis-substto.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  ASSIGN OVERLAY(estabelec.char-1,300,20) = TRIM(c-cod-cta-pis-substto)
         OVERLAY(estabelec.char-1,320,20) = TRIM(c-cod-ccusto-pis-substto)   
         OVERLAY(estabelec.char-1,340,20) = TRIM(c-cod-cta-cofins-substto)   
         OVERLAY(estabelec.char-1,360,20) = TRIM(c-cod-ccusto-cofins-substto).      

  RUN pi-verifica-ccusto (estabelec.ct-recven,OUTPUT l-utiliza-ccusto).                   
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-recven = "".                        
  RUN pi-verifica-ccusto (estabelec.ct-cusprod,OUTPUT l-utiliza-ccusto).                     
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-cusprod =  "".                          
  RUN pi-verifica-ccusto (estabelec.ct-ipi-ft,OUTPUT l-utiliza-ccusto).             
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-ipi-ft = "".                  
  RUN pi-verifica-ccusto (estabelec.ct-icms-ft,OUTPUT l-utiliza-ccusto).             
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-icms-ft = "".                   
  RUN pi-verifica-ccusto (estabelec.ct-icmsub-ft,OUTPUT l-utiliza-ccusto).                    
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-icmsub-ft = "".                         
  RUN pi-verifica-ccusto (TRIM(SUBSTRING(estabelec.char-1,300,20)),OUTPUT l-utiliza-ccusto).                    
  IF NOT l-utiliza-ccusto THEN ASSIGN OVERLAY(estabelec.char-1,320,20) = "".                         
  RUN pi-verifica-ccusto (estabelec.cod-cta-inss-recolh,OUTPUT l-utiliza-ccusto).                      
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.cod-ccusto-inss-recolh = "".                           
  RUN pi-verifica-ccusto (estabelec.ct-devolucao,OUTPUT l-utiliza-ccusto).                     
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-devolucao = "".                             
  RUN pi-verifica-ccusto (estabelec.ct-desconto,OUTPUT l-utiliza-ccusto).                        
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-desconto = "".                                
  RUN pi-verifica-ccusto (estabelec.ct-iss,OUTPUT l-utiliza-ccusto).                       
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-iss = "".                               
  RUN pi-verifica-ccusto (estabelec.ct-pis,OUTPUT l-utiliza-ccusto).                     
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-pis = "".                             
  RUN pi-verifica-ccusto (estabelec.ct-fins-pg,OUTPUT l-utiliza-ccusto).                        
  IF NOT l-utiliza-ccusto THEN ASSIGN estabelec.sc-fins-pg = "".
  RUN pi-verifica-ccusto (TRIM(SUBSTRING(estabelec.char-1,340,20)),OUTPUT l-utiliza-ccusto).                        
  IF NOT l-utiliza-ccusto THEN ASSIGN OVERLAY(estabelec.char-1,360,20) = "".                                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
    
  if i-pais-impto-usuario = 1 THEN
  disable c-cod-cta-pis-substto
          c-cod-cta-cofins-substto 
          estabelec.cod-cta-inss-recolh
          with frame {&FRAME-NAME}.

  DISABLE estabelec.sc-recven                 
          estabelec.sc-cusprod                
          estabelec.sc-ipi-ft                 
          estabelec.sc-icms-ft                
          estabelec.sc-icmsub-ft              
          c-cod-ccusto-pis-substto    
          estabelec.cod-ccusto-inss-recolh    
          estabelec.sc-devolucao              
          estabelec.sc-desconto               
          estabelec.sc-iss                    
          estabelec.sc-pis                    
          estabelec.sc-fins-pg                
          c-cod-ccusto-cofins-substto with frame {&frame-name}.
  
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
  
  RUN IniHandlers.

  /* Formatos de conta e centro de custo EMS5 */
  ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
         v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".

  IF AVAIL estabelec THEN DO:
      /* Gravaªío de formatos de tela */ 
      ASSIGN estabelec.sc-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-ipi-ft                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-icms-ft                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-icmsub-ft              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-desconto               :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-iss                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-pis                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.sc-fins-pg                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.cod-ccusto-inss-recolh    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
             estabelec.ct-fins-pg                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-iss                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-ipi-ft                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-icms-ft                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-recven                 :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-cusprod                :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-icmsub-ft              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-pis                    :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-devolucao              :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.ct-desconto               :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
             estabelec.cod-cta-inss-recolh       :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta NO-ERROR.
    
      ASSIGN c-cod-cta-pis-substto       = TRIM(SUBSTRING(estabelec.char-1,300,20))    
             c-cod-ccusto-pis-substto    = TRIM(SUBSTRING(estabelec.char-1,320,20))    
             c-cod-cta-cofins-substto    = TRIM(SUBSTRING(estabelec.char-1,340,20))    
             c-cod-ccusto-cofins-substto = TRIM(SUBSTRING(estabelec.char-1,360,20)).  
  END.

  ASSIGN c-cod-ccusto-cofins-substto:FORMAT IN FRAME {&FRAME-NAME} = IF c-cod-ccusto-cofins-substto <> "" THEN v_cod_format_ccust ELSE "X(20)"
         c-cod-ccusto-pis-substto   :FORMAT IN FRAME {&FRAME-NAME} = IF c-cod-ccusto-pis-substto    <> "" THEN v_cod_format_ccust ELSE "X(20)"
         c-cod-cta-pis-substto      :FORMAT IN FRAME {&FRAME-NAME} = IF c-cod-cta-pis-substto       <> "" THEN v_cod_format_cta   ELSE "X(20)"
         c-cod-cta-cofins-substto   :FORMAT IN FRAME {&FRAME-NAME} = IF c-cod-cta-cofins-substto    <> "" THEN v_cod_format_cta   ELSE "X(20)".

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

  run get-attribute ('adm-new-record').
/*
 *   if l-habilita = yes then */
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
     
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if i-pais-impto-usuario = 1 then
     enable c-cod-cta-pis-substto
            c-cod-cta-cofins-substto
            estabelec.cod-cta-inss-recolh
            with frame {&FRAME-NAME}.

  IF AVAIL estabelec THEN DO:
      RUN pi-verifica-ccusto (estabelec.ct-recven,OUTPUT l-utiliza-ccusto).                   
      ASSIGN estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                        
      RUN pi-verifica-ccusto (estabelec.ct-cusprod,OUTPUT l-utiliza-ccusto).                     
      ASSIGN estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
      RUN pi-verifica-ccusto (estabelec.ct-ipi-ft,OUTPUT l-utiliza-ccusto).             
      ASSIGN estabelec.sc-ipi-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                  
      RUN pi-verifica-ccusto (estabelec.ct-icms-ft,OUTPUT l-utiliza-ccusto).             
      ASSIGN estabelec.sc-icms-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                   
      RUN pi-verifica-ccusto (estabelec.ct-icmsub-ft,OUTPUT l-utiliza-ccusto).                    
      ASSIGN estabelec.sc-icmsub-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                         
      RUN pi-verifica-ccusto (c-cod-cta-pis-substto,OUTPUT l-utiliza-ccusto).                    
      ASSIGN c-cod-ccusto-pis-substto:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                         
      RUN pi-verifica-ccusto (estabelec.cod-cta-inss-recolh,OUTPUT l-utiliza-ccusto).                      
      ASSIGN estabelec.cod-ccusto-inss-recolh:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                           
      RUN pi-verifica-ccusto (estabelec.ct-devolucao,OUTPUT l-utiliza-ccusto).                     
      ASSIGN estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                             
      RUN pi-verifica-ccusto (estabelec.ct-desconto,OUTPUT l-utiliza-ccusto).                        
      ASSIGN estabelec.sc-desconto:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                                
      RUN pi-verifica-ccusto (estabelec.ct-iss,OUTPUT l-utiliza-ccusto).                       
      ASSIGN estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                               
      RUN pi-verifica-ccusto (estabelec.ct-pis,OUTPUT l-utiliza-ccusto).                     
      ASSIGN estabelec.sc-pis:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                             
      RUN pi-verifica-ccusto (estabelec.ct-fins-pg,OUTPUT l-utiliza-ccusto).                        
      ASSIGN estabelec.sc-fins-pg:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                                
      RUN pi-verifica-ccusto (c-cod-cta-cofins-substto,OUTPUT l-utiliza-ccusto).                        
      ASSIGN c-cod-ccusto-cofins-substto:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.                                
  END.

  ASSIGN estabelec.sc-recven             :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-cusprod            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-ipi-ft             :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-icms-ft            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-icmsub-ft          :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-devolucao          :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-desconto           :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-iss                :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-pis                :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.sc-fins-pg            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.cod-ccusto-inss-recolh:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-fins-pg            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-iss                :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-ipi-ft             :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-icms-ft            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-recven             :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-cusprod            :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-icmsub-ft          :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-pis                :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-devolucao          :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.ct-desconto           :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         estabelec.cod-cta-inss-recolh   :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-ccusto-cofins-substto     :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-ccusto-pis-substto        :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cta-pis-substto           :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cta-cofins-substto        :FORMAT IN FRAME {&FRAME-NAME} = "x(20)" NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {utp/ut-liter.i ICMS_a_Recolher MCD l} estabelec.ct-icms-ft:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Trans_Receita_Vendas MCD l} estabelec.ct-recven:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Custo_Prod_Vendas MCD l} estabelec.ct-cusprod:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Transit¢ria_Devoluá∆o MCD l} estabelec.ct-devolucao:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i COFINS_a_Recolher MCD l} estabelec.ct-fins-pg:label in frame {&frame-name} = return-value.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
     
     disable c-cod-cta-pis-substto
             c-cod-cta-cofins-substto
             estabelec.cod-cta-inss-recolh
             with frame {&FRAME-NAME}.

  DISABLE estabelec.sc-recven                 with frame {&frame-name}.
  DISABLE estabelec.sc-cusprod                with frame {&frame-name}.
  DISABLE estabelec.sc-ipi-ft                 with frame {&frame-name}.
  DISABLE estabelec.sc-icms-ft                with frame {&frame-name}.
  DISABLE estabelec.sc-icmsub-ft              with frame {&frame-name}.
  DISABLE c-cod-ccusto-pis-substto    with frame {&frame-name}.
  DISABLE estabelec.cod-ccusto-inss-recolh    with frame {&frame-name}.
  DISABLE estabelec.sc-devolucao              with frame {&frame-name}.
  DISABLE estabelec.sc-desconto               with frame {&frame-name}.
  DISABLE estabelec.sc-iss                    with frame {&frame-name}.
  DISABLE estabelec.sc-pis                    with frame {&frame-name}.
  DISABLE estabelec.sc-fins-pg                with frame {&frame-name}.
  DISABLE c-cod-ccusto-cofins-substto with frame {&frame-name}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-empresa V-table-Win 
PROCEDURE pi-recebe-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ph-v02ad107 AS HANDLE NO-UNDO.

ASSIGN h-v02ad107 = ph-v02ad107.

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
   
   IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
   
   RUN pi_busca_dados_ccusto IN h_api_ccust (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
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

        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

       RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,           /* EMPRESA EMS2 */
                                                 INPUT        "",                      /* PLANO DE CONTAS */
                                                 INPUT-OUTPUT v_cod_cta,               /* CONTA */
                                                 INPUT        TODAY,                   /* DATA TRANSACAO */   
                                                 OUTPUT       v_des_cta,               /* DESCRICAO CONTA */
                                                 OUTPUT       v_num_tip_cta,           /* TIPO DA CONTA */
                                                 OUTPUT       v_num_sit_cta,           /* SITUA∞ÄO DA CONTA */
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
   END. 
   ELSE 
      RETURN "adm-error".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ContaCentro V-table-Win 
PROCEDURE pi-valida-ContaCentro :
DEF INPUT PARAMETER p-conta  AS CHAR NO-UNDO.
    DEF INPUT PARAMETER p-centro AS CHAR NO-UNDO.

    IF VALID-HANDLE(h-v01ad107) THEN
        RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    run pi_valida_conta_contabil in h_api_cta (input  c-cod-empresa,         /* EMPRESA EMS2 */
                                               input  c-cod-estabel,        /* ESTABELECIMENTO EMS2 */
                                               input  "",                    /* UNIDADE NEG‡CIO */
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
    Notes: N∆o fazer assign aqui. Nesta procedure
    devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
    ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
            
    {include/i-vldfrm.i}

    RUN limpaErros.

    ASSIGN estabelec.ct-recven:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-cusprod:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-ipi-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-ipi-ft:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-icms-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-icms-ft:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-icmsub-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-icmsub-ft:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-pis-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-ccusto-pis-substto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.cod-cta-inss-recolh:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.cod-ccusto-inss-recolh:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-devolucao:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} = NO  
           estabelec.ct-desconto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-desconto:SENSITIVE IN FRAME {&FRAME-NAME} = NO  
           estabelec.ct-iss:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} = NO     
           estabelec.ct-iss:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-pis:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-pis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           estabelec.ct-fins-pg:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           estabelec.sc-fins-pg:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-cofins-substto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-ccusto-cofins-substto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.       
    IF NOT estabelec.ct-recven:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-recven).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Receita Vendas").
            apply 'entry':U to estabelec.ct-recven in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-recven:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-recven).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Receita Ven").
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
            run utp/ut-msgs.p ("show",47,"Custo Prod Vendido").
            apply 'entry':U to estabelec.ct-cusprod in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-cusprod:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-cusprod).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Custo Prod").
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
    IF NOT estabelec.ct-ipi-ft:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-ipi-ft).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"IPI Recolher").
            apply 'entry':U to estabelec.ct-ipi-ft in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-ipi-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-ipi-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC IPI Fat").
                apply 'entry':U to estabelec.sc-ipi-ft in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-ipi-ft, INPUT FRAME {&FRAME-NAME} estabelec.sc-ipi-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-ipi-ft IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-icms-ft:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-icms-ft).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"ICMS Recolher").
            apply 'entry':U to estabelec.ct-icms-ft in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-icms-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-icms-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Desp ICMS").
                apply 'entry':U to estabelec.sc-icms-ft in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-icms-ft, INPUT FRAME {&FRAME-NAME} estabelec.sc-icms-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-icms-ft IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-icmsub-ft:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-icmsub-ft).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"ICMSUB Recolher").
            apply 'entry':U to estabelec.ct-icmsub-ft in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-icmsub-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-icmsub-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC ICMSUB Rec").
                apply 'entry':U to estabelec.sc-icmsub-ft in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-icmsub-ft, INPUT FRAME {&FRAME-NAME} estabelec.sc-icmsub-ft).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-icmsub-ft IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT c-cod-cta-pis-substto:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-pis-substto).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Cta PIS Substituto").
            apply 'entry':U to c-cod-cta-pis-substto in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF c-cod-ccusto-pis-substto:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-ccusto-pis-substto).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC PIS Substituto").
                apply 'entry':U to c-cod-ccusto-pis-substto in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-pis-substto, INPUT FRAME {&FRAME-NAME} c-cod-ccusto-pis-substto).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO c-cod-ccusto-pis-substto IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.cod-cta-inss-recolh:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.cod-cta-inss-recolh).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Conta Inss Recolher").
            apply 'entry':U to estabelec.cod-cta-inss-recolh in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.cod-ccusto-inss-recolh:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.cod-ccusto-inss-recolh).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Inss Recolher").
                apply 'entry':U to estabelec.cod-ccusto-inss-recolh in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.cod-cta-inss-recolh, INPUT FRAME {&FRAME-NAME} estabelec.cod-ccusto-inss-recolh).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.cod-ccusto-inss-recolh IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-devolucao:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-devolucao).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Trans Devoluá∆o").
            apply 'entry':U to estabelec.ct-devolucao in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-devolucao:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-devolucao).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Trans Devoluá∆o").
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
    IF NOT estabelec.ct-desconto:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-desconto).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Despesa(desconto)").
            apply 'entry':U to estabelec.ct-desconto in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-desconto:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-desconto).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Despesa(desc.)").
                apply 'entry':U to estabelec.sc-desconto in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-desconto, INPUT FRAME {&FRAME-NAME} estabelec.sc-desconto).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-desconto IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-iss:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-iss).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"ISS Recolher").
            apply 'entry':U to estabelec.ct-iss in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-iss:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-iss).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC ISS").
                apply 'entry':U to estabelec.sc-iss in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-iss, INPUT FRAME {&FRAME-NAME} estabelec.sc-iss).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-iss IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-pis:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-pis).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"PIS Recolher").
            apply 'entry':U to estabelec.ct-pis in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-pis:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-pis).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC PIS").
                apply 'entry':U to estabelec.sc-pis in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-pis, INPUT FRAME {&FRAME-NAME} estabelec.sc-pis).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-pis IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT estabelec.ct-fins-pg:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} estabelec.ct-fins-pg).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Cta FINSOCIAL Pagar").
            apply 'entry':U to estabelec.ct-fins-pg in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF estabelec.sc-fins-pg:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} estabelec.sc-fins-pg).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC FINSOCIAL PG").
                apply 'entry':U to estabelec.sc-fins-pg in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} estabelec.ct-fins-pg, INPUT FRAME {&FRAME-NAME} estabelec.sc-fins-pg).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO estabelec.sc-fins-pg IN FRAME {&FRAME-NAME}.
               RETURN 'adm-error'.
           END.
       END.
    END.
    IF NOT c-cod-cta-cofins-substto:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
       RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-cofins-substto).
       IF RETURN-VALUE = "adm-error" THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show",47,"Cta COFINS Substituto").
            apply 'entry':U to c-cod-cta-cofins-substto in frame {&FRAME-NAME}.
            return 'adm-error'.
       END.
       IF c-cod-ccusto-cofins-substto:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-ccusto-cofins-substto).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"CC Cofins Substito").
                apply 'entry':U to c-cod-ccusto-cofins-substto in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-cofins-substto, INPUT FRAME {&FRAME-NAME} c-cod-ccusto-cofins-substto).
           IF RETURN-VALUE = "adm-error" THEN DO:
               APPLY 'entry':U TO c-cod-ccusto-cofins-substto IN FRAME {&FRAME-NAME}.
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

IF VALID-HANDLE(h-v01ad107) THEN
   RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).
IF VALID-HANDLE(h-v02ad107) THEN
   RUN pi-empresa-formato.

RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  c-cod-empresa,       /* EMPRESA EMS 2 */
                                                  INPUT  c-cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                  INPUT  "",                  /* PLANO CONTAS */
                                                  INPUT  p-conta,             /* CONTA */
                                                  INPUT  TODAY,               /* DT TRANSACAO */
                                                  OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                  OUTPUT TABLE tt_log_erro).  /* ERROS */       
ASSIGN p-log = v_log_utz_ccust.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pais V-table-Win 
PROCEDURE pi-verifica-pais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-verifica as logical no-undo.

/*if l-verifica = no then 
 *   RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
 * else 
 *   RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 *   
 * assign l-habilita = l-verifica.*/
 
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

