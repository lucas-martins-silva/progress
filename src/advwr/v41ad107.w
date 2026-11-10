&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V08DI022 2.00.00.004 } /*** "010004" 26/02/2026 07:34:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08di022 MFT}
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
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}

&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var c-opcao      as char  no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-cod-estabel         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-cod-estabel-aux     AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-lbl-liter-invalido  AS CHARACTER                    NO-UNDO.   
DEFINE VARIABLE c-lbl-liter-invalida  AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE l-valida              AS  LOGICAL                     NO-UNDO.
DEFINE VARIABLE i-empresa             like param-global.empresa-prin  NO-UNDO.
DEFINE VARIABLE l-nt2024002           AS LOGICAL                      NO-UNDO.

/*Inicio Unifica  o de Conceitos CONTA CONTABIL 2011*/
DEF VAR i-empresaCtContabel LIKE param-global.empresa-prin  NO-UNDO.
def var h_api_cta               as handle                   no-undo.
def var h_api_ccust             as handle                   no-undo.
DEF VAR h-v02ad107              AS HANDLE                   NO-UNDO.
def var v_cod_cta               as char                     no-undo.
def var v_des_cta               as char                     no-undo.
def var v_cod_ccust             as char                     no-undo.
def var v_des_ccust             as char                     no-undo.
def var v_cod_format_cta        as char                     no-undo.
def var v_cod_format_ccust      as char                     no-undo.
def var v_cod_format_inic       as char                     no-undo.
def var v_cod_format_fim        as char                     no-undo.
def var v_ind_finalid_cta       as char                     no-undo.
def var v_num_tip_cta           as int                      no-undo.
def var v_num_sit_cta           as int                      no-undo.
def var v_log_utz_ccust         as log                      no-undo.
DEF VAR v_cod_format_inic_ccust AS CHAR                     NO-UNDO.
DEF VAR v_cod_format_fim_ccust  AS CHAR                     NO-UNDO.
DEF VAR l-utiliza-ccusto        AS LOG                      NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N mero" column-label "N mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" LABEL "Mensagem Erro" column-label "Inconsist ncia".

/*Fim Unifica  o de Conceitos CONTA CONTABIL 2011*/

{utp/ut-liter.i "Inv lido" *}
ASSIGN c-lbl-liter-invalido = TRIM(RETURN-VALUE).  

{utp/ut-liter.i "Inv lida" *}
ASSIGN c-lbl-liter-invalida = TRIM(RETURN-VALUE).

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK 
                              WHERE funcao.cd-funcao = "spp-nt2024002":U
                              AND   funcao.ativo).

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
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS estabelec.log-1 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS ct-cbs-ft cc-cbs-ft ct-ibs-uf-ft ~
cc-ibs-uf-ft ct-ibs-mun-ft cc-ibs-mun-ft ct-is-ft cc-is-ft 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS ct-ibs-mun-ft 
&Scoped-define ADM-MODIFY-FIELDS ct-cbs-ft cc-cbs-ft ct-ibs-uf-ft ~
cc-ibs-uf-ft ct-ibs-mun-ft cc-ibs-mun-ft 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-estabel|y|y|movdis.it-doc-fisc.cod-estabel
cd-vin-ipi||y|movdis.it-doc-fisc.cd-vin-ipi
cod-servico||y|movdis.it-doc-fisc.cod-servico
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-estabel",
     Keys-Supplied = "cod-estabel,cd-vin-ipi,cod-servico"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cc-cbs-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC CBS a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE cc-ibs-mun-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC IBS Mun a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE cc-ibs-uf-ft AS CHARACTER FORMAT "X(256)":U 
     LABEL "CC IBS UF a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE cc-is-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "CC IS a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE ct-cbs-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "CBS a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE ct-ibs-mun-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "IBS Mun a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE ct-ibs-uf-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "IBS UF a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE ct-is-ft AS CHARACTER FORMAT "X(20)":U 
     LABEL "IS a Recolher" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.log-1 AT ROW 1.25 COL 33 WIDGET-ID 50
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     ct-cbs-ft AT ROW 2 COL 19 COLON-ALIGNED HELP
          "Informar conta de CBS a Recolher" WIDGET-ID 48
     cc-cbs-ft AT ROW 2 COL 63 COLON-ALIGNED HELP
          "Informar Centro de Custo de CBS a Recolher" WIDGET-ID 46
     ct-ibs-uf-ft AT ROW 3 COL 19 COLON-ALIGNED HELP
          "Informar conta de IBS Estado a Recolher" WIDGET-ID 44
     cc-ibs-uf-ft AT ROW 3 COL 63 COLON-ALIGNED HELP
          "Informar Centro de Custo de IBS Estado a Recolher" WIDGET-ID 42
     ct-ibs-mun-ft AT ROW 4 COL 19 COLON-ALIGNED HELP
          "Informar conta de IBS Municipio a Recolher"
     cc-ibs-mun-ft AT ROW 4 COL 62.86 COLON-ALIGNED HELP
          "Informar Centro de Custo de IBS Municipio a Recolher"
     ct-is-ft AT ROW 5 COL 19 COLON-ALIGNED HELP
          "Informar conta de IS a Recolher" WIDGET-ID 52
     cc-is-ft AT ROW 5 COL 63 COLON-ALIGNED HELP
          "Informar Centro de Custo de IS a Recolher" WIDGET-ID 54
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 8.83
         WIDTH              = 86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cc-cbs-ft IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN cc-ibs-mun-ft IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN cc-ibs-uf-ft IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN cc-is-ft IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cc-is-ft:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN ct-cbs-ft IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN ct-ibs-mun-ft IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN ct-ibs-uf-ft IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN ct-is-ft IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       ct-is-ft:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX estabelec.log-1 IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       estabelec.log-1:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME cc-cbs-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-cbs-ft V-table-Win
ON ENTRY OF cc-cbs-ft IN FRAME f-main /* CC CBS a Recolher */
DO:
    ASSIGN cc-cbs-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-cbs-ft V-table-Win
