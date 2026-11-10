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
{include/i-prgvrs.i V04IN287 2.00.00.029} /*** "010029" 01/10/2026 14:36:39 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v04in287 MUT}
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

/* Local Variable Definitions ---                                       */
def new global shared var l-inclui as logical no-undo.
DEF NEW GLOBAL SHARED VAR l-erro   AS LOGICAL NO-UNDO.
def var l-tem-movto as logical no-undo.
def var l-ok as logical.
def var l-ifrs-contab-estoq as log    no-undo.
def var lIntegracaoEMS5     as log    no-undo.
DEF VAR h-boin863           AS HANDLE NO-UNDO.
DEF VAR hShowMsg            AS HANDLE NO-UNDO.
DEF VAR hProgramZoom        AS HANDLE NO-UNDO.
DEF VAR l-conectou-ems5     AS LOG    NO-UNDO.
DEFINE VARIABLE c-lb-msg   AS CHARACTER   NO-UNDO.

DEF SHARED VAR c-lb-gerencial AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR c-lb-cod-cenario-ma-1 AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR c-lb-cod-cenario-ma-2 AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR l-ifrs-ma1 AS LOGICAL NO-UNDO.
DEF SHARED VAR l-ifrs-ma2 AS LOGICAL NO-UNDO.

{cdp/cdcfgmat.i}
{inbo/boin863.i tt-estab-mater-cenar-aux}
{btb/btb009za.i}
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */

/*Temp-table EMS5 - Retorna cen†rios cont†beis v†lidos*/
def temp-table tt_cenar_ctbl_ems5 no-undo
         field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
         field tta_des_cenar_ctbl               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
         field tta_log_cenar_ifrs               as logical format "Sim/N∆o" initial no label "Cen†rio IFRS" column-label "Cen†rio IFRS"
         field tta_log_cenar_fisc               as logical format "Sim/N∆o" initial no label "Cen†rio Fiscal" column-label "Cen†rio Fiscal"
         field ttv_log_permis_cenar_usuar       as logical format "Sim/N∆o" initial no
        .
def temp-table tt_erro_fgl no-undo
         field ttv_num_erro_fgl                 as integer format "9999999"
         field ttv_des_erro_fgl                 as character format "x(100)"
         field ttv_des_arq_erro                 as character format "x(100)"
         field ttv_log_ctbz                     as logical format "Sim/N∆o" initial yes label "Contabiliza Movto" column-label "Contabiliza Movto"
            .
DEF TEMP-TABLE tt-estab-mater-cenar LIKE tt-estab-mater-cenar-aux
    FIELD i-tipo-trans AS INTEGER. /*1-inclus∆o/alteraá∆o, 2-eliminaá∆o*/

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.moeda1 param-estoq.moeda2 ~
param-estoq.tp-ct-moeda1 param-estoq.tp-ct-moeda2 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 RECT-12 RECT-13 RECT-14 ~
RECT-15 rect-func l-moeda-func c-cenar-func i-cdn-moed-orig i-moeda-func ~
i-moeda-real-func 
&Scoped-Define DISPLAYED-FIELDS param-estoq.tem-moeda1 ~
param-estoq.tem-moeda2 param-estoq.moeda1 param-estoq.moeda2 ~
param-estoq.tp-ct-moeda1 param-estoq.tp-ct-moeda2 
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
&Scoped-Define DISPLAYED-OBJECTS c-moeda1 c-moeda2 l-ifrs-ma-1 l-ifrs-ma-2 ~
c-cod-cenario-ma-1 c-cod-cenario-ma-2 l-moeda-func c-cenar-func i-cdn-moed-orig ~
i-moeda-func c-desc-func i-moeda-real-func c-desc-real-func 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS param-estoq.tem-moeda1 ~
param-estoq.tem-moeda2 
&Scoped-define ADM-ASSIGN-FIELDS param-estoq.tem-moeda1 ~
param-estoq.tem-moeda2 
&Scoped-define ADM-MODIFY-FIELDS param-estoq.tem-moeda1 ~
param-estoq.tem-moeda2 

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
DEFINE VARIABLE c-cenar-func AS CHARACTER FORMAT "X(8)":U 
     LABEL "Cen†rio" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cenario-ma-1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo Cen†rio IFRS MA1" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-cenario-ma-2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo Cen†rio IFRS MA2" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-func AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-real-func AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE text-moeda-origem AS CHARACTER FORMAT "X(256)":U INITIAL "Moeda Origem:" 
   VIEW-AS TEXT 
  SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE i-moeda-func AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Funcional" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda-real-func AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Real Societ†rio" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-moed-orig AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "", 1,
"", 2
     SIZE 16 BY 1.96 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.75.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.71.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.71.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 4.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 4.5.

DEFINE RECTANGLE rect-func
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 3.75.

DEFINE VARIABLE l-ifrs-ma-1 AS LOGICAL INITIAL no 
     LABEL "IFRS Moeda Alternativa 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE l-ifrs-ma-2 AS LOGICAL INITIAL no 
     LABEL "IFRS Moeda Alternativa 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE l-moeda-func AS LOGICAL INITIAL no 
     LABEL "Tem Moeda Funcional" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-estoq.tem-moeda1 AT ROW 1.5 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .88
     param-estoq.tem-moeda2 AT ROW 1.5 COL 47.29
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .88
     param-estoq.moeda1 AT ROW 3.5 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda1 AT ROW 3.5 COL 25.72 COLON-ALIGNED NO-LABEL
     param-estoq.moeda2 AT ROW 3.5 COL 64.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda2 AT ROW 3.5 COL 68.86 COLON-ALIGNED NO-LABEL
     l-ifrs-ma-1 AT ROW 4.5 COL 9
     l-ifrs-ma-2 AT ROW 4.5 COL 52
     c-cod-cenario-ma-1 AT ROW 5.5 COL 25.57 COLON-ALIGNED
     c-cod-cenario-ma-2 AT ROW 5.5 COL 68.57 COLON-ALIGNED
     param-estoq.tp-ct-moeda1 AT ROW 8.5 COL 13.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di†ria", 1,
"Mensal", 2,
"MÇdia", 3
          SIZE 29.29 BY .83
     param-estoq.tp-ct-moeda2 AT ROW 8.5 COL 57.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di†ria", 1,
