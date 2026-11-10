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
{include/i-prgvrs.i V20IN270 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V20IN270 MUT}
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
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-2 f-nome-1 f-nome-2 f-nome-3 
&Scoped-Define DISPLAYED-OBJECTS de-man-prev-mob-d de-man-prev-mob-g ~
de-man-prev-mat de-man-corr-mob-d de-man-corr-mob-g de-man-corr-mat ~
de-man-pred-mob-d de-man-pred-mob-g de-man-pred-mat de-tot-man-mob-d ~
de-tot-man-mob-g de-tot-man-mat f-nome-1 f-nome-2 f-nome-3 

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
DEFINE VARIABLE de-man-corr-mat AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-corr-mob-d AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-corr-mob-g AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-pred-mat AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-pred-mob-d AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-pred-mob-g AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-prev-mat AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-prev-mob-d AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-man-prev-mob-g AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-man-mat AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-man-mob-d AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-man-mob-g AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE f-nome-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE f-nome-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE f-nome-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 7.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 7.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     de-man-prev-mob-d AT ROW 2.5 COL 25 COLON-ALIGNED
     de-man-prev-mob-g AT ROW 2.5 COL 42 COLON-ALIGNED NO-LABEL
     de-man-prev-mat AT ROW 2.5 COL 59 COLON-ALIGNED NO-LABEL
     de-man-corr-mob-d AT ROW 3.5 COL 25 COLON-ALIGNED
     de-man-corr-mob-g AT ROW 3.5 COL 42 COLON-ALIGNED NO-LABEL
     de-man-corr-mat AT ROW 3.5 COL 59 COLON-ALIGNED NO-LABEL
     de-man-pred-mob-d AT ROW 4.5 COL 25 COLON-ALIGNED
     de-man-pred-mob-g AT ROW 4.5 COL 42 COLON-ALIGNED NO-LABEL
     de-man-pred-mat AT ROW 4.5 COL 59 COLON-ALIGNED NO-LABEL
     de-tot-man-mob-d AT ROW 5.5 COL 25 COLON-ALIGNED
     de-tot-man-mob-g AT ROW 5.5 COL 42 COLON-ALIGNED NO-LABEL
     de-tot-man-mat AT ROW 5.5 COL 59 COLON-ALIGNED NO-LABEL
     f-nome-1 AT ROW 1.75 COL 25 COLON-ALIGNED NO-LABEL
     f-nome-2 AT ROW 1.75 COL 42 COLON-ALIGNED NO-LABEL
     f-nome-3 AT ROW 1.75 COL 59 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1 COL 1
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
         HEIGHT             = 7.46
         WIDTH              = 84.14.
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

/* SETTINGS FOR FILL-IN de-man-corr-mat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-corr-mob-d IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-corr-mob-g IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-pred-mat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-pred-mob-d IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-pred-mob-g IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-prev-mat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-prev-mob-d IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-man-prev-mob-g IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tot-man-mat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tot-man-mob-d IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tot-man-mob-g IN FRAME F-Main
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

{utp/ut-liter.i Manuten‡äes_Preventivas mmi r}
assign de-man-prev-mob-d:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Manuten‡äes_Corretivas mmi r}
assign de-man-corr-mob-d:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i  Manuten‡äes_Preditivas mmi r}
assign de-man-pred-mob-d:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Total_Geral_das_Manuten‡äes mmi r}
assign de-tot-man-mob-d:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i MÆo_de_Obra * r}
assign f-nome-1:screen-value in frame {&frame-name} = return-value.
{utp/ut-liter.i GGF * r}
assign f-nome-2:screen-value in frame {&frame-name} = return-value.
{utp/ut-liter.i Material * r}
assign f-nome-3:screen-value in frame {&frame-name} = return-value.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variaveis V-table-Win 
PROCEDURE pi-atualiza-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define input parameter de-par-man-prev-mat   as decimal no-undo.
define input parameter de-par-man-prev-mob-d as decimal no-undo.
define input parameter de-par-man-prev-mob-g as decimal no-undo.
define input parameter de-par-man-corr-mat   as decimal no-undo.
define input parameter de-par-man-corr-mob-d as decimal no-undo.
define input parameter de-par-man-corr-mob-g as decimal no-undo.
define input parameter de-par-man-pred-mat   as decimal no-undo.
define input parameter de-par-man-pred-mob-d as decimal no-undo.
define input parameter de-par-man-pred-mob-g as decimal no-undo.

    assign de-man-prev-mat   = de-par-man-prev-mat
           de-man-prev-mob-d = de-par-man-prev-mob-d
           de-man-prev-mob-g = de-par-man-prev-mob-g
           de-man-corr-mat   = de-par-man-corr-mat
           de-man-corr-mob-d = de-par-man-corr-mob-d
           de-man-corr-mob-g = de-par-man-corr-mob-g
           de-man-pred-mat   = de-par-man-pred-mat
           de-man-pred-mob-d = de-par-man-pred-mob-d
           de-man-pred-mob-g = de-par-man-pred-mob-g.

    assign de-tot-man-mob-d = de-man-prev-mob-d +
                              de-man-corr-mob-d +
                              de-man-pred-mob-d
           de-tot-man-mob-g = de-man-prev-mob-g +
                              de-man-corr-mob-g +
                              de-man-pred-mob-g
           de-tot-man-mat   = de-man-prev-mat +
                              de-man-corr-mat +
                              de-man-pred-mat.

    disp de-man-prev-mob-d 
         de-man-prev-mob-g
         de-man-prev-mat  
         de-man-corr-mob-d
         de-man-corr-mob-g
         de-man-corr-mat  
         de-man-pred-mob-d
         de-man-pred-mob-g
         de-man-pred-mat  
         de-tot-man-mob-d
         de-tot-man-mob-g
         de-tot-man-mat with frame {&frame-name}.


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


