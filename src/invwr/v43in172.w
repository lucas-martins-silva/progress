&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V43IN172 2.00.01.007 } /*** 010107 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V43IN172 MUT}
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
DEF NEW GLOBAL SHARED VAR gr-familia  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-localiz  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-planejad AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod AS rowid NO-UNDO.

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.ressup-fabri item.deposito-pad ~
item.cod-localiz item.cd-planejado item.lote-economi item.cap-est-fabr ~
item.nr-linha 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS item.fm-codigo item.ressup-fabri ~
item.deposito-pad item.cod-localiz item.cd-planejado item.lote-economi ~
item.cap-est-fabr item.nr-linha 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS cb-compr-fabric cb-classe-repro ~
cb-tipo-con-est cb-demanda cb-tipo-requis cb-tipo-contr cb-sit-aloc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-CREATE-FIELDS item.fm-codigo item.ressup-fabri ~
cb-compr-fabric cb-classe-repro item.deposito-pad cb-tipo-con-est ~
item.cod-localiz cb-demanda item.cd-planejado item.lote-economi ~
item.cap-est-fabr cb-tipo-requis cb-tipo-contr cb-sit-aloc item.nr-linha 
&Scoped-define ADM-ASSIGN-FIELDS item.fm-codigo item.ressup-fabri ~
cb-compr-fabric cb-classe-repro item.deposito-pad cb-tipo-con-est ~
item.cod-localiz cb-demanda item.cd-planejado item.lote-economi ~
item.cap-est-fabr cb-tipo-requis cb-tipo-contr cb-sit-aloc item.nr-linha 

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
DEFINE VARIABLE cb-classe-repro AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-compr-fabric AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-sit-aloc AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-contr AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     item.fm-codigo AT ROW 1.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     item.ressup-fabri AT ROW 1.54 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     cb-compr-fabric AT ROW 2.54 COL 20 COLON-ALIGNED
     cb-classe-repro AT ROW 2.54 COL 67 COLON-ALIGNED
     item.deposito-pad AT ROW 3.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     cb-tipo-con-est AT ROW 3.54 COL 67 COLON-ALIGNED
     item.cod-localiz AT ROW 4.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     cb-demanda AT ROW 4.54 COL 67 COLON-ALIGNED
     item.cd-planejado AT ROW 5.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     item.lote-economi AT ROW 5.54 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.cap-est-fabr AT ROW 6.54 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cb-tipo-requis AT ROW 6.58 COL 20 COLON-ALIGNED
     cb-tipo-contr AT ROW 7.54 COL 67 COLON-ALIGNED
     cb-sit-aloc AT ROW 7.75 COL 20 COLON-ALIGNED
     item.nr-linha AT ROW 8.92 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     RECT-1 AT ROW 1 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.42
         WIDTH              = 85.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN item.cap-est-fabr IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR COMBO-BOX cb-classe-repro IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-compr-fabric IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-demanda IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-sit-aloc IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-contr IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN item.cd-planejado IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN item.cod-localiz IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN item.deposito-pad IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN item.fm-codigo IN FRAME F-Main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN item.lote-economi IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN item.nr-linha IN FRAME F-Main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN item.ressup-fabri IN FRAME F-Main
   1 2                                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-field.i mgind item compr-fabric 1}
  ASSIGN cb-compr-fabric:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item tipo-requis 1}
  ASSIGN cb-tipo-requis:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item sit-aloc 1}
  ASSIGN cb-sit-aloc:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item classe-repro 1}
  ASSIGN cb-classe-repro:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item tipo-con-est 1}
  ASSIGN cb-tipo-con-est:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item demanda 1}
  ASSIGN cb-demanda:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-field.i mgind item tipo-contr 1}
  ASSIGN cb-tipo-contr:LABEL IN FRAME {&frame-name} = RETURN-VALUE.  

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  

    &IF DEFINED (bf_man_linha_estab) &THEN
    hide ITEM.nr-linha IN frame {&frame-name}.    
    &endif

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
  HIDE FRAME F-Main.
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

  IF  AVAIL item THEN DO WITH FRAME {&frame-name}:
      ASSIGN cb-compr-fabric:SCREEN-VALUE = {ininc/i01in172.i 04 item.compr-fabric}
             cb-tipo-requis:SCREEN-VALUE  = {ininc/i08in122.i 04 item.tipo-requis}
             cb-sit-aloc:SCREEN-VALUE     = {ininc/i18in172.i 04 item.sit-aloc}
             cb-classe-repro:SCREEN-VALUE = {ininc/i06in122.i 04 item.classe-repro}
             cb-tipo-con-est:SCREEN-VALUE = {ininc/i01in122.i 04 item.tipo-con-est}
             cb-demanda:SCREEN-VALUE      = {ininc/i02in122.i 04 item.demanda}
             cb-tipo-contr:SCREEN-VALUE   = {ininc/i09in122.i 04 item.tipo-contr}.       
  END.
  ELSE DO:
      ASSIGN cb-compr-fabric:SCREEN-VALUE = {ininc/i01in172.i 04 01}
             cb-tipo-requis:SCREEN-VALUE  = {ininc/i08in122.i 04 01}
             cb-sit-aloc:SCREEN-VALUE     = {ininc/i18in172.i 04 01}
             cb-classe-repro:SCREEN-VALUE = {ininc/i06in122.i 04 01}
             cb-tipo-con-est:SCREEN-VALUE = {ininc/i01in122.i 04 01}
             cb-demanda:SCREEN-VALUE      = {ininc/i02in122.i 04 01}
             cb-tipo-contr:SCREEN-VALUE   = {ininc/i09in122.i 04 01}.
  END.  
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

  DO WITH FRAME {&frame-name}:
     ASSIGN cb-compr-fabric:LIST-ITEMS = {ininc/i01in172.i 03}
            cb-tipo-requis:LIST-ITEMS  = {ininc/i08in122.i 03}
            cb-sit-aloc:LIST-ITEMS     = {ininc/i18in172.i 03}
            cb-classe-repro:LIST-ITEMS = {ininc/i06in122.i 03}
            cb-tipo-con-est:LIST-ITEMS = {ininc/i01in122.i 03}
            cb-demanda:LIST-ITEMS      = {ininc/i02in122.i 03}
            cb-tipo-contr:LIST-ITEMS   = {ininc/i09in122.i 03}.
  END.  

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
  FIND familia WHERE familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
  IF  AVAIL familia THEN
      ASSIGN gr-familia = ROWID(familia).
      
  FIND deposito WHERE deposito.cod-depos = item.deposito-pad NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).
      
  FIND planejad WHERE planejad.cd-planejado = item.cd-planejado NO-LOCK NO-ERROR.
  IF  AVAIL planejad THEN
      ASSIGN gr-planejad = ROWID(planejad).
      
  &IF DEFINED (bf_man_linha_estab) &THEN
  FIND lin-prod 
       WHERE lin-prod.cod-estabel = item.cod-estabel
         and lin-prod.nr-linha    = item.nr-linha NO-LOCK NO-ERROR.
  &ELSE
  FIND lin-prod WHERE lin-prod.nr-linha = item.nr-linha NO-LOCK NO-ERROR.  
  &ENDIF
  IF  AVAIL item THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod).        

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  ASSIGN INPUT FRAME {&frame-name} cb-compr-fabric
         item.compr-fabric = {ininc/i01in172.i 06 cb-compr-fabric}
         INPUT FRAME {&frame-name} cb-tipo-requis
         item.tipo-requis  = {ininc/i08in122.i 06 cb-tipo-requis}
         INPUT FRAME {&frame-name} cb-sit-aloc
         item.sit-aloc     = {ininc/i18in172.i 06 cb-sit-aloc}
         INPUT FRAME {&frame-name} cb-classe-repro
         item.classe-repro = {ininc/i06in122.i 06 cb-classe-repro}
         INPUT FRAME {&frame-name} cb-tipo-con-est
         item.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-con-est}
         INPUT FRAME {&frame-name} cb-demanda
         item.demanda      = {ininc/i02in122.i 06 cb-demanda}
         INPUT FRAME {&frame-name} cb-tipo-contr
         item.tipo-contr   = {ininc/i09in122.i 06 cb-tipo-contr}.

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

