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

{include/i-prgvrs.i V01IN084 2.00.00.096 } /*** "010096" 09/08/2024 11:02:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in084 MUT}
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
define buffer b-deposito for deposito.

/* Local Variable Definitions ---                                       */
define variable r-pl-it-calc              as rowid              no-undo.
define variable r-deposito                as rowid              no-undo.
define new global shared var gr-deposito  as rowid              no-undo.
DEFINE VARIABLE l-copy                    as logical initial NO no-undo.
DEFINE VARIABLE i-tipo-depos              AS INT                NO-UNDO.
 
def var c-label as char no-undo.

DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bosc048 AS HANDLE NO-UNDO.

{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
{bhp/bh9999.i1}

/** Integraá∆o MES X PPI-Multitask **/
DEFINE VARIABLE h-cdapi997      AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cdapi990      AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-handle        AS CHAR         NO-UNDO.
DEFINE VARIABLE cXML            AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cXMLAux         AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cChave          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-des-msg-ret   AS CHARACTER    NO-UNDO.

{cdp/cdapi990.i2} /* tt-cria-pendencia */


/*
/********************Multiplanta***********************/

/******************************************************/ 

/********************Multiplanta***********************/
def var i-tipo-movto   as integer no-undo.

{cdp/cd7300.i1}
{cdp/cdapi216.i}
{mcinc/mcapi285.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.

/******************************************************/

*/
  /***** Frotas ********/
    {cdp/cd0666.i}
    {cdp/cd9043.i}

DEFINE TEMP-TABLE RowErrorsFrotas no-undo
       field ErrorSequence as integer
       field ErrorNumber   as integer
       field ErrorDescription as char
       field ErrorParameters as char
       field ErrorType       as char
       field Errorhelp       as char
       field Errorsubtype    as char.

DEFINE VARIABLE l-log-2-aux          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-flag-log-2         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-existe-local-depos AS LOGICAL    NO-UNDO.

DEFINE VARIABLE hShowMsg             AS HANDLE     NO-UNDO.

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
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
&Scoped-define EXTERNAL-TABLES deposito
&Scoped-define FIRST-EXTERNAL-TABLE deposito


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR deposito.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS deposito.nome 
&Scoped-define ENABLED-TABLES deposito
&Scoped-define FIRST-ENABLED-TABLE deposito
&Scoped-Define ENABLED-OBJECTS cb-tp-classif-depos rs-tipo-depos RECT-2 ~
RECT-4 RECT-5 RECT-6 rt-key rt-mold rt-integra 
&Scoped-Define DISPLAYED-FIELDS deposito.cod-depos deposito.nome ~
deposito.cons-saldo deposito.ind-acabado deposito.ind-processo ~
deposito.alocado deposito.ind-dep-cq deposito.ind-dep-rej ~
deposito.nome-abrev 
&Scoped-define DISPLAYED-TABLES deposito
&Scoped-define FIRST-DISPLAYED-TABLE deposito
&Scoped-Define DISPLAYED-OBJECTS tg-wms-externo cb-tp-classif-depos ~
tg-integra-his tg-saldo-mrp l-recic l-log-2 l-aloca-saldo-erp rs-tipo-depos c-nome-emit ~
text-1 tg-aloca-saldo-ext text-3

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS deposito.cod-depos deposito.nome ~
deposito.cons-saldo deposito.ind-acabado tg-saldo-mrp deposito.ind-processo ~
deposito.alocado l-recic deposito.ind-dep-cq deposito.ind-dep-rej ~
deposito.nome-abrev 
&Scoped-define ADM-MODIFY-FIELDS deposito.cons-saldo deposito.ind-acabado ~
tg-saldo-mrp deposito.ind-processo deposito.alocado l-recic ~
deposito.ind-dep-cq deposito.ind-dep-rej 

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
DEFINE VARIABLE cb-tp-classif-depos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE rs-tipo-depos AS INTEGER FORMAT "-9":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Interno",1,
                     "Externo Arm. Geral",3,
                     "Externo Dep. Fechado",4,
                     "Externo (Outro)",2
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .88.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-3 AS CHARACTER FORMAT "X(256)":U INITIAL "WMS Externo" 
      VIEW-AS TEXT 
     SIZE 15.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.14 BY 2.38.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 2.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.

DEFINE RECTANGLE rt-integra
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 1.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 5.5.

DEFINE VARIABLE l-aloca-saldo-erp AS LOGICAL INITIAL no 
     LABEL "Aloca Saldo ERP" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 TOOLTIP "Aloca Saldo ERP" NO-UNDO.

DEFINE VARIABLE l-log-2 AS LOGICAL INITIAL no 
     LABEL "deposito-wms" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-recic AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.43 BY .75.

DEFINE VARIABLE tg-aloca-saldo-ext AS LOGICAL INITIAL no 
     LABEL "Aloca Saldo Dep Externo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-integra-his AS LOGICAL INITIAL no 
     LABEL "Integraá∆o HIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.72 BY .88 NO-UNDO.

DEFINE VARIABLE tg-saldo-mrp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .75 NO-UNDO.

DEFINE VARIABLE tg-wms-externo AS LOGICAL INITIAL no 
     LABEL "Dep¢sito WMS Externo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.57 BY .83 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-wms-externo AT ROW 5.21 COL 66.29 WIDGET-ID 8
     cb-tp-classif-depos AT ROW 1.17 COL 69 COLON-ALIGNED WIDGET-ID 2
     tg-integra-his AT ROW 7.04 COL 66.29
     deposito.cod-depos AT ROW 1.17 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     deposito.nome AT ROW 1.17 COL 16.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     deposito.cons-saldo AT ROW 2.67 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .75
     deposito.ind-acabado AT ROW 2.67 COL 35.57
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     tg-saldo-mrp AT ROW 3.58 COL 3.14
     deposito.ind-processo AT ROW 3.58 COL 35.57
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .75
     deposito.alocado AT ROW 4.54 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 29.86 BY .75
     l-recic AT ROW 4.54 COL 35.57
     deposito.ind-dep-cq AT ROW 5.5 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .75
     deposito.ind-dep-rej AT ROW 5.46 COL 35.57
          VIEW-AS TOGGLE-BOX
          SIZE 20.72 BY .75
     l-log-2 AT ROW 2.83 COL 66.29
     l-aloca-saldo-erp AT ROW 3.70 COL 66.29
     rs-tipo-depos AT ROW 8.96 COL 2.2 WIDGET-ID 4 NO-LABEL
     deposito.nome-abrev AT ROW 8.63 COL 35.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-nome-emit AT ROW 9.67 COL 35.14 COLON-ALIGNED NO-LABEL
     text-1 AT ROW 8.08 COL 3.72 NO-LABEL
     tg-aloca-saldo-ext AT ROW 5.92 COL 66.29 WIDGET-ID 10
     text-3 AT ROW 4.5 COL 66.43 NO-LABEL WIDGET-ID 12
     "WMS" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 2.25 COL 66.43
     RECT-2 AT ROW 8.38 COL 22.86
     RECT-4 AT ROW 8.38 COL 1
     RECT-5 AT ROW 2.5 COL 65
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     rt-integra AT ROW 7 COL 65
     RECT-6 AT ROW 4.83 COL 65 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: deposito
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
         HEIGHT             = 10.25
         WIDTH              = 89.57.
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

/* SETTINGS FOR TOGGLE-BOX deposito.alocado IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN deposito.cod-depos IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX deposito.cons-saldo IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX deposito.ind-acabado IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX deposito.ind-dep-cq IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX deposito.ind-dep-rej IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX deposito.ind-processo IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-aloca-saldo-erp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-log-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-recic IN FRAME f-main
   NO-ENABLE 1 3                                                        */
ASSIGN 
       l-recic:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN deposito.nome IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN deposito.nome-abrev IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN text-3 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX tg-aloca-saldo-ext IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-integra-his IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-saldo-mrp IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tg-wms-externo IN FRAME f-main
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

&Scoped-define SELF-NAME deposito.cons-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.cons-saldo V-table-Win
ON VALUE-CHANGED OF deposito.cons-saldo IN FRAME f-main /* Considera Saldo Dispon°vel */
DO:
    if deposito.cons-saldo:checked in frame {&frame-name} = no then
       assign tg-saldo-mrp:sensitive in frame {&frame-name} = yes.
    else assign tg-saldo-mrp:checked in frame {&frame-name} = yes
                tg-saldo-mrp:sensitive in frame {&frame-name} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME deposito.ind-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.ind-acabado V-table-Win
ON VALUE-CHANGED OF deposito.ind-acabado IN FRAME f-main /* Dep¢sito Produto Acabado */
DO:
  IF (deposito.ind-acabado:checked in frame {&frame-name}   
  OR  deposito.ind-processo:checked in frame {&frame-name}
  OR  l-log-2:CHECKED IN FRAME {&FRAME-NAME}) THEN
      ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}     = false
             deposito.ind-dep-rej:sensitive in frame {&frame-name}    = false
             deposito.ind-dep-cq:checked in frame {&frame-name}       = false
             deposito.ind-dep-rej:checked in frame {&frame-name}      = false.
  ELSE
     ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}      = true
            deposito.ind-dep-rej:sensitive in frame {&frame-name}     = true.             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME deposito.ind-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.ind-processo V-table-Win