ON F5 OF cc-cbs-ft IN FRAME f-main /* CC CBS a Recolher */
OR MOUSE-SELECT-DBLCLICK OF cc-cbs-ft IN FRAME f-main /* CC CBS a Recolher*/
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
    
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                       input  "",                    /* CODIGO DO PLANO CCUSTO */
                                       input  "",                    /* UNIDADE DE NEGOCIO */
                                       input  today,                 /* DATA DE TRANSACAO */
                                       output v_cod_ccust,           /* CODIGO CCUSTO */
                                       output v_des_ccust,           /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).    /* ERROS */ 
    
    
    IF (   NOT CAN-FIND(FIRST tt_log_erro) 
        OR RETURN-VALUE = "OK")
    AND v_cod_ccust <> "" THEN 
        ASSIGN cc-cbs-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-cbs-ft V-table-Win
ON LEAVE OF cc-cbs-ft IN FRAME f-main /* CC CBS a Recolher */
DO:
    IF INPUT FRAME {&FRAME-NAME} cc-cbs-ft <> "" THEN DO:
        RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} cc-cbs-ft,"",NO).
        ASSIGN cc-cbs-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cc-ibs-mun-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-mun-ft V-table-Win
ON ENTRY OF cc-ibs-mun-ft IN FRAME f-main /* CC IBS Mun a Recolher */
DO:
    ASSIGN cc-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-mun-ft V-table-Win
ON F5 OF cc-ibs-mun-ft IN FRAME f-main /* CC IBS Mun a Recolher */
OR MOUSE-SELECT-DBLCLICK OF cc-ibs-mun-ft IN FRAME f-main /* CC IBS Munic a Recolher */
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
    
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                       input  "",                    /* CODIGO DO PLANO CCUSTO */
                                       input  "",                    /* UNIDADE DE NEGOCIO */
                                       input  today,                 /* DATA DE TRANSACAO */
                                       output v_cod_ccust,           /* CODIGO CCUSTO */
                                       output v_des_ccust,           /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).    /* ERROS */ 
    
    
    IF (   NOT CAN-FIND(FIRST tt_log_erro) 
        OR RETURN-VALUE = "OK")
    AND v_cod_ccust <> "" THEN 
        ASSIGN cc-ibs-mun-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-mun-ft V-table-Win
ON LEAVE OF cc-ibs-mun-ft IN FRAME f-main /* CC IBS Mun a Recolher */
DO:
    IF INPUT FRAME {&FRAME-NAME} cc-ibs-mun-ft <> "" THEN DO:
        RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} cc-ibs-mun-ft,"",NO).
        ASSIGN cc-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cc-ibs-uf-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-uf-ft V-table-Win
ON ENTRY OF cc-ibs-uf-ft IN FRAME f-main /* CC IBS UF a Recolher */
DO:
    ASSIGN cc-ibs-uf-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-uf-ft V-table-Win
ON F5 OF cc-ibs-uf-ft IN FRAME f-main /* CC IBS UF a Recolher */
OR MOUSE-SELECT-DBLCLICK OF cc-ibs-uf-ft IN FRAME f-main /* CC IBS UF a Recolher*/
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
    
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                       input  "",                    /* CODIGO DO PLANO CCUSTO */
                                       input  "",                    /* UNIDADE DE NEGOCIO */
                                       input  today,                 /* DATA DE TRANSACAO */
                                       output v_cod_ccust,           /* CODIGO CCUSTO */
                                       output v_des_ccust,           /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).    /* ERROS */ 
    
    
       IF (   NOT CAN-FIND(FIRST tt_log_erro) 
           OR RETURN-VALUE = "OK")
       AND v_cod_ccust <> "" THEN 
            ASSIGN cc-ibs-uf-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-ibs-uf-ft V-table-Win
ON LEAVE OF cc-ibs-uf-ft IN FRAME f-main /* CC IBS UF a Recolher */
DO:
    IF INPUT FRAME {&FRAME-NAME} cc-ibs-uf-ft <> "" THEN DO:
        RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} cc-ibs-uf-ft,"",NO).
        ASSIGN cc-ibs-uf-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cc-is-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-is-ft V-table-Win
ON ENTRY OF cc-is-ft IN FRAME f-main /* CC IS a Recolher */
DO:
    ASSIGN cc-is-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-is-ft V-table-Win
ON F5 OF cc-is-ft IN FRAME f-main /* CC IS a Recolher */
OR MOUSE-SELECT-DBLCLICK OF cc-is-ft IN FRAME f-main /* CC IS a Recolher */
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
    
    run pi_zoom_ccusto in h_api_ccust (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                       input  "",                    /* CODIGO DO PLANO CCUSTO */
                                       input  "",                    /* UNIDADE DE NEGOCIO */
                                       input  today,                 /* DATA DE TRANSACAO */
                                       output v_cod_ccust,           /* CODIGO CCUSTO */
                                       output v_des_ccust,           /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).    /* ERROS */ 
    
    
    IF (   NOT CAN-FIND(FIRST tt_log_erro) 
        OR RETURN-VALUE = "OK")
    AND v_cod_ccust <> "" THEN 
        ASSIGN cc-is-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-is-ft V-table-Win
ON LEAVE OF cc-is-ft IN FRAME f-main /* CC IS a Recolher */
DO:
    IF INPUT FRAME {&FRAME-NAME} cc-is-ft <> "" THEN DO:
        RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} cc-is-ft,"",NO).
        ASSIGN cc-is-ft:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-cbs-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-cbs-ft V-table-Win
ON ENTRY OF ct-cbs-ft IN FRAME f-main /* CBS a Recolher */
DO:
    ASSIGN ct-cbs-ft:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
           cc-cbs-ft :SENSITIVE IN FRAME {&FRAME-NAME} = YES
           cc-cbs-ft :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-cbs-ft V-table-Win
ON F5 OF ct-cbs-ft IN FRAME f-main /* CBS a Recolher */
OR MOUSE-SELECT-DBLCLICK OF ct-cbs-ft IN FRAME f-main /* CBS a Recolher*/
DO:
    EMPTY TEMP-TABLE tt_log_erro.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                              input  "FTP",                 /* M DULO */
                                              input  "",                    /* PLANO DE CONTAS */
                                              input  "(nenhum)",            /* FINALIDADES */
                                              input  today,                 /* DATA TRANSACAO */
                                              output v_cod_cta,             /* CODIGO CONTA */
                                              output v_des_cta,             /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,     /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).    /* ERROS */ 

   IF  (   NOT CAN-FIND(FIRST tt_log_erro) 
        OR RETURN-VALUE = "OK")
   AND v_cod_cta <> "" THEN
       ASSIGN ct-cbs-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-cbs-ft V-table-Win