"Mensal", 2,
"MÇdia", 3
          SIZE 29.29 BY .83
     l-moeda-func AT ROW 9.83 COL 3.29 WIDGET-ID 4
     c-cenar-func AT ROW 10.63 COL 51.14 COLON-ALIGNED WIDGET-ID 16
     i-cdn-moed-orig AT ROW 10.79 COL 16.29 NO-LABEL WIDGET-ID 20
     i-moeda-func AT ROW 11.63 COL 50.86 COLON-ALIGNED WIDGET-ID 8
     c-desc-func AT ROW 11.63 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     i-moeda-real-func AT ROW 12.63 COL 50.86 COLON-ALIGNED WIDGET-ID 10
     c-desc-real-func AT ROW 12.63 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-5 AT ROW 7.75 COL 1.29 COLON-ALIGNED NO-LABEL
     FILL-IN-6 AT ROW 7.75 COL 45.29 COLON-ALIGNED NO-LABEL
    text-moeda-origem AT ROW 11 COL 2.86 NO-LABEL WIDGET-ID 18
     RECT-10 AT ROW 8 COL 1
     RECT-11 AT ROW 1 COL 1
     RECT-12 AT ROW 8 COL 45
     RECT-13 AT ROW 1 COL 45
     RECT-14 AT ROW 3 COL 1
     RECT-15 AT ROW 3 COL 45
     rect-func AT ROW 10.25 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
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
         HEIGHT             = 13
         WIDTH              = 86.86.
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

