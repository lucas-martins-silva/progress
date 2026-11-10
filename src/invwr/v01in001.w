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
{include/i-prgvrs.i V01IN001 2.00.00.027 } /*** "010027" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in001 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def new global shared var g-empresa-aed LIKE empresa.ep-codigo no-undo.

def buffer b-mla-tipo-doc-aprov for mla-tipo-doc-aprov.

def buffer b-estabelec for estabelec.

def var c-log-reg           as char no-undo.
def var c-msg               as char no-undo.
def var c-chave-doc         as char no-undo.
def var c-cod-estabel       as char no-undo.
DEF VAR c-lb-sim            AS CHAR NO-UNDO.
DEF VAR c-lb-nao            AS CHAR NO-UNDO.
def var c-horas-default     as CHAR INIT "000:00" no-undo.
DEF VAR c-hra-execucao      AS CHAR NO-UNDO.
DEF VAR c-horas             AS CHAR NO-UNDO.
DEF VAR c-minutos           AS CHAR NO-UNDO.
DEF VAR h-boin784           AS HANDLE NO-UNDO.
DEF VAR l-doc-integra-fluig AS LOG NO-UNDO. /*Indica se o documento est† tratado para integrar com o fluig*/
DEF VAR l-doc-utiliz-prior  AS LOG NO-UNDO. /*Indica se o documento utiliza prioridade */
DEF VAR l-prior-habilitada  AS LOG NO-UNDO. /*Indica se a prioridade est† habilitada nos parametros do mla(mla-param-aprov.log-priorid-aprova-docto)*/
DEF VAR l-estab-integra-fluig AS LOG NO-UNDO. /*Indica se o estabelecimento do documento est† parametrizado para integrar com o fluig*/

{utp/ut-liter.i "Sim" *}
ASSIGN c-lb-sim = RETURN-VALUE.

