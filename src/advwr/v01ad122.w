&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01AD122 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD122 MUT}
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
def buffer b-frequencia for frequencia.

define new global shared variable gr-frequencia as rowid no-undo.

define variable i-tipo     as integer no-undo.
define variable i-contador as integer no-undo.
define variable i-qt-ent   as integer no-undo.

{bhp/bh9999.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES frequencia
&Scoped-define FIRST-EXTERNAL-TABLE frequencia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR frequencia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS frequencia.descricao frequencia.dt-ref ~
frequencia.tp-freq frequencia.intervalo frequencia.cd-sub-freq ~
frequencia.frequencia[1] frequencia.frequencia[2] frequencia.frequencia[3] ~
frequencia.frequencia[4] frequencia.frequencia[5] frequencia.frequencia[6] ~
frequencia.frequencia[7] frequencia.frequencia[8] frequencia.frequencia[9] ~
frequencia.frequencia[10] frequencia.frequencia[11] ~
frequencia.frequencia[12] frequencia.frequencia[13] ~
frequencia.frequencia[14] frequencia.frequencia[15] ~
frequencia.frequencia[16] frequencia.frequencia[17] ~
frequencia.frequencia[18] frequencia.frequencia[19] ~
frequencia.frequencia[20] frequencia.frequencia[21] ~
frequencia.frequencia[22] frequencia.frequencia[23] ~
frequencia.frequencia[24] frequencia.frequencia[25] ~
frequencia.frequencia[26] frequencia.frequencia[27] ~
frequencia.frequencia[28] frequencia.frequencia[29] ~
frequencia.frequencia[30] frequencia.frequencia[31] ~
frequencia.frequencia[32] frequencia.frequencia[33] ~
frequencia.frequencia[34] frequencia.frequencia[35] ~
frequencia.frequencia[36] frequencia.frequencia[37] ~
frequencia.frequencia[38] frequencia.frequencia[39] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}intervalo ~{&FP2}intervalo ~{&FP3}~
 ~{&FP1}cd-sub-freq ~{&FP2}cd-sub-freq ~{&FP3}
&Scoped-define ENABLED-TABLES frequencia
&Scoped-define FIRST-ENABLED-TABLE frequencia
&Scoped-Define ENABLED-OBJECTS RECT-37 RECT-38 RECT-39 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS frequencia.cd-freq frequencia.descricao ~
frequencia.dt-ref frequencia.tp-freq frequencia.intervalo ~
frequencia.cd-sub-freq frequencia.frequencia[1] frequencia.frequencia[2] ~
frequencia.frequencia[3] frequencia.frequencia[4] frequencia.frequencia[5] ~
frequencia.frequencia[6] frequencia.frequencia[7] frequencia.frequencia[8] ~
frequencia.frequencia[9] frequencia.frequencia[10] ~
frequencia.frequencia[11] frequencia.frequencia[12] ~
frequencia.frequencia[13] frequencia.frequencia[14] ~
frequencia.frequencia[15] frequencia.frequencia[16] ~
frequencia.frequencia[17] frequencia.frequencia[18] ~
frequencia.frequencia[19] frequencia.frequencia[20] ~
frequencia.frequencia[21] frequencia.frequencia[22] ~
frequencia.frequencia[23] frequencia.frequencia[24] ~
frequencia.frequencia[25] frequencia.frequencia[26] ~
frequencia.frequencia[27] frequencia.frequencia[28] ~
frequencia.frequencia[29] frequencia.frequencia[30] ~
frequencia.frequencia[31] frequencia.frequencia[32] ~
frequencia.frequencia[33] frequencia.frequencia[34] ~
frequencia.frequencia[35] frequencia.frequencia[36] ~
frequencia.frequencia[37] frequencia.frequencia[38] ~
frequencia.frequencia[39] 
&Scoped-Define DISPLAYED-OBJECTS fi-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS frequencia.cd-freq 
&Scoped-define List-4 frequencia.frequencia[1] frequencia.frequencia[2] ~
frequencia.frequencia[3] frequencia.frequencia[4] frequencia.frequencia[5] ~
frequencia.frequencia[6] frequencia.frequencia[7] frequencia.frequencia[8] ~
frequencia.frequencia[9] frequencia.frequencia[10] ~
frequencia.frequencia[11] frequencia.frequencia[12] ~
frequencia.frequencia[13] frequencia.frequencia[14] ~
frequencia.frequencia[15] frequencia.frequencia[16] ~
frequencia.frequencia[17] frequencia.frequencia[18] ~
frequencia.frequencia[19] frequencia.frequencia[20] ~
frequencia.frequencia[21] frequencia.frequencia[22] ~
frequencia.frequencia[23] frequencia.frequencia[24] ~
frequencia.frequencia[25] frequencia.frequencia[26] ~
frequencia.frequencia[27] frequencia.frequencia[28] ~
frequencia.frequencia[29] frequencia.frequencia[30] ~
frequencia.frequencia[31] frequencia.frequencia[32] ~
frequencia.frequencia[33] frequencia.frequencia[34] ~
frequencia.frequencia[35] frequencia.frequencia[36] ~
frequencia.frequencia[37] frequencia.frequencia[38] ~
frequencia.frequencia[39] 

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
DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-dt-ref AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-frequencia AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-tp-freq AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.42.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.33.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 4.54.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     frequencia.cd-freq AT ROW 1.21 COL 33.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     frequencia.descricao AT ROW 1.21 COL 38.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     frequencia.dt-ref AT ROW 4.58 COL 19.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Data", 1,
"Semana", 2,
"Quinzena", 3,
"Màs", 4
          SIZE 59.14 BY .83
     frequencia.tp-freq AT ROW 3.04 COL 5.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Di†ria", 2,
