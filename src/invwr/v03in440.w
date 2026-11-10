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
{include/i-prgvrs.i V03IN440 2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN440 MUT}
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR i-aux AS integer NO-UNDO.
def new global shared var gr-turno as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES turno
&Scoped-define FIRST-EXTERNAL-TABLE turno


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR turno.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS turno.hr-dia-1 turno.hr-parada-1 ~
turno.hr-dia-2 turno.hr-parada-2 turno.hr-dia-3 turno.hr-parada-3 ~
turno.hr-dia-4 turno.hr-parada-4 turno.hr-dia-5 turno.hr-parada-5 ~
turno.hr-dia-6 turno.hr-parada-6 turno.hr-dia-7 turno.hr-parada-7 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}hr-dia-1 ~{&FP2}hr-dia-1 ~{&FP3}~
 ~{&FP1}hr-parada-1 ~{&FP2}hr-parada-1 ~{&FP3}~
 ~{&FP1}hr-dia-2 ~{&FP2}hr-dia-2 ~{&FP3}~
 ~{&FP1}hr-parada-2 ~{&FP2}hr-parada-2 ~{&FP3}~
 ~{&FP1}hr-dia-3 ~{&FP2}hr-dia-3 ~{&FP3}~
 ~{&FP1}hr-parada-3 ~{&FP2}hr-parada-3 ~{&FP3}~
 ~{&FP1}hr-dia-4 ~{&FP2}hr-dia-4 ~{&FP3}~
 ~{&FP1}hr-parada-4 ~{&FP2}hr-parada-4 ~{&FP3}~
 ~{&FP1}hr-dia-5 ~{&FP2}hr-dia-5 ~{&FP3}~
 ~{&FP1}hr-parada-5 ~{&FP2}hr-parada-5 ~{&FP3}~
 ~{&FP1}hr-dia-6 ~{&FP2}hr-dia-6 ~{&FP3}~
 ~{&FP1}hr-parada-6 ~{&FP2}hr-parada-6 ~{&FP3}~
 ~{&FP1}hr-dia-7 ~{&FP2}hr-dia-7 ~{&FP3}~
 ~{&FP1}hr-parada-7 ~{&FP2}hr-parada-7 ~{&FP3}
