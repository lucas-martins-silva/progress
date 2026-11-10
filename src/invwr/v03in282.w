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
{include/i-prgvrs.i V03IN282 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN282 MUT}
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
def new global shared var l-erro-v3 as logical no-undo.
def var c-variavel  as char no-undo.
def var wh-variavel as handle no-undo.
def new global shared var gr-param-cq as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES param-cq
&Scoped-define FIRST-EXTERNAL-TABLE param-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cq.idi-skip-lote-produc ~
param-cq.tp-skip-lot param-cq.ins-pref-x[1] param-cq.ins-pref-x[2] ~
param-cq.ins-pref-x[3] param-cq.ins-pref-y[1] param-cq.ins-pref-y[2] ~
param-cq.ins-pref-y[3] param-cq.ins-pref-z[1] param-cq.ins-pref-z[2] ~
param-cq.ins-pref-z[3] param-cq.num-inspec-x-produc ~
param-cq.num-inspec-y-produc param-cq.num-inspec-z-produc 
&Scoped-define ENABLED-TABLES param-cq
&Scoped-define FIRST-ENABLED-TABLE param-cq
&Scoped-Define ENABLED-OBJECTS c-label-criticidade c-label-x c-label-y ~
c-label-z c-label-bom c-label-skip-lote c-label-otimo c-label-excelente ~
c-label-recebimento c-label-manufatura c-label-skip-lote-2 ~
c-label-criticidade-2 c-label-x-2 c-label-y-2 c-label-z-2 c-label-bom-2 ~
rt-mold rt-mold-2 RECT-6 RECT-7 
&Scoped-Define DISPLAYED-FIELDS param-cq.idi-skip-lote-produc ~
param-cq.tp-skip-lot param-cq.ins-pref-x[1] param-cq.ins-pref-x[2] ~
param-cq.ins-pref-x[3] param-cq.ins-pref-y[1] param-cq.ins-pref-y[2] ~
param-cq.ins-pref-y[3] param-cq.ins-pref-z[1] param-cq.ins-pref-z[2] ~
param-cq.ins-pref-z[3] param-cq.num-inspec-x-produc ~
param-cq.num-inspec-y-produc param-cq.num-inspec-z-produc 
&Scoped-define DISPLAYED-TABLES param-cq
&Scoped-define FIRST-DISPLAYED-TABLE param-cq
&Scoped-Define DISPLAYED-OBJECTS c-label-perc-1 c-label-criticidade ~
c-label-perc-2 c-label-perc-3 c-label-perc-4 c-label-perc-5 c-label-perc-6 ~
c-label-perc-7 c-label-perc-8 c-label-perc-9 c-label-x c-label-y c-label-z ~
c-label-bom c-label-skip-lote c-label-otimo c-label-excelente ~
c-label-recebimento c-label-manufatura c-label-skip-lote-2 c-label-perc-10 ~
c-label-perc-11 c-label-perc-12 c-label-criticidade-2 c-label-x-2 ~
c-label-y-2 c-label-z-2 c-label-bom-2 

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
DEFINE VARIABLE c-label-bom AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-bom-2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-criticidade AS CHARACTER FORMAT "X(15)":U INITIAL "Criticidade" 
      VIEW-AS TEXT 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-criticidade-2 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 8.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-excelente AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-manufatura AS CHARACTER FORMAT "X(11)":U 
      VIEW-AS TEXT 
     SIZE 9.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-label-otimo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 6.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-perc-1 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-10 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-11 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-12 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-2 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-3 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-4 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-5 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-6 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-7 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-8 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-perc-9 AS CHARACTER FORMAT "X(2)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-recebimento AS CHARACTER FORMAT "X(11)":U 
      VIEW-AS TEXT 
     SIZE 9.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-label-skip-lote AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 7.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-label-skip-lote-2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 7.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-label-x AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-x-2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 3.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-y AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 2.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-y-2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-z AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 2.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-z-2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 1.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.86 BY 1.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 7.5.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cq.idi-skip-lote-produc AT ROW 2.75 COL 52 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Percentual", 1,