ON VALUE-CHANGED OF deposito.ind-processo IN FRAME f-main /* Dep¢sito Processo */
DO:
  &if defined (bf_man_sfc_lc) &then  
    IF (deposito.ind-acabado:checked in frame {&frame-name} 
    OR  deposito.ind-processo:checked in frame {&frame-name}
    OR  l-log-2:CHECKED IN FRAME {&FRAME-NAME}
    OR  tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME}    
    OR  l-recic:checked in frame {&frame-name}) THEN
        ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}     = false
               deposito.ind-dep-rej:sensitive in frame {&frame-name}    = false
               deposito.ind-dep-cq:checked in frame {&frame-name}       = false 
               deposito.ind-dep-rej:checked in frame {&frame-name}      = false.
    ELSE
       ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}      = true
              deposito.ind-dep-rej:sensitive in frame {&frame-name}     = true.            
  &else
    IF (deposito.ind-acabado:checked in frame {&frame-name} 
    OR  deposito.ind-processo:checked in frame {&frame-name}
    OR  tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME}
    OR  l-log-2:CHECKED IN FRAME {&FRAME-NAME}) THEN
        ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}     = false
               deposito.ind-dep-rej:sensitive in frame {&frame-name}    = false
               deposito.ind-dep-cq:checked in frame {&frame-name}       = false 
               deposito.ind-dep-rej:checked in frame {&frame-name}      = false.
    ELSE
       ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}      = true
              deposito.ind-dep-rej:sensitive in frame {&frame-name}     = true.  
  &endif          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-log-2 V-table-Win
ON VALUE-CHANGED OF l-log-2 IN FRAME f-main /* deposito-wms */
DO:
    IF l-log-2:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE 
        ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               l-aloca-saldo-erp:CHECKED   IN FRAME {&FRAME-NAME} = NO
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME deposito.ind-dep-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.ind-dep-cq V-table-Win
ON VALUE-CHANGED OF deposito.ind-dep-cq IN FRAME f-main /* deposito-wms */
DO:
    IF deposito.ind-dep-cq:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
       ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
    ELSE 
       ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-recic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-recic V-table-Win
ON VALUE-CHANGED OF l-recic IN FRAME f-main
DO:
    IF (deposito.ind-acabado:checked in frame {&frame-name} 
    OR  deposito.ind-processo:checked in frame {&frame-name}
    OR  l-recic:checked in frame {&frame-name}) THEN
        ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}     = false
               deposito.ind-dep-rej:sensitive in frame {&frame-name}    = false
               deposito.ind-dep-cq:checked in frame {&frame-name}       = false 
               deposito.ind-dep-rej:checked in frame {&frame-name}      = false.
    ELSE DO:
       IF l-log-2:CHECKED IN FRAME {&FRAME-NAME} OR
          tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME} THEN 
          ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}  = FALSE
                 deposito.ind-dep-rej:sensitive in frame {&frame-name} = FALSE.
       ELSE
          ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}  = true
                 deposito.ind-dep-rej:sensitive in frame {&frame-name} = true.         
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME deposito.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.nome-abrev V-table-Win
ON F5 OF deposito.nome-abrev IN FRAME f-main /* Destinat†rio */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="adzoom/z02ad098.w"
                  &tabela=deposito
                  &atributo=nome-abrev} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.nome-abrev V-table-Win
