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
{include/i-prgvrs.i V18IN172 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V18IN172 MUT}
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

def new global shared var gr-item as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 RECT-3 

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
DEFINE VARIABLE c-finalizada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .75 NO-UNDO.

DEFINE VARIABLE c-iniciada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .75 NO-UNDO.

DEFINE VARIABLE c-qt-alocada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-liberada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-nao-ini AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .71.

DEFINE VARIABLE c-qt-ordem AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-produzida AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-refugada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-requis AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-saldo AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .71 NO-UNDO.

DEFINE VARIABLE c-qt-separada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .71 NO-UNDO.

DEFINE VARIABLE c-terminada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .75 NO-UNDO.

DEFINE VARIABLE c-tot-ordem AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .71 NO-UNDO.

DEFINE VARIABLE de-prd-finalizada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-prd-iniciada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-prd-terminada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-alocada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-finalizada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-iniciada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-liberada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-nao-ini AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-requis AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-qt-separada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-ref-finalizada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-ref-iniciada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-ref-terminada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-sld-finalizada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-sld-iniciada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-tot-ordem AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.43 BY 8.63.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.43 BY 8.63.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 8.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-qt-nao-ini AT ROW 1.75 COL 27 RIGHT-ALIGNED NO-LABEL
     de-qt-alocada AT ROW 3 COL 27 RIGHT-ALIGNED NO-LABEL
     de-qt-iniciada AT ROW 3 COL 56 RIGHT-ALIGNED NO-LABEL
     de-qt-finalizada AT ROW 3 COL 71 RIGHT-ALIGNED NO-LABEL
     de-prd-terminada AT ROW 3 COL 86 RIGHT-ALIGNED NO-LABEL
     de-qt-liberada AT ROW 4.25 COL 27 RIGHT-ALIGNED NO-LABEL
     de-prd-iniciada AT ROW 4.25 COL 56 RIGHT-ALIGNED NO-LABEL
     de-prd-finalizada AT ROW 4.25 COL 71 RIGHT-ALIGNED NO-LABEL
     de-ref-terminada AT ROW 4.25 COL 71 COLON-ALIGNED NO-LABEL
     de-qt-separada AT ROW 5.5 COL 27 RIGHT-ALIGNED NO-LABEL
     de-ref-iniciada AT ROW 5.5 COL 56 RIGHT-ALIGNED NO-LABEL
     de-ref-finalizada AT ROW 5.5 COL 56 COLON-ALIGNED NO-LABEL
     de-qt-requis AT ROW 6.75 COL 12 COLON-ALIGNED NO-LABEL
     de-tot-ordem AT ROW 8.25 COL 27 RIGHT-ALIGNED NO-LABEL
     de-sld-iniciada AT ROW 8.25 COL 56 RIGHT-ALIGNED NO-LABEL
     de-sld-finalizada AT ROW 8.25 COL 71 RIGHT-ALIGNED NO-LABEL
     c-qt-nao-ini AT ROW 2 COL 3 NO-LABEL
     c-iniciada AT ROW 2 COL 43 NO-LABEL
     c-finalizada AT ROW 2 COL 58 NO-LABEL
     c-terminada AT ROW 2 COL 73 NO-LABEL
     c-qt-alocada AT ROW 3.25 COL 3 NO-LABEL
     c-qt-ordem AT ROW 3.25 COL 28 COLON-ALIGNED NO-LABEL
     c-qt-liberada AT ROW 4.46 COL 3 NO-LABEL
     c-qt-produzida AT ROW 4.5 COL 28 COLON-ALIGNED NO-LABEL
     c-qt-separada AT ROW 5.75 COL 3 NO-LABEL
     c-qt-refugada AT ROW 5.75 COL 28 COLON-ALIGNED NO-LABEL
     c-qt-requis AT ROW 7 COL 3 NO-LABEL
     c-tot-ordem AT ROW 8.5 COL 3 NO-LABEL
     c-qt-saldo AT ROW 8.5 COL 28 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.17 COL 1.57
     RECT-1 AT ROW 1.17 COL 29
     RECT-3 AT ROW 1.5 COL 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 8.79
         WIDTH              = 87.72.
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