{utp/ut-liter.i "N∆o" *}
ASSIGN c-lb-nao = RETURN-VALUE.
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
&Scoped-define EXTERNAL-TABLES mla-tipo-doc-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-tipo-doc-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-tipo-doc-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-tipo-doc-aprov.des-tip-doc ~
mla-tipo-doc-aprov.log-integr-fluig mla-tipo-doc-aprov.apr-tip-doc ~
mla-tipo-doc-aprov.log-1 mla-tipo-doc-aprov.cod-proces ~
mla-tipo-doc-aprov.verba-aprov mla-tipo-doc-aprov.log-2 ~
mla-tipo-doc-aprov.log-praz-conclus mla-tipo-doc-aprov.log-html ~
mla-tipo-doc-aprov.log-4 mla-tipo-doc-aprov.hra-execucao ~
mla-tipo-doc-aprov.prioridade-aprov ~
mla-tipo-doc-aprov.hra-exec-priorid-baixa ~
mla-tipo-doc-aprov.hra-exec-priorid-media ~
mla-tipo-doc-aprov.hra-exec-priorid-alta ~
mla-tipo-doc-aprov.hra-exec-priorid-altssmo mla-tipo-doc-aprov.prog-aprova ~
mla-tipo-doc-aprov.prog-rejeita 
&Scoped-define ENABLED-TABLES mla-tipo-doc-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-tipo-doc-aprov
&Scoped-Define ENABLED-OBJECTS RECT-15 RECT-2 RECT-3 RECT-4 RECT-16 RECT-17 ~
RECT-5 rs-idi-tip-val-pendcia tg-gera-pend txtPriorid 
&Scoped-Define DISPLAYED-FIELDS mla-tipo-doc-aprov.cod-tip-doc ~
mla-tipo-doc-aprov.des-tip-doc mla-tipo-doc-aprov.log-integr-fluig ~
mla-tipo-doc-aprov.apr-tip-doc mla-tipo-doc-aprov.log-1 ~
mla-tipo-doc-aprov.cod-proces mla-tipo-doc-aprov.verba-aprov ~
mla-tipo-doc-aprov.log-2 mla-tipo-doc-aprov.log-praz-conclus ~
mla-tipo-doc-aprov.log-html mla-tipo-doc-aprov.log-4 ~
mla-tipo-doc-aprov.hra-execucao mla-tipo-doc-aprov.prioridade-aprov ~
mla-tipo-doc-aprov.hra-exec-priorid-baixa ~
mla-tipo-doc-aprov.hra-exec-priorid-media ~
mla-tipo-doc-aprov.hra-exec-priorid-alta ~
mla-tipo-doc-aprov.hra-exec-priorid-altssmo mla-tipo-doc-aprov.prog-aprova ~
mla-tipo-doc-aprov.prog-rejeita 
&Scoped-define DISPLAYED-TABLES mla-tipo-doc-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-tipo-doc-aprov
&Scoped-Define DISPLAYED-OBJECTS rs-idi-tip-val-pendcia tb-aprovacao ~
tb-apr-usu-transacao tb-rejeicao tb-rej-usu-transacao tb-apr-usu-documento ~
tb-rej-usu-documento tb-apr-aprovadores tb-rej-aprovadores tb-apr-Informado ~
tb-rej-Informado tg-gera-pend 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-tipo-doc-aprov.cod-tip-doc 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataHora V-table-Win 
FUNCTION fnFormataHora RETURNS CHARACTER
  (c-valor AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE txtPriorid AS CHARACTER FORMAT "X(256)":U INITIAL "Por Prioridade:" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.
DEFINE VARIABLE rs-idi-tip-val-pendcia AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Total", 1,
"Saldo", 2
     SIZE 9 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 4.46.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.72 BY 2.38.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.72 BY 8.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.38.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 4.13.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.38.
DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.43 BY 4.13.

DEFINE VARIABLE tb-apr-aprovadores AS LOGICAL INITIAL no 
     LABEL "Aprovadores" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tb-apr-Informado AS LOGICAL INITIAL no 
     LABEL "Informado" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tb-apr-usu-documento AS LOGICAL INITIAL no 
     LABEL "Usu†rio Documento" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tb-apr-usu-transacao AS LOGICAL INITIAL no 
     LABEL "Usu†rio Transaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tb-aprovacao AS LOGICAL INITIAL no 
     LABEL "Aprovaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.14 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rej-aprovadores AS LOGICAL INITIAL no 
     LABEL "Aprovadores" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rej-Informado AS LOGICAL INITIAL no 
     LABEL "Informado" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rej-usu-documento AS LOGICAL INITIAL no 
     LABEL "Usu†rio Documento" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rej-usu-transacao AS LOGICAL INITIAL no 
     LABEL "Usu†rio Transaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rejeicao AS LOGICAL INITIAL no 
     LABEL "Rejeiá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 9.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-gera-pend AS LOGICAL INITIAL no 
     LABEL "Sempre Gera Pendància" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-tipo-doc-aprov.cod-tip-doc AT ROW 1.25 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     mla-tipo-doc-aprov.des-tip-doc AT ROW 2.25 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     mla-tipo-doc-aprov.log-integr-fluig AT ROW 3.38 COL 67.57
          LABEL "Integraá∆o Fluig"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     mla-tipo-doc-aprov.apr-tip-doc AT ROW 3.96 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 13.29 BY .83
     mla-tipo-doc-aprov.log-1 AT ROW 3.96 COL 23.14
          LABEL "Visualiza Narrativas"
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     rs-idi-tip-val-pendcia AT ROW 4.25 COL 52.86 NO-LABEL WIDGET-ID 2
     mla-tipo-doc-aprov.cod-proces AT ROW 4.38 COL 89 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     mla-tipo-doc-aprov.verba-aprov AT ROW 4.83 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .83
     mla-tipo-doc-aprov.log-2 AT ROW 4.83 COL 23.14
          LABEL "Re-an†lise das Pendàncias"
          VIEW-AS TOGGLE-BOX
          SIZE 27.14 BY .83
     mla-tipo-doc-aprov.log-praz-conclus AT ROW 5.38 COL 67.57
          VIEW-AS TOGGLE-BOX
          SIZE 19.43 BY .83
     mla-tipo-doc-aprov.log-html AT ROW 5.71 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 15.43 BY .83
     mla-tipo-doc-aprov.log-4 AT ROW 5.71 COL 23.14
          LABEL "E-mail HTML Palm"
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY 1
     mla-tipo-doc-aprov.hra-execucao AT ROW 6.38 COL 67.57 NO-LABEL FORMAT "999:99"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     mla-tipo-doc-aprov.prioridade-aprov AT ROW 6.79 COL 10.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Documento", 1,
"Item", 2,
"Referància", 3
          SIZE 34.14 BY .83
     mla-tipo-doc-aprov.hra-exec-priorid-baixa AT ROW 8.38 COL 89 RIGHT-ALIGNED FORMAT "999:99"
          LABEL "Baixa"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tb-aprovacao AT ROW 8.5 COL 2
     tb-apr-usu-transacao AT ROW 8.5 COL 13.57
     tb-rejeicao AT ROW 8.5 COL 32.57
     tb-rej-usu-transacao AT ROW 8.5 COL 43.43
     mla-tipo-doc-aprov.hra-exec-priorid-media AT ROW 9.38 COL 89 RIGHT-ALIGNED FORMAT "999:99"
          LABEL "MÇdia"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tb-apr-usu-documento AT ROW 9.5 COL 13.57
     tb-rej-usu-documento AT ROW 9.5 COL 43.43
     mla-tipo-doc-aprov.hra-exec-priorid-alta AT ROW 10.38 COL 89 RIGHT-ALIGNED FORMAT "999:99"
          LABEL "Alta"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tb-apr-aprovadores AT ROW 10.5 COL 13.57
     tb-rej-aprovadores AT ROW 10.5 COL 43.43
     mla-tipo-doc-aprov.hra-exec-priorid-altssmo AT ROW 11.38 COL 89 RIGHT-ALIGNED FORMAT "999:99"
          LABEL "Muito Alta"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tb-apr-Informado AT ROW 11.5 COL 13.57
     tb-rej-Informado AT ROW 11.5 COL 43.43
     mla-tipo-doc-aprov.prog-aprova AT ROW 13.13 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     tg-gera-pend AT ROW 13.83 COL 67.29
     mla-tipo-doc-aprov.prog-rejeita AT ROW 14.13 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     txtPriorid AT ROW 7.54 COL 67.57 NO-LABEL
     "Prioridade:" VIEW-AS TEXT
          SIZE 8.14 BY .83 AT ROW 6.79 COL 2.43 WIDGET-ID 10
     "Valor Pendància" VIEW-AS TEXT
          SIZE 11.29 BY .67 AT ROW 3.38 COL 52.86
     "hora(s)" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 6.38 COL 82.29
     "Exceá∆o Pendància Aprovaá∆o" VIEW-AS TEXT
          SIZE 22.72 BY .67 AT ROW 12.58 COL 67.29
     "Notificaá∆o" VIEW-AS TEXT
          SIZE 11.72 BY .67 AT ROW 7.75 COL 8.14
     RECT-15 AT ROW 8.04 COL 1
     RECT-2 AT ROW 1 COL 1
     RECT-3 AT ROW 3.63 COL 1
     RECT-4 AT ROW 12.88 COL 1
     RECT-16 AT ROW 12.88 COL 66.29
     RECT-17 AT ROW 3.63 COL 66.29
     RECT-5 AT ROW 3.63 COL 51.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-tipo-doc-aprov
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
         HEIGHT             = 14.29
         WIDTH              = 91.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 14.29
       FRAME f-main:WIDTH            = 91.

/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.cod-proces IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.cod-tip-doc IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.hra-exec-priorid-alta IN FRAME f-main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.hra-exec-priorid-altssmo IN FRAME f-main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.hra-exec-priorid-baixa IN FRAME f-main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.hra-exec-priorid-media IN FRAME f-main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN mla-tipo-doc-aprov.hra-execucao IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX mla-tipo-doc-aprov.log-1 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-tipo-doc-aprov.log-2 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-tipo-doc-aprov.log-4 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-tipo-doc-aprov.log-integr-fluig IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-apr-aprovadores IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-apr-Informado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-apr-usu-documento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-apr-usu-transacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-aprovacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-rej-aprovadores IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-rej-Informado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-rej-usu-documento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-rej-usu-transacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-rejeicao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPriorid IN FRAME f-main
   NO-DISPLAY ALIGN-L                                                   */
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

&Scoped-define SELF-NAME mla-tipo-doc-aprov.cod-tip-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.cod-tip-doc V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.cod-tip-doc IN FRAME f-main /* Documento */
DO:

  ENABLE mla-tipo-doc-aprov.log-integr-fluig
         mla-tipo-doc-aprov.log-praz-conclus 
         mla-tipo-doc-aprov.cod-proces WITH FRAME {&FRAME-NAME}.


  ASSIGN mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME f-main = YES
         mla-tipo-doc-aprov.cod-proces:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "WFMLA":U + 
                                                                             FILL("0",3 - LENGTH(trim(mla-tipo-doc-aprov.cod-tip-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}))) +
                                                                             trim(mla-tipo-doc-aprov.cod-tip-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
 
  RUN pi-tipo-valor-pend.
  RUN pi-disable-fluig-fields.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-tipo-doc-aprov.log-integr-fluig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.log-integr-fluig V-table-Win
ON VALUE-CHANGED OF mla-tipo-doc-aprov.log-integr-fluig IN FRAME f-main /* Integraá∆o Fluig */
DO:
  IF mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME {&FRAME-NAME} THEN
      ENABLE mla-tipo-doc-aprov.log-praz-conclus 
              mla-tipo-doc-aprov.cod-proces WITH FRAME {&FRAME-NAME}.
  ELSE DO:
      DISABLE mla-tipo-doc-aprov.hra-execucao
              mla-tipo-doc-aprov.log-praz-conclus
              mla-tipo-doc-aprov.hra-exec-priorid-baixa
              mla-tipo-doc-aprov.hra-exec-priorid-media 
              mla-tipo-doc-aprov.hra-exec-priorid-alta
              mla-tipo-doc-aprov.hra-exec-priorid-altssmo
              mla-tipo-doc-aprov.cod-proces
          WITH FRAME {&FRAME-NAME}.
      
      ASSIGN mla-tipo-doc-aprov.log-praz-conclus:CHECKED  IN FRAME {&FRAME-NAME} = NO.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-tipo-doc-aprov.log-praz-conclus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.log-praz-conclus V-table-Win
ON VALUE-CHANGED OF mla-tipo-doc-aprov.log-praz-conclus IN FRAME f-main /* Prazo Conclus∆o */
DO:
  IF mla-tipo-doc-aprov.log-praz-conclus:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
      ENABLE mla-tipo-doc-aprov.hra-execucao WITH FRAME {&FRAME-NAME}.
      IF l-doc-utiliz-prior AND l-prior-habilitada THEN
          ENABLE mla-tipo-doc-aprov.hra-exec-priorid-baixa
                 mla-tipo-doc-aprov.hra-exec-priorid-media 
                 mla-tipo-doc-aprov.hra-exec-priorid-alta
                 mla-tipo-doc-aprov.hra-exec-priorid-altssmo
              WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      DISABLE mla-tipo-doc-aprov.hra-execucao
              mla-tipo-doc-aprov.hra-exec-priorid-baixa
              mla-tipo-doc-aprov.hra-exec-priorid-media 
              mla-tipo-doc-aprov.hra-exec-priorid-alta
              mla-tipo-doc-aprov.hra-exec-priorid-altssmo
          WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

  &Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-execucao V-table-Win
ON LEAVE OF rs-idi-tip-val-pendcia IN FRAME f-main /*  */
DO:

    ASSIGN rs-idi-tip-val-pendcia = INPUT FRAME {&FRAME-NAME} rs-idi-tip-val-pendcia.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-execucao V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.hra-execucao IN FRAME f-main /* Hora de conclus∆o */
DO:

    ASSIGN c-hra-execucao = mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main
           mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-exec-priorid-baixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-exec-priorid-baixa V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.hra-exec-priorid-baixa IN FRAME f-main /* Hora conclus∆o prioridade baixa */
DO:

    ASSIGN c-hra-execucao = mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main
           mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-exec-priorid-media
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-exec-priorid-media V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.hra-exec-priorid-media IN FRAME f-main /* Hora conclus∆o prioridade mÇdia */
DO:

    ASSIGN c-hra-execucao = mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main
           mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-exec-priorid-alta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-exec-priorid-alta V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.hra-exec-priorid-alta IN FRAME f-main /*  Hora conclus∆o prioridade Alta */
DO:

    ASSIGN c-hra-execucao = mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main
           mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-tipo-doc-aprov.hra-exec-priorid-altssmo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-doc-aprov.hra-exec-priorid-altssmo V-table-Win
ON LEAVE OF mla-tipo-doc-aprov.hra-exec-priorid-altssmo IN FRAME f-main /*  Hora conclus∆o prioridade muito alta */
DO:

    ASSIGN c-hra-execucao = mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main
           mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tb-aprovacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-aprovacao V-table-Win
ON VALUE-CHANGED OF tb-aprovacao IN FRAME f-main /* Aprovaá∆o */
DO:
  IF tb-aprovacao:CHECKED THEN DO:
      ASSIGN tb-apr-usu-transacao:SENSITIVE = TRUE.
      ASSIGN tb-apr-usu-documento:SENSITIVE = TRUE.
      ASSIGN tb-apr-aprovadores  :SENSITIVE = TRUE.
      ASSIGN tb-apr-informado    :SENSITIVE = TRUE.
  END.
  ELSE DO:
      ASSIGN tb-apr-usu-transacao:SENSITIVE = FALSE.
      ASSIGN tb-apr-usu-documento:SENSITIVE = FALSE.
      ASSIGN tb-apr-aprovadores  :SENSITIVE = FALSE.
      ASSIGN tb-apr-informado    :SENSITIVE = FALSE.

      ASSIGN tb-apr-usu-transacao:CHECKED = FALSE.
      ASSIGN tb-apr-usu-documento:CHECKED = FALSE.
      ASSIGN tb-apr-aprovadores  :CHECKED = FALSE.
      ASSIGN tb-apr-informado    :CHECKED = FALSE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-rejeicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-rejeicao V-table-Win
ON VALUE-CHANGED OF tb-rejeicao IN FRAME f-main /* Rejeiá∆o */
DO:
  IF tb-rejeicao:CHECKED THEN DO:
      ASSIGN tb-rej-usu-transacao:SENSITIVE = TRUE.
      ASSIGN tb-rej-usu-documento:SENSITIVE = TRUE.
      ASSIGN tb-rej-aprovadores  :SENSITIVE = TRUE.
      ASSIGN tb-rej-informado    :SENSITIVE = TRUE.
  END.
  ELSE DO:
      ASSIGN tb-rej-usu-transacao:SENSITIVE = FALSE.
      ASSIGN tb-rej-usu-documento:SENSITIVE = FALSE.
      ASSIGN tb-rej-aprovadores  :SENSITIVE = FALSE.
      ASSIGN tb-rej-informado    :SENSITIVE = FALSE.
      ASSIGN tb-rej-usu-transacao:CHECKED = FALSE.
      ASSIGN tb-rej-usu-documento:CHECKED = FALSE.
      ASSIGN tb-rej-aprovadores  :CHECKED = FALSE.
      ASSIGN tb-rej-informado    :CHECKED = FALSE.
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
  {src/adm/template/row-list.i "mla-tipo-doc-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-tipo-doc-aprov"}

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
  
  RUN pi-seta-padrao-horas(INPUT YES).

  run pi-cria-novo-documento.

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
    APPLY "leave":U TO mla-tipo-doc-aprov.hra-execucao in frame {&frame-name}.
    APPLY "leave":U TO mla-tipo-doc-aprov.hra-exec-priorid-baixa in frame {&frame-name}.
    APPLY "leave":U TO mla-tipo-doc-aprov.hra-exec-priorid-media in frame {&frame-name}.
    APPLY "leave":U TO mla-tipo-doc-aprov.hra-exec-priorid-alta in frame {&frame-name}.
    APPLY "leave":U TO mla-tipo-doc-aprov.hra-exec-priorid-altssmo in frame {&frame-name}.

    /* Code placed here will execute PRIOR to standard behavior. */
    /*{include/i-valid.i}*/
    
    run pi-validate.
    if  return-value = "ADM-ERROR":U then
        undo, return "ADM-ERROR":U.
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    if not adm-new-record then
        run pi-log-reg.
    
    if adm-new-record then do:
        find b-mla-tipo-doc-aprov where
            b-mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
            b-mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
            b-mla-tipo-doc-aprov.cod-tip-doc = input frame {&frame-name} mla-tipo-doc-aprov.cod-tip-doc
            no-lock no-error.
        if  avail b-mla-tipo-doc-aprov then do:
            {utp/ut-table.i mgind mla-tipo-doc-aprov 1}
            run utp/ut-msgs.p ("show",1,trim(return-value)).
            apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    find estabelec where
        rowid(estabelec) = v-row-parent
        no-lock no-error.

    assign mla-tipo-doc-aprov.ep-codigo = g-empresa-aed.

    IF NOT adm-new-record THEN DO:
        RUN pi-salva-campo.
    END.

    IF tg-gera-pend:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN mla-tipo-doc-aprov.log-excec-val = YES.
    ELSE
        ASSIGN mla-tipo-doc-aprov.log-excec-val = NO.

    ASSIGN mla-tipo-doc-aprov.idi-tip-val-pendcia = INPUT FRAME {&FRAME-NAME} rs-idi-tip-val-pendcia.

    if adm-new-record then do:
    
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-tipo-doc-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-tipo-doc-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 22
               mla-log-reg.chave-reg   = string(mla-tipo-doc-aprov.cod-tip-doc)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
               mla-log-reg.log-reg     = entry(22,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "C¢digo                   : " + string(mla-tipo-doc-aprov.cod-tip-doc)        + chr(13) + 
                                         "Descriá∆o                : " + string(mla-tipo-doc-aprov.des-tip-doc)        + chr(13) + 
                                         "Log Aprovaá∆o            : " + string(mla-tipo-doc-aprov.apr-tip-doc)        + chr(13) +                                      
                                         "Prioridade Aprov         : " + string(mla-tipo-doc-aprov.prioridade-aprov)   + chr(13) +                                      
                                         "Verba                    : " + string(mla-tipo-doc-aprov.verba-aprov)        + chr(13) +                                                                           
                                         "Log HTML                 : " + string(mla-tipo-doc-aprov.log-html)           + chr(13) +                                                                          
                                         "Log HTML Palm            : " + string(mla-tipo-doc-aprov.log-4)              + chr(13) +                                                                          
                                         "Visualiza Narrativa      : " + string(mla-tipo-doc-aprov.log-1)              + chr(13) +
                                         "Re-an†lise das Pendàncias: " + string(mla-tipo-doc-aprov.log-2)              + chr(13) +
                                         "Not(Aprovaá∆o)           : " + SUBSTRING(mla-tipo-doc-aprov.char-1,1,1)      + chr(13) +
                                         "Not Apr(Usu†rio Transaá∆o): " + SUBSTRING(mla-tipo-doc-aprov.char-1,3,1)     + chr(13) +
                                         "Not Apr(Usu†rio Documento): " + SUBSTRING(mla-tipo-doc-aprov.char-1,4,1)     + chr(13) +
                                         "Not Apr(Aprovadores)     : " + SUBSTRING(mla-tipo-doc-aprov.char-1,5,1)      + chr(13) +
                                         "Not Apr(Informado)       : " + SUBSTRING(mla-tipo-doc-aprov.char-1,6,1)      + chr(13) +
                                         "Not(Rejeiá∆o)            : " + SUBSTRING(mla-tipo-doc-aprov.char-1,2,1)      + chr(13) +
                                         "Not Rej(Usu†rio Transaá∆o): " + SUBSTRING(mla-tipo-doc-aprov.char-1,7,1)     + chr(13) +
                                         "Not Rej(Usu†rio Documento): " + SUBSTRING(mla-tipo-doc-aprov.char-1,8,1)     + chr(13) +
                                         "Not Rej(Aprovadores)     : " + SUBSTRING(mla-tipo-doc-aprov.char-1,9,1)      + chr(13) +
                                         "Not Rej(Informado)       : " + SUBSTRING(mla-tipo-doc-aprov.char-1,10,1)     + chr(13) +
                                         "Prog Aprovaá∆o           : " + string(mla-tipo-doc-aprov.prog-aprova)        + chr(13) +                                                                           
                                         "Prog Rejeiá∆o            : " + string(mla-tipo-doc-aprov.prog-rejeita)       + chr(13) +                                                                           
                                         "Prog Consulta            : " + string(mla-tipo-doc-aprov.prog-consulta) + chr(13).  

        {utp/ut-field.i mgind mla-tipo-doc-aprov idi-tip-val-pendcia 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.idi-tip-val-pendcia) + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov log-integr-fluig 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov cod-proces 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + string(mla-tipo-doc-aprov.cod-proces) + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov log-praz-conclus 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov hra-execucao 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-execucao,"999:99") + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-baixa 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-baixa,"999:99") + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-media 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-media,"999:99") + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-alta 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-alta,"999:99") + chr(13).
        {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-altssmo 1}
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-altssmo,"999:99") + chr(13).



        /* for each mguni.empresa no-lock: */
            /* for each b-estabelec no-lock: */
                find first b-mla-tipo-doc-aprov 
                     where b-mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed 
                       and b-mla-tipo-doc-aprov.cod-estabel = c-cod-estabel 
                       and b-mla-tipo-doc-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc no-lock no-error.
                if not available b-mla-tipo-doc-aprov then do:
                    create b-mla-tipo-doc-aprov.
                    buffer-copy mla-tipo-doc-aprov except ep-codigo cod-estabel cod-tip-doc to b-mla-tipo-doc-aprov.
                    assign b-mla-tipo-doc-aprov.ep-codigo   = mguni.empresa.ep-codigo
                           b-mla-tipo-doc-aprov.cod-estabel = b-estabelec.cod-estabel
                           b-mla-tipo-doc-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc.               
                           
                    create mla-log-reg.
                    assign mla-log-reg.ep-codigo   = mguni.empresa.ep-codigo /*b-mla-tipo-doc-aprov.ep-codigo*/
                           mla-log-reg.cod-estabel = b-estabelec.cod-estabel /*b-mla-tipo-doc-aprov.cod-estabel*/
                           mla-log-reg.cod-usuar   = c-seg-usuario
                           mla-log-reg.cod-tabela  = 22
                           mla-log-reg.chave-reg   = string(b-mla-tipo-doc-aprov.cod-tip-doc)
                           mla-log-reg.data-reg    = today
                           mla-log-reg.hora-reg    = string(time,"hh:mm")
                           mla-log-reg.tipo-reg    = 1
                           mla-log-reg.log-reg     = entry(22,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                     "C¢digo             : " + string(b-mla-tipo-doc-aprov.cod-tip-doc)              + chr(13) + 
                                                     "Descriá∆o          : " + string(b-mla-tipo-doc-aprov.des-tip-doc)              + chr(13) + 
                                                     "Log Aprovaá∆o      : " + string(b-mla-tipo-doc-aprov.apr-tip-doc)              + chr(13) +                                      
                                                     "Prioridade Aprov   : " + string(b-mla-tipo-doc-aprov.prioridade-aprov)         + chr(13) +                                      
                                                     "Verba              : " + string(b-mla-tipo-doc-aprov.verba-aprov)              + chr(13) +                                                                           
                                                     "Log HTML           : " + string(b-mla-tipo-doc-aprov.log-html)                 + chr(13) +                                                                           
                                                     "Log HTML Palm      : " + string(b-mla-tipo-doc-aprov.log-4)                    + chr(13) +                                                                           
                                                     "Visualiza Narrativa      : " + string(b-mla-tipo-doc-aprov.log-1)              + chr(13) +
                                                     "Re-an†lise das Pendàncias: " + string(b-mla-tipo-doc-aprov.log-2)              + chr(13) +
                                                     "Not(Aprovaá∆o)           : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,1,1)      + chr(13) +
                                                     "Not Apr(Usu†rio Transaá∆o): " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,3,1)     + chr(13) +
                                                     "Not Apr(Usu†rio Documento): " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,4,1)     + chr(13) +
                                                     "Not Apr(Aprovadores)     : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,5,1)      + chr(13) +
                                                     "Not Apr(Informado)       : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,6,1)      + chr(13) +
                                                     "Not(Rejeiá∆o)            : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,2,1)      + chr(13) +
                                                     "Not Rej(Usu†rio Transaá∆o): " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,7,1)     + chr(13) +
                                                     "Not Rej(Usu†rio Documento): " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,8,1)     + chr(13) +
                                                     "Not Rej(Aprovadores)     : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,9,1)      + chr(13) +
                                                     "Not Rej(Informado)       : " + SUBSTRING(b-mla-tipo-doc-aprov.char-1,10,1)     + chr(13) +
                                                     "Prog Aprovaá∆o     : " + string(b-mla-tipo-doc-aprov.prog-aprova)              + chr(13) +                                                                           
                                                     "Prog Rejeiá∆o      : " + string(b-mla-tipo-doc-aprov.prog-rejeita)             + chr(13) +                                                                           
                                                     "Prog Consulta      : " + string(b-mla-tipo-doc-aprov.prog-consulta)            + chr(13).   
                    {utp/ut-field.i mgind mla-tipo-doc-aprov idi-tip-val-pendcia 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.idi-tip-val-pendcia) + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov log-integr-fluig 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF b-mla-tipo-doc-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov cod-proces 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + string(b-mla-tipo-doc-aprov.cod-proces) + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov log-praz-conclus 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF b-mla-tipo-doc-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-execucao 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.hra-execucao,"999:99") + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-baixa 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.hra-exec-priorid-baixa,"999:99") + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-media 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.hra-exec-priorid-media,"999:99") + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-alta 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.hra-exec-priorid-alta,"999:99") + chr(13).
                    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-altssmo 1}
                    ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(b-mla-tipo-doc-aprov.hra-exec-priorid-altssmo,"999:99") + chr(13).
                end.                           
            /* end. */
        /* end. */
    end.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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

    find estabelec where
        rowid(estabelec) = v-row-parent
        no-lock no-error.

    assign mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed
           mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel.        

    RUN pi-salva-campo.

    /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

  /* Code placed here will execute PRIOR to standard behavior. */
    IF VALID-HANDLE(h-boin784) THEN DO:
        DELETE PROCEDURE h-boin784.
        ASSIGN h-boin784 = ?.
    END.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
   
    /* Dispatch standard ADM method.                            */
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

    IF AVAIL mla-tipo-doc-aprov THEN DO:
        FOR FIRST mla-param-aprov
            WHERE mla-param-aprov.ep-codigo   = mla-tipo-doc-aprov.ep-codigo  
              AND mla-param-aprov.cod-estabel = mla-tipo-doc-aprov.cod-estabel NO-LOCK:
        END.
        IF AVAIL mla-param-aprov
        AND mla-param-aprov.log-cond-pagto THEN
            ASSIGN tg-gera-pend:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN tg-gera-pend:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

        IF mla-tipo-doc-aprov.log-excec-val THEN
            ASSIGN tg-gera-pend:CHECKED IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN tg-gera-pend:CHECKED IN FRAME {&FRAME-NAME}  = NO.

        IF mla-tipo-doc-aprov.idi-tip-val-pendcia <> 0 THEN
           ASSIGN rs-idi-tip-val-pendcia = mla-tipo-doc-aprov.idi-tip-val-pendcia.

        IF mla-tipo-doc-aprov.cod-tip-doc = 6  OR   /* Pedido de compra - item */
           mla-tipo-doc-aprov.cod-tip-doc = 7  OR   /* Pedido de compra - total */  
           mla-tipo-doc-aprov.cod-tip-doc = 8  OR   /* Pedido emergencial - total */
           mla-tipo-doc-aprov.cod-tip-doc = 19 OR   /* Pedido emergencial - item */
           mla-tipo-doc-aprov.cod-tip-doc = 13 OR   /* Documento contrato */          
           mla-tipo-doc-aprov.cod-tip-doc = 14 THEN /* Mediá∆o - item */                           
              ENABLE rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.
           ELSE
              DISABLE rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.
        DISPLAY rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.

        IF ((mla-tipo-doc-aprov.cod-tip-doc = 2)  /* Solicitaá∆o de compra - total */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 4)  /* Requisiá∆o de estoque - total */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 7)  /* Pedido de compra */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 8)  /* Pedido emergencial */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 10) /* Processo de compra - total */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 13) /* Documento contrato */
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 17) /* Evento total */ 
        OR  (mla-tipo-doc-aprov.cod-tip-doc = 21)) then
        IF mla-tipo-doc-aprov.prioridade-aprov:disable(entry(3, prioridade-aprov:radio-buttons)) in frame {&frame-name} then.

        IF mla-tipo-doc-aprov.cod-tip-doc = 21 THEN
            IF mla-tipo-doc-aprov.prioridade-aprov:disable(entry(5, prioridade-aprov:radio-buttons)) in frame {&frame-name} then.


        IF SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y" THEN
            ASSIGN tb-aprovacao:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-aprovacao:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y" THEN
            ASSIGN tb-rejeicao:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-rejeicao:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,3,1) = "Y" THEN
            ASSIGN tb-apr-usu-transacao:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-apr-usu-transacao:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,4,1) = "Y" THEN
            ASSIGN tb-apr-usu-documento:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-apr-usu-documento:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "Y" THEN
            ASSIGN tb-apr-aprovadores:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-apr-aprovadores:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,6,1) = "Y" THEN
            ASSIGN tb-apr-informado:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-apr-informado:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,7,1) = "Y" THEN
            ASSIGN tb-rej-usu-transacao:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-rej-usu-transacao:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,8,1) = "Y" THEN
            ASSIGN tb-rej-usu-documento:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-rej-usu-documento:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,9,1) = "Y" THEN
            ASSIGN tb-rej-aprovadores:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-rej-aprovadores:CHECKED IN FRAME f-main = NO.

        IF SUBSTRING(mla-tipo-doc-aprov.char-1,10,1) = "Y" THEN
            ASSIGN tb-rej-informado:CHECKED IN FRAME f-main = YES.
        ELSE
            ASSIGN tb-rej-informado:CHECKED IN FRAME f-main = NO.

        RUN pi-verifica-integra-fluig.
       
        ASSIGN mla-tipo-doc-aprov.hra-exec-priorid-baixa:VISIBLE IN FRAME {&FRAME-NAME}   = l-doc-utiliz-prior
               mla-tipo-doc-aprov.hra-exec-priorid-media:VISIBLE IN FRAME {&FRAME-NAME}   = l-doc-utiliz-prior
               mla-tipo-doc-aprov.hra-exec-priorid-alta:VISIBLE IN FRAME {&FRAME-NAME}    = l-doc-utiliz-prior
               mla-tipo-doc-aprov.hra-exec-priorid-altssmo:VISIBLE IN FRAME {&FRAME-NAME} = l-doc-utiliz-prior
               txtPriorid:VISIBLE IN FRAME {&FRAME-NAME} = l-doc-utiliz-prior.

        IF l-doc-utiliz-prior THEN
            DISPLAY mla-tipo-doc-aprov.hra-exec-priorid-baixa  
                    mla-tipo-doc-aprov.hra-exec-priorid-media  
                    mla-tipo-doc-aprov.hra-exec-priorid-alta   
                    mla-tipo-doc-aprov.hra-exec-priorid-altssmo WITH FRAME {&FRAME-NAME}.

        RUN pi-seta-padrao-horas(INPUT YES).
    END.

    RETURN "OK":U.
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
    &if DEFINED(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    ENABLE tb-aprovacao 
           tb-rejeicao
           tb-apr-usu-transacao
           tb-apr-usu-documento
           tb-apr-aprovadores
           tb-apr-informado
           tb-rej-usu-transacao
           tb-rej-usu-documento
           tb-rej-aprovadores
           tb-rej-informado WITH FRAME f-main.

    run pi-cria-novo-documento.
            
    RUN pi-disable-fluig-fields.
    
  
    APPLY "VALUE-CHANGED" TO tb-aprovacao IN FRAME f-main.
    APPLY "VALUE-CHANGED" TO tb-rejeicao  IN FRAME f-main.  

	END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-fluig-fields V-table-Win 
PROCEDURE pi-disable-fluig-fields :
/*------------------------------------------------------------------------------
  Purpose:     Habilita/Desabilita campos da integraá∆o com o fluig
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-verifica-integra-fluig.
    
    IF l-doc-integra-fluig AND l-estab-integra-fluig THEN DO:

        IF NOT mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME f-main THEN
            DISABLE  mla-tipo-doc-aprov.cod-proces
                     mla-tipo-doc-aprov.log-praz-conclus WITH FRAME f-main.
    
        IF NOT mla-tipo-doc-aprov.log-praz-conclus:CHECKED IN FRAME f-main THEN
            DISABLE mla-tipo-doc-aprov.hra-execucao
                    mla-tipo-doc-aprov.hra-exec-priorid-baixa
                    mla-tipo-doc-aprov.hra-exec-priorid-media
                    mla-tipo-doc-aprov.hra-exec-priorid-alta
                    mla-tipo-doc-aprov.hra-exec-priorid-altssmo WITH FRAME f-main.
        ELSE DO:
           IF l-doc-utiliz-prior AND NOT l-prior-habilitada THEN
                DISABLE mla-tipo-doc-aprov.hra-exec-priorid-baixa
                        mla-tipo-doc-aprov.hra-exec-priorid-media
                        mla-tipo-doc-aprov.hra-exec-priorid-alta
                        mla-tipo-doc-aprov.hra-exec-priorid-altssmo WITH FRAME f-main.
        END.
    END.
    ELSE DO:
        DISABLE mla-tipo-doc-aprov.log-integr-fluig
                mla-tipo-doc-aprov.cod-proces
                mla-tipo-doc-aprov.log-praz-conclus
                mla-tipo-doc-aprov.hra-execucao
                mla-tipo-doc-aprov.hra-exec-priorid-baixa
                mla-tipo-doc-aprov.hra-exec-priorid-media
                mla-tipo-doc-aprov.hra-exec-priorid-alta
                mla-tipo-doc-aprov.hra-exec-priorid-altssmo WITH FRAME f-main.
        ASSIGN mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME f-main = NO.
    END.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-fluig-fields V-table-Win 
PROCEDURE pi-tipo-valor-pend :
/*------------------------------------------------------------------------------
  Purpose:     Tratamento Tipo Valor Pendencia
  Notes:       
------------------------------------------------------------------------------*/
 
  IF INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 6  OR   /* Pedido de compra - item */
     INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 7  OR   /* Pedido de compra - total */  
     INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 8  OR   /* Pedido emergencial - total */
     INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 19 THEN DO: /* Pedido emergencial - item */
     ASSIGN rs-idi-tip-val-pendcia = 2. /* Saldo */
     ENABLE rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
     ASSIGN rs-idi-tip-val-pendcia = 1. /* Total */.   
     IF INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 13 OR    /* Documento contrato */          
        INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc = 14 THEN  /* Evento - item */              
        ENABLE rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.
     ELSE
        DISABLE rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.
  END.
  DISPLAY rs-idi-tip-val-pendcia WITH FRAME {&FRAME-NAME}.

   RETURN "OK":U.
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
  /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
    define input parameter wh-browse as handle no-undo.
    
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT wh-browse, INPUT "cod-estabel").

    assign v-row-parent  = v-row-parent-externo
           c-cod-estabel = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-novo-documento V-table-Win 