/* SETTINGS FOR FILL-IN c-cod-cenario-ma-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-cenario-ma-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-func IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-real-func IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX l-ifrs-ma-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-ifrs-ma-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX param-estoq.tem-moeda1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX param-estoq.tem-moeda2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME c-cenar-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cenar-func V-table-Win
ON F5 OF c-cenar-func IN FRAME f-main /* Cen†rio */
DO:
  
   {method/zoomfields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="c-cenar-func"
          &Frame1="f-main"
          &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cenar-func V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cenar-func IN FRAME f-main /* Cen†rio */
DO:
  APPLY "F5" TO c-cenar-func IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cenario-ma-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-1 V-table-Win
ON F5 OF c-cod-cenario-ma-1 IN FRAME f-main /* C¢digo Cen†rio IFRS MA1 */
DO:
      
   {method/zoomfields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="c-cod-cenario-ma-1"
          &Frame1="f-main"
          &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cenario-ma-1 IN FRAME f-main /* C¢digo Cen†rio IFRS MA1 */
DO:
  APPLY "F5" TO c-cod-cenario-ma-1 IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-1 V-table-Win
ON LEAVE OF c-cod-cenario-ma-1 IN FRAME f-main /* C¢digo Cen†rio IFRS MA1 */
DO:

  IF (c-lb-gerencial <> "" OR param-estoq.cod-cenar-geren <> "") AND l-ifrs-ma-1 = YES THEN DO:
    ASSIGN c-lb-cod-cenario-ma-1 = c-cod-cenario-ma-1:SCREEN-VALUE IN FRAME f-main.
    IF (c-cod-cenario-ma-1:SCREEN-VALUE IN FRAME f-main = c-lb-gerencial) 
    OR (c-cod-cenario-ma-1:SCREEN-VALUE IN FRAME f-main = param-estoq.cod-cenar-geren)
    THEN DO:
         run utp/ut-msgs.p (input "show":U, 
                                input 57731, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
         ASSIGN l-erro = YES.
         return "adm-error".
    END.
    
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cenario-ma-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-2 V-table-Win
ON F5 OF c-cod-cenario-ma-2 IN FRAME f-main /* C¢digo Cen†rio IFRS MA2 */
DO:
   {method/zoomfields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="c-cod-cenario-ma-2"
          &Frame1="f-main"
          &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cenario-ma-2 IN FRAME f-main /* C¢digo Cen†rio IFRS MA2 */
DO:
  APPLY "F5" TO c-cod-cenario-ma-2 IN FRAME {&FRAME-NAME}.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-2 V-table-Win
ON leave OF c-cod-cenario-ma-2 IN FRAME f-main /* C¢digo Cen†rio IFRS MA2 */
DO:
  IF (c-lb-gerencial <> "" OR param-estoq.cod-cenar-geren <> "") AND l-ifrs-ma-2 = YES THEN DO:
  
    ASSIGN c-lb-cod-cenario-ma-2 = c-cod-cenario-ma-2:SCREEN-VALUE IN FRAME f-main.
    IF (c-cod-cenario-ma-2:SCREEN-VALUE IN FRAME f-main = c-lb-gerencial) 
    OR (c-cod-cenario-ma-2:SCREEN-VALUE IN FRAME f-main = param-estoq.cod-cenar-geren)
    THEN DO:
         run utp/ut-msgs.p (input "show":U, 
                                input 57731, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
         ASSIGN l-erro = YES.
         return "adm-error".
    END.
    
  END. 
END.

&Scoped-define SELF-NAME c-cenar-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cenar-func V-table-Win
ON F5 OF c-cenar-func IN FRAME f-main /* Cen†rio Funcional */
DO:
   {method/zoomfields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="c-cenar-func"
          &Frame1="f-main"
          &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-func V-table-Win
ON F5 OF i-moeda-func IN FRAME f-main /* Moeda Funcional */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=i-moeda-func
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-func V-table-Win
ON LEAVE OF i-moeda-func IN FRAME f-main /* Moeda Funcional */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-func
                   &where="moeda.mo-codigo = input frame {&frame-name} i-moeda-func"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-func V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-moeda-func IN FRAME f-main /* Moeda Funcional */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda-real-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-real-func V-table-Win
ON F5 OF i-moeda-real-func IN FRAME f-main /* Moeda Real Societ†rio */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=i-moeda-real-func
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-real-func V-table-Win
ON LEAVE OF i-moeda-real-func IN FRAME f-main /* Moeda Real Societ†rio */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-real-func
                   &where="moeda.mo-codigo = input frame {&frame-name} i-moeda-real-func"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-real-func V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-moeda-real-func IN FRAME f-main /* Moeda Real Societ†rio */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ifrs-ma-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ifrs-ma-1 V-table-Win
ON VALUE-CHANGED OF l-ifrs-ma-1 IN FRAME f-main /* IFRS Moeda Alternativa 1 */
DO:
  if input frame {&frame-name} l-ifrs-ma-1 = yes THEN DO:
     ENABLE c-cod-cenario-ma-1 with frame {&frame-name}. 
     ASSIGN l-ifrs-ma1 = yes.
  END.
  else do:
      ASSIGN c-cod-cenario-ma-1:SCREEN-VALUE IN FRAME {&frame-name} = ""
             l-ifrs-ma1 = NO.
      disable c-cod-cenario-ma-1 with frame {&frame-name}. 
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ifrs-ma-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ifrs-ma-2 V-table-Win
ON VALUE-CHANGED OF l-ifrs-ma-2 IN FRAME f-main /* IFRS Moeda Alternativa 2 */
DO:
  if input frame {&frame-name} l-ifrs-ma-2 = yes then do:
     assign l-ifrs-ma2 = yes.
     ENABLE c-cod-cenario-ma-2 with frame {&frame-name}. 
  end.
  else do:
      ASSIGN c-cod-cenario-ma-2:SCREEN-VALUE IN FRAME {&frame-name} = ""
             l-ifrs-ma2 = no.
      disable c-cod-cenario-ma-2 with frame {&frame-name}. 
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-moeda-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-moeda-func V-table-Win
ON VALUE-CHANGED OF l-moeda-func IN FRAME f-main /* Tem Moeda Funcional */
DO:
  IF INPUT FRAME {&FRAME-NAME} l-moeda-func = YES THEN DO:

      /*SE OS PARAMETROS TEM MOEDA ALTERNATIVA 1 E TEM MOEDA ALTERNATIVA 2 ESTIVEREM MARCADOS, HABILITA MOEDA ORIGEM*/
      IF input frame {&frame-name} param-estoq.tem-moeda1 = YES AND input frame {&frame-name} param-estoq.tem-moeda2 = YES THEN     
        ENABLE i-cdn-moed-orig WITH FRAME {&FRAME-NAME}.
            
      ENABLE c-cenar-func
             i-moeda-func
             i-moeda-real-func 
             WITH FRAME {&FRAME-NAME}. 
  END.
  ELSE DO:
      ASSIGN c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             c-desc-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             c-desc-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      DISABLE c-cenar-func
              i-moeda-func
              i-moeda-real-func 
              i-cdn-moed-orig WITH FRAME {&FRAME-NAME}. 
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.moeda1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON F5 OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.moeda1
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON LEAVE OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda1
                   &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.moeda1"}
  RUN pi-moeda.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.moeda2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON F5 OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.moeda2
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON LEAVE OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda2
                   &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.moeda2"} 
  RUN pi-moeda.                 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.tem-moeda1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.tem-moeda1 V-table-Win
ON VALUE-CHANGED OF param-estoq.tem-moeda1 IN FRAME f-main /* Tem Moeda Alternativa 1 */
DO:
  if input frame {&frame-name} param-estoq.tem-moeda1 = yes then
     enable param-estoq.moeda1
            param-estoq.tp-ct-moeda1 
            l-ifrs-ma-1 with frame {&frame-name}. 
  else disable param-estoq.moeda1
               param-estoq.tp-ct-moeda1
               l-ifrs-ma-1 with frame {&frame-name}. 

  RUN pi-moeda.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.tem-moeda2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.tem-moeda2 V-table-Win
ON VALUE-CHANGED OF param-estoq.tem-moeda2 IN FRAME f-main /* Tem Moeda Alternativa 2 */
DO:
  if input frame {&frame-name} param-estoq.tem-moeda2 = yes then
     enable param-estoq.moeda2
            param-estoq.tp-ct-moeda2 
            l-ifrs-ma-2 with frame {&frame-name}. 
  else disable param-estoq.moeda2
               param-estoq.tp-ct-moeda2 
               l-ifrs-ma-2 with frame {&frame-name}. 

  RUN pi-moeda.

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

if param-estoq.moeda1:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if param-estoq.moeda2:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if c-cod-cenario-ma-1:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if c-cod-cenario-ma-2:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.

if i-moeda-func:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if i-moeda-real-func:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if c-cenar-func:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.

{utp/ut-liter.i Tem_Moeda_Funcional * R}
assign l-moeda-func:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Moeda_Origem: * R}
assign text-moeda-origem:screen-value in frame {&frame-name} = return-value.

{utp/ut-liter.i Moeda_Real_Societ†rio * R}
assign i-moeda-real-func:label in frame {&frame-name} = return-value.


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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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

  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 fill-in-5}
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 fill-in-6}
  

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
    run pi-validate.
    if  return-value = "ADM-ERROR":U then
        undo, return "ADM-ERROR":U.
    if l-ifrs-contab-estoq and lIntegracaoEMS5 AND AVAIL param-estoq then do: /*IFRS e Integraá∆o EMS5*/
        &if "{&bf_mat_versao_ems}" < "2.08" &THEN
            assign overlay(param-estoq.char-2,8,1) = if l-ifrs-ma-1:checked in frame {&frame-name} then "S":U else "N":U
                   overlay(param-estoq.char-2,9,1) = if l-ifrs-ma-2:checked in frame {&frame-name} then "S":U else "N":U
                   overlay(param-estoq.char-2,10,8) = c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME} 
                   overlay(param-estoq.char-2,18,8) = c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME}.
        &else
            assign param-estoq.log-moed-ifrs-1 = l-ifrs-ma-1:checked in frame {&frame-name}
                   param-estoq.log-moed-ifrs-2 = l-ifrs-ma-2:checked in frame {&frame-name}
                   param-estoq.cod-cenar-ifrs-1 = c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME} 
                   param-estoq.cod-cenar-ifrs-2 = c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME}.
        &endif
    end.

    IF lIntegracaoEMS5 AND AVAIL param-estoq THEN
        ASSIGN OVERLAY(param-estoq.char-2,86,8)  = c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
               OVERLAY(param-estoq.char-2,95,1)  = i-cdn-moed-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
               OVERLAY(param-estoq.char-2,96,2)  = i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
               OVERLAY(param-estoq.char-2,98,2)  = i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
               OVERLAY(param-estoq.char-2,100,1) = IF l-moeda-func:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
 
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 fill-in-5}
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 fill-in-6}
  if available param-estoq then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
            assign c-moeda1 = if avail moeda then 
                                       moeda.descricao 
                              else     "":U.
        find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
            assign c-moeda2 = if avail moeda then
                                       moeda.descricao 
                              else     "":U.
        if l-ifrs-contab-estoq AND lIntegracaoEMS5 THEN DO: /*Funá∆o IFRS*/
            &if "{&bf_mat_versao_ems}" < "2.08" &THEN
                assign l-ifrs-ma-1 = IF param-estoq.tem-moeda1 THEN substring(param-estoq.char-2,8,1) = "S":U ELSE NO
                       l-ifrs-ma-2 = IF param-estoq.tem-moeda2 THEN substring(param-estoq.char-2,9,1) = "S":U ELSE NO
                       c-cod-cenario-ma-1 = IF param-estoq.tem-moeda1 THEN substring(param-estoq.char-2,10,8) ELSE ""
                       c-cod-cenario-ma-2 = IF param-estoq.tem-moeda2 THEN substring(param-estoq.char-2,18,8) ELSE "".
            &else
                assign l-ifrs-ma-1 = IF param-estoq.tem-moeda1 THEN param-estoq.log-moed-ifrs-1 ELSE NO
                       l-ifrs-ma-2 = IF param-estoq.tem-moeda2 THEN param-estoq.log-moed-ifrs-2 ELSE NO
                       c-cod-cenario-ma-1 = IF param-estoq.tem-moeda1 THEN param-estoq.cod-cenar-ifrs-1 ELSE ""
                       c-cod-cenario-ma-2 = IF param-estoq.tem-moeda2 THEN param-estoq.cod-cenar-ifrs-2 ELSE "".
            &endif
        END.
        IF lIntegracaoEMS5 THEN
            ASSIGN l-moeda-func      = IF SUBSTRING(param-estoq.char-2,100,1) = "S":U THEN YES ELSE NO
                   c-cenar-func      = SUBSTRING(param-estoq.char-2,86,8)
                   i-cdn-moed-orig       = INT(SUBSTRING(param-estoq.char-2,95,1))
                   i-moeda-func      = INT(SUBSTRING(param-estoq.char-2,96,2))
                   i-moeda-real-func = INT(SUBSTRING(param-estoq.char-2,98,2)).
  end.
  ELSE DO:
        ASSIGN c-moeda1 = ""
               c-moeda2 = ""
               l-ifrs-ma-1 = NO 
               l-ifrs-ma-2 = NO 
               l-moeda-func = NO
               c-cod-cenario-ma-1 = ""
               c-cod-cenario-ma-2 = ""
               c-cenar-func = ""
               i-moeda-func = 0
               i-moeda-real-func = 0.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  if available param-estoq then do:
      if param-estoq.tem-moeda1 = no then do:
          assign param-estoq.moeda1:screen-value in frame {&frame-name} = ""
                 c-moeda1:screen-value           in frame {&frame-name} = ""
                 l-ifrs-ma-1:CHECKED             in frame {&frame-name} = NO
                 c-cod-cenario-ma-1:screen-value in frame {&frame-name} = "".
      end.
      if param-estoq.tem-moeda2 = no then do:
          assign param-estoq.moeda2:screen-value in frame {&frame-name} = ""
                 c-moeda2:screen-value           in frame {&frame-name} = ""
                 l-ifrs-ma-2:CHECKED             in frame {&frame-name} = NO
                 c-cod-cenario-ma-2:screen-value in frame {&frame-name} = "".
      end.

      /*SE O PARAMETRO TEM MOEDA ALTERNATIVA 1 OU TEM MOEDA ALTERNATIVA 2 ESTIVER MARCADO, HABILITA O PARAMETRO TEM MOEDA FUNCIONAL, SEN√O DESABILITA*/
      IF  input frame {&frame-name} param-estoq.tem-moeda1 = YES OR input frame {&frame-name} param-estoq.tem-moeda2 = yes THEN
           l-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = YES.        
      ELSE
          l-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         
   
      IF l-ifrs-contab-estoq AND lIntegracaoEMS5 then do: /*funá‰es: IFRS ativa e integraá∆o contabilidade EMS 5.00 ativa*/
          assign l-ifrs-ma-1:sensitive in frame {&FRAME-NAME} =  param-estoq.tem-moeda1
                 l-ifrs-ma-2:sensitive in frame {&FRAME-NAME} =  param-estoq.tem-moeda2
                 c-cod-cenario-ma-1:sensitive IN FRAME {&FRAME-NAME} =  param-estoq.tem-moeda1 AND l-ifrs-ma-1:CHECKED in frame {&FRAME-NAME}
                 c-cod-cenario-ma-2:sensitive IN FRAME {&FRAME-NAME} =  param-estoq.tem-moeda2 AND l-ifrs-ma-2:CHECKED in frame {&FRAME-NAME}.
      end.
      else do:
          assign l-ifrs-ma-1:sensitive in frame {&FRAME-NAME} =  no
                 l-ifrs-ma-2:sensitive in frame {&FRAME-NAME} =  no
                 c-cod-cenario-ma-1:sensitive IN FRAME {&FRAME-NAME} =  no
                 c-cod-cenario-ma-2:sensitive IN FRAME {&FRAME-NAME} =  no.
      end.

      IF lIntegracaoEMS5 AND SUBSTRING(param-estoq.char-2,100,1) = "S":U THEN DO:
          ASSIGN c-cenar-func:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                 i-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                 i-moeda-real-func:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                 i-cdn-moed-orig:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

          FOR FIRST moeda FIELDS(descricao) WHERE moeda.mo-codigo = i-moeda-func NO-LOCK: END.
          ASSIGN c-desc-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL moeda THEN moeda.descricao ELSE "":U.

          FOR FIRST moeda FIELDS(descricao) WHERE moeda.mo-codigo = i-moeda-real-func NO-LOCK: END.
          ASSIGN c-desc-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL moeda THEN moeda.descricao ELSE "":U.
      END.
      ELSE 
          ASSIGN c-cenar-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 i-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 i-moeda-real-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 l-moeda-func:CHECKED IN FRAME {&FRAME-NAME} = NO
                 c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-cdn-moed-orig:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  end. 
  ELSE DO:
          ASSIGN param-estoq.moeda1:screen-value in frame {&frame-name} = ""
                 c-moeda1:screen-value           in frame {&frame-name} = ""
                 l-ifrs-ma-1:CHECKED             in frame {&frame-name} = NO
                 c-cod-cenario-ma-1:screen-value in frame {&frame-name} = ""
                 param-estoq.moeda2:screen-value in frame {&frame-name} = ""
                 c-moeda2:screen-value           in frame {&frame-name} = ""
                 l-ifrs-ma-2:CHECKED             in frame {&frame-name} = NO
                 c-cod-cenario-ma-2:screen-value in frame {&frame-name} = ""
                 l-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 l-ifrs-ma-1:sensitive in frame {&FRAME-NAME} =  NO
                 l-ifrs-ma-2:sensitive in frame {&FRAME-NAME} =  NO
                 c-cod-cenario-ma-1:sensitive IN FRAME {&FRAME-NAME} =  NO
                 c-cod-cenario-ma-2:sensitive IN FRAME {&FRAME-NAME} =  NO
                 c-cenar-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 i-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 i-moeda-real-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 l-moeda-func:CHECKED IN FRAME {&FRAME-NAME} = NO
                 c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 i-cdn-moed-orig:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                 c-desc-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 c-desc-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          DISABLE c-cenar-func
                  i-moeda-func
                  i-moeda-real-func 
                  i-cdn-moed-orig WITH FRAME {&FRAME-NAME}.                 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 fill-in-5}
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 fill-in-6}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST param-estoq NO-LOCK NO-ERROR.
  FIND FIRST param-global NO-LOCK NO-ERROR.
  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 fill-in-5}
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 fill-in-6}
  
  /*Funá∆o IFRS*/
  assign l-ifrs-contab-estoq = yes
  
  /*Integraá∆o Contabilidade EMS5*/
         lIntegracaoEMS5 =  CAN-FIND(first funcao 
                                     WHERE funcao.cd-funcao = "adm-fgl-ems-5.00"
                                       AND funcao.ativo = YES
                                       AND funcao.log-1 = YES).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-moeda.

  FIND FIRST item-estab  NO-LOCK NO-ERROR.
  FIND FIRST movto-estoq USE-INDEX nr-trans NO-LOCK NO-ERROR.
  FIND FIRST saldo-estoq NO-LOCK NO-ERROR.

  IF AVAIL item-estab
  OR AVAIL movto-estoq
  OR AVAIL saldo-estoq THEN
      ASSIGN l-tem-movto = YES.
  ELSE
      ASSIGN l-tem-movto = NO.

   /* Code placed here will execute AFTER standard behavior.    */
  IF AVAIL param-estoq THEN DO:
    ASSIGN param-estoq.moeda1:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
           param-estoq.moeda2:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
           param-estoq.tem-moeda1:SENSITIVE     IN FRAME {&frame-name} = NOT(l-tem-movto)
           param-estoq.tem-moeda2:SENSITIVE     IN FRAME {&frame-name} = NOT(l-tem-movto)
           param-estoq.tp-ct-moeda1:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
           param-estoq.tp-ct-moeda2:SENSITIVE   IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
    ASSIGN param-estoq.moeda1:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
           param-estoq.moeda2:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
           param-estoq.tem-moeda1:SENSITIVE     IN FRAME {&frame-name} = YES
           param-estoq.tem-moeda2:SENSITIVE     IN FRAME {&frame-name} = YES
           param-estoq.tp-ct-moeda1:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
           param-estoq.tp-ct-moeda2:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
           c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           c-desc-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           c-desc-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    DISABLE c-cenar-func
            i-moeda-func
            i-moeda-real-func 
            i-cdn-moed-orig WITH FRAME {&FRAME-NAME}.
  END.

  IF param-estoq.tem-moeda1:CHECKED = NO THEN DO:
      ASSIGN param-estoq.moeda1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                       c-moeda1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
  END.
  ELSE DO:
      IF l-tem-movto = NO THEN
          ENABLE param-estoq.moeda1
                 param-estoq.tp-ct-moeda1  WITH FRAME {&FRAME-NAME}.
      ELSE 
          DISABLE param-estoq.moeda1
                  param-estoq.tp-ct-moeda1 WITH FRAME {&FRAME-NAME}. 
  END.                 

  IF param-estoq.tem-moeda2:CHECKED = NO THEN DO:
      ASSIGN param-estoq.moeda2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                       c-moeda2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
  END.
  ELSE DO:
      IF l-tem-movto = NO THEN
          ENABLE param-estoq.moeda2
                 param-estoq.tp-ct-moeda2  WITH FRAME {&FRAME-NAME}.
      ELSE 
          DISABLE param-estoq.moeda2
                  param-estoq.tp-ct-moeda2 WITH FRAME {&FRAME-NAME}. 
  END.                 
  
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 fill-in-5}
  {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 fill-in-6}

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-conecta-ems50 V-table-Win 
PROCEDURE Pi-conecta-ems50 :
def input param i-conect as integer no-undo.
    DEF VAR h-btb009za AS HANDLE NO-UNDO.
    find first param-global no-lock no-error.
    if not valid-handle (h-btb009za) or
       h-btb009za:TYPE <> "PROCEDURE":U or
       h-btb009za:FILE-NAME <> "btb/btb009za.p":U  then
       RUN btb/btb009za.p PERSISTENT SET h-btb009za.
    
    if i-conect = 1 then do:
       if not connected("emsbas") or 
          not connected("emsuni") or 
          not connected("emsfin") then do:          
         
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U AND 
               AVAIL param-global then do:
               ASSIGN l-conectou-ems5 = YES.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.
        else
    end.
    else do:
        if connected("emsbas") or 
           connected("emsfin") or 
           connected("emsuni") then do:
           
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U AND 
               AVAIL param-global then do:
               ASSIGN l-conectou-ems5 = NO.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.    
    end.
    
    if valid-handle(h-btb009za) then do:
        delete procedure h-btb009za no-error.
        assign h-btb009za = ?.
    end.
    if return-value <> "OK":U then do:
        FIND FIRST tt_erros_conexao NO-ERROR.
        IF AVAIL tt_erros_conexao THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input tt_erros_conexao.cd-erro, 
                               INPUT tt_erros_conexao.param-1).

            assign l-erro = yes.
            undo, return "NOK":U.
        END.
    end.    
    RETURN "OK":U.