/* SETTINGS FOR FILL-IN c-finalizada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-iniciada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-qt-alocada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-qt-liberada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-qt-nao-ini IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-qt-ordem IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-qt-produzida IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-qt-refugada IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-qt-requis IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-qt-saldo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-qt-separada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-terminada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-tot-ordem IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       c-tot-ordem:AUTO-RESIZE IN FRAME f-main      = TRUE.

/* SETTINGS FOR FILL-IN de-prd-finalizada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-prd-iniciada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-prd-terminada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-alocada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-finalizada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-iniciada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-liberada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-nao-ini IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-qt-requis IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN de-qt-separada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-ref-finalizada IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN de-ref-iniciada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-ref-terminada IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN de-sld-finalizada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-sld-iniciada IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR FILL-IN de-tot-ordem IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
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
  /*--- Labels primeiro retƒngulo ---*/
 /*   
 *   {utp/ut-field.i mgind ord-prod estado 1}
 *   assign c-estado:screen-value in frame {&FRAME-NAME} = return-value.  */

  {utp/ut-liter.i N_Iniciada mcs C}
  assign c-qt-nao-ini:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Alocada mcs C}
  assign c-qt-alocada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Liberada mcs C}
  assign c-qt-liberada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Separada mcs C}
  assign c-qt-separada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Requisit. mcs C}
  assign c-qt-requis:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Total mcs C}
  assign c-tot-ordem :screen-value in frame {&FRAME-NAME} = trim(return-value).  

  
  /*--- Labels segundo retƒngulo ---*/
  
  {utp/ut-field.i mgind ord-prod qt-ordem 2}
  assign c-qt-ordem:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-field.i mgind ord-prod qt-produzida 2}
  assign c-qt-produzida:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Qtd_Refugo mcs l}
  assign c-qt-refugada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Saldo mcs C}
  assign c-qt-saldo:screen-value in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-liter.i Iniciada mcs C}
  assign c-iniciada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Finalizada mcs C}
  assign c-finalizada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Terminada mcs C}
  assign c-terminada:screen-value in frame {&FRAME-NAME} = trim(return-value).  

 


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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

 
  /*--- Apresenta‡Æo dos Valores ---*/
 assign de-qt-nao-ini      = 0
        de-qt-alocada      = 0 
        de-qt-liberada     = 0    
        de-qt-separada     = 0
        de-qt-requis       = 0
        de-tot-ordem       = 0
        de-qt-iniciada     = 0
        de-prd-iniciada    = 0
        de-ref-iniciada    = 0
        de-sld-iniciada    = 0
        de-qt-finalizada   = 0
        de-prd-finalizada  = 0
        de-ref-finalizada  = 0
        de-sld-finalizada  = 0
        de-prd-terminada   = 0
        de-ref-terminada   = 0.
     
  if  gr-item <> ? then
      find first item no-lock
          where rowid(item) = gr-item
          no-error.      

  for each ord-prod use-index item no-lock
      where ord-prod.it-codigo = item.it-codigo:

      /*--- NÆo Iniciada ---*/
      if  ord-prod.estado = 1 then do:
          assign de-qt-nao-ini = de-qt-nao-ini + ord-prod.qt-ordem.
          next.
      end.

      /*--- Liberada ---*/
      if  ord-prod.estado = 2 then do:
          assign de-qt-liberada = de-qt-liberada + ord-prod.qt-ordem.
          next.
      end.     

      /*--- Requisitada ---*/         
      if  ord-prod.estado = 5 then do:
          assign de-qt-requis = de-qt-requis + ord-prod.qt-requis.
          next.
      end.

      /*--- Alocada ---*/
      if  ord-prod.estado = 3 then do:
          assign de-qt-alocada = de-qt-alocada + ord-prod.qt-ordem.
          next.
      end.

      /*--- Separada ---*/
      if  ord-prod.estado = 4 then do:
          assign de-qt-separada = de-qt-separada + ord-prod.qt-ordem.
          next.
      end.

      /*--- Finalizada ---*/
      if  ord-prod.estado = 7 then do:
          assign de-qt-finalizada  = de-qt-finalizada  + ord-prod.qt-ordem
                 de-prd-finalizada = de-prd-finalizada + ord-prod.qt-produzida
                 de-ref-finalizada = de-ref-finalizada + ord-prod.qt-refugada.
          next.
      end.

      /*--- Iniciada ---*/
      if  ord-prod.estado = 6 then 
          assign de-qt-iniciada  = de-qt-iniciada  + ord-prod.qt-ordem
                 de-prd-iniciada = de-prd-iniciada + ord-prod.qt-produzida
                 de-ref-iniciada = de-ref-iniciada + ord-prod.qt-refugada.

      /*--- Terminada ---*/
      if  ord-prod.estado = 8 then             
          assign de-prd-terminada = de-prd-terminada + ord-prod.qt-produzida
                 de-ref-terminada = de-ref-terminada + ord-prod.qt-refugada.     
  end.      
  assign de-tot-ordem      = de-qt-nao-ini + de-qt-liberada + de-qt-requis
                          + de-qt-alocada + de-qt-separada
         de-sld-iniciada   = de-qt-iniciada
                          - (de-prd-iniciada + de-ref-iniciada).
         de-sld-finalizada = de-qt-finalizada - de-prd-finalizada.
         
  disp de-qt-nao-ini
       de-qt-alocada
       de-qt-liberada     
       de-qt-separada
       de-qt-requis
       de-tot-ordem
       de-qt-iniciada
       de-prd-iniciada
       de-ref-iniciada
       de-sld-iniciada
       de-qt-finalizada
       de-prd-finalizada
       de-ref-finalizada
       de-sld-finalizada
       de-prd-terminada
       de-ref-terminada
       with frame {&FRAME-NAME}.                             

 
  
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
  {src/adm/template/snd-list.i "item"}

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


