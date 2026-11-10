&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V01IN566 2.00.00.024} /*** "010024" 26/09/2025 10:48:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in566 MUT}
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
def new global shared var v-row-parent   as rowid no-undo.         
def new global shared var gr-tab-mob-dir as rowid no-undo.                       
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgman.i}

def var i-moeda as integer.
def var i-moeda-estoq as integer.
def var de-aux as decimal no-undo.
def var h-handle as handle no-undo.

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


{csp/csapi021.i1}

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
&Scoped-define EXTERNAL-TABLES tab-mob-dir
&Scoped-define FIRST-EXTERNAL-TABLE tab-mob-dir


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tab-mob-dir.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-69 rt-key 
&Scoped-Define DISPLAYED-FIELDS tab-mob-dir.cd-mob-dir ~
tab-mob-dir.descricao tab-mob-dir.dt-atualiz-cor tab-mob-dir.vl-corrente[1] ~
tab-mob-dir.vl-corrente[2] tab-mob-dir.vl-corrente[3] ~
tab-mob-dir.dt-atualiz-pad tab-mob-dir.vl-padrao[1] ~
tab-mob-dir.vl-padrao[2] tab-mob-dir.vl-padrao[3] ~
tab-mob-dir.dt-atualiz-orc tab-mob-dir.vl-orcado[1] ~
tab-mob-dir.vl-orcado[2] tab-mob-dir.vl-orcado[3] ~
tab-mob-dir.val-cust-geren[1] tab-mob-dir.val-cust-geren[2] ~
tab-mob-dir.val-cust-geren[3] 
&Scoped-define DISPLAYED-TABLES tab-mob-dir
&Scoped-define FIRST-DISPLAYED-TABLE tab-mob-dir


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tab-mob-dir.cd-mob-dir ~
tab-mob-dir.descricao tab-mob-dir.dt-atualiz-cor tab-mob-dir.vl-corrente[1] ~
tab-mob-dir.vl-corrente[2] tab-mob-dir.vl-corrente[3] ~
tab-mob-dir.dt-atualiz-pad tab-mob-dir.vl-padrao[1] ~
tab-mob-dir.vl-padrao[2] tab-mob-dir.vl-padrao[3] ~
tab-mob-dir.dt-atualiz-orc tab-mob-dir.vl-orcado[1] ~
tab-mob-dir.vl-orcado[2] tab-mob-dir.vl-orcado[3] ~
tab-mob-dir.val-cust-geren[1] tab-mob-dir.val-cust-geren[2] ~
tab-mob-dir.val-cust-geren[3] 
&Scoped-define ADM-ASSIGN-FIELDS tab-mob-dir.descricao ~
tab-mob-dir.dt-atualiz-cor tab-mob-dir.vl-corrente[1] ~
tab-mob-dir.vl-corrente[2] tab-mob-dir.vl-corrente[3] ~
tab-mob-dir.dt-atualiz-pad tab-mob-dir.vl-padrao[1] ~
tab-mob-dir.vl-padrao[2] tab-mob-dir.vl-padrao[3] ~
tab-mob-dir.dt-atualiz-orc tab-mob-dir.vl-orcado[1] ~
tab-mob-dir.vl-orcado[2] tab-mob-dir.vl-orcado[3] ~
tab-mob-dir.val-cust-geren[1] tab-mob-dir.val-cust-geren[2] ~
tab-mob-dir.val-cust-geren[3] 
&Scoped-define ADM-MODIFY-FIELDS tab-mob-dir.descricao ~
tab-mob-dir.dt-atualiz-cor tab-mob-dir.vl-corrente[1] ~
tab-mob-dir.vl-corrente[2] tab-mob-dir.vl-corrente[3] ~
tab-mob-dir.dt-atualiz-pad tab-mob-dir.vl-padrao[1] ~
tab-mob-dir.vl-padrao[2] tab-mob-dir.vl-padrao[3] ~
tab-mob-dir.dt-atualiz-orc tab-mob-dir.vl-orcado[1] ~
tab-mob-dir.vl-orcado[2] tab-mob-dir.vl-orcado[3] ~
tab-mob-dir.val-cust-geren[1] tab-mob-dir.val-cust-geren[2] ~
tab-mob-dir.val-cust-geren[3] 

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
DEFINE VARIABLE fi-moeda-g1 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE fi-moeda-g2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE fi-moeda1 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE fi-moeda2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 8.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tab-mob-dir.cd-mob-dir AT ROW 1.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tab-mob-dir.descricao AT ROW 2.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     tab-mob-dir.dt-atualiz-cor AT ROW 3.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-corrente[1] AT ROW 4.75 COL 26 COLON-ALIGNED FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-corrente[2] AT ROW 4.75 COL 45 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-corrente[3] AT ROW 4.75 COL 65 COLON-ALIGNED NO-LABEL FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.dt-atualiz-pad AT ROW 6 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-padrao[1] AT ROW 7 COL 26 COLON-ALIGNED FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-padrao[2] AT ROW 7 COL 45 COLON-ALIGNED NO-LABEL FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-padrao[3] AT ROW 7 COL 65 COLON-ALIGNED NO-LABEL FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.dt-atualiz-orc AT ROW 8.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-orcado[1] AT ROW 9.25 COL 26 COLON-ALIGNED FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-orcado[2] AT ROW 9.25 COL 45 COLON-ALIGNED NO-LABEL FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.vl-orcado[3] AT ROW 9.25 COL 65 COLON-ALIGNED NO-LABEL FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.val-cust-geren[1] AT ROW 11 COL 26 COLON-ALIGNED WIDGET-ID 2 FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.val-cust-geren[2] AT ROW 11 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tab-mob-dir.val-cust-geren[3] AT ROW 11 COL 66 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-moeda1 AT ROW 3.75 COL 49 COLON-ALIGNED NO-LABEL
     fi-moeda2 AT ROW 3.75 COL 68 COLON-ALIGNED NO-LABEL
     fi-moeda-g1 AT ROW 10.25 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-moeda-g2 AT ROW 10.25 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     RECT-69 AT ROW 3.5 COL 1
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.tab-mob-dir
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
         HEIGHT             = 11.25
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN tab-mob-dir.cd-mob-dir IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tab-mob-dir.descricao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN tab-mob-dir.dt-atualiz-cor IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN tab-mob-dir.dt-atualiz-orc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN tab-mob-dir.dt-atualiz-pad IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-moeda-g1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda-g2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN tab-mob-dir.val-cust-geren[1] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
ASSIGN 
       tab-mob-dir.val-cust-geren[1]:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN tab-mob-dir.val-cust-geren[2] IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
ASSIGN 
       tab-mob-dir.val-cust-geren[2]:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN tab-mob-dir.val-cust-geren[3] IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
ASSIGN 
       tab-mob-dir.val-cust-geren[3]:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN tab-mob-dir.vl-corrente[1] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-corrente[2] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-corrente[3] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-orcado[1] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-orcado[2] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-orcado[3] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-padrao[1] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-padrao[2] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tab-mob-dir.vl-padrao[3] IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-FORMAT                                           */
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