ON LEAVE OF ct-cbs-ft IN FRAME f-main /* CBS a Recolher */
DO:

    IF  ct-cbs-ft:SCREEN-VALUE = "" THEN
        ASSIGN cc-cbs-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               cc-cbs-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

    IF  ct-cbs-ft:SCREEN-VALUE <> "" THEN DO:
    
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    
        EMPTY TEMP-TABLE tt_log_erro.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} ct-cbs-ft NO-ERROR.

        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA  O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF  NOT CAN-FIND(tt_log_erro) 
        OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN ct-cbs-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   ct-cbs-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
            
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            
            EMPTY TEMP-TABLE tt_log_erro.
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */       

            IF  v_log_utz_ccust THEN 
                ASSIGN cc-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN cc-cbs-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       cc-cbs-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE 
            ASSIGN cc-cbs-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   cc-cbs-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-ibs-mun-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-mun-ft V-table-Win
ON ENTRY OF ct-ibs-mun-ft IN FRAME f-main /* IBS Mun a Recolher */
DO:
    ASSIGN ct-ibs-mun-ft:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
           cc-ibs-mun-ft :SENSITIVE IN FRAME {&FRAME-NAME} = YES
           cc-ibs-mun-ft :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-mun-ft V-table-Win
ON F5 OF ct-ibs-mun-ft IN FRAME f-main /* IBS Mun a Recolher */
OR MOUSE-SELECT-DBLCLICK OF ct-ibs-mun-ft IN FRAME f-main /* IBS Munic a Recolher */
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato. 
    
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                              input  "FTP",                 /* M DULO */
                                              input  "",                    /* PLANO DE CONTAS */
                                              input  "(nenhum)",            /* FINALIDADES */
                                              input  today,                 /* DATA TRANSACAO */
                                              output v_cod_cta,             /* CODIGO CONTA */
                                              output v_des_cta,             /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,     /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).    /* ERROS */ 

   IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
       IF v_cod_cta <> "" THEN
       ASSIGN ct-ibs-mun-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-mun-ft V-table-Win
ON LEAVE OF ct-ibs-mun-ft IN FRAME f-main /* IBS Mun a Recolher */
DO:

   IF  ct-ibs-mun-ft:SCREEN-VALUE = "" THEN
       ASSIGN cc-ibs-mun-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              cc-ibs-mun-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.


    IF  ct-ibs-mun-ft:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
    
        EMPTY TEMP-TABLE tt_log_erro.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft NO-ERROR.

        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA  O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF  NOT CAN-FIND(tt_log_erro) 
        OR  RETURN-VALUE = "OK" THEN DO:
            ASSIGN ct-ibs-mun-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   ct-ibs-mun-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
            
            EMPTY TEMP-TABLE tt_log_erro.
            
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */       

            IF v_log_utz_ccust THEN 
                ASSIGN cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN cc-ibs-mun-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       cc-ibs-mun-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE 
            ASSIGN cc-ibs-mun-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   cc-ibs-mun-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-ibs-uf-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-uf-ft V-table-Win
ON ENTRY OF ct-ibs-uf-ft IN FRAME f-main /* IBS UF a Recolher */
DO:
    ASSIGN ct-ibs-uf-ft:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
           cc-ibs-uf-ft :SENSITIVE IN FRAME {&FRAME-NAME} = YES
           cc-ibs-uf-ft :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-uf-ft V-table-Win
ON F5 OF ct-ibs-uf-ft IN FRAME f-main /* IBS UF a Recolher */
OR MOUSE-SELECT-DBLCLICK OF ct-ibs-uf-ft IN FRAME f-main /* IBS UF a Recolher*/
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                              input  "FTP",                 /* M DULO */
                                              input  "",                    /* PLANO DE CONTAS */
                                              input  "(nenhum)",            /* FINALIDADES */
                                              input  today,                 /* DATA TRANSACAO */
                                              output v_cod_cta,             /* CODIGO CONTA */
                                              output v_des_cta,             /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,     /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).    /* ERROS */ 

   IF  NOT CAN-FIND(FIRST tt_log_erro) 
   OR  RETURN-VALUE = "OK" THEN 
       IF v_cod_cta <> "" THEN
       ASSIGN ct-ibs-uf-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-ibs-uf-ft V-table-Win
ON LEAVE OF ct-ibs-uf-ft IN FRAME f-main /* IBS UF a Recolher */
DO:
    IF  ct-ibs-uf-ft:SCREEN-VALUE = "" THEN
        ASSIGN cc-ibs-uf-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               cc-ibs-uf-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

    IF  ct-ibs-uf-ft:SCREEN-VALUE <> "" THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
        
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft NO-ERROR.

        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA  O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF  NOT CAN-FIND(tt_log_erro) 
        OR  RETURN-VALUE = "OK" THEN DO:
            ASSIGN ct-ibs-uf-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   ct-ibs-uf-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
            
            EMPTY TEMP-TABLE tt_log_erro.
            
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */       

            IF v_log_utz_ccust THEN 
                ASSIGN cc-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN cc-ibs-uf-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       cc-ibs-uf-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE 
            ASSIGN cc-ibs-uf-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   cc-ibs-uf-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-is-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-is-ft V-table-Win
ON ENTRY OF ct-is-ft IN FRAME f-main /* IS a Recolher */
DO:
    ASSIGN ct-is-ft:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
           cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           cc-is-ft:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-is-ft V-table-Win
ON F5 OF ct-is-ft IN FRAME f-main /* IS a Recolher */
OR MOUSE-SELECT-DBLCLICK OF ct-is-ft IN FRAME f-main /* IS a Recolher */
DO:
    EMPTY TEMP-TABLE tt_log_erro.
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
        
    RUN pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresaCtContabel,   /* EMPRESA EMS2 */
                                              input  "FTP",                 /* M DULO */
                                              input  "",                    /* PLANO DE CONTAS */
                                              input  "(nenhum)",            /* FINALIDADES */
                                              input  today,                 /* DATA TRANSACAO */
                                              output v_cod_cta,             /* CODIGO CONTA */
                                              output v_des_cta,             /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,     /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).    /* ERROS */ 

   IF  (   NOT CAN-FIND(FIRST tt_log_erro) 
        OR RETURN-VALUE = "OK")
   AND v_cod_cta <> "" THEN
       ASSIGN ct-is-ft:screen-value in frame {&FRAME-NAME} = v_cod_cta.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-is-ft V-table-Win