PROCEDURE pi-cria-novo-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if adm-new-record then do:
        find estabelec where
            rowid(estabelec) = v-row-parent
            no-lock no-error.
        find last b-mla-tipo-doc-aprov where
            b-mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
            b-mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel
            no-lock no-error.
        if not available b-mla-tipo-doc-aprov then
            assign mla-tipo-doc-aprov.cod-tip-doc:screen-value in frame {&frame-name} = "1".
        else do:
            if b-mla-tipo-doc-aprov.cod-tip-doc = 99 then do:
                run utp/ut-msgs.p (input "show",
                                   input 00,
                                   input "").
                return "adm-error".                   
            end.
            assign mla-tipo-doc-aprov.cod-tip-doc:screen-value in frame {&frame-name} = 
                            string(b-mla-tipo-doc-aprov.cod-tip-doc + 1).
        end.
        ASSIGN tb-aprovacao:CHECKED IN FRAME {&FRAME-NAME}         = TRUE
               tb-rejeicao:CHECKED IN FRAME {&FRAME-NAME}          = TRUE
               tb-apr-usu-transacao:CHECKED IN FRAME {&FRAME-NAME} = TRUE
               tb-apr-usu-documento:CHECKED IN FRAME {&FRAME-NAME} = TRUE
               tb-apr-aprovadores:CHECKED IN FRAME {&FRAME-NAME}   = TRUE
               tb-apr-informado:CHECKED IN FRAME {&FRAME-NAME}     = TRUE
               tb-rej-usu-transacao:CHECKED IN FRAME {&FRAME-NAME} = TRUE
               tb-rej-usu-documento:CHECKED IN FRAME {&FRAME-NAME} = TRUE
               tb-rej-aprovadores:CHECKED IN FRAME {&FRAME-NAME}   = TRUE
               tb-rej-informado:CHECKED IN FRAME {&FRAME-NAME}     = TRUE.

        FOR FIRST mla-param-aprov
            WHERE mla-param-aprov.ep-codigo   = g-empresa-aed
              AND mla-param-aprov.cod-estabel = estabelec.cod-estabel NO-LOCK:
        END.
        IF  AVAIL mla-param-aprov
        AND mla-param-aprov.log-cond-pagto THEN
             ASSIGN tg-gera-pend:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
             ASSIGN tg-gera-pend:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

        ASSIGN mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME {&FRAME-NAME} = AVAIL mla-param-aprov AND mla-param-aprov.log-integr-fluig.

        IF AVAIL mla-param-aprov AND 
                 mla-param-aprov.log-integr-fluig AND 
                 mla-tipo-doc-aprov.cod-tip-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND 
                 mla-tipo-doc-aprov.cod-proces:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN
             ASSIGN mla-tipo-doc-aprov.cod-proces:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "WFMLA":U + 
                                                                                       FILL("0",3 - LENGTH(trim(mla-tipo-doc-aprov.cod-tip-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}))) +
                                                                                        trim(mla-tipo-doc-aprov.cod-tip-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".

    if available mla-tipo-doc-aprov then do:
        if mla-tipo-doc-aprov.des-tip-doc <> input frame {&frame-name} mla-tipo-doc-aprov.des-tip-doc then
            assign c-log-reg = c-log-reg + 
                   "Descriá∆o          : " + string(mla-tipo-doc-aprov.des-tip-doc) + chr(13) + 
                   "                   : " + string(input frame {&frame-name} mla-tipo-doc-aprov.des-tip-doc) + chr(13) + chr(13).
        if mla-tipo-doc-aprov.apr-tip-doc <> mla-tipo-doc-aprov.apr-tip-doc:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Log Aprovaá∆o      : " + string(mla-tipo-doc-aprov.apr-tip-doc) + chr(13) +                                      
                   "                   : " + string(mla-tipo-doc-aprov.apr-tip-doc:checked in frame {&frame-name}) + chr(13) + chr(13).                                      
        if mla-tipo-doc-aprov.prioridade-aprov <> input frame {&frame-name} mla-tipo-doc-aprov.prioridade-aprov then
            assign c-log-reg = c-log-reg + 
                   "Prioridade Aprov   : " + string(mla-tipo-doc-aprov.prioridade-aprov) + chr(13) + 
                   "                   : " + string(input frame {&frame-name} mla-tipo-doc-aprov.prioridade-aprov) + chr(13) + chr(13).
        if mla-tipo-doc-aprov.verba-aprov <> mla-tipo-doc-aprov.verba-aprov:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Verba              : " + string(mla-tipo-doc-aprov.verba-aprov) + chr(13) +                                      
                   "                   : " + string(mla-tipo-doc-aprov.verba-aprov:checked in frame {&frame-name}) + chr(13) + chr(13).                                      
        if mla-tipo-doc-aprov.log-html <> mla-tipo-doc-aprov.log-html:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Log HTML           : " + string(mla-tipo-doc-aprov.log-html) + chr(13) +                                      
                   "                   : " + string(mla-tipo-doc-aprov.log-html:checked in frame {&frame-name}) + chr(13) + chr(13).                                      
        if mla-tipo-doc-aprov.log-4 <> mla-tipo-doc-aprov.log-4:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Log HTML Palm      : " + string(mla-tipo-doc-aprov.log-4) + chr(13) +                                      
                   "                   : " + string(mla-tipo-doc-aprov.log-4:checked in frame {&frame-name}) + chr(13) + chr(13).                                      
        if mla-tipo-doc-aprov.prog-aprova <> input frame {&frame-name} mla-tipo-doc-aprov.prog-aprova then
            assign c-log-reg = c-log-reg + 
                   "Prog Aprovaá∆o     : " + string(mla-tipo-doc-aprov.prog-aprova) + chr(13) + 
                   "                   : " + string(input frame {&frame-name} mla-tipo-doc-aprov.prog-aprova) + chr(13) + chr(13).
        if mla-tipo-doc-aprov.prog-rejeita <> input frame {&frame-name} mla-tipo-doc-aprov.prog-rejeita then
            assign c-log-reg = c-log-reg + 
                   "Prog Rejeiá∆o      : " + string(mla-tipo-doc-aprov.prog-rejeita) + chr(13) + 
                   "                   : " + string(input frame {&frame-name} mla-tipo-doc-aprov.prog-rejeita) + chr(13) + chr(13).
        if mla-tipo-doc-aprov.log-1 <> input frame {&frame-name} mla-tipo-doc-aprov.log-1 then
            assign c-log-reg = c-log-reg + 
                   "Visualiza Narrativa: " + string(mla-tipo-doc-aprov.log-1) + chr(13) + 
                   "                   : " + string(input frame {&frame-name} mla-tipo-doc-aprov.log-1) + chr(13) + chr(13).
        if mla-tipo-doc-aprov.log-2 <> input frame {&frame-name} mla-tipo-doc-aprov.log-2 then
            assign c-log-reg = c-log-reg + 
                   "Re-an†lise da Pendencias: " + string(mla-tipo-doc-aprov.log-2) + chr(13) + 
                   "                        : " + string(input frame {&frame-name} mla-tipo-doc-aprov.log-2) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "N" AND tb-aprovacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not(Aprovaá∆o): " + "No" + chr(13) + 
                   "              : " + string(tb-aprovacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y" AND NOT tb-aprovacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not(Aprovaá∆o): " + "Yes" + chr(13) + 
                   "              : " + string(tb-aprovacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "N" AND tb-rejeicao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not(Rejeiá∆o): " + "No" + chr(13) + 
                   "             : " + string(tb-rejeicao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y" AND NOT tb-rejeicao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not(Rejeiá∆o): " + "Yes" + chr(13) + 
                   "             : " + string(tb-rejeicao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,3,1) = "N" AND tb-apr-usu-transacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Usu†rio Transaá∆o): " + "No" + chr(13) + 
                   "                          : " + string(tb-apr-usu-transacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,3,1) = "Y" AND NOT tb-apr-usu-transacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Usu†rio Transaá∆o): " + "Yes" + chr(13) + 
                   "                          : " + string(tb-apr-usu-transacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,4,1) = "N" AND tb-apr-usu-documento:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Usu†rio Documento): " + "No" + chr(13) + 
                   "                          : " + string(tb-apr-usu-documento:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,4,1) = "Y" AND NOT tb-apr-usu-documento:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Usu†rio Documento): " + "Yes" + chr(13) + 
                   "                          : " + string(tb-apr-usu-documento:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "N" AND tb-apr-aprovadores:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Aprovadores): " + "No" + chr(13) + 
                   "                    : " + string(tb-apr-aprovadores:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "Y" AND NOT tb-apr-aprovadores:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Apr(Aprovadores): " + "Yes" + chr(13) + 
                   "                    : " + string(tb-apr-aprovadores:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,6,1) = "N" AND tb-apr-informado:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Informado): " + "No" + chr(13) + 
                   "                  : " + string(tb-apr-informado:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,6,1) = "Y" AND NOT tb-apr-informado:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Informado): " + "Yes" + chr(13) + 
                   "                  : " + string(tb-apr-informado:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,7,1) = "N" AND tb-rej-usu-transacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Usu†rio Transaá∆o): " + "No" + chr(13) + 
                   "                          : " + string(tb-rej-usu-transacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,7,1) = "Y" AND NOT tb-rej-usu-transacao:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Usu†rio Transaá∆o): " + "Yes" + chr(13) + 
                   "                          : " + string(tb-rej-usu-transacao:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,8,1) = "N" AND tb-rej-usu-documento:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Usu†rio Documento): " + "No" + chr(13) + 
                   "                          : " + string(tb-rej-usu-documento:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,8,1) = "Y" AND NOT tb-rej-usu-documento:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Usu†rio Documento): " + "Yes" + chr(13) + 
                   "                          : " + string(tb-rej-usu-documento:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,9,1) = "N" AND tb-rej-aprovadores:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Aprovadores): " + "No" + chr(13) + 
                   "                    : " + string(tb-rej-aprovadores:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,9,1) = "Y" AND NOT tb-rej-aprovadores:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Aprovadores): " + "Yes" + chr(13) + 
                   "                    : " + string(tb-rej-aprovadores:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,10,1) = "N" AND tb-rej-informado:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Informado): " + "No" + chr(13) + 
                   "                  : " + string(tb-rej-informado:checked) + chr(13) + chr(13).
        IF (SUBSTRING(mla-tipo-doc-aprov.char-1,10,1) = "Y" AND NOT tb-rej-informado:CHECKED) THEN
            assign c-log-reg = c-log-reg + 
                   "Not Rej(Informado): " + "Yes" + chr(13) + 
                   "                  : " + string(tb-rej-informado:checked) + chr(13) + chr(13).

        if mla-tipo-doc-aprov.idi-tip-val-pendcia <> input frame {&frame-name} rs-idi-tip-val-pendcia THEN DO:
           {utp/ut-field.i mgind mla-tipo-doc-aprov idi-tip-val-pendcia 1}
            assign c-log-reg = c-log-reg +
                   RETURN-VALUE + " : " + string(mla-tipo-doc-aprov.idi-tip-val-pendcia) + chr(13) +
                   "                        : " + string(input frame {&frame-name} rs-idi-tip-val-pendcia) + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.log-integr-fluig <> mla-tipo-doc-aprov.log-integr-fluig:checked in frame {&frame-name} THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov log-integr-fluig 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + chr(13) +
                   "                : " + (IF mla-tipo-doc-aprov.log-integr-fluig:CHECKED IN FRAME {&frame-name} THEN c-lb-sim ELSE c-lb-nao) + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.cod-proces <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.cod-proces THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov cod-proces 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.cod-proces) + chr(13) +
                   "                : " + mla-tipo-doc-aprov.cod-proces:SCREEN-VALUE IN FRAME {&frame-name} + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.log-praz-conclus <> mla-tipo-doc-aprov.log-praz-conclus:checked in frame {&frame-name} THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov log-praz-conclus 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + chr(13) +
                   "                : " + (IF mla-tipo-doc-aprov.log-praz-conclus:CHECKED IN FRAME {&frame-name} THEN c-lb-sim ELSE c-lb-nao) + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.hra-execucao <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.hra-execucao THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov hra-execucao 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-execucao,"999:99") + chr(13) +
                   "                : " + mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&frame-name} + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.hra-exec-priorid-baixa <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.hra-exec-priorid-baixa THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-baixa 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-baixa,"999:99") + chr(13) +
                   "                : " + mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME {&frame-name} + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.hra-exec-priorid-media <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.hra-exec-priorid-media THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-media 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-media,"999:99") + chr(13) +
                   "                : " + mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME {&frame-name} + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.hra-exec-priorid-alta <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.hra-exec-priorid-alta THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-alta 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-alta,"999:99") + chr(13) +
                   "                : " + mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME {&frame-name} + chr(13) + chr(13).
        END.
        IF mla-tipo-doc-aprov.hra-exec-priorid-altssmo <> INPUT FRAME {&frame-name} mla-tipo-doc-aprov.hra-exec-priorid-altssmo THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-altssmo 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-exec-priorid-altssmo,"999:99") + chr(13) +
                   "                : " + mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME {&frame-name}.
        END.
    end.

    if c-log-reg <> "" then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-tipo-doc-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-tipo-doc-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 22
               mla-log-reg.chave-reg   = string(mla-tipo-doc-aprov.cod-tip-doc)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
               mla-log-reg.log-reg     = entry(22,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         c-log-reg.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-campo V-table-Win 
PROCEDURE pi-salva-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF tb-aprovacao:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "N".

    IF tb-rejeicao:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "N".

    IF tb-apr-usu-transacao:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,3,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,3,1) = "N".
    
    IF tb-apr-usu-documento:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,4,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,4,1) = "N".

    IF tb-apr-aprovadores:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "N".

    IF tb-apr-informado:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,6,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,6,1) = "N".
    
    IF tb-rej-usu-transacao:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,7,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,7,1) = "N".

    IF tb-rej-usu-documento:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,8,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,8,1) = "N".

    IF tb-rej-aprovadores:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,9,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,9,1) = "N".

    IF tb-rej-informado:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,10,1) = "Y".
    ELSE
        ASSIGN SUBSTRING(mla-tipo-doc-aprov.char-1,10,1) = "N".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-padrao-horas V-table-Win 