ON LEAVE OF deposito.nome-abrev IN FRAME f-main /* Destinat†rio */
DO:
{include/leave.i &tabela=emitente
                 &atributo-ref=nome-emit
                 &variavel-ref=c-nome-emit
                 &where="(emitente.identific = 3 or emitente.identific = 1) and 
                          emitente.nome-abrev = input frame {&frame-name} deposito.nome-abrev"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deposito.nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF deposito.nome-abrev IN FRAME f-main /* Destinat†rio */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME tg-wms-externo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-wms-externo V-table-Win
ON VALUE-CHANGED OF tg-wms-externo IN FRAME f-main /* Dep¢sito WMS Externo */
DO:
    IF tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN tg-aloca-saldo-ext:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               deposito.ind-dep-cq:CHECKED   IN FRAME {&FRAME-NAME} = NO
               l-log-2:SENSITIVE   IN FRAME {&FRAME-NAME} = NO.
    ELSE 
        ASSIGN tg-aloca-saldo-ext:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-aloca-saldo-ext:CHECKED   IN FRAME {&FRAME-NAME} = NO
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               l-log-2:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.
END.


&Scoped-define SELF-NAME rs-tipo-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-depos V-table-Win
ON VALUE-CHANGED OF rs-tipo-depos IN FRAME f-main /* Tipo Dep¢s */
DO:
    IF (rs-tipo-depos:screen-value in frame {&frame-name} = "1" ) THEN
     ASSIGN deposito.nome-abrev:screen-value in frame {&frame-name} = ""
            c-nome-emit:screen-value in frame {&frame-name}         = ""
            deposito.nome-abrev:sensitive in frame {&frame-name}    = false.
  ELSE
     ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name} = true. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF 

    FIND FIRST param-global no-lock no-error.        
        IF deposito.nome-abrev:load-mouse-pointer ("Image~\lupa.cur") IN FRAME {&frame-name} THEN.

    ASSIGN l-log-2:SENSITIVE    IN FRAME {&frame-name} = NO
           l-log-2:LABEL        IN FRAME {&frame-name} = "Dep¢sito WMS"
           l-aloca-saldo-erp:SENSITIVE IN FRAME {&frame-name} = NO.

     ASSIGN tg-wms-externo:SENSITIVE IN FRAME {&frame-name} = NO
            tg-aloca-saldo-ext:SENSITIVE IN FRAME {&frame-name} = NO.

    &if defined (bf_man_sfc_lc) &then
        {utp/ut-field.i mgind deposito log-reciclagem 01}
        assign l-recic:label in frame {&frame-name} = return-value.
    &endif
    
    {utp/ut-liter.i Classificaá∆o}
    assign cb-tp-classif-depos:label in frame {&frame-name} = return-value. 
    
    {utp/ut-rtlbl.i mgind deposito ind-tipo-dep text-1}
    
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
  {src/adm/template/row-list.i "deposito"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "deposito"}

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
    ASSIGN l-flag-log-2 = YES
           l-copy = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN  deposito.cons-saldo:checked   in frame {&frame-name} = yes
          deposito.alocado:checked      in frame {&frame-name} = yes
          deposito.ind-acabado:checked  in frame {&frame-name} = no
          deposito.ind-processo:checked in frame {&frame-name} = no
          deposito.ind-dep-cq:checked   in frame {&frame-name} = no
          deposito.ind-dep-rej:checked  in frame {&frame-name} = no
          tg-saldo-mrp:checked          in frame {&frame-name} = yes
          tg-saldo-mrp:sensitive        in frame {&frame-name} = NO
          l-aloca-saldo-erp:checked     in frame {&frame-name} = NO
          l-aloca-saldo-erp:sensitive   in frame {&frame-name} = NO
          l-log-2:checked               IN FRAME {&FRAME-NAME} = NO
          l-log-2:SENSITIVE             IN FRAME {&FRAME-NAME} = YES
          tg-wms-externo:CHECKED    IN FRAME {&FRAME-NAME} = NO
          tg-aloca-saldo-ext:CHECKED    IN FRAME {&FRAME-NAME} = NO
          tg-wms-externo:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
          tg-aloca-saldo-ext:SENSITIVE  IN FRAME {&FRAME-NAME} = YES.

  IF (rs-tipo-depos:screen-value in frame {&frame-name} = "1" ) THEN
      ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name} = false.
  ELSE
      ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name} = true.

  
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      ASSIGN  tg-integra-his:CHECKED IN FRAME f-main = NO.
  &ENDIF

  DISP text-1 WITH FRAME {&FRAME-NAME}.

  APPLY "value-changed":U TO tg-wms-externo IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-classif-depos AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Ponha aqui a validaá∆o de chave duplicada */
  if  deposito.cod-depos:sensitive in frame {&frame-name} = yes 
  and can-find (b-deposito where b-deposito.cod-depos = input frame {&frame-name} deposito.cod-depos) 
  then do: 
      {utp/ut-field.i mgind contabiliza cod-depos 1}
      run utp/ut-msgs.p (input "show",
                         input 7,
                         input return-value).
      return 'ADM-ERROR':U.
  end.
  /* Ponha aqui as demais validaá‰es */

  /****  Validaá∆o para o c¢digo do deposito <> "" *****/
  if deposito.cod-depos:screen-value = "" then do:
     {utp/ut-field.i mgind deposito cod-depos 1}
       run utp/ut-msgs.p (input "show",
                          input 17677,
                          input return-value).
       apply 'entry' to deposito.cod-depos in frame {&frame-name}.
       return 'ADM-ERROR':U.
  end.

  /****  Validaá∆o para o nome do deposito <> "" *****/
  if deposito.nome:screen-value = "" then do:
     {utp/ut-field.i mgind deposito nome 1} 
       run utp/ut-msgs.p (input "show",
                          input 17677,
                          input return-value).
       apply 'entry' to deposito.nome in frame {&frame-name}.                          
       return 'ADM-ERROR':U.
  end.   

  /****  Validaá∆o para deposito.nom-abrev *****/
  find first emitente  
       where ((emitente.identific = 3  or emitente.identific = 1)  
       and     input frame {&frame-name} rs-tipo-depos >= "2" 
       and     emitente.nome-abrev = input frame {&frame-name} deposito.nome-abrev) no-lock no-error.
  
  if  not avail emitente and input frame {&frame-name} rs-tipo-depos >= "2" then do: 
      {utp/ut-liter.i Destinat†rio * L} 
      run utp/ut-msgs.p (input "show",
                         input 56,
                         input trim(return-value) ).
      return 'ADM-ERROR':U.
  end.

  /*---
  Caso o deposito possua movimentacao para deposito fechado/armazem geral nao
  permite mudar o tipo, pois o calculo do medio verifica o tipo do deposito
  para valorizar o item no deposito
  ---*/
  IF  adm-new-record = NO 
  AND rs-tipo-depos <> INPUT FRAME {&FRAME-NAME} rs-tipo-depos THEN DO:
  
      IF (i-tipo-depos > 1 AND i-tipo-depos <= 4) AND (INPUT FRAME {&FRAME-NAME} rs-tipo-depos = 1 OR INPUT FRAME {&FRAME-NAME} rs-tipo-depos = 2) THEN DO:
           
          IF CAN-FIND(FIRST saldo-estoq 
                      WHERE saldo-estoq.cod-depos = deposito.cod-depos
                        AND saldo-estoq.qtidade-ini > 0) THEN DO:

              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 56836,
                                 INPUT "").
              RETURN "adm-error":U.

          END.
              
      END.

  END.

  /*IF - Procedimento de modifica */
  IF NOT adm-new-record THEN DO:
      if  avail param-global then do:
          if  param-global.modulo-pl or 
              param-global.modulo-pi then do:
              if  (input frame {&frame-name} deposito.cons-saldo <> deposito.cons-saldo 
                   and  param-global.modulo-pl) then
                  for each saldo-estoq where 
                           saldo-estoq.cod-depos = deposito.cod-depos no-lock:
                      find item where 
                           item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
                      if  avail item then do:
                          run cdp/cd7000.p(input 1,
                                           input item.it-codigo,
                                           input item.cod-estabel).

                      end.                      
                  end. /*for*/
      end.
  end.   

  assign r-deposito = rowid(deposito).
  find deposito where rowid(deposito) = r-deposito exclusive-lock no-error.
  if  avail deposito then do:
      assign input frame {&frame-name} deposito.cons-saldo
             input frame {&frame-name} deposito.alocado
             input frame {&frame-name} deposito.ind-acabado
             input frame {&frame-name} rs-tipo-depos
             input frame {&frame-name} deposito.ind-processo
             input frame {&frame-name} deposito.ind-dep-cq
             input frame {&frame-name} deposito.ind-dep-rej
             input frame {&frame-name} deposito.nome-abrev.
  end.           
  END. /*IF - Procedimento de modifica */  
  ELSE
       /*IF - Procedimento de inclui */
      IF  (deposito.cod-depos:sensitive in frame {&frame-name} = yes) THEN DO:
         if  avail param-global then do:
          if  param-global.modulo-pl or param-global.modulo-pi then
              if  input frame {&frame-name} deposito.cons-saldo = yes then
                  for each saldo-estoq  where 
                           saldo-estoq.cod-depos = deposito.cod-depos no-lock:
                      find item where 
                           item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
                      if  avail item then 
                          run cdp/cd7000.p(input 1,
                                           input item.it-codigo,
                                           input item.cod-estabel).


                  end. /*for*/
         end.
      END. /*IF - Procedimento de inclui */ 

  /* Validaá∆o para a Release 2.02 - Se o dep¢sito foi informado nos ParÉmetros
     da Produá∆o como Dep¢sito Reciclagem, a flag Reciclagem n∆o pode ser desligada */
  &IF DEFINED (bf_man_sfc_lc) &THEN
      if input frame {&frame-name} l-recic = no and
      can-find(first param-cp 
               where substr(param-cp.char-2,1,3) = input frame {&frame-name} deposito.cod-depos) then do:
          run utp/ut-msgs.p (input 'show',
                             input 18140,
                             input "").
          apply 'entry' to l-recic in frame {&frame-name}.                   
          return 'ADM-ERROR':U.
      end.
  &ENDIF

  assign input frame {&frame-name} l-aloca-saldo-erp
         INPUT FRAME {&FRAME-NAME} l-log-2
         INPUT FRAME {&FRAME-NAME} tg-wms-externo
         INPUT FRAME {&FRAME-NAME} tg-aloca-saldo-ext.

  IF l-log-2 AND tg-wms-externo THEN DO:
      //Dep¢sito n∆o pode ter controle WMS e SaaS simultaneamente.
      run utp/ut-msgs.p (input 'show',
                         input 57466, 
                         input "").
      apply 'entry' to l-log-2 in frame {&frame-name}.                   
      return 'ADM-ERROR':U.

  END.

  ASSIGN l-log-2-aux = l-log-2:CHECKED IN FRAME {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */
  if tg-saldo-mrp:sensitive in frame {&frame-name} = yes then do:
      &if defined (bf_man_sfc_lc) &then 
          assign deposito.log-ordens-mrp = input frame {&frame-name} tg-saldo-mrp.      
      &else
          assign deposito.log-1          = input frame {&frame-name} tg-saldo-mrp.
      &endif
  end.
  else do:
      &if defined (bf_man_sfc_lc) &then
          assign deposito.log-ordens-mrp = yes.
      &else
          assign deposito.log-1          = yes.
      &endif
  end.

  &if defined (bf_man_sfc_lc) &then
      assign deposito.log-reciclagem = input frame {&frame-name} l-recic.  
  &endif
  
  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
      ASSIGN deposito.log-gera-wms = l-log-2-aux.
  &ELSE
      ASSIGN deposito.log-2 = l-log-2-aux.
  &ENDIF
  
  // Validaá∆o WMS SAAS
  IF CAN-FIND (FIRST funcao
               WHERE funcao.cd-funcao = "WMS-SAAS"
                 AND funcao.ativo     = YES) THEN DO:  
      ASSIGN deposito.log-wms-externo           = tg-wms-externo
             deposito.log-aloca-saldo-wms-ext   = tg-aloca-saldo-ext.
  END.
  // Fim Validaá∆o WMS SAAS

  IF l-aloca-saldo-erp:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
     l-aloca-saldo-erp THEN
     &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
         ASSIGN deposito.log-aloca-qtd-wms = YES.
     &ELSE
         ASSIGN overlay(deposito.char-1,1,1) = "Y".
     &ENDIF
  ELSE DO:
      IF NOT l-aloca-saldo-erp THEN
         &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
             ASSIGN deposito.log-aloca-qtd-wms = NO.
         &ELSE   
             ASSIGN overlay(deposito.char-1,1,1) = "N".
         &ENDIF
  END.
  
  ASSIGN c-classif-depos = cb-tp-classif-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}. 
  
  IF AVAILABLE deposito THEN DO:

     OVERLAY(deposito.char-1,3,1) = trim(STRING({ininc/i02in084.i 6 c-classif-depos})).

     IF substring(deposito.char-1,3,1) <> "1" AND
        substring(deposito.char-1,3,1) <> "2" AND
        substring(deposito.char-1,3,1) <> "3" AND
        substring(deposito.char-1,3,1) <> "4" THEN
        OVERLAY(deposito.char-1,3,1) = "1".

     /*Tipo Deposito*/
     IF rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" THEN
         ASSIGN deposito.ind-tipo-dep = 1. /*Interno*/
     ELSE DO:
         ASSIGN deposito.ind-tipo-dep = 2.            

         IF rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "3" THEN
             ASSIGN OVERLAY(deposito.char-1,4,1) = "A". /*Externo Armazem Geral*/
         ELSE IF rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "4" THEN
             ASSIGN OVERLAY(deposito.char-1,4,1) = "F". /*Externo Deposito Fechado*/
         ELSE
             ASSIGN OVERLAY(deposito.char-1,4,1) = "". /*Externo Outro*/

     END.

  END.
  
  DISP l-log-2          
       l-aloca-saldo-erp WITH FRAME f-main.

  IF CAN-FIND (FIRST funcao
               WHERE funcao.cd-funcao = "WMS-SAAS"
                 AND funcao.ativo     = YES) THEN DO:
      DISP text-3
           tg-wms-externo      
           tg-aloca-saldo-ext WITH FRAME f-main.
  END.


  ASSIGN l-log-2-aux = NO.