End Procedure. /*Pi-conecta-ems50*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-estab-mater-cenar V-table-Win 
PROCEDURE pi-cria-estab-mater-cenar :
/*------------------------------------------------------------------------------
  Purpose:    Cria relacionamento Estab X Cen†rio
  Notes:       
------------------------------------------------------------------------------*/
    
EMPTY TEMP-TABLE tt-estab-mater-cenar.
IF l-ifrs-ma-1:checked in frame {&frame-name} OR l-ifrs-ma-2:checked in frame {&frame-name} THEN DO:
    FOR EACH tt_cenar_ctbl_ems5 
       WHERE tt_cenar_ctbl_ems5.tta_log_cenar_fisc 
          OR tt_cenar_ctbl_ems5.tta_log_cenar_ifrs :
        
        FOR EACH estab-mat NO-LOCK:
            CREATE tt-estab-mater-cenar.
            ASSIGN tt-estab-mater-cenar.cod-estab      = estab-mat.cod-estabel
                   tt-estab-mater-cenar.cod-cenar-ctbl = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl
                   tt-estab-mater-cenar.log-cenar-fisc = tt_cenar_ctbl_ems5.tta_log_cenar_fisc
                   tt-estab-mater-cenar.log-cenar-ifrs = tt_cenar_ctbl_ems5.tta_log_cenar_ifrs.

            IF c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME} = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl AND
               l-ifrs-ma-1:checked in frame {&frame-name}  THEN
                ASSIGN tt-estab-mater-cenar.cdn-moeda    = 1
                       tt-estab-mater-cenar.i-tipo-trans = 1. /*inclus∆o/modificaá∆o*/
            ELSE IF c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME} = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl AND
               l-ifrs-ma-2:checked in frame {&frame-name}  THEN
                ASSIGN tt-estab-mater-cenar.cdn-moeda = 2
                       tt-estab-mater-cenar.i-tipo-trans = 1. /*inclus∆o/modificaá∆o*/
            ELSE 
                IF tt-estab-mater-cenar.log-cenar-ifrs THEN
                    ASSIGN tt-estab-mater-cenar.i-tipo-trans = 2. /*Eliminaá∆o*/
                ELSE
                    ASSIGN tt-estab-mater-cenar.cdn-moeda = 0
                           tt-estab-mater-cenar.i-tipo-trans = 1. /*inclus∆o/modificaá∆o*/ 
    
            IF param-estoq.tp-fech = 2 THEN /*Fechamento por Estabelecimento*/
                ASSIGN tt-estab-mater-cenar.contab-ate = estab-mat.contab-ate.
            ELSE
                ASSIGN tt-estab-mater-cenar.contab-ate = param-estoq.contab-ate.

            IF  l-moeda-func:CHECKED IN FRAME {&FRAME-NAME} THEN DO:

                IF  tt-estab-mater-cenar.log-cenar-ifrs THEN DO:
                    IF INT(param-estoq.moeda1:screen-value IN FRAME {&FRAME-NAME}) = int(i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN
                        ASSIGN tt-estab-mater-cenar.cdn-moeda = 2.
                    ELSE
                        ASSIGN tt-estab-mater-cenar.cdn-moeda = 1.
                END.

            END.

        END.
    END.
END.
ELSE DO:
    FOR EACH estab-mater-cenar NO-LOCK:
        CREATE tt-estab-mater-cenar.
        BUFFER-COPY estab-mater-cenar TO tt-estab-mater-cenar NO-ERROR.
        ASSIGN tt-estab-mater-cenar.i-tipo-trans = 2. /*Eliminaá∆o*/
    END.
END.

IF CAN-FIND (FIRST tt-estab-mater-cenar) THEN DO:
    if  not valid-handle (h-boin863) then
        run inbo/boin863.p persistent set h-boin863.

    FOR EACH tt-estab-mater-cenar:
        EMPTY TEMP-TABLE tt-estab-mater-cenar-aux.

        CREATE tt-estab-mater-cenar-aux.
        BUFFER-COPY tt-estab-mater-cenar TO tt-estab-mater-cenar-aux NO-ERROR.

        RUN openQueryStatic IN h-boin863 (INPUT "Main":U).
        RUN goToKey         IN h-boin863 (INPUT tt-estab-mater-cenar-aux.cod-estab, 
                                          INPUT tt-estab-mater-cenar-aux.cod-cenar-ctbl).
        IF (l-ifrs-ma-1:checked in frame {&frame-name} 
            OR l-ifrs-ma-2:checked in frame {&frame-name}) 
            AND tt-estab-mater-cenar.i-tipo-trans = 1  THEN DO: /*inclus∆o/alteraá∆o*/
            IF RETURN-VALUE = "NOK":U THEN DO:
                run emptyRowErrors in h-boin863.
                run setRecord in h-boin863 (input table tt-estab-mater-cenar-aux).
                                
                run createRecord in h-boin863.
                if  return-value = "NOK" then
                        run getRowErrors in h-boin863 (output table RowErrors append).
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &modal="YES"}
                    {method/showmessage.i3}
                    RUN destroy IN h-boin863.
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
            ELSE DO:
                run emptyRowErrors in h-boin863.
                run setRecord in h-boin863 (input table tt-estab-mater-cenar-aux).
                                
                run updateRecord in h-boin863.
                if  return-value = "NOK" then
                        run getRowErrors in h-boin863 (output table RowErrors append).
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &modal="YES"}
                    {method/showmessage.i3}
                    RUN destroy IN h-boin863.
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
        END.
        ELSE IF RETURN-VALUE <> "NOK":U THEN DO:
            run emptyRowErrors in h-boin863.
            run setRecord in h-boin863 (input table tt-estab-mater-cenar-aux).
            run deleteRecord in h-boin863.
            if  return-value = "NOK" then
                run getRowErrors in h-boin863 (output table RowErrors append).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                IF NOT CAN-FIND(FIRST RowErrors
                        WHERE (RowErrors.ErrorType = "INTERNAL":U) AND
                              (RowErrors.ErrorNumber = 10)) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &modal="YES"}
                    {method/showmessage.i3}
                    RUN destroy IN h-boin863.
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
        END.
    END.
    
    EMPTY TEMP-TABLE tt-estab-mater-cenar.

    if  valid-handle (h-boin863) then do:
        delete procedure h-boin863.
        assign h-boin863 = ?.
    end.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-moeda V-table-Win 
