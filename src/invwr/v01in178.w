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
{include/i-prgvrs.i V01IN178 2.00.00.017}  /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN178 MUT}
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

{cdp/cdcfgman.i} /* Pre-processadores */
{cdp/cdcfgmat.i}
{cdp/cd0669.i}

/* Local Variable Definitions ---                                       */
def new global shared var gr-item-fornec as rowid no-undo.
DEFINE VARIABLE h_v01in178 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h_cq0104 AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-mod AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cont-ant AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-cancela AS LOGICAL     NO-UNDO.

def temp-table tt-old-item-fornec like item-fornec .

/*************************  Multi-Planta ************************************/
def var  i-tipo-movto   as integer    no-undo.
def var  l-cria         as logical    no-undo.

{cdp/cd7300.i1}
/********************** Fim Multi-Planta ************************************/
def temp-table tt-estabel no-undo
    field cod-estabel  as char
    field cod-emitente as int
    field log-exporta as log format "*/ "
    index codigo is primary unique cod-estabel
    index exporta log-exporta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-fornec
&Scoped-define FIRST-EXTERNAL-TABLE item-fornec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-fornec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-fornec.tp-inspecao 
&Scoped-define ENABLED-TABLES item-fornec
&Scoped-define FIRST-ENABLED-TABLE item-fornec
&Scoped-define DISPLAYED-TABLES item-fornec
&Scoped-define FIRST-DISPLAYED-TABLE item-fornec
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-fornec.tp-inspecao ~
item-fornec.it-codigo item-fornec.cod-emitente 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-item-un c-des-emitente ~
cb-aval-insp-1 cb-aval-insp-2 cb-aval-insp-3 cb-aval-insp-4 cb-aval-insp-5 ~
cb-aval-insp-6 cb-aval-insp-7 cb-aval-insp-8 cb-aval-insp-9 cb-aval-insp-10 ~
cb-aval-insp-11 cb-aval-insp-12 cb-aval-insp-13 cb-aval-insp-14 ~
cb-aval-insp-15 cb-aval-insp-16 cb-aval-insp-17 cb-aval-insp-18 ~
cb-aval-insp-19 cb-aval-insp-20 cb-aval-insp-21 cb-aval-insp-22 ~
cb-aval-insp-23 cb-aval-insp-24 cb-aval-insp-25 cb-aval-insp-26 ~
cb-aval-insp-27 cb-aval-insp-28 cb-aval-insp-29 cb-aval-insp-30 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-fornec.it-codigo ~
item-fornec.cod-emitente cb-aval-insp-1 cb-aval-insp-2 cb-aval-insp-3 ~
cb-aval-insp-4 cb-aval-insp-5 cb-aval-insp-6 cb-aval-insp-7 cb-aval-insp-8 ~
cb-aval-insp-9 cb-aval-insp-10 cb-aval-insp-11 cb-aval-insp-12 ~
cb-aval-insp-13 cb-aval-insp-14 cb-aval-insp-15 cb-aval-insp-16 ~
cb-aval-insp-17 cb-aval-insp-18 cb-aval-insp-19 cb-aval-insp-20 ~
cb-aval-insp-21 cb-aval-insp-22 cb-aval-insp-23 cb-aval-insp-24 ~
cb-aval-insp-25 cb-aval-insp-26 cb-aval-insp-27 cb-aval-insp-28 ~
cb-aval-insp-29 cb-aval-insp-30 
&Scoped-define ADM-ASSIGN-FIELDS cb-aval-insp-1 cb-aval-insp-2 ~
cb-aval-insp-3 cb-aval-insp-4 cb-aval-insp-5 cb-aval-insp-6 cb-aval-insp-7 ~
cb-aval-insp-8 cb-aval-insp-9 cb-aval-insp-10 cb-aval-insp-11 ~
cb-aval-insp-12 cb-aval-insp-13 cb-aval-insp-14 cb-aval-insp-15 ~
cb-aval-insp-16 cb-aval-insp-17 cb-aval-insp-18 cb-aval-insp-19 ~
cb-aval-insp-20 cb-aval-insp-21 cb-aval-insp-22 cb-aval-insp-23 ~
cb-aval-insp-24 cb-aval-insp-25 cb-aval-insp-26 cb-aval-insp-27 ~
cb-aval-insp-28 cb-aval-insp-29 cb-aval-insp-30 
&Scoped-define ADM-MODIFY-FIELDS cb-aval-insp-1 cb-aval-insp-2 ~
cb-aval-insp-3 cb-aval-insp-4 cb-aval-insp-5 cb-aval-insp-6 cb-aval-insp-7 ~
cb-aval-insp-8 cb-aval-insp-9 cb-aval-insp-10 cb-aval-insp-11 ~
cb-aval-insp-12 cb-aval-insp-13 cb-aval-insp-14 cb-aval-insp-15 ~
cb-aval-insp-16 cb-aval-insp-17 cb-aval-insp-18 cb-aval-insp-19 ~
cb-aval-insp-20 cb-aval-insp-21 cb-aval-insp-22 cb-aval-insp-23 ~
cb-aval-insp-24 cb-aval-insp-25 cb-aval-insp-26 cb-aval-insp-27 ~
cb-aval-insp-28 cb-aval-insp-29 cb-aval-insp-30 

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
DEFINE VARIABLE cb-aval-insp-1 AS CHARACTER FORMAT "X(22)":U 
     LABEL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-10 AS CHARACTER FORMAT "X(22)":U 
     LABEL "10" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-11 AS CHARACTER FORMAT "X(22)":U 
     LABEL "11" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-12 AS CHARACTER FORMAT "X(22)":U 
     LABEL "12" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-13 AS CHARACTER FORMAT "X(22)":U 
     LABEL "13" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-14 AS CHARACTER FORMAT "X(22)":U 
     LABEL "14" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-15 AS CHARACTER FORMAT "X(22)":U 
     LABEL "15" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-16 AS CHARACTER FORMAT "X(22)":U 
     LABEL "16" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-17 AS CHARACTER FORMAT "X(22)":U 
     LABEL "17" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-18 AS CHARACTER FORMAT "X(22)":U 
     LABEL "18" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-19 AS CHARACTER FORMAT "X(22)":U 
     LABEL "19" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-2 AS CHARACTER FORMAT "X(22)":U 
     LABEL "2" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-20 AS CHARACTER FORMAT "X(22)":U 
     LABEL "20" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-21 AS CHARACTER FORMAT "X(22)":U 
     LABEL "21" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-22 AS CHARACTER FORMAT "X(22)":U 
     LABEL "22" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-23 AS CHARACTER FORMAT "X(22)":U 
     LABEL "23" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-24 AS CHARACTER FORMAT "X(22)":U 
     LABEL "24" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-25 AS CHARACTER FORMAT "X(22)":U 
     LABEL "25" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-26 AS CHARACTER FORMAT "X(22)":U 
     LABEL "26" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-27 AS CHARACTER FORMAT "X(22)":U 
     LABEL "27" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-28 AS CHARACTER FORMAT "X(22)":U 
     LABEL "28" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-29 AS CHARACTER FORMAT "X(22)":U 
     LABEL "29" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-3 AS CHARACTER FORMAT "X(22)":U 
     LABEL "3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-30 AS CHARACTER FORMAT "X(22)":U 
     LABEL "30" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-4 AS CHARACTER FORMAT "X(22)":U 
     LABEL "4" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-5 AS CHARACTER FORMAT "X(22)":U 
     LABEL "5" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-6 AS CHARACTER FORMAT "X(22)":U 
     LABEL "6" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-7 AS CHARACTER FORMAT "X(22)":U 
     LABEL "7" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-8 AS CHARACTER FORMAT "X(22)":U 
     LABEL "8" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-aval-insp-9 AS CHARACTER FORMAT "X(22)":U 
     LABEL "9" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-emitente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-un AS CHARACTER FORMAT "X(4)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE TEXT-1 AS CHARACTER FORMAT "X(40)":U 
      VIEW-AS TEXT 
     SIZE 37.57 BY .88 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(40)":U 
      VIEW-AS TEXT 
     SIZE 37.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     text-2 AT ROW 3.42 COL 2 COLON-ALIGNED NO-LABEL
     TEXT-1 AT ROW 5.46 COL 2 COLON-ALIGNED NO-LABEL
     item-fornec.tp-inspecao AT ROW 4.25 COL 8 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Severa", 1,
