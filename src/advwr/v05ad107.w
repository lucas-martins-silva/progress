&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V05AD107 2.00.00.014 } /*** "010014" 26/06/2024 16:44:01 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V05AD107 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

DEF VAR c-cod-estabel     AS CHAR NO-UNDO.
DEF VAR c-cod-empresa     AS CHAR NO-UNDO.

/* Local Variable Definitions --- */
DEF VAR i-empresa           LIKE param-global.empresa-prin NO-UNDO.

/*Inicio Unifica‡Æo de Conceitos CONTA CONTABIL 2011*/
DEF VAR i-empresaCtContabel LIKE param-global.empresa-prin NO-UNDO.

DEF VAR h_api_cta               AS HANDLE NO-UNDO.
DEF VAR h-v01ad107              AS HANDLE NO-UNDO.
DEF VAR h-v02ad107              AS HANDLE NO-UNDO.
DEF VAR h_api_ccust             AS HANDLE NO-UNDO.
DEF VAR v_cod_cta               AS CHAR   NO-UNDO.
DEF VAR v_des_cta               AS CHAR   NO-UNDO.
DEF VAR v_cod_ccust             AS CHAR   NO-UNDO.
DEF VAR v_des_ccust             AS CHAR   NO-UNDO.
DEF VAR v_cod_format_cta        AS CHAR   NO-UNDO.
DEF VAR v_cod_format_ccust      AS CHAR   NO-UNDO.
DEF VAR v_cod_format_inic       AS CHAR   NO-UNDO.
DEF VAR v_cod_format_fim        AS CHAR   NO-UNDO.
DEF VAR v_ind_finalid_cta       AS CHAR   NO-UNDO.
DEF VAR v_num_tip_cta           AS INT    NO-UNDO.
DEF VAR v_num_sit_cta           AS INT    NO-UNDO.
DEF VAR v_log_utz_ccust         AS LOG    NO-UNDO.
DEF VAR v_cod_format_inic_ccust AS CHAR   NO-UNDO.
DEF VAR v_cod_format_fim_ccust  AS CHAR   NO-UNDO.
DEF VAR l-utiliza-ccusto        AS LOG    NO-UNDO.
DEF VAR c-indice                AS CHAR   NO-UNDO.
DEF VAR v-row-parent            AS ROWID  NO-UNDO.
DEF VAR l-valida                AS LOGICAL NO-UNDO.

DEF TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro  AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistˆncia".


/*Fim Unifica‡Æo de Conceitos CONTA CONTABIL 2011*/

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
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-cod-cta-difal-dest c-cod-cta-difal-orig c-cod-cta-fet c-cod-cta-fcp c-cod-cta-fcpst ~
c-cod-cc-difal-dest c-cod-cc-difal-orig c-cod-cc-fcp c-cod-cc-fcpst c-cod-cc-fet 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-cod-cta-difal-dest c-cod-cta-difal-orig c-cod-cta-fcp c-cod-cta-fet c-cod-cta-fcpst ~
c-cod-cc-difal-dest c-cod-cc-difal-orig c-cod-cc-fcp c-cod-cc-fet c-cod-cc-fcpst 
&Scoped-define ADM-MODIFY-FIELDS c-cod-cta-difal-dest c-cod-cta-difal-orig c-cod-cta-fcp c-cod-cta-fet c-cod-cta-fcpst ~
c-cod-cc-difal-dest c-cod-cc-difal-orig c-cod-cc-fcp c-cod-cc-fet c-cod-cc-fcpst 

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
DEFINE VARIABLE c-cod-cta-difal-dest AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cc-difal-dest AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cta-difal-orig AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cc-difal-orig AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cta-fcp AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cta-fcpst AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cc-fcp AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cc-fcpst AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cc-fet AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-cod-cc-fet" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cta-fet AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-cod-cta-fet" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 12.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-cta-difal-orig AT ROW 1.63 COL 19.29 COLON-ALIGNED
     c-cod-cc-difal-orig  AT ROW 1.63 COL 64.43 COLON-ALIGNED 
     c-cod-cta-difal-dest AT ROW 2.63 COL 19.29 COLON-ALIGNED
     c-cod-cc-difal-dest  AT ROW 2.63 COL 64.43 COLON-ALIGNED
     c-cod-cta-fcp        AT ROW 3.63 COL 19.29 COLON-ALIGNED
     c-cod-cc-fcp         AT ROW 3.63 COL 64.43 COLON-ALIGNED
     c-cod-cta-fcpst      AT ROW 4.63 COL 19.29 COLON-ALIGNED
     c-cod-cc-fcpst       AT ROW 4.63 COL 64.43 COLON-ALIGNED
     c-cod-cta-fet        AT ROW 5.63 COL 19.29 COLON-ALIGNED HELP
          "C¢digo Conta Fundo Estadual de Transporte/Conta Fundo"
     c-cod-cc-fet         AT ROW 5.63 COL 64.43 COLON-ALIGNED HELP
          "Centro de Custo Fundo Estadual de Transporte/CC Fundo"
     rt-mold AT ROW 1.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.estabelec
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: External-Tables
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
         HEIGHT             = 13
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-cta-difal-dest IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-cod-cta-difal-orig IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-cod-cta-fcp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-cod-cc-difal-dest IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-cod-cc-difal-orig IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-cod-cc-fcp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartViewerCues" V-table-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/*:T SmartViewer,uib,50030 
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-cta-difal-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-orig V-table-Win
ON ENTRY OF c-cod-cta-difal-orig IN FRAME f-main
DO:   
  ASSIGN c-cod-cta-difal-orig:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-difal-orig :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-orig V-table-Win