&Scoped-define ENABLED-TABLES turno
&Scoped-define FIRST-ENABLED-TABLE turno
&Scoped-Define ENABLED-OBJECTS rt-key RECT-4 
&Scoped-Define DISPLAYED-FIELDS turno.cd-turno turno.descricao ~
turno.hr-dia-1 turno.hr-parada-1 turno.hr-dia-2 turno.hr-parada-2 ~
turno.hr-dia-3 turno.hr-parada-3 turno.hr-dia-4 turno.hr-parada-4 ~
turno.hr-dia-5 turno.hr-parada-5 turno.hr-dia-6 turno.hr-parada-6 ~
turno.hr-dia-7 turno.hr-parada-7 
&Scoped-Define DISPLAYED-OBJECTS i-hr1 i-mm1 i-hr2 i-mm2 i-hr3 i-mm3 i-hr4 ~
i-mm4 i-hr5 i-mm5 i-hr6 i-mm6 i-hr7 i-mm7 fi-tempo-proc fi-interrupcao ~
fi-hora-inic fi-dom fi-seg fi-ter fi-qua fi-qui fi-sex fi-sab 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS turno.cd-turno turno.descricao i-hr1 i-mm1 ~
i-hr2 i-mm2 i-hr3 i-mm3 i-hr4 i-mm4 i-hr5 i-mm5 i-hr6 i-mm6 i-hr7 i-mm7 
&Scoped-define ADM-ASSIGN-FIELDS i-hr1 i-mm1 i-hr2 i-mm2 i-hr3 i-mm3 i-hr4 ~
i-mm4 i-hr5 i-mm5 i-hr6 i-mm6 i-hr7 i-mm7 
&Scoped-define ADM-MODIFY-FIELDS i-hr1 i-mm1 i-hr2 i-mm2 i-hr3 i-mm3 i-hr4 ~
i-mm4 i-hr5 i-mm5 i-hr6 i-mm6 i-hr7 i-mm7 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cd-turno|y|y|mgind.turno.cd-turno
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cd-turno",
     Keys-Supplied = "cd-turno"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-dom AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-hora-inic AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-interrupcao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qua AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-qui AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-sab AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-sex AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-tempo-proc AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ter AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE i-hr1 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr2 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr3 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr4 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr5 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr6 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-hr7 AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm3 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm4 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm5 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm6 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-mm7 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 11.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     turno.cd-turno AT ROW 1.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     turno.descricao AT ROW 2.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     turno.hr-dia-1 AT ROW 6.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-1 AT ROW 6.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr1 AT ROW 6.25 COL 64 NO-LABEL
     i-mm1 AT ROW 6.25 COL 67 COLON-ALIGNED
     turno.hr-dia-2 AT ROW 7.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-2 AT ROW 7.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr2 AT ROW 7.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm2 AT ROW 7.25 COL 67 COLON-ALIGNED
     turno.hr-dia-3 AT ROW 8.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-3 AT ROW 8.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr3 AT ROW 8.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm3 AT ROW 8.25 COL 67 COLON-ALIGNED
     turno.hr-dia-4 AT ROW 9.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-4 AT ROW 9.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr4 AT ROW 9.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm4 AT ROW 9.25 COL 67 COLON-ALIGNED
     turno.hr-dia-5 AT ROW 10.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-5 AT ROW 10.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr5 AT ROW 10.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm5 AT ROW 10.25 COL 67 COLON-ALIGNED
     turno.hr-dia-6 AT ROW 11.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-6 AT ROW 11.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr6 AT ROW 11.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm6 AT ROW 11.25 COL 67 COLON-ALIGNED
     turno.hr-dia-7 AT ROW 12.25 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     turno.hr-parada-7 AT ROW 12.25 COL 46 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-hr7 AT ROW 12.25 COL 62 COLON-ALIGNED NO-LABEL
     i-mm7 AT ROW 12.25 COL 67 COLON-ALIGNED
     fi-tempo-proc AT ROW 5.25 COL 27 NO-LABEL
     fi-interrupcao AT ROW 5.25 COL 44 COLON-ALIGNED NO-LABEL
     fi-hora-inic AT ROW 5.25 COL 61 COLON-ALIGNED NO-LABEL
     fi-dom AT ROW 6.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-seg AT ROW 7.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-ter AT ROW 8.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-qua AT ROW 9.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-qui AT ROW 10.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-sex AT ROW 11.25 COL 14 COLON-ALIGNED NO-LABEL
     fi-sab AT ROW 12.25 COL 14 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-4 AT ROW 4.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.turno
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
         HEIGHT             = 14.58
         WIDTH              = 88.29.
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