"Normal", 2,
"Atenuada", 3,
"Pref Bom", 4,
"Pref àtimo", 5,
"Pref Excelente", 6
          SIZE 75.86 BY .75
     item-fornec.it-codigo AT ROW 1.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 1.17 COL 42 COLON-ALIGNED NO-LABEL
     c-item-un AT ROW 1.17 COL 79.57 COLON-ALIGNED NO-LABEL
     item-fornec.cod-emitente AT ROW 2.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-des-emitente AT ROW 2.17 COL 37 COLON-ALIGNED NO-LABEL
     cb-aval-insp-1 AT ROW 6.71 COL 2 COLON-ALIGNED
     cb-aval-insp-2 AT ROW 8 COL 2 COLON-ALIGNED
     cb-aval-insp-3 AT ROW 9.33 COL 2 COLON-ALIGNED
     cb-aval-insp-4 AT ROW 10.71 COL 2 COLON-ALIGNED
     cb-aval-insp-5 AT ROW 12.04 COL 2 COLON-ALIGNED
     cb-aval-insp-6 AT ROW 13.38 COL 2 COLON-ALIGNED
     cb-aval-insp-7 AT ROW 6.67 COL 19 COLON-ALIGNED
     cb-aval-insp-8 AT ROW 8 COL 19 COLON-ALIGNED
     cb-aval-insp-9 AT ROW 9.33 COL 19 COLON-ALIGNED
     cb-aval-insp-10 AT ROW 10.71 COL 19 COLON-ALIGNED
     cb-aval-insp-11 AT ROW 12.04 COL 19 COLON-ALIGNED
     cb-aval-insp-12 AT ROW 13.38 COL 19 COLON-ALIGNED
     cb-aval-insp-13 AT ROW 6.67 COL 37 COLON-ALIGNED
     cb-aval-insp-14 AT ROW 8 COL 37 COLON-ALIGNED
     cb-aval-insp-15 AT ROW 9.33 COL 37 COLON-ALIGNED
     cb-aval-insp-16 AT ROW 10.71 COL 37 COLON-ALIGNED
     cb-aval-insp-17 AT ROW 12.04 COL 37 COLON-ALIGNED
     cb-aval-insp-18 AT ROW 13.38 COL 37 COLON-ALIGNED
     cb-aval-insp-19 AT ROW 6.67 COL 55 COLON-ALIGNED
     cb-aval-insp-20 AT ROW 8 COL 55 COLON-ALIGNED
     cb-aval-insp-21 AT ROW 9.33 COL 55 COLON-ALIGNED
     cb-aval-insp-22 AT ROW 10.71 COL 55 COLON-ALIGNED
     cb-aval-insp-23 AT ROW 12.04 COL 55 COLON-ALIGNED
     cb-aval-insp-24 AT ROW 13.38 COL 55 COLON-ALIGNED
     cb-aval-insp-25 AT ROW 6.67 COL 73 COLON-ALIGNED
     cb-aval-insp-26 AT ROW 8 COL 73 COLON-ALIGNED
     cb-aval-insp-27 AT ROW 9.33 COL 73 COLON-ALIGNED
     cb-aval-insp-28 AT ROW 10.71 COL 73 COLON-ALIGNED
     cb-aval-insp-29 AT ROW 12.04 COL 73 COLON-ALIGNED
     cb-aval-insp-30 AT ROW 13.38 COL 73 COLON-ALIGNED
     RECT-1 AT ROW 6 COL 1
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-fornec
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
         HEIGHT             = 13.79
         WIDTH              = 88.57.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-10 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-11 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-12 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-13 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-14 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-15 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-16 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-17 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-18 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-19 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-20 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-21 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-22 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-23 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-24 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-25 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-26 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-27 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-28 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-29 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-30 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-4 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-5 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-6 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-7 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-8 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-aval-insp-9 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item-fornec.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item-fornec.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN TEXT-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN            
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF         

  {utp/ut-rtlbl.i mgind item-fornec aval-insp text-1}
  {utp/ut-rtlbl.i mgind item-fornec tp-inspecao text-2}

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
  {src/adm/template/row-list.i "item-fornec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-fornec"}

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
  for each tt-old-item-fornec:
      delete tt-old-item-fornec.
  end.

  create tt-old-item-fornec.
  buffer-copy item-fornec to tt-old-item-fornec.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
   assign input frame {&frame-name} cb-aval-insp-1 item-fornec.aval-insp[1] = {ininc/i01in178.i 06 cb-aval-insp-1}
         input frame {&frame-name} cb-aval-insp-2 item-fornec.aval-insp[2] = {ininc/i01in178.i 06 cb-aval-insp-2}
         input frame {&frame-name} cb-aval-insp-3 item-fornec.aval-insp[3] = {ininc/i01in178.i 06 cb-aval-insp-3}
         input frame {&frame-name} cb-aval-insp-4 item-fornec.aval-insp[4] = {ininc/i01in178.i 06 cb-aval-insp-4}
         input frame {&frame-name} cb-aval-insp-5 item-fornec.aval-insp[5] = {ininc/i01in178.i 06 cb-aval-insp-5}
         input frame {&frame-name} cb-aval-insp-6 item-fornec.aval-insp[6] = {ininc/i01in178.i 06 cb-aval-insp-6}
         input frame {&frame-name} cb-aval-insp-7 item-fornec.aval-insp[7] = {ininc/i01in178.i 06 cb-aval-insp-7}
         input frame {&frame-name} cb-aval-insp-8 item-fornec.aval-insp[8] = {ininc/i01in178.i 06 cb-aval-insp-8}
         input frame {&frame-name} cb-aval-insp-9 item-fornec.aval-insp[9] = {ininc/i01in178.i 06 cb-aval-insp-9}
         input frame {&frame-name} cb-aval-insp-10 item-fornec.aval-insp[10] = {ininc/i01in178.i 06 cb-aval-insp-10}.
  assign input frame {&frame-name} cb-aval-insp-11 item-fornec.aval-insp[11] = {ininc/i01in178.i 06 cb-aval-insp-11}
         input frame {&frame-name} cb-aval-insp-12 item-fornec.aval-insp[12] = {ininc/i01in178.i 06 cb-aval-insp-12}
         input frame {&frame-name} cb-aval-insp-13 item-fornec.aval-insp[13] = {ininc/i01in178.i 06 cb-aval-insp-13}
         input frame {&frame-name} cb-aval-insp-14 item-fornec.aval-insp[14] = {ininc/i01in178.i 06 cb-aval-insp-14}
         input frame {&frame-name} cb-aval-insp-15 item-fornec.aval-insp[15] = {ininc/i01in178.i 06 cb-aval-insp-15}
         input frame {&frame-name} cb-aval-insp-16 item-fornec.aval-insp[16] = {ininc/i01in178.i 06 cb-aval-insp-16}
         input frame {&frame-name} cb-aval-insp-17 item-fornec.aval-insp[17] = {ininc/i01in178.i 06 cb-aval-insp-17}
         input frame {&frame-name} cb-aval-insp-18 item-fornec.aval-insp[18] = {ininc/i01in178.i 06 cb-aval-insp-18}
         input frame {&frame-name} cb-aval-insp-19 item-fornec.aval-insp[19] = {ininc/i01in178.i 06 cb-aval-insp-19}
         input frame {&frame-name} cb-aval-insp-20 item-fornec.aval-insp[20] = {ininc/i01in178.i 06 cb-aval-insp-20}.
  assign input frame {&frame-name} cb-aval-insp-21 item-fornec.aval-insp[21] = {ininc/i01in178.i 06 cb-aval-insp-21}
         input frame {&frame-name} cb-aval-insp-22 item-fornec.aval-insp[22] = {ininc/i01in178.i 06 cb-aval-insp-22}
         input frame {&frame-name} cb-aval-insp-23 item-fornec.aval-insp[23] = {ininc/i01in178.i 06 cb-aval-insp-23}
         input frame {&frame-name} cb-aval-insp-24 item-fornec.aval-insp[24] = {ininc/i01in178.i 06 cb-aval-insp-24}
         input frame {&frame-name} cb-aval-insp-25 item-fornec.aval-insp[25] = {ininc/i01in178.i 06 cb-aval-insp-25}
         input frame {&frame-name} cb-aval-insp-26 item-fornec.aval-insp[26] = {ininc/i01in178.i 06 cb-aval-insp-26}
         input frame {&frame-name} cb-aval-insp-27 item-fornec.aval-insp[27] = {ininc/i01in178.i 06 cb-aval-insp-27}
         input frame {&frame-name} cb-aval-insp-28 item-fornec.aval-insp[28] = {ininc/i01in178.i 06 cb-aval-insp-28}
         input frame {&frame-name} cb-aval-insp-29 item-fornec.aval-insp[29] = {ininc/i01in178.i 06 cb-aval-insp-29}
         input frame {&frame-name} cb-aval-insp-30 item-fornec.aval-insp[30] = {ininc/i01in178.i 06 cb-aval-insp-30}.
         
  /* atualilza tabelas */
  find first param-global no-lock no-error.
  if avail param-global then do:
     if param-global.modulo-pl = yes and param-global.modulo-pi = yes then do:
            run cdp/cd7000.p (input 2, item-fornec.it-codigo, ""). /* usado para planejamento*/
     end.
  end.
  else do:
     run utp/ut-msgs.p (input "show",
                        input 16).
  end.

 &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      IF CAN-FIND(FIRST funcao
                  WHERE funcao.cd-funcao = "spp-cq-itfornest"
                  AND   funcao.ativo     = yes no-lock )then do:

                  if avail item-fornec then do:
                      run cqp/cq0104b.w (input  item-fornec.it-codigo,
                                         input  item-fornec.cod-emitente,
                                         input  h_v01in178,
                                         input-output  l-mod,
                                         output l-cont-ant,
                                         output p-cancela,
                                         output table tt-estabel).
                  END.
      END.
      ELSE DO:
          &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            if avail item-fornec then do:
                      run cqp/cq0104b.w (input  item-fornec.it-codigo,
                                         input  item-fornec.cod-emitente,
                                         input  h_v01in178,
                                         input-output  l-mod,
                                         output l-cont-ant,
                                         output p-cancela,
                                         output table tt-estabel).
                  END.
          &endif
      END.
      
  &ENDIF
    /*********** Multi-Planta **************/
  
  assign c-transacao = "MAT001".  
  assign i-tipo-movto = if item-fornec.cod-emitente:sensitive in frame {&frame-name} = yes 
                           then 1 else 2.
  
  run pi-cria-tt-dados (input i-tipo-movto). 
  
  
  /********** Fim Multi-Planta ***********/



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
  
  run pi-desabita-btexp in h_cq0104 (input no).

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

  {utp/ut-rtlbl.i mgind item-fornec aval-insp text-1}
  {utp/ut-rtlbl.i mgind item-fornec tp-inspecao text-2}

  if avail item-fornec then do:
     find item no-lock
        where item.it-codigo = item-fornec.it-codigo no-error.
     if avail item then do:
        assign c-desc-item = item.desc-item
               c-item-un   = item.un.
     end.
     else do:
        assign c-desc-item = " "
               c-item-un   = " ".
     end.

     find emitente no-lock
        where emitente.cod-emitente = item-fornec.cod-emitente no-error.
     if avail emitente then do:
        assign c-des-emitente = emitente.nome-abrev.
     end.
     else do:
        assign c-des-emitente = " ".
     end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail item-fornec then do with frame {&FRAME-NAME}:
     assign cb-aval-insp-1:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[1]}
            cb-aval-insp-2:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[2]}
            cb-aval-insp-3:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[3]}
            cb-aval-insp-4:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[4]}
            cb-aval-insp-5:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[5]}
            cb-aval-insp-6:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[6]}
            cb-aval-insp-7:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[7]}
            cb-aval-insp-8:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[8]}
            cb-aval-insp-9:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[9]}
            cb-aval-insp-10:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[10]}.            
     assign cb-aval-insp-11:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[11]}
            cb-aval-insp-12:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[12]}
            cb-aval-insp-13:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[13]}
            cb-aval-insp-14:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[14]}
            cb-aval-insp-15:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[15]}
            cb-aval-insp-16:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[16]}
            cb-aval-insp-17:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[17]}
            cb-aval-insp-18:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[18]}
            cb-aval-insp-19:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[19]}
            cb-aval-insp-20:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[20]}.
     assign cb-aval-insp-21:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[21]}
            cb-aval-insp-22:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[22]}
            cb-aval-insp-23:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[23]}
            cb-aval-insp-24:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[24]}
            cb-aval-insp-25:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[25]}
            cb-aval-insp-26:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[26]}
            cb-aval-insp-27:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[27]}
            cb-aval-insp-28:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[28]}
            cb-aval-insp-29:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[29]}
            cb-aval-insp-30:screen-value = {ininc/i01in178.i 04 item-fornec.aval-insp[30]}.
  end.
  
  else do:  
     assign cb-aval-insp-1:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-2:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-3:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-4:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-5:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-6:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-7:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-8:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-9:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-10:screen-value = {ininc/i01in178.i 04 1}.
     assign cb-aval-insp-11:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-12:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-13:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-14:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-15:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-16:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-17:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-18:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-19:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-20:screen-value = {ininc/i01in178.i 04 1}.
     assign cb-aval-insp-21:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-22:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-23:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-24:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-25:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-26:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-27:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-28:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-29:screen-value = {ininc/i01in178.i 04 1}
            cb-aval-insp-30:screen-value = {ininc/i01in178.i 04 1}.            
  end.  
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
  
   run pi-desabita-btexp in h_cq0104 (input yes). 

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

  {utp/ut-rtlbl.i mgind item-fornec aval-insp text-1}
  {utp/ut-rtlbl.i mgind item-fornec tp-inspecao text-2}

  /* C¢digo do Combo-box */
  do with frame {&FRAME-NAME}:
      assign cb-aval-insp-1:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-2:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-3:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-4:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-5:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-6:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-7:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-8:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-9:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-10:list-items = {ininc/i01in178.i 03}.
      assign cb-aval-insp-11:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-12:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-13:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-14:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-15:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-16:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-17:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-18:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-19:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-20:list-items = {ininc/i01in178.i 03}.
      assign cb-aval-insp-21:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-22:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-23:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-24:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-25:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-26:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-27:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-28:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-29:list-items = {ininc/i01in178.i 03}
             cb-aval-insp-30:list-items = {ininc/i01in178.i 03}.
  end.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */
  if avail item-fornec then
     assign gr-item-fornec = rowid(item-fornec).

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passa-temp-table V-table-Win 
PROCEDURE passa-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER  TABLE FOR tt-old-item-fornec.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passa-temp-table V-table-Win 
PROCEDURE passa-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM i-cod-emitente LIKE item-fornec.cod-emitente NO-UNDO.
DEFINE OUTPUT PARAM c-it-codigo LIKE item-fornec.it-codigo NO-UNDO.

ASSIGN i-cod-emitente = INPUT FRAME {&FRAME-NAME} item-fornec.cod-emitente
       c-it-codigo    = INPUT FRAME {&frame-name} item-fornec.it-codigo.
       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.

find first param-global no-lock no-error.

if  param-global.modulo-mp then do:
    run cdp/cdapi150.p (input "item-fornec",
                        input rowid(item-fornec),
                        input i-tipo-movto,
                        input c-transacao,
                        input-output table tt-erro). 
end.

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
 def input parameter p-handle as handle no-undo.
 def input parameter p-handle-pai as handle no-undo.

 assign h_v01in178 = p-handle
        h_cq0104   = p-handle-pai.


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
  {src/adm/template/snd-list.i "item-fornec"}

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