&Scoped-define SELF-NAME tab-mob-dir.dt-atualiz-cor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.dt-atualiz-cor V-table-Win
ON LEAVE OF tab-mob-dir.dt-atualiz-cor IN FRAME f-main /* Data Atualiz Valor */
DO:
   if avail tab-mob-dir then
      if input tab-mob-dir.dt-atualiz-cor <> tab-mob-dir.dt-atualiz-cor then 
         apply "leave" to tab-mob-dir.vl-corrente[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-mob-dir.dt-atualiz-orc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.dt-atualiz-orc V-table-Win
ON LEAVE OF tab-mob-dir.dt-atualiz-orc IN FRAME f-main /* Data Atualiz Valor */
DO:
   if avail tab-mob-dir then
      if input tab-mob-dir.dt-atualiz-orc <> tab-mob-dir.dt-atualiz-orc then 
         apply "leave" to tab-mob-dir.vl-orcado[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-mob-dir.dt-atualiz-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.dt-atualiz-pad V-table-Win
ON LEAVE OF tab-mob-dir.dt-atualiz-pad IN FRAME f-main /* Data Atualiz Valor */
DO:
   if avail tab-mob-dir then
      if input tab-mob-dir.dt-atualiz-pad <> tab-mob-dir.dt-atualiz-pad then 
         apply "leave" to tab-mob-dir.vl-padrao[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-mob-dir.vl-corrente[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.vl-corrente[1] V-table-Win
ON LEAVE OF tab-mob-dir.vl-corrente[1] IN FRAME f-main /* Valor Corrente[1] */
DO:
   do i-moeda = 2 to 3:
      if i-moeda = 2 and param-estoq.tem-moeda1
         then assign i-moeda-estoq = param-estoq.moeda1.
         else if i-moeda = 3 and param-estoq.tem-moeda2
                 then assign i-moeda-estoq = param-estoq.moeda2.
                 else next.
      run cdp/cd0812.p (input 0,
                        input i-moeda-estoq,
                        input (input tab-mob-dir.vl-corrente[1]),
                        input (input tab-mob-dir.dt-atualiz-cor),
                        output de-aux).
      case i-moeda:
         when 2 then 
            if de-aux <> ? then
               assign tab-mob-dir.vl-corrente[2]:screen-value = string (de-aux).
         when 3 then
            if de-aux <> ? then
               assign tab-mob-dir.vl-corrente[3]:screen-value = string (de-aux).
      end. 
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-mob-dir.vl-orcado[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.vl-orcado[1] V-table-Win
ON LEAVE OF tab-mob-dir.vl-orcado[1] IN FRAME f-main /* Valor Oráado[1] */
DO:    
   do i-moeda = 2 to 3:
      if i-moeda = 2 and param-estoq.tem-moeda1
         then assign i-moeda-estoq = param-estoq.moeda1.
         else if i-moeda = 3 and param-estoq.tem-moeda2
                 then assign i-moeda-estoq = param-estoq.moeda2.
                 else next.
      run cdp/cd0812.p (input 0,
                        input i-moeda-estoq,
                        input (input tab-mob-dir.vl-orcado[1]),
                        input (input tab-mob-dir.dt-atualiz-orc),
                        output de-aux).
      case i-moeda:
         when 2 then
            if de-aux <> ? then 
               assign tab-mob-dir.vl-orcado[2]:screen-value = string (de-aux).             
         when 3 then
            if de-aux <> ? then
               assign tab-mob-dir.vl-orcado[3]:screen-value = string (de-aux).
      end. 
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-mob-dir.vl-padrao[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-mob-dir.vl-padrao[1] V-table-Win
ON LEAVE OF tab-mob-dir.vl-padrao[1] IN FRAME f-main /* Valor Padr∆o[1] */
DO:
   do i-moeda = 2 to 3:
      if i-moeda = 2 and param-estoq.tem-moeda1
         then assign i-moeda-estoq = param-estoq.moeda1.
         else if i-moeda = 3 and param-estoq.tem-moeda2
                 then assign i-moeda-estoq = param-estoq.moeda2.
                 else next.
      run cdp/cd0812.p (input 0,
                        input i-moeda-estoq,
                        input (input tab-mob-dir.vl-padrao[1])  ,
                        input (input tab-mob-dir.dt-atualiz-pad),
                        output de-aux).                        
      case i-moeda:
         when 2 then 
            if de-aux <> ? then 
               assign tab-mob-dir.vl-padrao[2]:screen-value = string (de-aux).             
         when 3 then
            if de-aux <> ? then 
               assign tab-mob-dir.vl-padrao[3]:screen-value = string (de-aux).
      end. 
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
  {src/adm/template/row-list.i "tab-mob-dir"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tab-mob-dir"}

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

  if param-estoq.tem-moeda1 then do:
     find first moeda where moeda.mo-codigo = param-estoq.moeda1
          no-lock no-error.
     assign fi-moeda1 = moeda.descricao.
  end.
  else
     assign fi-moeda1 = "".

  if param-estoq.tem-moeda2 then do:
     find first moeda where moeda.mo-codigo = param-estoq.moeda2
          no-lock no-error.
     assign fi-moeda2 = moeda.descricao.
  end.
  else
     assign fi-moeda2 = "".

  disp fi-moeda1
       fi-moeda2 
       with frame {&frame-name}.

  assign tab-mob-dir.dt-atualiz-pad:screen-value in frame {&frame-name} = string(today) 
         tab-mob-dir.dt-atualiz-cor:screen-value in frame {&frame-name} = string(today)
         tab-mob-dir.dt-atualiz-orc:screen-value in frame {&frame-name} = string(today).

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
  {include/i-valid.i}

  if tab-mob-dir.cd-mob-dir:sensitive in frame {&frame-name} and
     can-find (tab-mob-dir where tab-mob-dir.cd-mob-dir =
               input frame {&frame-name} tab-mob-dir.cd-mob-dir) then do:
     {utp/ut-table.i mgind tab-mob-dir 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).        
     return 'adm-error'.
  end.                

  if input frame {&frame-name} tab-mob-dir.cd-mob-dir = "" then do :
     run utp/ut-msgs.p (input "show",
                        input 16263 ,
                        input ""    ).
     apply "entry" to tab-mob-dir.cd-mob-dir in frame {&frame-name}.
     return "adm-error".
  end.     


  if input frame {&frame-name} tab-mob-dir.descricao = "" then do :
     run utp/ut-msgs.p (input "show",
                        input 190   ,
                        input ""    ).
     apply "entry" to tab-mob-dir.descricao in frame {&frame-name}.
     return "adm-error".
  end.     

  &IF DEFINED (bf_man_custeio_item) &THEN
  assign tab-mob-dir.dt-atualiz-pad:screen-value in frame {&frame-name} = string(today).
  &ENDIF 

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

find first movto-dir 
    where movto-dir.cd-mob-dir = tab-mob-dir.cd-mob-dir no-lock no-error.
if avail movto-dir then do:
    run utp/ut-msgs.p (INPUT "show",
                       input 3,
                       input movto-dir.cd-mob-dir).
    return 'adm-error'.
end.

&IF DEFINED(bf_man_sfc_lc) &THEN
    /*a partir da release 202 (Preprocessador bf_man_sfc_lc = release 202)*/
    DEFINE VARIABLE c-liter AS CHARACTER  NO-UNDO.

    /*valida a exclus∆o contra a tabela Operador*/
    IF CAN-FIND(FIRST operador WHERE operador.cd-mob-dir = tab-mob-dir.cd-mob-dir NO-LOCK) THEN DO:
        {utp/ut-liter.i Mob_Direta *}
        ASSIGN c-liter = RETURN-VALUE.
        {utp/ut-liter.i Operador *}
        run utp/ut-msgs.p (INPUT "show",
                           input 5,
                           input c-liter + "~~":U + RETURN-VALUE).
        return 'adm-error'.
    END.
&ENDIF

/******Validaá∆o para Frotas*****/

    run cdp/cd9902.p (input 3).  /** Manutená∆o MecÉnica **/
    if return-value = "OK":U then do:
        assign lValida = yes.                
    end.

    if lValida then do:
        /** Passa o rowid para API de Frotas **/
        run abp/abapi008.p persistent set h-abapi008 (input rowid(tab-mob-dir)).
        /** ValidaªÑes **/
        run validateMaoObra in h-abapi008 (INPUT tab-mob-dir.cd-mob-dir).
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
            for each RowErrorsFrotas exclusive-lock:
                delete RowErrorsFrotas.
            end.
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





  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
  IF l-fnc-fech-gerenc THEN
     DISABLE tab-mob-dir.val-cust-geren[1] WITH FRAME {&FRAME-NAME}.
  
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

  if not param-estoq.tem-moeda1 then 
     assign tab-mob-dir.vl-corrente[2]:visible in frame {&frame-name} = no             
            tab-mob-dir.vl-orcado[2]:visible   in frame {&frame-name} = no
            tab-mob-dir.vl-padrao[2]:visible   in frame {&frame-name} = no.

  if not param-estoq.tem-moeda2 then 
     assign tab-mob-dir.vl-corrente[3]:visible in frame {&frame-name} = no
            tab-mob-dir.vl-orcado[3]:visible   in frame {&frame-name} = no
            tab-mob-dir.vl-padrao[3]:visible   in frame {&frame-name} = no.

 /*&IF DEFINED (bf_man_custeio_item) &THEN*/
     assign tab-mob-dir.dt-atualiz-pad:visible in frame {&frame-name} = YES.
 /*&ENDIF  */  

     IF l-usa-fech-gerenc THEN DO:
        ENABLE tab-mob-dir.val-cust-geren[1] WITH FRAME {&FRAME-NAME}.

        IF log-tem-moed-geren-1 THEN 
            ENABLE tab-mob-dir.val-cust-geren[2] WITH FRAME {&FRAME-NAME}.
        ELSE tab-mob-dir.val-cust-geren[2]:visible   in frame {&frame-name} = NO.

        IF log-tem-moed-geren-2 THEN 
            ENABLE tab-mob-dir.val-cust-geren[3] WITH FRAME {&FRAME-NAME}.
        ELSE tab-mob-dir.val-cust-geren[3]:visible   in frame {&frame-name} = NO.
     END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR c-label-val-cust-gerencial AS CHAR NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
assign tab-mob-dir.dt-atualiz-pad:visible in frame {&frame-name} = YES
       tab-mob-dir.vl-padrao[1]:visible   in frame {&frame-name} = YES
       tab-mob-dir.vl-padrao[2]:visible   in frame {&frame-name} = YES
       tab-mob-dir.vl-padrao[3]:visible   in frame {&frame-name} = YES.

{utp/ut-liter.i Valor_Oráado[2] *}
ASSIGN tab-mob-dir.vl-padrao[1]:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

FIND FIRST param-estoq NO-LOCK NO-ERROR.

IF l-usa-fech-gerenc AND AVAIL param-estoq THEN DO:
    {utp/ut-liter.i Valor_Hora_ *}

    ASSIGN c-label-val-cust-gerencial = RETURN-VALUE + param-estoq.cod-cenar-geren.
END.
ELSE DO:
    {utp/ut-liter.i Valor_Hora_Gerencial *}
    ASSIGN c-label-val-cust-gerencial = RETURN-VALUE.
END.

ASSIGN tab-mob-dir.val-cust-geren[1]:LABEL IN FRAME {&FRAME-NAME} = c-label-val-cust-gerencial.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-estoq no-lock no-error.  
  if avail(param-estoq) then do : 

     if  param-estoq.tem-moeda1 then do:
         find first moeda where moeda.mo-codigo = param-estoq.moeda1
              no-lock no-error.
         assign fi-moeda1:screen-value in frame {&frame-name} = moeda.descricao.
     end.
     else
         assign fi-moeda1:screen-value             in frame {&frame-name} = ""
                tab-mob-dir.vl-corrente[2]:visible in frame {&frame-name} = no             
                tab-mob-dir.vl-orcado[2]:visible   in frame {&frame-name} = no
                tab-mob-dir.vl-padrao[2]:visible   in frame {&frame-name} = no.         

     if  param-estoq.tem-moeda2 then do:
         find first moeda where 
                    moeda.mo-codigo = param-estoq.moeda2
                    no-lock no-error.
         assign fi-moeda2:screen-value in frame {&frame-name} = moeda.descricao.
     end.
     else
         assign fi-moeda2:screen-value             in frame {&frame-name} = ""  
                tab-mob-dir.vl-corrente[3]:visible in frame {&frame-name} = no
                tab-mob-dir.vl-orcado[3]:visible   in frame {&frame-name} = no
                tab-mob-dir.vl-padrao[3]:visible   in frame {&frame-name} = no.                      
  end.
  else do :
     run utp/ut-msgs.p (input "show",
                        input 1059  ,
                        input ""    ).
     apply "close" to this-procedure.
     return.                   
  end.   

  IF l-usa-fech-gerenc = YES THEN DO:
     ASSIGN tab-mob-dir.val-cust-geren[1]:VISIBLE in frame {&FRAME-NAME} = YES.

     IF log-tem-moed-geren-1 THEN DO:
         find first moeda where moeda.mo-codigo = cdn-moed-geren-1
              no-lock no-error.

         ASSIGN tab-mob-dir.val-cust-geren[2]:VISIBLE in frame {&FRAME-NAME} = YES 
                fi-moeda-g1:VISIBLE IN FRAME {&FRAME-NAME} = YES
                fi-moeda-g1:SCREEN-VALUE IN FRAME {&frame-name} = moeda.descricao.

     END.
     IF log-tem-moed-geren-2 THEN DO:
         find first moeda where moeda.mo-codigo = cdn-moed-geren-2
              no-lock no-error.

         ASSIGN tab-mob-dir.val-cust-geren[3]:VISIBLE in frame {&FRAME-NAME} = YES
                fi-moeda-g2:VISIBLE IN FRAME {&FRAME-NAME} = YES
                fi-moeda-g2:SCREEN-VALUE IN FRAME {&frame-name} = moeda.descricao.

     END.

  END.



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

  if avail tab-mob-dir then
     assign gr-tab-mob-dir = rowid(tab-mob-dir).

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
  {src/adm/template/snd-list.i "tab-mob-dir"}

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