"Semanal", 3,
"Quinzenal", 4,
"Mensal", 5,
"Informada", 6
          SIZE 82.29 BY .75
     frequencia.intervalo AT ROW 5.92 COL 19.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     frequencia.cd-sub-freq AT ROW 5.92 COL 45.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     frequencia.frequencia[1] AT ROW 8.08 COL 8.72
          LABEL "1"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[2] AT ROW 8.83 COL 8.72
          LABEL "2"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[3] AT ROW 9.58 COL 8.72
          LABEL "3"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[4] AT ROW 10.33 COL 8.72
          LABEL "4"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[5] AT ROW 11.08 COL 8.72
          LABEL "5"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[6] AT ROW 8.08 COL 17.72
          LABEL "6"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[7] AT ROW 8.83 COL 17.72
          LABEL "7"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[8] AT ROW 9.58 COL 17.72
          LABEL "8"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[9] AT ROW 10.33 COL 17.72
          LABEL "9"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[10] AT ROW 11.08 COL 17.72
          LABEL "10"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[11] AT ROW 8.08 COL 27.72
          LABEL "11"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[12] AT ROW 8.83 COL 27.72
          LABEL "12"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[13] AT ROW 9.58 COL 27.72
          LABEL "13"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[14] AT ROW 10.33 COL 27.72
          LABEL "14"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[15] AT ROW 11.08 COL 27.72
          LABEL "15"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[16] AT ROW 8.08 COL 37.72
          LABEL "16"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[17] AT ROW 8.83 COL 37.72
          LABEL "17"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[18] AT ROW 9.58 COL 37.72
          LABEL "18"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     frequencia.frequencia[19] AT ROW 10.33 COL 37.72
          LABEL "19"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[20] AT ROW 11.08 COL 37.72
          LABEL "20"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[21] AT ROW 8.08 COL 47.72
          LABEL "21"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[22] AT ROW 8.83 COL 47.72
          LABEL "22"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[23] AT ROW 9.58 COL 47.72
          LABEL "23"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[24] AT ROW 10.33 COL 47.72
          LABEL "24"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[25] AT ROW 11.08 COL 47.72
          LABEL "25"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[26] AT ROW 8.08 COL 57.72
          LABEL "26"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[27] AT ROW 8.83 COL 57.72
          LABEL "27"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[28] AT ROW 9.58 COL 57.72
          LABEL "28"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[29] AT ROW 10.33 COL 57.72
          LABEL "29"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[30] AT ROW 11.08 COL 57.72
          LABEL "30"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[31] AT ROW 8.08 COL 67.72
          LABEL "31"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[32] AT ROW 8.83 COL 67.72
          LABEL "32"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[33] AT ROW 9.58 COL 67.72
          LABEL "33"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[34] AT ROW 10.33 COL 67.72
          LABEL "34"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[35] AT ROW 11.08 COL 67.72
          LABEL "35"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[36] AT ROW 8.08 COL 77.72
          LABEL "36"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[37] AT ROW 8.83 COL 77.72
          LABEL "37"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[38] AT ROW 9.58 COL 77.72
          LABEL "38"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     frequencia.frequencia[39] AT ROW 10.33 COL 77.72
          LABEL "39"
          VIEW-AS TOGGLE-BOX
          SIZE 6 BY .75
     fi-descricao AT ROW 5.92 COL 50.72 COLON-ALIGNED NO-LABEL
     fi-label-tp-freq AT ROW 2.29 COL 6.29 COLON-ALIGNED NO-LABEL
     fi-label-dt-ref AT ROW 4 COL 6 COLON-ALIGNED NO-LABEL
     fi-label-frequencia AT ROW 7.21 COL 9.72 COLON-ALIGNED NO-LABEL
     RECT-37 AT ROW 2.58 COL 1
     RECT-38 AT ROW 4.29 COL 1
     RECT-39 AT ROW 7.58 COL 1
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.frequencia
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.17
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN frequencia.cd-freq IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-dt-ref IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-label-frequencia IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-label-tp-freq IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[10] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[11] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[12] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[13] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[14] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[15] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[16] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[17] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[18] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[19] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[1] IN FRAME f-main
   4 EXP-LABEL                                                          */