/*  
/********************Multiplanta-SMC***********************/
    for each tt-smc-deposito:
        delete tt-smc-deposito.
    end.    
        assign c-transacao = "SMC011".
        {cdp/cd7300.i5 "001" c-transacao "-SMC"}

        assign  i-tipo-movto = if deposito.cod-depos:sensitive in frame {&frame-name}
                           then 1 else 2.

   /*if  param-global.modulo-mp and
 *         tt-replica-msg-SMC.log-replica-msg  = yes then do: 
 *         create tt-smc-deposito.
 *         buffer-copy deposito to tt-smc-deposito.
 *         create tt-dados-env-SMC.                  
 *         assign tt-dados-env-SMC.num-sequencia  = i-seq
 *                tt-dados-env-SMC.cod-tipo-reg   = 285
 *                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
 *                tt-dados-env-SMC.identif-msg    = string(deposito.cod-depos).
 *         raw-transfer tt-smc-deposito to tt-dados-env-SMC.conteudo-msg. 
 *         assign i-seq = i-seq + 1.                                     
 *    end.*/


       run pi-cria-tt-dados-smc (input i-tipo-movto).

        {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/******************Fim-Multiplanta-SMC********************/    
*/

  &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx037.p PERSISTENT SET hDBOproxy.
        RUN replicaDeposito IN hDBOproxy(INPUT input frame {&frame-name} deposito.cod-depos,
                                         INPUT input frame {&frame-name} deposito.nome,
                                         OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            RUN destroy IN hDBOproxy.
            undo, return "ADM-ERROR":U.
        END.
        RUN destroy IN hDBOproxy.

        
        IF l-log-2:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
            IF NOT VALID-HANDLE(h-bosc048) THEN
                RUN scbo/bosc048.p PERSISTENT SET h-bosc048.

            RUN RetornaRelacionamentoLocalxDeposito IN h-bosc048(INPUT input frame {&frame-name} deposito.cod-depos,
                                                                 OUTPUT l-existe-local-depos).
            IF l-existe-local-depos THEN DO:

                ASSIGN l-log-2:CHECKED IN FRAME {&FRAME-NAME} = NO.

                run utp/ut-msgs.p (input "show",
                                   input 56177,
                                   input return-value).
                undo, return 'ADM-ERROR':U.

            END.

            DELETE OBJECT h-bosc048 NO-ERROR.
        END.
    END.
  &ENDIF
       
  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN        
        /** Integraá∆o EAI2 **/
       
        IF v_log_eai2_ativado THEN DO:
           FIND FIRST deposito WHERE deposito.cod-depos = input frame {&frame-name} deposito.cod-depos NO-LOCK NO-ERROR.
           
           IF NOT VALID-HANDLE(h-cdapi997) OR
              h-cdapi997:TYPE <> "PROCEDURE":U OR
              h-cdapi997:FILE-NAME <> "cdp/cdapi997.p":U THEN DO:
              RUN cdp/cdapi997.p PERSISTENT SET h-cdapi997. 
           END.
                                                          
           RUN pi-sendUpsert IN h-cdapi997 (INPUT ROWID(deposito), OUTPUT TABLE RowErrors).
              
           IF VALID-HANDLE(h-cdapi997) AND
              h-cdapi997:TYPE = "PROCEDURE":U AND
              h-cdapi997:FILE-NAME = "cdp/cdapi997.p":U THEN DO:
              DELETE PROCEDURE h-cdapi997 NO-ERROR.
              ASSIGN h-cdapi997 = ?.
           END.
          
           IF CAN-FIND(FIRST RowErrors) THEN DO:
              {method/showmessage.i1}
              {method/showmessage.i2}
              {method/showmessage.i3}
              RETURN "ADM-ERROR".
           END.                               
        END.
  &ENDIF        
    
    /** Integraá∆o MES X PPI-Multitask **/    
    FIND FIRST param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
    
        IF AVAIL deposito THEN DO:
            IF NOT VALID-HANDLE(h-cdapi997) OR
               h-cdapi997:TYPE <> "PROCEDURE":U OR
               h-cdapi997:FILE-NAME <> "cdp/cdapi997.p":U THEN DO:
               RUN cdp/cdapi997.p PERSISTENT SET h-cdapi997. 
            END.
            
            IF NOT VALID-HANDLE(h-cdapi990) OR
               h-cdapi990:TYPE <> "PROCEDURE":U OR
               h-cdapi990:FILE-NAME <> "cdp/cdapi990.p":U THEN DO:
               RUN cdp/cdapi990.p PERSISTENT SET h-cdapi990. 
            END.
            
            EMPTY TEMP-TABLE rowErrors NO-ERROR.          

            RUN pi-SendDirectUpsertWarehouse IN h-cdapi997 (INPUT ROWID(deposito),
                                                            OUTPUT cXml,
                                                            OUTPUT cChave,
                                                            OUTPUT TABLE rowErrors).

            IF CAN-FIND(FIRST rowErrors ) THEN DO:
                ASSIGN c-des-msg-ret = ""
                       cXMLAux     = cXML.
                
                /* Busca a descriá∆o dos erros para criar a pendencia */
                FOR EACH rowErrors:
                    ASSIGN c-des-msg-ret =  c-des-msg-ret + rowErrors.errorDescription + chr(10) .
                END.  
                
                EMPTY TEMP-TABLE rowErrors NO-ERROR.
                     
                /** Tela de confirmacao **/
                {utp/ut-liter.i do_dep¢sito * }
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 54394, 
                                   INPUT TRIM(RETURN-VALUE) + " ":U + deposito.cod-depos).
                IF RETURN-VALUE = "YES":U THEN DO:  
                    
                    EMPTY TEMP-TABLE tt-cria-pendencia NO-ERROR.
                    
                    DO WHILE(TRUE):
                        CREATE tt-cria-pendencia.
                        ASSIGN tt-cria-pendencia.cTransaction      = "Warehouse":U
                               tt-cria-pendencia.cInternalId       = cChave 
                               tt-cria-pendencia.cErrorDescription = c-des-msg-ret
                               tt-cria-pendencia.iTipStatus        = 1. /* Pendente com Erro */                              
                        
                        IF LENGTH(cXMLAux) > 9990 THEN DO:
                            ASSIGN tt-cria-pendencia.cXml  =  SUBSTR(cXMLAux, 1, 9990)
                                   SUBSTR(cXMLAux,1, 9990) = "":U.
                        END.
                        ELSE DO:
                            ASSIGN tt-cria-pendencia.cXml = cXMLAux. 
                            LEAVE.
                        END.
                    END. /*end do while*/
                    
                    RUN createPendency IN h-cdapi990 (INPUT TABLE tt-cria-pendencia,
                                                      OUTPUT TABLE rowErrors).
                END.
                ELSE DO:
                    UNDO, RETURN "ADM-ERROR":U.
                END.
                
            END.
            ELSE DO:
                /* Se o retorno for ok, verifica se existe pendencia para a chave. Se tiver, exlui */           
                IF CAN-FIND(FIRST pendcia-integr-mes 
                            WHERE pendcia-integr-mes.cod-chave-ident = cChave) THEN
                    RUN deletePendciaByIdentif IN h-cdapi990 (INPUT cChave).
            END.
            
            /* TODO: INCLUIR NA FASE 2 DA INTEGRACAO MES TOTVS ATRAVES DE PARAMETRO
            RUN pi-exporta-mensagem  IN h-cdapi997 (INPUT cXML, 
                                                    INPUT "Warehouse":U, 
                                                    INPUT cChave,
                                                    INPUT 1, /* Pendente com Erro */
                                                    OUTPUT TABLE rowErrors APPEND).*/
                
            IF CAN-FIND(FIRST rowErrors) THEN DO:
                {method/showmessage.i1}     
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}  
                RETURN "ADM-ERROR":U.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-cdapi990) AND
        h-cdapi990:TYPE = "PROCEDURE":U AND
        h-cdapi990:FILE-NAME = "cdp/cdapi990.p":U THEN DO:
        DELETE PROCEDURE h-cdapi990 NO-ERROR.
        ASSIGN h-cdapi990 = ?.
    END. 
    
    IF VALID-HANDLE(h-cdapi997) AND
        h-cdapi997:TYPE = "PROCEDURE":U AND
        h-cdapi997:FILE-NAME = "cdp/cdapi997.p":U THEN DO:
        DELETE PROCEDURE h-cdapi997 NO-ERROR.
        ASSIGN h-cdapi997 = ?.
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

  assign l-copy = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  if avail deposito then do:
    if deposito.cons-saldo = no then
       assign tg-saldo-mrp:sensitive in frame {&frame-name} = yes.
    else assign tg-saldo-mrp:sensitive in frame {&frame-name} = NO.
  end.
  
  IF deposito.ind-dep-cq:CHECKED IN FRAME {&FRAME-NAME} = NO THEN
    ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  
  IF  input frame {&frame-name} l-log-2 = YES OR
      input frame {&frame-name} tg-wms-externo = YES THEN
      ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
             
  IF  input frame {&frame-name} l-log-2 = YES THEN
      ASSIGN tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             tg-aloca-saldo-ext:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF  input frame {&frame-name} tg-wms-externo = YES THEN
      ASSIGN tg-aloca-saldo-ext:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             l-aloca-saldo-erp:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      ASSIGN  tg-integra-his:CHECKED IN FRAME f-main = NO.
  &ENDIF
  
  apply 'entry' to deposito.cod-depos in frame {&frame-name}.