ON F5 OF c-cod-cta-difal-orig IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  c-cod-empresa,          /* EMPRESA EMS2 */
                                              INPUT  "FTP",                  /* M¹DULO */
                                              INPUT  "",                     /* PLANO DE CONTAS */
                                              INPUT  "(nenhum)",             /* FINALIDADES */
                                              INPUT  TODAY,                  /* DATA TRANSACAO */
                                              OUTPUT v_cod_cta,              /* CODIGO CONTA */
                                              OUTPUT v_des_cta,              /* DESCRICAO CONTA */
                                              OUTPUT v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              OUTPUT TABLE tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-orig V-table-Win
ON LEAVE OF c-cod-cta-difal-orig IN FRAME f-main
DO: 
    IF c-cod-cta-difal-orig:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-orig NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-cod-cta-difal-orig:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
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
                ASSIGN c-cod-cc-difal-orig:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-cod-cc-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-cc-difal-orig:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-cod-cc-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-cc-difal-orig:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-cc-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-cc-difal-orig:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-orig V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-difal-orig IN FRAME f-main
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cta-difal-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-dest V-table-Win
ON ENTRY OF c-cod-cta-difal-dest IN FRAME f-main
DO:   
  ASSIGN c-cod-cta-difal-dest:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-difal-dest :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-dest V-table-Win
ON F5 OF c-cod-cta-difal-dest IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  c-cod-empresa,          /* EMPRESA EMS2 */
                                              INPUT  "FTP",                  /* M¹DULO */
                                              INPUT  "",                     /* PLANO DE CONTAS */
                                              INPUT  "(nenhum)",             /* FINALIDADES */
                                              INPUT  TODAY,                  /* DATA TRANSACAO */
                                              OUTPUT v_cod_cta,              /* CODIGO CONTA */
                                              OUTPUT v_des_cta,              /* DESCRICAO CONTA */
                                              OUTPUT v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              OUTPUT TABLE tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-dest V-table-Win
ON LEAVE OF c-cod-cta-difal-dest IN FRAME f-main
DO: 
    IF c-cod-cta-difal-dest:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-dest NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-cod-cta-difal-dest:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
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
                ASSIGN c-cod-cc-difal-dest:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-cod-cc-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-cc-difal-dest:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-cod-cc-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-cc-difal-dest:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-cc-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-cc-difal-dest:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-difal-dest V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-difal-dest IN FRAME f-main
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cta-fcp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcp V-table-Win
ON ENTRY OF c-cod-cta-fcp IN FRAME f-main
DO:   
  ASSIGN c-cod-cta-fcp:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-fcp :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcp V-table-Win
ON F5 OF c-cod-cta-fcp IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  c-cod-empresa,          /* EMPRESA EMS2 */
                                              INPUT  "FTP",                  /* M¹DULO */
                                              INPUT  "",                     /* PLANO DE CONTAS */
                                              INPUT  "(nenhum)",             /* FINALIDADES */
                                              INPUT  TODAY,                  /* DATA TRANSACAO */
                                              OUTPUT v_cod_cta,              /* CODIGO CONTA */
                                              OUTPUT v_des_cta,              /* DESCRICAO CONTA */
                                              OUTPUT v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              OUTPUT TABLE tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcp V-table-Win
ON LEAVE OF c-cod-cta-fcp IN FRAME f-main
DO: 
    IF c-cod-cta-fcp:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-fcp NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-cod-cta-fcp:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
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
                ASSIGN c-cod-cc-fcp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-cod-cc-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-cc-fcp:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-cod-cc-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-cc-fcp:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-cc-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-cc-fcp:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-fcp IN FRAME f-main
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cta-fcpst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcpst V-table-Win
ON ENTRY OF c-cod-cta-fcpst IN FRAME f-main
DO:   
  ASSIGN c-cod-cta-fcpst:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-fcpst :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcpst V-table-Win