ASSIGN 
       frequencia.frequencia[1]:AUTO-RESIZE IN FRAME f-main      = TRUE.

/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[20] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[21] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[22] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[23] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[24] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[25] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[26] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[27] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[28] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[29] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[2] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[30] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[31] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[32] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[33] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[34] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[35] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[36] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[37] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[38] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[39] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[3] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[4] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[5] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[6] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[7] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[8] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX frequencia.frequencia[9] IN FRAME f-main
   4 EXP-LABEL                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frequencia.cd-sub-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frequencia.cd-sub-freq V-table-Win
ON F5 OF frequencia.cd-sub-freq IN FRAME f-main /* Sub-Freq?ància */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom=adzoom\z01ad122.w
                       &campo=frequencia.cd-sub-freq
                       &campozoom=cd-freq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frequencia.cd-sub-freq V-table-Win
ON LEAVE OF frequencia.cd-sub-freq IN FRAME f-main /* Sub-Freq?ància */
DO:
  
   find first b-frequencia where
              b-frequencia.cd-freq = int(self:screen-value) no-lock no-error.
   if avail b-frequencia then
      assign fi-descricao:screen-value in frame {&frame-name} = b-frequencia.descricao.
   else   
      assign fi-descricao:screen-value in frame {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frequencia.cd-sub-freq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF frequencia.cd-sub-freq IN FRAME f-main /* Sub-Freq?ància */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME frequencia.tp-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frequencia.tp-freq V-table-Win
ON VALUE-CHANGED OF frequencia.tp-freq IN FRAME f-main /* Tipo Freq?ància */
DO:
    assign i-tipo = input frame {&frame-name} frequencia.tp-freq.
    if  i-tipo = 6 then do with frame {&frame-name}:
        enable frequencia.intervalo
               frequencia.dt-ref
               frequencia.cd-sub-freq
               {&List-4}.
    end.
    else do with frame {&frame-name}:
        assign frequencia.intervalo:screen-value = entry(i-tipo,"0,1,7,15,30").
        disable frequencia.intervalo.
        if  i-tipo = 1 then 
            disable frequencia.dt-ref 
                    frequencia.cd-sub-freq 
                    {&List-4}.
        else
            enable frequencia.dt-ref
                   frequencia.cd-sub-freq 
                   {&List-4}.
    end.

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

    if  frequencia.cd-sub-freq:load-mouse-pointer("Image/lupa.cur") in frame {&frame-name} then .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "frequencia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "frequencia"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  {utp/ut-rtlbl.i mgadm frequencia dt-ref     fi-label-dt-ref}
  {utp/ut-rtlbl.i mgadm frequencia tp-freq    fi-label-tp-freq}
  {utp/ut-rtlbl.i mgadm frequencia frequencia fi-label-frequencia}
  
  apply "value-changed" to frequencia.tp-freq in frame {&frame-name}.
         
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  if frequencia.cd-freq:sensitive then do:
     
     if can-find(frequencia where
                 frequencia.cd-freq = input frame {&frame-name} frequencia.cd-freq) then do:
         /* j† existe frequencia informada */ 
         {utp/ut-table.i mgadm frequencia 1}
         run utp/ut-msgs.p (input "show", input 1, input return-value).
         apply "entry" to frequencia.cd-freq in frame {&frame-name}.
         return "adm-error".         
     end.
  
     if frequencia.cd-freq:screen-value in frame {&frame-name} = "0" then do:
        {utp/ut-field.i mgadm frequencia cd-freq 1}
        run utp/ut-msgs.p (input "show", input 265, input return-value). 
        apply "entry" to frequencia.cd-freq in frame {&frame-name}.
        return "adm-error".
     end.
  end.                         
  
  
  
  /* Ponha aqui as demais validaá‰es */

  apply "value-changed" to frequencia.tp-freq in frame {&frame-name}.

  if  frequencia.cd-sub-freq:screen-value = frequencia.cd-freq:screen-value then do:
      run utp/ut-msgs.p (input "show", input 934, input "").
      apply "entry" to frequencia.cd-sub-freq in frame {&frame-name}.
      return "adm-error".
  end.

  if  frequencia.descricao:screen-value = "" then do:
      run utp/ut-msgs.p (input "show", input 190, input "").
      apply "entry" to frequencia.descricao in frame {&frame-name}.
      return "adm-error".
  end.

  
  if  frequencia.cd-freq:sensitive = no then do: /* Opá∆o Modifica */
      if  frequencia.tp-freq <> i-tipo and i-tipo <> 1 and i-tipo <> 6 then do:
          find first b-frequencia
               where b-frequencia.cd-sub-freq = frequencia.cd-freq 
                 and b-frequencia.tp-freq < 6 
                 and b-frequencia.tp-freq <= i-tipo no-lock no-error.
          if  avail b-frequencia then do:
              run utp/ut-msgs.p (input "show", input 938, input b-frequencia.cd-freq).
              apply "entry" to frequencia.tp-freq in frame {&frame-name}.
              return "adm-error".
          end.    
      end.
      if  frequencia.intervalo <> input frame {&frame-name} frequencia.intervalo then do:
          find first b-frequencia
               where b-frequencia.cd-sub-freq = frequencia.cd-freq
                 and b-frequencia.intervalo <= input frame {&frame-name} frequencia.intervalo
                     no-lock no-error.
          if  avail b-frequencia then do:
              run utp/ut-msgs.p (input "show", input 938, input b-frequencia.cd-freq).
              apply "entry" to frequencia.intervalo in frame {&frame-name}.
              return "adm-error".
          end.   
      end.
  end.
  
  If  i-tipo <> 1 then do:

      if input frame {&frame-name} frequencia.cd-sub-freq > 0 then do:  
     
          find b-frequencia 
              where b-frequencia.cd-freq = input frame {&frame-name} frequencia.cd-sub-freq 
              no-lock no-error.
             
          if  not avail b-frequencia  then do:
              {utp/ut-field.i mgadm frequencia cd-sub-freq 1}
              run utp/ut-msgs.p (input "show", input 2, input return-value).
              apply "entry" to frequencia.cd-sub-freq in frame {&frame-name}.
              return "adm-error".
          end.

          if  i-tipo <> 6 then do:
              if  b-frequencia.intervalo >= input frame {&frame-name} frequencia.intervalo then do:
                  run utp/ut-msgs.p (input "show", input 935, input "").
                  apply "entry" to frequencia.cd-sub-freq in frame {&frame-name}.
                  return "adm-error".
              end.
          end.
          else do:
              if  b-frequencia.tp-freq >= i-tipo then do:
                  run utp/ut-msgs.p (input "show", input 936, input "").
                  apply "entry" to frequencia.cd-sub-freq in frame {&frame-name}.
                  return "adm-error".
              end.
          end.
      
      end.
  
      assign i-qt-ent = 0.
      do  i-contador = 1 to 39:
          assign 
              i-qt-ent = integer(input frame {&frame-name} frequencia.frequencia[1]) +
                         integer(input frame {&frame-name} frequencia.frequencia[2]) +
                         integer(input frame {&frame-name} frequencia.frequencia[3]) +
                         integer(input frame {&frame-name} frequencia.frequencia[4]) +
                         integer(input frame {&frame-name} frequencia.frequencia[5]) +
                         integer(input frame {&frame-name} frequencia.frequencia[6]) +
                         integer(input frame {&frame-name} frequencia.frequencia[7]) +
                         integer(input frame {&frame-name} frequencia.frequencia[8]) +
                         integer(input frame {&frame-name} frequencia.frequencia[9]) +
                         integer(input frame {&frame-name} frequencia.frequencia[10]) +
                         integer(input frame {&frame-name} frequencia.frequencia[11]) +
                         integer(input frame {&frame-name} frequencia.frequencia[12]) +
                         integer(input frame {&frame-name} frequencia.frequencia[13]) +
                         integer(input frame {&frame-name} frequencia.frequencia[14]) +
                         integer(input frame {&frame-name} frequencia.frequencia[15]) +
                         integer(input frame {&frame-name} frequencia.frequencia[16]) +
                         integer(input frame {&frame-name} frequencia.frequencia[17]) +
                         integer(input frame {&frame-name} frequencia.frequencia[18]) +
                         integer(input frame {&frame-name} frequencia.frequencia[19]) +
                         integer(input frame {&frame-name} frequencia.frequencia[20]) +
                         integer(input frame {&frame-name} frequencia.frequencia[21]) +
                         integer(input frame {&frame-name} frequencia.frequencia[22]) +
                         integer(input frame {&frame-name} frequencia.frequencia[23]) +
                         integer(input frame {&frame-name} frequencia.frequencia[24]) +
                         integer(input frame {&frame-name} frequencia.frequencia[25]) +
                         integer(input frame {&frame-name} frequencia.frequencia[26]) +
                         integer(input frame {&frame-name} frequencia.frequencia[27]) +
                         integer(input frame {&frame-name} frequencia.frequencia[28]) +
                         integer(input frame {&frame-name} frequencia.frequencia[29]) +
                         integer(input frame {&frame-name} frequencia.frequencia[30]) +
                         integer(input frame {&frame-name} frequencia.frequencia[31]) +
                         integer(input frame {&frame-name} frequencia.frequencia[32]) +
                         integer(input frame {&frame-name} frequencia.frequencia[33]) +
                         integer(input frame {&frame-name} frequencia.frequencia[34]) +
                         integer(input frame {&frame-name} frequencia.frequencia[35]) +
                         integer(input frame {&frame-name} frequencia.frequencia[36]) +
                         integer(input frame {&frame-name} frequencia.frequencia[37]) +
                         integer(input frame {&frame-name} frequencia.frequencia[38]) +
                         integer(input frame {&frame-name} frequencia.frequencia[39]).
      end.
      if  i-qt-ent = 0 then do:
          run utp/ut-msgs.p (input "show", input 937, input "").
          apply "entry" to frequencia.cd-sub-freq in frame {&frame-name}.
          return "adm-error".
      end.
  end.
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
      if avail frequencia then do:
        IF  FREQUENCIA.TP-FREQ = 1 THEN 
            ASSIGN FREQUENCIA.DT-REF      = 0
                   FREQUENCIA.CD-SUB-FREQ = 0
                   FREQUENCIA.FREQUENCIA  = NO
                   FREQUENCIA.QT-ENT      = 0.
        ELSE
            ASSIGN FREQUENCIA.QT-ENT = I-QT-ENT.
      end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Frequencia frequencia.cd-freq '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
  if  avail frequencia then do:
      find b-frequencia no-lock where 
           b-frequencia.cd-freq = frequencia.cd-sub-freq no-error.
      assign fi-descricao = if available b-frequencia then b-frequencia.descricao 
                            else "":U.
  end.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
{utp/ut-rtlbl.i mgadm frequencia dt-ref     fi-label-dt-ref}
  {utp/ut-rtlbl.i mgadm frequencia tp-freq    fi-label-tp-freq}
  {utp/ut-rtlbl.i mgadm frequencia frequencia fi-label-frequencia}

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
  assign gr-frequencia = if avail frequencia then rowid(frequencia) else gr-frequencia.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "frequencia"}

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

  if p-state = 'EndUpdate':U 
  or p-state = 'Update-Begin':U
  or p-state = 'Add-Record':U  then
     apply 'value-changed':U to frequencia.tp-freq in frame {&frame-name}.

  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