ON LEAVE OF ct-is-ft IN FRAME f-main /* IS a Recolher */
DO:

    IF  ct-is-ft:SCREEN-VALUE = "" THEN
        ASSIGN cc-is-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               cc-is-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

    IF  ct-is-ft:SCREEN-VALUE <> "" THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.
        
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} ct-is-ft NO-ERROR.

        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel, /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUA  O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF  NOT CAN-FIND(tt_log_erro) 
        OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN ct-is-ft:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   ct-is-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
            
            EMPTY TEMP-TABLE tt_log_erro.
            
            IF VALID-HANDLE(h-v02ad107) THEN
                RUN pi-empresa-formato.
            
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                              INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
                                                              INPUT  "",                  /* PLANO CONTAS */
                                                              INPUT  v_cod_cta,           /* CONTA */
                                                              INPUT  TODAY,               /* DT TRANSACAO */
                                                              OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                              OUTPUT TABLE tt_log_erro).  /* ERROS */       

            IF  v_log_utz_ccust THEN 
                ASSIGN cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            ELSE 
                ASSIGN cc-is-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       cc-is-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        END.
        ELSE 
            ASSIGN cc-is-ft:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   cc-is-ft:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF     
  
  /*Unifica  o de conceitos Conta-contabil ems5*/
   FOR FIRST param-global NO-LOCK:   
       ASSIGN i-empresaCtContabel = param-global.empresa-prin.
   END.


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

    if  not valid-handle(h_api_cta) then
        run prgint\utb\utb743za.py persistent set h_api_cta.
                
    if  not valid-handle(h_api_ccust) then
        run prgint\utb\utb742za.py persistent set h_api_ccust.
        
    
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-busca-empresa IN h-v02ad107 (OUTPUT i-empresaCtContabel).

    &IF DEFINED (bf_dis_consiste_conta) &THEN
        /*Inclu da esta condi  o, para que os clientes que utilizem a empresa por estabelecimento possam configurar
        ? no campo estabecimento. Neste caso, a conta cont bil continuar  sendo buscada com a empresa do param-global*/
        IF  c-cod-estabel <> ?
        AND c-cod-estabel <> "" THEN
            FOR FIRST estabelec 
                WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK :            
                RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                                  OUTPUT i-empresaCtContabel).
            END.
    &ENDIF
   
    /* ---------------- CONTA ---------------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_retorna_formato_cta_ctbl in h_api_cta (input i-empresaCtContabel, /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CONTAS */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_cod_format_cta,   /* FORMATO cta */
                                                 output table tt_log_erro). /* ERROS */

   IF  CAN-FIND(tt_log_erro)
   OR  RETURN-VALUE = "NOK" THEN 
       ASSIGN v_cod_format_fim = "x(20)".
   ELSE 
       ASSIGN v_cod_format_fim = v_cod_format_cta.


   /* ------------- CENTRO DE CUSTO --------------------------------------------------------------------------------------------*/

   EMPTY TEMP-TABLE tt_log_erro.
   run pi_retorna_formato_ccusto in h_api_ccust (input  i-empresaCtContabel,                 /* EMPRESA EMS2 */
                                                 input  "",             /* PLANO CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_cod_format_ccust, /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */

   IF  CAN-FIND(tt_log_erro)
   OR  RETURN-VALUE = "NOK" THEN 
       ASSIGN v_cod_format_fim = "x(20)".
   ELSE 
       ASSIGN v_cod_format_fim_ccust = v_cod_format_ccust.

     
    /*Fim Unifica  o de Conceitos CONTA CONTABIL 2011*/
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
    /* Ponha na pi-validate todas as valida  es */
    /* N o gravar nada no registro antes do dispatch do assign-record e 
    nem na PI-validate. */  
          
    ASSIGN INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft cc-ibs-mun-ft ct-ibs-uf-ft cc-ibs-uf-ft ct-cbs-ft cc-cbs-ft.

    //Linha abaixo ficar  comentada at  que o IS entre em vigor
    //ASSIGN INPUT FRAME {&FRAME-NAME} ct-is-mun-ft cc-is-mun-ft
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    /* Todos os assign s n o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    if  RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.      

    IF i-pais-impto-usuario = 1 THEN DO:

       /* IBS Mun */
       FIND FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 08 EXCLUSIVE-LOCK NO-ERROR.

       IF NOT AVAIL estab-ctas-impto THEN DO:
       
          CREATE estab-ctas-impto.
          ASSIGN estab-ctas-impto.cod-estab        = estabelec.cod-estabel
                 estab-ctas-impto.num-impto        = 08
                 estab-ctas-impto.dat-inic-valid   = 01/01/1800
                 estab-ctas-impto.dat-fim-valid    = 12/30/9999.
       END.

       ASSIGN estab-ctas-impto.conta-imposto    = ct-ibs-mun-ft
              estab-ctas-impto.cod-ccusto-impto = cc-ibs-mun-ft.

       /* IBS UF */
       FIND FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 09 EXCLUSIVE-LOCK NO-ERROR.

       IF NOT AVAIL estab-ctas-impto THEN DO:

           CREATE estab-ctas-impto.
           ASSIGN estab-ctas-impto.cod-estab        = estabelec.cod-estabel
                  estab-ctas-impto.num-impto        = 09
                  estab-ctas-impto.dat-inic-valid   = 01/01/1800
                  estab-ctas-impto.dat-fim-valid    = 12/30/9999.
       END.

       ASSIGN estab-ctas-impto.conta-imposto    = ct-ibs-uf-ft
              estab-ctas-impto.cod-ccusto-impto = cc-ibs-uf-ft.

       /* CBS */
       FIND FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 10 EXCLUSIVE-LOCK NO-ERROR.

       IF NOT AVAIL estab-ctas-impto THEN DO:

           CREATE estab-ctas-impto.
           ASSIGN estab-ctas-impto.cod-estab        = estabelec.cod-estabel
                  estab-ctas-impto.num-impto        = 10
                  estab-ctas-impto.dat-inic-valid   = 01/01/1800
                  estab-ctas-impto.dat-fim-valid    = 12/30/9999.
       END.

       ASSIGN estab-ctas-impto.conta-imposto    = ct-cbs-ft
              estab-ctas-impto.cod-ccusto-impto = cc-cbs-ft.

       //A l¢gica abaixo ficar  comentada at‚ que o IS entre em vigor
 /*    /* IS */
       FIND FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 11 EXCLUSIVE-LOCK NO-ERROR.

       IF NOT AVAIL estab-ctas THEN DO:
          CREATE estab-ctas-impto.
          ASSIGN estab-ctas-impto.cod-estab        = estabelec.cod-estabel
                 estab-ctas-impto.num-impto        = 11
                 estab-ctas-impto.dat-inic-valid   = 01/01/1800
                 estab-ctas-impto.dat-fim-valid    = 12/30/9999.
       end.
       
       assign estab-ctas-impto.conta-imposto    = ct-is-ft
              estab-ctas-impto.cod-ccusto-impto = cc-is-ft.
*/

       RUN pi-verifica-ccusto (ct-ibs-mun-ft,OUTPUT l-utiliza-ccusto).
       IF NOT l-utiliza-ccusto THEN ASSIGN cc-ibs-mun-ft = "".

       RUN pi-verifica-ccusto (ct-ibs-uf-ft,OUTPUT l-utiliza-ccusto).
       IF NOT l-utiliza-ccusto THEN ASSIGN cc-ibs-uf-ft = "".

       RUN pi-verifica-ccusto (ct-cbs-ft,OUTPUT l-utiliza-ccusto).
       IF NOT l-utiliza-ccusto THEN ASSIGN cc-cbs-ft = "".

       //As linhas abaixo ficar o comentadas at  que o IS entre em vigor
   /*  RUN pi-verifica-ccusto (ct-is-ft,OUTPUT l-utiliza-ccusto).
       IF NOT l-utiliza-ccusto THEN ASSIGN cc-is-ft = "". */

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  IF ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-ibs-mun-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.

  IF ct-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-ibs-uf-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.
  
  IF ct-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-cbs-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.  

  /* //Imposto IS
  IF ct-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    RUN pi-verifica-ccusto (ct-is-ft,OUTPUT l-utiliza-ccusto).
    ASSIGN cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.  */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h_api_cta) THEN DO:
        DELETE PROCEDURE h_api_cta.
        ASSIGN h_api_cta = ?.
    END.
    
    IF  VALID-HANDLE(h_api_ccust) THEN DO:
        DELETE PROCEDURE h_api_ccust.
        ASSIGN h_api_ccust = ?.
    END.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) . 

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
    
    RUN GET-ATTRIBUTE ('adm-new-record').
    
    RUN pi-formato.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    IF  AVAIL estabelec THEN DO:

        ASSIGN ct-ibs-mun-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
               cc-ibs-mun-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
               ct-ibs-uf-ft:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
               cc-ibs-uf-ft:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
               ct-cbs-ft:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
               cc-cbs-ft:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = "".

        /* IBS Mun */
        FOR FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 08 NO-LOCK:

            ASSIGN ct-ibs-mun-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.conta-imposto   
                   cc-ibs-mun-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.cod-ccusto-impto.
        END.

        /* IBS UF */
        FOR FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 09 NO-LOCK:

            ASSIGN ct-ibs-uf-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.conta-imposto   
                   cc-ibs-uf-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.cod-ccusto-impto.
        END.

        /* CBS */
        FOR FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 10 NO-LOCK:

            ASSIGN ct-cbs-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.conta-imposto   
                   cc-cbs-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.cod-ccusto-impto.
        END.

       //A l¢gica abaixo ficar  comentada at‚ que o IS entre em vigor
 /*    /* IS */
       FOR FIRST estab-ctas-impto WHERE 
            estab-ctas-impto.cod-estab = estabelec.cod-estabel AND   
            estab-ctas-impto.num-impto = 11 NO-LOCK:
              
          ASSIGN ct-is-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.conta-imposto   
                 cc-is-ft:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = estab-ctas-impto.cod-ccusto-impto.
       END.
       */
  
    /* Code placed here will execute AFTER standard behavior.    */

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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF  ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-ibs-mun-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.

  IF  ct-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-ibs-uf-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.

  IF  ct-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      RUN pi-verifica-ccusto (ct-cbs-ft,OUTPUT l-utiliza-ccusto).
      ASSIGN cc-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.
  