"N£mero de Lotes", 2
          SIZE 25.57 BY 1
     c-label-perc-1 AT ROW 5.13 COL 14.86 COLON-ALIGNED NO-LABEL
     c-label-criticidade AT ROW 4.33 COL 3 NO-LABEL
     c-label-perc-2 AT ROW 6.13 COL 15 COLON-ALIGNED NO-LABEL
     c-label-perc-3 AT ROW 7.13 COL 14.86 COLON-ALIGNED NO-LABEL
     c-label-perc-4 AT ROW 5.13 COL 24.57 COLON-ALIGNED NO-LABEL
     c-label-perc-5 AT ROW 6.13 COL 24.57 COLON-ALIGNED NO-LABEL
     c-label-perc-6 AT ROW 7.13 COL 34.14 COLON-ALIGNED NO-LABEL
     c-label-perc-7 AT ROW 5.13 COL 34.14 COLON-ALIGNED NO-LABEL
     c-label-perc-8 AT ROW 6.13 COL 34.14 COLON-ALIGNED NO-LABEL
     c-label-perc-9 AT ROW 7.13 COL 24.57 COLON-ALIGNED NO-LABEL
     c-label-x AT ROW 5.13 COL 3 NO-LABEL
     c-label-y AT ROW 6.13 COL 3 NO-LABEL
     c-label-z AT ROW 7.13 COL 3 NO-LABEL
     c-label-bom AT ROW 4.33 COL 10 COLON-ALIGNED NO-LABEL
     c-label-skip-lote AT ROW 2.17 COL 2.57 COLON-ALIGNED NO-LABEL
     c-label-otimo AT ROW 4.33 COL 19.43 COLON-ALIGNED NO-LABEL
     c-label-excelente AT ROW 4.25 COL 29 COLON-ALIGNED NO-LABEL
     param-cq.tp-skip-lot AT ROW 2.71 COL 8.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Percentual", 1,
"N£mero de Lotes", 2
          SIZE 25.57 BY 1
     param-cq.ins-pref-x[1] AT ROW 5.13 COL 9.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-x[2] AT ROW 5.13 COL 19.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-x[3] AT ROW 5.13 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-y[1] AT ROW 6.13 COL 9.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-y[2] AT ROW 6.13 COL 19.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-y[3] AT ROW 6.13 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-z[1] AT ROW 7.13 COL 9.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-z[2] AT ROW 7.13 COL 19.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cq.ins-pref-z[3] AT ROW 7.13 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-label-recebimento AT ROW 1 COL 3.86 NO-LABEL
     c-label-manufatura AT ROW 1 COL 46.14 NO-LABEL WIDGET-ID 6
     c-label-skip-lote-2 AT ROW 2.08 COL 44.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     param-cq.num-inspec-x-produc AT ROW 5.13 COL 52.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     param-cq.num-inspec-y-produc AT ROW 6.13 COL 52.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     param-cq.num-inspec-z-produc AT ROW 7.13 COL 52.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-label-perc-10 AT ROW 5.13 COL 57.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     c-label-perc-11 AT ROW 6.25 COL 57.72 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-label-perc-12 AT ROW 7.25 COL 57.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-label-criticidade-2 AT ROW 4.33 COL 45.29 NO-LABEL WIDGET-ID 34
     c-label-x-2 AT ROW 5.13 COL 43.86 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     c-label-y-2 AT ROW 6.21 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     c-label-z-2 AT ROW 7.13 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-label-bom-2 AT ROW 4.25 COL 53 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     rt-mold AT ROW 1.29 COL 2
     rt-mold-2 AT ROW 1.29 COL 44 WIDGET-ID 4
     RECT-6 AT ROW 2.42 COL 3 WIDGET-ID 10
     RECT-7 AT ROW 2.42 COL 45.14 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cq
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
         HEIGHT             = 8.17
         WIDTH              = 85.57.
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

