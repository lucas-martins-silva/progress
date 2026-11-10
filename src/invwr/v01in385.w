&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V01IN385 2.00.00.018 } /*** "010018" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in385 MUT}
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

/*def new global shared var gr-requisicao as rowid no-undo.*/

{include/i-vrtab.i requisicao}
{include/i-vrtab.i estabelec}
{include/i-vrtab.i requisitante}

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
&Scoped-define EXTERNAL-TABLES requisicao
&Scoped-define FIRST-EXTERNAL-TABLE requisicao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR requisicao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS requisicao.nr-requisicao requisicao.narrativa 
&Scoped-define ENABLED-TABLES requisicao
&Scoped-define FIRST-ENABLED-TABLE requisicao
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS requisicao.nr-requisicao ~
requisicao.cod-estabel requisicao.nome-abrev requisicao.dt-requisicao ~
requisicao.loc-entrega requisicao.narrativa 
&Scoped-define DISPLAYED-TABLES requisicao
&Scoped-define FIRST-DISPLAYED-TABLE requisicao
&Scoped-Define DISPLAYED-OBJECTS c-estab c-nome-requis fi-situacao ~
fi-estado fi-tp-requis 

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
DEFINE VARIABLE c-estab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-requis AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(20)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-situacao AS CHARACTER FORMAT "X(15)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-requis AS CHARACTER FORMAT "X(25)":U 
     LABEL "Tipo Requisi‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE label-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.43 BY 4.29.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 12.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     requisicao.nr-requisicao AT ROW 1.17 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     requisicao.cod-estabel AT ROW 2.67 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-estab AT ROW 2.67 COL 28.14 COLON-ALIGNED NO-LABEL
     requisicao.nome-abrev AT ROW 3.67 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     c-nome-requis AT ROW 3.67 COL 37.29 COLON-ALIGNED NO-LABEL
     requisicao.dt-requisicao AT ROW 4.67 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fi-situacao AT ROW 5.67 COL 20.72 COLON-ALIGNED
     fi-estado AT ROW 6.67 COL 20.72 COLON-ALIGNED
     requisicao.loc-entrega AT ROW 7.67 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     fi-tp-requis AT ROW 8.67 COL 20.72 COLON-ALIGNED
     requisicao.narrativa AT ROW 10.71 COL 4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 83 BY 3.25
          FONT 2
     label-1 AT ROW 9.88 COL 6 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 10.17 COL 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.requisicao
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
         HEIGHT             = 14.25
         WIDTH              = 88.57.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 14.25
       FRAME f-main:WIDTH            = 88.57.

/* SETTINGS FOR FILL-IN c-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-requis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN requisicao.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN requisicao.dt-requisicao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tp-requis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN requisicao.loc-entrega IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN requisicao.nome-abrev IN FRAME f-main
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

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-rtlbl.i mgind requisicao narrativa label-1}

{utp/ut-field.i mgind requisicao situacao 1}
assign fi-situacao:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-field.i mgind requisicao estado 1}
assign fi-estado:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-field.i mgind requisicao tp-requis 1}
assign fi-tp-requis:label in frame {&FRAME-NAME} = trim(return-value).

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
  {src/adm/template/row-list.i "requisicao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "requisicao"}

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

  if available requisicao then do:

     find estabelec where 
        estabelec.cod-estabel = requisicao.cod-estabel
        no-lock no-error.        
     assign c-estab = if avail estabelec then estabelec.nome else "":U.

     find requisitante where 
        requisitante.nome-abrev = requisicao.nome-abrev
        no-lock no-error.
     assign c-nome-requis = if available requisitante then requisitante.nome else "":U.

  end.

  /* Dispatch standard ADM method. */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 

  if avail requisicao then do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao001 = {ininc/i02in385.i 04 requisicao.estado}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-estado:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-estado:screen-value = {ininc/i02in385.i 04 requisicao.estado}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao002 = {ininc/i01in385.i 04 requisicao.situacao}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-situacao:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-situacao:screen-value = {ininc/i01in385.i 04 requisicao.situacao}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao003 = {ininc/i03in385.i 04 requisicao.tp-requis}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-tp-requis:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-tp-requis:screen-value = {ininc/i03in385.i 04 requisicao.tp-requis}.
     &endif
  end.
  else do:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao004 = {ininc/i02in385.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-estado:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-estado:screen-value = {ininc/i02in385.i 04 1}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao005 = {ininc/i01in385.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-situacao:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-situacao:screen-value = {ininc/i01in385.i 04 1}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao006 = {ininc/i03in385.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao006)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  fi-tp-requis:screen-value = RETURN-VALUE.
     &else
         ASSIGN fi-tp-requis:screen-value = {ininc/i03in385.i 04 1}.
     &endif
  end.

  {utp/ut-rtlbl.i mgind requisicao narrativa label-1}.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if avail requisicao then do:
     assign gr-requisicao = rowid(requisicao).
     find estabelec where estabelec.cod-estabel = requisicao.cod-estabel no-lock no-error.
      if avail estabelec then 
       assign gr-estabelec = rowid(estabelec).
     find requisitante where requisitante.nome-abrev = requisicao.nome-abrev no-lock no-error.
      if avail requisitante then 
       assign gr-requisitante = rowid(requisitante).
  end.     

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed V-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*  {utp/ut-rtlbl.i mgind requisicao narrativa label-1}. */

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
  {src/adm/template/snd-list.i "requisicao"}

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