/*/* IS */
  IF  ct-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    RUN pi-verifica-ccusto (ct-is-ft,OUTPUT l-utiliza-ccusto).
    ASSIGN cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.       
  END.*/

  RUN pi-formato.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF ct-ibs-mun-ft:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF cc-ibs-mun-ft:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF ct-ibs-uf-ft :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF cc-ibs-uf-ft :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF ct-cbs-ft    :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF cc-cbs-ft    :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.

  /* IS */
/*IF ct-is-ft    :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF cc-is-ft    :LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME} THEN. */

  ASSIGN ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         ct-ibs-uf-ft :SENSITIVE IN FRAME {&FRAME-NAME} = NO
         cc-ibs-uf-ft :SENSITIVE IN FRAME {&FRAME-NAME} = NO
         ct-cbs-ft    :SENSITIVE IN FRAME {&FRAME-NAME} = NO
         cc-cbs-ft    :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
     /*  ct-is-ft     :SENSITIVE IN FRAME {&FRAME-NAME} = NO
         cc-is-ft     :SENSITIVE IN FRAME {&FRAME-NAME} = NO. */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-formato.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */  


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  IF  AVAIL estabelec THEN DO:

      /* IBS Mun */
      IF CAN-FIND (FIRST estab-ctas-impto 
             WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
             AND   estab-ctas-impto.num-impto = 08) THEN DO:

         ASSIGN estab-ctas-impto.conta-imposto    = ct-ibs-mun-ft
                estab-ctas-impto.cod-ccusto-impto = cc-ibs-mun-ft.
      END.
      
      /* IBS UF */
      IF CAN-FIND (FIRST estab-ctas-impto 
              WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
              AND   estab-ctas-impto.num-impto = 09) THEN DO:

              ASSIGN estab-ctas-impto.conta-imposto    = ct-ibs-uf-ft
                     estab-ctas-impto.cod-ccusto-impto = cc-ibs-uf-ft.
       END.

       /* CBS */
       IF CAN-FIND (FIRST estab-ctas-impto 
              WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
              AND   estab-ctas-impto.num-impto = 10) THEN DO:

          ASSIGN estab-ctas-impto.conta-imposto    = ct-cbs-ft
                 estab-ctas-impto.cod-ccusto-impto = cc-cbs-ft.
       END.

       //A l gica abaixo ficar  comentada at  que o IS entre em vigor
 /*    /* IS */
       IF CAN-FIND (FIRST estab-ctas-impto 
              WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
              AND   estab-ctas-impto.num-impto = 11) THEN DO:

           ASSIGN estab-ctas-impto.conta-imposto    = ct-is-ft
                  estab-ctas-impto.cod-ccusto-impto = cc-is-ft.
       END. */
  END.
         
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empresa-formato V-table-Win 
PROCEDURE pi-empresa-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-v02ad107) THEN
        RUN pi-busca-empresa IN h-v02ad107 (OUTPUT i-empresaCtContabel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formato V-table-Win 
PROCEDURE pi-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN IniHandlers.

    /* Formatos de conta e centro de custo EMS5 */
    ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
           v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".

    IF  AVAIL estabelec THEN DO:
        ct-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = IF NOT ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN v_cod_format_cta   ELSE "x(20)" NO-ERROR.
        ct-ibs-uf-ft:FORMAT  IN FRAME {&FRAME-NAME} = IF NOT ct-ibs-uf-ft:SENSITIVE  IN FRAME {&FRAME-NAME} THEN v_cod_format_cta   ELSE "x(20)" NO-ERROR.
        ct-cbs-ft:FORMAT     IN FRAME {&FRAME-NAME} = IF NOT ct-cbs-ft:SENSITIVE     IN FRAME {&FRAME-NAME} THEN v_cod_format_cta   ELSE "x(20)" NO-ERROR.
        cc-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = IF NOT cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN v_cod_format_ccust ELSE "X(20)" NO-ERROR.
        cc-ibs-uf-ft:FORMAT  IN FRAME {&FRAME-NAME} = IF NOT cc-ibs-uf-ft:SENSITIVE  IN FRAME {&FRAME-NAME} THEN v_cod_format_ccust ELSE "X(20)" NO-ERROR.
        cc-cbs-ft:FORMAT     IN FRAME {&FRAME-NAME} = IF NOT cc-cbs-ft:SENSITIVE     IN FRAME {&FRAME-NAME} THEN v_cod_format_ccust ELSE "X(20)" NO-ERROR.
                                                                                                                                            
        /* IS */
     /* cc-is-ft:FORMAT  IN FRAME {&FRAME-NAME} = IF NOT cc-is-ft:SENSITIVE  IN FRAME {&FRAME-NAME} THEN v_cod_format_ccust ELSE "X(20)" NO-ERROR.
        cc-is-ft:FORMAT  IN FRAME {&FRAME-NAME} = IF NOT cc-is-ft:SENSITIVE  IN FRAME {&FRAME-NAME} THEN v_cod_format_ccust ELSE "X(20)" NO-ERROR. */
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-cod-estabel V-table-Win 
PROCEDURE pi-recebe-cod-estabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pc-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-leave        AS LOG  NO-UNDO.

    ASSIGN c-cod-estabel = pc-cod-estabel          
           c-cod-estabel-aux = IF c-cod-estabel = ? THEN "" else c-cod-estabel.

    IF  p-leave THEN
        RUN pi-formato.

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

    DEF INPUT PARAM ph-v02ad107 AS HANDLE NO-UNDO.
    
    ASSIGN h-v02ad107 = ph-v02ad107.

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
   DEF INPUT PARAMETER p-campo  AS CHAR NO-UNDO.
   DEF INPUT PARAMETER p-erro   AS LOG  NO-UNDO.
   
   EMPTY TEMP-TABLE tt_log_erro.

   IF VALID-HANDLE(h-v02ad107) THEN
       RUN pi-empresa-formato.
   
   RUN pi_busca_dados_ccusto IN h_api_ccust (INPUT        i-empresaCtContabel,     /* EMPRESA EMS2 */
                                             INPUT        "",                      /* PLANO DE CONTAS */
                                             INPUT        p-centro,                /* CCUSTO */
                                             INPUT        TODAY,                   /* DATA TRANSACAO */   
                                             OUTPUT       v_des_ccust,             /* DESCRICAO CCUSTO */
                                             OUTPUT TABLE tt_log_erro).            /* ERROS */
   /* validacao da conta */
   IF  CAN-FIND(tt_log_erro) 
   OR  RETURN-VALUE = "NOK" THEN
       FOR FIRST tt_log_erro:      
           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 17006, 
                              INPUT STRING(p-campo) + ' ' + c-lbl-liter-invalido + '. ' + STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + STRING(p-campo) + ' ' + c-lbl-liter-invalido + '. ' + tt_log_erro.ttv_des_msg_ajuda).       
           RETURN "adm-error".
       END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-centro-conta V-table-Win 