/*Code placed here will execute AFTER standard behavior. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.
define variable texto-1    as char    no-undo.
define variable texto-2    as char    no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  
&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN  
    DEFINE VARIABLE c-cod-depos   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-descricao   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-classif-dep AS CHARACTER NO-UNDO.
    
&ENDIF

IF CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN DO:

      &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          IF (deposito.log-orig-ext) THEN DO:
             RUN utp/ut-msgs.p (input "show",
                                input 35074,
                                input "").
             RETURN 'adm-error'.
          END.                  
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            IF TRIM(SUBSTRING(deposito.char-1,2,1)) = "S" THEN DO:
               RUN utp/ut-msgs.p (input "show",
                                  input 35074,
                                  input "").
               RETURN 'adm-error'.
            END.
         &ENDIF
      &ENDIF.
  END.
RUN set-cursor IN adm-broker-hdl (INPUT "wait").

for each estabelec fields (cod-estabel) no-lock:
    for first item 
      fields (cod-estabel deposito-pad)
      where item.cod-estabel  = estabelec.cod-estabel and
            item.deposito-pad = deposito.cod-depos 
      no-lock:
        {utp/ut-field.i mgind contabiliza cod-depos 1}
        run utp/ut-msgs.p (input "show",input 3,input return-value).
        return 'ADM-ERROR':U.
    end.
    if can-find (first localizacao
                 where localizacao.cod-depos = deposito.cod-depos
                   and localizacao.cod-estabel = estabelec.cod-estabel) then do:
                run utp/ut-msgs.p(input 'show',input 15830,input "").
       return "adm-error". 
    end. 
end.

for first contabiliza 
  fields (cod-depos) 
  where contabiliza.cod-depos = deposito.cod-depos no-lock:
   {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.

for first param-cp 
  fields (dep-fabrica)
  where param-cp.dep-fabrica = deposito.cod-depos no-lock:
   {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.

if  param-estoq.depos-pad = deposito.cod-depos then do:
    {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.

IF CAN-FIND (FIRST lin-prod NO-LOCK
             WHERE lin-prod.deposito-pad  = deposito.cod-depos) THEN DO:
    {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
END.
if can-find (first saldo-estoq 
             where saldo-estoq.cod-depos = deposito.cod-depos) then do:
    run utp/ut-msgs.p(input 'show',input 6714,input "").
    return "adm-error". 
end. 

/*********** MODULO AQR (Aquisiá∆o Produtos Rurais) *******************/

    if  not available(param-global) then
        find first param-global no-lock no-error.

    IF AVAIL param-global AND substring(param-global.char-2,101,1) = "S" THEN DO:

        IF CAN-FIND(FIRST liber-carg WHERE liber-carg.cod-depos = deposito.cod-depos) THEN DO:

            {utp/ut-table.i mgind deposito 1}
            assign texto-1 = return-value.
            {utp/ut-table.i movind liber-carg 1}
            assign texto-2 = return-value.
            run utp/ut-msgs.p (input "show":U, input 5, input texto-1 + "~~" + texto-2).
            return "adm-error".

        END.

    END.

