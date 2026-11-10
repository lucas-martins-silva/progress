&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V03IN061 2.00.00.006}  /*** 010006 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in061 MUT}
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

def new global shared var gr-consumo as rowid no-undo.
def var i-per as integer.
def var i-empresa like param-global.empresa-prin no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-consumo
&Scoped-define FIRST-EXTERNAL-TABLE it-consumo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-consumo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-consumo.conta-contabil it-consumo.ano ~
it-consumo.it-codigo it-consumo.qt-saida[1] it-consumo.qt-saida[2] ~
it-consumo.qt-saida[3] it-consumo.qt-saida[4] it-consumo.qt-saida[5] ~
it-consumo.qt-saida[6] it-consumo.qt-saida[7] it-consumo.qt-saida[8] ~
it-consumo.qt-saida[9] it-consumo.qt-saida[10] it-consumo.qt-saida[11] ~
it-consumo.qt-saida[12] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}conta-contabil ~{&FP2}conta-contabil ~{&FP3}~
 ~{&FP1}ano ~{&FP2}ano ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}qt-saida[1] ~{&FP2}qt-saida[1] ~{&FP3}~
 ~{&FP1}qt-saida[2] ~{&FP2}qt-saida[2] ~{&FP3}~
 ~{&FP1}qt-saida[3] ~{&FP2}qt-saida[3] ~{&FP3}~
 ~{&FP1}qt-saida[4] ~{&FP2}qt-saida[4] ~{&FP3}~
 ~{&FP1}qt-saida[5] ~{&FP2}qt-saida[5] ~{&FP3}~
 ~{&FP1}qt-saida[6] ~{&FP2}qt-saida[6] ~{&FP3}~
 ~{&FP1}qt-saida[7] ~{&FP2}qt-saida[7] ~{&FP3}~
 ~{&FP1}qt-saida[8] ~{&FP2}qt-saida[8] ~{&FP3}~
 ~{&FP1}qt-saida[9] ~{&FP2}qt-saida[9] ~{&FP3}~
 ~{&FP1}qt-saida[10] ~{&FP2}qt-saida[10] ~{&FP3}~
 ~{&FP1}qt-saida[11] ~{&FP2}qt-saida[11] ~{&FP3}~
 ~{&FP1}qt-saida[12] ~{&FP2}qt-saida[12] ~{&FP3}
&Scoped-define ENABLED-TABLES it-consumo
&Scoped-define FIRST-ENABLED-TABLE it-consumo
&Scoped-Define ENABLED-OBJECTS rt-key RECT-16 
&Scoped-Define DISPLAYED-FIELDS it-consumo.conta-contabil it-consumo.ano ~
it-consumo.it-codigo it-consumo.qt-entrada[1] it-consumo.qt-saida[1] ~
it-consumo.qt-entrada[2] it-consumo.qt-saida[2] it-consumo.qt-entrada[3] ~
it-consumo.qt-saida[3] it-consumo.qt-entrada[4] it-consumo.qt-saida[4] ~
it-consumo.qt-entrada[5] it-consumo.qt-saida[5] it-consumo.qt-entrada[6] ~
it-consumo.qt-saida[6] it-consumo.qt-entrada[7] it-consumo.qt-saida[7] ~
it-consumo.qt-entrada[8] it-consumo.qt-saida[8] it-consumo.qt-entrada[9] ~
it-consumo.qt-saida[9] it-consumo.qt-entrada[10] it-consumo.qt-saida[10] ~
it-consumo.qt-entrada[11] it-consumo.qt-saida[11] it-consumo.qt-entrada[12] ~
it-consumo.qt-saida[12] 
&Scoped-Define DISPLAYED-OBJECTS fi-titulo fi-item-1 de-consumo-1 ~
de-consumo-2 de-consumo-3 de-consumo-4 de-consumo-5 de-consumo-6 ~
de-consumo-7 de-consumo-8 de-consumo-9 de-consumo-10 de-consumo-11 ~
de-consumo-12 fi-saida fi-consumo fi-entrada fi-mes-1 fi-mes-2 fi-mes-3 ~
fi-mes-4 fi-mes-5 fi-mes-6 fi-mes-7 fi-mes-8 fi-mes-9 fi-mes-10 fi-mes-11 ~
fi-mes-12 

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
DEFINE VARIABLE de-consumo-1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-10 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-11 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-12 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-4 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-5 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-6 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-7 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-8 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE de-consumo-9 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE fi-consumo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-entrada AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-item-1 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 50.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-mes-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-10 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-11 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-12 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-7 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-8 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mes-9 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-saida AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.72 BY .67 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 13.04.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-consumo.conta-contabil AT ROW 1.17 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     fi-titulo AT ROW 1.17 COL 35 COLON-ALIGNED NO-LABEL
     it-consumo.ano AT ROW 1.17 COL 78.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     it-consumo.it-codigo AT ROW 2.17 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     fi-item-1 AT ROW 2.17 COL 33.86 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[1] AT ROW 4.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[1] AT ROW 4.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-1 AT ROW 4.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[2] AT ROW 5.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[2] AT ROW 5.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-2 AT ROW 5.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[3] AT ROW 6.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[3] AT ROW 6.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-3 AT ROW 6.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[4] AT ROW 7.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[4] AT ROW 7.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-4 AT ROW 7.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[5] AT ROW 8.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[5] AT ROW 8.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-5 AT ROW 8.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[6] AT ROW 9.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[6] AT ROW 9.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-6 AT ROW 9.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[7] AT ROW 10.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[7] AT ROW 10.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-7 AT ROW 10.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[8] AT ROW 11.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[8] AT ROW 11.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-8 AT ROW 11.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[9] AT ROW 12.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[9] AT ROW 12.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     de-consumo-9 AT ROW 12.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[10] AT ROW 13.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[10] AT ROW 13.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-10 AT ROW 13.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[11] AT ROW 14.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[11] AT ROW 14.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-11 AT ROW 14.33 COL 65 COLON-ALIGNED NO-LABEL
     it-consumo.qt-entrada[12] AT ROW 15.33 COL 19.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-consumo.qt-saida[12] AT ROW 15.33 COL 42.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     de-consumo-12 AT ROW 15.33 COL 65 COLON-ALIGNED NO-LABEL
     fi-saida AT ROW 3.5 COL 42.43 COLON-ALIGNED NO-LABEL
     fi-consumo AT ROW 3.5 COL 65.29 COLON-ALIGNED NO-LABEL
     fi-entrada AT ROW 3.58 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-mes-1 AT ROW 4.58 COL 7.29 NO-LABEL
     fi-mes-2 AT ROW 5.58 COL 7.29 NO-LABEL
     fi-mes-3 AT ROW 6.58 COL 7.29 NO-LABEL
     fi-mes-4 AT ROW 7.58 COL 7.29 NO-LABEL
     fi-mes-5 AT ROW 8.58 COL 7.29 NO-LABEL
     fi-mes-6 AT ROW 9.58 COL 7.29 NO-LABEL
     fi-mes-7 AT ROW 10.58 COL 7.29 NO-LABEL
     fi-mes-8 AT ROW 11.58 COL 7.29 NO-LABEL
     fi-mes-9 AT ROW 12.58 COL 7.29 NO-LABEL
     fi-mes-10 AT ROW 13.58 COL 7.29 NO-LABEL
     fi-mes-11 AT ROW 14.58 COL 7.29 NO-LABEL
     fi-mes-12 AT ROW 15.58 COL 7.29 NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-16 AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.it-consumo
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
         HEIGHT             = 15.46
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN de-consumo-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-consumo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-entrada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-item-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-mes-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-10 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-11 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-12 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-3 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-4 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-5 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-6 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-7 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-8 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-mes-9 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-saida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[10] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[11] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[12] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[4] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[5] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[6] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[7] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[8] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-consumo.qt-entrada[9] IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

      
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
          
      RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
       
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "it-consumo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-consumo"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  find first param-global no-lock no-error.
  
  find conta-contab where
     conta-contab.ep-codigo = i-empresa and
     conta-contab.conta-contabil = it-consumo.conta-contabil no-lock no-error.

  if available conta-contab then
     assign fi-titulo = conta-contab.titulo.
  else
     assign fi-titulo = "":U.
     
  find item where 
      item.it-codigo = it-consumo.it-codigo no-lock no-error.
  
  if available item then 
     assign fi-item-1 = item.desc-item.
  else
     assign fi-item-1 = "":U.
     
  if available it-consumo then do:
  assign de-consumo-1  = it-consumo.qt-saida[1]  - it-consumo.qt-entrada[1]
         de-consumo-2  = it-consumo.qt-saida[2]  - it-consumo.qt-entrada[2]
         de-consumo-3  = it-consumo.qt-saida[3]  - it-consumo.qt-entrada[3]
         de-consumo-4  = it-consumo.qt-saida[4]  - it-consumo.qt-entrada[4]
         de-consumo-5  = it-consumo.qt-saida[5]  - it-consumo.qt-entrada[5]
         de-consumo-6  = it-consumo.qt-saida[6]  - it-consumo.qt-entrada[6]
         de-consumo-7  = it-consumo.qt-saida[7]  - it-consumo.qt-entrada[7]
         de-consumo-8  = it-consumo.qt-saida[8]  - it-consumo.qt-entrada[8]
         de-consumo-9  = it-consumo.qt-saida[9]  - it-consumo.qt-entrada[9] 
         de-consumo-10 = it-consumo.qt-saida[10] - it-consumo.qt-entrada[10]
         de-consumo-11 = it-consumo.qt-saida[11] - it-consumo.qt-entrada[11]
         de-consumo-12 = it-consumo.qt-saida[12] - it-consumo.qt-entrada[12].
         if de-consumo-1 = ? then de-consumo-1 = 0.
         if de-consumo-2 = ? then de-consumo-2 = 0.
         if de-consumo-3 = ? then de-consumo-3 = 0.
         if de-consumo-4 = ? then de-consumo-4 = 0.
         if de-consumo-5 = ? then de-consumo-5 = 0.
         if de-consumo-6 = ? then de-consumo-6 = 0.
         if de-consumo-7 = ? then de-consumo-7 = 0.
         if de-consumo-8 = ? then de-consumo-8 = 0.
         if de-consumo-9 = ? then de-consumo-9 = 0.
         if de-consumo-10 = ? then de-consumo-10 = 0.
         if de-consumo-11 = ? then de-consumo-11 = 0.
         if de-consumo-12 = ? then de-consumo-12 = 0.
             
  if it-consumo.qt-entrada[1] = ? then 
     assign it-consumo.qt-entrada[1]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[1] = ? then 
     assign it-consumo.qt-saida[1]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[2] = ? then 
     assign it-consumo.qt-entrada[2]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[2] = ? then 
     assign it-consumo.qt-saida[2]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[3] = ? then 
     assign it-consumo.qt-entrada[3]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[3] = ? then 
     assign it-consumo.qt-saida[3]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[4] = ? then 
     assign it-consumo.qt-entrada[4]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[4] = ? then 
     assign it-consumo.qt-saida[4]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[5] = ? then 
     assign it-consumo.qt-entrada[5]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[5] = ? then 
     assign it-consumo.qt-saida[5]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[6] = ? then 
     assign it-consumo.qt-entrada[6]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[6] = ? then 
     assign it-consumo.qt-saida[6]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[7] = ? then 
     assign it-consumo.qt-entrada[7]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[7] = ? then 
     assign it-consumo.qt-saida[7]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[8] = ? then 
     assign it-consumo.qt-entrada[8]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[8] = ? then 
     assign it-consumo.qt-saida[8]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[9] = ? then 
     assign it-consumo.qt-entrada[9]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[9] = ? then 
     assign it-consumo.qt-saida[9]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[10] = ? then 
     assign it-consumo.qt-entrada[10]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[10] = ? then 
     assign it-consumo.qt-saida[10]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[11] = ? then 
     assign it-consumo.qt-entrada[11]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[11] = ? then 
     assign it-consumo.qt-saida[11]:screen-value in frame {&frame-name} = string(0).
  
  if it-consumo.qt-entrada[12] = ? then 
     assign it-consumo.qt-entrada[12]:screen-value in frame {&frame-name} = string(0).
  if it-consumo.qt-saida[12] = ? then 
     assign it-consumo.qt-saida[12]:screen-value in frame {&frame-name} = string(0).
  end.
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
     
  {utp/ut-liter.i Entrada * r}
  assign fi-entrada = return-value.
  {utp/ut-liter.i Sa¡da * r}
  assign fi-saida = return-value.
  {utp/ut-liter.i Janeiro * r}
  assign fi-mes-1 = return-value.
  {utp/ut-liter.i Fevereiro * r}
  assign fi-mes-2 = return-value.
  {utp/ut-liter.i Mar‡o * r}
  assign fi-mes-3 = return-value.
  {utp/ut-liter.i Abril * r}
  assign fi-mes-4 = return-value.
  {utp/ut-liter.i Maio  * r}
  assign fi-mes-5 = return-value.
  {utp/ut-liter.i Junho  * r}
  assign fi-mes-6 = return-value.
  {utp/ut-liter.i Julho * r}
  assign fi-mes-7 = return-value.
  {utp/ut-liter.i Agosto * r}
  assign fi-mes-8 = return-value.
  {utp/ut-liter.i Setembro  * r}
  assign fi-mes-9 = return-value.
  {utp/ut-liter.i Outubro * r}
  assign fi-mes-10 = return-value.
  {utp/ut-liter.i Novembro  * r}
  assign fi-mes-11 = return-value.
  {utp/ut-liter.i Dezembro  * r}
  assign fi-mes-12 = return-value. 
 
 find first param-global no-lock no-error.
    if avail param-global then 
    assign i-empresa = param-global.empresa-prin. 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "it-consumo"}

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