PROCEDURE pi-seta-padrao-horas :
/*------------------------------------------------------------------------------
  Purpose: Seta o valor padrao para os campos de horas de conclus∆o    
  Parameters:  pl-verifica-branco - input - Indica se s¢ atribui valor se campo estiver em branco
  Notes:        
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-verifica-branco AS LOGICAL NO-UNDO.

    IF pl-verifica-branco THEN DO:
        IF mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main = "" THEN 
            ASSIGN mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main = c-horas-default.
    
        IF mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main = "" THEN 
            ASSIGN mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main = c-horas-default.
        
        IF mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main = "" THEN 
            ASSIGN mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main = c-horas-default.
    
        IF mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main = "" THEN 
            ASSIGN mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main = c-horas-default.
    
        IF mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main = "" THEN 
            ASSIGN mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main = c-horas-default.
    END.
    ELSE
        ASSIGN mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main = c-horas-default
               mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main = c-horas-default
               mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main = c-horas-default
               mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main = c-horas-default
               mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main = c-horas-default.

    RETURN "OK":U.

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
    
    find estabelec
        where rowid(estabelec) = v-row-parent no-lock no-error.
    find first param-aprov no-lock no-error.

    /*** Validaá∆o para setar aprovaá∆o do tipo do documento ***/
    CASE INPUT FRAME {&FRAME-NAME} mla-tipo-doc-aprov.cod-tip-doc:
           WHEN 1 THEN DO: /**Solicitaá∆o de Compra - Item**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 2 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Solicitaá∆o_de_Compra_por_Item}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Solicitaá∆o_de_Compra_por_Total_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-solic = no
                     or (    param-aprov.aprova-solic = yes
                         and param-aprov.aprov-total-solic = yes
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 2 THEN DO: /**Solicitaá∆o de Compra - Total**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 1 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Solicitaá∆o_de_Compra_por_Total}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Solicitaá∆o_de_Compra_por_Item_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-solic = no
                     or (    param-aprov.aprova-solic = yes
                         and param-aprov.aprov-total-solic = no
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 3 THEN DO: /**Requisiá∆o de Estoque - Item**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 4 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Requisiá∆o_de_Estoque_por_Item}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Requisiá∆o_de_Estoque_por_Total_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-requis = no
                     or (    param-aprov.aprova-requis = yes
                         and param-aprov.aprov-total-requis = yes
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 4 THEN DO: /**Requisiá∆o de Estoque - Total**/ 
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 3 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Requisiá∆o_de_Estoque_por_Total}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Requisiá∆o_de_Estoque_por_Item_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-requis = no
                     or (    param-aprov.aprova-requis = yes
                         and param-aprov.aprov-total-requis = no
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 6 THEN DO: /**Pedido de Compra - Item**/ 
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 7 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Pedido_de_Compra_por_Item}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Pedido_de_Compra_por_Total_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-pedido = no
                     or (    param-aprov.aprova-pedido = yes
                         and param-aprov.aprov-total-pedido = yes
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 7 THEN DO: /**Pedido de Compra - Total**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 6 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Pedido_de_Compra_por_Total}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Pedido_de_Compra_por_Item_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-pedido = no
                     or (    param-aprov.aprova-pedido = yes
                         and param-aprov.aprov-total-pedido = no
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 8 THEN DO: /**Pedido Emergencial - Total**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 19 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Pedido_Emergencial_por_Total}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Pedido_Emergencial_por_Item_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-emerg = no
                     or (    param-aprov.aprova-emerg = yes
                         and param-aprov.aprov-total-pedido = no
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 9 THEN DO: /**Processo de Compras - Item**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 10 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Processo_de_Compra_por_Item}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Processo_de_Compra_por_Total}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.
    
                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-proc = no
                     or (    param-aprov.aprova-proc = yes
                         and param-aprov.aprov-total-proc = yes
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 10 THEN DO: /**Processo de Compras - Total**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 9 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Processo_de_Compra_por_Total}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Processo_de_Compra_por_Item}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.
    
                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-proc = no
                     or (    param-aprov.aprova-proc = yes
                         and param-aprov.aprov-total-proc = no
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
           WHEN 19 THEN DO: /**Pedido Emergencial - Item**/
                IF CAN-FIND (mla-tipo-doc-aprov where
                    mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed and
                    mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel and
                    mla-tipo-doc-aprov.cod-tip-doc = 8 AND
                    mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:
                      assign c-msg = "".
                      {utp/ut-liter.i Pedido_Emergencial_por_Item}
                      assign c-msg = trim(return-value).
                      {utp/ut-liter.i _Pedido_Emergencial_por_Total_}
                      assign c-msg = c-msg + "~~" + trim(return-value).
                      run utp/ut-msgs.p (INPUT "show",INPUT 30343, INPUT c-msg).
                      apply "entry" to mla-tipo-doc-aprov.cod-tip-doc in frame {&frame-name}.
                      return "adm-error".
                END.

                if   input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc = yes 
                and  avail param-aprov
                and (    param-aprov.aprova-emerg = no
                     or (    param-aprov.aprova-emerg = yes
                         and param-aprov.aprov-total-pedido = yes
                         )
                     ) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31003,
                                       input mla-tipo-doc-aprov.des-tip-doc).
                    return "ADM-ERROR".
                end.
           END.
    END CASE.  


    /*n∆o permite que o parÉmetro Aprovaá∆o seja desmarcado enquanto houver pendàncias para o documento*/
    if  avail mla-tipo-doc-aprov
    and input frame {&frame-name} mla-tipo-doc-aprov.apr-tip-doc <> mla-tipo-doc-aprov.apr-tip-doc 
    and can-find(first mla-doc-pend-aprov
                where mla-doc-pend-aprov.ep-codigo    = g-empresa-aed
                and   mla-doc-pend-aprov.cod-estabel  = estabelec.cod-estabel 
                and   mla-doc-pend-aprov.cod-tip-doc  = input frame {&frame-name} mla-tipo-doc-aprov.cod-tip-doc
                and   mla-doc-pend-aprov.ind-situacao = 1 /*Pendente*/ ) then do:
                             
        case input frame {&frame-name} mla-tipo-doc-aprov.cod-tip-doc:
            when 1  or       /*Solicitaá∆o de Compra - Item*/
            when 2  or       /*Solicitaá∆o de Compra - Total*/
            when 3  or       /*Requisiá∆o de Estoque - Item*/
            when 4  or       /*Requisiá∆o de Estoque - Total*/
            when 6  or       /*Pedido de Compra - Item*/
            when 7  or       /*Pedido de Compra - Total*/
            when 8  or       /*Pedido Emergencial - Total*/
            when 9  or       /* Processo de Compra - Item */
            when 10 or       /* Processo de Compra - Total */
            when 19 then do: /*Pedido Emergencial - Item*/ 
                find first mla-doc-pend-aprov
                    where mla-doc-pend-aprov.ep-codigo    = g-empresa-aed
                    and   mla-doc-pend-aprov.cod-estabel  = estabelec.cod-estabel
                    and   mla-doc-pend-aprov.cod-tip-doc  = input frame {&frame-name} mla-tipo-doc-aprov.cod-tip-doc
                    and   mla-doc-pend-aprov.ind-situacao = 1 /*Pendente*/
                       no-lock no-error.
                if  avail mla-doc-pend-aprov then do:
                    
                    /*monta chave do documento com separadores*/
                    assign c-chave-doc = "".
                    for each mla-chave-doc-aprov
                        where mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock:
                        assign c-chave-doc = c-chave-doc + 
                                substring(mla-doc-pend-aprov.chave-doc,mla-chave-doc-aprov.posicao-ini,
                                    ((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1)) +
                                    " | ".
                    end.
                    assign c-chave-doc = substring(c-chave-doc,1,(length(c-chave-doc) - 3)).

                    run utp/ut-msgs.p (input "show",
                                       input 26203,
                                       input input frame {&frame-name} mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                             c-chave-doc).
                    return "ADM-ERROR".
                end.
            end.
        end.
    end.

    RUN pi-valida-minutos (INPUT mla-tipo-doc-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "ENTRY":U TO mla-tipo-doc-aprov.hra-execucao IN FRAME f-main.
        RETURN "ADM-ERROR":U.
    END.

    RUN pi-valida-minutos (INPUT mla-tipo-doc-aprov.hra-exec-priorid-baixa:SCREEN-VALUE IN FRAME f-main).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "ENTRY":U TO mla-tipo-doc-aprov.hra-exec-priorid-baixa IN FRAME f-main.
        RETURN "ADM-ERROR":U.
    END.

    RUN pi-valida-minutos (INPUT mla-tipo-doc-aprov.hra-exec-priorid-media:SCREEN-VALUE IN FRAME f-main).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "ENTRY":U TO mla-tipo-doc-aprov.hra-exec-priorid-media IN FRAME f-main.
        RETURN "ADM-ERROR":U.
    END.

    RUN pi-valida-minutos (INPUT mla-tipo-doc-aprov.hra-exec-priorid-alta:SCREEN-VALUE IN FRAME f-main).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "ENTRY":U TO mla-tipo-doc-aprov.hra-exec-priorid-alta IN FRAME f-main.
        RETURN "ADM-ERROR":U.
    END.

    RUN pi-valida-minutos (INPUT mla-tipo-doc-aprov.hra-exec-priorid-altssmo:SCREEN-VALUE IN FRAME f-main).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "ENTRY":U TO mla-tipo-doc-aprov.hra-exec-priorid-altssmo IN FRAME f-main.
        RETURN "ADM-ERROR":U.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-integra-fluig V-table-Win 
PROCEDURE pi-verifica-integra-fluig :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se documento tratado para integrar com fluig e se utiliza 
               prioridade de aprovaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-boin784) THEN
        RUN inbo/boin784.p PERSISTENT SET h-boin784.
    
    find estabelec where
            rowid(estabelec) = v-row-parent
            no-lock no-error.

    RUN pi-permite-doc-fluig IN h-boin784(INPUT INPUT FRAME f-main mla-tipo-doc-aprov.cod-tip-doc).
    ASSIGN l-doc-integra-fluig = (RETURN-VALUE = "OK":U).

    IF AVAIL estabelec THEN DO:
         
        RUN pi-doc-utiliz-prior IN h-boin784(INPUT g-empresa-aed,
                                             INPUT estabelec.cod-estabel,
                                             INPUT INPUT FRAME f-main mla-tipo-doc-aprov.cod-tip-doc,
                                             OUTPUT l-doc-utiliz-prior,
                                             OUTPUT l-prior-habilitada).
    
        RUN pi-verifica-estab-integra-fluig IN h-boin784(INPUT g-empresa-aed,
                                                         INPUT estabelec.cod-estabel,
                                                         OUTPUT l-estab-integra-fluig).
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAIL mla-tipo-doc-aprov THEN
    ASSIGN mla-tipo-doc-aprov.ep-codigo   = g-empresa-aed 
           mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel 
           mla-tipo-doc-aprov.cod-tip-doc = input frame {&frame-name} mla-tipo-doc-aprov.cod-tip-doc.

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
  {src/adm/template/snd-list.i "mla-tipo-doc-aprov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-minutos V-table-Win 
PROCEDURE pi-valida-minutos:
/* -----------------------------------------------------------
  Purpose: Valida minutos entre 0 e 59     
  Parameters:  c-hora-minutos: hora e minutos digitados
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-hora-minutos AS CHARACTER NO-UNDO.

    ASSIGN c-minutos = ENTRY(2, c-hora-minutos, ":").

    if int(c-minutos) > 59 then do:
        run utp/ut-msgs.p (input "show",
                           input 3073,
                           input "").
        RETURN "NOK":U.
    end.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataHora V-table-Win 
FUNCTION fnFormataHora RETURNS CHARACTER
  (c-valor AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor formatado da hora para ser preenchida conforme o formato 999:99
  Parameters: c-valor - Valor digitado
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-valor-formatado AS CHARACTER   NO-UNDO.
  
  ASSIGN c-horas   = trim(ENTRY(1,c-valor,":"))
         c-minutos = trim(ENTRY(2,c-valor,":")).
  
  IF c-horas = "" AND c-minutos = "" THEN DO:
      ASSIGN c-valor-formatado = "000:00".
  END.
  ELSE DO:
     ASSIGN c-horas   = FILL("0", 3 - LENGTH(c-horas)) + c-horas
            c-minutos = c-minutos + FILL("0", 2 - LENGTH(c-minutos))
            c-valor-formatado = c-horas + ":" + c-minutos. 
           
  END.
  
  RETURN c-valor-formatado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