/*********** FIM MODULO AQR (Aquisiªío Produtos Rurais) **************/

/**************************************** FO-1468.192 *********************************************

Foram retiradas as leituras abaixo para melhoria de performance.


for first reservas fields (cod-depos)
  where reservas.cod-depos = deposito.cod-depos no-lock:
    {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.                      

for first ord-prod fields (cod-depos cod-estabel)
  where ord-prod.cod-depos = deposito.cod-depos no-lock:
    {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.

for first it-nota-fisc 
  fields (cod-depos)
  where it-nota-fisc.cod-depos = deposito.cod-depos no-lock:
    {utp/ut-field.i mgind contabiliza cod-depos 1}
    run utp/ut-msgs.p (input "show",input 3,input return-value).
    return 'ADM-ERROR':U.
end.

*****[ BANCOS HIST‡RICOS ]**********************************************************************************
    if  not available(param-global) then
        find first param-global no-lock no-error.
        
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Deposito deposito.cod-depos '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end. 
************************************************************************************************************/



&if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF CAN-FIND (first unid-negoc-depos
                 where unid-negoc-depos.cod-depos = deposito.cod-depos) THEN DO:
        {utp/ut-field.i mgind contabiliza cod-depos 1}
        run utp/ut-msgs.p (input "show",input 3,input return-value).
        return 'ADM-ERROR':U.
end.
&endif

/*
/********************Multiplanta-SMC***********************/
    for each tt-smc-deposito:
        delete tt-smc-deposito.
    end.    
    assign c-transacao = "SMC011"
           i-tipo-movto = 3.
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    run pi-cria-tt-dados-smc (input i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/******************Fim-Multiplanta-SMC********************/ 

*/
/******Validaá∆o para Frotas*****/

     do i-cont = 1 to 5:
        if i-cont <> 3
        and i-cont <> 4 then do:
            run cdp/cd9902.p (input i-cont).
            if return-value = "OK":U then do:
                assign lValida = yes.
                leave.
            end.
        end.
    end.
    if lValida then do:
        /** Passa o rowid para API de Frotas **/
        run abp/abapi008.p persistent set h-abapi008 (input rowid(deposito)).
        /** ValidaªÑes **/
        run validateDeposito in h-abapi008 (INPUT deposito.cod-depos).
        if return-value = "NOK":U then do:
            for each RowErrorsFrotas exclusive-lock:
                delete RowErrorsFrotas.
            end.
            /** Busca os erros ocorridos em frotas **/
            run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
            assign i-cont = 0.
            /** Se ocorreram erros no produto padrío, busca a última sequºncia **/
            for last tt-erro no-lock:
                assign i-cont = tt-erro.i-sequen.
            end.
            /** Percorre os erros ocorridos em frotas **/
            for each RowErrorsFrotas no-lock:
                /** Cria os erros no produto padrío **/
                create tt-erro.
                assign tt-erro.i-sequen = i-cont + 1
                       tt-erro.cd-erro  = RowErrorsFrotas.ErrorNumber
                       tt-erro.mensagem = RowErrorsFrotas.ErrorDescription
                       i-cont           = tt-erro.i-sequen.
            end.
            empty temp-table RowErrorsFrotas.
            /** Mostra os Erros ocorridos **/
            run cdp/cd0666.w (input table tt-erro).
            /** Elimina a API da memΩria **/
            if valid-handle(h-abapi008) then
                delete procedure h-abapi008.
            return "NOK":U.
        end.
        /** Elimina a API da memΩria **/
        if valid-handle(h-abapi008) then
            delete procedure h-abapi008.
    end.
    /***********************************************************/

&IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx037.p PERSISTENT SET hDBOproxy.
        RUN eliminaDeposito IN hDBOproxy(INPUT deposito.cod-depos,
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

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    ASSIGN c-cod-depos   = deposito.cod-depos
           c-descricao   = deposito.nome
           c-classif-dep = SUBSTRING(deposito.char-1,3,1).
&ENDIF 
   
/*ELIMINA DIRETAMENTE O RELACIONAMENTO USUµRIO X DEP‡SITO (CD1760)*/
FOR EACH usuar-depos EXCLUSIVE-LOCK
   WHERE usuar-depos.cod-depos = deposito.cod-depos: 
    DELETE usuar-depos.
END.

RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

/* Code placed here will execute AFTER standard behavior.    */

RUN set-cursor IN adm-broker-hdl (INPUT "").

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /** Integraá∆o EAI2 **/
    
    IF v_log_eai2_ativado THEN DO:                               
       IF NOT VALID-HANDLE(h-cdapi997) OR
          h-cdapi997:TYPE <> "PROCEDURE":U OR
          h-cdapi997:FILE-NAME <> "cdp/cdapi997.p":U THEN DO:
          RUN cdp/cdapi997.p PERSISTENT SET h-cdapi997. 
       END.
                                                      
       RUN pi-sendDelete IN h-cdapi997 (INPUT c-cod-depos, INPUT c-descricao, INPUT c-classif-dep, OUTPUT TABLE RowErrors).
         
       IF VALID-HANDLE(h-cdapi997) AND
          h-cdapi997:TYPE = "PROCEDURE":U AND
          h-cdapi997:FILE-NAME = "cdp/cdapi997.p":U THEN DO:
          DELETE PROCEDURE h-cdapi997 NO-ERROR.
          ASSIGN h-cdapi997 = ?.
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


  ASSIGN l-log-2:SENSITIVE            IN FRAME {&frame-name} = NO
         tg-wms-externo:SENSITIVE IN FRAME {&frame-name} = NO.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name} = false.
  &endif

  ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&frame-name} = NO.
  ASSIGN tg-aloca-saldo-ext:SENSITIVE IN FRAME {&frame-name} = NO.
  ASSIGN cb-tp-classif-depos:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  ASSIGN rs-tipo-depos:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
 

