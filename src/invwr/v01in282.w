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
{include/i-prgvrs.i V01IN282 2.00.00.007 } /*** "010007" 21/11/2023 17:01:03 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN282 MUT}
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

def new global shared var gr-param-cq as rowid no-undo.
DEFINE VARIABLE hDBOCatalDoctoAnexo AS HANDLE NO-UNDO.

&IF {&ROWID_READY} = YES &THEN
    DEF NEW GLOBAL SHARED VAR v_rec_catal_docto_anexo AS rowid NO-UNDO.
&ELSE
    DEF NEW GLOBAL SHARED VAR v_rec_catal_docto_anexo AS RECID NO-UNDO.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES param-cq
&Scoped-define FIRST-EXTERNAL-TABLE param-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cq.tipo-cq param-cq.plano-na ~
param-cq.plano-ns param-cq.gera-rast param-cq.confirma-senha ~
param-cq.cod-catal-laudo 
&Scoped-define ENABLED-TABLES param-cq
&Scoped-define FIRST-ENABLED-TABLE param-cq
&Scoped-Define ENABLED-OBJECTS tg-control-versao rt-mold RECT-9 RECT-7 ~
RECT-8 RECT-10 RECT-11 RECT-34 
&Scoped-Define DISPLAYED-FIELDS param-cq.tipo-cq param-cq.plano-na ~
param-cq.plano-ns param-cq.gera-rast param-cq.confirma-senha ~
param-cq.cod-catal-laudo 
&Scoped-define DISPLAYED-TABLES param-cq
&Scoped-define FIRST-DISPLAYED-TABLE param-cq
&Scoped-Define DISPLAYED-OBJECTS tg-control-versao c-label-tipo-cq ~
c-label-plano-na c-label-plano-ns c-desc-laudos 

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
DEFINE VARIABLE c-desc-laudos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-plano-na AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-plano-ns AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-tipo-cq AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.04.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.04.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68.72 BY 1.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.08.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.08.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.08.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 10.25.

DEFINE VARIABLE tg-control-versao AS LOGICAL INITIAL no 
     LABEL "Controle Vers∆o Exame" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cq.tipo-cq AT ROW 2.42 COL 21.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o tem CQ", 1,
"S¢ gera Roteiro", 2,
"CQ Total", 3
          SIZE 44.43 BY .75
     param-cq.plano-na AT ROW 4.25 COL 21.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "horizontal", 1,
"diagonal", 2,
"vertical", 3,
"tabela", 4
          SIZE 44.72 BY .75
     param-cq.plano-ns AT ROW 6.13 COL 21.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "horizontal", 1,
"diagonal", 2,
"vertical", 3,
"tabela", 4
          SIZE 44.72 BY .75
     param-cq.gera-rast AT ROW 7.38 COL 20.14
          VIEW-AS TOGGLE-BOX
          SIZE 22.86 BY .75
     tg-control-versao AT ROW 7.33 COL 68.29 RIGHT-ALIGNED WIDGET-ID 10
     param-cq.confirma-senha AT ROW 8.71 COL 20.14
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .75
     param-cq.cod-catal-laudo AT ROW 10.21 COL 24.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     c-label-tipo-cq AT ROW 1.63 COL 18.86 COLON-ALIGNED NO-LABEL
     c-label-plano-na AT ROW 3.46 COL 18.86 COLON-ALIGNED NO-LABEL
     c-label-plano-ns AT ROW 5.38 COL 18.86 COLON-ALIGNED NO-LABEL
     c-desc-laudos AT ROW 10.21 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     rt-mold AT ROW 1.5 COL 1.14
     RECT-9 AT ROW 2.29 COL 18.86
     RECT-7 AT ROW 4.08 COL 18.86
     RECT-8 AT ROW 5.96 COL 18.86
     RECT-10 AT ROW 7.25 COL 18.86
     RECT-11 AT ROW 8.58 COL 18.86
     RECT-34 AT ROW 9.92 COL 9.86 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cq
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
         HEIGHT             = 10.83
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-laudos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-plano-na IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-plano-ns IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-tipo-cq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-control-versao IN FRAME f-main
   ALIGN-R                                                              */
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