ON F5 OF c-cod-cta-fcpst IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  c-cod-empresa,      /* EMPRESA EMS2 */
                                              INPUT  "FTP",              /* M¹DULO */
                                              INPUT  "",                 /* PLANO DE CONTAS */
                                              INPUT  "(nenhum)",         /* FINALIDADES */
                                              INPUT  TODAY,              /* DATA TRANSACAO */
                                              OUTPUT v_cod_cta,          /* CODIGO CONTA */
                                              OUTPUT v_des_cta,          /* DESCRICAO CONTA */
                                              OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                              OUTPUT TABLE tt_log_erro). /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcpst V-table-Win
ON LEAVE OF c-cod-cta-fcpst IN FRAME f-main
DO: 
    IF c-cod-cta-fcpst:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-fcpst NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-cod-cta-fcpst:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
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
                ASSIGN c-cod-cc-fcpst:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-cod-cc-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-cc-fcpst:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-cod-cc-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-cc-fcpst:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-cc-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-cc-fcpst:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fcpst V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-fcpst IN FRAME f-main
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod-cta-fet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fet V-table-Win
ON ENTRY OF c-cod-cta-fet IN FRAME f-main /* c-cod-cta-fet */
DO:
    ASSIGN c-cod-cta-fet:FORMAT   IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-cc-fet:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fet V-table-Win
ON F5 OF c-cod-cta-fet IN FRAME f-main /* c-cod-cta-fet */
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  c-cod-empresa,          /* EMPRESA EMS2 */
                                              INPUT  "FTP",                  /* M¹DULO */
                                              INPUT  "",                     /* PLANO DE CONTAS */
                                              INPUT  "(nenhum)",             /* FINALIDADES */
                                              INPUT  TODAY,                  /* DATA TRANSACAO */
                                              OUTPUT v_cod_cta,              /* CODIGO CONTA */
                                              OUTPUT v_des_cta,              /* DESCRICAO CONTA */
                                              OUTPUT v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              OUTPUT TABLE tt_log_erro).     /* ERROS */ 
     
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
            ASSIGN c-cod-cta-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fet V-table-Win
ON LEAVE OF c-cod-cta-fet IN FRAME f-main /* c-cod-cta-fet */
DO:
    IF c-cod-cta-fet:SCREEN-VALUE <> "" THEN DO:
        IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

        RUN limpaErros.
        ASSIGN v_cod_cta = INPUT FRAME {&FRAME-NAME} c-cod-cta-fet NO-ERROR.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT        "",                  /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT v_cod_cta,           /* CONTA */
                                                  INPUT        TODAY,               /* DATA TRANSACAO */   
                                                  OUTPUT       v_des_cta,           /* DESCRICAO CONTA */
                                                  OUTPUT       v_num_tip_cta,       /* TIPO DA CONTA */
                                                  OUTPUT       v_num_sit_cta,       /* SITUAø°O DA CONTA */
                                                  OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE tt_log_erro).        /* ERROS */ 
        
        IF NOT CAN-FIND(tt_log_erro) OR RETURN-VALUE = "OK" THEN DO:
            ASSIGN c-cod-cta-fet:FORMAT       IN FRAME {&FRAME-NAME} = v_cod_format_fim
                   c-cod-cta-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta NO-ERROR.
                          
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
                ASSIGN c-cod-cc-fet:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
            END.
            ELSE DO:
                ASSIGN c-cod-cc-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-cc-fet:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            END.
        END.
        ELSE 
            ASSIGN c-cod-cc-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-cod-cc-fet:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN c-cod-cc-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-cod-cc-fet:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cta-fet V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cta-fet IN FRAME f-main /* c-cod-cta-fet */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cc-fet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fet V-table-Win
ON ENTRY OF c-cod-cc-fet IN FRAME f-main /* c-cod-cc-fet */
DO:
    ASSIGN c-cod-cc-fet:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fet V-table-Win
ON F5 OF c-cod-cc-fet IN FRAME f-main /* c-cod-cc-fet */
OR MOUSE-SELECT-DBLCLICK OF c-cod-cc-fet IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_ccusto IN h_api_ccust (INPUT  c-cod-empresa,        /* EMPRESA EMS2 */
                                       INPUT  "",                   /* CODIGO DO PLANO CCUSTO */
                                       INPUT  "",                   /* UNIDADE DE NEGOCIO */
                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                       OUTPUT v_cod_ccust,          /* CODIGO CCUSTO */
                                       OUTPUT v_des_ccust,          /* DESCRICAO CCUSTO */
                                       OUTPUT TABLE tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-cc-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fet V-table-Win
ON LEAVE OF c-cod-cc-fet IN FRAME f-main /* c-cod-cc-fet */
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fet).
    ASSIGN c-cod-cc-fet:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cc-difal-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-orig V-table-Win