/*  if deposito.cons-saldo = no then
 *      assign tg-saldo-mrp:sensitive in frame {&frame-name} = yes.
 *   else assign tg-saldo-mrp:sensitive in frame {&frame-name} = no.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  if available deposito then do:
     find first emitente  where ((emitente.identific = 3  
                          or      emitente.identific = 1) 
                          and     emitente.nome-abrev = deposito.nome-abrev) 
                          no-lock no-error.                            
     assign c-nome-emit:screen-value in frame {&frame-name} = if avail emitente then emitente.nome-emit else "":U.

     &if defined (bf_man_sfc_lc) &then
         assign l-recic:checked in frame {&frame-name}      = deposito.log-reciclagem
                tg-saldo-mrp:checked in frame {&frame-name} = deposito.log-ordens-mrp.

     &else
         assign tg-saldo-mrp:checked in frame {&frame-name} = deposito.log-1.
     &endif
  end.

  IF NOT adm-new-record THEN DO:
    if avail deposito and substring(deposito.char-1,3,1) <> "" then do with frame {&frame-name}:
         assign cb-tp-classif-depos:SCREEN-VALUE = {ininc/i02in084.i 04 int(substring(deposito.char-1,3,1))} NO-ERROR.
    end.
    else
        assign cb-tp-classif-depos:SCREEN-VALUE = {ininc/i02in084.i 04 1} NO-ERROR.
    
    /*Tipo Dep¢sito*/
    IF AVAIL deposito THEN DO:
        IF deposito.ind-tipo-dep = 1 THEN
            ASSIGN rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
        ELSE DO:
            IF Substr(deposito.char-1,4,1) = "A" THEN
                ASSIGN rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "3".
            ELSE IF Substr(deposito.char-1,4,1) = "F" THEN
                ASSIGN rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "4".
            ELSE 
                ASSIGN rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2".
        END.
    END.
  END.

  ASSIGN cb-tp-classif-depos:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
         rs-tipo-depos:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

  IF AVAIL deposito THEN DO:
    &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
             tg-integra-his:CHECKED IN FRAME f-main = deposito.log-orig-ext.
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
               tg-integra-his:CHECKED IN FRAME f-main = TRIM(SUBSTRING(deposito.char-1,2,1)) = "S".
         &ENDIF
    &ENDIF
    
  END.
  if available deposito then do:
      &IF "{&mgscm_version}" >= "2.05" &THEN
          IF deposito.log-aloca-qtd-wms = YES THEN
      &ELSE
          IF Substr(deposito.char-1,1,1) = "Y" THEN
      &ENDIF
         ASSIGN  l-aloca-saldo-erp:checked in frame {&frame-name} = true.
      ELSE
         ASSIGN  l-aloca-saldo-erp:checked in frame {&frame-name} = FALSE.
      
  END.

  IF AVAILABLE deposito THEN DO:
      &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
          ASSIGN l-log-2:CHECKED IN FRAME {&FRAME-NAME} = deposito.log-gera-wms.
      &ELSE
          ASSIGN l-log-2:CHECKED IN FRAME {&FRAME-NAME} = deposito.log-2.
      &ENDIF 
      // Validaá∆o WMS SAAS
      IF CAN-FIND (FIRST funcao 
                   WHERE funcao.cd-funcao = "WMS-SAAS"
                     AND funcao.ativo     = YES) THEN DO:
          ASSIGN tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME}     = deposito.log-wms-externo
                 tg-aloca-saldo-ext:CHECKED IN FRAME {&FRAME-NAME} = deposito.log-aloca-saldo-wms-ext.
      END.
      // Fim Validaá∆o WMS SAAS
  END.
  
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

  ASSIGN i-tipo-depos = int(rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif      


    IF l-flag-log-2 = NO THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
            ASSIGN l-log-2 = deposito.log-gera-wms.
        &ELSE
            ASSIGN l-log-2 = deposito.log-2.
        &ENDIF
    END.
    ELSE DO:
        ASSIGN l-log-2:CHECKED IN FRAME {&FRAME-NAME} = NO
               l-flag-log-2 = NO.
    END.

    // Validaá∆o WMS SAAS
   IF CAN-FIND (FIRST funcao 
                WHERE funcao.cd-funcao = "WMS-SAAS"
                  AND funcao.ativo     = YES) THEN DO:
       ASSIGN tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME}     = deposito.log-wms-externo
              tg-aloca-saldo-ext:CHECKED IN FRAME {&FRAME-NAME} = deposito.log-aloca-saldo-wms-ext.
   END.
   // Fim Validaá∆o WMS SAAS

    &IF "{&bf_mat_versao_ems}":U >= "2.04":U &THEN
        &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
            IF  NOT adm-new-record THEN
                ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NOT CAN-FIND (FIRST saldo-estoq
                                                                                WHERE saldo-estoq.cod-depos = INPUT FRAME {&FRAME-NAME} deposito.cod-depos).
        &ELSE
            if  adm-new-record then
                assign l-log-2:sensitive in frame {&frame-name} = 
                       (avail para-fat    and substr(para-fat.char-1,21,1)   = "1") or /*FATURAMENTO*/
                       (avail param-estoq and substr(param-estoq.char-2,6,1) = "1"  or /*RECEBIMENTO*/
                                                     param-estoq.int-1       =  1 ).   /*ESTOQUE*/
            else
                assign l-log-2:sensitive in frame {&frame-name} = 
                       ((avail para-fat    and substr(para-fat.char-1,21,1)   = "1")  or  /*FATURAMENTO*/
                        (avail param-estoq and substr(param-estoq.char-2,6,1) = "1"   or  /*RECEBIMENTO*/
                                                      param-estoq.int-1       =  1 )) and /*ESTOQUE*/
                         not can-find(first saldo-estoq                                   /*n∆o h† saldo no dep¢sito*/
                                      where saldo-estoq.cod-depos = input frame {&frame-name} deposito.cod-depos).
        &ENDIF
    &ENDIF

  if adm-new-record AND l-copy = NO then do:
     ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}  = yes
            deposito.ind-dep-rej:sensitive in frame {&frame-name} = yes
            rs-tipo-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = "1".



  end.
  else do:
      &if defined (bf_man_sfc_lc) &then
            IF (deposito.ind-acabado:checked in frame {&frame-name}  = true 
            OR  deposito.ind-processo:checked in frame {&frame-name} = true
            OR  l-recic:checked in frame {&frame-name}               = true)
            AND not adm-new-record 
            THEN
              ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}  = no
                     deposito.ind-dep-rej:sensitive in frame {&frame-name} = no.
      &else
            IF (deposito.ind-acabado:checked in frame {&frame-name}  = true 
            OR  deposito.ind-processo:checked in frame {&frame-name} = true)
            AND not adm-new-record THEN
                ASSIGN deposito.ind-dep-cq:sensitive in frame {&frame-name}  = no
                       deposito.ind-dep-rej:sensitive in frame {&frame-name} = no.      
      &endif 
  end.     

  if avail deposito then do:
    if deposito.cons-saldo = no then
       assign tg-saldo-mrp:sensitive in frame {&frame-name} = yes.
    else assign tg-saldo-mrp:sensitive in frame {&frame-name} = no.

    IF (l-log-2:CHECKED   IN FRAME {&FRAME-NAME} = YES AND 
        l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES) OR 
       (tg-wms-externo:CHECKED   IN FRAME {&FRAME-NAME} = YES AND 
        tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES) THEN
        ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&frame-name} = YES
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&frame-name}  = NO.
    ELSE 
        ASSIGN l-aloca-saldo-erp:SENSITIVE IN FRAME {&frame-name} = NO
               deposito.ind-dep-cq:SENSITIVE IN FRAME {&frame-name}  = NO.
        
    IF l-log-2:CHECKED IN FRAME {&FRAME-NAME} = NO OR
       tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME} = NO THEN
        ASSIGN deposito.ind-dep-cq:SENSITIVE IN FRAME {&frame-name}  = YES.
  
    IF deposito.ind-dep-cq:CHECKED IN FRAME {&FRAME-NAME} = YES OR 
       l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO OR 
       tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
       ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
    ELSE 
       ASSIGN l-log-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 

    // Validaá∆o WMS SAAS
    IF CAN-FIND (FIRST funcao
                 WHERE funcao.cd-funcao = "WMS-SAAS"
                   AND funcao.ativo     = YES) THEN DO:
        IF tg-wms-externo:CHECKED   IN FRAME {&FRAME-NAME} = YES AND 
           tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN
            assign tg-aloca-saldo-ext:sensitive in frame {&frame-name} = yes.
        else 
            assign tg-aloca-saldo-ext:sensitive in frame {&frame-name} = no.
    END.

    &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
         IF deposito.log-aloca-qtd-wms = YES THEN
    &ELSE
         IF substr(deposito.char-1,1,1) = "Y"  THEN 
    &ENDIF
            ASSIGN l-aloca-saldo-erp:CHECKED IN FRAME {&FRAME-NAME} = YES.
        ELSE 
            ASSIGN l-aloca-saldo-erp:CHECKED IN FRAME {&FRAME-NAME} = NO.
  end.

  ASSIGN cb-tp-classif-depos:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
         rs-tipo-depos:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

  IF (rs-tipo-depos:screen-value in frame {&frame-name} = "1" ) THEN
      ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name}  = false.
  ELSE
      ASSIGN deposito.nome-abrev:sensitive in frame {&frame-name}  = true.

  &if defined (bf_man_sfc_lc) &then
      assign l-recic:sensitive in frame {&frame-name} = yes
             l-recic:hidden in frame {&frame-name}    = no.
  &else
      assign l-recic:sensitive in frame {&frame-name} = no
             l-recic:hidden in frame {&frame-name}    = yes.
  &endif

   /* O usu†rio n∆o poder† modificar o campo descriá∆o quando o deposito teve origem no HIS */
   IF CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-integra-ems-his" AND 
                            funcao.ativo = YES) THEN DO:
       IF NOT adm-new-record THEN DO:
           IF (tg-integra-his:CHECKED IN FRAME {&FRAME-NAME}) THEN DISABLE deposito.nome WITH FRAME {&FRAME-NAME}.
       END.
   END.

   ASSIGN tg-wms-externo:SENSITIVE IN FRAME {&FRAME-NAME} = l-log-2:SENSITIVE IN FRAME {&FRAME-NAME}.
   
   IF l-log-2:CHECKED IN FRAME {&FRAME-NAME} = YES OR
      tg-wms-externo:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
       ASSIGN deposito.ind-dep-cq:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  

   apply "value-changed" to deposito.alocado in frame {&frame-name}.

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
  {utp/ut-liter.i Considera_Saldo_Ordens_MRP *}
  assign tg-saldo-mrp:label in frame {&frame-name} = trim(return-value).

  find first para-fat    no-lock no-error.
  find first param-estoq no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .  

  /* Code placed here will execute AFTER standard behavior.    */

  &if defined (bf_man_sfc_lc) &then
        assign l-recic:hidden in frame {&frame-name} = no.
  &endif

    IF NOT CAN-FIND (FIRST funcao 
       WHERE funcao.cd-funcao = "spp-integra-ems-his"
       AND   funcao.ativo     = YES) THEN DO:
        tg-integra-his:VISIBLE IN FRAME f-main = NO.
        rt-integra:VISIBLE IN FRAME f-main = NO.

        rect-5:HEIGHT IN FRAME f-main = rect-5:HEIGHT IN FRAME f-main + 0.6.
        l-log-2:HEIGHT IN FRAME f-main = l-log-2:HEIGHT IN FRAME f-main + 0.3.
        l-aloca-saldo-erp:HEIGHT IN FRAME f-main = l-aloca-saldo-erp:HEIGHT IN FRAME f-main + 0.5.

        TEXT-3:ROW IN FRAME f-main = TEXT-3:ROW IN FRAME f-main + 0.6.
        rect-6:ROW IN FRAME f-main = rect-6:ROW IN FRAME f-main + 0.6.
        tg-wms-externo:ROW IN FRAME f-main = tg-wms-externo:ROW IN FRAME f-main + 0.5.
        tg-aloca-saldo-ext:ROW IN FRAME f-main = tg-aloca-saldo-ext:ROW IN FRAME f-main + 0.7.

        rect-6:HEIGHT IN FRAME f-main = rect-6:HEIGHT IN FRAME f-main + 0.6.
        tg-wms-externo:HEIGHT IN FRAME f-main = tg-wms-externo:HEIGHT IN FRAME f-main + 0.3.
        tg-aloca-saldo-ext:HEIGHT IN FRAME f-main = tg-aloca-saldo-ext:HEIGHT IN FRAME f-main + 0.3.

    END.

    IF NOT CAN-FIND (FIRST funcao 
       WHERE funcao.cd-funcao = "WMS-SAAS"
       AND   funcao.ativo     = YES) THEN DO:

        ASSIGN TEXT-3:VISIBLE IN FRAME f-main = NO
               RECT-6:VISIBLE IN FRAME f-main = NO
               tg-wms-externo:VISIBLE IN FRAME f-main = NO
               tg-aloca-saldo-ext:VISIBLE IN FRAME f-main = NO.
    END.

    IF (CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-eai2-integra-ems-pims" AND funcao.ativo)) THEN
       ASSIGN cb-tp-classif-depos:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    ELSE  ASSIGN cb-tp-classif-depos:VISIBLE IN FRAME {&FRAME-NAME} = NO. 

    do with frame {&frame-name}:
       DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao002 = {ininc/i02in084.i 3}.
       RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
       assign cb-tp-classif-depos:LIST-ITEM-PAIRS = cAuxTraducao002.     
    end.
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /* Carrega a vari·vel global v_log_eai2_ativado */
        RUN cdp/cd0101i.p. 
    &ENDIF
    
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
  if avail deposito then
      assign gr-deposito = rowid(deposito).

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  ASSIGN l-copy = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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
/*
def input parameter i-tipo-movto as integer.

   if  param-global.modulo-mp and
        tt-replica-msg-SMC.log-replica-msg  = yes then do: 
        create tt-smc-deposito.
        buffer-copy deposito to tt-smc-deposito.
        create tt-dados-env-SMC.                  
        assign tt-dados-env-SMC.num-sequencia  = i-seq
               tt-dados-env-SMC.cod-tipo-reg   = 285
               tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
               tt-dados-env-SMC.identif-msg    = string(deposito.cod-depos).
        raw-transfer tt-smc-deposito to tt-dados-env-SMC.conteudo-msg. 
        assign i-seq = i-seq + 1.                                     
   end.
*/
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
  {src/adm/template/snd-list.i "deposito"}

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