PROCEDURE pi-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-desc-moeda AS CHARACTER EXTENT 2 NO-UNDO.
  DEF VAR i-moeda-base         AS INT                NO-UNDO.
                 
  IF AVAIL param-estoq THEN DO:

      ASSIGN i-cdn-moed-orig = INT(SUBSTRING(param-estoq.char-2,95,1)) 
             i-moeda-base    = i-cdn-moed-orig NO-ERROR.

      IF param-estoq.tem-moeda2:CHECKED IN FRAME {&frame-name} THEN
      DO:
         FIND moeda WHERE mo-codigo = int(param-estoq.moeda2:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
         IF AVAILABLE moeda THEN
            ASSIGN c-desc-moeda[2] = moeda.descricao
                   i-cdn-moed-orig = IF i-moeda-base = 0 THEN 2 ELSE i-cdn-moed-orig.             
      END.
      ELSE
      DO:
         {utp/ut-liter.i N∆o_Existe * R}
         ASSIGN c-desc-moeda[2] = RETURN-VALUE.
      END.
    
      IF param-estoq.tem-moeda1:CHECKED IN FRAME {&frame-name} THEN
      DO:
         FIND moeda WHERE mo-codigo = int(param-estoq.moeda1:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
         IF AVAILABLE moeda THEN
            ASSIGN c-desc-moeda[1] = moeda.descricao
                   i-cdn-moed-orig = IF i-moeda-base = 0 THEN 1 ELSE i-cdn-moed-orig.          
      END.
      ELSE
      DO:
         {utp/ut-liter.i N∆o_Existe * R}
          ASSIGN c-desc-moeda[1] = RETURN-VALUE.
      END.
    
      ASSIGN i-cdn-moed-orig:RADIO-BUTTONS IN FRAME {&frame-name} = c-desc-moeda[1] + ",1," + c-desc-moeda[2] + ",2".
    
      DISPLAY i-cdn-moed-orig WITH FRAME {&frame-name}.

      IF NOT param-estoq.tem-moeda1 OR NOT param-estoq.tem-moeda2 THEN
         ASSIGN i-cdn-moed-orig :SENSITIVE IN FRAME {&frame-name} = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/* -----------------------------------------------------------
  Purpose:     Validaá∆o executada no momento da gravaá∆o dos
               dados na base
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 DEFINE VARIABLE i-mo-fasb  AS INTEGER     NO-UNDO.
 DEFINE VARIABLE i-mo-cmi   AS INTEGER     NO-UNDO.
 DEFINE VARIABLE l-fasb     AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE l-cmi      AS LOGICAL     NO-UNDO.
 define variable v_hdl_cenar as handle     no-undo.

 ASSIGN l-erro = NO.
 {cep/ce9990.i} /*FASB*/ 
 {cep/ce9991.i}/*CMI*/
 if lIntegracaoEMS5 and 
    l-ifrs-contab-estoq then do: /*Integraá∆o Contabilizaá∆o e Funá∆o IFRS*/
     if l-ifrs-ma-1:checked in frame {&frame-name} and
        ((l-fasb and                 /*Moeda parametrizada como Fasb*/
          i-mo-fasb = 2) or          /*Moeda1 = moeda Fasb */
        (l-cmi  and                  /*Moeda parametrizada como CMI*/
         i-mo-cmi = 2)) then do:     /*Moeda1 = moeda CMI */

        run utp/ut-msgs.p (input "show":U, 
                          input 51923, 
                          input INPUT frame {&frame-name} c-moeda1).
        ASSIGN l-erro = YES.
        return "adm-error".
     end.
     if l-ifrs-ma-2:checked in frame {&frame-name} and
        ((l-fasb and               /*Moeda parametrizada como Fasb*/
          i-mo-fasb = 3) or        /*Moeda2 = moeda Fasb */         
         (l-cmi  and               /*Moeda parametrizada como CMI*/ 
          i-mo-cmi = 3)) then do:  /*Moeda2 = moeda CMI */          
        run utp/ut-msgs.p (input "show":U, 
                          input 51923, 
                          input INPUT frame {&frame-name} c-moeda2).
        ASSIGN l-erro = YES.
        return "adm-error".
     end.

     Run  pi-conecta-ems50( 1). /*Conecta bancos EMS5*/
     IF RETURN-VALUE = "NOK":U THEN
         RETURN "adm-error".
     ELSE DO:
         run prgfin/fgl/fgl920za.py persistent set v_hdl_cenar.
    
         run  pi_main_retorna_cenar_ctbl_empres_1 in v_hdl_cenar(input i-ep-codigo-usuario,
                                                             input today,
                                                             output table tt_cenar_ctbl_ems5,
                                                             output table tt_erro_fgl).
         delete procedure v_hdl_cenar.
         assign v_hdl_cenar = ?.
    
         if  c-cod-cenario-ma-1:sensitive IN FRAME {&FRAME-NAME} and
             not can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME}) then do:
             {utp/ut-liter.i "Cen†rio Cont†bil"}
             run utp/ut-msgs.p (input "show":U, 
                               input 2, 
                               INPUT return-value + "~~" + c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME}).
             ASSIGN l-erro = YES.
             return "adm-error".
         end.
         ELSE IF can-find (first tt_cenar_ctbl_ems5
                           where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME}
                            AND NOT tt_cenar_ctbl_ems5.tta_log_cenar_ifrs) THEN DO:
            {utp/ut-liter.i "Cen†rio Cont†bil n∆o Ç IFRS"}
                ASSIGN c-lb-msg = RETURN-VALUE.
            {utp/ut-liter.i "O Cen†rio Cont†bil informado n∆o est† parametrizado como IFRS."}
             run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               INPUT c-lb-msg + "~~" + RETURN-VALUE).
             ASSIGN l-erro = YES.
             return "adm-error".

         END.
         if  c-cod-cenario-ma-2:sensitive IN FRAME {&FRAME-NAME} and
             not can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME}) then do:
             {utp/ut-liter.i "Cen†rio Cont†bil"}
             run utp/ut-msgs.p (input "show":U, 
                               input 2, 
                               INPUT return-value + "~~" + c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME}).
             ASSIGN l-erro = YES.
             return "adm-error".
         end.
         ELSE IF can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME}
                            AND NOT tt_cenar_ctbl_ems5.tta_log_cenar_ifrs) THEN DO:
             {utp/ut-liter.i "Cen†rio Cont†bil n∆o Ç IFRS"}
                ASSIGN c-lb-msg = RETURN-VALUE.
             {utp/ut-liter.i "O Cen†rio Cont†bil informado n∆o est† parametrizado como IFRS."}
              run utp/ut-msgs.p (input "show":U, 
                                input 17006, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
              ASSIGN l-erro = YES.
              return "adm-error".

         END.
         
         IF AVAIL param-estoq THEN DO:

             IF (c-lb-gerencial <> "" OR param-estoq.cod-cenar-geren <> "") AND (l-ifrs-ma1 = YES OR l-ifrs-ma2 = YES) THEN DO:
               IF (c-cod-cenario-ma-1:screen-value IN FRAME f-main = c-lb-gerencial) 
               OR (c-cod-cenario-ma-2:screen-value IN FRAME f-main = c-lb-gerencial)
               OR (c-cod-cenario-ma-1:screen-value IN FRAME f-main = param-estoq.cod-cenar-geren)
               OR (c-cod-cenario-ma-2:screen-value IN FRAME f-main = param-estoq.cod-cenar-geren)
               THEN DO:
                    run utp/ut-msgs.p (input "show":U, 
                                          input 57731, 
                                          INPUT c-lb-msg + "~~" + RETURN-VALUE).
                    ASSIGN l-erro = YES.
                    return "adm-error".
               END.
             END.
             
         END.

         IF  c-cenar-func:SENSITIVE IN FRAME {&FRAME-NAME} AND 
             NOT CAN-FIND (FIRST tt_cenar_ctbl_ems5
                           WHERE tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cenar-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
             {utp/ut-liter.i "Cen†rio_Funcional"}
             RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 2, 
                                INPUT RETURN-VALUE).
             ASSIGN l-erro = YES.
             RETURN "adm-error".
         END.
            
         IF  c-cod-cenario-ma-1:screen-value IN FRAME {&FRAME-NAME} = c-cod-cenario-ma-2:screen-value IN FRAME {&FRAME-NAME} AND
             l-ifrs-ma-1:checked in frame {&frame-name} AND
             l-ifrs-ma-2:checked in frame {&frame-name} AND
             i-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN DO:
             {utp/ut-liter.i "Cen†rio Cont†bil j† informado"}
                ASSIGN c-lb-msg = RETURN-VALUE.
             {utp/ut-liter.i "N∆o Ç permitido cadastrar o mesmo Cen†rio Cont†bil para as duas moedas alternativas."}
              run utp/ut-msgs.p (input "show":U, 
                                input 17006, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
              ASSIGN l-erro = YES.
              return "adm-error".
         END.
         RUN pi-cria-estab-mater-cenar.
     END.
     IF l-conectou-ems5 THEN
        Run  pi-conecta-ems50( 2). /*Desconecta bancos EMS5*/


     IF l-moeda-func:CHECKED IN FRAME {&FRAME-NAME} THEN DO:

         FIND moeda WHERE mo-codigo = int(param-estoq.moeda1:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
         IF NOT AVAILABLE moeda THEN DO:
             {utp/ut-liter.i "Moeda_Funcional"}                                    
             run utp/ut-msgs.p (input "msg",                                           
                                input 495,                                              
                                input return-value).
             ASSIGN l-erro = YES.
             RETURN "adm-error".
         END.

         FIND moeda WHERE mo-codigo = int(param-estoq.moeda2:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
         IF NOT AVAILABLE moeda THEN DO:
             {utp/ut-liter.i "Moeda_Alternativa_2"}                                    
             run utp/ut-msgs.p (input "msg",                                           
                                input 495,                                              
                                input return-value).
             ASSIGN l-erro = YES.
             RETURN "adm-error".
         END.

     END.

     IF  i-moeda-func:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO: 

         IF NOT CAN-FIND (FIRST moeda
                       WHERE moeda.mo-codigo = INT(i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:

             {utp/ut-liter.i "Moeda_Funcional"}
             RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 2, 
                                INPUT RETURN-VALUE).
             ASSIGN l-erro = YES.
             RETURN "adm-error".

         END.

         /*Moeda funcional, deve ser uma das moedas alternativas*/
         IF INT(i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> int(param-estoq.moeda1:SCREEN-VALUE IN FRAME {&frame-name}) AND
            INT(i-moeda-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> int(param-estoq.moeda2:SCREEN-VALUE IN FRAME {&frame-name}) THEN DO:

             RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 55975, 
                                INPUT "").
             ASSIGN l-erro = YES.
             RETURN "adm-error".

         END.
     
     END.

     IF  i-moeda-real-func:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
     
         IF NOT CAN-FIND (FIRST moeda
                       WHERE moeda.mo-codigo = INT(i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:

             {utp/ut-liter.i "Moeda_Real_Funcional"}
             RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 2, 
                                INPUT RETURN-VALUE).
             ASSIGN l-erro = YES.
             RETURN "adm-error".

         END.

         IF INT(i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> int(param-estoq.moeda1:SCREEN-VALUE IN FRAME {&frame-name}) AND
            INT(i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> int(param-estoq.moeda2:SCREEN-VALUE IN FRAME {&frame-name}) AND 
            INT(i-moeda-real-func:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:

             RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 55976, 
                                INPUT "").
             ASSIGN l-erro = YES.
             RETURN "adm-error".

         END.

     END.

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
  {src/adm/template/snd-list.i "param-estoq"}

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