ON ENTRY OF c-cod-cc-difal-orig IN FRAME f-main
DO:
    ASSIGN c-cod-cc-difal-orig:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-orig V-table-Win
ON F5 OF c-cod-cc-difal-orig IN FRAME f-main
OR MOUSE-SELECT-DBLCLICK OF c-cod-cc-difal-orig IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    RUN pi_zoom_ccusto IN h_api_ccust (INPUT  c-cod-empresa,        /* EMPRESA EMS2 */
                                       INPUT  "",                   /* CODIGO DO PLANO CCUSTO */
                                       INPUT  "",                   /* UNIDADE DE NEGOCIO */
                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                       OUTPUT v_cod_ccust,          /* CODIGO CCUSTO */
                                       OUTPUT v_des_ccust,          /* DESCRICAO CCUSTO */
                                       OUTPUT TABLE tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-cc-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-orig V-table-Win
ON LEAVE OF c-cod-cc-difal-orig IN FRAME f-main
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-orig).
    ASSIGN c-cod-cc-difal-orig:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod-cc-difal-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-dest V-table-Win
ON ENTRY OF c-cod-cc-difal-dest IN FRAME f-main
DO:
    ASSIGN c-cod-cc-difal-dest:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-dest V-table-Win
ON F5 OF c-cod-cc-difal-dest IN FRAME f-main
OR MOUSE-SELECT-DBLCLICK OF c-cod-cc-difal-dest IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_ccusto IN h_api_ccust (INPUT  c-cod-empresa,        /* EMPRESA EMS2 */
                                       INPUT  "",                   /* CODIGO DO PLANO CCUSTO */
                                       INPUT  "",                   /* UNIDADE DE NEGOCIO */
                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                       OUTPUT v_cod_ccust,          /* CODIGO CCUSTO */
                                       OUTPUT v_des_ccust,          /* DESCRICAO CCUSTO */
                                       OUTPUT TABLE tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-cc-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-difal-dest V-table-Win
ON LEAVE OF c-cod-cc-difal-dest IN FRAME f-main
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-dest).
    ASSIGN c-cod-cc-difal-dest:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cc-fcp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcp V-table-Win
ON ENTRY OF c-cod-cc-fcp IN FRAME f-main
DO:
    ASSIGN c-cod-cc-fcp:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcp V-table-Win
ON F5 OF c-cod-cc-fcp IN FRAME f-main
OR MOUSE-SELECT-DBLCLICK OF c-cod-cc-fcp IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
            RUN pi-empresa-formato.

    RUN pi_zoom_ccusto IN h_api_ccust (INPUT  c-cod-empresa,        /* EMPRESA EMS2 */
                                       INPUT  "",                   /* CODIGO DO PLANO CCUSTO */
                                       INPUT  "",                   /* UNIDADE DE NEGOCIO */
                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                       OUTPUT v_cod_ccust,          /* CODIGO CCUSTO */
                                       OUTPUT v_des_ccust,          /* DESCRICAO CCUSTO */
                                       OUTPUT TABLE tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-cc-fcp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcp V-table-Win
ON LEAVE OF c-cod-cc-fcp IN FRAME f-main
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fcp).
    ASSIGN c-cod-cc-fcp:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod-cc-fcpst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcpst V-table-Win
ON ENTRY OF c-cod-cc-fcpst IN FRAME f-main
DO:
    ASSIGN c-cod-cc-fcpst:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcpst V-table-Win