&Scoped-define SELF-NAME param-cq.cod-catal-laudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cq.cod-catal-laudo V-table-Win
ON LEAVE OF param-cq.cod-catal-laudo IN FRAME f-main /* Cat†logo Laudos */
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOCatalDoctoAnexo"
        &KeyValue1="param-cq.cod-catal-laudo:SCREEN-VALUE IN FRAME f-main"
        &FieldName1="des_catal_docto_anexo"
        &FieldScreen1="c-desc-laudos"
        &Frame1="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cq.cod-catal-laudo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cq.cod-catal-laudo IN FRAME f-main /* Cat†logo Laudos */
OR F5 OF param-cq.cod-catal-laudo DO:

    RUN btb/btb003ka.p.

    IF  v_rec_catal_docto_anexo <> ? then do:

        RUN goToRecid    IN hDBOCatalDoctoAnexo (INPUT v_rec_catal_docto_anexo).
        RUN getCharField IN hDBOCatalDoctoAnexo (INPUT "cod_catal_docto_anexo":U, OUTPUT param-cq.cod-catal-laudo).
        
        ASSIGN param-cq.cod-catal-laudo:SCREEN-VALUE IN FRAME f-main = param-cq.cod-catal-laudo.

        APPLY "LEAVE":U TO param-cq.cod-catal-laudo IN FRAME f-Main.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cq.tipo-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cq.tipo-cq V-table-Win
ON VALUE-CHANGED OF param-cq.tipo-cq IN FRAME f-main /* Tp CQ */
DO:
RUN pi-habilita-desabilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  param-cq.cod-catal-laudo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-Main.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  {utp/ut-rtlbl.i mgind param-cq tipo-cq  c-label-tipo-cq}
  {utp/ut-rtlbl.i mgind param-cq plano-ns c-label-plano-ns}
  {utp/ut-rtlbl.i mgind param-cq plano-na c-label-plano-na}

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
  {src/adm/template/row-list.i "param-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cq"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  ASSIGN param-cq.log-2 = LOGICAL(tg-control-versao:SCREEN-VALUE IN FRAME f-Main). 

  IF RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  VALID-HANDLE(hDBOCatalDoctoAnexo) THEN DO:
        DELETE PROCEDURE hDBOCatalDoctoAnexo.
        ASSIGN hDBOCatalDoctoAnexo = ?.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    IF AVAIL param-cq THEN
        ASSIGN tg-control-versao:SCREEN-VALUE IN FRAME f-Main = STRING(param-cq.log-2). 

    APPLY "LEAVE":U TO param-cq.cod-catal-laudo IN FRAME f-Main.
    
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

    /* Inicializa DBO de Catalogo de documentos (Laudos) */
    IF  NOT VALID-HANDLE(hDBOCatalDoctoAnexo) OR
        hDBOCatalDoctoAnexo:TYPE      <> "PROCEDURE":U OR
        hDBOCatalDoctoAnexo:FILE-NAME <> "unbo/boun014.p":U THEN DO:
        RUN unbo/boun014.p PERSISTENT SET hDBOCatalDoctoAnexo.
    END.
    RUN openQueryStatic IN hDBOCatalDoctoAnexo (INPUT "Default":U) NO-ERROR.
  
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

  if avail param-cq then
     assign gr-param-cq = rowid(param-cq).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-desabilita V-table-Win 
PROCEDURE pi-habilita-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if integer(param-cq.tipo-cq:screen-value in frame {&FRAME-NAME}) = 3 then do:
     enable param-cq.plano-na
            param-cq.plano-ns
            param-cq.gera-rast with frame {&FRAME-NAME}.
     RUN notify IN THIS-PROCEDURE ('habilita,link_1-target':U).
  end.
  else do:
     disable param-cq.plano-na
             param-cq.plano-ns
           /*  param-cq.gera-rast*/ with frame {&FRAME-NAME}.
     RUN notify IN THIS-PROCEDURE ('desabilita,link_1-target':U).
  end.

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
  {src/adm/template/snd-list.i "param-cq"}

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

