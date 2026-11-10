&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i  2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-periodoa i-equ-corr-a i-man-corr-a ~
i-equ-prev-a i-man-prev-a i-equ-pred-a i-man-pred-a c-periodob i-equ-corr-b ~
i-man-corr-b i-equ-prev-b i-man-prev-b i-equ-pred-b i-man-pred-b 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-periodoa AS CHARACTER FORMAT "99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodob AS CHARACTER FORMAT "99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-corr-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-corr-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-pred-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-pred-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-prev-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-equ-prev-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-corr-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-corr-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-pred-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-pred-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-prev-a AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-man-prev-b AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 14.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-periodoa AT ROW 1.17 COL 33 COLON-ALIGNED
     i-equ-corr-a AT ROW 2.17 COL 33 COLON-ALIGNED
     i-man-corr-a AT ROW 3.17 COL 33 COLON-ALIGNED
     i-equ-prev-a AT ROW 4.17 COL 33 COLON-ALIGNED
     i-man-prev-a AT ROW 5.17 COL 33 COLON-ALIGNED
     i-equ-pred-a AT ROW 6.17 COL 33 COLON-ALIGNED
     i-man-pred-a AT ROW 7.17 COL 33 COLON-ALIGNED
     c-periodob AT ROW 8.67 COL 33 COLON-ALIGNED
     i-equ-corr-b AT ROW 9.67 COL 33 COLON-ALIGNED
     i-man-corr-b AT ROW 10.67 COL 33 COLON-ALIGNED
     i-equ-prev-b AT ROW 11.67 COL 33 COLON-ALIGNED
     i-man-prev-b AT ROW 12.67 COL 33 COLON-ALIGNED
     i-equ-pred-b AT ROW 13.67 COL 33 COLON-ALIGNED
     i-man-pred-b AT ROW 14.67 COL 33 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 14.92
         WIDTH              = 71.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-periodoa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodob IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-corr-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-corr-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-pred-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-pred-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-prev-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-equ-prev-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-corr-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-corr-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-pred-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-pred-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-prev-a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-man-prev-b IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Per¡odo * r}
assign c-periodoa:label in frame {&frame-name} = trim(return-value)
       c-periodob:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Equiptos_Manut_Corretivas mmi r}
assign i-equ-corr-a:label in frame {&frame-name} = trim(return-value)
       i-equ-corr-b:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Manuten‡äes_Corretivas mmi r}
assign i-man-corr-a:label in frame {&frame-name} = trim(return-value)
       i-man-corr-b:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Equiptos_Manut_Preventivas mmi r}
assign i-equ-prev-a:label in frame {&frame-name} = trim(return-value)
       i-equ-prev-b:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Manuten‡äes_Preventivas mmi r}
assign i-man-prev-a:label in frame {&frame-name} = trim(return-value)
       i-man-prev-b:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Equiptos_Manut_Preditivas mmi r}
assign i-equ-pred-a:label in frame {&frame-name} = trim(return-value)
       i-equ-pred-b:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Manuten‡äes_Preditivas mmi r}
assign i-man-pred-a:label in frame {&frame-name} = trim(return-value)
       i-man-pred-b:label in frame {&frame-name} = trim(return-value).

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-variaveis V-table-Win 
PROCEDURE pi-inicializa-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define input parameter c-par-periodoa    as char format "99/9999"        no-undo.
define input parameter i-par-equ-corr-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-equ-prev-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-equ-pred-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-corr-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-prev-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-pred-a  as integer format ">>>,>>>,>>9" no-undo.
define input parameter c-par-periodob    as char format "99/9999"        no-undo.
define input parameter i-par-equ-corr-b  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-equ-prev-b  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-equ-pred-b  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-corr-b  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-prev-b  as integer format ">>>,>>>,>>9" no-undo.
define input parameter i-par-man-pred-b  as integer format ">>>,>>>,>>9" no-undo.

assign c-periodoa   = c-par-periodoa
       i-equ-corr-a = i-par-equ-corr-a
       i-equ-prev-a = i-par-equ-prev-a
       i-equ-pred-a = i-par-equ-pred-a
       i-man-corr-a = i-par-man-corr-a
       i-man-prev-a = i-par-man-prev-a
       i-man-pred-a = i-par-man-pred-a
       c-periodob   = c-par-periodob
       i-equ-corr-b = i-par-equ-corr-b
       i-equ-prev-b = i-par-equ-prev-b
       i-equ-pred-b = i-par-equ-pred-b
       i-man-corr-b = i-par-man-corr-b
       i-man-prev-b = i-par-man-prev-b
       i-man-pred-b = i-par-man-pred-b.
       
display c-periodoa
        i-equ-corr-a
        i-equ-prev-a
        i-equ-pred-a
        i-man-corr-a
        i-man-prev-a
        i-man-pred-a
        c-periodob
        i-equ-corr-b
        i-equ-prev-b
        i-equ-pred-b
        i-man-corr-b
        i-man-prev-b
        i-man-pred-b
        with frame {&frame-name}.


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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


