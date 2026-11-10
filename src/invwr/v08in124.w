&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V08IN124 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN124 MUT}
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

def var i-receb    as integer extent 3 no-undo.
def var i-rejei    as integer extent 3 no-undo.
def var de-iqf-qtd as decimal extent 3 no-undo.
def var de-iqf-val as decimal extent 3 no-undo.
def var i-cont  as integer no-undo.
def var de-receb as decimal extent 3 no-undo.
def var de-rejei as decimal extent 3 no-undo.
def var de-preco as decimal no-undo.
def new global shared var i-preco   as integer initial 1            no-undo.
def new global shared var da-inicio as date    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF  no-undo.
def new global shared var da-fim    as date    initial "12/31/9999" no-undo.

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
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-14 ~
FILL-IN-2 FILL-IN-15 FILL-IN-22 FILL-IN-3 FILL-IN-23 FILL-IN-30 FILL-IN-4 ~
FILL-IN-31 rt-mold 
&Scoped-Define DISPLAYED-OBJECTS i-receb-x i-rejei-x de-iqf-qtd-x ~
de-receb-x de-rejei-x de-iqf-val-x i-receb-y i-rejei-y de-iqf-qtd-y ~
de-receb-y de-rejei-y de-iqf-val-y i-receb-z i-rejei-z de-iqf-qtd-z ~
de-receb-z de-rejei-z de-iqf-val-z FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-14 ~
FILL-IN-2 FILL-IN-15 FILL-IN-22 FILL-IN-3 FILL-IN-23 FILL-IN-30 FILL-IN-4 ~
FILL-IN-31 

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
DEFINE VARIABLE de-iqf-qtd-x AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-iqf-qtd-y AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-iqf-qtd-z AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-iqf-val-x AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-iqf-val-y AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-iqf-val-z AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-receb-x AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-receb-y AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-receb-z AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-rejei-x AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-rejei-y AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-rejei-z AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-14 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-15 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-22 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-23 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-30 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-31 AS CHARACTER FORMAT "X(4)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(16)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE i-receb-x AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-receb-y AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-receb-z AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-rejei-x AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-rejei-y AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-rejei-z AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 8.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-receb-x AT ROW 2.5 COL 23 COLON-ALIGNED NO-LABEL
     i-rejei-x AT ROW 2.5 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-qtd-x AT ROW 2.5 COL 64 COLON-ALIGNED NO-LABEL
     de-receb-x AT ROW 3.42 COL 23 COLON-ALIGNED NO-LABEL
     de-rejei-x AT ROW 3.42 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-val-x AT ROW 3.42 COL 64 COLON-ALIGNED NO-LABEL
     i-receb-y AT ROW 4.79 COL 23 COLON-ALIGNED NO-LABEL
     i-rejei-y AT ROW 4.79 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-qtd-y AT ROW 4.79 COL 64 COLON-ALIGNED NO-LABEL
     de-receb-y AT ROW 5.71 COL 23 COLON-ALIGNED NO-LABEL
     de-rejei-y AT ROW 5.71 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-val-y AT ROW 5.71 COL 64 COLON-ALIGNED NO-LABEL
     i-receb-z AT ROW 7 COL 23 COLON-ALIGNED NO-LABEL
     i-rejei-z AT ROW 7 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-qtd-z AT ROW 7 COL 64 COLON-ALIGNED NO-LABEL
     de-receb-z AT ROW 8 COL 23 COLON-ALIGNED NO-LABEL
     de-rejei-z AT ROW 8 COL 43 COLON-ALIGNED NO-LABEL
     de-iqf-val-z AT ROW 8 COL 64 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 1.25 COL 22.57 COLON-ALIGNED NO-LABEL
     FILL-IN-6 AT ROW 1.25 COL 43.14 COLON-ALIGNED NO-LABEL
     FILL-IN-7 AT ROW 1.25 COL 64.14 COLON-ALIGNED NO-LABEL
     FILL-IN-14 AT ROW 2.5 COL 74 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 2.63 COL 2.29 NO-LABEL
     FILL-IN-15 AT ROW 3.42 COL 74 COLON-ALIGNED NO-LABEL
     FILL-IN-22 AT ROW 4.79 COL 74 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 5 COL 2 NO-LABEL
     FILL-IN-23 AT ROW 5.71 COL 74 COLON-ALIGNED NO-LABEL
     FILL-IN-30 AT ROW 7.13 COL 74 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 7.25 COL 2 NO-LABEL
     FILL-IN-31 AT ROW 8.04 COL 74 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 8.38
         WIDTH              = 85.72.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN de-iqf-qtd-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-iqf-qtd-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-iqf-qtd-z IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-iqf-val-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-iqf-val-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-iqf-val-z IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-receb-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-receb-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-receb-z IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-rejei-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-rejei-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-rejei-z IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-receb-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-receb-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-receb-z IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-rejei-x IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-rejei-y IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-rejei-z IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

 /* A linha abaixo trar  para literal label conforme especificado */
  {utp/ut-liter.i Criticidade_X * L}
  assign fill-in-2 = return-value.
  {utp/ut-liter.i Criticidade_Y * L}
  assign fill-in-3 = return-value.
  {utp/ut-liter.i Criticidade_Z * L}
  assign fill-in-4 = return-value.

  {utp/ut-liter.i Lotes_Aprov. * C}
  assign fill-in-5 = return-value.

  {utp/ut-liter.i Lotes_Rej. * C}
  assign fill-in-6 = return-value.

  {utp/ut-liter.i IQF * C}
  assign fill-in-7 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-14 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-15 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-22 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-23 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-30 = return-value.
  {utp/ut-liter.i % * L}
  assign fill-in-31 = return-value.

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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

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
  run pi-calcula-valor in this-procedure. /* (input i-preco, input da-inicio, input da-fim).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-valor V-table-Win 
PROCEDURE pi-calcula-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign i-receb       = 0  
       i-rejei       = 0  
      de-iqf-qtd     = 0
      de-iqf-val     = 0
      de-receb       = 0
      de-rejei       = 0
      de-preco       = 0.

if  emitente.cod-emitente <> 0 then do:

    for each ficha-cq where
             ficha-cq.cod-emitente = emitente.cod-emitente no-lock,
        each docum-est {cdp/cd8900.i docum-est ficha-cq} and
             docum-est.dt-trans >= da-inicio and
             docum-est.dt-trans <= da-fim no-lock:
             find item where item.it-codigo = ficha-cq.it-codigo no-lock no-error.
    
             /*assign de-preco = if i-preco = 1 then item.preco-base else
     *                            if i-preco = 2 then item.preco-repos else
     *                            if i-preco = 3 then item.preco-ul-ent else
     *                            if i-preco = 4 then item.val-unit-mat[1] +
     *                                                item.val-unit-mob[1] else 1.*/
    
                if  ficha-cq.qt-rejeitada + ficha-cq.qt-apr-cond > 0 then
                   assign i-rejei[item.criticidade] = i-rejei[item.criticidade] + 1.
                else
                    if  ficha-cq.qt-aprovada + ficha-cq.qt-consumida > 0 then
                       assign i-receb[item.criticidade] = i-receb[item.criticidade] + 1.
    
                assign de-receb[item.criticidade] = de-receb[item.criticidade]
                                                   + (ficha-cq.qt-aprovada + ficha-cq.qt-consumida) * de-preco
                       de-rejei[item.criticidade] = de-rejei[item.criticidade]
                                                   + (ficha-cq.qt-rejeitada + ficha-cq.qt-apr-cond) * de-preco.
    
    
    end.

    do i-cont = 1 to 3:
       assign de-iqf-qtd[i-cont] = 100 - (i-rejei[i-cont] / i-receb[i-cont]) * 100
              de-iqf-val[i-cont] = 100 - (de-rejei[i-cont] / de-receb[i-cont]) * 100.
       if  de-iqf-qtd[i-cont] = ? then
           de-iqf-qtd[i-cont] = 0.
       if  de-iqf-val[i-cont] = ? then
           de-iqf-val[i-cont] = 0.
       if  de-iqf-qtd[i-cont] >= 1000 then
           de-iqf-qtd[i-cont] = 999.99.
       else
          if  de-iqf-qtd[i-cont] <= -1000 then
              de-iqf-qtd[i-cont] = -999.99.
          if  de-iqf-val[i-cont] >= 1000 then
              de-iqf-val[i-cont] = 999.99.
          else
              if  de-iqf-val[i-cont] <= -1000 then
                  de-iqf-val[i-cont] = -999.99.
    end.