ON F5 OF c-cod-cc-fcpst IN FRAME f-main
OR MOUSE-SELECT-DBLCLICK OF c-cod-cc-fcpst IN FRAME f-main
DO:
    RUN limpaErros.

    IF VALID-HANDLE(h-v02ad107) THEN
        RUN pi-empresa-formato.

    RUN pi_zoom_ccusto IN h_api_ccust (INPUT  c-cod-empresa,        /* EMPRESA EMS2 */
                                       INPUT  "",                   /* CODIGO DO PLANO CCUSTO */
                                       INPUT  "",                   /* UNIDADE DE NEGOCIO */
                                       INPUT  TODAY,                /* DATA DE TRANSACAO */
                                       OUTPUT v_cod_ccust,          /* CODIGO CCUSTO */
                                       OUTPUT v_des_ccust,          /* DESCRICAO CCUSTO */
                                       OUTPUT TABLE tt_log_erro).   /* ERROS */ 
           
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-cod-cc-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cc-fcpst V-table-Win
ON LEAVE OF c-cod-cc-fcpst IN FRAME f-main
DO:
    RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fcpst).
    ASSIGN c-cod-cc-fcpst:FORMAT IN FRAME {&FRAME-NAME} = IF RETURN-VALUE = "adm-error" THEN "x(20)" ELSE v_cod_format_fim_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***************************  Main Block  *************************** */

    if c-cod-cta-difal-orig:load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cc-difal-orig :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cta-difal-dest:load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cc-difal-dest :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cta-fcp       :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cc-fcp        :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cta-fcpst     :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cc-fcpst      :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cta-fet       :load-mouse-pointer ("image/lupa.cur") then.
    if c-cod-cc-fet        :load-mouse-pointer ("image/lupa.cur") then.
    
    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN        
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         
  
    /*Unifica»’o de conceitos Conta-contabil ems5*/
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-empresaCtContabel = param-global.empresa-prin.

    RUN IniHandlers.

    /* Formatos de conta e centro de custo EMS5 */
    ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
           v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".

    ASSIGN c-cod-cta-difal-orig:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cc-difal-orig :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cta-difal-dest:FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cc-difal-dest :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cta-fcp       :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cc-fcp        :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cta-fcpst     :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cc-fcpst      :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cta-fet       :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cc-fet        :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust.
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    DEF VAR aux-des-campo   AS CHARACTER NO-UNDO.
    DEF VAR aux-des-campo-2 AS CHARACTER NO-UNDO.
    DEF VAR aux-cod-livre-1 AS CHARACTER NO-UNDO.
    DEF VAR aux-cod-livre-2 AS CHARACTER NO-UNDO.

    ASSIGN aux-des-campo   = (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcp        + "#" + INPUT FRAME {&FRAME-NAME} c-cod-cc-fcp)
           aux-des-campo-2 = (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcpst      + "#" + INPUT FRAME {&FRAME-NAME} c-cod-cc-fcpst)
           aux-cod-livre-1 = (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-dest + "#" + INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-dest)
           aux-cod-livre-2 = (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-orig + "#" + INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-orig).
    
    ASSIGN INPUT FRAME {&FRAME-NAME} c-cod-cta-fet c-cod-cc-fet NO-ERROR.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.

    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN OVERLAY(estabelec.char-2,238,20) = c-cod-cta-fet NO-ERROR.
    ASSIGN OVERLAY(estabelec.char-2,259,20) = IF SUBSTRING(estabelec.char-2,238,20) <> "" THEN c-cod-cc-fet ELSE "" NO-ERROR.

    RUN pi-verifica-ccusto (c-cod-cta-difal-dest,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN c-cod-cc-difal-dest = "".
    RUN pi-verifica-ccusto (c-cod-cta-difal-orig,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN c-cod-cc-difal-orig = "".
    RUN pi-verifica-ccusto (c-cod-cta-fcp,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN c-cod-cc-fcp = "".
    RUN pi-verifica-ccusto (c-cod-cta-fcpst,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN c-cod-cc-fcpst = "".
    RUN pi-verifica-ccusto (c-cod-cta-fet,OUTPUT l-utiliza-ccusto).
    IF NOT l-utiliza-ccusto THEN ASSIGN c-cod-cc-fet = "".

    IF VALID-HANDLE(h-v01ad107) THEN
        RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).
        
    ASSIGN c-indice = TRIM(c-cod-estabel).
    
    FOR FIRST reg-inf-compl NO-LOCK
        WHERE reg-inf-compl.cod-tab-inform   = "CONTA-CONTAB-CD0403":U
          AND reg-inf-compl.cod-campo-inform = "CONTA-CONTAB-CD0403":U:
    END.
    
    IF  NOT AVAIL reg-inf-compl THEN DO:
        CREATE reg-inf-compl.
        ASSIGN reg-inf-compl.cdn-identif      = 18
               reg-inf-compl.cod-tab-inform   = "CONTA-CONTAB-CD0403":U
               reg-inf-compl.cod-campo-inform = "CONTA-CONTAB-CD0403":U
               reg-inf-compl.des-campo-inform = "CONTAS CONTABEIS ESTABELEC - EC87/2015":U.
    END.
    
    /*******************/

    FOR FIRST inf-compl EXCLUSIVE-LOCK
        WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*18*/
          AND inf-compl.cod-indice  = c-indice
          AND inf-compl.num-campo   = 0:
    END.
    
    IF  NOT AVAIL inf-compl THEN DO:
        CREATE inf-compl.
        ASSIGN inf-compl.cdn-identif = reg-inf-compl.cdn-identif
               inf-compl.cod-indice  = c-indice
               inf-compl.num-campo   = 0.
    END.

    ASSIGN inf-compl.des-campo   = aux-des-campo    /* FCP        */
           inf-compl.cod-livre-1 = aux-cod-livre-1  /* DIFAL Dest */
           inf-compl.cod-livre-2 = aux-cod-livre-2. /* DIFAL Orig */

    /*******************/

    FOR FIRST inf-compl EXCLUSIVE-LOCK
        WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*18*/
          AND inf-compl.cod-indice  = c-indice
          AND inf-compl.num-campo   = 1:
    END.
    
    IF  NOT AVAIL inf-compl THEN DO:
        CREATE inf-compl.
        ASSIGN inf-compl.cdn-identif = reg-inf-compl.cdn-identif
               inf-compl.cod-indice  = c-indice
               inf-compl.num-campo   = 1.
    END.

    ASSIGN inf-compl.des-campo = aux-des-campo-2. /* FCP ST */

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    RUN IniHandlers.
  
    IF AVAIL estabelec THEN
        ASSIGN c-cod-cta-fet:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(SUBSTRING(estabelec.char-2,238,20)) 
               c-cod-cc-fet :SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(SUBSTRING(estabelec.char-2,259,20)). 

    /* Formatos de conta e centro de custo EMS5 */
    ASSIGN v_cod_format_ccust = IF v_cod_format_fim_ccust <> "" THEN v_cod_format_fim_ccust ELSE "X(20)" 
           v_cod_format_cta   = IF v_cod_format_fim       <> "" THEN v_cod_format_fim       ELSE "X(20)".

    ASSIGN c-cod-cc-difal-dest  :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cc-difal-orig  :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cc-fcp         :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cc-fet         :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cc-fcpst       :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_ccust
           c-cod-cta-difal-dest :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cta-difal-orig :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cta-fcp        :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta 
           c-cod-cta-fet        :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta
           c-cod-cta-fcpst      :FORMAT IN FRAME {&FRAME-NAME} = v_cod_format_cta NO-ERROR.

    /* Dispatch standard ADM method.                               */
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/
    /* Code placed here will execute AFTER standard behavior.      */

    IF VALID-HANDLE(h-v01ad107) THEN
        RUN pi-busca-estabel IN h-v01ad107 (OUTPUT c-cod-estabel).
    
    ASSIGN c-indice = TRIM(c-cod-estabel).

    FOR FIRST reg-inf-compl NO-LOCK
        WHERE reg-inf-compl.cod-tab-inform   = "CONTA-CONTAB-CD0403":U
          AND reg-inf-compl.cod-campo-inform = "CONTA-CONTAB-CD0403":U:
    END.
    
    IF AVAIL reg-inf-compl THEN DO:
        FOR FIRST inf-compl NO-LOCK
            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*18*/
              AND inf-compl.cod-indice  = c-indice
              AND inf-compl.num-campo   = 0:
        END.

        IF AVAIL inf-compl THEN
            ASSIGN c-cod-cta-fcp       :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,inf-compl.des-campo, "#")   
                   c-cod-cc-fcp        :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,inf-compl.des-campo, "#")   
                   c-cod-cta-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,inf-compl.cod-livre-1, "#") 
                   c-cod-cc-difal-dest :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,inf-compl.cod-livre-1, "#") 
                   c-cod-cta-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,inf-compl.cod-livre-2, "#") 
                   c-cod-cc-difal-orig :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,inf-compl.cod-livre-2, "#").
        ELSE 
            ASSIGN c-cod-cta-fcp       :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cc-fcp        :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cta-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cc-difal-dest :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cta-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cc-difal-orig :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".

        /*************************/

        FOR FIRST inf-compl NO-LOCK
            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*18*/
              AND inf-compl.cod-indice  = c-indice
              AND inf-compl.num-campo   = 1:
        END.

        IF AVAIL inf-compl THEN
            ASSIGN c-cod-cta-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,inf-compl.des-campo, "#")   
                   c-cod-cc-fcpst :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,inf-compl.des-campo, "#").
        ELSE 
            ASSIGN c-cod-cta-fcpst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                   c-cod-cc-fcpst :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
    END.
    ELSE DO:
        ASSIGN c-cod-cta-fcp       :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cc-fcp        :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cta-fcpst     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cc-fcpst      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cta-difal-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cc-difal-dest :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cta-difal-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-cod-cc-difal-orig :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
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
/*     RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
/*     if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
  
  RUN pi-verifica-ccusto (c-cod-cta-difal-dest,OUTPUT l-utiliza-ccusto).
  ASSIGN c-cod-cc-difal-dest:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
  RUN pi-verifica-ccusto (c-cod-cta-difal-orig,OUTPUT l-utiliza-ccusto).
  ASSIGN c-cod-cc-difal-orig:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
  RUN pi-verifica-ccusto (c-cod-cta-fcp,OUTPUT l-utiliza-ccusto).
  ASSIGN c-cod-cc-fcp:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
  RUN pi-verifica-ccusto (c-cod-cta-fcpst,OUTPUT l-utiliza-ccusto).
  ASSIGN c-cod-cc-fcpst:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.
  RUN pi-verifica-ccusto (c-cod-cta-fet,OUTPUT l-utiliza-ccusto).
  ASSIGN c-cod-cc-fet:SENSITIVE IN FRAME {&FRAME-NAME} = l-utiliza-ccusto.

  ASSIGN c-cod-cta-difal-dest :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-difal-dest  :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cta-difal-orig :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-difal-orig  :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cta-fcp        :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-fcp         :FORMAT IN FRAME {&FRAME-NAME} = "x(20)" 
         c-cod-cta-fcpst      :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-fcpst       :FORMAT IN FRAME {&FRAME-NAME} = "x(20)" 
         c-cod-cta-fet        :FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         c-cod-cc-fet         :FORMAT IN FRAME {&FRAME-NAME} = "x(20)" NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
    {utp/ut-liter.i ICMS_DIFAL_Orig_Recolher MCD l}      c-cod-cta-difal-orig :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i ICMS_DIFAL_Dest_Recolher MCD l}      c-cod-cta-difal-dest :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i Fundo_Pobreza_Recolher MCD l}        c-cod-cta-fcp        :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i Fundo_Pobreza_ST_Recolher MCD l}     c-cod-cta-fcpst      :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i CC_ICMS_DIFAL_Orig_Recolher MCD l}   c-cod-cc-difal-orig  :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i CC_ICMS_DIFAL_Dest_Recolher MCD l}   c-cod-cc-difal-dest  :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i CC_Fundo_Pobreza_Recolher MCD l}     c-cod-cc-fcp         :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i CC_Fundo_Pobreza_ST_Recolher MCD l}  c-cod-cc-fcpst       :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i FET/FUNDO_Recolher MCD l}            c-cod-cta-fet        :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i CC_FET/FUNDO_Recolher MCD l}         c-cod-cc-fet         :LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

    ASSIGN c-cod-cc-difal-dest :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cc-difal-orig :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cc-fcp        :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cc-fcpst      :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-difal-dest:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-fcp       :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-fcpst     :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-cod-cta-difal-orig:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */

    RUN limpaErros.

    IF i-pais-impto-usuario = 1 THEN DO:
        ASSIGN c-cod-cta-difal-dest:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
               c-cod-cc-difal-dest :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-cod-cta-difal-orig:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
               c-cod-cc-difal-orig :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-cod-cta-fcp       :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
               c-cod-cc-fcp        :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-cod-cta-fcpst     :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
               c-cod-cc-fcpst      :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-cod-cta-fet       :FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
               c-cod-cc-fet        :SENSITIVE IN FRAME {&FRAME-NAME} = NO.

        IF NOT c-cod-cta-difal-dest:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
           ASSIGN l-valida = YES.
           RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-dest).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"ICMS Difal UF Destino Recolher").
                apply 'entry':U to c-cod-cta-difal-dest in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           IF c-cod-cc-difal-dest:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
               RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-dest).
               IF RETURN-VALUE = "adm-error" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"CC Desp ICMS Difal UF Destino").
                    apply 'entry':U to c-cod-cc-difal-dest in frame {&FRAME-NAME}.
                    return 'adm-error'.
               END.
               RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-dest, INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-dest).
               IF RETURN-VALUE = "adm-error" THEN DO:
                   APPLY 'entry':U TO c-cod-cc-difal-dest IN FRAME {&FRAME-NAME}.
                   RETURN 'adm-error'.
               END.
           END.
        END.
    
        IF NOT c-cod-cta-difal-orig:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
           ASSIGN l-valida = YES.
           RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-orig).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"ICMS Difal UF Origem Recolher").
                apply 'entry':U to c-cod-cta-difal-orig in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           IF c-cod-cc-difal-orig:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
               RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-orig).
               IF RETURN-VALUE = "adm-error" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"CC Desp ICMS Difal UF Origem").
                    apply 'entry':U to c-cod-cc-difal-orig in frame {&FRAME-NAME}.
                    return 'adm-error'.
               END.
               RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-difal-orig, INPUT FRAME {&FRAME-NAME} c-cod-cc-difal-orig).
               IF RETURN-VALUE = "adm-error" THEN DO:
                   APPLY 'entry':U TO c-cod-cc-difal-orig IN FRAME {&FRAME-NAME}.
                   RETURN 'adm-error'.
               END.
           END.
        END.
    
        IF NOT c-cod-cta-fcp:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
           ASSIGN l-valida = YES.
           RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcp).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"ICMS Fundo Combate a Pobreza").
                apply 'entry':U to c-cod-cta-fcp in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           IF c-cod-cc-fcp:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
               RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fcp).
               IF RETURN-VALUE = "adm-error" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"CC Desp ICMS Fundo Combate a Pobreza").
                    apply 'entry':U to c-cod-cc-fcp in frame {&FRAME-NAME}.
                    return 'adm-error'.
               END.
               RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcp, INPUT FRAME {&FRAME-NAME} c-cod-cc-fcp).
               IF RETURN-VALUE = "adm-error" THEN DO:
                   APPLY 'entry':U TO c-cod-cc-fcp IN FRAME {&FRAME-NAME}.
                   RETURN 'adm-error'.
               END.
           END.
        END.

        IF NOT c-cod-cta-fcpst:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
           ASSIGN l-valida = YES.
           RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcpst).
           IF RETURN-VALUE = "adm-error" THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p ("show",47,"ICMS ST Fundo Combate a Pobreza").
                apply 'entry':U to c-cod-cta-fcpst in frame {&FRAME-NAME}.
                return 'adm-error'.
           END.
           IF c-cod-cc-fcpst:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
               RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fcpst).
               IF RETURN-VALUE = "adm-error" THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p ("show",47,"CC Desp ICMS ST Fundo Combate a Pobreza").
                    apply 'entry':U to c-cod-cc-fcpst in frame {&FRAME-NAME}.
                    return 'adm-error'.
               END.
               RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-fcpst, INPUT FRAME {&FRAME-NAME} c-cod-cc-fcpst).
               IF RETURN-VALUE = "adm-error" THEN DO:
                   APPLY 'entry':U TO c-cod-cc-fcpst IN FRAME {&FRAME-NAME}.
                   RETURN 'adm-error'.
               END.
           END.
        END.
        
        IF NOT c-cod-cta-fet:HIDDEN IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN l-valida = NO.
            RUN pi-valida-conta (INPUT FRAME {&FRAME-NAME} c-cod-cta-fet).
            IF c-cod-cc-fet:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
                RUN pi-valida-centro (INPUT FRAME {&FRAME-NAME} c-cod-cc-fet).
                IF RETURN-VALUE = "adm-error" THEN DO:
                     {include/i-vldprg.i}
                     run utp/ut-msgs.p ("show",47,"CC Fundo Estadual de Transporte").
                     apply 'entry':U to c-cod-cc-fet in frame {&FRAME-NAME}.
                     return 'adm-error'.
                END.
                RUN pi-valida-ContaCentro (INPUT FRAME {&FRAME-NAME} c-cod-cta-fet, INPUT FRAME {&FRAME-NAME} c-cod-cc-fet).
                IF RETURN-VALUE = "adm-error" THEN DO:
                    APPLY 'entry':U TO c-cod-cc-fet IN FRAME {&FRAME-NAME}.
                    RETURN 'adm-error'.
                END.
            END.
        END.
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
    RUN pi-trata-state (p-issuer-hdl, p-state).

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
    
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccust.
   
    RUN pi-formato-cta-ccust.

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

    RUN pi_retorna_formato_cta_ctbl in h_api_cta (INPUT c-cod-empresa,       /* EMPRESA EMS2 */
                                                  INPUT  "",                 /* PLANO CONTAS */
                                                  INPUT  TODAY,              /* DATA DE TRANSACAO */
                                                  OUTPUT v_cod_format_cta,   /* FORMATO cta */
                                                  OUTPUT TABLE tt_log_erro). /* ERROS */

    IF NOT CAN-FIND(tt_log_erro)
    OR RETURN-VALUE = "OK" THEN 
        ASSIGN v_cod_format_fim = v_cod_format_cta.
    
    RUN limpaErros.
    RUN pi_retorna_formato_ccusto in h_api_ccust (INPUT  c-cod-empresa,          /* EMPRESA EMS2 */
                                                  INPUT  "",                     /* PLANO CCUSTO */
                                                  INPUT  TODAY,                  /* DATA DE TRANSACAO */
                                                  OUTPUT v_cod_format_ccust,     /* FORMATO CCUSTO */
                                                  OUTPUT TABLE tt_log_erro).     /* ERROS */

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
                                                 OUTPUT       v_num_sit_cta,           /* SITUA°€O DA CONTA */
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
       IF l-valida THEN
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

    RUN pi_valida_conta_contabil IN h_api_cta (INPUT  c-cod-empresa,         /* EMPRESA EMS2 */
                                               INPUT  c-cod-estabel,         /* ESTABELECIMENTO EMS2 */
                                               INPUT  "",                    /* UNIDADE NEGàCIO */
                                               INPUT  "",                    /* PLANO CONTAS */ 
                                               INPUT  p-conta,               /* CONTA */
                                               INPUT  "",                    /* PLANO CCUSTO */ 
                                               INPUT  p-centro,              /* CCUSTO */
                                               INPUT  TODAY,                 /* DATA TRANSACAO */
                                               OUTPUT TABLE tt_log_erro).    /* ERROS */

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