PROCEDURE pi-valida-centro-conta :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER v_cod_cta       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER v_log_utz_ccust AS LOGICAL   NO-UNDO.     
   
    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.
   
    RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                      INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
                                                      INPUT  "",                  /* PLANO CONTAS */
                                                      INPUT  v_cod_cta,           /* CONTA */
                                                      INPUT  TODAY,               /* DT TRANSACAO */
                                                      OUTPUT v_log_utz_ccust,     /* UTILIZA CCUSTO ? */
                                                      OUTPUT TABLE tt_log_erro).  /* ERROS */
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
   DEF INPUT PARAMETER p-campo AS CHAR NO-UNDO.
   
   ASSIGN i-empresaCtContabel = param-global.empresa-prin.
   
   IF  p-conta <> "" THEN DO:
       &IF DEFINED (bf_dis_consiste_conta) &THEN
           /*Inclu da esta condi  o, para que os clientes que utilizem a empresa por estabelecimento possam configurar
           ? no campo estabecimento. Neste caso, a conta cont bil continuar  sendo buscada com a empresa do param-global*/
           IF  c-cod-estabel <> ?
           AND c-cod-estabel <> "" THEN
               FOR FIRST estabelec 
                   WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK:               
                   RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                                     OUTPUT i-empresaCtContabel).
               END.
       &ENDIF
   
       ASSIGN v_cod_cta = p-conta.
       EMPTY TEMP-TABLE tt_log_erro.

       IF VALID-HANDLE(h-v02ad107) THEN
           RUN pi-empresa-formato.
       
       RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        i-empresaCtContabel,     /* EMPRESA EMS2 */
                                                 INPUT        "",                      /* PLANO DE CONTAS */
                                                 INPUT-OUTPUT v_cod_cta,               /* CONTA */
                                                 INPUT        TODAY,                   /* DATA TRANSACAO */   
                                                 OUTPUT       v_des_cta,               /* DESCRICAO CONTA */
                                                 OUTPUT       v_num_tip_cta,           /* TIPO DA CONTA */
                                                 OUTPUT       v_num_sit_cta,           /* SITUA  O DA CONTA */
                                                 OUTPUT       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                 OUTPUT TABLE tt_log_erro).            /* ERROS */                                                 
       
       /* validacao da conta */
       IF  CAN-FIND(tt_log_erro) 
       OR  RETURN-VALUE = "NOK" THEN DO:
           FOR FIRST tt_log_erro:
               RUN utp/ut-msgs.p (INPUT 'show',
                                  INPUT 17006, 
                                  INPUT STRING(p-campo) + ' ' + c-lbl-liter-invalida + '. ' + STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + STRING(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + STRING(p-campo) + ' ' + c-lbl-liter-invalida + '. ' + tt_log_erro.ttv_des_msg_ajuda).
               RETURN "adm-error".
           END.
       END.
       
       IF  v_num_tip_cta = 6 THEN DO:
           {include/i-vldprg.i}
           /*Conta Contabil nao pode ser do tipo Titulo*/
           RUN utp/ut-msgs.p ("show", 5000, "").
           RETURN "adm-error".        
       END.
       IF  v_num_sit_cta = 1 THEN DO:
           {include/i-vldprg.i}
           /*Conta Contabil deve ser de sistema*/
           RUN utp/ut-msgs.p ("show", 638, STRING(p-conta)).
           RETURN "adm-error".        
       END.
       IF  v_num_sit_cta = 2 THEN DO:
           {include/i-vldprg.i}
           /*Conta Contabil esta desativada*/
           RUN utp/ut-msgs.p ("show", 913, STRING(p-conta)).
           RETURN "adm-error".        
       END.
       IF  l-valida THEN DO:
           RUN pi_valida_cta_ctbl_integr IN h_api_cta (INPUT i-empresaCtContabel,
                                                       INPUT "FTP",
                                                       INPUT "",
                                                       INPUT v_cod_cta,
                                                       INPUT "(nenhum)",
                                                       INPUT TODAY,
                                                       OUTPUT TABLE tt_log_erro).
           IF  CAN-FIND(tt_log_erro) 
           OR  RETURN-VALUE = "NOK" THEN DO:
               {include/i-vldprg.i}
               /*Conta Contabil nao pode receber lancamentos do modulo de Faturamento*/
               RUN utp/ut-msgs.p ("show", 915, "").
               RETURN "adm-error".
           END.
       END.
       
   END. /* FIM IF p-conta <> "" THEN DO: */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-pais V-table-Win 
PROCEDURE pi-valida-pais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida  o de dicion rio */

    if  i-pais-impto-usuario = 1 then do:
    
        ASSIGN ct-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
        IF INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft <> "" THEN
            ASSIGN ct-ibs-mun-ft:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_fim.
        ASSIGN ct-ibs-mun-ft = INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft NO-ERROR.
        IF ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show", 9, " ").
            apply 'entry':U to ct-ibs-mun-ft IN FRAME {&FRAME-NAME}.
            return 'adm-error'.
        END.      
        
        ASSIGN ct-ibs-uf-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
        IF INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft <> "" THEN
            ASSIGN ct-ibs-uf-ft:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_fim.
        ASSIGN ct-ibs-uf-ft = INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft NO-ERROR.
        IF ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show", 9, " ").
            apply 'entry':U to ct-ibs-uf-ft IN FRAME {&FRAME-NAME}.
            return 'adm-error'.
        END.
        
        ASSIGN ct-cbs-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
        IF INPUT FRAME {&FRAME-NAME} ct-cbs-ft <> "" THEN
            ASSIGN ct-cbs-ft:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_fim.
        ASSIGN ct-cbs-ft = INPUT FRAME {&FRAME-NAME} ct-cbs-ft NO-ERROR.
        IF ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show", 9, " ").
            apply 'entry':U to ct-cbs-ft IN FRAME {&FRAME-NAME}.
            return 'adm-error'.
        END.  

        /* IS 
        ASSIGN ct-is-ft:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
        IF INPUT FRAME {&FRAME-NAME} ct-is-ft <> "" THEN
            ASSIGN ct-is-ft:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_fim.
        ASSIGN ct-is-ft = INPUT FRAME {&FRAME-NAME} ct-is-ft NO-ERROR.
        IF ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p ("show", 9, " ").
            apply 'entry':U to ct-is-ft IN FRAME {&FRAME-NAME}.
            return 'adm-error'.
        END.
        */  
        
        /* Apenas obrigar a colocaras contas quando a fun  o estiver ativa */
        IF  l-nt2024002 THEN DO:
            IF  ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN
                IF INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft = "" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"Conta IBS Munic a Recolher").   
                    apply 'entry':U to ct-ibs-mun-ft in frame {&FRAME-NAME}.
                    return 'adm-error'.
                END.            
            IF  ct-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN
                IF INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft = "" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"Conta IBS UF a Recolher").   
                    apply 'entry':U to ct-ibs-uf-ft in frame {&FRAME-NAME}.
                    return 'adm-error'.
                END.           
        
            IF  ct-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN
                IF INPUT FRAME {&FRAME-NAME} ct-cbs-ft = "" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"Conta CBS a Recolher").   
                    apply 'entry':U to ct-cbs-ft in frame {&FRAME-NAME}.
                    return 'adm-error'.
                END.    

            /* IS
            IF  ct-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN
                IF INPUT FRAME {&FRAME-NAME} ct-is-ft = "" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"Conta IS a Recolher").   
                    apply 'entry':U to ct-is-ft in frame {&FRAME-NAME}.
                    return 'adm-error'.
                END. */
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-pais-ccusto V-table-Win 
PROCEDURE pi-valida-pais-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /* Valida  o de dicion rio */   

    ASSIGN v_log_utz_ccust = NO.
    RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft, OUTPUT v_log_utz_ccust).
    IF  v_log_utz_ccust AND cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} 
    AND INPUT FRAME {&FRAME-NAME} cc-ibs-mun-ft = "" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p ("show",47,"C Custo IBS Munic a Recolher").   
        apply 'entry':U to cc-ibs-mun-ft in frame {&FRAME-NAME}.
        return 'adm-error'.
    END.
    
    ASSIGN v_log_utz_ccust = NO.
    RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft, OUTPUT v_log_utz_ccust).
    IF  v_log_utz_ccust AND cc-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} 
    AND INPUT FRAME {&FRAME-NAME} cc-ibs-uf-ft = "" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p ("show",47,"C Custo IBS UF a Recolher").   
        apply 'entry':U to cc-ibs-uf-ft in frame {&FRAME-NAME}.
        return 'adm-error'.
    END.
        
    ASSIGN v_log_utz_ccust = NO.
    RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-cbs-ft, OUTPUT v_log_utz_ccust).
    IF  v_log_utz_ccust AND cc-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} 
    AND INPUT FRAME {&FRAME-NAME} cc-cbs-ft = "" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p ("show",47,"C Custo CBS a Recolher").   
        apply 'entry':U to cc-cbs-ft in frame {&FRAME-NAME}.
        return 'adm-error'.
    END.

    /* IS
    ASSIGN v_log_utz_ccust = NO.
    RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-is-ft, OUTPUT v_log_utz_ccust).
    IF  v_log_utz_ccust AND cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} 
    AND INPUT FRAME {&FRAME-NAME} cc-is-ft = "" THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p ("show",47,"C Custo IS a Recolher").   
        apply 'entry':U to cc-is-ft in frame {&FRAME-NAME}.
        return 'adm-error'.
    END. */
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida  es, pois neste ponto do programa o registro 
  ainda n o foi criado.       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /*:T Valida  o de dicion rio */

    DEF VAR l-erro AS LOG NO-UNDO.
    
    run pi-valida-pais.  
    if return-value = "ADM-ERROR":U then 
        return "ADM-ERROR":U.           
    
    run pi-valida-pais-ccusto.
    if return-value = "ADM-ERROR":U then
        return "ADM-ERROR":U.
    
    EMPTY TEMP-TABLE tt_log_erro.

    IF l-nt2024002 THEN DO:
        IF  ct-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN l-valida = NO.
            RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft,"Conta IBS Munic").
            IF  return-value = "adm-error" then do:
                {include/i-vldprg.i}
                apply "entry" to ct-ibs-mun-ft in frame {&frame-name}.
                return "adm-error".
            END.
            ASSIGN v_log_utz_ccust = NO.
            RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-mun-ft, OUTPUT v_log_utz_ccust).
            IF  v_log_utz_ccust AND cc-ibs-mun-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
                run pi-valida-centro (input frame {&frame-name} cc-ibs-mun-ft,"Centro de Custo IBS Munic",YES).
                if  return-value = "adm-error" then do:
                    {include/i-vldprg.i}
                    apply "entry" to cc-ibs-mun-ft in frame {&frame-name}.
                    return "adm-error".
                end.
            end.
        END.
        
        IF  ct-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN l-valida = NO.
            RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft,"Conta IBS UF").
            IF  return-value = "adm-error" then do:
                {include/i-vldprg.i}
                apply "entry" to ct-ibs-uf-ft in frame {&frame-name}.
                return "adm-error".
            END.
            ASSIGN v_log_utz_ccust = NO.
            RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-ibs-uf-ft, OUTPUT v_log_utz_ccust).
            IF  v_log_utz_ccust AND cc-ibs-uf-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
                run pi-valida-centro (input frame {&frame-name} cc-ibs-uf-ft,"Centro de Custo IBS UF",YES).
                if  return-value = "adm-error" then do:
                    {include/i-vldprg.i}
                    apply "entry" to cc-ibs-uf-ft in frame {&frame-name}.
                    return "adm-error".
                end.
            end.
        END.
    
        IF  ct-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN l-valida = NO.
            RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} ct-cbs-ft,"Conta CBS").
            IF  return-value = "adm-error" then do:
                {include/i-vldprg.i}
                apply "entry" to ct-cbs-ft in frame {&frame-name}.
                return "adm-error".
            END.       
            
            ASSIGN v_log_utz_ccust = NO.
            RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-cbs-ft, OUTPUT v_log_utz_ccust).
            IF  v_log_utz_ccust AND cc-cbs-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
                run pi-valida-centro (input frame {&frame-name} cc-cbs-ft,"Centro de Custo CBS",YES).
                if  return-value = "adm-error" then do:
                    {include/i-vldprg.i}
                    apply "entry" to cc-cbs-ft in frame {&frame-name}.
                    return "adm-error".
                end.
            end.        
        END.
    
        /* IS
        IF  ct-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN l-valida = NO.
            RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} ct-is-ft,"Conta IS").
            IF  return-value = "adm-error" then do:
                {include/i-vldprg.i}
                apply "entry" to ct-is-ft in frame {&frame-name}.
                return "adm-error".
            END.       
            
            ASSIGN v_log_utz_ccust = NO.
            RUN pi-valida-centro-conta (INPUT FRAME {&FRAME-NAME} ct-is-ft, OUTPUT v_log_utz_ccust).
            IF  v_log_utz_ccust AND cc-is-ft:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
                run pi-valida-centro (input frame {&frame-name} cc-is-ft,"Centro de Custo IS",YES).
                if  return-value = "adm-error" then do:
                    {include/i-vldprg.i}
                    apply "entry" to cc-is-ft in frame {&frame-name}.
                    return "adm-error".
                end.
            end.        
        END. */
    END.
    
    RETURN "OK":U.

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
DEF INPUT  PARAM p-conta AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-log   AS LOG  NO-UNDO.

IF VALID-HANDLE(h-v02ad107) THEN
    RUN pi-empresa-formato.

RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresaCtContabel, /* EMPRESA EMS 2 */
                                                  INPUT  c-cod-estabel-aux,   /* ESTABELECIMENTO EMS2 */
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
  {src/adm/template/sndkycas.i "cod-estabel" "it-doc-fisc" "cod-estabel"}
  {src/adm/template/sndkycas.i "cd-vin-ipi" "it-doc-fisc" "cd-vin-ipi"}
  {src/adm/template/sndkycas.i "cod-servico" "it-doc-fisc" "cod-servico"}

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