end.


   assign i-receb-x:screen-value in frame {&FRAME-NAME} = string(i-receb[1])
          i-receb-y:screen-value in frame {&FRAME-NAME} = string(i-receb[2])
          i-receb-z:screen-value in frame {&FRAME-NAME} = string(i-receb[3])
          i-rejei-x:screen-value in frame {&FRAME-NAME} = string(i-rejei[1])
          i-rejei-y:screen-value in frame {&FRAME-NAME} = string(i-rejei[2])
          i-rejei-z:screen-value in frame {&FRAME-NAME} = string(i-rejei[3])
          de-iqf-qtd-x:screen-value in frame {&FRAME-NAME} = string(de-iqf-qtd[1])
          de-iqf-qtd-y:screen-value in frame {&FRAME-NAME} = string(de-iqf-qtd[2])
          de-iqf-qtd-z:screen-value in frame {&FRAME-NAME} = string(de-iqf-qtd[3])
          de-iqf-val-x:screen-value in frame {&FRAME-NAME} = string(de-iqf-val[1])
          de-iqf-val-y:screen-value in frame {&FRAME-NAME} = string(de-iqf-val[2])
          de-iqf-val-z:screen-value in frame {&FRAME-NAME} = string(de-iqf-val[3])
          de-receb-x:screen-value in frame {&FRAME-NAME} = string(de-receb[1])
          de-receb-y:screen-value in frame {&FRAME-NAME} = string(de-receb[2])
          de-receb-z:screen-value in frame {&FRAME-NAME} = string(de-receb[3])
          de-rejei-x:screen-value in frame {&FRAME-NAME} = string(de-rejei[1])
          de-rejei-y:screen-value in frame {&FRAME-NAME} = string(de-rejei[2])
          de-rejei-z:screen-value in frame {&FRAME-NAME} = string(de-rejei[3]).

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
  {src/adm/template/snd-list.i "emitente"}

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