/* SETTINGS FOR FILL-IN turno.cd-turno IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN turno.descricao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-dom IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-hora-inic IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-interrupcao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qua IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qui IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-seg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sex IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tempo-proc IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-ter IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-hr1 IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR FILL-IN i-hr2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-hr3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-hr4 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-hr5 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-hr6 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-hr7 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm4 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm5 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm6 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-mm7 IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {utp/ut-field.i mgind turno hr-dia-1 1}
  ASSIGN fi-tempo-proc = RETURN-VALUE.
  
  {utp/ut-field.i mgind turno hr-parada-1 1}
  ASSIGN fi-interrupcao = RETURN-VALUE.
  
  {utp/ut-field.i mgind calen-data hora-ini 1}
  ASSIGN fi-hora-inic = RETURN-VALUE.
  
  {utp/ut-liter.i "Dom" * "L"}
  ASSIGN fi-dom = " " + RETURN-VALUE.        
  
  {utp/ut-liter.i "Seg" * "L"}
  ASSIGN fi-seg = " " + RETURN-VALUE.
  
  {utp/ut-liter.i "Ter" * "L"}
  ASSIGN fi-ter = " " + RETURN-VALUE.
  
  {utp/ut-liter.i "Qua" * "L"}
  ASSIGN fi-qua = " " + RETURN-VALUE.
  
  {utp/ut-liter.i "Qui" * "L"}
  ASSIGN fi-qui = " " + RETURN-VALUE.
  
  {utp/ut-liter.i "Sex" * "L"}
  ASSIGN fi-sex = " " + RETURN-VALUE.
 
  {utp/ut-liter.i "Sab" * "L"} 
  ASSIGN fi-sab = " " + RETURN-VALUE.
  
  DISP fi-tempo-proc
       fi-interrupcao
       fi-hora-inic
       fi-dom
       fi-seg
       fi-ter
       fi-qua
       fi-qui
       fi-sex
       fi-sab
       WITH FRAME {&frame-name}.
  
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cd-turno':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = turno
           &WHERE = "WHERE turno.cd-turno eq key-value"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "turno"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "turno"}

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
  
  ASSIGN i-hr1 = 0
         i-mm1 = 0
         i-hr2 = 0
         i-mm2 = 0
         i-hr3 = 0
         i-mm3 = 0
         i-hr4 = 0
         i-mm4 = 0
         i-hr5 = 0
         i-mm5 = 0
         i-hr6 = 0
         i-mm6 = 0
         i-hr7 = 0
         i-mm7 = 0.    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
   DISP fi-tempo-proc
        fi-interrupcao
        fi-hora-inic
        fi-dom
        fi-seg
        fi-ter
        fi-qua
        fi-qui
        fi-sex
        fi-sab
        i-hr1 
        i-mm1 
        i-hr2 
        i-mm2 
        i-hr3 
        i-mm3 
        i-hr4 
        i-mm4 
        i-hr5 
        i-mm5 
        i-hr6 
        i-mm6 
        i-hr7 
        i-mm7 
        WITH FRAME {&frame-name}.

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  
  DO WITH FRAME {&frame-name}:
     ASSIGN i-hr1 i-hr2 i-hr3 i-hr4 i-hr5 i-hr6 i-hr7
            i-mm1 i-mm2 i-mm3 i-mm4 i-mm5 i-mm6 i-mm7.  
  END.

  IF  turno.cd-turno:SENSITIVE = true THEN DO:
      FIND turno WHERE turno.cd-turno = INPUT FRAME {&frame-name} turno.cd-turno NO-LOCK NO-ERROR.
      IF  AVAIL turno THEN DO:
          RUN utp/ut-msgs.p (input "show",
                             input 7243,
                             input "").
          APPLY "entry" TO turno.cd-turno IN FRAME {&frame-name}.
          RETURN "adm-error".                         
      END. /* if avail turno ... */
  END. /* if turno ... */
  
                               /* Valida‡Æo Hora 1 */  
  IF  INPUT FRAME {&frame-name} i-hr1 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr1 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr1 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm1 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm1 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm1 ... */
    
                                /* Valida‡Æo Hora 2 */
  
  IF  INPUT FRAME {&frame-name} i-hr2 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr2 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr2 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm2 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm2 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm2 ... */
    
                                /* Valida‡Æo Hora 3 */
   
  IF  INPUT FRAME {&frame-name} i-hr3 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr3 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr3 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm3 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm3 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm3 ... */
    
                                /* Valida‡Æo Hora 4 */
    
  IF  INPUT FRAME {&frame-name} i-hr4 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr4 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr4 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm4 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm4 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm4 ... */
    
                                /* Valida‡Æo Hora 5 */
          
  IF  INPUT FRAME {&frame-name} i-hr5 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr5 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr5 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm5 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm5 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm5 ... */
                  
                                /* Valida‡Æo Hora 6 */
                                     
  IF  INPUT FRAME {&frame-name} i-hr6 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr6 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr6 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm6 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm6 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm6 ... */
                                                                                        
                                /* Valida‡Æo Hora 7 */                                
    
  IF  INPUT FRAME {&frame-name} i-hr7 > 23 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7181,
                         input "").
      APPLY "entry" TO i-hr7 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-hr7 ... */
  
  IF  INPUT FRAME {&frame-name} i-mm7 >= 60 THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 7182,
                         input "").
      APPLY "entry" TO i-mm7 IN FRAME {&frame-name}.
      RETURN "adm-error".                         
  END. /* if i-mm7 ... */

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .   
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
         
  {cdp/cd0282.i 1}.      
  {cdp/cd0282.i 2}.
  {cdp/cd0282.i 3}.
  {cdp/cd0282.i 4}.
  {cdp/cd0282.i 5}.
  {cdp/cd0282.i 6}.
  {cdp/cd0282.i 7}.
  
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  IF  AVAIL turno THEN DO:
      {cdp/cd0282.i1 1}.
      {cdp/cd0282.i1 2}.
      {cdp/cd0282.i1 3}.
      {cdp/cd0282.i1 4}.
      {cdp/cd0282.i1 5}.
      {cdp/cd0282.i1 6}.
      {cdp/cd0282.i1 7}.
  END. /* if avail turno ... */

 if avail turno then
  assign gr-turno = rowid (turno).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/   
                                                                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cd-turno" "turno" "cd-turno"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "turno"}

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