/* SETTINGS FOR FILL-IN c-label-criticidade IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-criticidade-2 IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-manufatura IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-perc-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-perc-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-recebimento IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-x IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-y IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-label-z IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-cq.num-inspec-x-produc IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cq.num-inspec-y-produc IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cq.num-inspec-z-produc IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME param-cq.idi-skip-lote-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cq.idi-skip-lote-produc V-table-Win
ON VALUE-CHANGED OF param-cq.idi-skip-lote-produc IN FRAME f-main /* Skip Lote Produ‡Æo */
DO:
    DEFINE VARIABLE l-hidden  AS LOGICAL NO-UNDO.

    ASSIGN l-hidden = INTEGER(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 2. /* Num Lotes */
    
    ASSIGN c-label-perc-10:HIDDEN IN FRAME {&FRAME-NAME} = l-hidden
           c-label-perc-11:HIDDEN IN FRAME {&FRAME-NAME} = l-hidden
           c-label-perc-12:HIDDEN IN FRAME {&FRAME-NAME} = l-hidden.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cq.tp-skip-lot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cq.tp-skip-lot V-table-Win
ON VALUE-CHANGED OF param-cq.tp-skip-lot IN FRAME f-main /* Skip Lot */
DO:
  if integer(param-cq.tp-skip-lot:screen-value in frame {&FRAME-NAME}) = 1  then
     assign c-label-perc-1:hidden in frame {&FRAME-NAME} = no
            c-label-perc-2:hidden in frame {&FRAME-NAME} = no
            c-label-perc-3:hidden in frame {&FRAME-NAME} = no
            c-label-perc-4:hidden in frame {&FRAME-NAME} = no
            c-label-perc-5:hidden in frame {&FRAME-NAME} = no
            c-label-perc-6:hidden in frame {&FRAME-NAME} = no
            c-label-perc-7:hidden in frame {&FRAME-NAME} = no
            c-label-perc-8:hidden in frame {&FRAME-NAME} = no
            c-label-perc-9:hidden in frame {&FRAME-NAME} = no.

else    if integer(param-cq.tp-skip-lot:screen-value in frame {&FRAME-NAME}) = 2  then
         assign c-label-perc-1:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-2:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-3:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-4:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-5:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-6:hidden in frame {&FRAME-NAME} = yes
         c-label-perc-7:hidden in frame {&FRAME-NAME} = yes
          c-label-perc-8:hidden in frame {&FRAME-NAME} = yes
          c-label-perc-9:hidden in frame {&FRAME-NAME} = yes.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-desabilita V-table-Win 
PROCEDURE adm-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE all WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-habilita V-table-Win 
PROCEDURE adm-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ENABLE all WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "param-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cq"}

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

  define var c-msg-bom-x       as char no-undo.
  define var c-msg-otimo-x     as char no-undo.
  define var c-msg-excelente-x as char no-undo.
  define var c-msg-bom-y       as char no-undo.
  define var c-msg-otimo-y     as char no-undo.
  define var c-msg-excelente-y as char no-undo.
  define var c-msg-bom-z       as char no-undo.
  define var c-msg-otimo-z     as char no-undo.
  define var c-msg-excelente-z as char no-undo.

  /* carga das variaveis das mensagens */
  {utp/ut-liter.i Bom_x * R}
  assign c-msg-bom-x = return-value.

  {utp/ut-liter.i àtimo_x * R}
  assign c-msg-otimo-x = return-value.

  {utp/ut-liter.i Excelente_x * R}
  assign c-msg-excelente-x = return-value.

  {utp/ut-liter.i Bom_y * R}
  assign c-msg-bom-y = return-value.

  {utp/ut-liter.i àtimo_y * R}
  assign c-msg-otimo-y = return-value.

  {utp/ut-liter.i Excelente_y * R}
  assign c-msg-excelente-y = return-value.

  {utp/ut-liter.i Bom_z * R}
  assign c-msg-bom-z = return-value.

  {utp/ut-liter.i àtimo_z * R}
  assign c-msg-otimo-z = return-value.

  {utp/ut-liter.i Excelente_z * R}
  assign c-msg-excelente-z = return-value.
     
  RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-variavel).
  assign wh-variavel = widget-handle(c-variavel).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT string(param-cq.tipo-cq)).

  assign l-erro-v3 = no.
  if string(param-cq.tipo-cq) = "3" then do:

     /* Valor da porcentagem tem que ser menor ou igual a 100 */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-x[1]:screen-value in frame {&FRAME-NAME}) > 100 then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 507,
                           input param-cq.ins-pref-x[1]:screen-value in frame {&FRAME-NAME}).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-x[1].
        return 'adm-error'.
     end.
   
     /* àtimo/x tem que ser menor ou igual a bom/x */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-x[2]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-x[1]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-otimo-x + "~~" + c-msg-bom-x).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-x[2].
        return 'adm-error'.
     end.
   
     /* Excelente/x tem que ser menor ou igual a ¢timo/x */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-x[3]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-x[2]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-excelente-x + "~~" + c-msg-otimo-x).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-x[3].
        return 'adm-error'.
     end.
   
     /* bom/y tem que ser menor ou igual a bom/x */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-y[1]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-x[1]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-bom-y + "~~" + c-msg-bom-x).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-y[1].
        return 'adm-error'.
     end.
   
     /* ¢timo/y tem que ser menor ou igual a bom/y */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-y[2]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-y[1]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-otimo-y + "~~" + c-msg-bom-y).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-y[2].
        return 'adm-error'.
     end.
   
     /* excelente/y tem que ser menor ou igual a ¢timo/y */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-y[3]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-y[2]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-excelente-y + "~~" + c-msg-otimo-y).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-y[3].
        return 'adm-error'.
     end.
   
     /* bom/z tem que ser menor ou igual a bom/y */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-z[1]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-y[1]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-bom-z + "~~" + c-msg-bom-y).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-z[1].
        return 'adm-error'.
     end.
   
     /* ¢timo/z tem que ser menor ou igual a bom/z */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-z[2]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-z[1]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-otimo-z + "~~" + c-msg-bom-z).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-z[2].
        return 'adm-error'.
     end.
   
     /* excelente/z tem que ser menor ou igual a ¢timo/z */
     if integer(param-cq.tp-skip-lot:screen-value   in frame {&FRAME-NAME}) = 1 and 
        integer(param-cq.ins-pref-z[3]:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.ins-pref-z[2]:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v3 = yes.
        run utp/ut-msgs.p (input "show",
                           input 508,
                           input c-msg-excelente-z + "~~" + c-msg-otimo-z).
        run select-page in wh-variavel (3).
        apply 'entry' to param-cq.ins-pref-z[3].
        return 'adm-error'.
     end.


     /* VALIDA€åES SKIP LOTE MANUFATURA */

     /* Bom x deve ser menor que Bom y */
     IF INT(param-cq.num-inspec-y-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > INT(param-cq.num-inspec-x-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
        ASSIGN l-erro-v3 = yes.
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 508,
                           INPUT c-msg-bom-y + "~~" + c-msg-bom-X).
        RUN select-page in wh-variavel (3).
        APPLY 'entry' to param-cq.num-inspec-y-produc.
        RETURN 'adm-error'.
     END.

     /* Bom y deve ser menor que Bom z */
     IF INT(param-cq.num-inspec-z-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > INT(param-cq.num-inspec-y-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
        ASSIGN l-erro-v3 = yes.
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 508,
                           INPUT c-msg-bom-z + "~~" + c-msg-bom-y).
        RUN select-page in wh-variavel (3).
        APPLY 'entry' to param-cq.num-inspec-z-produc.
        RETURN 'adm-error'.
     END.
    
    /*  PERCENTUAL */
    IF INT(param-cq.idi-skip-lote-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 1 THEN DO:
        /* Valor da porcentagem tem que ser menor ou igual a 100 */
        IF INT(param-cq.num-inspec-x-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > 100 THEN DO:
            ASSIGN l-erro-v3 = YES.
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 507,
                               INPUT param-cq.num-inspec-x-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
                               
            RUN select-page in wh-variavel (3).
            APPLY 'entry' to param-cq.num-inspec-x-produc.
            RETURN 'adm-error'.      
        END.

        /* Valor da porcentagem tem que ser menor ou igual a 100 */        
        IF INT(param-cq.num-inspec-y-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > 100 THEN DO:
            ASSIGN l-erro-v3 = YES.
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 507,
                               INPUT param-cq.num-inspec-y-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
                               
            RUN select-page in wh-variavel (3).
            APPLY 'entry' to param-cq.num-inspec-y-produc.
            RETURN 'adm-error'.      
        END.
        /* Valor da porcentagem tem que ser menor ou igual a 100 */
        IF INT(param-cq.num-inspec-z-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > 100 THEN DO:
            ASSIGN l-erro-v3 = YES.
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 507,
                               INPUT param-cq.num-inspec-z-produc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
                               
            RUN select-page in wh-variavel (3).
            APPLY 'entry' to param-cq.num-inspec-z-produc.
            RETURN 'adm-error'.      
        END.
    END.

  END.

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

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
  {utp/ut-liter.i Recebimento * R}
  assign c-label-recebimento:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Manufatura * R}
  assign c-label-manufatura:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgind param-cq tp-skip-lot 1}
  assign c-label-skip-lote:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-skip-lote-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Criticidade * R}
  assign c-label-criticidade:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-criticidade-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Bom * R}
  assign c-label-bom:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-bom-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i àtimo * R}
  assign c-label-otimo:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Excelente * R}
  assign c-label-excelente:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i X * R}
  assign c-label-x:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-x-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Y * R}
  assign c-label-y:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-y-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE. 

  {utp/ut-liter.i Z * R}
  assign c-label-z:screen-value in frame {&FRAME-NAME} = RETURN-VALUE
         c-label-z-2:screen-value in frame {&FRAME-NAME} = RETURN-VALUE.

  if avail param-cq then do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT 'tipo-cq').

    IF return-value = '3' then
       ENABLE ALL WITH FRAME {&frame-name}.
    ELSE 
       DISABLE ALL WITH FRAME {&frame-name}.  
  end.       


  APPLY 'VALUE-CHANGED' TO param-cq.idi-skip-lote-produc IN FRAME {&FRAME-NAME}. 
  APPLY 'VALUE-CHANGED' TO param-cq.tp-skip-lot          IN FRAME {&FRAME-NAME}. 

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

  if avail param-cq then
     assign gr-param-cq = rowid(param-cq).

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "param-cq"}

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

